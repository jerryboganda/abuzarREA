import os, re, collections

ROOT = r"C:\Projects\Abuzar\recovered\scripts"
create_re = re.compile(r'this\.(\w+)\s*=\s*create\s+u_transaction', re.I)
files = []
for dp, dn, fn in os.walk(ROOT):
    for f in fn:
        if f.lower().endswith('.pbs'):
            files.append(os.path.join(dp, f))

leaks = []
starts = collections.Counter()
for p in files:
    t = open(p, encoding='utf-8', errors='replace').read()
    for m in create_re.finditer(t):
        var = m.group(1)
        starts[var] += 1
        stop = re.search(r'SQL\s+stop\s+using\s+this\.' + re.escape(var) + r'\b', t, re.I)
        dest = re.search(r'destroy\s+this\.' + re.escape(var) + r'\b', t, re.I)
        if not stop and not dest:
            leaks.append((os.path.relpath(p, ROOT).replace('\\','/'), var))

print("instance transaction vars created:", sum(starts.values()))
print("distinct vars:", len(starts))
print("vars never stopped/destroyed in same file:", len(leaks))
for x in leaks[:60]:
    print(x)
print()
print("top vars:", starts.most_common(15))
