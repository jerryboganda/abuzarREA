SET NOCOUNT ON;
IF OBJECT_ID('tempdb..#fk') IS NOT NULL DROP TABLE #fk;
CREATE TABLE #fk (
  fk_name sysname, tbl sysname, ref_tbl sysname, cols nvarchar(400), col_count int,
  obj_id int, ref_id int, rows_ bigint, total_mb decimal(12,1)
);
INSERT #fk
SELECT fk.name, tp.name, tr.name,
  STUFF((SELECT ','+c.name FROM sys.foreign_key_columns fkc
         JOIN sys.columns c ON c.object_id=fkc.parent_object_id AND c.column_id=fkc.parent_column_id
         WHERE fkc.constraint_object_id=fk.object_id ORDER BY fkc.constraint_column_id
         FOR XML PATH('')),1,1,''),
  (SELECT COUNT(*) FROM sys.foreign_key_columns fkc WHERE fkc.constraint_object_id=fk.object_id),
  tp.object_id, tr.object_id, 0, 0
FROM sys.foreign_keys fk
JOIN sys.tables tp ON tp.object_id=fk.parent_object_id
JOIN sys.tables tr ON tr.object_id=fk.referenced_object_id;

UPDATE f SET rows_=x.rows_, total_mb=x.mb
FROM #fk f
JOIN (SELECT t.object_id, SUM(CASE WHEN p.index_id IN (0,1) THEN p.rows ELSE 0 END) AS rows_,
             CAST(SUM(a.total_pages)*8.0/1024 AS DECIMAL(12,1)) AS mb
      FROM sys.tables t JOIN sys.indexes i ON i.object_id=t.object_id AND i.index_id IN (0,1)
      JOIN sys.partitions p ON p.object_id=i.object_id AND p.index_id=i.index_id
      JOIN sys.allocation_units a ON a.container_id=p.partition_id
      GROUP BY t.object_id) x ON x.object_id=f.obj_id;

SELECT 'FK_TOTALS' AS k;
SELECT COUNT(*) AS fks,
  SUM(CASE WHEN is_not_trusted=1 THEN 1 ELSE 0 END) AS untrusted,
  SUM(CASE WHEN is_disabled=1 THEN 1 ELSE 0 END) AS disabled,
  SUM(CASE WHEN delete_referential_action_desc<>'NO_ACTION' THEN 1 ELSE 0 END) AS cascading
FROM sys.foreign_keys;

SELECT 'FK_UNINDEXED_TOP' AS k;
SELECT TOP 40 f.tbl, f.rows_, f.total_mb, f.col_count, f.cols, f.ref_tbl, f.fk_name,
  CASE WHEN EXISTS (
    SELECT 1 FROM sys.index_columns ic
    JOIN sys.indexes i ON i.object_id=ic.object_id AND i.index_id=ic.index_id
    WHERE ic.object_id=f.obj_id AND ic.key_ordinal=1 AND i.is_disabled=0
      AND ic.column_id = (SELECT TOP 1 fkc.parent_column_id FROM sys.foreign_key_columns fkc
                          WHERE fkc.constraint_object_id=OBJECT_ID(f.fk_name) ORDER BY fkc.constraint_column_id)
  ) THEN 1 ELSE 0 END AS has_leading_idx,
  CASE WHEN EXISTS (
    SELECT 1 FROM sys.index_columns ic
    JOIN sys.indexes i ON i.object_id=ic.object_id AND i.index_id=ic.index_id
    WHERE ic.object_id=f.obj_id AND ic.key_ordinal=1 AND i.is_disabled=0
      AND ic.column_id IN (SELECT fkc.parent_column_id FROM sys.foreign_key_columns fkc WHERE fkc.constraint_object_id=OBJECT_ID(f.fk_name))
  ) THEN 1 ELSE 0 END AS has_any_fk_col_leading
FROM #fk f
ORDER BY f.total_mb DESC, f.rows_ DESC;

SELECT 'FK_COVERAGE_SUMMARY' AS k;
SELECT
  COUNT(*) AS fk_total,
  SUM(CASE WHEN has_leading_idx=1 THEN 1 ELSE 0 END) AS leading_covered,
  SUM(CASE WHEN has_leading_idx=0 THEN 1 ELSE 0 END) AS leading_missing
FROM (
  SELECT f.fk_name,
    CASE WHEN EXISTS (
      SELECT 1 FROM sys.index_columns ic
      JOIN sys.indexes i ON i.object_id=ic.object_id AND i.index_id=ic.index_id
      WHERE ic.object_id=f.obj_id AND ic.key_ordinal=1 AND i.is_disabled=0
        AND ic.column_id = (SELECT TOP 1 fkc.parent_column_id FROM sys.foreign_key_columns fkc
                            WHERE fkc.constraint_object_id=OBJECT_ID(f.fk_name) ORDER BY fkc.constraint_column_id)
    ) THEN 1 ELSE 0 END AS has_leading_idx
  FROM #fk f
) s;

SELECT 'FK_MISSING_BY_TABLE' AS k;
SELECT TOP 30 f.tbl, MAX(f.rows_) AS rows_, MAX(f.total_mb) AS total_mb, COUNT(*) AS missing_fk_idx,
  STUFF((SELECT '; '+x.cols+'->'+x.ref_tbl FROM #fk x
         WHERE x.tbl=f.tbl AND NOT EXISTS (
           SELECT 1 FROM sys.index_columns ic JOIN sys.indexes i ON i.object_id=ic.object_id AND i.index_id=ic.index_id
           WHERE ic.object_id=x.obj_id AND ic.key_ordinal=1 AND i.is_disabled=0
             AND ic.column_id=(SELECT TOP 1 fkc.parent_column_id FROM sys.foreign_key_columns fkc
                               WHERE fkc.constraint_object_id=OBJECT_ID(x.fk_name) ORDER BY fkc.constraint_column_id))
         FOR XML PATH('')),1,2,'') AS fks
FROM #fk f
WHERE NOT EXISTS (
  SELECT 1 FROM sys.index_columns ic JOIN sys.indexes i ON i.object_id=ic.object_id AND i.index_id=ic.index_id
  WHERE ic.object_id=f.obj_id AND ic.key_ordinal=1 AND i.is_disabled=0
    AND ic.column_id=(SELECT TOP 1 fkc.parent_column_id FROM sys.foreign_key_columns fkc
                      WHERE fkc.constraint_object_id=OBJECT_ID(f.fk_name) ORDER BY fkc.constraint_column_id))
GROUP BY f.tbl
ORDER BY MAX(f.total_mb) DESC;
