# Waseela implementation scripts

These are the exact scripts applied to `FazalDinPP19DataBaseV2` on 2026-11-02. They are written to be re-runnable where practical.

## Preconditions

1. A verified full backup exists:
   `C:\Projects\Abuzar\deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak`
2. Stop `abuzar.exe` before running index creation/rebuild scripts (`01`, `07`) — SQL Server 2008 R2 Express cannot rebuild online.
3. Run from an account that can authenticate to `.\SQLEXPRESS`. The current Windows account is a sysadmin, so `-E` works; `sa` also works.

## Apply order

```powershell
$sql = 'sqlcmd.exe'
$server = '.\SQLEXPRESS'

# 1. Indexes + file sizing (stop the app first)
& $sql -S $server -E -C -d master -b -i .\01_indexes.sql

# 2. Statistics + UPDATEUSAGE
& $sql -S $server -E -C -d master -b -i .\02_statistics.sql

# 3. Instance settings + tempdb
& $sql -S $server -E -C -d master -b -i .\03_config.sql

# 4. Stored procedures + disable xp_cmdshell
& $sql -S $server -E -C -d master -b -i .\04_procs.sql

# 5. Preferences
& $sql -S $server -E -C -d master -b -i .\05_prefs.sql

# 6. fn_getSaleInvTotal O(1) rewrite
& $sql -S $server -E -C -d master -b -i .\06_fn_getSaleInvTotal.sql

# 7. Rebuild fragmented hot tables (stop the app first; maintenance window)
& $sql -S $server -E -C -d master -b -i .\07_rebuild.sql

# 8. Verify fragmentation (must run from master)
& $sql -S $server -E -C -d master -b -i .\07_verify_fragmentation.sql

# 9. Validate/trust the untrusted foreign keys
& $sql -S $server -E -C -d FazalDinPP19DataBaseV2 -b -i .\08_fk_validate.sql
```

## Post-implementation state

- Live SQL Server: `DESKTOP-NQ9K8T3\SQLEXPRESS2022` (**16.0.1000.6 Express**), compatibility **160**, Query Store **ON**, page compression on the hot tables, buffer pool **1,409 MB**.
- Old 2008 R2 instance: online, database **READ_ONLY**; rollback via `10_sql2022_rollback.ps1` (sets it back to READ_WRITE).
- 86 previously untrusted FKs: **trusted**; one pre-existing `Purledger`/`TaxCategory` orphan is isolated and its FK is **untrusted but enabled**.
- `deploy\Application`: `Users` read/execute; `C:\waseela_temp`: `Users` modify; `Script.mdb`: read-only.
- `BUILTIN\Users` SQL login: `DENY CONNECT`.
- Fiscalization: `ATL71.DLL` copied to `FiscalizationApp`; listener on **9111**; `FiscalizationMachine=DESKTOP-NQ9K8T3`; logon task `Waseela Fiscalization Listener`.

## Watermark gate

`09_virtualgl_watermark.sql` renames the originals to `SP_VirtualGL_Full` / `SP_STOCKLEDGER_Full` and installs wrappers that skip the incremental pass when `fn_VirtualGLSourceVersion()` is unchanged for <10 minutes.

```powershell
sqlcmd -S .\SQLEXPRESS -E -C -d FazalDinPP19DataBaseV2 -b -i .\09_virtualgl_watermark.sql
```

Live result: `SP_VirtualGL` **2.58 s → 35 ms**; `SP_STOCKLEDGER` **30.7 s → 38 ms**; parity exact.

## SQL Server 2022 Express (free, production-legal)

The 2008 R2 instance stays as the rollback. The new engine is installed
side-by-side as `.\SQLEXPRESS2022`; the client alias is switched only after the
new instance passes parity.

```powershell
# 1. Install SQLEXPRESS2022 from the verified Microsoft media (see sql2022/).
# 2. Restore + migrate (run on the NEW instance):
sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -b -i .\10_sql2022_restore.sql
sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -b -i .\10_sql2022_migrate.sql
# 3. Point the client at the new instance:
powershell -ExecutionPolicy Bypass -File .\10_sql2022_switch.ps1
# Rollback:
powershell -ExecutionPolicy Bypass -File .\10_sql2022_rollback.ps1
```

The migration sets compatibility **160**, page compression, Query Store and
`sa` for the PB client; the 1,410 MB Express buffer and scalar-UDF inlining are
the main free gains. Developer edition is **not** used because it is licensed
for development/test only.

## Code signing

`WaseelaLauncher.exe` is signed with the self-signed certificate
`deploy\impl\WaseelaCodeSigning.cer` (thumbprint
`4CB4FD989CEF1FBB78B44BECD412601AD178351F`, valid to 2036). It verifies
**Valid** on this machine. Import the `.cer` into Trusted Root once on any
additional PC.

## Cold-start diagnostic and preload

```powershell
# Safe cold-file-cache capture (no reboot)
powershell -ExecutionPolicy Bypass -File .\Measure-ColdStart.ps1 -Label coldcache -ClearStandby -RuntimeSeconds 40

# One-shot true reboot capture (currently disabled)
Enable-ScheduledTask -TaskName 'Waseela Cold Start Capture'
# reboot, then inspect C:\Projects\Abuzar\deploy\impl\cold\cold-boot-*
```

`Waseela Preload` starts the app at logon so the cold load happens before the cashier needs it.

## Nightly maintenance

`maintenance.sql` refreshes statistics and rebuilds only indexes that are **>30% fragmented and >1,000 pages**. It is registered as the Windows task:

```
Waseela DB Maintenance
Daily 02:00
sqlcmd -S .\SQLEXPRESS -E -C -d master -i maintenance.sql
```

Manual test:

```powershell
Start-ScheduledTask -TaskName 'Waseela DB Maintenance'
Get-ScheduledTaskInfo -TaskName 'Waseela DB Maintenance'
Get-Content .\logs\maintenance-task.log
```

## Rollback

**Preferred:** restore the verified backup while `abuzar.exe` is stopped.

```sql
RESTORE DATABASE [FazalDinPP19DataBaseV2]
FROM DISK = N'C:\Projects\Abuzar\deploy\impl\backup\FazalDinPP19DataBaseV2_pre_impl.bak'
WITH REPLACE, RECOVERY;
```

**Object-level:** `99_rollback.sql` restores the original procedures/function, drops the new indexes, restores the original indexes, and resets the preference/config values. It was syntax-validated with `SET NOEXEC ON`:

```powershell
sqlcmd -S .\SQLEXPRESS -E -C -d master -b -i .\validate_rollback.sql
```

**ACL/fiscalization/preload:** `99_rollback.ps1` restores the ACLs, re-grants `BUILTIN\Users`, stops/removes the fiscalization listener task, removes `Waseela Preload` and the one-shot cold-capture task, clears `FiscalizationMachine`, and removes the copied `ATL71.DLL`.

The data file is intentionally left at 4 GB; do not shrink it after index creation.

## Files

| File | Purpose |
|---|---|
| `01_indexes.sql` | Pre-size + hot indexes |
| `02_statistics.sql` | Statistics + UPDATEUSAGE |
| `03_config.sql` | ad-hoc/CTFP/tempdb |
| `04_procs.sql` | `SP_WayToMoon`, `SP_StockReport`, `xp_cmdshell=0` |
| `05_prefs.sql` | backup-health/item-refresh prefs |
| `06_fn_getSaleInvTotal.sql` | O(1) function + 9-row adjustment |
| `07_rebuild.sql` | Rebuild five fragmented hot tables |
| `07_verify_fragmentation.sql` | Fragmentation check (run from master) |
| `08_fk_validate.sql` | Validate/trust untrusted FKs |
| `09_virtualgl_watermark.sql` | VirtualGL/StockLedger watermark gate |
| `Start-Fiscalization.ps1` | Logon fiscalization listener starter; waits up to 60 seconds and checks that port 9111 belongs to the expected executable |
| `Start-Fiscalization.Tests.ps1` | Mocked listener-startup regression tests (Pester) |
| `Start-WaseelaPreload.ps1` | Logon Waseela preload |
| `Measure-ColdStart.ps1` | ProcMon cold-cache/boot capture |
| `maintenance.sql` | Nightly stats/rebuild |
| `99_rollback.sql` | Object-level rollback |
| `99_rollback.ps1` | ACL/fiscalization/preload rollback |
| `validate_rollback.sql` | `SET NOEXEC ON` syntax validation |
| `backup/` | Verified pre/post backups |
| `logs/` | Apply/verify logs |
| `cold/` | ProcMon PML/CSV and cold/warm timelines |
| `tools/` | Procmon64.exe, RAMMap64.exe |
| `launcher/` | Native splash launcher source |

Full context and evidence: `..\IMPLEMENTATION-REPORT.md`.
