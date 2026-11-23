import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for name in ["d_customerledger_itemwise","d_stockandsale_zone_and_others","d_wholesaledetail","d_saledetail"]:
    r=[x for x in rows if x["name"]==name][0]
    print("====",name,r["path"])
    print("tables",r["sql"]["tables"])
    print("joins",r["sql"]["n_joins"],"subq",r["sql"]["subqueries"])
    print(r["sql"]["sql"][:600].replace("\n"," "))
