import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
rc={}
for line in open("rowcounts.txt",encoding="utf-8-sig"):
    p=line.strip().split("|")
    if len(p)==2 and p[1].isdigit(): rc[p[0].lower()]=int(p[1])
def s(r,k,d=0): return (r.get("sql") or {}).get(k,d)
def maxtab(r):
    v=[rc.get(t.lower(),0) for t in s(r,"tables",[])]
    return max(v) if v else 0
for r in rows: r["max_tab_rows"]=maxtab(r)
print("== no WHERE, biggest table ==")
m=[r for r in rows if r.get("sql") and not r["sql"].get("is_pbselect") and s(r,"where_len")==0 and s(r,"n_tables")>0]
for r in sorted(m,key=lambda r:-r["max_tab_rows"])[:25]:
    print(f'{r["max_tab_rows"]:9,d} {s(r,"n_tables"):2d}t used={r.get("lit_files",0):3d} {r["name"][:48]:48s} {r["lib"][:22]}')
print("\n== no WHERE at all (any) ==",len(m))
print("\n== max table >=100k, no args (dropdown risk) ==")
m2=[r for r in rows if r["max_tab_rows"]>=100000 and r.get("n_args",0)==0 and r.get("sql")]
print(len(m2))
for r in sorted(m2,key=lambda r:-r["max_tab_rows"])[:20]:
    print(f'{r["max_tab_rows"]:9,d} {s(r,"n_tables"):2d}t used={r.get("lit_files",0):3d} sort={r.get("sort")!r:15s} {r["name"][:48]:48s} {r["lib"][:20]}')
print("\n== dropdowns with no args, biggest table ==")
m3=[r for r in rows if r["lib"]=="dropdowns" and r.get("sql")]
for r in sorted(m3,key=lambda r:-r["max_tab_rows"])[:15]:
    print(f'{r["max_tab_rows"]:9,d} args={r.get("n_args")} used={r.get("lit_files",0):3d} {r["name"][:48]:48s}')
print("dropdowns total",len(m3),"noargs",sum(1 for r in m3 if r.get("n_args",0)==0))
