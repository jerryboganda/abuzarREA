import json
from pathlib import Path

rows = json.load(open(Path(__file__).parent / "dw_metrics.json", encoding="utf-8"))
by = {r["name"]: r for r in rows}
cands = """d_customerledger_itemwise d_customerledger_itemwise_portrait
d_customerledger_itemwise_patient d_customerledger_itemwise_ref
d_customerledger_itemwise_itemdesc d_customerledger_quarter_summary
d_cashflow d_cashflow5 d_cashflow_withreceiptsummary d_cashflow_cashandbanks
d_cashflow_onecashacc d_cashflow_onecashacc_portrait d_cashflow_student
d_crs_customerledger_itemwise d_crs_customerledger_itemwise_custgroup
d_supplierledger_itemwise d_supplierledger_itemwise_patient
d_supplierledger_itemwise_format2 d_summacc_accountledger_itemwise
d_stockandsale_zone_and_others d_inpatientbill d_inpatientbill_grouped
d_itemstockregister_antinarcotix3 d_itemstockregister_standard
d_itemstockregister_new d_purchase_order_format11 d_godown_saleperson_activity
d_po_purchase_disparity d_popup_supplierselection_many
d_customerbalances_in_sales d_stockinbackdate d_stockinhand_modelwise_backdate
d_popup_customerselection d_popup_itemselection d_itemlist d_itemstockinfo
d_customer_list d_groups_discount d_saledetail d_wholesaledetail
d_normalpurchasedetail d_loosepurchasedetail d_saleorderheader
d_advpurchasedetail d_imppurchasedetail d_customer_detail d_itemlog_azhar
d_item_detail d_item_garments_wizard d_item_update d_wholesaleheader
ddd_stockdate ddd_item ddd_positem d_positem d_pending_refusedsalesreport
d_deletedue_list d_satisfydue_list d_saleinvlist_lookup
d_manfwise_salessummary d_arg_class d_itemcategories d_security d_sequence
d_decentphwh_saleprint_full d_amintraders_billsummary_saleinvreport
d_glaxydist_saleinvreport""".split()

for n in cands:
    r = by.get(n)
    if not r:
        print("MISSING", n)
        continue
    s = r.get("sql") or {}
    print("|".join(str(x) for x in [
        n, r["lib"], r.get("lit_files", 0), r.get("nested_used_by", 0),
        r.get("kind"), r["bytes"] // 1024, r.get("n_columns", 0),
        r.get("n_compute", 0), s.get("n_tables", 0), s.get("n_joins", 0),
        s.get("subqueries", 0), s.get("union", 0), s.get("group_by", 0),
        (r.get("sort") or "")[:20], r.get("n_args", 0),
    ]))
