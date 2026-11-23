# Starts Waseela at logon so the cold PBVM/registry load happens before the
# cashier needs the app. Idempotent: the launcher brings an existing instance
# forward instead of starting a second one.
$ErrorActionPreference = 'Stop'
$log = 'C:\Projects\Abuzar\deploy\impl\logs\preload.log'
$appDir = 'C:\Projects\Abuzar\deploy\Application'
$launcher = Join-Path $appDir 'WaseelaLauncher.exe'

function Write-Log([string]$message) {
    Add-Content -Path $log -Value ("{0} {1}" -f (Get-Date -Format 's'), $message)
}

if (Get-Process abuzar -ErrorAction SilentlyContinue) {
    Write-Log 'abuzar already running - preload skipped'
    exit 0
}

if (-not (Test-Path $launcher)) {
    Write-Log "missing launcher: $launcher"
    exit 1
}

Start-Process -FilePath $launcher -WorkingDirectory $appDir
Start-Sleep -Seconds 5

if (Get-Process abuzar -ErrorAction SilentlyContinue) {
    Write-Log 'preload started abuzar'
    exit 0
}

Write-Log 'preload did not start abuzar within 5 seconds'
exit 1
