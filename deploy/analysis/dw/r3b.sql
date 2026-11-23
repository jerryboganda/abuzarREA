SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;
SELECT A.AccCode AS Code1, Sum(V.Debit - V.Credit) AS value1
FROM Accounts A
JOIN SubAccounts S ON A.SubCode = S.SubAccCode
JOIN VirtualGl V ON V.AccCode = A.AccCode
WHERE S.SubAccCode = 3
GROUP BY A.AccCode, A.Name
OPTION (FORCE ORDER);
