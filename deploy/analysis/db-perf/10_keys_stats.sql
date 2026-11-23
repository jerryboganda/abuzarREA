SET NOCOUNT ON;
SELECT 'PK_KEYS' AS k;
SELECT t.name AS tbl, i.name AS idx, i.type_desc, i.is_unique,
  STUFF((SELECT ','+c.name+CASE WHEN ic.is_descending_key=1 THEN ' DESC' ELSE '' END
         FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=0
         ORDER BY ic.key_ordinal FOR XML PATH('')),1,1,'') AS keycols,
  STUFF((SELECT ','+c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
         WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=1
         FOR XML PATH('')),1,1,'') AS included
FROM sys.indexes i JOIN sys.tables t ON t.object_id=i.object_id
WHERE t.name IN ('SaleLedger','Saledetail','Item','VirtualGl','StockReport','ItemLog','Purdetail','PurOrderDetail','SRLedger','SRdetail','PricePolicy','DeletedSaleItem','PreviousSaleHistory','GodownDetail')
  AND i.type>0
ORDER BY t.name, i.index_id;

SELECT 'IDENTITY' AS k;
SELECT t.name AS tbl, c.name AS col, c.is_identity
FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id
WHERE c.is_identity=1 AND t.name IN ('SaleLedger','Saledetail','VirtualGl','StockReport','ItemLog','Purdetail','Item')
ORDER BY t.name;

SELECT 'STATS_SUMMARY' AS k;
SELECT COUNT(*) AS stat_objects, SUM(CASE WHEN no_recompute=1 THEN 1 ELSE 0 END) AS norecompute,
       SUM(CASE WHEN auto_created=1 THEN 1 ELSE 0 END) AS auto_created,
       SUM(CASE WHEN user_created=1 THEN 1 ELSE 0 END) AS user_created,
       MAX(STATS_DATE(object_id, stats_id)) AS newest, MIN(STATS_DATE(object_id, stats_id)) AS oldest
FROM sys.stats WHERE object_id IN (SELECT object_id FROM sys.tables WHERE is_ms_shipped=0);

SELECT 'STATS_STALE_TOP' AS k;
SELECT TOP 30 t.name AS tbl, s.name AS stat, s.no_recompute, s.auto_created,
       si.rowcnt AS rows_, si.rowmodctr,
       STATS_DATE(s.object_id,s.stats_id) AS updated,
       DATEDIFF(day, STATS_DATE(s.object_id,s.stats_id), GETDATE()) AS days_old
FROM sys.stats s
JOIN sys.tables t ON t.object_id=s.object_id AND t.is_ms_shipped=0
JOIN sys.sysindexes si ON si.id=s.object_id AND si.indid=s.stats_id
WHERE si.rowcnt > 1000
ORDER BY si.rowcnt DESC;

SELECT 'STATS_NO_RECOMPUTE' AS k;
SELECT t.name AS tbl, s.name, si.rowcnt
FROM sys.stats s JOIN sys.tables t ON t.object_id=s.object_id
JOIN sys.sysindexes si ON si.id=s.object_id AND si.indid=s.stats_id
WHERE s.no_recompute=1 AND si.rowcnt>0 ORDER BY si.rowcnt DESC;

SELECT 'STATS_AGE_BUCKETS' AS k;
SELECT CASE WHEN d IS NULL THEN 'never' WHEN d<1 THEN '<1d' WHEN d<7 THEN '1-7d'
            WHEN d<30 THEN '7-30d' WHEN d<365 THEN '30-365d' ELSE '>1y' END AS age_bucket,
       COUNT(*) AS cnt
FROM (SELECT DATEDIFF(day, STATS_DATE(s.object_id,s.stats_id), GETDATE()) AS d
      FROM sys.stats s JOIN sys.tables t ON t.object_id=s.object_id AND t.is_ms_shipped=0) x
GROUP BY CASE WHEN d IS NULL THEN 'never' WHEN d<1 THEN '<1d' WHEN d<7 THEN '1-7d'
            WHEN d<30 THEN '7-30d' WHEN d<365 THEN '30-365d' ELSE '>1y' END;
