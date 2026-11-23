# UI / MDI / rendering / perceived performance — findings

## Executive verdict

- **The client is not slow because it draws too many controls; it is slow because every screen does synchronous work before it paints.** Median window has 5 controls (max 207), but 443 windows run DataWindow retrieves inside `open()`, 1,090 open another window (mostly modal) from `open()`, and 55 re-walk the entire menu security model on every sheet open.
- **The two worst per-transaction stalls are not database plans: they are a fiscalization socket to port 9111 (nothing is listening) and a 1,308-row linear preference scan repeated 4,694 times in code.** Both are invisible in DB traces.
- **Startup is a serial chain of 4–6 separate physical SQL connections, 3 first-time DDL/DML checks, a 588k-row SaleLedger aggregate, 3 `RESTORE HEADERONLY` calls and a menu security walk — before the main window paints.** No connection pooling anywhere (`SetTransPool` is never called; 250 `create u_transaction`, 264 `SQL start`).
- **The "splash delay" is real but not a `Sleep`.** There is no artificial sleep in the startup path. The splash covers a long serial startup; it is also the only thing on screen while 3 backup devices are opened with `RESTORE HEADERONLY` and two security DataStores are retrieved.
- **Perceived performance is partly recoverable without the original source.** Preference flips (backup health, fiscalization, logo) remove the startup dialog and up to two per-sale dialogs, plus several seconds. The rest — print-preview default, eager tab loads, the item-list reload, the 199 SetRedraw leaks, the 162 forced maximize-on-activate handlers — needs source or the rebuild.

## Evidence base

- **2,062 windows / 10,597 controls** from `recovered/objects/**/window/*.json`: average 5.1 controls, max 207 (`w_job_schedule`), max nesting depth 3. 346 windows have zero controls; only 3 have >100. **1,643 (80%) are response/modal windows**; 839 are `w_arg_*` parameter dialogs and 213 are `w_selectformat_*` — 51% of the entire UI is report parameter pickers. 1,322 controls (12.5%) are `visible=false`.
- **8,748 DataWindows / 327.7 MB of SRD** (`recovered/datawindows`): average 38.4 KB, 771 >97 KB, 7 >195 KB, largest 328.5 KB. 1,609 DataWindow controls (842 `u_dwstandard` + 767 `datawindow`). 5,845 DWs contain computed fields; 2,043 have group bands; **2,802 carry a client-side `sort=` clause**; 111 a `filter=`; 168 nested reports; 70 graphs; 975 bitmap objects; 1,593 use `UNION` in SQL. 1,942 declare grid presentation (`grid.lines`, 1,891 with lines off); 6,806 do not. 102 have a detail band taller than 3,000 PB units.
- **1,883 recovered `open()` handlers**: 443 call `.retrieve()`, 12 call 5+, 6 call 10+; 1,090 call `open()`/`openwithparm()`; 666 contain a `MessageBox`; only 204 (11%) use `SetRedraw` at all. `w_preferences` does 45 retrieves + 12 SQL SELECT in `open()`; `w_newpreferences` 34 + 12.
- **Script-wide**: 8,779 `MessageBox` calls (558 lexically inside loops; `w_sale` 359, `w_postsale` 151, `w_purchase` 138); 4,694 `f_stringpreferences` calls (352 in `w_sale`); 218 `f_getgroupcode` calls (each is a SQL round trip); 250 `create u_transaction` and 264 `SQL start`; 55 `mf_initsecurityapp` call sites; 2 `Yield()`; 730 `SetPointer(HourGlass!)`; 80 `hprogressbar` controls (72 hidden), used only in 16 batch/backup/transfer/repair windows — **no item-entry, sale, or report path uses one**.
- **Runtime observation of the live process (PID 8796):** 144 MB working set, 440 handles, 151 HWNDs for one open sheet (111 `pbdw125` DataWindow HWNDs, 24 `pbdwlb125` drop-down listboxes, 12 `ComboLBox`, 1 frame `FNWND3125`). Idle CPU **0.000 s over 12.1 s** — there is no runaway polling in the current state. Process is **not DPI-aware** (`GetProcessDpiAwareness` = 0) at 96 DPI. Only one top-level `FNWND3125` exists, i.e. `w_bkg` is **not** instantiated in this session.
- **DB facts used for sizing** (read-only): `Rights` 463 rows (313 A / 150 W); admin `GroupRights` = 463; `Item` 28,966 rows / 134 columns / ~3.9 KB per row; `Customer` 2; `Patient` 0; `SoftwarePreferences` 1,308 rows; `CheckManualBackupHealthAtStartUp=Y`; `AutoFiscalizeOnPosting=Y`; `FiscalizationMethod=2`; `FiscalizationAppPort=9111`; `LogoSelected=0`; `AutoRefreshItemList=N`, `AutoRefreshItemListTime=0`; `refreshtime=1`.
- **Gap:** the application object's `open` event (the exact startup order and splash duration) was not decompiled into readable text; it exists only in `abuzarapp.pbd` p-code. `d_itemsinfo` is referenced 196 times but its SRD was not exported. Findings that depend on these are marked `[hypothesis]`.

## Findings

| ID | Finding | Evidence (file:line / SQL result) | Why it costs time | Fix | Expected gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| F1 | Fiscalization runs on every posted invoice against a dead socket | `functions/f_fiscalizesaleinvoice.pbs:52-67`; `f_get_googleqrcode_for_fiscalinvno.pbs:35-47`; prefs Y/2/9111; no listener on 9111 | Winsock connect + send + blocking `of_recv` on the UI thread; failure raises a modal `MessageBox`; when `PrintUnFiscalizedInvoice=N` the receipt is silently suppressed (`w_sale.pbs:15446-15460`) | Set `AutoFiscalizeOnPosting=N` until the service runs, or start FiscalizationApp on 9111; move fiscalization to a background queue in the rebuild | Removes 1–2 dialogs and ~0.2–20 s per sale (0.2 s local refuse, up to TCP timeout if host unreachable) | S | Low config / Medium if fiscalization is legally required |
| F2 | Startup opens 3 backup devices with `RESTORE HEADERONLY` | `functions/f_getbackupinfo.pbs:102-108`; called from `w_startup.pbs:71` and `w_backupinfo.pbs:32`; pref `CheckManualBackupHealthAtStartUp=Y` (consumed by `af_check_manualbackuphealth`, present in the app-open fnrefs; exact call path not decompiled) | Opens each `.DBDump` file and reads headers synchronously before login; then shows a "Backup Information" modal when none exists (`w_backupinfo.pbs:34-39`) | Set pref `N`; in rebuild show backup age in the status bar, refresh on demand | 0.3–3 s per login + one dialog click | S | Low |
| F3 | Login/startup makes 4–6 separate physical connections; no pooling | `f_get_database_status.pbs:25-28` (connect→SP→disconnect), `w_startup.pbs:52-54`, `w_logo.pbs:30-31`, `w_backupinfo.pbs:15-17`, `w_login1.pbs:215`; 250 `create u_transaction`, 264 `SQL start`; no `SetTransPool` anywhere | Each is a full OLE DB login + named-pipe handshake; repeated again for every window that creates its own connector | `SetTransPool(3,12,60)` at app start; reuse `sqlca`; one connector per session | 0.2–1.5 s startup; 20–200 ms per affected screen | S–M | Low/Medium (pool sizing) |
| F4 | `w_main.open` does SQL + 2 security retrieves + menu walk before painting | `abuzarapp/w_main.pbs:175,185,190,197-202` | 1 SELECT, 2×`d_security` (313/150 rows), `gd_itemsinfo.filter()`, `mf_initsecurityapp`, then `d_groups` retrieve — all serial | Cache user/group/security/prefs at login; pass into `w_main`; no DB in frame `open` | 0.3–1.0 s login→main | M | Low |
| F5 | Every sheet rebuilds a full menu (ancestor `m_entry`, 156 menu objects) and re-walks all 313 rights | `components/m_mainmenu.pbs:34-96`; callers `w_multi_entry.pbs:846`, `w_reviewreport.pbs:877`, 52 others; `m_multi_entry`/`m_salemenu` ancestor = `m_entry` | ~3,490 `mf_findindex` string parses + 626 menu property writes (2 per right) per sheet; property writes may invalidate the toolbar | Compute menu enabled/visible once per user/group at login; apply a cached bitset; do not re-walk per sheet | 0.05–0.4 s per sheet open | M | Low |
| F6 | `f_stringpreferences` is O(1,308) per call, called 4,694 times | `functions/f_stringpreferences.pbs:8` (`gds_preferences.find(" lower(name) = '…'")`); `SoftwarePreferences` 1,308 rows; 352 calls in `w_sale.pbs` | Every lookup linearly evaluates `lower(name)` over 1,308 rows; repeated in item loops and keystroke handlers | One-time load into a PB map / hash; or a case-sensitive keyed find; rebuild: dictionary | 20–300 ms per screen; keystroke lag on POS | M | Low |
| F7 | `f_getgroupcode` is a SQL round trip on every call (218 sites) | `functions/f_getgroupcode.pbs:10` | Synchronous `SELECT MIN(GroupCode)` per call; `w_multi_entry` calls it 14× in one open | Cache `gl_groupcode` at login; invalidate on user change | 10–100 ms per screen on LAN; much worse on WAN | S | Low |
| F8 | Reports are always rendered in **print preview**, then rulers are toggled | `reportviewer/w_reviewreport.pbs:301-304` (`Print.Preview=yes`, Zoom), `359-367` (`wf_showruler` modifies preview again) | Print preview paginates the entire result set; at least two full layout passes per open, all on the UI thread | Default to scrollable grid; preview on demand; don't toggle rulers after retrieve | 2–10× faster report open; large reports 5–20 s → 0.5–3 s | M | Low |
| F9 | Item list is reloaded and client-filtered repeatedly | `functions/f_refreshitemlist.pbs:10-17` (reset/retrieve), `18-26` (security scan), `27-32` (26 `find()` scans), `33-43` (2 more full retrieves); `w_multi_entry.pbs:327-375`; `wf_filter` at `222-248` uses `upper(col)` over 29k rows | 28,966 rows × ~0.5–1 KB per retrieve; 26 linear searches; `Filter()` evaluates an expression per row on every filter/keystroke | Server-side `WHERE`/`ORDER BY` + paged lookup; cache only display columns; debounce filter; rebuild with virtual list | 0.3–2 s per open/filter | L | Medium |
| F10 | 199 `SetRedraw(false)` blocks can return without `SetRedraw(true)` | scanner over 2,780 scripts; concrete `components/w_entry.pbs:501,504-506` (Down at last row: `beep; return` with redraw off) | Grid stays with redraw disabled → screen looks frozen/stale until another event calls `SetRedraw(true)`; 162 `activate` handlers call it defensively | Wrap in try/finally; always re-enable on every exit path | Eliminates the "ghost screen" class of bugs | S–M | Low |
| F11 | 162 `activate` handlers force `windowstate = maximized!` | e.g. `w_reviewreport.pbs:939-941`, `w_single_entry.pbs`, `w_listview_form.pbs`, `w_cashonsales.pbs` | Every focus change re-maximizes → WM_SIZE + full repaint of the sheet and all DataWindows; visible flash on alt-tab | Remove from activate; maximize once in open; keep state | Smoother window switching; fewer full repaints | S | Low |
| F12 | 8,779 MessageBoxes; success confirmations on every save | `w_multi_entry.pbs:965` ("Changes take effect in database", OK-only); `w_sale.pbs` 359 sites; 558 inside loops | Each is a modal window: extra click, extra paint, blocks background work, breaks cashier rhythm | Non-modal status/toast; one summary dialog per batch, not per row | 0.5–2 s + 1–2 clicks per transaction | M | Low |
| F13 | No progress indication and no cooperative yield in transaction/report paths | only 2 `Yield()` (in `dw2xls`); 730 hourglass; 80 `hprogressbar` controls exist but only 16 batch/backup/transfer/repair windows use them — none in item entry, sale or reports | Long `retrieve`, `virtualgl`, posting and report formatting freeze the single PB thread; hourglass often never paints because the pump is blocked | Busy window with animated indicator, `Yield()` in row loops, cancellable phases; rebuild: async jobs | Perceived freeze → visible progress | M | Medium (re-entrancy) |
| F14 | Preferences windows load every tab eagerly | `abuzarapp/w_newpreferences.pbs:124-533` (34 retrieves, 24 DWs/443 KB, 409-line open); `preferences/w_preferences.pbs` (45 retrieves, 44 DWs/365 KB, `dbms_version` at 502) | Opens 20+ tab pages and retrieves each, though the user edits one page | Retrieve on `selectionchanged`, cache dirty pages, reuse the `w_dashboards.pbs:selectionchanged` pattern | 1–3 s per preferences open | M | Low |
| F15 | 51% of windows are report argument/format dialogs, chained modally | 839 `w_arg_*`, 213 `w_selectformat_*`; 1,090 windows open a dialog in `open()`; 1,643 response windows | A report is 3 window creations + focus changes + paints before data; each modal blocks its parent | Merge arg+format into one dialog; remember last args; rebuild as inline side panel | 2–4 fewer windows per report | L | Medium |
| F16 | Freeform "god forms" render hundreds of fields per row | `d_item_detail.srd` 122 columns, 121 distinct Y, detail band 11,136; `d_itemregrequest_detail` 119 cols/10,458; 102 DWs >3,000 detail | Freeform DW paints each object individually; tall forms scroll-repaint everything; 122 columns retrieved even when 5 are edited | Split into tabs; retrieve only visible columns; rebuild with virtualized views | 2–5× item edit | XL | Medium |
| F17 | Client-side sort/filter is the default | 2,802 SRDs carry `sort=`; runtime 357 `SetFilter`, 314 `Filter`, 151 `Sort`, 59 `GroupCalc` | Sorting/filtering happens after all rows arrive and is re-done on every change; blocks the UI thread | Move `ORDER BY`/predicates to SQL; index for them; paginate | 2–20× on large lists | L | Medium |
| F18 | No connection pooling + 32-bit, non-LARGE_ADDRESS_AWARE process | PE characteristics 0x010f (bit 0x20 clear); 144 MB WS with one sheet; 111 DataWindow HWNDs per sheet | 2 GB address-space ceiling; many open sheets + 12 DWs each risks OOM/paging; new connections per window add latency | `SetTransPool`; `editbin /LARGEADDRESSAWARE` on a signed-off copy; limit open sheets | Stability with 10+ sheets | S (patch) | Medium |
| F19 | The "background" window is a separate top-level window moved on every MDI resize | `w_main.pbs:16-33` (resize `w_bkg` + `p_1`, then `setfocus()`), `w_bkg.pbs:26-35`; `yourlogo.bmp` **missing** from `deploy/Application` | If enabled, resizing moves/repaints a second top-level window and steals focus on each WM_SIZE; `SetFocus` per resize tick causes activation churn | Keep background inside `mdi_1` (BackColor only); never `SetFocus` in resize; remove the missing bitmap path | Smooth resize, no flicker | S | Low |
| F20 | Splash/`w_logo` opens its own DB connection to read a bitmap preference | `abuzarapp/w_logo.pbs:30-38` | A full login handshake before the main window, just to choose `logo_1.bmp` vs `Logo.bmp` | Read `LogoSelected` from cached preferences; no DB in the splash | 50–250 ms startup | S | Low |

## Top 25 UI hotspots (ranked by perceived gain × frequency)

| # | Window / control | Evidence | Cost | Fix | Expected perceived gain | Effort |
|---|---|---|---|---|---|---|
| 1 | `f_fiscalizesaleinvoice` / `f_get_googleqrcode…` on every post | `f_fiscalizesaleinvoice.pbs:52-67`; port 9111 closed; prefs Y/2 | 0.2–20 s + 1–2 dialogs + no receipt | Disable pref or run the service | Instant relief on every sale | S |
| 2 | `w_backupinfo` + 3×`RESTORE HEADERONLY` at startup | `f_getbackupinfo.pbs:102-108`; pref `CheckManualBackupHealthAtStartUp=Y` | 0.3–3 s + modal click per login | Pref `N` | 0.3–3 s login | S |
| 3 | `w_reviewreport` print preview + ruler toggle | `w_reviewreport.pbs:301-304,359-367` | 2+ full paginations per report | Grid default; preview on demand | 2–10× report open | M |
| 4 | `f_refreshitemlist` / item-list filter | `f_refreshitemlist.pbs:10-43`; `w_multi_entry.pbs:222-248`; 28,966 items | 0.3–2 s per item screen/filter | Server-side paged search | Biggest POS/search win | L |
| 5 | `mf_initsecurityapp` on every sheet | `m_mainmenu.pbs:34-96`; 55 call sites; 3,490 findindex + 626 writes | 50–400 ms per sheet | Cache menu state per user | Every screen ~0.1–0.4 s faster | M |
| 6 | `f_stringpreferences` linear scan | `f_stringpreferences.pbs:8`; 1,308 rows; 4,694 calls | 20–300 ms/screen; keystroke lag | Preload to map | POS typing becomes snappy | M |
| 7 | `w_main.open` security + prefs + menu | `w_main.pbs:175-202` | 0.3–1.0 s login→main | Move to login cache | Login target <2 s | M |
| 8 | `w_sale` first open (12 DWs/486 KB + 4 OLE) | `w_sale.json`; `w_sale.pbs:15574-16514` | 0.3–1.5 s | Lazy panels, defer OLE | First sale of shift | L |
| 9 | `w_postsale` (POS) open | 5 DWs/297 KB; 4 retrieves; 3 OLE; 68 `f_` calls | 0.3–1.2 s | Same | Faster till start | L |
| 10 | `w_newpreferences` 34 retrieves / 24 DWs | `w_newpreferences.pbs:124-533` | 1–3 s | Lazy per tab | Instant prefs | M |
| 11 | `w_preferences` 45 retrieves / 44 DWs | `w_preferences.pbs` open; `dbms_version` 502 | 1–3 s | Lazy per tab | Instant prefs | M |
| 12 | `w_job_schedule` 207 controls + msdb connector + 12 job reads | `preferences/w_job_schedule.pbs` | 2–5 s | Retrieve current tab only; reuse pool | Schedules usable | M |
| 13 | `w_mr_form` 26 DWs / 884 KB metadata | `patientcomponents/w_mr_form.json` | 1–3 s | Lazy sections | Medical record opens fast | L |
| 14 | 162 `activate` → maximize | e.g. `w_reviewreport.pbs:939-941` | Full repaint per focus change | Maximize once | No flash on alt-tab | S |
| 15 | 199 redraw leaks | `w_entry.pbs:501-506` concrete | Stuck unpainted grids | try/finally | No "frozen" screens | S–M |
| 16 | Success MessageBox on save | `w_multi_entry.pbs:965` | 0.5–2 s + click per save | Status bar/toast | Faster checkout | M |
| 17 | `w_dashboard` 60 s timer | `dashboard/w_dashboard.pbs:68-88` | 4 retrieves + 4 graphs per minute | 5–15 min or on demand | No periodic hitch | S |
| 18 | `w_logo` DB connect for logo pref | `w_logo.pbs:30-38` | 50–250 ms | Cached pref | Faster splash handoff | S |
| 19 | `f_getgroupcode` SQL per call | `f_getgroupcode.pbs:10`; 218 sites | 10–100 ms/screen | Cache at login | Snappier screens | S |
| 20 | `w_bkg` + `ue_mdi_move` `setfocus()` | `w_main.pbs:16-33`; `w_bkg.pbs` | Flicker/activation churn on resize | Background = MDI BackColor | Smooth resize | S |
| 21 | 8,779 MessageBoxes / 558 in loops | script scan | Clicks and paint per message | Batch errors | Less interruption | M |
| 22 | 80 progress bars, 16 batch windows only; 2 `Yield()` | script scan | UI freezes during long ops | Busy dialog + Yield | Perceived speed | M |
| 23 | 51% of windows are modal arg/format dialogs | 839 + 213 windows | 3 modals before data | Merge dialogs | Fewer clicks per report | L |
| 24 | DPI-unaware process | `GetProcessDpiAwareness=0`; 5,714 controls at 10 pt Arial | Blurry and stretched at 125/150% | Run at 100% or rebuild DPI-aware | Crispness + less stretch blit | S (ops) |
| 25 | Non-LARGE_ADDRESS_AWARE 32-bit exe | PE `0x010f` | OOM/paging with many sheets | `editbin /LARGEADDRESSAWARE` (copy) | Stability | S |

## Top 10 by ROI (ranked)

1. **Turn off fiscalization-on-post until the service exists** (F1). Zero code, biggest per-sale win.
2. **Turn off startup backup health** (F2). Zero code, every login.
3. **Stop forcing print preview / re-toggling rulers** (F8). 2–10× on every report.
4. **Cache security/menu state once per login instead of per sheet** (F5) — 55 call sites, all screens.
5. **Cache preferences in a map** (F6) — 4,694 call sites, affects typing latency.
6. **Page/search the item list server-side** (F9) — the single largest screen-level cost at this site (28,966 items).
7. **Fix `SetRedraw` leaks and remove activate-maximize** (F10/F11) — cheap, removes the "ghost/stale screen" and flash class of complaints.
8. **Lazy-load preference tabs and report sheets** (F14/F15).
9. **Replace success MessageBoxes with a status bar/toast** (F12).
10. **Pool connections and cache groupcode/logo pref** (F3/F7/F20) — startup and per-screen round trips.

## Startup / screen-open choreography (proposed)

**Current (serial, blocking):** mutex/session → `f_get_database_status` (connect + SP + disconnect) → 3 first-time DDL/DML checks → `f_firsttimelic` SaleLedger aggregate + `CREATE TABLE` check → `w_startup` (new connection, DW retrieve, 3 `RESTORE HEADERONLY`) → `w_login1` (stop/start `sqlca`, user SELECT) → license check → `w_logo` (new connection, LogoSelected) → `w_main` (user SELECT, 2× `d_security`, `gd_itemsinfo.filter`, menu walk, `d_groups`) → optional `w_backupinfo` modal. No step is parallel because PowerBuilder is single-threaded.

**Proposed:**
1. **0–150 ms:** show the splash from a local 8-bit bitmap immediately. No DB, no file scan, no license.
2. **Splash phase (bounded 1.5 s):** one pooled connection; session/mutex; license; read `LogoSelected`, security A/W, group and preferences in **one** round trip (batch or a single stored proc). Skip DDL checks when a `SchemaVersion` row matches. Never call `RESTORE HEADERONLY` here.
3. **Login:** reuse the same connection; one query returns user, password hash, groupcode and rights version. Cache `gl_usercode`, `gl_groupcode`, security, prefs, menu state.
4. **Main frame:** build the menu once from the cached state, paint, `PostEvent` a low-priority warm-up. No SQL in `w_main.open`.
5. **After main is visible (idle):** prefetch the item list (display columns only), the godown list and dashboard tab 1; warm the three most-used sheets' DataWindow definitions. Do not block input.
6. **Per screen:** `open` paints the shell + skeleton; `ue_postopen` loads data; every tab retrieves on first activation; attachments/images/notes/audit load on demand; reports start in grid mode and switch to preview on request.
7. **Cache:** security (A/W), preferences dict, groupcode, item list, customer/supplier/godown lists, menu bitset. Invalidate on change or TTL; never re-walk security per sheet.
8. **Precompute at login:** menu enabled/visible bitset per group; item letter index in SQL; report argument defaults per user.

## No-source quick wins vs. needs-rebuild

**Do now, without source (config/ops):**
- `CheckManualBackupHealthAtStartUp = N` — removes a modal + 3 `RESTORE HEADERONLY` + one connection per login.
- `AutoFiscalizeOnPosting = N` until the fiscalization service listens on 9111; then start the service. Restores receipt printing and removes 2 dialogs per sale.
- Keep `AutoRefreshItemList = N` and `AutoRefreshItemListTime = 0`. **Never set a positive time**: `w_main.wf_settimer` would reload the 28,966-item list every N minutes and freeze the till (`w_main.pbs:99-114`, `f_refreshitemlist.pbs:10-43`).
- `LogoSelected = 0` (already set) and shrink `Logo.bmp` (400×188×24-bit, 225 KB) to 8-bit; `logo_1.bmp` (600×400, 703 KB) is then unused.
- Provide a small `yourlogo.bmp` (or a 1×1 blank) — `w_bkg.p_1.picturename` points at a file that does not exist in `deploy/Application`.
- Windows tuning on POS terminals: disable "Animate windows when minimizing and maximizing", menu fade and window shadows; set the app compatibility flag `DISABLETHEMES` for `abuzar.exe`; run at 100% display scaling.
- Add antivirus exclusions for `deploy/Application` (701 MB of PBDs) and the SQL data/log files; keep the app on local SSD, never a network share; High Performance power plan.
- Start maximized at a fixed size; avoid drag-resizing (`ue_mdi_move` + `setfocus`); keep the number of open MDI sheets low.
- Binary patch (needs sign-off): `editbin /LARGEADDRESSAWARE` on a **copy** of `abuzar.exe`.
- Do not use RDP/terminal services for POS until the synchronous-round-trip architecture is fixed.

**Needs source or rebuild (cannot be fixed by config):**
- Print-preview default and ruler toggling; force-maximize on activate.
- Menu security walk per sheet; full `m_entry` menu instance per sheet.
- Preference lookup map, `f_getgroupcode` cache, connection pool (`SetTransPool`).
- Lazy tab/sheet loading; deferring OLE/ActiveX and image/attachment panels.
- Item-list paging + server-side search; removal of `upper(col)` client filters.
- Redraw-leak fixes; MessageBox-to-toast conversion; real progress/cancel with `Yield()`.
- Splitting god forms (`d_item_detail` 122 columns, `w_mr_form` 26 DWs).
- DPI-aware layout and virtualized DataWindows.
- Removing the 51% modal arg/format dialog surface.

## Implementation plan (ordered)

1. **Config pass (day 1):** `CheckManualBackupHealthAtStartUp=N`, `AutoFiscalizeOnPosting=N` (or start service), verify `AutoRefreshItemList=N/0`, `LogoSelected=0`, add `yourlogo.bmp`. Validation: time 3 logins and 3 sales; count dialogs (should drop by 2 per login and 2 per sale); confirm receipts print.
2. **Ops pass (day 1):** OS animation/theme flags, AV exclusions, 100% scaling, local SSD, fixed window size. Validation: WPR trace before/after, count repaints on alt-tab.
3. **Source-level safe fixes (week 1):** redraw try/finally, remove activate-maximize, replace success MessageBoxes, pool connections, cache groupcode/prefs. Validation: sheet open p50/p95, idle GDI/handle growth over 50 open/close cycles.
4. **Report path (week 2):** grid-first report viewer, preview on demand, one argument dialog. Validation: time 20 reports of <2k and >20k rows; compare paint-to-first-row.
5. **Item path (weeks 2–4):** server-side paged item lookup, cached display list, debounced filter, lazy item panels. Validation: scan-to-line p95 ≤100 ms; item screen open ≤300 ms.
6. **Rebuild parity:** only then move the same contracts to Rust/Tauri (menu bitset, pref map, paged queries, virtual grid). The targets below become the acceptance tests.

## Perceived-performance targets and how to measure

| Path | Target | Measurement |
|---|---|---|
| Splash visible | <150 ms after launch | ETW `Microsoft-Windows-Win32k` / `WPR` first-window timestamp, or a `WinEventHook` on `EVENT_OBJECT_SHOW` |
| Login → main painted | ≤2.0 s p95 | WinEvent timestamp from login click to `FNWND3125` show; repeat 10× |
| Sheet open (item/entry) | p50 ≤300 ms, p95 ≤800 ms first open; ≤150 ms cached | `WinEventHook` from menu click to sheet show; SQL trace for round-trip count |
| Report first paint (<2k rows) | ≤1.5 s | click → first `WM_PAINT` on `pbdw125`; ETW UI delay |
| Report first paint (>20k rows) | skeleton ≤300 ms, data progressive | same; verify no >200 ms unindicated freeze |
| Scan → line item | ≤100 ms p95 | instrument barcode handler (rebuilt) or WinEvent + SQL trace |
| Sale post | ≤800 ms, zero modal on success | stopwatch on `ue_post` + dialog count |
| Resize / alt-tab | 60 fps, no frame >50 ms, no re-maximize | WPR GPU/CPU frame timeline; count `WM_SIZE`/`WM_PAINT` per second |
| Idle CPU | <1% (currently 0.000 s/12 s) | `Get-Counter '\Process(abuzar)\% Processor Time'` |
| Memory/handles | no growth after 50 sheet open/close | `Get-Process` WS/handles delta; `GetGuiResources` |

**Exact instruments:** `wpr -start GeneralProfile -filemode` → reproduce login, one report, one sale → `wpr -stop trace.etl`; SQL Server Profiler filtered to the app SPID (or `sys.dm_exec_query_stats` deltas before/after one screen open) to count statements and elapsed per open; a 30-line PowerShell `SetWinEventHook` harness to timestamp click→show without touching the app. For a rebuilt client, add phase timers (`t0` process start, `t1` splash, `t2` main, `t3` first sheet, `t4` first row) and assert the table above in CI.

## What NOT to do

- **Do not add indexes to fix UI lag.** Indexes help the retrieve, not the 3,490 menu parses, the 1,308-row preference scan, print-preview pagination or the 199 redraw leaks.
- **Do not raise `AutoRefreshItemListTime`** to "keep the item list fresh" — it reloads 28,966 rows every N minutes on the UI thread.
- **Do not disable fiscalization permanently** if FBR reporting is legally required — fix the 9111 service or queue it in the rebuild.
- **Do not run at 125/150% DPI expecting crispness** — the binary is DPI-unaware; Windows bitmap-stretches it.
- **Do not patch `abuzar.exe` in place** (`LARGE_ADDRESS_AWARE`); work on a copy with sign-off.
- **Do not rewrite the UI before taking the config wins** — two preference flips remove the loudest dialogs for free.
- **Do not assume 2,062 windows are 2,062 screens** — half are tiny report argument dialogs; optimize the ~300 transaction/report windows first.

## Measurements still needed

- **Per-open SQL round trips:** `sys.dm_exec_query_stats` snapshot delta (or Profiler) around one `w_sale`, one `w_reviewreport`, one `w_purchase` open. This separates DB latency from client parse/render.
- **Menu-walk cost:** time `mf_initsecurityapp` in a rebuilt copy, or count menu/toolbar invalidations with Spy++ during one sheet open (`[hypothesis]` 50–400 ms).
- **DataWindow parse cost:** time `SetDataObject` for `d_saledetail` (196 KB) and `d_item_detail` (296 KB) in a test PB app; confirms the 0.3–1.5 s estimate.
- **Item-list retrieve size:** `d_itemsinfo` SRD is missing; recover it or trace the actual TDS row size for the item lookup to quantify MB per retrieve.
- **Splash duration/order:** decompile the application `open` event (only p-code remains) or timestamp the window sequence with WinEventHook across 5 launches.
- **`w_bkg` usage:** confirm whether any deployment opens it (only 1 top-level window in the running session); if never used, delete the dead path.
- **Fiscalization behaviour:** next posted sale — record whether 1 or 2 dialogs appear, connect latency and whether the receipt is suppressed.
- **Redraw leak reproduction:** open item search, press Down at the last row, then scroll — confirm the grid stops repainting (proves the `w_entry.pbs:504-506` path).
- **Memory ceiling:** open 10 heavy sheets, record WS/handles/GDI; then test the `LARGE_ADDRESS_AWARE` copy for OOM headroom.
