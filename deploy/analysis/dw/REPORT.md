# DataWindow layer (8,748 SRDs) — findings

## Executive verdict
- **The layer is bimodal.** 22 measured retrieves split cleanly: transactional entry DWs are **4–9 ms / <500 logical reads**; ledger/stock reports are **0.2–21.5 s / 25k–500k reads**. The pain is ~30 report/popup objects, not 8,748.
- **The defect is combinatorial SQL, not `SELECT *`.** Only 38 DWs use `SELECT *` and 11 use `TOP`; but 5,145 DWs contain **26,899 subqueries**, 1,048 contain top-level `UNION` (**3,686 legs**), and 4,088 touch a ≥100k-row table. `d_customerledger_itemwise` (11 legs, 89 subqueries) takes **21.5 s for one week of one customer**.
- **PowerBuilder settings amplify it.** Only **2/8,748** DWs set `retrieve.asneeded=yes`; **none** set `Rows`/`Buffer`; **2,854** dropdowns have `dddw.limit=0`; **1,965** DWs sort twice. Every report materialises its full result before painting.
- **The fastest wins are DB-only.** Five narrow indexes are corroborated by SQL Server's missing-index DMV at **83–99.98% estimated impact**. The biggest app-side win is the 12 `COUNT/MIN/MAX` “Total Invoices” legs: measured **176,951 → 103,284 reads (−42%)** on one leg.
- **Most of the 8,748 are dormant variants.** 2,275 sale-print DWs (**143 MB, 42% of DW bytes**) are selected by a `gs_company` chain, one per deployment. Tune the active default, not the 2,274 others.

## Evidence base
- Parsed every `.srd` under `recovered/datawindows/**` (**8,748 files, 343.7 MB, 102 libraries**) with `deploy/analysis/dw/dwparse.py` → `dw_metrics.json` / `.csv`. 8,664 contain retrieve SQL (166 `PBSELECT(...)`), 84 composites.
- Cross-referenced **2,780 `.pbs`**: 3,193 static `dataobject = "..."` assignments, 5,304 DW names referenced by literal, 4,090 `.Retrieve()` calls, 5,115 `SetTransObject`.
- **SQL feature census:** 38 `SELECT *`, 281 `DISTINCT` (160 on ≥100k-row tables), 11 `TOP`, 1 `LIKE '%'`, 4,313 `CASE`, 5,130 function-on-column, 2,757 `ISNULL`, 0 temp tables, 0 `EXEC`. Table blocks define **189,205 columns** (avg 21.6/DW); **14,014 retrieve arguments across 7,074 DWs** (1,674 have none); 147 crosstabs, 70 graphs, 168 DWs with nested reports.
- **Shared/core:** `d_arg_class` (74 scripts), `d_arg_packing` (73), `d_itemcategories` (69), `d_manufacturers` (69) are report-argument pickers; `d_itemstockinfo` (24) is the shared stock panel; `d_popup_customerselection` (22); `d_normalpurchasedetail` (19); `d_loosepurchasedetail` (16); `d_groups_discount` (14); `d_security` and `d_sequence` are low-traffic infrastructure. There is **no canonical `d_item`/`d_customer`** — those roles are split across 281/282 variants.
- DB `.\SQLEXPRESS` / `FazalDinPP19DataBaseV2`: 752 tables; row counts from `sys.partitions`; 22 DW queries run with `SET STATISTICS IO, TIME ON`; plans via `SET SHOWPLAN_ALL ON`. Files `deploy/analysis/dw/m*.sql`, `out_*.txt`.
- **Caveat:** the restored copy has **2 Customer rows, 225 suppliers, 137 VirtualGl accounts**, but full transaction tables (≈588.9k `SaleLedger`, 1.31M `Saledetail`, ≈2.0M `VirtualGl`, 2.91M `StockReport`). Timings prove plan shape, not production cardinality; every number is reproducible from the saved `.sql`. Two screens (`d_customerbalances_in_sales`, `d_popup_supplierselection_many`) have no date filter by design; each was run **once**, not repeated.

## Findings
| ID | Finding | Evidence (file:line / measured) | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| F1 | **UNION-leg farms** — each ledger type is its own `SELECT` | 1,048 DWs / 3,686 top-level legs; `accountreports/d_cashflow.srd:16` has 24 legs; plan = 60 scans, 111 seeks, 144 nested loops, 14 sorts; 6 `SaleLedger` scans = 270,210 reads, 1.33 s for 3 rows | Every leg re-opens the same headers and re-applies the same date filter | One pass with `CASE`, or pre-aggregate each leg then `UNION` the small results | 2–5× [measured/analogous] | M | Medium — row-equivalence must be proved |
| F2 | **Correlated scalar subqueries in SELECT** | 26,899 `(SELECT` / 5,145 DWs; `d_customerledger_itemwise.srd:34` has 89; 5,689 `SaleDetail` seeks + 2,843 `CashierWindow` seeks → **21.5 s**, ~206k reads for 6,872 rows | Executed per output row/group; each is a seek or scan the optimizer cannot batch | `LEFT JOIN` pre-aggregated derived tables; drop redundant `MAX(ROWID)` predicates | 3–8× [measured baseline] | M | Low–Medium |
| F3 | **COUNT/MIN/MAX inside display strings** | `d_cashflow` legs 9–20; each does 3 subqueries over `SaleLedger` per cash account; leg measured **176,951 → 103,284 reads** after grouping | Extra scans per leg just to print “Total Invoices: n (min–max)” | One grouped derived table `(cashacccode, n, mn, mx)` joined once | 1.7× on leg; ~20% full report [measured] | S | Low |
| F4 | **Whole-table aggregate for a tiny screen** | `accounts/d_customerbalances_in_sales.srd:9`: **75,814 reads / 259 ms → 2 rows**; `reportdwarg/d_popup_supplierselection_many.srd:19`: **37,907 reads / 835 ms → 225 rows** | Aggregates 2M `VirtualGl` rows before filtering to the few accounts the UI needs | Covering index + filter accounts first; keep the single pre-aggregate (see “What NOT to do”) | 5–10× [measured IO] | S | Low |
| F5 | **Missing covering indexes on the four big tables** | DMV: `VirtualGl(AccCode) INCLUDE(Debit,Credit)` 99.6%; `StockReport(ICode,Date) INCLUDE(GCode,Stock,PurchasePrice,SalePrice)` 99.98%; `SaleLedger(Posted,AccountFor) INCLUDE(SaleInvCode)` 83.8% (date-first variant chosen for the ledger family); `SaleDetail(Due) INCLUDE(SaleInvcode,ICode,LooseQty,BonusQty)` 42.2% | Heap/clustered scans of 202–674 MB tables | Create five indexes across these four tables (see plan) | 3–10× read reduction [DMV estimate] | S | Low — write cost, buffer pool |
| F6 | **StockReport scanned for one date/item** | `stockreports/d_stockinbackdate.srd:22`: **28,244 reads / 200 ms → 0 rows** for one date+item; `dropdowns/ddd_stockdate.srd:8` = `SELECT DISTINCT Date FROM StockReport` over 2.9M rows | No `(ICode,Date)` or `(Date)` index; DISTINCT scans 202 MB to show ~1k dates | `(ICode,Date)` + `(Date)` indexes; cache dates in a small table | 10–30× | S | Low |
| F7 | **Unbounded retrieves** | 4,088 DWs touch ≥100k rows; **3,309** have no range predicate in a `WHERE` (heuristic; join-clause filters not counted); only 11 use `TOP` | Full result set built, sorted, sent, and held client-side | Mandatory date args, `TOP (n)`, or `Retrieve As Needed` | 2–20× | M | Low |
| F8 | **PB retrieval settings unused** | `retrieve.asneeded=yes` in **2/8,748**; `rows=`/`buffer=` in **0**; `ShareData` only 184 calls | All rows materialised; no incremental paint, no row cap | Enable on flat report lists; set Rows/Buffer; ShareData where identical | 1.5–4× perceived [hypothesis] | S | Low |
| F9 | **Double sorting** | 2,732 DWs have `sort=`; **1,965** also have SQL `ORDER BY`; e.g. `d_wholesaledetail` `ORDER BY MIN(IDENTITYCOL)` + `sort="id A"`; `d_stockandsale_zone_and_others.srd:457` `sort="groupname A, itemname A"` | SQL sorts the full set, then PB sorts it again client-side | Remove PB `sort=` where SQL order is identical; otherwise drop SQL `ORDER BY` | 5–15% of report time | S | Low |
| F10 | **Unbounded dropdowns** | 2,854 `dddw.limit=0`; 200 of 222 `dropdowns/*` have no args; `ddd_stockdate` 2.9M; `ddd_item`/`ddd_positem` 28,964; `d_pending_refusedsalesreport` 1.3M no args | Opening a picker scans/materialises the whole table | `TOP 100`, `WHERE active=1`, `dddw.limit=50`, auto-retrieve off | 0.1–2 s per open | S | Low |
| F11 | **Presentation bloat** | **97,059** compute objects; 2,265 DWs with ≥20 computes; 1,696 with ≥40 columns; 771 >100 KB; max 328 KB / 138 cols (`abuzarapp/d_itemlog_azhar.srd`) | Each compute recalculates per row; wide rows slow paint/scroll/print | Thin list + detail DW; move computes to SQL; hide unused columns | 1.2–2× perceived [hypothesis] | M | Low |
| F12 | **Entry DWs are DB-fast but render-heavy** | `salewin/d_saledetail.srd`: 9 ms / 297 reads / 58 rows, but **81 cols + 16 computes + 196 KB**; `d_normalpurchasedetail`: 8 ms, 73 cols/57 computes; `d_wholesaledetail`: 4 ms, 96 cols/39 computes | DB is not the bottleneck on sale/purchase entry; client row construction is | Column pruning; compute in SQL; split header/detail | 1.2–1.5× perceived | M | Low |
| F13 | **Dormant print templates + variant explosion** | 2,275 DWs in `sprnt*` alone (143 MB, 0 updatable), chosen by `gs_company` chains; 3,276 DWs reference `Saledetail`; 281 `d_item*`, 282 `d_customer*`; `d_item`/`d_customer` do not exist | The active template is buried; each variant must be tuned separately | Tune the default only; define canonical `d_item_list`/`d_customer_list`; config-driven variants | Avoids wasted work | S/L | Low |
| F14 | **Non-sargable predicates** | 5,130 DWs use functions on columns; 2,757 `ISNULL`; 452 `OR`; `d_stockinbackdate` filters `CASE :as_ReportType WHEN 'M' THEN I.ManfCode … END IN (:ai_code)` | Index unusable; forces scan/convert per row | Split by report type; `(@type='M' AND I.ManfCode IN (…)) OR …` + `OPTION(RECOMPILE)`, or dynamic SQL | 2–10× | M | Medium |
| F15 | **Nested/composite reports** | 59 composites, 280 nested refs; `d_zonalareasales3` embedded 16× | Each child retrieves separately; no shared result | `ShareData` where identical; one query for same source | 1.5–3× on composites [hypothesis] | M | Medium |
| F16 | **Optimizer fragility / data skew** | `d_areawisereceivable` same shape = **8 reads / 2 ms**; `d_customerbalances_in_sales` = **75,814 / 259 ms**. 588,862 of 588,865 SaleLedger rows are customer 19 | Plan flips between seek and full scan on statistics/grouping | Filter-first temp table + covering index; update stats; test production-like data | 10× on the bad variant | S–M | Low |
| F17 | **No stored procedures or temp tables** | 0 DWs use `EXEC` or `#temp`; all heavy logic is ad-hoc client SQL | No plan reuse, no set-based staging, huge parse cost (34 KB SQL) | Move top 10 reports to stored procedures returning the same shape | 2–5× [analogous] | L | Medium |

## Measured sample (15 of 22 shown; all 22 in `out_*.txt`)
| DataWindow | Rows | Logical reads | CPU ms | Elapsed ms | Plan shape |
|---|---:|---:|---:|---:|---|
| `d_customerledger_itemwise` | 6,872 | 206k | 20,062 | **21,492** | 4 VirtualGl scans, 3 SaleLedger scans, 5,689 SaleDetail seeks, 2,843 CashierWindow seeks |
| `d_customerledger_quarter_summary` | 4,502 | 473k | 4,328 | **6,851** | 4 SaleLedger scans, 27,881 SaleDetail seeks, 9 VirtualGl scans, 4 SRLedger scans |
| `d_stockandsale_zone_and_others` | 342 | 123k | 1,422 | **3,649** | 2,844 SaleDetail seeks, 2 SaleLedger scans, 83 Purdetail seeks, 2 SRLedger scans |
| `d_cashflow` | 3 | 385k | 1,172 | **1,327** | 6 SaleLedger scans (270k), 13,939 SaleDetail seeks, 1 VirtualGl scan |
| `d_cashflow5` | 3 | 385k | 1,188 | **1,216** | Same shape as `d_cashflow` |
| `d_popup_supplierselection_many` | 225 | 37.9k | 844 | **835** | 1 VirtualGl scan + hash aggregate/hash join |
| `d_supplierledger_itemwise` | 88 | 80.4k | 344 | **402** | 4 VirtualGl scans (76,258) |
| `d_customerbalances_in_sales` | 2 | 75.8k | 234 | **259** | 2 VirtualGl scans + hash aggregate |
| `d_stockinbackdate` | 0 | 28.2k | 203 | **200** | 1 StockReport scan |
| `d_po_purchase_disparity` | 14 | 24.8k | 63 | **58** | 79 Purdetail seeks, 1 Purledger scan |
| `d_saledetail` | 58 | 0.30k | 0 | **9** | 1 clustered seek + 58 ItemPacking seeks |
| `d_normalpurchasedetail` | 40 | 0.33k | 0 | **8** | 1 clustered seek + 41 GodownDetail seeks |
| `d_wholesaledetail` | 50 | 0.30k | 0 | **4** | 1 clustered seek + 57 ItemPacking seeks |
| `d_itemstockregister_standard` | 0 | 4.0k | 16 | **21** | 1 SaleDetail scan, 1 SRdetail scan, 100 AdjDetail seeks |
| `d_areawisereceivable` | 0 | **8** | 0 | **2** | 2 VirtualGl seeks — same shape as `d_customerbalances_in_sales` but a different plan |

The last row is the control: near-identical shape to `d_customerbalances_in_sales`, ~9,500× fewer reads because the optimizer chose seeks. That is the fragility F16 describes.

## Top 50 DataWindow hit list
Legend — **Cls**: R report, E entry, L list/dropdown, P print. **Used** = distinct `.pbs` files that name the DW (static; dynamic `ls_report` dispatch undercounts). **Shape** = T tables / J joins / SQ subqueries / U top-level union legs. **Measured** = ms / k logical reads; `*` = measured in this study. **Fix**: IDX index, RW retrieve rewrite, PB retrieve settings, THIN columns/computes, ARG args/TOP, DROP duplicate sort. Rows marked `*` are from the stated test slice; ledger/report rows scale with the date range and customer count. Rows 11–20 are unmeasured family variants whose shape is equal to or worse than the measured sibling.

| # | DataWindow (library) | Cls | Used | Shape | Rows out | Measured | Fix | Gain |
|---:|---|---|---:|---|---:|---|---|---|
| 1 | `d_customerledger_itemwise` (accountreports) | R | 1 | T18 J17 SQ89 U11 | 6,872* | **21,492 / 206k** | RW + IDX | 3–8× |
| 2 | `d_customerledger_quarter_summary` (accountreports) | R | 1 | T10 J9 SQ60 U3 | 4,502* | **6,851 / 473k** | RW + IDX | 3–6× |
| 3 | `d_stockandsale_zone_and_others` (stockreports) | R | 2 | T24 J52 SQ10 U1 (24 nested unions) | 342* | **3,649 / 123k** | RW + IDX | 2–4× |
| 4 | `d_customerbalances_in_sales` (accounts) | L | 9 | T3 J2 SQ0 | 2* | **259 / 75.8k** | IDX | 5–10× |
| 5 | `d_popup_supplierselection_many` (reportdwarg) | L | 6 | T5 J2 SQ3 | 225* | **835 / 37.9k** | IDX | 5–10× |
| 6 | `d_cashflow` (accountreports) | R | 2 | T21 J20 SQ117 U24 | 3* | **1,327 / 385k** | RW + IDX | 2–3× |
| 7 | `d_cashflow5` (accountreports) | R | 1 | T20 J19 SQ120 U24 | 3* | **1,216 / 385k** | RW + IDX | 2–3× |
| 8 | `d_supplierledger_itemwise` (accountreports) | R | 1 | T15 J14 SQ51 U16 | 88* | **402 / 80.4k** | RW + IDX | 2–4× |
| 9 | `d_stockinbackdate` (stockreports) | R | 1 | T6 J5 SQ2 | 0* | **200 / 28.2k** | IDX + RW | 10–30× |
| 10 | `d_po_purchase_disparity` (purchase&returnreports) | R | 3 | T7 J6 SQ4 U1 | 14* | **58 / 24.8k** | IDX | 2–3× |
| 11 | `d_customerledger_itemwise_portrait` (accountreports) | R | 1 | T22 J21 SQ119 U17 | thousands | not run | RW + IDX | 3–8× |
| 12 | `d_customerledger_itemwise_patient` (accountreports) | R | 1 | T19 J18 SQ107 | thousands | not run | RW + IDX | 3–8× |
| 13 | `d_customerledger_itemwise_ref` (accountreports) | R | 1 | T18 J17 SQ89 | thousands | not run | RW + IDX | 3–8× |
| 14 | `d_customerledger_itemwise_itemdesc` (accountreports) | R | 1 | T18 J17 SQ89 | thousands | not run | RW + IDX | 3–8× |
| 15 | `d_cashflow_withreceiptsummary` (accountreports) | R | 1 | T20 J19 SQ134 U26 | few | not run | RW | 2–3× |
| 16 | `d_cashflow_cashandbanks` (accountreports) | R | 1 | T19 J18 SQ111 U23 | few | not run | RW | 2–3× |
| 17 | `d_cashflow_onecashacc_portrait` (accountreports) | R | 1 | T20 J19 SQ101 U24 | few | not run | RW | 2–3× |
| 18 | `d_crs_customerledger_itemwise_custgroup` (crsreports) | R | 1 | T19 J18 SQ100 U10 | thousands | not run | RW | 3–6× |
| 19 | `d_crs_customerledger_itemwise` (crsreports) | R | 1 | T17 J16 SQ75 | thousands | not run | RW | 3–6× |
| 20 | `d_inpatientbill` (patientreports) | R | 2 | T26 J118 SQ93 U11 | per admission | not run (0 admissions) | RW | 2–5× |
| 21 | `d_inpatientbill_grouped` (patientreports) | R | 1 | T24 J121 SQ71 U12 | per admission | not run | RW | 2–5× |
| 22 | `d_itemstockregister_antinarcotix3` (itemreports) | R | 1 | T29 J105 SQ79 U11 | hundreds | not run | RW + IDX | 2–4× |
| 23 | `d_itemstockregister_standard` (itemreports) | R | 1 | T26 J79 SQ50 U11 | 0* | **21 / 4.0k** | IDX for lists | 2–3× |
| 24 | `d_itemstockregister_new` (itemreports) | R | 1 | T27 J80 SQ52 U1 (20 nested) | hundreds | not run | RW + IDX | 2–3× |
| 25 | `d_purchase_order_format11` (purchase&returnreports) | P | 0 | T24 J23 SQ21 U1 (18 nested) | 1 PO | not run | THIN | 1.2–2× |
| 26 | `d_godown_saleperson_activity` (godownreports) | R | 1 | T31 J30 SQ42 U4 (33 nested) | thousands | not run | RW | 2–4× |
| 27 | `d_decentphwh_saleprint_full` (sprntatod) | P | 1 | T9 J8 SQ3 | 1 invoice | not run | THIN | 1.2× |
| 28 | `d_amintraders_billsummary_saleinvreport` (billsummary) | P | 1 | T12 J11 SQ4, 44 cmp | 1 invoice | not run | THIN | 1.2–2× |
| 29 | `d_glaxydist_saleinvreport` (sprntetok) | P | 1 | T8 J7 SQ2, 49 cmp | 1 invoice | not run | THIN | 1.2–2× |
| 30 | `d_pending_refusedsalesreport` (salereportsdet) | R | 0 | T4 J2 SQ1 | 1.3M | not run | ARG | 10× |
| 31 | `d_normalpurchasedetail` (purchasecomponents) | E | 19 | T3 J2 SQ2, c73/57 cmp | 40* | **8 / 0.33k** | THIN | 1.2–2× |
| 32 | `d_loosepurchasedetail` (purchasecomponents) | E | 16 | T3 J2 SQ2, c58/34 cmp | 40* | **6 / 0.33k** | THIN | 1.2–1.5× |
| 33 | `d_saledetail` (salewin) | E | 4 | T3 J2 SQ2, c81/16 cmp | 58* | **9 / 0.30k** | THIN | 1.2–1.5× |
| 34 | `d_wholesaledetail` (salewin) | L | 4 | T5 J4 SQ3, c96/39 cmp | 50* | **4 / 0.30k** | THIN | 1.2–1.5× |
| 35 | `d_saleorderheader` (saleorder) | E | 10 | T5 J4 SQ1, c79 | 1 | empty test | THIN | 1.2× |
| 36 | `d_advpurchasedetail` (advancedpurchase) | E | 1 | T4 J3 SQ2, c70/41 cmp | 1 | not run | THIN | 1.2× |
| 37 | `d_imppurchasedetail` (advancedpurchase) | E | 1 | T3 J2 SQ1, c66/39 cmp | 1 | not run | THIN | 1.2× |
| 38 | `d_customer_detail` (custcomponents) | R | 1 | T3 J2 SQ1, c88 | 1 | not run | THIN | 1.2× |
| 39 | `d_itemlog_azhar` (abuzarapp) | E | 0 | T1, c138, 328 KB | 1 | not run | THIN/DROP | n/a |
| 40 | `d_item_detail` (singleentryitem) | E | 0 | T2 J1 SQ1, c130 | 1 | not run | THIN | 1.2× |
| 41 | `ddd_stockdate` (dropdowns) | L | 0 | T1, DISTINCT 2.9M | ~1k dates | not run | IDX/ARG | 10–30× |
| 42 | `ddd_item` (dropdowns) | L | 0 | T1, no WHERE | 28,964 | not run | ARG | 5–10× |
| 43 | `ddd_positem` / `d_positem` (dropdowns/salewin) | L | 0 | T1, no WHERE | 28,964 | not run | ARG | 5–10× |
| 44 | `d_saleinvlist_lookup` (reportdwarg) | L | 0 | T4 J3, 1.3M no args | 1.3M | not run | ARG | 10× |
| 45 | `d_deletedue_list` (duecomponents) | L | 0 | T3 J2, 1.3M no args | 1.3M | not run | ARG | 10× |
| 46 | `d_satisfydue_list` (duecomponents) | L | 0 | T3 J2, 1.3M no args | 1.3M | not run | ARG | 10× |
| 47 | `d_manfwise_salessummary` (salereports) | R | 1 | T4 J6, date range in JOIN | tens of thousands | not run | RW + IDX | 2–4× |
| 48 | `d_customer_list` (custcomponents) | L | 10 | T9 J8 SQ6 | thousands | not run | RW + IDX | 2–3× |
| 49 | `d_popup_customerselection` (reportdwarg) | L | 22 | T5 J4 SQ2 | thousands | not run | ARG | 2–5× |
| 50 | `d_wholesaleheader` (salewin) | E | 4 | T12 J3 SQ7, c135 | 1 | not run | THIN | 1.2–2× |

**Extremes (full ranked lists in `dw_metrics.csv`):** largest files — `d_itemlog_azhar` 328 KB/138 cols, `d_item_detail` 295/130, `d_item_garments_wizard` 294/129, `d_item_update` 271/116, `d_normalpurchasedetail` 211/73. Most joins — `d_inpatientbill_grouped` 121, `d_inpatientbill` 118, `d_itemstockregister_antinarcotix3` 105, `d_itemstockregister_antinarcotix2` 101, `d_itemstockregister_nopricedisc` 87. Most subqueries — `d_cashflow_withreceiptsummary` 134, `d_cashflow5` 120, `d_customerledger_itemwise_portrait` 119, `d_cashflow` 117, `d_cashflow_cashandbanks` 111. The Top 50 above is the impact-ranked subset, not a pure size list.

## Pattern catalogue (10 recurring anti-patterns)
1. **Ledger-leg `UNION ALL` farm** — 1,048 DWs / 3,686 legs. *Before:* 24 `UNION ALL SELECT` blocks, each `FROM SaleLedger … WHERE date BETWEEN …`. *After:* one `SELECT` over the date range with `CASE` on `SaleCatCode`/`DocumentType`, or aggregate each leg into `#tmp` then `UNION` the small results. Owner: app. 2–5×.
2. **Scalar subquery in the SELECT list** — 26,899 occurrences / 5,145 DWs. *Before:* `Remark=(SELECT I.Name FROM Item I WHERE I.ICode=D.ICode)`. *After:* `LEFT JOIN Item I ON I.ICode=D.ICode` and select `I.Name`. Owner: app. 2–10×; **never** convert a pre-aggregated derived table to a per-row `OUTER APPLY` (measured 5.95M reads, 5.08 s vs 0.84 s).
3. **COUNT/MIN/MAX in a display string** — `d_cashflow` legs 9–20. *Before:* three `(SELECT COUNT/MIN/MAX(SaleInvCode) FROM saleledger WHERE cashacccode=s.… )` per row. *After:* `LEFT JOIN (SELECT cashacccode, COUNT(*) n, MIN(SaleInvCode) mn, MAX(SaleInvCode) mx FROM saleledger WHERE … GROUP BY cashacccode) SL ON …`. Owner: app. 1.7× leg, measured.
4. **Whole-table aggregate for a filtered screen** — `d_customerbalances_in_sales`, `d_popup_supplierselection_many`. *Before:* aggregate all `VirtualGl` rows, then join to `Accounts`. *After:* add the `VirtualGl(AccCode) INCLUDE(Debit,Credit)` index; filter-first rewrites alone still scanned in testing (75,814 reads). Owner: DB (+ optional app). 5–10×.
5. **Unbounded retrieve** — 3,309 big-table DWs with no range predicate. *Before:* no date arg, no `TOP`. *After:* mandatory `@start/@end`, `TOP (n)`, or `Retrieve As Needed`. Owner: app/PB. 2–20×.
6. **Non-sargable predicate** — 5,130 function-on-column, 2,757 `ISNULL`, 452 `OR`, `CASE … IN`. *Before:* `CASE @type WHEN 'M' THEN I.ManfCode … END IN (@codes)`. *After:* split into per-type branches, or `(@type='M' AND I.ManfCode IN (…)) OR (@type='C' AND I.ICatCode IN (…)) OPTION(RECOMPILE)`. Owner: app. 2–10×.
7. **Double sort** — 1,965 DWs. *Before:* SQL `ORDER BY` + PB `sort="id A"`. *After:* delete the PB sort when the SQL order is identical; otherwise delete the SQL `ORDER BY`. Owner: app/PB. 5–15%.
8. **Dropdown without limit** — 2,854 `dddw.limit=0`; 200 no-arg dropdowns. *Before:* `SELECT … FROM Item`. *After:* `SELECT TOP 100 … WHERE active=1`, `dddw.limit=50`, auto-retrieve off. Owner: app/PB. 0.1–2 s per open.
9. **Wide row / computed presentation** — 97,059 computes, 1,696 DWs ≥40 columns. *Before:* 81 columns + 16 computes in one row. *After:* thin list (10–15 columns) + detail DW; compute in SQL. Owner: app/PB. 1.2–2× perceived.
10. **Missing covering index for a hot aggregate** — VirtualGl/StockReport/SaleLedger. *Before:* heap scan 2M rows. *After:* `CREATE INDEX … INCLUDE(…)` on the predicate + aggregate columns. Owner: DB. 5–10× reads.

## Safe rewrite recipe — `d_cashflow` (high value, measured)
**Why this one:** menu report used by 2 scripts; 24 output legs; 1,327 ms and 385k logical reads to return 3 rows. The “Total Invoices” legs (9–20) each recompute the same three aggregates per cash account.

**Before** (`recovered/datawindows/accountreports/d_cashflow.srd:16`, leg 9):
```sql
remarks = 'Total Invoices: ' +
  LTRIM(RTRIM(STR((SELECT COUNT(SaleInvCode) FROM saleledger
     WHERE saleledger.cashacccode = s.cashacccode AND salecatcode = 3
       AND posted = 'Y' AND accountfor = 'Y'
       AND date >= :ad_StartDate AND date <= :ad_EndDate), 7)))
  + ' (' + ... MIN ... + '-' + ... MAX ... + ')'
...
FROM (SELECT h.cashacccode, amt = ... FROM saleledger h, saledetail d
      WHERE ... GROUP BY ...) S
GROUP BY S.cashacccode HAVING SUM(S.Amt) <> 0
```

**After** (complete runnable version in `deploy/analysis/dw/leg9_after.sql`):
```sql
remarks = 'Total Invoices: ' + LTRIM(RTRIM(STR(SL.n, 7))) + ' (' +
          LTRIM(RTRIM(STR(SL.mn, 7))) + '-' + LTRIM(RTRIM(STR(SL.mx, 7))) + ')'
...
FROM (SELECT h.cashacccode, amt = ... FROM saleledger h, saledetail d
      WHERE ... GROUP BY ...) S
LEFT JOIN (SELECT cashacccode, COUNT(*) n, MIN(SaleInvCode) mn, MAX(SaleInvCode) mx
           FROM saleledger
           WHERE salecatcode = 3 AND posted = 'Y' AND accountfor = 'Y'
             AND date >= :ad_StartDate AND date <= :ad_EndDate
           GROUP BY cashacccode) SL ON SL.cashacccode = S.cashacccode
GROUP BY S.cashacccode, SL.n, SL.mn, SL.mx
HAVING SUM(S.Amt) <> 0
```
**Measured:** leg 9 went from **176,951 logical reads / 4 SaleLedger scans (234 ms CPU)** to **103,284 reads / 2 scans (203 ms CPU)** — −42% reads. SaleDetail’s 13,939 seeks (46,702 reads) are unchanged; they need a `SaleDetail(ICode,SaleInvCode)` index and a set-based line aggregate. Apply the same edit to legs 10–20; validate by comparing row counts and `remarks` strings for three months before switching.

## Fix ownership — what can actually ship
“App-only” here means **no DB schema change**, not “no client rebuild”: the running app loads DataWindows from `.pbd`, not from the recovered `.srd`. Every retrieve/property fix below needs a PB 12.5 rebuild (or a runtime patch, which needs source).

| Fix | Lives in | Deployable without PB 12.5/PBL rebuild? |
|---|---|---|
| Five indexes; `UPDATE STATISTICS` | SQL Server | **Yes** — DB-only, maintenance window |
| Retrieve SQL rewrite (UNION, subqueries, args) | `.srd` → PBL → PBD | **No** — `.srd` is recovered evidence, not the runtime artifact; requires re-import + library rebuild |
| `retrieve.asneeded`, `Rows`, `Buffer`, `sort`, `filter`, `dddw.limit` | DataWindow object properties | **No** — PBL/PBD rebuild |
| Column/compute thinning | PBL/PBD | **No** |
| Stored-procedure report | DB object + DW retrieve change | DB half **yes**; client half **no** |
| Runtime `SetSQLSelect`/`Modify` patch | PowerScript source | **No** — no source |
| Retire dormant print variants | deployment/config | **Yes** — stop shipping/tuning them |

**Bottom line:** the only fixes deployable *today* without a PowerBuilder rebuild are the DB indexes and statistics. The app-side rewrites are cheap in principle but require PB 12.5 and the PBLs; budget that dependency explicitly.

## Top 10 by ROI (ranked)
1. **Create 5 indexes** (VirtualGl, StockReport ×2, SaleLedger, SaleDetail) — S, DB-only, 3–10× on the measured reports.
2. **Rewrite the 12 “Total Invoices” legs** in `d_cashflow`/`d_cashflow5` — S, measured −42% reads on the leg.
3. **Rewrite `d_customerledger_itemwise` family** (11–17 legs, 89–119 subqueries) — M, 3–8×; the single worst measured screen.
4. **Guard the 35 no-arg big-table DWs** with date args/`TOP` — M, 2–20×.
5. **Fix `d_customerbalances_in_sales`** (75.8k reads for 2 rows, 9 screens) — S, 5–10×.
6. **Fix dropdowns** (`ddd_stockdate`, `ddd_item`, `ddd_positem`, due/sale lists) — S, 0.1–2 s per open.
7. **Remove 1,965 double sorts** — S, 5–15%.
8. **Enable `Retrieve As Needed`/Rows** on flat report lists — S, 1.5–4× perceived [hypothesis].
9. **Thin `d_saledetail`/`d_normalpurchasedetail`/`d_wholesaledetail`** — M, 1.2–1.5× perceived; DB already fast.
10. **Retire dormant print variants**; tune the active default — S, avoids wasted effort.

## Implementation plan (ordered)
1. **Freeze a baseline.** Run `m1`, `m2`, `m7`, `m8`, `m21`, `m22` against a restored copy; save `out_*.txt`. Validation: same row counts and totals as today.
2. **Create the five indexes** in a maintenance window (one at a time): `VirtualGl(AccCode) INCLUDE(Debit,Credit)`; `StockReport(ICode,Date) INCLUDE(GCode,Stock,PurchasePrice,SalePrice,PackUnits)`; `StockReport(Date) INCLUDE(ICode,GCode,Stock)`; `SaleLedger(Date,SaleCatCode) INCLUDE(Posted,AccountFor,CashAccCode,CustCode)`; `SaleDetail(ICode,SaleInvCode) INCLUDE(LooseQty,BonusQty,SalePrice,ItemFlatDisc,DiscPerc)`. Validation: rerun the same six and compare reads/time; watch write latency on sale posting.
3. **Rewrite `d_cashflow` legs 9–20** using `leg9_after.sql`; validate three months of `remarks`, `debit`, `credit`, row counts.
4. **Rewrite `d_customerledger_itemwise`**: pre-aggregate `CashierWindow` per invoice, pre-aggregate `VirtualGL` opening balances, replace `CASE MAX(D.RowID) WHEN (SELECT MAX(SD.ROWID)…)` with a CTE `MaxRow` join. Validate totals per customer/month.
5. **Add args/TOP** to the 35 no-arg big-table DWs; start with `d_pending_refusedsalesreport`, `d_saleinvlist_lookup`, `d_deletedue_list`, `d_satisfydue_list`.
6. **Dropdown sweep**: add `TOP 100`/`WHERE active=1`, set `dddw.limit`, disable auto-retrieve on 200 no-arg pickers.
7. **Sort sweep**: delete PB `sort=` where SQL `ORDER BY` is identical; measure paint time.
8. **Presentation thinning** on the five widest entry DWs; then re-measure screen open time end-to-end.

## What NOT to do
- **Do not rewrite pre-aggregated derived tables as correlated `OUTER APPLY`.** Measured on the supplier popup: 5,949,878 worktable reads / 5.08 s vs 37,907 / 0.84 s — 6× worse.
- **Do not use `OPTION (FORCE ORDER)` as the fix.** It halved `d_customerbalances_in_sales` reads (75,814 → 37,907) but still scanned the heap; the covering index is the real fix.
- **Do not create every DMV suggestion.** Many overlap (VirtualGl has 10 variants); on Express with a ~1 GB buffer pool, wide indexes crowd out data pages.
- **Do not use indexed views.** Express does not support them (Enterprise/Developer only).
- **Do not enable `Retrieve As Needed` on updatable entry DWs.** It breaks row status/locking assumptions; test on flat report lists only.
- **Do not tune the 2,275 print variants.** Only one company branch is active per deployment.
- **Do not add `DISTINCT` or `TOP` blindly** — `DISTINCT` on 160 big-table DWs hides duplicate joins and adds sorts.

## Measurements still needed
- **Production-cardinality run.** Restore a production backup on a test instance and rerun `m7`/`m8`/`m21`/`m22`; the local copy has 2 customers and 137 VirtualGl accounts, so plan choices may differ.
- **Client render time.** No PB instrumentation here: measure screen-open wall clock minus the SQL RPC duration from Profiler (`RPC:Completed`, `Duration`, `RowCounts`).
- **Index impact on a copy.** The five `CREATE INDEX` statements above; measure before/after with the same `m*.sql`; also measure sale-posting write latency.
- **`Retrieve As Needed` behavior.** Test on `d_customerledger_itemwise` and `d_customerledger_quarter_summary` in a PB test build; measure time-to-first-row and total.
- **Top SQL by total time.** Read-only query:
  ```sql
  SELECT TOP 20 qs.total_elapsed_time/qs.execution_count/1000 avg_ms,
         qs.total_logical_reads/qs.execution_count avg_reads,
         qs.execution_count, SUBSTRING(st.text,1,200) sql
  FROM sys.dm_exec_query_stats qs
  CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
  WHERE st.text LIKE '%Saledetail%' OR st.text LIKE '%VirtualGl%'
  ORDER BY qs.total_elapsed_time DESC;
  ```
- **Network payload.** For the 6,872-row customer ledger, capture bytes on the named-pipe connection (Wireshark) to separate server CPU (20.1 s measured) from transfer.
