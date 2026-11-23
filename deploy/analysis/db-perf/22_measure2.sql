SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
PRINT '=== Q2b VirtualGl AccCode=2 full history to 2025 ===';
SELECT SUM(V.Debit - V.Credit) FROM VirtualGl V WHERE V.AccCode = 2 AND V.[Date] < '2025-01-01';
PRINT '=== Q3b VirtualGl AccCode=2 Dec-2024 ===';
SELECT SUM(V.Debit - V.Credit) FROM VirtualGl V WHERE V.AccCode = 2 AND V.[Date] >= '2024-12-01' AND V.[Date] < '2025-01-01';
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
