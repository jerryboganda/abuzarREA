import json,collections,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
rc={}
for line in open("rowcounts.txt",encoding="utf-8",errors="ignore"):
    p=line.strip().split("|")
    if len(p)==2 and p[1].isdigit(): rc[p[0].lower()]=int(p[1])
def tabs(r): return [t.lower() for t in (r.get("sql") or {}).get("tables",[])]
big={"stockreport","virtualgl","saledetail","saleledger","purorderdetail","purdetail","deletedsaleitem","itemlog","previoussalehistory","srdetail","srledger"}
for t in sorted(big):
    m=[r for r in rows if t in tabs(r)]
    print(f"=== {t} rows={rc.get(t,0):,} DWs={len(m)}")
    for r in sorted(m,key=lambda r:-r.get("heavy_score",0))[:8]:
        s=r.get("sql") or {}
        print(f'  {r["heavy_score"]:5.1f} {r["name"]:48s} {r["lib"]:20s} {r.get("kind"):9s} size={r["bytes"]//1024:4d}K tabs={s.get("n_tables")} j={s.get("n_joins")} subq={s.get("subqueries")} grp={s.get("group_by")} ob={s.get("order_by")} used={r.get("used_by_scripts")}')
