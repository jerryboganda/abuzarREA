SET NOCOUNT ON;
SELECT 'SAMPLED_DENSITY' AS k;
SELECT OBJECT_NAME(ps.object_id) AS tbl, ps.index_id, i.name, ps.index_type_desc,
       ps.record_count, ps.avg_record_size_in_bytes AS avg_rec_b, ps.page_count,
       CAST(ps.avg_page_space_used_in_percent AS DECIMAL(5,1)) AS page_fill_pct,
       CAST(ps.avg_fragmentation_in_percent AS DECIMAL(5,1)) AS frag_pct,
       ps.fragment_count, ps.forwarded_record_count
FROM sys.dm_db_index_physical_stats(DB_ID('FazalDinPP19DataBaseV2'), NULL, NULL, NULL, 'SAMPLED') ps
JOIN FazalDinPP19DataBaseV2.sys.indexes i ON i.object_id=ps.object_id AND i.index_id=ps.index_id
WHERE ps.object_id IN (OBJECT_ID('FazalDinPP19DataBaseV2.dbo.SaleLedger'),OBJECT_ID('FazalDinPP19DataBaseV2.dbo.Saledetail'),
      OBJECT_ID('FazalDinPP19DataBaseV2.dbo.VirtualGl'),OBJECT_ID('FazalDinPP19DataBaseV2.dbo.Item'),
      OBJECT_ID('FazalDinPP19DataBaseV2.dbo.StockReport'),OBJECT_ID('FazalDinPP19DataBaseV2.dbo.Purdetail'),
      OBJECT_ID('FazalDinPP19DataBaseV2.dbo.ItemLog'),OBJECT_ID('FazalDinPP19DataBaseV2.dbo.PurOrderDetail'))
AND ps.index_id IN (0,1)
ORDER BY ps.page_count DESC;
