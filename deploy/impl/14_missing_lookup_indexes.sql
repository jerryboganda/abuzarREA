-- 14: lookup indexes recommended by SQL Server's own missing-index statistics (2026-11-23),
-- collected while the app's screens/reports and the DataWindow sweep ran:
--   SRLedger(SaleInvCode)  99% est. impact, 95,512 uses  (sale-return lookup by sale invoice)
--   SRdetail(Icode)        53%, 25,496 uses
--   AdjDetail(ICode)       15%, 50,924 uses
--   Item(ManfCode)         28-32%, manufacturer-wise reports
-- Pure performance; no data/application change.  Rollback: 14_missing_lookup_indexes_rollback.sql
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SRLedger') AND name = N'IX_SRLedger_SaleInvCode')
    CREATE INDEX [IX_SRLedger_SaleInvCode] ON [dbo].[SRLedger] ([SaleInvCode]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SRdetail') AND name = N'IX_SRdetail_Icode')
    CREATE INDEX [IX_SRdetail_Icode] ON [dbo].[SRdetail] ([Icode]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.AdjDetail') AND name = N'IX_AdjDetail_ICode')
    CREATE INDEX [IX_AdjDetail_ICode] ON [dbo].[AdjDetail] ([ICode]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Item') AND name = N'IX_Item_ManfCode')
    CREATE INDEX [IX_Item_ManfCode] ON [dbo].[Item] ([ManfCode]) INCLUDE ([CustomICode], [Name]);
PRINT 'indexes ensured';
