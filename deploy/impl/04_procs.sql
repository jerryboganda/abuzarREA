/* ============================================================================
   04_procs.sql
   Remove the obsolete xp_cmdshell DLL-existence check and make
   SP_StockReport sargable. Then disable xp_cmdshell.
   NOTE: CREATE/ALTER PROCEDURE must be the first statement in its batch.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 04.1 SP_WayToMoon: remove xp_cmdshell dependency ===';
GO
ALTER PROCEDURE dbo.SP_WayToMoon
    @fl  VARCHAR(100),
    @fl2 VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    /* The original procedure spawned two cmd.exe processes per login to test
       for optional DLLs. The check is obsolete and the DLLs are not used by
       the normal purchase/sale screens. Returning 0 keeps the documented
       contract (0 = OK, 1 = missing) without shell access or process spawns. */
    RETURN 0;
END
GO

PRINT '=== 04.2 SP_StockReport: replace NOT IN with sargable NOT EXISTS ===';
GO
ALTER PROCEDURE dbo.SP_StockReport
    @DailyReportDays   INTEGER,
    @ArchiveReportDays INTEGER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @today DATETIME;
    SET @today = CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 120));

    INSERT INTO dbo.StockReport
        (Date, GCode, ICode, Stock, PurchasePrice, SalePrice,
         AvgPrice, RecentPurchasePrice, PackUnits)
    SELECT
        Date                = GETDATE(),
        Gcode               = Gd.GCode,
        ICode               = Gd.ICode,
        Stock               = SUM(Gd.CurrQty),
        PurchasePrice       = I.PurPrice,
        SalePrice           = I.SalePrice,
        AvgPrice            = I.AvgPrice,
        RecentPurchasePrice = I.RecentPurPrice,
        PackUnits           = I.PackUnits
    FROM dbo.GodownDetail Gd
    INNER JOIN dbo.Item I ON I.ICode = Gd.ICode
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.StockReport SR
        WHERE SR.[Date] >= @today
          AND SR.[Date] <  DATEADD(DAY, 1, @today)
    )
    GROUP BY
        Gd.GCode,
        Gd.ICode,
        I.PurPrice,
        I.SalePrice,
        I.AvgPrice,
        I.RecentPurPrice,
        I.PackUnits;
END
GO

PRINT '=== 04.3 disable xp_cmdshell ===';
IF EXISTS (SELECT 1 FROM sys.configurations WHERE name = 'xp_cmdshell' AND value_in_use = 1)
BEGIN
    EXEC sp_configure 'xp_cmdshell', 0;
    RECONFIGURE;
    PRINT 'xp_cmdshell disabled.';
END
ELSE
    PRINT 'xp_cmdshell already disabled.';
GO

PRINT '=== 04.4 verify ===';
SELECT name, value_in_use FROM sys.configurations WHERE name = 'xp_cmdshell';
EXEC dbo.SP_WayToMoon 'systemab.dll', 'tapi161.dll';
GO

PRINT '=== 04_procs.sql completed ===';
GO
