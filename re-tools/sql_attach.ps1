# Copy an unprotected .mdf/.ldf pair into SQL Server's data folder and attach it as a scratch database.
# usage: powershell -File sql_attach.ps1 -Mdf <path> -Ldf <path> -Db TraderRE
param(
    [string]$Mdf = 'C:\Projects\Abuzar\Junk\2024-11-11\Data1\FazalDinPP19V2DB.mdf',
    [string]$Ldf = 'C:\Projects\Abuzar\Junk\2024-11-11\Data1\FazalDinPP19V2Log.ldf',
    [string]$Db = 'TraderRE',
    [string]$Server = '.')

function Invoke-Sql([string]$sql, [int]$timeout = 3600) {
    $cn = New-Object System.Data.SqlClient.SqlConnection("Server=$Server;Database=master;Integrated Security=SSPI;TrustServerCertificate=True")
    $cn.Open()
    $cmd = $cn.CreateCommand(); $cmd.CommandText = $sql; $cmd.CommandTimeout = $timeout
    $da = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    $ds = New-Object System.Data.DataSet
    [void]$da.Fill($ds)
    $cn.Close()
    return $ds
}

$dp = (Invoke-Sql "SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(260)) p").Tables[0].Rows[0].p
$lp = (Invoke-Sql "SELECT CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS nvarchar(260)) p").Tables[0].Rows[0].p
$dm = Join-Path $dp "$Db.mdf"
$dl = Join-Path $lp "${Db}_log.ldf"
"copying to $dm and $dl"
Copy-Item $Mdf $dm -Force
Copy-Item $Ldf $dl -Force
$sql = "CREATE DATABASE [$Db] ON (FILENAME = N'$dm') LOG ON (FILENAME = N'$dl') FOR ATTACH"
try { [void](Invoke-Sql $sql 3600); "attached with existing log" }
catch {
    "attach failed: " + $_.Exception.InnerException.Message
    $sql2 = "CREATE DATABASE [$Db] ON (FILENAME = N'$dm') FOR ATTACH_REBUILD_LOG"
    [void](Invoke-Sql $sql2 3600); "attached with rebuilt log"
}
(Invoke-Sql "SELECT name, state_desc, compatibility_level, collation_name FROM sys.databases WHERE name = N'$Db'").Tables[0] | Format-Table -AutoSize
$cnt = Invoke-Sql "USE [$Db]; SELECT (SELECT COUNT(*) FROM sys.tables) AS tables, (SELECT COUNT(*) FROM sys.procedures) AS procs, (SELECT COUNT(*) FROM sys.views) AS views, (SELECT COUNT(*) FROM sys.foreign_keys) AS fks"
$cnt.Tables[0] | Format-Table -AutoSize
