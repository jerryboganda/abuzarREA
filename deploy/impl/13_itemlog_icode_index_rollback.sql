-- Rollback of 13_itemlog_icode_index.sql
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ItemLog') AND name = N'IX_ItemLog_ICode_RowID')
    DROP INDEX [IX_ItemLog_ICode_RowID] ON [dbo].[ItemLog];
