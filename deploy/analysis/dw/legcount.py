import json, re
from pathlib import Path

rows = json.load(open(Path(__file__).parent / "dw_metrics.json", encoding="utf-8"))
by = {r["name"]: r for r in rows}


def top_level_parts(sql):
    """Split on UNION [ALL] at paren depth 0."""
    parts, buf = [], []
    depth = 0
    i = 0
    while i < len(sql):
        c = sql[i]
        if c == "(":
            depth += 1
        elif c == ")":
            depth = max(0, depth - 1)
        if depth == 0:
            m = re.match(r"\bUNION\b(\s+ALL\b)?", sql[i:], re.I)
            if m:
                parts.append("".join(buf))
                buf = []
                i += m.end()
                continue
        buf.append(c)
        i += 1
    parts.append("".join(buf))
    return parts


for n in ["d_customerledger_itemwise", "d_customerledger_itemwise_portrait",
          "d_cashflow", "d_cashflow5", "d_customerledger_quarter_summary",
          "d_stockandsale_zone_and_others", "d_itemstockregister_standard",
          "d_inpatientbill", "d_customerledger_withbalance"]:
    r = by.get(n)
    if not r:
        continue
    s = r["sql"]["sql"]
    parts = top_level_parts(s)
    print(f"{n:46s} bytes={len(s):6d} top-level-legs={len(parts):3d} rawUNION={r['sql']['union']:3d} subq={r['sql']['subqueries']}")
