-- Data-faithfulness fixes found by the full live-data load.
--
-- The rebuild schema was generated from recovered source metadata.  In two
-- places it is stricter than the live database:
--
--   itemcolour/itemsize.shortname is NOT NULL in the rebuild schema, but the
--   live tables have no such column at all (only Code, Name, Description).
--   The recovered Item Colour/Size DataWindows use code/name/description, so
--   the extra column is unused; it must accept NULL for the live rows.
--
-- This file is applied by Apply-RebuildSchema.ps1 after the release schema.
ALTER TABLE dbo.itemcolour ALTER COLUMN shortname DROP NOT NULL;
ALTER TABLE dbo.itemsize   ALTER COLUMN shortname DROP NOT NULL;
