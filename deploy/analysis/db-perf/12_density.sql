SET NOCOUNT ON;
SELECT 'ITEM_IDX_PARTITIONS' AS k;
SELECT i.index_id, i.name, i.type_desc, ps.row_count, ps.used_page_count, ps.reserved_page_count,
       CAST(ps.used_page_count*8.0/1024 AS DECIMAL(10,1)) AS used_mb
FROM sys.indexes i JOIN sys.dm_db_partition_stats ps ON ps.object_id=i.object_id AND ps.index_id=i.index_id
WHERE i.object_id=OBJECT_ID('Item') ORDER BY i.index_id;

SELECT 'ITEM_IDX100_COLS' AS k;
SELECT ic.index_id, ic.index_column_id, ic.key_ordinal, ic.is_included_column, c.name, c.max_length
FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
WHERE ic.object_id=OBJECT_ID('Item') AND ic.index_id=100 ORDER BY ic.index_column_id;

SELECT 'TOP10_IDX_PARTITIONS' AS k;
SELECT TOP 40 OBJECT_NAME(ps.object_id) AS tbl, ps.index_id, i.name, i.type_desc, ps.row_count,
       CAST(ps.used_page_count*8.0/1024 AS DECIMAL(10,1)) AS used_mb
FROM sys.dm_db_partition_stats ps
JOIN sys.indexes i ON i.object_id=ps.object_id AND i.index_id=ps.index_id
WHERE OBJECT_NAME(ps.object_id) IN ('Item','SaleLedger','Saledetail','VirtualGl','StockReport','ItemLog','Purdetail','PurOrderDetail')
ORDER BY ps.used_page_count DESC;
