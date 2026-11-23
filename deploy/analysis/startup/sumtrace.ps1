$rows = Get-Content C:\Projects\Abuzar\deploy\analysis\startup\trace_events.psv | Where-Object {$_ -match '^\d{4}-'} | ForEach-Object { $p=$_ -split '~',5; [pscustomobject]@{t=[datetime]::ParseExact($p[0],'yyyy-MM-dd HH:mm:ss.fff',$null); dur=[int]$p[1]; app=$p[3]; txt=$p[4]} }
$defs = @(
  @('connect-setup','sp_oledb_ro_usrname|sp_provider_types_rowset|sp_procedure_params_rowset|SET QUOTED_IDENTIFIER|implicit_transactions'),
  @('cleanup','SP_CleanUp_Bad_Session'),
  @('firsttime-ddl','SysColumns|Syscolumns|Syscatelog|sysobjects'),
  @('client-instance','ClientInstance'),
  @('login-user','FROM dbo.users'),
  @('firsttimelic','Max \( SaleInvCode \)'),
  @('license','Systextcatalog|systextcatalog|sp_ReturnDateTime|Sequence'),
  @('waytomoon','WayToMoon'),
  @('cursor-plumbing','sp_cursor')
)
foreach($d in $defs){ $m=$rows | Where-Object {$_.txt -match $d[1]}; [pscustomobject]@{Phase=$d[0];Events=$m.Count;BusyMs=[math]::Round((($m|Measure-Object dur -Sum).Sum)/1000,1)} }
