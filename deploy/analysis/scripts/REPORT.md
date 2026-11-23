# Client PowerScript — code-level findings

## Executive verdict

- The client is **round-trip-bound and copy-paste-bound**, not CPU-bound. 294 loops contain SQL; 323 of 449 calls to stock/avg-price wrapper procedures are inside loops. A 50-line sale or purchase save issues roughly **300–600 SQL/proc round trips**.
- Three multipliers: **180 windows** open a second `u_transaction` connection on top of `sqlca`; **3,337 of 7,450 SQL statements are COMMIT/ROLLBACK**; and the same item/customer/date lookups are copy-pasted across 20–55 windows.
- UI traps still cost seconds: `SetRedraw(false)` never restored in `w_sale.wf_refreshddw`; a modal expiry prompt per batch on save; 1-second `Sleep()` in galleries; 12 `Modify()` calls per column with no redraw suppression in two view windows.
- Bloat is measurable: **276.9 MB (43.5%)** of the 637 MB PBD set is report/print code; **150 MB** is five alphabetical shards of per-client report layouts; **60.6 MB** is hospital/student/hotel/CRS modules. Roughly 200–250 MB (29–36% of the install) is never exercised by FazalDin PP19.
- Correction: `w_newpreferences` (80 KB, 1,799 lines) is **not** live. `m_preferences.clicked` opens `w_preferences` (158 KB, 3,589 lines); `w_newpreferences` and `w_oldpreferences` have zero external references.

## Evidence base

- Read-only scanner over `recovered/scripts/**/*.pbs`: **2,780 files, 568,818 lines, 21.3 MB**. Method: indentation-aware loop spans plus normalised SQL hashes; output `deploy/analysis/scripts/out/scan.json`.
- **7,450 SQL statements**: 2,682 SELECT, 349 UPDATE, 138 DELETE, 107 INSERT, 1,037 COMMIT, 2,300 ROLLBACK, 121 EXECUTE. **464 inside loops** (170 SELECT, 57 INSERT, 41 UPDATE, 32 COMMIT, 93 ROLLBACK). **4,349 loops**, 294 with SQL, 73 with `Retrieve()`, 328 with a `MessageBox`, 1,167 with `RowCount()` in the header.
- Client primitives: 5,157 `SetTransObject`, 8,848 `MessageBox`, 1,300 `Find`, 753 `Modify`, 606 `Describe`, 359 `SetFilter`, 108 `autocommit=true`, **250 `create u_transaction`**.
- DB cardinalities (read-only): `Item` 28,966; `SaleLedger` 588,865; `Rights` 463; `Preferences` 1 row; `Customer` 2; `Patient` 0.
- Inspected in full: `w_sale`, `w_purchase`, `w_postsale`, `w_salereturnbuffer`, `w_transfer`, `w_purchaseorder`, `w_preferences`, `w_newpreferences`, `w_main`, `w_startup`, `w_login1`, `w_autorecovery`, `w_dbbackup1`, `f_stringpreferences`, `f_getgroupcode`, `f_refreshitemlist`, `f_generateitemlog`, `u_transaction`, `u_session`, `u_sessioninfo`, `u_ds_standard`, `u_dwstandard`.
- Caveat: the recovered tree was regenerated at 02:12 during this analysis; line numbers are current at that scan. Decompiler artefacts (`type_XXXX`, missing SQL bodies, `goto`) make a few lines approximate.

## Findings — Top 20 hotspots

| ID | Hotspot (file:line) | Evidence / snippet | Why it costs time | Fix | Gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| H1 | `salewin/w_sale.pbs:907-936` | `for ll_count = 1 to id_detail.rowcount()` → `getitemstocktotal` (910), nested `for … ids_invoiceinfo.rowcount()` (917), `SELECT item…` (925) | Opening an existing invoice does N stock procs + N×M comparisons + N item SELECTs. 200 lines ⇒ ~200 procs + up to 40k inner iterations | Fetch stock/prices with the detail retrieve; delete the inner loop | 10–40× open | M | Medium |
| H2 | `salewin/w_sale.pbs:3647-3949` | per line: `getitemavgpriceforsale` (3714), `getitemtotalpiecesinhand` (3716), `getitemstockall` (3728), `wf_selectitembatches` (3730); per batch: pricing (3829), stock update/delete (3841/3847) | ~5 round trips/line + 3/batch. 50 lines × 2 batches ⇒ ~450 RT; a datastore is created/destroyed per line (6264/6351) | One `PostSale @invoice` set-based proc; hoist the datastore | 100–200× fewer RT; 5–20× | L | High |
| H3 | `salewin/w_sale.pbs:3814,3818` | `SELECT saleexpirydays…` then `messagebox("Current item will expire…")` inside the per-batch loop | Modal dialog per expiring batch on Save. `SaleCheckExpiry=N` here, so a **config cliff**, not current cost | One aggregated warning per invoice; precompute expiry days | 1–3 s/invoice when enabled | S | Low |
| H4 | `purchasecomponents/w_purchase.pbs:4185-4554` | 3 retrieves/invoice (4188-4190); `wf_setpurorderqty` (4315), sale/retail price updates (4319/4326), supplier info (4332); item SELECTs (4371/4452) | ~4–6 RT/line on this config; 100 lines ⇒ 400–600 RT | One `PostPurchase @invoice` proc | 50–150× fewer RT; 10–30× | L | High |
| H5 | `purchasecomponents/w_purchase.pbs:4300,4704-4717` | `wf_check_right_exists` = `f_getgroupcode` SQL (4707) + `COUNT GroupRights` (4708), called per line | 2 extra SQL per line when margin enforcement is on | Rights bitmap per session; fold margin into detail query | 3× fewer statements | S–M | Low |
| H6 | `salereturncomponents/w_salereturnbuffer.pbs:1960-2156` | per line: 6 procs (2026, 2034, 2054, 2057, 2072, 2077); commits at 2108 and 2116; 8 `Modify(UpdateTable)` + 2 retrieves/invoice (1967-1998) | 6 procs/line; 2 commits/invoice (fiscalization=Y), 5 with all monitors | Set-based `PostSaleReturn`; one commit; design-time UpdateTable | 100× fewer RT; 5–15× | L | High |
| H7 | `transfer/w_transfer.pbs:2630-2780` | per line: 2 `getitemstocktotal` (2674/2675), `getitemavgprice` (2682), item SELECT (2683); per batch: 2 procs (2716/2724); `commit using sqlca` (2746) **and** `it_transobject` (2762); O(n²) scan (2632-2637) | ~4 RT/line + 2–3/batch; two commits on two transactions; O(invoices × unposted rows) | Set-based post; one commit; hash the unposted list | 100× fewer RT | L | High |
| H8 | `poscomponents/w_postsale.pbs:1760-1893` | `getitemavgpriceforsale` (1788), `getitemstockall` (1790), `saleupdateitemstockbatch` (1832); `commit using sqlca` (1903) while stock is on `it_transobject` | 2 procs/line + 1 stock update/batch; transaction split; extra log flush | One `PostPOS` proc; one commit | 20–50× fewer RT; 2–5× checkout | L | High |
| H9 | `pocomponents/w_purchaseorder.pbs:3633-3704` | `wf_update_itemalert` (3668) → unconditional `UPDATE item` (3076); min/reorder/optimum (3677/3686/3695); 3 preference lookups/line | 1–4 UPDATEs/line + 3 Finds. A 500-line PO ⇒ 500–2,000 UPDATEs | Set-based `UPDATE … FROM`, only when changed; load prefs once | 100–500× fewer statements | M | Medium |
| H10 | `functions/f_stringpreferences.pbs:8`, `functions/f_getgroupcode.pbs:5,10` | `gds_preferences.find(" lower(name)=…")`; `SELECT MIN(GroupCode) FROM UserGroups` | 5,480 preference calls (4,694 string), 195 in loops; group code is a SQL round trip ×217 | Hash map loaded once; cache group code; invalidate on save | 50–300 ms/posting; 1 RT/right check | S | Low |
| H11 | `components/w_multi_entry.pbs:378-398,665` (6 copies) | full `gd_itemsinfo.retrieve()` + `SetFilter`/`Filter` + 26 `Find("Lower(itemname)>=…")`; `as_icode = as_icode + …` | Every filter re-fetches **28,966 rows**, scans them, then scans 26 more times for A–Z; O(n²) string build | Pass filters to the retrieve; one-pass bucket map; array join | 3–10× faster search; 100–500→20–60 ms | M | Medium |
| H12 | `functions/f_refreshitemlist.pbs:10-29`; `abuzarapp/w_main.pbs:216` | reset/filter/retrieve `gd_itemsinfo` + `gd_popup_itemsinfo` + optional alias cache; 26 Finds; `f_getgroupcode` 2–4× | Timer/manual refresh freezes UI while re-fetching ~29k items. Auto-refresh is `N` here, so latent | Background/on-demand refresh; reuse buckets; cache group code | 1–5 s freeze → <100 ms | M | Medium |
| H13 | `preferences/w_preferences.pbs:512-626,1047-1391,630` | **44 retrieves** on open (35 preference DWs + hidden + 4 schedule); **37 updates** on save; second MSDB connection | 44 round trips for one wide row; 37 UPDATEs to the same row, one commit; MSDB reopened | One wide retrieve + one update proc; lazy tabs; reuse MSDB | 10–30× open/save | M | Medium |
| H14 | `abuzarapp/w_main.pbs:186,191,198,104,79` | `d_security` retrieved twice live (third at 50 is dead); `setfilter("restricted='N'")` + `filter()` on 29k (198-199); `ds_groups` never destroyed (104); `wf_findindex` re-parses per level | Login filters the whole item cache and rebuilds the menu with repeated substring parsing; leaks a datastore | One security retrieve; pass `restricted` to retrieve; destroy `ds_groups`; parse once | 200–800 ms login | S–M | Low |
| H15 | `abuzarapp/w_startup.pbs:52-53,70`; `functions/f_getbackupinfo.pbs:102,104` | new `u_transaction` + `autocommit=true`, then `RESTORE HEADERONLY` ×3 | Extra connection + 3 file-header reads before the splash; stale/UNC devices block | Reuse `sqlca`; lazy backup info; validate device paths | 0.3–3 s startup `[hypothesis]` | S | Low |
| H16 | `abuzarapp/w_login1.pbs:198-206,106` | datastore created and looped with **no `retrieve()`** (201), so `gs_company` never set; server field connects to `master`, retrieves DB list, disconnects | Dead loop hides broken report-server detection; every server commit is a connect/disconnect | Remove dead loop; cache DB list; connect once | Correctness + 1 handshake | S | Low |
| H17 | `templates/u_stockledger.pbs:134-159` | per item: `updateitemstockledger` (141) and up to 4 progress retrieves; unconditional `return` (159) | Intended loop would be 28,966 procs + ~116k retrieves; early return silently does **one item** and reports success | Set-based proc; progress every N items; remove return | 100×+ if enabled | M | Medium |
| H18 | `functions/f_generateitemlog.pbs:27,43,59,75,90,106` | `INSERT itemlog SELECT …, i.* FROM item i WHERE i.icode=:ll_code` + correlated `SUM(GodownDetail)` | Copies every Item column into ItemLog per row; 14 looped variants; Item ~4 KB/row | Insert needed columns only; compute stock once; set-based insert | 3–10× log generation | M | Medium |
| H19 | `components/u_ds_standard.pbs:39,54` | `openwithparm(w_dberror,…)` on every DW error; `SQL rollback using sqlca` | A bad row opens a modal dialog and rolls back the **global** transaction, not the DW's | Collect errors; roll back owning transaction; one summary dialog | Removes modal stalls | S–M | Medium |
| H20 | `issuecomponents/w_view_issueheader.pbs:170-204`, `saleorder/w_view_saleorderheader.pbs:185-219`, `salewin/w_sale.pbs:15585-15592` | 12 `modify("<col>.X/Y/Visible")` per column, no `SetRedraw`; `idc_guest/idc_student.setredraw(false)` never restored | Each `Modify` relayouts; a 30-column view does 360+ relayouts. Redraw leak freezes two dropdowns | One concatenated `Modify`; wrap in `SetRedraw(false/true)`; fix false→true | 100–300 ms/view; UI correctness | S | Low |

Other: `w_dbbackup1.pbs:83-99` runs `BACKUP DATABASE` synchronously; `w_autorecovery.pbs:107,147` drops/creates `sp_execute_temp` and runs `RESTORE HEADERONLY`; `w_activation.pbs:253` busy-waits 5,000,000 iterations; `accountsrespwin/w_gldocument_gallery.pbs:235` sleeps 1,000 ms; `m_mainmenu.pbs` creates 719 menu objects/10,779 property writes at startup; `u_session`/`u_sessioninfo` duplicate session tracking; `n_cst_sst.pbs:38-102` is O(n²) blob building during XLS export.

## Repeated-work map

| Work repeated | Where / how often | Fix |
|---|---|---|
| `d_security` for A and W rights | `w_main.pbs:186` and `:191`; 463 rows; third at `:50` is dead | One retrieve with both flags, or one datastore + filter; build a right→bool map |
| Full item list re-retrieved/re-filtered | `w_multi_entry.pbs` six blocks (378/475/526/565/610/670); `f_refreshitemlist.pbs:14-16`; 22 retrieve sites; 28,966 rows | Retrieve with category/alias/ICode predicate; cache; one-pass A–Z buckets |
| Preference lookups | 5,480 `f_*preferences` calls (4,694 string), 195 in loops; 3/PO line | Hash map loaded once; invalidate on save |
| Group code | 217 `f_getgroupcode` calls; 2 inside `wf_check_right_exists` | Cache per user; rights bitmap |
| 35 preference DWs for one row | `w_preferences.pbs:512-726` (44 retrieves), `1047-1391` (37 updates) | One wide retrieve + one update proc; lazy tabs |
| `d_groups_discount` per window | 16 windows retrieve it on open (`w_sale`, `w_postsale`, `w_quotation`, returns…) | Global cached datastore, invalidated on group save |
| Server date / max sale date | 44 `SELECT LastTransDate FROM ServerDate`; 36 `SELECT MAX(Date) FROM SaleLedger` | Cache server date; reuse existing `gd_recenttransdate` |
| `d_interfacesettingcols` | 27 window opens | Global cached datastore |
| Copy-pasted item/customer/supplier lookups | Same SQL 55×, 47×, 27×, 20× across windows | Central functions/repository |
| Session tracking | `u_session` (`sysconns`) + `u_sessioninfo` (`sysisolaation`), each its own connection/temp table | One tracker; both tables exist in `tempdb` |
| MSDB job reads | `w_preferences.pbs:630`, `w_newpreferences.pbs`, control panels | One cached job-status read; reuse connection |
| Barcode layout | 264 `f_printbarcode_*`, one selected by `gs_company` in `w_barcodelabels` | One parameterised renderer |

## Dead-code / bloat inventory

| Item | Size / lines | Evidence | Estimated dead / rarely used | Safe-removal note |
|---|---|---|---|---|
| `barcodefunctions` client forks | 265 files, 1.7 MB scripts, 3.3 MB PBD | 264 `f_printbarcode_*`; `w_barcodelabels` selects one by `gs_company` | **99.6%** (263/264) unused per install | Low risk object-level in IDE; keep the dispatcher branch |
| `sprnt*` report shards | **150.0 MB**, 2,273 DWs, 143 MB SRD | `sprntatod` A–D, `sprntetok` E–K, `sprntlton` L–N, `sprntotos` O–S, `sprntttoz` T–Z; per-client layouts | 60–90% (**90–135 MB**) not instantiated for FazalDin | **High risk**: shards contain used generic layouts; prune object-level with runtime usage, not whole PBDs |
| All report/print libraries | **276.9 MB = 43.5%** of 637 MB PBD | 35 PBDs matching report/print/sprnt | 40–60% (**110–165 MB**) | Medium–high; needs report usage log + regression |
| Vertical modules | **60.6 MB** | patient 38.6, student 15.1, guest 4.6, CRS 2.3; `Patient` has 0 rows | ~90% (**55 MB**) | Medium; confirm menus/rights |
| `w_newpreferences` + `w_oldpreferences` | 84 KB, 1,936 lines | Zero external refs; `m_preferences.clicked` opens `w_preferences` | 100% dead | Low; IDE removal |
| `_old`/`_copy`/`_modified` variants | 52 files, 644 KB | `w_transfer_old` 142 KB, `w_sale_modified` 133 KB, `w_purpayment_old`, `w_emp_attendance_old` | Most superseded | Low–medium; verify `w_sale_modified` |
| Windows with no static reference | ~700, 9.0 MB scripts, 240k lines | Token analysis; **upper bound** — menu items decompile as `type_XXXX` | Unknown; not proof of death | Do not act on this alone |
| Function files with no external reference | 58 files, 113 KB | Five `f_towords_*`, four `f_save_from_ds_to_*`, `f_printbarcode_potpourri_old` | Candidates only; app `open` event missing | Low–medium; full call graph/IDE |

**Bottom line:** 200–250 MB (29–36%) of the 701 MB install is report variants, per-client layouts, or vertical modules not exercised here.

## Safe refactor order

1. **DB-only now.** Make the per-row stock/avg procedures cheap and indexed; reduce lock duration; fix `VirtualGl`/`SaleLedger` plans. This lowers cost per call but **cannot remove 300–600 round trips**. Establish a baseline: round trips and duration per invoice.
2. **Config/operations, reversible.** Disable optional per-row work where business agrees (`SaleCheckExpiry`, `SaveBalanceOnSalePosting`, PO qty updates, activity monitors); point backup devices at local paths; stop the startup header scan; disable item auto-refresh until backgrounded.
3. **PowerBuilder source/PBL required.** Reconstruct the seven posting windows (`w_sale`, `w_purchase`, `w_receipt`, `w_salereturnbuffer`, `w_transfer`, `w_issue`, `w_adjustment`) and replace per-line loops with one `Post*` proc each. Fix `SetRedraw` leaks, remove loop MessageBoxes, lazy-load preferences, cache preferences/group/rights, collapse 44 retrieves to 1. L–XL per window; needs PB 12.5 IDE + regression DB.
4. **Rust/Tauri rebuild.** Port hot screens first: POS checkout, sale save, item search, purchase post, startup. One pool, one round trip per command, set-based SQL, async UI, no modal dialogs in loops. Do **not** port the loop structure.
5. **Report/barcode consolidation (last).** One parameterised report renderer and one barcode renderer replace 2,273 layouts and 264 functions. Largest size win, lowest runtime urgency.

## What NOT to do

- **Do not 1:1 port the PowerScript.** A Rust UI over the same per-line proc calls will still feel slow.
- **Do not delete PBDs from static dead lists.** Menu windows open via decompiler-typed variables; `sprnt*` shards mix used and unused layouts.
- **Do not add client-side filtering/sorting** on the 29k-row item cache. Push predicates into the retrieve.
- **Do not put `MessageBox` or `Sleep` in row loops.** Aggregate errors; use non-blocking progress.
- **Do not create a transaction object per window.** Use `sqlca` or a pool; commit on the connection that did the work.
- **Do not run `BACKUP`/`RESTORE HEADERONLY` synchronously** on the UI thread.

## Measurements still needed

1. **Session count:** `SELECT session_id, host_process_id, login_time FROM sys.dm_exec_sessions WHERE is_user_process=1;` before/after 1, 3, 5 windows. `+1/window` confirms the second connection.
2. **Round trips/invoice:** Profiler trace (or `sys.dm_exec_query_stats` delta) around one sale save at 10/50/100 lines; count `RPC:Completed` + `SQL:BatchCompleted`.
3. **Startup:** instrument `w_startup.open`, `f_getbackupinfo`, `w_login1.cb_ok.clicked`; `SET STATISTICS TIME` on the 3 `RESTORE HEADERONLY` calls.
4. **Per-proc cost:** `SET STATISTICS TIME` on `getitemstocktotal`, `getitemavgpriceforsale`, `saleupdateitemstockbatch`, `updateitemstockbatch`; multiply by calls/invoice.
5. **Item filter:** time `wf_refreshitemslist_catwise`/`_drilldown` with `cpu()`; expect 100–500 ms/action at 28,966 rows.
6. **WAN sensitivity:** repeat one sale save at 20 ms and 50 ms latency; round-trip-bound code scales linearly, sizing the rebuild benefit.
