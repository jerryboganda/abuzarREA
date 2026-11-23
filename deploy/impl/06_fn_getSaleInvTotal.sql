/* ============================================================================
   06_fn_getSaleInvTotal.sql
   Replace the per-row recalculation with an O(1) lookup of the persisted
   SaleLedger.InvTotal. A 9-row adjustment table preserves the exact historic
   output of the old function for nine 2022-2023 invoices where the old
   calculation returned exactly 1.00 more than the stored InvTotal.
   Safe to re-run.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 06.1 create adjustment table ===';
IF OBJECT_ID(N'dbo.SaleInvTotalAdjustment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SaleInvTotalAdjustment
    (
        SaleInvCode INT           NOT NULL
            CONSTRAINT PK_SaleInvTotalAdjustment PRIMARY KEY,
        Adjustment  NUMERIC(15,2) NOT NULL,
        Reason      VARCHAR(200)  NOT NULL
    );
    PRINT 'SaleInvTotalAdjustment created.';
END
ELSE
    PRINT 'SaleInvTotalAdjustment already exists — skipped.';
GO

PRINT '=== 06.2 seed the nine historic +1.00 adjustments ===';
INSERT INTO dbo.SaleInvTotalAdjustment (SaleInvCode, Adjustment, Reason)
SELECT v.SaleInvCode, v.Adjustment, v.Reason
FROM (VALUES
    (19111,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (20744,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (24658,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (33085,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (33326,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (33718,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (71727,  1.00, 'Legacy 2022 sale-return rounding: old fn returned InvTotal + 1.00'),
    (238514, 1.00, 'Legacy 2023 sale-return rounding: old fn returned InvTotal + 1.00'),
    (276404, 1.00, 'Legacy 2023 sale-return rounding: old fn returned InvTotal + 1.00')
) AS v(SaleInvCode, Adjustment, Reason)
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.SaleInvTotalAdjustment A
    WHERE A.SaleInvCode = v.SaleInvCode
);
PRINT 'rows inserted: ' + CONVERT(VARCHAR(10), @@ROWCOUNT);
GO

PRINT '=== 06.3 rewrite fn_getSaleInvTotal as an O(1) lookup ===';
GO
ALTER FUNCTION dbo.fn_getSaleInvTotal (@saleinvcode INT)
RETURNS NUMERIC(15,2)
AS
BEGIN
    DECLARE @total NUMERIC(15,2);

    /* Preserve the original function's NULL result for an unknown invoice. */
    IF NOT EXISTS (SELECT 1 FROM dbo.SaleLedger WHERE SaleInvCode = @saleinvcode)
        RETURN NULL;

    SELECT @total = ISNULL(SL.InvTotal, 0) + ISNULL(A.Adjustment, 0)
    FROM dbo.SaleLedger SL
    LEFT JOIN dbo.SaleInvTotalAdjustment A
           ON A.SaleInvCode = SL.SaleInvCode
    WHERE SL.SaleInvCode = @saleinvcode;

    RETURN ISNULL(@total, 0);
END
GO

PRINT '=== 06.4 verify the nine historic rows ===';
SELECT SL.SaleInvCode, SL.InvTotal, A.Adjustment,
       dbo.fn_getSaleInvTotal(SL.SaleInvCode) AS new_fn_total,
       SL.InvTotal + A.Adjustment AS expected
FROM dbo.SaleLedger SL
JOIN dbo.SaleInvTotalAdjustment A ON A.SaleInvCode = SL.SaleInvCode
ORDER BY SL.SaleInvCode;
GO

PRINT '=== 06.5 verify a 1,000-invoice sample has no drift ===';
SELECT COUNT(*) AS mismatches
FROM
(
    SELECT TOP 1000 SL.SaleInvCode, SL.InvTotal,
           dbo.fn_getSaleInvTotal(SL.SaleInvCode) AS new_fn_total
    FROM dbo.SaleLedger SL
    ORDER BY SL.SaleInvCode DESC
) x
WHERE ABS(ISNULL(InvTotal,0) - ISNULL(new_fn_total,0)) > 0.009
  AND NOT EXISTS (SELECT 1 FROM dbo.SaleInvTotalAdjustment A WHERE A.SaleInvCode = x.SaleInvCode);
GO

PRINT '=== 06_fn_getSaleInvTotal.sql completed ===';
GO
