param(
    [string]$Database = 'trader',
    [string]$PgBin = 'C:\PostgreSQL\17\bin',
    [string]$PgUser = 'postgres',
    [string]$PgPassword = 'postgres',
    [string]$SchemaDir = 'C:\Projects\Abuzar\deploy\parity\rebuild-dist'
)
$ErrorActionPreference = 'Stop'
$env:PGPASSWORD = $PgPassword
$psql = Join-Path $PgBin 'psql.exe'
if (-not (Test-Path $psql)) { throw "psql not found: $psql" }

Write-Output "=== recreate database $Database ==="
& $psql -h 127.0.0.1 -U $PgUser -d postgres -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS $Database;"
if ($LASTEXITCODE -ne 0) { throw "drop database failed" }
& $psql -h 127.0.0.1 -U $PgUser -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE $Database;"
if ($LASTEXITCODE -ne 0) { throw "create database failed" }

# Schema only. The seed/bootstrap files (85_base, 90_seed, 92_menu_rights,
# 95_bootstrap, 96_rights_profile) are deliberately skipped: the live SQL
# Server data is loaded instead. 86_jobs creates dbo.sysjobs before functions
# that reference it.
$files = @(
    '00_init.sql',
    '10_tables.sql',
    '20_foreign_keys.sql',
    '30_indexes.sql',
    '86_jobs.sql',
    '40_functions.sql',
    '50_views.sql',
    '60_procedures.sql',
    '70_triggers.sql',
    '80_audit.sql'
)
foreach ($f in $files) {
    $path = Join-Path $SchemaDir $f
    Write-Output "=== $f ==="
    & $psql -h 127.0.0.1 -U $PgUser -d $Database -v ON_ERROR_STOP=1 -q -f $path
    if ($LASTEXITCODE -ne 0) { throw "schema file failed: $f" }
}

Write-Output '=== object counts ==='
& $psql -h 127.0.0.1 -U $PgUser -d $Database -At -c @"
SELECT 'tables=' || COUNT(*) FROM information_schema.tables WHERE table_schema='dbo' AND table_type='BASE TABLE';
SELECT 'functions=' || COUNT(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='dbo';
SELECT 'views=' || COUNT(*) FROM information_schema.views WHERE table_schema='dbo';
"@
