# Architecture of the original application ("Waseela" / Trader App v1)

Reverse engineered from the compiled PowerBuilder 12.5 libraries; every statement below was read from `recovered/scripts` (decompiled code), `recovered/objects`, `recovered/datawindows` or `db/`. Where something is inferred it says so.

## 1. Shape
- One Windows client (`abuzar.exe`, PowerBuilder 12.5 p-code, 120 `.pbd` libraries, ~2,060 windows, 156 menus, 460 global functions, 8,748 DataWindows) talking **directly to SQL Server** (OLE DB provider `SQLOLEDB`, login `sa`, `autocommit = false`, lock level `RC`). No application server: the client contains all business logic; the database holds 642 stored procedures, 74 functions, 36 views, 10 triggers.
- Connection settings (server name, database, company) are read at start-up by `af_get_app_setting()` from the local application settings; the company key (`gs_company`) switches behaviour per customer deployment (many `if gs_company = "..."` branches select print layouts and rules).
- The application object is `traderappv1`; globals live in its symbol table (126 entries, `recovered/pcode_names/shared_vars.json`): `sqlca`, `message`, `gl_usercode`, `gl_remotegroup`, `gs_company`, `gds_security`, `gds_securitywindow`, `gds_preferences`, `gds_colpref`, cached item list `gd_itemsinfo` + alphabetic lookup `ga_llookuptable`, etc.

## 2. Layers and inheritance
```
w_entry_primitives
  w_multi_entry        master/detail transaction windows (sale, purchase, vouchers ... ~hundreds)
  w_single_entry       one-table maintenance forms (170 windows use menu m_single_entry)
  w_listview_form / w_popup_forselection / w_arguements ...   lists, pickers, report-argument dialogs
u_transaction          transaction object (sqlca type) + 449 stored-procedure (RPC) declarations of stored procedures
u_dwstandard / u_ds_standard   standard DataWindow control / DataStore with common key handling (`ue_enterkey`, `ue_dwnkey`)
```
- Every transaction window follows the same skeleton (events `ue_new`, `ue_save`, `ue_detail`, `ue_list`, `ue_retrieve`, `ue_first/next/previous/last`, `ue_newform`, `ue_postopen`, `ue_close`; functions `wf_*`). The skeleton is in `w_multi_entry` (+ `w_entry`, `w_single_entry`), so the Rust rebuild can implement it once as a generic "master/detail document" engine and drive each window from its recovered definition and DataWindows.
- Global functions: `f_stringpreferences("Key")` / `f_numberpreferences("Key")` read the `d_general1` preference DataWindow cached in `gds_preferences` (system settings); `f_getgroupcode(user)`; `f_validatedw(dw)` (required-field validation); `f_refreshitemlist()`; the `f_retrieve_report*` family drive the reports; `f_towords*` amount-to-words per currency.

## 3. Data access
- Master/detail windows hold 3-4 DataWindows: `id_master`, `id_detail`, `id_footer`, `id_list` (+ a picker); each is bound to the transaction object with `settransobject` and updated with `update()` inside one explicit transaction (`SQL commit/rollback USING sqlca`).
- Embedded SQL (7,450 statements) and stored procedures (RPC through `u_transaction`) are used for posting, locking, numbering (`gettabmaxkey` on `_TabMaxKey`), stock and ledger maintenance. See `docs/DATA-ACCESS.md` and `docs/data/table_usage.json`.
- DataWindow features used heavily: computed fields, group bands, dynamic `object.<column>[row]` access, `setfilter/sort`, `describe/modify` for run-time layout, `sharedata`, DataWindow children (drop-downs).

## 4. Multi-user, sessions, licensing
- Start-up creates a session row (`u_session`/`u_sessioninfo`: `of_createsession_setup`), enforces maximum users / single-user licence / "same user not allowed twice", optional single-instance mutex per machine (`configsetting.allow_multiple_session`).
- Licensing: `f_firsttimelic`, `f_islicenseexpire` (= -2 opens `w_activation`), `f_getlicinfo`, table `systextcatalog` / `syscatelog` flags, a hardware dongle through `sysdrv.dll` (`pd_openusbpd`, `pd_writepd`, `pd_pdstate`) and a helper program. These are **inventoried only**; the rebuild needs its own licensing decision (not a copy of this mechanism).
- Schema upgrades: the client carries a `Script.mdb` (Access) of numbered DDL scripts; at start-up it compares `sequence.AppVersion/SequenceId` with the script count and executes the missing scripts one by one, marking `DBStatus` while doing so; a database dump device (`...DBDump`) is used to restore on failure. (The rebuild should use proper migrations; `db/seed/seed_ledger.sql` is the ordered content of that script chain.)

## 5. Security model (details in `docs/SECURITY-AND-RIGHTS.md`)
Users -> groups; rights are rows of the `rights` table addressed by *menu index path* (`IndicesString` like `5,3,2,`); `d_security` returns, per user, `levelindex/indicesstring/status` rows for objects `A` (menu items) and `W` (window-level rights); `m_mainmenu.mf_initsecurityapp` / `w_main.wf_initsecurityapp` walk the menu and set `visible/enabled`; windows check specific right codes (e.g. 1118 start-up window, 515 restricted items). Group/category rights filter the item list and report data (`GroupCategoryRights`, `gi_catlist`).

## 6. Printing and reports
Print layouts are DataWindows chosen at run time by company and voucher type (`wf_selectprintout`, e.g. `d_voucherprint_half_format2`); report-argument windows (838 `w_arg_*` windows) collect parameters and call `f_retrieve_report*`; export to Excel through `pb2xls.dll`/`n_dwr_*` (DataWindow-to-XLS service), PDF/e-mail through `n_smtp` (`cl32.dll`, winsock), label printing through TSC printer DLL (`tsclib.dll`), QR codes (`qrcodegenlibrary.dll`, `makeqrbarcode.dll`), scanner/TWAIN image capture (`eztw32.dll`), barcode scale/fiscal-invoice integration (FBR digital invoice tables `fbr_di_*`, separate `FiscalizationApp`).

## 7. Modules (libraries -> business areas)
Accounts & cash; Purchase & stock; Sales/POS/quotations/orders/returns; Services; Hospital/clinic (patients, visits, e-prescription, ICD); School (students, fees); Hotel (guests); Employees/HR (attendance, biometric); SMS; remote sync (CRS / data transfer); reports. Library -> module mapping and per-object data are in `docs/data/libraries.json` and `docs/catalog/*.md`.
