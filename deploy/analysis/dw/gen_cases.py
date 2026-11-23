#!/usr/bin/env python3
"""Generate standalone .sql files from a DataWindow retrieve SQL with literal args."""
import json
import re
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parent
rows = json.load(open(OUT / "dw_metrics.json", encoding="utf-8"))
by = {r["name"]: r for r in rows}

CASES = [
    ("m2_supplier_popup", "d_popup_supplierselection_many", {}),
    ("m3_area_receivable", "d_areawisereceivable", {}),
    ("m4_saledetail", "d_saledetail", {"ar_SaleInvCode": "359939"}),
    ("m5_wholesaledetail", "d_wholesaledetail", {"ar_SaleInvCode": "359939"}),
    ("m6_normalpurchasedetail", "d_normalpurchasedetail", {"r_InvCode": "160"}),
    ("m6b_loosepurchasedetail", "d_loosepurchasedetail", {"r_InvCode": "160"}),
    ("m7_customerledger_itemwise", "d_customerledger_itemwise",
     {"ai_custcode": "19", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-07", "ai_allcustomers": "0"}),
    ("m7b_customerledger_portrait", "d_customerledger_itemwise_portrait",
     {"ai_custcode": "3386", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-31", "ai_allcustomers": "0"}),
    ("m8_cashflow", "d_cashflow", {"ad_StartDate": "2024-01-01", "ad_EndDate": "2024-01-31"}),
    ("m9_itemstockregister", "d_itemstockregister_standard",
     {"ar_icode": "476111", "ar_stdate": "2024-01-01", "ar_enddate": "2024-01-31"}),
    ("m10_summacc_ledger", "d_summacc_accountledger_itemwise",
     {"ar_summacccode": "1", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-31"}),
    ("m11_quarter_summary", "d_customerledger_quarter_summary",
     {"ai_custcode": "3386", "ar_startdate": "2024-01-01", "ar_enddate": "2024-12-31",
      "as_comment1": "", "as_comment2": "", "as_comment3": "", "as_comment4": "", "ai_allcustomers": "0"}),
    ("m12_stockinbackdate", "d_stockinbackdate",
     {"as_ReportType": "S", "ai_Code": "476111", "ai_PriceType": "1", "ad_date": "2024-01-31",
      "ai_gcode": "1", "as_allgodown": "N"}),
    ("m13_saleorderheader", "d_saleorderheader", {"ar_SaleOrderCode": "1"}),
    ("m14_po_disparity", "d_po_purchase_disparity",
     {"ai_pocode": "1", "ad_startdate": "2024-01-01", "ad_enddate": "2024-01-31"}),
    ("m15_cashflow5", "d_cashflow5", {"ad_StartDate": "2024-01-01", "ad_EndDate": "2024-01-31"}),
    ("m16_itemstockregister_portrait", "d_itemstockregister_withremarks",
     {"ar_icode": "476111", "ar_stdate": "2024-01-01", "ar_enddate": "2024-01-31"}),
    ("m17_custbalances_direct", "d_customerbalances_in_sales", {}),
    ("m18_custledger_plain", "d_customerledger_itemwise",
     {"ai_custcode": "19", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-31", "ai_allcustomers": "0"}),
    ("m19_itemstock_standard_year", "d_itemstockregister_standard",
     {"ar_icode": "476111", "ar_stdate": "2024-01-01", "ar_enddate": "2024-12-31"}),
    ("m20_supplierledger", "d_supplierledger_itemwise",
     {"ai_Suppcode": "101", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-07"}),
    ("m21_stockandsale", "d_stockandsale_zone_and_others",
     {"as_groupcriteria": "M", "ai_groupcode": "1", "ad_startdate": "2024-01-01", "ad_enddate": "2024-01-07",
      "ai_pricetype": "1", "ai_zonecode": "1", "ai_zonecode2": "1", "as_otherzone": "N"}),
    ("m22_quarter_summary", "d_customerledger_quarter_summary",
     {"ai_custcode": "19", "ar_startdate": "2024-01-01", "ar_enddate": "2024-01-31",
      "as_comment1": "", "as_comment2": "", "as_comment3": "", "as_comment4": "", "ai_allcustomers": "0"}),
]


def lit(v: str) -> str:
    return "'" + v.replace("'", "''") + "'" if not re.fullmatch(r"-?\d+(\.\d+)?", v) else v


def gen(name, params, header=True):
    r = by.get(name)
    if not r:
        print(f"!! missing {name}")
        return
    sql = r["sql"]["sql"].rstrip().rstrip(";")
    for k, v in params.items():
        sql = re.sub(r"(?i):" + re.escape(k) + r"\b", lit(v), sql)
    left = sorted(set(re.findall(r":([A-Za-z_]\w*)", sql)))
    body = ""
    if header:
        body += "SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\n"
    body += sql + ";\n"
    (OUT / f"{name}.sql").write_text(body, encoding="ascii", errors="replace")
    print(f"{name}: bytes={len(sql)} leftovers={left}")


if __name__ == "__main__":
    for fname, dw, params in CASES:
        gen(fname, params, header=True) if False else None
        r = by.get(dw)
        if not r:
            print(f"!! missing {dw}")
            continue
        sql = r["sql"]["sql"].rstrip().rstrip(";")
        for k, v in params.items():
            sql = re.sub(r"(?i):" + re.escape(k) + r"\b", lit(v), sql)
        left = sorted(set(re.findall(r":([A-Za-z_]\w*)", sql)))
        body = ("SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\n"
                + sql + ";\n")
        (OUT / f"{fname}.sql").write_text(body, encoding="ascii", errors="replace")
        print(f"{fname}: dw={dw} bytes={len(sql)} leftovers={left}")
