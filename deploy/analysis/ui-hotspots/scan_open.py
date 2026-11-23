import os, re, glob, json, collections

SCRIPTS = r"C:\Projects\Abuzar\recovered\scripts"
out = []
stat = collections.Counter()

for path in glob.glob(os.path.join(SCRIPTS, "**", "*.pbs"), recursive=True):
    try:
        txt = open(path, encoding="utf-8", errors="replace").read()
    except Exception:
        continue
    lines = txt.splitlines()
    # object name from first line: // window w_xxx (lib)  ancestor: ...
    m = re.match(r"//\s+(\w+)\s+(\w+)\s+\(([^)]+)\)", lines[0]) if lines else None
    if not m:
        continue
    kind, name, lib = m.group(1), m.group(2), m.group(3)
    if kind.lower() != "window":
        continue
    # find open block
    hdr = re.compile(r"^//\s+" + re.escape(name) + r"\.open\(\)", re.I)
    starts = [i for i, l in enumerate(lines) if hdr.match(l)]
    if not starts:
        continue
    s = starts[0] + 1
    e = len(lines)
    for i in range(s, len(lines)):
        if lines[i].startswith("// " + name + "."):
            e = i
            break
    block = "\n".join(lines[s:e])
    low = block.lower()
    rec = {
        "lib": lib, "name": name, "path": path,
        "lines": e - s,
        "retrieve": len(re.findall(r"\.retrieve\s*\(", low)),
        "sqlselect": len(re.findall(r"\bsql\s+select\b", low)) + len(re.findall(r"\bselect\s+.*\binto\b", low)),
        "opens": len(re.findall(r"\bopen\s*\(", low)) + len(re.findall(r"\bopenwithparm\s*\(", low)),
        "msgbox": low.count("messagebox("),
        "setredraw": low.count("setredraw("),
        "timer": len(re.findall(r"\btimer\s*\(", low)),
        "insertrow": low.count("insertrow"),
        "settrans": low.count("settransobject"),
        "sleep": low.count("sleep("),
        "yield": low.count("yield("),
        "datastore_create": low.count("create datastore") + low.count("create u_ds"),
        "forloop": len(re.findall(r"^\s*for\s+\w+\s*=", block, re.M)),
        "dowhile": len(re.findall(r"^\s*do\s+while\b", block, re.M)),
        "dw_assign": len(re.findall(r"\.dataobject\s*=", low)),
    }
    out.append(rec)
    stat["windows_with_open"] += 1
    if rec["retrieve"]: stat["open_retrieves_any"] += 1
    if rec["retrieve"] >= 5: stat["open_retrieves_5plus"] += 1
    if rec["retrieve"] >= 10: stat["open_retrieves_10plus"] += 1
    if rec["sqlselect"]: stat["open_sql_select"] += 1
    if rec["opens"]: stat["open_opens_dialog"] += 1
    if rec["msgbox"]: stat["open_msgbox"] += 1
    if rec["setredraw"]: stat["open_setredraw"] += 1
    if rec["timer"]: stat["open_timer"] += 1
    if rec["sleep"]: stat["open_sleep"] += 1
    if rec["yield"]: stat["open_yield"] += 1

print("windows parsed:", len(out))
print(stat)
print("\nTop 30 open() by retrieve count:")
for r in sorted(out, key=lambda x: -x["retrieve"])[:30]:
    print(f"{r['name'][:38]:38} {r['lib'][:22]:22} ret={r['retrieve']:>3} sql={r['sqlselect']:>2} open={r['opens']:>2} lines={r['lines']:>4} msg={r['msgbox']} sr={r['setredraw']}")

print("\nTop 20 open() by SQL SELECT count:")
for r in sorted(out, key=lambda x: -x["sqlselect"])[:20]:
    print(f"{r['name'][:38]:38} {r['lib'][:22]:22} sql={r['sqlselect']:>3} ret={r['retrieve']:>3} lines={r['lines']:>4}")

print("\nWindows whose open() has no DB work:", sum(1 for r in out if r['retrieve'] == 0 and r['sqlselect'] == 0))
json.dump(out, open(r"C:\Projects\Abuzar\deploy\analysis\ui-hotspots\open_blocks.json", "w"), indent=1)
