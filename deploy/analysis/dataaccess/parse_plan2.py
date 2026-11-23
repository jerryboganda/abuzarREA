import re

s = open(r"C:\Projects\Abuzar\deploy\analysis\dataaccess\item_plan.xml", encoding="utf-8", errors="replace").read()
for m in re.finditer(r'<RelOp [^>]*NodeId="(\d+)"[^>]*PhysicalOp="([^"]+)"[^>]*EstimateRebinds="([^"]*)"[^>]*>', s):
    node, op, rebinds = m.group(1), m.group(2), m.group(3)
    if "Seek" in op or "Scan" in op:
        tail = s[m.end():m.end()+700]
        idx = re.findall(r'<Object [^>]*Index="\[([^\]]+)\]"', tail)
        tbl = re.findall(r'<Object [^>]*Table="\[([^\]]+)\]"', tail)
        print(node, op, "rebinds=", rebinds, "table=", tbl[:1], "index=", idx[:1])
