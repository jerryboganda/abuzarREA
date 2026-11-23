# Agent handoff: Modern UI full QA session (2026-11-22 → 2026-11-23)

This file is local only. `C:\Projects\Abuzar` must never be pushed, and the file holds no passwords.
Read the following first:
- `CLAUDE.md` (root);
- `rebuild/CLAUDE.md` and `rebuild/AGENTS.md` (Project execution policy);
- `PROJECT-MEMORY.md`;
- the memory files in `C:\Users\Admin\.claude\projects\C--Projects-Abuzar\memory\`, especially `abuzar-modern-qa-tooling.md`.

## 1. The standing goal

The user's `/goal` is enforced by a Stop hook. Their words: "check each and every screen and each and every element inside a screen and in-depth analyze all issues and fix them all. CLICK each and every element AND CHECK OK. Drive the UI like an expert frontend visual QA. FIX ALL ISSUES, LEAVE NOTHING BEHIND." The scope covers UI/UX and display, business logic and requirements, and backend issues in the Modern frontend, which was built from the design artifact.

The Stop hook keeps rejecting "done". The gaps it lists are the remaining checklist in section 4.

## 2. Where things are

| Item | Value |
|---|---|
| Rebuild repo | `C:\Projects\Abuzar\rebuild` (public GitHub `jerryboganda/abuzar-rebuild`) |
| Branch | `qa/modern-workflows-2026-11-22` |
| Last commit | `a3f5c02a` QA crawler: QA_WRITE, QA_SKIP, QA_BOXWHERE |
| Deployed to production | `bccfd45b`, which has every product-code fix except the uncommitted Cash Sale popup fix below |
| Production | `https://pharmacy.polytronx.com`: VPS in France, behind Cloudflare (SIN PoP), nginx basic auth |
| Deploy | Push first, then `ssh vps "/opt/pharmacy/deploy.sh <commit>"` (it fetches from GitHub) |
| Direct test path (bypasses Cloudflare and basic auth) | `ssh -N -L 18787:<pharmacy-app container IP>:8787 vps`. Get the IP with `docker inspect`; it changes after every deploy. |
| Local servers (`.claude/launch.json`) | `trader-test-server` on 127.0.0.1:8790 (scratch DB `waseela_rehearsal`, never production) and `trader-web-real` dev server on 5174 (no HMR, so reload to pick up code) |
| Modern URL locally | `http://localhost:5174/?presentation=1`; Classic is the same URL plus `classic=1` |
| Test login | `C:\Projects\Abuzar\.claude\test-login.local.txt` (user `CLAUDE TEST`, operator code 12). Pass it only through env `APP_USER`/`APP_PW` (scratchpad `qa.ps1`). Never print it. |

## 3. What was done this session

### Deployed (production is on `bccfd45b`)

1. **Interface chooser start page and refreshed Modern sign-in** (`e990a83d`). Register was skipped as the user asked.
2. **SUPERADMIN user created on production.** The user chose "New user SUPERADMIN". The password is in no file and must never be written to the repo or memory.
3. **"Purchases is very slow" fix** (`6bbe88ab`):
   - `web/src/app/query-memory.ts`: `SETUP_TABLES` and `readsSetupOnly()`. Setup and configuration reads are shared across windows for 120 s.
   - `web/src/app/httpdb.ts`: `unchangedHere()` shares a read unless it touches a table this session changed. Before this, the uncommitted login write to `tmp_lt_maxdate` blocked all sharing.
   - Tests are in `web/tests/httpdb-speed.test.ts`.
4. **Errors found by clicking every element** (`bccfd45b`):
   - `dw-choice-editor.ts` and `dwview.ts`: a stale drop-down choice throws `ChoiceStale` and closes quietly instead of raising an error.
   - `runtime/interp.ts`: posted events carry a target, and `drainPosted` drops events whose window or object was destroyed.
   - `native/controls.ts` and `native/windowing.ts`: windows get `ready`, and `closeByUser` (`rt.closeWindowByUser`) waits for open to finish before closing.
   - The close buttons and tab × in `dom-ui.ts`, `modern-window.ts` and `presentation-ui.ts` now use it.
   - New test in `language.test.ts`. The suite is 967 tests, all passing; `tsc` is clean.
5. **Crawler upgrades** in `web/e2e/modern-visual-qa.mjs` (`bccfd45b`, `a3f5c02a`): `QA_ELEMENTS`, `QA_WRITE`, `QA_RUN`/`QA_RUN_WAIT`, `QA_SKIP`, `QA_BOXWHERE`, `QA_FROM`. Windows are tracked by object, not by name.
6. **Cloudflare:** each request costs about 300 ms through Cloudflare against about 135 ms direct. The user was asked and answered "Keep Cloudflare". Do not switch to DNS-only.

### Not committed yet (in the working tree)

- **`web/src/ui/ds-sale.ts`:** the Cash Sale item-search popup was too wide and covered the customer panel's Ref./Remarks fields. It now fills only the left column: `grid-area:1 / 1 / 3 / 2; position:absolute; left:0; top:var(--ds-aux-top,150px); width:100%`.
  - Verified in a screenshot: the popup is 926 px wide and `custrefno` is clickable.
  - `tsc` is clean and the 967 tests pass.
- **`web/e2e/modern-visual-qa.mjs`:** the `QA_FIELDS=1` field pass:
  - it clicks each editable field, types `1` or `01/01/2026`, then Tab;
  - it records an `entries` list per screen;
  - it re-tags fields after re-renders and keys them by `data-obj`/`data-field`;
  - the shared after-click handler is now `window.__side()`.
- Untracked files not to commit: `GEMINI.md` (not mine; leave it) and `web/e2e/_tmp-sqlerr.mjs` (a temporary probe; delete it or keep it out of the commit).

### QA coverage measured so far (local, scratch DB)

- **Screens:** all 202 enabled menu leaves were opened, in dark and light themes.
- **Element pass (`QA_ELEMENTS`):** 241 clicks, 0 errors.
- **Write pass (`QA_WRITE`):** 269 clicks including Save/Delete/Post/Print, 0 errors.
- **Field pass (`QA_FIELDS`):** 464 fields, 0 errors, 3 reported "not clickable":
  - Cash Sale `custrefno` was covered by the popup and is fixed in `ds-sale.ts`;
  - Purchase Return `bonusqty` and Price Policy `icode` are clickable when checked alone, so these are probably crawler timing.
- **Reports (`QA_RUN`):** 140 run, 0 errors. Slow ones finish given time: Reorder Level has 818 pages, and Item Activity renders about 1 s after Ok.
- **Last run:** the "^Sales" verification run (job `b9uaoqf3o`) was stopped by the app or the user partway. Its partial results:
  - Cash Sale: 8 elements and 7 fields, 0 errors;
  - Credit Sale: 4 elements, 0 errors;
  - the run reached Sale Return before it stopped.
  - The report is at `C:\Users\Admin\AppData\Local\Temp\claude\6b97e9b935f0b3d7\12e0d8fc-dc1d-48cf-a317-8adb84fb7903\scratchpad\fld-sales\report.json`. The scratchpad may be cleared.

### Settled as the original's behaviour (do NOT "fix")

- **Credit Sale:** it asks "Do You want to save changes" even when untouched. `ue_newform` closes only if `wf_validatedate()` (= `editflag`) is true.
- **Empty-form Save** on Lock Reason, Supplier Category and Category Segment gives a DB rollback box (`edit.required=no` on a NOT NULL column).
- **`w_selectformat_saleinvtypewisereport`** has no default radio button, so Ok does nothing until one is picked.
- **"Database Error" boxes:**
  - they come from the original's not-found handling (`sqlcode≠0`);
  - they appear on Quotation `custcode`, Credit Sale Return `saleinvcode` and Cash Sale Return batch.
- **Credit Sale ledger refresh:** `sp_virtualgl` takes about 0.7 s on production because a partial index isn't used. This is the original's query; left as is.
- **Earlier settled items:** see `memory/abuzar-modern-qa-tooling.md`.
  - `??:??`, the `!` micro help, `none` group titles;
  - the after-Cancel Null-object chain;
  - Cash Sale Sales 1.00 / Misc +1;
  - Purchases "(" placeholder;
  - Margin 100.00, among others.

## 4. Remaining work toward 100%

In order:

1. **Finish the Cash Sale popup fix:**
   - re-run the Sales field and element pass to completion:
     `QA_FIELDS=1 QA_ELEMENTS=1` with `qa.ps1 e2e/modern-visual-qa.mjs http://localhost:5174 <out> "^Sales" light`;
   - check `report.json` for errors and "not clickable" fields;
   - then commit `ds-sale.ts` and `modern-visual-qa.mjs`, but not `GEMINI.md` or `_tmp-sqlerr.mjs`;
   - push the branch;
   - deploy with `ssh vps "/opt/pharmacy/deploy.sh <commit>"` (the user said "ok deploy when done");
   - verify live: HTTP 200 and the version shown in the proxy conf.
2. **Full field pass on every screen, not only Sales:**
   - run `QA_FIELDS=1 QA_ELEMENTS=1` over all leaves (filter `.`);
   - re-check Purchase Return `bonusqty` and Price Policy `icode` in context;
   - fix any real error.
3. **Gaps the Stop hook keeps citing:**
   - **Field and cell coverage inside grids:** detail lines, every column of a line, plus drop-down choice selection and pick-list dialogs, not just the first editable cell.
   - **Save/Delete/Post/Print with real data:** the write pass clicked them on empty forms. Next, drive complete flows end to end on the scratch DB, each with a saved record:
     - Cash Sale;
     - Credit Sale;
     - Purchase;
     - Purchase Return;
     - Sale Return;
     - Quotation;
     - Vouchers.
     Then check the DB rows and the printed preview.
   - **Reports:** run the ones skipped by the crawler (`QA_SKIP` list and the format-dialog-first ones) with criteria filled in, and compare totals against the Classic UI.
   - **Credit Sale save prompt:** verify against the running original app. Read-only probes through `sqlcmd -E` on `.\SQLEXPRESS2022` are allowed, and the classic app can be logged into via `deploy\login.ps1`. Never type passwords into it by hand.
   - **Sale/Return Summary dialog:** check its layout and behaviour against Classic.
   - **Credit Sale ledger 0.7 s and the 300 ms per-request Cloudflare latency:** the remaining lever is fewer round trips (batch the queries a screen fires on open). Cloudflare stays, by the user's decision.
4. **Visual pass after fixes:** run screenshots of all screens in dark and light. Fan out review to subagents in batches of about 50 with the "do not report" list from the memory file. Verify their top findings yourself.
5. **Production check:**
   - after each deploy, open Purchases, Cash Sale and Credit Sale through the SSH tunnel and time the open;
   - the earlier perf script is in the scratchpad.
6. **Housekeeping:**
   - update `docs/STATUS.md` and the memory file `abuzar-modern-qa-tooling.md` with new settled items;
   - the branch `qa/modern-workflows-2026-11-22` is not merged to `main`. Open a PR only if the user asks.

## 5. Hard rules (unchanged)

- **Push and repo contents:**
  - Never push `C:\Projects\Abuzar`: it is public and holds vendor binaries.
  - The rebuild repo is public: no passwords, credentials, customer data or vendor binaries in it.
- **Passwords:**
  - Never print or store the test password or the SUPERADMIN password.
  - Never repeat the vendor backup/media passwords.
  - Don't crack the `.BAK` files or bypass licensing.
- **Production:** database changes need the owner's go-ahead. Write-pass crawls (`QA_WRITE`) only on the scratch DB.
- **Commits:** commit and push only for user-requested deploys; the standing one is "deploy when done".
- **Tooling gotchas:**
  - PowerShell 5.1 drops empty-string arguments, so pass `.` as the match-all filter.
  - Never rewrite source with `Get-Content -Raw`/`WriteAllText` (it causes mojibake). Use Edit, or Python with `newline=''`.
