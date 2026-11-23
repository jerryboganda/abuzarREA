# Agent handoff — classic Waseela app (PowerBuilder 12.5), session 2026-11-23

Read first: `CLAUDE.md`, `PROJECT-MEMORY.md` (git-ignored; holds the app login), `deploy\FIX-LOG-2026-11-23.md`
(every fix + verification + rollback), `deploy\SAVE-POST-TEST-2026-11-23.md` (save/post test log, just started).
Never push this repo (`origin` is public). Never put the app login in tracked files.

## ⚠ Current live state you must know
- **FBR sending is BLOCKED right now** (for the save/post test, owner's choice):
  - `SoftwarePreferences` PrefID 805 `AutoFiscalizeOnPosting` = 'N'/'No' (original 'Y'/'Yes')
  - listener `C:\Projects\Abuzar\FiscalizationApp\fiscalizationapp.exe` (port 9111) stopped
  - scheduled task `Waseela Fiscalization Listener` **Disabled** (original: Ready/enabled)
  - Restore when testing ends:
    ```powershell
    sqlcmd -S .\SQLEXPRESS2022 -E -C -d FazalDinPP19DataBaseV2 -Q "update SoftwarePreferences set PrefValue='Y', PrefValue2='Yes' where PrefID=805"
    Enable-ScheduledTask -TaskName 'Waseela Fiscalization Listener'; Start-ScheduledTask -TaskName 'Waseela Fiscalization Listener'
    ```
    then restart the app (preferences load at login) and confirm 9111 is listening.
- App running: `deploy\Application\abuzar.exe`, logged in as ADMIN (restarted 04:05 after the FBR change).
- XE trace session `waseela_walk_errors` was dropped (cleanup done).

## Environment
- SQL Server 2022 Express `.\SQLEXPRESS2022`, DB `FazalDinPP19DataBaseV2` (compat 160). Old 2008 R2 instance READ_ONLY rollback.
- App folder `C:\Projects\Abuzar\deploy\Application`; vendor originals `C:\Projects\Abuzar\Application`.
- Launch: `deploy\Application\WaseelaLauncher.exe`; auto-login doesn't always fire → `deploy\login.ps1` (owner allows the agent to log in).
- Close app before replacing .pbd: File > Exit (WM_COMMAND 10002) + OK, or CloseMainWindow.
- 32-bit Python `C:\Tools\py32\python.exe` hosts PBVM125/pbdwe125 for exporters (`re-tools\pcode_export.py`, `re-tools\dw_export_all.py`).

## DONE this session (all verified; details in FIX-LOG)
1. App working on SQL 2022; fiscal listener startup script waits for SQL + LAN IP (`deploy\impl\Start-Fiscalization.ps1`, 12 Pester tests pass).
2. Opened every one of 212 menu items (open/close, Ok-with-defaults, cancel/X-close at every dialog) and executed all 8,748 DataWindow queries read-only.
3. Fixes (patched .pbd files, equal-length, re-disassembly/engine re-export + SQL execution + live):
   - 19 null-object crashes on X-closing report format boxes (reportviewer).
   - "All" ticked by default in 355+ report argument windows + ancestor; Cash/Credit default in user-wise discount/commission; category window (reports, reports_cust).
   - 71 "Not a DataWindowChild" cancel paths (reports, reports_cust).
   - Audit Purpose cancel DB error — guard + relocation into unreachable duplicate `case` (reportviewer).
   - ~110 SQL compat fixes: ORDER BY not grouped (94 invoice layouts), UNION ORDER BY, ambiguous columns, typo, `=`→`IN` on list arg, divide-by-zero NULLIF (stockreports, accountreports, salereportscust, sprnt*×5, proformasales, studentcomponents, patientreports, saleorder, purchaseprintouts).
   - Sale Price Difference 97 s → 0.4 s, identical output (itemreports).
   - Preferences backup-schedule query SQL2000→2005+ form (abuzarapp).
   - DB: `deploy\impl\12_restore_hinted_indexes.sql`, `13_itemlog_icode_index.sql`, `14_missing_lookup_indexes.sql` (+ rollbacks).
   - Originals of every patched .pbd: `deploy\Application\_pbd_before_patch_20261123\` (rollback = copy back with app closed).
4. Confirmed not bugs: Advanced Sale sort ('alias' literal works), supplier multicurrency ledgers, supplier batch stock.
5. Docs/memory: FIX-LOG, PROJECT-MEMORY (summary + login), CLAUDE.md rule updated, agent memory `abuzar-classic-pbd-patching.md`.

## Owner decisions (do NOT redo unless asked)
- No VirtualGl index for hidden Customer/Account multicurrency ledgers (keeps postings fast).
- Leave 6 dead DataWindows (d_gene, d_preferences, d_newpreferences1, d_issueform, d_departmentsection, d_userattendance).
- No DB backups wanted for this work.
- Save/post tests go into the **live DB and test entries are kept**; FBR blocked during tests.

## UPDATE (later on 2026-11-23): save/post test mostly done — see `deploy\SAVE-POST-TEST-2026-11-23.md`
Desktop control for `abuzar.exe` was granted (request_access with the exact process name `abuzar.exe`, not "Trader").
Done with **no unexpected DB errors and nothing to patch**: all Purchase screens except Purchase Return (12277/12278/12279 posted, PO 6656), Adjustment Increase/Decrease/Stock Adjustment (buffer), Priority, Lock Batches, Update Item Suppliers, Interface Setting, Preferences (unchanged saves), and every Basic Data master (Customer, Supplier, Item, Item Basic Data, Price Policy, classes, categories, alerts, tax, PCT, templates, …), plus edits of existing records (customer 326, PO 6656) and print preview.
**Blocked on the owner**: every sale/return/quotation/refused-sale/purchase-return save opens the salesman password prompt (w_salesmanpassword; Claude does not type credentials). The Cash Sale draft is left open in the app ready for the owner (File > Save And Post, enter salesman code + password). **FBR must stay off until those sale tests are finished**, then restore it with the commands above, restart the app and confirm 9111 listens. Also left for the owner: Manage > Groups/Users/Group-wise settings and Cashier Job (security/workflow settings), the bulk tools, real printing (Print Spooler is stopped).
The XE session `waseela_walk_errors` is running again — drop it when testing ends.

## (original list) REMAINING toward 100%
1. **Save/post test of every entry screen** (the part still open is the list above). Scope (~45 screens, from the menu walk):
   - Purchase: Purchases, Purchase Return, Opening Purchase, Purchases (Loose), Purchase Orders
   - Sales: Cash Sale, Credit Sale, Cash/Credit Sale Return, Open Cash/Credit Sale Return, Quotation, Refused Sales
   - Basic Data: Customer, Customer Category, Sale Promotion, Customer Sector, Supplier, Supplier Category, Item, Manufacturer, Item Class, Item Category, Generic Item, Item Basic Data, Price Policy, Item Alert, Sales Tax Schedule, PCT Codes, Generic Item Type, Item Thickness, Lock Reason, Category Segment, Manufacturer Type, Sale Template, Tax Category
   - Maintenance: Adjustment Increase/Decrease/Stock Adjustment, Priority Setting, Update Item Suppliers, Lock Item Batches, Interface Setting, Preferences (Save)
   - Manage: Groups, Users, Group Allowed Price, Group Wise Cash Account, Cashier Job, Group Wise Supplier Category
   - Excluded as bulk/destructive unless owner approves: Inplace Initialization, Change Items Price, Change Item Discount, Update Item Basic Data, Change Item Reorder Qty, Import Previous Sales, Modify Sale Invoices, Modify Last Transaction Date, Change Password, Backup Database, Job Schedule, Session Monitor.
   - Use small quantities, label remarks/names "TEST CLAUDE 2026-11-23", record every document number in `deploy\SAVE-POST-TEST-2026-11-23.md`. Watch DB errors (re-create an XE error_reported session filtered on client_app_name LIKE 'Waseela%').
2. **Fix whatever the save/post test finds** (same patch + verify discipline).
3. **Restore FBR** (commands above) and confirm the listener is up.
4. **Not yet tested at all:** printing (print preview/printers), FBR submission end-to-end (needs a real invoice + owner approval), editing existing documents.
5. Optional, not in this shop's menu: 68 windows with their own unticked "All" box.

## Verification tools (session scratchpad — may be wiped; recreate from this description if missing)
`C:\Users\Admin\AppData\Local\Temp\claude\96755286f62fd54f\bfcfc672-8464-4a1e-8d4d-e275e002f168\scratchpad\`
- `patch\`: apply_patches.py (word manifest, old-value check), audit_relocate.py, fix_spd.py, fix_backupschedule.py, dw_obj.py, proplists.py, mclp_default.py, default_checked.py, batch_orderby.py, fix_misc.py, run_fixed_sql.py; `verify\` copies of pcode_export.py with its own liblist.txt.
- `walk\`: walker.py (menu walker; run with plain `python`, env WALK_MODE=cancel / WALK_PICK / WALK_NO_TICK), w32.py, results per run dir.
Techniques and lessons: agent memory `abuzar-classic-pbd-patching.md`.
