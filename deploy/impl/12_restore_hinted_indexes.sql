-- 12: restore two indexes that the application references by name in index hints.
-- 01_indexes.sql (2026-11-02) dropped IDX_SaleDetail_Icode and IDX_SaleLedger_CustCode as
-- "redundant", but these DataWindows force them with WITH (INDEX(...)) hints:
--   d_itemsalehistory, d_itemsalehistory_print, d_previnv, d_previnv2
-- so those queries failed with error 308 ("Index ... does not exist").
-- Definitions are the originals from db/schema/03_indexes.sql.
-- Rollback: 12_restore_hinted_indexes_rollback.sql
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Saledetail') AND name = N'IDX_SaleDetail_Icode')
BEGIN
    CREATE INDEX [IDX_SaleDetail_Icode] ON [dbo].[Saledetail] ([ICode]);
    PRINT 'Created IDX_SaleDetail_Icode';
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SaleLedger') AND name = N'IDX_SaleLedger_CustCode')
BEGIN
    CREATE INDEX [IDX_SaleLedger_CustCode] ON [dbo].[SaleLedger] ([CustCode]);
    PRINT 'Created IDX_SaleLedger_CustCode';
END
