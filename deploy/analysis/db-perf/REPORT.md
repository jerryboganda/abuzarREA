# SQL Server / database performance — findings

**Analyst #2 of 10 — scope:** schema, indexes, statistics, query plans, stored procedures, data types, constraints, triggers, instance configuration.
**Instance:** `.\SQLEXPRESS` = SQL Server 2008 R2 SP2 **Express** (10.50.4000.0, x64) on a 32 GB host.
**Database:** `FazalDinPP19DataBaseV2`, data file 3,058 MB (2,882 MB used), log 493 MB, **compatibility level 80**.
**Method:** read-only queries only. No DDL, no `sp_configure`, no rebuild, no `DBCC CHECKDB`, no service restart. Scratch SQL/output lives in `deploy/analysis/db-perf/`.

> **Freshness caveat.** Every fact table ends `2025-01-01` (SaleLedger, SaleDetail, VirtualGl, StockReport). This is a January-2025 restore, not a live production snapshot. DMV usage counters and waits cover only the 1.4 h since the service started at 2026-11-02 00:07, so they are *directional*, not a production baseline.

## Executive verdict

- **The database is not short of indexes; it is short of memory and maintenance.** 793 MB of buffer pool against 2,882 MB of used data means ~27% residency. The three biggest reporting tables — SaleLedger 628 MB, SaleDetail 674 MB, VirtualGl 516 MB — cannot co-reside with anything. Every large report re-reads them from disk.
- **Two missing access paths dominate all other DB work.** `StockReport` (2,906,627 rows, **zero indexes**) answers a one-day stock query with a 28,244-page full scan: **174 ms warm, 220 MB of IO, 6,082 rows returned**. `VirtualGl` (2,004,033-row heap) answers a one-month ledger query for the accounts that matter with a **37,907-page heap scan: 132 ms**. Three accounts (2, 37, 6) own 29–33% of the rows and tip the optimizer from seek to scan. Fixing these two is worth more than the other eighteen items combined.
- **~10% of the data file is page-split bloat, and the worst tables are 65–99% fragmented** because there is no maintenance plan — Express has no SQL Agent. SaleLedger is 57.2% page-dense, 67.9% fragmented, 53,112 fragments. Statistics on every large table were last updated in **Nov/Dec 2024** (700+ days) and will not auto-update for years: the 20% threshold on a 2M-row table is ~400,000 modifications, and the observed counters are 96k–107k.
- **Compatibility level 80 is not the optimizer win it was suspected to be.** On SQL 2008 R2 there is exactly one cardinality estimator (CE70) for levels 80–110, so raising the level changes **no estimates**. It does block `PIVOT`/`UNPIVOT` and `CROSS/OUTER APPLY` (both verified here), but a full scan of `sys.sql_modules` found **no** legacy `*=`/`=*` joins, so the bump is low-risk. Treat it as a blocker-clearing task for the 2019 upgrade, not a speed switch.
- **The biggest single step-change is leaving Express.** SQL 2019/2022 Standard with 16 GB holds the entire post-cleanup database (~2.5 GB) in RAM and adds scalar-UDF inlining (50 scalar UDFs; `Fn_GetPreference` is referenced by **84 modules**) and interleaved execution (20 multi-statement TVFs). That is a 3–10x class change on cold reports; everything else here is 1.2–5x.

## Evidence base

| Item | Measured |
|---|---|
| Engine / memory | 2008 R2 SP2 Express; host 32,673 MB; `bpool_committed` **793 MB**, `bpool_visible` 1,410 MB |
| Database | compat **80**, SIMPLE, TORN_PAGE_DETECTION, AUTO_CLOSE/SHRINK off, auto-create/update stats on, async off, RCSI off, ANSI_NULLS/QUOTED_IDENTIFIER/ARITHABORT/CONCAT_NULL all **off** |
| Files | data 3,058 MB / 2,882 used / **176 free**; log 493 MB / 15 used; both **10% autogrowth**, on `C:`; 62 GB free on volume |
| Objects | 751 user tables; **109 user heaps / 642 clustered / 317 NC** (the brief's 130/358 include 111 index rows on internal/catalog objects plus one `is_ms_shipped` table); 1,717 FKs (**86 untrusted**); 590 procs; 31 views; 50 scalar + 20 MSTVFs; 10 triggers; 2,017 statistics |
| Workload reality | **0 stored-procedure executions and 0 trigger executions in this database since restart.** Plan cache: 294 ad-hoc plans (24 MB) vs 20 proc plans. The interactive app path is **DataWindow ad-hoc SQL compiled into the PBDs**, not the 590 procs. DMV counters are server-wide and include the other analysts sharing this instance — use them relatively, not as a production baseline. |
| Big tables | StockReport 2,906,627 / 220 MB / 0 indexes; VirtualGl 2,004,033 / 296 MB heap + 220 MB indexes; SaleDetail 1,306,000 / 674 MB total; SaleLedger 588,865 / 628 MB total (580 MB clustered) |
| Physical | SaleLedger 580.7 B/rec, **57.2% fill, 67.9% frag, 53,112 fragments**; Item 726 B, 58.7%, 94.4%; ItemLog 777 B, 62.0%, 99.1%; Purdetail 61.4%, 76.0%; PurOrderDetail 63.7%, 65.3%; SaleDetail 90.4%, 17.4%; VirtualGl 96.0%; StockReport 95.4% (SAMPLED) |
| Stats | 944 statistics >1 year old, **973 never updated**, 0 `NORECOMPUTE`; VirtualGl/SaleLedger/SaleDetail last 2024-11/12; `rowmodctr` 96,375–107,252 |
| Query measurements | StockReport day: 28,244 reads / 174 ms; VirtualGl AccCode=2 month: **37,907 reads / 132 ms**; full history 381 ms; SaleLedger CustCode=19 month: 48,752 reads / 31 ms; SaleDetail by invoice: 3 reads / 0 ms |
| Procs | 78 procs (86 modules) with `CURSOR`, 41 procs (43 modules) with `SELECT *` (168 occurrences), 57 modules with `NOT IN (`, 123 procs with `CREATE TABLE #`, 0 `NOLOCK`, 0 `RECOMPILE`, 0 `sp_executesql`, 5 dynamic `EXEC` |
| Cross-table | **120 procs reference both SaleLedger and SaleDetail**; 168 SaleLedger, 132 SaleDetail, 67 VirtualGl |

## Findings

| ID | Finding | Evidence | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| D1 | **StockReport is an unindexed 2.9M-row heap** | 2,906,627 rows, 0 indexes, 28,244 pages; `WHERE [Date]=…` = 28,244 reads / 174 ms for 6,082 rows | Every stock/backdate report reads 220 MB; at 1 GB buffer it evicts everything else | Clustered `(Date,GCode,ICode)` | **400–500x fewer pages**; 174 → 2–5 ms (measured basis) | S | Med: 220 MB, 1–3 min lock |
| D2 | **VirtualGl tips from index seek to full heap scan** | AccCode=2 owns 650,459 rows (32%); month query = 37,907 reads / 132 ms. Existing AccCode index is non-covering → RID lookups | A one-account, one-month query reads the whole 296 MB table | `(AccCode,[Date])` covering INCLUDE | **100–300x pages**; 132 → 1–3 ms | S | Low |
| D3 | **Three indexes on 100%-NULL columns** | PatientCode/StudentCode/GuestCode: 2,004,033 NULLs each, 0 distinct; 0 seeks, 1 scan (mine); ~128 MB total | 60% of all VirtualGl index maintenance for indexes that can never be sought | Drop all three | ~128 MB + ~60% less write amplification | S | Low |
| D4 | **SaleLedger customer statements lack a composite path** | CustCode=19 month: 48,752 reads / 31 ms; `IDX_SaleLedger_CustCode` had 2 seeks, 7 scans since start | Date seek + one clustered lookup per invoice (16k/month for this customer) | `(CustCode,[date]) INCLUDE (InvTotal)` | **100–1000x pages** | S | Low |
| D5 | **SaleLedger is 57.2% dense and 67.9% fragmented** | 580.7 B/record, 53,112 fragments / 74,255 pages; 67.9% logical frag | 580 MB where ~415 MB is needed; readahead broken by 53k fragments | Rebuild FF80 | 1.4x scans, **165 MB freed** | M | High: offline rebuild, needs space |
| D6 | Four more tables 58–63% dense, 65–99% frag | Item 52 MB/58.7%/94.4%; ItemLog 127/62.0/99.1; Purdetail 147/61.4/76.0; PurOrderDetail 103/63.7/65.3 | Same mechanism: 100% fill + row-growing updates → page splits | Rebuild FF85–90 | 1.2–1.5x; **~135 MB freed** | M | Med |
| D7 | **Statistics are years old and will not auto-update** | Last update 2024-11/12 on 2M/588k tables; threshold is 20% + 500 = ~400k changes; counters 96k–107k | Bad cardinality → wrong join order/scan choices on the biggest reports | `UPDATE STATISTICS … FULLSCAN` + schedule | 1.1–1.5x on affected reports [hypothesis] | S | Low |
| D8 | **No maintenance plan at all** | Express has no SQL Agent; fragmentation + stat ages are the proof | Root cause of D5–D7; recurring | Task Scheduler + `sqlcmd` | Prevents regression | S | Low |
| D9 | **Compat 80 does not change the CE** | Verified level 80; `PIVOT` → error 325; `APPLY` → syntax error; CTE and `ROW_NUMBER` *work*; **no** `*=`/`=*` joins anywhere in `sys.sql_modules` | Direct optimizer gain ≈ 0 on 2008 R2; blocks modern rewrites; blocks 2019 upgrade | Level 100 on a copy, then production | 0–5% direct [hypothesis] | M | Low–Med: behavior changes, no known code blocker |
| D10 | 1,438 of 1,717 FKs have no leading index | `has_leading_idx=0` for 1,438; SaleLedger 35, Item 26, ItemLog 26, SaleDetail 4 | Mostly lookup codes; indexing all would be catastrophic (see “Do not index blindly”) | Only 2 pass the test | ~0 | S | — |
| D11 | **86 FKs are untrusted** | `is_not_trusted=1`; Item 6, ItemLog 6, GodownDetail 2, ItemInModel 2 | Optimizer cannot eliminate joins; possible orphan rows | Validate + `WITH CHECK` | 1.05–1.1x [hypothesis] | M | Med: may fail on orphans |
| D12 | **120 procs rebuild balances from SaleLedger+SaleDetail** | Both referenced by 120 modules; `sp_CustomerTransactionStatus` aggregates all history before a date | Each run reads up to 1.1 GB although VirtualGl already holds debit/credit per document | Rewrite against VirtualGl | 3–8x [hypothesis] | L | High: accounting correctness |
| D13 | 78 cursor procs | `sp_SatisfyDueInBulk` 36 cursor keywords, `sp_Post_SaleReturn_BillSummary` 30, `sp_PostItemConversion` 28, `sp_PostStockAdjustment` 24 | Row-by-row posting and round trips | Set-based rewrite | 2–10x on posting [hypothesis] | L | High |
| D14 | 168 `SELECT *` in 41 procs | `SP_TransferSaleInvoices` 5, `SP_GetAliasName*` 6 each | Reads 140-column rows to use 5 | Column lists | 1.1–1.3x on those paths | M | Low |
| D15 | Non-SARGable `NOT IN` + date conversion | `SP_StockReport`: `CONVERT(DATETIME, …STR(DATEPART…)+…) NOT IN (SELECT DISTINCT CONVERT(…DATE…) FROM STOCKREPORT)`; deletes commented out. `sp_AutoSalePosting` also uses `DateDiff(Minute, OriginalDate, GetDate()) >= @age … WITH (UPDLOCK,ROWLOCK,READPAST)` | Full scan + DISTINCT sort of 2.9M rows per run; auto-posting scans 588k SaleLedger rows per poll with update locks | `NOT EXISTS` + indexed date; `OriginalDate <= DATEADD(minute,-@age,GETDATE())` | 5–10x for the proc; auto-posting becomes a range seek [hypothesis] | S | Low |
| D16 | **50 scalar UDFs, no inlining on 2008 R2** | `Fn_GetPreference` in 84 modules, `Fn_Get_Int_Preference` in 35; interpreted per row; blocks parallelism | Per-row table access in SELECT/WHERE | Inline as join, or SQL 2019 inlining | 2–10x on affected reports [hypothesis] | L | Med |
| D17 | 20 multi-statement TVFs with fixed 1-row estimate | `Fn_GetUnposted_Purchase` 51 KB / 35 selects; `Fn_GetUnposted_AccTrans` 27 KB | Nested-loop plans over huge inputs (pre-2017 behaviour) | Inline TVF/temp table; 2017+ interleaved execution | 2–20x [hypothesis] | L | High |
| D18 | Triggers: no cursors, but two self-updates and two string-appends | `Trig_Item…LastUpdate`, `Trig_GodownDetail…LastUpdated` re-update the same row; `Trig_SrLedger` appends to `SaleLedger.ListOfSrInvoices varchar(500)`; ItemPart triggers are on **1 row / 0 rows** | 2x writes; row growth on SaleLedger feeds D5; silent 500-char truncation risk | Remove self-updates, replace string with child table | 1.05–1.2x writes | S | Med |
| D19 | tempdb is 28 MB, one file, 10% growth | `sp_IncomeStatment` creates 10 temp tables; 123 procs use temp tables | Hundreds of 2.8 MB autogrows, each a stall | 4 × 64 MB, 64 MB fixed growth | Removes 0.1–2 s stalls [hypothesis] | S | Low |
| D20 | Instance defaults are wrong for this workload | CTFP **5**, MAXDOP 0, optimize-for-adhoc **0**, max memory default, 1,059 indexes at fill factor 0 (100%) / 9 at 80, 10% growth, TORN_PAGE, RCSI off | Parallel overhead on small queries; 24 MB of ad-hoc plans; growth stalls; 100% fill drives the splits in D5–D6 | See backlog | 1.05–1.15x [hypothesis] | S | Low |
| D21 | **Buffer pool holds 27% of the database** | 793 MB committed vs 2,882 MB used; top 3 tables alone 1.8 GB | Every report evicts the previous one; latency is bimodal | Cleanup + Standard 16 GB | **3–10x cold** | XL | — |
| D22 | Space metadata is inconsistent | `IDX_VirtualGL_DocumentType_DocumentCode`: 2 pages in `dm_db_partition_stats` but 7,452 in `dm_db_index_physical_stats`; DMV total 2,533 MB vs FILEPROPERTY 2,882 MB | `sp_spaceused` understates by ~350 MB → wrong capacity decisions | `DBCC UPDATEUSAGE` in a window | — | S | Low |

## Hot tables — what they are and how they are read

| Table | Rows / size | Nature | Dominant access | Verdict |
|---|---|---|---|---|
| StockReport | 2.9M / 220 MB | **Daily stock snapshot** (one row per item × godown per day, 6,020/day, 483 days) | `d_stockinbackdate`: `WHERE S.Date = :ad_date`, joins to Item/Manufacturer/Category/Class, `GROUP BY` | Not a transaction table. Rebuild one day at a time (55 pages/day); needs a CI, not a rewrite. Retention is unbounded because the DELETEs were commented out in 2023 |
| VirtualGl | 2.0M / 516 MB (296 heap + 220 indexes) | **Accounting journal** (137 accounts, 1,097 days, append-only by date) | 67 procs: ledger, aging, cash-flow; `AccCode` + date range; `SUM(Debit-Credit)` | Heap + 5 NC indexes is the wrong shape. A covering `(AccCode,Date)` index fixes it |
| SaleLedger | 589k / 628 MB | Invoice header, 140 columns | By date (reports), by customer (statements), by PK (screen/update) | Date path OK, customer path poor, physical layout poor |
| SaleDetail | 1.31M / 674 MB | Invoice lines, 2.22 lines/invoice | Clustered by `SaleInvcode`; 13.7k seeks since restart | **Already optimal** — do not touch |
| Item | 29k / 52 MB used (112 reserved) | Item master, 134 columns, 86 child FKs | Scanned by almost every screen; updated rarely | Wide but not hot; fix density, not types |
| ItemLog | 98k / 127 MB | Audit copy of Item (138 columns), 99.1% frag | History/audit | Archive candidate; 1,354 B/page-row is waste |
| DeletedSaleItem | 169k / 27 MB | Deletion audit heap | Occasional audit | Heap is acceptable; low priority |
| PricePolicy / SRDetail / SRLedger | 29k / 90k / 62k | Pricing and sale-return detail | By item/customer | Small; no action now |

The remaining **107 heaps are <170k rows** (DeletedSaleItem 169k and PreviousSaleHistory 95k are the only non-trivial ones); they are not worth indexing before the five above. `StockReport` is the only true *summary/cache* table — everything else is primary data.

## Compatibility level 80 — what it does and does not do

**Verified facts (not hypotheses):**

1. `sys.databases.compatibility_level = 80`.
2. The **cardinality estimator does not change** between 80, 90, 100 and 110 on 2008 R2. CE70 is the only estimator shipped from SQL 7.0 through SQL 2012; CE versioning by compatibility level starts at SQL 2014 (level 120). Therefore `OPTION (QUERYTRACEON 9481)` — which forces the legacy CE — **would change nothing here**; there is no “new CE” to disable.
3. `PIVOT` fails at level 80 with *“Incorrect syntax near 'PIVOT'. You may need to set the compatibility level … to a higher value”* (Msg 325).
4. `CROSS APPLY` / `OUTER APPLY` fail to parse at level 80. CTEs and `ROW_NUMBER()` **do work** — so the parser restriction is selective, not total.
5. A full scan of `sys.sql_modules` for legacy `*=` / `=*` joins (word-boundary only, excluding comment banners) returns **zero matches**. The earlier LIKE hit was the `/*=====*/` banners used throughout this codebase — a false positive. So no procedure is known to break at level 90.
6. `sys.dm_db_index_physical_stats` / `sys.dm_db_index_operational_stats` fail to parse *inside* this database at level 80: `sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')` returns “Incorrect syntax near ')'”, but the identical call works from `master` and in tempdb. All maintenance scripts must connect to `master` and use three-part object names (this report's fragmentation numbers were collected that way).

**Conclusion:** the compat bump buys **no plan quality**. Its value is (a) unblocking `APPLY`/`PIVOT` for the cursor/temp-table rewrites, (b) being mandatory for SQL 2019/2022 (which support only levels 100–150 on 2019 and 100–160 on 2022), and (c) removing a class of parser restrictions before the rebuild. Expected direct gain 0–5%; effort M; risk **Low–Medium** — the only known behavioural exposure is the ANSI/QUOTED_IDENTIFIER semantics (46 modules were created with both OFF, 253 with QUOTED_IDENTIFIER OFF), which matters for indexed views/computed columns (there are none) rather than plain queries.

**Safe test plan (do not touch the live DB):**

1. Back up, restore as `FazalDinPP19_Compat100` on the same instance (10 GB cap is *per database*; 62 GB is free). Leave the original at 80.
2. On the copy: `ALTER DATABASE FazalDinPP19_Compat100 SET COMPATIBILITY_LEVEL = 100;`
3. Execute the report suite and a smoke test of all 590 procs at level 100; compare outputs and timings against the level-80 copy.
4. Baseline 10 representative report queries on the **80** copy with `SET STATISTICS IO, TIME ON`; record logical reads, CPU, elapsed. Repeat identically on the **100** copy. Same data, same indexes → any delta is pure optimizer/parser.
5. Save both plans as `.sqlplan` and compare `CardinalityEstimationModelVersion` — it will read **70** in both, confirming no CE change.
6. Only then change production; rollback is instant (`… = 80`).

## Top-20 DDL / config backlog

All statements are recommendations, **not executed**. `[E]` = works on 2008 R2 Express, `[S]` = needs Standard/Enterprise, `[N]` = needs 2016/2019+.

**Prerequisite (do first, 2 min):** the data file has only **176 MB free**; every operation below needs working space.

```sql
ALTER DATABASE [FazalDinPP19DataBaseV2] MODIFY FILE
  (NAME = N'MehmoodDataBase_Data', SIZE = 4096MB, FILEGROWTH = 256MB);   -- [E]
```

| # | Action | Exact statement | Expected gain | Effort | Risk | Validation |
|---|---|---|---|---|---|---|
| 1 | **StockReport clustered index** | `CREATE CLUSTERED INDEX CIX_StockReport ON dbo.StockReport([Date],GCode,ICode) WITH (FILLFACTOR=95,SORT_IN_TEMPDB=OFF,ONLINE=OFF);` | 400–500x fewer pages; 174 → 2–5 ms | S | Med: 220 MB, 1–3 min lock | `SET STATISTICS IO ON; SELECT SUM(Stock) FROM dbo.StockReport WHERE [Date]>='2025-01-01' AND [Date]<'2025-01-02';` → ~60 reads (was 28,244) |
| 2 | **VirtualGl covering index** | `CREATE INDEX IX_VirtualGl_AccCode_Date ON dbo.VirtualGl(AccCode,[Date]) INCLUDE (Debit,Credit,DocumentCode,DocumentType,VRow) WITH (FILLFACTOR=90);` | 100–300x pages; 132 → 1–3 ms; ~120 MB | S | Low | `SELECT SUM(Debit-Credit) FROM dbo.VirtualGl WHERE AccCode=2 AND [Date]>='2024-12-01' AND [Date]<'2025-01-01';` → ~135 reads (was 37,907) |
| 3 | **Drop 3 all-NULL indexes** | `DROP INDEX IDX_VirtualGL_PatientCode ON dbo.VirtualGl; DROP INDEX IDX_VirtualGL_StudentCode ON dbo.VirtualGl; DROP INDEX IDX_VirtualGL_GuestCode ON dbo.VirtualGl;` | ~128 MB, ~60% less index maintenance | S | Low | 0 seeks on all three; columns 100% NULL (already verified) |
| 4 | Drop redundant AccCode index | `DROP INDEX IDX_VirtualGL_AccCode ON dbo.VirtualGl;` | ~34 MB | S | Low | After #2 has run a full week; check `sys.dm_db_index_usage_stats` shows no seeks |
| 5 | **SaleLedger customer/date index** | `CREATE INDEX IX_SaleLedger_CustCode_Date ON dbo.SaleLedger(CustCode,[date]) INCLUDE (InvTotal) WITH (FILLFACTOR=90);` | 100–1000x on statements | S | Low: ~15 MB | CustCode=19 month → ~50 reads (was 48,752) |
| 6 | **Rebuild SaleLedger** | `ALTER INDEX PK_SaleLedger ON dbo.SaleLedger REBUILD WITH (FILLFACTOR=80,SORT_IN_TEMPDB=OFF);` | 580 → ~415 MB, frag 67.9 → <5% | M | **High**: offline, 1–5 min lock | `SELECT avg_fragmentation_in_percent,avg_page_space_used_in_percent FROM sys.dm_db_index_physical_stats(DB_ID('FazalDinPP19DataBaseV2'),OBJECT_ID('FazalDinPP19DataBaseV2.dbo.SaleLedger'),1,NULL,'SAMPLED');` (run from `master`) → fill ~80%, frag <5% |
| 7 | Rebuild ItemLog | `ALTER INDEX PK_ItemLog ON dbo.ItemLog REBUILD WITH (FILLFACTOR=90,SORT_IN_TEMPDB=OFF);` | 127 → ~90 MB, 99.1 → <5% frag | M | Med | Same DMV query, expect fill ~90% |
| 8 | Rebuild Purdetail | `ALTER INDEX PK_Purdetail_2__12 ON dbo.Purdetail REBUILD WITH (FILLFACTOR=90,SORT_IN_TEMPDB=OFF);` | 147 → ~100 MB, 76 → <5% | M | Med | DMV fill/frag |
| 9 | Rebuild PurOrderDetail | `ALTER INDEX PK_PurOrderDetail_1__11 ON dbo.PurOrderDetail REBUILD WITH (FILLFACTOR=90,SORT_IN_TEMPDB=OFF);` | 103 → ~73 MB, 65 → <5% | M | Med | DMV fill/frag |
| 10 | Rebuild Item | `ALTER INDEX PK_Item ON dbo.Item REBUILD WITH (FILLFACTOR=85,SORT_IN_TEMPDB=OFF);` | 52 → ~34 MB, 94.4 → <10% | M | Med | DMV fill/frag; row count unchanged |
| 11 | **Refresh statistics (top 10 tables)** | `UPDATE STATISTICS dbo.SaleLedger WITH FULLSCAN;` (repeat for SaleDetail, VirtualGl, StockReport, Purdetail, ItemLog, PurOrderDetail, Item, SRLedger, SRdetail) | 1.1–1.5x on stale-plan reports [hypothesis] | S | Low: blocks readers briefly | `SELECT STATS_DATE(OBJECT_ID('dbo.SaleLedger'),index_id) FROM sys.indexes WHERE object_id=OBJECT_ID('dbo.SaleLedger');` → today |
| 12 | Rewrite `SP_StockReport` predicate | Replace `NOT IN (SELECT DISTINCT CONVERT(…))` with `NOT EXISTS (SELECT 1 FROM StockReport WHERE [Date]>=@d AND [Date]<DATEADD(day,1,@d))` | 5–10x for the proc [hypothesis] | S | Low | Proc duration; `sys.dm_exec_query_stats` before/after |
| 13 | tempdb sizing | `ALTER DATABASE tempdb ADD FILE (NAME=N'tempdev2',FILENAME=N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\tempdev2.ndf',SIZE=64MB,FILEGROWTH=64MB);` (repeat for `tempdev3`, `tempdev4`; 4 × 64 MB) | Removes repeated autogrow stalls | S | Low | `SELECT name,size*8/1024 FROM tempdb.sys.database_files;` → 4 files, fixed growth |
| 14 | Fixed autogrowth | `ALTER DATABASE [FazalDinPP19DataBaseV2] MODIFY FILE (NAME=N'MehmoodDataBase_Log',FILEGROWTH=128MB);` (data done in prerequisite) | No 300 MB growth stalls | S | Low | `sys.database_files.is_percent_growth = 0` |
| 15 | Optimize for ad-hoc | `EXEC sp_configure 'optimize for ad hoc workloads',1; RECONFIGURE;` | Frees ~20 MB of the 24 MB ad-hoc plan cache | S | Low | `SELECT value_in_use FROM sys.configurations WHERE name='optimize for ad hoc workloads';` → 1 |
| 16 | CTFP 5 → 25 | `EXEC sp_configure 'cost threshold for parallelism',25; RECONFIGURE;` | 5–15% on OLTP mix; fewer CXPACKET-style stalls [hypothesis] | S | Low | `value_in_use` → 25; compare `sys.dm_os_wait_stats` CXPACKET over a day |
| 17 | Move to compat 100 | `ALTER DATABASE [FazalDinPP19DataBaseV2] SET COMPATIBILITY_LEVEL=100;` (test on a restore first) | 0–5% direct; unblocks APPLY/PIVOT and the 2019 upgrade | M | Low–Med | Execute the report suite and all 590 procs' smoke tests on a copy at 100; no error 4147 possible (no legacy joins), but check output diffs |
| 18 | Scheduled maintenance (no Agent on Express) | Windows Task Scheduler → `sqlcmd -S .\SQLEXPRESS -U sa -P … -C -d FazalDinPP19DataBaseV2 -i maint.sql` nightly: `UPDATE STATISTICS` + conditional `ALTER INDEX … REBUILD` where frag > 30% | Prevents D5–D7 recurring | S | Low | Job history; frag/stat age after 7 days |
| 19 | Fix self-update triggers | Remove `Trig_Item_AfterUpdate_UpdateLastUpdate_TimeStamp` / `Trig_GodownDetail_AfterUpdate_LastUpdated`, or replace with `DEFAULT CURRENT_TIMESTAMP` on insert only | ~2x fewer writes on Item/GodownDetail | S | Med: app may display LastUpdate | Compare `user_updates` before/after on a copy |
| 20 | **SQL 2019/2022 Standard, 16–32 GB** | Platform project (not DDL) | **3–10x cold reports**; whole DB cached; UDF inlining + interleaved execution | XL | — | PLE, `physical_reads`, report wall time before/after |

**Edition check:** items **#1–#19 are Express-compatible as written** (they use physical rebuilds, not `ONLINE=ON`). **#20 requires Standard 2016 SP1+ / 2019+.** Deliberately excluded because they need Enterprise or a newer version: online index rebuild, page/row compression, columnstore, indexed views, filtered indexes, Resource Governor, Query Store.

**Not in the 20 but cheap:** `ALTER DATABASE … SET PAGE_VERIFY CHECKSUM` (hygiene, no perf); `AUTO_UPDATE_STATISTICS_ASYNC ON` (only after #11/#18); drop/disable the 3 inert ItemPart triggers (1 row / 0 rows) for correctness; `DBCC UPDATEUSAGE` to fix D22.

## Top 10 by ROI (ranked)

1. **StockReport clustered index** — 174 ms → 2–5 ms on a report the app runs constantly; 220 MB of IO becomes 0.4 MB. S.
2. **VirtualGl `(AccCode,Date)` covering index + drop the 3 NULL indexes** — net **−42 MB** (drop ~162 MB, add ~120 MB) and 100–300x on every ledger/aging query. S.
3. **SaleLedger `(CustCode,date)`** — 48,752 → ~50 pages for a customer month. S.
4. **Rebuild SaleLedger @ FF80** — 1.4x scans and 165 MB returned to a 1 GB buffer. M.
5. **UPDATE STATISTICS + nightly job** — the plans the other fixes depend on; prevents the 2024-era estimates from persisting. S.
6. **Rebuild ItemLog / Purdetail / PurOrderDetail / Item** — another ~135 MB and 1.2–1.5x. M.
7. **Rewrite `SP_StockReport`** — removes a 2.9M-row DISTINCT sort from a routine path. S.
8. **tempdb + fixed autogrowth** — removes multi-second growth pauses from temp-table-heavy reports. S.
9. **CTFP 25 + optimize-for-adhoc** — 5–15% on the mixed workload and ~20 MB of plan cache. S.
10. **Compat 100** — no direct speed, but it is the gate to the APPLY/PIVOT rewrites and to any future version; no legacy-join blocker was found. M.

The **largest absolute win is the platform upgrade** (item 20); it is outside the quick-win ranking only because it is a purchase, not a change.

## Stored procedures — 30 worst by likely cost

Static ranking (no Query Store, 1.4 h uptime). “Cursor” counts occurrences of the string `CURSOR` — including variable names like `saleposting_cursor` — so use it as a ranking signal only, not as a loop count. `#` counts temp-table references. None of this is execution-measured; use `sys.dm_exec_query_stats` after a business day to confirm.

| # | Procedure | KB | Cursor | `SELECT *` | `#` | Likely cost |
|---|---|---|---|---|---|---|
| 1 | sp_SatisfyDueInBulk | 18 | 36 | 0 | 0 | Cursor-per-document over due invoices |
| 2 | sp_Post_SaleReturn_BillSummary | 17 | 30 | 0 | 0 | Row-by-row voucher posting |
| 3 | sp_IncomeStatment | 60 | 0 | 0 | 279 | 10 temp tables, multi-pass sales aggregation |
| 4 | sp_PostItemConversion | 27 | 28 | 0 | 0 | Cursor conversion posting |
| 5 | sp_PostStockAdjustment | 25 | 24 | 0 | 0 | Cursor adjustment posting |
| 6 | sp_Test2 | 33 | 0 | 0 | 176 | 176 temp references, numeric-heavy aggregation |
| 7 | sp_AutoIssueConsumableItem | 21 | 16 | 0 | 1 | Cursor issue generation |
| 8 | sp_GenerateIssue_On_ProdunctionNote | 19 | 16 | 0 | 0 | Cursor issue generation |
| 9 | sp_GenerateIssue | 19 | 16 | 0 | 0 | Cursor issue generation |
| 10 | sp_AccountsBalance | 34 | 0 | 0 | 157 | Multi-pass VirtualGl aggregation |
| 11 | SP_RePrioritizeStockBatches | 10 | 14 | 0 | 0 | Cursor over batches |
| 12 | SP_GroupWise_RePrioritizeStockBatches | 12 | 14 | 0 | 0 | Cursor over batches |
| 13 | SP_CheckDBIntegrity | 5 | 13 | 0 | 1 | Cursor over tables |
| 14 | sp_init_delete_table | 28 | 0 | 0 | 36 | 64 UNIONs, catalog churn |
| 15 | sp_GenerateMarkedSaleFromTemplate | 22 | 8 | 0 | 22 | Cursor + 22 temp refs |
| 16 | sp_GenerateSale_From_SaleOrder | 26 | 8 | 0 | 10 | Cursor + temp pipeline |
| 17 | sp_GenerateAutoSale | 21 | 8 | 0 | 14 | Cursor + temp pipeline |
| 18 | sp_Translate_ChildeServer_Sale | 33 | 8 | 0 | 9 | Cursor + dynamic transfer |
| 19 | sp_PostInstallment | 15 | 8 | 0 | 0 | Cursor posting |
| 20 | sp_GenerateReceipt_On_ProdunctionNote | 19 | 8 | 0 | 0 | Cursor posting |
| 21 | sp_PostReceipt_From_Production | 14 | 8 | 0 | 0 | Cursor posting |
| 22 | sp_GenerateReceipt | 18 | 8 | 0 | 0 | Cursor posting |
| 23 | sp_autosaleposting | 4 | 7 | 0 | 0 | Cursor in a 4 KB proc |
| 24 | sp_PostPurOrder | 3 | 7 | 0 | 0 | Cursor posting |
| 25 | sp_GetAllowedGroupSupplierCategory | 1 | 7 | 0 | 0 | Cursor over rights |
| 26 | sp_GetAllowedGroupCustomerCategory | 1 | 7 | 0 | 0 | Cursor over rights |
| 27 | SP_CRS_VirtualGL_Purchase | 55 | 0 | 0 | 67 | 12 UNION branches, 19 CONVERTs |
| 28 | SP_AutoDataMigration | 6 | 6 | 0 | 0 | Cursor + dynamic SQL |
| 29 | sp_PostPayroll | 7 | 6 | 0 | 0 | Cursor posting |
| 30 | SP_UpdateActivityMonitor | 41 | 0 | 0 | 20 | 20 temp refs, 44 ISNULLs — check if timer-driven |

Cross-cutting: **120 procs join SaleLedger+SaleDetail**; `sp_CustomerTransactionStatus` and `sp_SupplierTransactionStatus` aggregate *all history before a date* per run. The `SP_CRS_VirtualGL_*` family (11 procs; the largest is 55 KB, 67 temp refs) duplicates the non-CRS `SP_VirtualGL_*` family almost line-for-line — 11 variants over the same 2M-row ledger. `sp_executesql` is used **zero** times; the 5 dynamic procs use `EXEC (@sql)`, which cannot reuse plans and concatenates server/database names (plan-cache and injection risk).

## Do not index blindly

- **1,717 FKs, 1,438 without a leading index — do not “fix” this.** The FK gap count is a schema smell, not a to-do list. Most of those columns point at 5–20-row lookup tables (Users, Accounts, SaleType, Currency); an index on the child adds space and write cost and will never be chosen for a seek.
- **The arithmetic kills it.** Indexing all 1,438 at a conservative ~2 MB average = **~2.9 GB**, doubling the data file against a 10 GB Express cap and halving what the 1 GB buffer can cache. On SaleLedger alone the 35 missing FKs would add ~300 MB and take the table from **3 B-trees per insert to 38**. At ~540 invoices/day (SaleLedger is 588,865 rows over 1,096 days; the 1,800/day figure often quoted is VirtualGl journal lines, not invoices) that is ~19,000 extra index-row writes/day, plus log, for columns with <100 distinct values.
- **The test an FK must pass:** (a) the parent row is genuinely deleted/updated in normal use, (b) a real query filters or joins on that child column, (c) the child table is >10k rows, and (d) the column is selective (>100 distinct values) or is the leading range key. In this database only **`Saledetail.GCode`** (godown-wise reports) and possibly **`SRLedger.CustCode`** (customer returns) come close. The other ~1,436 fail (d) or (c).
- **Fixing the 86 untrusted FKs is worth more than indexing their columns.** Untrusted constraints cannot be used for join elimination, and they may hide orphan rows. Validate with `DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS` on a **copy** first, then `ALTER TABLE … WITH CHECK CHECK CONSTRAINT …` in a window.
- **Write amplification on the hot path.** SaleDetail (1.3M rows) has 3 NC indexes; every insert/delete already maintains 4 B-trees. Four more FK indexes would make it 8, and each rebuild of those indexes needs space and an exclusive lock (no online rebuild on Express).
- **Express limits make blind indexing worse than on Standard:** 1 GB buffer, 10 GB database cap, no online rebuild, no data compression, no columnstore, no indexed views. Every unnecessary index is paid for in the same 1 GB the reports need.

## Implementation plan (ordered)

**Phase 0 — baseline (30 min, no app impact).** Capture the five measurements in `21_measure.sql` (logical reads, CPU, elapsed). Record `bpool_committed`, PLE, and the five queries' plans. Take a full backup.

**Phase 1 — index wins (1 h, low risk, short locks).** Grow the file (#0). Then: drop the 3 NULL indexes (#3) → create StockReport CI (#1) → create VirtualGl index (#2) → create SaleLedger index (#5). Validate each with the listed `STATISTICS IO` query. No clustered rebuild yet, so no long locks.

**Phase 2 — maintenance window (2–4 h, offline).** Rebuild SaleLedger (#6), ItemLog (#7), Purdetail (#8), PurOrderDetail (#9), Item (#10); `UPDATE STATISTICS … FULLSCAN` (#11); `DBCC UPDATEUSAGE` (D22). Do **not** shrink afterwards.

**Phase 3 — configuration (same day, instant).** tempdb files (#13), fixed growth (#14), optimize-for-adhoc (#15), CTFP 25 (#16), scheduled maintenance job (#18). Validate from `sys.configurations` and `tempdb.sys.database_files`.

**Phase 4 — code (1–2 weeks).** Rewrite `SP_StockReport` (#12). Regression-test the report suite on a copy at compat 100 (#17) and then apply it. Fix the two self-update triggers and the string-append triggers (#19). Because **0 procs executed in this database** during the observation window, treat proc rewrites as medium-term: the interactive hot path is DataWindow SQL, not the procs.

**Phase 5 — structural (project).** Rewrite the top cursor procs (D13) and the sale-balance procs against VirtualGl (D12); inline `Fn_GetPreference` (D16). Then the platform upgrade (#20): 2019/2022 Standard, 16 GB, compat 150. Re-measure before considering compression/columnstore.

## Upgrade case: 2008 R2 Express vs 2019/2022 Standard

| | Now (2008 R2 Express) | Standard 2019/2022, 16 GB | Standard, 32 GB |
|---|---|---|---|
| Buffer pool | ~1 GB cap; **793 MB committed** | 16 GB → whole ~2.5 GB DB resident | 32 GB → DB + tempdb + 10 years of growth |
| DB resident | **27%** (793 / 2,882 MB) | **100%** | 100% with headroom |
| Cores | 1 socket / 4 cores | 4 sockets or 24 cores (whichever is less) | same |
| DB size cap | 10 GB | no practical cap | no practical cap |
| SQL Agent / scheduling | **none** | yes | yes |
| Data compression | no | **yes** (since 2016 SP1) | yes |
| Columnstore | no | yes (Standard, memory-limited) | yes |
| Online index rebuild | no | **no** (Enterprise only) | no |
| Scalar UDF inlining | no | **yes** (2019, compat 150) | yes |
| Interleaved MSTVF execution | no | **yes** (2017+) | yes |
| Batch mode on rowstore | no | **yes** (2019) | yes |

**What 16 GB actually buys.** The post-cleanup database is ≈2.5 GB (2,882 MB − ~300 MB bloat − 162 MB useless indexes + ~120 MB new index). It fits entirely in a 16 GB buffer pool with 13+ GB left for tempdb, plan cache and OS. That converts every “cold” report into a memory scan and removes the bimodal latency that dominates the user experience today. Expect **3–10x on cold reports** (IO elimination) and **1.5–3x on warm reports** (CPU/plan quality), with the variance gone. Basis: arithmetic on 793 MB → 16 GB for a 2.5 GB working set; [hypothesis] until measured.

**Beyond memory, the version matters more than the edition.** The two dominant code-level costs — 50 scalar UDFs (`Fn_GetPreference` in 84 modules) and 20 multi-statement TVFs — are *fixed by the 2019 optimizer*, not by RAM. Scalar UDF inlining and interleaved execution can remove 2–10x from exactly the reports that hurt. Data compression (Standard) would typically cut the 2.9M-row StockReport and 2M-row VirtualGl by 40–60%, further reducing IO [hypothesis]. Online rebuild still needs Enterprise, so keep the maintenance window.

**Growth check:** SaleLedger grows ~196k rows/year (~200 MB), SaleDetail ~435k/year (~175 MB), VirtualGl ~670k/year (~100 MB), StockReport ~160 MB/year if the snapshot job resumes → **~0.6 GB/year**. 16 GB of RAM is sufficient for a decade at this rate; the Express 10 GB *database* cap would be the binding constraint long before that.

## What NOT to do

- **Do not index the 1,438 FK gaps.** See above: ~2.9 GB, 38 B-trees per SaleLedger insert, no buffer left.
- **Do not enable RCSI/snapshot isolation.** It adds 14 bytes of versioning per row on a 2.9 GB database with a 1 GB buffer, and the app is a single-writer ERP. Fix blocking with shorter transactions and report isolation instead.
- **Do not rebuild all 1,068 user indexes.** Most NC indexes are already dense and tiny (Item's four total 1.1 MB). Rebuild only the five in the backlog plus anything the maintenance job flags >30% frag with >1,000 pages.
- **Do not `DBCC SHRINKFILE` after the rebuilds.** It re-fragments and the file is only 3 GB of a 10 GB cap; the freed pages are useful headroom.
- **Do not set `max server memory`.** Express enforces its own ~1 GB cap; the setting is inert here.
- **Do not use `OPTION (QUERYTRACEON 9481)`.** It forces the legacy CE, which is the only CE this build has; it changes nothing.
- **Do not add filtered indexes, indexed views, page compression, columnstore, or `ONLINE=ON` rebuilds** on this instance — all are Enterprise/2016+ features and will simply fail.
- **Do not convert `char` → `varchar` expecting a win.** There are **no `char(255)` columns**; **1,484 of the 1,553 `char` columns are `char(1)` flags**, the whole set totals only 3,988 declared bytes (largest is one `char(100)`), and there are 115 `varchar(255)` columns. `Item` is **726 B/record**, not 4 KB; its 112 MB is *reserved* space, of which ~60 MB is unused pages. `PBTrimCharColumns=Yes` is not costing anything measurable.
- **Do not chase the ItemPart triggers.** `ItemPart` has **1 row**, `ItemPartInModel` and `ItemInModel` have **0**. The 40-SELECT trigger body is a correctness landmine, not a performance problem.
- **Do not put the database in FULL recovery “for safety.”** SIMPLE is correct for this single-server deployment; the log is 493 MB with 15 MB used, and FULL would only add log-growth stalls.

## Measurements still needed

1. **Cold-cache baseline:** restore a copy of the database to a second instance (or `DBCC DROPCLEANBUFFERS` on a copy), then run `21_measure.sql`; record physical reads and elapsed. This converts the warm numbers (174/132/31 ms) into the numbers users actually feel.
2. **Real workload ranking:** no Query Store on 2008 R2. Run a server-side trace or Extended Events `sql_statement_completed` for one business day; rank by `duration`, `logical_reads`, `cpu`. Confirm the static proc ranking above.
3. **PLE and buffer hit ratio under load:** sample `sys.dm_os_performance_counters` every 10 s during a report run; today's PLE (5,226 s) is idle noise.
4. **Blocking:** snapshot `sys.dm_exec_requests` + `sys.dm_os_waiting_tasks` during month-end; count `LCK_M_*` waits. RCSI is off and readers take shared locks.
5. **Index usage over one full cycle:** `sys.dm_db_index_usage_stats` resets at service start; run for a week before dropping anything beyond the three NULL indexes.
6. **Estimate vs actual rows** for the top 20 queries (`SET STATISTICS PROFILE ON` or actual plan) — this is how D7/D16/D17 get quantified.
7. **Compat-100 A/B** exactly as described above; also record `CardinalityEstimationModelVersion` (expect 70 both sides).
8. **Verify `BACKUP … WITH COMPRESSION`** on a scratch database on this Express build before relying on it; if unsupported, address the ~25 s of BACKUPIO/write waits seen at startup by moving the backup off the app-launch path.
9. **Disk type of `C:`** (SSD vs HDD). The difference between 0.6 s and 3 s for a 296 MB scan, and it decides whether the Express buffer-pool problem is urgent or critical.

