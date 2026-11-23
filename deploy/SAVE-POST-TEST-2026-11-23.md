# Save/post test — 2026-11-23 (live DB, test entries kept, FBR blocked)

## FBR block (restore after testing) — STILL BLOCKED
- SoftwarePreferences 805 AutoFiscalizeOnPosting: original PrefValue='Y', PrefValue2='Yes' -> currently 'N'/'No' (re-checked after the Preferences save, unchanged)
- Listener fiscalizationapp.exe (9111) stopped; scheduled task 'Waseela Fiscalization Listener' Disabled (original state: Ready)
- Restore commands: see `HANDOFF-2026-11-23-classic-app.md`.

## Method
Driven through the real desktop UI (computer use) by Claude; every save/post was compared with a before/after row-count snapshot of all 755 tables, and a SQL Server extended-events `error_reported` trace (`waseela_walk_errors`, severity >= 11) was read after each step (trace session is still running; drop it when testing is finished: `DROP EVENT SESSION waseela_walk_errors ON SERVER`).
Test data are labelled `TEST CLAUDE` / `TESTCLAUDE*`; item used: `3 WAY STOPER TUBE` (icode 24357), supplier `A TRADERS` (199).

## Result in one line
All entry screens that do not need a salesman credential or a security setting were saved (and posted where the screen has a post step) with **no unexpected DB errors and no crashes**. Nothing found that needs a patch. The sale family, Purchase Return and the stock-count post need the owner to enter a salesman code + password.

## Needs the owner (credentials) — prepared but NOT saved
Saving/posting sales, quotations, refused sales and purchase return opens **w_salesmanpassword** ("User Password": salesman Code + Password; governed by preferences `Salesalesmanwindow`, `CreditSaleAskUserPassword`, `askuserpwdinsalereturn`, `AskUserPwdInSaleOrder`, `AskUserPwdOnsavingInTransfer`). Claude does not type credentials, so these were filled in up to the prompt and the prompt was cancelled. Cancel path verified: "Transaction Rollback" / "Save Fails" message and the draft stays intact.

| Screen | State |
|---|---|
| Sales > CashSale | **draft left open**: 3 WAY STOPER TUBE x1 = 50.00, remark TEST CLAUDE. Owner: File > Save And Post (Ctrl+Q), enter salesman code/password. (FBR is off.) |
| Purchase > Purchase Return | prompt reached on Save (item 3 WAY STOPER TUBE batch TC1 x1, supplier A TRADERS) |
| Sales > Quotation | prompt reached on Save |
| Sales > Refused Sales | prompt reached on Save |
| Sales > Credit Sale, Sale Return, Open Cash/Credit Sale Return | not opened for save; preferences `creditsaleaskuserpassword`=Y and `askuserpwdinsalereturn`=Y say they will prompt too |
| Maintenance > Adjustment > Stock Adjustment | saved into the count buffer (AdjBuffer 2629); *posting* the buffer (w_adjbuffer) needs the same prompt |

## Left for the owner on purpose (access-control / workflow settings)
Manage > Groups, Users, Group Wise Header / Allowed Price / Cash Account / Supplier Category settings: these change who may do what (security settings) and Users creates logins; not touched. Manage > Cashier Management > Cashier Job: would create an active job that can gate live cashier posting; opened, not saved. The bulk/destructive tools listed in the handoff (Inplace Initialization, Change Items Price, Change Item Discount, Update Item Basic Data, Change Item Reorder Qty, Import Previous Sales, Modify Sale Invoices, Modify Last Transaction Date, Change Password, Backup Database, Job Schedule, Session Monitor) were not run.

## Test entries created and verified
| Screen | Document no. | Saved | Posted | Result |
|---|---|---|---|---|
| Purchase > Purchases | 12277 | yes | yes (Save And Post, "Posting Completed") | OK: Purledger/Purdetail +1, GodownDetail batch .TC1 qty 1, ItemLog +1, VirtualGl rows added; reopened as read-only, print preview renders |
| Purchase > Opening Purchase | 12278 | yes | yes | OK (batch TC2, item 3 WAY STOPPER, 50.00) |
| Purchase > Purchases (Loose) | 12279 | yes | yes | OK (batch TC3, 40.00) |
| Purchase > Purchase Orders | PO 6656 | yes | n/a | OK; **edited later** (required packs 2 -> 3, amount 80 -> 120) and re-saved: PurOrderDetail.Qty = 3 |
| Maintenance > Adjustment > Increase | 3667 | yes | immediately effective | OK: GodownDetail +1 batch TC4 |
| Maintenance > Adjustment > Decrease | 3668 | yes | immediately effective | OK: TC4 batch removed again, stock back to 2 |
| Maintenance > Adjustment > Stock Adjustment | buffer 2629 | yes | no (needs owner prompt) | OK saved (AdjBufferHeader/Detail +1) |
| Maintenance > Priority Setting | item 24357, batch TC3 priority 10 -> 11 | yes | n/a | OK |
| Maintenance > Lock Item Batches | item 24357, batch TC3 locked | yes | n/a | OK (left locked; unlock if wanted) |
| Maintenance > Update Item Suppliers | supplier 327 + item 24357 priority 2 | yes | n/a | OK. First try (default priority 1) raised the generic "Some unidentifiable problem... Row No: 1" box: the item already has a priority-1 supplier and `ItemSuppliers_ICode_Priority_UK` rejected the insert. Original behaviour (unique key), message is just unhelpful. |
| Maintenance > Interface Setting | saved unchanged | yes | n/a | OK ("Changes take effect in the database") |
| Maintenance > Preferences | saved unchanged | yes | n/a | OK; PrefID 805 still N/No |
| Basic Data > Tax Category | 4 (TEST CLAUDE TAX, 5%) | yes | n/a | OK |
| Basic Data > Sale Template | TEST CLAUDE TPL | yes | n/a | OK |
| Basic Data > Customer > Customer Category | 2 | yes | n/a | OK |
| Basic Data > Customer > Customer Sector | 2 | yes | n/a | OK |
| Basic Data > Customer > Customer | 326 (TEST CLAUDE CUST) | yes | n/a | OK; **edited later** (City = LAHORE) and re-saved, persisted |
| Basic Data > Supplier > Supplier | 327 (TEST CLAUDE SUPP) | yes | n/a | OK (needs Alias Name and Contact Person; first validation box shows a blank field name — original wording) |
| Basic Data > Supplier > Supplier Category | 2 | yes | n/a | OK |
| Basic Data > Item > Item | 29042 (TEST CLAUDE ITM2, 10/15) | yes | n/a | OK (price policy row created automatically) |
| Basic Data > Item > Item Basic Data | item 29041 + ItemPart 2 (TCPART1) | yes | n/a | OK (needs Class and Manufacturer) |
| Basic Data > Item > Price Policy | 28967 (item 29041, qty limit 99999) | yes | n/a | OK. Existing items refuse with "Price Policy already exists for this item" — correct, every item already has one (28,966 rows). |
| Basic Data > Item > Manufacturer | 1020 | yes | n/a | OK |
| Basic Data > Item > Item Class / Item Category / Generic Item / Generic Item Type / Item Thickness / Lock Reason / Category Segment / Manufacturer Type | 13 / 8 / 2 / 2 / 2 / 2 / 2 / 2 | yes | n/a | OK |
| Basic Data > Item > Item Alert | 6 (SILENT / MUTE) | yes | n/a | OK |
| Basic Data > Item > Sales Tax Schedule | 8 | yes | n/a | OK |
| Basic Data > Item > PCT Codes | 4 | yes | n/a | OK |

Totals in the DB (all tables, before vs after): Purledger 12276 -> 12279 (all posted, no unposted purchases), VirtualGl +6, GodownDetail 6430 -> 6433, plus the master rows above. No DB error was raised by any of the above except the expected unique-key violation noted.

## Other checks
- Editing a **posted** purchase (12277): fields are read-only and Save does nothing — correct.
- Print preview (invoice 12277 from the list): renders correctly (header, items, Net Total). **Real printing was not tested**: the Windows Print Spooler is *stopped* (Manual start; a deliberate "Windows Print Spooler Off/On" shortcut pair exists on the desktop), so the app's `print()` returns the original "Printing: Can not Print Invoice". Needs the spooler started (previous sessions started it) and a usable default printer (installed: RustDesk Printer = default, Microsoft Print to PDF).
- Item-list popup "Stock" column showed 2 for 3 WAY STOPER TUBE while the window footer showed the live 3 right after Adjustment Increase 3667 (and the DB had 3). The popup is a retrieve-time snapshot (`stock = sum(godowndetail.currqty)`), so this is staleness of an already-open list, not a data error. Not patched.

## Not possible in this database
| Screen | Why |
|---|---|
| Basic Data > Customer > Sale Promotion | required "Customer Group" list is empty (`CustomerGroup` has 0 rows and no Customer Group screen is on this menu); focus is trapped in that field so even the name cannot be typed. Original behaviour with this master data, not a patch regression. |

## Still untested
FBR end-to-end (needs a real sale + owner approval), saving/posting the sale family and Purchase Return (owner credential), real printing (spooler), the security/bulk tools listed above.
