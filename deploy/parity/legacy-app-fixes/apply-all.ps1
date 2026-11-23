# Re-apply the legacy PowerBuilder client fixes on this machine.
# Run from an elevated PowerShell while abuzar.exe is closed.
#
#   powershell -ExecutionPolicy Bypass -File apply-all.ps1
#
# The script does not start SQL Server Agent.  It only defines the job objects
# the legacy Job Schedule / Preferences screens expect.
param(
    [string]$AppDir = 'C:\Projects\Abuzar\deploy\Application',
    [string]$SqlInstance = '.\SQLEXPRESS2022',
    [switch]$SkipPatch,
    [switch]$SkipJobs,
    [switch]$SkipGroup
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $SkipPatch) {
    Write-Host '== Patching the PBD version gate =='
    python -I (Join-Path $here 'patch-pbd-version.py') --app-dir $AppDir
}

if (-not $SkipJobs) {
    Write-Host '== Creating the vendor SQL Agent jobs =='
    # First pass: the clean vendor exports that survived extraction intact.
    Get-ChildItem (Join-Path $here 'jobs-clean') -Filter *.sql | Sort-Object Name | ForEach-Object {
        & sqlcmd -S $SqlInstance -E -C -i $_.FullName 2>&1 | Out-Null
    }
    # Second pass: clean definitions for the jobs whose vendor text was split
    # at an extraction boundary (also creates AutoPostVisit and the stock report job).
    & sqlcmd -S $SqlInstance -E -C -b -i (Join-Path $here 'create-missing-jobs.sql')
    if ($LASTEXITCODE -ne 0) { throw 'create-missing-jobs.sql failed' }
    # Repair the schedule name that the first vendor extraction split.
    & sqlcmd -S $SqlInstance -E -C -b -i (Join-Path $here 'repair-autobackupclient.sql')
    if ($LASTEXITCODE -ne 0) { throw 'repair-autobackupclient.sql failed' }
}

if (-not $SkipGroup) {
    Write-Host '== Allowing the legacy groups to see the default customer category =='
    & sqlcmd -S $SqlInstance -E -C -b -i (Join-Path $here 'customer-group-category.sql')
    if ($LASTEXITCODE -ne 0) { throw 'customer-group-category.sql failed' }
}

Write-Host '== Verification =='
& sqlcmd -S $SqlInstance -E -C -d msdb -h -1 -W -Q "SET NOCOUNT ON; SELECT 'jobs='+CONVERT(varchar,COUNT(*)) FROM dbo.sysjobs; SELECT 'backup-schedule='+s.name FROM dbo.sysjobs j JOIN dbo.sysjobschedules js ON js.job_id=j.job_id JOIN dbo.sysschedules s ON s.schedule_id=js.schedule_id WHERE j.name='autobackupclient'"
& sqlcmd -S $SqlInstance -E -C -d FazalDinPP19DataBaseV2 -h -1 -W -Q "SET NOCOUNT ON; SELECT 'group-mappings='+CONVERT(varchar,COUNT(*)) FROM dbo.CustomerGroupCategory"
Write-Host 'Done. Start abuzar.exe for the PBD change to take effect.'
