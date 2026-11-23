# Save/post test — 2026-11-23 (live DB, test entries kept, FBR blocked)

## FBR block (restore after testing)
- SoftwarePreferences 805 AutoFiscalizeOnPosting: original PrefValue='Y', PrefValue2='Yes' -> set 'N'/'No' during test
- Listener fiscalizationapp.exe (9111) stopped; scheduled task 'Waseela Fiscalization Listener' disabled during test (original state: Ready)
- Restore commands: see `HANDOFF-2026-11-23-classic-app.md`.

## Method
Driven through the real desktop UI (computer use) by Claude; each save/post compared with a before/after row-count snapshot of every table, and a SQL Server extended-events `error_reported` trace (`waseela_walk_errors`, severity >= 11) watched for DB errors.
Test data are labelled `TEST CLAUDE` / `TESTCLAUDE*`; item used: `3 WAY STOPER TUBE` (icode 24357), supplier `A TRADERS` (199).

## Authentication blocker (needs the owner)
Saving/posting sales, sale returns and purchase return opens **w_salesmanpassword** ("User Password": salesman Code + Password, governed by preferences such as `Salesalesmanwindow`, `CreditSaleAskUserPassword`, `askuserpwdinsalereturn`, `AskUserPwdInSaleOrder`, `AskUserPwdOnsavingInTransfer`). Claude does not type credentials, so these screens were prepared up to the prompt and cancelled (cancel path verified: "Transaction Rollback" / "Save Fails" and the draft stays intact). The owner must enter a valid salesman code + password for these.

## Test entries created
| Screen | Document no. | Saved | Posted | Result |
|---|---|---|---|---|
| Purchase > Purchases | 12277 | yes | yes (Save And Post, "Posting Completed") | OK: Purledger/Purdetail +1, GodownDetail batch .TC1 qty 1, ItemLog +1, no DB errors |
| Purchase > Opening Purchase | 12278 | yes | yes | OK (batch TC2, item 3 WAY STOPPER, 50.00) |
| Purchase > Purchases (Loose) | 12279 | yes | yes | OK (batch TC3, 40.00) |
| Purchase > Purchase Orders | PO 6656 | yes | n/a (no post for PO) | OK: PurOrderHeader/Detail +1 |
| Basic Data > Tax Category | 4 (TEST CLAUDE TAX, 5%) | yes | n/a | OK |
| Basic Data > Sale Template | TEST CLAUDE TPL | yes | n/a | OK |
| Basic Data > Customer > Customer Category | 2 (TEST CLAUDE CAT) | yes | n/a | OK |
| Basic Data > Customer > Customer Sector | 2 (TEST CLAUDE SEG) | yes | n/a | OK |
| Basic Data > Customer > Customer | 326 (TEST CLAUDE CUST) | yes | n/a | OK |
| Basic Data > Supplier > Supplier | 327 (TEST CLAUDE SUPP) | yes | n/a | OK (needs Alias Name and Contact Person; first validation message shows a blank field name — original wording) |

## Not completed / notes
| Screen | Status |
|---|---|
| Sales > Cash Sale | filled (3 WAY STOPER TUBE x1 = 50.00) up to Save And Post; stopped at salesman password prompt (owner) |
| Purchase > Purchase Return | filled up to Save; stopped at salesman password prompt (owner) |
| Basic Data > Customer > Sale Promotion | cannot be saved in this database: required "Customer Group" list is empty (`CustomerGroup` has 0 rows and no Customer Group screen is on the menu); focus is trapped in that field. Original behaviour, not a patch regression. |
