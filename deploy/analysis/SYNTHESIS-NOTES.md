# Synthesis notes (working file)

## Verified environment facts (2026-11-02)

- Host: HP Z440, Intel Xeon E5-2695 v4, 18C/36T, 32 GB RAM, C: 240 GB Intel SSD (64 GB free), 1 TB HDD (warning).
- SQL Server: 2008 R2 SP2 Express (10.50.4000.0, x64). Express edition: 1 socket / 4 cores, ~1 GB buffer pool, 10 GB DB cap.
- DB: `FazalDinPP19DataBaseV2`, data 3,058 MB + log 493 MB. Compatibility **80**. SIMPLE recovery. `AUTO_CLOSE`/`AUTO_SHRINK` off. RCSI off. Page verify TORN_PAGE_DETECTION.
- Config: MAXDOP 0, cost threshold 5, max server memory 2147483647 (Express cap applies), optimize for ad hoc 0, CLR 0, xp_cmdshell 1.
- App: PID 8796, start 01:21:33, working set ~144 MB, private ~125 MB, 1 OS thread, low idle CPU.
- DB counts confirmed: 505/752 empty tables; 30 tables >1k rows; 2 customers; 9 users; 28,966 items; 588,865 sale invoices, all `SaleTypeCode=1`; 0 patients/students/guests/loyalty.
- Startup: successful run 01:21:33 -> `w_main` title 01:22:20 = 47 s (includes human login + Backup Information modal). Startup SQL measured at 77.4 ms across 119 statements in the traced failed run. The 47 s run was not traced.
- Trace: 316 events, 41.6 s; 77 RPC completed, 42 batch completed, 73 transaction events; 2 errors (15281 in `SP_WayToMoon`). Trace omitted Reads/Writes/CPU columns.
- `SP_WayToMoon` succeeds in 53 ms via two `cmd.exe dir` calls (25 + 28 ms). `SP_CleanUp_Bad_Session` ~32.5 ms per launch.
- `VirtualGl` is a 2M-row heap; `IDX_VirtualGL_AccCode` exists but plan does seek + RID lookup; covering `Debit,Credit` is a quick win.
- 30 statistics on the 7 >100k-row tables predate 2018; 72 stats date to 2004.
- Data file has ~176 MB free; 10% autogrowth (~306 MB).

## Key findings from completed analysts

### Architecture (analyst 8)
- "Rust/Tauri fast" is real for shell/startup/memory (10–20x), 5–10x window open, 2–5x client report layout/Excel; large-report SQL and month-end posting stay ~1x unless DB is fixed.
- 1,145 report windows (55.5%), 4,746 DWs, 108k lines; 839 `w_arg*` windows; 2,275 `sprnt*` DWs; 2,378 of 6,947 parseable DWs share 660 identical SQL clusters; largest are 154/110 copies.
- 1,334 distinct `Open()` targets; 728 windows never opened by literal name; 36 `_old`/`_copy`/test names.
- Business is narrow: 588,865 invoices, 2 customers, 9 users, zero verticals.
- 505/752 empty tables; 150–200 tables cover core.
- MVP: 300–400 windows (15–20%), 500–700 DWs (6–8%), 150–200k lines (26–35%). Focused MVP 3–6 months, $80–160k; operational core 9–12 months, $200–330k; full parity 24–36 months, $0.8–2.0M.
- Recommended: optimize PB/SQL for 4–6 weeks, then strangler Tauri lighthouse. Keep SQL Server; use tiberius-ng (sqlx MSSQL is pending rewrite). Defer PostgreSQL.
- Correction: SQL 2008 R2 max compat is 100. "Compat 160" requires upgrading the engine to SQL Server 2019/2022. Immediate safe test is 80→100 on a copy.
- `tiberius-ng` 0.13.1 is real/maintained; upstream `tiberius` 0.13 has TLS advisories. `sqlx` MSSQL support is explicitly "pending a full rewrite" (pre-0.7 support removed), so not production-grade.
- Tauri 2 stable, not 3 alpha. WebView2. React/TanStack. Rust band report engine. SQLite cache/outbox.
- Scope cuts: 265 barcode functions (42k lines) -> label templates; 2,275 print layouts -> 40–60 base layouts; 839 arg windows -> one metadata dialog; 222 dropdown DWs -> cached lookup; dw2xls/Crystal -> rust_xlsxwriter/report engine.
- Effort/team: 2 Rust, 2 frontend, 1 PB domain/BA, 1 QA, 0.5 design, 0.5 DevOps; 3–6 month MVP.

### Measurement (analyst 10)
- Startup SQL is not the bottleneck: 77.4 ms across 119 statements; 12.49 s gap is human login; 10.33 s pre-SQL gap is PB load/connect (unmeasured); 47 s run includes login + backup modal.
- Trace lacks Reads/Writes/CPU; re-trace needed.
- App is effectively single-threaded: 1 OS thread; any query/report freezes UI.
- Buffer pool 713 MB used / 795 MB committed vs 3.06 GB data; big scans hit disk.
- 30 stats on 7 big tables older than 2018; 72 stats from 2004.
- `IDX_VirtualGL_AccCode` does seek + RID lookup; covering INCLUDE is high ROI.
- Data file 176 MB free; 10% autogrowth can stall.
- 5,115 `SetTransObject`, 4,090 `.retrieve(`, 8,779 `MessageBox` sites.
- `w_main` sets title before security/menu/timer work -> "visible" != "ready".
- No cold/module/grid/report/export/print/backup/multi-user timings exist.
- SLO targets: warm start -> login ≤1.5 s (P1), login -> main ≤1 s, sale open ≤1.5 s, item/customer ≤300 ms, grid 10k ≤100 ms, report 10k ≤2 s, Excel 10k ≤5 s, memory ≤300 MB.
- Top 5: measure for a week; stats + top report queries + VirtualGl covering; remove startup friction (dialogs/auto-login/conditional checks); stop full retrieves on UI thread (paging/aggregation/streaming Excel); test compat 100 on a copy.
- No source means no PB tracing in the deployed p-code copy; instrumentation spec is for the next build.

## Contradictions / corrections to apply
- "Compat 160" only after engine upgrade; on 2008 R2 test 100.
- `sqlx` does have an `mssql` feature but it is explicitly pending a full rewrite; phrase as "not production-grade" rather than "cannot".
- The 47 s startup is n=1 and includes human typing/dialogs; do not present it as pure app latency.
- The 12.49 s "login wait" is inferred human typing; label it as such.

### Security / startup waste (analyst 9)
- Client connects as `sa`; hardcoded credentials in `w_login1.pbs:95,101,185,210` and `f_get_database_status.pbs:20-22`; 4 live `sa` sessions; password recoverable from PBDs.
- `xp_cmdshell=1`; `SP_WayToMoon` concatenates input into `cmd.exe`; measured 49.6 ms/call, 496 ms for 10 calls; `xp_fileexist` 0.6 ms/call. Replacing it saves ~48 ms/login and removes RCE.
- `Script.mdb` is a writable 7,968-statement migration channel run as `sa`; row 5456 creates `SP_WayToMoon`, row 7858 uses `OPENROWSET`; 317 DROP, 2,876 ALTER; `Authenticated Users: Modify`.
- `RESTORE HEADERONLY` ×3 on startup for the cosmetic backup dialog: 36–62 ms each, 110–190 ms total; replace with `msdb.dbo.backupset` or async.
- Licence check = 6 round trips + write on startup and every sale/purchase `ue_postopen`; 10–60 ms/startup, 2–10 ms/window; DB row is the trust anchor and is writable.
- `w_administrator_key` drops `SysTextCatalog` (licence reset backdoor).
- `Users.Password` plaintext; 9 users, 8/9 ≤3 chars; client-side compare; no lockout. `SpecialRight.RightPwd`, SMTP/SMS/payment API secrets also plaintext.
- 106 dynamic-SQL procs, 0 `sp_executesql`; 74 take server/db/owner and concatenate; `SP_MyExecuteLocal`, `SP_Get_ResultSet_From_Excel` (`OPENROWSET`), `SP_WaseelaMini_*`, `SP_WayToMoon` are injection gadgets.
- `Application`, `Backup`, `AutoBackup`, `Junk`, `C:\waseela_temp` writable by `Authenticated Users`; `BUILTIN\Users` is a SQL login; 4 backups 11.26 GB readable by `Users`; MDF/LDF writable.
- `abuzar.exe`/`abuzar.ext` unsigned; `.ext` duplicate; p-code decompilable; install dir writable -> binary replacement.
- SQL 2008 R2 + Windows 11; mixed mode; ForceEncryption=0; no audit; SQL Browser exposed.
- Secure+fast target: Authenticode + Ed25519 manifest, Ed25519 licence file (1–3 ms, no DB), Windows auth/least privilege, one connection, `sp_getapplock` for session limit, async backup/update checks. ~15–65 ms security work vs ~175–320 ms now.
- Top 5: disable xp_cmdshell/replace DLL check; fix ACLs; move licence off DB writes; move backup header off startup; Argon2id + server-side verify.

### Startup / login (analyst 1)
- **Biggest finding: 14.1 s zero-SQL wait before the first SQL connection.** Process start 01:21:33 -> first session 01:21:47.130. Whole 17-min session used 11.9 s CPU, read 115 MB. Cause not proven: Sleep / UNC/SMB timeout / audio / PBVM+PBD load / AV. Measure with ProcMon/ETW/API hook first; worth more than all SQL tuning.
- No pre-login splash. `w_logo` opens **after** `w_login1`; the 14 s is a blank screen. Add a native splash/preloader.
- Startup SQL is tiny: 85 app events, **64 ms** busy; 143 ms pre-login wall; 12.49 s is the human typing at login.
- 7 separate connections in one startup (`sp_oledb_ro_usrname` 7×, ~10–13 ms each). Keep one `sqlca`.
- `SP_CleanUp_Bad_Session` 32.5 ms/start (4 correlated subqueries over sysprocesses/sysdatabases).
- Migration DDL every start (`f_firsttime_script`, `f_firsttimewks_limit`) 8 events / 13.3 ms; schema-version gate.
- `f_firsttimelic` runs a `SaleLedger` aggregate but uses 12 logical reads / 0 ms; result only used if `systextcatalog` missing; 5.1 ms no-op `CREATE TABLE`.
- Licence check writes every login (`f_islicenseexpire` 5 queries + update/commit 1.85 ms).
- `SP_WayToMoon` 50–54 ms/login; trace errors 15281; then captured run ended.
- **No runtime reference to `Script.mdb` found** (no string in EXE; only `Data.mdb` in `w_access.pbs:28`); `Sequence` is read from SQL. Treat `Script.mdb` as a deployment/migration artifact, not a startup cost. Security risk remains only if a migration tool reads it.
- Backup: `w_startup`/`w_backupinfo` are not in the recovered Open path; observed dialog trigger outside recovered PBL. `f_getbackupinfo` does 3–4 RT per device × 3 devices; RESTORE fails (wrong device names/passwords), shows N/A. `w_startup.open` runs it even with 0 startup-task rows.
- `d_security` retrieved **twice** (A and W), not three times; third is dead code in `w_main.wf_initsecurityapp`. `m_mainmenu.mf_initsecurityapp` does not retrieve.
- Menu rights loop: 313 rows, 719 menu items, ~2,026 comma-string parses (`mf_findindex`); 20–100 ms [hypothesis].
- `wf_settimer` retrieves 17 columns + 2 DDDW for 2 values; 5–20 ms.
- `f_stringpreferences` linear search over 1,308 rows; called from `w_main` and many windows.
- Item cache `f_refreshitemlist`: 28,966 rows, 389 ms SQL / 4,455 reads; may load before first screen; 400–2,000 ms.
- `w_main.open` title query is redundant (login already has username); 0.3–4 ms.
- F5 at login runs `DBCC CHECKDB` (`w_login1.pbs:335-337`); can block minutes.
- Target: cold log-in interactive 4–6 s optimized PB (from ~14 s), login->main 0.5–1.0 s, end-to-end 5–7 s; Rust <2 s.
- Top actions: find/remove 14 s wait; native splash/preloader; backup check off startup; 1 connection + bootstrap proc; delete SP_WayToMoon; cache rights/prefs; lazy item cache; prune PBD list (`sprnt*` 150 MB not needed to log in).

### Reports / print / export (analyst 6)
- Report PBDs total **281.6 MB, 40% of the 701 MB client**: `reports.pbd` 20.4MB/704 windows, `reportformat` 4.1MB/287, `reports_cust` 4.5MB/145, `sprnt*` 150.1MB/2,275 layouts, `reportviewer` 4.2MB, `psrviewer` 1.5MB.
- **423 unique logical reports**; dispatched by **752 hard-coded `case` branches** in ten `f_retrieve_report*.pbs` (~520KB). 1,136 argument/format dialogs. No report metadata/cache/queue/usage log.
- **`fn_getSaleInvTotal` per-row scalar UDF in 584 DWs.** Measured `d_dailysalesdetail`: 1 day 1.59s vs 0.116s without UDF (**13.7x**); 7 days 7.82s vs 0.70s (11.2x); 30 days ~33s extrapolated. Fix: persist `SaleLedger.NetTotal/TaxTotal`, join once.
- **Ledger reports rescan `VirtualGl` 36–81x per run**: `d_customerledger_itemwise` 31 UNIONs/36 VGL refs/89 subqueries; portrait 45/54/119. Fix: one-pass account statement proc + `RptLedgerDaily`.
- **`SP_VirtualGL` rebuild runs before 90 report branches**; truncates temp, `TABLOCKX` on `VirtualGl`, 18 EXEC branches; measured 0.53–1.26s sales branch; 2–5s all branches est. `SP_STOCKLEDGER` also `TABLOCKX`, scans Pur/Sale, blocks stock.
- **`StockReport` 2.9M rows/202MB is an unindexed heap; purge disabled since 05-JUN-2023**; backdate report 28,244 reads/226MB (0.14–0.82s). Cluster `(Date,GCode,ICode)`/`(ICode,Date)`, archive >2 years, restore purge.
- No summary layer: only `StockReport` snapshot + `PreviousSaleHistory`. Add `RptSaleDaily`, `RptLedgerDaily`, `RptItemMonthly`, stock snapshots.
- Every report retrieves full result; no `Retrieve.As.Needed`; 2,133 client `sort=`, 4,193 computed fields, 4,457 summary bands; 55k-row reports materialized in 32-bit memory.
- Crosstab reports share global `CrossTab_ReportData` (`DELETE` + dynamic `UPDATE`); 152 crosstab DWs; two users can corrupt/block.
- Nested reports loop up to 15 retrieves of the same range.
- **Excel export is in-process BIFF `dw2xls`, per-cell `Describe("Evaluate(...)")`**; 1.1M cells for 1,000 pages; 60–180s est. **PDF export** is whole-document client-side `saveas("", pdf!, false)`, UI frozen; 30–120s/1,000 pages est.
- Print: two modal dialogs, preview always on, `PageCount()` re-evaluated; all printing via `DataWindow.Print()`; no `PrintOpen`/`PrintDataWindow`.
- 2,275 print layouts avg 81 controls, 714 with logos; 27 `d_dailysalesdetail*`, 30 `d_dailysalessummery*`, 93 `d_stockinhand*`, 30 `d_customerledger*`, 38 `d_wholesaleinvreport*`.
- Crystal cheque printing via COM + `sa` (`w_crystal_report_viewer.pbs:15-17`).
- Email/SMS synchronous socket I/O on UI thread.
- RCSI off; 0 `NOLOCK` in 4,813 DWs -> report scans block posting.
- Missing indexes match report predicates: VGL `(AccCode)` 99.62%, `(Date)` 96.53%; StockReport `(Date)` 99.94%, `(ICode,Date)` 99.98%; SaleLedger `(Posted,AccountFor)` 83.83%.
- Measured `d_stockinhand` 376ms/4,600 reads; `d_stockinbackdate` 0.14–0.82s/28,244 reads; VGL date range 37,907 reads/232ms; VGL new-sales anti-join 74,406 reads/1.26s cold.
- Recommendation: SQL fixes first (2–15x), summary layer (10–100x), then hybrid Rust report service (5–20x render/export). SSRS only for back-office tabular, not invoices/cheques.
- Report cache key: report_id + params + rights scope + data_version; TTL 5min daily/1h monthly/24h statements; store PDF/XLSX on disk, metadata in DB.
- Benchmark: 12 reports × {1d,1mo,1yr} × {100,1k,10k,50k rows}; daily p95 <3s, monthly <10s, Excel 10k <15s, 1,000-page PDF <30s, peak <800MB.

### SQL Server / DB (analyst 2)
- **Correction: compatibility 80 is NOT a direct optimizer win on 2008 R2.** CE70 is the only estimator for levels 80–110; raising to 100 changes no estimates. It does block `PIVOT`/`APPLY` (verified), but no legacy `*=`/`=*` joins exist. Treat 80→100 as a low-risk blocker-clearing task, not a speed switch. 160 requires SQL 2019/2022.
- **DB is short on memory/maintenance, not indexes.** Buffer pool 793 MB vs 2,882 MB used (~27% residency). Top 3 tables (SaleLedger 628MB, SaleDetail 674MB, VirtualGl 516MB) cannot co-reside. Express ~1GB cap. SQL 2019/2022 Standard 16GB = whole DB resident -> **3–10x cold reports**; the biggest absolute win.
- **Top DB wins:**
  1. `StockReport` 2.9M rows, **zero indexes**; day query 28,244 reads/174ms/220MB. Clustered `(Date,GCode,ICode)` -> 400–500x fewer pages, 174 -> 2–5ms.
  2. `VirtualGl` 2M-row heap; AccCode=2 month 37,907 reads/132ms. `(AccCode,Date) INCLUDE (Debit,Credit,...)` -> 100–300x, 132 -> 1–3ms. Drop 3 indexes on 100%-NULL PatientCode/StudentCode/GuestCode (~128MB).
  3. `SaleLedger` `(CustCode,date) INCLUDE (InvTotal)`; customer month 48,752 -> ~50 reads.
  4. Rebuild SaleLedger FF80 (57.2% dense/67.9% frag/53,112 fragments) -> 580 -> ~415MB, 1.4x scans.
  5. Rebuild ItemLog/Purdetail/PurOrderDetail/Item -> ~135MB freed, 1.2–1.5x.
  6. `UPDATE STATISTICS FULLSCAN` top 10; **944 stats >1 year old, 973 never updated**; auto-update threshold on 2M rows is ~400k changes, counters only 96k–107k.
  7. Rewrite `SP_StockReport` `NOT IN (SELECT DISTINCT CONVERT(...))` -> `NOT EXISTS`; removes 2.9M-row DISTINCT sort.
  8. tempdb 28MB/1 file/10% growth -> 4×64MB fixed; fixed autogrowth.
  9. CTFP 5 -> 25; optimize for ad hoc 1.
- **Do NOT index the 1,438 FK gaps.** Most point at 5–20-row lookups; indexing all = ~2.9GB, 38 B-trees per SaleLedger insert, catastrophic on 1GB buffer. Only `Saledetail.GCode` and maybe `SRLedger.CustCode` pass. 86 FKs are untrusted; validate them instead.
- **No `char(255)` columns.** 1,484 of 1,553 char columns are `char(1)`; total declared char bytes ~3,988. `Item` is 726B/record, 112MB reserved not 4KB rows. Do not chase char->varchar.
- `SaleDetail` is already optimal (clustered by SaleInvcode, 13.7k seeks); do not touch.
- 78 cursor procs, 41 procs with `SELECT *`, 120 procs join SaleLedger+SaleDetail, 50 scalar UDFs (`Fn_GetPreference` in 84 modules), 20 MSTVFs. **0 proc executions in this DB since restart** — the interactive hot path is DataWindow ad-hoc SQL, so proc rewrites are medium-term.
- 107 heaps <170k rows; only StockReport/VirtualGl/SaleLedger matter now.
- Data file only 176MB free; pre-size to 4GB, 256MB growth.
- `sys.dm_db_index_physical_stats` fails inside DB at compat 80; run from master with 3-part names.
- DB freshness caveat: all fact tables end 2025-01-01; it's a Jan-2025 restore, not live production. DMV counters cover 1.4h.

### UI / MDI / rendering (analyst 5)
- 2,062 windows / 10,597 controls; median 5 controls, max 207; 80% modal; 839 `w_arg_*` + 213 `w_selectformat_*` = 51% report parameter pickers.
- 443 windows retrieve in `open()`; 1,090 open another window (mostly modal); 55 re-walk menu security per sheet.
- **Fiscalization to port 9111 with nothing listening**; prefs `AutoFiscalizeOnPosting=Y`, `FiscalizationMethod=2`, `FiscalizationAppPort=9111`; every posted invoice does blocking Winsock connect/send/recv + modal; receipt suppressed if `PrintUnFiscalizedInvoice=N`. **Per-sale win: set pref N or start service.**
- `CheckManualBackupHealthAtStartUp=Y` -> set N; removes 3 RESTORE HEADERONLY + modal.
- 4–6 physical connections, no `SetTransPool`; 250 `create u_transaction`, 264 `SQL start`.
- `w_main.open`: 1 SELECT, 2× d_security (313/150 rows), `gd_itemsinfo.filter`, menu walk, d_groups.
- Every sheet rebuilds full `m_entry` menu + 313 rights: ~3,490 `mf_findindex` parses + 626 writes; 50–400ms/sheet.
- `f_stringpreferences` O(1,308) linear scan, **4,694 calls** (352 in w_sale); 20–300ms/screen + keystroke lag.
- `f_getgroupcode` SQL per call, 218 sites; cache at login.
- Reports always print preview + ruler toggle; 2+ full paginations; 2–10x report open.
- Item list 28,966 rows reload/filter, 26 linear finds, `upper(col)` filter; 0.3–2s per open/filter.
- 199 `SetRedraw(false)` blocks can leak; 162 `activate` handlers force maximize -> flash/repaint.
- 8,779 MessageBoxes (558 in loops); 2 `Yield()`; 80 progress bars but only 16 batch windows; no progress in sale/item/report.
- Preferences windows eager-load 34/45 retrieves; 51% of windows are modal arg dialogs.
- 2,802 SRDs client `sort=`; 357 SetFilter/314 Filter/151 Sort/59 GroupCalc.
- 32-bit exe is **not LARGE_ADDRESS_AWARE** (PE 0x010f); 2GB ceiling; 144MB WS with one sheet.
- `w_bkg` missing `yourlogo.bmp`; not instantiated in this session; `ue_mdi_move` calls `setfocus()` on resize.
- DPI-unaware at 96 DPI; 5,714 controls 10pt Arial; blurry at 125/150%.
- No artificial `Sleep` found in startup path; the 14s wait is likely PBVM/PBD load, AV, or UNC. `w_logo` is after login, not a pre-login splash.
- Config quick wins: backup health N, fiscalization N/service, item auto-refresh N/0, LogoSelected 0, add yourlogo.bmp, OS animations off, DISABLETHEMES, AV exclusions, 100% scaling, local SSD, fixed window size, `editbin /LARGEADDRESSAWARE` on a copy, no RDP.
- Targets: splash <150ms, login->main ≤2s p95, sheet p50 ≤300ms/p95 ≤800ms, report first paint <1.5s, scan->line ≤100ms, sale post ≤800ms, 60fps resize, idle CPU <1%, memory stable.

### Network / data access (analyst 7)
- **Biggest data-access cost: item catalogue loaded at login, one list executed twice.** DMV: **900,187 logical reads, 2,271 ms CPU, ~15.5 MB TDS**; session 51 1.0M reads, 3,790 writes. Item SQL is N+1: plan shows **26,246 rebinds ×3** on `PK_GodownDetail`; 300k reads/exec; 26k-row sort.
- PO/issue screens re-fetch all 27.8k items to show a few (`w_purchase.pbs:3202-3224`, `w_advancepurchase.pbs:2143-2165`; 25 sites); 7–15MB + ~141 FETCH RTT per screen.
- Transport measured (32-bit SQLOLEDB, 1,000×SELECT 1): direct pipe 153µs, `\\localhost` pipe 264µs, alias 257µs, TCP loopback 172µs, shared memory 180µs. Fresh connect 5–8ms; first connect/process 580ms; pooled reconnect 0.38ms. 28,966×2 cols: 4,096B=105ms, 8,192B=60ms, 32,767B=53ms. **Packet size 4,096 -> 32,767 = ~2x bulk.**
- No connect/command/lock timeout, no deadlock retry (1205); query can freeze UI forever.
- 250 `create u_transaction`; 104 files `SQL START`; 4 sessions; **0 `SetTransPool`**; 132 instance transaction objects; 75 never stopped/destroyed; `it_imagetrans` 9 creates, 0 stop/destroy -> leak per image view.
- DataWindow updates one statement per row; 20-line invoice ~25 RTT. Posting loops 15–19 DB ops/invoice -> 100 invoices 1,500–1,900 RTT; WAN 50ms RTT = 90–100s.
- 70 CRS tables / 31 `SP_CRS_*`; 35 procs `XACT_ABORT`; cursor sync `SP_SyncTransactionData_OnRemote` 14.5KB; potential MSDTC.
- 30+ pre-login queries + 3 RESTORE HEADERONLY; 3–4 startup connections.
- `f_getgroupcode` 218× uncached, always returns 2; 1 RTT/call.
- **`Script.mdb` not in runtime path** (no refs in 2,780 scripts, no string in client; `Sequence` 1-row table, no `Script` table). Deployment artifact; remove if installer doesn't need.
- Transaction boundaries ambiguous: `CommitOnDisconnect` No (login) / Yes (health); `w_purchase.pbs:553-575` mixes `sqlca`/`it_transobject`.
- DBParm variants: login master/app DB, health check, MSDB job panels, master admin/import, source-server import, Jet `Data.mdb`/`RightsClone.mdb`, dynamic remote. **None sets PacketSize, MARS, timeouts, encryption, TrustServerCertificate.**
- WAN direct SQL unusable: login 18–30s, ~200ms/scan, 90–100s/100-invoice post. Use RDS in DB datacentre or local branch DB + outbox.
- Rust/Tauri: `tiberius` + `deadpool`/`bb8`, TCP only, one pool, batching/TVP, streaming, keyset pagination, local SQLite item/price/stock cache. Keep SQL Server; upgrade off 2008 R2.
- Top 10: cache/lazy item list; rewrite item SQL; server-side item filter; TCP + packet size; timeouts/retry; set-based posting; batch DW writes; report process/precomputed VirtualGl; one pool/fix image leak; RCSI + least privilege.

### DataWindow layer (analyst 3)
- 8,748 SRDs parsed; 8,664 with SQL. **Bimodal:** entry DWs 4–9ms/<500 reads; report/ledger DWs 0.2–21.5s/25k–500k reads. Pain is ~30 report/popup objects, not 8,748.
- **Combinatorial SQL, not `SELECT *`:** only 38 `SELECT *`, 11 `TOP`; 5,145 DWs contain **26,899 subqueries**; 1,048 have top-level `UNION` (**3,686 legs**); 4,088 touch ≥100k-row tables; 3,309 have no range predicate (heuristic); 5,130 function-on-column; 2,757 ISNULL; 452 OR.
- **`d_customerledger_itemwise` = 21.5s / 206k reads for 6,872 rows** (18 tables, 17 joins, 89 subqueries, 11 union legs). Family variants 11–17 legs/89–119 subqueries.
- `d_cashflow` 1,327ms/385k reads for 3 rows; 24 legs; leg 9 rewrite -42% reads (176,951 -> 103,284).
- `d_customerbalances_in_sales` 75,814 reads/259ms for 2 rows; `d_popup_supplierselection_many` 37,907/835ms for 225 rows; `d_stockinbackdate` 28,244/200ms for 0 rows; `d_po_purchase_disparity` 24.8k/58ms for 14 rows.
- **PB settings:** `retrieve.asneeded=yes` in only **2/8,748**; `rows`/`buffer` in **0**; 2,854 `dddw.limit=0`; 1,965 double sort (SQL ORDER BY + PB sort); 2,732 DWs have `sort=`.
- 97,059 compute objects; 1,696 DWs ≥40 columns; 771 >100KB; max 328KB/138 cols (`d_itemlog_azhar`, dead). Entry DWs: `d_saledetail` 9ms/297 reads/58 rows but 81 cols/16 computes/196KB; `d_normalpurchasedetail` 8ms but 73 cols/57 computes.
- 2,275 `sprnt*` DWs = 143MB (42% of DW bytes), one per deployment; tune the active default only.
- 0 DWs use `EXEC`/temp tables; all ad-hoc client SQL (no plan reuse, 34KB SQL parse).
- **Fix ownership:** only DB indexes/statistics are deployable without a PB 12.5/PBL rebuild. Every `.srd` retrieve/property fix, `Retrieve As Needed`, `sort`/`filter`, column thinning, dropdown limits require the original PBL/PBD rebuild. Runtime `SetSQLSelect`/`Modify` patch needs PowerScript source. Retiring dormant print variants is deployment-config and can be done now.
- Top 10: 5 indexes; rewrite cashflow legs; rewrite customerledger; guard 35 no-arg big-table DWs; fix customerbalances; dropdown limits; remove 1,965 double sorts; enable Retrieve As Needed on flat lists; thin entry DWs; retire dormant print variants.
- **Do not** rewrite pre-aggregated derived tables as correlated `OUTER APPLY` (measured 5.95M reads/5.08s vs 37,907/0.84s, 6x worse); do not `FORCE ORDER`; do not create every DMV suggestion; do not use indexed views on Express; do not enable Retrieve As Needed on updatable entry DWs.

## Pending analysts
4 PowerScript hotspots (last one).
