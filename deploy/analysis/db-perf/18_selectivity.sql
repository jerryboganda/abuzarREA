SET NOCOUNT ON;
SELECT 'VIRTUALGL_COL_SELECTIVITY' AS k;
SELECT COUNT(*) AS rows_,
  COUNT(DISTINCT PatientCode) AS pat_distinct, SUM(CASE WHEN PatientCode IS NULL THEN 1 ELSE 0 END) AS pat_null,
  COUNT(DISTINCT StudentCode) AS stu_distinct, SUM(CASE WHEN StudentCode IS NULL THEN 1 ELSE 0 END) AS stu_null,
  COUNT(DISTINCT GuestCode) AS guest_distinct, SUM(CASE WHEN GuestCode IS NULL THEN 1 ELSE 0 END) AS guest_null,
  COUNT(DISTINCT AlternateAccCode) AS alt_distinct, SUM(CASE WHEN AlternateAccCode IS NULL THEN 1 ELSE 0 END) AS alt_null,
  COUNT(DISTINCT CatCode) AS cat_distinct, COUNT(DISTINCT DocumentType) AS dt_distinct
FROM VirtualGl;

SELECT 'INDEX_SPACE_BY_TYPE' AS k;
SELECT i.type_desc, COUNT(*) AS idx_cnt, SUM(ps.used_page_count)*8/1024 AS used_mb,
       SUM(ps.row_count) AS entries
FROM sys.indexes i
JOIN sys.dm_db_partition_stats ps ON ps.object_id=i.object_id AND ps.index_id=i.index_id
JOIN sys.tables t ON t.object_id=i.object_id AND t.is_ms_shipped=0
GROUP BY i.type_desc;

SELECT 'TOP_INDEX_SPACE' AS k;
SELECT TOP 20 OBJECT_NAME(ps.object_id) AS tbl, SUM(ps.used_page_count)*8/1024 AS idx_mb, COUNT(*) AS idx_cnt
FROM sys.dm_db_partition_stats ps
JOIN sys.indexes i ON i.object_id=ps.object_id AND i.index_id=ps.index_id
JOIN sys.tables t ON t.object_id=ps.object_id AND t.is_ms_shipped=0
WHERE i.type=2
GROUP BY ps.object_id ORDER BY SUM(ps.used_page_count) DESC;

SELECT 'PROCS_USING_BOTH_BIG' AS k;
SELECT COUNT(*) AS procs_both FROM sys.sql_modules
WHERE definition LIKE '%SaleLedger%' AND definition LIKE '%Saledetail%';
SELECT COUNT(*) AS procs_saleledger FROM sys.sql_modules WHERE definition LIKE '%SaleLedger%';
SELECT COUNT(*) AS procs_saledetail FROM sys.sql_modules WHERE definition LIKE '%Saledetail%';
SELECT COUNT(*) AS procs_virtualgl FROM sys.sql_modules WHERE definition LIKE '%VirtualGl%';

SELECT 'REDUNDANT_PREFIX_TOP' AS k;
SELECT t.name AS tbl, i1.name AS redundant_idx, i2.name AS superset_idx,
  CAST(ps1.used_page_count*8.0/1024 AS DECIMAL(10,1)) AS redundant_mb
FROM sys.tables t
JOIN sys.indexes i1 ON i1.object_id=t.object_id AND i1.type=2 AND i1.is_unique=0
JOIN sys.indexes i2 ON i2.object_id=t.object_id AND i2.index_id<>i1.index_id AND i2.type IN (1,2)
JOIN sys.dm_db_partition_stats ps1 ON ps1.object_id=i1.object_id AND ps1.index_id=i1.index_id
WHERE t.is_ms_shipped=0 AND ps1.used_page_count>50
AND NOT EXISTS (
  SELECT 1 FROM sys.index_columns a
  JOIN sys.index_columns b ON b.object_id=a.object_id AND b.index_id=i2.index_id AND b.key_ordinal=a.key_ordinal
  WHERE a.object_id=i1.object_id AND a.index_id=i1.index_id AND a.is_included_column=0
    AND (b.column_id<>a.column_id OR b.is_included_column=1)
)
AND EXISTS (SELECT 1 FROM sys.index_columns k WHERE k.object_id=i1.object_id AND k.index_id=i1.index_id AND k.is_included_column=0)
ORDER BY ps1.used_page_count DESC;
