-- Rollback of 12_restore_hinted_indexes.sql (re-breaks the four hinted DataWindows; use only if needed).
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Saledetail') AND name = N'IDX_SaleDetail_Icode')
    DROP INDEX [IDX_SaleDetail_Icode] ON [dbo].[Saledetail];
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.SaleLedger') AND name = N'IDX_SaleLedger_CustCode')
    DROP INDEX [IDX_SaleLedger_CustCode] ON [dbo].[SaleLedger];
