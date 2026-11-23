SET NOCOUNT ON;
GO
DECLARE @dbid INT;
DECLARE @id INT;
SET @dbid = DB_ID('FazalDinPP19DataBaseV2');

SET @id = OBJECT_ID('FazalDinPP19DataBaseV2.dbo.SaleLedger');
SELECT 'SaleLedger' AS tbl, avg_fragmentation_in_percent, avg_page_space_used_in_percent, page_count
FROM sys.dm_db_index_physical_stats(@dbid, @id, 1, NULL, 'SAMPLED');

SET @id = OBJECT_ID('FazalDinPP19DataBaseV2.dbo.ItemLog');
SELECT 'ItemLog' AS tbl, avg_fragmentation_in_percent, avg_page_space_used_in_percent, page_count
FROM sys.dm_db_index_physical_stats(@dbid, @id, 1, NULL, 'SAMPLED');

SET @id = OBJECT_ID('FazalDinPP19DataBaseV2.dbo.Purdetail');
SELECT 'Purdetail' AS tbl, avg_fragmentation_in_percent, avg_page_space_used_in_percent, page_count
FROM sys.dm_db_index_physical_stats(@dbid, @id, 1, NULL, 'SAMPLED');

SET @id = OBJECT_ID('FazalDinPP19DataBaseV2.dbo.PurOrderDetail');
SELECT 'PurOrderDetail' AS tbl, avg_fragmentation_in_percent, avg_page_space_used_in_percent, page_count
FROM sys.dm_db_index_physical_stats(@dbid, @id, 1, NULL, 'SAMPLED');

SET @id = OBJECT_ID('FazalDinPP19DataBaseV2.dbo.Item');
SELECT 'Item' AS tbl, avg_fragmentation_in_percent, avg_page_space_used_in_percent, page_count
FROM sys.dm_db_index_physical_stats(@dbid, @id, 1, NULL, 'SAMPLED');
GO
