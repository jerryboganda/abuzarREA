import json, collections

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))
c = collections.Counter()
loc = collections.defaultdict(list)
for r in d['sql']:
    if r['kind'] in ('commit', 'rollback', 'other', 'fetch', 'execute'):
        continue
    c[r['norm']] += 1
    if len(loc[r['norm']]) < 8:
        loc[r['norm']].append(r['file'] + ':' + str(r['line']))
for norm, n in c.most_common(20):
    print('%3d  %s' % (n, norm[:170]))
    print('     ', loc[norm][:5])
