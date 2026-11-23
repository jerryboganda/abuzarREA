/* ============================================================================
   07_rebuild.sql
   Rebuild the five fragmented hot tables at a sane fill factor.
   Offline operation — stop abuzar.exe first.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 07.1 rebuild SaleLedger (FF80) ===';
ALTER INDEX PK_SaleLedger ON dbo.SaleLedger
    REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
PRINT 'SaleLedger rebuilt.';
GO

PRINT '=== 07.2 rebuild ItemLog (FF90) ===';
ALTER INDEX PK_ItemLog ON dbo.ItemLog
    REBUILD WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
PRINT 'ItemLog rebuilt.';
GO

PRINT '=== 07.3 rebuild Purdetail (FF90) ===';
ALTER INDEX PK_Purdetail_2__12 ON dbo.Purdetail
    REBUILD WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
PRINT 'Purdetail rebuilt.';
GO

PRINT '=== 07.4 rebuild PurOrderDetail (FF90) ===';
ALTER INDEX PK_PurOrderDetail_1__11 ON dbo.PurOrderDetail
    REBUILD WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
PRINT 'PurOrderDetail rebuilt.';
GO

PRINT '=== 07.5 rebuild Item (FF85) ===';
ALTER INDEX PK_Item ON dbo.Item
    REBUILD WITH (FILLFACTOR = 85, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
PRINT 'Item rebuilt.';
GO

PRINT '=== 07.6 refresh statistics on rebuilt tables ===';
UPDATE STATISTICS dbo.SaleLedger WITH FULLSCAN;
UPDATE STATISTICS dbo.ItemLog WITH FULLSCAN;
UPDATE STATISTICS dbo.Purdetail WITH FULLSCAN;
UPDATE STATISTICS dbo.PurOrderDetail WITH FULLSCAN;
UPDATE STATISTICS dbo.Item WITH FULLSCAN;
GO

PRINT '=== 07.7 fragmentation verification is in 07_verify_fragmentation.sql (run from master) ===';
GO

PRINT '=== 07_rebuild.sql completed ===';
GO
