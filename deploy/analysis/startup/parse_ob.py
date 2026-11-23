import sys, re
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbd_lib import entries, read_obj
p=r'C:\Projects\Abuzar\deploy\analysis\startup\ob.exe.bin'
d=open(p,'rb').read()
es=entries(d)
print('entries',len(es))
for e in es[:30]:
    print(repr(e['name']), e['size'], e['ptr'])
s=d.decode('utf-16le','ignore')
print('--- strings ---')
for m in list(re.finditer(r'[\x20-\x7e]{5,}', s))[:120]:
    print(m.group(0))
