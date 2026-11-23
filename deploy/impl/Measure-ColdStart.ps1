param(
    [string]$Label = (Get-Date -Format 'yyyyMMdd-HHmmss'),
    [int]$RuntimeSeconds = 40,
    [switch]$ClearStandby,
    [switch]$BootCapture
)

$ErrorActionPreference = 'Stop'

$tools   = 'C:\Projects\Abuzar\deploy\impl\tools'
$outDir  = 'C:\Projects\Abuzar\deploy\impl\cold'
$procmon = Join-Path $tools 'Procmon64.exe'
$rammap  = Join-Path $tools 'RAMMap64.exe'
$appDir  = 'C:\Projects\Abuzar\deploy\Application'
$launcher = Join-Path $appDir 'WaseelaLauncher.exe'
New-Item -ItemType Directory -Force $outDir | Out-Null

if (-not (Test-Path $procmon)) { throw "ProcMon not found: $procmon" }
if (-not (Test-Path $launcher)) { throw "Launcher not found: $launcher" }

# A boot capture must not race the logon preload; disable it for the run and
# re-enable it at the end so normal logons keep the fast-start behaviour.
if ($BootCapture) {
    Disable-ScheduledTask -TaskName 'Waseela Preload' -ErrorAction SilentlyContinue | Out-Null
    Write-Output 'Waseela Preload disabled for the duration of the boot capture.'
}

# Stop the app so the capture starts from a clean process.
Get-Process abuzar -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

if ($ClearStandby -and (Test-Path $rammap)) {
    Write-Output 'Clearing standby list (file cache)...'
    $rp = Start-Process -FilePath $rammap -ArgumentList '-AcceptEula','-Et' -PassThru -WindowStyle Hidden
    if (-not $rp.WaitForExit(30000)) { $rp.Kill() }
    Write-Output "RAMMap exit=$($rp.ExitCode)"
    Start-Sleep -Seconds 2
}

$pml = Join-Path $outDir "cold-$Label.pml"
$csv = Join-Path $outDir "cold-$Label.csv"
if (Test-Path $pml) { Remove-Item $pml -Force }

Write-Output 'Starting ProcMon...'
Start-Process -FilePath $procmon -ArgumentList '/AcceptEula','/Quiet','/Minimized','/BackingFile',$pml,
    '/Runtime',$RuntimeSeconds -WindowStyle Hidden
Start-Sleep -Seconds 2

# Persistent SQL connection for first-session timing.
Add-Type -AssemblyName System.Data
$conn = New-Object System.Data.SqlClient.SqlConnection(
    'Server=.\SQLEXPRESS2022;Database=master;Integrated Security=SSPI;Connect Timeout=5')
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT MIN(login_time) FROM sys.dm_exec_sessions WHERE program_name LIKE 'Waseela%'"

$rows = New-Object System.Collections.ArrayList
$start = Get-Date
Write-Output 'Starting launcher...'
Start-Process -FilePath $launcher -WorkingDirectory $appDir

$deadline = $start.AddSeconds(45)
$firstSql = $null
while ((Get-Date) -lt $deadline) {
    $p = Get-Process abuzar -ErrorAction SilentlyContinue | Select-Object -First 1
    $elapsed = ((Get-Date) - $start).TotalMilliseconds
    $cpu = 0.0
    $ws = 0.0
    $title = ''
    if ($p) {
        $cpu = $p.TotalProcessorTime.TotalMilliseconds
        $ws = $p.WorkingSet64 / 1MB
        $title = $p.MainWindowTitle
    }

    try {
        $login = $cmd.ExecuteScalar()
        if ($login -and $login -isnot [DBNull]) {
            $loginTime = [datetime]$login
            if ($loginTime -ge $start) { $firstSql = $loginTime }
        }
    } catch { }

    [void]$rows.Add([pscustomobject]@{
        elapsed_ms = [math]::Round($elapsed, 0)
        cpu_ms     = [math]::Round($cpu, 0)
        ws_mb      = [math]::Round($ws, 1)
        title      = $title
        first_sql  = if ($firstSql) { $firstSql.ToString('HH:mm:ss.fff') } else { '' }
    })

    if ($title) { break }
    Start-Sleep -Milliseconds 200
}

$conn.Close()
Start-Sleep -Seconds 1

Write-Output 'Stopping ProcMon...'
Start-Process -FilePath $procmon -ArgumentList '/Terminate' -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

$timeline = Join-Path $outDir "cold-$Label-timeline.csv"
$rows | Export-Csv -NoTypeInformation -Path $timeline
if (Test-Path $pml) {
    Get-Item $pml | Select-Object Name, Length | Format-List
}

Write-Output 'Exporting ProcMon CSV (may take a few minutes)...'
if (Test-Path $pml) {
    $e = Start-Process -FilePath $procmon -ArgumentList '/OpenLog',$pml,'/SaveAs',$csv,'/Quiet' -PassThru -WindowStyle Hidden
    if (-not $e.WaitForExit(600000)) {
        Write-Output 'ProcMon export timed out; PML retained.'
        $e.Kill()
    } else {
        Write-Output "ProcMon export exit=$($e.ExitCode)"
    }
}
if (Test-Path $csv) {
    Get-Item $csv | Select-Object Name, Length | Format-List
}

Write-Output "Timeline: $timeline"
Write-Output "PML: $pml"
Write-Output "CSV: $csv"

if ($BootCapture) {
    # One-shot boot capture: disable the task after the first run and restore
    # the normal logon preload.
    try {
        Disable-ScheduledTask -TaskName 'Waseela Cold Start Capture' -ErrorAction SilentlyContinue | Out-Null
        Write-Output 'Waseela Cold Start Capture task disabled after boot run.'
    } catch { }
    try {
        Enable-ScheduledTask -TaskName 'Waseela Preload' -ErrorAction SilentlyContinue | Out-Null
        Write-Output 'Waseela Preload re-enabled.'
    } catch { }
}
