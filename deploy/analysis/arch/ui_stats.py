import os, json, collections
root = r"C:\Projects\Abuzar\recovered\objects"
types = collections.Counter()
per = []
props = 0
def walk(node, depth=0):
    global props
    t = node.get("ancestor") or node.get("type") or "?"
    types[t] += 1
    props += len(node.get("fields") or [])
    for c in node.get("controls") or []:
        walk(c, depth+1)
nwin = 0
for lib in os.listdir(root):
    p = os.path.join(root, lib, "window")
    if not os.path.isdir(p): continue
    for f in os.listdir(p):
        if not f.endswith(".json"): continue
        nwin += 1
        d = json.load(open(os.path.join(p,f), encoding="utf-8"))
        before = sum(types.values())
        props0 = props
        walk(d)
        per.append((sum(types.values())-before, props-props0, f))
print("windows", nwin, "control nodes", sum(types.values()), "props", props)
print("avg controls/window", round(sum(x[0] for x in per)/nwin,1), "max", max(per)[:2])
print("control types", types.most_common(30))
print("windows with >100 controls", sum(1 for x in per if x[0]>100), ">50", sum(1 for x in per if x[0]>50))
print("top", sorted(per, reverse=True)[:10])
