import json,sys,glob
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
import decomp_obj as D, pcode_lift as L, pcode_struct as S
f,owner,ro=sys.argv[1:4]
obj=json.load(open(f,encoding='utf-8'))
ctx=D.Ctx(glob.glob(f.rsplit('/',2)[0]+'/_classfields.json'))
for o,r in D.routines_of(obj,obj['name']):
    if o==owner and r['name']==ro:
        lf=L.Lifter(obj,ctx,r,o); items=lf.run()
        for k,it in enumerate(items):
            if it[0]=='s':
                out=[]; S.pstmt(it[2],0,out); print(k,it[1],' | '.join(out))
            elif it[0]=='j':
                print(k,it[1],it[2],'->',it[3],'(item %d)'%__import__('bisect').bisect_left([x[1] for x in items],it[3]), L.render(it[4]) if it[4] else '')
            else: print(k,it)
        break
