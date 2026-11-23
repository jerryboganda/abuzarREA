# Starts the Waseela fiscalization TCP listener once per logon.
# Idempotent: does nothing if the expected executable is already listening.
$ErrorActionPreference = 'Stop'
$log = 'C:\Projects\Abuzar\deploy\impl\logs\fiscalization-start.log'
$exe = 'C:\Projects\Abuzar\FiscalizationApp\fiscalizationapp.exe'

function Write-Log([string]$message) {
    Add-Content -Path $log -Value ("{0} {1}" -f (Get-Date -Format 's'), $message)
}

function Get-ListenerStatus {
    $listeners = @(Get-NetTCPConnection -LocalPort 9111 -State Listen -ErrorAction SilentlyContinue)
    $processes = @(Get-Process -Name fiscalizationapp -ErrorAction SilentlyContinue)
    $expectedProcesses = @($processes | Where-Object { $_.Path -eq $exe })
    $expectedIds = @($expectedProcesses | ForEach-Object { $_.Id })
    return [pscustomobject]@{
        Processes = $processes
        ExpectedProcesses = $expectedProcesses
        Listeners = @($listeners | Where-Object { $expectedIds -contains $_.OwningProcess })
        OtherListeners = @($listeners | Where-Object { $expectedIds -notcontains $_.OwningProcess })
    }
}

$status = Get-ListenerStatus
if ($status.OtherListeners.Count -gt 0) {
    Write-Log "port 9111 is also owned by an unexpected process (pid $($status.OtherListeners.OwningProcess -join ', '))"
    exit 1
}
if ($status.Listeners.Count -gt 0) {
    Write-Log "listener already on 9111 (pid $($status.Listeners[0].OwningProcess))"
    exit 0
}

if ($status.ExpectedProcesses.Count -gt 0) {
    Write-Log "fiscalizationapp pid $($status.ExpectedProcesses[0].Id) exists; waiting for port 9111 without starting a duplicate"
} elseif ($status.Processes.Count -gt 0) {
    Write-Log "a fiscalizationapp process exists at an unexpected or inaccessible path; refusing to start a duplicate"
    exit 1
} else {
    if (-not (Test-Path $exe)) {
        Write-Log "missing executable: $exe"
        exit 1
    }
    # At logon the listener can start before SQL Server or the LAN address is
    # up; it then never binds 9111. Wait (max 2 min) for both before starting.
    $prereqDeadline = (Get-Date).AddSeconds(120)
    while ((Get-Date) -lt $prereqDeadline) {
        $sql = Get-Service -Name 'MSSQL$SQLEXPRESS2022' -ErrorAction SilentlyContinue
        $lan = @([System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
            Where-Object { $_.AddressFamily -eq 'InterNetwork' -and
                $_.IPAddressToString -notlike '127.*' -and $_.IPAddressToString -notlike '169.254.*' })
        if ($sql -and $sql.Status -eq 'Running' -and $lan.Count -gt 0) { break }
        Start-Sleep -Seconds 5
    }
    Start-Process -FilePath $exe -WorkingDirectory (Split-Path -Parent $exe)
}

$deadline = (Get-Date).AddSeconds(60)
do {
    Start-Sleep -Seconds 2
    $status = Get-ListenerStatus
    if ($status.OtherListeners.Count -gt 0) {
        Write-Log "port 9111 is also owned by an unexpected process (pid $($status.OtherListeners.OwningProcess -join ', '))"
        exit 1
    }
    if ($status.Listeners.Count -gt 0) {
        Write-Log "listener ready on 9111 (pid $($status.Listeners[0].OwningProcess))"
        exit 0
    }
} while ((Get-Date) -lt $deadline)

Write-Log "fiscalizationapp is not listening on port 9111 after 60 seconds"
exit 1
