import os, re, json, collections

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))
loops = collections.defaultdict(list)
for L in d['loops']:
    loops[L['file']].append((L['start'], L['end']))

procs = ['getitemavgprice', 'getitemavgpriceforsale', 'getitemstockall', 'getitemstocktotal',
         'getitemtotalpiecesinhand', 'updateitemtotalpiecesinhand', 'getitemstockbatch',
         'updateitemstockbatch', 'saleupdateitemstockbatch', 'deleteitemstockbatch',
         'getitemstockinallowedgodown', 'update_supplier_item_info']
rx = re.compile(r'\.(' + '|'.join(procs) + r')\s*\(', re.I)
total = collections.Counter()
inloop = collections.Counter()
for dp, _, ns in os.walk('recovered/scripts'):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        rel = os.path.relpath(p, 'recovered/scripts').replace('\\', '/')
        for i, l in enumerate(open(p, encoding='utf-8', errors='replace'), 1):
            m = rx.search(l)
            if not m:
                continue
            name = m.group(1).lower()
            total[name] += 1
            for s, e in loops.get(rel, ()):
                if s < i <= e:
                    inloop[name] += 1
                    break
print('proc calls total:', sum(total.values()), 'inside loops:', sum(inloop.values()))
for k, v in total.most_common():
    print('%-35s total=%4d in_loop=%3d' % (k, v, inloop[k]))
