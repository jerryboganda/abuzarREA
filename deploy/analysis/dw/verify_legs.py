import json
import re
from pathlib import Path

rows = json.load(open(Path(__file__).parent / "dw_metrics.json", encoding="utf-8"))
by = {r["name"]: r for r in rows}


def legs(s):
    p, buf, d, i = [], [], 0, 0
    while i < len(s):
        c = s[i]
        if c == "(":
            d += 1
        elif c == ")":
            d = max(0, d - 1)
        if d == 0:
            m = re.match(r"\bUNION\b(\s+ALL\b)?", s[i:], re.I)
            if m:
                p.append("".join(buf))
                buf = []
                i += m.end()
                continue
        buf.append(c)
        i += 1
    p.append("".join(buf))
    return len(p)


for n in ["d_customerledger_itemwise_portrait", "d_cashflow_withreceiptsummary",
          "d_cashflow_cashandbanks", "d_cashflow_onecashacc_portrait",
          "d_inpatientbill_grouped", "d_itemstockregister_new",
          "d_purchase_order_format11", "d_stockandsale_zone_and_others",
          "d_cashflow", "d_cashflow5", "d_supplierledger_itemwise",
          "d_godown_saleperson_activity", "d_inpatientbill"]:
    r = by.get(n)
    if r:
        print(f"{n:46s} raw={r['sql']['union']:3d} top={legs(r['sql']['sql']):3d}")
