SET NOCOUNT ON;
SELECT 'TOP_TABLES' AS k;
SELECT TOP 40
  t.name AS tbl,
  SUM(CASE WHEN p.index_id IN (0,1) THEN p.rows ELSE 0 END) AS rows_,
  CAST(SUM(a.total_pages)*8.0/1024 AS DECIMAL(12,1)) AS total_mb,
  CAST(SUM(CASE WHEN p.index_id IN (0,1) THEN a.data_pages ELSE 0 END)*8.0/1024 AS DECIMAL(12,1)) AS data_mb,
  MAX(CASE WHEN i.index_id=0 THEN 1 ELSE 0 END) AS is_heap,
  COUNT(DISTINCT i.index_id) AS idx_cnt,
  (SELECT COUNT(*) FROM sys.columns c WHERE c.object_id=t.object_id) AS col_cnt,
  (SELECT COUNT(*) FROM sys.foreign_keys fk WHERE fk.parent_object_id=t.object_id) AS fk_out,
  (SELECT COUNT(*) FROM sys.foreign_keys fk WHERE fk.referenced_object_id=t.object_id) AS fk_in
FROM sys.tables t
JOIN sys.indexes i ON i.object_id=t.object_id
JOIN sys.partitions p ON p.object_id=i.object_id AND p.index_id=i.index_id
JOIN sys.allocation_units a ON a.container_id=p.partition_id
WHERE t.is_ms_shipped=0
GROUP BY t.object_id, t.name
ORDER BY SUM(CASE WHEN p.index_id IN (0,1) THEN p.rows ELSE 0 END) DESC;

SELECT 'HEAPS' AS k;
SELECT t.name AS tbl, p.rows,
  CAST(SUM(a.total_pages)*8.0/1024 AS DECIMAL(12,1)) AS mb,
  (SELECT COUNT(*) FROM sys.columns c WHERE c.object_id=t.object_id) AS cols
FROM sys.tables t
JOIN sys.indexes i ON i.object_id=t.object_id AND i.index_id=0
JOIN sys.partitions p ON p.object_id=t.object_id AND p.index_id=0
JOIN sys.allocation_units a ON a.container_id=p.partition_id
WHERE t.is_ms_shipped=0
GROUP BY t.object_id, t.name, p.rows
ORDER BY p.rows DESC;

SELECT 'IDX_SUMMARY' AS k;
SELECT i.type_desc, COUNT(*) AS cnt, SUM(p.rows) AS rows_total
FROM sys.indexes i
JOIN sys.tables t ON t.object_id=i.object_id AND t.is_ms_shipped=0
JOIN sys.partitions p ON p.object_id=i.object_id AND p.index_id=i.index_id
GROUP BY i.type_desc;

SELECT 'WIDEST' AS k;
SELECT TOP 25 t.name AS tbl,
  SUM(CASE WHEN c.system_type_id IN (167,175,231,239,35) THEN c.max_length ELSE 0 END) AS char_bytes_declared,
  COUNT(*) AS cols,
  MAX(c.max_length) AS max_col_len
FROM sys.tables t JOIN sys.columns c ON c.object_id=t.object_id
WHERE t.is_ms_shipped=0
GROUP BY t.object_id,t.name
ORDER BY SUM(CASE WHEN c.system_type_id IN (167,175,231,239,35) THEN c.max_length ELSE 0 END) DESC;
