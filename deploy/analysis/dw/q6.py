import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for n in ["d_cashflow","d_cashflow5","d_customerledger_itemwise","d_inpatientbill","d_itemstockregister_standard"]:
    r=[x for x in rows if x["name"]==n][0]
    print("="*100); print(n,r["lib"],"bytes",r["bytes"],"tables",r["sql"]["tables"]); print("subq",r["sql"]["subqueries"],"joins",r["sql"]["n_joins"],"groupby",r["sql"]["group_by"],"having",r["sql"]["having"])
    print(r["sql"]["sql"][:2600])
