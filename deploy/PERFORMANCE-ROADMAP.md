# Abuzar / Waseela — complete performance & architecture roadmap

**Prepared:** 2026-11-02  
**Basis:** 10 parallel analyst reports over the deployed copy (`deploy/Application`, `FazalDinPP19DataBaseV2`), read-only. Full evidence: `deploy/analysis/`.

> **Implementation status (2026-11-02):** the P0 database/config layer is **applied and verified** on the deployed copy: hot indexes, statistics, file/tempdb sizing, `SP_StockReport`, `SP_WayToMoon`/`xp_cmdshell=0`, `fn_getSaleInvTotal` O(1), rebuilds, nightly maintenance, 86 FKs validated, ACL hardening, fiscalization listener on 9111, `SP_VirtualGL`/`SP_STOCKLEDGER` watermark gates, cold-start diagnostic + logon preload, and the splash launcher. **SQL Server 2022 Express (16.0.1000.6) is installed and live** with compatibility **160**, Query Store, page compression, and a **1,409 MB** buffer pool; the old 2008 R2 database is READ_ONLY as the rollback. See `deploy/IMPLEMENTATION-REPORT.md` and `deploy/SQL2022-MIGRATION.md`. The app-side/P1/P2/P3 items below remain as the roadmap.

> **Freshness caveat.** The restored database is a **January-2025 snapshot** with 2 customers, 9 users, 28,966 items, 588,865 invoices, and **505 of 752 tables empty**. Timings prove plan shape, not production cardinality. Re-run the benchmarks on a production backup before committing to DDL/index changes.

---

## 0. The blunt answer

- You **cannot** make a 32-bit PowerBuilder 12.5 p-code client "100% like a Rust & Tauri app" by tuning it. Tauri wins on startup, memory, installer size and rendering; it does **not** fix SQL or report costs.
- The app is slow for **six measured reasons**, not because it is written in PowerBuilder:
  1. A **14.1-second client-side wait before the first SQL connection** (cause unproven).
  2. The **item catalogue loaded at login**: 900,187 logical reads, 2.27 s CPU, ~15.5 MB TDS, one list executed twice.
  3. The **per-row `fn_getSaleInvTotal` UDF** used by 584 DataWindows: daily sales **1.59 s vs 0.116 s** without it (13.7×).
  4. **`VirtualGl` and `StockReport` heaps**, plus **synchronous `SP_VirtualGL` / `SP_STOCKLEDGER`** rebuilds that take `TABLOCKX` before reports.
  5. **Full-result retrieves, print preview, Excel and PDF on the single UI thread** (4,090 retrieves, no `Retrieve.As.Needed`, 2,275 print layouts).
  6. **Chatty writes and no timeouts/pooling** (15–19 DB ops per invoice, 250 transaction objects, 4 sessions, no `SetTransPool`).
- The **database** fixes are mostly deployable **now** without source. The **client** fixes mostly need the original PBL/PowerScript or a rebuild. That distinction is the most important planning fact in this document.
- A focused Rust/Tauri MVP is **3–6 months / $80–160k**; the operational core is **9–12 months / $200–330k**; full parity is **24–36 months / $0.8–2.0M**.
- Recommended sequence: **P0 DB/config now (days) → P1 DB/report SQL (weeks) → P2 architecture/SQL upgrade (months) → P3 Tauri strangler (quarters)**.
- If you only do five things: **measure the 14 s wait, add the three indexes + stats, make `fn_getSaleInvTotal` cheap, stop synchronous VirtualGl/StockLedger, and move Excel/PDF/print off the UI thread.**

### What "Rust/Tauri fast" means here

| Layer | What Tauri buys | What it does not fix |
|---|---|---|
| Cold start / memory / installer | 10–20× better (≈0.8–1.5 s, 150–200 MB, <35 MB installer) | PBVM/PBD load, SQL connect, dialogs |
| Window open / grid render | 2–5× better | Window business logic, security/menu work |
| Report SQL / aggregation | ≈1× — same SQL, same DB | UDFs, heaps, missing indexes, `TABLOCKX` |
| Print / Excel / PDF | 3–10× better with a Rust renderer/streamer | Pixel parity, printer drivers, paper |
| Maintainability / hiring | Much better long-term | 2,062 windows / 8,748 DataWindows of scope |

**Conclusion:** Tauri is the right destination for the client, but the database and report SQL must be fixed first — otherwise the new client will faithfully render the same slow queries.

---

## 1. What is actually slow (measured)

### 1.1 Startup: the 14-second blank screen

| Phase | Measured / estimated | Evidence | Fix | Expected saving |
|---|---:|---|---|---:|
| Process start → first SQL session | **14,130 ms** | Process start 01:21:33; first session 01:21:47.130; whole 17-min session used 11.9 s CPU / 115 MB read | ProcMon/ETW + API hook on a copy; suspect PBVM/PBD load, AV, UNC/SMB, audio; add native splash | **10,000–14,000 ms** (cause must be measured) |
| First connection + `SP_CleanUp_Bad_Session` | 43 ms (32.5 SQL) | Trace 01:15:48.417→.460 | Reuse connection; set-based cleanup or SQL Agent/Task Scheduler heartbeat | 25–35 ms |
| First-time DDL/DML checks | 13 ms | `f_firsttime_script`, `f_firsttimewks_limit`, `f_firsttime_waytomoon`; 8 events | Schema-version gate; run DDL once at install | 5–13 ms + lock risk |
| `f_insert_client_instance` | 7 ms | Trace .553→.560 | `IF NOT EXISTS`/`MERGE`; skip if same | 5 ms |
| `w_login1` first paint | 20–50 ms est. | No SQL; window creation | Show earlier; pre-connect | 10–30 ms |
| Human typing at login | **12,490 ms** | Trace 01:15:48.560→01:16:01.050 | Exclude from app budget; SSO/biometric later | n/a |
| Login query + license + update | 30 ms | Trace .090→.120; 5.1 + 1.8 ms | One bootstrap proc; skip unchanged date | 10–20 ms |
| `w_logo` + 2 embedded BMPs | 30–80 ms est. | `w_logo.pbs:30-38`; EXE embeds 225,656 + 720,054 B | Reuse `sqlca`; one BMP; drop splash | 20–60 ms |
| `w_main` security + menu + timer | 20–150 ms est. | `w_main.pbs:175-202`; 313/150 rights; 719 menu items; ~2,026 parses | One A+W query; cached rights map; 2-column group select | 30–100 ms |
| Item cache (28,966 rows) | 389 ms SQL / 4,455 reads; 0.4–2 s client | `f_refreshitemlist.pbs:12-45`; DMV 900k reads for two lists | Lazy/server-side paged search; cache delta | 0.4–2 s first screen |
| Backup `RESTORE HEADERONLY` ×3 | 110–190 ms + modal | `f_getbackupinfo.pbs:102-108`; pref `CheckManualBackupHealthAtStartUp=Y` | Set pref `N`; `msdb.dbo.backupset`; non-modal toast | 0.3–3 s + click |
| `SP_WayToMoon` ×2 `cmd.exe` | **49.6–54 ms** | `f_firsttime_waytomoon.pbs:9`; measured 496 ms/10 calls | Remove or `xp_fileexist` (0.6 ms) | ~48 ms |
| Licence check + write | 10–60 ms startup; 2–10 ms/window | `f_islicenseexpire.pbs:25,50,54,63`; 6 RT + update | Signed file + cache; never in `ue_postopen` | 10–60 ms + per-window |
| 7 OLE DB connections | ~10–13 ms each | 7× `sp_oledb_ro_usrname`; 4 live sessions | One `sqlca` + `SetTransPool` | 50–80 ms |
| **End-to-end, successful run** | **47 s (n=1)** | Process 01:21:33 → title 01:22:20; includes human login + Backup modal | Native splash; auto-login; defer checks | **target 5–7 s** |

**Key point:** startup SQL is **64–77 ms**. Do not tune indexes for startup. The 14 s blank screen is the prize.

### 1.2 Login → main: the item catalogue is the hidden cost

- One session accumulated **1,003,529 logical reads** and **2,951 ms CPU**; two item-list queries account for **900,187 reads / 2,271 ms CPU / ~15.5 MB TDS**.
- The item SQL is N+1 inside one statement: the plan shows **26,246 rebinds ×3** on `PK_GodownDetail`; one execution reads ~300k pages and sorts ~26k rows.
- Purchase/issue screens re-fetch all **27.8k items** to show a few (`w_purchase.pbs:3202-3224`, `w_advancepurchase.pbs:2143-2165`; 25 sites).
- `f_stringpreferences` does a **linear scan of 1,308 rows on every call**, and there are **4,694 calls** (352 in `w_sale` alone).
- `f_getgroupcode` is a SQL round trip on **218 sites**; it always returns 2.
- Reports always open in **print preview**, then toggle rulers, causing two full paginations.

### 1.3 Reports: 30 objects cause most of the pain

- **`fn_getSaleInvTotal`** runs a grouped aggregate over `SaleDetail` once per invoice row in **584 DataWindows**. Measured daily sales: **1 day 1.59 s → 0.116 s** (13.7×); **7 days 7.82 s → 0.70 s** (11.2×); 30 days ≈33 s.
- **Ledger reports rescan `VirtualGl` 36–81× per run**: `d_customerledger_itemwise` = 21.5 s / 206k reads for 6,872 rows (18 tables, 17 joins, 89 subqueries, 11 union legs).
- **`SP_VirtualGL` runs before 90 report branches**, truncates a temp table, takes `TABLOCKX` on 2M rows, and runs 18 branches; sales branch alone **0.53–1.26 s**. `SP_STOCKLEDGER` also `TABLOCKX` and scans purchase/sale.
- **`StockReport` is a 2.9M-row unindexed heap**; one day+item query reads **28,244 pages / 200 ms / 220 MB**. Its purge was disabled in June 2023.
- **`d_cashflow`** returns 3 rows after **1,327 ms / 385k reads**; 24 union legs; leg 9 rewrite alone cut reads 42%.
- **`d_customerbalances_in_sales`** reads **75,814 pages / 259 ms for 2 rows**; `d_popup_supplierselection_many` reads **37,907 / 835 ms for 225 rows**.
- **Only 2 of 8,748 DataWindows use `Retrieve.As.Needed`; none set `Rows`/`Buffer`.** 3,309 big-table DWs have no range predicate; 2,854 dropdowns have `dddw.limit=0`; 1,965 sort twice.
- **Excel export is in-process BIFF with per-cell `Describe`**; PDF export is whole-document `SaveAs(..., PDF!)`; both freeze the UI.
- **2,275 print layouts / 143 MB** are per-customer variants; one is active per deployment.

### 1.4 Writes and network: chatty by design

- DataWindow updates are **one statement per row**; a 20-line invoice ≈25 round trips.
- A **50-line sale or purchase save** issues roughly **300–600 SQL/proc round trips**: 294 loops contain SQL, and 323 of 449 calls to stock/avg-price wrappers are inside loops.
- Purchase/return/transfer posting loops do **15–19 DB ops per invoice**; 100 invoices ≈1,500–1,900 round trips. On a 50 ms WAN that is **90–100 s**.
- **180 windows** open a second `u_transaction` connection on top of `sqlca`; **3,337 of 7,450 SQL statements are COMMIT/ROLLBACK**.
- **7 physical connections** at startup; 250 `create u_transaction`; 104 files issue `SQL START`; **0 `SetTransPool`**.
- The `it_imagetrans` object is created 9 times and never stopped/destroyed — one leaked connection per image view.
- Packet size is **4,096**; measured bulk fetch **105 ms at 4 KB vs 53 ms at 32,767**.
- Transport is a localhost named pipe (`\\localhost` alias); direct pipe 153 µs, localhost pipe 264 µs, TCP loopback 172 µs per statement.
- No connect/command/lock timeout; no deadlock retry. A blocked query can freeze the POS forever.
- `Script.mdb` is **not read at runtime** (three analysts found no reference; the client reads `dbo.Sequence`). It is a deployment/migration artifact, not a login cost. Secure it if the vendor's upgrade tool uses it.

### 1.5 UI: the stalls that no index fixes

- **Fiscalization tries to connect to port 9111 on every posted invoice; nothing is listening.** Prefs `AutoFiscalizeOnPosting=Y`, `FiscalizationMethod=2`, `FiscalizationAppPort=9111`. Every sale pays a blocking Winsock connect/send/recv + modal; if `PrintUnFiscalizedInvoice=N`, the receipt is suppressed.
- **8,779 `MessageBox` calls** (558 lexically inside loops); success confirmations on every save.
- **199 `SetRedraw(false)` blocks** can return without `SetRedraw(true)`; **162 `activate` handlers** force `windowstate = maximized!` on every focus change.
- **51% of windows are report argument/format dialogs** (839 `w_arg_*` + 213 `w_selectformat_*`); a report is often 3 modal windows before data.
- **199 preferences retrieves** across `w_preferences` (45) and `w_newpreferences` (34) on open; every tab loads eagerly.
- **97,059 compute objects**; 1,696 DataWindows have ≥40 columns; `d_saledetail` is 81 columns / 16 computes / 196 KB for 58 rows.
- The 32-bit exe is **not `LARGE_ADDRESS_AWARE`** (PE 0x010f); 2 GB address-space ceiling; 144 MB working set with one sheet.
- The process is **DPI-unaware**; 5,714 controls at 10 pt Arial blur at 125/150% scaling.

### 1.6 Database: memory and maintenance, not index count

- Buffer pool **793 MB committed / 2,882 MB used (~27% residency)**; Express caps at ~1 GB. The top three tables (SaleLedger 628 MB, SaleDetail 674 MB, VirtualGl 516 MB) cannot co-reside.
- **944 statistics are >1 year old; 973 were never updated.** Auto-update threshold on a 2M-row table is ~400k changes; observed counters are 96k–107k.
- **SaleLedger is 57.2% page-dense, 67.9% fragmented, 53,112 fragments**; ~165 MB recoverable. ItemLog 99.1% fragmented; Item 94.4%; Purdetail 76%.
- **No maintenance plan** — Express has no SQL Agent. This is the root cause of the fragmentation/statistics decay.
- **Compatibility 80 is not a direct optimizer win on 2008 R2** (same CE70 estimator at 80–110). It does block `PIVOT`/`APPLY`; test 80→100 on a copy, but do not expect a speed switch. 160 requires SQL 2019/2022.
- **Do not index the 1,438 FK columns without a leading index.** Most point at 5–20-row lookups; indexing all adds ~2.9 GB and 38 B-trees per SaleLedger insert, catastrophic on a 1 GB buffer. Only `Saledetail.GCode` and maybe `SRLedger.CustCode` pass the test.
- **No `char(255)` problem.** 1,484 of 1,553 `char` columns are `char(1)`; total declared char bytes ~3,988. `Item` is 726 B/record, 112 MB reserved, not 4 KB rows. Do not chase char→varchar.
- **`SaleDetail` is already optimal** (clustered by SaleInvcode, 13.7k seeks). Do not touch it.
- **0 stored-procedure executions in this database since restart** — the interactive hot path is DataWindow ad-hoc SQL. Proc rewrites are medium-term.

---

## 2. The complete enhancement list

### A. P0 — do now, no client source required (0–3 days)

| ID | Change | Evidence / why | Gain | Effort | Risk |
|---|---|---|---|---|---|
| P0-1 | Set `CheckManualBackupHealthAtStartUp = N` | `SoftwarePreferences` pref Y; `w_startup.pbs:71` / `w_backupinfo.pbs:32`; 3× `RESTORE HEADERONLY` | 0.3–3 s per login + one modal | S | Low |
| P0-2 | Set `AutoFiscalizeOnPosting = N` until the 9111 service runs; or start `FiscalizationApp` on 9111 | `f_fiscalizesaleinvoice.pbs:52-67`; port 9111 closed; prefs Y/2/9111 | Removes 1–2 dialogs and 0.2–20 s **per sale**; restores receipt | S | Low (legal review if FBR required) |
| P0-3 | Keep `AutoRefreshItemList = N`, `AutoRefreshItemListTime = 0` | `w_main.pbs:99-114`; `f_refreshitemlist.pbs:10-43` | Prevents 28,966-row reload every N minutes | S | Low |
| P0-4 | Create `StockReport` clustered index `(Date,GCode,ICode)` | 2.9M rows, 0 indexes; 28,244 reads/174 ms/day | 400–500× fewer pages; 174 → 2–5 ms | S | Med: 220 MB, 1–3 min lock |
| P0-5 | Create `VirtualGl(AccCode,Date) INCLUDE (Debit,Credit,DocumentCode,DocumentType,VRow)`; drop the 3 all-NULL indexes (PatientCode/StudentCode/GuestCode) | 2M-row heap; 37,907 reads/132 ms; 3 indexes on 100% NULL columns (~128 MB) | 100–300× pages; net −42 MB; less write amplification | S | Low |
| P0-6 | Create `SaleLedger(CustCode,date) INCLUDE (InvTotal)` | Customer month 48,752 reads/31 ms; no composite path | 100–1000× pages on statements | S | Low |
| P0-7 | `UPDATE STATISTICS ... FULLSCAN` on SaleLedger, SaleDetail, VirtualGl, StockReport, Purdetail, ItemLog, PurOrderDetail, Item, SRLedger, SRdetail | 944 stats >1 year; 973 never updated | 1.1–1.5× on stale-plan reports | S | Low |
| P0-8 | Pre-size data file to 4 GB, `FILEGROWTH=256MB`; log `128MB`; tempdb 4×64 MB fixed | Data file 176 MB free; 10% autogrowth (~306 MB) can stall | Removes growth pauses | S | Low |
| P0-9 | Replace `SP_WayToMoon` with `xp_fileexist` or remove; **disable `xp_cmdshell`** | 49.6 ms/call measured; `xp_fileexist` 0.6 ms; RCE surface | ~48 ms/login + security | S | Low |
| P0-10 | Replace startup `RESTORE HEADERONLY` with `msdb.dbo.backupset` query; move to background/toast | 3–4 RT × 3 devices; 110–190 ms + modal | 0.3–3 s perceived | S | Low |
| P0-11 | `optimize for ad hoc workloads = 1`; `cost threshold for parallelism = 25` | 24 MB ad-hoc plan cache; CTFP 5; MAXDOP 0 | 5–15% on mixed workload; ~20 MB cache | S | Low |
| P0-12 | **Measure the 14.1 s pre-SQL wait** with ProcMon/ETW/API hook on a copy; add a native splash wrapper (Rust/C#) that paints <150 ms | 14,130 ms gap; no pre-login splash; `w_logo` is after login | 10–14 s perceived; cause-specific removal | S–M | Low/Med |

### B. Database — P1 (1–4 weeks)

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| DB-1 | Rebuild `SaleLedger` `FILLFACTOR=80` | 57.2% dense, 67.9% frag, 53,112 fragments; 580 → ~415 MB | 1.4× scans; 165 MB freed | M | High: offline 1–5 min |
| DB-2 | Rebuild `ItemLog`, `Purdetail`, `PurOrderDetail`, `Item` at FF85–90 | 99.1/76/65/94% frag; ~135 MB recoverable | 1.2–1.5×; ~135 MB | M | Med |
| DB-3 | Rewrite `SP_StockReport` `NOT IN (SELECT DISTINCT CONVERT(...))` → `NOT EXISTS` + indexed date | 2.9M-row DISTINCT sort per run; purge disabled | 5–10× proc; stops unbounded growth | S | Low |
| DB-4 | Make `fn_getSaleInvTotal` cheap: persist `NetTotal/TaxTotal` on `SaleLedger` at posting; backfill; function reads one row | 584 DWs; measured 13.7× when removed | 10–15× on 584 reports | M | Low: reconcile totals |
| DB-5 | `SP_VirtualGL` / `SP_STOCKLEDGER`: watermark/async refresh; return last committed snapshot; never `TABLOCKX` on report open | Called before 90 report branches; 0.53–1.26 s sales branch; blocks postings | 2–10 s per ledger report; removes freezes | M | Med: stale window |
| DB-6 | `SaleDetail(ICode,SaleInvCode) INCLUDE (LooseQty,BonusQty,SalePrice,ItemFlatDisc,DiscPerc)` | Cashflow leg has 13,939 seeks / 46,702 reads; 42.2% DMV impact | 3–10× on item-wise reports | S | Low: write cost |
| DB-7 | `GodownDetail(ICode) INCLUDE (GCode,CurrQty)` | Item query 26,246 rebinds ×3; 300k reads/exec | 5–20× item query | S | Low |
| DB-8 | Validate the 86 untrusted FKs; `WITH CHECK CHECK CONSTRAINT` on a copy | 86 FKs `is_not_trusted=1`; join elimination blocked | 1.05–1.1× + integrity | M | Med: may fail on orphans |
| DB-9 | `DBCC UPDATEUSAGE` | DMV total 2,533 MB vs FILEPROPERTY 2,882 MB; `sp_spaceused` understates ~350 MB | Correct capacity decisions | S | Low |
| DB-10 | Test compatibility 100 on a restored copy; keep 80 live until the report suite passes | 80 blocks APPLY/PIVOT; no legacy `*=` joins found; CE unchanged | 0–5% direct; unblocks rewrites/upgrade | M | Low–Med |
| DB-11 | Scheduled maintenance via Windows Task Scheduler (Express has no Agent): stats + conditional rebuild >30% frag | No maintenance plan | Prevents regression | S | Low |
| DB-12 | **SQL Server 2019/2022 Standard, 16 GB RAM** | 793 MB buffer vs 2.9 GB data; Express 1 GB cap; no UDF inlining | **3–10× cold reports**; whole DB resident; UDF inlining/interleaved execution | XL | Platform/licensing |

### C. DataWindow / report SQL — P1–P2 (needs PB 12.5/PBL rebuild)

> **Fix ownership:** only DB indexes/statistics are deployable today. Every `.srd` retrieve/property fix requires the original PBL/PBD rebuild. The recovered `.srd` is evidence, not the runtime artifact.

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| DW-1 | Rewrite the 12 “Total Invoices” legs in `d_cashflow`/`d_cashflow5` with one grouped derived table | Leg 9 176,951 → 103,284 reads (−42%); 24 legs/385k reads | 1.7× leg; ~20% report | S | Low |
| DW-2 | Rewrite `d_customerledger_itemwise` family: pre-aggregate `CashierWindow`, `VirtualGl` opening, replace `CASE MAX(RowID)` with CTE | 21.5 s / 206k reads for 6,872 rows; 89 subqueries/11 legs | 3–8× | M | Med: totals |
| DW-3 | Guard the 35 no-arg big-table DWs with date args/`TOP`; start with `d_pending_refusedsalesreport`, `d_saleinvlist_lookup`, `d_deletedue_list`, `d_satisfydue_list` | 3,309 DWs no range; 1.3M-row lists | 2–20× | M | Low |
| DW-4 | Fix `d_customerbalances_in_sales` (75,814 reads/259 ms for 2 rows) | Whole-table aggregate filtered late | 5–10× | S | Low |
| DW-5 | Dropdown sweep: `TOP 100`, `WHERE active=1`, `dddw.limit=50`, disable auto-retrieve on 200 no-arg pickers | 2,854 `limit=0`; `ddd_stockdate` 2.9M DISTINCT | 0.1–2 s/picker | S | Low |
| DW-6 | Remove 1,965 double sorts (SQL `ORDER BY` + PB `sort=`) | 2,732 DWs have `sort=`; 1,965 also SQL order | 5–15% report time | S | Low |
| DW-7 | Enable `Retrieve.As.Needed`/`Rows` on flat report lists only | Only 2/8,748 use it; none set Rows/Buffer | 1.5–4× perceived | S | Low: not on updatable entry DWs |
| DW-8 | Thin entry DWs: `d_saledetail` 81 cols/16 computes/196 KB; `d_normalpurchasedetail` 73/57; `d_wholesaledetail` 96/39 | DB is 4–9 ms; render is the cost | 1.2–1.5× perceived | M | Low |
| DW-9 | Move top 10 reports to stored procedures returning the same shape | 0 DWs use `EXEC`/temp tables; 34 KB ad-hoc SQL parse | 2–5× plan reuse | L | Med |
| DW-10 | Retire dormant print variants; tune the active default only | 2,275 `sprnt*` DWs = 143 MB, one per deployment | Avoids wasted work; smaller client | S–L | Low |

### D. PowerScript / client code — P1–P2 (needs source or rebuild)

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| PS-1 | `w_sale` open-existing-invoice loop: replace per-line stock procs + nested item compares with one detail fetch | `salewin/w_sale.pbs:907-936`; N stock procs + N×M inner iterations + N item SELECTs | 10–40× open | M | Med |
| PS-2 | `w_sale` save: replace per-line `getitemavgpriceforsale` / `getitemtotalpiecesinhand` / `getitemstockall` / `selectitembatches` + per-batch pricing/update with one `PostSale @invoice` proc | `w_sale.pbs:3647-3949`; ~5 RT/line + 3/batch; 50 lines × 2 batches ≈450 RT; datastore created/destroyed per line | 100–200× fewer RT; 5–20× | L | High |
| PS-3 | `w_purchase` save: one `PostPurchase @invoice` proc; remove per-line supplier/price/stock lookups | `w_purchase.pbs:4185-4554`; 4–6 RT/line; 100 lines = 400–600 RT | 50–150× fewer RT; 10–30× | L | High |
| PS-4 | `w_salereturnbuffer` post: one set-based `PostSaleReturn`; one commit; design-time `UpdateTable` | `w_salereturnbuffer.pbs:1960-2156`; 6 procs/line; 2 commits/invoice; 8 `Modify(UpdateTable)` | 100× fewer RT; 5–15× | L | High |
| PS-5 | `w_transfer` post: set-based; one commit; hash the unposted list | `w_transfer.pbs:2630-2780`; ~4 RT/line; two commits on two transactions; O(n²) scan | 100× fewer RT | L | High |
| PS-6 | `w_postsale` checkout: one `PostPOS` proc; one commit; do not split stock/`sqlca` transactions | `w_postsale.pbs:1760-1893`; 2 procs/line + stock update/batch | 20–50× fewer RT; 2–5× checkout | L | High |
| PS-7 | `w_purchaseorder`: set-based `UPDATE … FROM` only when changed; load preferences once | `w_purchaseorder.pbs:3633-3704`; 1–4 UPDATEs/line; 500-line PO = 500–2,000 updates | 100–500× fewer statements | M | Med |
| PS-8 | Replace `f_stringpreferences` linear scan with a map; cache `f_getgroupcode` | 5,480 preference calls (4,694 string, 195 in loops); 217 group-code SQL round trips | 50–300 ms/posting | S | Low |
| PS-9 | Item list: push category/alias/ICode predicates into the retrieve; cache; one-pass A–Z buckets | `w_multi_entry.pbs:378-398,665` (6 copies); `f_refreshitemlist.pbs:10-29`; 28,966 rows; 26 `Find` + O(n²) string build | 3–10× search; 1–5 s freeze → <100 ms | M | Med |
| PS-10 | `w_preferences`: one wide retrieve + one update proc; lazy tabs; reuse MSDB connection | `w_preferences.pbs:512-726` 44 retrieves; `1047-1391` 37 updates; second MSDB connection | 10–30× open/save | M | Med |
| PS-11 | `w_main`: one security retrieve; pass `restricted` to retrieve; destroy `ds_groups`; parse menu path once | `w_main.pbs:186,191,198,104,79`; 2× d_security; filter 29k; leak; repeated `wf_findindex` | 200–800 ms login | S–M | Low |
| PS-12 | Fix `SetRedraw` leaks, 12 `Modify` per column, modal expiry per batch, 1 s `Sleep` galleries, success MessageBoxes | `w_sale.pbs:3814,3818`; `w_view_issueheader.pbs:170-204`; `w_view_saleorderheader.pbs:185-219`; `w_gldocument_gallery.pbs:235`; 8,779 MessageBoxes | 0.1–3 s/view; no ghost screens | S–M | Low |
| PS-13 | Remove dead/bloat: 265 `f_printbarcode_*` (99.6% unused), `w_newpreferences`/`w_oldpreferences` (zero refs), `_old`/`_copy`; audit ~700 static-unreferenced windows before deleting | 265 barcode functions; 52 `_old`/`_copy` files (644 KB); report/print code 276.9 MB (43.5%); ~200–250 MB (29–36%) not exercised | Smaller client; faster startup/install | L | Med: dynamic opens |

**Correction:** `w_newpreferences` (80 KB, 1,799 lines) is **not live**. `m_preferences.clicked` opens `w_preferences` (158 KB, 3,589 lines); `w_newpreferences` and `w_oldpreferences` have zero external references. The earlier “82 KB god window” finding should target `w_preferences`, not `w_newpreferences`.

### E. UI / perceived performance — P0–P2

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| UI-1 | Native pre-login splash <150 ms; pre-open DB; touch hot PBDs | 14.1 s blank screen; `w_logo` is after login | Perceived instant start | S–M | Low |
| UI-2 | Config prefs: backup health N, fiscalization N/service, item auto-refresh N/0, LogoSelected 0, add `yourlogo.bmp` | `SoftwarePreferences`; `w_bkg` missing bitmap | 0.3–3 s/login + 0.2–20 s/sale | S | Low |
| UI-3 | Report viewer: grid first, preview on demand, no ruler toggle | `w_reviewreport.pbs:301-304,359-367`; 2+ paginations | 2–10× report open | M | Low |
| UI-4 | Remove `setfocus()` from `ue_mdi_move`; background = MDI BackColor; no second top-level window | `w_main.pbs:16-33`; `w_bkg.pbs` | Smooth resize; no activation churn | S | Low |
| UI-5 | OS tuning: disable animations/menu fade/shadows; `DISABLETHEMES`; AV exclusions for 701 MB app + DB; 100% scaling; local SSD; fixed window size | DPI-unaware; 701 MB PBDs; 4–6 connections | 5–20% perceived; fewer AV stalls | S | Low |
| UI-6 | `editbin /LARGE_ADDRESS_AWARE` on a signed copy | PE 0x010f; 2 GB ceiling; 144 MB WS | Stability with 10+ sheets | S | Med: sign-off |
| UI-7 | Merge report arg+format into one dialog; remember last args | 839 + 213 dialogs; 51% of UI | 2–4 fewer windows/report | L | Med |
| UI-8 | Fix 162 activate-maximize + 199 redraw leaks | see PS-5 | No flash/stale screens | S–M | Low |
| UI-9 | Throttle/disable dashboard 60 s timer; refresh on demand | `w_dashboard.pbs:68-88`; 4 retrieves + 4 graphs/min | No periodic hitch | S | Low |
| UI-10 | Lazy-load OLE/ActiveX/image panels in `w_sale`/`w_postsale` | 12 DWs/486 KB + 4 OLE; 5 DWs/297 KB + 3 OLE | 0.3–1.5 s first sale | L | Med |
| UI-11 | Do not use RDP for POS until round trips are fixed | 282 FETCH + 2.3 s CPU login; 50 ms RTT = 24–30 s | Avoids unusable WAN | S | Low |
| UI-12 | Add a non-modal backup/update/status strip | Backup dialog; licence writes | Removes blocking modals | M | Low |

### F. Network / data access — P1–P2

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| NET-1 | Lazy-load/cache the item catalogue; one slim list; refresh by version | 900,187 reads / 2,271 ms CPU / 15.5 MB | 1.5–2.5 s local; 10–30 s WAN | M | Low |
| NET-2 | Rewrite item SQL: aggregate `GodownDetail` once; cover/drop `ORDER BY` | 26,246 rebinds ×3; 300k reads/exec | 5–20× | S–M | Low |
| NET-3 | Server-side filter for PO/issue: `WHERE ICode IN (...)` or temp table | 27.8k rows fetched for a few; 25 sites | 6–15 s WAN; 0.8–1.5 s LAN | S | Low |
| NET-4 | TCP alias for LAN/WAN; direct pipe locally; `PacketSize=32767` (server or DBParm) | 4,096 packet; 105 vs 53 ms; 257 vs 153 µs | 1.5–2× bulk; deployable LAN | S | Low |
| NET-5 | Connect 5–10 s, command 30–60 s (300 s reports), `LOCK_TIMEOUT 5000`, retry 1205 | No timeouts; infinite freeze | No permanent POS freeze | S | Low: long reports |
| NET-6 | Set-based posting: one proc/TVP per range instead of 15–19 ops/invoice | 100 invoices = 1,500–1,900 RTT; 90–100 s WAN | 10–50× | M | Med: ledger parity |
| NET-7 | Batch DataWindow writes / TVP; one commit per batch | 20-line invoice ≈25 RTT | 10–20× WAN | M | Med |
| NET-8 | One pool + `SetTransPool`; remove per-window `SQL START`; fix image leak | 250 creates; 104 START; 4 sessions; 9 leaks | Fewer sessions; faster open | M | Med |
| NET-9 | Separate report process/read-only connection; precomputed VirtualGl | Reports block POS on `TABLOCKX`; single thread | Minutes → seconds; no blocking | M–L | Med |
| NET-10 | Sync/CRS: outbox/inbox + batch ETL, no linked servers/MSDTC | 70 tables; cursor sync; 35 `XACT_ABORT` | Minutes → seconds; survives WAN | L | High |

### G. Reports / print / export — P1–P2

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| REP-1 | Replace `fn_getSaleInvTotal` with persisted totals (same as DB-4) | 584 DWs; 13.7× measured | 10–15× | M | Low |
| REP-2 | Remove synchronous `SP_VirtualGL`/`SP_STOCKLEDGER` (same as DB-5) | 90 report branches; TABLOCKX | 2–10 s/report | M | Med |
| REP-3 | Add `RptSaleDaily`, `RptLedgerDaily`, `RptItemMonthly`, stock snapshots; watermark ETL | Only StockReport snapshot now; 1.3M–2M-row scans | 10–100× aggregates | L | Med: reconciliation |
| REP-4 | Server-side Excel via `rust_xlsxwriter`; stream rows | Per-cell BIFF `Describe`; 1.1M cells/1,000 pages | 5–20× | M | Low |
| REP-5 | Server-side PDF/queue; stream page chunks | Whole-document `saveas(..., PDF!)`; UI freeze | 3–10×; no freeze | L | Med |
| REP-6 | Print: one dialog, preview on demand, direct `Print()`, cache page count | Two dialogs; preview always; `PageCount()` re-eval | 1–3 s/print; 2–5× paging | S | Low |
| REP-7 | Replace global `CrossTab_ReportData` with session-keyed temp/per-request pivot | `DELETE` + dynamic `UPDATE`; 152 crosstab DWs; concurrent users corrupt | Correctness + 5–10× | M | Med |
| REP-8 | Collapse 752 dispatch cases into metadata + one dispatcher | 10 `f_retrieve_report*.pbs`, ~520 KB; 423 reports | Maintainability; enables cache/queue | L | Med |
| REP-9 | Collapse 2,275 print layouts to 40–60 templates + client config | 143 MB; 714 with logos; 27/30/93/30/38 variants | 2–5× render; 5–10× maintenance | L | Med: pixel parity |
| REP-10 | Report cache + queue + usage telemetry | No cache/queue; `ReportData` is arg staging | 10–100× repeats | M | Low |
| REP-11 | Replace Crystal cheque COM (`sa`) with Rust/typst | `w_crystal_report_viewer.pbs:15-17` | 3–10× + security | M | Low |
| REP-12 | Async email/SMS; no UI-thread SMTP | `n_smtp`/`n_winsock`; attachments in blob | No UI freeze | M | Low |

### H. Security / licensing / startup integrity — P0–P2

| ID | Change | Evidence | Gain | Effort | Risk |
|---|---|---|---|---|---|
| SEC-1 | Disable `xp_cmdshell`; remove `SP_WayToMoon` (same as P0-9) | 49.6 ms/login; RCE surface | 48 ms + security | S | Low |
| SEC-2 | Stop using `sa` in the client; least-privilege login/Windows auth | `w_login1.pbs:95,101,185,210`; 4 sa sessions | Enables all controls | XL (PB) / M (rebuild) | High: app does DDL/BACKUP |
| SEC-3 | Argon2id + server-side verify + lockout; drop plaintext | 9 users, 8/9 ≤3 chars; client-side compare | ~100 ms once/login; closes worst hole | M | Med: PB helper |
| SEC-4 | Signed Ed25519 licence file + machine binding + grace; no DB row/write | 6 RT + write startup + per `ue_postopen`; DB row writable | 10–60 ms + per-window; real licensing | M | Med: rollout |
| SEC-5 | Replace `Script.mdb` with signed read-only migration; remove writable `Authenticated Users` | 7,968 statements; 317 DROP; 2,876 ALTER; world-writable | Removes code-exec channel | S/M | High if used |
| SEC-6 | ACLs: app/backup/temp not writable by Users; backups off-host/encrypted; remove `BUILTIN\Users` SQL login | `Application`/`Backup`/`C:\waseela_temp` modify; 11.26 GB readable | Stops local escalation | S | Med: keys |
| SEC-7 | Code-sign exe/DLL/installer; signed updater; per-user install; drop `.ext` rename | Unsigned; `.ext` duplicate; writable install dir | Stops DLL planting/supply chain | M | Med: key custody |
| SEC-8 | Remove `w_administrator_key` `DROP TABLE SysTextCatalog` path; parameterize backup restore/`OPENROWSET` | `w_administrator_key.pbs:6-8,78`; 106 dynamic procs | Removes backdoor/RCE | S/M | Low |

### I. Architecture / Rust + Tauri — P2–P3

| ID | Change | Evidence / rationale | Gain | Effort | Risk |
|---|---|---|---|---|---|
| ARCH-1 | Fix PB/SQL first; measure 4–6 weeks | 14 s wait, UDF, heaps, VirtualGL | 2–15× now; baseline for rewrite | S–M | Low |
| ARCH-2 | Tauri 2 + Rust core + React/TS + WebView2 | Stable 2.x; small binary; modern UI | 10–20× startup/memory | XL | Med |
| ARCH-3 | `tiberius-ng` + `bb8`/`deadpool`; keep SQL Server; defer PostgreSQL | sqlx MSSQL is “pending a full rewrite”; tiberius-ng maintained | Async, pool, streaming | L | Med |
| ARCH-4 | Data-driven UI renderer for uniform screens; hand-build ~300 core forms | 2,062 windows; 51% are arg dialogs; JSON has layout, not behaviour | Avoids 2,062 rewrites | XL | High |
| ARCH-5 | Rust band report engine + PDF/Excel/HTML; 40–60 templates | 8,748 DWs; 2,275 print layouts; 423 reports | 3–10× render/export | XL | High: parity |
| ARCH-6 | SQLite local cache/outbox for POS; server assigns invoice numbers | Offline/WAN; 900k-read item list | Fast local reads; resilient WAN | L | High: sync |
| ARCH-7 | Ed25519 licence, Argon2id, RBAC, signed updates | Current plaintext/sa/xp_cmdshell | Security + 10–60 ms startup | M | Med |
| ARCH-8 | Strangler: read-only lighthouse → master data → POS/purchase → GL → verticals | 2,062 windows/8,748 DWs; full parity 24–36 months | Early value, reversible | XXL | High |

---

## 3. Prioritized roadmap

### P0 — 0–3 days (DB/config/ops only)

1. P0-1 backup health `N`.
2. P0-2 fiscalization `N`/service.
3. P0-3 item auto-refresh `N/0`.
4. P0-4 `StockReport` clustered index.
5. P0-5 `VirtualGl` covering index + drop 3 NULL indexes.
6. P0-6 `SaleLedger(CustCode,date)`.
7. P0-7 statistics on top 10 tables.
8. P0-8 pre-size data/log/tempdb.
9. P0-9 `SP_WayToMoon`/`xp_cmdshell`.
10. P0-10 backup header off startup.
11. P0-11 optimize-for-adhoc + CTFP 25.
12. P0-12 measure the 14 s wait; native splash.

**Gate:** 20 warm runs p50/p95; top-5 scenarios ≥30% faster; no posting regression; no new blocking.

### P1 — 1–4 weeks

- DB-1/2 rebuilds; DB-3 `SP_StockReport`; DB-4 persisted invoice totals; DB-5 VirtualGL/StockLedger watermark; DB-6/7 indexes; DB-8 untrusted FKs; DB-9 UPDATEUSAGE; DB-10 compat 100 test; DB-11 maintenance job.
- NET-4 TCP/packet; NET-5 timeouts; NET-8 pool/leak (needs source for some).
- REP-4/5/6 server-side Excel/PDF/print; REP-10 cache/queue.
- UI-2/3/4/5 config/OS.
- Start SQL 2019/2022 Standard 16 GB procurement (DB-12).

**Gate:** daily sales p95 <3 s; ledger 10k <10 s; report 10k <2 s; Excel 10k <5 s; no `TABLOCKX` on report open; 10-user p95 save <1 s.

### P2 — 1–3 months

- DB-12 SQL upgrade + compat 150 (after regression).
- REP-3 summary tables; REP-7 crosstab; REP-8/9 dispatcher/templates.
- DW-1…DW-10 (PBL rebuild).
- PS-1…PS-10 (PBL rebuild).
- UI-7/10/12; NET-6/7/9/10.
- SEC-2…SEC-8.
- ARCH-1 baseline; ARCH-2/3 lighthouse prototype.

**Gate:** operational core SLOs; month-end close on a pilot branch; zero ledger diff; 10-user load.

### P3 — 3–24 months

- ARCH-4…ARCH-8: Tauri strangler, module by module.
- Full parity only for measured-used modules; freeze zero-row verticals.

**Gate:** pilot branch dual-runs 30 days with zero ledger/stock diff; rollback switch works.

---

## 4. Rust + Tauri target architecture

### 4.1 Shape

```text
┌──────────────────────── Windows 10/11 x64 ────────────────────────┐
│ Tauri 2 shell (Rust)                 WebView2 (Chromium)          │
│  single instance, updater, tray,     React 19 + TypeScript        │
│  printing, devices                   TanStack Table/Virtual       │
│                                      React Hook Form + Zod        │
│        typed IPC commands / channels / events                     │
│  ┌──────────────────────────────┐    ┌──────────────────────────┐  │
│  │ Rust core (modular monolith) │    │ UI renderer              │  │
│  │ auth, sales, purchase, stock │    │ ScreenDef → React        │  │
│  │ GL, master data, reporting   │    │ ReportDef → preview      │  │
│  └──────────────┬───────────────┘    └──────────────────────────┘  │
│  ┌──────────────▼───────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │ SQL Server repository    │  │ Report engine│  │ SQLite cache  │ │
│  │ tiberius-ng + bb8 pool   │  │ bands, expr, │  │ master, outbox│ │
│  │ prepared, streaming      │  │ PDF/XLSX     │  │ report queue  │ │
│  └──────────────┬───────────┘  └──────────────┘  └───────┬───────┘ │
└─────────────────┼─────────────────────────────────────────┼─────────┘
                  │ TDS 7.4/TLS                             │ sync (optional)
        ┌─────────▼──────────────┐              ┌───────────▼──────────┐
        │ SQL Server 2019/2022   │              │ axum sync/report host│
        │ system of record       │              │ same domain crates   │
        └────────────────────────┘              └──────────────────────┘
```

### 4.2 Stack decisions

| Layer | Choice | Why |
|---|---|---|
| Shell | **Tauri 2.x** (not 3 alpha) | Stable; WebView2; 10–20× smaller/faster than Electron |
| UI | React 19 + TypeScript + Vite; TanStack Table/Virtual; RHF + Zod | Hiring pool; virtual grids; typed forms |
| IPC | Typed commands + `Channel` for batches/progress; `tauri-specta` | No generic SQL; no global mutable state |
| DB | **SQL Server** + `tiberius-ng` + `bb8`/`deadpool` | `sqlx` MSSQL is pending a full rewrite; tiberius-ng is maintained |
| Cache | SQLite WAL + `rusqlite_migration`; outbox | POS offline; master data; report queue |
| Reports | Rust band engine; `typst`/`printpdf`; `rust_xlsxwriter`; `cosmic-text` | Streaming PDF/Excel; Urdu shaping |
| Auth | Argon2id; Credential Manager (`keyring`); RBAC | Removes plaintext/sa |
| Licence | Ed25519 signed file; machine fingerprint; 14–30-day grace | 1–3 ms cold, 0 ms warm; no DB write |
| Updates | MSI/NSIS; Authenticode; signed updater; staged rollout | No `.ext` rename |
| Observability | `tracing` JSON; slow query >200 ms; optional Sentry/OTel | Measure parity |

### 4.3 Performance budgets

| Metric | Target | Enforcement |
|---|---|---|
| Cold start → login | ≤2.5 s SSD / ≤4 s HDD | `--smoke-startup` timestamps; nightly |
| Warm start → main | ≤700 ms | tauri-driver + WebDriverIO |
| Window open | ≤150 ms | E2E per route |
| Grid scroll | ≥55 fps, frame ≤16 ms | WebView2 trace |
| Simple CRUD | p50 ≤30 ms, p95 ≤100 ms | Rust SQL harness |
| Report query 10k | p50 ≤1.5 s, p95 ≤4 s | SQL harness |
| PDF/Excel 10k | PDF ≤5 s, Excel ≤2.5 s; first page ≤800 ms | Criterion + E2E |
| Idle memory/CPU | ≤180 MB; 100k grid ≤450 MB; CPU ≤1% | dhat/ETW |
| Installer | ≤35 MB online / ≤160 MB fixed WebView2 | `tauri build` gate |
| Sync 500 invoices | ≤30 s | k6 on axum host |

### 4.4 Strangler phases

| Phase | Duration | Output | Exit criterion |
|---|---|---|---|
| 0. Baseline + DB rescue | 2–4 wks | Compat 100 on a copy, top-20 plans, index fixes, usage/device inventory | PB regression passes; top reports 2–10× faster |
| 1. Read-only lighthouse | 8–12 wks | Shell, login/RBAC, dashboards, 20–25 reports, PDF/Excel, master cache | Amounts match PB to 0.00; within 10% time |
| 2. Master data | 8–10 wks | Items, categories, packing, price policy, customers, suppliers, accounts, godown, users | CRUD/validation/audit parity; PB unaffected |
| 3. POS + purchase + inventory | 3–4 mo | Sale/return/receipt/shift, PO/GRN/purchase/return, transfer/adjustment | One branch dual-runs 30 days; zero ledger diff |
| 4. GL + accounts | 2–3 mo | Vouchers, trial balance, P&L, balance sheet, aging; read-only first | Month-end close on new app for pilot branch |
| 5. Selected verticals | on demand | Pharmacy batch/expiry, SMS, CRS, fiscalization, HR | Only modules with measured usage |

### 4.5 Scope reduction (from this restored DB)

| Bucket | Windows | DWs | Lines | Disposition |
|---|---:|---:|---:|---|
| Reports/args/print | 1,145 | 4,746 | 108,010 | Engine + ~60 templates; top 50 first |
| Master data/forms | 284 | 1,031 | 91,315 | Port core; generic CRUD |
| Core sales | 157 | 648 | 102,274 | Retail POS first; wholesale later |
| Core purchase/inventory | 70 | 555 | 58,444 | After POS |
| Accounts/GL | 35 | 191 | 15,560 | Read-only first, then vouchers |
| Pharmacy/hospital | 140 | 792 | 69,181 | Pharmacy batch/expiry only if used; drop hospital |
| School/hotel | 44 | 164 | 12,535 | Drop — 0 students/guests |
| HR/attendance | 29 | 112 | 10,154 | Freeze unless used |
| SMS/CRS/sync | 64 | 193 | 12,452 | Freeze; one SMS provider; central DB instead of CRS |
| Framework/tools | 94 | 316 | 91,403 | Replace barcode/dw2xls; keep primitives |

**Do not port by default:** 265 `f_printbarcode_*` functions (42k lines) → one label engine + 5–10 templates; 2,275 `sprnt*` layouts → 40–60 base layouts; 839 `w_arg*` windows / 664 generic dialogs → one metadata dialog; 222 dropdown DWs → one cached lookup; `dw2xls`/Crystal → Rust; 3,460 DWs never named in scripts / 728 windows never opened by literal name → candidate dead, instrument 30 days before deleting; hospital/school/hotel/loyalty/installments/payroll if unused (0 rows here); CRS unless multi-site.

**MVP:** one company, one branch, retail sale/return, receipt/shift, purchase/GRN/return, transfer/adjustment, master data, 25–35 reports, GL read-only, offline POS. ≈300–400 windows (15–20%), 500–700 DWs (6–8%), 150–200k lines (26–35%).

### 4.6 Effort / cost

Assumes Pakistan-based senior team at **$3.5–5.5k/person-month**; US/EU 3–5×.

| Phase | Duration | Team | PM | Cost (USD) |
|---|---|---|---|---|
| 0 Baseline/DB rescue | 1 mo | 2 | 2 | 8–12k |
| 1 Lighthouse | 2–3 mo | 4 | 8–12 | 30–65k |
| 2 Master data | 2 mo | 4 | 8 | 30–45k |
| 3 POS/purchase/inventory | 4 mo | 5 | 20 | 70–110k |
| 4 GL/reporting | 3 mo | 4 | 12 | 45–65k |
| 5 Offline/hardening | 2 mo | 3 | 6 | 20–35k |
| **Focused MVP** (0–2 + POS pilot) | **3–6 mo** | **4–5** | **20–30** | **80–160k** |
| **Operational core** | **9–12 mo** | **5–6** | **56–60** | **200–330k** |
| Selected verticals/parity | 12–24 mo | 6–8 | 80–140 | 300–700k |
| **Full parity** | **24–36 mo** | **8–12** | **200–350** | **0.8–2.0M** |

### 4.7 Decision matrix

| Option | Cost | Time to value | Risk | Verdict |
|---|---|---|---|---|
| A. Optimize PB + SQL only | $15–50k | 2–6 wks | Low–Med | **Do first**; 2–10× reports, preserves rules |
| B. Hybrid: PB + Rust services/reports | $80–200k | 4–6 mo | Med | Good fallback; two runtimes |
| C. Big-bang rewrite now | $1.5–3M | 24–48 mo | Very High | **Reject**; no rollback |
| D. Strangler (recommended) | $200–330k core; $0.8–2M full | 8–12 wks; 9–12 mo core | Med | **Recommended**; early value, reversible |

---

## 5. What not to do

1. **Do not start with a Rust/Tauri rewrite as the latency fix.** Fix the DB/client waits first; a fast shell on slow SQL is still slow.
2. **Do not index the 1,438 FK gaps.** ~2.9 GB, 38 B-trees per SaleLedger insert, catastrophic on 1 GB buffer.
3. **Do not expect compatibility 80→100 to be a speed switch.** Same CE on 2008 R2; it unblocks `APPLY`/`PIVOT` and the upgrade.
4. **Do not convert `char`→`varchar`.** No `char(255)` columns; 1,484/1,553 are `char(1)`; `Item` is 726 B/row.
5. **Do not rebuild all 1,068 indexes.** Only the hot five plus >30% frag + >1,000 pages.
6. **Do not use indexed views, columnstore, compression, or online rebuild on Express 2008 R2.** They need Enterprise/2016+.
7. **Do not run `SP_VirtualGL`/`SP_STOCKLEDGER` synchronously on report open.** `TABLOCKX` blocks the shop.
8. **Do not enable `Retrieve.As.Needed` on updatable entry DataWindows.** Test on flat report lists only.
9. **Do not rewrite pre-aggregated derived tables as correlated `OUTER APPLY`.** Measured 5.95M reads/5.08 s vs 37,907/0.84 s (6× worse).
10. **Do not use `FORCE ORDER` as the fix.** It halved reads but still scanned the heap; the covering index is the fix.
11. **Do not migrate to PostgreSQL in phase 1.** 620 procs/74 functions/1,717 FKs; keep SQL Server, upgrade it.
12. **Do not enable `xp_cmdshell` in production, keep `sa` in the client, or store plaintext passwords.**
13. **Do not patch `abuzar.exe` in place** (`LARGE_ADDRESS_AWARE`); work on a signed copy.
14. **Do not use RDP/WAN direct SQL for POS** until round trips are fixed (login 18–30 s; 100-invoice post 90–100 s).
15. **Do not tune 2,275 print variants.** Only one is active per deployment; tune the default.

---

## 6. Measurement and acceptance

### 6.1 Baseline scenarios (p95 unless noted)

| Scenario | Current | PB P0 | PB P1 | Rust/Tauri | How |
|---|---:|---:|---:|---:|---|
| Cold start → login | 14.3 s (n=1) | ≤8 s | ≤3 s | ≤1.2 s | UIA + QPC |
| Warm start → login | 14 s (n=1) | ≤4 s | ≤1.5 s | ≤0.6 s | 20 runs |
| Login → main | 0.4–2.5 s + modal | ≤3 s | ≤1 s | ≤0.4 s | UIA + click ping |
| Main → first sheet | not measured | ≤3 s | ≤1 s | ≤0.3 s | screenshot + UIA |
| Sale open | not measured | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace |
| Purchase open | not measured | ≤5 s | ≤1.5 s | ≤400 ms | UIA + trace |
| Item open | not measured | ≤1.5 s | ≤300 ms | ≤100 ms | UIA |
| Customer open | not measured | ≤1.5 s | ≤300 ms | ≤100 ms | UIA |
| Grid 1k/10k/100k scroll | not measured | 100/250/750 ms | 50/100/250 ms | 16/16/50 ms | frame diff |
| Simple indexed query | 0.65 ms avg startup | ≤100 ms | ≤50 ms | ≤20 ms | SQL trace |
| Stock report 10k | not measured; 56,488 reads | ≤8 s | ≤2 s | ≤1 s | trace + screenshot |
| Ledger 10k | not measured | ≤8 s | ≤2 s | ≤1 s | trace + screenshot |
| Report preview 10k | not measured | ≤8 s | ≤2 s | ≤1 s | trace + screenshot |
| Day-end | not measured | ≤10 s | ≤3 s | ≤1 s | trace |
| Excel 10k | not measured | ≤20 s | ≤5 s | ≤2 s | file + trace |
| Print 100 pages | not measured | ≤60 s | ≤20 s | ≤10 s | spooler + trace |
| Backup 3 GB | not measured | ≤180 s | ≤90 s | n/a | `msdb.backupset` |
| 2/5/10 users save | not measured | ≤2 s | ≤1 s | ≤300 ms | concurrent test |
| Memory / idle CPU | 137.6 MB / 0% | ≤300 MB/≤2% | same | ≤150 MB/≤0.5% | PerfMon |

### 6.2 Instruments

- **PB trace (next build only):** `TraceOpen`, `TraceEnableActivity`, `TraceEnableESQL`, `TraceEnableRoutine`, `TraceBegin/End`; `GetTickCount`/`CPU()`; `QueryPerformanceCounter` via `kernel32` for sub-15 ms.
- **Server-side trace:** events 10/12/17/33/43/50; columns 1,3,8,10–18,23,48; filter `ApplicationName LIKE 'Waseela%'`.
- **DMVs:** `dm_exec_query_stats`, `dm_os_wait_stats`, `dm_db_index_usage_stats`, `dm_db_missing_index_*`, `dm_io_virtual_file_stats`, `dm_os_buffer_descriptors`, `dm_tran_locks`.
- **PerfMon:** process CPU/WS/private/IO; `Memory\Available MBytes`; `PhysicalDisk\Avg. Disk sec/Read`; Buffer Manager PLE/page reads/hit ratio; SQL Statistics batches/compilations; Locks waits.
- **ProcMon/ETW:** one cold run, filter `abuzar.exe`, Load Image/CreateFile/RegQueryValue/TCP-UDP, flag `NAME NOT FOUND`; `wpr -start GeneralProfile -start CPU -start DiskIO -filemode`.
- **UI Automation:** poll top-level windows at 10 Hz; timestamp Login, License Expire, DB Problem, Backup Information, main; screenshot every 250 ms; first stable frame at 30 fps.

### 6.3 Benchmark harness

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

**Method:** quiet host (CPU <5%, no other sessions/backups) → DMV snapshots → start trace/PerfMon/UI capture → launch + auto-login → main/first sheet → stop → export trace → diff snapshots → append results. 5 cold runs after reboot, 20 warm. One change at a time.

---

## 7. Bottom line

1. **The app is not slow because it is PowerBuilder.** It is slow because of a 14 s client wait, a 900k-read item list, a per-row UDF, two heaps, synchronous `TABLOCKX` ledger rebuilds, full-result reports, and chatty writes.
2. **Fix the database first** — it is the cheapest, lowest-risk, highest-ROI work and it speeds up the current app immediately. P0 is days, not months.
3. **Fix the client waits next** — the 14 s gap, item list, fiscalization 9111, backup dialog, menu/prefs scans, print preview. Some need PB source; request the original PBLs from the vendor now.
4. **Upgrade SQL Server** to 2019/2022 Standard with 16–32 GB. The 1 GB Express buffer holds 27% of the database; this is the single largest absolute win (3–10× cold reports).
5. **Then build the Tauri strangler** — read-only lighthouse in 8–12 weeks, master data, POS/purchase, GL, selected verticals. Keep PB as the system of record until parity is proven.
6. **Do not promise "100% like Rust & Tauri" without the rewrite.** Promise **5–15× faster on the measured paths in weeks**, then **10–20× startup/memory and 2–5× rendering** with the rewrite.

---

## Appendix A — verified environment

- Host: HP Z440, Xeon E5-2695 v4 (18C/36T), 32 GB RAM, C: 240 GB Intel SSD (64 GB free), 1 TB HDD.
- SQL Server: 2008 R2 SP2 Express 10.50.4000.0 x64; 1 socket/4 cores, ~1 GB buffer, 10 GB DB cap.
- DB: `FazalDinPP19DataBaseV2`, 3,058 MB data + 493 MB log; compat 80; SIMPLE; RCSI off; AUTO_CLOSE/SHRINK off.
- Config: MAXDOP 0, CTFP 5, optimize-for-adhoc 0, CLR 0, xp_cmdshell 1.
- App: 144 MB WS, 125 MB private, 1 OS thread, 4 named-pipe sessions.
- Data: 505/752 empty tables; 30 >1k rows; 2 customers; 9 users; 28,966 items; 588,865 sale invoices (all `SaleTypeCode=1`); 0 patients/students/guests/loyalty.

## Appendix B — full analyst reports

| Area | Report |
|---|---|
| Startup / login | `deploy/analysis/startup/REPORT.md` |
| SQL Server / DB | `deploy/analysis/db-perf/REPORT.md` |
| DataWindows | `deploy/analysis/dw/REPORT.md` |
| PowerScript | `deploy/analysis/scripts/REPORT.md` |
| UI / MDI | `deploy/analysis/ui-hotspots/REPORT.md` |
| Reports / print | `deploy/analysis/reports/REPORT-ANALYSIS.md` |
| Network / data access | `deploy/analysis/dataaccess/REPORT.md` |
| Rust / Tauri | `deploy/analysis/arch/ARCHITECTURE-REPORT.md` |
| Security / licensing | `deploy/analysis/security/report.md` |
| Measurement / roadmap | `deploy/analysis/measurement/REPORT.md` |

---

*No product files, database schema/data, or running processes were modified. All findings are read-only.*
