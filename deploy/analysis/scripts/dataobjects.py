import os, re, collections

cnt = collections.Counter()
locs = collections.defaultdict(list)
for dp, _, ns in os.walk('recovered/scripts'):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        rel = os.path.relpath(p, 'recovered/scripts').replace('\\', '/')
        for i, l in enumerate(open(p, encoding='utf-8', errors='replace'), 1):
            m = re.search(r'\.dataobject\s*=\s*"([^"]+)"', l, re.I)
            if m:
                key = m.group(1).lower()
                cnt[key] += 1
                if len(locs[key]) < 6:
                    locs[key].append(rel + ':' + str(i))
print('distinct dataobjects assigned:', len(cnt))
for k, v in cnt.most_common(45):
    if v >= 4:
        print('%3d %-45s %s' % (v, k, locs[k]))
