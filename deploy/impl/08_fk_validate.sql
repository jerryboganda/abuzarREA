/* ============================================================================
   08_fk_validate.sql
   Validate every untrusted, enabled foreign key with a targeted orphan count.
   Trust only the FKs with zero orphan rows; leave any violated FK untrusted
   and visible in the report.
   Run on the copy first, then on the live database.
   ============================================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID('tempdb..#fk_check') IS NOT NULL
    DROP TABLE #fk_check;

CREATE TABLE #fk_check
(
    fk           SYSNAME       NOT NULL,
    child_table  NVARCHAR(300) NOT NULL,
    parent_table NVARCHAR(300) NOT NULL,
    orphans      INT           NOT NULL
);

DECLARE @fk        SYSNAME;
DECLARE @child     NVARCHAR(300);
DECLARE @parent    NVARCHAR(300);
DECLARE @object_id INT;
DECLARE @pred      NVARCHAR(MAX);
DECLARE @notnull   NVARCHAR(MAX);
DECLARE @sql       NVARCHAR(MAX);

DECLARE fk_cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT fk.name,
           QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + N'.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),
           QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id)) + N'.' + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),
           fk.object_id
    FROM sys.foreign_keys fk
    WHERE fk.is_not_trusted = 1
      AND fk.is_disabled = 0;

OPEN fk_cur;
FETCH NEXT FROM fk_cur INTO @fk, @child, @parent, @object_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @pred = N'';
    SET @notnull = N'';

    SELECT @pred = @pred + N' AND p.' + QUOTENAME(pc.name) + N' = c.' + QUOTENAME(cc.name),
           @notnull = @notnull + N' AND c.' + QUOTENAME(cc.name) + N' IS NOT NULL'
    FROM sys.foreign_key_columns fkc
    JOIN sys.columns cc
      ON fkc.parent_object_id = cc.object_id
     AND fkc.parent_column_id = cc.column_id
    JOIN sys.columns pc
      ON fkc.referenced_object_id = pc.object_id
     AND fkc.referenced_column_id = pc.column_id
    WHERE fkc.constraint_object_id = @object_id;

    SET @sql = N'INSERT INTO #fk_check (fk, child_table, parent_table, orphans)
                 SELECT ' + QUOTENAME(@fk, '''') + N', ' + QUOTENAME(@child, '''') + N', ' + QUOTENAME(@parent, '''') + N',
                        COUNT(*)
                 FROM ' + @child + N' c
                 WHERE 1 = 1' + @notnull + N'
                   AND NOT EXISTS (SELECT 1 FROM ' + @parent + N' p WHERE 1 = 1' + @pred + N');';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM fk_cur INTO @fk, @child, @parent, @object_id;
END

CLOSE fk_cur;
DEALLOCATE fk_cur;

PRINT '=== untrusted FK orphan counts (non-zero first) ===';
SELECT fk, child_table, parent_table, orphans
FROM #fk_check
ORDER BY orphans DESC, fk;

SELECT COUNT(*) AS valid_fks   FROM #fk_check WHERE orphans = 0;
SELECT COUNT(*) AS invalid_fks FROM #fk_check WHERE orphans > 0;

PRINT '=== trusting only zero-orphan FKs ===';
DECLARE @alter NVARCHAR(MAX);
SET @alter = N'';

SELECT @alter = @alter +
    N'ALTER TABLE ' + child_table + N' WITH CHECK CHECK CONSTRAINT ' + QUOTENAME(fk) + N';' + CHAR(13)
FROM #fk_check
WHERE orphans = 0;

IF @alter <> N''
    EXEC sp_executesql @alter;

SELECT COUNT(*) AS still_untrusted FROM sys.foreign_keys WHERE is_not_trusted = 1;
GO

PRINT '=== 08_fk_validate.sql completed ===';
GO
