"""Build the screen/menu/DataWindow coverage diff from the recovered tree and the rebuild bundle."""
import json, os, re, gzip, sys
from pathlib import Path

ROOT = Path(r"C:\Projects\Abuzar")
REC = ROOT / "recovered"
REB = ROOT / "rebuild" / "web" / "public" / "data"
OUT = ROOT / "deploy" / "parity"
OUT.mkdir(parents=True, exist_ok=True)

def names_under(pattern):
    out = set()
    for p in REC.glob(pattern):
        out.add(p.stem if p.suffix else p.name)
    return out

# Recovered window names: recovered/objects/<lib>/window/<name>.json
rec_windows = set()
for p in REC.glob("objects/*/window/*.json"):
    rec_windows.add(p.stem)
# Recovered menu names: recovered/objects/<lib>/menu/<name>.json
rec_menus = set()
for p in REC.glob("objects/*/menu/*.json"):
    rec_menus.add(p.stem)
# Recovered DataWindow names: recovered/datawindows/<lib>/<name>.srd
rec_dws = set()
for p in REC.glob("datawindows/*/*.srd"):
    rec_dws.add(p.stem)

# Rebuild class index: web/public/data/classes/_index.json
index = json.loads((REB / "classes" / "_index.json").read_text(encoding="utf-8"))
reb_classes = set(index.keys())
reb_windows = {n for n in reb_classes if n.startswith("w_")}
reb_menus = {n for n in reb_classes if n.startswith("m_")}

# Rebuild DataWindow bundles: each .json.gz is a library bundle whose keys are
# the individual DataWindow names (8,740 definitions in 103 bundles).
reb_dws = set()
dw_bundles = 0
for p in (REB / "dw").glob("*.json.gz"):
    dw_bundles += 1
    with gzip.open(p, "rt", encoding="utf-8") as f:
        j = json.load(f)
    if isinstance(j, dict):
        reb_dws.update(j.keys())

def report(label, rec, reb):
    missing = sorted(rec - reb)
    extra = sorted(reb - rec)
    print(f"\n== {label} ==")
    print(f"recovered={len(rec)} rebuild={len(reb)} common={len(rec & reb)} missing_in_rebuild={len(missing)} extra_in_rebuild={len(extra)}")
    (OUT / f"missing-{label}.txt").write_text("\n".join(missing), encoding="utf-8")
    (OUT / f"extra-{label}.txt").write_text("\n".join(extra), encoding="utf-8")
    for n in missing[:20]:
        print("  missing:", n)
    return {"label": label, "recovered": len(rec), "rebuild": len(reb), "common": len(rec & reb),
            "missing": len(missing), "extra": len(extra)}

rows = [
    report("windows", rec_windows, reb_windows),
    report("menus", rec_menus, reb_menus),
    report("datawindows", rec_dws, reb_dws),
]

# Count scripts/routines from the recovered .pbs headers
routine_count = 0
object_count = 0
for p in REC.glob("scripts/**/*.pbs"):
    object_count += 1
    text = p.read_text(encoding="utf-8", errors="replace")
    routine_count += len(re.findall(r"^// .*?\(.*?\) returns", text, re.M))

print(f"\nscripts={object_count} routines={routine_count}")
summary = {
    "rows": rows,
    "scripts": object_count,
    "routines": routine_count,
    "note": "missing_in_rebuild means the recovered name is not present in the rebuild bundle; it is a coverage gap, not necessarily dead code.",
}
(OUT / "coverage.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
print("\nwrote", OUT / "coverage.json")
