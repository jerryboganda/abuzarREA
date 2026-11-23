SET NOCOUNT ON;
SELECT 'OLD_JOIN_SYNTAX' AS k;
SELECT o.name, o.type_desc
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id
WHERE m.definition LIKE '%*=%' OR m.definition LIKE '%=*%';

SELECT 'COMPAT80_PARSER_TESTS' AS k;
