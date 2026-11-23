import sys, os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sys,os,glob,collections,json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pbd_lib import *
root=sys.argv[1]
tot=collections.Counter(); totsz=collections.Counter(); rows=[]; allobjs={}
pe=0
for p in sorted(glob.glob(os.path.join(root,'*.pbd'))):
    d=open(p,'rb').read()
    es=entries(d)
    c=collections.Counter(os.path.splitext(e['name'])[1].lower() for e in es)
    for e in es:
        x=os.path.splitext(e['name'])[1].lower(); tot[x]+=1; totsz[x]+=e['size']
    mz = d.count(b'This program cannot be run')
    pe+=mz
    rows.append((os.path.basename(p), len(d)//1024, len(es), dict(c), mz))
    allobjs[os.path.basename(p)]=[(e['name'],e['size']) for e in es]
for r in rows: print(r)
print('TOTAL objs', sum(tot.values()))
for k,v in tot.most_common(): print(k, v, totsz[k]//1024,'KB')
print('embedded PE stubs', pe)
json.dump(allobjs, open('inventory.json','w'))
