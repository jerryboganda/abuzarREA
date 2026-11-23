# Local test server for Claude's UI checks: the production server binary against the scratch copy `waseela_rehearsal`,
# listening on this PC only (127.0.0.1:8790, no token needed there). Never points at the production database `waseela`.
$env:DATABASE_URL = 'postgres://postgres:postgres@127.0.0.1:5432/waseela_rehearsal'
$env:BIND = '127.0.0.1:8790'
$env:STATIC_DIR = 'C:\Waseela\web'
$env:FS_ROOT = 'C:\Projects\Abuzar\.claude\test-files'
$env:MAX_SESSIONS = '60'
$env:PATH = 'C:\PostgreSQL\17\bin;' + $env:PATH
New-Item -ItemType Directory -Force $env:FS_ROOT | Out-Null
& 'C:\Waseela\server\trader-server.exe'
