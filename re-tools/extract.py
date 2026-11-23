import sys, os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sys,os,glob,re,collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pbd_lib import *
root=sys.argv[1]; out=sys.argv[2]
os.makedirs(out,exist_ok=True)
u16=re.compile(rb'(?:[\x20-\x7e\t\r\n\xa0-\xff]\x00){4,}')
a8=re.compile(rb'[\x20-\x7e]{8,}')
def strs(b):
    r=[]
    for m in u16.finditer(b):
        r.append(m.group().decode('utf-16le','ignore'))
    return r
for p in sorted(glob.glob(os.path.join(root,'*.pbd'))):
    d=open(p,'rb').read()
    es=entries(d)
    name=os.path.basename(p)[:-4]
    with open(os.path.join(out,name+'.txt'),'w',encoding='utf-8',errors='replace') as f:
        for e in es:
            b=read_obj(d,e)
            f.write('\n##### %s (%d bytes)\n'%(e['name'],len(b)))
            for s in strs(b):
                f.write(s.replace('\r','\r').replace('\n','\n')+'\n')
print('done')
