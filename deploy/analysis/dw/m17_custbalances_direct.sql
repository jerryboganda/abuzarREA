SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT A.AccCode AS Code1, Sum(Debit - Credit) AS value1 FROM VirtualGL V, Accounts A, SubAccounts S WHERE V.AccCode = A.AccCode AND A.SubCode = S.SubAccCode AND S.SubAccCode = 3 GROUP BY A.AccCode, A.Name;
