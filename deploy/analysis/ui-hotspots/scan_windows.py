import json, os, glob, collections, statistics

ROOT = r"C:\Projects\Abuzar\recovered\objects"
rows = []
totals = collections.Counter()
anc_counts = collections.Counter()

def walk(ctrls, depth, acc_names, acc_anc):
    n = 0
    for c in ctrls:
        n += 1
        acc_names.append(c.get("name", ""))
        anc = (c.get("ancestor") or "").lower()
        acc_anc[anc] += 1
        n += walk(c.get("controls") or [], depth + 1, acc_names, acc_anc)
    return n

for path in glob.glob(os.path.join(ROOT, "**", "window", "*.json"), recursive=True):
    try:
        with open(path, encoding="utf-8") as fh:
            j = json.load(fh)
    except Exception as e:
        continue
    flds = {f["name"]: f.get("value") for f in j.get("fields", [])}
    names = []
    anc = collections.Counter()
    n = walk(j.get("controls") or [], 1, names, anc)
    # max depth
    def maxdepth(cs, d=1):
        m = 0
        for c in cs:
            m = max(m, d, maxdepth(c.get("controls") or [], d + 1))
        return m
    rows.append({
        "lib": j.get("library", ""),
        "name": j.get("name", ""),
        "path": path,
        "n": n,
        "depth": maxdepth(j.get("controls") or []),
        "vis": flds.get("visible"),
        "title": flds.get("title") or "",
        "w": flds.get("width"),
        "h": flds.get("height"),
        "type": flds.get("windowtype"),
        "anc": dict(anc),
    })
    totals["windows"] += 1
    totals["controls"] += n

print("windows", totals["windows"], "controls", totals["controls"], "avg", round(totals["controls"]/max(1,totals["windows"]),1))
rows.sort(key=lambda r: -r["n"])
print("\nTOP 40 by control count (all kinds):")
print(f"{'rank':>4} {'window':40} {'ctrls':>5} {'depth':>5} {'type':>4} {'lib':22} title")
for i, r in enumerate(rows[:40], 1):
    print(f"{i:>4} {r['name'][:40]:40} {r['n']:>5} {r['depth']:>5} {str(r['type']):>4} {r['lib'][:22]:22} {str(r['title'])[:40]}")

print("\nDistribution:")
buckets = collections.Counter()
for r in rows:
    n = r["n"]
    b = "0" if n == 0 else "1-5" if n <= 5 else "6-15" if n <= 15 else "16-30" if n <= 30 else "31-60" if n <= 60 else "61-120" if n <= 120 else "120+"
    buckets[b] += 1
print(dict(buckets))
print("windows with >100 controls:", sum(1 for r in rows if r["n"] > 100))
print("windows with >200 controls:", sum(1 for r in rows if r["n"] > 200))
print("max depth overall:", max(r["depth"] for r in rows))

with open(r"C:\Projects\Abuzar\deploy\analysis\ui-hotspots\windows.json", "w", encoding="utf-8") as fh:
    json.dump(rows, fh)
