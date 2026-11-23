import re
from pathlib import Path

OUT = Path(__file__).resolve().parent
leg = (OUT / "leg9.sql").read_text(encoding="ascii")


def sub(sql, **kw):
    for k, v in kw.items():
        sql = re.sub(r"(?i):" + k + r"\b", v, sql)
    return sql


params = dict(ad_StartDate="'2024-01-01'", ad_EndDate="'2024-01-31'")
before = sub(leg, **params)

# after: one grouped pass for count/min/max per cash account
after = leg
after = after.replace(
    "remarks='Total Invoices: ' + LTRIM(RTRIM(STR((SELECT COUNT(SaleInvCode) FROM saleledger "
    "WHERE saleledger.cashacccode = s.cashacccode and salecatcode = 3 and posted = 'Y' and accountfor='Y' "
    "and date >= :ad_StartDate and date <= :ad_EndDate), 7))) + ' (' + LTRIM(RTRIM(STR((SELECT MIN(SaleInvCode) "
    "FROM saleledger WHERE saleledger.cashacccode = s.cashacccode and salecatcode = 3 and posted = 'Y' and "
    "accountfor='Y' and date >= :ad_StartDate and date <= :ad_EndDate), 7))) + '-' + LTRIM(RTRIM(STR((SELECT "
    "MAX(SaleInvCode) FROM saleledger WHERE saleledger.cashacccode = s.cashacccode and salecatcode = 3 and "
    "posted = 'Y' and accountfor='Y' and date >= :ad_StartDate and date <= :ad_EndDate), 7))) + ')'",
    "remarks='Total Invoices: ' + LTRIM(RTRIM(STR(SL.n, 7))) + ' (' + LTRIM(RTRIM(STR(SL.mn, 7))) + '-' + "
    "LTRIM(RTRIM(STR(SL.mx, 7))) + ')'")
after = after.replace(
    ") S GROUP BY S.cashacccode HAVING SUM(S.Amt) <> 0",
    ") S LEFT JOIN (SELECT cashacccode, COUNT(*) n, MIN(SaleInvCode) mn, MAX(SaleInvCode) mx "
    "FROM saleledger WHERE salecatcode = 3 AND posted = 'Y' AND accountfor = 'Y' "
    "AND date >= :ad_StartDate AND date <= :ad_EndDate GROUP BY cashacccode) SL "
    "ON SL.cashacccode = S.cashacccode "
    "GROUP BY S.cashacccode, SL.n, SL.mn, SL.mx HAVING SUM(S.Amt) <> 0")
after = sub(after, **params)

hdr = "SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\n"
(OUT / "leg9_before.sql").write_text(hdr + before + ";\n", encoding="ascii", errors="replace")
(OUT / "leg9_after.sql").write_text(hdr + after + ";\n", encoding="ascii", errors="replace")
print("before len", len(before), "after len", len(after))
print("after has SL:", "SL.n" in after)
