-- Repair daily and monthly alternate-invoice resets across year boundaries.
-- Applies only to the exact known conditions and changes both procedures atomically.
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET LOCK_TIMEOUT 5000;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @daily nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter2'));
    DECLARE @monthly nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter'));
    DECLARE @oldDaily nvarchar(200) = N'IF ( @currentday > @lastday ) OR ( @currentday = 1 AND @lastday >364 )';
    DECLARE @oldMonthly nvarchar(200) = N'IF ( @currentmonth > @lastmonth ) OR ( @currentmonth = 1 AND @lastmonth = 12 )';
    DECLARE @dailyPos int, @monthlyPos int;

    IF @daily IS NULL OR @monthly IS NULL
        THROW 51050, 'Alternate-invoice reset procedures are missing or encrypted.', 1;
    IF CHARINDEX(@oldDaily, @daily) = 0 OR CHARINDEX(@oldDaily, @daily, CHARINDEX(@oldDaily, @daily) + 1) <> 0
        THROW 51051, 'Daily reset procedure differs from the expected baseline.', 1;
    IF CHARINDEX(@oldMonthly, @monthly) = 0 OR CHARINDEX(@oldMonthly, @monthly, CHARINDEX(@oldMonthly, @monthly) + 1) <> 0
        THROW 51052, 'Monthly reset procedure differs from the expected baseline.', 1;

    SET @daily = REPLACE(@daily, @oldDaily, N'IF CONVERT(date, @currentdate) > CONVERT(date, @lastdate)');
    SET @monthly = REPLACE(@monthly, @oldMonthly, N'IF DATEDIFF(month, @lastdate, @currentdate) > 0');
    SET @dailyPos = PATINDEX('%[A-Za-z]%', @daily);
    SET @monthlyPos = PATINDEX('%[A-Za-z]%', @monthly);
    IF UPPER(SUBSTRING(@daily, @dailyPos, 6)) <> 'CREATE' OR UPPER(SUBSTRING(@monthly, @monthlyPos, 6)) <> 'CREATE'
        THROW 51053, 'Unexpected procedure definition headers.', 1;
    SET @daily = STUFF(@daily, @dailyPos, 6, 'ALTER');
    SET @monthly = STUFF(@monthly, @monthlyPos, 6, 'ALTER');

    EXEC sys.sp_executesql @daily;
    EXEC sys.sp_executesql @monthly;
    COMMIT TRANSACTION;
    PRINT 'Alternate-invoice calendar reset procedures updated.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
