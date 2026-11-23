/* ============================================================================
   maintenance.sql
   Nightly Waseela database maintenance.
   - Refresh statistics on the hot tables.
   - Rebuild only indexes >30% fragmented with >1,000 pages.
   Run from master with Windows auth:
     sqlcmd -S .\SQLEXPRESS -E -C -d master -i maintenance.sql
   The DMV is queried from master because this database is compatibility 80.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== update statistics (hot tables) ===';
UPDATE STATISTICS dbo.SaleLedger      WITH FULLSCAN;
UPDATE STATISTICS dbo.SaleDetail      WITH FULLSCAN;
UPDATE STATISTICS dbo.VirtualGl       WITH FULLSCAN;
UPDATE STATISTICS dbo.StockReport     WITH FULLSCAN;
UPDATE STATISTICS dbo.Purdetail       WITH FULLSCAN;
UPDATE STATISTICS dbo.ItemLog         WITH FULLSCAN;
UPDATE STATISTICS dbo.PurOrderDetail  WITH FULLSCAN;
UPDATE STATISTICS dbo.Item            WITH FULLSCAN;
UPDATE STATISTICS dbo.SRLedger        WITH FULLSCAN;
UPDATE STATISTICS dbo.SRdetail        WITH FULLSCAN;
PRINT 'Statistics updated.';
GO

USE [master];
GO
PRINT '=== find indexes >30% fragmented and >1,000 pages ===';
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT @sql = @sql +
    N'USE [FazalDinPP19DataBaseV2]; ALTER INDEX ' + QUOTENAME(i.name) +
    N' ON ' + QUOTENAME(OBJECT_SCHEMA_NAME(i.object_id, DB_ID('FazalDinPP19DataBaseV2'))) +
    N'.' + QUOTENAME(OBJECT_NAME(i.object_id, DB_ID('FazalDinPP19DataBaseV2'))) +
    N' REBUILD WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);' + CHAR(13)
FROM sys.dm_db_index_physical_stats(DB_ID('FazalDinPP19DataBaseV2'), NULL, NULL, NULL, 'LIMITED') ps
JOIN FazalDinPP19DataBaseV2.sys.indexes i
  ON i.object_id = ps.object_id AND i.index_id = ps.index_id
WHERE i.type IN (1, 2)
  AND i.is_disabled = 0
  AND ps.page_count > 1000
  AND ps.avg_fragmentation_in_percent > 30;

IF @sql <> N''
BEGIN
    PRINT 'Rebuilding:';
    PRINT @sql;
    EXEC sp_executesql @sql;
END
ELSE
    PRINT 'No index above 30% fragmentation and 1,000 pages.';
GO

PRINT '=== maintenance.sql completed ===';
GO
