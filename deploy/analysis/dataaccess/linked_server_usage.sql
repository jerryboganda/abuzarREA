SET NOCOUNT ON;
SELECT o.name, o.type_desc
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE m.definition LIKE '%OPENROWSET%' OR m.definition LIKE '%OPENQUERY%'
   OR m.definition LIKE '%sp_addlinkedserver%' OR m.definition LIKE '%CRSSERVER%'
   OR m.definition LIKE '%OPENROWSET%' OR m.definition LIKE '%OPENDATASOURCE%'
ORDER BY o.name;

SELECT o.name
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE m.definition LIKE '%BEGIN DISTRIBUTED TRANSACTION%' OR m.definition LIKE '%SET XACT_ABORT%'
ORDER BY o.name;

SELECT COUNT(*) AS procs_with_at FROM sys.sql_modules m WHERE m.definition LIKE '%] AT %' OR m.definition LIKE '% AT [%';
