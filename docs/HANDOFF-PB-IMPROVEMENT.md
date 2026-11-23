# Handoff: improving the PowerBuilder desktop app (session of 2026-11-23)

Local only. The outer repository's `origin` is public: never push it. `pbsrc*/`, `pbrun/`, `pbtest/` are git-ignored
and hold vendor code and secrets.

## 1. The goal

Owner's goal: regenerate the complete source of the PowerBuilder 12.5 app ("Waseela / Trader App v1"), fix all errors
and bugs, apply every worthwhile backend and frontend improvement, and end with an enterprise-grade, production-ready
application. Target is the **PowerBuilder app itself** (a new `abuzar.exe`), not the Rust rebuild.

Owner decisions so far: screens may be redesigned freely (business rules and data written must not change); unused
modules (hospital, school, hotel, HR/payroll, multi-site sync) are to be removed after the exact list is confirmed;
default priority is security and data integrity. Never say "there is no source": the recovered code is the source.

## 2. Where things stand

| Item | State |
|---|---|
| Source regeneration | 11,582 objects in 118 libraries, 0 skipped (`re-tools/pbsrc_export.py . pbsrc2 improve`) |
| Compile (PowerBuilder 2022 build 1878, free command-line tools) | Full rebuilds: 1,406 errors -> 224 -> 60 -> 1 -> **0 (cycle 6)** |
| Executable | `abuzar.exe` + 118 `.pbd` built with the free tools (`orca_build.py exe`); the paid IDE was not needed |
| First run | On the test database copy: Login shown, login accepted, main frame with 211 menu items |
| Cash Sale | **Crashed on first open** (null object reference). Cause fixed in the decompiler; **not yet re-tested** |
| Cycle 7 (the build with that fix, 600 objects) | Import clean; full rebuild started 09:25. **Result not read** |
| Everything past login and the menu | **Not exercised**: no posting, printing, reports, FBR |

## 3. Done in this session

1. **Analysis and roadmap**: `docs/IMPROVEMENT-ROADMAP.md` (improvements A-I, phases 0-5, open decisions).
2. **Source generator** `re-tools/pbsrc_export.py`: writes PowerBuilder export source (`ws_objects/<lib>.pbl.src/`).
3. **Recovered from the compiled libraries**: 777 external / stored-procedure declarations, 35 object-level
   structures, array bounds, event signatures and message ids, 134 enumerations, 36 OLE binary sections, design-time
   list items of 98 controls, 60 initial values of global variables (e.g. `gl_appversion = 3567`).
4. **Build driver** `re-tools/orca_build.py` (ORCA API, 32-bit Python): import, full / incremental rebuild, exe.
5. **Decompiler corrections** (`pcode_struct.py`, `pcode_lift.py`), each changes behaviour:
   - extra valueless `return` after a nested `if ... return x`;
   - inverted condition on a jump that leaves a block (10 places in 8 objects);
   - member numbering skipped own constants but not inherited ones (one statement in `n_smtp`);
   - nested `if A` / `if B` merged into `if A and B` (PowerScript does not short-circuit; 600 objects).
6. **Generator corrections**: controls inside user-object instances get empty type blocks (51 scripts had been
   emitted twice); functions that end without a value return the type default (68, an assumption); component events
   `activate` / `deactivate` declared with their message ids.
7. **Improvement overlay** `improve/`: `patches.py` (80 patches, each with an expected match count),
   `properties.json` (12 overrides; 361 report windows inherit the ticked "All"), `datawindows/` (117 corrected),
   `objects/` (HTTPClient replacement of the SOAP SMS proxy, self-test window), `remove.txt`.
   It repeats in source every fix of `deploy/FIX-LOG-2026-11-23.md`.
8. **Test environment**: database `WaseelaPBTest` on `.\SQLEXPRESS2022` (copy-only backup restored under another
   name; fiscal port, SMS provider and mail server neutralised). Run folder `pbrun\` (`re-tools/pb_runfolder.py`).
9. **Run helpers** that touch only the process started from `pbrun\`: `run_login.ps1`, `run_menu.ps1`,
   `run_shot.ps1`, `run_children.ps1`, `run_selftest.ps1`, `selftest_list.py`.
10. **Docs and memory** updated: `docs/STATUS.md` (top section), the roadmap, the auto-memory file.

## 4. In flight when the session stopped

- **Cycle 7**: check `pbsrc2\cycle-7.done`, then `python -I re-tools/compile_errors.py pbsrc2/rebuild-7.jsonl`.
  It includes the nested-if fix, the global initial values and `w_selftest` (hand-written, never compiled before:
  expect possible errors there).
- **Auto-instantiate flag**: edit made in `pbsrc_export.py` (`autoinstantiated()`), **never completed a run**; the
  owner interrupted both attempts. The first, broader rule produced a wrong list. Evidence-based intent: a class is
  auto-instantiated when a local of it is used without ever being assigned (`n_winsock`, `u_deleted_saleitemlog`,
  and likely `n_cst_hash_entry`, `n_cst_hash_blob_entry`, `n_dwr_string`, `n_xls_format`, `nv_qrcode`, plus the
  descendant `n_smtp`). Verify the list before using it; without it fiscalization by socket will fail at run time.
  `pbtest/gen` may hold a half-written generation: ignore it.
- `pbsrc2/ws_objects` was generated **before** the auto-instantiate edit and matches what cycle 7 compiles.

## 5. Remaining work, in order

**Phase 0, finish the faithful baseline**
1. Read cycle 7; fix any errors; settle auto-instantiate; rebuild; build the exe; refresh `pbrun`.
2. Re-test Cash Sale. Then run the self-test (`run_selftest.ps1`, 2,019 windows) and fix what it finds. Expect more
   defects of the kind only a run shows.
3. Compare old exe and new exe on copies of the same database: post the same sale, purchase, return; ledger and
   stock rows must be identical. Then printing, reports, and FBR against a test endpoint.
4. Loose ends: 3 undecoded design-time lists, 32 lists placed by tie-breaker, access levels (everything is public),
   exe icon and version resource, SOAP SMS replacement untested against the provider.

**Phase 1, security and integrity**: no `sa` login; salted password hashes; remove the hard-coded password and the
fixed backup-password scheme; atomic invoice numbering; lock / command timeouts; read the fiscal reply; fix the
split-invoice fiscal loop; atomic multi-invoice tendering. Strip vendor secrets before the source goes anywhere.

**Phase 2, speed**: one-call posting, cached preferences, paged item search, single connection.

**Phase 3, screens and look**: theme, high DPI, tabbed sheets, one report screen, POS mode.

**Phase 4, features and scope**: alerts, messaging, module removal (needs the owner's list).

**Phase 5, platform**: scripted release build, installer with update and rollback, signing, error log, automated
regression as a release gate, user and operations documentation.

None of phases 1-5 has been started.

## 6. Needs the owner

- **The live Rust rebuild probably carries the same decompiler defects** (`recovered/scripts`,
  `rebuild/data/src/scripts` were not regenerated). Inverted conditions sit in `w_billsummary`, `w_sale` (twice),
  `w_postsale`, `vf_dwdupcode2`; the stray `return` is in 344 functions. Not checked and not touched.
- Which system is production: the rebuild on PostgreSQL (current) or this app on SQL Server (older snapshot).
- Appeon's terms for shipping the 2022 runtime to shop PCs.
- Licence checks in the regenerated app (currently unchanged from the vendor's).
- Exact list of modules to remove.

## 7. How to work on it

| Task | Command |
|---|---|
| Decompile (9 min) | `PB_POWERSCRIPT=1 python -I re-tools/decomp_all.py recovered/pcode recovered/scripts_pb` |
| Generate (40 s) | `python -I re-tools/pbsrc_export.py . pbsrc2 improve` then read `pbsrc2/export-report.json` |
| Full cycle (import + full rebuild, 35-45 min; start detached) | `re-tools\build_cycle.cmd C:\Projects\Abuzar\pbsrc2 <n>` |
| Quick loop | `orca_build.py importeach`, `rebuild ... incremental` (3.5 min), `exe` (2.5 min, run from `Application\`) |
| Errors | `compile_errors.py <jsonl>`, `compile_show.py <jsonl> pbsrc2/ws_objects <code>` |
| Run folder | `python -I re-tools/pb_runfolder.py pbsrc2 deploy/Application C:/Projects/Abuzar/pbrun --db WaseelaPBTest` |
| Drive the app | `run_login.ps1`, `run_menu.ps1 -List` / `-Invoke "Sales/CashSale"`, `run_shot.ps1` |

Rules that bit this session:
- "Compiled entries exist" is not proof; only a full rebuild's error list is.
- Bash heredocs mangle backslashes in embedded Python: write scripts with the Write tool.
- 32-bit exporters change the working directory: pass absolute paths.
- The vendor's classic app is often open on this PC; never drive "the first `abuzar` process".
- The self-test and every test run only on `WaseelaPBTest`. Do not post test transactions in a real database.
- The app login is only in git-ignored local files; do not copy it anywhere.
