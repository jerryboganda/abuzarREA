#!/usr/bin/env python3
"""Second pass: count every string-literal reference to a DataWindow name in .pbs."""
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(r"C:\Projects\Abuzar")
SCRIPTROOT = ROOT / "recovered" / "scripts"
OUT = Path(__file__).resolve().parent
rows = json.load(open(OUT / "dw_metrics.json", encoding="utf-8"))
names = {r["name"].lower(): r for r in rows}

lit = re.compile(r'"([A-Za-z_][A-Za-z0-9_]{2,80})"')
count = defaultdict(lambda: {"files": set(), "refs": 0})
files = 0
for p in SCRIPTROOT.rglob("*.pbs"):
    files += 1
    txt = p.read_text(encoding="latin-1", errors="replace")
    seen = set()
    for m in lit.finditer(txt):
        n = m.group(1).lower()
        if n in names:
            count[n]["refs"] += 1
            seen.add(n)
    for n in seen:
        count[n]["files"].add(str(p))

for r in rows:
    c = count.get(r["name"].lower())
    r["lit_files"] = len(c["files"]) if c else 0
    r["lit_refs"] = c["refs"] if c else 0
    r["usage_score"] = max(r.get("usage_score", 0), r["lit_files"])

json.dump(rows, open(OUT / "dw_metrics.json", "w", encoding="utf-8"), indent=1)
refd = sum(1 for r in rows if r["lit_files"])
print(f"scripts={files} dw_names={len(names)} referenced_by_literal={refd}")
print("top literals:")
for r in sorted(rows, key=lambda r: -r["lit_files"])[:25]:
    print(f'{r["lit_files"]:4d} {r["lit_refs"]:5d} {r["name"]:48s} {r["lib"]:22s} {r.get("kind")}')
