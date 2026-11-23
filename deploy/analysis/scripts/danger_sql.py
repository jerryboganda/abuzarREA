import json, collections

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))
print('=== SELECT without WHERE ===')
c = collections.Counter()
ex = {}
for r in d['sql']:
    if r['kind'] == 'select' and not r['has_where']:
        c[r['norm']] += 1
        ex.setdefault(r['norm'], (r['file'], r['line'], r['sql']))
for k, v in c.most_common(20):
    f, l, s = ex[k]
    print(v, f + ':' + str(l), s[:160])
print()
print('=== UPDATE without WHERE ===')
c = collections.Counter(); ex = {}
for r in d['sql']:
    if r['kind'] == 'update' and not r['has_where']:
        c[r['norm']] += 1
        ex.setdefault(r['norm'], (r['file'], r['line'], r['sql']))
for k, v in c.most_common(20):
    f, l, s = ex[k]
    print(v, f + ':' + str(l), s[:160])
print()
print('=== DELETE without WHERE ===')
for r in d['sql']:
    if r['kind'] == 'delete' and not r['has_where']:
        print(r['file'] + ':' + str(r['line']), r['sql'][:160])
