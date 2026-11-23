GO
SET SHOWPLAN_TEXT ON;
GO
SELECT ICode, GCode, Stock, PurchasePrice, SalePrice
FROM StockReport
WHERE [Date] >= '2024-12-01' AND [Date] < '2025-01-02' AND ICode = 100;
GO
SELECT AccCode, Debit, Credit, [Date], DocumentCode, DocumentType
FROM VirtualGl
WHERE AccCode = 19 AND [Date] >= '2024-12-01' AND [Date] < '2025-01-01';
GO
SELECT SaleInvCode, [date], CustCode, InvTotal
FROM SaleLedger
WHERE CustCode = 19 AND [date] >= '2024-12-01' AND [date] < '2025-01-01';
GO
SELECT SaleInvcode, ICode, PackQty, LooseQty, Rate
FROM Saledetail
WHERE SaleInvcode = 500000;
GO
SET SHOWPLAN_TEXT OFF;
GO
