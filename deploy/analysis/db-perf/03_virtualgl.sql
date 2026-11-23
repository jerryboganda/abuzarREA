SET NOCOUNT ON;
SELECT 'MISSING_IDX' AS k;
SELECT TOP 25
  DB_NAME(mid.database_id) AS db, OBJECT_NAME(mid.object_id, mid.database_id) AS tbl,
  migs.user_seeks, migs.user_scans, migs.avg_total_user_cost, migs.avg_user_impact,
  migs.user_seeks*migs.avg_total_user_cost*migs.avg_user_impact/100.0 AS score,
  mid.equality_columns, mid.inequality_columns, mid.included_columns, mid.statement
FROM sys.dm_db_missing_index_details mid
JOIN sys.dm_db_missing_index_groups mig ON mig.index_handle=mid.index_handle
JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle=mig.index_group_handle
WHERE mid.database_id=DB_ID()
ORDER BY migs.user_seeks*migs.avg_total_user_cost*migs.avg_user_impact DESC;

SELECT 'COLS_VIRTUALGL' AS k;
SELECT c.column_id, c.name, ty.name AS typ, c.max_length, c.precision, c.scale, c.is_nullable, c.is_identity
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE c.object_id=OBJECT_ID('VirtualGl') ORDER BY c.column_id;

SELECT 'IDX_VIRTUALGL' AS k;
SELECT i.index_id, i.name, i.type_desc, i.is_unique, i.is_primary_key, i.fill_factor, i.is_disabled,
  STUFF((SELECT ','+c.name+CASE WHEN ic.is_descending_key=1 THEN ' DESC' ELSE '' END
         FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=0
         ORDER BY ic.key_ordinal FOR XML PATH('')),1,1,'') AS keycols,
  STUFF((SELECT ','+c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=1
         FOR XML PATH('')),1,1,'') AS included
FROM sys.indexes i WHERE i.object_id=OBJECT_ID('VirtualGl');

SELECT 'IDX_STOCKREPORT' AS k;
SELECT i.index_id, i.name, i.type_desc, i.is_unique, i.fill_factor,
  STUFF((SELECT ','+c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=0
         ORDER BY ic.key_ordinal FOR XML PATH('')),1,1,'') AS keycols,
  STUFF((SELECT ','+c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=1
         FOR XML PATH('')),1,1,'') AS included
FROM sys.indexes i WHERE i.object_id=OBJECT_ID('StockReport');

SELECT 'COLS_STOCKREPORT' AS k;
SELECT c.column_id, c.name, ty.name AS typ, c.max_length, c.is_nullable
FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
WHERE c.object_id=OBJECT_ID('StockReport') ORDER BY c.column_id;
