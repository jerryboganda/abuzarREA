/* ============================================================================
   01_indexes.sql
   Abuzar / Waseela V2 — P0 database indexes
   Target: SQL Server 2008 R2 Express, database FazalDinPP19DataBaseV2
   Safe to re-run: every object is guarded by an existence check.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== 01.1 pre-size data and log files ===';
ALTER DATABASE [FazalDinPP19DataBaseV2]
  MODIFY FILE (NAME = N'MehmoodDataBase_Data', SIZE = 4096MB, FILEGROWTH = 256MB);
ALTER DATABASE [FazalDinPP19DataBaseV2]
  MODIFY FILE (NAME = N'MehmoodDataBase_Log', FILEGROWTH = 128MB);
GO

USE [FazalDinPP19DataBaseV2];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== 01.2 StockReport clustered index ===';
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.StockReport') AND name = N'CIX_StockReport')
BEGIN
    PRINT 'Creating CIX_StockReport on StockReport(Date,GCode,ICode)...';
    CREATE CLUSTERED INDEX CIX_StockReport
        ON dbo.StockReport ([Date], GCode, ICode)
        WITH (FILLFACTOR = 95, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
    PRINT 'CIX_StockReport created.';
END
ELSE
    PRINT 'CIX_StockReport already exists — skipped.';
GO

PRINT '=== 01.3 VirtualGl covering index ===';
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.VirtualGl') AND name = N'IX_VirtualGl_AccCode_Date')
BEGIN
    PRINT 'Creating IX_VirtualGl_AccCode_Date...';
    CREATE NONCLUSTERED INDEX IX_VirtualGl_AccCode_Date
        ON dbo.VirtualGl (AccCode, [Date])
        INCLUDE (Debit, Credit, DocumentCode, DocumentType, VRow)
        WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
    PRINT 'IX_VirtualGl_AccCode_Date created.';
END
ELSE
    PRINT 'IX_VirtualGl_AccCode_Date already exists — skipped.';
GO

PRINT '=== 01.4 drop redundant VirtualGl indexes ===';
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.VirtualGl') AND name = N'IDX_VirtualGL_AccCode')
BEGIN
    DROP INDEX IDX_VirtualGL_AccCode ON dbo.VirtualGl;
    PRINT 'Dropped IDX_VirtualGL_AccCode (replaced by covering index).';
END
GO
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.VirtualGl') AND name = N'IDX_VirtualGL_PatientCode')
BEGIN
    DROP INDEX IDX_VirtualGL_PatientCode ON dbo.VirtualGl;
    PRINT 'Dropped IDX_VirtualGL_PatientCode (100% NULL column).';
END
GO
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.VirtualGl') AND name = N'IDX_VirtualGL_StudentCode')
BEGIN
    DROP INDEX IDX_VirtualGL_StudentCode ON dbo.VirtualGl;
    PRINT 'Dropped IDX_VirtualGL_StudentCode (100% NULL column).';
END
GO
IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.VirtualGl') AND name = N'IDX_VirtualGL_GuestCode')
BEGIN
    DROP INDEX IDX_VirtualGL_GuestCode ON dbo.VirtualGl;
    PRINT 'Dropped IDX_VirtualGL_GuestCode (100% NULL column).';
END
GO

PRINT '=== 01.5 SaleLedger customer/date index ===';
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.SaleLedger') AND name = N'IX_SaleLedger_CustCode_Date')
BEGIN
    PRINT 'Creating IX_SaleLedger_CustCode_Date...';
    CREATE NONCLUSTERED INDEX IX_SaleLedger_CustCode_Date
        ON dbo.SaleLedger (CustCode, [date])
        INCLUDE (InvTotal)
        WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
    PRINT 'IX_SaleLedger_CustCode_Date created.';
END
ELSE
    PRINT 'IX_SaleLedger_CustCode_Date already exists — skipped.';
GO

IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.SaleLedger') AND name = N'IDX_SaleLedger_CustCode')
BEGIN
    DROP INDEX IDX_SaleLedger_CustCode ON dbo.SaleLedger;
    PRINT 'Dropped IDX_SaleLedger_CustCode (replaced by composite index).';
END
GO

PRINT '=== 01.6 SaleDetail item/invoice index ===';
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.SaleDetail') AND name = N'IX_SaleDetail_ICode_SaleInvCode')
BEGIN
    PRINT 'Creating IX_SaleDetail_ICode_SaleInvCode...';
    CREATE NONCLUSTERED INDEX IX_SaleDetail_ICode_SaleInvCode
        ON dbo.SaleDetail (ICode, SaleInvcode)
        INCLUDE (LooseQty, bonusqty, SalePrice, itemflatdisc, DiscPerc)
        WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
    PRINT 'IX_SaleDetail_ICode_SaleInvCode created.';
END
ELSE
    PRINT 'IX_SaleDetail_ICode_SaleInvCode already exists — skipped.';
GO

IF EXISTS (SELECT 1 FROM sys.indexes
           WHERE object_id = OBJECT_ID(N'dbo.SaleDetail') AND name = N'IDX_SaleDetail_Icode')
BEGIN
    DROP INDEX IDX_SaleDetail_Icode ON dbo.SaleDetail;
    PRINT 'Dropped IDX_SaleDetail_Icode (replaced by composite index).';
END
GO

PRINT '=== 01.7 GodownDetail item index ===';
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.GodownDetail') AND name = N'IX_GodownDetail_ICode')
BEGIN
    PRINT 'Creating IX_GodownDetail_ICode...';
    CREATE NONCLUSTERED INDEX IX_GodownDetail_ICode
        ON dbo.GodownDetail (ICode)
        INCLUDE (GCode, CurrQty)
        WITH (FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, ONLINE = OFF);
    PRINT 'IX_GodownDetail_ICode created.';
END
ELSE
    PRINT 'IX_GodownDetail_ICode already exists — skipped.';
GO

PRINT '=== 01_indexes.sql completed ===';
GO
