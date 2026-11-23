import os, re

sprnt_dirs = ['sprntatod', 'sprntotos', 'sprntetok', 'sprntlton', 'sprntttoz']
names = {}
for d in sprnt_dirs:
    p = os.path.join('recovered', 'datawindows', d)
    for n in os.listdir(p):
        if n.endswith('.srd'):
            names.setdefault(n[:-4].lower(), []).append(d)

# Build identifier set of every script and every non-sprnt srd (cheap-ish, chunked)
tok = re.compile(r'[A-Za-z_][A-Za-z0-9_]*')
ids = set()
for root in ['recovered/scripts']:
    for dp, _, ns in os.walk(root):
        for n in ns:
            if n.endswith(('.pbs', '.srd')):
                t = open(os.path.join(dp, n), encoding='utf-8', errors='replace').read()
                ids.update(x.lower() for x in tok.findall(t))

# also count references in non-sprnt datawindows only (layout inheritance)
used = [n for n in names if n in ids]
print('sprnt datawindows:', len(names), 'statically referenced somewhere:', len(used))
print('bytes total MB:', round(sum(os.path.getsize(os.path.join('recovered/datawindows', d, n + '.srd'))
                                    for n, ds in names.items() for d in ds) / 1024 / 1024, 1))
print('sample referenced:', used[:20])
