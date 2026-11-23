import os, collections, hashlib
root = r"C:\Projects\Abuzar\recovered"
wins = collections.defaultdict(list)
dws = collections.defaultdict(list)
for lib in os.listdir(os.path.join(root,"objects")):
    p = os.path.join(root,"objects",lib,"window")
    if os.path.isdir(p):
        for f in os.listdir(p):
            if f.endswith(".json"): wins[f[:-5].lower()].append(lib)
for lib in os.listdir(os.path.join(root,"datawindows")):
    p = os.path.join(root,"datawindows",lib)
    if os.path.isdir(p):
        for f in os.listdir(p):
            if f.endswith(".srd"): dws[f[:-4].lower()].append(lib)
print("window files", sum(len(v) for v in wins.values()), "distinct names", len(wins), "names in >1 lib", sum(1 for v in wins.values() if len(v)>1))
print("top dup win names", sorted(((k,len(v)) for k,v in wins.items() if len(v)>1), key=lambda x:-x[1])[:15])
print("dw files", sum(len(v) for v in dws.values()), "distinct names", len(dws), "names in >1 lib", sum(1 for v in dws.values() if len(v)>1))
print("top dup dw names", sorted(((k,len(v)) for k,v in dws.items() if len(v)>1), key=lambda x:-x[1])[:15])
