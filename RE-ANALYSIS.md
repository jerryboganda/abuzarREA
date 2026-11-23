# Abuzar / "Trader App v1" — Reverse-Engineering Analysis

Static analysis only. Nothing was executed, restored or modified (except this file and `re-tools/`).
Extraction scripts live in `re-tools/`; bulk output (strings dump, SQL dump) was kept out of the repo.

## 1. What it is

| | |
|---|---|
| Product | **Trader App v1** (application object `traderappv1`, library `abuzarapp.pbd`) |
| Vendor | Abuzar Consultancy, Lahore, Pakistan (from `MyPDUConverter.dll` metadata) |
| Brand/client strings | "Waseela" (`c:\waseela_temp`, `view_waseelamini_*`); this copy is the **FazalDin PP19** deployment (DB `FazalDinPP19DataBaseV3`) |
| Kind | Deployed **PowerBuilder 12.5** client/server ERP + POS — **no source code present, only compiled output** |
| Verticals in one binary | retail/pharmacy inventory, sales/purchase/returns, GL & accounts, hospital (patients, admissions, wards, doctors, visits, prescriptions, labs), school (students/classes), hotel (guest rooms), HR/payroll + biometric attendance, SMS, loyalty cards, installments, barcode labels, multi-server data sync ("CRS") |

## 2. Layout of `C:\Projects\Abuzar`

| Path | Contents | In git |
|---|---|---|
| `Application/` | 216 files / 702 MB — the runnable app: `abuzar.exe`, 120 `.pbd`, PB 12.5 runtime DLLs, `Script.mdb`, reports, media | yes (except `Script.mdb`) |
| `FiscalizationApp/` | second, small PB app: tax-authority invoice submission | yes |
| `FazalDinPP19V3DBDump.BAK`, `…Log.ldf` | SQL Server full backup (2.4 GB) + log | no (ignored) |
| `AutoBackup/`, `Backup/`, `Junk/` | more `.BAK` (V2/V3, ~14 GB), old `.mdf/.ldf`, old app copies | no |
| `Data/MSSQL.rat`, `IMSSetup/141973.ims` | `.rat` is a RAR archive (SQL system DB files, e.g. `distmdl`); `.ims` is an opaque installer/package blob | no |
| `ReadMe.doc` | 2014 legacy doc (not reviewed) | no |

## 3. Technology

- **Runtime:** PowerBuilder 12.5.0.2511 (`PBVM125.dll`, Sybase), 32-bit x86. `abuzar.exe` (1.1 MB) is only the PB launcher + embedded library list; `*.ext` files are renamed copies of the exes (self-update mechanism).
- **Compilation:** **P-code** PBDs (no embedded native PE images found in any of the 120 PBDs) — i.e. decompilable.
- **DB access:** OLE DB `SQLOLEDB` to **SQL Server** (references to SQL Server 2012); `Microsoft.Jet.OLEDB.4.0` (32-bit) to `Script.mdb`/`Data.mdb`.
- **Native/COM helpers:** `QRCodeGenLibrary.dll` (C++), `MyPDUConverter.dll` (VB6, SMS PDU encoding), `EZTW32.dll` (TWAIN scanning), `usbpd.dll` (USB pole display, imported by the app, not shipped here), TSC/BCP barcode-printer exports, `Service1.dll` (.NET 4.0, 24 KB — decompiled with ILSpy: a generated SOAP proxy for the Zong "ReachCWSv2" corporate SMS gateway, `http://cbs.zong.com.pk/ReachCWSv2/CorporateSMS.svc`; operations GetReports, GetCampaigns, QuickSMS, BulkSMS, DynamicSMS, GetAccountSummary, GetInbox; used by `smswebservices.pbd`, not by the fiscalization app), OpenSSL `libeay32.dll`, Crystal Reports viewer window + `Reports/rptPrintCheque.rpt`.
- **`mdsys.exe`:** *not* part of the app logic — it is John Walker's public-domain `md5.exe` (hashing utility).
- **PB runtime noise to ignore:** `pbjdbc12125.jar`, `libj*.dll`, `pbXerces125.dll`, `pbNetWSRuntime125.dll`, `tp15_*`, etc.
- **Third-party PB libs inside the PBDs:** `dw2xls.pbd` (DataWindow→Excel service, `n_dwr_*`/`n_xls_*`), `pbdwr125/pbsoapclient125/pbwsclient125` (PB web-service client).

## 4. Object inventory (120 PBDs, **11,623 objects**)

| Type | Count | Notes |
|---|---:|---|
| DataWindow (`.dwo`) | 8,748 | ~75 % of the app — mostly reports/printouts (`sprnt*` = print layouts, 5 PBDs ≈ 150 MB) |
| Window (`.win`) | 2,062 | 704 in `reports.pbd`, 287 `reportformat.pbd`, 145 `reports_cust.pbd` |
| Global function (`.fun`) | 460 | **265 are per-customer barcode-label functions** (`f_printbarcode_<clientname>`) |
| Menu (`.men`) | 156 | |
| User object (`.udo`) | 100 | 56 are the DW2XLS lib; core: `u_transaction`, `u_session`, `u_dwstandard`, `u_ds_standard`, `u_mutex`, `n_smtp`, `n_winsock`, `u_fbr_response`, `nv_qrcode`, `u_waytomoon` |
| Structure (`.str`) / other | 54 / ~45 | |

Module PBDs (by name): accounts*, sale* / salewin / saleorder / quotation / proforma*, purchase* / advancedpurchase / po* / pr*, multientry* / singleentry*, issue*, adjustment, transfer, stockreports, godown*, service* (≈20 PBDs), patient*/ipservices/ipsale/eprescription, student*, employee/useratten, smscomponents/smswebservices, crs*, datatransfer*, dashboard/graph*, barcode*, preferences, templates, reportviewer.

## 5. What can be recovered, and how well

| Asset | State | Recoverability |
|---|---|---|
| **Server-side logic (T-SQL)** | Stored in **plaintext** in `Application/Script.mdb` (Access/Jet; the app pulls `SELECT Query FROM Script WHERE SequenceId=…` to upgrade the DB). 0 objects use `WITH ENCRYPTION`. | **100 %** — **634 tables, 537 stored procedures, 30 views, 73 functions, 10 triggers**, ~7,300 seed `INSERT`s, ~2,000 `ALTER TABLE`s. This *is* your DB schema + business rules. |
| DataWindows | Binary `PDW1250` format, but SQL, column names, expressions, headings, fonts and `f_*` calls are plain UTF-16 | High: semantic content is already extractable; exact layout coordinates need the binary format decoded or a decompiler |
| Windows, menus, user objects, functions | P-code with a readable symbol table: event/function names, variables, **embedded SQL literals**, object references, DLL imports | Structure/dependencies: done in this pass. Logic: needs a p-code decompiler/disassembler |
| Application object | `traderappv1.apl`: globals, 30+ job/schedule names, external DLL declarations, startup chain | Structure readable now |
| Data | SQL Server backup of `FazalDinPP19DataBaseV3` (orig. path `D:\V3_AbuzarSoftWare\Data\`) | Needs SQL Server to restore — **none installed on this machine** |

PBD container format (parsed by `re-tools/pbd_lib.py`): 1 KB `HDR*` header; `ENT*` entry = `"0600"`(UTF-16) + first-block ptr, size, timestamp, comment len, name len, UTF-16 name; data is a chain of `DAT*` blocks (`next ptr(4) + length(2) + payload`).

## 6. Runtime architecture (from the application object)

- **Startup chain:** `w_startup` → `f_get_database_status` → `f_firsttime_script` / `f_firsttimewks_limit` / `f_firsttimelic` → `w_login1` → `f_islicenseexpire` / `w_activation` → `w_logo` → `w_main`. Single-instance mutex (`u_mutex`); session tracking (`u_session`, `configsetting.allow_multiple_session`).
- **Licensing/activation exists** (`gs_regid`, `gl_firsttimeinvlimit`, `gl_firsttimeduration`, `gi_wkslimit`, `syscatelog`, `customerlicense`). It was inventoried only to understand startup flow — no bypass work done.
- **Global state:** `gs_servername/dbname/password`, `gs_company`, user/group/security datastores, preferences datastore, item caches.
- **Multi-server topology:** parent / child / CRS / archive / dropbox link servers (`gs_parentserver`, `gs_crs_*`, `gs_arc_*`, `gs_dropbox_*`, `datacarrydb`), 70 `crs_*` replica tables, `sp_crs_*` (31 procs) for replication/reporting sync.
- **Background automation = SQL Agent jobs created by the app** (88 `sp_add_job/_jobstep/_linkedserver` uses): auto cash/credit sale posting, auto backup, auto stock ledger/report/verification, data migration, scheduled SMS, due satisfaction, attendance timeout, purge posted sales, CRS send/fetch, etc.
- **External integrations:** many Pakistani SMS gateways (smspoint.pk, brandedsms.pk, bizsms.pk, outreach.pk, cbs.zong.com.pk, jazzcmt, brandyourtext), SMTP (`n_smtp`, registry `HKCU\Software\TopWiz\EmailSMTP`), Google Chart QR endpoint, abuzar.com.pk, fingerprint hardware (`emp_finger*`), TSC barcode printers, TWAIN scanners.
- **FiscalizationApp:** separate PB app (`fiscalizationapp.pbd` 356 KB) with `u_transaction`, `n_winsock` + TCP listener tab, `f_fiscalizesaleinvoice`, `f_fiscalizesrinvoice`, JSON DataWindows (`d_saleinvoice_json`, `d_srinvoice_json`), `u_fbr_response`, QR via Google. (FBR = Pakistan tax authority — inferred from names; endpoint not verified.)

## 7. Core data model (most-referenced tables in SQL embedded in the app)

`saleledger`, `saledetail`, `srledger/srdetail` (sale returns), `purledger/purdetail`, `prledger/prdetail`, `accounts`, `virtualgl` / `gldetail` / `glheader` (ledger), `item`, `itempacking`, `itemcategory`, `itemclass`, `godown`/`godowndetail` (warehouses/stock batches), `customer`, `supplier`, `salesman`, `manufacturer`, `users`/`usergroups`/`grouprights`, `patient`/`patientadmission`/`doctors`/`serviceheader`/`serviceresultstamp`, `student`, `loyaltycardledger`, `duesatisfyheader`, `cashiershift`, `preferences`/`configsetting`. Naming prefixes: `crs_` (replica), `emp_` (HR, 29 tables), `db_`/`imp_` (import/dropbox staging), `view_sms_*` (SMS feeds).

## 8. Observations worth acting on

1. **User passwords are read/updated via `users.password` in plain SQL** (`select … from users where lower(username)=…`, `update users set password=…`). Storage format (plaintext vs hash) is *unverified* — check in the restored DB.
2. `xp_cmdshell` (2 uses) and `OPENROWSET` (1) in the scripts; DB credentials live in globals (`gs_password`, `gs_source_pwd`, `gs_dropbox_pwd`).
3. Per-client forks inside a single binary (265 barcode functions, `view_waseelamini_*`) — any rebuild must keep client-specific branches.
4. Hard-coded paths (`c:\waseela_temp`), 32-bit-only Jet dependency, PB 12.5 (end-of-life).
5. Git currently tracks ~700 MB of compiled binaries; there is still no source.

## 9. Suggested next steps

1. **Rebuild the schema as clean SQL** from `Script.mdb` (ordered by `SequenceId`) → split into tables / procs / views / functions / triggers files. (Fast, high value, fully automatable.)
2. **Decode `PDW1250`** to regenerate `.srd` DataWindow source (8,748 objects).
3. **P-code decompile** of windows/user objects/functions into `.srw/.sru/.srf` (try a PB 12.5-capable decompiler; verify it handles 12.5.0.2511 before trusting output), then rebuild into PBLs in the PowerBuilder 12.5 IDE.
4. Restore the `.BAK` on a throwaway SQL Server instance to validate the schema and inspect real data (needs SQL Server — not present here).
5. Build a dependency/call graph (windows → DWs → tables/procs) from the inventory + embedded SQL to scope a rewrite.

## 10. REA (github.com/morluto/rea) results

REA ("Reverse Engineer Anything", npm `rea-agents` 6.8.0) was **not installed** anywhere on this machine (checked PATH, global npm, the project folder, Claude/Codex/Gemini skill, plugin and MCP config). It was installed locally in a scratch folder only (`npm install --ignore-scripts`, no `rea setup`, no agent config changed) and run from there.

- **Works:** `inspect-artifact`, `inspect-pe-imports`, `inspect-pe-resources`, `inspect-pe-load-config`, `inspect-byte-entropy`, `inspect-managed-artifact` run fine on the Windows PE files.
- **`abuzar.exe`:** PE32 x86, links only `KERNEL32.dll` + `PBVM125.dll` (confirms it is a thin PowerBuilder launcher; all logic is in the PBDs). PE timestamp 2024-11-09. SHA-256 `71551d44…cf56c`.
- **`accounts.pbd`:** file-wide entropy 3.03 — not packed or encrypted, consistent with plaintext p-code and strings.
- **Does not work:** `.pbd` and `Script.mdb` are rejected as "unsupported binary format". REA has no PowerBuilder or Jet/MDB support, and `inspect-binary-layout` is Linux-x64 only. The `re-tools/` scripts remain the way to read those.
- **Not ready:** `rea doctor` reports unhealthy — Node 26.8.1 is below the required 26.12.1, and no native engine (Ghidra 12.1.x, Hopper, IDA) is installed. `decompile`/`function` need one of those, and would only apply to the native helper DLLs (QRCodeGenLibrary, EZTW32, PBVM125), not to PB p-code.

## 11. Database reconstruction

Final schema (see `db/README.md`): **761 tables, 10,882 columns, 1,730 FKs, 81 indexes, 642 procedures, 74 functions, 36 views, 10 triggers**, read from the catalog pages of the V3 data file (SQL Server 2000 format, parsed without SQL Server) and validated on SQL Server 2025: everything applies except two procedures. An independent first reconstruction (V2 file + migration scripts #7800-7968 from `Script.mdb`) is a strict subset of it, which cross-checks both. The vendor `*.BAK` files are SQL Server 2000 format and would need SQL Server 2008 R2 or older to restore; no backup was opened.

## 12. Ghidra/REA results on the native binaries

`rea analyze` and `rea decompile-all` (Ghidra 12.1.4) ran on `abuzar.exe`, `fiscalizationapp.exe`, `QRCodeGenLibrary.dll`, `EZTW32.dll`, `MyPDUConverter.dll` and `PBVM125.dll`. Output is in the session scratch folder (not in the repo): 12,306 decompiled functions for `PBVM125.dll` (119 MB), 1,000 for QRCodeGenLibrary, 233 for EZTW32.

`PBVM125.dll` (stripped, no symbols) is the PowerBuilder VM: it contains the PBD loader, the DataWindow (`PDW1250`) loader and the p-code interpreter. First leads for the decoders:

- `0x10c41d40` — maps object extensions (`.dwo`, `.win`, `.udo`) to object types
- `0x10c457b0`, `0x10c46190`, `0x10c556c0`, `0x10c57260` — `.pbd` handling
- `0x10b017c0`, `0x10b1c1e0`, `0x10b31ab0`, `0x10b41630`, `0x10c06ac0`, `0x10c06eb0` — `PDW` (DataWindow) format
- `0x10c13770` and `0x10bd0700` — two 142-case switches, candidates for the instruction dispatch / expression evaluator

## 13. DataWindow recovery: done (all 8,748)

All 8,748 DataWindows were turned back into their original source text (`.srd`) and then into JSON. 0 failures, 0 crashes.

- **How:** a `.dwo` is a memory image of the DataWindow engine's objects, so instead of decoding it by hand the real engine does it. `pbdwe125.dll` exports 576 C functions; with a 32-bit Python host (`C:\Tools\py32`), a copy of the runtime DLLs in `C:\Tools\dwhostin` (project folder untouched) and a 1 KB stand-in for the missing `ATL71.DLL` (`re-tools/make_atl71_stub.py`), `re-tools/dw_export.py` calls `dwLoadLibrary` (engine loads the object from the `.pbd`), creates a hidden DataWindow control, and asks `dwDescribe("datawindow.syntax")`. Driver: `re-tools/dw_export_all.py`.
- **Output:** `recovered/datawindows/<library>/<name>.srd` (350 MB, PowerBuilder 12.5 syntax: bands, table/SQL, every text/column/compute/line/bitmap/report/graph with x, y, width, height, font, colour, border, edit style, format, expressions) and `recovered/datawindows_json/` (485 MB, same content parsed by `re-tools/dw_parse.py`; regenerable).
- **Contents:** 398,442 controls (144,504 text, 105,218 column, 97,059 compute, 49,328 line, 1,399 bitmap, 280 nested report, 270 groupbox, 70 graph, 65 button, others); 8,664 have SQL, 21 call stored procedures.
- **Cross-check against the recovered database:** the reports reference 609 distinct tables; only 17 are not in `db/schema.json`, and all 17 are system objects, user functions, temp names, or a table that the migration scripts drop (`DepartmentSection`, used by one dead DataWindow).

Still not decoded: windows (`.win`), menus, user objects, global functions and all PowerScript (p-code).

## 14. Windows, menus, user objects: first results (in progress)

`PBVM125.dll` exports the PowerBuilder **object manager** (the same `ob_*` functions the IDE uses: 495 of them) plus reflection (`ClassDef_*`, `VariableDef_*`, `ScriptDef_*`). It can be hosted like the DataWindow engine (`re-tools/pbvm_host.py`, 32-bit Python, DLLs in `C:\Tools\dwhost\bin`).

Working so far (`re-tools/vm_list_objects.py`):
- Create a manager: `pbstg_begin_nofast(0x2000)` then `ob_mgr_init_ex(<zeroed 512-byte block>, pool, L"pbvm125.dll")`.
- `ob_set_liblist(mgr, wchar_t** paths, count, 0)` accepts the `.pbd` files.
- `ob_get_objnames_of_class_in_lib(mgr, kind, &count, path)` lists object names by kind. Kind codes: **0x4079 structure, 0x4080 user object, 0x4085 window, 0x408A DataWindow, 0x40AF menu**. Verified against the PBD inventory (e.g. `components.pbd`: 22 / 36 / 15 / 4).

Not yet working: resolving a class name to a type reference (`ob_type_reference` returns the "not found" sentinel 0xC000 because the library group isn't opened the way the runtime opens it), hence no field tables (`ob_get_class_field_info`, 0x4A-byte records) or initial values yet. Window and control properties (x, y, width, height, title, fonts) are field initial values; scripts remain p-code (bodies are not available through this API).

Realistic alternative: the original vendor (Abuzar Consultancy) holds the PowerBuilder source (`.pbl`); with it, windows and scripts need no decoding.

## 15. Windows, menus, user objects: extraction working

`re-tools/obj_export.py` drives the real object manager in `PBVM125.dll` (hosted on a private hidden desktop so runtime error boxes never reach the screen) and writes, per object, ancestor class, every non-default property with its initial value (x, y, width, height, title, text, font, tab order, ...), instance variables with initial values, and all nested controls/menu items recursively. Needs all 120 libraries registered (cross-library references such as `u_dwstandard`) with backslash paths. Driver: `re-tools/obj_export_all.py` -> `recovered/objects/<library>/<kind>/<name>.json`. Scripts (event/function bodies) are still compiled code and not yet readable.

**Result:** 2,834 objects exported from all 120 libraries with 0 failures and 0 crashes, matching the inventory exactly: 2,062 windows, 156 menus, 100 user objects, 54 structures, 2 application objects, 460 global functions (names only). 11,556 nested controls / menu items and 255,654 non-default properties, 36 MB, in `recovered/objects/`.

**Still missing for functional parity:** the PowerScript bodies (events and functions, all compiled code), plus event/function signatures. These need either the instruction set from `PBVM125.dll` (a p-code decompiler) or the vendor's original source.

## 16. Scripts: instruction set and disassembly (done), decompiler (next)

- **Instruction set read from `PBVM125.dll`:** 583 opcodes (`SM_RETURN`, `SM_PUSH_LOCAL_VAR`, `SM_ASSIGN_STRING`, `SM_JUMPFALSE`, `SM_DOTFUNCCALL`, `SM_DBSELECT` ...). Names: table behind `rt_pcode_name_index` (0x10DDC7E8, UTF-16 pointers). Operand counts, stack effect and handler address: 12-byte records at 0x10DDAC94 (`rt_semfun_args_index`). Saved as `re-tools/opcodes.json`.
- **Encoding:** a routine is a run of 16-bit words; an instruction is `[opcode][N operand words]`. Jump operands are byte offsets from the routine start.
- **Routine location** (hosted object manager): class record -> routine table (count at +0x1E, base at +2, 0x28 bytes per routine); routine -> header block `[u16 byte length][u16][u16][u32 code pointer]...`; prototype table gives names (`+name` = event). Verified: every routine decodes to exactly its recorded length (3 exceptions in 25,441).
- **Output:** `recovered/pcode/<library>/<kind>/<object>.json` (69 MB): per class and nested control, every event and function as a list of `[word index, opcode, operands]`. 25,441 routines (18,856 events), 2.33 million instructions, 312 distinct opcodes in use. 156 nested classes have no routine data (native error while reading their tables).
- **Names are not in the instruction stream.** Operands such as `PUSH_CONST_REF [off,0]`, `DOTFUNCCALL [off,...]`, `PUSH_CONST_STRING [off,0]` are byte offsets into per-routine tables stored next to the code (local variable names `ai_status`, `lstr_in_out`; member/function names; string literals). Reading those tables, rebuilding if/else/loops/choose-case from the jumps, and printing PowerScript are the remaining decompiler steps.

## 17. Scripts: symbols and decompiler (done)

**Result:** `recovered/scripts/<library>/<object>.pbs` - readable PowerScript-like source for every event and function of every window, menu, user object, global function and the application object: **2,780 objects, 28,140 routines, 579,202 lines, 7,450 embedded SQL statements**. Every routine decompiles with no open issue (0 flagged); 80 zero-length routines are native methods of system classes (`soapconnection` ...) with no script; 29 `goto` remain (valid code, not re-structured); 6 SQL statements carry `/* bind positions inferred */`.

**How the names were found** (read from the hosted runtime and the unlinked class images; no source involved):
- A class's routine table entry (0x28 bytes: `+0xc` routine record, `+0x18/+0x1c/+0x24` three *descriptors*) leads, through the pointer inside each descriptor (`+8` for name tables, `+2` for local records), to the routine's private tables (large tables sit in their own allocation at page offset 8; the descriptor carries the used size). Code and tables are **not** contiguous in memory.
- **Locals table:** 0x14-byte records `[flags/constant][array-bounds offset or 0xffff][name offset][slot or constant value][type word]`; type word = class type (>= 0x8000, local type table; < 0x8000 = system class, see `recovered/pcode_names/system_types.json`) or primitive code in byte 2 (1 integer, 2 long, 4 double, 6 string, 7 boolean, 10 unsignedlong, 11 blob, 12 date, 13 time, 14 datetime, 18 char) with flags. The first *argc* records are the arguments (argc and return type are in the prototype record, `+0x1e` / `+0x1c`). Global objects (`sqlca`, `message`) are records with flag 0x40 whose slot number is what `PUSH_LOCAL_GLOBREF` uses.
- **Reference table**: `PUSH_CONST_REF [off]` -> `[name offset][field index u16][type u16]`; `DOTFUNCCALL [off ...]` -> `[0xC000xxxx function | 0x8000xxxx event][name offset]`; `PUSH_CONST_STRING [off]` -> the string at `off`; `PUSH_CONST_DOUBLE/DEC/DATE [off]` -> literal bytes (decimal = 12-byte mantissa, sign, scale). Field records of system classes carry no name, only an index into the class's field table (without index 0 and without constants); when the class is unknown the (index, declared type) pair resolves it.
- **Prototype index of the calling class** (`PUSH_FUNC_CLASS [id, type]` + `CLASS_CALL`): `id` is the index of a prototype *record* in the class's original table; records of global functions / ancestor functions / external functions are removed at link time but are still in the `.pbd` image -> `re-tools/raw_protos.py` + `build_fnrefs.py` (one record per call signature, so the same function can occupy several ids). Validated: every resolved name matches the callee's argument count (9,065 + 6,966 call sites, 0 mismatches). System functions: id = index in the `systemfunctions` prototype table (456 entries, `sysfuncs.json`); system-class methods: the class vtable (e.g. `powerobject.getcontextservice`).
- **Embedded SQL** lives in the group's statement pool (`group data +0x26`). A DBSELECT/UPDATE/... operand is `[offset, 0x8000 + k]`: `k = 0` = this object's pool, `k != 0` = a second section of the same pool that holds statements inherited from an ancestor (base found by aligning the operands with the statement records; 16 statements of `w_sale`). The compiler replaced each host variable by a dummy literal (`0`, `' '`, `{ts '...'}`); binds are on the stack in order, INTO variables first, transaction object last. Real zeros (`ISNULL(x, 0)`, `CASE ... THEN 0`, `WHEN x = 0`) are filtered by syntax and bind kinds.
- **Shared / global variables**: `PUSH_SHARED_VAR [n]` indexes the symbol table of the object's group (`recovered/pcode_names/shared_vars.json`; entry 0 = the object's own global instance variable; the application object holds the 126 application globals); their class types give member names (`global_types.json`).
- **Application object**: its executable routines sit behind the external-function declarations in the prototype table (cnt of routine descriptors < prototype entries): 15 routines incl. the 11 KB `open` start-up script (see `docs/STARTUP-AND-SESSION-FLOW.md`).

**Stack machine, as observed** (`re-tools/pcode_lift.py`): every `PUSH_*` pushes one entry; calls leave receiver and arguments in place and set a result register; `POP_N_TIMES n` removes n entries and pushes the result (`PUSH_RESULT` pushes it without popping); `FREE_*`/`COPY_*`/`CNV_*` are bookkeeping; `CAT_STRING` appends in place and a later `POP_*` drops the consumed operand; `ASSIGN_*` pop value + lvalue; `STORE_RETURN_VAL [1|0]` + `JUMP end` is `return`; array index bounds are (index, lower, upper) triples; bounded array literals are `BUILD_BOUNDED_ARRAYLIST [type, flags, n, n, 0]`; cursor / dynamic SQL ops take the cursor or statement variable below the transaction operand; `PUSH_TRY [catch, end]` ... `CATCH_EXCEPTION` ... `GOSUB`/`RETURN_SUB` = try/catch/finally.

**Structuring** (`re-tools/pcode_struct.py`): forward `JUMPFALSE/JUMPTRUE` = `if` (`else` when the then-part ends in a forward `JUMP`), consecutive guards with one exit merge into `and`, backward `JUMP` to the condition = `do while`, backward conditional jump = `do ... loop while`, `init; JUMP cond; incr; cond ...` = `for ... to ... step`, `casenn = x; if casenn = 1 ...` chains = `choose case`, try/catch/finally, compiler epilogues and dead code removed.

## 18. Completion pass (what was missing and how it was closed)
Missing before: 16,870 unnamed global-function calls, the application object's routines (526 routines in classes with external declarations), shared-variable and member names, ancestor SQL, 89 flagged routines, DB catalog doubts. Closed by the methods above plus: FK cascade rules do not exist (none in the migration scripts; status bit 0x08000000 on 86 FKs = created WITH NOCHECK), identity seed/increment verified (1,1) from `syscolumns.autoval`, `u_transaction` has 449 stored-procedure prototypes, 838 `w_arg_*` report-argument windows, 156 menus with the real navigation menu `m_mainmenu` (718 items) and its security model. New documents: `docs/` (see `docs/STATUS.md`). Still impossible without a licensed running installation: screenshots of the original UI and run-time verification.
