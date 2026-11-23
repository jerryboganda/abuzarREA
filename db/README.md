# db/ - recovered database (schema only, no customer data)

Final schema of the Trader App database ("V3"): **761 tables, 10,882 columns, 1,730 foreign keys, 81 indexes, 642 stored procedures, 74 functions, 36 views, 10 triggers.**
Everything except two procedures runs cleanly on an empty SQL Server 2025 database (`validate.log`).

## How it was built

1. **First reconstruction (independent of the final source).** The V2 database file (`Junk/2024-11-11/Data1/FazalDinPP19V2DB.mdf`, SQL Server 2000 on-disk format, internal version 539) cannot be attached by SQL Server 2025. `re-tools/mdf2000.py` reads its system tables (sysobjects, syscolumns, sysindexes, sysreferences, syscomments) directly from the 8 KB pages, including undoing torn-page-detection bits. Migration scripts #7800-7968 from `Application/Script.mdb` were replayed on top (`re-tools/db_rebuild.py`). Result: 751 tables, 589 procedures (kept in `previous_v2_plus_scripts/`).
2. **Final schema = the V3 data file's catalog.** `Junk/2024-11-11/Data1/FazalDinPP19V3DB_recovered.mdf` (same 2000 format, produced outside this analysis; origin not verified by me) was read with the same parser, catalog only. It is a strict superset of the first reconstruction: nothing of mine is missing, and it adds 10 tables (FBR digital invoice tables `fbr_di_*`, `crs_transactions`, `icdlist`, `visiticd`, `headerlogo`, `itemcolourandsize`, `stateprovince`), 26 tables with extra columns (e.g. `buyerntn`, `digitalinvoiceno` on the invoice tables) and 53 more procedures (CRS push/pull, aging). That agreement is also a good check of the first method.
3. **Checked** by running `schema/*.sql` on SQL Server 2025 (`re-tools/sql_validate.ps1`), then dumping the engine's own catalog to `catalog/*.jsonl` (columns, indexes, foreign keys, modules, parameters, object dependencies).

| Path | Contents |
|---|---|
| `schema/01..07_*.sql` | tables, foreign keys, indexes, functions, views, procedures, triggers (apply in this order) |
| `schema.json` | same schema, machine-readable (tables, columns, PK/UQ/FK/CHECK, indexes, procedure/function/view/trigger bodies) |
| `catalog/` | SQL Server catalog dump of the validated schema, incl. `dependencies.jsonl` (which procedure/view touches which table) |
| `seed/seed_ledger.sql` | 10,737 data statements from the migration chain, in order (rights, preferences, dropdowns, report metadata). Not validated |
| `previous_v2_plus_scripts/` | the first reconstruction (V2 + scripts) |
| `v2_catalog/schema.json` | raw V2 catalog (provenance) |
| `validate.log` | the 2 procedures that do not compile |

## Known limits

- Two procedures do not compile on SQL Server 2025 (one uses the obsolete `DUMP` statement; one references a column that no longer exists).
- Foreign keys carry no cascade rules (SQL Server 2000 stored none); identity seed/increment are assumed `(1,1)`; collations other than the database default are not recorded.
- The customer `*.BAK` backups are SQL Server 2000 format and cannot be restored on SQL Server 2025 at all (they would need SQL Server 2008 R2 or older). No backup was opened, and no row data was read, apart from system catalogs.
