param()
$root = 'C:\Projects\Abuzar\deploy\parity'
function Invoke-Timeout([string]$file, [string]$argLine, [string]$workdir, [int]$seconds) {
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $file; $psi.Arguments = $argLine; $psi.WorkingDirectory = $workdir
  $psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
  $p = [System.Diagnostics.Process]::Start($psi)
  if (-not $p.WaitForExit($seconds * 1000)) { try { $p.Kill($true) } catch {}; return @{ ok = $false; out = 'TIMEOUT' } }
  return @{ ok = ($p.ExitCode -eq 0); out = ($p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()) }
}
$items = @(
  @{n='004'; p='Reports | Daily Reports | Sale | Sale Summary Inv. Cust Wise'},
  @{n='005'; p='Reports | Daily Reports | Sale | Sale Detail Inv. Wise'},
  @{n='006'; p='Reports | Daily Reports | Sale | Sale Detail (Format 2)'},
  @{n='007'; p='Reports | Daily Reports | Sale | Refused Sales Detail'}
)
foreach ($it in $items) {
  $old = Get-ChildItem (Join-Path $root 'old-final') -File | Where-Object { $_.Name -like "$($it.n)_*.png" } | Select-Object -First 1
  if (-not $old) { "no old capture for $($it.n)"; continue }
  $newOut = Join-Path $root ('new-final\' + $old.Name)
  $args = "`"$root\pw\probe-report-generic.mjs`" `"$($it.p)`" `"$newOut`" `"$($newOut -replace '\.png$','.json')`""
  $r = Invoke-Timeout 'node.exe' $args $root 120
  $v = ($r.out -split "`n" | Select-String -Pattern '"rows"|"fatal"|"title"' | Select-Object -First 3) -join ' / '
  "$($it.n) ok=$($r.ok) $v"
}
