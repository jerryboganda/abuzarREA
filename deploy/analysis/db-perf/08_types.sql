SET NOCOUNT ON;
SELECT 'TYPE_CENSUS' AS k;
SELECT ty.name AS typ, COUNT(*) AS cols, SUM(c.max_length) AS declared_bytes,
       SUM(CASE WHEN c.max_length=255 THEN 1 ELSE 0 END) AS len255,
       SUM(CASE WHEN c.max_length=510 THEN 1 ELSE 0 END) AS len510_nvarchar255,
       SUM(CASE WHEN c.max_length=8000 THEN 1 ELSE 0 END) AS len8000,
       SUM(CASE WHEN c.max_length=-1 THEN 1 ELSE 0 END) AS max_types
FROM sys.columns c
JOIN sys.tables t ON t.object_id=c.object_id AND t.is_ms_shipped=0
JOIN sys.types ty ON ty.user_type_id=c.user_type_id
GROUP BY ty.name ORDER BY COUNT(*) DESC;

SELECT 'CHAR255_TOP' AS k;
SELECT TOP 25 t.name AS tbl, COUNT(*) AS char255_cols, SUM(c.max_length) AS bytes_per_row
FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id AND t.is_ms_shipped=0
WHERE c.system_type_id IN (175,239) AND c.max_length=255
GROUP BY t.name ORDER BY COUNT(*) DESC;

SELECT 'NVARCHAR_TOP' AS k;
SELECT TOP 20 t.name AS tbl, COUNT(*) AS nvarchar_cols, SUM(c.max_length) AS bytes_per_row
FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id AND t.is_ms_shipped=0
WHERE c.system_type_id IN (231,239) AND c.max_length>0
GROUP BY t.name ORDER BY SUM(c.max_length) DESC;

SELECT 'LOB_COLS' AS k;
SELECT t.name AS tbl, c.name AS col, ty.name AS typ, c.max_length
FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id AND t.is_ms_shipped=0
JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE ty.name IN ('text','ntext','image') ORDER BY t.name, c.name;

SELECT 'ITEM_COLS' AS k;
SELECT c.column_id, c.name, ty.name AS typ, c.max_length, c.precision, c.scale, c.is_nullable
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE c.object_id=OBJECT_ID('Item') ORDER BY c.column_id;

SELECT 'SALELEDGER_COLS_WIDE' AS k;
SELECT c.column_id, c.name, ty.name AS typ, c.max_length, c.precision, c.scale, c.is_nullable
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE c.object_id=OBJECT_ID('SaleLedger') AND c.max_length>=20
ORDER BY c.max_length DESC;

SELECT 'SALEDETAIL_COLS_WIDE' AS k;
SELECT c.column_id, c.name, ty.name AS typ, c.max_length, c.precision, c.scale, c.is_nullable
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE c.object_id=OBJECT_ID('Saledetail') AND c.max_length>=20
ORDER BY c.max_length DESC;
