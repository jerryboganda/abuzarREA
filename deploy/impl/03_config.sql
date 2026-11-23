/* ============================================================================
   03_config.sql
   Instance-level performance settings + tempdb sizing.
   Safe to re-run.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== 03.1 optimize for ad hoc workloads ===';
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'optimize for ad hoc workloads', 1;
RECONFIGURE;
GO

PRINT '=== 03.2 cost threshold for parallelism ===';
EXEC sp_configure 'cost threshold for parallelism', 25;
RECONFIGURE;
GO

PRINT '=== 03.3 tempdb: add three fixed-growth data files ===';
IF NOT EXISTS (SELECT 1 FROM tempdb.sys.database_files WHERE name = N'tempdev2')
BEGIN
    ALTER DATABASE tempdb ADD FILE
        (NAME = N'tempdev2',
         FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\tempdev2.ndf',
         SIZE = 64MB, FILEGROWTH = 64MB);
    PRINT 'tempdev2 added.';
END
ELSE PRINT 'tempdev2 already exists — skipped.';
GO
IF NOT EXISTS (SELECT 1 FROM tempdb.sys.database_files WHERE name = N'tempdev3')
BEGIN
    ALTER DATABASE tempdb ADD FILE
        (NAME = N'tempdev3',
         FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\tempdev3.ndf',
         SIZE = 64MB, FILEGROWTH = 64MB);
    PRINT 'tempdev3 added.';
END
ELSE PRINT 'tempdev3 already exists — skipped.';
GO
IF NOT EXISTS (SELECT 1 FROM tempdb.sys.database_files WHERE name = N'tempdev4')
BEGIN
    ALTER DATABASE tempdb ADD FILE
        (NAME = N'tempdev4',
         FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\tempdev4.ndf',
         SIZE = 64MB, FILEGROWTH = 64MB);
    PRINT 'tempdev4 added.';
END
ELSE PRINT 'tempdev4 already exists — skipped.';
GO

PRINT '=== 03.4 verify settings ===';
SELECT name, value_in_use FROM sys.configurations
WHERE name IN ('optimize for ad hoc workloads', 'cost threshold for parallelism',
               'max degree of parallelism', 'max server memory (MB)', 'xp_cmdshell');
SELECT name, physical_name, size * 8 / 1024 AS mb, growth, is_percent_growth
FROM tempdb.sys.database_files ORDER BY file_id;
GO

PRINT '=== 03_config.sql completed ===';
GO
