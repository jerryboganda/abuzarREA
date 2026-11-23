$ErrorActionPreference = 'Stop'
try {
  $cn = New-Object System.Data.OleDb.OleDbConnection('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Projects\Abuzar\deploy\Application\Script.mdb;Mode=Read')
  $cn.Open()
  $cm = $cn.CreateCommand()
  foreach ($p in @('xp_cmdshell','BACKUP ','DROP ','ALTER ','CREATE LOGIN','sp_configure','shutdown','OPENROWSET','BULK INSERT','password','sa ')) {
    $cm.CommandText = "SELECT COUNT(*) FROM [script] WHERE query LIKE '%" + $p.Replace("'","''") + "%'"
    $p + ' = ' + $cm.ExecuteScalar()
  }
  $cm.CommandText = 'SELECT MIN(sequenceid), MAX(sequenceid), MIN(date), MAX(date), COUNT(*) FROM [script]'
  $r = $cm.ExecuteReader()
  if ($r.Read()) { 'SEQ: ' + $r.GetValue(0) + '..' + $r.GetValue(1) + ' DATES: ' + $r.GetValue(2) + '..' + $r.GetValue(3) + ' N=' + $r.GetValue(4) }
  $r.Close()
  $cn.Close()
} catch { 'ERR: ' + $_.Exception.Message }
