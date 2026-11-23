import os, json, collections
root = r"C:\Projects\Abuzar\recovered\objects"
anc = collections.Counter()
names = []
for lib in os.listdir(root):
    p = os.path.join(root, lib, "window")
    if not os.path.isdir(p): continue
    for f in os.listdir(p):
        if not f.endswith(".json"): continue
        d = json.load(open(os.path.join(p,f), encoding="utf-8"))
        a = (d.get("ancestor") or "").lower()
        anc[a] += 1
        names.append(f[:-5].lower())
print("top ancestors")
for k,v in anc.most_common(30): print(f"{k or '(none)':32} {v}")
print("total", sum(anc.values()))
import re
cats = {
 "report-ish": lambda n: bool(re.match(r"w_(rpt|report|rep|sprnt|r_|reports)", n)) or "report" in n,
 "arg": lambda n: n.startswith("w_arg"),
 "form": lambda n: n.endswith("_form"),
 "popup": lambda n: "popup" in n,
 "entry": lambda n: "entry" in n,
}
for c,fn in cats.items():
    print(c, sum(1 for n in names if fn(n)))
print("sample report-like", [n for n in names if cats["report-ish"](n)][:20])
