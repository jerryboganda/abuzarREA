import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for pat in ["^d_saledetail","^d_item","^d_customer","^d_security","^d_sequence"]:
    m=[r for r in rows if re.match(pat,r["name"],re.I)]
    m.sort(key=lambda r:(-r.get("lit_files",0),-r["bytes"]))
    print("==",pat,len(m))
    for r in m[:12]:
        print(f'  used={r.get("lit_files",0):3d} refs={r.get("lit_refs",0):4d} {r["name"][:48]:48s} {r["lib"][:20]:20s} {r["bytes"]//1024:4d}K {r.get("kind")}')
