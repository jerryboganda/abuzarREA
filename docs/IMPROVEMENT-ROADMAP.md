# Improvement roadmap: the PowerBuilder desktop app (Waseela / Trader App v1)

Written 2026-11-23. Keep this file in the outer project only (it names live weaknesses; the outer repository is never pushed).

**Owner decisions, 2026-11-23**

| Decision | Choice |
|---|---|
| Which app receives the improvements | **The PowerBuilder desktop app itself** (a new `abuzar.exe`), built from the recovered code |
| How it is compiled | Appeon **PBAutoBuild** (official, free, no IDE and no licence; needs PowerBuilder Runtime 2025) |
| Screens | May be redesigned freely; business rules, calculations and data written must not change |
| Unused modules (hospital, school, hotel, HR/payroll, multi-site sync) | Remove from the product (exact list to be confirmed before deleting) |
| Priority | Not chosen; default used here: security and data integrity first |

Evidence for the numbers below: `docs/ARCHITECTURE.md`, `docs/SECURITY-AND-RIGHTS.md`, `docs/UI-STRUCTURE.md`, `docs/STATUS.md`, `PROJECT-MEMORY.md`, `deploy/PERFORMANCE-ROADMAP.md` (measured rows and IDs such as PS-2, DW-5 are defined there).

---

## 1. How the app gets changed (the build pipeline)

```
recovered/scripts  (37,895 routines)  ┐
recovered/objects  (windows, menus…)  ├─ re-tools/pbsrc_export.py ─→ pbsrc/ws_objects/<lib>.pbl.src/*.sr*
recovered/datawindows (8,748 .srd)    ┘                              pbsrc/abuzar.pbt + build.json
                                                                          │
                                              PBAutoBuild250.exe /f build.json   (Merging: create PBLs,
                                              import .sr*, upgrade to 2025, compile)
                                                                          │
                                                          new abuzar.exe + PBDs  →  test on a database copy
```

| Step | State on 2026-11-23 (evening of the same working day; details in `docs/STATUS.md`) |
|---|---|
| Compiler | PowerBuilder 2022 build 1878, free command-line tools (`PowerBuilderUtilities 22.0`); driven through the ORCA API by `re-tools/orca_build.py` (PBAutoBuild's JSON merge did not work; OrcaScript prints no errors) |
| Generator (`python -I re-tools/pbsrc_export.py . pbsrc2 improve`) | 11,582 source files in 118 libraries: 2,062 windows, 99 user objects, 156 menus, 53 structures, 460 global functions, 2 application objects, 8,748 DataWindows, 1 pipeline, 1 query. 0 objects skipped |
| Recovered on the way | 777 external / stored-procedure declarations, 35 object-level structures, array bounds, event signatures and message ids, 134 enumerations, 36 OLE binary sections, design-time list items of 98 controls |
| Full rebuilds measured | cycle 1: 1,406 errors in 868 objects · cycle 3: 224 in 147 · cycle 4: 60 in 44 · cycle 5: **1 in 1** (fixed in the generator; cycle 6 not yet read when this was written) |
| Improvement overlay (`improve/`) | carries every 2026-11-23 fix of `deploy\Application` in source form (79 script patches, 12 property overrides, 117 DataWindows) and the HTTPClient replacement of the SOAP SMS proxy |
| Executable | **not built yet**; nothing has been run |
| Test database | `WaseelaPBTest` on `.\SQLEXPRESS2022`: a copy-only backup of the local database restored under another name, with the fiscal port, SMS provider and mail server neutralised. The real databases are not touched by tests |

Known gaps (each is counted in `pbsrc2/export-report.json`):

1. Access levels (private/protected) are not recovered: everything is written public. Initial values of global variables are not recovered.
2. 68 functions end without a return value on some path (allowed by 12.5, an error in 2022): they return the type's default there. An assumption about the old runtime, listed as `functions_without_value`.
3. Design-time lists: 3 controls not decoded, 32 placed by a tie-breaker (listed in the report); integer arrays of list views (`itempictureindex`) are not recovered.
4. The SOAP SMS replacement is not tested against the provider.
5. Vendor secrets in the recovered scripts (a hard-coded password, the backup-password scheme) are still in the generated source; `pbsrc*/` is git-ignored and must stay local until they are removed (D3).
6. Three decompiler defects found through this work also sit in the scripts the Rust rebuild runs (see `docs/STATUS.md`): the rebuild has not been corrected.

Risks to settle early:

- **Runtime change.** The new build runs on the PowerBuilder 2025 runtime, not `PBVM125.dll`. All 120 libraries must be rebuilt together. The 32-bit vendor DLLs (`sysdrv`, `tsclib`, `eztw32`, `pb2xls`, `qrcodegenlibrary`) keep the build 32-bit.
- **Licence terms.** The docs say PBAutoBuild is free; they do not say whether that covers shipping the 2025 runtime to shop PCs. Check Appeon's terms before production use.
- **Where the data is.** Since the 2026-11-14 cutover the shop's entries go into the rebuild's PostgreSQL on the VPS. The PowerBuilder app works on SQL Server, which holds the older snapshot. Returning the PowerBuilder app to production needs either a PostgreSQL → SQL Server data return, or pointing the PowerBuilder app at PostgreSQL (the rebuild already holds the translated schema, 638 procedures and statements). Owner decision D1 below.

---

## 2. What the analysis found

- **Shape.** One 32-bit client (120 libraries, 2,062 windows, 8,748 DataWindows, 460 global functions) holding all business logic and talking straight to SQL Server as `sa`. No server tier. 761 tables (505 empty here), 642 procedures.
- **Screens.** 1,643 of 2,062 windows are modal dialogs; 838 report-argument and 213 format dialogs are 51% of the UI; a report is often three dialogs before data. Arial 10, DPI-unaware, MDI sheets, 8,779 message boxes.
- **Speed.** A 50-line sale or purchase save makes 300–600 round trips; the 28,966-row item list loads at login, twice; `f_stringpreferences` scans 1,308 rows on each of 4,694 calls; 7 connections at start, no timeouts, no pooling.
- **Correctness.** Invoice counters can fall behind the ledger (found and repaired on the live database), fiscalization success is assumed without reading the reply, split-invoice fiscalization sends the wrong id, crosstab reports share one global work table, multi-invoice tendering commits per document.
- **Security.** Plain-text passwords compared in the client, `sa` in every session, a hard-coded server password, backup passwords built from fixed prefixes, a maintenance window that can drop a licence table.

Already improved without recompiling (database and configuration): SQL Server 2022, hot indexes and statistics, page compression, `fn_getSaleInvTotal` O(1), `SP_VirtualGL`/`SP_STOCKLEDGER` watermark gates (30.7 s → 67 ms warm), nightly maintenance, FK validation, ACLs, `xp_cmdshell` off, signed launcher, counter and calendar-reset repairs.

---

## 3. All improvements

"Needs" column: **DB** = database/config only, possible today; **PB** = needs the recompiled app.

### A. Architecture

| ID | Improvement | Needs |
|---|---|---|
| A1 | Reproducible build: source in git (private), PBAutoBuild in one script, versioned releases | PB |
| A2 | Posting through one stored procedure per document (`PostSale`, `PostPurchase`, `PostSaleReturn`, `PostTransfer`) with table-valued parameters, one transaction | PB + DB |
| A3 | One connection (`sqlca`) with pooling; remove the 250 extra `u_transaction` objects and the leaked image connection | PB |
| A4 | Cached lookups: preferences as a keyed map, `f_getgroupcode` cached, item list paged from the server | PB |
| A5 | Proper schema migrations (numbered, signed scripts) replacing the `Script.mdb` chain | PB + DB |
| A6 | Reporting off the posting path: summary tables (`RptSaleDaily`, `RptLedgerDaily`, stock snapshots), read-only report connection | DB, then PB |
| A7 | Metadata-driven report launcher replacing the 752-case dispatcher and 838 argument windows | PB |
| A8 | Remove the unused modules and dead code (265 unused barcode functions, `_old`/`_copy` objects, 2,275 print variants of which one set is active) | PB |
| A9 | Service layer for integrations (REST calls for SMS, WhatsApp, FBR) with `HTTPClient` instead of raw Winsock and COM | PB |
| A10 | 64-bit build once the 32-bit vendor DLLs are replaced | PB |

### B. Backend and database

| ID | Improvement | Needs |
|---|---|---|
| B1 | Invoice numbering that cannot collide: sequence or locked counter inside the posting transaction, with a self-check against the ledger maximum | DB (+PB) |
| B2 | Remaining report SQL rewrites: customer ledger item-wise (21.5 s), cashflow (24 union legs), customer balances | DB for procs, PB for DataWindow SQL |
| B3 | Per-session crosstab work table instead of the global `CrossTab_ReportData` | PB + DB |
| B4 | Lock and command timeouts, deadlock retry | PB |
| B5 | Audit trail by trigger on master and financial tables (who, when, before/after) | DB |
| B6 | Automatic, verified, encrypted backups with off-site copy; restore test on a schedule | DB |
| B7 | Fix the orphan purchase tax category so the last untrusted FK can be trusted | DB (owner chose to leave it) |
| B8 | `serverdate.lasttransdate` guard that cannot lock posting after a quiet period | PB or DB |
| B9 | Archive policy for `StockReport` (2.9 M rows, growing) | DB (owner chose to keep history) |

### C. Functional correctness

| ID | Improvement | Needs |
|---|---|---|
| C1 | Read the fiscalization reply; mark an invoice fiscalized only on a confirmed FBR number; retry queue for failures | PB |
| C2 | Split-sale fiscalization loop uses each generated invoice id | PB |
| C3 | Atomic multi-invoice cash tendering (all documents or none) | PB |
| C4 | Print button no longer saves/posts as a side effect without saying so | PB |
| C5 | All `SetRedraw(false)` paths restore drawing (199 sites) | PB |
| C6 | Success message boxes replaced by a status line; real errors stay modal | PB |
| C7 | Validation messages name the field and move focus to it | PB |

### D. Security

| ID | Improvement | Needs |
|---|---|---|
| D1 | Application login without `sa`: least-privilege SQL login or Windows authentication | PB + DB |
| D2 | Salted password hashes verified on the server, lockout after failed tries, minimum length | PB + DB |
| D3 | Remove hard-coded credentials, the fixed backup-password scheme and the table-dropping maintenance path | PB |
| D4 | Rights enforced in the database (procedure permissions per group), not only by hiding menu items | DB + PB |
| D5 | Signed executables and installer; install folder not writable by users | PB build + deploy |
| D6 | Licence handling: owner's decision (the rebuild runs without the vendor scheme since 2026-11-02; not yet decided for this track) | owner |

### E. Performance (client)

| ID | Improvement | Needs |
|---|---|---|
| E1 | Sale, purchase, return, transfer save in one call (PS-2 to PS-6): 100–200× fewer round trips | PB + DB |
| E2 | Open-invoice loop fetches details once (PS-1) | PB |
| E3 | Item search served by the database with paging (PS-9, NET-1 to NET-3) | PB |
| E4 | Preferences window: one retrieve, lazy tabs (PS-10) | PB |
| E5 | Login: one rights query, menu path parsed once (PS-11) | PB |
| E6 | Reports: grid first, preview on demand, one pagination (UI-3); `Retrieve.As.Needed` on flat lists (DW-7) | PB |
| E7 | Dropdowns limited and filtered (DW-5), double sorts removed (DW-6) | PB |
| E8 | Excel and PDF export without freezing the screen (native PDF, streamed XLSX) | PB |
| E9 | Startup: find and remove the 14 s wait before the first connection; splash at once | PB |

### F. Frontend and UX

| ID | Improvement | Needs |
|---|---|---|
| F1 | Tabbed sheets instead of overlapping MDI windows; remembered window sizes | PB |
| F2 | One report screen: pick report, criteria and format together; remembers last values | PB |
| F3 | Global search (menu items, customers, items, invoices) with a keyboard shortcut | PB |
| F4 | POS mode for Cash Sale: large totals, barcode-first entry, touch keys, hold/recall bills | PB |
| F5 | Keyboard help overlay per screen; consistent Enter/Tab/F-keys | PB |
| F6 | Inline validation and required-field marks instead of pop-ups | PB |
| F7 | Favourites and recent screens on a home page | PB |
| F8 | Urdu labels and right-to-left printing where wanted | PB |

### G. Visual

| ID | Improvement | Needs |
|---|---|---|
| G1 | Application-wide UI theme (flat, light and dark) from the PowerBuilder 2025 runtime | PB |
| G2 | High-DPI awareness so text is sharp at 125–150% scaling | PB |
| G3 | Modern font (Segoe UI), consistent spacing, new toolbar icons | PB |
| G4 | Ribbon or cleaned toolbar replacing the 718-item menu for daily tasks | PB |
| G5 | Redesigned invoices, receipts and reports (40–60 templates instead of 2,275 variants) with logo and QR | PB |
| G6 | Dashboard with charts (sales, stock value, expiry, receivables) | PB |

(G1, G2 and G4 depend on runtime features; confirm each against the Appeon 2025 documentation before committing.)

### H. New features

| ID | Improvement | Needs |
|---|---|---|
| H1 | Expiry, near-expiry and reorder alerts with a daily list | PB + DB |
| H2 | Receipts and statements by WhatsApp, SMS and e-mail | PB |
| H3 | Scheduled reports (daily sales, cash position) sent to the owner | DB + small service |
| H4 | Offline-tolerant POS: queue sales when the server is unreachable | PB (large) |
| H5 | Owner's phone view (read-only sales, stock, cash) | separate small app |
| H6 | Purchase suggestions from sales velocity and stock | DB + PB |
| H7 | Customer loyalty, price lists and promotions review | PB |

### I. Operations and quality

| ID | Improvement | Needs |
|---|---|---|
| I1 | Automated regression: open every window, post a sale and a purchase on a database copy after each build | PB build |
| I2 | Ledger and stock comparison (old exe vs new exe on the same copy) as the release gate | DB |
| I3 | Installer with automatic update and rollback | PB build |
| I4 | Error log with screen, user and SQL for every failure | PB |
| I5 | Health panel: backup age, counter check, fiscal queue, database size against the Express limits | PB + DB |

---

## 4. Phases

| Phase | Content | Gate |
|---|---|---|
| **0. Build proof** | Finish the generators (section 1), install PBAutoBuild, compile, drive compiler errors to zero | New exe signs in and opens Cash Sale on a restricted database copy; all 2,062 windows open; old vs new post the same sale with identical ledger and stock rows |
| **1. Security and integrity** | D1–D5, B1, B4, C1–C3 | No `sa`, no plain-text password in the database or the code; numbering and fiscal checks proven on a copy |
| **2. Speed** | E1–E9, A2–A4, B2–B3 | Sale save under 1 s at 50 lines; login to main under 3 s; no report takes a table lock |
| **3. Screens and look** | G1–G5, F1–F7, A7 | Owner acceptance of Cash Sale, Purchase, report screen |
| **4. Features and scope** | H1–H7, A8, G6 | Per feature |
| **5. Platform** | A1, A5, A9, A10, I1–I5 | Every release built, tested and installed by script |

Phase 0 is the only phase that can start before PBAutoBuild is installed (generators are local Python). Database-only items (B5, B6, B2 procedures, A6) can run in parallel with any phase.

## 5. Decisions still needed from the owner

| # | Decision | Recommendation |
|---|---|---|
| D1 | Which system is production: the rebuild on PostgreSQL (current) or the improved PowerBuilder app on SQL Server | Keep the rebuild in production until phase 0 and 1 pass, then decide with real evidence |
| D2 | Install PowerBuilder Runtime 2025 + PowerBuilder Utilities on this PC | Yes; it is the blocker for the first compile |
| D3 | Licence checks in the regenerated app | Same choice as for the rebuild, stated explicitly |
| D4 | Exact list of modules to remove | Remove only after a dependency list is reviewed |
