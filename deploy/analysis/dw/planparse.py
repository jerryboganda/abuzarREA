import csv, collections, io, sys

fn = "plan_m8_u8.txt"
lines = open(fn, encoding="utf-8-sig", errors="replace").read().splitlines()
start = next((i for i, l in enumerate(lines) if l.startswith("StmtText|")), None)
if start is None:
    print("no header")
    sys.exit()
rows = list(csv.DictReader(io.StringIO("\n".join(lines[start:])), delimiter="|"))
print("plan rows", len(rows))
ops = collections.Counter((r.get("PhysicalOp") or "").strip() for r in rows)
print("physical ops:")
for k, v in ops.most_common(20):
    print(f"  {v:5d} {k}")
print("\nscans/seeks:")
for r in rows:
    op = (r.get("PhysicalOp") or "").strip()
    if op in ("Table Scan", "Clustered Index Scan", "Index Scan",
              "Clustered Index Seek", "Index Seek"):
        print(f'  {op:22s} est={r.get("EstimateRows",""):>8s} '
              f'execs={r.get("EstimateExecutions",""):>10s} {r.get("Argument","")[:160]}')
print("\ntop cost nodes:")
for r in sorted(rows, key=lambda r: float(r.get("TotalSubtreeCost") or 0), reverse=True)[:12]:
    print(f'  {float(r.get("TotalSubtreeCost") or 0):10.2f} '
          f'{(r.get("PhysicalOp") or "").strip():24s} est={r.get("EstimateRows",""):>8s} '
          f'{r.get("Argument","")[:120]}')
