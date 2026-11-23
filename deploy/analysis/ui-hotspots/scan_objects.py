import os, glob, json, collections

ROOT = r"C:\Projects\Abuzar\recovered\objects"
agg = collections.Counter()
by_lib = collections.Counter()
win_rows = []
pics = []
visible_false = 0
total_ctrl = 0

def walk(cs, depth, win):
    global visible_false, total_ctrl
    for c in cs:
        total_ctrl += 1
        anc = (c.get("ancestor") or "").lower()
        agg[anc] += 1
        f = {x["name"]: x.get("value") for x in c.get("fields", [])}
        if f.get("visible") is False:
            visible_false += 1
        pn = f.get("picturename")
        if pn:
            pics.append((win["name"], win["lib"], pn, f.get("width"), f.get("height"), f.get("picturemode")))
        walk(c.get("controls") or [], depth + 1, win)

for path in glob.glob(os.path.join(ROOT, "**", "window", "*.json"), recursive=True):
    try:
        j = json.load(open(path, encoding="utf-8"))
    except Exception:
        continue
    flds = {f["name"]: f.get("value") for f in j.get("fields", [])}
    lib = j.get("library", "")
    win = {"name": j.get("name", ""), "lib": lib}
    walk(j.get("controls") or [], 1, win)
    by_lib[lib] += 1
    if flds.get("picturename"):
        pics.append((win["name"], lib, flds.get("picturename"), flds.get("width"), flds.get("height"), None))
    if flds.get("titlebar") is False or flds.get("border") is False:
        pass

print("window total", sum(by_lib.values()), "controls", total_ctrl, "visible=false", visible_false)
print("\ncontrol kinds (top 40):")
for k, v in agg.most_common(40):
    print(f"{k or '(none)':30} {v}")

print("\nwindows per library (top 25):")
for k, v in by_lib.most_common(25):
    print(f"{k:28} {v}")

print("\npicture controls (top 40 by area):")
def area(p):
    try: return float(p[3] or 0) * float(p[4] or 0)
    except: return 0
for p in sorted(pics, key=lambda p: -area(p))[:40]:
    print(f"{p[0][:32]:32} {p[1][:20]:20} {str(p[2])[:26]:26} {p[3]}x{p[4]} mode={p[5]}")

open(r"C:\Projects\Abuzar\deploy\analysis\ui-hotspots\pics.txt","w",encoding="utf-8").write("\n".join(str(p) for p in pics))
