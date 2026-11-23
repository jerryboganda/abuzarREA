# SQL Server 2022 Express migration runbook

**Purpose:** move the Waseela database from SQL Server 2008 R2 Express to the
free, production-legal SQL Server 2022 Express, side-by-side, with a one-command
rollback.

## Why Express 2022, not Developer

Microsoft’s SQL Server 2022 edition documentation states:

- **Express** is the free entry-level edition for desktop and small server
  applications; it is licensed for production. Limits: **10 GB database**,
  **1,410 MB buffer pool**, 1 socket / 4 cores.
- **Developer** includes Enterprise functionality but is licensed **for
  development and test only, not as a production server**.
- **Standard** is the paid production edition (128 GB buffer pool, 24 cores,
  no 10 GB cap).

Express 2022 is therefore the only **free, legal production** upgrade. It still
adds the features that matter here: modern cardinality estimation, **scalar UDF
inlining**, **interleaved execution**, **columnstore**, **data compression**,
**Query Store**, and **compatibility level 160**.

## What is installed

| Item | Value |
|---|---|
| Installer | `C:\waseela_sql2022\media\SQLEXPR_x64_ENU.exe` |
| Product | Microsoft SQL Server 2022 Express **16.0.1000.6** |
| Signature | **Valid**, Microsoft Corporation |
| Instance | `.\SQLEXPRESS2022` |
| Collation | `SQL_Latin1_General_CP1_CI_AS` (matches the database) |
| Auth | Mixed mode; `sa` enabled for the PB client |
| Protocols | TCP and named pipes |
| Old instance | `.\SQLEXPRESS` — **online, database READ_ONLY, remains the rollback** |

## Live result (2026-11-02)

| Check | Result |
|---|---|
| Instance | `DESKTOP-NQ9K8T3\SQLEXPRESS2022`, **16.0.1000.6 Express** |
| Restore | 347,922 pages in **16.1 s**; row counts exact |
| Compatibility | **160** |
| Query Store | **ON** |
| Page compression | StockReport, VirtualGl, SaleLedger, SaleDetail, StockLedger, ItemLog, Purdetail, PurOrderDetail |
| Reserved space | 2,779,688 KB → **1,295,880 KB** (~1.4 GB smaller) |
| Buffer pool | **1,409 MB** (was 793 MB) |
| `StockReport` one day | **26 reads / 2 ms** |
| `VirtualGl` account-month | **134 reads / 9 ms** |
| `SaleLedger` customer-month | **60 reads / 4 ms** |
| `fn_getSaleInvTotal` | **0 drift** on 1,000 rows; checksums exact |
| Watermark skip | `SP_VirtualGL` **67 ms**, `SP_STOCKLEDGER` **67 ms** |
| App | logged in on the new instance; **Cash Sale with real item rows**; `[Open Cash Sale Return]` opens successfully |
| Fiscalization | restarted on the new instance; **9111** listening |
| Maintenance | retargeted to `SQLEXPRESS2022`; result **0** |
| Old database | **READ_ONLY**; rollback flips it to READ_WRITE |

## Cutover sequence

```powershell
# 0. Fresh verified backup (already done)
#    deploy\impl\backup\FazalDinPP19DataBaseV2_pre_sql2022.bak  (2.85 GB)

# 1. Restore into the new instance
sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -b -i .\impl\10_sql2022_restore.sql

# 2. Migrate: sa, compat 160, page compression, stats, Query Store, probes
sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -b -i .\impl\10_sql2022_migrate.sql

# 3. Point the client alias at the new instance
powershell -ExecutionPolicy Bypass -File .\impl\10_sql2022_switch.ps1

# 4. Log in, open Cash Sale, run a report.
```

## Verification gates

| Gate | Pass condition |
|---|---|
| Instance | `SELECT @@VERSION` shows 16.0.x, Express Edition |
| Restore | Row counts match: SaleLedger 588,865; SaleDetail 1,305,994; VirtualGl 2,004,033; StockReport 2,906,627; StockLedger 1,621,864; Item 28,966 |
| Compatibility | `160` |
| `sa` | `sa` can connect with the application password |
| Probes | Q1/Q2/Q3 totals match the 2008 R2 values; `fn_getSaleInvTotal` 0 drift |
| Watermark | `SP_VirtualGL` and `SP_STOCKLEDGER` return in <100 ms on a warm state |
| App | Login succeeds; main window opens; **Cash Sale** opens with stock; a report opens |
| Fiscalization | Listener still on 9111; a test sale does not raise a fiscalization dialog |
| Maintenance | `Waseela DB Maintenance` task retargeted to `SQLEXPRESS2022`, result 0 |

## Rollback

**Connection only** (the old database was never modified):

```powershell
powershell -ExecutionPolicy Bypass -File .\impl\10_sql2022_rollback.ps1
```

The script restores both the 32-bit and 64-bit `FazalDinPP19` aliases to:

```
DBNMPNTW,\\localhost\pipe\MSSQL$SQLEXPRESS\sql\query
```

Then starts `WaseelaLauncher.exe`. No data restore is needed.

**If the new instance itself is bad:** stop and disable
`MSSQL$SQLEXPRESS2022`, run the rollback script, and leave the old instance
online. The old instance is never stopped by the migration.

## Known risks and mitigations

| Risk | Mitigation |
|---|---|
| PB 12.5 / SQLOLEDB cannot talk to SQL 2022 | TDS is backward compatible; named-pipe alias is unchanged except the instance. Test login + Cash Sale before declaring success. |
| `sa` / mixed mode not enabled | Installer used `/SECURITYMODE=SQL /SAPWD=...`; `10_sql2022_migrate.sql` re-enables `sa`. |
| Collation mismatch | Instance created with `SQL_Latin1_General_CP1_CI_AS`; database keeps its own collation on restore. |
| 10 GB Express cap | Current data is ~2.2 GB used; the cap is not near. |
| 1.41 GB buffer pool | Still 41% more than 2008 R2; combined with page compression it reduces I/O. Standard remains the paid next step. |
| Compatibility 160 plan changes | Probes + app smoke test; rollback to 100 is one `ALTER DATABASE` statement. |
| Compression / rebuild locks | Done on the new instance before cutover, with the client stopped. |
| Named-pipe alias cache | The client is restarted after the alias change. Both 32-bit and 64-bit aliases are updated. |
