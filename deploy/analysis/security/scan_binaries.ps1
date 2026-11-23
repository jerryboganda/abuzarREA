$ErrorActionPreference = 'SilentlyContinue'
$needles = @('Script.mdb','script.mdb','sequenceid','SequenceId','mdsys.exe','sysdrv.dll','systemab','tapi161','xp_cmdshell','SP_WayToMoon','sp_waytomoon')
$files = Get-ChildItem 'C:\Projects\Abuzar\deploy\Application' -File | Where-Object { .Extension -in '.exe','.pbd','.dll' }
foreach ($f in $files) {
  $b = [IO.File]::ReadAllBytes($f.FullName)
  $a = [Text.Encoding]::ASCII.GetString($b)
  $u = [Text.Encoding]::Unicode.GetString($b)
  foreach ($n in $needles) {
    if ($a.IndexOf($n, [StringComparison]::OrdinalIgnoreCase) -ge 0 -or $u.IndexOf($n, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      $f.Name + ' :: ' + $n
    }
  }
}
