# Item list performance: one retrieve per shared list

Measured on 2026-11-02 against the running rebuild (`trader-server.exe` on 127.0.0.1:8787, dev server on
127.0.0.1:5174, PostgreSQL 17 `trader` schema `dbo`). Playwright measured navigation to
`window.rt.windowInstances.get('w_main')`, to `typeof window.__opensheet === 'function'`, and the opening of `w_sale`;
a request hook counted POST `/api/query` bodies whose SQL starts `SELECT item.icode, item.customicode, item.name`.

## Before / after

| Metric | Before | After |
| --- | ---: | ---: |
| Navigation -> `w_main` instance | 18.14 s | 8.43 s |
| Navigation -> `__opensheet` available | 32.65 s | 8.54 s |
| `__opensheet('w_sale')` | 1.20 s | 1.22 s |
| Full item-list statements during login | 4 measured here (5 reported; primary 2, popup 2) | 2 (primary 1, popup 1) |
| Primary `ddd_itemmanfnames_groupgodown` executions | 2 | **1** |
| Popup `ddd_itemmanfnames_groupgodown_popup` executions | 2 | **1** |
| Primary query, database time | 6.58 s | 1.21 s |
| Popup query, database time | 6.56 s | 1.39 s |
| `gd_itemsinfo` rows | 27,818 | 27,818 |
| `gd_popup_itemsinfo` rows | 27,818 | 27,818 |
| `SELECT count(*) FROM dbo.item WHERE active = 1` | 27,818 | 27,818 |

The original session preloads two distinct item lists (`gd_itemsinfo` and `gd_popup_itemsinfo`), so one retrieve per
DataWindow/SQL is the original behaviour. The repeated retrieve of the *same* list is gone: the primary list is read once
and the popup list once. In the reported five-execution session the extra executions were additional refreshes of the same
two SQL statements; those now reuse the session result (or are never issued) as described below.

The after numbers were reproduced twice: 8.43/8.54 s and 8.42/8.53 s; the `w_sale` timings were 1.29 s and 1.22 s.
No page errors appeared in either run.

## Root cause

1. `traderappv1.open` retrieves `gd_itemsinfo` (primary list) and `gd_popup_itemsinfo` (popup list) once after login.
   This is the original preload and accounts for the first two statements.
2. `w_main.open` calls `wf_settimer()`. That routine ends with `timer(ll_refreshminutes * 60, this)`. With the default
   `ll_refreshminutes = 0`, PowerBuilder's **system function** `Timer(0, window)` stops the timer.
   The rebuild had no `Timer` system function, so the unqualified call was resolved as a method of `w_main` and ran the
   window's own `Timer` event. That event calls `f_refreshitemlist()`, which resets and re-retrieves both item lists inside
   `w_main.open` - the second primary and second popup statement, and the ~14 s gap between `w_main` existing and
   `__opensheet` becoming available.
3. The second pair was not reusable: `retrieve()` always went to the database. There was no session-level cache for the
   shared item-list DataWindows.

`w_main.open -> wf_settimer -> w_main.timer -> f_refreshitemlist` was confirmed with a Playwright routine trace before the
fix; after the fix only the two preload statements remain and no `f_refreshitemlist` call appears during startup.

## Fix

### Timer system function (root cause of the duplicate preload)

`rebuild/web/src/runtime/native/windowing.ts` now registers `timer(interval, window)`:

- `interval > 0` schedules the window's `Timer` event every `interval` seconds.
- `interval = 0` (or negative) stops the window timer, as in PowerBuilder.
- the timer is cleared when the window closes.

Because a system function with that name now exists, the interpreter's existing rule ("a plain call never runs an event
that shares its name with a system function") resolves `timer(0, this)` to the function, not to `w_main.timer`.

### Shared session cache for the app-wide item lists

`rebuild/web/src/runtime/interp.ts` owns the cache; `rebuild/web/src/dw/model.ts` uses it. It is deliberately limited to
the DataObjects that `traderappv1.open` loads into application-wide DataStores:

- `ddd_itemmanfnames_groupgodown`
- `ddd_itemmanfnames_cat_groupgodown`
- `ddd_itemmanfnames_groupgodown_popup`
- `ddd_itemmanfnames_groupgodown_popup_aa`

Cache key: **DataWindow name + translated retrieve SQL + the wire-format parameter values** (plus a call/SQL discriminator).
All screens that retrieve the same shared list with the same arguments receive the already-retrieved result; ordinary
reports and entry DataWindows are not cached and still read fresh data.

### Invalidation rule

The cache is per application session and is invalidated as follows:

1. **Any successful `DwModel.update()`** clears the whole cache. Item price, stock, description or any other DataWindow
   update therefore makes the next shared-list retrieve go to the database.
2. **Any successful embedded `INSERT` / `UPDATE` / `DELETE`, `EXECUTE IMMEDIATE`, or transaction `COMMIT` / `ROLLBACK`**
   clears the cache (`runtime/native/transaction.ts`). The commit/rollback hook also covers item changes made through
   stored procedures or dynamic SQL.
3. **`Reset()` before `Retrieve()` bypasses the cache for that retrieve.** This is the original's explicit refresh path
   (`f_refreshitemlist()` and windows that rebuild `gd_itemsinfo`); even if no write went through the two hooks above,
   the caller still gets current rows. `Retrieve()` itself clears buffers without marking the model dirty, so a plain
   repeat retrieve can reuse the result.
4. A new page/session starts with an empty cache; nothing is shared between logins or terminals.

## SQL / plan optimisation

New migration: `deploy/parity/99_performance_indexes.sql` (applied to the running `trader` database):

```sql
CREATE INDEX IF NOT EXISTS ix_godowndetail_icode_gcode_qty
  ON dbo.godowndetail (icode, gcode) INCLUDE (currqty);
ANALYZE dbo.godowndetail;
```

The item query calculates `stock`, `sstock` and `pstock` with per-item aggregates over `dbo.godowndetail`. The only
existing matching index was `i_gdits(gcode, icode)`, whose leading column is `gcode`; a predicate on `icode` alone could
not use it, so PostgreSQL scanned/index-scanned the table once per item.

EXPLAIN (ANALYZE, BUFFERS) of the primary SQL, same rows and same text before and after:

Before:

```text
Gather Merge ... rows=27818 ... actual time=643.279..6380.357
  SubPlan 3  (loops=27818)
    Aggregate ... Buffers: shared hit=534611
      Index Scan using i_gdits on godowndetail ... Index Cond: (icode = item.icode)
Buffers: shared hit=799110
Execution Time: 6385.769 ms
```

After:

```text
Gather Merge ... rows=27818 ... actual time=626.414..1180.214
  SubPlan 3  (loops=27818)
    Aggregate ... Buffers: shared hit=55638
      Index Only Scan using ix_godowndetail_icode_gcode_qty ... Index Cond: (icode = item.icode)
Buffers: shared hit=252369
Execution Time: 1184.550 ms
```

The popup SQL also uses the same index-only scans: `Execution Time: 1333.887 ms` for 27,818 rows. No query text was
changed, so the row set is identical (27,818 active items before and after).

## Cache verification in the live app

After a normal login (2 preload statements), the following was executed in the page:

```js
const g = window.rt.globals.get('gd_itemsinfo')
g.n_reset()
await g.n_retrieve(2)   // explicit refresh: 1 database query
await g.n_retrieve(2)   // same list, no Reset: 0 additional database queries
```

Result: one additional `/api/query`, both calls returned 27,818 rows, and `g.model.rowCount()` stayed 27,818.

## Verification

- `node --test web/tests`: **22 pass, 0 fail** (includes new tests for the shared-list cache/invalidation and for
  `Timer(0, window)` not firing the window's `Timer` event).
- Playwright login + `__opensheet('w_sale')`: no page errors, `w_main` and `w_sale` both open; `gd_itemsinfo` and
  `gd_popup_itemsinfo` both 27,818 rows.
- PostgreSQL: `SELECT count(*) FROM dbo.item WHERE active = 1` -> 27,818.
- Server log: only two item-list SQL statements per login, each returning 27,818 rows; primary 1.21 s, popup 1.39 s.

## Files changed

- `rebuild/web/src/runtime/native/windowing.ts` - real `Timer()` system function, timer cleanup on close (root cause).
- `rebuild/web/src/runtime/interp.ts` - per-session retrieve cache + invalidation hook.
- `rebuild/web/src/dw/model.ts` - shared-list cache key, Reset bypass, cache invalidation on update.
- `rebuild/web/src/runtime/native/transaction.ts` - invalidation after embedded writes / execute immediate.
- `rebuild/web/tests/dw.test.ts` - shared-list cache and invalidation test.
- `rebuild/web/tests/language.test.ts` - Timer system-function regression test.
- `deploy/parity/99_performance_indexes.sql` - new covering index (applied).
- `deploy/parity/ITEM-LIST-PERFORMANCE.md` - this evidence file.

Not touched: `web/public/data/sql.json`, `data/sql/statements.json`, `f_islicenseexpire*`, `f_getlicinfo*`,
`f_findrepch*`, and the licence logic.
