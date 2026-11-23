import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for n in ["d_saledetail","d_item","d_customer","d_security","d_sequence","d_saleheader","d_stock","d_purchaseheader"]:
    m=[r for r in rows if r["name"].lower()==n]
    if m:
        r=m[0]; print(n, r["lib"], "used",r.get("used_by_scripts"),"refs",r.get("ref_count"),"nestedUsed",r.get("nested_used_by"),"kind",r.get("kind"),"bytes",r["bytes"])
    else: print(n,"NOT FOUND")
