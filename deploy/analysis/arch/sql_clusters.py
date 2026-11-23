import os, re, hashlib, collections, json
root = r"C:\Projects\Abuzar\recovered\datawindows"
sqls = {}
missing = 0
for lib in os.listdir(root):
    p = os.path.join(root, lib)
    if not os.path.isdir(p): continue
    for f in os.listdir(p):
        if not f.endswith(".srd"): continue
        lines = open(os.path.join(p,f), encoding="utf-8", errors="ignore").read().splitlines()
        start = None
        for i,l in enumerate(lines):
            if "retrieve=" in l:
                start = i; break
        if start is None:
            missing += 1; continue
        # SQL begins after retrieve=" on start line
        first = lines[start].split('retrieve="',1)[1] if 'retrieve="' in lines[start] else ""
        buf = [first]
        for j in range(start+1, len(lines)):
            if re.match(r"\s*arguments\s*=", lines[j]):
                break
            buf.append(lines[j])
        # last line ends with '"' possibly followed by nothing
        txt = "\n".join(buf).rstrip()
        if txt.endswith('"'): txt = txt[:-1]
        norm = re.sub(r"\s+", " ", txt.strip().lower()).rstrip(";")
        h = hashlib.md5(norm.encode()).hexdigest()
        sqls.setdefault(h, []).append((lib, f[:-4], txt))

print("dws with retrieve", len(sqls), "missing", missing)
clusters = sorted(sqls.values(), key=len, reverse=True)
print("unique SQL hashes", len(clusters))
print("clusters with >1 DW", sum(1 for c in clusters if len(c)>1))
print("top cluster sizes", [len(c) for c in clusters[:15]])
print("dws in duplicate clusters", sum(len(c) for c in clusters if len(c)>1))
# distinct first table / table sets
tabs = collections.Counter()
for c in clusters:
    txt = c[0][2].lower()
    m = re.search(r"\bfrom\s+([a-z_][a-z0-9_]*)", txt)
    tabs[m.group(1) if m else "?"] += 1
print("top base tables", tabs.most_common(25))
json.dump({"unique_sql": len(clusters), "dup_clusters": sum(1 for c in clusters if len(c)>1),
           "dws_in_dups": sum(len(c) for c in clusters if len(c)>1),
           "top_clusters": [[len(c), c[0][0], c[0][1]] for c in clusters[:20]]},
          open(r"C:\Projects\Abuzar\deploy\analysis\arch\sql_clusters.json","w"), indent=1)
