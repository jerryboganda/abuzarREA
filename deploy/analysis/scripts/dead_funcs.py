import os, re, collections

root = 'recovered/scripts'
funcs = []
for dp, _, ns in os.walk(root):
    for n in ns:
        if n.endswith('.pbs') and n.startswith('f_'):
            funcs.append(os.path.join(dp, n))

# collect identifier set per file once
tok = re.compile(r'[A-Za-z_][A-Za-z0-9_]*')
ids = {}
for dp, _, ns in os.walk(root):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        ids[p] = set(x.lower() for x in tok.findall(open(p, encoding='utf-8', errors='replace').read()))

dead = []
for p in funcs:
    name = os.path.basename(p)[:-4].lower()
    used = 0
    for q, s in ids.items():
        if q != p and name in s:
            used += 1
    if used == 0:
        dead.append((os.path.getsize(p), os.path.relpath(p, root).replace('\\', '/')))

dead.sort(reverse=True)
print('function files:', len(funcs), 'never referenced outside own file:', len(dead),
      'bytes:', sum(b for b, _ in dead), 'KB:', sum(b for b, _ in dead) // 1024)
for b, p in dead[:40]:
    print('%6d %s' % (b, p))
