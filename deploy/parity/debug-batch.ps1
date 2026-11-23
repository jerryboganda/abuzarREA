$p = 'C:\Projects\Abuzar\deploy\parity\screen-parity\screens-bc.json'
"exists=" + (Test-Path $p)
$s = Get-Content $p -Raw | ConvertFrom-Json
"count=" + $s.Count
"first=" + $s[0].n + " last=" + $s[-1].n
$t = $s | Where-Object { $_.n -ge 69 -and $_.n -le 69 }
"targets=" + $t.Count
$t | ForEach-Object { "n=$($_.n) path=$($_.path)" }
