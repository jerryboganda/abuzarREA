# Roll the client back to the original 2008 R2 instance.
# The old database was set READ_ONLY by the cutover; this script makes it
# writable again, restores the alias, then restarts the fiscalization listener
# so it connects to the old instance. The old instance is never dropped.

$ErrorActionPreference = 'Stop'
$oldPipe = 'DBNMPNTW,\\localhost\pipe\MSSQL$SQLEXPRESS\sql\query'

Write-Output '=== stop the client ==='
Get-Process abuzar -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

Write-Output '=== make the old database writable again ==='
sqlcmd -S .\SQLEXPRESS -E -C -d master -b -Q `
  "ALTER DATABASE [FazalDinPP19DataBaseV2] SET READ_WRITE;"

Write-Output '=== restore the original alias (both 32-bit and 64-bit) ==='
Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo' -Name 'FazalDinPP19' -Value $oldPipe
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo' -Name 'FazalDinPP19' -Value $oldPipe

Write-Output '=== retarget the nightly maintenance task back to the old instance ==='
$sqlcmd = (Get-Command sqlcmd.exe).Source
$action = New-ScheduledTaskAction -Execute $sqlcmd `
  -Argument '-S .\SQLEXPRESS -E -C -d master -i "C:\Projects\Abuzar\deploy\impl\maintenance.sql" -o "C:\Projects\Abuzar\deploy\impl\logs\maintenance-task.log"' `
  -WorkingDirectory 'C:\Projects\Abuzar\deploy\impl'
Set-ScheduledTask -TaskName 'Waseela DB Maintenance' -Action $action | Out-Null

Write-Output '=== restart the fiscalization listener AFTER the alias switch ==='
Get-Process fiscalizationapp -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Start-Process -FilePath 'C:\Projects\Abuzar\FiscalizationApp\fiscalizationapp.exe' `
  -WorkingDirectory 'C:\Projects\Abuzar\FiscalizationApp'

Write-Output '=== start the client ==='
Start-Process -FilePath 'C:\Projects\Abuzar\deploy\Application\WaseelaLauncher.exe' `
  -WorkingDirectory 'C:\Projects\Abuzar\deploy\Application'
Start-Sleep -Seconds 8
Get-Process abuzar -ErrorAction SilentlyContinue |
  Select-Object Id, MainWindowTitle, Responding |
  Format-Table -AutoSize | Out-String -Width 220

Write-Output '=== verify the old instance ==='
sqlcmd -S .\SQLEXPRESS -E -C -d master -W -s '|' -w 200 -Q `
  "SET NOCOUNT ON; SELECT @@SERVERNAME AS server_name, SERVERPROPERTY('ProductVersion') AS version;"
