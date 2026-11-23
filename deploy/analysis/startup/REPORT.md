# Startup / login / session bootstrap — findings

## Executive verdict

- **The database is not the startup bottleneck.** The complete SQL side of the captured startup is **64 ms of server busy time** across 85 app batch/RPC events. Of the 12.75 s wall time from first connection to last startup query, **12.49 s is the user sitting at the login window**; app-side pre-login work is **143 ms**.
- **The real cost is a ~14.1 s client-side wait before the first SQL connection.** `abuzar.exe` starts at 01:21:33 and the first observed SQL session is created at 01:21:47.130. For the whole 17-minute session the process used only **11.9 s CPU** and read **115 MB**; even allowing for uncounted memory-mapped I/O, 14 s of pure CPU/disk work cannot fit inside an 11.9 s CPU budget. It is a blocking wait inside the Open path — most likely a hard-coded `Sleep`/splash delay or a dead UNC/audio call.
- **There is no splash before login.** `w_logo` is opened *after* `w_login1` (trace: `LogoSelected` query at 01:16:01.120, after the login query at 01:16:01.060). The user stares at nothing for the 14 s.
- **After login the app re-does work it already has:** two `d_security` retrieves, a 313-row menu-rights loop with ~2,026 comma-string parses over 719 menu items, a fat `d_groups` retrieve for two values, three `RESTORE HEADERONLY` calls, and a DLL-existence check that spawns `cmd.exe` twice.
- **Fix the wait first, then defer the checks.** Removing the 14 s wait plus the backup/DLL/session/licence work is plausibly a **10–14 s** win. All SQL/index micro-tuning combined is **<0.2 s**.

## Evidence base

- Inspected `recovered/scripts/abuzarapp/` (28 windows/menus), `recovered/scripts/functions/`, `recovered/scripts/components/`, `recovered/datawindows/abuzarapp|multientrygroups|multientryitem|preferences/`, `recovered/pcode/abuzarapp/application/traderappv1.json`, `deploy/trace/app.trc`, `deploy/README-DEPLOY.md`.
- Recovered application object: `traderappv1.pbs` contains **only `ue_close`**; the Open event is not in the PBD. `abuzar.exe` embeds `ob.exe` (147,728 B) whose trailing reference table lists the Open path in order: `f_set_client_info → f_setlocalcomputername → f_get_database_status → w_autorecovery → f_firsttime_script → f_firsttimewks_limit → f_firsttime_waytomoon → f_insert_client_instance → f_create_temp_directory → w_login1 → f_firsttimelic → w_logo → f_set_other_client_info → …`. `w_startup` and `w_backupinfo` are **not** in that list.
- Trace: `fn_trace_gettable('C:\Projects\Abuzar\deploy\trace\app.trc', DEFAULT)` read-only. 316 events, 119 batch/RPC events total (85 from the app), window 2026-11-02 01:15:48.417–01:16:01.163. The captured run ended at `SP_WayToMoon` with two `Error 15281` events (xp_cmdshell was disabled at that moment); no `w_main` queries were captured before the trace stop. Warm-state costs were measured separately with `SET STATISTICS IO/TIME`.
- Live process: `abuzar.exe` PID 8796, start 01:21:33, `sys.dm_exec_sessions.login_time` 01:21:47.130/01:22:29.303/01:22:57.820/01:23:01.723, 137.6 MB working set, 11.9 s total CPU (`Win32_Process` Kernel+User), 115 MB read.
- Database: `SaleLedger` 588,832 rows / 643,592 KB; `users` 9 rows; `Rights` 463; `GroupRights` 687; `SoftwarePreferences` 1,308; `Item` 28,966; `StartupRight` 5; `GroupAllowedStartupRight` 0.

### Corrections to the brief

1. `d_security` is retrieved **twice** on the live path (`A` and `W`), not three times. The third is inside `w_main.wf_initsecurityapp` (`w_main.pbs:35-71`), which is **dead code** — `w_main.open:201` calls `lm_menu.mf_initsecurityapp`, i.e. `components/m_mainmenu.pbs:34-99`, which does **not** retrieve.
2. `f_firsttimelic` **does** run its `SaleLedger` aggregate on every login, but it does **not** scan 626 MB. The optimizer uses `PK_SaleLedger`/`Date_SaleInvCode_IDX`: measured **12 logical reads, 0 ms**. The waste is that its result is only used when `systextcatalog` does not exist, plus a 5.1 ms no-op `CREATE TABLE` batch.
3. **No runtime reference to `Script.mdb` was found.** There is no `Script.mdb`/`.mdb`/`Microsoft.Jet` string in `abuzar.exe`; the only `.mdb` reference in recovered code is `w_access.pbs:28` (`Data.mdb`, a separate access window). The app reads `dbo.Sequence` from SQL. The 29 MB Jet file is a deployment/migration artifact (`[hypothesis]`, but no code path found).
4. The splash (`w_logo`) is **after** login. There is no pre-login splash.
5. The observed “Backup Information” dialog is not opened by the recovered Open path. `w_backupinfo` is opened only from `w_startup.pbs:120` and `w_dbbackup1.pbs:68`; `w_startup.open` calls `f_getbackupinfo` unconditionally at `w_startup.pbs:71`. The trigger of the observed dialog is therefore outside the recovered PBL (`[hypothesis]`); the code that must be fixed is the same either way.

### Backup dialog mechanics (measured)

- `w_backupinfo.ue_postopen` (`w_backupinfo.pbs:3-49`) opens a **new** `u_transaction` (`:15-17`), calls `f_getbackupinfo` (`:32`), shares the result into `dw_backupinfo` (`:33`), and if `rowcount()=0` shows a modal messagebox (`:34-39`). `d_backupinfo.srd:41-...` retrieves a **one-row dummy SELECT of SPACE(255) columns**, so the `rowcount()=0` branch is normally unreachable; the user sees the dummy row with `N/A`/absurd age values.
- `w_startup.open` (`w_startup.pbs:52-104`) always runs the same `f_getbackupinfo` before it checks whether the startup-task list has rows (`:71` vs `:89`). With `GroupAllowedStartupRight = 0` rows on this deployment, the window is empty but the three-device backup check still runs.
- `f_getbackupinfo` loops the three device names (`f_getbackupinfo.pbs:71-132`) and issues `RESTORE HEADERONLY FROM <device>` with a hard-coded `alfia…`/`alcia…` password (`:102-105`), then `SQL execute`/`fetch`/`close` (`:106-129`) — 3–4 round trips per device. A failing `RESTORE` measured **~20–40 ms** each; the modal click (1–5 s) dominates the user-perceived cost.
- `f_getbackupdevicename` (`f_getbackupdevicename.pbs:7-39`) builds `FazalDinPP19V2DBDump`, `AutoClientFazalDinPP19DBDumpV2`, `AutoStartUpFazalDinPP19DBDumpV2`. The actual files are `Backup\FazalDinPP19V2DBDump.BAK` and `AutoBackup\AutoClientFazalDinPP19DBDump2.BAK` / `AutoStartupFazalDinPP19DBDump2.BAK`; no `sys.backup_devices` rows exist, so every restore errors.

## Startup timeline

Measured values are from the 01:15 trace and the 01:21 live process. “Est.” means client-side estimate; SQL is measured.

| # | Step | Evidence | ms | Fix | Expected saving |
|---|---|---|---|---|---|
| 0 | Double-click → process start | `Win32_Process.CreationDate` 01:21:33 | 0 | — | — |
| 1 | Pre-SQL Open wait | process CPU 11.9 s total, 115 MB read, first session 01:21:47.130 | **14,130 measured** | Find/remove `Sleep`/UNC/audio wait; native splash | **10,000–14,000** `[hypothesis on cause]` |
| 2 | `f_get_database_status` connect + `SP_CleanUp_Bad_Session` | trace 01:15:48.417→.460; cleanup 32.5 ms | 43 measured (32.5 SQL) | Reuse this connection; async/set-based cleanup | 25–35 |
| 3 | `f_firsttime_script` + `f_firsttimewks_limit` + `f_firsttime_waytomoon` | trace .540→.553; DDL 4.74 ms | 13 measured | Schema-version gate; one-time installer | 5–13 cold; lock risk removed |
| 4 | `f_insert_client_instance` | trace .553→.560; 2.7+2.9 ms | 7 measured | `IF NOT EXISTS`/`MERGE`, no write if same | 5 |
| 5 | `w_login1` first paint | no SQL; window creation | 20–50 est. | Show earlier; pre-connect | 10–30 |
| 6 | User types credentials | 01:15:48.560→01:16:01.050 | **12,490 measured** | Excluded from app budget; SSO/biometric later | n/a |
| 7 | `cb_ok` connect + `dbo.users` query | trace 01:16:01.050→.090 | 40 measured (0.2 SQL) | Reuse sqlca; prefetch user on `itemchanged` | 10–30 |
| 8 | `f_firsttimelic` + `f_islicenseexpire` + update | trace .090→.120; 5.1 + 1.8 ms | 30 measured | One bootstrap proc; skip unchanged date | 10–20 |
| 9 | `w_logo` connect + `LogoSelected` + two BMPs | trace .120→.130; EXE embeds 225,656 + 720,054 B | 30–80 est. | Use sqlca/pref cache; one BMP; delete splash | 20–60 |
| 10 | `w_main.open`: user/title, 2× `d_security`, filter | `w_main.pbs:175-199`; 313 + 150 rows, 3 ms each | 20–60 est. | One A+W query; cached rights map | 10–40 |
| 11 | `mf_initsecurityapp` + `wf_settimer` | 313 rows × 2 × level parses; `d_groups` + 2 DDDW | 40–150 est. | One-pass map; 2-column group select | 30–100 |
| 12 | Default sheet + item cache (28,966 rows) | SQL 389 ms/4,455 reads; `w_main.pbs:197-198` | 400–2,000 est. | Lazy/server-side item search | 400–2,000 on first screen |
| 13 | Backup/DLL checks + modal dialog | 3× `RESTORE` 55–120 ms; `SP_WayToMoon` 50–54 ms | 100–170 measured + click | Query `msdb.backupset`; remove DLL check; toast | 100–170 + dialog |

**Target budget**

| Scenario | Today | PB optimized | Rust/Tauri |
|---|---|---|---|
| Cold: process → login interactive | ~14.3 s | 4–6 s | 0.8–1.5 s |
| Warm: process → login interactive | ~14 s measured once | 3–4 s | 0.3–0.6 s |
| Login → `w_main` interactive | 0.4–2.5 s + dialog | 0.5–1.0 s | 0.15–0.30 s |
| End-to-end | 15–20 s | 5–7 s | <2 s |

## Findings

| ID | Finding | Evidence (file:line / SQL result) | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| S1 | **14.1 s zero-SQL wait before first connection** | start 01:21:33 → `login_time` 01:21:47.130; 11.9 s CPU and 115 MB read for whole session; `traderappv1` declares `sleep`/`sndplaysounda` but no recovered startup script calls them | Blocking wait (Sleep/UNC/audio/driver), not CPU or disk | Hook `Sleep`/`sndPlaySound`/network; remove delay; add native splash | **10–14 s** (measured gap; cause `[hypothesis]`) | S if Sleep, M if UNC | Low/Medium |
| S2 | Startup SQL is tiny | 85 app events, 64 ms busy; 143 ms pre-login wall | Proves indexes/SQL tuning will not fix startup | Stop tuning SQL for startup | — | — | — |
| S3 | 7 separate connections in one startup | 7× `sp_oledb_ro_usrname`; ~10–13 ms each | Each `SQL start` pays OLE DB init + provider rowsets | Keep one `sqlca`; pass it to windows | 50–80 ms measured | S | Low |
| S4 | `SP_CleanUp_Bad_Session` every start | 32.5 ms trace; 4 correlated subqueries over `sysprocesses`×`sysdatabases` | Cold compile + correlated scans | SQL Agent heartbeat/cleanup; set-based query | 25–30 ms cold | S | Low |
| S5 | Migration DDL every start | `f_firsttime_script.pbs:5-6`; `f_firsttimewks_limit.pbs:5-15`; 8 events, 13.3 ms | Compiles `ALTER TABLE` even when no-op; schema locks | `AppMeta.SchemaVersion` gate; remove after install | 5–13 ms cold; lock risk | S | Low |
| S6 | `f_firsttimelic` does unused work | `f_firsttimelic.pbs:8` query 12 reads/0 ms; `:15-16` 5.1 ms batch | Result only used if `systextcatalog` missing | Check table first; delete DDL | 5–10 ms | S | Low |
| S7 | Licence check writes every login | `f_islicenseexpire.pbs:25,50,54,63-65`; update+commit 1.85 ms | 5 queries + write/log per user | One proc; update only if date changed | 5–10 ms + log | S | Low |
| S8 | `SP_WayToMoon` spawns `cmd.exe` twice per login | `f_firsttime_waytomoon.pbs:9`; measured 50–54 ms; trace errors 15281, then the captured run ended | Two `xp_cmdshell dir` + 2 round trips; hard gate | Delete check; disable `xp_cmdshell` | 50 ms/login measured | S | Low (security improves) |
| S9 | No runtime reference to `Script.mdb` | no string in EXE; only `.mdb` reference is `w_access.pbs:28` (`Data.mdb`); `Sequence` read from SQL | No 29 MB Jet read to optimise | Leave it | 0 | — | — |
| S10 | `w_logo` extra connection + two embedded BMPs | `w_logo.pbs:30-38`; EXE embeds 225,656 + 720,054 B | 1 connection + 2 BMP decodes on login→main path | Reuse sqlca, read pref cache, one BMP, drop splash | 20–60 ms est. | S | Low |
| S11 | `w_startup` always runs backup info | `w_startup.pbs:52-54,71`; 3× `RESTORE` in `f_getbackupinfo.pbs:102-113` | 3 devices × 3–4 round trips; runs even with 0 rows | Guard on rowcount; move to `msdb.backupset`; toast | 50–150 ms + dialog | S/M | Low |
| S12 | Backup device/password naming always fails | `f_getbackupdevicename.pbs:7-39` builds `FazalDinPP19V2DBDump`; actual `Backup\FazalDinPP19V2DBDump.BAK`; wrong `alfia…` password | RESTORE errors → N/A dialog + user click | Config table of devices; query `msdb` metadata | 1–5 s perceived | S | Low |
| S13 | `d_security` twice; dead third retrieve | `w_main.pbs:181-190`; dead `w_main.pbs:35-71`; `d_security.srd:7-33`; 313/150 rows, 3 ms | 2 round trips + 2 DW parses | One A+W query; delete dead function | 6–10 ms + parse | S | Low |
| S14 | Menu rights loop reparses strings ~2,026× | `m_mainmenu.pbs:18-32,59-95`; 719 menu items; 313 rights (7/51/131/109/15 by level) | `mf_findindex` scans from string start for every level and both `field2`/`field4` | Parse path once; `RightCode→MenuItem` map; cache bitmask | 20–100 ms `[hypothesis]` | M | Low |
| S15 | `wf_settimer` fat `d_groups` retrieve | `w_main.pbs:99-114`; 17 columns + 2 `dddw.autoretrieve=yes` | 3 queries for 2 values; DW parse | `SELECT AutoRefreshItemList,Time`; cache group code | 5–20 ms | S | Low |
| S16 | `f_stringpreferences` linear search | `f_stringpreferences.pbs:8`; 1,308 rows; called from `w_main.pbs:96` and many windows | O(n) `find` with `lower(name)` per call | Load into `StringMap`/sorted array | 5–20 ms | S | Low |
| S17 | 28,966-row item cache may load before first screen | `f_refreshitemlist.pbs:12-45`; SQL 389 ms/4,455 reads; `w_main.pbs:197-198` filters it | Full `Item` scan + PB fetch + filter | Lazy load; server-side paged search; cache delta | 0.4–2 s first screen | M/L | Medium |
| S18 | Login security is client-side plaintext | `w_login1.pbs:226,258-260`; `sqlca.logid="sa"` `:210`; `users` 9 rows, no username index | Not a startup cost (2 reads) but critical exposure | Hash server-side; least-privilege login; add index only if users grow | ~0 ms | M | High if ignored |
| S19 | Redundant title query | `w_main.pbs:175` `SELECT username,getdate()`; login already has username | 1 round trip (4 cursor RPCs) | Pass username/client date | 0.3–4 ms | S | Low |
| S20 | F5 at login runs `DBCC CHECKDB` | `w_login1.pbs:335-337`; `w_checkdb.pbs:76` | Can block for minutes/hours | Admin-only, confirmation, background | minutes risk | S | Medium |

## Top 10 by ROI (ranked)

1. **Find and remove the 14 s Open wait.** Use API hooking/ETW to see whether the gap is `Sleep`, `sndPlaySound`, or a UNC/SMB timeout. This is worth more than every other item combined.
2. **Add a native pre-login splash + preloader.** A 200 KB native launcher can show the logo instantly, pre-open a SQL connection, and sequentially touch the hot PBDs while PBVM starts. Perceived 14 s → instant; actual maybe 0.1–0.3 s warm.
3. **Move the backup check off startup.** `f_getbackupinfo` should query `msdb.dbo.backupset`/`backupmediafamily` or a local heartbeat table, run after first paint, and show a non-modal banner.
4. **Collapse 7 connections to 1 and one bootstrap proc.** Connect in `f_get_database_status`, keep `sqlca`, run all first-time/licence/session/security reads on it.
5. **Delete `SP_WayToMoon` from login and disable `xp_cmdshell`.** 50 ms/login + critical RCE surface.
6. **Cache menu rights as a `RightCode→MenuItem` map/bitmask.** One query, one tree walk, no string parsing per row.
7. **Make the item cache lazy.** Load on first item search/POS, not before `w_main`; use server-side paging.
8. **Replace `f_stringpreferences` linear search with a map.** 1,308 rows × many calls.
9. **Remove migration DDL and the licence date write from login.** Schema-version gate; update only when the date changes.
10. **Trim/split the PBD library list.** 120 PBDs / 637 MB; the 150 MB `sprnt*` report PBDs are not needed to log in.

## Implementation plan (ordered)

1. **Instrument the 14 s.** ProcMon boot trace filtered on `abuzar.exe` + ETW CPU sample; API hook `Sleep`, `sndPlaySoundA`, `CreateFile` on UNC. Validation: a per-phase log from process start to first `SQLCA` connect.
2. **Remove the wait.** If `Sleep`, binary-patch a **copy** of the embedded `ob.exe` constant (scratch only) or rebuild; if UNC, fix the share/DNS or set a 1 s timeout; if audio, play asynchronously or skip. Validation: process→first SQL < 2 s on the copy.
3. **Add the native splash/preloader.** Show logo in <100 ms; pre-open DB; optionally read the hot PBD list sequentially. Validation: first visible pixel <300 ms; first SQL <1.5 s.
4. **One connection + bootstrap proc.** `sp_AppBootstrap @user` returns one scalar row + one rights result set; `w_startup`, `w_logo`, `w_checkdb` reuse `sqlca`. Validation: `sys.dm_exec_sessions` shows 1 app SPID during login.
5. **Off-path checks.** Remove `SP_WayToMoon`, move `SP_CleanUp_Bad_Session` to Agent, guard `w_startup` backup block, replace RESTORE with `msdb` query. Validation: no `RESTORE`/`xp_cmdshell` in the startup trace.
6. **Rights/preferences cache.** One-pass menu map; `StringMap` for prefs; 2-column group select. Validation: `mf_initsecurityapp` <10 ms, zero `find()` calls.
7. **Lazy item cache.** Defer `f_refreshitemlist` until first item search; server-side paged query. Validation: `w_main` interactive before any `Item` scan.
8. **PBD pruning.** Copy the app to scratch, remove unused `sprnt*`/module PBDs from the library list, measure. Validation: cold start −2 to −8 s; no missing-class errors in the exercised flows.
9. **Rust/Tauri target.** Pool, one bootstrap call, local SQLite cache for rights/prefs/licence, instant window, background refresh. Target <2 s cold.

## What NOT to do

- **Do not add indexes for startup.** `SaleLedger` startup queries use 12 logical reads; `users` is 9 rows. An index on `username` buys ~0 ms.
- **Do not move to SQL Server Enterprise or add memory for startup.** Startup SQL is 64 ms; the 14 s is client-side.
- **Do not run `DBCC CHECKDB` at login or startup.** It is a maintenance operation, not a health ping.
- **Do not add more licence/DLL/hardware checks.** `SP_WayToMoon` already costs 50 ms and requires `xp_cmdshell`.
- **Do not assume the splash covers startup.** `w_logo` is after login; the 14 s is a blank screen.
- **Do not cache licence validity in a client-editable file** without a signed token/server check; keep invoice enforcement server-side.
- **Do not rewrite the UI in Rust before removing the wait.** A Rust front end that ports the same `Sleep`/UNC call will be just as slow.

## Measurements still needed

- **Split the 14.1 s:** `procmon /BackingFile C:\temp\abuzar.pml /Quiet` then launch a **copy**; or `wpr -start CPU -filemode`, open in WPA. Look for `Sleep`, SMB `CreateFile` on `\\AZHAR\…`, and audio calls.
- **Per-step timestamps in `w_main.open`:** temporary build with `cpu()`/`Now()` writes around lines 175, 185, 190, 201, 202.
- **Menu loop cost:** `cpu()` around `lm_menu.mf_initsecurityapp` and `wf_settimer`.
- **Item cache cost:** `cpu()` around `gd_itemsinfo.retrieve`/`filter` in `f_refreshitemlist` and `w_main.open:197`.
- **Backup check cost:** `cpu()` around `f_getbackupinfo` and each `RESTORE`; compare with `SELECT TOP 1 backup_finish_date, backup_size FROM msdb.dbo.backupset WHERE database_name='FazalDinPP19DataBaseV2' ORDER BY backup_finish_date DESC`.
- **Timer(0) behaviour:** log `w_main.timer` invocations for 60 s to confirm whether `f_refreshitemlist` runs continuously.
- **PBD pruning experiment:** copy `deploy\Application` to scratch, remove `sprnt*.pbd` from the `.pbr`/library list, measure cold start; do not touch the running copy.

---

*Scope note: this report covers startup, login, splash, session bootstrap, licence/DB checks, the backup dialog, and synchronous pre-`w_main` steps only. General DataWindow SQL and the Rust rebuild are other analysts’ lanes; the Rust target above is a budget, not a design.*
