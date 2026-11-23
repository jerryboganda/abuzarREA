"""The list of window classes the self test opens (selftest.list in the run folder), and the result table of a log.

usage: python -I selftest_list.py list <ws_objects> <out selftest.list>
       python -I selftest_list.py report <selftest.log> [out json]

Left out of the list: the test window itself, the frame and start-up windows (they exist already), and windows that
work on the SQL Server instance or on files rather than on the database of the test (backup, restore, recovery, server
links, transfer, archive, licence activation).  The list is a text file: lines can be added or removed by hand.
"""
import sys, os, re, glob, json, collections

SKIP_EXACT = {'w_selftest', 'w_main', 'w_bkg', 'w_logo', 'w_login1', 'w_startup'}
SKIP_PART = ('backup', 'autorecover', 'activation', 'licens', 'controlpanel', 'datatransfer', 'datamigration', 'dropbox',
             'linkserver', 'childserver', 'parentserver', 'crs_', 'login')


def make(ws, out):
    names = sorted({os.path.basename(f)[:-4] for f in glob.glob(os.path.join(ws, '*', '*.srw'))})
    keep = [n for n in names if n not in SKIP_EXACT and not any(p in n for p in SKIP_PART)]
    with open(out, 'w', encoding='ascii', newline='\r\n') as f:
        f.write('\n'.join(keep) + '\n')
    print('windows', len(names), '| in the list', len(keep), '| left out', len(names) - len(keep))
    print('left out:', ' '.join(n for n in names if n not in keep))


def report(log, out=None):
    res, order = {}, []
    for line in open(log, encoding='utf-8', errors='replace'):
        m = re.match(r'^\S+ (OPEN|OK|ERROR|STOPPED) (\d+) (\S+)(?: \| (.*))?', line.rstrip('\r\n'))
        if not m:
            continue
        kind, idx, name, rest = m.group(1), int(m.group(2)), m.group(3), m.group(4) or ''
        if kind == 'OPEN':
            res[name] = ('STOPPED', 'no result line')
            order.append(name)
        elif name in res or kind == 'STOPPED' and name != 'driver':
            res[name] = (kind, rest)
    c = collections.Counter(v[0] for v in res.values())
    print('windows tried', len(res), dict(c))
    why = collections.Counter()
    for name, (kind, rest) in res.items():
        if kind != 'OK':
            why[re.sub(r'\d+', 'N', rest.split(' | ')[0])[:90]] += 1
    for k, v in why.most_common(25):
        print('%5d  %s' % (v, k))
    if out:
        json.dump({n: res[n] for n in order}, open(out, 'w', encoding='utf-8'), indent=1)


if __name__ == '__main__':
    if sys.argv[1] == 'list':
        make(sys.argv[2], sys.argv[3])
    else:
        report(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
