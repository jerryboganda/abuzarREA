SET NOCOUNT ON;
SELECT i.name AS index_name, i.type_desc, c.name AS col, ic.key_ordinal
FROM sys.indexes i
JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID('dbo.Item') AND ic.key_ordinal > 0
ORDER BY i.index_id, ic.key_ordinal;

SELECT i.name AS index_name, i.type_desc, c.name AS col, ic.key_ordinal
FROM sys.indexes i
JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID('dbo.GodownDetail') AND ic.key_ordinal > 0
ORDER BY i.index_id, ic.key_ordinal;

SELECT COUNT(*) AS godown_rows FROM dbo.GodownDetail;
