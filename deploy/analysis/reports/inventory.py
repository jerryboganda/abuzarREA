import os, json, collections
ROOT=r"C:\Projects\Abuzar\recovered\objects"
libs=['reports','reportformat','reports_cust','sprntatod','sprntotos','sprntetok','sprntlton','sprntttoz','reportviewer','psrviewer']
for lib in libs:
    d=os.path.join(ROOT,lib)
    if not os.path.isdir(d):
        print(lib,'MISSING'); continue
    kinds=collections.Counter()
    names=collections.defaultdict(list)
    for kind in os.listdir(d):
        kd=os.path.join(d,kind)
        if not os.path.isdir(kd): continue
        for f in os.listdir(kd):
            if f.endswith('.json'):
                kinds[kind]+=1
                names[kind].append(f[:-5])
    print(lib, dict(kinds))
    if lib in ('reports','reportviewer','psrviewer'):
        for k,v in names.items():
            print('  ',k,', '.join(sorted(v)[:30]))
