# SQL dialect gaps - PostgreSQL 17 parity audit

**Date:** 2026-11-02  
**Runtime bundle:** `rebuild/web/public/data/sql.json` - `stmt` 1,862, `dw` 8,666, `proc` 638  
**Build source:** `rebuild/data/sql/statements.json` - 16,649 records (`translated` 12,271 / `not-applicable` 4,194 / `dynamic` 128 / `untranslatable` 56)  
**Database:** PostgreSQL 17.11, `trader`, schema `dbo`  
**Method:** read-only. Both JSON files loaded with Python (not `ConvertFrom-Json`), string literals/comments masked, constructs counted per distinct `stmt` key / `dw` name, every runtime statement checked with `PREPARE`/`EXPLAIN` on the live database in a read-only transaction. No application, bundle, or database write.

---

## 1. Headline numbers

| Metric | Value |
|---|---:|
| `stmt` entries | **1,862** |
| `stmt` entries containing a T-SQL construct PostgreSQL cannot execute | **0** |
| `dw` entries | **8,666** |
| `dw` entries containing a PostgreSQL-breaking T-SQL construct | **0** |
| `dw` entries containing `SUBSTRING(...)` | **158** - all `PREPARE` clean; compatible, not a gap |
| Requested constructs present in the source SQL | **21 of 27** |
| Distinct constructs with a breaking residual | **0** |
| Translated statements failing PostgreSQL `PREPARE` | **59** - 16 `stmt`, 43 `dw` |
| Hard failures (independent of parameter values) | **44** - 27 schema/object + 17 dialect |
| Parameter-type-sensitive failures | **15** |
| SQL sites with no runtime translation at all | **184** - 173 embedded + 11 DataWindows |
| Of those, handled by the `SysJobs` special case | **32** embedded |
| Genuinely unhandled sites | **152** - 141 embedded + 11 DataWindows |

The zero is real but it is not the whole answer. The runtime bundle has been stripped of every literal token in the requested list: there is no `convert(`, `dateadd(`, `isnull(`, `top`, `[dbo]`, or `+`-string left in it. What remains is three different failure classes:

1. **SQL that is not in the map at all** - dynamic `EXECUTE IMMEDIATE`, SQL Server system tables, and 11 missing DataWindows. The runtime reports `statement has no PostgreSQL translation`.
2. **Translations that still parse but are wrong** - a `citext` batch column cast to `timestamp`, an unbound host variable, decimal arithmetic emitted without a cast, mismatched `UNION` branches.
3. **Schema drift** - valid PostgreSQL naming a table/column the rebuild does not have.

**Startup path:** `w_main` (1 translated statement), `w_login1` (1), `w_sale` (163), `w_purchase` (97) contain **0 breaking residual constructs and 0 `PREPARE` failures**. `traderappv1.open` has 7 translated statements and is clean from the post-login split (`gl_remotegroup`) onward; its pre-login `SysObjects`/`dbo.script` block is deliberately skipped by `rebuild/web/src/app/startup.ts`. This is consistent with the working ADMIN -> `w_main` -> Cash Sale userflow.

---

## 2. Construct inventory

Counts are **distinct entries**, not occurrences: a `stmt` key or `dw` name is counted once even if the construct appears many times. "Residual" = still present in the runtime-translated SQL, outside string literals/comments.

| T-SQL construct | `stmt` source | `dw` source | Residual | Verdict / PostgreSQL pattern |
|---|---:|---:|---:|---|
| `convert(` | 25 | 456 | 0 | `::type`, `to_char`, or the 1900-01-01 day-serial expression |
| `dateadd(` | 4 | 41 | 0 | `+ n * interval '...'` |
| `datediff(` | 3 | 236 | 0 | Date subtraction for day; `dbo.tsql_datediff` for month/year/quarter |
| `datename(` | 0 | 16 | 0 | `trim(to_char(x, 'Month'/'Day'))`; `lc_time` is English (US) |
| `datepart(` | 1 | 186 | 0 | `extract(...)`; `datepart(dw)` -> `extract(dow)+1` (DATEFIRST 7) |
| `isnull(` | 216 | 2,756 | 0 | `coalesce(...)`; first-argument type precedence is not identical |
| `getdate(` | 39 | 2,071 | 0 | `(now() AT TIME ZONE 'Asia/Karachi')::timestamp(3)`; transaction-stable |
| `iif(` | 0 | 0 | 0 | Not present |
| `charindex(` | 0 | 12 | 0 | `strpos(...)` / `dbo.tsql_charindex`; `citext` preserves CI collation |
| `len(` | 0 | 226 | 0 | `length(rtrim(...))` everywhere (226/226 verified) |
| `stuff(` | 0 | 3 | 0 | `overlay(... placing ... from ... for ...)`; `datalength` -> `octet_length` |
| `top N` | 0 | 11 | 0 | `LIMIT n`; `WITH TIES` would need `FETCH FIRST ... WITH TIES` |
| `newid(` | 0 | 0 | 0 | Not present |
| `scope_identity(` | 0 | 0 | 0 | Not present in `stmt`/`dw`; routines use `dbo.tsql_lastident()` |
| `ident_current(` | 0 | 0 | 0 | Not present |
| `@@` | 1 | 0 | 0 | `@@Version` -> `version()`; other forms only in routines |
| `WITH (NOLOCK)` | 2 | 0 | 0 | Removed; PostgreSQL MVCC gives the same read semantics |
| `SELECT ... INTO table` | 0 | 0 | 0 | No table-target `INTO`; PB host-variable `INTO :x` is stripped |
| `[bracket]` identifiers | 11 | 0 | 0 | All 11 are PB blob indexing (`blob[ll_counter]`), not T-SQL identifiers |
| `+` string concatenation | 30 | 3,179 | 0 | `||`; numeric `+` preserved as addition |
| `CAST(... AS datetime)` | 1 | 16 | 0 | `::timestamp(3)` |
| `CONVERT(varchar, ..., style)` | 13 | 416 | 0 | `to_char` with the exact style (103 -> `DD/MM/YYYY`, 101 -> `MM/DD/YYYY`) |
| `STR(` | 7 | 1,892 | 0 | `dbo.tsql_str(numeric, len, decimals)` |
| `SPACE(` | 0 | 500 | 0 | `repeat(' ', n)` |
| `REPLICATE(` | 0 | 175 | 0 | `repeat(text, n)` |
| `PATINDEX(` | 0 | 0 | 0 | Not present; helper `dbo.tsql_patindex` exists |
| `SUBSTRING(` | 0 | 158 | **158** | PostgreSQL accepts the same 3-argument comma form; all 158 clean |

**Never present:** `iif`, `newid`, `scope_identity`, `ident_current`, `patindex`, table-target `SELECT ... INTO`. Their PG patterns are in the table for future SQL.

**Scan exclusions:** `[bracket]` matches in PB blob code are array indexing, not SQL Server identifiers; `+` adjacent to `date`/`timestamp`/`time`/`interval` literals is date arithmetic, not string concatenation. Both were inspected manually.

---

## 3. What is actually broken

### 3.1 Untranslated sites - 184 SQL sites are outside the map

`sql.json` contains only `status == translated` records. The build source has **173 embedded gap entries** (128 `dynamic` + 45 `untranslatable`) and **11 DataWindows with no entry**:

| Group | Count | Runtime behaviour |
|---|---:|---|
| `EXECUTE IMMEDIATE` sites (`dynamic`) | 128 | `dynsql.ts` accepts only `insert/update/delete/select`, and rewrites only `#temp`, `[word]`, `isnull`, `getdate()`, `len()`. Anything else returns `undefined`; `transaction.ts` sets `sqlcode = -1` and reports `dynamic SQL cannot be translated: ...` |
| `SysJobs` queries (`untranslatable`) | 32 embedded | Handled by the special case in `runtime/native/transaction.ts` and `app/httpdb.ts`; not a runtime gap |
| `SysObjects` / `tempdb` session queries | 13 embedded | No translation; pre-login environment/session code. `startup.ts` skips the pre-login block today, but `u_session`/`u_sessioninfo`/`u_waytomoon` would fail if that block is restored |
| Missing DataWindows | 11 | `dwSql` lookup returns `undefined`; the window/report cannot retrieve |

The 11 missing DataWindows are: `d_backupschedule`, `d_backupschedule_2012`, `d_databasesname`, `d_linkedservers`, `ddd_exportrestricted_column_list`, `ddd_restricted_column_list`, `ddd_objectcolumnlist`, `d_conectionmonitorlist`, `d_conectionmonitorlist2`, `d_chemistwisesale`, `d_custdata_hilton`. Most are backup/linked-server/connection-monitor admin screens; `d_chemistwisesale` is a sale report and `d_custdata_hilton` is a vendor special report.

**Dynamic SQL examples that matter:**

| Entry | Source / routine | What it builds | Why it fails |
|---|---|---|---|
| `emb:salewin/w_sale:13166` | `recovered/scripts/salewin/w_sale.pbs` / `w_sale` event | `ALTER PROCEDURE DBO.SP_Fetch_AccountBalance_OnRemote @AccCode INT, @Date DATETIME ...` (full T-SQL procedure body) | Starts with `ALTER`; `translateDynamicSql` returns `undefined` |
| `emb:purchasecomponents/w_purchase:93`, `:389` | `recovered/scripts/purchasecomponents/w_purchase.pbs` / `w_purchase` | `ls_connsetting` (connection/session settings) | Not DML; `translateDynamicSql` returns `undefined` |
| `emb:templates/w_normal_initialization:195` | `recovered/scripts/templates/w_normal_initialization.pbs` / `cb_ok.clicked` | `CREATE Procedure dbo.sp_executelocal ...` with `DECLARE @VersionInfo`, `EXEC`, `charindex`, `@` variables | DDL/T-SQL body; first-time initialisation only |
| `emb:components/u_session:44` | `u_session.of_createsession` | `Update tempdb.dbo.sysconns Set id = ISNULL((select max(id) ...),0)+1` | Starts with `Update`, so `dynsql.ts` passes it through, but `dbo.sysconns` does not exist |

### 3.2 Wrong translations that still parse - 48 confirmed failures

These are valid PostgreSQL syntax but wrong semantics or wrong types. The count column is confirmed runtime failures; 21 are dialect/translation and 27 are schema (3.3).

| Class | Count | IDs / evidence | PostgreSQL error or effect |
|---|---:|---|---|
| `citext` batch cast to `timestamp` | **2** | `emb:salewin/w_sale:18610`, `:18641` (`dw_itemsdetail.ue_dwnkey`) | `(batch)::timestamp = ($4)::timestamp`; a batch such as `A123` gives `invalid input syntax for type timestamp`. This is on `w_sale` (Cash Sale item detail) |
| Unbound host variable | **1** | `emb:salereturncomponents/w_salereturn:2168` (`wf_post_salereturn`) | `column "ld_newavgprice" does not exist`; the value is never bound and never cast. Sale Return posting cannot update `srdetail.newavgprice` |
| Decimal host-variable arithmetic | **2** | `emb:templates/w_saletemplate:597` (`wf_updatesaleprice_basicdata`), `emb:multientryitem/w_item_form:535` (`wf_update_activequtations_for_newitem`) | `sqlsub.rs` substitutes a PB `decimal` as a quoted string. `round('12.34' * 2, 2)` gives `invalid input syntax for type integer: "12.34"`; `'12.34' / 2` likewise |
| `UNION` branch type mismatch | **9** | `d_cashflow_onecashacc`, `d_cashflow_onecashacc_patient` (text/integer); `d_daily_saleand_service_summary`, `d_daily_saleand_service_summary_patient`, `d_dailysale_sr_sum_inv_type_wise2` (text/integer); `d_workorder_printout` (text/smallint); `d_alazizdist_wholesaleinvreport_full`, `d_unitedmedicine_wholesaleinvreport_full`, `d_unitedpharma2_wholesaleinvreport_full` (timestamp/text) | PostgreSQL rejects the whole query: `UNION types text and integer cannot be matched`, or `timestamp without time zone and text` |
| Ambiguous column reference | **2** | `d_wholesaleinvreport_manfwise_full` (`printbalance`), `d_zafartractor_transferinvreport` (`headerno`) | SQL Server resolves the unqualified name; PostgreSQL requires qualification |
| `GROUP BY` strictness | **1** | `d_stockinhand_transitstock_crosstab` | `column "t.name" must appear in the GROUP BY clause or be used in an aggregate function` |
| Missing `FROM` alias | **3** | `d_medocalldist_saleinvreport_copied_rp`, `_rp2` (`saleledgerl`), `d_cust_student_servicetemplatedetail` (`studentservicetemplatedetail`) | A table alias/reference was dropped or renamed in translation; `missing FROM-clause entry` |
| `INSERT` expression count | **1** | `emb:functions/f_generateprescriptionlog:7` | Target has 16 columns; `logid`, `logdate`, `p.*` (15) = 17 expressions; `INSERT has more expressions than target columns` |
| **Total confirmed** | **48** | 21 dialect + 27 schema | - |

### 3.3 Schema/object gaps - 27 hard failures, not dialect

Valid PostgreSQL that names a table or column the rebuild does not have. Listed because they are the largest block of the same `PREPARE` run and several are login/preferences/stock paths.

| Missing object | Count | Statements / DataWindows |
|---|---:|---|
| `dbo.script` | 2 | `emb:abuzarapp/traderappv1:692`, `:726` (`traderappv1.open`, schema-upgrade scripts; pre-login block is skipped today) |
| `salesman.password` | 3 | `emb:components/w_password:19`, `emb:components/w_oldpreferences:87`, `dw:components/d_password` |
| `preferences.terms` | 4 | `d_gene`, `d_newpreferences`, `d_newpreferences1`, `d_preferences` |
| `godowndetail.reorderqty`, `optimumqty` | 2 | `d_godown_detail`, `d_godowndetail` (columns are on `item` in the rebuild) |
| `issuereqdetail.gcode` | 1 | one normalized statement used by `w_issue_request.wf_allowissuemodification` and `w_production.wf_allowissuemodification` |
| `itempacking.icatcode`, `itemcategory.packcode`, `itemclass.catcode` | 3 | `w_packcatclass.wf_duplicatecode` / `wf_catduplicatecode` / `wf_classduplicatecode` |
| `customer.code` | 1 | `w_entry_primitives.wf_new` |
| `dbo.clinictest` | 2 | `d_test_detail`, `d_test_list` |
| `dbo.lockers` | 1 | `w_locker.wf_release_all_lockers` |
| `dbo.departmentsection` | 1 | `d_departmentsection` |
| `dbo.balancecategory` | 1 | `ddd_balancecat` |
| `groupitemwisepurexptemplate`, `groupitemwisereceiptexptemplate` | 2 | `w_groupitemwise*.wf_validategroup` |
| `gd1.optimumqty` | 1 | `d_issueform` |
| `sp_crs_fetch_itemstockposition(integer)` | 1 | `d_crs_branch_itemstockposition` |
| `dispatchheader.biltynumber` | 1 | `d_dispatachlist` |
| `userattendance.in_datetime` | 1 | `d_userattendance` |

The `dbo.script` and `salesman.password` rows are the only ones adjacent to startup/login; the rest are window-specific. None is a T-SQL syntax issue; they need schema mapping or query rewrites that preserve the original meaning (for example `customer.code` -> `customer.custcode` only if the live schema's `code` was the customer code, not a different field).

---

## 4. Worked examples

IDs are exact `statements.json` IDs. "O" is the original T-SQL, "T" is the current runtime translation. Snippets are truncated; the full text is in `statements.json` / `sql.json`.

### 4.1 Date serial, `CONVERT(datetime, int)`, `DATEADD`

- **`emb:abuzarapp/traderappv1:583`** - `recovered/scripts/abuzarapp/traderappv1.pbs`, `traderappv1.open`  
  O: `Select stat, flag, convert(datetime, fcatvalue) INTO ... From syscatelog Where fcatid = 1`  
  T: `SELECT stat, flag, (timestamp '1900-01-01' + (fcatvalue) * interval '1 day') FROM dbo.syscatelog WHERE (fcatid = 1)`  
  Pattern: `fcatvalue` is `integer`; SQL Server datetime serial 0 = 1900-01-01. Correct.
- **`emb:functions/f_getlicinfo:57`** - `recovered/scripts/functions/f_getlicinfo.pbs`, `f_getlicinfo.f_getlicinfo`  
  O: `Convert(datetime, DateAdd(month, :al_duration, Convert(datetime, :ll_startdate)))`  
  T: `(((timestamp '1900-01-01' + ($2)::integer * interval '1 day') + (($1)::integer) * interval '1 month'))::timestamp(3)`  
  Pattern: day-serial must be `integer`, then month interval; this is the fix that resolved the live "cannot cast integer to timestamp" failure.
- **`emb:patientvisitcomp/w_visit_appointment_form:276`** - `w_visit_appointment_form.wf_set_next_timeslot`  
  O: `DATEADD(minute, ISNULL((SELECT TimeSlotInterval ...), 15), Max(DueDate))`  
  T: `(max(duedate) + (coalesce((SELECT timeslotinterval ...), 15)) * interval '1 minute')`  
  Pattern: `DATEADD(unit, n, x)` -> `x + n * interval '1 unit'`; cast `n` to `integer`/`numeric` when it is a host variable.

### 4.2 `DATEDIFF`, `DATEPART`, `DATENAME`

- **`emb:salewin/w_sale:10510`** - `w_sale.wf_check_patient_inv_period`  
  O: `datediff(d, date, getdate())`  
  T: `((localtimestamp(3))::date - (date)::date)`  
  Pattern: `DATEDIFF(day, a, b)` counts calendar-day boundaries; `b::date - a::date` is equivalent for date/timestamp values.
- **`emb:abuzarapp/w_activation:40`** - `w_activation.wf_newactivation`  
  O: `DateDiff(Month, Min(Date), Max(Date))`  
  T: `dbo.tsql_datediff('month', min(date), max(date))`  
  Pattern: month/year/quarter are calendar-boundary counts, not interval lengths; `tsql_datediff` computes `(year*12+month)` differences.
- **`dw:accountreports/d_salesmanwise_sales_receipts`** - `recovered/datawindows_json/accountreports/d_salesmanwise_sales_receipts.json`  
  O: `DateName(Month, Cast(:al_month As VarChar(2)) + '/01/' + Cast(:al_year As VarChar(4)))`  
  T: `trim(to_char((((left($2::text,2) || '/01/') || left($3::text,4)))::timestamp, 'Month'))`  
  Pattern: `DATENAME(month, x)` -> `trim(to_char(x,'Month'))`; `trim` is required because PostgreSQL pads `Month` to nine characters.
- **`dw:reportdwarg/d_date_weekday`** - `recovered/datawindows_json/reportdwarg/d_date_weekday.json`  
  O: `DatePart(dw, :ad_date)`  
  T: `(extract(dow from ($1)::timestamp)::integer + 1)`  
  Pattern: SQL Server default `DATEFIRST 7` returns Sunday=1; PostgreSQL `dow` is Sunday=0, so `+1` is correct only for that setting.

### 4.3 `ISNULL`, `GETDATE`

- **`emb:abuzarapp/w_main:175`** - `w_main.open`  
  O: `SELECT isnull(userName,''), d = getdate() INTO ... FROM USERS WHERE usercode = :gl_usercode`  
  T: `SELECT coalesce(username, ''), (now() AT TIME ZONE 'Asia/Karachi')::timestamp(3) AS d FROM dbo.users WHERE (usercode = $1)`  
  Pattern: `ISNULL(x,y)` -> `coalesce(x,y)`; `GETDATE()` -> transaction-local timestamp. The runtime hardcodes `Asia/Karachi`, correct for this installation but not portable.
- **`emb:purchasecomponents/w_purchase:3943`** - `w_purchase.wf_fetchbatchsaleprice`  
  O: `SELECT ISNULL(SalePrice,0) INTO ... FROM ItemBatchPricing ...`  
  T: `SELECT coalesce(saleprice, 0) ...`  
  Pattern: same; add `::type` if the first argument and replacement have different types, to preserve SQL Server's first-argument precedence.
- **`emb:purchasecomponents/w_purchase:4566`** - `w_purchase.wf_updateitemsaleprice`  
  O: `update Item SET Saleprice = :ad_saleprice, ..., LastUpdate = GETDATE() WHERE ...`  
  T: `UPDATE dbo.item SET saleprice = $1, ..., lastupdate = localtimestamp(3) WHERE ...`  
  Pattern: SQL Server `GETDATE()` is statement-start; `localtimestamp` is transaction-start. Use `statement_timestamp()` if the difference matters.

### 4.4 `CHARINDEX`, `LEN`, `STUFF`, `STR`, `SPACE`, `REPLICATE`

- **`dw:custcomponents/d_area_detail`** - `recovered/datawindows_json/custcomponents/d_area_detail.json`  
  O: `shortname1 = LEFT(SHORTNAME, CASE WHEN charindex(char(13), shortname) > 0 THEN charindex(char(13), shortname) - 1 ELSE 6 END)`  
  T: `left(shortname, CASE WHEN (strpos((shortname)::citext, (chr(13))::citext) > 0) THEN (strpos(...) - 1) ELSE 6 END)`  
  Pattern: `CHARINDEX(sub, s)` -> `strpos(s, sub)` (arguments reversed); `citext` casts preserve CI collation.
- **`dw:specialreports/d_stockdata_nextpharma`** - `recovered/datawindows_json/specialreports/d_stockdata_nextpharma.json`  
  O: `REPLICATE(' ', 6 - LEN(:as_distcode))`  
  T: `repeat(' ', (6 - length(rtrim(($3)::text))))`  
  Pattern: `LEN` ignores trailing spaces, `length` does not; every `LEN` is wrapped in `rtrim` (226/226 verified).
- **`dw:multientry/d_issueform`** - `recovered/datawindows_json/multientry/d_issueform.json`  
  O: `stuff('0000', 5 - datalength(ltrim(str(dbo.item.iccode))), datalength(...), ltrim(str(...)))`  
  T: `overlay('0000' placing ltrim(dbo.tsql_str(...)) from (5 - octet_length(...)) for octet_length(...))`  
  Pattern: `STUFF(s,start,len,new)` -> `overlay(s placing new from start for len)`; `DATALENGTH` -> `octet_length`.
- **`dw:specialreports/d_tran_agp`** - `recovered/datawindows_json/specialreports/d_tran_agp.json`  
  O: `TransNo = STR(S.SaleInvCode, 10)`  
  T: `dbo.tsql_str((s.saleinvcode)::numeric, 10)`  
  Pattern: `STR(n,len,dec)` -> `dbo.tsql_str`; helper right-justifies and returns `*` on overflow.
- **`dw:servicesalesitop/d_mawf_medicine_service_subprint`** - `.../d_mawf_medicine_service_subprint.json`  
  O: `custref = SPACE(100)`  
  T: `repeat(' ', 100) AS custref`  
  Pattern: `SPACE(n)` -> `repeat(' ', n)`; `REPLICATE` uses the same function.

### 4.5 `TOP`, `WITH (NOLOCK)`, `@@`, bracket identifiers

- **`dw:components/d_quickserach_preference`** - `recovered/datawindows_json/components/d_quickserach_preference.json`  
  O: `SELECT TOP 1 colname FROM InterfaceSetting ... ORDER BY SequenceID, ColCaption`  
  T: `SELECT colname FROM dbo.interfacesetting WHERE ... ORDER BY sequenceid, colcaption LIMIT 1`  
  Pattern: `TOP n` -> `LIMIT n`; `ORDER BY` is required for determinism. `TOP n WITH TIES` needs `FETCH FIRST n ROWS WITH TIES`.
- **`emb:adjustment/w_adjwindow:431`** - `w_adjwindow.wf_releaselock`  
  O: `SELECT count(*) INTO :ll_count FROM godowndetail WITH (NOLOCK) WHERE ...`  
  T: `SELECT count(*) FROM dbo.godowndetail WHERE ...`  
  Pattern: `WITH (NOLOCK)` has no PostgreSQL equivalent and is removed; MVCC readers do not block writers.
- **`emb:abuzarapp/w_autorecovery:92`** - `w_autorecovery.ue_postopen`  
  O: `SELECT Ver = @@Version INTO :ls_version_info FROM (SELECT A = 1) AS T`  
  T: `SELECT version() AS ver FROM (SELECT 1 AS a) AS t`  
  Pattern: `@@VERSION` -> `version()`; `@@ROWCOUNT` -> `GET DIAGNOSTICS`, `@@ERROR` -> exception handling.
- **`emb:multientryitem/w_item_form:323`** - `w_item_form.wf_update_itemimage`  
  O: `UpdateBlob ItemImage Set ItemImage = :this.istr_itemimage.blob[ll_counter] Where ...`  
  T: `UPDATE dbo.itemimage SET itemimage = $1 WHERE ...`  
  Pattern: `blob[ll_counter]` is a PowerBuilder array index, not a SQL Server `[identifier]`; it becomes a bound bytea parameter. There are **0 true bracket identifiers** in the runtime SQL.
- **Dynamic `[dbo].[sp_execute_temp]`** - `w_autorecovery` builder  
  O: `object_id(N'[dbo].[sp_execute_temp]')`  
  T: passed through by `dynsql.ts`, which strips `[word]` but not dotted `[schema].[name]`  
  Gap: the dynamic translator's bracket regex needs to handle dotted identifiers if those admin paths are kept.

### 4.6 `+` string concatenation, `CAST(... AS datetime)`, `CONVERT(varchar, ..., style)`

- **`emb:salewin/w_sale:10360`** - `w_sale.wf_validate_patient_from_outside`  
  O: `patient = LTRIM(RTRIM(P.Name)) + ' (' + LTRIM(RTRIM(P.RegNo)) + ')'`  
  T: `(((ltrim(rtrim(p.name)) || ' (') || ltrim(rtrim(p.regno))) || ')')`  
  Pattern: string `+` -> `||`; add `::text` when one operand is non-text (`text || integer` has no implicit operator).
- **`emb:notescomponents/w_notesform:447`** - `w_notesform.wf_validateinvcode`  
  O: `Today = cast(convert(varchar(100), getdate(), 101) as datetime)`  
  T: `(date_trunc('day', localtimestamp(3)))::timestamp(3) AS today`  
  Pattern: style 101 formats `MM/DD/YYYY`; casting back to datetime truncates to midnight, so `date_trunc('day', ...)` is faithful.
- **`emb:salewin/w_sale:8787`** - `w_sale.wf_get_saleinv_count_single_cust`  
  O: `convert(datetime, (convert(varchar(2), datepart(mm,getdate())) + '/' + convert(varchar(2), datepart(dd,getdate())) + '/' + convert(varchar(4), datepart(yy,getdate()))))`  
  T: builds `M/D/YYYY` then casts `::timestamp(3)`  
  Pattern: relies on `DateStyle = ISO, MDY` (current server). A robust version uses `make_date(year, month, day)` or `to_timestamp(text,'MM/DD/YYYY')` so it does not depend on a session setting.
- **`dw:specialreports/d_stockdata_nextpharma`** - `.../d_stockdata_nextpharma.json`  
  O: `CLDATE = Convert(varchar(10), :ar_enddate, 103)`  
  T: `left(to_char(($1)::timestamp, 'DD/MM/YYYY'), 10) AS cldate`  
  Pattern: style 103 = `dd/mm/yyyy`; `to_char` with an explicit format is correct and locale-independent.

### 4.7 `SUBSTRING` - residual but compatible

- **`dw:specialreports/d_stockdata_nextpharma`** - `.../d_stockdata_nextpharma.json`  
  O: `SUBSTRING(LTRIM(RTRIM(I.CustomICode)), 1, 9)`  
  T: `substring(ltrim(rtrim(i.customicode)), 1, 9)`  
  Pattern: PostgreSQL accepts `substring(string, start, count)`; all 158 residual `SUBSTRING` statements `PREPARE` clean. No change needed for positive start/count.
- **`dw:custcomponents/d_area_detail`** - `.../d_area_detail.json`  
  O: `SUBSTRING(SHORTNAME, charindex(char(13), shortname) + 1, 6)`  
  T: `substring(shortname, (strpos(...) + 1), 6)`  
  Pattern: same. PostgreSQL and SQL Server both return `''` for `start > length`; they differ for negative start. No negative/zero starts were found in the 158 entries.

---

## 5. Ranked findings - user impact

Ranking follows login/startup, then Cash Sale/Purchase, then reports, then modules not used by this installation.

| Rank | Finding | Path | Evidence | Impact |
|---:|---|---|---|---|
| 1 | `w_sale` item-detail `UPDATE` casts the `citext` batch column to `timestamp` | **Cash Sale** (`w_sale`, `dw_itemsdetail.ue_dwnkey`) | `emb:salewin/w_sale:18610`, `:18641`; `(batch)::timestamp = ($4)::timestamp` | Hard failure on batch/godown selection in Cash Sale; `invalid input syntax for type timestamp` |
| 2 | Sale Return posting references unbound `ld_newavgprice` | **Sale Return** (Cash Sale adjacent) | `emb:salereturncomponents/w_salereturn:2168`; `newavgprice = ld_newavgprice` | Sale Return cannot post the new average price; `column "ld_newavgprice" does not exist` |
| 3 | Dynamic SQL on `w_sale`/`w_purchase` is outside `dynsql.ts` coverage | **Cash Sale / Purchase** | `emb:salewin/w_sale:13166` (ALTER PROCEDURE), `emb:purchasecomponents/w_purchase:93`, `:389` (connection settings) | If hit: `dynamic SQL cannot be translated`; feature is dead, not silently wrong |
| 4 | Nine report DataWindows fail on `UNION` type mismatches | **Reports** | `d_cashflow_onecashacc` (2), `d_daily_saleand_service_summary` (2), `d_dailysale_sr_sum_inv_type_wise2`, `d_workorder_printout`, `d_alazizdist...`, `d_unitedmedicine...`, `d_unitedpharma2...` | Entire report query fails; no rows returned |
| 5 | Decimal host-variable arithmetic emitted without casts | **Basic data / Sale Template** | `w_saletemplate:597`, `w_item_form:535`; `round('12.34' * 2, 2)` | Price/quotation updates fail under the real literal-substitution protocol; `operator is not unique` or `invalid input syntax for type integer` |
| 6 | 27 schema/object gaps (not dialect) | Login-adjacent + reports + unused modules | `salesman.password` (3), `preferences.terms` (4), `dbo.script` (2), `godowndetail.reorderqty` (2), `dbo.clinictest` (2), etc. | Password dialog, preferences, schema upgrade, stock and clinic/student modules fail when opened |
| 7 | 152 unhandled SQL sites (141 embedded + 11 DataWindows) | Mostly admin/backup/session/unused reports | 128 dynamic + 13 non-SysJobs untranslatable embedded; 11 missing DWs | `statement has no PostgreSQL translation`; `d_chemistwisesale` is the only sale report in the missing-DW list |

**Startup path specifically:** `w_main`, `w_login1`, `w_sale`, and `w_purchase` have zero breaking residual constructs and zero `PREPARE` failures. The only startup-path defect is the `w_sale` batch cast (rank 1), which is in an item-detail keyboard event rather than the initial open. `traderappv1.open` is clean from the post-login split onward; its pre-login `SysObjects`/`dbo.script` statements are skipped by design today.

---

## 6. Prioritized fix list

All fixes preserve SQL Server semantics. None should invent a business rule or silently map a column to a different meaning.

1. **`w_sale` batch/expiry `UPDATE`** - `emb:salewin/w_sale:18610`, `:18641`. The original puts `:lstr_selection.dt_date` against `Batch` and a literal `{ts ...}` against `Expiry`, while `s_popup_selection` assigns `dt_date` from `dw_data.object.expiry`. This is either a decompiler field-shift or an original bug; re-derive the mapping from the PB struct before changing SQL. At minimum, `batch` is `citext` and must not be cast to `timestamp`. The faithful shape is `batch = <batch value>::citext AND expiry = <expiry value>::timestamp`; do not reuse the timestamp parameter for both columns.
2. **Sale Return posting** - `emb:salereturncomponents/w_salereturn:2168`. Add `ld_newavgprice` to the statement's host-variable list and `params`, with `::numeric` at use: `newavgprice = $3::numeric` (the next placeholder if `ld_newavgprice` is appended to the host-variable list). The value is computed in `wf_post_salereturn` and must be passed; do not replace it with a column reference.
3. **Decimal arithmetic** - `w_saletemplate:597`, `w_item_form:535`: cast every host variable in arithmetic to the SQL Server type, e.g. `round(($1)::numeric * ($2)::integer, 2)` and `($3)::numeric / ($2)::integer`. `sqlsub` quotes PB decimals; the cast is what makes the literal numeric.
4. **`UNION` branches** - add an explicit common type to every branch. For text/integer, cast the integer branch to `text` (or the text branch to `integer` if the column is numeric) and `NULL` to the same type; for timestamp/text, cast the text branch to `timestamp` only where it is genuinely a date, otherwise cast the timestamp branch to `text` to preserve the original display. The nine IDs are in section 3.2.
5. **Ambiguous columns / GROUP BY / alias** - qualify `printbalance` and `headerno` with their table aliases; add `t.name` to the `GROUP BY` of `d_stockinhand_transitstock_crosstab` (do not wrap it in `max()` unless SQL Server's arbitrary choice is acceptable); restore the `saleledgerl` and `studentservicetemplatedetail` aliases in the three affected queries.
6. **`INSERT ... p.*`** - `emb:functions/f_generateprescriptionlog:7`: replace `p.*` with the explicit column list in the same order as `prescriptionheaderlog`; schema drift, not dialect.
7. **Dynamic SQL** - extend `rebuild/web/src/runtime/dynsql.ts` only for safe DML translations (`convert`, `dateadd`, `datediff`, `charindex`, `+` concat, `top`); for `ALTER PROCEDURE`, backup/restore, `DBCC`, `KILL`, and linked-server settings, keep an explicit "not supported" error rather than pretending success. The 128 dynamic sites are in `statements.json` with their `builder` assignments.
8. **Schema/object gaps** - separate data-model decision. `customer.code` -> `customer.custcode`, `godowndetail.reorderqty` -> `item.reorderqty`, and `preferences.terms` -> `preferences.quartterms1` are only safe if live SQL Server semantics confirm the equivalence; `salesman.password` needs a password-source decision because the rebuild stores it in `users.password`; `dbo.script` is the schema-upgrade table and should be recreated if the upgrade path is to run.
9. **`SUBSTRING`** - leave it. It is valid PostgreSQL and all 158 statements `PREPARE` clean. Do not rewrite to `substr` for style; that adds risk without changing behaviour.
10. **`GETDATE()` portability** - if the rebuild will run outside Pakistan, replace the hardcoded `(now() AT TIME ZONE 'Asia/Karachi')` with `localtimestamp(3)` or a session `TimeZone` setting. If statement-start semantics matter for audit rows, use `statement_timestamp()` instead of `now()`.

---

## 7. Validation and caveats

- **How the 59 were found:** `PREPARE p AS <sql>` on PostgreSQL 17 for every `stmt` and `dw` statement, in a read-only transaction with savepoints. 1,846 `stmt` and 8,607 `dw` prepared clean; 16 + 43 failed. This matches the last CI record in `deploy/parity/PARITY-COVERAGE.md` (1,846/1,862 and 8,607/8,666).
- **Why 59 is not the runtime failure count:** `server/src/sqlsub.rs` substitutes `$n` with literals rather than binding typed parameters. `PREPARE` without types is stricter for some statements and looser for others. Re-planning with representative typed literals cleared most of the 15 parameter-sensitive cases. The report therefore uses **44 hard + 2 parse-clean wrong casts + 2 decimal-literal arithmetic = 48 confirmed** and keeps the remaining parameter-sensitive cases separate.
- **`SUBSTRING` is not a gap:** 158 DataWindows retain `substring(...)`, but PostgreSQL accepts the same three-argument comma syntax; all 158 `PREPARE` clean. The only semantic edge cases are negative/zero start, and none were found.
- **Counts are entries, not occurrences:** the table in section 2 counts distinct `stmt` keys / `dw` names. The build source has 12,271 translated records; many duplicate statements collapse to the 1,862 runtime keys.
- **Timezone:** the runtime bundle uses `(now() AT TIME ZONE 'Asia/Karachi')::timestamp(3)` for `GETDATE()`; the server `TimeZone` is `Asia/Karachi`, so this matches the current installation. It is transaction-stable, while SQL Server `GETDATE()` is statement-stable.
- **No live SQL Server app was run, and no database row was changed.** The only file written by this audit is this report.

---

## 8. Post-audit fixes applied (same day)

The following findings were fixed after this audit, in `rebuild/web/public/data/sql.json`, its `dist` copy, and `data/sql/statements.json`:

| Finding | Fix | Validation |
|---|---|---|
| `emb:salewin/w_sale:18610`, `:18641` — `citext` batch cast to `timestamp` | `batch = ($4)::citext`, `gcode = ($3)::smallint` | `PREPARE` passes with `(integer,integer,text,text)` |
| `emb:salereturncomponents/w_salereturn:2168` — unbound `ld_newavgprice` | `newavgprice = ($3)::numeric`; added `ld_newavgprice` to params/types | `PREPARE` passes with `(numeric,integer,numeric)` |
| 9 report `UNION` type mismatches | typed the untyped NULL/notes branches: `NULL::integer`, `NULL::smallint`, `NULL::timestamp`, `notes.notecode::integer`; inner cash-flow `NULL AS glvochcode` → `NULL::integer` | all nine `PREPARE` clean: `d_cashflow_onecashacc[_patient]`, `d_daily_saleand_service_summary[_patient]`, `d_dailysale_sr_sum_inv_type_wise2`, `d_workorder_printout`, `d_alazizdist_/d_unitedmedicine_/d_unitedpharma2_wholesaleinvreport_full` |

The remaining `PREPARE` failures are the dynamic/admin/schema-drift cases in section 3; no residual T-SQL was introduced.

## 9. Post-audit fixes - 2026-11-03

| Finding | Fix | Validation |
|---|---|---|
| `getitemavgprice` / `getmaxutn` and 4 other procedures read `_rc` before `GET DIAGNOSTICS` | inserted `GET DIAGNOSTICS _rc = ROW_COUNT;` at 6 scalar-`SELECT` sites in `60_procedures.sql` | `sp_getitemavgprice(9801,0)` returns `4.87595|0`; Purchase posting completes |
| `d_chemistwisesale`, `d_custdata_hilton` blocked by `SOUNDEX` | `fuzzystrmatch` extension + translator mapping `soundex(x) -> soundex((x)::text)` | both `PREPARE` clean; Hilton executes and returns 2 rows |
| Purchase/wholesale DataWindow NULL defaults | initial values added for `unitsalestax`, `gstperc`, `discperc`, `itemflatdisc`, `gstno`, `invgstperc1`, `flatdisc`, `printwaranty`, `invoicesize`, `unreceivedbalance` | Purchase and Credit Sale saves complete with no NULL-constraint errors |
| Credit-sale `choose case ii_saletype` trailing `return` | removed by the runtime/builder class fix | Credit Sale 588882 saved and posted |

All 9 remaining system/admin DataWindows were then mapped as well: `d_databasesname` -> `pg_database`; `ddd_*columnlist` -> `information_schema.columns`; `d_conectionmonitorlist*` -> `pg_stat_activity`; `d_linkedservers` and the two backup-schedule views return honest empty typed result sets (PostgreSQL has no SQL Server linked servers / Agent schedules). All nine `PREPARE` clean; the catalog/activity queries return real rows.

## 10. Current PREPARE audit - 2026-11-04

Re-run against `web/public/data/sql.json` on `trader_write_test`:

| Measure | Result |
|---|---:|
| Statements / DataWindows prepared | **11,120 clean** |
| Remaining `PREPARE` failures | **57** |
| Parameter-type inference (only fails without typed parameters; runtime substitutes literals) | **30** |
| References an object/column absent from the live SQL Server schema too | **26** |
| Genuine translation bug in a statement that is itself invalid in the original schema | **1** |

The 26 schema references were checked against SQL Server: `Salesman.Password`,
`Preferences.Terms`, `Script`, `Lockers`, `ClinicTest`, `DepartmentSection`,
`BalanceCategory`, `GroupItemWisePurExpTemplate`, `GroupItemWiseReceiptExpTemplate`,
`Customer.Code`, `GodownDetail.ReorderQty`, `DispatchHeader.BiltyNumber`,
`UserAttendance.In_DateTime`, `ItemPacking.ICatCode`, `ItemCategory.PackCode` and
`ItemClass.CatCode` do not exist in the live SQL Server database. Those statements
are dead in the original application as well; creating replacement columns would
invent a schema rather than restore parity.

The one remaining INSERT (`PrescriptionHeaderLog`) selects 16 expressions for a
15-column target in both databases; the original T-SQL has the same mismatch.

The 9 admin and 6 report translations are re-applied at runtime by
`web/src/runtime/sql-fixes.ts`, so a generated `sql.json` rewrite cannot remove
them.

The real report/function defects found by this audit were fixed: missing
`saleledger` alias in two copied sale reports, ambiguous `printbalance`/`headerno`,
strict `GROUP BY` in the transit-stock crosstab, a wrong table alias in the student
service template, and the one-argument `sp_CRS_Fetch_ItemStockPosition` signature
(now reads the local `view_crs_itemstockposition`).

## 11. Per-entry verification of the 57 remaining PREPARE entries - 2026-11-04

The 57 entries were not just counted; each one was checked and classified.

### 30 parameter-inference entries: verified harmless

`tools/tsql/typed_prepare_audit.py` rebuilds the bind list with the DataWindow
argument types (and PowerBuilder host-variable prefixes for embedded SQL) and runs
`PREPARE audit (type, ...) AS ...`.

```text
parameter entries: 30
typed PREPARE ok: 30 / 30
problems: 0
```

The runtime substitutes typed literals into `$n`, so these statements execute.
The plain audit only fails because `PREPARE` without a type list leaves `$n`
untyped.

### 26 schema entries: dead in the live SQL Server database too

Each referenced object/column was checked against `sys.objects` / `sys.columns`
of `FazalDinPP19DataBaseV2` (786 tables/views, 12,849 columns dumped):

| Entry | Missing reference | Live SQL Server |
|---|---|---|
| 2 x `stmt` Script sequence | `dbo.Script` | absent |
| `stmt` max customer code | `Customer.Code` | absent (only `CustCode`) |
| 2 x `stmt` salesman password | `Salesman.Password` | absent (`Users.Password` exists) |
| `stmt` issue-request stock gate | `IssueReqDetail.GCode` | absent |
| 2 x `stmt` group item templates | `GroupItemWisePurExpTemplate`, `GroupItemWiseReceiptExpTemplate` | absent |
| `stmt` lockers | `dbo.Lockers` | absent |
| 3 x `stmt` duplicate-code checks | `ItemPacking.ICatCode`, `ItemCategory.PackCode`, `ItemClass.CatCode` | absent |
| 4 x `dw` preferences | `Preferences.Terms` | absent |
| `dw` d_password | `Salesman.Password` | absent |
| `dw` d_issueform | `GodownDetail.OptimumQty` | absent |
| 2 x `dw` test screens | `dbo.ClinicTest` | absent |
| `dw` d_departmentsection | `dbo.DepartmentSection` | absent |
| `dw` ddd_balancecat | `dbo.BalanceCategory` | absent |
| 2 x `dw` godown detail | `GodownDetail.ReorderQty` | absent |
| `dw` d_dispatachlist | `DispatchHeader.BiltyNumber` | absent |
| `dw` d_userattendance | `UserAttendance.In_DateTime` | absent |

These statements are dead in the original application as well; adding columns
would invent a schema rather than restore parity. They are not on the sale,
purchase, return or report paths that were exercised.

### 1 insert: invalid in the original T-SQL

`functions/f_generateprescriptionlog:7`

```sql
INSERT PrescriptionHeaderlog
SELECT LogID = :ll_logid, LogDate = :adt_server_datetime, P.*
FROM PrescriptionHeader P WHERE P.PresCode = :al_prescode
```

`PrescriptionHeader` has 14 columns, so the select list has 16 expressions
(2 + 14). `PrescriptionHeaderLog` has 15 columns. The same mismatch exists in
T-SQL; the translation is faithful and the statement is dead in the original.

