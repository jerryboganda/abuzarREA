-- Rollback of 14_missing_lookup_indexes.sql
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SRLedger') AND name = N'IX_SRLedger_SaleInvCode') DROP INDEX [IX_SRLedger_SaleInvCode] ON [dbo].[SRLedger];
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SRdetail') AND name = N'IX_SRdetail_Icode') DROP INDEX [IX_SRdetail_Icode] ON [dbo].[SRdetail];
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.AdjDetail') AND name = N'IX_AdjDetail_ICode') DROP INDEX [IX_AdjDetail_ICode] ON [dbo].[AdjDetail];
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Item') AND name = N'IX_Item_ManfCode') DROP INDEX [IX_Item_ManfCode] ON [dbo].[Item];
