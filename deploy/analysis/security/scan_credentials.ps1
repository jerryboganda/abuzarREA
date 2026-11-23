$ErrorActionPreference = 'SilentlyContinue'
$root = 'C:\Projects\Abuzar\recovered\scripts'
$patterns = @(
  'logpass\s*=',
  'password\s*=\s*"',
  'pwd\s*=\s*"',
  'gs_password\s*=',
  'gs_source_pwd\s*=',
  'gs_dropbox_pwd\s*=',
  'smtp',
  'TokenValue',
  'apikey',
  'api_key',
  'http://',
  'https://',
  'logid\s*=\s*"sa"'
)
foreach ($p in $patterns) {
  $hits = Select-String -Path (Join-Path $root '*\*.pbs') -Pattern $p
  if ($hits) {
    $p + ' => ' + $hits.Count
    $hits | Select-Object -First 12 | ForEach-Object {
      $line = $_.Line.Trim()
      $line = $line -replace '"[^"]{2,}"', '"<redacted>"'
      '  ' + $_.Filename + ':' + $_.LineNumber + '  ' + $line
    }
  }
}
