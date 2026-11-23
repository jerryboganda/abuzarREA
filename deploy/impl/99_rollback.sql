/* ============================================================================
   99_rollback.sql
   Reverts the database object/config/preference changes made by 01-08.
   The safest rollback is still the verified full backup:
       RESTORE DATABASE [FazalDinPP19DataBaseV2]
       FROM DISK = N'C:\Projects\Abuzar\deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak'
       WITH REPLACE, RECOVERY;
   Stop abuzar.exe before restoring.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== 99.0 revert compatibility level ===';
ALTER DATABASE [FazalDinPP19DataBaseV2] SET COMPATIBILITY_LEVEL = 80;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 99.1 restore original SP_WayToMoon ===';
GO
ALTER PROCEDURE dbo.SP_WayToMoon @fl VARCHAR(100), @fl2 VARCHAR(100)
AS
DECLARE @cmdline VARCHAR(255)
DECLARE @rt_code INT
DECLARE @Ver VARCHAR(4000)
SET @Ver = @@Version

IF CHARINDEX('X64', @Ver, 1) > 0
	SET @cmdline = 'dir %systemroot%\syswow64\' + LTRIM(RTRIM(@fl))
ELSE
	SET @cmdline = 'dir %systemroot%\system32\' + LTRIM(RTRIM(@fl))

EXEC @rt_code = master..xp_cmdshell @cmdline, NO_OUTPUT
IF @rt_code >= 1
	RETURN 1
ELSE
BEGIN 
	IF CHARINDEX('X64', @Ver, 1) > 0
		SET @cmdline = 'dir %systemroot%\syswow64\' + LTRIM(RTRIM(@fl2))
	ELSE
		SET @cmdline = 'dir %systemroot%\system32\' + LTRIM(RTRIM(@fl2))
	EXEC @rt_code = master..xp_cmdshell @cmdline, NO_OUTPUT
	IF @rt_code >= 1
		RETURN 1
END
RETURN 0
GO

PRINT '=== 99.2 restore original SP_StockReport ===';
GO
ALTER PROCEDURE dbo.SP_StockReport @DailyReportDays INTEGER, @ArchiveReportDays INTEGER
AS

/* 
	First Delete Reports Older than @DailyReportDays passed as first argument 
	to this script. But Don't Delete Reports for 1st, 10th and 20th day of month.
*/
/**** Deletion Stopped C/O Rashid/Shakil/Azhar 05-JUN-2023  ****/
--DELETE StockReport WHERE DATE <= GETDATE() - @DailyReportDays AND DATEPART(dy, DATE) NOT IN (1, 10, 20)

/* 
	Now Delete Reports Older than @ArchiveReportDays passed as 2nd argument 
	to this script. This will Delete Reports for 1st, 10th and 20th day of month
	as well.
*/
/**** Deletion Stopped C/O Rashid/Shakil/Azhar 05-JUN-2023  ****/
--DELETE StockReport WHERE DATE <= GETDATE() - @ArchiveReportDays

/*
	Now check whether the today's report is submitted/saved or not. If yes than no 
	need to save it again else store it.
*/
INSERT INTO StockReport (Date, GCode, ICode, Stock, PurchasePrice, SalePrice, 
	AvgPrice, RecentPurchasePrice, PackUnits)
SELECT
	Date=GETDATE(),
	Gcode=Gd.GCode,
	ICode=Gd.ICode,
	Stock=SUM(Gd.CurrQty),
	PurchasePrice=I.PurPrice,
	SalePrice=I.SalePrice,
	AvPrice=I.AvgPrice,
	RecentPurchasePrice=I.RecentPurPrice,
	PackUnits=I.PackUnits
FROM
	GodownDetail Gd,
	Item I
WHERE
	Gd.ICode = I.ICode AND
	CONVERT(DATETIME, RTRIM(LTRIM(STR(DATEPART(month, GETDATE())))) + '-' +
	RTRIM(LTRIM(STR(DATEPART(day, GETDATE()))))  + '-' +
	RTRIM(LTRIM(STR(DATEPART(year, GETDATE()))))) NOT IN
	(SELECT DISTINCT 
		CONVERT(DATETIME, RTRIM(LTRIM(STR(DATEPART(month, DATE)))) + '-' +
		RTRIM(LTRIM(STR(DATEPART(day, DATE))))  + '-' +
		RTRIM(LTRIM(STR(DATEPART(year, DATE)))))
	FROM STOCKREPORT)

GROUP BY
	Gd.GCode,
	Gd.ICode,
	I.PurPrice,
	I.SalePrice,
	I.AvgPrice,
	I.RecentPurPrice,
	I.PackUnits
GO

PRINT '=== 99.3 drop new indexes and restore originals ===';
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.StockReport') AND name='CIX_StockReport')
    DROP INDEX CIX_StockReport ON dbo.StockReport;
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.VirtualGl') AND name='IX_VirtualGl_AccCode_Date')
    DROP INDEX IX_VirtualGl_AccCode_Date ON dbo.VirtualGl;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.VirtualGl') AND name='IDX_VirtualGL_AccCode')
    CREATE NONCLUSTERED INDEX IDX_VirtualGL_AccCode ON dbo.VirtualGl(AccCode);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.VirtualGl') AND name='IDX_VirtualGL_PatientCode')
    CREATE NONCLUSTERED INDEX IDX_VirtualGL_PatientCode ON dbo.VirtualGl(PatientCode);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.VirtualGl') AND name='IDX_VirtualGL_StudentCode')
    CREATE NONCLUSTERED INDEX IDX_VirtualGL_StudentCode ON dbo.VirtualGl(StudentCode);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.VirtualGl') AND name='IDX_VirtualGL_GuestCode')
    CREATE NONCLUSTERED INDEX IDX_VirtualGL_GuestCode ON dbo.VirtualGl(GuestCode);
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.SaleLedger') AND name='IX_SaleLedger_CustCode_Date')
    DROP INDEX IX_SaleLedger_CustCode_Date ON dbo.SaleLedger;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.SaleLedger') AND name='IDX_SaleLedger_CustCode')
    CREATE NONCLUSTERED INDEX IDX_SaleLedger_CustCode ON dbo.SaleLedger(CustCode);
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.SaleDetail') AND name='IX_SaleDetail_ICode_SaleInvCode')
    DROP INDEX IX_SaleDetail_ICode_SaleInvCode ON dbo.SaleDetail;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.SaleDetail') AND name='IDX_SaleDetail_Icode')
    CREATE NONCLUSTERED INDEX IDX_SaleDetail_Icode ON dbo.SaleDetail(ICode);
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.GodownDetail') AND name='IX_GodownDetail_ICode')
    DROP INDEX IX_GodownDetail_ICode ON dbo.GodownDetail;
GO

PRINT '=== 99.4 restore original fn_getSaleInvTotal ===';
GO
ALTER FUNCTION dbo.fn_getSaleInvTotal ( @saleinvcode Int )
RETURNS NUMERIC(15, 2)
AS
BEGIN
DECLARE @netamount Numeric(15, 2), @RoundUpYo TINYINT
SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SELECT  @netamount = Case when Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc   +   misccharges), 2) IS NULL Then 0  Else Round(Sum ( Round((  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100),2) ) - flatdisc   +   misccharges, @RoundUpYo) End 
				+
				Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
				 +  
				(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), @RoundUpYo)
FROM Saleledger SL, Saledetail SD
WHERE  SL.SaleInvCode = @saleinvcode AND
		SL.saleinvcode = SD.saleinvcode 
GROUP BY	SL.saleinvcode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.invgstperc1
IF @@RowCOUNT = 0
	SELECT  @netamount = Case when Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc   +   misccharges), 2) IS NULL Then 0  Else Round(Sum ( Round((  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100),2) ) - flatdisc   +   misccharges, @RoundUpYo) End 
					+
					Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
					 +  
					(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *   (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), @RoundUpYo)
	FROM Saleledger SL, SaleInvdetail SD
	WHERE  SL.SaleInvCode = @saleinvcode AND
			SL.saleinvcode = SD.saleinvcode 
	GROUP BY	SL.saleinvcode,
				SL.flatdisc,
				SL.misccharges,
				SL.discperc,
				SL.invgstperc1

Return @netamount
END
GO

IF OBJECT_ID(N'dbo.SaleInvTotalAdjustment', N'U') IS NOT NULL
    DROP TABLE dbo.SaleInvTotalAdjustment;
GO

PRINT '=== 99.5 restore preference/config ===';
UPDATE dbo.SoftwarePreferences SET PrefValue='Y' WHERE Name='CheckManualBackupHealthAtStartUp';
GO
EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;
EXEC sp_configure 'optimize for ad hoc workloads', 0; RECONFIGURE;
EXEC sp_configure 'cost threshold for parallelism', 5; RECONFIGURE;
GO

PRINT '=== 99.6 file growth (size left at 4 GB; shrinking is not recommended) ===';
ALTER DATABASE [FazalDinPP19DataBaseV2] MODIFY FILE (NAME=N'MehmoodDataBase_Data', FILEGROWTH=10%);
ALTER DATABASE [FazalDinPP19DataBaseV2] MODIFY FILE (NAME=N'MehmoodDataBase_Log', FILEGROWTH=10%);
GO

PRINT '=== 99.7 FK trust notes ===';
/*
 08_fk_validate.sql trusted 86 previously untrusted FKs. That is a deliberate
 integrity improvement and is not automatically reverted. To restore the
 original untrusted state, run the inverse ALTER TABLE ... WITH NOCHECK CHECK
 CONSTRAINT statements for those 86 FKs (see logs/live-fk-validate.log).

 The Purledger/TaxCategory FK is currently untrusted/enabled because of a real
 orphan (TaxCategoryCode='87'). Re-trusting it requires cleaning that row first;
 do not run WITH CHECK on it while the orphan exists.
*/
GO

PRINT '=== 99_rollback.sql completed ===';
GO
