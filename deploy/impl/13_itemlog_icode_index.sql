-- 13: index for Item Reports > History > Sale Price Difference (d_itemsalepricedifference).
-- Its correlated subqueries look up later ItemLog rows of the same item
-- (il.icode = itemlog.icode AND il.itemrowid > ... AND il.logdate > ...), but ItemLog had no
-- index on ICode, so each row rescanned the table (report did not finish within minutes).
-- Pure performance change; no data or application change.
-- Rollback: 13_itemlog_icode_index_rollback.sql
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ItemLog') AND name = N'IX_ItemLog_ICode_RowID')
BEGIN
    CREATE INDEX [IX_ItemLog_ICode_RowID] ON [dbo].[ItemLog] ([ICode], [ItemRowID]) INCLUDE ([LogDate], [PackUnits]);
    PRINT 'Created IX_ItemLog_ICode_RowID';
END
