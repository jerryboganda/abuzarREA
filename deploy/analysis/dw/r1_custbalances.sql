SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- rewrite A: filter accounts first, aggregate per account
SELECT A.AccCode AS Code1, ISNULL(bal.v,0) AS value1
FROM Accounts A
JOIN SubAccounts S ON A.SubCode = S.SubAccCode
OUTER APPLY (SELECT SUM(V.Debit - V.Credit) v FROM VirtualGl V WHERE V.AccCode = A.AccCode) bal
WHERE S.SubAccCode = 3;
