SET NOCOUNT ON;
SELECT 'PROC_SCORE' AS k;
SELECT TOP 35 o.name, DATALENGTH(m.definition)/1024 AS kb,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'CURSOR','')))/6 AS cursors,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'SELECT *','')))/8 AS sel_star,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'NOT IN','')))/6 AS not_in,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'#','')))/1 AS hash_marks,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'GETDATE()','')))/9 AS getdate_cnt,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'ISNULL(','')))/7 AS isnull_cnt,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'DISTINCT','')))/8 AS distinct_cnt,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'UNION','')))/5 AS union_cnt,
  (LEN(m.definition)-LEN(REPLACE(m.definition,' LIKE ','')))/6 AS like_cnt,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'CONVERT(','')))/8 AS convert_cnt
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.type='P' AND o.is_ms_shipped=0
ORDER BY (LEN(m.definition)-LEN(REPLACE(m.definition,'CURSOR','')))/6*10
       + (LEN(m.definition)-LEN(REPLACE(m.definition,'SELECT *','')))/8*4
       + (LEN(m.definition)-LEN(REPLACE(m.definition,'NOT IN','')))/6*3
       + (LEN(m.definition)-LEN(REPLACE(m.definition,'#','')))/1*1
       + (LEN(m.definition)-LEN(REPLACE(m.definition,'GETDATE()','')))/9*1 DESC;

SELECT 'CURSOR_PROCS' AS k;
SELECT o.name, DATALENGTH(m.definition)/1024 AS kb,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'CURSOR','')))/6 AS cursor_refs
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.type='P' AND m.definition LIKE '%CURSOR%'
ORDER BY (LEN(m.definition)-LEN(REPLACE(m.definition,'CURSOR','')))/6 DESC;

SELECT 'SELECT_STAR_PROCS' AS k;
SELECT o.name, DATALENGTH(m.definition)/1024 AS kb,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'SELECT *','')))/8 AS stars
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.type='P' AND m.definition LIKE '%SELECT *%'
ORDER BY (LEN(m.definition)-LEN(REPLACE(m.definition,'SELECT *','')))/8 DESC;

SELECT 'LEADING_WILDCARD' AS k;
SELECT o.name, o.type_desc
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0 AND (m.definition LIKE '%LIKE ''%''%' OR m.definition LIKE '%LIKE ''% %');

SELECT 'DYNAMIC_OR_EXEC' AS k;
SELECT o.name,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'sp_executesql','')))/13 AS sp_exec,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'EXEC (','')))/6 AS exec_paren,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'EXEC(','')))/5 AS exec_paren2
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0 AND (m.definition LIKE '%EXEC (%' OR m.definition LIKE '%EXEC(%' OR m.definition LIKE '%sp_executesql%');

SELECT 'SET_OPTIONS' AS k;
SELECT uses_ansi_nulls, uses_quoted_identifier, COUNT(*) AS modules
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id AND o.is_ms_shipped=0
GROUP BY uses_ansi_nulls, uses_quoted_identifier;

SELECT 'UNTRUSTED_FK' AS k;
SELECT TOP 25 tp.name AS child_tbl, fk.name, tr.name AS parent_tbl, fk.is_not_for_replication
FROM sys.foreign_keys fk
JOIN sys.tables tp ON tp.object_id=fk.parent_object_id
JOIN sys.tables tr ON tr.object_id=fk.referenced_object_id
WHERE fk.is_not_trusted=1
ORDER BY tp.name;

SELECT 'FREE_SPACE' AS k;
SELECT name, size*8/1024 AS size_mb,
  FILEPROPERTY(name,'SpaceUsed')*8/1024 AS used_mb,
  (size-FILEPROPERTY(name,'SpaceUsed'))*8/1024 AS free_mb
FROM sys.database_files;

SELECT 'TEMPDB' AS k;
SELECT name, physical_name, size*8/1024 AS size_mb, growth, is_percent_growth, max_size
FROM tempdb.sys.database_files;
