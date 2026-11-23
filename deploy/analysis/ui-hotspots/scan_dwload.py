import json, glob, os, collections, sys

OBJ = r"C:\Projects\Abuzar\recovered\objects"
DW = r"C:\Projects\Abuzar\recovered\datawindows"
srd = {}
for p in glob.glob(os.path.join(DW, "**", "*.srd"), recursive=True):
    n = os.path.basename(p)[:-4].lower()
    srd.setdefault(n, []).append(os.path.getsize(p))

rows = []
for p in glob.glob(os.path.join(OBJ, "**", "window", "*.json"), recursive=True):
    try:
        j = json.load(open(p, encoding="utf-8"))
    except Exception:
        continue
    tot = 0
    names = []
    def walk(cs):
        nonlocal tot
        for c in cs:
            f = {x["name"]: x.get("value") for x in c.get("fields", [])}
            d = f.get("dataobject")
            if d:
                sz = sum(srd.get(str(d).lower(), [0]))
                tot += sz
                names.append((d, sz))
            walk(c.get("controls") or [])
    walk(j.get("controls") or [])
    if tot:
        rows.append((tot, j.get("name"), j.get("library"), len(names), names))

rows.sort(reverse=True)
print("Top 30 windows by static DataWindow metadata (SRD bytes assigned in window definition):")
for tot, name, lib, n, names in rows[:30]:
    print(f"{name[:36]:36} {str(lib)[:20]:20} dws={n:>3} srd={tot/1024:>8.1f} KB")
print("\nWindows with >=3 DWs:", sum(1 for r in rows if r[3] >= 3))
print("Windows with any DW:", len(rows))
print("\nDetail w_sale:")
for r in rows:
    if r[1] == "w_sale":
        for d, s in r[4]:
            print(f"  {d:34} {s/1024:8.1f} KB")
