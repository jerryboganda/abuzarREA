import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
cands=["d_customerledger_itemwise","d_customerledger_itemwise_portrait","d_cashflow","d_cashflow5","d_stockandsale_zone_and_others","d_itemstockregister_standard","d_inpatientbill","d_wholesaledetail","d_saledetail","d_normalpurchasedetail","d_loosepurchasedetail","d_saleorderheader","d_advpurchasedetail","d_imppurchasedetail","d_summacc_accountledger_itemwise","d_supplierledger_itemwise","d_customerledger_quarter_summary","d_po_purchase_disparity","d_stockinbackdate","d_stockinhand_modelwise_backdate"]
for n in cands:
    m=[x for x in rows if x["name"]==n]
    if not m: print(n,"MISSING"); continue
    r=m[0]; s=r["sql"]
    print(f'{n:46s} {r["lib"][:20]:20s} args={[a["name"]+":"+a["type"] for a in r["arguments"]]}')
    print(f'    tabs={s["n_tables"]} joins={s["n_joins"]} subq={s["subqueries"]} union={s["union"]} grp={s["group_by"]} cols={r["n_columns"]} bytes={r["bytes"]} used={r.get("lit_files")}')
