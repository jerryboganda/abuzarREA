# Network & Data-Access Architecture — findings

## Executive verdict
- The client is a 2-tier PowerBuilder app: a global `sqlca` over OLE DB `SQLOLEDB`, a second `u_transaction` in many windows, and a `\\localhost` named-pipe alias. Locally the wire is cheap (~0.26 ms/statement); the cost is the **number** of statements, not the transport.
- Login is dominated by two item-list queries (one executed twice): **900,187 logical reads, 2.27 s CPU, ~15.5 MB TDS** on one session — ~90% of its 1.0 M reads. This is the biggest data-access cost in the product.
- Writes are chattiest: DataWindow updates are one statement per row (a 20-line invoice ≈25 round trips), and purchase/return/transfer posting loops do **15–19 DB ops per invoice** — 100 invoices ≈1,500–1,900 round trips.
- The `FazalDinPP19` alias works only because the DB is local. For LAN use TCP; for WAN direct SQL is unusable (login 18–30 s, ~200 ms per scan, 90–100 s per 100-invoice post). Use RDS in the DB datacentre, or a local branch DB + outbox.
- Rust/Tauri: `tiberius` + `deadpool`/`bb8`, TCP only, one pool, batching/TVP, streaming, keyset pagination, local item cache. Keep SQL Server for OLTP but upgrade off 2008 R2/compat 80. PostgreSQL is a rewrite, not a speed switch.

## Evidence base
- **Static:** 2,780 `.pbs`; 4,090 `retrieve`; 5,110 `SetTransObject`; 264 `SQL START` vs 324 `SQL STOP`; 104 files with both; 251 files with a loop containing DB calls; 250 `create u_transaction`; 132 instance transaction objects; 75 never stopped/destroyed in-file; 9 `it_imagetrans` creates, 0 stops, 0 destroys; 218 `f_getgroupcode` calls; 82 `Async=1` assignments (41 pairs); 70 `CRS_*` tables / 31 `SP_CRS_*` procs; 35 procs set `XACT_ABORT`; 0 explicit `BEGIN DISTRIBUTED TRANSACTION`.
- **Live DMV (one idle client):** 4 sleeping sessions, all `Waseela (5)`, named pipe, `net_packet_size=4096`; session 51: 1,003,529 logical reads, 2,951 ms CPU, 3,790 writes (~15.5 MB at 4 KB/packet). No open transactions, no blocking.
- **Item queries:** #1 executed 2×: 598,692 reads, 1,438 ms CPU; #2 1×: 301,495 reads, 833 ms CPU. Total 900,187 reads / 2,271 ms CPU for two 27.8k-row lists.
- **Transport (32-bit `SQLOLEDB`, 1,000 × `SELECT 1`, best of 3):** direct pipe 153 µs; `\\localhost` pipe 264 µs; alias 257 µs; TCP loopback 172 µs; shared memory 180 µs. Fresh connect 5–8 ms; first connect/process 580 ms; pooled reconnect 0.38 ms. 28,966 × 2-column fetch: 4,096 B = 105 ms avg, 8,192 B = 60 ms, 32,767 B = 53 ms.
- **Database:** SQL Server 2008 R2 Express SP2, compat **80**, RCSI **off**, SIMPLE recovery, TORN_PAGE_DETECTION, 4,096 B packet, 0 linked servers, 1 default Agent job, `xp_cmdshell` on, Ad Hoc Distributed Queries off.
- **Script.mdb:** 29.4 MB / 7,968 rows; no reference in 2,780 scripts and no `Script.mdb` string in the client folder; `Sequence` is a 1-row table; no `Script` table exists. It is a deployment/rebuild artifact, not a login cost.
- **DBParm variants (all assignments):** (a) login to `master` (`w_login1.pbs:105`) and app DB (`:214`): `SQLOLEDB`, `CommitOnDisconnect='No'`, `DataBase=master|gs_dbname`, `APP=gs_app`, `WSID=host`, `PBTrimCharColumns=Yes`, `StripParmNames=Yes`; (b) health check (`f_get_database_status.pbs:24,34`): same but `CommitOnDisconnect='Yes'`, `APP=Waseela`, autocommit true; (c) MSDB job panels (`w_preferences:631`, `w_newpreferences:383`, `w_job_schedule:2738`, `w_sms_center:747`, CRS/child/parent panels): `DataBase=MSDB`; (d) master-DB admin/import (`w_fetch_linkservers:16`, `w_update_saleandreturncost:21`, `w_import_previoussalehistory:27`); (e) source-server import (`w_itemregrequest_form.pbs:186`): `gs_source_server/db` + `PBMaxBlobSize=1024000`; (f) Jet (`w_access.pbs:28` `Data.mdb`; `w_rightsmodification.pbs:139` `RightsClone.mdb`, `StaticBind='No',PBNoCatalog='YES'`); (g) dynamic remote (`nv_remote_datawindow.pbs:84`). **None sets PacketSize, MARS, ConnectTimeout, CommandTimeout, encryption, or TrustServerCertificate.**
- **Transaction objects:** `u_transaction` is an empty subclass of `transaction` with 449 p-code methods (stock, posting, CRS/sync) and no fields; each `create` + `SQL START` is a real connection. `SetTransObject` is used 5,110×, `SetTrans` only 6×; `SharedData` is used 238× (sale/POS share the loaded item list), but purchase/issue screens re-retrieve instead.

## Findings

| ID | Finding | Evidence (file:line / SQL result) | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| N1 | Item catalogue loaded at login, one list twice | DMV: 900,187 reads / 2,271 ms CPU; session 51 1.0 M reads, 3,790 writes/15.5 MB | 2.3 s CPU + 15 MB before the main window | Lazy-load one slim list; cache locally; refresh by version | 1.5–2.5 s local; 10–30 s WAN | M | Low |
| N2 | Item SQL is N+1 inside one statement | Plan: 26,246 rebinds ×3 on `PK_GodownDetail`; 26k-row sort cost 50.4; 300k reads/exec | Three stock subqueries re-run per item | Aggregate `GodownDetail` once; index `(ICode) INCLUDE (GCode,CurrQty)`; cover/drop `ORDER BY` | 5–20× | S–M (DB) | Low |
| N3 | PO/issue screens re-fetch all 27.8k items to show a few | `w_purchase.pbs:3202-3224`, `w_advancepurchase.pbs:2143-2165`; 25 sites | 7–15 MB + ~141 FETCH round trips per screen | Server-side `WHERE Icode IN (...)` or temp table; reuse loaded list | 6–15 s WAN; 0.8–1.5 s LAN | S | Low |
| N4 | Alias is a localhost named pipe | Registry `HKLM\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo` + 64-bit view; 32-bit app connects via Named pipe (DMV); 257 µs vs 153 µs direct | SMB loopback; alias is machine-local | TCP alias for LAN/WAN; direct pipe locally | ~1.7× per statement; 5–10% per screen | S | Low |
| N5 | Packet size 4,096 | DMV/config 4,096; 105 ms vs 53 ms at 32,767; 3,790 packets | More packets/syscalls/CPU | `PacketSize=32767` (code) or server setting (restart) | 1.5–2× bulk | S | Low |
| N6 | No connect/command/lock timeout, no deadlock retry | No settings; 0 matches for `1205`/`LOCK_TIMEOUT` | 15 s connect; infinite query; permanent UI freeze | 5–10 s connect, 30–60 s command, `LOCK_TIMEOUT 5000`, retry 1205 | No permanent freezes | S | Low |
| N7 | Connection per window; fragmented pools | 250 `create u_transaction`; 104 files `SQL START`; 4 sessions; 0 `SetTransPool`; first connect 580 ms, pooled 0.38 ms | 5–8 ms/connect; idle sessions; pool fragmentation | One pool/`sqlca`; `SetTransObject`; standardise strings | Fewer sessions; faster open | M | Medium |
| N8 | Image view leaks a transaction object | `w_sale.pbs:8005-8007`; 9 sites, 0 stop/destroy | Reassignment orphans connection per view | Create once/reuse; stop on close | Flat session count | S | Low |
| N9 | Every client is `sa`, plaintext, `xp_cmdshell` on | `w_login1.pbs:101,210`; `f_get_database_status.pbs:20`; `xp_cmdshell=1` | Any client is sysadmin; no audit; credential extractable | Least privilege/Windows auth; TLS; disable `xp_cmdshell` | Security/audit | M | High |
| N10 | Ledger reports rebuild 2M-row VirtualGL under `TABLOCKX` | `sp_VirtualGL`: `TRUNCATE VirtualGLTemp` + `SELECT COUNT(*) ... (TABLOCKX)`; 15 calls in `f_retrieve_report1` | Minutes of exclusive lock; shared temp table | Nightly snapshot; per-session temp; read-only report DB | Minutes → seconds | M–L | Medium |
| N11 | No async; `Async=1` after connect is a no-op | 0 `SharedObject`; 82 `Async` assignments (`w_sale.pbs:605-607`); PB 12.5 has no async DW retrieve | UI blocks every retrieve/report | Separate report process; DataStore in shared object | Responsive UI | M | Medium |
| N12 | DataWindow updates are one statement per row | `w_sale.pbs:549-572`: 5 `update()` calls; 20 lines ≈25 RTT | 1 round trip per row | Proc/TVP/multi-row INSERT | 10–20× WAN | M | Medium |
| N13 | Posting is a per-invoice loop | `w_purchase.pbs:4185-4549` 18/invoice; `w_salereturnbuffer.pbs:1960-2150` 19; `w_transfer.pbs:2630-2772` 15 | 1,500–1,900 RTT/100 invoices | One set-based proc per range/TVP | 10–50× | M | Medium |
| N14 | 70-table cursor sync/CRS in one transaction | `SP_SyncTransactionData_OnRemote` 14.5 KB cursor + `SP_COLUMNLIST`; `SP_CRS_ClientDataTransfer` 6.5 KB; 35 procs set `XACT_ABORT`; `w_datasync.pbs:157-190` | Hundreds of remote statements + potential MSDTC + locks | Outbox/inbox + batch ETL; no MSDTC | Minutes → seconds | L | High |
| N15 | 30+ pre-login queries + 3 `RESTORE HEADERONLY` | App fnrefs: config ×6, client instance, DDL checks, `f_getbackupinfo`; 3–4 startup connections | 25–35 RTT + file I/O before login | Cache config/licence; drop backup dialog; one connection | 0.3–1 s local; 1.5–2 s WAN | S–M | Low |
| N16 | `f_getgroupcode` 218× uncached, no `WHERE` | `functions/f_getgroupcode.pbs:7`; `vf_` variant used once | 1 RTT per call; always returns 2 | Cache once; add `WHERE UserCode` | 60 ms LAN / 10 s WAN | S | Low |
| N17 | Script.mdb is a red herring | 29.4 MB; no refs; `Sequence` 1 row; no `Script` table | Not in login path | Remove if installer doesn't need; don't optimise | None | S | Low |
| N18 | Transaction boundaries ambiguous | `CommitOnDisconnect` No/Yes; `w_purchase.pbs:553-575` mixes `sqlca`/`it_transobject`; session 51 ended `COMMIT TRAN` | Wrong-object rollback; partial commits | `No` everywhere; one tx/flow; explicit; `XACT_ABORT` | Integrity | S–M | High |

## Connection / round-trip inventory

Static counts are worst-case; local uses measured 0.26 ms RTT + measured CPU; WAN assumes 50 ms RTT.

| Screen / flow | Conns | Queries | Commits | RTTs | Local est. | WAN 50 ms | Basis |
|---|---:|---:|---:|---:|---:|---:|---|
| Cold start → login | 2–3 | ~25 | 5–7 | ~30 | 0.6–1.0 s | 1.7–2.5 s | Static + 580 ms first connect |
| Login → `w_main` | 3–4 | ~15 + 2 item lists (282 FETCH) | 1–2 | ~310 | 2.5–3.6 s | 24–30 s | DMV CPU + 15.5 MB |
| Open sale screen | 1–2 | ~10 | 0–1 | ~12 | 15–55 ms | 0.6–0.8 s | Static |
| Barcode scan | 0 new | 4 | 0 | 4 | 3–11 ms | ~210 ms | `w_sale.pbs:4222-4255` |
| Save 20-line sale | 0 new | ~25 | 1 | ~25 | 15–40 ms | 1.3 s | Static |
| Post 1 sale / N header-wise | 0 new | 3 | 1 | 3 | 20 ms–2 s | 0.35–2.2 s | Static |
| Purchase post, 100 | 0 new | ~1,800 | 1 | ~1,800 | 1.5–5.5 s | 90–100 s | `w_purchase.pbs:4185-4549` |
| Sale-return post, 100 | 0 new | ~1,900 | 1 | ~1,900 | 1.5–6 s | 95 s | `w_salereturnbuffer.pbs:1960-2150` |
| Transfer post, 100 | 0 new | ~1,500 | 1 | ~1,500 | 1–5 s | 75 s | `w_transfer.pbs:2630-2772` |
| Ledger report | 0 new | 1 proc + 1 commit + 1 retrieve | 1 | 2 + fetches | 1–10 min | 1–10 min | `sp_VirtualGL`, 2M rows |
| Sync / CRS (70 tables) | 1 | 3–4 procs, 200+ remote statements | 1 | 200+ | 2–30 min | hours | Cursor + `SP_COLUMNLIST` |
| Preferences / job schedule | 1 MSDB | ~20 + 2 retrieves | 0 | ~25 | 30–110 ms | 1.3 s | `w_job_schedule.pbs` |
| Item image view | 1 new (leak) | 2 | 0 | 2 | 8–20 ms | 0.1 s | Accumulates per view |

**Top static counts** (source worst case, not a runtime trace; `Describe`/`Modify` are client-side and excluded):

| File | SELECT | I/U/D | Retrieve | Commit | SetTransObject | SQL START |
|---|---:|---:|---:|---:|---:|---:|
| `salewin/w_sale.pbs` | 122 | 17 | 106 | 34 | 120 | 9 |
| `purchasecomponents/w_purchase.pbs` | 58 | 33 | 50 | 14 | 49 | 5 |
| `poscomponents/w_postsale.pbs` | 57 | 12 | 39 | 16 | 52 | 3 |
| `servicesalescomp/w_service.pbs` | 42 | 13 | 55 | 23 | 60 | 3 |
| `advancedsale/w_advancedsale.pbs` | 53 | 8 | 55 | 12 | 55 | 0 |
| `salereturncomponents/w_salereturn.pbs` | 60 | 6 | 31 | 13 | 36 | 2 |
| `salereturncomponents/w_salereturnbuffer.pbs` | 55 | 4 | 30 | 8 | 38 | 1 |
| `transfer/w_transfer.pbs` | 20 | 5 | 44 | 4 | 43 | 0 |
| `reportviewer/f_retrieve_report1.pbs` | 4 | 0 | 85 | 31 | 34 | 0 |
| `preferences/w_preferences.pbs` | 6 | 0 | 48 | 5 | 47 | 2 |

Full 2,780-file ranking: `deploy/analysis/dataaccess/roundtrip_scan.csv`.

## Data-access configuration checklist

| Setting | Current | Recommended | Why | Risk |
|---|---|---|---|---|
| Provider | `SQLOLEDB` | `MSOLEDBSQL` if PB 12.5 32-bit passes; else keep until rebuild | Deprecated; TLS/perf/support | Driver compatibility |
| DataSource | `FazalDinPP19` → `\\localhost` pipe | TCP `server,port` (LAN/WAN); direct pipe local | Routable, faster, no SMB | Firewall/Browser/static port |
| CommitOnDisconnect | No (login), Yes (health) | No everywhere + explicit commit | Avoid commit-on-close | Locks if forgotten |
| PBTrimCharColumns / StripParmNames | Yes / Yes | Keep | Less wire data, smaller RPC | None |
| PacketSize | absent → 4,096 | 32,767 | Measured 2× on bulk | Small-query CPU; test |
| ConnectTimeout / CommandTimeout | absent → 15 s / infinite | 5–10 s / 30–60 s (300 s reports) | No permanent freeze | Long reports; per-report override |
| MARS | off | Leave off | Not needed for sequential DWs | None |
| Use Encryption | off | On after SQL upgrade; `TrustServerCertificate=No` | Plaintext today | 2008 R2 SP2 TLS 1.0 |
| Pooling | OLE DB default on; no `SetTransPool` | Keep; `SetTransPool(2,10,30)` if using `Connect` | Reuse works (0.38 ms) | Stale sessions/locks |
| Login | `sa` | Least privilege/Windows auth | Security/audit | Permission mapping |
| Autocommit / isolation | false/true mixed; RC | Explicit; RC + RCSI | Clear boundaries; readers don't block | Tempdb/version store |
| max worker threads / MAXDOP / cost | 0 / 0 / 5 | Leave / 1–2 / 50 | Avoid parallel report plans | Report speed |
| max server memory | unlimited (Express 1 GB cap) | Upgrade edition; set max memory | Buffer pool is the limit | Licensing |
| Compatibility level | 80 | 100/110 after test | Modern optimizer/`MERGE` | Plan regressions |
| Page verify / recovery | TORN_PAGE / SIMPLE | CHECKSUM / FULL if PITR | Integrity/restore | Log volume |
| Linked servers | none | Outbox/ETL, not UI linked servers | No MSDTC; survives WAN | Rewrite |
| `xp_cmdshell` / Ad Hoc | on / off | off / off after licence rework | Security | Licence check |
| `autorefreshitemlist` | N (off) | Keep off; use change feed if needed | Full list per tick | Config drift |

## Topology recommendation

| Deployment | Topology | Transport | Expected latency | Notes |
|---|---|---|---|---|
| Single PC | SQL Express local; one process | Direct pipe/shared memory; no alias | 20–100 ms simple; 1–2 s login after cache fix | No `\\localhost`; local backup |
| LAN 5–30 clients | SQL Standard on server; wired 1 Gbps | TCP 1433 static; packet 32,767; one pool/client | 50–300 ms simple; 5–20 s per 100-invoice post | No named pipes; report process; fix item query |
| WAN 20–80 ms | **RDS in DB datacentre**, or local branch SQL + outbox | RDS remoting; or local TDS + background batches | RDS 50–200 ms; local 20–100 ms; direct SQL 18–30 s login | Direct PB over WAN unusable |
| Multi-branch/CRS | Central + branch SQL; outbox/inbox; background sync; central reporting DB | Batched TDS/HTTPS; no linked servers/MSDTC | Seconds per batch, not minutes per screen | Replaces 70-table cursor |

**Target architecture for the current app:** one TCP pool per client (single `sqlca`), a local read-through cache for item/price/stock, set-based stored procs for all writes, a separate report process on a read-only connection, and outbox tables for sync. No per-window connections, no linked servers in the UI, no `sa`, no `TABLOCKX` reports. This keeps PB 12.5 but removes the round-trip multiplier and the blocking.

The numbers make the WAN verdict non-negotiable: 282 FETCH round trips + 2.3 s CPU is 16–30 s at 20–50 ms RTT before `w_main`; a scan is 4 RTT (~200 ms); 100-invoice posting is ~1,800 RTT (~90 s). Only RDS or a local DB removes the RTT multiplier.

## Future data access (Rust/Tauri)
- **Driver/pool:** `tiberius` (TDS 7.2/7.3) + `deadpool-tiberius` or `bb8-tiberius`; one pool per process, 10–20 connections, 30-min lifetime, 5-min idle. Tiberius is TCP-only — it forces the TCP topology above.
- **Queries:** `client.prepare` + typed params / `sp_executesql`; never concatenate. Batch 500–1,000 rows per INSERT or use TVP (SQL 2008+, compat 100+); `MERGE` for upserts.
- **Reads:** `QueryStream`/`RowStream` into Serde/Arrow; keyset pagination (`WHERE (Name,Icode) > (@n,@i) ORDER BY ...`) because 2008 R2 lacks `OFFSET/FETCH`; upgrade to 2012+ for `OFFSET/FETCH` or use `ROW_NUMBER()`.
- **Cache:** local SQLite item/price/stock snapshot; invalidate by `LastUpdate` max or Change Tracking; 30–60 s stock TTL. The item list is global (GroupCode=2), so one snapshot serves all users.
- **Reports:** separate async task/process with a read-only connection; render PDF/Excel off-thread; never block the UI.
- **SQL Server vs PostgreSQL:** keep SQL Server for OLTP (620 procs/71 functions, 1,717 FKs); upgrade to 2019/2022 Standard for buffer pool, columnstore, Query Store, TLS 1.2 and `OFFSET/FETCH`. PostgreSQL is XL: rewrite procs (`MERGE`→`ON CONFLICT`, `OUTPUT`→`RETURNING`, `TOP`→`LIMIT`), redo collation/`money`/`datetime`, and move business logic into Rust. Use PostgreSQL first for a new analytics/reporting store, not the OLTP core.

## Top 10 by ROI
1. Cache/lazy-load the item catalogue (N1): 2.3 s + 15.5 MB every login.
2. Rewrite the item SQL (N2): 300k reads/exec → ~10–20k.
3. Server-side item filter for PO/issue (N3): stop downloading 27.8k rows for 20.
4. TCP alias + `PacketSize=32767` (N4/N5): 1.5–2× bulk and a deployable LAN.
5. Timeouts + lock timeout + deadlock retry (N6): no permanent POS freezes.
6. Set-based posting (N13): 10–50× on purchase/return/transfer.
7. Batch DataWindow writes/TVP (N12): 10–20× on invoice save over WAN.
8. Report process + precomputed VirtualGL (N10/N11): minutes → seconds, no blocking.
9. One pool + fix `it_imagetrans` (N7/N8): stability, fewer sessions.
10. RCSI + least-privilege login (N9 + checklist): concurrency and security.

## Implementation plan (ordered)
1. **Baseline:** snapshot `sys.dm_exec_query_stats`/`sys.dm_exec_sessions`; record login, sale, purchase post. Validation: before/after `total_logical_reads` delta.
2. **Transport:** client alias to TCP (or direct pipe locally); keep 32/64-bit in sync. Validation: `net_transport=TCP`; p95 statement latency.
3. **Item query:** add `GodownDetail(ICode) INCLUDE (GCode,CurrQty)`; aggregate stock once; test in a copy. Validation: rebinds 26,246 → 1; reads drop >80%.
4. **Client cache/filter:** one slim list lazily; `WHERE Icode IN (...)`; cache group/security/config. Validation: login time and `num_writes` drop >80%.
5. **Hardening:** `PacketSize=32767`, timeouts, `LOCK_TIMEOUT`, retry 1205; remove per-window `SQL START`; fix `it_imagetrans`. Validation: kill a query and see a timely error; image view 20× leaves session count flat.
6. **Write batching:** TVP/proc for invoice details and posting; one commit per batch. Validation: trace `rpc_completed` for 100 invoices; target <50.
7. **Reports/sync:** separate report process; nightly VirtualGL; outbox/ETL. Validation: report while posting shows no blocking; network drop mid-sync retries cleanly.
8. **Security/upgrade/Rust:** least privilege, TLS, SQL 2019/2022, compat 110, RCSI; then build the Rust layer alongside. Validation: per-user audit; TLS handshake; plan-regression test.

## Quick wins (no source changes) vs needs code/rebuild

**No client source changes:**
- Change the client alias to TCP (or direct local pipe) via `cliconfg`/registry.
- Put WAN users on RDS in the DB datacentre.
- Enable RCSI; add the `GodownDetail(ICode)` and `VirtualGL(AccCode)` indexes (DB maintenance window).
- Raise server `network packet size` only if a restart/test window exists.
- Upgrade SQL Server edition/version/storage; keep `autorefreshitemlist='N'`.

**Needs code/rebuild:**
- `PacketSize`, connect/command timeouts, encryption in the five hard-coded DBParm strings.
- One pool; remove per-window `SQL START`; fix the `it_imagetrans` leak.
- Cache item/group/security/config; server-side item filter; rewrite item SQL.
- Batch updates/posting; report process; precomputed VirtualGL.
- Outbox/ETL for sync/CRS; least-privilege login; Rust/Tauri data layer.

## What NOT to do
- Don't enable MARS as a speed fix; the app is sequential and MARS adds overhead.
- Don't blanket `NOLOCK`; it hides blocking and returns dirty data.
- Don't move to PostgreSQL expecting speed; you would rewrite 620 procs and still have the same design.
- Don't set `PacketSize=32767` server-wide without a restart/test window.
- Don't run ledger reports on `sqlca` while POS is active; `sp_VirtualGL` takes `TABLOCKX` on 2M rows.
- Don't use named pipes across a WAN/subnet; use TCP or RDS.
- Don't rely on `Async=1` after `SQL START`; it doesn't apply to DataWindow retrieves.
- Don't optimise Script.mdb; it isn't in the login path.

## Measurements still needed
- **Per-screen round trips:** Extended Events on `sql_batch_completed`/`rpc_completed` filtered by `program_name LIKE 'Waseela%'` for one login/sale/post.
- **Fetch block size:** `SELECT * FROM sys.dm_exec_cursors(0)` during a retrieve; or count `FETCH` executions in `sys.dm_exec_query_stats` (282 observed for two lists). Run DMV queries from `master` to avoid compat-80 `CROSS APPLY` restrictions.
- **`sp_VirtualGL`:** in a **copy**, `SET STATISTICS TIME,IO ON; EXEC sp_VirtualGL 'A';` plus `sys.dm_tran_locks`. Never in production.
- **WAN latency:** `Test-NetConnection -ComputerName <server> -Port 1433`; `ping -n 20 <server>`.
- **Leak:** open the image view 20×; `SELECT COUNT(*) FROM sys.dm_exec_sessions WHERE program_name LIKE 'Waseela%'` must stay flat.
- **Packet A/B:** test PBD with `PacketSize=32767`; measure 10 screens and `num_writes`.
- **`Async`:** set before `SQL START`, block a lock, see if the UI responds; otherwise remove the 82 toggles.
- **Pooling:** after 1 h with 20 clients, count sessions by `program_name`/`host_name`.
- **Compat upgrade:** capture top 50 plans before/after `COMPATIBILITY_LEVEL=110` in a copy.
