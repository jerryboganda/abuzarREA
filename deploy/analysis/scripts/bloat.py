import os, re, collections, json

ROOT = 'recovered/scripts'
files = []
for dp, _, ns in os.walk(ROOT):
    for n in ns:
        if n.endswith('.pbs'):
            files.append(os.path.join(dp, n))

by_name = collections.defaultdict(list)
for p in files:
    by_name[os.path.basename(p).lower()].append(p)

dups = {k: v for k, v in by_name.items() if len(v) > 1}
print('unique basenames:', len(by_name), 'duplicated basenames:', len(dups), 'files in dup groups:', sum(len(v) for v in dups.values()))
print('bytes in dup groups:', sum(os.path.getsize(p) for v in dups.values() for p in v))
print('\nTop duplicate groups:')
for k, v in sorted(dups.items(), key=lambda kv: -sum(os.path.getsize(p) for p in kv[1]))[:25]:
    print('%8d %2d %s' % (sum(os.path.getsize(p) for p in v), len(v), k))
    print('     ', ', '.join(os.path.dirname(x).replace('\\', '/') for x in v))

pat = re.compile(r'(_old|_copy|_backup|_bak|_test|_temp|_new|_2$|_v2$|_modified|_fix|_original|_unused|_dontuse)', re.I)
var = [p for p in files if pat.search(os.path.basename(p))]
print('\nvariant-looking files:', len(var), 'bytes:', sum(os.path.getsize(p) for p in var))
for p in sorted(var, key=lambda x: -os.path.getsize(x))[:15]:
    print('%8d %s' % (os.path.getsize(p), p.replace('\\', '/')))

# per-library totals
lib = collections.Counter(); libb = collections.Counter()
for p in files:
    d = os.path.basename(os.path.dirname(p))
    lib[d] += 1; libb[d] += os.path.getsize(p)
print('\nlibrary count', len(lib))
print('top libraries by bytes:')
for d, b in libb.most_common(12):
    print('%8d KB %4d files %s' % (b // 1024, lib[d], d))
