import re
from collections import Counter

s = open(r"C:\Projects\Abuzar\deploy\analysis\dataaccess\item_plan.xml", encoding="utf-8", errors="replace").read()
ops = re.findall(r'PhysicalOp="([^"]+)"', s)
print(Counter(ops))
for m in re.finditer(r'<RelOp [^>]*PhysicalOp="([^"]+)"[^>]*>', s):
    tag = m.group(0)
    if any(k in tag for k in ("Index", "Lookup", "Scan", "Sort")):
        print(tag[:320])
