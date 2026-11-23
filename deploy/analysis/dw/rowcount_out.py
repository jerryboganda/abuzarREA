import glob
import re

for fn in sorted(glob.glob("out_*.txt")):
    s = open(fn, encoding="utf-16", errors="replace").read()
    lines = s.splitlines()
    n = 0
    for l in lines:
        if l.startswith("Table '"):
            break
        n += 1
    data = max(0, n - 2) if n >= 2 else 0
    cpu = re.findall(r"CPU time = (\d+) ms", s)
    el = re.findall(r"elapsed time = (\d+) ms", s)
    print(f"{fn:40s} rows~{data:7d} cpu={cpu[-1] if cpu else '?':>6s} elapsed={el[-1] if el else '?':>6s}")
