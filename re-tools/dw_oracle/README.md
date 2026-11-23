# DataWindow engine as an oracle

`pbdwe125.dll` (the DataWindow engine of the original, 32-bit) answers `Describe("Evaluate('<expression>', 0)")` for any PowerBuilder DataWindow expression, so the rebuild's
formatter and expression engine can be compared with the original's own results.

* `engine_host.py <pbd> <dwname> <exprs.json> <out.jsonl> <start>` - loads one DataWindow object and evaluates a JSON list of `Evaluate(...)` strings, one result per line
  (an item is written as `<PENDING>` before it runs: the item that is pending when the host dies or stalls is the one that stopped it). Run with `C:\Tools\py32\python.exe -I`.
* `driver.py <dir>` - restarts the host after a stop (a modal error dialog of the engine, e.g. `Double('12abc')`, stalls it: 40 s timeout, the item is marked `<CRASH>`).
* `gen_functions.py <dir>` - the function batch (round, mid, pos, date / time functions, conversions ...); formats were collected from the `format=` / `editmask.mask` of all DataWindows.
* Compare with `rebuild/web/tools/format-diff.ts` (number / date-time formats) and `rebuild/web/tools/expr-diff.ts` (expressions).

Inside the `Evaluate` string a quote is written `~'`. Results seen on the reference machine (regional settings): short date `m/d/yyyy`, `[time]` = `hh:mm:ss`, `[currency]` = `$#,##0.00;($#,##0.00)`.
