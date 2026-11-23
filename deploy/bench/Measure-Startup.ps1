param(
    [string]$OutDir = 'C:\Projects\Abuzar\deploy\bench\results',
    [int]$TimeoutSeconds = 45,
    [switch]$KeepRunning
)

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force $OutDir | Out-Null

$appDir = 'C:\Projects\Abuzar\deploy\Application'
$launcher = Join-Path $appDir 'WaseelaLauncher.exe'
if (-not (Test-Path $launcher)) { throw "Launcher not found: $launcher" }

Get-Process abuzar -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$started = Get-Date
Start-Process -FilePath $launcher -WorkingDirectory $appDir
$deadline = $started.AddSeconds($TimeoutSeconds)
$title = ''
$appPid = 0

while ((Get-Date) -lt $deadline) {
    $p = Get-Process abuzar -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($p -and $p.MainWindowTitle) {
        $title = $p.MainWindowTitle
        $appPid = $p.Id
        break
    }
    Start-Sleep -Milliseconds 100
}

$elapsed = ((Get-Date) - $started).TotalSeconds
$row = [pscustomobject]@{
    Timestamp = $started.ToString('s')
    ElapsedSeconds = [math]::Round($elapsed, 2)
    Title = $title
    ProcessId = $appPid
    TimedOut = [bool]($title -eq '')
}
$row | Export-Csv -NoTypeInformation -Append -Path (Join-Path $OutDir 'startup.csv')
$row | Format-List

if (-not $KeepRunning -and $appPid -eq 0) {
    Write-Output 'The app did not reach a visible window within the timeout.'
}
