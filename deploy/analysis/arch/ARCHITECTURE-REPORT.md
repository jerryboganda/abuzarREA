# Rust + Tauri target architecture and migration — findings

**Scope:** end-state architecture, delivery plan, and critique of `REBUILD-PLAN.md`. DB index tuning and individual UI controls are other analysts' lanes; this uses their aggregate evidence.

## Executive verdict

- **"Rust/Tauri fast" is real for the shell, not for reports.** No part is 100x faster; 10–20x is the ceiling. Multipliers: 10–20x cold start, installer size and memory; 5–10x window open; 2–5x client-side report layout/Excel; ~1x large-report SQL and month-end posting unless the database is fixed. On a 10k-row report, 60–85% of wall time is SQL parse/scan/aggregate plus I/O.
- **The bottleneck is structural.** The live DB runs at compatibility level **80**; `VirtualGl` is a 2.0M-row heap, `StockReport` 2.9M rows, `Saledetail` 1.3M rows/674 MB; SQL Server 2008 R2 Express has ~1 GB buffer pool and 4 cores. Fix those first — it also speeds up PB while the rewrite is built.
- **"100% UI/UX parity" is the wrong target; the PostgreSQL move is the biggest unforced risk.** The DB has **505 empty tables of 752**, zero patients/students/guests/loyalty rows, two customers and nine users. Full parity of 2,062 windows is a multi-year programme; a focused MVP is 3–6 months, operational core 9–12 months, full parity 24–36 months.
- **Use a strangler, not a big bang.** Keep SQL Server and PB as the system of record. Ship a read-only Rust/Tauri lighthouse in 8–12 weeks, then master data, POS, purchase/inventory, GL, then selected verticals. Every phase must be useful and reversible.
- **The data-driven UI renderer is half-right.** The JSON is excellent for layout and the 1,145 report-launcher/argument windows, whose behaviour is uniform. It contains no behaviour: 568k lines of PowerScript, 16,870 unresolved global-function calls, 200 `goto`s and 89 flagged routines still need semantic review. Generate scaffolds; hand-build the ~300 core forms.

## Evidence base

Static counts from `recovered/objects/`, `recovered/datawindows/`, `recovered/scripts/`; read-only catalog queries on `FazalDinPP19DataBaseV2`. Helpers in `deploy/analysis/arch/`.

| ID | Finding | Evidence | Implication |
|---|---|---|---|
| F1 | Reporting dominates | 1,145 windows (55.5%), 4,746 DWs (54.3%), 108k lines | Port an engine + templates, not 1,145 windows |
| F2 | Arguments are generic | 839 `w_arg*` windows; 664 inherit two dialogs; 1,182 of 2,062 inherit five framework ancestors | One metadata-driven dialog covers hundreds |
| F3 | Print layouts are copies | 2,275 `sprnt*` DWs (26%); 2,378 of 6,947 parseable DWs share 660 identical SQL clusters; largest are 154/110 copies of one invoice query | 40–60 base templates + client config |
| F4 | Many screens are dead | 1,334 distinct `Open()` targets; 728 windows never opened by literal name; 36 windows with `_old`/`_copy`/test names | Candidate dead code; classify, verify dynamic opens |
| F5 | Business is narrow | 588,865 invoices, all `SaleTypeCode=1`, 2022–2025, ~PKR 407M; Customer=2, Users=9; Patient/Student/Guest/Loyalty=0 | Retail POS + inventory + accounts, not a vertical suite |
| F6 | Most tables unused | 505/752 empty; only 30 tables >1k rows, 7 >100k | Schema size is not scope; 150–200 tables cover the core |
| F7 | Security/posting are legacy | 463 Rights, 687 GroupRights, 0 UserRights; passwords 1–12 chars; `sp_PostSaleLedger` 11.2k chars | Group RBAC + Argon2id; call procs for write parity |

**Not measured here:** startup/screen timings on client hardware; validate in phase 0.

## Target architecture

```
┌──────────────────────── Windows 10/11, x64 ────────────────────────┐
│ Tauri 2 shell (Rust)                  WebView2 (Chromium)          │
│  single instance, updater, tray,      React 19 + TypeScript        │
│  printing, devices                    TanStack Table/Virtual       │
│                                       React Hook Form + Zod        │
│        typed IPC commands / channels / events                      │
│  ┌──────────────────────────────┐    ┌──────────────────────────┐  │
│  │ Rust core (modular monolith) │    │ UI renderer              │  │
│  │ auth, sales, purchase, stock │    │ ScreenDef → React        │  │
│  │ GL, master data, reporting   │    │ ReportDef → preview      │  │
│  └──────────────┬───────────────┘    └──────────────────────────┘  │
│  ┌──────────────▼───────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │ SQL Server repository    │  │ Report engine│  │ SQLite cache  │  │
│  │ tiberius-ng + bb8 pool   │  │ bands, expr, │  │ master, outbox│  │
│  │ prepared, streaming      │  │ PDF/XLSX     │  │ report queue  │  │
│  └──────────────┬───────────┘  └──────────────┘  └───────┬───────┘  │
└─────────────────┼─────────────────────────────────────────┼──────────┘
                  │ TDS 7.4/TLS                             │ sync (optional)
        ┌─────────▼──────────────┐              ┌───────────▼──────────┐
        │ SQL Server 2022/2025   │              │ axum sync/report host│
        │ system of record       │              │ same domain crates   │
        └────────────────────────┘              └──────────────────────┘
```

| Layer | Decision | Why / critique |
|---|---|---|
| Shell | **Tauri 2.12.x**, not 3 alpha | 2.x stable; 3.0 alpha. 2.12 dropped Win7; target Win10 1803+/Win11 x64. WebView2 Evergreen; fixed (~180 MB) only for air-gapped installs. |
| UI/grid | **React 19.3 + TS 7 + Vite 8**, TanStack Table 9 + Virtual 3 | Hiring pool, virtual rows, keyboard nav. Keyset pagination above ~50k; never 100k DOM rows. |
| Forms/types | **RHF 7 + Zod 4**; **specta/tauri-specta** | One schema from Rust DTOs to TS; no drift. |
| UI renderer | **Build-time codegen + primitives**; runtime `ScreenDef` only for uniform screens | JSON has layout, not events. Generate CRUD scaffolds; hand-code POS, purchase, GL, top 50 dialogs. Resolve ancestor trees. |
| IPC/state | One command per use case; `Channel` for batches/progress; `AppState`; TanStack Query + Zustand | No generic `execute_sql`; no global mutable state like `sqlca`. Typed errors, CSP, allowlist. |
| DB | **Keep SQL Server**; **tiberius-ng 0.13.1** + custom bb8/deadpool manager | `sqlx` has no TDS driver; `sqlx-sqlserver` 0.0.3 is not production-grade. Upstream `tiberius` 0.13 has RUSTSEC TLS advisories. Needs TCP/SQL Browser + TLS 1.2; 2008 R2 may fail, so upgrade first. |
| Queries/writes | Prepared `@P1`, `SET NOCOUNT ON`, streaming; call existing procs in a transaction; idempotency keys | Keyset on `(date, id)`; `numeric` → `rust_decimal`. Procs guarantee ledger parity; reimplement later with shadow tests. |
| Server | `axum 0.8.9` for sync/report host only | No localhost HTTP server in every desktop install; share domain crates. |
| Cache/offline | **SQLite WAL** (`rusqlite 0.41` + `rusqlite_migration`); outbox | POS sale + receipt only, 7 days/500 invoices; server assigns official numbers. No offline GL/purchase/transfer. |
| Sync | Idempotency key, per-aggregate sequence, `base_version`, pull watermark | Not CRDTs. Stale price/credit/stock → reject; cash sale → provisional; master data → server time wins. |
| Reporting | Rust band engine; HTML preview; **printpdf**/typst; **rust_xlsxwriter**; `cosmic-text` | Expression evaluator compiled to closures; unknown = hard error. Urdu shaping; thermal via ESC/POS. Workers: `rayon` CPU, DB semaphore, bounded queue, cancel. |
| Auth/licensing | **Argon2id 0.6**; Credential Manager (`keyring 4.2`); Rights/GroupRights; **Ed25519** signed licence | Passwords 1–12 chars, likely plaintext: verify, rehash, force reset. Licence: machine fingerprint 2-of-3, 14–30 day grace, clock-rollback check; no `xp_cmdshell`/DLL/DB row. |
| Packaging/observability | MSI/NSIS, Authenticode, signed updater, staged rollout; `tracing` JSON, slow query >200 ms, optional Sentry/OTel | Per-user install avoids admin; keep previous MSI. Redact PII; support bundle without secrets. |

### What the plan gets wrong

1. **PostgreSQL 17 is phase 1, before the app exists.** That is two migrations at once: 642 procedures, 74 functions, 10 triggers, T-SQL semantics and 7,448 embedded statements. Keep SQL Server for v1; move to PostgreSQL 18.6 + sqlx only after app parity if the business case is real.
2. **`axum + sqlx` is wrong for a desktop app.** `axum` adds a server you don't need; `sqlx` cannot talk to SQL Server. Use tiberius-ng; add axum only for multi-branch sync. **"Pixel diff per window" is not a delivery plan** — use workflow + data + print parity, pixel-golden only the top 50 documents.
3. **No exit criteria, flags, coexistence or rollback.** A rewrite that cannot be rolled back per branch dies at the first month-end. And decompiled code is evidence, not source: 16,870 `gfunc_<n>` sites, 200 `goto`, 89 flagged routines and 201 ambiguous SQL binds need semantic review.

## Performance budgets and SLOs

Assume 4-core/8 GB SSD and 1 Gbps LAN; measure p95.

| Metric | Target | Enforcement |
|---|---|---|
| Cold start → login | ≤2.5 s SSD, ≤4 s HDD | `--smoke-startup` timestamps; hyperfine; nightly |
| Warm start → main | ≤700 ms | tauri-driver + WebDriverIO marker |
| Window open | ≤150 ms | E2E per route |
| Grid scroll | ≥55 fps, frame ≤16 ms | WebView2 trace; Playwright web build |
| Simple CRUD query | p50 ≤30 ms, p95 ≤100 ms | Rust SQL harness |
| Report query 10k rows | p50 ≤1.5 s, p95 ≤4 s | SQL harness + `SET STATISTICS TIME` |
| PDF/Excel 10k rows | PDF ≤5 s, Excel ≤2.5 s; first page ≤800 ms | Criterion + E2E |
| Idle memory/CPU | ≤180 MB; 100k grid ≤450 MB; CPU ≤1% | dhat/ETW |
| Installer | ≤35 MB online, ≤160 MB fixed WebView2 | `tauri build` gate |
| IPC / stream | ≤5 ms command; ≥50k rows/s | Microbenchmark |
| Sync 500 invoices | ≤30 s | k6 on axum host |

CI: `criterion 0.8` for expression/band/PDF/Excel; `insta` snapshots; `proptest` for money rounding; `tauri-driver 2.1` + WebdriverIO 10 for the real shell; Playwright 1.64 only against the browser build. SQL benchmarks need a self-hosted Windows runner with a restored snapshot; run nightly. Gate on **relative regression >15–20%** vs a stored baseline, not absolute numbers. Bundle via `cargo bloat`; memory via `dhat`.

## Migration strategy

**Pattern:** strangler at the client edge. The Tauri app is a second client on the same SQL Server. PB stays installed. No schema fork, no DB migration, no big bang.

| Phase | Duration | Output | Exit criterion |
|---|---|---|---|
| 0. Baseline + DB rescue | 2–4 wks | Compat 160 on a copy, top-20 plans, index fixes, usage/device inventory | PB regression passes; top reports 2–10x faster |
| 1. Read-only lighthouse | 8–12 wks | Shell, login/RBAC, dashboards, 20–25 reports, PDF/Excel, master cache | Amounts match PB to 0.00; within 10% time; side-by-side use |
| 2. Master data | 8–10 wks | Items, categories, packing, price policy, customers, suppliers, accounts, godown, users | CRUD/validation/audit parity; PB unaffected |
| 3. POS + purchase + inventory | 3–4 mo | Sale/return/receipt/shift, PO/GRN/purchase/return, transfer/adjustment | One branch dual-runs 30 days; zero ledger diff |
| 4. GL + accounts | 2–3 mo | Vouchers, trial balance, P&L, balance sheet, aging; read-only first | Month-end close on new app for pilot branch |
| 5. Selected verticals | on demand | Pharmacy batch/expiry, SMS, CRS, fiscalization, HR | Only modules with measured usage |

**Coexistence.** Both clients write through the same procs; Rust never directly updates `SaleLedger`, `VirtualGl` or stock for financial documents. Add nullable columns/defaults only; version procs and keep the old one for PB. Tag rows `Source='RUST'`; add idempotency/audit. Test PB after every DDL. Raise compatibility level in production only after PB passes regression on a copy: compat 80 is a major problem, but changing it can alter implicit conversions/null behaviour.

**Dual-run/parity.** Reports: same snapshot, compare row counts, column hashes, decimal sums and totals; print top 50 to PDF and diff text + SSIM (zero tolerance on amounts). Writes: shadow mode writes intended entries to `shadow_*`; diff against PB's ledger/stock; any non-zero diff blocks cutover. UI: top 50 screenshots at 100/125/150% DPI + keyboard flows. Reconcile daily sales, tax, discounts, COGS and GL to 0.00.

**Flags/rollback.** `FeatureFlag` keyed company/branch/user/module (`sales.write`, `offline.pos`, `gl.readonly`). Canary one branch; keep PB installed; rollback is a UI switch because both clients share schema/procs. Sync offline invoices first. Never delete posted documents; use reversals.

**Data migration.** None for v1. If PostgreSQL is later approved: migrate tables/columns/FKs; rebuild derived tables from source; rewrite procs with golden tests; validate counts, decimal sums, dates, collation, `char` padding and identities. Parallel read-only for two weeks; cut over per company. Never migrate DB and rewrite UI in the same quarter.

**Avoiding a 3-year big bang.** Ship every 6–8 weeks; contract module acceptance; order the backlog by measured usage; freeze zero-row modules. PB remains the fallback, so the new app can be incomplete without stopping the business.

## Scope reduction

Each library assigned once; totals reconcile to 2,062/8,748/571k extracted lines.

| Bucket | Windows | DWs | Lines | Disposition |
|---|---:|---:|---:|---|
| Reports/args/print | 1,145 | 4,746 | 108,010 | Engine + ~60 templates; top 50 reports first |
| Master data/forms | 284 | 1,031 | 91,315 | Port core; generic CRUD scaffolds |
| Core sales | 157 | 648 | 102,274 | Retail POS first; wholesale later |
| Core purchase/inventory | 70 | 555 | 58,444 | After POS |
| Accounts/GL | 35 | 191 | 15,560 | Read-only reports first, then vouchers |
| Pharmacy/hospital | 140 | 792 | 69,181 | Pharmacy batch/expiry only if used; drop hospital |
| School/hotel | 44 | 164 | 12,535 | Drop — 0 students/guests |
| HR/attendance | 29 | 112 | 10,154 | Freeze unless payroll/attendance is used |
| SMS/CRS/sync | 64 | 193 | 12,452 | Freeze; one SMS provider; central DB instead of CRS |
| Framework/tools | 94 | 316 | 91,403 | Replace barcode/dw2xls; keep primitives |

**Do not port by default:**
- **265 `f_printbarcode_<client>` functions (42k lines)** → one label-template engine + 5–10 templates.
- **2,275 `sprnt*` layouts** → 40–60 base layouts (A4/A5/thermal/wholesale/retail) parameterised by client. Two identical invoice queries are duplicated 154 and 110 times.
- **839 `w_arg*` windows / 664 generic dialogs** → one parameter dialog driven by DW `arguments=`.
- **222 dropdown DWs** → one cached lookup service.
- **`dw2xls` (11 functions, 15k lines) and Crystal** → `rust_xlsxwriter` + report engine.
- **3,460 DWs never named in scripts; 728 windows never opened by literal name** → candidate dead, not proven (nested/dynamic/config-selected). Instrument 30 days of hits before deleting; classify the 36 `_old`/`_copy`/test windows, don't bulk-delete.
- **Hospital, school, hotel, loyalty, installments, payroll** if unused (current DB: 0 rows). Keep schema for compatibility; no UI/reports/migration work.
- **CRS replication** unless multiple sites exist; 70 replica tables/31 procs are a hidden tax.

**MVP:** one company, one branch, retail sale/return (wholesale later), receipt/shift, purchase/GRN/return, transfer/adjustment, master data, 25–35 reports, GL read-only, offline POS. Roughly **300–400 windows (15–20%)**, **500–700 DWs (6–8%)**, **150–200k lines (26–35%)**.

## Effort, team, cost

Assumes a Pakistan-based senior team at **$3.5–5.5k/person-month**; US/EU rates are 3–5x.

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

**3/6/12/24 months.** 3: lighthouse with 20 reports and SLO baseline (8–12 PM). 6: focused MVP — master CRUD, one-branch POS pilot, 40 reports, dual-run reconciliation (25–30 PM). 12: operational core, GL read-only + month-end, 70–80% of daily users (50–60 PM). 24: core parity + selected integrations; PB frozen for pilot branches (120–180 PM). Full parity only if funded and the client accepts the rarely used 20%.

**Team:** 2 Rust, 2 frontend, 1 PB domain/BA, 1 QA automation, 0.5 designer, 0.5 DevOps/security. Add a print/hardware specialist for 3–6 months.

## Crate and tool list (checked Nov 2026)

| Area | Crate/tool | Version | Why |
|---|---|---|---|
| Shell | `tauri` / `tauri-build`; updater, single-instance, window-state, log, dialog, opener | 2.12.5; 2.14.1, 2.5.5, 2.5.0, 2.10.1, 2.8.4, 2.7.2 | Stable 2.x; signed updates, one instance, restore |
| Frontend | React / TypeScript / Vite | 19.3.1 / 7.0.2 / 8.3.5 | Mature ecosystem |
| Grid/forms | `@tanstack/react-table`, `virtual`, `query`, `react-hook-form`, `zod` | 9.3.1, 3.14.25, 5.105.1, 7.91.0, 4.6.7 | Virtual grid, server state, validation |
| Types/IPC | `serde`, `specta`, `tauri-specta`, `rust_decimal`, `chrono` | 1.0.229, 1.0.5, 1.0.2, 1.43.0, 0.4.45 | Generate TS types; exact money/date |
| DB | **`tiberius-ng`**, `bb8`, `tokio` | **0.13.1**, 0.9.1, 1.54.1 | Maintained TDS; custom pool manager |
| Local cache | `rusqlite` (bundled), `rusqlite_migration`, `tokio-rusqlite` | 0.41.1, 2.6.0, 0.8.0 | WAL, migrations, blocking pool |
| Server | `axum`, `tower-http` | 0.8.9, current | Sync/report host only |
| PDF/Excel | `printpdf`, `typst`, `cosmic-text`, `rust_xlsxwriter` | 0.12.8, 0.15.1, 0.19.0, 0.102.0 | Bands, Urdu shaping, streaming Excel |
| Barcode/QR | `qrcode`, `barcoders`, `escpos` | 0.14.1, 2.0.0, 0.20.1 | Labels, thermal |
| Auth/crypto | `argon2`, `ed25519-dalek`, `keyring` | 0.6.0, 3.0.0, 4.2.0 | Argon2id, licences, Credential Manager |
| Observability | `tracing`, `tracing-appender`, `sentry`, `opentelemetry` | 0.1.44, current, 0.49.5, 0.33.1 | Logs, crash reports, OTLP |
| Testing | `criterion`, `insta`, `proptest`, `tauri-driver`, WebdriverIO, Playwright | 0.8.2, 1.49.0, 1.12.0, 2.1.0, 10.1, 1.64.1 | Perf, snapshots, E2E |

## Decision matrix

| Option | Cost | Time to value | Risk | Pros | Cons |
|---|---|---|---|---|---|
| **A. Optimize PB + SQL Server only** | $15–50k | 2–6 wks | Low–Med | Immediate 2–10x reports; preserves rules | PB 12.5 EOL; 32-bit; no modern UI; ceiling |
| **B. Hybrid: PB + Rust services/reports** | $80–200k | 4–6 mo | Med | Fast reports; low disruption | Two runtimes; deploy complexity; PB UX |
| **C. Big-bang rewrite now** | $1.5–3M | 24–48 mo | Very High | Clean architecture | Likely failure; no rollback |
| **D. Strangler (recommended)** | $200–330k core; $0.8–2M full | 8–12 wks; 9–12 mo core | Med | Early value, reversible, measured | Discipline, dual-run QA |

**Recommendation:** run **A for 4–6 weeks** (compat 160 on a copy, top-20 query/index fixes, report SQL) for immediate relief and a baseline. Start **D's lighthouse** in parallel. At 3 months, use measured parity and user feedback as go/no-go. Keep **B** as fallback; reject **C**.

## Top 10 risks

1. **SQL/report performance (High).** Rust won't fix plans. Compat 160, indexes, query rewrites, pre-aggregation; benchmark before/after.
2. **Print/layout parity (High).** Thermal, A4/A5, cheques, Urdu shaping, barcodes. Top-50 golden PDFs, print lab, `cosmic-text`, ESC/POS prototypes.
3. **Offline sync/duplicates (High).** POS cash only; idempotency keys; provisional numbering; 30-day pilot.
4. **PB logic gaps (High).** 16,870 unresolved calls, 200 `goto`, 89 flagged routines. Runtime traces, domain review, shadow writes, procs for posting.
5. **PostgreSQL migration now (High).** Defer; isolate repositories; rebuild derived tables; two-week parallel run.
6. **Scope creep (High).** Signed module disposition, flags, MVP definition, usage-based backlog.
7. **Hardware integration (Med–High).** Scanners, scales, pole displays, TSC, fingerprint. Inventory and prototypes in weeks 1–4.
8. **Legal/IP (High).** Rights to decompile/rebuild/brand. Counsel, clean-room separation, written assignment.
9. **Talent/bus factor (Med–High).** Rust + PB domain is rare. Two Rust engineers, docs, pair review.
10. **User acceptance (Med).** Dual-run fatigue. Champions, training, visible wins, rollback.

## First 30 days

- **Week 1 — baseline/scope.** Measure startup, 20 screens, 20 reports on target hardware; capture query stats. Confirm empty modules; pick a pilot branch. ADR-001: SQL Server retained; tiberius-ng; React.
- **Week 2 — foundation.** Private repo + CI (Windows runner, nextest, audit, lint). Tauri 2 shell, tiberius-ng, login/RBAC, one virtualised grid; test Authenticode.
- **Week 3 — report spike.** Parse three DW JSONs (invoice, ledger, stock), render HTML/PDF/Excel, benchmark 1k/10k rows, compare amounts to PB.
- **Week 4 — lighthouse demo.** Login → dashboard → sales report → PDF/Excel on a snapshot. Publish SLO baseline, risk register, 90-day plan; go/no-go.

**Exit:** one real report with 0.00 amount difference and within 10% of PB time; cold start ≤2.5 s; installer ≤40 MB; no blocker in printing, auth or DB.

## What NOT to do

- Don't migrate to PostgreSQL in phase 1; don't run two migrations at once.
- Don't auto-generate all 2,062 windows and call it parity; behaviour isn't in the JSON.
- Don't expose generic SQL over IPC or embed SQL.
- Don't reimplement financial posting before shadow-parity tests; call existing procs.
- Don't use `sqlx` for SQL Server or upstream `tiberius` 0.13.
- Don't use Tauri 3 alpha.
- Don't chase pixel-perfect everywhere; top 50 documents only.
- Don't port dead modules, 265 barcode functions or 2,275 layouts.
- Don't build microservices or localhost servers.

## Measurements still needed

- Startup/screen timings on actual client hardware.
- 30-day hit counts per window/report (instrument PB or SQL trace).
- p50/p95 and plans for top 30 reports on a restored snapshot.
- Printer/scanner/scale/pole/fingerprint inventory and drivers.
- Branch count, WAN/LAN quality, offline tolerance.
- Data growth vs the 10 GB Express cap (`sp_spaceused` monthly).
- Urdu/RTL print samples and font requirements.
- Legal rights to source, artifacts and brand.
- Confirm hospital/school/hotel/loyalty/payroll are out of scope.

---

*Helper data in `deploy/analysis/arch/`. No product files changed.*
