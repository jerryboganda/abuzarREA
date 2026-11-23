"""Write liblist.txt (absolute .pbd paths, application library order) for obj_export.py.
usage: python -I make_liblist.py <Application dir>
Order: the order recorded in abuzar.exe (UTF-16 names), then any library on disk that is not listed there.
"""
import os, re, sys

app = sys.argv[1]
disk = {f.lower(): f for f in os.listdir(app) if f.lower().endswith('.pbd')}
exe = open(os.path.join(app, 'abuzar.exe'), 'rb').read()
listed = []
for m in re.finditer(rb'(?:[\x21-\x7e]\x00){2,80}', exe):
    s = m.group().decode('utf-16le').lower()
    if s.endswith('.pbd'):
        # names are preceded by a stray length character: match against files on disk by suffix
        cand = sorted((f for f in disk if f == s or s.endswith(f) or f.endswith(s)), key=lambda f: -len(f))
        if cand and cand[0] not in listed:
            listed.append(cand[0])
rest = sorted(f for f in disk if f not in listed)
order = listed + rest
here = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(here, 'liblist.txt'), 'w', encoding='utf-8') as f:
    f.write('\n'.join(os.path.join(app, disk[n]) for n in order))
print(len(listed), 'from exe order,', len(rest), 'appended;', len(order), 'total')
