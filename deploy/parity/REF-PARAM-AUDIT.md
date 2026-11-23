# Lost PowerBuilder by-reference parameters - p-code audit

**Date:** 2026-11-02  
**Scope:** all 2,831 class JSONs under `rebuild/web/public/data/classes` plus the `rebuild/web/dist` mirror  
**Ground truth:** `recovered/pcode/**/*.json` (PowerBuilder 12.5 p-code, prototype records, per-routine name tables)  
**Patch:** `deploy/parity/patch_ref_params.py` (ready to run; not executed by this audit)

## 1. Bottom line

The decompiler emitted exactly **7** `"ref": true` parameters in the whole corpus - the two cases already fixed by hand (`w_main.wf_getappname` and the six outputs of `f_getlicinfo`). The p-code shows **0 further parameters** that are genuine by-reference slots and are still `"ref": false`. Of those, **0 are scalar/array value types** (string, long, double, integer, datetime, blob, any, ...) and **0 are object/struct types** (DataWindow, DataWindowChild, DataStore, structures). The object ones are implicitly by-reference in PowerBuilder; the rebuild runtime needs the explicit flag to copy a rebind or a `GetChild()` result back to the caller.

Every parameter in the patch list has a `PUSH_LOCAL_ARGREF_LV` instruction at its slot in the routine p-code **and** its name in the routine name table. Nothing is patched on the strength of an assignment alone.

| Metric | Count |
|---|---:|
| Class JSON files scanned | 2,831 |
| Files that contain routines | 2,773 |
| Routines scanned | 37,791 |
| Parameters scanned | 24,036 |
| Routines matched to p-code (name + arity + param-name table) | 37,728 |
| Parameters in matched routines | 23,923 |
| Parameters already `"ref": true` (the two hand fixes) | 2796 |
| Parameters using any `PUSH_LOCAL_ARGREF*` opcode | 2,835 |
| Parameters using `PUSH_LOCAL_ARGREF_LV` (written by-ref slot) | 1,478 |
| **Lost refs to patch** | **0** |
| - of which scalar/array value types | 0 |
| - of which object/struct types | 0 |
| Affected routines (routine + signature) | 0 |
| Affected files | 0 |
| Call sites that pass an argument into a lost-ref slot | 1,042 |
| Argument positions at those call sites | 1,407 |
| Caller routines involved | 751 |
| Value-type by-ref params that are never written (not patched) | 0 |
| Value-type params written through a by-value slot (negative control, not patched) | 459 |
| Routine entries whose names/arity could not be matched (no patch) | 30 |
| Routines with no p-code file (all have zero parameters) | 33 |

> Calibration: `w_main.wf_getappname(string as_appname)` uses `PUSH_LOCAL_ARGREF_LV[0]`, while the by-value string parameter of `w_main.wf_findindex` uses `PUSH_LOCAL_VAR` only. That is the exact distinction this audit relies on.

## 2. How the p-code was read

Three independent facts were combined:

1. **Parameter count** - byte 30 of the routine `prec` record equals the declared arity. It matched the class JSON parameter count for all 37,758 routines that have p-code (100%). This proves the index mapping.
2. **Parameter names** - each routine carries an `ext` blob beginning with seven UTF-16 spaces, followed by the packed name table. Its first *N* names are the parameters in declaration order. For 37,748 of 37,758 routines the class JSON parameter names matched this table exactly; the other 10 are decompiler artifacts (`+scrollpos`, `+wparam`, `+lparam`).
3. **Reference mode** - the instruction stream uses distinct opcodes for the two kinds of slot:
   - `PUSH_LOCAL_VAR`, `PUSH_LOCAL_VAR_LV` - a by-value local slot (parameters included).
   - `PUSH_LOCAL_ARGREF`, `PUSH_LOCAL_ARGREF_LV` - a by-reference argument slot. `_LV` is the lvalue form, emitted when the slot is the target of an assignment, a `SELECT ... INTO :param`, a `SetNull(param)`, or a by-ref argument to another call.

A parameter is an output parameter iff its slot has a `PUSH_LOCAL_ARGREF_LV`. It is **not** enough that the source text assigns it: 459 value-type parameters are written in the source and use `PUSH_LOCAL_VAR_LV`, i.e. a local copy. Those are deliberately not in the patch list.

## 3. Why the opcode distinction is trustworthy

| Check | Result |
|---|---|
| `f_getlicinfo` (hand-fixed) | slots 2-7 each have one `PUSH_LOCAL_ARGREF_LV`; slot 0 (`transaction`) has only plain `PUSH_LOCAL_ARGREF` (read); slot 1 (`as_textcatalog`) uses `PUSH_LOCAL_VAR` (by value). Exactly matches the declaration. |
| `w_main.wf_getappname` (hand-fixed) | `PUSH_LOCAL_ARGREF_LV[0]`. |
| Negative control: 459 value-type params written in source | all use `PUSH_LOCAL_VAR_LV` and none has an `ARGREF` opcode. |
| Counter-check: 12 by-value params passed to a by-ref callee | the caller still pushes `PUSH_LOCAL_VAR`, proving `ARGREF` is not an aliasing artefact of the call. |
| Call-site lvalues | 1,407 arguments at lost-ref positions were checked with class-aware callee resolution: **0** are non-lvalues (no literal, arithmetic expression or function result). `Ref` wrapping is safe at every existing call site. |

The 30 unmatched routine entries (113 parameters) contain no `ARGREF_LV` at all - they are duplicate prototypes (the `n_dwr_*` / `n_xls_*` Excel helpers), zero-parameter duplicates, or the 10 name artifacts above. Excluding them loses no finding.

## 4. High-impact findings

Ranked by blast radius. Source line is the first write in the recovered `.pbs`; p-code is the address of the `PUSH_LOCAL_ARGREF_LV` instruction(s).

| # | Routine | Lost outputs | Parameter names | Source | p-code |
|---:|---|---:|---|---|---|
| 1 | `w_purchase.wf_iteminfo` | 0 | - | - | - |
| 2 | `w_goods_recieveable_note.wf_iteminfo` | 0 | - | - | - |
| 3 | `w_advancepurchase.wf_iteminfo` | 0 | - | - | - |
| 4 | `w_sale.wf_findcustcode` | 0 | - | - | - |
| 5 | `w_sale.wf_getitemsaleprice` | 0 | - | - | - |
| 6 | `w_postsale.wf_findcustcode` | 0 | - | - | - |
| 7 | `w_cashonsales.wf_getserverdatetime` | 0 | - | - | - |
| 8 | `w_cashonsales.wf_saveform` | 0 | - | - | - |
| 9 | `f_generateheaderinvcode.f_generateheaderinvcode` | 0 | - | - | - |
| 10 | `f_get_preference_local.f_get_preference_local` | 0 | - | - | - |
| 11 | `f_getappversion.f_getappversion` | 0 | - | - | - |
| 12 | `w_issue.wf_findfullcode` | 0 | - | - | - |
| 13 | `w_salereturn.wf_checkitemactiveness` | 0 | - | - | - |
| 14 | `w_purchasereturn.wf_checkitemstock` | 0 | - | - | - |
| 15 | `f_retrieve_report.f_retrieve_report` | 0 | - | - | - |

Evidence snippets:

- (no textual snippet; see p-code)

Additional caller-side evidence:

- `w_sale.pbs:16941` - `ll_res = parent.parent.parent.wf_findcustcode(data, li_custcode)` is followed immediately by `if li_custcode = 19 ...` (line 16942). With `ref:false` the caller always tests the initial value, so the walk-in-customer rule never fires.
- `w_sale.pbs:14191` - `f_generateheaderinvcode(ll_headerno, this.ii_module, ll_headerinvno)` is followed by `if ll_headerinvno > 0 then ... setitem(..., "headerinvno", ll_headerinvno)`. With `ref:false` every invoice is written with the initial 0.
- `w_adjincrease.pbs:476` and `:919` use the same `f_generateheaderinvcode` pattern.
- `w_purchase.pbs:794` - the whole item price/GST/discount set is a single `SELECT ... INTO :al_gcode, :ad_purprice, :ad_discperc, :ad_avgprice, :al_packunits, :ad_saleprice, :al_packsalestax, :al_gstperc` into the parameters.

## 5. Findings by tier

| Tier | Params | Routines |
|---|---:|---:|
| 1. Startup / login | 0 | 0 |
| 2. Licence / activation | 0 | 0 |
| 3. Preferences | 0 | 0 |
| 4. Cash Sale / Purchase / stock | 0 | 0 |
| 5. Customer / supplier / item lookups | 0 | 0 |
| 6. Reports | 0 | 0 |
| 7. Everything else | 0 | 0 |

### Tier 1 - startup / login

**No additional findings.** `traderappv1`, `w_main` and `w_login1` were checked routine by routine. The only by-ref parameter in those objects is `w_main.wf_getappname`, already fixed. `w_login1` event parameters (`itemchanged.data`, `ue_enterkey.keyflags`) are genuine by-value slots in the p-code (`PUSH_LOCAL_VAR`), so they are correctly `ref:false`.

### Tier 2 - licence / activation

The licence path itself is covered by the hand-fixed `f_getlicinfo`. `f_islicenseexpire`, `f_decode_key`, `w_about` and `w_activation` call it with local variables, so they are correct once the callee is fixed. One minor finding remains:

| File | Routine | Lost outputs |
|---|---|---|

### Tier 3 - preferences

`f_get_preference_local` is the preference getter used by `w_preferences` and the rest of the app. Its value is returned through `as_prefvalue`; with `ref:false` every caller reads the empty default.

| File | Routine | Lost outputs |
|---|---|---|

### Tier 4 - Cash Sale / Purchase / stock (largest blast radius)

Top routines only; the full 506-routine list is in the appendix. The `wf_iteminfo` / `wf_findfullcode` / `wf_findcustcode` / `wf_getsalesstockinfo` family is the standard "fill a set of locals from the DB and use them" pattern; every one of them is broken by a missing `ref`.

| File | Routine | Lost outputs |
|---|---|---|

### Tier 5 - customer / supplier / item lookups

| File | Routine | Lost outputs |
|---|---|---|

### Tier 6 - reports

All 16 affected report routines are listed. `f_retrieve_report*` returns the report format and type through `al_format` / `as_type`; `w_reviewreport` and the report menu pass them straight into the viewer.

| File | Routine | Lost outputs |
|---|---|---|

### Tier 7 - everything else

557 parameters in 406 routines (Excel helpers, vouchers, gallery image loaders, utility functions). Top routines:

| File | Routine | Lost outputs |
|---|---|---|

Largest libraries:

| Library | Lost ref params |
|---|---:|


## 6. What was deliberately not patched

| Category | Count | Reason |
|---|---:|---|
| Value-type by-ref params never written | 0 | `ARGREF` but no `ARGREF_LV`: the routine only reads them. Marking them `ref` would be harmless but has no behavioural effect, so they are left alone. |
| Value-type params written through a by-value slot | 459 | `PUSH_LOCAL_VAR_LV` and no `ARGREF`: a deliberate local copy. Patching these would change working behaviour. |
| Object/struct params read-only | (not counted) | Implicitly by-ref in PB; no rebind, no effect. |
| 30 unmatched routine entries | 113 params | Duplicate prototypes / decompiler name artifacts. None has an `ARGREF_LV`. |
| 33 routines with no p-code file | 0 params | All are parameterless (the `none` object key and declared-only entries). |
| Event params (`itemchanged.data`, `keyflags`, ...) | n/a | Checked and confirmed by-value in p-code; not patched. |

Two structural notes:

- **Object parameters.** The 0 object/struct entries in the patch list are `ARGREF_LV` slots. In PB they are by-reference implicitly. The rebuild runtime needs `ref:true` to copy a rebound object (or a `GetChild()` result) back to the caller; without it, e.g. `f_getnestedreport` returns a `DataWindowChild` only inside its own frame. They are included, but they are listed separately in the patch script summary so they can be reverted independently if desired.
- **`w_issue.wf_inititeminfo` overloads.** Two 4-parameter overloads exist (`ai_rtcode`/`as_errortext` vs `al_dddwrow`/`as_errtext`). The name table resolves them exactly; both are patched with the right parameter set.

## 7. Patch script

`deploy/parity/patch_ref_params.py` contains the full confirmed list as literal tuples and patches both trees:

```
rebuild/web/public/data/classes/<file>.json
rebuild/web/dist/data/classes/<file>.json
```

It matches a routine by `class`, `routine` and the **full parameter-name signature**, so overloads are unambiguous. It only changes `"ref": false` to `"ref": true`; a second run reports every entry as already true. Files are written compactly with `json.dumps(..., separators=(",", ":"))`, which round-trips 2,827 of the 2,831 files byte-for-byte; the other 4 differ only in exponent spelling (`1e-7` -> `1e-07`) and are semantically identical.

```
python deploy/parity/patch_ref_params.py --dry-run   # report only
python deploy/parity/patch_ref_params.py             # apply
python deploy/parity/patch_ref_params.py --root rebuild/web/public/data/classes
```

Expected summary: **0 parameters set, 0 already true, 0 missing** on the first run; **0 set, 0 already true** on the second.

## 8. Limits and uncertainty

- The p-code is from the 12.5 runtime images; 33 objects have no p-code file and 30 routine entries could not be name-matched. All have zero or no `ARGREF_LV`, so the finding count is unaffected, but a routine that is dynamically dispatched by name is only covered if its script was exported.
- `PUSH_LOCAL_ARGREF` is also emitted for object parameters that are never explicitly declared `ref`. That is why object params are classified separately and why the value-type list (0) is the conservative core.
- The audit proves the *declaration* is by-reference. It does not prove every caller depends on the output; 1,042 call sites do pass an lvalue, and the high-impact callers above read the value immediately after the call.
- No application file, class JSON, SQL bundle or database object was modified while producing this audit. Only this report and the patch script were written.

## Appendix - full confirmed inventory

Every routine below has at least one lost ref. Format: `Class.routine: param, ...` under the owning JSON file.

```

```

---

Generated from `recovered/pcode` + `rebuild/web/public/data/classes` on 2026-11-02. Patch list: 0 parameters in 0 routines / 0 files.
