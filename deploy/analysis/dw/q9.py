import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
def show(n,lim=2200):
    r=[x for x in rows if x["name"]==n][0]
    print("="*110); print(n,r["lib"],"bytes",r["bytes"],"args",[a["name"]+":"+a["type"] for a in r["arguments"]],"used",r.get("lit_files"),"kind",r.get("kind"))
    s=r["sql"]; print("tables",s["tables"],"joins",s["n_joins"],"subq",s["subqueries"],"union",s["union"],"group",s["group_by"],"having",s["having"])
    print(s["sql"][:lim])
for n in ["d_customerbalances_in_sales","d_popup_supplierselection_many","d_itemstockinfo","d_popup_customerselection","d_itemlist","d_areawisereceivable"]:
    show(n)
