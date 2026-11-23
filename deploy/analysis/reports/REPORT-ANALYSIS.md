# Reporting, print, preview & export — findings

## Executive verdict
- **Reports are slow because of SQL shape, not PowerBuilder drawing.** The dominant costs are a per-row scalar UDF used by 584 DataWindows, ledger statements that re-scan `VirtualGl` 36–81 times per execution, and a `TABLOCKX` rebuild of `VirtualGl`/`StockLedger` that runs *before* 90 report branches even when no data changed.
- **The “largest SRD” list is a red herring.** `d_itemlog_azhar` (328 KB) is `SELECT * FROM ItemLog WHERE ICode < 0` and has zero script references; `d_saledetail`, `d_item_detail`, `d_item_update`, `d_item_garments_wizard` and `d_normalpurchasedetail` are OLTP entry DataWindows. File size is mostly column definitions, not report work.
- **There is no reporting architecture.** 423 menu reports are dispatched by 752 hard-coded `choose case` branches in ten functions; 1,136 argument/format dialogs front them; there is no server-side report layer, no result cache, no queue, no usage telemetry, and almost no summary tables.
- **The biggest wins are cheap and DB-side.** Denormalising invoice totals, 3–4 indexes, 3–4 daily/monthly summary tables and removing the synchronous `VirtualGl` rebuild should give 10–100× on the hot reports for 2–6 weeks of work.
- **For Tauri, build a Rust report *service*, not a big-bang rewrite.** SQL → band model → PDF/XLSX/HTML with cache, queue and streaming gives 5–20× on render/export. SSRS is a pragmatic interim for back-office tabular reports, but it is poor for invoices/cheques and expensive for 400 reports.

## Evidence base
- **Client inventory:** `reports.pbd` 20.4 MB / 704 windows (684 `w_arg_*` dialogs, 20 helpers); `reportformat` 4.1 MB / 287 pickers; `reports_cust` 4.5 MB / 145; `sprnt*` 150.1 MB / 2,275 layouts; `reportviewer` 4.2 MB; `psrviewer` 1.5 MB. Report PBDs total **281.6 MB, 40% of the 701 MB client**.
- **Report metadata:** 8,748 recovered `.srd` files parsed. 4,813 are in report/print libraries; 2,275 are per-customer print layouts (143.2 MB of SRD). 8,664 have retrievable SQL.
- **Dispatch:** `recovered/scripts/reportviewer/f_retrieve_report*.pbs` contain 752 `case` branches in ten functions (~520 KB of PowerScript). `components/m_mainmenu.pbs` makes 429 `mf_displayreport` calls for **423 unique report DW names**.
- **SQL patterns:** 2,772 report DWs use `GROUP BY` (58%), 1,167 use `UNION` (24%), 160 have >10 `UNION` branches, 47 have >50 subqueries, 60 reference `VirtualGl` >10 times, 745 call a `dbo.fn_*` scalar function, **584 call `fn_getSaleInvTotal`**. 2,133 have a client `sort=` clause, 110 a client `filter=`, 4,193 computed fields, 4,457 non-empty summary bands, 975 bitmaps/logos, 109 nested reports. Only 38 use `SELECT *` and 217 `DISTINCT`; sampled SQL over 2 KB carries a date/period predicate, so absent ranges are not the systemic issue. Joins are old-style comma joins across 26–36 table definitions. **Zero use `NOLOCK`, zero use temp tables, only 9 use `TOP`, no `Retrieve.As.Needed`, no explicit Rows/Buffer limiting.**
- **Database:** SQL Server 2008 R2 Express SP2, compatibility level **80**, 1 GB buffer pool, `READ_COMMITTED_SNAPSHOT OFF`. `StockReport` 2,906,627 rows / 202 MB (heap, no index); `VirtualGl` 1,998,300 / 392 MB (heap); `SaleDetail` 1,305,994 / 674 MB; `SaleLedger` 588,832 / 626 MB. No summary tables except `StockReport` (daily snapshot) and `PreviousSaleHistory`.
- **Measured SQL (read-only, `SET STATISTICS IO/TIME`):** `d_dailysalesdetail` 1 day = 1,929 rows / **1.59 s**; without `fn_getSaleInvTotal` 0.116 s (13.7×); 7 days 7.82 s vs 0.70 s (11.2×); 30-day extrapolation ≈33 s. `d_stockinhand` 376 ms / 4,600 reads. `d_stockinbackdate` 0.14–0.82 s / **28,244 reads (226 MB)**. `VirtualGl` date range 37,907 reads / 232 ms; an `AccCode=1`-only predicate still scans 37,907 pages (114 ms). VGL “new sales” anti-join 74,406 reads / **1.26 s cold, 0.53 s warm**. DMV: VGL `(AccCode)` 99.62%, `(Date)` 96.53%; StockReport `(Date)` 99.94%, `(ICode,Date)` 99.98%; SaleLedger `(Posted,AccountFor)` 83.83%.
- **Caveat:** the local DB has 2 customers and synthetic sales; timings are structural. No usage log exists (`ReportData` is argument staging), so “hot” is inferred from menu/business function, not measured frequency.

## Findings
| ID | Finding | Evidence (file:line / SQL result) | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| F1 | Reporting is ten hard-coded dispatchers, not an architecture | `f_retrieve_report.pbs` … `f_retrieve_report9.pbs`; 752 cases | Every new report/format edits ~520 KB of compiled code; no shared query/caching layer | Move report definitions to metadata (SQL + bands + params) behind one dispatcher | Maintainability; enables caching/queue | L | Medium: parity |
| F2 | `fn_getSaleInvTotal` runs per row in 584 DWs | `d_dailysalesdetail.srd` retrieve; 1.59 s vs 0.116 s without UDF | UDF runs a grouped aggregate over `SaleDetail` + a preference lookup for **every invoice row** | Persist `SaleLedger.NetTotal/TaxTotal` on posting; make UDF a single-row lookup or join once | **10–15× measured**; 5–15× across 584 DWs | M | Low: reconcile totals |
| F3 | Ledger reports re-scan `VirtualGl` 36–81× per run | `d_customerledger_itemwise`: 31 UNIONs, 36 VGL refs, 89 subqueries; portrait: 45/54/119 | Each UNION branch repeats the same account/date scan and correlated `Item`, `CashierWindow`, `MAX(RowID)` subqueries | One-pass account-statement proc into a temp table; format from it; add `RptLedgerDaily` | **10–50×** | L | Medium: layout parity |
| F4 | `SP_VirtualGL` rebuild runs before 90 report branches | `sqlca.virtualgl("A")` at `w_reviewreport`/`f_retrieve_report.pbs:56`; 90 calls in reportviewer, 167 overall | Truncates `VirtualGLTemp`, takes `TABLOCKX` on `VirtualGL`, runs 18 EXEC branches; measured 0.53–1.26 s for sales alone | Watermark/async rebuild; reports read last committed snapshot; never rebuild on open | **2–10 s saved per ledger report**, no blocking | M | Medium: stale ledger window |
| F5 | `SP_STOCKLEDGER` takes `TABLOCKX` and scans Pur/Sale | `SP_STOCKLEDGER` definition; 4 `sqlca.stockledger()` calls | Blocks all stock readers/writers during rebuild; `NOT EXISTS` over large tables | Same watermark pattern; batch 1,000 docs; run off-peak | 5–10× + removes freezes | M | Medium |
| F6 | `StockReport` is an unindexed heap and its purge is disabled | `SP_StockReport` has DELETE commented out “05-JUN-2023”; 2.9M rows, 202 MB, no index; backdate scans 28,244 pages | Every back-date report scans 226 MB; table grows ~6k rows/day forever | Clustered `(Date,GCode,ICode)` or `(ICode,Date)`; archive >2 years; restore purge | **5–50×** on backdate; stops unbounded growth | S | Low |
| F7 | No daily/monthly summary layer | Only `StockReport` snapshot; no `RptSaleDaily`, `RptLedgerDaily`, `RptItemMonthly`; 752 report cases hit base tables | Every report re-aggregates 1.3M–2M rows | Add 3–4 narrow summary tables + watermark ETL | 10–100× on aggregates | L | Medium: reconciliation |
| F8 | Every report retrieves the full result set; PB then sorts/groups/computes | No `Retrieve.As.Needed`; 2,133 `sort=`, 4,193 compute fields, 4,457 summary bands | 55k-row reports are fully materialised in 32-bit memory before preview; client sort duplicates SQL `ORDER BY` | Server-side `ORDER BY`; remove redundant `sort=`; paginate preview; cap/preview-first | 2–5× + less memory | M | Low |
| F9 | Crosstab reports share one global `CrossTab_ReportData` table | `SP_SUBAREASALES_CROSSTAB` does `DELETE CrossTab_ReportData`, dynamic `UPDATE`, then DW reads it; 152 crosstab DWs | Two users running crosstabs corrupt/block each other; fixed 13 area columns | Session-keyed temp table or per-request result set; server-side pivot | Correctness + 5–10× | M | Medium |
| F10 | Nested reports loop up to 15 retrieves of the same range | `f_retrieve_report1.pbs:1096` loops transaction types, `ldc_nested.retrieve(...)` each | 15 separate SQL executions per report; repeated scans | Single query grouped by transaction type; one child retrieve | 5–15× on that family | M | Medium |
| F11 | Excel export is per-cell BIFF writing with `Describe` per cell | `dw2xls/n_dwr_field.pbs:717` `Describe("Evaluate(...)")`; `n_dwr_band.pbs:49` parses `DataWindow.Syntax`; `f_saveasexcel` uses it. **It is in-process BIFF (`n_xls_*`), not COM/OLE.** | 1.1M cells for 1,000 pages × 20 cols; multiple `Describe` calls each; whole workbook in PB memory | `rust_xlsxwriter` streaming export server-side; or PB `SaveAs` CSV for raw data | **5–20×** | M | Low |
| F12 | PDF export is whole-document, client-side, no queue | `w_reviewreport.pbs:835` `saveas("", pdf!, false)` | Builds entire PDF in 32-bit process; UI frozen; 1,000 pages can exhaust memory | Server-side streaming PDF; job queue; open result when ready | 3–10× + no freeze | L | Medium |
| F13 | Print path opens two modal dialogs and always enables preview | `w_reviewreport.pbs:134` `printsetup()`, then `w_printer`; `:301` `Preview=yes`; `w_printer` `printsetprinter()`; page navigation re-evaluates `PageCount()`. **No `PrintOpen`/`PrintDataWindow`; all printing is `DataWindow.Print()`.** | Two dialogs per print; full layout computed even for viewing; page count recomputed while paging | One print dialog; preview on demand; direct `Print()` with saved setup; cache page count | 1–3 s perceived per print; 2–5× paging | S | Low |
| F14 | 2,275 print layouts, avg 81 controls, 714 with logos; format explosion | `sprnt*` 143 MB SRD; median 80 controls, p90 114, max 183; 714 with bitmap; 27 `d_dailysalesdetail*`, 30 `d_dailysalessummery*`, 93 `d_stockinhand*`, 30 `d_customerledger*`, 38 `d_wholesaleinvreport*` | Per-page control draw + logo; duplicated per customer; every variant carries its own SQL/UDF | Template + parameterised logo/header; one definition per logical report | 2–5× render; 5–10× maintenance | L | Medium: pixel parity |
| F15 | Crystal Reports used for cheque printing via COM + plaintext `sa` | `w_crystal_report_viewer.pbs:15` `CrystalRuntime.Application`; `:17` `logonserver(...,"sa",gs_password)` | Extra runtime, COM marshalling, synchronous `readrecords`, credential exposure | Replace with Rust/typst cheque template | 3–10× + removes security risk | M | Low |
| F16 | Email/SMS export is synchronous socket I/O | `n_smtp.pbs` over `n_winsock`: logon→send→logoff; attachments read into blob; `w_sms_center` OLE HTTP | UI blocks during SMTP; large PDF attachments in memory | Queue email; send from service; stream attachment | No UI freeze | M | Low |
| F17 | No cache, queue or usage telemetry | `ReportData` is `DELETE`+`INSERT` argument staging; no report log; DMV shows no report procs | Every run repeats identical work; can't prioritise by real use | `RptCache` keyed by params+data version; `RptJob` queue; log report/rows/seconds | 10–100× on repeats | M | Low |
| F18 | Express 2008 R2 + compat 80 caps the whole design | 1 GB buffer; no indexed views/columnstore/partitioning/Agent; 392 MB VGL + 674 MB SaleDetail exceed cache | Buffer churn; old CE; no modern SQL; no scheduled jobs | SQL 2019/2022 Standard, 32–64 GB RAM; raise compat after testing | 2–10× DB-wide | L | Medium: licensing |
| F19 | Reports run read-committed without `NOLOCK`/RCSI | `is_read_committed_snapshot_on=0`; 0 `NOLOCK` in 4,813 DWs | Long report scans hold shared locks and can block sale posting (and vice versa) | RCSI on a copy/upgrade, or report-only snapshot/summary tables | Removes intermittent freezes | M | Medium: semantics |
| F20 | Missing indexes exactly match report predicates | DMV: VGL `(AccCode)` 99.62%, `(Date)` 96.53%; StockReport `(Date)` 99.94%, `(ICode,Date)` 99.98%; SaleLedger `(Posted,AccountFor)` 83.83% | Full scans of 2M/2.9M rows per report | Add covering indexes; test posting write cost | **10–100× reads** | S | Low: write overhead |

**Families:** daily sales (57 variants: `d_dailysalesdetail` 27, `d_dailysalessummery` 30), stock (`stockreports` 243: `d_stockinhand` 93, `d_stockandsale`, `d_stockinbackdate`, `d_stockmovement_*`), accounts/ledgers (`accountreports` 197: `d_customerledger_itemwise` 30, `d_supplierledger_*` 13, `d_cashflow` 15), sales/customer (`salereports` 256 + `salereportscust` 289), purchase (`purchase&returnreports` 132 + `purchaseprintouts` 126), item (`itemreports` 92), print layouts (`sprnt*` 2,275 / 143 MB), plus patient/student/CRS and special/financial/aging collections.

**On the named “largest” reports:** `d_itemlog_azhar` (328 KB) is a dead ItemLog template (`SELECT * FROM ItemLog WHERE ICode < 0`, 0 refs); `d_item_detail`/`d_item_garments_wizard`/`d_item_update` are item entry; `d_normalpurchasedetail`/`d_customer_detail` are entry/lookup; `d_saledetail` is sale entry (740 refs). The `d_amintraders_*` (4), `d_glaxydist_*` (3) and `d_ahmadmedicine2_*` (1) are one-page invoice print layouts — hot daily, but one page each. None is a 1,000-page report.

**Render estimate.** A 20-column tabular report at ~55 rows/page draws ~1.1M control instances for 1,000 pages; at PB’s per-control cost this is **30–120 s** and 300 MB–1 GB of 32-bit memory `[hypothesis; verify with the protocol below]`. An 81-control invoice layout with logos is heavier per page (~5–15 min for 1,000 pages). Rust typst/printpdf with the same band model should do the tabular case in **3–10 s** and stay under 200 MB by streaming/chunking pages.

## Top 30 report hotspots
| # | Report / DW | Rows / scan | Time (measured or est.) | Fix | Expected gain |
|---|---|---|---|---|---|
| 1 | `d_dailysalesdetail` (+26 variants) | 1,929/day; 13.5k/7d | **1.59 s/day; 7.82 s/7d; ~33 s/30d measured/extrapolated** | Replace UDF with set-based total | 10–15× |
| 2 | `d_dailysalesdetail_invwise` | same shape | 1.5–8 s | Same | 10–15× |
| 3 | `d_dailysalessummery` (+29 variants) | 783 inv/day | 1–3 s/day; 10–20 s/month est. | UDF + pre-aggregate | 8–12× |
| 4 | `d_customerledger_itemwise` | 2M VGL × 36 | 30–120 s/year est. | Single-pass proc + `RptLedgerDaily` | 10–50× |
| 5 | `d_customerledger_itemwise_portrait` | 2M VGL × 54 | 60–180 s est. | Same | 10–50× |
| 6 | `d_customerledger_quarter_summary` | VGL × 81 | 20–60 s est. | Summary table | 10–30× |
| 7 | `d_customerledger_quarter` | VGL × 81 | 20–60 s est. | Summary table | 10–30× |
| 8 | `d_supplierledger_itemwise` (+format2) | VGL × 51 | 20–60 s est. | Same | 10–30× |
| 9 | `d_crs_customerledger_itemwise` (+custgroup) | VGL × 45, 25 UNIONs | 30–90 s est. | Same | 10–30× |
| 10 | `d_cashflow` (+5 variants) | 23–25 UNIONs, 92–134 subqueries | 20–60 s est. | One-pass cashflow proc | 10–20× |
| 11 | `d_accountledger_multicurrency` | VGL × 48 | 20–60 s est. | Index + summary | 10–20× |
| 12 | `d_summacc_accountledger_itemwise` | VGL × 13, 63 subqueries | 10–40 s est. | Same | 10–20× |
| 13 | `d_itemstockregister_antinarcotix3` | 20 UNIONs, 79 subqueries | 15–45 s est. | Single-pass register | 8–15× |
| 14 | `d_godown_saleperson_activity` | 34 UNIONs, 42 subqueries | 10–30 s est. | Same | 8–15× |
| 15 | `d_stockandsale` (+summary variants) | 29k items, 26 UNIONs | 5–20 s est. | Summary table | 5–10× |
| 16 | `d_stockinbackdate` | 6k rows/day; 28,244 reads (226 MB) | **0.14–0.82 s measured** | Cluster/index StockReport | 5–50× |
| 17 | `d_stockinhand_modelwise_backdate` | same heap scan | 1–3 s est. | Same | 5–50× |
| 18 | `d_stockinhand` | 29k items; 4,600 reads | **376 ms measured** | Remove client sort/group | 1.5–2× |
| 19 | `d_stockinhand_allgodown_crosstab` | items × godowns | 5–20 s est. | Session crosstab | 5–10× |
| 20 | `d_subareasales_landscape_crosstab2` | items × 13 areas | 5–20 s est. | Server pivot | 5–10× |
| 21 | `d_zonalareasales_crosstab` (+portrait) | items × zones | 5–20 s est. | Server pivot | 5–10× |
| 22 | `d_saledetail_crosstab` | 1.3M SaleDetail | 2–10 s est. | Pre-aggregate | 3–5× |
| 23 | `d_purdetail_crosstab` | 197k PurDetail | 2–10 s est. | Pre-aggregate | 3–5× |
| 24 | `SP_VirtualGL` pre-step (90 branches) | 2M VGL; 74,406 reads | **0.53–1.26 s sales branch**; 2–5 s all branches est. | Watermark/async | 5–10× perceived |
| 25 | `SP_STOCKLEDGER` pre-step | Pur/Sale scan + `TABLOCKX` | 2–10 s est.; blocks all stock | Batch/async | 5–10× |
| 26 | `fn_getSaleInvTotal` (584 DWs) | ~0.76 ms/call | 0.5–3 s per report | Denormalise totals | 5–15× |
| 27 | Excel export via `dw2xls` | 1.1M cells/1,000 pages | 60–180 s est. | `rust_xlsxwriter` | 5–20× |
| 28 | PDF export / preview | 1,000 pages | 30–120 s est. | Streaming renderer + queue | 3–10× |
| 29 | Invoice print layout | 81 controls/page; 714 logo layouts | 0.3–1 s/page est. | Template + direct print | 2–5× |
| 30 | Crystal cheque `rptPrintCheque.rpt` | 1 page | 2–5 s + COM | Rust/typst cheque | 3–10× |

## Reporting architecture options
| Option | What it fixes | Performance | Effort | Licensing / ops | Verdict |
|---|---|---|---|---|---|
| **Current PB + SQL fixes** | UDF, indexes, VGL/StockLedger pre-steps, double print dialog | 2–15× hot reports; render/export unchanged | 2–6 weeks | $0; existing client | **Do first.** Highest ROI, lowest risk |
| **SQL summary layer** | Daily sales, ledger balances, item/month, stock snapshots | 10–100× on aggregates; 1–3 s typical | 3–6 weeks | $0 on Express; >10 GB/columnstore needs Standard | **Do second.** Works with PB unchanged |
| **SSRS** | Tabular back-office, subscriptions, cached snapshots | 1–10 s server-side; good pagination/export | 6–12 weeks for 30–50 reports | SSRS free with SQL Standard ($3,945/2-core or $989+$230/CAL); Windows server; no Agent on Express | Good interim for ledgers/management; poor fit for invoices/cheques |
| **Power BI / Fabric** | Dashboards, management visuals | Fast in-memory; not pixel reports | 4–8 weeks + modelling | Pro $14/user/mo; PPU $24; F2 from ~$263/mo | Management dashboards only |
| **Metabase** | Ad-hoc SQL/dashboards | 1–5 s; weak pixel print | 1–3 weeks | OSS free; Pro $575/mo (10 users) | Cheap ad-hoc layer, not a report replacement |
| **Rust report service** | SQL→bands→PDF/XLSX/HTML, streaming, cache, queue | 55k rows → PDF 3–10 s; XLSX 1–3 s; <200 MB (est.) | 3–6 months core + top 20; 12–18 months parity | $0 runtime (MIT/Apache); one service | **Target architecture** for Tauri |
| **Hybrid (recommended)** | PB keeps entry + long tail; Rust serves top 20/exports | 5–20× on moved reports | 3–4 months | As above | Best perceived win / risk balance |

## Migration order
1. **Cross-cutting fixes (weeks 1–2):** replace `fn_getSaleInvTotal`; add VGL/StockReport/SaleLedger indexes; stop synchronous `SP_VirtualGL`/`SP_STOCKLEDGER`; remove double print dialog. Validation: run the 1-day/7-day daily-sales benchmark before/after; check posting throughput.
2. **Daily sales & stock (weeks 2–4):** `d_dailysalesdetail`, `d_dailysalessummery`, `d_stockinhand`, `d_stockinbackdate`. Validation: totals reconcile to `SaleLedger`/`StockReport`; p95 <3 s.
3. **Customer/supplier ledgers & statements (weeks 4–8):** `d_customerledger_itemwise*`, `d_supplierledger*`, `d_cashflow*` on `RptLedgerDaily`. Validation: opening + movements = closing for 20 accounts; compare to legacy PDF.
4. **Item-wise sales/purchase, stock & sale, aging (weeks 8–12):** `d_itemstockregister*`, `d_stockandsale`, aging. Validation: sample 10 items/months.
5. **Crosstabs (weeks 12–14):** area/zone/stock-in-hand; session-keyed pivot. Validation: two concurrent users, no data bleed.
6. **Compliance & pixel-perfect (weeks 14–22):** sales tax/FBR, invoices, cheques. Keep PB fallback until byte-identical.
7. **Long tail (6–12 months):** migrate only reports with real usage; template the 2,275 print layouts.

## Caching, queue & background generation
- **Cache key:** `hash(report_id, normalised_params, rights_scope, data_version)`, including godown/customer scope to prevent leaks. Bump `RptDataVersion` on posting; TTL 5 min (daily sales/stock), 1 h (monthly/ledger), 24 h (statements). Store PDF/XLSX on disk with a metadata row, not as blobs in the 10 GB DB.
- **Queue:** `RptJob(JobId, ReportId, ParamsJson, Status, OutputPath)`. Interactive jobs first; 2–4 workers for long runs; PB polls, Tauri uses SSE. Pre-render daily snapshots after midnight; notify via existing SMTP/SMS.

## Rust service shape
`axum`/`tokio`; `tiberius` read-only pool; versioned YAML/JSON report definitions (SQL + bands + columns); `typst` for statements/invoices, `printpdf`/`pdf-writer` for fixed grids, `rust_xlsxwriter` for Excel, `minijinja` for HTML preview. Stream SQL rows, render page chunks, merge with `lopdf` for 1,000+ pages; semaphore caps workers at cores−1. No headless browser unless HTML-to-PDF fidelity is required. Both the current PB app and Tauri call the same service — the lowest-risk migration path.

## Benchmark protocol
- **Matrix:** 12 reports × {1 day, 1 month, 1 year} × {100, 1k, 10k, 50k rows}; include one 1,000-page print and one 50k-row Excel/PDF export.
- **Phases, measured separately:** dialog time, SQL retrieve, PB retrieve (rows/s), preview layout, print spool, Excel, PDF, email.
- **Instrumentation:** PB `SecondsAfter()` + `cpu()` around each phase; `Get-Process` peak working set; SQL `SET STATISTICS IO/TIME`; `sys.dm_exec_query_stats` (note: compat 80 blocks `CROSS APPLY`, so capture via trace or upgrade); PerfMon counters (CPU, pages/s, lock waits); spooler page count; `pdfinfo` page count.
- **Method:** 2 warm-up runs, 3 measured runs, median; same client/printer driver/data snapshot; record rows, pages, seconds, CPU, peak MB, logical reads, output MB. Never run `DBCC DROPCLEANBUFFERS` on production.
- **Acceptance:** daily reports p95 <3 s; monthly <10 s; 10k-row Excel <15 s; 1,000-page PDF <30 s; peak working set <800 MB (32-bit safe); logical reads <100k/report.
- **Concurrency:** 5 users running daily sales + 2 running ledgers + 1 crosstab; measure POS posting latency and deadlocks.

## What NOT to do
- **Don't migrate 4,813 DataWindows one by one.** There are ~423 logical reports; parameterise variants and template customer branding.
- **Don't chase SRD file size.** The 200–330 KB DWs are wide OLTP definitions; the heavy reports are 38–54 KB of SQL fan-out.
- **Don't use indexed views, columnstore, partitioning or compression on 2008 R2 Express.** Indexed views need Enterprise/Developer; columnstore needs 2012 Enterprise or 2016 SP1+; partitioning/compression need Enterprise on 2008 R2.
- **Don't run `SP_VirtualGL`/`SP_STOCKLEDGER` synchronously on report open.** The `TABLOCKX` blocks the whole shop.
- **Don't export Excel cell-by-cell or print 1,000-page reports on the POS client.** Move both server-side.
- **Don't put SSRS/Crystal in the hot path for invoices/cheques.** Pixel parity and per-page cost are worse than PB.

## Measurements still needed
1. Add dispatcher telemetry (`report, user, params, rows, retrieve_s, render_s, export_s`) — there is no usage log today.
2. Time `SP_VirtualGL` end-to-end on a **copy** DB; sum all 18 branches.
3. Benchmark `dw2xls` at 1k/10k/50k rows and PB preview/print at 100/500/1,000 pages; capture CPU and peak MB.
4. Measure index write overhead on sale posting before/after; test compat level 100/110 on a copy.
5. Reconcile each summary table to source for 3 months.
6. Run two crosstabs concurrently on a copy to reproduce the global-table race.
7. Measure real report frequency from menu/security usage; rank by count × duration.

**Bottom line:** the current app can be made “lightning fast” for most reports without touching PowerBuilder — the measured 11–14× on daily sales and 100×-class read reductions on ledgers are available from SQL and indexing alone. The Rust engine is the right long-term renderer for Tauri, but it should sit behind a report service that the existing PB app can call, so each report can move when it is ready rather than as a big-bang rewrite.
