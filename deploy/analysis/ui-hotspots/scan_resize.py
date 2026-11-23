import os, re, glob, json, collections

SCRIPTS = r"C:\Projects\Abuzar\recovered\scripts"
rows = []
tot = collections.Counter()
for path in glob.glob(os.path.join(SCRIPTS, "**", "*.pbs"), recursive=True):
    try:
        lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    except Exception:
        continue
    cur = None
    for i, l in enumerate(lines):
        m = re.match(r"^//\s+(\S+)\.(\w+)\(([^)]*)\)", l)
        if m:
            cur = (m.group(1), m.group(2), i, m.group(3))
            continue
        if cur and re.match(r"^//\s+\S+\.", l):
            cur = None
            continue
    # second pass: extract resize blocks
    for i, l in enumerate(lines):
        m = re.match(r"^//\s+(\S+)\.resize\(", l)
        if not m:
            continue
        obj = m.group(1)
        s = i + 1
        e = len(lines)
        for j in range(s, len(lines)):
            if lines[j].startswith("// "):
                e = j
                break
        block = "\n".join(lines[s:e]).lower()
        rec = {
            "obj": obj, "path": path, "lines": e - s,
            "retrieve": block.count(".retrieve("),
            "sql": len(re.findall(r"\bsql\s+select\b", block)),
            "resize_child": len(re.findall(r"\.resize\s*\(", block)) + len(re.findall(r"\.width\s*=", block)) + len(re.findall(r"\.height\s*=", block)),
            "moves": len(re.findall(r"\.move\s*\(", block)) + len(re.findall(r"\.x\s*=", block)) + len(re.findall(r"\.y\s*=", block)),
            "setredraw": block.count("setredraw("),
            "setfocus": block.count("setfocus("),
            "timer": len(re.findall(r"\btimer\s*\(", block)),
            "loop": len(re.findall(r"^\s*(for|do)\b", block, re.M)),
            "triggerevent": block.count("triggerevent("),
            "postevent": block.count("postevent("),
        }
        rows.append(rec)
        tot["resize_handlers"] += 1
        if rec["retrieve"]: tot["resize_db"] += 1
        if rec["setredraw"]: tot["resize_setredraw"] += 1
        if rec["setfocus"]: tot["resize_setfocus"] += 1
        if rec["triggerevent"]: tot["resize_triggers"] += 1
print(tot)
print("\nTop resize handlers by child geometry writes:")
for r in sorted(rows, key=lambda x: -(x["resize_child"] + x["moves"]))[:25]:
    print(f"{r['obj'][:36]:36} {os.path.basename(r['path']):34} geom={r['resize_child']+r['moves']:>3} lines={r['lines']:>4} loop={r['loop']} sr={r['setredraw']} focus={r['setfocus']} trig={r['triggerevent']}")
