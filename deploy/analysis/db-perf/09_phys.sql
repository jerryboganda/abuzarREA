SET NOCOUNT ON;
SELECT 'PHYS_TOP40' AS k;
SELECT TOP 40 OBJECT_NAME(ps.object_id) AS tbl, ps.index_id, i.name AS idx, ps.index_type_desc,
       ps.record_count, ps.avg_record_size_in_bytes AS avg_rec_b,
       ps.page_count, CAST(ps.page_count*8.0/1024 AS DECIMAL(10,1)) AS mb,
       CAST(ps.avg_page_space_used_in_percent AS DECIMAL(5,1)) AS page_fill_pct,
       CAST(ps.avg_fragmentation_in_percent AS DECIMAL(5,1)) AS frag_pct, ps.fragment_count,
       ps.forwarded_record_count
FROM sys.dm_db_index_physical_stats(DB_ID('FazalDinPP19DataBaseV2'), NULL, NULL, NULL, 'LIMITED') ps
JOIN FazalDinPP19DataBaseV2.sys.tables t ON t.object_id=ps.object_id
LEFT JOIN FazalDinPP19DataBaseV2.sys.indexes i ON i.object_id=ps.object_id AND i.index_id=ps.index_id
WHERE ps.page_count > 200
ORDER BY ps.page_count DESC;

SELECT 'FILLFACTOR' AS k;
SELECT i.fill_factor, COUNT(*) AS idx_cnt
FROM FazalDinPP19DataBaseV2.sys.indexes i
JOIN FazalDinPP19DataBaseV2.sys.tables t ON t.object_id=i.object_id AND t.is_ms_shipped=0
GROUP BY i.fill_factor ORDER BY i.fill_factor;

SELECT 'INDEX_COUNT_BY_TABLE' AS k;
SELECT TOP 15 t.name AS tbl, COUNT(*) AS idx_cnt,
  SUM(CASE WHEN i.type=2 THEN 1 ELSE 0 END) AS nc,
  SUM(CASE WHEN i.is_unique=1 THEN 1 ELSE 0 END) AS uniq,
  SUM(p.rows) AS rows_
FROM FazalDinPP19DataBaseV2.sys.tables t
JOIN FazalDinPP19DataBaseV2.sys.indexes i ON i.object_id=t.object_id
JOIN FazalDinPP19DataBaseV2.sys.partitions p ON p.object_id=i.object_id AND p.index_id=i.index_id
WHERE t.is_ms_shipped=0
GROUP BY t.name ORDER BY COUNT(*) DESC;
