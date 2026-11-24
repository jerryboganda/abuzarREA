import os,sys,json
sys.path.insert(0,r"C:\Projects\Abuzar\re-tools"); sys.stdout.reconfigure(encoding="utf-8")
import pcode_diff as P
A=r"C:\Projects\Abuzar\recovered\pcode\components"; B=sys.argv[1]
n=0; diffs=0
for root,_,files in os.walk(A):
    for f in files:
        if not f.endswith(".json") or f.startswith("_"): continue
        a=os.path.join(root,f); b=os.path.join(B,os.path.relpath(a,A))
        if not os.path.exists(b): print("MISSING",b); continue
        n+=1
        ja=json.load(open(a,encoding="utf-8")); jb=json.load(open(b,encoding="utf-8"))
        ra,rb=P.routines(ja),P.routines(jb)
        if set(ra)!=set(rb): print("ROUTINE SET DIFFERS",f); diffs+=1; continue
        for k in ra:
            if (ra[k].get("instrs") or [])!=(rb[k].get("instrs") or []):
                diffs+=1; print("==",f,k); P.main(a,b,3)
                break
print("objects compared",n,"objects with differences",diffs)
