# Final 210-screen menu walk - 2026-11-04

**Run:** `menu-walk.mjs` against `http://127.0.0.1:5177`, which serves the final
`web/dist` and proxies the API to the final `trader-server.exe` on 8788
(`trader_write_test`, exact migrated clone).

- **210 actionable leaves**, all attempted; 1261 menu leaf items in the tree.
- **1,352 s** baseline run, 8 periodic browser resets, no
  `ERR_INSUFFICIENT_RESOURCES`.
- Every click was closed through `rt.closeWindow`; no save, print, post or
  fiscalisation was performed by the walk.

## Effective result after the focused retry

| Outcome | Count |
|---|---:|
| Opened OK (no modal) | **200** |
| Caller-parameter popup (`w_arg_group`, needs caller parm) | **2** |
| Correct no-data dialog (Cashier Activity Window) | **1** |
| Safety-policy skips (Exit, Change User, Backup, Check Integrity, Import, Inplace Init, Lock Batches) | **7** |
| **Real screen failures** | **0** |

### The two parameterized popups

`Maintenance | Godown Preferences | Group Wise Godown Setting` and
`Manage | Group Wise Header Setting` open `w_arg_group`. It expects the caller to
set `message.powerobjectparm` (a group argument); a standalone menu walk has no
parm, so the first invocation throws before the dialog is shown. The harness's
retry opens both successfully and classifies them as `parameterized_popup_artifact`,
which is what they are: argument dialogs, not standalone screens.

### Cashier Activity Window

`Manage | Cashier Management | Cashier Activity Window` reports
`Unable to fetch cashier job data from database`. This is correct: `dbo.CashierJob`
has **0 rows** and **0 active rows** in both the live `trader` database and the
clone. The original reports the same no-data condition.

## Evidence

- `MENU-WALK.md` - full baseline and retry tables
- `menu-walk.json` - per-item outcomes, screenshots, timings
- `menu-walk/` - 1920x1080 screenshot for every opened screen
- `menu-walk-final3.log` - full run log
- `menu-walk-retry-final.log` - retry/classification log

## Original-side visual captures

Fresh original desktop screenshots for login, main, Cash Sale and Pack Purchase
already exist from the earlier capture session and are used in
`real/64-main-original-vs-final.png`,
`real/65-cashsale-original-vs-final.png`,
`real/67-login-dialog-compare.png` and
`real/71-purchase-original-vs-final.png`.

A new original report capture was attempted on 2026-11-04. The pristine
`Application\abuzar.exe` fails with the Windows error `ATL71.DLL was not found`;
the safe `deploy\Application` copy starts, but its PowerBuilder DataWindow login
could not be driven reliably in this session. The live database was verified
unchanged afterwards. The final Net Cash report is therefore compared against its
original DataWindow definition and measured layout (`68-final-report-netcash.png`:
0 px overflow, net cash 53,624,465.00). Capturing the original report on the
production machine remains a manual step.

## Real outside dependency

None of the screens failed because of the rebuild. The only remaining external
dependency for full production use is the real fiscal service/device on port
9111; the relay is implemented and was proven with a mock (`S588884`).
