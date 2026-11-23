SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;
SELECT COUNT(V.balance) AS n, SUM(ISNULL(V.balance,0)) AS total
FROM dbo.supplier S
JOIN dbo.accounts A ON A.acccode = S.suppcode
LEFT JOIN (
  SELECT V.AccCode, SUM(V.Debit - V.Credit) AS balance
  FROM VirtualGl V
  WHERE EXISTS (SELECT 1 FROM dbo.Supplier S2 WHERE S2.SuppCode = V.AccCode)
  GROUP BY V.AccCode
) V ON V.AccCode = A.AccCode;
