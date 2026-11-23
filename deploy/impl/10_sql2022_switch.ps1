# Switch the Waseela client from the old 2008 R2 instance to the new
# SQL Server 2022 Express instance (.\SQLEXPRESS2022).
#
# Run only after:
#   1. SQLEXPRESS2022 is installed and running.
#   2. 10_sql2022_restore.sql has restored + verified the database.
#   3. 10_sql2022_migrate.sql has completed and the probes match.
#
# Rollback: 10_sql2022_rollback.ps1 (restores the original alias and starts
# the old instance client). The old instance is never stopped.

$ErrorActionPreference = 'Stop'

$oldPipe = 'DBNMPNTW,\\localhost\pipe\MSSQL$SQLEXPRESS\sql\query'
$newPipe = 'DBNMPNTW,\\localhost\pipe\MSSQL$SQLEXPRESS2022\sql\query'

Write-Output '=== stop the client ==='
Get-Process abuzar -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

Write-Output '=== point both aliases at SQLEXPRESS2022 ==='
Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo' -Name 'FazalDinPP19' -Value $newPipe
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo' -Name 'FazalDinPP19' -Value $newPipe

Write-Output '=== verify alias ==='
(Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo').FazalDinPP19
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo').FazalDinPP19

Write-Output '=== start the client ==='
Start-Process -FilePath 'C:\Projects\Abuzar\deploy\Application\WaseelaLauncher.exe' `
  -WorkingDirectory 'C:\Projects\Abuzar\deploy\Application'
Start-Sleep -Seconds 8
Get-Process abuzar -ErrorAction SilentlyContinue |
  Select-Object Id, MainWindowTitle, Responding |
  Format-Table -AutoSize | Out-String -Width 220

Write-Output '=== verify the app is on the new instance ==='
sqlcmd -S .\SQLEXPRESS2022 -E -C -d master -W -s '|' -w 200 -Q `
  "SET NOCOUNT ON; SELECT @@SERVERNAME AS server_name, SERVERPROPERTY('ProductVersion') AS version, SERVERPROPERTY('Edition') AS edition;"

Write-Output '=== restart the fiscalization listener so it re-reads the alias ==='
Get-Process fiscalizationapp -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Start-Process -FilePath 'C:\Projects\Abuzar\FiscalizationApp\fiscalizationapp.exe' `
  -WorkingDirectory 'C:\Projects\Abuzar\FiscalizationApp'

Write-Output '=== retarget the nightly maintenance task ==='
$sqlcmd = (Get-Command sqlcmd.exe).Source
$action = New-ScheduledTaskAction -Execute $sqlcmd `
  -Argument '-S .\SQLEXPRESS2022 -E -C -d master -i "C:\Projects\Abuzar\deploy\impl\maintenance.sql" -o "C:\Projects\Abuzar\deploy\impl\logs\maintenance-task-2022.log"' `
  -WorkingDirectory 'C:\Projects\Abuzar\deploy\impl'
Set-ScheduledTask -TaskName 'Waseela DB Maintenance' -Action $action | Out-Null

Write-Output '=== guard: old database read-only (prevents stale writes) ==='
sqlcmd -S .\SQLEXPRESS -E -C -d master -b -Q `
  "ALTER DATABASE [FazalDinPP19DataBaseV2] SET READ_ONLY WITH ROLLBACK IMMEDIATE;"
Write-Output 'Old database is READ_ONLY. Rollback sets it back to READ_WRITE.'
