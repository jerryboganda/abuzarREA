$ErrorActionPreference = 'Stop'
try {
  $cn = New-Object System.Data.OleDb.OleDbConnection('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Projects\Abuzar\deploy\Application\Script.mdb;Mode=Read')
  $cn.Open()
  $cm = $cn.CreateCommand()
  $cm.CommandText = "SELECT sequenceid, query FROM [script] WHERE query LIKE '%xp_cmdshell%' OR query LIKE '%OPENROWSET%'"
  $r = $cm.ExecuteReader()
  while ($r.Read()) {
    $q = $r.GetString(1)
    $masked = $q -replace "'[^']{1,80}'", "'<literal>'"
    if ($masked.Length -gt 500) { $masked = $masked.Substring(0, 500) }
    'SEQ ' + $r.GetValue(0) + ': ' + $masked
  }
  $r.Close()
  $cm.CommandText = "SELECT sequenceid, query FROM [script] WHERE query LIKE '%password%'"
  $r = $cm.ExecuteReader()
  $ids = @()
  while ($r.Read()) { $ids += [string]$r.GetValue(0) }
  $r.Close()
  'PASSWORD_SCRIPT_SEQS: ' + ($ids -join ',')
  $cn.Close()
} catch { 'ERR: ' + $_.Exception.Message }
