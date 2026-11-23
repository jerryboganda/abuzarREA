import json, os, subprocess, sys

S = sys.argv[1]
exprs = S + '/exprs.json'
out = S + '/engine_out.jsonl'
n = len(json.load(open(exprs)))
NL = chr(10)
if os.path.exists(out):
    os.remove(out)
start = 0
crashes = 0
while start < n:
    try:
        subprocess.run(['C:/Tools/py32/python.exe', '-I', S + '/dweval3.py', r'C:\Projects\Abuzar\Application\pocomponents.pbd', 'd_purchaseorderdetail', exprs, out, str(start)], timeout=40)
    except subprocess.TimeoutExpired:
        # a modal error dialog of the engine (invalid conversion ...) stops the host: kill it, mark the item, go on
        os.system('taskkill /F /IM python.exe /FI "WINDOWTITLE eq nothing" >nul 2>&1')
        subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process python | Where-Object { $_.Path -like '*py32*' } | Stop-Process -Force"], capture_output=True)
    done = {}
    last = -1
    if os.path.exists(out):
        for line in open(out, encoding='utf-8'):
            j = json.loads(line)
            done[j['i']] = j['r']
            last = max(last, j['i'])
    if last >= n - 1 and done.get(n - 1) != '<PENDING>':
        break
    pend = [i for i, r in done.items() if r == '<PENDING>' and i >= start]
    bad = max(pend) if pend else last + 1
    with open(out, 'a', encoding='utf-8') as f:
        f.write(json.dumps({'i': bad, 'r': '<CRASH>'}) + NL)
    crashes += 1
    start = bad + 1
print('done', n, 'crashes', crashes)
