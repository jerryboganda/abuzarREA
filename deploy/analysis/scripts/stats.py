import os, re, collections, json

ROOT = r'recovered/scripts'
files = []
for dp, _, ns in os.walk(ROOT):
    for n in ns:
        if n.lower().endswith('.pbs'):
            files.append(os.path.join(dp, n))

pats = {
    'create u_transaction': re.compile(r'^\s*\w+\s*=\s*create\s+u_transaction', re.I),
    'SQL start': re.compile(r'^\s*SQL\s+start\s+using', re.I),
    'SQL stop': re.compile(r'^\s*SQL\s+stop\s+using', re.I),
    'autocommit true': re.compile(r'autocommit\s*=\s*true', re.I),
    'autocommit false': re.compile(r'autocommit\s*=\s*false', re.I),
    'settransobject': re.compile(r'\.settransobject\s*\(', re.I),
    'setredraw(false)': re.compile(r'\.setredraw\s*\(\s*false\s*\)', re.I),
    'setredraw(true)': re.compile(r'\.setredraw\s*\(\s*true\s*\)', re.I),
    'sleep': re.compile(r'\bsleep\s*\(', re.I),
    'setfilter': re.compile(r'\.setfilter\s*\(', re.I),
    '.filter()': re.compile(r'\.filter\s*\(\s*\)', re.I),
    '.find(': re.compile(r'\.find\s*\(', re.I),
    '.describe(': re.compile(r'\.describe\s*\(', re.I),
    '.modify(': re.compile(r'\.modify\s*\(', re.I),
    'retrieve(': re.compile(r'\.retrieve\s*\(', re.I),
    'messagebox': re.compile(r'\bmessagebox\s*\(', re.I),
    'dataobject=': re.compile(r'\.dataobject\s*=', re.I),
    'sharedata': re.compile(r'\.sharedata\s*\(', re.I),
    'postevent': re.compile(r'\bpostevent\s*\(', re.I),
    'triggerevent': re.compile(r'\btriggerevent\s*\(', re.I),
    'opensheet': re.compile(r'\bopensheet\w*\s*\(', re.I),
    'open(': re.compile(r'(?<![\w.])open\s*\(', re.I),
    'executeimmed': re.compile(r'^\s*SQL\s+executeimmed', re.I),
}

tot = collections.Counter()
perfile = collections.defaultdict(collections.Counter)
for p in files:
    txt = open(p, encoding='utf-8', errors='replace').read()
    for name, rx in pats.items():
        c = len(rx.findall(txt))
        if c:
            tot[name] += c
            perfile[os.path.relpath(p, ROOT).replace('\\', '/')][name] = c

for k, v in tot.most_common():
    print('%-22s %6d' % (k, v))

print('\n=== top settransobject files ===')
for f, c in sorted(perfile.items(), key=lambda kv: -kv[1]['settransobject'])[:20]:
    print(c['settransobject'], f)

print('\n=== top retrieve files ===')
for f, c in sorted(perfile.items(), key=lambda kv: -kv[1]['retrieve('])[:20]:
    print(c['retrieve('], f)

print('\n=== open()/opensheet() per file ===')
for f, c in sorted(perfile.items(), key=lambda kv: -(kv[1]['open('] + kv[1]['opensheet']))[:15]:
    print(c['open('], c['opensheet'], f)
