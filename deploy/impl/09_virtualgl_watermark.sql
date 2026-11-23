/* ============================================================================
   09_virtualgl_watermark.sql
   Add a watermark gate in front of the incremental SP_VirtualGL and
   SP_STOCKLEDGER rebuilds.

   How it works:
   - fn_VirtualGLSourceVersion() hashes the max document code + row count of
     the core posted-document tables.
   - If the version is unchanged and the last full run is < 10 minutes old,
     the wrapper returns immediately.
   - Otherwise it runs the original proc (renamed _Full) and records the
     version/time.
   - The 10-minute TTL catches in-place edits/deletes that do not change the
     max code/count.

   Run with -d <database>. Idempotent for re-runs.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=== 09.1 source-version function ===';
IF OBJECT_ID('dbo.fn_VirtualGLSourceVersion') IS NULL
BEGIN
    EXEC(N'
CREATE FUNCTION dbo.fn_VirtualGLSourceVersion()
RETURNS BIGINT
AS
BEGIN
    DECLARE @v BIGINT;

    SELECT @v = CHECKSUM(
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.SaleLedger), 0),
        ISNULL((SELECT MAX(SaleInvCode) FROM dbo.SaleLedger), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.Purledger), 0),
        ISNULL((SELECT MAX(PurInvCode) FROM dbo.Purledger), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.SRLedger), 0),
        ISNULL((SELECT MAX(SRInvCode) FROM dbo.SRLedger), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.ReceiptHeader), 0),
        ISNULL((SELECT MAX(ReceiptInvCode) FROM dbo.ReceiptHeader), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.IssueHeader), 0),
        ISNULL((SELECT MAX(IssueInvCode) FROM dbo.IssueHeader), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.AdjHeader), 0),
        ISNULL((SELECT MAX(AdjCode) FROM dbo.AdjHeader), 0),
        ISNULL((SELECT COUNT_BIG(*) FROM dbo.DueSatisfyHeader), 0),
        ISNULL((SELECT MAX(DueSatisfyCode) FROM dbo.DueSatisfyHeader), 0)
    );

    RETURN ISNULL(@v, 0);
END
');
    PRINT 'fn_VirtualGLSourceVersion created.';
END
ELSE
    PRINT 'fn_VirtualGLSourceVersion already exists - skipped.';
GO

PRINT '=== 09.2 state tables ===';
IF OBJECT_ID('dbo.VirtualGLRefresh', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.VirtualGLRefresh
    (
        AccountType   CHAR(1)  NOT NULL CONSTRAINT PK_VirtualGLRefresh PRIMARY KEY,
        SourceVersion BIGINT   NOT NULL,
        LastRefresh   DATETIME NOT NULL
    );
    PRINT 'VirtualGLRefresh created.';
END
ELSE
    PRINT 'VirtualGLRefresh already exists - skipped.';

IF OBJECT_ID('dbo.StockLedgerRefresh', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.StockLedgerRefresh
    (
        Id            INT      NOT NULL CONSTRAINT PK_StockLedgerRefresh PRIMARY KEY
                               CONSTRAINT CK_StockLedgerRefresh_Id CHECK (Id = 1),
        SourceVersion BIGINT   NOT NULL,
        LastRefresh   DATETIME NOT NULL
    );
    PRINT 'StockLedgerRefresh created.';
END
ELSE
    PRINT 'StockLedgerRefresh already exists - skipped.';
GO

PRINT '=== 09.3 rename originals (first run only) ===';
IF OBJECT_ID('dbo.SP_VirtualGL_Full', 'P') IS NULL
   AND OBJECT_ID('dbo.SP_VirtualGL', 'P') IS NOT NULL
BEGIN
    EXEC sp_rename 'dbo.SP_VirtualGL', 'SP_VirtualGL_Full';
    PRINT 'SP_VirtualGL renamed to SP_VirtualGL_Full.';
END
ELSE
    PRINT 'SP_VirtualGL_Full already exists - rename skipped.';

IF OBJECT_ID('dbo.SP_STOCKLEDGER_Full', 'P') IS NULL
   AND OBJECT_ID('dbo.SP_STOCKLEDGER', 'P') IS NOT NULL
BEGIN
    EXEC sp_rename 'dbo.SP_STOCKLEDGER', 'SP_STOCKLEDGER_Full';
    PRINT 'SP_STOCKLEDGER renamed to SP_STOCKLEDGER_Full.';
END
ELSE
    PRINT 'SP_STOCKLEDGER_Full already exists - rename skipped.';
GO

PRINT '=== 09.4 SP_VirtualGL wrapper ===';
DECLARE @body NVARCHAR(MAX);
SET @body = N'
@ac_type CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v BIGINT, @last BIGINT, @lastRefresh DATETIME;
    DECLARE @autoPurge CHAR(1), @key CHAR(1);

    SET @key = CASE WHEN UPPER(ISNULL(@ac_type, ''A'')) = ''S'' THEN ''S'' ELSE ''A'' END;
    SET @autoPurge = ISNULL((SELECT dbo.Fn_GetPreference(''AutoPurgeVirtualGL'')), ''N'');

    IF @autoPurge = ''Y''
    BEGIN
        EXEC dbo.SP_VirtualGL_Full @ac_type;
        RETURN 0;
    END

    SET @v = dbo.fn_VirtualGLSourceVersion();

    SELECT @last = SourceVersion, @lastRefresh = LastRefresh
    FROM dbo.VirtualGLRefresh
    WHERE AccountType = @key;

    IF @last IS NOT NULL
       AND @last = @v
       AND DATEDIFF(MINUTE, @lastRefresh, GETDATE()) < 10
        RETURN 0;

    EXEC dbo.SP_VirtualGL_Full @ac_type;
    IF @@ERROR <> 0 RETURN @@ERROR;

    IF EXISTS (SELECT 1 FROM dbo.VirtualGLRefresh WHERE AccountType = @key)
        UPDATE dbo.VirtualGLRefresh
        SET SourceVersion = @v, LastRefresh = GETDATE()
        WHERE AccountType = @key;
    ELSE
        INSERT INTO dbo.VirtualGLRefresh (AccountType, SourceVersion, LastRefresh)
        VALUES (@key, @v, GETDATE());

    RETURN 0;
END
';
IF OBJECT_ID('dbo.SP_VirtualGL', 'P') IS NULL
    EXEC(N'CREATE PROCEDURE dbo.SP_VirtualGL ' + @body);
ELSE
    EXEC(N'ALTER PROCEDURE dbo.SP_VirtualGL ' + @body);
PRINT 'SP_VirtualGL wrapper ready.';
GO

PRINT '=== 09.5 SP_STOCKLEDGER wrapper ===';
DECLARE @body2 NVARCHAR(MAX);
SET @body2 = N'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v BIGINT, @last BIGINT, @lastRefresh DATETIME;

    SET @v = dbo.fn_VirtualGLSourceVersion();

    SELECT @last = SourceVersion, @lastRefresh = LastRefresh
    FROM dbo.StockLedgerRefresh
    WHERE Id = 1;

    IF @last IS NOT NULL
       AND @last = @v
       AND DATEDIFF(MINUTE, @lastRefresh, GETDATE()) < 10
        RETURN 0;

    EXEC dbo.SP_STOCKLEDGER_Full;
    IF @@ERROR <> 0 RETURN @@ERROR;

    IF EXISTS (SELECT 1 FROM dbo.StockLedgerRefresh WHERE Id = 1)
        UPDATE dbo.StockLedgerRefresh
        SET SourceVersion = @v, LastRefresh = GETDATE()
        WHERE Id = 1;
    ELSE
        INSERT INTO dbo.StockLedgerRefresh (Id, SourceVersion, LastRefresh)
        VALUES (1, @v, GETDATE());

    RETURN 0;
END
';
IF OBJECT_ID('dbo.SP_STOCKLEDGER', 'P') IS NULL
    EXEC(N'CREATE PROCEDURE dbo.SP_STOCKLEDGER ' + @body2);
ELSE
    EXEC(N'ALTER PROCEDURE dbo.SP_STOCKLEDGER ' + @body2);
PRINT 'SP_STOCKLEDGER wrapper ready.';
GO

PRINT '=== 09.6 state ===';
SELECT 'SP_VirtualGL' AS object_name, OBJECT_ID('dbo.SP_VirtualGL') AS object_id
UNION ALL SELECT 'SP_VirtualGL_Full', OBJECT_ID('dbo.SP_VirtualGL_Full')
UNION ALL SELECT 'SP_STOCKLEDGER', OBJECT_ID('dbo.SP_STOCKLEDGER')
UNION ALL SELECT 'SP_STOCKLEDGER_Full', OBJECT_ID('dbo.SP_STOCKLEDGER_Full')
UNION ALL SELECT 'fn_VirtualGLSourceVersion', OBJECT_ID('dbo.fn_VirtualGLSourceVersion')
UNION ALL SELECT 'VirtualGLRefresh', OBJECT_ID('dbo.VirtualGLRefresh')
UNION ALL SELECT 'StockLedgerRefresh', OBJECT_ID('dbo.StockLedgerRefresh');
SELECT dbo.fn_VirtualGLSourceVersion() AS source_version;
GO

PRINT '=== 09_virtualgl_watermark.sql completed ===';
GO
