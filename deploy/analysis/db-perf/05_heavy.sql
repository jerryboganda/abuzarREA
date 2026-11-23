SET NOCOUNT ON;
SET STATISTICS IO ON;
SELECT 'STOCKREPORT_SHAPE' AS k;
SELECT COUNT(*) AS rows_, MIN([Date]) AS min_dt, MAX([Date]) AS max_dt,
       COUNT(DISTINCT CONVERT(varchar(10),[Date],120)) AS distinct_days,
       MIN(DATEPART(hour,[Date])) AS min_hr, MAX(DATEPART(hour,[Date])) AS max_hr
FROM StockReport;
SELECT 'STOCKREPORT_LAST' AS k;
SELECT TOP 5 [Date], COUNT(*) AS n FROM StockReport GROUP BY [Date] ORDER BY [Date] DESC;
SET STATISTICS IO OFF;

SET STATISTICS IO ON;
SELECT 'VIRTUALGL_SHAPE' AS k;
SELECT COUNT(*) AS rows_, MIN([Date]) AS min_dt, MAX([Date]) AS max_dt,
       COUNT(DISTINCT AccCode) AS acc_codes, COUNT(DISTINCT DocumentCode) AS doc_codes,
       COUNT(DISTINCT CONVERT(varchar(12),[Date],112)) AS distinct_days
FROM VirtualGl;
SET STATISTICS IO OFF;
