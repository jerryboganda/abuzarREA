$starter = Join-Path $PSScriptRoot 'Start-Fiscalization.ps1'

Describe 'Fiscalization listener startup' {
$fixture = Join-Path $TestDrive 'fiscalization-fixture.ps1'

@'
param([string]$Starter, [string]$Scenario)

$global:clock = [datetime]'2026-01-01T00:00:00'
$global:checks = 0
$global:started = $false

function Get-Date {
    [CmdletBinding()]
    param([string]$Format)
    if ($Format) { return $global:clock.ToString($Format) }
    return $global:clock
}
function Get-NetTCPConnection {
    [CmdletBinding()]
    param([int]$LocalPort, [string]$State)
    $global:checks++
    if ($Scenario -eq 'mixed') {
        return @([pscustomobject]@{ OwningProcess = 123 }, [pscustomobject]@{ OwningProcess = 456 })
    }
    if ($Scenario -in @('foreign-listener', 'unexpected-path-listener') -or
        ($Scenario -eq 'delayed-conflict' -and $global:checks -ge 3)) {
        return [pscustomobject]@{ OwningProcess = 456 }
    }
    if ($Scenario -eq 'already' -or ($Scenario -in @('delayed', 'existing-delayed') -and $global:checks -ge 6)) {
        return [pscustomobject]@{ OwningProcess = 123 }
    }
}
function Get-Process {
    [CmdletBinding()]
    param([string]$Name)
    if ($Scenario -in @('unexpected-process', 'unexpected-path-listener')) {
        return [pscustomobject]@{ Id = 456; Path = 'C:\Other\fiscalizationapp.exe' }
    }
    if ($Scenario -eq 'inaccessible-process') {
        return [pscustomobject]@{ Id = 456; Path = $null }
    }
    if ($global:started -or $Scenario -in @('already', 'mixed', 'existing-process', 'existing-delayed')) {
        return [pscustomobject]@{ Id = 123; Path = 'C:\Projects\Abuzar\FiscalizationApp\fiscalizationapp.exe' }
    }
}
function Test-Path {
    [CmdletBinding()]
    param([string]$Path)
    return $Scenario -ne 'missing'
}
function Start-Process {
    [CmdletBinding()]
    param([string]$FilePath, [string]$WorkingDirectory)
    $global:started = $true
    Write-Output 'MOCK_START'
}
function Start-Sleep {
    [CmdletBinding()]
    param([int]$Seconds)
    $global:clock = $global:clock.AddSeconds($Seconds)
    Write-Output 'MOCK_SLEEP'
}
function Add-Content {
    [CmdletBinding()]
    param([string]$Path, [string]$Value)
    Write-Output $Value
}

& $Starter
exit $LASTEXITCODE
'@ | Set-Content -LiteralPath $fixture -Encoding UTF8

function Invoke-ListenerScenario([string]$Scenario) {
    $output = @(& powershell.exe -NoProfile -File $fixture -Starter $starter -Scenario $Scenario 2>&1)
    return [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join "`n") }
}

    It 'does not launch a duplicate when the listener is ready' {
        $result = Invoke-ListenerScenario 'already'
        $result.ExitCode | Should Be 0
        $result.Output | Should Match 'listener already on 9111'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'waits for a listener that starts after five seconds' {
        $result = Invoke-ListenerScenario 'delayed'
        $result.ExitCode | Should Be 0
        $result.Output | Should Match 'listener ready on 9111'
        ([regex]::Matches($result.Output, 'MOCK_START')).Count | Should Be 1
        ([regex]::Matches($result.Output, 'MOCK_SLEEP')).Count | Should Be 5
    }

    It 'waits without launching when an existing process starts listening' {
        $result = Invoke-ListenerScenario 'existing-delayed'
        $result.ExitCode | Should Be 0
        $result.Output | Should Match 'listener ready on 9111'
        $result.Output | Should Not Match 'MOCK_START'
        ([regex]::Matches($result.Output, 'MOCK_SLEEP')).Count | Should Be 5
    }

    It 'fails after the readiness deadline when no listener starts' {
        $result = Invoke-ListenerScenario 'timeout'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'not listening on port 9111 after 60 seconds'
        ([regex]::Matches($result.Output, 'MOCK_START')).Count | Should Be 1
        ([regex]::Matches($result.Output, 'MOCK_SLEEP')).Count | Should Be 30
    }

    It 'times out without launching a duplicate when an existing process never listens' {
        $result = Invoke-ListenerScenario 'existing-process'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'not listening on port 9111 after 60 seconds'
        $result.Output | Should Not Match 'MOCK_START'
        ([regex]::Matches($result.Output, 'MOCK_SLEEP')).Count | Should Be 30
    }

    It 'fails without launching when the executable is missing' {
        $result = Invoke-ListenerScenario 'missing'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'missing executable'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'rejects a listener owned by another process without starting the app' {
        $result = Invoke-ListenerScenario 'foreign-listener'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected process'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'rejects a listener from a same-named executable at another path' {
        $result = Invoke-ListenerScenario 'unexpected-path-listener'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected process'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'rejects a same-named process at another path before launching' {
        $result = Invoke-ListenerScenario 'unexpected-process'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected or inaccessible path'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'does not launch a duplicate when the process path is inaccessible' {
        $result = Invoke-ListenerScenario 'inaccessible-process'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected or inaccessible path'
        $result.Output | Should Not Match 'MOCK_START'
    }

    It 'rejects a foreign listener that appears during startup' {
        $result = Invoke-ListenerScenario 'delayed-conflict'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected process'
        ([regex]::Matches($result.Output, 'MOCK_START')).Count | Should Be 1
    }

    It 'rejects mixed expected and foreign listeners' {
        $result = Invoke-ListenerScenario 'mixed'
        $result.ExitCode | Should Be 1
        $result.Output | Should Match 'unexpected process'
        $result.Output | Should Not Match 'MOCK_START'
    }
}
