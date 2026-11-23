# re-tools

Python 3 (run with `python -I`). Read-only analysis helpers for the compiled PowerBuilder 12.5 app.

- `pbd_lib.py`  – PBD container parser (`entries()`, `read_obj()`).
- `inv.py <Application dir>` – per-PBD object inventory by type; writes `inventory.json` to cwd.
- `extract.py <Application dir> <out dir>` – dumps UTF-16 strings of every object (SQL, symbols, DW text) to `<out>/<pbd>.txt` (~90 MB).
- `mdb3.py <Script.mdb>` – pulls the plaintext T-SQL (tables/procs/views/functions/triggers) out of `Script.mdb` to `script_mdb_all.txt` in cwd.
