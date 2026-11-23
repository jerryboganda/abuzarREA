import json
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
def s(r,k,d=0): return (r.get("sql") or {}).get(k,d)
print("== most subqueries ==")
for r in sorted(rows,key=lambda r:-s(r,"subqueries"))[:20]:
    print(f'{s(r,"subqueries"):4d} sub {s(r,"n_tables"):3d}t {s(r,"n_joins"):3d}j {r["bytes"]//1024:4d}K used={r.get("lit_files",0):3d} {r["name"][:46]:46s} {r["lib"][:22]}')
print("\n== most joins ==")
for r in sorted(rows,key=lambda r:-s(r,"n_joins"))[:20]:
    print(f'{s(r,"n_joins"):4d}j {s(r,"n_tables"):3d}t {s(r,"subqueries"):4d}sub {r["bytes"]//1024:4d}K used={r.get("lit_files",0):3d} {r["name"][:46]:46s} {r["lib"][:22]}')
print("\n== largest sql len ==")
for r in sorted(rows,key=lambda r:-s(r,"sql_len"))[:15]:
    print(f'{s(r,"sql_len"):6d} ch {s(r,"n_tables"):3d}t {s(r,"subqueries"):4d}sub used={r.get("lit_files",0):3d} {r["name"][:46]:46s} {r["lib"][:22]}')
print("\n== largest files ==")
for r in sorted(rows,key=lambda r:-r["bytes"])[:15]:
    print(f'{r["bytes"]//1024:5d}K cols={r.get("n_columns",0):3d} txt={r.get("n_text",0):4d} comp={r.get("n_compute",0):4d} sql={s(r,"sql_len"):5d} used={r.get("lit_files",0):3d} {r["name"][:46]:46s} {r["lib"][:22]}')
