/* ============================================================================
   02_statistics.sql
   Refresh statistics on the hot tables and fix space metadata.
   Safe to re-run.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 02.1 UPDATE STATISTICS (FULLSCAN) ===';
UPDATE STATISTICS dbo.SaleLedger      WITH FULLSCAN;
PRINT 'SaleLedger statistics updated.';
UPDATE STATISTICS dbo.SaleDetail      WITH FULLSCAN;
PRINT 'SaleDetail statistics updated.';
UPDATE STATISTICS dbo.VirtualGl       WITH FULLSCAN;
PRINT 'VirtualGl statistics updated.';
UPDATE STATISTICS dbo.StockReport     WITH FULLSCAN;
PRINT 'StockReport statistics updated.';
UPDATE STATISTICS dbo.Purdetail       WITH FULLSCAN;
PRINT 'Purdetail statistics updated.';
UPDATE STATISTICS dbo.ItemLog         WITH FULLSCAN;
PRINT 'ItemLog statistics updated.';
UPDATE STATISTICS dbo.PurOrderDetail  WITH FULLSCAN;
PRINT 'PurOrderDetail statistics updated.';
UPDATE STATISTICS dbo.Item            WITH FULLSCAN;
PRINT 'Item statistics updated.';
UPDATE STATISTICS dbo.SRLedger        WITH FULLSCAN;
PRINT 'SRLedger statistics updated.';
UPDATE STATISTICS dbo.SRdetail        WITH FULLSCAN;
PRINT 'SRdetail statistics updated.';
GO

PRINT '=== 02.2 DBCC UPDATEUSAGE ===';
DBCC UPDATEUSAGE ([FazalDinPP19DataBaseV2]) WITH COUNT_ROWS, NO_INFOMSGS;
PRINT 'DBCC UPDATEUSAGE completed.';
GO

PRINT '=== 02_statistics.sql completed ===';
GO
