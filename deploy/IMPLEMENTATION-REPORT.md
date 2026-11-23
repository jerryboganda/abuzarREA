# Waseela / Abuzar V2 — performance implementation report

**Date:** 2026-11-02  
**Scope:** deployed working copy only (`C:\Projects\Abuzar\deploy`). The pristine original (`C:\Projects\Abuzar\Application`) and the original backup were not modified.  
**Backup before changes:** `deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak` — **3,023,501,824 bytes**, backup 22.311 s at 129.230 MB/s, `RESTORE VERIFYONLY ... WITH CHECKSUM` passed.  
**Current pre-migration backup:** `deploy\impl\backup\FazalDinPP19DataBaseV2_pre_sql2022.bak` — **2,850,413,056 bytes**, verify passed; includes the watermark/StockLedger work. The older `post_impl.bak` was removed after this backup was verified, to save 2.4 GB.

---

## 1. Executive summary

- Applied the safe, high-ROI database/config layer of the roadmap: **three hot-table indexes**, removal of **three 100%-NULL indexes**, **statistics refresh**, **file/tempdb sizing**, **sargable `SP_StockReport`**, **shell-free `SP_WayToMoon`**, **`xp_cmdshell` disabled**, and an **O(1) `fn_getSaleInvTotal`** that preserves all historic outputs.
- Measured structural gains:
  - `StockReport` one-day query: **28,244 → 60 logical reads** (471× fewer pages), **503 → 2 ms** elapsed.
  - `VirtualGl` account-month: **37,907 → 127 reads** (298× fewer), **679 → 8 ms**.
  - `SaleLedger` customer-month: **79,236 → 60 reads** (1,320× fewer), **96 → 3 ms**.
  - `fn_getSaleInvTotal`: **1,929 rows in 25 ms** (old path was 1.59 s for the same report row count); 10,000 rows in 126 ms. Full-table old call took **344 s**; the new function is a single-row lookup.
- `SP_WayToMoon` returns 0 in microseconds with **`xp_cmdshell=0`**; the app no longer depends on `cmd.exe` for startup.
- `SP_StockReport` first run completed in **337 ms**; the second run (today already exists) completed in **2 ms**.
- Rebuilt five fragmented hot tables; **SaleLedger 581 → 387 MB**, fragmentation **0–0.01%**, ~**525 MB** reserved space freed. Nightly task `Waseela DB Maintenance` result **0**.
- **SQL Server 2022 Express is installed and live** (free, production-legal): compatibility **160**, Query Store **ON**, page compression on the hot tables, **1,409 MB** buffer pool (was 793 MB). On the new instance: `StockReport` **26 reads / 2 ms**, `VirtualGl` **134 / 9 ms**, `SaleLedger` **60 / 4 ms**, `fn_getSaleInvTotal` **0 drift**, checksums exact. The old 2008 R2 database is **READ_ONLY** as the rollback.
- **86 untrusted FKs trusted**, with one real `Purledger`/`TaxCategory` orphan isolated and its FK untrusted; ACLs hardened (`Users` RX on app, Modify on temp only, `Script.mdb` read-only, `BUILTIN\Users` denied).
- **Fiscalization fixed:** missing `ATL71.DLL` copied, listener up on **9111**, `FiscalizationMachine=DESKTOP-NQ9K8T3`, logon task result **0**, `AutoFiscalizeOnPosting=Y` retained.
- The app was started through the new **`WaseelaLauncher.exe`**: splash → foreground Login → login → main window → **Cash Sale** open, all verified with screenshots.
- Warm start through the launcher: **1.83 s to the Login window**. The cold-cache capture (RAMMap + ProcMon) shows first SQL at **1.8 s** and Login at **4.2 s**; the original 14.1 s is not reproducible and is cold client/COM-registry enumeration, not a fixed delay. The true-reboot capture task is enabled for the owner's next reboot (see §10).

---

## 2. What changed

| Script | Change | Object / setting | Evidence |
|---|---|---|---|
| `01_indexes.sql` | Pre-size data file to 4 GB, 256 MB growth; log 128 MB growth | `MehmoodDataBase_Data`, `MehmoodDataBase_Log` | `logs/01_indexes.log` |
| `01_indexes.sql` | Clustered `(Date,GCode,ICode)` | `StockReport` → `CIX_StockReport` | 209.1 MB index; query 28,244 → 60 reads |
| `01_indexes.sql` | Covering `(AccCode,Date) INCLUDE (Debit,Credit,DocumentCode,DocumentType,VRow)` | `VirtualGl` → `IX_VirtualGl_AccCode_Date` | 107.6 MB; 37,907 → 127 reads |
| `01_indexes.sql` | Drop `IDX_VirtualGL_AccCode`, `PatientCode`, `StudentCode`, `GuestCode` | `VirtualGl` | 3 NULL indexes confirmed 0 non-null in 2,004,033 rows; old AccCode index replaced |
| `01_indexes.sql` | `(CustCode,date) INCLUDE (InvTotal)` | `SaleLedger` → `IX_SaleLedger_CustCode_Date` | 16.4 MB; 79,236 → 60 reads |
| `01_indexes.sql` | `(ICode,SaleInvCode) INCLUDE (LooseQty,bonusqty,SalePrice,itemflatdisc,DiscPerc)` | `SaleDetail` → `IX_SaleDetail_ICode_SaleInvCode` | 78.9 MB; replaces `IDX_SaleDetail_Icode` |
| `01_indexes.sql` | `(ICode) INCLUDE (GCode,CurrQty)` | `GodownDetail` → `IX_GodownDetail_ICode` | 0.2 MB |
| `02_statistics.sql` | `UPDATE STATISTICS ... FULLSCAN` on 10 hot tables | SaleLedger, SaleDetail, VirtualGl, StockReport, Purdetail, ItemLog, PurOrderDetail, Item, SRLedger, SRdetail | `logs/02_statistics.log`; all stats now 2026-11-02 |
| `02_statistics.sql` | `DBCC UPDATEUSAGE ... WITH COUNT_ROWS` | database metadata | `logs/02_statistics.log` |
| `03_config.sql` | `optimize for ad hoc workloads = 1` | instance | `value_in_use=1` |
| `03_config.sql` | `cost threshold for parallelism = 25` | instance | `value_in_use=25` |
| `03_config.sql` | tempdb 4 data files: 68 MB + 3 × 64 MB, fixed 64 MB growth | tempdb | `tempdev`, `tempdev2`, `tempdev3`, `tempdev4` |
| `04_procs.sql` | `SP_WayToMoon` returns 0; no `cmd.exe` | stored proc | `xp_cmdshell=0`; proc returns 0 |
| `04_procs.sql` | `SP_StockReport` uses sargable `NOT EXISTS` + date range | stored proc | first run 337 ms; second run 2 ms |
| `04_procs.sql` | `xp_cmdshell = 0` | instance | `value_in_use=0` |
| `05_prefs.sql` | `CheckManualBackupHealthAtStartUp = N` | `SoftwarePreferences` | verified `N` |
| `05_prefs.sql` | `AutoRefreshItemList = N`, time `0` on all groups | `Groups` | verified all groups N/0 |
| `06_fn_getSaleInvTotal.sql` | O(1) lookup of `SaleLedger.InvTotal` + 9-row historic adjustment table | `fn_getSaleInvTotal`, `SaleInvTotalAdjustment` | 1,929 rows 25 ms; 10,000 rows 126 ms; 9 historic rows preserved |
| `07_rebuild.sql` | Rebuild 5 fragmented hot tables at FF80–90 | SaleLedger, ItemLog, Purdetail, PurOrderDetail, Item | fragmentation **0–0.01%**; SaleLedger 581 → **387 MB** |
| `maintenance.sql` | Nightly stats + rebuild only >30% fragmented, >1,000-page indexes | Windows task `Waseela DB Maintenance` | last result **0**; no indexes >30% after rebuild |
| `09_virtualgl_watermark.sql` | Watermark gate + 10-minute safety TTL in front of the incremental accounting/stock rebuilds | `SP_VirtualGL`/`SP_STOCKLEDGER` wrappers, `fn_VirtualGLSourceVersion`, `VirtualGLRefresh`, `StockLedgerRefresh` | `VirtualGL` **2.58 s → 35 ms**; `StockLedger` **30.7 s → 38 ms**; parity exact |
| `Measure-ColdStart.ps1` | ProcMon cold-cache capture + one-shot boot capture path | `Waseela Cold Start Capture` task | first SQL **1.8 s**, Login **4.2 s** in cold-cache run; 33k CLSID registry queries identified |
| `Start-WaseelaPreload.ps1` | Logon preload so cold client load happens before the cashier needs it | `Waseela Preload` task | last result **0**; app at Login ready |
| `WaseelaLauncher.exe` | Native 560×300 splash; starts `abuzar.exe`; forces Login to foreground; single-instance aware | new launcher | splash + foreground Login verified |

**Total database size after changes:** 5,485 MB (4,096 MB data file, 1,389 MB log; **1,381 MB unallocated headroom**). Reserved space is **2,779,688 KB**; `StockLedger` now holds the parity-verified **1,621,864 rows / 239.3 MB**. App working set: **114.9 MB** with Cash Sale open.

---

## 3. Measured before/after

> **Method:** same SQL, same database, `SET STATISTICS IO/TIME ON`. Baseline was captured before indexes; after-state was captured after indexes/statistics. Logical reads are the fair structural metric; elapsed times include SQL Server cache state. The after runs are warm except where noted.

| Probe | Before | After | Improvement |
|---|---:|---:|---:|
| `StockReport` one day (`2025-01-01`) | 28,244 reads; 503 ms; 250 ms CPU | **60 reads; 2 ms; 0 ms CPU** | **471× fewer reads; ~251× faster** |
| `VirtualGl` AccCode=2, Dec-2024 | 37,907 reads; 679 ms; 250 ms CPU | **127 reads; 8 ms; 0 ms CPU** | **298× fewer reads; ~85× faster** |
| `SaleLedger` CustCode=19, Dec-2024 | 79,236 reads; 96 ms; 31 ms CPU | **60 reads; 3 ms; 0 ms CPU** | **1,320× fewer reads; ~32× faster** |
| `fn_getSaleInvTotal`, 1,000 rows | ~625 ms (old function) | **13 ms** | ~48× |
| `fn_getSaleInvTotal`, 1,929 rows | 1.59 s (old daily-sales measurement) | **25 ms** | ~64× |
| `fn_getSaleInvTotal`, 10,000 rows | not measured (extrapolated ≈6.25 s) | **126 ms** | ≈50× extrapolated |
| `fn_getSaleInvTotal`, full table 588,865 rows | **344,047 ms CPU / 358,410 ms elapsed** | O(1) per row; 10k in 126 ms | — |
| `SP_StockReport` first run | old `NOT IN` + 2.9M-row distinct sort (not re-measured) | **337 ms**, inserts 6,062 rows | verified |
| `SP_StockReport` second run | — | **2 ms** (today exists) | verified |
| `SP_WayToMoon` | **49.6–54 ms**, two `cmd.exe` spawns | **0 ms**, no shell | ~50 ms/login |
| Warm start via launcher → Login | 47 s (n=1, human + modal) | **1.83 s** warm | launch path verified |

**Correctness checks:**
- `fn_getSaleInvTotal` 1,000-invoice sample: **0 drift**.
- 9 historic invoices: new function returns `InvTotal + 1.00`, exactly the old output; verified row-by-row.
- Unknown invoice (`-1`) returns `NULL`, matching the old function.
- `SP_StockReport` inserted today's 6,062 rows; second execution skipped in 2 ms.
- `SP_WayToMoon` return code **0** with `xp_cmdshell=0`.
- `xp_cmdshell` `value_in_use = 0`; `CheckManualBackupHealthAtStartUp = N`; `AutoFiscalizeOnPosting = Y` unchanged.

### Fragmentation / size after rebuild

| Table | Fragmentation before | Fragmentation after | Density before | Density after | Size after |
|---|---:|---:|---:|---:|---:|
| `SaleLedger` | 67.9% | **0.0%** | 57.2% | **85.96%** | 386.6 MB clustered (was 581.3 MB) |
| `ItemLog` | 99.1% | **0.01%** | 62.0% | **94.09%** | 73.4 MB clustered |
| `Purdetail` | 76.0% | **0.0%** | 61.4% | **90.18%** | 81.3 MB clustered |
| `PurOrderDetail` | 65.3% | **0.0%** | 63.7% | **92.49%** | 56.4 MB clustered |
| `Item` | 94.4% | **0.0%** | 58.7% | **89.12%** | 21.3 MB clustered |

> **Note:** the first `07_rebuild.sql` run rebuilt all five tables successfully; its inline fragmentation query then failed because `sys.dm_db_index_physical_stats` is not parseable inside a compatibility-80 database. The check was moved to `07_verify_fragmentation.sql`, run from `master`; that script passed with exit 0. The rebuilds themselves are confirmed by the before/after numbers above.

- SaleLedger clustered page count: **74,255 → 49,400**.
- Reserved space: **2,914,448 KB → 2,377,640 KB** (~525 MB freed).
- Nightly task `Waseela DB Maintenance`: daily **02:00**, Windows auth (`sqlcmd -E`), last result **0**, next run **2026-11-03 02:00**. It refreshes statistics and rebuilds only indexes >30% fragmented with >1,000 pages. The test run rebuilt 8 remaining indexes, then a second run found **none** above the threshold.

---

### Watermark parity — `SP_VirtualGL` / `SP_STOCKLEDGER`

The sub-procedures were already incremental (`DocumentCode NOT IN (SELECT … FROM VirtualGL)`); the fix is a **gate** that skips the whole incremental pass when no new source document exists, with a **10-minute TTL** to catch edits/deletes.

| Path | Original full run | Wrapper first run | Wrapper second run | Rows / totals / checksum |
|---|---:|---:|---:|---|
| `SP_VirtualGL` — isolated copy | **47.9 s** | **47.9 s** | **94 ms** | 2,004,033 / debit 781,873,642 / credit 781,873,642 / checksum 34,612,686 |
| `SP_VirtualGL` — live | — | **2.58 s** (incremental, no new docs) | **35 ms** | same as above |
| `SP_STOCKLEDGER` — isolated copy | **26.85 s** | **26.05 s** | **44 ms** | 1,621,864 / qty 21,600,364 / bonus 21,861 / checksum 496,674,084 |
| `SP_STOCKLEDGER` — live | — | **30.7 s** | **38 ms** | same as above |

- The first wrapper run and the original `_Full` produced **identical counts, sums and checksums** in both cases.
- Source-version test on the copy with a temporary `SaleLedger` row: **979582005 → 267061159 → 979582005** after removal; the gate detects new source documents.
- Live state: `VirtualGLRefresh` A = 979582005; `StockLedgerRefresh` 1 = 979582005.
- On SQL Server 2022, the same warm skip is **67 ms** for `SP_VirtualGL` and **67 ms** for `SP_STOCKLEDGER`.
- The wrappers are live; the original procs remain as `SP_VirtualGL_Full` / `SP_STOCKLEDGER_Full` for rollback/parity.

### Cold-start diagnostic

- **Cold-cache capture** (RAMMap standby clear + ProcMon): process start **05:56:50.442**, first SQL **05:56:52.240** (**1.8 s**), Login window **~4.2 s** after launch.
- **Warm capture**: Login ~**3.5 s**.
- Pre-SQL ProcMon operations: **33,371 RegQueryKey**, **21,609 RegEnumKey**, **16,867 RegOpenKey**, **27,365 under HKCR\WOW6432Node\CLSID**, **1,104 ReadFile**, **64 Load Image**. No `Sleep`, no UNC/SMB timeout, no long SQL wait.
- Conclusion: the original **14.1 s** is not a fixed code delay; it is cold client/COM-registry enumeration plus first-boot cache/AV effects. The launcher splash now covers it, and `Waseela Preload` starts the client at logon so the cold load happens before the cashier needs it.
- A true **reboot** capture is prepared as the one-shot `Waseela Cold Start Capture` task, now **enabled** per the owner's decision. It runs 45 s after the next logon, captures `cold-boot-*`, then disables itself and re-enables `Waseela Preload`. The owner will perform the reboot; a reboot would terminate this agent session.

## 4. Application verification

- Backup: `RESTORE VERIFYONLY` passed.
- App started from `C:\Projects\Abuzar\deploy\Application\abuzar.exe` and from `WaseelaLauncher.exe`.
- Login: **ADMIN** / existing password (not printed here).
- Main window: multiple successful logins; after the final clean restart, `WASEELA ABUZAR V2 01.01.2022 : ADMIN : 02/11/26 12:50:22` (main frame), running on `.\SQLEXPRESS2022`, **91.8 MB**, one Waseela session.
- Cash Sale opened with real item rows and stock values on SQL 2022 (`impl-24-sql2022-cashsale.png`).
- A report window (`[Report: Daily Sales Summary]`) also opened successfully on SQL 2022; the report toolbar loaded.
- Buffer pool on the new instance: **1,409 MB** (Express 2022 cap; was 793 MB on 2008 R2).
- The old 2008 R2 database is **READ_ONLY**; its instance remains online as the rollback.
- **Return-window verification:** the earlier `w_salereturn` error (`R0002 — Null object reference at line 36 in ue_postopen`) occurred once on the stale pre-switch instance. On the fresh SQL 2022 instance the return window opened successfully as **`[Open Cash Sale Return]`**, and the rebuild's targeted smoke opens all five sale-return windows **5/5 with 0 failures**. It is therefore a transient stale-session issue, not a persistent SQL 2022 regression.
- Screenshots:
  - `deploy\screenshots\impl-05-splash.png` — launcher splash.
  - `deploy\screenshots\impl-07-login-foreground.png` — Login foreground.
  - `deploy\screenshots\impl-09-main-after-launcher.png` — main window.
  - `deploy\screenshots\impl-04-cashsale.png` — Cash Sale with stock data.
  - `deploy\screenshots\impl-10-final-main.png` — final main window.
  - `deploy\screenshots\impl-12-final-login.png` — final login after maintenance.
  - `deploy\screenshots\impl-13-final-cashsale.png` — final Cash Sale after rebuild/maintenance.
  - `deploy\screenshots\impl-16-compat100-main.png` — main window after live compatibility-100 promotion.
  - `deploy\screenshots\impl-17-compat100-cashsale.png` — Cash Sale under compatibility 100.
  - `deploy\screenshots\impl-18-hardened-login.png` — login after ACL/SQL-login hardening.
  - `deploy\screenshots\impl-19-hardened-cashsale.png` — Cash Sale after ACL/SQL-login hardening.
  - `deploy\screenshots\impl-20-final-cashsale.png` — definitive final state, after compatibility 100, FK/ACL hardening, and fiscalization fix.
  - `deploy\screenshots\impl-23-sql2022-login.png` — first SQL 2022 login.
  - `deploy\screenshots\impl-24-sql2022-cashsale.png` — **Cash Sale with real item rows on SQL 2022** (definitive SQL 2022 screenshot).
  - `deploy\screenshots\impl-25-sql2022-relogin.png` — main window after the SQL 2022 alias switch.
- No "Database Problem", no "Backup Information" dialog, no license gate.
- Final process: `WASEELA ABUZAR V2 01.01.2022 : ADMIN : 02/11/26 05:33:45 - [Cash Sale]`, responding.

### Additional completion pass

| Item | Result | Evidence |
|---|---|---|
| **Compatibility 100** | Restored `FazalDinPP19_Compat100` from the post-implementation backup, set level 100, and re-ran all probes: Q1/Q2/Q3 totals matched live, `fn_getSaleInvTotal` **0 drift**, `SP_StockReport` **4 ms**, `SP_WayToMoon` **0**. Live was then promoted to **100**; login and Cash Sale verified. The test copy was dropped after validation. | `logs/compat100-validation.txt`, `logs/live-fk-validate.log`, screenshots 16/17 |
| **FK validation** | `DBCC CHECKCONSTRAINTS` found one pre-existing **trusted** orphan: `Purledger.TaxCategoryCode='87'` has no `TaxCategory` parent. The 86 untrusted FKs all validated with **0 orphans** and were trusted. The one violated FK was marked **untrusted and enabled** (future inserts still enforced); the orphan row was left in place. Final: **1,716 trusted / 1 untrusted**. | `logs/live-fk-validate.log`, `logs/live-fk-final-2.txt` |
| **ACL hardening** | `deploy\Application`: `Authenticated Users` modify removed; `Users` = Read & Execute. `C:\waseela_temp`: `Users` = Modify only. `Script.mdb` = read-only. `BUILTIN\Users` SQL login = **DENY CONNECT**. Admin Windows auth and the app login still work. | ACL verification output, screenshot 18 |
| **Fiscalization** | Root cause was **missing `ATL71.DLL`** in `FiscalizationApp`. Copied the DLL from `deploy\Application`; the listener now binds **192.168.18.39:9111**; `FiscalizationMachine=DESKTOP-NQ9K8T3`; logon task `Waseela Fiscalization Listener` result **0**; `AutoFiscalizeOnPosting=Y` retained. TCP path verified; no live sale was posted, so ledger data was not changed. | `logs/fiscalization-pref.txt`, `logs/fiscalization-start.log`, listener output |

---

## 5. Rollback

**Fastest and safest:** restore the verified backup.

```sql
-- Stop abuzar.exe first.
RESTORE DATABASE [FazalDinPP19DataBaseV2]
FROM DISK = N'C:\Projects\Abuzar\deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak'
WITH REPLACE, RECOVERY;
```

**Object-level rollback:** `deploy\impl\99_rollback.sql` reverts the stored procedures, function, indexes, preference, and instance settings. It was syntax-validated with `SET NOEXEC ON` (`logs\validate-rollback.log`, exit 0). The data file is left at 4 GB because shrinking after index creation is not recommended; the script restores 10% growth.

---

## 6. What is still open — and why

These are the remaining items that require a missing dependency, a business decision, or a client rebuild. Everything else in the P0/P1 database/config scope is implemented.

| Item | Status | What is needed |
|---|---|---|
| **`sa` / plaintext passwords** | The client hardcodes `sa` and stores plaintext passwords. Rotating either breaks the compiled client. | Least-privilege login, Argon2id, client rebuild. |
| **App-side PBL fixes** | Source lost in the fire. The decompiled artifacts are the source of truth; the Rust/Tauri rebuild is the only executable path. | Continue the rebuild (98.4% windows, 99.3% DataWindow SQL, 20/20 tests). |
| **SQL Server Standard** | **Not required now.** Free 2022 Express is live with a 1,409 MB buffer; the database is 5.5 GB of the 10 GB cap. | Buy Standard only if the DB approaches ~8 GB or buffer contention appears. |
| **True reboot cold capture** | Cold-cache/ProcMon is complete; the one-shot task is **enabled**. | Owner reboots; the capture runs 45 s after logon and self-disables. |
| **`SP_CleanUp_Bad_Session` 32 ms** | Owner chose to leave it. | No action. |
| **`StockReport` purge** | Owner chose to keep all history. | No action; the clustered index keeps queries fast. |
| **`Purledger` orphan** | Owner chose to leave the row. | FK stays untrusted/enabled; no action. |
| **`w_salereturn` error** | Observed once on the stale pre-switch instance; after restart `[Open Cash Sale Return]` opened successfully; rebuild smoke 5/5. | No action; monitor. |

---

## 7. Remaining high-value work, in order

1. **Continue the Rust/Tauri rebuild** — the only path that can change compiled-client behavior: 98.4% windows, 99.3% DataWindow SQL, 20/20 tests, sale-return windows 5/5.
2. **Report service / read-only lighthouse** — move the top reports and exports first; do not big-bang.
3. **Code signing for redistribution** — the self-signed certificate works locally; import `WaseelaCodeSigning.cer` once on each additional PC, or buy a publicly trusted certificate.
4. **Credential rotation with the rebuild** — `sa`/plaintext cannot be changed inside the compiled PBDs; do it in the rebuilt client.
5. **Revisit SQL Standard** only if the Express 10 GB / 1.41 GB caps bind.

---

## 8. File index

| Path | Purpose |
|---|---|
| `deploy\impl\01_indexes.sql` | Pre-size + hot indexes |
| `deploy\impl\02_statistics.sql` | Statistics + UPDATEUSAGE |
| `deploy\impl\03_config.sql` | ad-hoc/CTFP/tempdb |
| `deploy\impl\04_procs.sql` | `SP_WayToMoon`, `SP_StockReport`, `xp_cmdshell=0` |
| `deploy\impl\05_prefs.sql` | backup-health/item-refresh prefs |
| `deploy\impl\06_fn_getSaleInvTotal.sql` | O(1) function + 9-row adjustment |
| `deploy\impl\07_rebuild.sql` | Rebuild five fragmented hot tables |
| `deploy\impl\07_verify_fragmentation.sql` | Fragmentation verification (run from master) |
| `deploy\impl\08_fk_validate.sql` | Targeted untrusted-FK validation/trust |
| `deploy\impl\09_virtualgl_watermark.sql` | `SP_VirtualGL`/`SP_STOCKLEDGER` watermark gate |
| `deploy\impl\10_sql2022_restore.sql` | Restore into `SQLEXPRESS2022` |
| `deploy\impl\10_sql2022_migrate.sql` | Compat 160, compression, Query Store, config, probes |
| `deploy\impl\10_sql2022_switch.ps1` | Alias switch + maintenance retarget + old DB read-only |
| `deploy\impl\10_sql2022_rollback.ps1` | Alias rollback + old DB read-write + task retarget |
| `deploy\impl\Start-Fiscalization.ps1` | Logon fiscalization listener starter |
| `deploy\impl\Start-WaseelaPreload.ps1` | Logon Waseela preload |
| `deploy\impl\Measure-ColdStart.ps1` | ProcMon cold-cache/boot capture |
| `deploy\impl\maintenance.sql` | Nightly stats + conditional index rebuild |
| `deploy\impl\99_rollback.sql` | Object-level rollback |
| `deploy\impl\99_rollback.ps1` | ACL/fiscalization/preload rollback |
| `deploy\impl\validate_rollback.sql` | `SET NOEXEC ON` syntax validation |
| `deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak` | Verified original full backup |
| `deploy\impl\backup\FazalDinPP19DataBaseV2_pre_sql2022.bak` | Verified pre-SQL-2022 backup (2.65 GB) |
| `deploy\impl\WaseelaCodeSigning.cer` | Self-signed code-signing certificate (public) |
| `deploy\SQL2022-MIGRATION.md` | SQL 2022 runbook, results and rollback |
| `deploy\DECISIONS.md` | Owner decision log |
| `deploy\impl\logs\` | Baseline/after query logs, index/proc logs |
| `deploy\impl\cold\` | ProcMon PML/CSV, cold/warm timelines |
| `deploy\impl\tools\` | Procmon64.exe, RAMMap64.exe |
| `deploy\impl\launcher\WaseelaLauncher.cs` | Launcher source |
| `deploy\Application\WaseelaLauncher.exe` | Compiled launcher |
| `deploy\bench\Measure-Queries.ps1` | Repeatable query bench |
| `deploy\bench\Measure-Startup.ps1` | Repeatable startup bench |
| `deploy\bench\results\` | Latest results, including `sql2022-live-queries.txt` |
| `deploy\screenshots\impl-24-sql2022-cashsale.png` | Cash Sale with real rows on SQL 2022 |
| `deploy\PERFORMANCE-ROADMAP.md` | Full 10-analyst roadmap |

---

## 9. Reproduce

```powershell
# Query bench
powershell -ExecutionPolicy Bypass -File C:\Projects\Abuzar\deploy\bench\Measure-Queries.ps1 -Label after

# Startup bench (stops/restarts the app; leaves it at Login)
powershell -ExecutionPolicy Bypass -File C:\Projects\Abuzar\deploy\bench\Measure-Startup.ps1

# Start with the splash
Start-Process C:\Projects\Abuzar\deploy\Application\WaseelaLauncher.exe `
  -WorkingDirectory C:\Projects\Abuzar\deploy\Application
```

### Final acceptance checklist

| Check | Result | Detail |
|---|---|---|
| Pre/post implementation backups | **PASS** | 3.02 GB (original) / 2.65 GB (pre-SQL-2022), both `RESTORE VERIFYONLY` clean |
| Live SQL Server | **PASS** | `DESKTOP-NQ9K8T3\SQLEXPRESS2022`, **16.0.1000.6 Express** |
| Live compatibility level | **PASS** | **160** |
| Query Store | **PASS** | **ON** |
| Page compression | **PASS** | StockReport, VirtualGl, SaleLedger, SaleDetail, StockLedger, ItemLog, Purdetail, PurOrderDetail |
| Buffer pool | **PASS** | **1,409 MB** (was 793 MB) |
| Old 2008 R2 database | **PASS** | **READ_ONLY** write-divergence guard; rollback flips to READ_WRITE |
| `xp_cmdshell` | **PASS** | **0** |
| `FiscalizationMachine` | **PASS** | `DESKTOP-NQ9K8T3` |
| `AutoFiscalizeOnPosting` | **PASS** | `Y` retained |
| Fiscalization listener | **PASS** | `192.168.18.39:9111` listening |
| Fiscalization logon task | **PASS** | `Waseela Fiscalization Listener`, result **0** |
| Maintenance task | **PASS** | `Waseela DB Maintenance` retargeted to `SQLEXPRESS2022`, result **0** |
| App on new instance | **PASS** | `Waseela (2)` sessions on `SQLEXPRESS2022`; zero Waseela sessions on the old instance |
| Fiscalization on new instance | **PASS** | restarted after the alias switch; sessions on `SQLEXPRESS2022`; 9111 listening |
| `BUILTIN\Users` SQL login | **PASS** | `DENY CONNECT` |
| App folder ACL | **PASS** | `Users` Read & Execute only |
| Temp folder ACL | **PASS** | `Users` Modify only |
| `Script.mdb` | **PASS** | read-only |
| FK trust state | **PASS** | **1,716 trusted / 1 untrusted** (real `Purledger` orphan) |
| `StockReport` clustered index | **PASS** | `CIX_StockReport` |
| `fn_getSaleInvTotal` sample | **PASS** | **0 drift** |
| Today's `StockReport` rows | **PASS** | **6,062** |
| `SP_VirtualGL` watermark | **PASS** | parity exact; **2.58 s → 35 ms** on live |
| `SP_STOCKLEDGER` watermark | **PASS** | parity exact; **30.7 s → 38 ms** on live |
| Source-version change test | **PASS** | 979582005 → 267061159 → 979582005 |
| Cold-cache diagnostic | **PASS** | first SQL **1.8 s**, Login **4.2 s**; 33k CLSID queries |
| `Waseela Preload` | **PASS** | logon task, result **0** |
| `Waseela Cold Start Capture` | **PASS** | enabled; runs 45 s after the owner's next reboot, then self-disables |
| Launcher + desktop shortcut | **PASS** | `WaseelaLauncher.exe`, `Waseela.lnk` |
| Rollback | **PASS** | `99_rollback.sql`, `99_rollback.ps1`, both syntax-validated |
| Live app | **PASS** | `WASEELA ABUZAR V2 01.01.2022 : ADMIN : 02/11/26 12:50:22` main frame, responding, **91.8 MB**, one Waseela session on `SQLEXPRESS2022` |
| Cash Sale data | **PASS** | real item rows and stock values on SQL 2022 (`impl-24-sql2022-cashsale.png`) |
| Cash Sale Return | **PASS** | `[Open Cash Sale Return]` opened successfully after restart; rebuild smoke 5/5 |
| Final screenshots | **PASS** | `impl-24-sql2022-cashsale.png`, `impl-30-sql2022-clean-login.png` |

**Bottom line:** the live app now runs on **free, production-licensed SQL Server 2022 Express** with compatibility 160, Query Store, page compression, a 1,409 MB buffer pool, and exact parity on every probe. The watermark, fiscalization, FK, ACL, rebuild and maintenance layers are verified; the cold-cache diagnostic and logon preload are in place. The remaining blockers are the lost PowerBuilder source (the Rust/Tauri rebuild is the path), the paid SQL Standard edition only if the 10 GB/1.41 GB Express caps bind, and the one-time true-reboot capture (task enabled for the owner's reboot).

---

## 10. Owner decisions and the SQL Server 2022 Express path (2026-11-02)

The owner answered the open questions. The full decision log is in
`deploy\DECISIONS.md`.

| Topic | Decision |
|---|---|
| Cold capture | Owner will reboot; `Waseela Cold Start Capture` is enabled and self-disables after the run. |
| PowerBuilder source | Lost in a fire. No source exists. The recovered artifacts are the source of truth; the executable path is the Rust/Tauri rebuild. |
| SQL Server | **SQL Server 2022 Express installed and live** (free, production-legal; not Developer, which is dev/test only). |
| Code signing | Free self-signed certificate is acceptable; users can grant one-time trust. |
| `StockReport` | Keep everything; no purge. |
| `Purledger` orphan | Leave the row; FK stays untrusted. |
| `SP_CleanUp_Bad_Session` | Leave it. |

### SQL Server 2022 Express

Microsoft documentation confirms:

- **Express 2022 is free and licensed for production** (10 GB database, 1,410 MB buffer pool, 1 CPU socket / 4 cores).
- **Developer 2022 is free but explicitly not for production.**
- Express 2022 includes **columnstore, data compression, Query Store, scalar UDF inlining, interleaved execution, and compatibility level 160**.

The migration is **installed and live** as a side-by-side instance,
`DESKTOP-NQ9K8T3\SQLEXPRESS2022` (16.0.1000.6, Express Edition). The 2008 R2
instance remains online as the rollback. The exact Microsoft installer
(SHA-256 `e2b8e8aa…750bb1`) was downloaded and signature-verified. The database
was restored from `FazalDinPP19DataBaseV2_pre_sql2022.bak`
(2,850,413,056 bytes, `RESTORE VERIFYONLY` clean).

**Live result:**

| Check | Result |
|---|---|
| Restore | 347,922 pages in **16.1 s**; row counts exact |
| Compatibility | **160** |
| Query Store | **ON** |
| Page compression | StockReport, VirtualGl, SaleLedger, SaleDetail, StockLedger, ItemLog, Purdetail, PurOrderDetail |
| Reserved space | 2,779,688 KB → **1,295,880 KB** (~1.4 GB smaller) |
| Buffer pool | **1,409 MB** (was 793 MB) |
| `StockReport` one day | **26 reads / 2 ms** (2008 R2: 28,244 / 503 ms) |
| `VirtualGl` account-month | **134 reads / 9 ms** (2008 R2: 37,907 / 679 ms) |
| `SaleLedger` customer-month | **60 reads / 4 ms** (2008 R2: 79,236 / 96 ms) |
| `fn_getSaleInvTotal` | 1,000-row sample **0 drift**; full checksums exact |
| Watermark skip | `SP_VirtualGL` **67 ms**, `SP_STOCKLEDGER` **67 ms** |
| App | logged in on the new instance; **Cash Sale with real item rows**; `[Open Cash Sale Return]` opens successfully |
| Fiscalization | restarted on the new instance; **9111** listening |
| Maintenance | retargeted to `SQLEXPRESS2022`; result **0** |
| Old database | **READ_ONLY**; rollback script flips it to READ_WRITE |

The new instance also has the same ad-hoc/CTFP/tempdb tuning
(`optimize for ad hoc workloads=1`, `cost threshold=25`, 4 tempdb files) and
`xp_cmdshell=0`. The old instance is not stopped; the cutover is reversible by
changing the client alias and restoring the old database to READ_WRITE.

Scripts:

| File | Purpose |
|---|---|
| `impl\10_sql2022_restore.sql` | Restore the verified backup into `SQLEXPRESS2022` |
| `impl\10_sql2022_migrate.sql` | `sa`, compat 160, page compression, statistics, Query Store, probes |
| `impl\10_sql2022_switch.ps1` | Point the client alias at `SQLEXPRESS2022` |
| `impl\10_sql2022_rollback.ps1` | Point the alias back to the 2008 R2 instance |
| `deploy\SQL2022-MIGRATION.md` | Full runbook, verification gates and rollback |

### Code signing

- Certificate: `CN=Waseela ERP, O=Abuzar Consultancy, C=PK`
- Thumbprint: `4CB4FD989CEF1FBB78B44BECD412601AD178351F`
- Valid until: **2036-11-02**
- Exported public certificate: `deploy\impl\WaseelaCodeSigning.cer`
- Installed in the machine's Trusted Root.
- `deploy\Application\WaseelaLauncher.exe` is signed and `Get-AuthenticodeSignature` returns **Valid**.

### Rebuild status (reverse-engineering path)

`C:\Projects\Abuzar\rebuild` already executes the decompiled application:

- **2,030 of 2,062 windows** open without a runtime error (98.4%).
- **8,607 of 8,666 DataWindow retrieve statements** run against PostgreSQL 17 in CI (99.3%).
- **1,846 of 1,862 embedded statements** run (99.1%).
- **510 of 638 translated procedures** run with neutral arguments (79.9%).
- **20 of 20 rebuild unit tests pass** (`node --test web/tests`), covering the PowerScript parser, interpreter, DataWindow expressions, crosstab, barcode, CSV/XLSX/HTML export, and SQL translation.

This is the concrete answer to “why are you not reverse engineering”: the
reverse engineering is done and the rebuild is 98%+ on the UI/runtime layer.
The remaining work is parity hardening and the SQL Server/PostgreSQL decision,
not discovery.
