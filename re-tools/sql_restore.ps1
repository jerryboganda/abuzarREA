# Restore the customer .BAK into a scratch database (Windows auth, local default instance).
# usage: powershell -File sql_restore.ps1 -Bak <path> -Db <name>
param([string]$Bak = 'C:\Projects\Abuzar\FazalDinPP19V3DBDump.BAK', [string]$Db = 'TraderRE', [string]$Server = '.')

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

"--- HEADERONLY"
$h = Invoke-Sql "RESTORE HEADERONLY FROM DISK = N'$Bak'"
$h.Tables[0] | Select-Object DatabaseName, ServerName, BackupStartDate, SoftwareVersionMajor, DatabaseVersion, CompatibilityLevel, Compressed, BackupSize | Format-List

"--- FILELISTONLY"
$f = Invoke-Sql "RESTORE FILELISTONLY FROM DISK = N'$Bak'"
$f.Tables[0] | Select-Object LogicalName, Type, @{n='SizeMB';e={[int]($_.Size/1MB)}} | Format-Table -AutoSize

$dp = (Invoke-Sql "SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(260)) p").Tables[0].Rows[0].p
$lp = (Invoke-Sql "SELECT CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS nvarchar(260)) p").Tables[0].Rows[0].p
$moves = @()
foreach ($r in $f.Tables[0].Rows) {
    $ext = if ($r.Type -eq 'L') { 'ldf' } else { 'mdf' }
    $dir = if ($r.Type -eq 'L') { $lp } else { $dp }
    $moves += "MOVE N'$($r.LogicalName)' TO N'$dir${Db}_$($r.LogicalName).$ext'"
}
$sql = "RESTORE DATABASE [$Db] FROM DISK = N'$Bak' WITH " + ($moves -join ', ') + ", REPLACE, STATS = 10"
"--- RESTORE"
$sql
[void](Invoke-Sql $sql 7200)
(Invoke-Sql "SELECT name, state_desc, compatibility_level FROM sys.databases WHERE name = N'$Db'").Tables[0] | Format-Table -AutoSize
