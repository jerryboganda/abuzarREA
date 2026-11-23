# recovered/

Source recovered from the compiled application (no customer data).

| Path | Contents |
|---|---|
| `datawindows/<library>/<name>.srd` | 8,748 DataWindows as PowerBuilder 12.5 source text, exported by the real DataWindow engine |
| `datawindows_json/` | the same, parsed to JSON (bands, table/SQL, objects with geometry/fonts/colours); regenerate with `re-tools/dw_parse.py` |
| `objects/<library>/<kind>/<name>.json` | 2,834 windows, menus, user objects, structures, applications: ancestor, properties with initial values (x, y, width, height, title, text, font, tab order ...), instance variables, nested controls / menu items |
| `scripts/<library>/<object>.pbs` | **all PowerScript**: 2,780 objects, 28,140 events and functions, 7,450 embedded SQL statements, decompiled from the p-code (see RE-ANALYSIS.md section 17). Windows, menus, user objects, the 460 global functions (`f_*`) and the application object |
| `pcode/<library>/<kind>/<object>.json` | the machine-readable form the decompiler reads: per routine the instruction list, the local / reference tables, the line table, the SQL statement pool; per object the class table, enumerations and prototype records; `_classfields.json` per library |
| `pcode_names/` | `sysfuncs.json` (456 system functions), `protos.json` (prototype index of every class), `shared_vars.json`, `global_types.json`, `system_types.json`, `objindex.json` |
| `*.log`, `summary.json` | run logs |

Open: 29 residual `goto` and 6 SQL statements with inferred bind positions (see `docs/STATUS.md`).
Regenerate scripts from `pcode/`: `python -I re-tools/decomp_all.py recovered/pcode recovered/scripts`.
Size: `pcode` about 290 MB, `scripts` 28 MB; the DataWindow JSON copy can be regenerated from the `.srd` files.
