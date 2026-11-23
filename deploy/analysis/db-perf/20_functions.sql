SET NOCOUNT ON;
SELECT 'FUNCTIONS' AS k;
SELECT o.name, o.type_desc, DATALENGTH(m.definition)/1024 AS kb,
  CASE WHEN m.definition LIKE '%RETURNS @%' THEN 'MSTVF' WHEN m.definition LIKE '%RETURNS TABLE%' THEN 'INLINE' ELSE 'SCALAR' END AS kind,
  (LEN(m.definition)-LEN(REPLACE(m.definition,'SELECT','')))/6 AS selects_
FROM sys.objects o JOIN sys.sql_modules m ON m.object_id=o.object_id
WHERE o.type IN ('FN','IF','TF') AND o.is_ms_shipped=0
ORDER BY DATALENGTH(m.definition) DESC;

SELECT 'SCALAR_UDF_REFS' AS k;
SELECT f.name,
  (SELECT COUNT(*) FROM sys.sql_modules m WHERE m.definition LIKE '%'+f.name+'%') AS module_refs
FROM sys.objects f WHERE f.type='FN' AND f.is_ms_shipped=0
ORDER BY module_refs DESC;

SELECT 'VIEW_NESTING' AS k;
SELECT v.name, DATALENGTH(m.definition)/1024 AS kb FROM sys.views v JOIN sys.sql_modules m ON m.object_id=v.object_id
ORDER BY DATALENGTH(m.definition) DESC;

SELECT 'COMPUTED_COLUMNS' AS k;
SELECT t.name AS tbl, c.name, c.is_computed FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id
WHERE c.is_computed=1 AND t.is_ms_shipped=0;
