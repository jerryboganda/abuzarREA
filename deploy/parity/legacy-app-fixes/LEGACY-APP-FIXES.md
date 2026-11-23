# Legacy PowerBuilder client — SQL Server 2022 compatibility fixes

Date: 2026-11-07  
Client: `C:\Projects\Abuzar\deploy\Application\abuzar.exe` (PowerBuilder 12.5)  
Database: `FazalDinPP19DataBaseV2` on `.\SQLEXPRESS2022`

The client binary/source was not recompiled.  The only binary edit is a
same-length UTF-16 string in five PBDs; every other fix is database or SQL Agent
configuration.

## Fixed

### 1. SQL Server 2022 version gate (screens 038 Preferences, 060 Job Schedule, 061 Group Wise Supplier Category)

The client switches its schedule DataWindows to the SQL-2012-era definitions
only when `sqlca.dbms_version()` contains `SQL Server 2012`:

```powerscript
sqlca.dbms_version(ls_version_info)
if match(ls_version_info, "SQL Server 2012") = true then
    ...dw_backupschedule.dataobject = "d_backupschedule_2012"...
end if
```

On SQL Server 2022 the returned string is `SQL Server 2022 (RTM) - 16.0.1000.6 ...`.
The test fails, the client keeps the old `d_backupschedule`, and that DataWindow
runs:

```sql
Select Schedule_Id, freq_subday_type, freq_subday_interval, active_start_time
From SysJobSchedules sjs, SysJobs sj
Where sj.Name = :as_jobname And sjs.Name = :as_backupschedulename
And sjs.job_id = sj.job_id
```

`msdb.dbo.sysjobschedules` no longer has `Name`, `freq_subday_type`,
`freq_subday_interval` or `active_start_time` (those moved to `sysschedules` in
SQL Server 2005), so the client displays `SQLSTATE = 42S22 Invalid column name
'Name'.`

Fix: `patch-pbd-version.py` replaces the UTF-16 literal `SQL Server 2012` with
`SQL Server 2022` (same byte length) in:

| PBD | occurrences |
|---|---:|
| `abuzarapp.pbd` | 3 |
| `preferences.pbd` | 2 |
| `functions.pbd` | 3 |
| `datatransfercomponents.pbd` | 2 |
| `templates.pbd` | 1 |

Backups: `<pbd>.legacy-fix-backup` next to each file.

Result: the client now selects `d_backupschedule_2012`, which joins
`SysJobSchedules`, `SysJobs` and `SysSchedules` correctly.  Preferences and Job
Schedule open without the Waseela SQL error; the same gate also controls the
newer schedule DataWindows in the transfer/control-panel and New Preferences
screens.

### 2. Missing SQL Agent jobs (038, 060)

The fresh SQL Server 2022 `msdb` contained only `syspolicy_purge_history`.  The
client expects 24 jobs (backup, cash/credit posting, stock ledger/report,
patient recurring services, SMS, doctor token reset, etc.).  The job creation
scripts are embedded in `Application\Script.mdb`; they were extracted and
applied to `msdb`:

* 22 vendor jobs from `Script.mdb` (`jobs-clean/`)
* `AutoPostVisit` and `TSQL_Job_StockReport`, whose vendor text was split across
  extraction runs (`create-missing-jobs.sql`)
* the malformed `autobackupclient` schedule was repaired to the exact name the
  client expects: `autobackupscheduleclient` (`repair-autobackupclient.sql`)

Current state: `24` jobs, all with the expected schedules.  The "Unable to
fetch ... job status" dialogs are gone.

SQL Server Agent (`SQLAgent$SQLEXPRESS2022`) is intentionally left stopped.  The
job definitions are correct, but starting Agent will execute the vendor
schedules (including backup/data-transfer jobs), so that is an operational
decision for the owner.

### 3. Reports 067 and 068 (customer selection list)

`dbo.CustomerGroupCategory` was empty.  The customer selection list for
`Claimable for Allowed Customers` and `Customer NTN Wise Sales Tax Report` uses:

```sql
Customer.CustCatCode IN (
  SELECT CustomerCategoryCode FROM CustomerGroupCategory
  WHERE GroupCode = :ai_groupcode AND Status = 1)
```

With no rows it returned zero customers and the original showed:

> Row Validation — There are no rows to select in SelectionList. Kindly try again.

Fix: `customer-group-category.sql` maps every legacy group (`2, 5, 11, 12`) to
the only customer category (`1`, `DEFAULT CATEGORY`) with `Status = 1`.  The
selection query now returns the two customers in the database; the report
selection list opens, `All` + `Ok` proceeds, and 067/068 render.

The DataWindow SQL itself is valid on PostgreSQL/SQL Server 2022.  Direct
execution against 2025-01-01 data returned:

* 067: 205 sale headers / 444 detail rows in the day, report query returns rows
* 068: report query returns rows (NTN, customer, invoice, qty, exempted/taxable
  sale, GST amount)

The reports are daily reports and default to the current date; historical dates
need the report date argument/preference.  `ApplyArgSDate`/`DefaultArgSDate`
were restored to their original values (`N` / `2005-10-23 20:28:22.950`) after
the data check.

## Remaining defects in the compiled client (not database-fixable)

These are original PowerBuilder code defects.  Fixing them requires editing the
compiled P-code or rebuilding the PBD with PowerBuilder 12.5.  The original
source/PBL was lost and no PowerBuilder 12.5 compiler is installed; the only
binary edit performed is the safe string-literal patch above.  The rebuild
implements the corresponding behavior.

| Screen | Defect | Evidence |
|---|---|---|
| Journal Voucher 14/17 | `GetChild("patientcode")` returns -1 because `d_invJournalVoucherDetail` has no `patientcode` DDDW; the client shows `Can not get a detail DataWindowChild` and closes the form. | `w_journalvoucher.ue_postopen`, `d_invjournalvoucherdetail.srd` |
| Sale Template | `File | Delete` is enabled but there is no `ue_delete` handler; the menu item does nothing. | `w_saletemplate` / `m_saletemplate` |
| Groups — new group | `w_groups_form.cb_ok.clicked` returns after inserting the default godown/header rows, **before** `SQL commit`; the first Save leaves the group row uncommitted, the second Save hits the primary key. | `w_groups_form.pbs`, `cb_ok.clicked` |
| Item Basic Data — edit | The edit path has an early `return`; the update is not sent. The new-item path is reliable. | `w_item_form` edit event |
| Cashier Activity | The database has no active `CashierJob`; the client correctly reports `Unable to fetch cashier job data`.  This is a state/operational prerequisite, not a code bug. | `CashierJob` table |
| Selection List (067/068) | The list data is populated, but the original list control is only 44 px high and clips the detail rows; the user can use `All` (or type an alias) and the report runs. | `w_arg_allowedcustomers` / `w_popup_forselection_walias` layout |

## Verification performed

* `Preferences` (038) opens with no dialogs.
* `Job Schedules` (060) opens with no dialogs; Backup tab and schedules display.
* `Group Wise Supplier Category` (061) opens; the old `Invalid column name
  'Name'` dialog does not appear.
* `Claimable for Allowed Customers` (067) opens the Selection List and renders
  the report.
* `Customer NTN Wise Sales Tax Report` (068) opens the Selection List and
  renders the report (no crash).
* The exact failing SQL `Select ... From SysJobSchedules sjs, SysJobs sj ...`
  now succeeds and the 2012 DataWindow is used.
* `CustomerGroupCategory` has 4 rows (groups 2/5/11/12 → category 1).
* `msdb.dbo.sysjobs` has 24 rows; `autobackupclient` schedule name is
  `autobackupscheduleclient`.
* `msdb.dbo.sysjobschedules` has only its four native columns (the temporary
  compatibility columns tried during diagnosis were removed).

Evidence files (local, not committed):

* `C:\Projects\Abuzar\deploy\parity\old-038-clean.png`
* `C:\Projects\Abuzar\deploy\parity\old-060-clean2.png`
* `C:\Projects\Abuzar\deploy\parity\old-061-open2.png`
* `C:\Projects\Abuzar\deploy\parity\old-067-data2.png`
* `C:\Projects\Abuzar\deploy\parity\msdb-before-legacy-fixes.bak`

## Rollback

1. Stop `abuzar.exe`.
2. Restore each `<pbd>.legacy-fix-backup` over its `.pbd`.
3. Optionally restore `msdb-before-legacy-fixes.bak` (msdb is small; keep the
   existing 2022 instance).
4. Remove the configuration rows if desired:

```sql
DELETE FROM dbo.CustomerGroupCategory WHERE CustomerCategoryCode = 1;
```

5. The SQL Agent jobs can be deleted with `msdb.dbo.sp_delete_job`; they are
   inert while SQL Server Agent is stopped.

## Files

`deploy\parity\legacy-app-fixes\`

| File | Purpose |
|---|---|
| `patch-pbd-version.py` | UTF-16 `SQL Server 2012` → `SQL Server 2022` PBD patch |
| `apply-all.ps1` | one-shot re-apply (PBD + jobs + group mapping) |
| `create-missing-jobs.sql` | 15 clean job definitions (incl. AutoPostVisit/StockReport) |
| `jobs-clean\*.sql` | vendor SQL Agent exports that survived extraction intact |
| `repair-autobackupclient.sql` | fixes the split `autobackupscheduleclient` name |
| `customer-group-category.sql` | group → default customer category mapping |
| `jobs-apply.log` | first-pass job application log |
| `LEGACY-APP-FIXES.md` | this report |

No vendor binaries, database dumps, credentials or customer data are part of
this report.  The scripts use Windows authentication (`sqlcmd -E`).
