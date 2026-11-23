-- Run against the repaired database with sqlcmd -b. Only temporary objects are changed.
SET NOCOUNT ON;
CREATE TABLE #test_tabmaxkey (TABName varchar(32) NOT NULL, TabMaxKey int NOT NULL);
CREATE TABLE #test_ServerDateMonth (lastMonthDate datetime NOT NULL);

DECLARE @daily nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter2'));
DECLARE @monthly nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.sp_UpdateSaleLedgerDummyCounter'));
IF @daily IS NULL OR @monthly IS NULL
    THROW 51090, 'Alternate-invoice reset procedures are missing or encrypted.', 1;

SET @daily = REPLACE(@daily, N'CREATE  Procedure sp_UpdateSaleLedgerDummyCounter2 As', N'CREATE PROCEDURE #daily_reset @testNow datetime AS');
SET @monthly = REPLACE(@monthly, N'CREATE  Procedure sp_UpdateSaleLedgerDummyCounter As', N'CREATE PROCEDURE #monthly_reset @testNow datetime AS');
SET @daily = REPLACE(REPLACE(REPLACE(@daily, N'_tabmaxkey', N'#test_tabmaxkey'), N'ServerDateMonth', N'#test_ServerDateMonth'), N'GetDate()', N'@testNow');
SET @monthly = REPLACE(REPLACE(REPLACE(@monthly, N'_tabmaxkey', N'#test_tabmaxkey'), N'ServerDateMonth', N'#test_ServerDateMonth'), N'GetDate()', N'@testNow');
IF CHARINDEX(N'CREATE PROCEDURE #daily_reset', @daily) = 0 OR CHARINDEX(N'CREATE PROCEDURE #monthly_reset', @monthly) = 0
    THROW 51091, 'Temporary procedure transformation failed.', 1;
EXEC sys.sp_executesql @daily;
EXEC sys.sp_executesql @monthly;

DECLARE @cases table (label varchar(30), lastDate datetime, nowDate datetime, daily bit, monthly bit);
INSERT @cases VALUES
    ('same day', '2026-11-17T01:00:00', '2026-11-17T15:00:00', 0, 0),
    ('next day', '2026-11-16T23:00:00', '2026-11-17T01:00:00', 1, 0),
    ('next month', '2026-10-31T23:00:00', '2026-11-01T01:00:00', 1, 1),
    ('year boundary skipped', '2025-12-31T23:00:00', '2026-01-02T01:00:00', 1, 1),
    ('same month next year', '2025-11-17T01:00:00', '2026-11-17T01:00:00', 1, 1),
    ('multiple years', '2024-12-31T23:00:00', '2026-11-17T01:00:00', 1, 1),
    ('leap day', '2024-02-28T23:00:00', '2024-02-29T01:00:00', 1, 0),
    ('earlier clock', '2026-11-17T12:00:00', '2026-10-30T01:00:00', 0, 0);

DECLARE @label varchar(30), @last datetime, @now datetime, @d bit, @m bit,
        @expected int, @actual int, @updated datetime, @result int, @tested int = 0;
DECLARE tests CURSOR LOCAL FAST_FORWARD FOR SELECT label, lastDate, nowDate, daily, monthly FROM @cases;
OPEN tests;
FETCH NEXT FROM tests INTO @label, @last, @now, @d, @m;
WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM #test_tabmaxkey;
    DELETE FROM #test_ServerDateMonth;
    INSERT #test_tabmaxkey VALUES ('SaleLedgerCashDummy', 100), ('SaleLedgerCreditDummy', 101);
    INSERT #test_ServerDateMonth VALUES (@last);
    EXEC @result = #daily_reset @testNow = @now;
    SET @expected = CASE WHEN @d = 1 THEN 0 ELSE 100 END;
    SET @actual = NULL;
    SET @updated = NULL;
    SELECT @actual = TabMaxKey FROM #test_tabmaxkey WHERE TABName = 'SaleLedgerCashDummy';
    SELECT @updated = lastMonthDate FROM #test_ServerDateMonth;
    IF @result IS NULL OR @result <> 0 OR @actual IS NULL OR @actual <> @expected
        OR @updated IS NULL OR @updated <> CASE WHEN @d = 1 THEN @now ELSE @last END
        OR (SELECT COUNT(*) FROM #test_tabmaxkey) <> 2
        OR (SELECT COUNT(*) FROM #test_ServerDateMonth) <> 1
        OR NOT EXISTS (SELECT 1 FROM #test_tabmaxkey WHERE TABName = 'SaleLedgerCreditDummy' AND TabMaxKey = CASE WHEN @d = 1 THEN 0 ELSE 101 END)
    BEGIN
        PRINT 'Daily case failed: ' + @label;
        THROW 51092, 'Daily reset test failed.', 1;
    END;

    DELETE FROM #test_tabmaxkey;
    DELETE FROM #test_ServerDateMonth;
    INSERT #test_tabmaxkey VALUES ('SaleLedgerCashDummy', 100), ('SaleLedgerCreditDummy', 101);
    INSERT #test_ServerDateMonth VALUES (@last);
    EXEC @result = #monthly_reset @testNow = @now;
    SET @expected = CASE WHEN @m = 1 THEN 0 ELSE 100 END;
    SET @actual = NULL;
    SET @updated = NULL;
    SELECT @actual = TabMaxKey FROM #test_tabmaxkey WHERE TABName = 'SaleLedgerCashDummy';
    SELECT @updated = lastMonthDate FROM #test_ServerDateMonth;
    IF @result IS NULL OR @result <> 0 OR @actual IS NULL OR @actual <> @expected
        OR @updated IS NULL OR @updated <> CASE WHEN @m = 1 THEN @now ELSE @last END
        OR (SELECT COUNT(*) FROM #test_tabmaxkey) <> 2
        OR (SELECT COUNT(*) FROM #test_ServerDateMonth) <> 1
        OR NOT EXISTS (SELECT 1 FROM #test_tabmaxkey WHERE TABName = 'SaleLedgerCreditDummy' AND TabMaxKey = CASE WHEN @m = 1 THEN 0 ELSE 101 END)
    BEGIN
        PRINT 'Monthly case failed: ' + @label;
        THROW 51093, 'Monthly reset test failed.', 1;
    END;
    SET @tested = @tested + 1;
    FETCH NEXT FROM tests INTO @label, @last, @now, @d, @m;
END;
CLOSE tests;
DEALLOCATE tests;
SELECT @tested AS calendar_cases_passed;
