import os, re, collections
root = r"C:\Projects\Abuzar\recovered\datawindows"
sprnt = ["sprntatod","sprntetok","sprntlton","sprntotos","sprntttoz"]
bases = collections.Counter()
clients = collections.Counter()
for lib in sprnt:
    p = os.path.join(root, lib)
    for f in os.listdir(p):
        if not f.endswith(".srd"): continue
        n = f[:-4]
        parts = n.split("_")
        # d_<client>_...; client token is second
        if len(parts) > 2 and parts[0] == "d":
            clients[parts[1]] += 1
        bases[re.sub(r"^d_[a-z0-9]+_", "", n)] += 1
print("sprnt files", sum(clients.values()), "distinct client tokens", len(clients))
print("top clients", clients.most_common(15))
print("distinct layout bases", len(bases))
print("top layout bases", bases.most_common(20))

# processing values across all DWs
proc = collections.Counter()
units = collections.Counter()
for dp,_,fs in os.walk(root):
    for f in fs:
        if not f.endswith(".srd"): continue
        try:
            t = open(os.path.join(dp,f),encoding="utf-8",errors="ignore").read(1500)
        except: continue
        m = re.search(r"processing=(\d+)", t); proc[m.group(1) if m else "?"] += 1
        m = re.search(r"units=(\d+)", t); units[m.group(1) if m else "?"] += 1
print("processing", proc.most_common())
print("units", units.most_common())
