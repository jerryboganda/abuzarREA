# Measurement, baselines & prioritized roadmap — findings

## Executive verdict

- **The captured startup is not SQL-bound.** The only startup trace has 119 statements and 316 events but just **77.4 ms** of server time across 41.6 s; `SP_CleanUp_Bad_Session` is 32.5 ms of that. The rest is client initialization, dialogs and human login. The successful run's SQL path was not traced, so its backup/security calls remain unmeasured.
- **The 47 s "startup" figure is real but n=1.** Process start 01:21:33 → `w_main` title 01:22:20 = 47 s, including a login and the Backup Information modal. The traced launch is a *different, failed* run: 13.0 s from first SQL to "Database Problem", of which 12.49 s was a login pause.
- **Reports, grids and exports are unmeasured.** They probably cost more per working day than startup, but there is no evidence yet. Week 1 must be measurement-only.
- **The likely database lever is plan quality and statistics, not another index.** 30 statistics on the seven >100k-row tables predate 2018, compatibility is **80**, and `IDX_VirtualGL_AccCode` exists but still does RID lookups.
- **Do not start the Rust/Tauri rebuild as the latency fix.** Fix the measurable PB/SQL problems first; the rebuild is a 3–24 month strategic option.

## Evidence base

Inspected `deploy/trace/app.trc` (316 events, 41.6 s, 01:15:38–01:16:19); 10 screenshots plus `deploy/screen1.png`/`screen2.png` (viewed 01, 02, 03, 06, 07, 08, 10; 05/09 are docs/editor captures); `deploy/README-DEPLOY.md`; `RE-ANALYSIS.md`; `REBUILD-PLAN.md`; 2,780 recovered scripts; live process/SQL DMVs. **`docs/STATUS.md` does not exist.**

Live state (2026-11-02 ~01:40–01:50): SQL Server 2008 R2 SP2 Express; DB 3,552 MB (3,058 data + 493 log), compatibility **80**, SIMPLE, RCSI off. Buffer pool 713 MB used / 795 MB committed; target pages report 1.41 GB but the documented Express cap is ~1 GB — treat ~1 GB as effective until verified. App PID 8796: start 01:21:33, **1 OS thread**, 137.6 MB working set, 119.2 MB private, 0% CPU over 10 s idle. Four named-pipe sessions (51–54) belong to it.

Trace: 77 `RPC:Completed`, 42 `SQL:BatchCompleted`, 73 `SQLTransaction` (37 begin/26 commit/10 rollback), 2 errors (15281). It captured columns 1, 3, 10–15, 21, 23, 25 — **not Reads/Writes/CPU** — and stopped before the main window.

## Findings

| ID | Finding | Evidence | Why it costs time | Fix | Gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| F1 | Startup SQL = 77.4 ms; 119 statements, 73 transaction events | trace sum over events 10/12 | DB is not the startup constraint | Stop tuning SQL for startup | <0.1 s possible | — | — |
| F2 | Trace lacks Reads (16), Writes (17), CPU (18) | trace setup batch | Cannot separate I/O/CPU/client wait | Re-trace with 16/17/18/48 | Diagnosis | S | Low |
| F3 | 12.49 s of no SQL before login SQL | gap 01:15:48.560→01:16:01.050 | Human typing/clicking, not app work | Auto-login; separate machine/human SLO | 5–12 s perceived | S/M | Low |
| F4 | 10.33 s from trace start to first app SQL | gap 01:15:38.090→01:15:48.417 | PB load + OLE DB connect, unmeasured | ProcMon/ETW cold capture | Unknown | S | Low |
| F5 | Successful run: 47 s to title, 68 s to screenshot; screenshot names are misleading (02/03 = License Expire, 06/07 = DB Problem, 05/09 = docs) | process/title/screenshot mtimes | Includes login and modal(s); composition inferred | Instruments below; rename by content | 10–25 s | M | Low |
| F6 | Traced failure was 15281 inside `SP_WayToMoon`; current proc succeeds in 53 ms via two `cmd.exe dir` calls | Event Log 15281; `SET STATISTICS TIME` 25+28 ms | False DB failure; shell can be slowed by AV | `xp_fileexist`/registry check | 30–50 ms + security | S | Low |
| F7 | `SP_CleanUp_Bad_Session` = 32.5 ms every launch | trace RPC duration | 42% of startup DB time for cleanup | Conditional/throttled cleanup | ~30 ms | S | Low |
| F8 | Startup uses 3 app-name contexts/2 SPIDs; live app holds 4 sessions | `Waseela`, null, `Waseela (4)`; sessions 51–54 | Each connection repeats metadata calls | Single-connection strategy | 10–20 ms now; scales | M | Med |
| F9 | App is effectively single-threaded | 1 OS thread, PID 8796 | Any query/report freezes UI | Out-of-process reports/exports | Perceived responsiveness | L | Med |
| F10 | Buffer pool 713 MB of 3.06 GB | buffer descriptors, `dm_os_sys_info` | Big scans hit disk; 2.9M-row reports cannot cache | Index/aggregate/archive | 10–30% on scans | M | Med |
| F11 | Wait stats dominated by backup; other analysts' 3.3 s queries are in cache | `BACKUPIO` 12.9 s/86k; `dm_exec_query_stats` | Current timings are contaminated | Quiet-window benchmark | Measurement validity | S | Low |
| F12 | Compatibility 80 blocks modern T-SQL (`CROSS APPLY` failed in DB; same query ran from `master`) | `sys.databases`, repro | SQL 2000-era optimizer; no filtered indexes | Test compat 100 on a copy | 10–30% `[hypothesis]` | M | High |
| F13 | 30 stats on 7 big tables older than 2018; 72 stats date to 2004 | `sys.stats` + `sys.partitions` | Bad cardinality → bad joins/sorts | `UPDATE STATISTICS` top tables | 20–50% | S | Low |
| F14 | `IDX_VirtualGL_AccCode` exists but plan does seek + RID lookup; StockReport shape scans 56,488 reads | `db-perf/16_plans.out:10-18`, `05_heavy.out` | 2M-row heap lookups; 441 MB logical reads | INCLUDE `Debit,Credit`/cluster | 1.5–3× on GL `[hypothesis]` | S/M | Med |
| F15 | Data file 3,058 MB, 176 MB free, 10% autogrowth (~306 MB) | `sys.database_files` | Next growth can stall writes | Pre-size + fixed MB growth | Rare stalls removed | S | Low |
| F16 | 5,115 `SetTransObject`, 4,090 `.retrieve(`, 8,779 `MessageBox` sites | static scan | Per-DW edits infeasible; dialogs pervasive | Base-class wrappers | Enables measurement | M | Low |
| F17 | `w_main` sets title **before** security/menu/timer work | `w_main.pbs:175-206` | "Visible" ≠ "ready" | Measure readiness at line 206 | Valid SLO | S | Low |
| F18 | No cold/module/grid/report/export/print/backup/multi-user timings exist; Express shows 36 schedulers on 1 socket; SQL 2008 R2/PB 12.5 are legacy/out of support | artifacts; `dm_os_schedulers`; `@@VERSION` | Cannot prioritize; upgrade risk | Week-1 harness; verify licensing; upgrade plan | — | M | High |

## Startup timeline — measured vs inferred

The trace and the 47 s run are **different launches**. Do not merge them. The manual screenshot sequence is also not one run: 00:12:11 desktop → 00:12:45 Login → 00:13:47 License Expire → 00:50:36 License Expire → 01:03:53 document → 01:04:34 Database Problem → 01:16:07 Database Problem → 01:21:53 Backup Information → 01:22:41 main. The 37-minute gap and duplicate dialogs prove these are separate attempts; only the last two belong to the 01:21:33 process. No screenshot captures the license gate in the successful run.

| Phase | Time | Duration | Status |
|---|---|---:|---|
| Trace starts | 01:15:38.090 | — | measured |
| First app SQL | 01:15:48.417 | +10.33 s | gap measured; launch/connect **inferred** |
| Cleanup + schema checks | 01:15:48.430–48.560 | 32.5 + ~83 ms | measured |
| Login wait | 01:15:48.560–01:16:01.050 | **12.49 s** | gap measured; human typing **inferred** |
| Login/license SQL | 01:16:01.050–01:16:01.107 | ~57 ms | measured |
| `SP_WayToMoon` fails 15281 | 01:16:01.163 | 1.42 ms | measured |
| "Database Problem" shot | 01:16:07 | +5.8 s | timestamp measured; state observed |
| Trace stops | 01:16:19.690 | 41.6 s | measured |
| Successful process starts | 01:21:33 | — | measured |
| Backup dialog shot | 01:21:53 | +20 s | measured |
| `w_main` title (`getdate()`) | 01:22:20 | **+47 s** | measured; composition inferred |
| Main screenshot / extra SQL activity | 01:22:41 / 01:22:31–01:23:03 | +68 s / +58–90 s | measured request times; background/user action inferred |

**Certain:** startup SQL is milliseconds; visible delay is login, dialogs and client work after the title. **Unknown:** the split between PB load, security/menu init, `RESTORE HEADERONLY`, typing and clicks.

## Instrumentation

### Inside the PB app — only with source/vendor build

The deployed app has no source (`RE-ANALYSIS.md` §16–17: 99.7% decompiled, but 16,870 global-function calls remain `gfunc_<n>`) and no `TraceOpen`/`CPU()`/`GetTickCount`. **You cannot add PB tracing to the running p-code copy.** This is the specification for the next build.

APIs (confirm signatures in PB 12.5 help): `TraceOpen(file,key)`, `TraceEnableActivity()`, `TraceEnableRoutine()`, `TraceEnableESQL()`, `TraceBegin(group,label)`, `TraceEnd(group)`, `TraceClose()`. Use `GetTickCount()` for phases, `CPU()` deltas for client compute, and `QueryPerformanceCounter` via `kernel32.dll` for sub-15 ms work (`GetTickCount` resolution ~15.6 ms). `Now()` is second-resolution only.

| # | Point | File:line | Measure |
|---|---|---|---|
| 1 | Application open | app object (open body missing in recovered output) | `t0`, run_id, build, host |
| 2 | DB status + cleanup | `functions/f_get_database_status.pbs:25-28` | connect + `cleanup_bad_session` |
| 3 | Schema checks | `functions/f_firsttime_script.pbs:5-9`, `f_firsttimewks_limit`, `f_firsttimelic` | one event each |
| 4 | Login connect + user lookup | `abuzarapp/w_login1.pbs:209-221`, `226-249` | wall, CPU, SQL code, rows |
| 5 | Login→main boundary | `w_login1.pbs:273` | `login_submit` marker |
| 6 | Logo | `abuzarapp/w_logo.pbs:30-38` | wall + SQL |
| 7 | Startup backup + dialog | `abuzarapp/w_startup.pbs:52-104`; `w_backupinfo.pbs:14-49` | per-device, modal duration |
| 8 | Main readiness | `abuzarapp/w_main.pbs:174-206` | title 180, security 185/190, menu 201, timer 202 |
| 9 | First sheet / every DW | `opensheet` path; 4,090 retrieves | wrapper around `SetTransObject` + `Retrieve` |
| 10 | Every modal | 8,779 sites | wrapper `of_msg_timed(title,text)` |

File-first log (DB writes would pollute a single-threaded client):

```text
ts|run_id|build|session|scenario|phase|object|event|wall_ms|cpu_ms|rows|sql_ms|reads|success|note
2026-11-02T01:22:20.123+05:00|run-001|pb12.5.2511|A1B2|startup|main_open|w_main|title_set|47123|10109|1|77|0|1|n=1
```

Optional central table (separate `Bench` DB): `app_timing(timing_id, run_id, build, session_id, host, login_name, scenario, phase, object_name, event_name, started_at datetime2(3), wall_ms, cpu_ms, rows_affected, sql_ms, sql_reads, success, note)`. `TraceEnableActivity/Routine` can add double-digit overhead; use a benchmark build only.

### Outside the app — available today

- **Server-side SQL trace**, not Profiler GUI. Events 10/12/17/33/43/50; columns 1,3,8,10,11,12,13,14,15,**16,17,18**,23,48. Filter `ApplicationName LIKE 'Waseela%'`, one scenario per run. The existing trace omitted 16–18.
- **DMV snapshots before/after:** `dm_exec_query_stats`, `dm_os_wait_stats`, `dm_db_index_usage_stats`, `dm_db_missing_index_*`, `dm_io_virtual_file_stats`, `dm_os_buffer_descriptors`, `dm_tran_locks`. Instance uptime is only since 12:07:58; all cumulative numbers are short-window.
- **PerfMon:** process CPU/WS/private/IO, `Memory\Available MBytes`, `PhysicalDisk\Avg. Disk sec/Read`, Buffer Manager PLE/page reads/hit ratio, SQL Statistics batches/compilations, Locks waits/average wait.
- **ProcMon, one cold run only:** filter `abuzar.exe`, Load Image/CreateFile/RegQueryValue/TCP-UDP, flag `NAME NOT FOUND`. This answers whether the 10.3 s pre-SQL gap is disk/DLL loading. Not installed here; budget Sysinternals.
- **ETW/WPR:** `wpr -start GeneralProfile -start CPU -start DiskIO -filemode`; analyze in WPA. **Network:** named pipes confirmed (`dm_exec_connections.net_transport`), so Wireshark is blind to it; use ProcMon/ETW. Only trace TCP if the deployment changes.
- **UI/dialog timing without code:** poll UI Automation at 10 Hz for top-level windows owned by PID; log title/open/close; screenshot every 250 ms. This captures Login, License Expire, DB Problem, Backup Information and main without touching p-code. For paint, capture 30 fps and find the first stable frame.

## Baseline scenarios, SLOs and pass/fail

Measure **machine** (auto-login, dialogs dismissed immediately) for engineering and **human-equivalent** (scripted typing + 2 s per dialog) for the founder's experience. Never mix them. **All targets below are p95 unless marked;** the scorecard records p50 and p95.

| Scenario | Current (2026-11-02) | PB P0 (0–3d) | PB P1 (1–4wk) | Rust/Tauri | How measured | User outcome |
|---|---:|---:|---:|---:|---|---|
| Cold start → login ready | not measured; 10.3 s pre-SQL gap in failed run `[inferred]` | ≤8 s | ≤3 s | ≤1.2 s | UIA + QPC | First impression |
| Warm start → login ready | not measured | ≤4 s | ≤1.5 s | ≤0.6 s | 20 runs | Fast switch |
| Login → main interactive | 57 ms SQL + unknown client | ≤3 s | ≤1 s | ≤0.4 s | UIA + click ping | No freeze |
| Main → first sheet usable | not measured; title at +47 s | ≤3 s | ≤1 s | ≤0.3 s | screenshot + UIA | Start selling |
| Sale open | not measured | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace | Cashier throughput |
| Purchase open | not measured | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace | Buying throughput |
| Item open | not measured | ≤1.5 s | ≤300 ms | ≤100 ms | UIA + paint | Fluid navigation |
| Customer open | not measured | ≤1.5 s | ≤300 ms | ≤100 ms | UIA + paint | Fluid navigation |
| Grid 1k/10k/100k scroll | not measured | 100/250/750 ms | 50/100/250 ms | 16/16/50 ms | frame diff | No jank |
| Simple indexed query | 0.65 ms avg startup stmt `[not representative]` | ≤100 ms | ≤50 ms | ≤20 ms | SQL trace | Instant search |
| Stock report 10k | not measured; 56,488 logical reads for one shape | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | Decision loop |
| Ledger 10k | not measured | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | Reconciliation |
| Report preview 10k | not measured | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | Decision loop |
| Day-end | not measured | ≤10 s | ≤3 s | ≤1 s | trace | Closing shift |
| Excel export 10k | not measured | ≤20 s | ≤5 s | ≤2 s | file time + trace | End-of-day |
| Print 100 pages (spool) | not measured | ≤60 s | ≤20 s | ≤10 s | spooler + trace | Invoice counter |
| Backup 3 GB | not measured; backup waits already 12.9 s | ≤180 s | ≤90 s | n/a | `msdb.backupset` | Closing shift |
| 2/5/10 users save | not measured | p95 ≤2 s | p95 ≤1 s | ≤300 ms | 2/5/10 sessions or VMs | No blocking |
| Memory / idle CPU | **137.6 MB / 0%** | ≤300 MB / ≤2% | same | ≤150 MB / ≤0.5% | PerfMon | Older PCs |

**Pass/fail:** pass = p95 ≤ target and error rate <0.1%; fail = p95 >1.5× target or any data error. n≥20 warm/5 cold; 30 modules; 100 queries; 10 reports/exports.

**P0 caveat:** the startup P0 targets assume either a config-only fix or vendor source access. With DB-only changes, expect the P0 database gains but **not** the startup gains; auto-login and dialog removal cannot be done in deployed p-code.

## Baseline scorecard template

| Scenario | Build/date | n | Current p50 | Current p95 | P0 | P1 | Rust | Measured by | Status |
|---|---|---:|---:|---:|---:|---:|---:|---|---|
| Cold start → login |  |  |  |  | ≤8 s | ≤3 s | ≤1.2 s | UIA + QPC | ☐ |
| Warm start → login |  |  |  |  | ≤4 s | ≤1.5 s | ≤0.6 s | UIA + QPC | ☐ |
| Login → main |  |  |  |  | ≤3 s | ≤1 s | ≤0.4 s | UIA | ☐ |
| Main → first sheet |  |  |  |  | ≤3 s | ≤1 s | ≤0.3 s | screenshot | ☐ |
| Sale open |  |  |  |  | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace | ☐ |
| Purchase open |  |  |  |  | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace | ☐ |
| Item open |  |  |  |  | ≤1.5 s | ≤300 ms | ≤100 ms | UIA | ☐ |
| Customer open |  |  |  |  | ≤1.5 s | ≤300 ms | ≤100 ms | UIA | ☐ |
| Stock report 10k |  |  |  |  | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | ☐ |
| Ledger 10k |  |  |  |  | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | ☐ |
| Report preview 10k |  |  |  |  | ≤8 s | ≤2 s | ≤1 s | trace + screenshot | ☐ |
| Day-end |  |  |  |  | ≤10 s | ≤3 s | ≤1 s | trace | ☐ |
| Grid 10k scroll |  |  |  |  | ≤250 ms | ≤100 ms | ≤16 ms | frame diff | ☐ |
| Excel 10k |  |  |  |  | ≤20 s | ≤5 s | ≤2 s | file + trace | ☐ |
| Print/Backup |  |  |  |  | ≤60/180 s | ≤20/90 s | ≤10 s/n/a | spooler/`msdb` | ☐ |
| 2/5/10 users save |  |  |  |  | ≤2 s | ≤1 s | ≤300 ms | concurrent test | ☐ |
| Memory / idle CPU |  |  | 137.6 MB / 0% | — | ≤300 MB/≤2% | same | ≤150 MB/≤0.5% | PerfMon | ✅ |

## Scored backlog

`Score = (impact seconds saved per user per day × confidence) / effort days`. Assumes 20 users, 3 launches/day, 5 reports/day, 3 exports/day, 20 grid opens/day — replace after week 1. Risk/dependency are gates. **Rev.** = reversibility: H = flag/drop/revert in <1 h; M = restore copy; L = data loss or architectural change.

| Rank | Change | Phase | Impact s/day | Effort d | Conf. | Risk | Depends | Rev. | Score |
|---:|---|---|---:|---:|---:|---|---|---|---:|
| 1 | Statistics on 7 big tables; `optimize for ad hoc workloads` | P0 | 40 | 0.5 | 0.8 | Low | DBA window | H | **64** |
| 2 | Covering INCLUDE (`Debit,Credit`) on `IDX_VirtualGL_AccCode` | P0 | 20 | 0.5 | 0.8 | Med | index window | H | **32** |
| 3 | Excel export streaming/background | P1 | 90 | 3 | 0.6 | Med | export analyst | M | **18** |
| 4 | Report paging/TOP + server-side aggregation | P1 | 90 | 4 | 0.6 | Med | report analyst | M | **13.5** |
| 5 | Pre-size data/log; fixed MB autogrowth | P0 | 3 | 0.25 | 0.9 | Low | DBA | M | **10.8** |
| 6 | Top-5 report query rewrites/indexes | P1 | 100 | 5 | 0.5 | Med | db-perf | M | **10** |
| 7 | Compat 80→100 on copy, regression, pilot | P1 | 60 | 3 | 0.5 | High | full regression | H | **10** |
| 8 | Remove/auto-dismiss dialogs; auto-login; skip backup header checks | P0 | 12 | 1 | 0.8 | Med | source/vendor | H | **9.6** |
| 9 | Archive/purge old StockReport/VirtualGl/Saledetail | P1 | 40 | 5 | 0.5 | Med | business approval | L | **4** |
| 10 | Summary tables for stock/ledger/day-end | P2 | 80 | 15 | 0.4 | High | nightly job | M | **2.1** |
| 11 | Report service (out-of-process) | P2 | 120 | 25 | 0.4 | High | architecture | L | **1.9** |
| 12 | Master-data cache + lazy modules | P2 | 20 | 5 | 0.4 | Med | source | H | **1.6** |
| 13 | Rust/Tauri rebuild | P3 | strategic | 180+ | 0.5 | High | parity | L | n/a |

**10 changes that buy ~80% (provisional):** stats, VirtualGl covering index, Excel export, report paging, top-5 reports, compat 100, startup dialogs/auto-login + deferred default sheet, archive/purge, summary tables, master-data cache — ~552 of ~680 perceived seconds/day under the assumptions. Gains overlap; do not add linearly.

## 30/60/90-day plan

| Week | Owner | Deliverable | Gate | Rollback |
|---|---|---|---|---|
| 1 | Perf lead + QA | **Do nothing.** Freeze app/schema; build harness; restore `Bench` copy; baseline 20 warm/5 cold starts, 10 modules, 10 reports, exports, 10-user | Warm p50 repeats ±10%; all scenarios captured | none |
| 2 | DBA | Stats, ad-hoc setting, pre-size/fixed growth, backup-device cleanup | Top-10 p95 −30%; write latency +<10%; no plan regressions | restore copy; growth safe |
| 3 | PB/vendor | Dialogs/auto-login (source-dependent), `SP_WayToMoon` file check, conditional cleanup | Cold ≤8 s; login→main ≤3 s; zero DB Problem | previous build; flag |
| 4 | DBA + QA | Compat 100 on copy; 50-query/10-report regression; 2-user pilot | No errors; p95 −15%+ | compat back to 80 |
| 5–6 | DBA | Top-5 report indexes/rewrites; archive with approval | Report 10k ≤5 s; DB shrinks; no data loss | drop indexes; restore archive |
| 7–8 | PB/vendor | Paging, server aggregation, Excel off UI thread | Report ≤2 s; export ≤5 s; sheet ≤1 s | feature flag |
| 9–10 | QA + DBA | 10-user load, connection strategy, blocking review | p95 save ≤1 s; error <0.1% | connection flag |
| 11–12 | Architect + founder | Report-service prototype, summary tables, Rust scope; 90-day review | SLO dashboard green 2 weeks | shadow mode |

**Gates:** 30 days — P0 met or ≥30% improvement on top-five scenarios. 60 days — P1 reports/exports/grids with no sale/purchase corruption. 90 days — 10-user p95, memory/CPU budgets, Rust go/no-go.

## Benchmark harness specification

```text
bench/
├─ README.md, config/scenarios.yaml, counters.txt, login.json
├─ sql/00_env.sql, 01_snapshot.sql, 02_diff.sql, 10_top_queries.sql,
│     20_wait_stats.sql, 30_index_usage.sql, 40_trace_start.sql, 41_trace_stop.sql
├─ ps/Run-Scenario.ps1, Measure-Startup.ps1, Measure-Ui.ps1,
│     Collect-PerfMon.ps1, Start-SqlTrace.ps1, Stop-SqlTrace.ps1,
│     Export-Trace.ps1, Invoke-MultiUser.ps1
├─ tools/procmon-config.pmc, wpr-profile.wprp
└─ results/2026-11-02-baseline/{runs}, index.csv
```

CSV: `run_id,scenario,phase,build,start_utc,end_utc,dur_ms,p50_ms,p95_ms,min_ms,max_ms,n,sql_stmts,sql_ms,sql_reads,sql_cpu_ms,proc_cpu_ms,peak_ws_mb,users,pass,notes`.

JSONL: `{"run_id":"...","scenario":"startup_warm","phase":"login_to_main","build":"pb12.5.2511","ts_utc":"...","dur_ms":47123,"sql":{"stmts":119,"ms":77.4},"proc":{"cpu_ms":10109,"ws_mb":138},"dialogs":[{"title":"Backup Information","ms":2000}],"result":"pass"}`.

Contract: quiet host (CPU <5%, no other sessions/backups) → DMV snapshots → start trace/PerfMon/UI capture → launch + auto-login → main/first sheet → stop → export trace → diff snapshots → append results. Cold runs need scheduled reboots (5); warm 20. Multi-user needs 10 RDP sessions or VMs; verify whether the single-instance mutex is global before relying on RDP.

## Risk register

| Risk | Likelihood | Impact | Signal | Mitigation | Rollback |
|---|---|---|---|---|---|
| Plan regression from stats/index | High | High | p95 +>10%, new sorts/spills | One change at a time; store plan XML; compare reads | drop index/restore copy |
| Compatibility 80→100 changes behavior | Med | High | SQL errors, different plans | Full regression on copy; 2-user pilot | `ALTER DATABASE ... COMPATIBILITY_LEVEL=80` |
| Index write amplification (SaleDetail/Purdetail) | Med | Med | insert/update latency, page splits | Cover only hot reads; monitor write waits | drop index |
| Schema/type change breaks PB binds | Med | High | SQL errors, truncated values | Stage on copy; query/report diff | restore copy |
| Dialog removal hides license/backup compliance | Med | High | missed expiry/backup | Non-modal status; legal review; license check unchanged | re-enable dialog |
| User training/adoption | Med | Med | workarounds, missed steps | Champions, release notes, pilot group | revert UX change |
| Stale item/price cache | Med | High | wrong prices | TTL + invalidation + audit | disable cache |
| Measurement bias (human/warm/analysts/AV) | High | High | variance >15% | Machine vs human; quiet window; 20 runs; ProcMon | discard run |
| Express limits / EOL (10 GB, 1 GB, no patches) | Med | High | DB growth, memory pressure | Pre-size/archive/upgrade | restore/upgrade |
| No source / vendor dependency | High | High | cannot change app behavior | Request PBL/source; limit P0 to DB/config | n/a |

## One-page executive dashboard

```text
WASEELA PERFORMANCE — 2026-11-02
Baseline completeness: 2 of 19 core scenarios measured (startup n=1; memory/CPU).

RED    Startup (process → main, n=1, human)      47 s
GREEN  SQL time for startup                      0.08 s
GREEN  Idle memory / CPU                         138 MB / 0%
AMBER  DB size / Express cap                     3.5 GB / 10 GB
RED    Compatibility level                       80 (SQL 2000 optimizer)
AMBER  Top report scan (StockReport shape)       56,488 logical reads
UNKNOWN Reports, grids, Excel, print, backup, 10 users

Truth: the app is not slow because startup SQL is slow. It is slow because of
client work, dialogs and (probably) reports we have not measured.
Next 30 days: measure → stats/indexes → dialogs/auto-login → compat test.
Decision: approve a 1-week freeze, staging copy, maintenance window, and a
vendor request for PowerBuilder source.
```

## If you only do 5 things

1. **Measure for one week, change nothing.** Machine + human baselines for every core scenario.
2. **Fix statistics and the top report queries** — 7 big tables, `VirtualGl` covering columns, SaleLedger/Saledetail/StockReport.
3. **Remove startup friction** — dialogs, auto-login, conditional `SP_WayToMoon`, conditional cleanup.
4. **Stop full retrieves on the UI thread** — paging/TOP, server aggregation, streaming Excel.
5. **Test compatibility 100 on a copy** — the cheapest whole-database optimizer change available.

## Top 10 by ROI (provisional)

1. Statistics on 7 big tables (64).
2. VirtualGl covering index (32).
3. Excel export (18).
4. Report paging (13.5).
5. Pre-size/fixed growth (10.8; P0 hygiene).
6. Top-5 report queries (10).
7. Compat 100 (10).
8. Startup dialogs/auto-login (9.6).
9. Archive/purge (4).
10. Summary tables (2.1).

Rust/Tauri has no ROI score here: it is a strategic replacement, not the fastest latency fix.

## Implementation plan (ordered, with validation)

1. Freeze/baseline — warm p50 repeats ±10%, all scenarios captured.
2. Instrument — trace has Reads/Writes/CPU; dialog log matches screenshots.
3. P0 DB — top-10 p95 −30%, write latency +<10%, no errors.
4. P0 startup — cold ≤8 s, login→main ≤3 s, license/backup still work.
5. Compat pilot — 50 queries + 10 reports diff, 2 users, rollback tested.
6. P1 reports/exports — 10k report ≤2 s, export ≤5 s, grid 10k ≤100 ms.
7. P1 archive/cache — DB shrinks, no stale-price incidents.
8. P2 service/summaries — 10-user p95 ≤1 s, shadow parity.

## What NOT to do

- Do not start with Rust/Tauri; 2,062 windows, 8,748 DataWindows, no baseline.
- Do not add indexes everywhere; 358 nonclustered indexes already exist and sales/purchases are write-heavy.
- Do not change compatibility and indexes in the same window; you cannot attribute gains.
- Do not run Profiler GUI, ProcMon or heavy DMVs during baseline; use server-side trace and one scenario at a time.
- Do not shrink the DB or run `DBCC CHECKDB` as a performance fix.
- Do not patch PBD binaries or recompile decompiled source for production; 16,870 unresolved global calls make it a rebuild.
- Do not use indexed views, columnstore, online rebuild or Query Store on this Express instance; they need newer/Enterprise edition.
- Do not remove license/backup checks without legal review; replace blocking dialogs with non-modal status.

## Measurements still needed

```sql
-- Re-trace with missing columns (sa; 2008 R2)
DECLARE @id int;
EXEC sp_trace_create @id OUTPUT, 2, N'C:\...\bench\startup', 50;
EXEC sp_trace_setevent @id,10,1,1;  EXEC sp_trace_setevent @id,10,12,1;
EXEC sp_trace_setevent @id,10,13,1; EXEC sp_trace_setevent @id,10,14,1;
EXEC sp_trace_setevent @id,10,15,1; EXEC sp_trace_setevent @id,10,16,1;
EXEC sp_trace_setevent @id,10,17,1; EXEC sp_trace_setevent @id,10,18,1;
EXEC sp_trace_setevent @id,10,23,1; EXEC sp_trace_setevent @id,10,48,1;
-- repeat for 12/17/33; 43 (SP:Completed); 50 (only 1,3,12,13,21,23)
EXEC sp_trace_setstatus @id, 1;  -- start
```

- **Startup:** UIA poll 100 ms; `Start-Process -PassThru`; screenshot 250 ms; 20 warm / 5 cold. Cold = after reboot + SQL ready, not second launch.
- **PerfMon:** `Get-Counter '\Process(abuzar)\% Processor Time','\Process(abuzar)\Working Set','\SQLServer:Buffer Manager\Page life expectancy' -SampleInterval 1 -MaxSamples 120`.
- **File/registry/DLL:** `procmon.exe /AcceptEula /Quiet /Minimized /BackingFile bench\cold.pml /Runtime 180 /Terminate` (one cold run).
- **CPU/disk ETW:** `wpr -start GeneralProfile -start CPU -start DiskIO -filemode`, stop to `.etl`, analyze WPA.
- **Query/plan:** `SET STATISTICS IO, TIME ON` on top 10 reports; store `dm_exec_query_plan` XML before/after; compare logical reads.
- **Reports/exports/print/backup:** first stable frame at 30 fps; Excel file timestamp; `Get-PrintJob`; `msdb.dbo.backupset`.
- **Multi-user:** 10 RDP/VMs, synchronized start; 10 concurrent saves; capture `dm_tran_locks`, `dm_exec_requests`, error rate.
- **Cold-start check:** `LastBootUpTime` + `sys.dm_os_sys_info.sqlserver_start_time` + 60 s.

**Bottom line:** one good startup trace, one successful startup observation, and no report/grid/export/multi-user baseline. Fix that first, then buy the measurable seconds.
