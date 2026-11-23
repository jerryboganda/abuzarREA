/* ============================================================================
   10_sql2022_restore.sql
   Restore the freshly verified pre-migration backup into the NEW
   SQL Server 2022 Express instance (.\SQLEXPRESS2022).

   Run with:
     sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -b -i 10_sql2022_restore.sql

   The old 2008 R2 instance and its database are not touched.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== target instance ===';
SELECT @@SERVERNAME AS server_name,
       SERVERPROPERTY('ProductVersion') AS version,
       SERVERPROPERTY('Edition') AS edition,
       SERVERPROPERTY('InstanceDefaultDataPath') AS data_path,
       SERVERPROPERTY('InstanceDefaultLogPath') AS log_path;
GO

PRINT '=== drop a previous test restore if present ===';
IF DB_ID(N'FazalDinPP19DataBaseV2') IS NOT NULL
BEGIN
    ALTER DATABASE [FazalDinPP19DataBaseV2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [FazalDinPP19DataBaseV2];
    PRINT 'Previous copy dropped.';
END
ELSE
    PRINT 'No previous copy.';
GO

PRINT '=== restore from the verified pre-migration backup ===';
DECLARE @backup NVARCHAR(4000) = N'C:\Projects\Abuzar\deploy\impl\backup\FazalDinPP19DataBaseV2_pre_sql2022.bak';
DECLARE @data   NVARCHAR(4000) = CONVERT(NVARCHAR(4000), SERVERPROPERTY('InstanceDefaultDataPath'));
DECLARE @log    NVARCHAR(4000) = CONVERT(NVARCHAR(4000), SERVERPROPERTY('InstanceDefaultLogPath'));
DECLARE @sql    NVARCHAR(MAX);

IF @data IS NULL OR @data = N''
    SET @data = N'C:\waseela_sql2022\data\';
IF @log IS NULL OR @log = N''
    SET @log = N'C:\waseela_sql2022\data\';

SET @sql = N'
RESTORE DATABASE [FazalDinPP19DataBaseV2]
FROM DISK = N''' + @backup + N'''
WITH MOVE N''MehmoodDataBase_Data'' TO N''' + @data + N'FazalDinPP19DataBaseV2.mdf'',
     MOVE N''MehmoodDataBase_Log''  TO N''' + @log  + N'FazalDinPP19DataBaseV2_log.ldf'',
     REPLACE, RECOVERY, STATS = 10;';

PRINT @sql;
EXEC (@sql);
GO

PRINT '=== post-restore state ===';
SELECT name, compatibility_level, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = N'FazalDinPP19DataBaseV2';
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== key row counts (must match the live 2008 R2 values) ===';
SELECT 'SaleLedger' AS table_name, COUNT_BIG(*) AS rows FROM dbo.SaleLedger
UNION ALL SELECT 'SaleDetail', COUNT_BIG(*) FROM dbo.SaleDetail
UNION ALL SELECT 'VirtualGl', COUNT_BIG(*) FROM dbo.VirtualGl
UNION ALL SELECT 'StockReport', COUNT_BIG(*) FROM dbo.StockReport
UNION ALL SELECT 'StockLedger', COUNT_BIG(*) FROM dbo.StockLedger
UNION ALL SELECT 'Item', COUNT_BIG(*) FROM dbo.Item;
GO

PRINT '=== 10_sql2022_restore.sql completed ===';
GO
