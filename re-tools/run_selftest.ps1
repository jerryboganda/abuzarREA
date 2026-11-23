# Runs the self test of the rebuilt application (improve/objects/abuzarapp.pbl.src/w_selftest.srw) to its end:
# starts <Folder>\abuzar.exe /selftest, logs in (run_login.ps1), waits; when the program ends before the list is done
# (a window stopped it) it is started again and the test goes on after that window.
#   powershell -File run_selftest.ps1 [-Folder C:\Projects\Abuzar\pbrun] [-MaxStarts 300]
# The list (selftest.list) and the log (selftest.log) are in the run folder.  Only the process started from that folder is
# touched.  The self test itself refuses to run unless the database name contains "test".
param(
  [string]$Folder = 'C:\Projects\Abuzar\pbrun',
  [int]$MaxStarts = 300,
  [int]$QuietSeconds = 240
)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$log = Join-Path $Folder 'selftest.log'
$full = (Resolve-Path $Folder).Path.TrimEnd('\')
function Get-App { Get-Process abuzar -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($full, [StringComparison]::OrdinalIgnoreCase) } }
function Test-Done { (Test-Path $log) -and (Select-String -Path $log -Pattern ' DONE ' -Quiet) }
for ($start = 1; $start -le $MaxStarts; $start++) {
  if (Test-Done) { break }
  if (Get-App) { Get-App | Stop-Process -Force; Start-Sleep -Seconds 2 }
  Start-Process -FilePath (Join-Path $Folder 'abuzar.exe') -ArgumentList '/selftest' -WorkingDirectory $Folder
  $ok = $false
  for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 2
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $here 'run_login.ps1') -Folder $Folder 2>&1
    if ($out -match 'login sent') { $ok = $true; break }
    if (-not (Get-App)) { break }
  }
  if (-not $ok) { "start ${start}: no login ($out)"; Get-App | Stop-Process -Force -ErrorAction SilentlyContinue; continue }
  # wait for the program to end; a log that stays silent for too long means it hangs
  $last = Get-Date; $size = -1
  while (Get-App) {
    Start-Sleep -Seconds 5
    $now = if (Test-Path $log) { (Get-Item $log).Length } else { 0 }
    if ($now -ne $size) { $size = $now; $last = Get-Date }
    elseif (((Get-Date) - $last).TotalSeconds -gt $QuietSeconds) {
      Add-Content -Path $log -Value ("{0} STOPPED 0 driver | no log line for {1} seconds, program ended by the driver" -f (Get-Date -Format 'HH:mm:ss'), $QuietSeconds)
      Get-App | Stop-Process -Force
      break
    }
  }
  "start ${start}: ended, log {0} lines" -f ((Get-Content $log -ErrorAction SilentlyContinue | Measure-Object).Count)
}
if (Test-Done) { 'self test finished' } else { 'self test NOT finished' }
