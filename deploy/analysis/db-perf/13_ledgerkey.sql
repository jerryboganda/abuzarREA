SET NOCOUNT ON;
SELECT 'SALELEDGER_KEY_SHAPE' AS k;
SELECT COUNT(*) AS rows_, COUNT(DISTINCT SaleInvCode) AS distinct_codes, MIN(SaleInvCode) AS min_code, MAX(SaleInvCode) AS max_code,
       MIN([date]) AS min_date, MAX([date]) AS max_date
FROM FazalDinPP19DataBaseV2.dbo.SaleLedger;

SELECT 'SALELEDGER_CODE_SAMPLE' AS k;
SELECT SaleInvCode, [date], CustCode
FROM FazalDinPP19DataBaseV2.dbo.SaleLedger
WHERE SaleInvCode % 20000 = 0
ORDER BY SaleInvCode;

SELECT 'SALEDETAIL_PER_INVOICE' AS k;
SELECT COUNT(*) AS invoices, AVG(CAST(lines AS decimal(10,2))) AS avg_lines, MAX(lines) AS max_lines
FROM (SELECT SaleInvcode, COUNT(*) AS lines FROM FazalDinPP19DataBaseV2.dbo.Saledetail GROUP BY SaleInvcode) x;

SELECT 'SALELEDGER_DATE_MONTHS' AS k;
SELECT CONVERT(varchar(7),[date],120) AS ym, COUNT(*) AS n
FROM FazalDinPP19DataBaseV2.dbo.SaleLedger GROUP BY CONVERT(varchar(7),[date],120) ORDER BY ym;
