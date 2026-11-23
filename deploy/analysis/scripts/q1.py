import json, collections, sys

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))

def show(label, rows, n=40):
    print(f'--- {label} ({len(rows)}) ---')
    for r in rows[:n]:
        print(r)

loops = [L for L in d['loops'] if L['counts'].get('SQL', 0) > 0]
loops.sort(key=lambda x: -x['score'])
print('loops with SQL:', len(loops))
for L in loops[:35]:
    c = L['counts']
    print('{}:{}-{} span={} score={} sql={} ret={} get={} set={} msg={} hdr={}'.format(
        L['file'], L['start'], L['end'], L['span'], L['score'], c.get('SQL', 0), c.get('Retrieve', 0),
        c.get('GetItem', 0), c.get('SetItem', 0), c.get('MessageBox', 0), L['header'][:100]))

print()
print('=== SQL in loop by file ===')
cnt = collections.Counter(r['file'] for r in d['sql'] if r['in_loop'])
for f, n in cnt.most_common(30):
    print(n, f)
print('SQL in loop total', sum(cnt.values()))

print()
print('=== in-loop SQL statements (top 40 by file size) ===')
rows = [r for r in d['sql'] if r['in_loop']]
for r in rows[:10]:
    print(r['file'], r['line'])
