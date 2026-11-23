# Status of the reverse engineering (authoritative; update every session)

> **Operational deployment/performance state:** see `PROJECT-MEMORY.md` — live SQL Server 2022 Express, client alias, scheduled tasks, rollback, final metrics. This file stays focused on the reverse engineering and rebuild.

## PowerBuilder source regeneration and first real compile (2026-11-23)

The owner asked for the PowerBuilder application itself to be improved. Its source is being regenerated from the
recovered data and compiled with PowerBuilder 2022 (build 1878) through the free command-line tools
(`PowerBuilderUtilities 22.0`: OrcaScript and the ORCA build API). Plan and progress: `docs/IMPROVEMENT-ROADMAP.md`.

- `re-tools/pbsrc_export.py . <folder>` writes the whole application as export source in the `ws_objects` layout:
  2,062 windows, 100 user objects, 156 menus, 53 structures, 460 global functions, 2 application objects,
  8,748 DataWindows, 1 pipeline, 1 query (118 libraries). It reads `recovered/scripts_pb`, a second decompile in
  PowerScript mode (`PB_POWERSCRIPT=1 decomp_all.py`); `recovered/scripts` (the rebuild's dialect) is unchanged.
- First full rebuild by the real compiler: **1,406 errors in 868 of 11,581 objects; all 8,748 DataWindows compile.**
  The error classes are being fixed at their source (decompiler or generator), one compile cycle at a time
  (`re-tools/build_cycle.cmd`, `orca_build.py`, `compile_errors.py`, `compile_show.py`). Measured full rebuilds:
  cycle 1 = 1,406 errors in 868 objects, cycle 3 = 224 in 147, **cycle 4 = 60 in 44** (34 of them one class: a function
  that ends without a return value). The fixes for all 60 are in the generator; cycle 5 has not been measured.
  No executable has been built yet and nothing has been run.
- **Improvement overlay** (`improve/`, third argument of `pbsrc_export.py`): script patches with an expected match
  count (`patches.py`), design-time property overrides (`properties.json`), corrected DataWindows
  (`datawindows/<library>/`), whole objects (`objects/<library>.pbl.src/`), removed objects (`remove.txt`).
  It already repeats, in source, every fix that was patched into the compiled `deploy\Application` libraries on
  2026-11-23 (`deploy/FIX-LOG-2026-11-23.md`): 79 script patches (71 report argument windows, 19 report-viewer
  format chains in 7 functions, the audit-report guard), 12 property overrides from which 361 windows inherit the
  ticked "All" box, 117 DataWindows. The patched libraries were re-exported and compared instruction by instruction
  (`re-tools/patched_export.py`, `pcode_diff.py`, `improve_all_ticked.py`) to get that list.
- The SOAP call of the SMS centre (Zong corporate SMS) used a .NET proxy and the 12.5 SOAP extension, neither of
  which exists for the 2022 runtime. Replaced by three objects in the overlay that send the same SOAP 1.1 request
  with `HTTPClient` (action, namespaces and member names read from the vendor's `Service1.dll`). **Not tested
  against the service**; the old option that wrote the SMS login to `C:\mySoapLog.log` is not carried over.
- Newly recovered from the compiled libraries: 777 external and stored-procedure declarations, 35 object-level
  structures, the bounds of local / instance / structure arrays, the argument lists of events declared without a
  script, the message ids of events (692 ids from `PBVM125.dll`), all enumerations (134), the OLE control data
  (36 binary sections, exported by PowerBuilder's own API from the original `.pbd` files), and the **design-time
  list items** of 98 drop-down lists and list boxes (printer models, COM ports, AM/PM, report formats, filter
  operators), which no earlier export contained.
- **Decompiler defect that changes behaviour (also affects the Rust rebuild):** for
  `if A then ... if B then return x end if end if` the decompiler added a valueless `return` after the inner `if`,
  so the routine leaves where the original continues (for example with the next loop round). Corrected in
  `re-tools/pcode_struct.py`; `recovered/scripts_pb` is regenerated, but **`recovered/scripts` and
  `rebuild/data/src/scripts` are not**: 344 functions in 143 objects there still carry it
  (`w_fee_voucher.wf_validategroupcustcat`, for one, validates only the first row). The rebuild needs the same
  re-decompile and its usual merge of hand edits.
- **Second decompiler defect that changes behaviour (also affects the Rust rebuild), found 2026-11-23:** a
  conditional jump that leaves the enclosing block was written with the condition the wrong way round
  (`if c then <leave>` instead of `if not c then <leave>`). **10 places in 8 objects had inverted logic:**
  `w_billsummary` (the invoice-balance error check), `w_sale` twice (sale-order enforcement of bonus quantity and
  discount %), `w_postsale` (auto-production: which held item has a recipe), `vf_dwdupcode2` (duplicate-code check),
  `nv_remote_datawindow`, `w_generate_services_academicclass`, `...2` (twice), `...3`. Corrected in
  `pcode_struct.py` (`PB_GUARD_TRACE=1` marks the places, `PB_LEGACY_STRUCT=1` gives the old text);
  `recovered/scripts_pb` is regenerated, `recovered/scripts` and `rebuild/data/src/scripts` are **not**.
- **Third decompiler defect (names), same date:** member numbers skip constants, and inherited constants (attribute
  0xd9) were counted. 10 classes have inherited constants before variables; in the decompiled text it changed one
  statement: the constructor of the mailer `n_smtp` read `this.crypt_string_base64` where the original has
  `this.idbl_frequency`. Corrected in `pcode_lift.py` (a full re-decompile changed that line only); same state for
  the rebuild's scripts as above. Two controls (`w_item_form.dw_find`, `w_itemregrequest_form.dw_find`) had no names
  for the global functions they call (`gfunc_1` ...): `build_fnrefs.py` now finds their table.
- **Fourth decompiler defect, found by running the rebuilt program (2026-11-23):** two nested ifs without an else
  (`if A then` / `if B then`) were written as one `if A and B then`. PowerScript has no short-circuit evaluation: in
  the merged form B runs even when A is false (a function call with side effects, or a member of an object A has just
  tested: the first Cash Sale opened in the rebuilt program stopped with "Null object reference" in
  `w_sale.tab_retrieve.selectionchanging`). A compiled `and` is one instruction, two jumps are always two ifs: kept
  apart in PowerScript mode now (`pcode_struct.py`). `recovered/scripts` (the rebuild's dialect) still has the merged
  form; whether that matters there depends on how the rebuild's interpreter evaluates `and` (not checked).
- **Initial values of global variables** were not recovered before: the application's version number
  (`gl_appversion = 3567`, equal to `Sequence.AppVersion` of the database; with 0 the program refuses to start), the
  default godown, the names of the SQL Agent jobs, the temporary folder: 60 values, read from the compiled application
  object by `re-tools/globals_export.py` into `recovered/pcode_names/global_inits.json`.
- **First run (2026-11-23 09:02):** full rebuild with 0 errors (cycle 6), `abuzar.exe` + 118 `.pbd` built by
  `orca_build.py exe` (every library a PBD, as the vendor ships it), started from `pbrun\` (new program + PowerBuilder
  2022 runtime + the vendor's non-PowerBuilder files; `re-tools/pb_runfolder.py`) on the database copy
  `WaseelaPBTest`: the Login window appears, the login is accepted, the main frame opens with its 211 menu items.
  Helpers that drive only the program started from that folder, by window messages: `re-tools/run_shot.ps1`,
  `run_login.ps1`, `run_menu.ps1`, `run_children.ps1`.
- Controls inside a user object placed on a window (7 windows, 77 controls) were written with the user object's own
  scripts repeated at window level (51 scripts), which would have run them twice. They now get the empty type block
  PowerBuilder itself exports.

## Modern UI visual QA, second pass (2026-11-15; commits `695daa81` + `38ba21a4`, deployed to production 2026-11-16)

Every enabled menu screen of the Modern interface (202 of 211 leaves of the test user's menu) was opened in a real browser against
the scratch copy `waseela_rehearsal`, photographed and reviewed in repeated full crawls (dark and light, all 404 screenshots read
after the last fixes; key screens also at
1100-1366 px width). The defects found were fixed in the shared renderer and design layer of `rebuild/web/src/ui` (Home, Cash and
Credit Sale, Pack Purchase, report criteria cards, dialogs, master forms, frame header and toolbar, report viewer, message boxes);
the list and what was checked and left as the original are in `rebuild/docs/DEPLOYMENT.md`, "Modern UI visual
QA, second pass". 962 frontend tests and the presentation types pass; a Cash Sale was posted end to end in Modern on the scratch
copy (invoice 588877), and a Pack Purchase was saved and posted (invoice 12278). Committed as `695daa81` and `38ba21a4` (CI green) and deployed to pharmacy.polytronx.com on 2026-11-16 (version `38ba21a4-944d1f4b`).

## Classic completeness (2026-11-12)

The Classic version of the rebuild (the interface that reproduces the original
application) was measured end to end and the defects that stopped windows from
opening were fixed.

- **Every window class opens: 2,062 of 2,062** in the headless run with the
  mock database (`node web/tools/smoke-windows.ts web/public/data -`), against
  **2,046 of 2,062** before this pass. `rebuild/docs/PARITY.md` is generated
  from that run.
- The windows the application opens with an argument are now opened with **that
  argument** (`rebuild/web/src/app/window-arguments.ts`): the Find and print
  dialogs get the grid, the column picker and the graph dialogs get their
  structure, the entry, response and graph windows get the structure their
  caller builds. Before, a window read a null object and stopped — exactly as
  the original would.
- A DataWindow **without a definition** behaves like the empty DataWindow of
  the original (no columns, no objects, no null reference): the entry windows
  read `object.datawindow.column.count` in their Open event to fill their
  column lists.
- The definitions of the DataWindow controls are loaded **before** the window's
  Open event runs, as PowerBuilder loads them when the control is created, so
  those column lists hold the real columns.
- The **PowerBuilder graph control** of the graph viewer is implemented
  (`rebuild/web/src/runtime/native/graph.ts`) and drawn as SVG in the Classic
  view; the eight graph windows open and work.
- One decompiler defect was corrected in the rebuild (`w_visitprescription`
  printed `.name` for the `object` namespace of a DataWindow, the same defect
  it printed as `.borderstyle` in dozens of windows). It is a scoped
  correction in `rebuild/web/src/runtime/class-fixes.ts`; the recovered source
  is unchanged.
- Two more defects of the recovered scripts are corrected the same way: the
  barcode label popup re-triggered its own `ue_postopen` event (an endless
  recursion), and `SQL stop` on a transaction that was never connected raised
  a null reference.
- **The direct event calls now run.** `event ue_xxx()` and
  `post event ue_xxx()` (the compiler's event call modifier) were noted as
  missing functions and did nothing; the Cash Sale alone calls
  `event ue_deleteitem()` 26 times, and the entry windows post their
  post-open and new-form events. The interpreter now runs the event script of
  the object the statement belongs to.
- A **Classic browser sweep** opens every window class in the real Classic DOM
  of the running application (`rebuild/web/e2e/classic-window-sweep.mjs`) and
  records the runtime errors, the page errors and the message boxes of each
  window: **2,062 of 2,062 windows open**, with no page error and no console
  error in the whole sweep (59 minutes, 1,366 px viewport).
- **The Classic interface was launched against the real database** (the data
  server of the deployment on 127.0.0.1:8787 and the migrated PostgreSQL data,
  the current sources served by the development server):
  - the sign-in through the original login window works with the deployment's
    administrator; the main window opens with the original's title
    (`WASEELA ABUZAR V2 01.01.2022 : ADMIN : …`) and the **264 menu commands**
    of the deployment's rights (the original showed 265);
  - **Sales | Cash Sale** opens with the real catalogue (**27,818 items**),
    picking an item fills the line with the real name, price and stock
    (2BLINK 15ML EYE DROPS at 440), the quantity 2 gives the line total 880
    and the footer 881.00 (880 + the 1.00 FBR POS fee);
  - **the sale was posted into the database**: the app asks the operator for
    the password, the invoice 588872/588873 was written to `saleledger` with
    its line in `saledetail` (441.00 and 881.00) and the counter table moved
    on;
  - **Reports | Sales Reports | User Wise | Net Cash** runs against the real
    data and prints the report (From 01/01/24, To 31/12/25, User ADMIN,
    Total Sales 17,777,449.00);
  - **Basic Data | Customer** opens the Customer form with its line;
  - no page error and no console error in any of it.
  - The write test ran against the **rehearsal copy** of the migrated data
    (`waseela_rehearsal`), so the migrated copy stayed untouched; two
    test invoices (588872, 588873) are in that copy as the evidence.
- **The Classic application was then driven by hand in the user's own Chrome**
  (through the Browse Chrome extension, the visible browser of this PC) against
  the real database, exactly the way an operator uses it:
  - **sign-in** through the original login window (the app's own editor cells,
    then Ok); the main window opens with the original's title
    `WASEELA   ABUZAR V2 01.01.2022 : ADMIN : 13/11/26 21:06:52`;
  - **Sales | Cash&Sale**: the item list on the right holds the real
    catalogue; clicking an item fills the line (SACHETS 10S at 1,000.00,
    20CC D/SYRINGE at 35.00 with stock 43), the line total and the footer
    total follow (1,001.00 = 1,000.00 + the 1.00 FBR POS fee);
  - **File | Save**: the app asks the operator for the password (the User
    Password window, code + password), and after it the document is posted:
    the **invoice 588874** is in `saleledger` (13/11/2026 20:58:59, cash
    customer 19, 36.00) with its line in `saledetail` (20CC D/SYRINGE, 1 ×
    35.00) and the counter table moved on to 588874;
  - **Basic Data | Customer .......... | Customer**: the list page shows the
    real customers (19 ****CASH SALES CUSTOMER / CASHSALES, 22 CREDIT
    SALES-WALKING CUSTOMER A/C) and the detail page the whole record;
  - **Basic Data | Item .......... | Item**: the list page shows the real
    catalogue (SACHETS 10S alias 27429, 10 CC BD D/SYRINGE alias 4273, …);
  - **Reports | Sales Reports | User Wise | Net Cash**: the criteria window
    takes the date range (01/01/24 00:00:00 – 31/12/25 23:59:59) and the user
    from its list (ADMIN), and the report prints the real figures (Total
    Sales 1,777,749.00, Net Cash 1,777,749.00, Total 1,777,749.00);
  - no page error and no console error in the whole session.
- **A finding for the live deployment** (read-only check of the live SQL
  Server): the invoice counter table `_tabmaxkey` of the live system holds
  **588,861** for `SaleLedger` while the highest invoice in `SaleLedger` is
  **588,871** (588,865 rows). The next invoice number the application computes
  is therefore 588,862 — a number that is already used — and the application
  refuses the posting with "Sale invoice 588862 already exists. Please Try
  Again..". The rebuild reproduces this behaviour exactly (it is the
  application's own rule, not a defect of the rebuild). The counter of the
  rehearsal copy was set to the true maximum (588,871) for the test; the
  live system and the migrated copy were **not** changed at that time.
- **Live SQL Server repair (2026-11-16):** after an owner-approved, verified
  backup, the `SaleLedger` counter was advanced to **588,871** and the
  `PurLedger` counter from **12,266** to its maximum **12,276**. A rolled-back
  allocation test produced unused numbers for both. The migrated PostgreSQL
  copy was not changed. No live test transaction was created.
- **Legacy alternate-invoice reset repair (2026-11-17):** the daily and monthly
  SQL Server reset procedures now compare complete calendar dates or months,
  fixing missed resets after certain year boundaries. The guarded migration and
  rollback scripts are `deploy\impl\11_invoice_counter_calendar.sql` and
  `deploy\impl\11_invoice_counter_calendar_rollback.sql`. Eight calendar cases
  in `deploy\impl\11_invoice_counter_calendar_test.sql` and a rolled-back check
  of the committed procedures passed; no invoice was posted.
- **Legacy counter checks (2026-11-17):** three log/quotation counters omitted
  from the single-integer-primary-key scan point to unused next keys; their
  mapped tables were empty. The next values in fourteen mapped header counters
  for header 1 were also unused, including four service counters whose mapped
  tables were empty. A check of 31 voucher, notes, sale type, sale order,
  receipt and issue category counters found no next-key collisions or counters
  behind their existing maxima. These checks do not cover every counter type.
- **Legacy desktop navigation (2026-11-17):** Cash Sale opened via one drag
  from the Sales menu to its first item; the existing Pack Purchase window
  remained open. A prompt to save the new sale was canceled, and the item
  selection popup displayed catalogue rows with stock and prices. These checks
  do not verify item selection, posting, fiscalization, reporting or printing.
- **Legacy report queries (2026-11-17):** the recovered Daily Sales Summary
  SQL returned rows with non-null totals for the latest posted-sales day and
  its most frequent category. Daily Purchase Summary SQL returned rows with
  non-null amounts for the latest posted-purchase day. Only aggregate counts
  were returned; the desktop report viewer and printing were not exercised.
- **Legacy desktop recheck (2026-11-19):** the original app was restarted with
  its application working directory; Cash Sale opened and its item catalogue
  loaded. A physical-only SQL Server consistency check and eight temporary
  calendar-reset cases passed, and the next sale and purchase keys were
  unused. A synthetic Notepad document printed to Microsoft Print to PDF and
  its contents were verified; this does not verify the app's print flow.
  The spooler was restarted with its startup mode still Manual. The default
  printer was RustDesk Printer, and no physical printer was observed.
  Recovered `w_sale.ue_print` can save and post a sale, and can commit a
  reprinting-counter update, so the Cash Sale print button was not used as a
  read-only test. Actual app report rendering, printing, posting and fiscal
  submission remain unverified.
- **Legacy database integrity (2026-11-19):** a subsequent full SQL Server
  `DBCC CHECKDB` reported zero allocation and consistency errors. This is a
  database consistency check, not an end-to-end application test.
- **Legacy posting data checks (2026-11-19):** aggregate read-only checks
  found all 588,865 sales and 12,276 purchases marked posted, no headers
  without detail rows, and no orphan sale or purchase detail rows. One
  historical posted 2022 purchase still has the known missing tax-category
  reference; it is the reason its enabled FK is untrusted. No historical
  financial data was rewritten. SQL metadata shows an idle fiscalization
  connection with one long-open transaction, but no table locks; it was left
  untouched. These checks do not exercise a new application posting.
- **Legacy SQL posting check (2026-11-19):** in a restricted temporary copy
  restored from a verified backup, a loginless test user was denied access to
  the live database. A rolled-back cash-sale posting check verified category
  filtering, the posted header fields and a repeated call; the original copied
  header was restored and the temporary database removed. The tested posting
  procedure and four related routine definitions matched the live database;
  loyalty, item-meter and posting SMS paths were inactive in the copy. This
  does not test the desktop save flow, inventory, purchase or fiscalization.
- **Legacy purchase stock check (2026-11-19):** on a separate restricted
  temporary database copy, existing- and new-batch stock updates produced the
  expected batch, warehouse and item totals. For the single existing-batch
  update, the timestamp trigger changed no unrelated batch timestamps.
  Rollback restored the complete stock-table snapshot, and the copy was
  removed. The tested procedures and trigger matched the live definitions.
  This does not test desktop purchase posting or external integrations.
- **Legacy fiscal listener probe (2026-11-19):** a local zero-invoice TCP
  request closed without a response, and the listener remained responsive.
  Its recovered receive handler guards sale and return processing on a
  positive invoice number. This probe has no positive acknowledgement and
  does not verify fiscal processing or external submission.
- **Legacy fiscal listener startup (2026-11-19):** the previous scheduled
  run reported failure after checking only five seconds after launch, though
  the same process was later listening. The starter now waits up to 60 seconds
  without launching duplicate processes and rejects port 9111 listeners
  belonging to other executables; twelve mocked startup cases passed. A manual
  Task Scheduler run returned 0 with the existing listener PID unchanged and
  only one listener process. This tests the existing-listener path, not startup
  at logon or successful fiscal submission.
- **Historical fiscalization marker (2026-11-17):** one non-deleted posted
  sale on the latest historical posted-sales day has `Fiscalized='N'`, with no
  stored fiscal number or timestamp. Its eligibility and reason are unknown;
  no submission or status change was attempted. It was not a generated split
  invoice. Separately, the recovered save path populates a list of split
  invoice IDs, but the automatic fiscalization loop passes the original ID
  each time instead of the current list entry. `SplitSaleInvoice` is currently
  `N` and no posted split sales were found, so the defect is inactive in the
  current configuration; it has not been reproduced at runtime or fixed in
  the compiled vendor application.
- **A second finding on the same rule** (found while posting on this PC): the
  application only accepts an invoice dated within `MaxAllowDate` (4 days by
  default) after `serverdate.lasttransdate`. The migrated copy — and the live
  SQL Server — carried **2025-01-04**, so a current sale was refused with
  "Date Violation: Forward Date Invoice Check violates". The application
  offers the operator the maintenance window for it (`Set Last Transaction
  Date`, `w_set_lasttransdate`); until that row is brought up to date the
  system cannot post new invoices. The rule and the message are reproduced
  faithfully by the rebuild.
- **Live SQL Server date repair (2026-11-16):** with owner approval,
  `serverdate.lasttransdate` was set to 2026-11-16 00:00:00. This can prevent
  backdated entries. The app advances the timestamp when its date check
  succeeds, but a long period without transactions can again exceed the
  configured forward-date limit. On 2026-11-17 the live `SoftwarePreferences`
  value of `maxallowdate` was 30; 4 is the fallback when the preference is null.
  The legacy desktop's end-to-end posting has not yet been verified after this
  change.
- The frontend suite passes (946 tests) and the strict presentation types
  compile; the new checks live in
  `rebuild/web/tests/classic-window-open.test.ts`.
- Still open for Classic: the menu crawl of the 265 observed leaves of the
  original's menu needs the rights of the deployment (the real database, so it
  runs in the CI end-to-end job), and the OLE controls of the deployment
  (fingerprint reader, ActiveX viewers) are stubs.

## Latest verified UI enhancement snapshot

**Project rules updated 2026-11-08:** `rebuild\AGENTS.md` now requires
implementation-first work with no intermediate browser runs and one final
consolidated browser pass after the agreed code scope is complete. Routine
decisions use recommended defaults without repeated questions; required
approvals still apply. Root and rebuild agent instructions and handoffs link
to this policy. This documentation change does not change the verified
implementation counts or acceptance evidence below.

Both source calendar owners now share the Classic/Modern renderer, with 55
criteria owners and 70 authored modal layouts. The ISO-returning DataWindow
calendar retains its original-date Cancel contract. Its standard and
customer-comments F4 handlers reject invalid drafts, preserve millisecond
clocks, initialize empty datetimes at midnight and restore exact editor text
and focus. Colon-separated fractional masks retain their source date order.
The customer-comments override is checked in a synthetic owner, not the
complete business window.

The enhancement is not complete. The authored registry covers 168 of 2,062
inventoried windows (8.15%; 3,005 of 32,730 inherited control paths, 9.18%): 70 modal layouts
(55 criteria, 5 native-field, 4 transaction, 4 calculator and 2 calendar windows)
and 98 entry windows (95 single-entry: 43 Code/Name and 52 richer, including
sixteen added masters). 271 of 8,740 DataWindows (3.10%) have an authored surface.
No window has verified runtime reachability, role coverage or Classic evidence, and
no complete screen is verified. Three print families and four print definitions
exist; none is approved.

The verified snapshot passes 796 frontend tests, 9 static-inventory tests and strict
presentation types. Consolidated regression passes 12,819 assertions and 789
appearances, plus 148 additional forced-color assertions and 84 focused print
assertions (5 settings and 4 document appearances), with no failures, runtime/page
errors or forbidden requests. All 95 single-entry masters pass 4,007 focused
Classic/Modern assertions, including Goods Company's 15-character Phone boundary.
Evidence is in the session artifacts `goodscompany-complete-regression`,
`single-entry-complete-verified` and `goodscompany-final-print`.
The aging-date, list-date, inpatient/service and
`f_getdatefromcalendar` callers have source-handler tests. `rebuild/docs/ui-completion-audit.md`
(generated by `rebuild/tools/parity/ui_completion_audit.mjs`) lists the full gap. Normal
startup remains Classic. Previous evidence below belongs to its own inputs and is
not a claim of overall completion.

### Repository state (rebuild/, `jerryboganda/abuzar-rebuild`)

Five local commits sit on `main`, five ahead of `origin/main` and **not yet
pushed**: `523a5c5e` (code, tests, e2e), `b0f6ca67` (CI presentation-job fix),
`8fce815a` (docs, audit generator and report), `38d9c8c6` (audit-tool note) and
`0571876b` (verified Goods Company integration and refreshed audit). The session's GitHub account
(`manwara575-star`) has no write access, so `git push` returns 403. To publish,
run `git push origin main` from `rebuild/` as the repository owner, then watch
the `ci` and `sql` runs. The `ci` presentation job (about 25 minutes on a
workstation, 90-minute limit) is unproven on a real runner; a clean-checkout
rehearsal of its steps on Windows passed (793 tests, types, inventory, data
generation, 67-module build, 84 print assertions). The outer repository is never
pushed. Four files hold newer concurrent edits that are deliberately uncommitted
(`web/src/ui/window-surfaces.ts`, `web/tests/window-surfaces.test.ts`,
`web/e2e/presentation-browser.mjs`, `web/e2e/presentation-single-entry-browser.mjs`):
the additional `w_emailtemplate_form`, generalized display-field fixtures and
a narrowed debugging filter. They appeared while the Goods Company full
regression was running, so they are not covered by the frozen snapshot above.
Do not overwrite them or mix their live counts into this committed audit.

### Previous DataWindow-calendar snapshot

The previous source-matched snapshot passed 745 frontend tests, strict
presentation types and 624 focused both-host assertions/eight appearances.
Consolidated regression passed 11,909 assertions and 781 appearances, including
eight of each calendar owner, plus 148 additional forced-color assertions.
There were no failures, runtime/page errors or forbidden requests. All 67
production modules, 25 copied fixtures and 127 inputs matched;
`datawindow-calendar-verification.json` records final identity, hashes and
acceptance boundaries. The full result is
`datawindow-calendar-final-consolidated\result.json`.
Complete screen/document catalogs, additional native callers, business
workflows and native/database/assistive-technology/hardware acceptance remain
open.

### Previous native-date calendar snapshot

The original shared F4 calendar now has native single-date APIs and a shared
Classic/Modern renderer. That snapshot has 55 criteria owners and 69 modal
layouts. Selection, output references, source events, mask/clock retention,
cancellation and restored field focus are covered in both hosts. Delayed
DateChanged work cannot be bypassed by rapid Enter or OK, and Modern initial
calendar focus waits until its modal is visible.

The native-date calendar snapshot passes 739 frontend tests, strict presentation
types and 924 focused browser assertions/eight appearances. Enlarged dates retain
at least four pixels of measured horizontal room at 320px; minimum ordinary
calendar text contrast is 6.384:1. Source-matched consolidated regression passes
11,285 assertions and 773 appearances, plus 148 additional forced-color checks,
with no failures, runtime/page errors or forbidden requests. All 67 production
modules, 24 fixtures and 126 inputs match; `calendar-verification.json` records
final identity, evidence hashes and scope. The ISO-returning `w_calendar2`
DataWindow owner and other callers were outside that snapshot's acceptance.
Previous evidence below belongs to its own inputs. Complete catalogs/workflows,
native/database/assistive-technology/hardware acceptance and controlled rollout
remain open. Normal startup remains Classic.

### Previous date/choice snapshot

Six source-backed date/choice dialogs now add As On, cost-price variants,
Cash/Credit/Both, cashflow accounts and remarks. Authored coverage reaches 55
criteria owners and 68 modal layouts. Secondary-buffer guards retain original
lookup keys/defaults, nulls and return fields without adding a blocking guard
around the parent's original customer AcceptText call. Literal external labels
remain accessible and live through selector repaint.

The focused snapshot passes 726 frontend tests, strict presentation types and
734 both-host assertions/48 appearances, with actual date recovery and
secondary-selector keyboard/pointer input. All 65 modules, 24 fixtures and 123
inputs match. Consolidated regression passes 10,645 assertions and 765 appearances,
plus 148 forced-color assertions, with no failures, runtime/page errors or
forbidden requests. `date-choice-verification.json` records final identity,
evidence hashes and contrast; full results are in
`date-choice-keyboard-consolidated\result.json`. That snapshot did not cover
MonthCalendar/F4 behavior. Complete catalogs/workflows and native/database/
assistive-technology/hardware acceptance remained open.

### Previous date-option snapshot

Nine additional source-backed date/filter dialogs now have Modern layouts,
bringing authored criteria owners to 49 and modal layouts to 62. They preserve
sales/returns cash-credit flags, adjustment and outstanding options, posting
status and date categories, purchase/sale type rules, and all fifteen original
transaction codes. All Transactions retains its check/disable and clear/enable
behavior. Hidden customer criteria remain empty and unused. Atomic native-date
preflight and fresh cancellation cannot overwrite a return with partial dates
or reuse prior success. Missing native option TabOrder receives a normal Modern
tab stop without changing explicit exclusions or Classic.

The date-option snapshot passes 713 frontend tests, strict presentation types
and 1,282 both-host browser assertions/72 appearances, including real keyboard
and pointer actions at narrow and enlarged-text sizes. All 65 production
modules, 24 copied fixtures and 123 input hashes match the focused and consolidated
snapshot. The complete synthetic regression passes 9,913 assertions and 717
appearances, plus 148 forced-color assertions. Final source/build/fixture equality
is recorded in `date-option-verification.json`, with the full result in
`date-option-keyboard-consolidated\result.json`. Minimum measured ordinary text
contrast is 5.959:1; the added dialog appearances reach at least 6.759:1.
There are no failures, runtime/page errors or forbidden requests. Complete catalogs,
workflows, native/database/assistive-technology and hardware acceptance remain
open. No operational app, customer data, printer or native desktop was accessed.

### Previous print-snapshot history

Print integration now preserves global/family inheritance, permits clearing
overrides, retains failed drafts and explains unavailable templates without
claiming a print job occurred. Short choices and linked help remain readable
at 320px/200%. Decorative print rules no longer shift fields or expand hidden
zero-height bands. Sales/purchase invoice layouts remain previews; item labels
remain blocked pending paper/printer information.

The integrated snapshot passes 694 frontend tests, strict presentation types
and 84 focused browser assertions with five settings/four synthetic document
appearances. All 65 production modules, 24 copied fixtures and 123 tracked
inputs match the focused evidence in `print-integration-current-focused`.
The source-matched consolidated run passes 8,633 assertions, 645 appearances and
148 additional forced-color assertions. `print-integration-verification.json`
records final input/build/fixture equality and measured results. A concurrently
appended duplicate focused-print entry point used the old helper signature;
removing only that redundant definition preserved the complete both-host runner
and restored exact equality with the passing snapshot. No printer, native desktop
or database was exercised; normal startup remains Classic.

### Earlier numeric-snapshot history

Classic/Modern enhancement remains incomplete and unreleased. Cashier closing,
multiple-invoice cash tendering and category changes have scoped Modern modals and original-script
synthetic coverage; real authorization and database acceptance remain outstanding.
The numeric-dialog snapshot has 685 passing frontend tests, passing strict
presentation types and two identical isolated 63-module builds. During browser
verification, concurrent print work added `modern-print.ts` and
`print-templates.ts` and changed `ui-preferences.ts`, `presentation-styles.ts`,
`presentation-ui.ts` and `print.ts`. These edits were preserved.
The first combined 65-module check passed 692 frontend tests and strict types.
A subsequent 65-module full run also passed 8,549 assertions, 636 appearances
and 148 forced-color assertions, and the latest completed frontend/type run
passed 693 tests. Concurrent work continued changing `modern-print.ts`,
`presentation-browser.mjs` and `presentation-smoke.mjs` and added
`presentation-print-browser.mjs`. The strict provenance check rejected this
source/fixture drift; neither full run is final current-tree acceptance.
The numeric changes remain preserved, and no competing edits were reverted.
Initial numeric provenance recorded 59 matching production modules and 23
matching fixtures before those later edits; those are historical observations,
not claims about the still-changing checkout.
The concurrent HTTP backup-parser
TS2322 has been resolved with a type-only capture annotation, preserving its
backup behavior. Historical failure logs and the older snapshot mismatch are
retained; they no longer describe the current type-check state.
Recovered `DDDW.PercentWidth` and positive
`DDDW.Lines` values now size
editable, automatic and ordinary readonly lookup popups with viewport clamping.
Large lists now use measured variable-height windows with bounded live and
cached option nodes, preserving full-set navigation, source keys and focus.
The complete numeric browser snapshot passes 8,549 assertions and 636 appearance cases,
including forty authored criteria-dialog integrations. The preceding focused
component baseline has 773 assertions/108 appearances; the expanded owning-dialog
fixture passes 1,908 assertions/304 appearances for forty owners, including real item
search, native-list keyboard/pointer interaction, native date correction/navigation,
six reference-text owners, six numeric owners and selection/acceptance in all fifteen lookup owners.
The full-run result records the
owning-window appearances once.
An additional 148 forced-color assertions pass across four emulated light/dark
system-palette and viewport cases. Modern selection, current-row/focus cues,
checkbox/radio markers, invalid borders and default actions use system colors.
Narrow text-backplate suppression keeps selected grid/suffix/lookup glyphs readable
while native editor descendants retain automatic system colors. Real rejected
drafts and focus survive palette changes without storing the rejected value.
Pixel checks supplement computed CSS colors; the measured system selection
pairs reach at least 14.371:1. Current evidence is
`numeric-criteria-consolidated\result.json`,
`numeric-criteria-final-focused\criteria-window-result.json` and
`numeric-criteria-verification.json` in the session artifacts;
the full result also contains the 148 forced-color assertions.
`numeric-criteria-verification.json` records current source/test hashes,
matching tested snapshots and copied fixtures, measured browser results and
the explicit concurrent-print differences (`currentSourceMatch: false`).
Separate `numeric-criteria-concurrent-frontend.log` and
`numeric-criteria-concurrent-types.log` record the combined tree's passing checks.
The later snapshot is `numeric-current-consolidated\result.json`, with
`numeric-current-frontend.log`, `numeric-current-types.log` and
`numeric-current-inputs.json`. `verify-numeric-current.mjs` refused to write
a current-source acceptance report after observing concurrent fixture drift.
At that stage, final print integration required stable source inputs; the
subsequent focused integration is recorded separately above.
The preceding `text-criteria-verification.json` retains the 672-test,
8,243-assertion / 588-appearance reference-text snapshot and its
1,602-assertion / 256-appearance focused result.
The preceding `lookup-criteria-verification.json` remains historical evidence
for the prior 659-test snapshot.
The preceding native-date evidence remains in `native-date-verification.json`,
`native-date-complete` and `native-date-keyboard-focused`, with 628 frontend
tests, 7,244 full assertions / 420 appearances and 603 focused assertions / 88
appearances. Earlier lookup runs are retained as fixture failures: Boolean
flags were incorrectly treated as integers, item cancellation was confused with
quotation cancellation, the exact `Ok` caption was miscapitalized, and the
source-persistent ShowList required real Tab before the next action.
The final snapshot preserves those original semantics rather than changing them.
The preceding item-selection baseline remains in `item-selection-verification.json`,
`item-selection-current-complete` and `item-selection-current-focused`, with
617 frontend tests, 7,018 full assertions and 396 appearances.
The mistyped script invocation in `item-selection-current-types.log`
is not type-check evidence. The first successful item-selection full run,
`item-selection-complete`, predates a concurrent Classic focus-rule edit.
That rule is preserved; Modern's stronger native-control selector retains its
two-pixel themed focus ring, with an explicit browser assertion. The fresh
current snapshot includes both rules.
The preceding `criteria-owners-verification.json` records the historical HTTP
module/type mismatch, now resolved. Its full run had 6,953 assertions and
392 appearances. The interrupted `criteria-owners-complete` has no passing
result; `item-selection-interaction` retains the earlier DataStore-feedback
failure. These historical failures and mismatches are not current blockers.
The earlier suffix baseline remains in `criteria-affixes-verification.json`.
Earlier linked-criteria
evidence remains in `linked-criteria-verification.json`; the preceding
required-guidance baseline
remains in `required-guidance-verification.json`; the earlier high-contrast baseline
remains in `forced-colors-verification.json`. This is browser
emulation, not actual Windows high-contrast or assistive-technology acceptance.
Modern now identifies source-required editable form fields and grid columns,
sharing the exact FindRequired metadata rule without new validation or browser
constraints. Labels, multiline hints, optional lookup distinctions, dynamic
drafts/caret and stored values are preserved. Required state is attached to
supported field/editor roles, not generic groups; protected/generated form
values and computed outputs are excluded. Headings return to normal scrolling
when a sticky heading and a full row cannot fit. Thirty transaction appearances
retain 29 sticky headers and one short-pane flowing header, with whole-editor
bounds checked against headings and totals.
Twenty-seven criteria components now have explicit Modern mappings. In addition
to distributor code/city variants, OT bill, sale price/disabled price/discount
and multiline letter fields, four distributor export variants retain their
individual static target-system lists, the zonal daily-sales form preserves
both report lists, and the margin/mark-up form keeps its sorted choice and
0–100 percentage spinners. Original labels, hidden city/default, readonly
price, decimal validation, text limits, CRLF and individual empty-text policy
remain intact. Ten further mappings cover class variants, packing layout,
price type/mark-up, service template/remarks/due date, zone, quotation/customer
and voucher/invoice ranges. Nine retrieval-free lookup definitions use synthetic
rows to verify original data/display keys, duplicate-label selection,
editable-caption resolution, veto/retry and readonly dependencies.
Percentage adjustment, top-customer count and customer-reference replacement
now retain source-bound trailing units/instructions. Suffixes wrap and describe
their fields, with live text/visibility and supported per-row expressions.
Hidden/empty suffixes remove only their own descriptions without changing a
draft, selection or stored value. The original percentage dialog retains its
caller caption, initial `To:` versus changed `By:` wording, validation, decimal/
intervention return and -1 cancellation status.

Its source scripts exposed a shared property-assignment defect: literal text
was fed back into Modify syntax and truncated at spaces. A direct literal
setter now preserves quotes, whitespace, empty text and apparent assignments,
while sharing boolean normalization, visibility ordering, table-property
side effects and version invalidation with Modify. No recovered scripts were
rewritten. The fixture waits for input processing before invoking OK and
explicitly checks ItemError, not merely a busy-input rejection.
The criteria components' 773 both-mode assertions and 108 appearance cases include
source-list selection, IME, retained rejected drafts, real Shift+Enter and
source-order Tab navigation. The remaining inherited reporting windows, retrieval/output workflows and full
multi-column child detail layouts are not migrated by these component bindings.
Forty complete outer criteria layouts have separate original-script coverage;
these still do not establish production reporting acceptance.
The fifteen new single-lookup owners cover account, item, doctor, godown,
manufacturer, patient, region, zone, sales-person, subaccount, supplier, user and
customer-group criteria. Context-local bindings retain exact child keys,
external captions, editing policies, row budgets and inherited controls.
The supplier-label All option remains visible; suppression/hide flags remain
Boolean. Untouched null selections retain source semantics, including explicit
godown/sales-person null-to-zero conversion. Invalid edited choices and consumed
dates cannot return stale or partially written results. Item-criteria retrieval
failure reports its error and cancels before insertion. Subaccount ShowList stays
open after selection; real Tab accepts, dismisses it and reaches the next action.
Dependent machine/date retrieval, shared global item lookups and distributor
export workflows remain separate work.
Six numeric owners now cover Day, Discount %, GST %, two code-range variants
and document-number ranges with five context-local DataWindow bindings.
Their original integer/null and percentage/zero defaults, decimal returns,
inclusive percentage limits, discount-only spinner and Boolean ordering
branches remain intact. Day explicitly binds its header-band text despite
freeform processing, with negative tests for missing/wrong-band declarations.
Range captions keep their original DOM identities beside the matching fields
through repaint. Hidden unused dates are not newly validated; ranges are not
reordered. Invalid drafts and vetoes stay correctable, no-row percentage
returns retain failure status, and Cancel/title-bar close cannot reuse success.
The first numeric browser run passed all 1,908 in-page assertions and real
input checks, then exposed a fixture assumption equating plain Tab focus with
the model's current column. It now checks the actual focused field node without
changing runtime focus semantics. Both prior mapping failures and that browser
failure remain separate from the passing snapshots.
The new zone/date/top-customer dialog reuses its external source Zone label,
preserves selector/date/count order, and accepts both buffers before original
validation. Invalid zone/count drafts remain correctable; untouched null zones
still return zero and the default count remains twenty. The customer-reference
chooser keeps codes 1-4 and -1 cancellation, including title-bar closing after
a prior positive return. Its live source field label names the untitled modal
across redraws, and Close no longer shares space with the data. Real Tab order
and modal wrap pass at each appearance size. These additions bring the registry
to 53 modals (forty criteria), 47 global DataWindows (27 criteria) and 82 entry
layouts, not accepted workflows. The item-selection top-N owner now retains its
selector ancestors, source group captions, sorted native selected list, All
option, date/count buffers and exact return keys/flags. Its one-row search grid
has an explicit context-local form presentation without changing source processing
metadata or header identities. Sort resets the current row without focus events,
so the original removal routine deletes its temporary null row rather than an item.
The count guard does not validate the intentionally cleared search form.
Failed all-items DataStore retrieval shows explicit database feedback and cannot
return success; title-bar cancellation cannot reuse a previous successful result.
The focused fixture preserves GetSQLSelect-dependent procedure routing with strict
synthetic outputs, and verifies add/remove/re-add, All, validation, dates and
each retrieval failure stage. Calling report/invoice flows, document output and
native acceptance remain open.
Specified date, date-only and start/end date owners now retain every inherited
control, including the empty hidden customer buffer and source-specific date
visibility. Their original preference branch, today override and midnight/end-
of-day defaults remain intact. Native datetime GetData reuses strict numeric-
mask parsing instead of JavaScript rollover; invalid calendars/clocks cannot
replace a draft or destination. Scoped preflight guards validate all consumed
dates before either return field is written. Correctable input has focused
feedback, `aria-invalid`, a themed error border and a forced-color dashed border;
successful conversion clears stale invalid state. No date-range ordering rule
or source-absent Escape shortcut is invented. Title-bar closing cannot reuse
an earlier successful return.
Shared native KeyDown dispatch now reaches original Enter/Handle/Send routines.
Plain-control Send skips CSS-hidden and disabled fields and follows positive-
then-zero tab order. Source Enter navigation cannot also activate a default
button. Both-mode checks cover hidden/disabled navigation and default collisions;
real typing covers rejection, correction, one acceptance and explicit Cancel.
Historical native-date failures remain separate: hidden/disabled Letter fixture
focus, important-border precedence and missing native key dispatch/navigation.
The final source-matched run resolves all three; calendar-popup workflows and
full native mask equivalence remain open.
The due-date fixture exposed regional parsing beneath
an explicit numeric date mask. Shared initial editor text and conversion now use
the mask's order; unchanged date-only edits preserve stored time. Invalid dates
and live mask changes retain unapplied drafts. Other temporal mask grammars keep
their previous regional editor behavior and still need native equivalence work.
A complete-run failure exposed a taller summary replacing the short Ready
status after Tab, clipping the focused calculator action. Repaint now preserves
visible sibling focus within the same mapped window without undoing deliberate
scrolling. The deterministic regression and eight corrected keyboard repetitions
pass; failed-run diagnostics remain separate from final evidence.
The browser fixtures had no page errors, backend/external requests or native
desktop access. Lowest measured text contrast is 5.959:1, including required
guidance. Separately, 22
synthetic literal expressions ran in the isolated original DataWindow engine
and resolve the mixed Date/date-time-mask gap without changing its source
formula or mask. This is not packaged/native UI acceptance.
The preceding static-list expansion remains in
`criteria-followup-full-results\result.json`; the older
`criteria-verification.json` describes only its own earlier source slice.
CI, packaged/native, hardware and production acceptance remain outstanding.
The chronological authoring notes below retain their original counts and
verification deferral; these current results supersede their "unrun" statements.
New shared validation, required/null
handling, typed temporal input, text limits, source-directed focus, external-blur
draft retention and visible DBError behavior have synthetic frontend/browser
coverage, not complete production acceptance.
Original aging validation and New/Delete/Save fixtures now include a strict
in-memory SQL call recorder; they do not establish database persistence.
The radio focus-ring correction now passes. Real pointer tracing also found
duplicate Modern checkbox activation: one click could commit twice and undo
itself. The shared renderer now owns the single click route; browser cases
assert exact changes for native/semantic Space and repeated field/marker
clicks. Removing the form scroll margin from grid keyboard targets fixes
full-width cell clipping at 320px/200%. Appearance changes retain unaccepted
uppercase drafts without storing them.
The shared click route honors live TabSequence overrides. Redraw restores
multiline focus without scrolling ancestors; active typing reveals the field
after repaint so browser caret scrolling cannot leave half of it offscreen.
Genuine form text-editor and radio-option focus use post-paint reveal; radio
focus reveals its whole label. Grid/dropdown/checkbox focus does not request extra
redraws. Paused-paint regressions exposed a stale grid-focus snapshot:
the renderer now reads focus immediately before DOM replacement and preserves
both newer cell focus and focus outside the DataWindow.

Four transaction calculator dialogs now use context-local Modern forms:
`w_discountcalculator`, `w_pricecalculator`, `w_qty_rate_value_calculator`
and `w_set_flatdiscamt`. All 28 source field/calculation bindings, original controls, financial scripts,
precision helpers and OK/Cancel return channels remain intact. Quantity form
groups preserve exact membership and source decoration/visibility semantics.
Strict synthetic query recorders reject unexpected SQL and all writes.
Preview cleanup restores the live state captured at each activation, rather
than deleting later fixtures' event routes. Sixteen calculator appearance/input
cases cover light/100%, dark/200%, narrow reflow and visible keyboard focus.
Guarded native radio groups preserve source keys, hidden fields and original
discount validation. They retain rejected drafts, avoid duplicate acceptance and
keep pointer/Tab/Arrow/Escape transitions consistent. Classic backward navigation
honors source-revealed fields; Modern radio glyphs scale with text and use themed
focus outlines. Passive radio repaint preserves deliberate scrolling.
Coverage is now twenty modal mappings, forty-seven global DataWindow mappings and
82 entry mappings, not complete sales/purchase/cashier workflows. Unsupported
radio variants, full editable transaction lookup layouts and other transaction/grouped bands remain
separate implementation work.

Six reviewed transaction grids now render source-computed summary/footer
totals: invoice bank/cash payment and receipt details, cash denominations and
associated advance-sale invoices. Every field/label/compute has an explicit
binding; hidden keys remain hidden. The original evaluator and formatter own
the calculations. Synthetic checks cover validation, accepted/rejected drafts,
empty/zero-height bands, independent label/value visibility, filtering,
deletion, 1,000-row totals, readonly focus and Classic print isolation.
Horizontal scrolling no longer displaces totals outside their viewport.
Short panes release sticky footers; source column selection returns from a
total to the actual row even when that row was offscreen. Thirty appearance
cases cover both scroll axes, whole-editor visibility, retained draft/caret/
GetText state and light/100% or dark/200% including 320px widths and 220px heights.
Complete voucher posting, cashier settlement, remaining bands and dynamic
band-height/computed-expression replacement are not claimed complete.

The associated-invoice modal now opens through the real runtime with its
recovered parameter structure and a synthetic shared caller buffer. Original
validation, invoice-total reads, modify-mode exclusion, duplicate correction,
Cancel/OK returns and Ctrl+I/Ctrl+D/Enter run in both presentations. Strict
recorders accept only five translated SELECT statements, retain separate
caller/sqlca transaction ownership, and reject writes or unexpected access.
Real modal actions also cover two-stage Escape and single Enter activation.
Shared fixes restore non-editor DataWindow key routing and Classic cancellation
focus, normalize TriggerEvent/PostEvent enum names, prevent duplicate native
button activation, and distinguish untouched deleted rows from genuinely
changed drafts requiring recovery. No original-app interaction occurred.

Cashier closing retains source order, conditional figures, lookup keys,
denomination initialization and closed-shift protection. Six mapped horizontal
rules keep their original visibility. Existing offline bytecode evidence
disproves three unconditional closing returns; scoped production corrections
remove them. Both DataWindow updates retain original/dirty snapshots so failed
cash writes cannot make a later retry omit the rolled-back detail update.
The strict synthetic transport checks exact query/parameter contracts, source
optimistic predicates, separate server-date transactions and rollback/retry.
Its authorization boundary is a synthetic result, not an exercised login.

The closing fixture has 72 both-mode assertions and eight appearance cases.
Source-driven repaint no longer swallows Modern text-cell activation. The shared
editor consumes its first Escape before removing the input; an unconsumed
second Escape reaches native Cancel only after any source key handler permits
it. Deferred-result cases preserve source rejection and changed focus.
The complete shared regression passes in `presentation-selectors-shared-final`.
No original app, database, native desktop or hardware was accessed; upstream
shift creation, cashier-job supervision and production settlement remain open.

Multiple-invoice cash tendering now retains its original document grid, signed
total, payment fields, three actions and hidden Classic print companion. Explicit
auxiliary bindings cannot omit, duplicate or silently reinterpret controls.
The 101-assertion fixture runs original sale/return lookup, duplicate/unavailable
document rejection, tender validation, balance calculations, per-document
supervision, Print selection, Cancel and keep-open preferences. Native ProcCaller
uses the built production signature against strict synthetic SQL/RPC results.
Failure after the first document does not undo its commit; the original
keep-open `Y` preference also resets failed entry buffers. Neither behavior is
represented as atomic saving or complete recovery.

Offline bytecode confirmed a shared FOR counter defect that skipped
single-document Print. The interpreter now stores the incremented counter before
the terminal comparison, while preserving Exit/Return behavior. Shared
pointer/Tab/Modern grid navigation also honors RowFocusChanging before selecting
another row, with guards for delayed rejection, replacement records, selection,
lifetime and newer external focus. Original Ctrl+I/Ctrl+D/Enter/Escape and the
last-blank-row veto run in both modes. Eight sale/return appearance cases cover
light/100%, dark/200% and narrow viewports; the final shared run includes
the real-pointer veto check. No printer, database, native app or hardware
was used. ModuleID >100 insertion and full production settlement remain open.

Category changes retain all nine source fields, account/group restrictions,
conditional protection and actual tender/charged/change amounts. The synthetic
fixture's 112 assertions execute original source and production SQL/RPC signatures with distinct
`sqlca` and owned transaction boundaries. Scoped reliability guards reject
pending/invalid input and failed data/permission loads; dirty/original snapshots
survive failed updates and commits. Failed Open always returns -1 rather than
reusing the caller's row ID as an acceptance sentinel. A lost commit acknowledgment
retains edits and warns to check the document before retrying, without automatic
reposting. These error-path changes are intentional rebuild hardening, not
claimed decompiler corrections.
Zero tender, fractional change and unchanged read-only saving are explicitly
covered without inventing a database write or a supervision call.

Joined account/subaccount SQL `name` columns now map by source position instead
of overwriting customer names. Unique reordered and partial named results retain
their intended mapping. Repaint keeps previously visible focused fields in view
after reflow while preserving deliberate scrolling away. Eight category cash/
credit appearance cases exercise real Enter, account selection and staged Escape.
The harness now registers production Handle/Send, and its native-field fixture
uses explicit registry bindings rather than guessing custom-control ancestry.
Full cashier monitor/job workflows, alternate insertion, native/database
acceptance and Modern printing remain unfinished.

The shared editable DDDW slice adds optional/required Manufacturer criteria
(`d_arg_manf`, `d_arg_manf2`) in both presentations. Draft display text and
numeric keys stay separate through GetText/SetText, EditChanged, validation,
duplicate-row selection and source key/Enter continuations. IME and stale
configuration retain their drafts. Classic's asynchronous repaint restores
an open popup without reclaiming external focus. Source `initial="Null"` now
initializes numeric fields as null, not NaN. Separate owned preview controls
keep the complete scaled input/toggle inside narrow viewports. The selected
sale search routine uses synthetic rows; no sale/purchase transaction is
accepted by this fixture. Focus-open ShowList and the concrete editable DDLB/
left-caption checkbox variants are covered by the later shared slice below;
full inline lookup layouts and packaged-device popup performance remain open.

DataWindow ShowList opens on field focus and suppresses its arrow, not a
permanently expanded list. The source catalog has 206 DDDW and 19 DDLB
focus-open field occurrences, and no recovered HSplitScroll=yes. Shared
readonly/editable popups preserve original keys, key vetoes, rejected drafts,
IME, retry and external focus. Actual Generic Item Type detail browsing works
from the new combobox editor; pending source SetText corrections can commit
unmatched valid values without a false post-write error.

Five further global mappings cover Generic Item Type and margin criteria,
the thirteen-field purchase-change grid, Customer Category and Stock Ledger
Inputs. The one recovered editable DDLB maps Page Size labels to F/H/Q and
retains freeform/schema/null validation. All four left-caption checkboxes keep
source Y/N values, wrapped captions, native focus, rejection and one activation
per pointer/Space action. Grid status text remains visible during horizontal
navigation. Twelve automatic and twenty-eight selector-variant appearances extend
the shared evidence. Email Subject remains a fixture-only mapping. These
fixtures execute no maintenance, permission changes or invoice persistence.
Readonly non-ShowList DDDWs with explicit PercentWidth or positive Lines use the controlled
popup too. They stay collapsed on focus, preserve keys versus labels and child
buffers/cursors, and retain pending SetText keys if the source binding changes
before or after repaint. Toggle and detail actions remain separate.
Positive source line counts use measured font/row geometry, wrapped labels
and viewport-aware height/placement. Page Up/Down follows the visible page
instead of a fixed ten rows. Options remain the same DOM nodes through
nearby navigation and source-driven redraws; a 10,000-choice fixture verifies
bounded live/cached nodes and reuse. The source five-line purchase
type retains a local readonly cursor even without an explicit width.
Manufacturer appearances cover its seven-line budget with 1,004 synthetic choices,
200% text, 320px width and 220px height. The focused selector/contact run passes
840 assertions and 45 appearances. Native zero/default sizing, scrollbar/input
properties, complete inline layouts and assistive-technology acceptance remain open.

Above 100 choices, shared popups render the visible range, eight overscan rows
on each side and at most one pinned active option. Measured variable-height
prefixes retain wrapping and scroll anchors; font/width changes remeasure
without losing input focus or a draft. The complete choice data and numeric
height arrays remain O(N), while offscreen option nodes are evicted.
Home/End, measured paging, full-set/repeated-letter search and duplicate labels
retain original indices and guarded acceptance. Manual scrolling does not
change the parent value or source cursor. Real editable Manufacturer and
readonly Customer Segment fixtures separately check their child-cursor rules.
The final isolated 10,000-choice probe retains 12-16 option nodes in its three
scenarios instead of 10,000; local single-run opening measurements improve
from 155.3-181.2ms to 2.0-9.5ms, not a packaged-device performance guarantee.
Final evidence in `lookup-window-verification.json` matches all 63 built
modules and 21 copied fixtures to source and retains 86 source/test hashes.
Empty/one/100/101-choice boundaries, replacement lists, live reflow, pinned
active descendants and distant selection pass without inventing a selection
or changing the original source validation.

The purchase due-date formatting gap is resolved with 22 synthetic literal
observations from the original DataWindow engine. Missing time displays
`??:??`; the Date result, invoice timestamp, recovered formula and mask are
unchanged. Question-mark outputs are no longer silently skipped by the format
comparator. This isolated native engine probe is separate from the browser
fixture and involved no ERP launch, Retrieve/Connect, records, backups or
licensing changes. See `rebuild/docs/FIDELITY.md` for hashes and limitations.

Another 43 standard Code/Name entry windows now have authored Modern outer
layouts and control-local form/list mappings, retaining all 22 inherited
controls and hidden print companions. Shared text editing now implements
Edit.Case, explicit AutoSelect flags and guarded IME completion, without
rewriting stored values on focus. Catalog and both-mode browser regressions,
including eight representative appearance cases, are authored but unrun.
These fixtures omit concrete-window business scripts and real
save/retrieve/print execution; the mapping count is not an acceptance count.

The next authored slice adds shared guarded code-table/lookup editors and the
Contact Group outer/member layout, bringing the entry registry to 45 mappings.
Pending selections survive rejection, repaint and native text replacement;
asynchronous commits reject stale records, configuration or child rows.
Lookup name changes and parent replacement/destruction invalidate owned child
controls. New helper/native and both-mode contact browser fixtures cover
recovered member validation, duplicate correction and ten-field propagation
using synthetic rows. The next slice now adds one reviewed eleven-column
contact lookup browser beside the native select, with loaded-value search,
50-row pages, full selected-row details and tracked keyboard modality.
It excludes hidden fields, preserves the child buffers, cancels on owner
changes and guards stale displayed details/metadata before acceptance.
Unsupported child layouts retain the basic list with an explicit warning.
New generic and integration fixtures cover large synthetic lists, duplicate
names, errors, cancellation and source validation after browsing closes.
Four Lookup appearance cases bring Contact Group's authored matrix to sixteen.
All of this remains unrun. Other selector variants and the Contact Group
open/selection/SQL/save/print workflows remain unaccepted.

The preceding authored slice adds guarded native two-value checkboxes, with
focus/Tab/F2/redraw separated from activation, retained rejected drafts,
original-key GetText/SetText and stale ownership/configuration checks.
Null/unknown stored values remain mixed instead of silently becoming off.
Checklist Item, Shift and Tax Category add three exact contextual form/list
mappings: 46 standard single-entry windows and **48 total entry mappings**.
Inherited controls, hidden print companions, source field order and label
quirks are retained. Helper/metadata and both-mode browser regressions are
authored; 24 new appearance cases bring the single-entry matrix to 32.
None have run. Concrete-window business queries, persistence and printing
remain outside this slice.

Contact Card now adds an exact eleven-field form/list mapping, bringing the
registry to **49 entry mappings** (46 single-entry). All 24 inherited/added
controls and the hidden print companion are retained. Sorted Title/SMS choices
preserve original keys, slash-containing titles and stable duplicate ordering.
The shared multiline editor preserves untouched line endings, CRLF live input,
case/limits, IME, selection/scroll, rejection corrections and copyable stale
drafts in both modes. Enter retains the recovered handler; Shift+Enter is an
intentional new line-entry gesture, not a verified vendor shortcut.

New helper/metadata and both-mode browser fixtures are authored. The actual
account-copy routine uses three whitelisted statements with synthetic
in-memory customer/supplier results; the null-account branch is also covered
in the authored cases. Twelve Contact Card appearance cases add Detail,
Editing and List at light/100% and dark/200% with narrow effective widths.
No new tests, fixture generation, type checks, builds, screenshots or CI ran.
Original runtime collation/escape/keyboard equivalence, real SQL/persistence,
query-failure and full open/save/retrieve/print workflows remain unaccepted.

The next authored slice adds Relation and thirty-two additional master
layouts, retaining source labels, list field order and `GetRow()` serial numbers
where present. The entry registry now has 82 authored mappings (79
single-entry). Corrective inspection found that several new list declarations
used export-array order instead of source horizontal positions. Those orders,
Resource Category's missing multiline declaration and Grade's rejected decimal
spinner are corrected. Independent source-position checks and metadata
assertions pass. Decimal drafts use exact arithmetic and safe integer
configuration; existing Enter routing is preserved.

Single-entry fixtures now seed/edit every additional mapped field, assert
computed serials and source mnemonics, and add Resource Category/Grade cases
(48 authored single-entry appearance cases). Strip-only constructor and strict
keyboard-event typing failures are repaired. The browser run exposed an
unstubbed replacement contact-child retrieval; it now uses explicit synthetic
rows, and fixtures reject leaked dialogs. Classic redraw preserves invalid-state
semantics; Contact Card fixtures use real Handle/Send navigation. The complete
synthetic browser result now passes: 9 component, 8 dialog, 8 aging-entry,
48 single-entry, 16 Contact Group, 12 Contact Card and 4 editable-dropdown
appearance cases. This is not a passing production release gate.

The historical 143 frontend tests / 518 browser assertions describe the prior
dropdown baseline only. Accepted production Modern workflows and verified
Modern print templates remain **zero**. Remaining screen families, all-role
acceptance, printing, packaged Windows checks and hardware remain open.
No repository was pushed and the live installation was not modified.
Details: `rebuild/docs/UI-ENHANCEMENT.md`.

Last update: 2026-11-02 (second pass). The Rust/Tauri conversion **has started** in the private repository `jerryboganda/abuzar-rebuild` (local folder `rebuild/`, own git; never push this folder's public `origin`). Its generated status is `rebuild/docs/PARITY.md`.

## Correction found while running the rebuild (important)
The first export followed only the controls and menu items that an object **declares itself** (field attribute 0x8c). Inherited controls and menu items that a *descendant* extends or customises (attribute 0x9c) were silently missing. Closed on 2026-11-02:
- `re-tools/pcode_export.py` (`has_own` / `defined_events`) and `re-tools/obj_export.py` now follow inherited nodes; `re-tools/diff_inherited.py` keeps only what the descendant changed; `re-tools/menu_export.py` exports the complete item tree of every menu (156 menus, `recovered/menu_trees/`).
- Result: **37,895 routines** (was 28,140: +9,755 menu-item and inherited-control scripts), 37,792 with a script body, **all 37,792 parse** (720,096 lines); object definitions now include overrides such as `dw_control.dataobject` of the `w_arg_*` windows (previously absent) and the item additions of descendant menus (e.g. `m_single_entry.m_file.m_save`).
- The previous "0 flagged / 100%" claims referred to the routines that had been exported, not to everything that exists. The old export is kept as `recovered/*_v1`.

## Reverse engineering - done
| Area | Result | Where |
|---|---|---|
| Database schema | 761 tables, 10,882 columns, 1,730 FKs, 81 indexes, 642 procedures, 74 functions, 36 views, 10 triggers; FK cascade rules: none exist (scripts contain none); identity seed/increment (1,1) verified; 86 FKs were created WITH NOCHECK; 2 legacy procedures do not compile on SQL Server 2025 (obsolete `DUMP`, missing column) | `db/` |
| DataWindows | 8,748 as PowerBuilder source, plus JSON | `recovered/datawindows*/` |
| Windows / menus / user objects | 2,834 definitions (properties, controls, instance variables). Menu captions and item properties are *assigned in the `create` scripts*, not stored as properties | `recovered/objects/`, `recovered/scripts/` |
| PowerScript | 37,895 routines in 2,780 objects (720k lines; call modifiers post / dynamic / event and event flags are kept), 7,450 embedded SQL statements; 0 unresolved global-function / shared-variable / member names; a few `goto` left (valid code, not structured); 6 SQL statements with inferred bind positions (`/* bind positions inferred */`) | `recovered/scripts/` |
| Global-function names | recovered from the unlinked class images in the `.pbd` files (`re-tools/raw_protos.py`, `build_fnrefs.py`); checked against argument counts: 0 mismatches | `recovered/pcode/*/*.json` (`fnrefs`) |
| Navigation, catalogs | menus (156), windows, DataWindows, table usage, libraries, inheritance | `docs/data/*.json`, `docs/*.md` |
| UI structure | window/control/font/colour statistics, DataWindow styles | `docs/UI-STRUCTURE.md` |
| External components | 22 DLL / EXE references found in the libraries (kernel32, user32, eztw32, tsclib, qrcodegenlibrary, pb2xls, cl32 (mail), winsock, sysdrv (dongle) ...) | `docs/data/external_libs.json`, `docs/EXTERNAL-COMPONENTS.md` |

## Reverse engineering - not done / limits (be honest about these)
1. **No screenshots of the original application exist.** Running it needs a database it accepts (the vendor `.BAK` files are SQL Server 2000 format and password protected - not touched), a licence/dongle check that must not be bypassed, and a login. Visual parity is therefore based on the recovered coordinates, fonts, colours and DataWindow definitions, not on pixels.
2. Nothing recovered has been *executed* against the real application; decompiled code is verified by structure (stack balance, argument counts against prototypes, table names against the schema: 99.3% of SQL table names match) and by reading, not by running.
3. Event-driven behaviour that exists only at runtime (timers, OLE controls, Windows messages, external DLL behaviour) is documented from its call sites only.
4. SQL bind positions are not stored in the compiled form; they are inferred from the dummy literals (exact for all but 6 statements, which are flagged).
5. Rights seed data is partial: `db/seed/` only holds what the migration scripts inserted.

## Conversion status (rebuild repository)
The authoritative, generated numbers are in `rebuild/docs/PARITY.md`; what the numbers do not cover is in `rebuild/docs/ROADMAP.md`. Summary of 2026-11-02:
- **Corrections to this file's earlier claims**: the crosstab specification (147 DataWindows) and the suppress-repeating-values lists (408) *are* recoverable - they sit in the `extras` section of the DataWindow JSON (`crosstab`, `sparse`) and are used by the rebuild. Seed data: `db/seed/seed_ledger.sql` is complete for the migration chain (translated into `rebuild/db/pg/90_seed.sql`), but the base rows of a new database (first user, base rights) are not in the recovered data; `rebuild/db/pg/95_bootstrap.sql` creates a first administrator instead.
- Verified in CI against PostgreSQL 17 and the real Rust server: schema, 74 functions, 36 views, 642 procedures, 10 triggers apply; DataWindow retrieves, embedded statements, procedures and window opens are executed (numbers in PARITY.md); the Windows desktop shell builds.
- Rebuilt natively (no original code): DataWindow engine incl. crosstab, groups, nested reports, labels, charts, windowed rendering, print preview, page-across printing, SaveAs (csv / text / xlsx / html / xml), Code 39 barcodes, QR codes (the QRCodeGenLibrary.dll call), TSC label printer commands, MDI / menus / controls, file functions through the server.
- Enhancements beyond the original: server API token for LAN use, audit trail of master data, typed procedure calls, windowed rendering of large DataWindows.
- Open (see ROADMAP.md): pixel calibration (no original screenshots), behavioural comparison with real data (no usable database), cross-site data transfer (~85 procedures / ~60 dynamic SQL sites use linked-server names), SQL Server administration procedures (DBCC, jobs - not meaningful on PostgreSQL), fingerprint / scanner hardware, unattended PDF export, argon2 passwords, server-side rights, base rights generated from the menu trees.

## 2026-11-02 (late): fidelity measured on the running original
The rebuild's look was compared with the running original (computer use + Win32): `rebuild/docs/FIDELITY.md`, tools in `rebuild/tools/orig/`.
Done: menu tree of the original dumped (265 entries) and reproduced exactly (CI check); toolbar pictures from PBVM125.dll's own name table; Windows 11 buttons, message boxes,
title bar with the application icon, tab control, status bar; PowerBuilder unit 7/32 x 16/64 px; layout from the real screen size; accelerators; mnemonic underlines.
Crawled 109 windows of the original (screenshots + dialogs + control geometry); the rebuild walks the same menu paths in CI and uploads screens named by the original's command ids.
Open: new-form-on-open of the single entry windows, report windows (first stage fixed), dropdown menu pixel metrics, window height of response windows, data-dependent screens.

## 2026-11-02 (evening): transaction windows open, licence decision
CI run 41476660400 (commit 650415d) green: windows 2047/2062 against the real server, retrieves 8607/8666, embedded 1846/1862, procedures 510/638, browser errors 0. Walk of 80 menu items: every walked window opens (Purchase x3, Credit Sale, Sale Return x4, Quotation, Sale Template, Adjustments now included); Cash Sale needs the retail customer 19 (data fix committed locally, not yet verified in CI).
Owner decision (popup): the rebuild has no licence checks (native `f_islicenseexpire` / `f_getlicinfo`); enhancements deferred (parity only). Root causes and fixes: `rebuild/docs/FIDELITY.md`, memory `abuzar-rust-rebuild.md`.
Open: re-capture of 21 original windows with a 7 s settle (needs the original started and logged in by the user), installer rebuild from the final commit, dropdown menu metrics, response-window height factor, data-dependent screens.

## Correction found while comparing the rebuild with the running original (2026-11-03): for-loop limits
The decompiler printed 793 `for` loops with the loop variable as its own limit (`for li_counter = 1 to li_counter`; 702 of that exact shape): the test of the loop compares the limit with a *widened copy* of the variable (`CNV_INT_TO_LONG`), and `pcode_struct.for_loop` only recognised the bare variable. The real limits (`lds_itemsetting.rowcount()`, `gds_securitywindow.rowcount()` ...) were dropped, so every rights check and every dynamic field layout built in such a loop did not run (Customer Form showed only `Code:`, `Save + Post` was never enabled).
Fixed in `re-tools/pcode_struct.py` (casts are stripped before the comparison); full re-decompile (37,895 routines, 8 min): exactly 793 lines changed, nothing else; `recovered/scripts` and `rebuild/data/src/scripts` carry the corrected loops.

### Second decompiler correction (2026-11-03): initial values of local variables
A local declared with an initial value (`boolean lb_check1 = true`, `char lc = "N"`, `string ls_showrows = "N"`, `long ll = -1`, `double ld_defaultqty = 1.0`) lost it: the value sits in the 4-byte field after the name offset of the 20-byte local record (`slot` of `pcode_blocks._find_locals`): inline for integer / long / unsigned / boolean (low byte) / char (low byte = character code), an offset into the reference table for strings and doubles. `decomp_obj.local_init` now prints them (strings of secret-looking names are skipped). Full re-decompile: 3,007 declarations gained their value (integer 1098, boolean 743, long 607, unsignedinteger 242, string 219, char 54, unsignedlong 31, double 13), nothing else changed. Not decoded: decimal / real / date / time initialisers (none found with a non-zero value).
Also: the compiled `for` re-evaluates its limit on every pass (the test block holds the whole limit expression) - the interpreter now does the same.

### Third decompiler correction (2026-11-03): by-reference parameters
No routine header carried `ref` (0 of 37,196): the decompiler dropped the modifier, so every value a routine returns through an argument was lost (`w_main.wf_getappname(ref string as_appname)` left the title without the application name; `wf_getserverdatetime(ref datetime ..., ref string ...)` left the entry windows' date at 1900). The type word of an argument in the local record carries 0x80 for `ref`. `decomp_obj` prints it (1,316 parameters in 571 files changed, nothing else); the interpreter passes references for them, also for calls through a receiver (`obj.wf_x(ref ...)`) and hands member / element arguments in with their current value.

### State at the end of 2026-11-03 session
CI run 41533191290 (commit 275f629) green: windows 2044/2062 against the real server, DataWindow retrieves 8,616/8,666, embedded statements 1,847/1,862, procedures 510/638, browser errors 0, 75 menu items walked and every one opens a window. Installer `Trader build-5` (release.yml, commit db127bd). Compared with the running original (21 windows at 7 s settle): Customer Form, Cash Sale Return, Purchase Return, Pack Purchase, Quotation, Users, Supplier, Manufacturer, Tax Category now match; open: Customer form scroll bar, grid totals offset by a few px, item-list popup of the entry windows (other writer), data-dependent screens, the original must be started again for further captures.
Decompiler corrections this session: for-loop limits (793), local initial values (3,007), ref parameters (1,316), array initialisers (5 routines). Runtime: two-subscript arrays, re-evaluated for limits, ref semantics for script calls.

### Final slice (2026-11-03, rebuild commit da8823d)
CI run 41539599920 green (e2e job rerun once: the first attempt stalled on one response window on the runner, the rerun was clean): windows 2046/2062 against the real server, DataWindow retrieves 8,616/8,666, embedded statements 1,847/1,862, procedures 510/638, browser sample 51/52 with 0 browser errors, installer rebuilt from the same code.
Fixed: `w_goodscompany_form` export gap (dataobject of dw_list / dw_detail), ListView control (items, pictures, GetItem, click), InsertRow item-focus emulation without keyboard theft, tests (26 pass).
The remaining 16 windows of the headless run need open arguments from a parent window (same behaviour as the original opened bare). Open, blocked on the original being started and logged in by the user: side-by-side comparison of the rest of the windows, data-dependent screens and reports, hardware items; enhancements deferred (parity only, user decision).

### Original running again (2026-11-03, later): side-by-side crawl and fixes (rebuild commits 824caf0 .. 869d3a7)
The original was started and logged in by the user; `crawl.ps1 open ids_all.txt <dir> 7000` captured 44 windows (18 more produced a dialog or no frame). Compared with the CI screenshots: fixed the initial dates from `string(datetime)` (default expiry 12/12/2030), edit-mask date display, `<None>` null row of drop-downs, left-aligned drop-down text, City / County / Post Code order (tie order of InterfaceSetting), the fixed purchase / sale / adjustment / notes categories as first-run rows, GetFocus / LoseFocus and the keyboard in the current cell when a window comes up (Cash Sale and Refused Sale show the item list, the Purchase Order does not), `DataWindow.Objects` (quantity precision of the installation: `1` instead of `1.0000`, 78 windows). Verified in CI screenshots against the original: Customer form order, Sale Promotion, Opening Purchase category / expiry, Adjustment Increase, Cash Sale popup, Purchase Order without popup, quantity precision.
CI run 41563063841 (commit 869d3a7) green: windows 2046/2062, retrieves 8616/8666, embedded statements 1847/1862, procedures 510/638, DataWindow expressions evaluated with synthetic rows 8748/8748 (new CI step), browser sample 51/52, 0 browser errors. The browser step stalled on one window in 3 of 8 runs since da8823d (a debugger stack and per-window timings are logged now); every rerun was clean.
Open: Purchase Order grid shows no `Min Qty` / `Required (Loose)` (InterfaceSetting says visible); the original's initial focus ring / selected text in more windows; 22 windows of the crawl not paired (dialogs); data-dependent screens. **Installer of the latest code not built: the Windows runner refuses to start (`recent account payments have failed or your spending limit needs to be increased`); release `Trader build-6` (commit b4a555d) is the newest installer.**

### Engine oracle and grid layout (2026-11-03, rebuild commit 01ef1f0; not yet in a CI run)
The research folder can now drive the original's own DataWindow engine (`re-tools/dw_oracle`). With it: grid layout (a column switched on is appended behind the last visible one, in call order: Purchase Order columns follow the InterfaceSetting sequence), 3,109 format cases (3,092 agree) and 290 expression cases (278 agree) compared; formatter, date order and expression fixes in the rebuild. Local checks only (unit tests 29, headless smoke 2046/2062, DW expression sweep 8748/8748) because GitHub Actions refuses to start jobs (billing / spending limit); the last CI run is 41563063841 on 869d3a7. Open: the 16 windows after `Modify Last Transaction Date` of the crawl (the original crashed there), installer `Trader build-6` is the newest, data-dependent screens and reports, hardware.

### Exporter zero-value gap (2026-11-03)
`obj_export.py` skipped every property whose raw value was zero, so explicit `visible = false` / `enabled = false` of inherited controls were lost: the argument windows of the reports showed their date fields although the original hides them (found with the Group Wise Header Setting dialog). Fixed in `obj_export.py` and `diff_inherited.py` (zeros of inherited nodes are kept in the raw export, pruned against the ancestor; only `visible`, `enabled`, `border` keep a zero); all 2,830 objects re-exported (`recovered/objects`, previous export in `recovered/objects_v3`). Effect: 1,229 controls hidden and 65 disabled as in the original; local checks unchanged (smoke 2046 / 2062, 8748 / 8748 expression sweep).
Second exporter gap (2026-11-03): string properties were read with a fixed 2,000-character read from their pointer; a short string at the end of a mapped page made the read fail and came out empty (64 texts, 57 font faces, 12 data objects, 6 titles, 3 masks, 2 tips; e.g. both DataWindows of the goods company form). `obj_export.py` / `pbvm_host.py` now fall back to a read up to the terminator; objects re-exported (`recovered/objects6_raw`, pruned `recovered/objects`).

Failing DataWindow retrieves (2026-11-03): all 50 of the CI sweep classified against the live SQL Server database of the deployment (metadata only). 15 linked-server pass-throughs, 20 statements the original itself cannot bind (missing columns/tables, typo aliases, ambiguity), 2 `ORDER BY :arg` (SQL Server Msg 1008 too), 10 sweep artefacts, 3 features without a PostgreSQL counterpart; no translator defect. Details in rebuild/docs/FIDELITY.md.
Failing procedures (2026-11-03): 122 of the 128 failing procedures classified from their T-SQL: 113 cross-database / system catalogue / dynamic SQL by design, 4 failing in the original too, 1 sweep artefact, 3 OLE/OBJECT_ID, and 1 real translator defect (sp_salesman_collectionplan: DROP of a temp table an open cursor reads) fixed in rebuild tools/tsql/tstmt.py. See rebuild/docs/FIDELITY.md.

### Classic/Modern UI enhancement: opt-in runtime foundation

The user approved a phased UI/UX enhancement while retaining Classic, one shared
business engine, per-user local appearance settings, and independent screen/print
choices. This supersedes "enhancements deferred" for this UI/UX work only.
See `rebuild/PRODUCT.md` and `rebuild/docs/UI-ENHANCEMENT.md`.

Created an allowlisted static metadata inventory tool and a standalone synthetic
all-role design prototype (`rebuild/web/prototypes/modern`). The inventory selects
8,740 indexed DataWindows from 8,748 bundle entries (eight unselected/shadowed
definitions), records 2,062 windows and 32,730 inherited control paths, and flags
five missing static DataWindow references. These are not verified Modern screen
counts or a complete runtime/document coverage denominator.

Added a metadata-only AST inventory of redacted scripts: 2,780 files, 37,792
parsed routines and 53,976 relevant sites. It identifies 3,975 window-open
candidates (426 unresolved), 3,809 Dataobject assignments (1,088 locally
declared DataStore receivers, five clears, 840 unresolved targets), and 529
output calls. It does not execute scripts, expose source text or establish
runtime reachability/role coverage.

The user then directed autonomous implementation after the prototype. Added an
opt-in post-login host (`?app=1&presentation=1`), typed shared host calls,
characterized DataWindow commit/validation, versioned local scoped preferences,
retained tabs, live menu-command search and Modern message/prompt dialogs.
Existing response windows use native modal containers while retaining their
runtime/DOM instances, nested focus/activation and CloseQuery return behavior.
Normal startup remains Classic. Modern theme/text settings apply to the shell
and explicitly mapped components, not unmapped compatibility controls or
Classic printing. Documented direction:
`rebuild/DESIGN.md`.

Added seven explicit Modern DataWindow component pilots: aging interval form/list/detail,
contact group form/list, summary account list and date argument. They reuse the
shared model, formatting and edit/validation path. Draft/error/selection
retention, guarded commits, synchronous AcceptText ownership, definition
load/clear notifications and bounded 10,000-row grid rendering are covered.
Unmapped/changed layouts retain Classic instead of dropping objects. This is
not complete business-window or workflow migration.
The detail grid reuses serial/comparison expressions, keeps calculated cells
readonly and preserves the hidden key. Presentation navigation is separate from
the data column; explicit SetColumn overrides it without new business events.
Insertion/deletion, rejected limit edits, print isolation and narrow keyboard
focus visibility are covered. Modern numeric steppers now honor bounds and
increments, retain drafts until shared validation accepts them, preserve grouped
input and existing key notifications, and guard runtime changes/model replacement.
Real pointer/keyboard checks cover repeated steps and advancing to the next row.
Full aging-window duplicate/save rules, other spin variants and Classic/native
stepping parity remain open.

Five native-control response dialogs now have complete Modern layouts:
`w_arg_amount`, `w_arg_decimal_val`, `w_arg_integer_val`, `w_arg_noofsiblings` and
`w_printer_copies`. They retain original controls/scripts, validation, dynamic
bindings, CloseQuery and numeric return channels. Untitled modals are named by
their original field labels. Changed/unsupported structures retain every control
in Classic. The shared `ue_keydown` alias/native-event parity gap remains open.

Form-tab clicks in both presentations now wait for active/pending DataWindow
validation and the original unsaved-change guard rather than skipping them.
Rejected fields retain their page and Modern draft. Pointer activation does not
blur/revalidate a rejected entry or override script-directed focus. Cancel and
failed-commit decisions retain the current page; accepted selections dispatch
once. Modern adds keyboard navigation,
paired tab/panel semantics, live labels/state and focus recovery from hidden
panels. The recovered entry-window confirmation scripts run against synthetic
save/list outcomes; this is not database-save or whole-window acceptance.
Programmatic tab selection and initial/native event parity remain open.

The shared editor now dispatches ordered EditChanged while typing and owns live
GetText/SetText by model, row object and column. Recovered scripts enable Save
and drive ascending-text Find/Detail availability. Script-corrected rejection,
focus preservation, input-message blur safety, failure/correction and queued
cancellation on close are covered in both presentations. Native busy acceptance
fails conservatively; no-active-editor/DataStore text behavior, other Find
branches, native reentrancy and complete entry-window acceptance remain open.
Cancellation does not abort an already running source routine.

The aging-entry outer layout now reflows all 23 inherited control paths,
including original sort/filter groups, context-only Find, instructions and
hidden auxiliaries. Structural mismatches retain the whole Classic layout.
Recovered filter/unfilter and ascending-sort scripts run on synthetic rows;
native dropdown selection/SelectItem now synchronize Text, and radio groups
are isolated across retained windows. Editable dropdowns now accept freeform
criteria without inventing selection events, and deliver Modified at edit
completion. Keyboard/pointer choices, dynamic state/focus, text/list mutation,
source-driven filter-column population, error reporting and queued-event cleanup
are covered in both modes. This is not an accepted full workflow: exact native
message/locale semantics, other list families and database validation/save remain open.

Local evidence: 9 inventory tests, 143 frontend tests, strict presentation/main
type checking, 117 standalone-prototype assertions, and 518 actual-runtime
browser assertions using synthetic data, seven mapped definitions plus Find
metadata, five reviewed response-dialog scripts and inherited tab/input/Find/filter/sort
routines in both presentations.
Additional browser checks cover four workspace viewports, explicit settings
labels, dialog/grid/entry keyboard behavior, nine component, eight dialog, eight entry and four editable-dropdown
theme/density/reflow cases, including 200% text and narrow effective widths.
Measured component/window text contrast,
including inputs, popup choices and selected rows, passes 4.5:1 in every case (minimum observed 6.18:1).
A blocking presentation CI job and synthetic evidence uploads are prepared but
have not run remotely for these changes.

**Still open:** runtime/role/caller baseline, remaining shared-event
characterization, Modern control/form/grid migration, the production all-role
pilot, every verified Modern business screen/template, full accessibility and
packaged Windows acceptance, and actual printer/scanner verification.
Compatibility views do not count as Modern coverage; Modern print is disabled.
Native title-bar theming is now wired through the official Tauri API with a
main-window-only theme permission, ordered requests and explicit failure/retry.
Classic restores Light; Modern System restores native system following. The
bridge is unit/mocked-browser verified, not packaged/Windows verified.

Production source files changed, but no live database, running original app,
installed app or printer was changed. No commits, pushes, releases or deployments
were performed by this UI enhancement work.

## 2026-11-08 UI enhancement: generated Modern layouts (local only, nothing pushed)
In `rebuild/` (own repo, uncommitted): 1,958 of 2,062 windows now have a Modern layout (170 reviewed, 1,788 generated from `data/src`
by `web/tools/derive-*.ts`); 3,206 of 8,740 DataWindows have a surface. Non-browser checks pass (813 frontend tests, types, 9 inventory
tests, 72-module build). No browser run exists for this tree; one consolidated pass is prepared (see `rebuild/docs/UI-ENHANCEMENT.md`).
