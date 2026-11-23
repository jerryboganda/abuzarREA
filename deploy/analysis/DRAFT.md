# Abuzar / Waseela — complete performance & architecture roadmap (draft)

## The one-paragraph answer

You can make the existing app feel **5–15× faster** without a rewrite by fixing six things: the **14-second client-side wait before the first SQL connection**, the database's **compatibility level 80 + stale statistics**, the **per-row `fn_getSaleInvTotal` UDF** used by 584 DataWindows, the **`VirtualGl` / `StockReport` heaps**, the **synchronous `SP_VirtualGL` / `SP_STOCKLEDGER` rebuilds** that run before reports, and the **full-result DataWindow retrieves** that freeze the single-threaded UI. Those are measured, not theoretical: daily sales is **1.59 s vs 0.116 s** without the UDF (13.7×), and `SP_WayToMoon` is **~50 ms** versus **~0.6 ms** for `xp_fileexist`.

You **cannot** make a 32-bit PowerBuilder 12.5 p-code client "100% like a Rust & Tauri app" by tuning it. A Tauri rebuild can cut cold start, memory and installer size by **10–20×** and client rendering/export by **2–5×**, but it will **not** fix slow SQL or reports unless the database is fixed first. The honest sequence is: **measure → fix the PB/SQL bottlenecks (4–6 weeks) → build a Rust/Tauri strangler alongside it (3–6 month MVP, 9–12 month operational core)**. A full-parity rewrite is a **24–36 month, $0.8–2.0M** programme, not a performance patch.

## Why "Rust/Tauri fast" is the wrong first question

A Tauri app is a Rust process plus the system WebView2. It is fast because it starts small, renders with a modern engine, and does I/O asynchronously. It does **not** make a 2M-row ledger scan, a per-row UDF, or a 1,000-page print layout faster. For this product, the time budget is roughly:

| Layer | Share of user-perceived time | What fixes it |
|---|---|---|
| Startup / login / dialogs | 40–60% today (14 s wait + 12 s human typing + modals) | Native splash, remove wait, async checks, one connection |
| Report SQL / aggregation | 20–40% of a report-heavy day | UDF removal, indexes, summary tables, one-pass procs |
| DataWindow retrieve + render | 10–30% of screen time | Paging, server-side sort, fewer columns, lazy load |
| Print / Excel / PDF | 5–20% of admin time | Streaming Rust service, queue, templates |
| Network / connections | 5–10% | One connection, TCP, pooling, fewer round trips |
| UI framework | <5% | Tauri/React wins here, but it is the smallest lever |

That is why the answer is not "rewrite in Rust." It is "remove the client-side waits and database pathologies first; then rewrite for maintainability and the remaining 2–5×."

## What we verified about this deployment

- Host: HP Z440, Xeon E5-2695 v4 (18C/36T), **32 GB RAM**, C: 240 GB SSD, 1 TB HDD.
- SQL Server: **2008 R2 SP2 Express**, 10.50.4000.0, x64. Express cap: 1 socket / 4 cores, ~1 GB buffer pool, 10 GB database.
- Database: `FazalDinPP19DataBaseV2`, **3.06 GB data + 493 MB log**, compatibility **80**, SIMPLE recovery, RCSI off, `AUTO_CLOSE`/`AUTO_SHRINK` off.
- Config: MAXDOP 0, cost threshold 5, optimize for ad hoc 0, CLR 0, `xp_cmdshell` 1.
- App: 144 MB working set, 125 MB private, **1 OS thread**, low idle CPU; 4 named-pipe sessions.
- Data shape: **505 of 752 tables empty**; 30 tables >1k rows; 2 customers; 9 users; 28,966 items; 588,865 sale invoices, all `SaleTypeCode=1`; 0 patients/students/guests/loyalty rows. This is a retail POS + inventory + accounts workload, not the full vertical suite.
- Startup: successful run **47 s** process→title (n=1, includes human login + Backup Information modal). Traced startup SQL is **64–77 ms** across 85–119 statements. The largest single gap is **14.1 s before the first SQL connection**; cause unproven (PBVM/PBD load, AV, UNC/SMB timeout, `Sleep`, or audio).
- Reports: **423 logical reports**, 752 hard-coded dispatcher branches, 2,275 print layouts, 4,813 report/print DataWindows, 281.6 MB of report PBDs (40% of the client).
- Client scale: 120 PBDs / 701 MB, 11,623 objects, 8,748 DataWindows, 2,062 windows, 2,780 scripts / 27,700 routines / 568k lines.
- Security: client runs as `sa`; `xp_cmdshell` enabled; passwords plaintext; `Application`/`Backup`/`C:\waseela_temp` writable by `Authenticated Users`; unsigned binaries. See the security section; these are not just hygiene, they are part of why the startup path is slow and fragile.

## The six measured wins (do these first)

1. **Find and remove the 14.1 s pre-SQL wait.** Process start 01:21:33 → first session 01:21:47.130. The whole 17-minute session used only 11.9 s CPU and read 115 MB, so this is a blocking wait, not compute. Use ProcMon/ETW/API hook on a copy. Add a native splash so the user sees something in <300 ms. **Expected: 10–14 s perceived; cause must be measured.**
2. **Fix statistics + compatibility.** 30 statistics on the seven >100k-row tables predate 2018; 72 date to 2004. Compatibility 80 blocks modern T-SQL (`CROSS APPLY` fails) and the SQL 2000 optimizer. Test 80→100 on a copy first (2008 R2 max is 100; 160 requires a newer engine). **Expected: 20–50% on big joins/scans.**
3. **Replace `fn_getSaleInvTotal` with a stored total.** It runs a grouped aggregate over `SaleDetail` per invoice row in **584 DataWindows**. Measured 1-day daily sales **1.59 s → 0.116 s** (13.7×); 7 days **7.82 s → 0.70 s** (11.2×). Persist net/tax totals on `SaleLedger` and join once. **Expected: 10–15× on 584 reports.**
4. **Fix `VirtualGl` and `StockReport`.** `VirtualGl` is a 2M-row heap; the existing `(AccCode)` index does a seek + RID lookup, so add `INCLUDE (Debit, Credit)` or cluster it. `StockReport` is a 2.9M-row unindexed heap whose purge was disabled in 2023; back-date reports scan 28,244 pages / 226 MB. **Expected: 5–50× on ledger/stock reports.**
5. **Stop rebuilding `VirtualGl`/`StockLedger` synchronously before reports.** `SP_VirtualGL` takes `TABLOCKX`, runs 18 branches, and is invoked before 90 report branches; the sales branch alone is 0.53–1.26 s. `SP_STOCKLEDGER` also `TABLOCKX` and scans purchase/sale. Move to a watermark/async job; reports read the last committed snapshot. **Expected: 2–10 s per ledger report + removes freezes.**
6. **Stop full-result retrieves on the UI thread.** 4,090 `.retrieve()` calls, no `Retrieve.As.Needed`, 2,133 client `sort=` clauses, 4,457 summary bands. Cap preview rows, push `ORDER BY`/aggregation to SQL, and move Excel/PDF/print to a worker/service. **Expected: 2–5× on large screens/reports and no UI freeze.**

## Complete enhancement list — structure

The detailed list is organized by layer, with evidence, expected gain, effort and risk:

- **A. Measurement & guardrails** — baseline, SQL trace columns, PerfMon, ProcMon, UI Automation, SLOs.
- **B. SQL Server / database** — compatibility, statistics, indexes, heaps, data types, FKs, triggers, procs, config, Express limits.
- **C. DataWindows / retrieval** — SQL shape, UDFs, paging, client sort/filter, shared data, presentation.
- **D. PowerScript / client code** — loops with SQL, repeated queries, object churn, string parsing, dead code.
- **E. UI / MDI / rendering** — startup choreography, splash, window creation, repaint, menu rights, timers.
- **F. Reports / print / export** — dispatcher, UDF, VirtualGl, summary tables, crosstabs, Excel/PDF, print templates.
- **G. Network / connections / deployment** — 7 connections, OLE DB, named pipes, pooling, round trips, WAN.
- **H. Security / licensing / startup integrity** — `sa`, `xp_cmdshell`, `Script.mdb`, licence writes, ACLs, signing.
- **I. Architecture / Rust+Tauri** — target stack, SLOs, strangler phases, scope reduction, effort/cost.

*(Detailed tables to be filled from the remaining analyst reports.)*
