import json, collections, os, re

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))
lines = {}
for fs in d['file_stats']:
    lines[fs['file']] = fs['lines']

# 1. loops ranked by string/parse work (no SQL)
loops = d['loops']
strloops = [L for L in loops if L['counts'].get('Concat', 0) + L['counts'].get('Mid', 0) + L['counts'].get('Pos', 0) >= 5]
strloops.sort(key=lambda x: -(x['counts'].get('Concat', 0) * 3 + x['counts'].get('Mid', 0) + x['counts'].get('Pos', 0)))
print('=== string/parse loops ===')
for L in strloops[:20]:
    c = L['counts']
    print('%s:%d-%d span=%d concat=%d mid=%d pos=%d msg=%d | %s' % (
        L['file'], L['start'], L['end'], L['span'], c.get('Concat', 0), c.get('Mid', 0),
        c.get('Pos', 0), c.get('MessageBox', 0), L['header'][:90]))

print()
print('=== messagebox in loops ===')
ml = [L for L in loops if L['counts'].get('MessageBox', 0) > 0]
ml.sort(key=lambda x: -x['counts'].get('MessageBox', 0))
for L in ml[:15]:
    print('%s:%d-%d msg=%d span=%d | %s' % (L['file'], L['start'], L['end'], L['counts']['MessageBox'], L['span'], L['header'][:90]))

print()
print('=== create/destroy in loops ===')
cl = [L for L in loops if L['counts'].get('Create', 0) + L['counts'].get('Destroy', 0) > 0]
cl.sort(key=lambda x: -(x['counts'].get('Create', 0) + x['counts'].get('Destroy', 0)))
for L in cl[:15]:
    c = L['counts']
    print('%s:%d-%d create=%d destroy=%d span=%d | %s' % (L['file'], L['start'], L['end'], c.get('Create', 0), c.get('Destroy', 0), L['span'], L['header'][:90]))

print()
print('=== retrieve/settransobject in loops ===')
rl = [L for L in loops if L['counts'].get('Retrieve', 0) + L['counts'].get('SetTransObject', 0) > 0]
rl.sort(key=lambda x: -(x['counts'].get('Retrieve', 0) * 5 + x['counts'].get('SetTransObject', 0)))
for L in rl[:20]:
    c = L['counts']
    print('%s:%d-%d ret=%d sto=%d sql=%d span=%d | %s' % (L['file'], L['start'], L['end'], c.get('Retrieve', 0), c.get('SetTransObject', 0), c.get('SQL', 0), L['span'], L['header'][:90]))

print()
print('=== filter/setsort/describe/modify heavy loops ===')
fl = [L for L in loops if L['counts'].get('Filter', 0) + L['counts'].get('SetSort', 0) + L['counts'].get('Describe', 0) + L['counts'].get('Modify', 0) >= 3]
fl.sort(key=lambda x: -(x['counts'].get('Filter', 0) * 4 + x['counts'].get('SetSort', 0) * 3 + x['counts'].get('Describe', 0) + x['counts'].get('Modify', 0)))
for L in fl[:15]:
    c = L['counts']
    print('%s:%d-%d filt=%d sort=%d desc=%d mod=%d span=%d | %s' % (L['file'], L['start'], L['end'], c.get('Filter', 0), c.get('SetSort', 0), c.get('Describe', 0), c.get('Modify', 0), L['span'], L['header'][:80]))
