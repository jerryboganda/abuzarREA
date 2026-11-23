import os, re, json, collections

root = r"C:\Projects\Abuzar"
obj = os.path.join(root, "recovered", "objects")
dwroot = os.path.join(root, "recovered", "datawindows")
scrroot = os.path.join(root, "recovered", "scripts")

# 1. windows per library
win_by_lib = {}
for lib in os.listdir(obj):
    p = os.path.join(obj, lib, "window")
    if os.path.isdir(p):
        win_by_lib[lib] = len([f for f in os.listdir(p) if f.endswith(".json")])

# 2. DW per library + total controls parsed from srd? just counts + sql presence
dw_by_lib = {}
sql_dw = 0
total_dw = 0
for lib in os.listdir(dwroot):
    p = os.path.join(dwroot, lib)
    if not os.path.isdir(p):
        continue
    fs = [f for f in os.listdir(p) if f.lower().endswith(".srd")]
    dw_by_lib[lib] = len(fs)
    total_dw += len(fs)
    for f in fs:
        try:
            t = open(os.path.join(p, f), encoding="utf-8", errors="ignore").read(200000)
        except Exception:
            continue
        if "retrieve=" in t:
            sql_dw += 1

# 3. script lines per library
lines_by_lib = {}
routines_by_lib = {}
for lib in os.listdir(scrroot):
    p = os.path.join(scrroot, lib)
    if not os.path.isdir(p):
        continue
    n = 0
    r = 0
    for dp, _, fs in os.walk(p):
        for f in fs:
            if f.endswith(".pbs"):
                try:
                    txt = open(os.path.join(dp, f), encoding="utf-8", errors="ignore").read()
                except Exception:
                    continue
                n += txt.count("\n") + 1
                r += len(re.findall(r"^\s*(?:event|function|on)\s", txt, re.M))
    lines_by_lib[lib] = n
    routines_by_lib[lib] = r

# 4. opened windows across scripts
opens = set()
for dp, _, fs in os.walk(scrroot):
    for f in fs:
        if not f.endswith(".pbs"):
            continue
        txt = open(os.path.join(dp, f), encoding="utf-8", errors="ignore").read()
        for m in re.finditer(r"(?i)\bOpen(?:Sheet|SheetWithParm|WithParm)?\s*\(\s*(w_[A-Za-z0-9_]+)", txt):
            opens.add(m.group(1).lower())
        for m in re.finditer(r"(?i)\bOpen\s*\(\s*[\"']?(w_[A-Za-z0-9_]+)", txt):
            opens.add(m.group(1).lower())

allwins = set()
for lib in win_by_lib:
    p = os.path.join(obj, lib, "window")
    for f in os.listdir(p):
        allwins.add(f[:-5].lower())

# 5. DW references in scripts
dwnames = set()
for lib in dw_by_lib:
    p = os.path.join(dwroot, lib)
    for f in os.listdir(p):
        if f.lower().endswith(".srd"):
            dwnames.add(f[:-4].lower())
refd = set()
for dp, _, fs in os.walk(scrroot):
    for f in fs:
        if not f.endswith(".pbs"):
            continue
        txt = open(os.path.join(dp, f), encoding="utf-8", errors="ignore").read().lower()
        for name in re.findall(r"\b(d_[a-z0-9_]+)", txt):
            refd.add(name)

# 6. old/test/copy window names
pat = re.compile(r"(_old$|_old_|_test|_copy|_backup|_temp$|_dummy|_del$)")
old = sorted(w for w in allwins if pat.search(w))

print("== windows per library (top 25) ==")
for k, v in sorted(win_by_lib.items(), key=lambda x: -x[1])[:25]:
    print(f"{k:26} {v}")
print("total windows", sum(win_by_lib.values()))
print("distinct opened in scripts", len(opens), "matched", len(opens & allwins), "unmatched", len(opens - allwins))
print("never opened (by name)", len(allwins - opens))
print("old/test/copy-named windows", len(old))

print("\n== DW per library (top 25) ==")
for k, v in sorted(dw_by_lib.items(), key=lambda x: -x[1])[:25]:
    print(f"{k:26} {v}")
print("total DW", total_dw, "with retrieve", sql_dw)
print("distinct d_* refs in scripts", len(refd), "of which real DWs", len(refd & dwnames))
print("DWs never named in scripts", len(dwnames - refd))

print("\n== script lines per library (top 25) ==")
for k, v in sorted(lines_by_lib.items(), key=lambda x: -x[1])[:25]:
    print(f"{k:26} {v:7} lines {routines_by_lib.get(k,0):5} routines")
print("total lines", sum(lines_by_lib.values()), "routines", sum(routines_by_lib.values()))

open(os.path.join(r"C:\Projects\Abuzar\deploy\analysis\arch", "scope_stats.json"), "w").write(json.dumps({
    "windows": win_by_lib, "dws": dw_by_lib, "lines": lines_by_lib,
    "opened": sorted(opens), "never_opened": sorted(allwins - opens),
    "old_windows": old, "dw_unreferenced": len(dwnames - refd)
}, indent=1))

