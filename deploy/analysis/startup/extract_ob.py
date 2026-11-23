import sys
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbd_lib import entries, read_obj
p=r'C:\Projects\Abuzar\deploy\Application\abuzar.exe'
d=open(p,'rb').read()
e=[x for x in entries(d) if x['name']=='ob.exe'][0]
buf=read_obj(d,e)
print('len',len(buf))
open(r'C:\Projects\Abuzar\deploy\analysis\startup\ob.exe.bin','wb').write(buf)
print(buf[:32].hex())
