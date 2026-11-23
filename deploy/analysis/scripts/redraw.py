import os, re, collections

HDR = re.compile(r'^//\s+([\w\-]+)\.([\w\-]+)\((.*?)\)\s+returns\s+(.*)$')
bad = []
for dp, _, ns in os.walk('recovered/scripts'):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        rel = os.path.relpath(p, 'recovered/scripts').replace('\\', '/')
        lines = open(p, encoding='utf-8', errors='replace').read().splitlines()
        hdrs = [(i, m.group(2)) for i, l in enumerate(lines) for m in [HDR.match(l)] if m]
        for k, (i, fn) in enumerate(hdrs):
            end = hdrs[k+1][0] if k + 1 < len(hdrs) else len(lines)
            body = lines[i:end]
            f = sum(1 for l in body if re.search(r'\.setredraw\s*\(\s*false', l, re.I))
            t = sum(1 for l in body if re.search(r'\.setredraw\s*\(\s*true', l, re.I))
            if f > t:
                bad.append((f - t, rel, i + 1, fn, f, t, end - i))
bad.sort(reverse=True)
print('functions with more setredraw(false) than true:', len(bad))
for b in bad[:30]:
    print(b)
