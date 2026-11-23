SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT A.name, A.aliasname, S.suppcode, S.address1, S.phone, S.City, S.country, S.suppcatcode,
       balancetype = CASE WHEN V.balance > 0 THEN 'DR.' ELSE 'CR.' END,
       balance = CASE A.restricted WHEN 'Y' THEN 0 ELSE V.balance END,
       SummaryAccount = CASE WHEN (SELECT COUNT(SD.AccCode) FROM SummaryAccountDetail SD WHERE SD.AccCode = A.AccCode) = 0 THEN NULL
                             ELSE (SELECT MAX(SA.Name) + ' (' + MAX(SA.AliasName) + ')' FROM SummaryAccount SA, SummaryAccountDetail SD WHERE SD.AccCode = A.AccCode AND SD.SummaryAccCode = SA.SummaryAccCode) END
FROM dbo.supplier S
JOIN dbo.accounts A ON A.acccode = S.suppcode
OUTER APPLY (SELECT SUM(V.Debit - V.Credit) AS balance FROM VirtualGl V WHERE V.AccCode = A.AccCode) V;
