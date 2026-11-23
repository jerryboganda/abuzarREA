import sys, os
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbd_lib import entries
p=r'C:\Projects\Abuzar\deploy\Application\abuzarapp.pbd'
d=open(p,'rb').read()
for e in entries(d):
    print(e['name'], e['size'], e['ptr'])
