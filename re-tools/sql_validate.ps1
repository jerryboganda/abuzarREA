# Run the reconstructed schema files against an empty scratch database and report every failing batch.
# usage: powershell -File sql_validate.ps1 -Dir C:\Projects\Abuzar\db\schema -Db SchemaCheck -Log C:\path\validate.log
param([string]$Dir = 'C:\Projects\Abuzar\db\schema', [string]$Db = 'SchemaCheck', [string]$Log = 'C:\Projects\Abuzar\db\validate.log', [string]$Server = '.')

function Exec([string]$database, [string]$sql) {
    $cn = New-Object System.Data.SqlClient.SqlConnection("Server=$Server;Database=$database;Integrated Security=SSPI;TrustServerCertificate=True")
    $cn.Open(); $c = $cn.CreateCommand(); $c.CommandText = $sql; $c.CommandTimeout = 600
    try { [void]$c.ExecuteNonQuery() } finally { $cn.Close() }
}

Exec 'master' "IF DB_ID(N'$Db') IS NOT NULL BEGIN ALTER DATABASE [$Db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$Db]; END"
Exec 'master' "CREATE DATABASE [$Db] COLLATE SQL_Latin1_General_CP1_CI_AS"
$out = New-Object System.Collections.Generic.List[string]
foreach ($f in 'syntax-placeholder') { }
foreach ($file in Get-ChildItem $Dir -Filter '*.sql' | Sort-Object Name) {
    $text = [System.IO.File]::ReadAllText($file.FullName)
    $batches = [regex]::Split($text, '(?im)^\s*GO\s*$') | Where-Object { $_.Trim() -ne '' -and $_.Trim() -notmatch '^(--[^\r\n]*\s*)+$' }
    $ok = 0; $bad = 0
    foreach ($b in $batches) {
        try { Exec $Db $b; $ok++ }
        catch {
            $bad++
            $msg = $_.Exception.InnerException.Message
            if (-not $msg) { $msg = $_.Exception.Message }
            $head = ($b.Trim() -split "`r?`n" | Where-Object { $_ -notmatch '^\s*--' } | Select-Object -First 1)
            $out.Add(("{0}`t{1}`t{2}" -f $file.Name, ($head -replace '\s+', ' ').Substring(0, [Math]::Min(80, $head.Length)), ($msg -replace '\s+', ' ')))
        }
    }
    "{0}: {1} ok, {2} failed" -f $file.Name, $ok, $bad
}
[System.IO.File]::WriteAllLines($Log, $out, (New-Object System.Text.UTF8Encoding($false)))
