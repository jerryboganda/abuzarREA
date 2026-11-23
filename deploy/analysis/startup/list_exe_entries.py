import sys
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbd_lib import entries, read_obj
p=r'C:\Projects\Abuzar\deploy\Application\abuzar.exe'
d=open(p,'rb').read()
es=entries(d)
print('entries',len(es))
for e in es[:50]:
    print(e['name'], e['size'], e['ptr'])
