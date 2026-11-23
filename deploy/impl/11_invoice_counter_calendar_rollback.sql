-- Restore the two original alternate-invoice reset conditions.
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET LOCK_TIMEOUT 5000;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @daily nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter2'));
    DECLARE @monthly nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter'));
    DECLARE @newDaily nvarchar(200) = N'IF CONVERT(date, @currentdate) > CONVERT(date, @lastdate)';
    DECLARE @newMonthly nvarchar(200) = N'IF DATEDIFF(month, @lastdate, @currentdate) > 0';
    DECLARE @dailyPos int, @monthlyPos int;

    IF @daily IS NULL OR @monthly IS NULL
        THROW 51060, 'Alternate-invoice reset procedures are missing or encrypted.', 1;
    IF CHARINDEX(@newDaily, @daily) = 0 OR CHARINDEX(@newDaily, @daily, CHARINDEX(@newDaily, @daily) + 1) <> 0
        THROW 51061, 'Daily reset procedure differs from the expected patched form.', 1;
    IF CHARINDEX(@newMonthly, @monthly) = 0 OR CHARINDEX(@newMonthly, @monthly, CHARINDEX(@newMonthly, @monthly) + 1) <> 0
        THROW 51062, 'Monthly reset procedure differs from the expected patched form.', 1;

    SET @daily = REPLACE(@daily, @newDaily, N'IF ( @currentday > @lastday ) OR ( @currentday = 1 AND @lastday >364 )');
    SET @monthly = REPLACE(@monthly, @newMonthly, N'IF ( @currentmonth > @lastmonth ) OR ( @currentmonth = 1 AND @lastmonth = 12 )');
    SET @dailyPos = PATINDEX('%[A-Za-z]%', @daily);
    SET @monthlyPos = PATINDEX('%[A-Za-z]%', @monthly);
    IF UPPER(SUBSTRING(@daily, @dailyPos, 6)) = 'CREATE'
        SET @daily = STUFF(@daily, @dailyPos, 6, 'ALTER');
    ELSE IF UPPER(SUBSTRING(@daily, @dailyPos, 5)) <> 'ALTER'
        THROW 51063, 'Unexpected daily procedure definition header.', 1;
    IF UPPER(SUBSTRING(@monthly, @monthlyPos, 6)) = 'CREATE'
        SET @monthly = STUFF(@monthly, @monthlyPos, 6, 'ALTER');
    ELSE IF UPPER(SUBSTRING(@monthly, @monthlyPos, 5)) <> 'ALTER'
        THROW 51064, 'Unexpected monthly procedure definition header.', 1;

    EXEC sys.sp_executesql @daily;
    EXEC sys.sp_executesql @monthly;
    COMMIT TRANSACTION;
    PRINT 'Original alternate-invoice calendar conditions restored.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
