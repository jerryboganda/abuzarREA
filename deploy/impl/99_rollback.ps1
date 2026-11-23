# Roll back the non-SQL changes made on 2026-11-02:
# - application/temp ACL hardening
# - Script.mdb read-only flag
# - BUILTIN\Users SQL CONNECT denial
# - fiscalization listener / logon task / ATL71.DLL copy / FiscalizationMachine pref
#
# Run 99_rollback.sql separately for the database object/config changes.
# Stop abuzar.exe before running.

$ErrorActionPreference = 'Stop'

$app    = 'C:\Projects\Abuzar\deploy\Application'
$temp   = 'C:\waseela_temp'
$script = Join-Path $app 'Script.mdb'
$fisc   = 'C:\Projects\Abuzar\FiscalizationApp'

Write-Output '=== restore ACLs ==='
icacls $app /grant "NT AUTHORITY\Authenticated Users:(OI)(CI)(M)" /T /C | Out-Null
icacls $temp /grant "NT AUTHORITY\Authenticated Users:(OI)(CI)(M)" /T /C | Out-Null
if (Test-Path $script) {
    Set-ItemProperty -Path $script -Name IsReadOnly -Value $false
    icacls $script /grant "NT AUTHORITY\Authenticated Users:(M)" /C | Out-Null
}

Write-Output '=== restore BUILTIN\Users SQL CONNECT ==='
sqlcmd -S .\SQLEXPRESS -E -C -d master -b -Q "GRANT CONNECT SQL TO [BUILTIN\Users];"

Write-Output '=== stop fiscalization listener and remove logon task ==='
Get-Process fiscalizationapp -ErrorAction SilentlyContinue | Stop-Process -Force
Unregister-ScheduledTask -TaskName 'Waseela Fiscalization Listener' -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName 'Waseela Preload' -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName 'Waseela Cold Start Capture' -Confirm:$false -ErrorAction SilentlyContinue

Write-Output '=== clear FiscalizationMachine preference ==='
sqlcmd -S .\SQLEXPRESS -E -C -d FazalDinPP19DataBaseV2 -b -Q "UPDATE dbo.SoftwarePreferences SET PrefValue='' WHERE Name='FiscalizationMachine';"

Write-Output '=== remove copied ATL71.DLL ==='
$atl = Join-Path $fisc 'ATL71.DLL'
if (Test-Path $atl) { Remove-Item $atl -Force }

Write-Output '=== done. Run 99_rollback.sql for DB objects/config. ==='
