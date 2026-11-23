import os, re, json

HDR = re.compile(r'^//\s+([\w\-]+)\.([\w\-]+)\((.*?)\)\s+returns\s+(.*)$')
rows = []
for dp, _, ns in os.walk('recovered/scripts'):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        rel = os.path.relpath(p, 'recovered/scripts').replace('\\', '/')
        lines = open(p, encoding='utf-8', errors='replace').read().splitlines()
        h = [(i, m.group(2)) for i, l in enumerate(lines) for m in [HDR.match(l)] if m]
        for k, (i, fn) in enumerate(h):
            end = h[k+1][0] if k + 1 < len(h) else len(lines)
            body = lines[i:end]
            sql = sum(1 for l in body if re.match(r'^\s*SQL\s', l, re.I))
            loops = sum(1 for l in body if re.match(r'^\s*(for\s+\w+\s*=|do\s+while|do\s+until)', l, re.I))
            msg = sum(1 for l in body if re.search(r'\bmessagebox\s*\(', l, re.I))
            if end - i >= 300 or sql >= 20:
                rows.append((end - i, sql, loops, msg, rel, i + 1, fn))
print('routines >=300 lines or >=20 SQL:', len(rows))
for r in sorted(rows, reverse=True)[:45]:
    print('lines=%4d sql=%3d loops=%2d msg=%2d  %s:%d %s' % r)
