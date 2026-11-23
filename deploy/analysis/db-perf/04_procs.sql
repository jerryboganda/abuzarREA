SET NOCOUNT ON;
SELECT 'MODULE_STATS' AS k;
SELECT o.type_desc, COUNT(*) AS cnt, SUM(DATALENGTH(m.definition))/1024 AS total_kb,
       MAX(DATALENGTH(m.definition))/1024 AS max_kb
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0
GROUP BY o.type_desc;

SELECT 'PATTERNS' AS k;
SELECT
  SUM(CASE WHEN m.definition LIKE '%CURSOR%' THEN 1 ELSE 0 END) AS cursor_procs,
  SUM(CASE WHEN m.definition LIKE '%SELECT *%' THEN 1 ELSE 0 END) AS select_star_procs,
  SUM(CASE WHEN m.definition LIKE '%SELECT *%' THEN (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'SELECT *','')))/8 ELSE 0 END) AS select_star_occurrences,
  SUM(CASE WHEN m.definition LIKE '%NOLOCK%' THEN 1 ELSE 0 END) AS nolock_procs,
  SUM(CASE WHEN m.definition LIKE '%OPTION (RECOMPILE)%' OR m.definition LIKE '%OPTION(RECOMPILE)%' THEN 1 ELSE 0 END) AS recompile_procs,
  SUM(CASE WHEN m.definition LIKE '%sp_executesql%' THEN 1 ELSE 0 END) AS sp_executesql_procs,
  SUM(CASE WHEN m.definition LIKE '%EXEC(%' OR m.definition LIKE '%EXEC (%' THEN 1 ELSE 0 END) AS exec_dynamic_procs,
  SUM(CASE WHEN m.definition LIKE '%NOT IN%' THEN 1 ELSE 0 END) AS notin_procs,
  SUM(CASE WHEN m.definition LIKE '%CREATE TABLE #%' THEN 1 ELSE 0 END) AS temptable_procs,
  SUM(CASE WHEN m.definition LIKE '%LIKE ''%''%' THEN 1 ELSE 0 END) AS like_wildcard_procs,
  SUM(CASE WHEN m.definition LIKE '%GETDATE()%' THEN 1 ELSE 0 END) AS getdate_procs,
  SUM(CASE WHEN m.definition LIKE '%CONVERT(VARCHAR%GETDATE%' OR m.definition LIKE '%CONVERT(VARCHAR(10)%' THEN 1 ELSE 0 END) AS convert_date_procs
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0 AND o.type='P';

SELECT 'TOP_BY_SIZE' AS k;
SELECT TOP 30 o.name, o.type_desc, DATALENGTH(m.definition)/1024 AS kb,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'SELECT','')))/6 AS select_cnt,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'FROM','')))/4 AS from_cnt,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'JOIN','')))/4 AS join_cnt,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'CURSOR','')))/6 AS cursor_cnt,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'NOLOCK','')))/6 AS nolock_cnt
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0
ORDER BY DATALENGTH(m.definition) DESC;

SELECT 'TRIGGERS' AS k;
SELECT t.name AS tbl, tr.name AS trg, tr.is_instead_of_trigger, DATALENGTH(m.definition)/1024 AS kb,
  CASE WHEN m.definition LIKE '%CURSOR%' THEN 1 ELSE 0 END AS has_cursor,
  (DATALENGTH(m.definition)-DATALENGTH(REPLACE(m.definition,'SELECT','')))/6 AS select_cnt
FROM sys.triggers tr
JOIN sys.tables t ON t.object_id=tr.parent_id
JOIN sys.sql_modules m ON m.object_id=tr.object_id
WHERE tr.is_ms_shipped=0 ORDER BY DATALENGTH(m.definition) DESC;

SELECT 'REFS' AS k;
SELECT o.name, o.type_desc,
  CASE WHEN m.definition LIKE '%StockReport%' THEN 1 ELSE 0 END AS uses_stockreport,
  CASE WHEN m.definition LIKE '%VirtualGl%' THEN 1 ELSE 0 END AS uses_virtualgl
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE o.is_ms_shipped=0 AND (m.definition LIKE '%StockReport%' OR m.definition LIKE '%VirtualGl%')
ORDER BY o.type_desc, o.name;
