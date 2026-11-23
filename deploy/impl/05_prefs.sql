/* ============================================================================
   05_prefs.sql
   Remove the startup backup-health check and guarantee the item-list
   auto-refresh is off. These are data-only, reversible preference changes.
   Fiscalization is deliberately NOT changed here: it is a legal/business
   setting and needs the FiscalizationApp listener or an explicit decision.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE [FazalDinPP19DataBaseV2];
GO

PRINT '=== 05.1 disable startup backup-health check ===';
UPDATE dbo.SoftwarePreferences
SET PrefValue = 'N'
WHERE Name = 'CheckManualBackupHealthAtStartUp';
PRINT 'rows updated: ' + CONVERT(VARCHAR(10), @@ROWCOUNT);
GO

PRINT '=== 05.2 guarantee item auto-refresh is off ===';
UPDATE dbo.Groups
SET AutoRefreshItemList = 'N',
    AutoRefreshItemListTime = 0
WHERE AutoRefreshItemList <> 'N'
   OR AutoRefreshItemListTime <> 0;
PRINT 'rows updated: ' + CONVERT(VARCHAR(10), @@ROWCOUNT);
GO

PRINT '=== 05.3 verify ===';
SELECT Name, PrefValue FROM dbo.SoftwarePreferences
WHERE Name IN ('CheckManualBackupHealthAtStartUp', 'AutoFiscalizeOnPosting');
SELECT GroupCode, AutoRefreshItemList, AutoRefreshItemListTime FROM dbo.Groups;
GO

PRINT '=== 05_prefs.sql completed ===';
GO
