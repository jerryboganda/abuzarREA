# Menu walk recheck — 2026-11-03

This is the focused recheck of every screen that the 2026-11-02 baseline left as a real failure.
The baseline itself is unchanged in `MENU-WALK.md`.

## Baseline (2026-11-02)

- **210 actionable leaves**, all attempted.
- After the focused retry: **198 opened OK**, 0 modal-only, 0 no-window, **3 legacy failures**, 7 safety skips, 2 caller-parameter popups.
- The three legacy failures were `w_changepassword`, `w_interfacesetting` and the cashier-activity dialog.

## Recheck result

| Screen | Baseline result | 2026-11-03 result | Evidence |
|---|---|---|---|
| Maintenance \| Change Password (`w_changepassword`) | failed: null `setfocus` | **opens, stays open, closes, 0 page errors** | `probe-one-screen2.mjs` output, `menu-walk/retry_1073_*` |
| Maintenance \| Interface Setting (`w_interfacesetting`) | failed: null `setfocus` | **opens, stays open, closes, 0 page errors** | `probe-one-screen2.mjs` output, `menu-walk/retry_1112_*` |
| Manage \| Cashier Management \| Cashier Activity Window | no window | **correct business message** `Unable to fetch cashier job data from database` — there is no active cashier job in this data snapshot | `menu-walk/retry_1213_*` |
| Maintenance \| Godown Preferences \| Group Wise Godown Setting | parameterized popup | caller-supplied `message.powerobjectparm`; not a standalone screen | `w_arg_group` |
| Manage \| Group Wise Header Setting | parameterized popup | caller-supplied `message.powerobjectparm`; not a standalone screen | `w_arg_group` |

**Real screen failures after recheck: 0.**

The root cause of both `setfocus` crashes was the runtime menu object not exposing
the PowerBuilder `parentwindow` property. Menus are now attached to their owning
window when the menu is created and when `ChangeMenu` runs, so
`this.parentwindow.setfocus()` resolves to `w_main`/`w_sale` etc.

## Fresh full walk attempt (same day)

A complete 210-leaf walk was also run after the fixes. It handled all 210 leaves
and left **0 windows open**, but 41 entries failed with browser-level
`net::ERR_INSUFFICIENT_RESOURCES` after the run had issued tens of thousands of
requests. These are not application errors: the same screens had passed in the
focused retry and pass when opened alone.

- Full log: `menu-walk-2026-11-03.log`
- Resource-exhausted report: `MENU-WALK-2026-11-03-RESOURCE-EXHAUSTED.md`
- JSON: `menu-walk-2026-11-03-resource-exhausted.json`

## Other runtime defects found and fixed during this recheck

| Defect | Symptom | Fix |
|---|---|---|
| Menu `parentwindow` null | every window menu handler crashed or did nothing | attach the owning window; make `parentwindow` a computed property |
| `InsertRow` suppressed `ItemFocusChanged` | Purchase closed itself in `wf_validatedate` (`editflag=false`) | always raise the item-focus event; handlers already guard `ib_focusdetail` |
| `type_18` char fields left null | `ic_impactinventory` null, posting matched zero rows | decode the char default from the recovered hex value at class load |
| Decompiler-copied `return`s | Cash/Purchase/Credit Sale aborted after a passed validation | remove trailing returns from validation-bearing blocks, in both the class builder and the runtime loader |
