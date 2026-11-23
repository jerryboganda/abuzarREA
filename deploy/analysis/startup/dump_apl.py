import sys, re, os
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbd_lib import entries, read_obj
p=r'C:\Projects\Abuzar\deploy\Application\abuzarapp.pbd'
d=open(p,'rb').read()
e=[x for x in entries(d) if x['name']=='traderappv1.apl'][0]
buf=read_obj(d,e)
print('len',len(buf))
open(r'C:\Projects\Abuzar\deploy\analysis\startup\traderappv1.apl.bin','wb').write(buf)
# utf16 strings
s=buf.decode('utf-16le','ignore')
out=[]
for m in re.finditer(r'[\x20-\x7e\r\n\t]{4,}', s):
    out.append(m.group(0))
print('\n'.join(out[:200]))
