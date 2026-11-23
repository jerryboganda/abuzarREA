"""Compare every common SQL Server/PostgreSQL table: row count and numeric sums."""
import csv
from decimal import Decimal
import pyodbc
import psycopg

MSSQL = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=.\\SQLEXPRESS2022;DATABASE=FazalDinPP19DataBaseV2;"
    "Trusted_Connection=yes;TrustServerCertificate=yes;"
)
PG = "dbname=trader user=postgres password=postgres host=127.0.0.1 port=5432"
OUT = r"C:\Projects\Abuzar\deploy\parity"

MS_NUM = {"int", "bigint", "smallint", "tinyint", "decimal", "numeric", "money", "smallmoney", "float", "real"}
MS_INT = {"int", "bigint", "smallint", "tinyint"}
PG_NUM = {"smallint", "integer", "bigint", "numeric", "real", "double precision", "money"}

ms = pyodbc.connect(MSSQL, autocommit=True)
pg = psycopg.connect(PG, autocommit=True)
mc = ms.cursor()
pc = pg.cursor()

ms_tables = {r[0].lower(): r[0] for r in mc.execute(
    "SELECT t.name FROM sys.tables t WHERE t.schema_id=SCHEMA_ID('dbo') AND t.is_ms_shipped=0")}
pg_tables = [r[0] for r in pc.execute(
    "SELECT table_name FROM information_schema.tables WHERE table_schema='dbo' AND table_type='BASE TABLE'")]
common = [p for p in pg_tables if p.lower() in ms_tables]

count_rows = []
sum_rows = []
mismatch_counts = 0
mismatch_sums = 0
total_ms = 0
total_pg = 0

for p in common:
    m = ms_tables[p.lower()]
    n_ms = mc.execute(f"SELECT COUNT(*) FROM [dbo].[{m}]").fetchone()[0]
    n_pg = pc.execute(f'SELECT COUNT(*) FROM dbo."{p}"').fetchone()[0]
    total_ms += n_ms
    total_pg += n_pg
    ok = n_ms == n_pg
    if not ok:
        mismatch_counts += 1
    count_rows.append([m, p, n_ms, n_pg, "OK" if ok else "MISMATCH"])

    ms_cols = {r[0].lower(): (r[0], r[1]) for r in mc.execute(
        "SELECT c.name, ty.name FROM sys.columns c JOIN sys.types ty ON c.user_type_id=ty.user_type_id "
        "WHERE c.object_id=OBJECT_ID(?) AND c.is_computed=0", (f"dbo.{m}",))}
    pg_cols = {r[0].lower(): (r[0], r[1]) for r in pc.execute(
        "SELECT column_name, data_type FROM information_schema.columns "
        "WHERE table_schema='dbo' AND table_name=%s", (p,))}
    for key in sorted(set(ms_cols) & set(pg_cols)):
        mcol, mtype = ms_cols[key]
        pcol, ptype = pg_cols[key]
        if mtype.lower() not in MS_NUM or ptype.lower() not in PG_NUM:
            continue
        try:
            msum = f"SUM(CAST([{mcol}] AS decimal(38,0)))" if mtype.lower() in MS_INT else f"SUM([{mcol}])"
            a = mc.execute(f"SELECT {msum} FROM [dbo].[{m}]").fetchone()[0]
            b = pc.execute(f'SELECT SUM(CAST("{pcol}" AS numeric)) FROM dbo."{p}"').fetchone()[0]
        except Exception as e:
            sum_rows.append([m, p, pcol, "ERR", str(e)[:120], "ERROR"])
            mismatch_sums += 1
            continue
        if a is None and b is None:
            continue
        a = Decimal(str(a or 0))
        b = Decimal(str(b or 0))
        tol = max(Decimal("0.01"), abs(a) * Decimal("0.000000001"))
        ok = abs(a - b) <= tol
        if not ok:
            mismatch_sums += 1
        sum_rows.append([m, p, pcol, str(a), str(b), "OK" if ok else "MISMATCH"])

with open(f"{OUT}\\all-counts.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["sqlserver_table", "postgres_table", "ms_rows", "pg_rows", "status"])
    w.writerows(count_rows)
with open(f"{OUT}\\all-sum-mismatches.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["sqlserver_table", "postgres_table", "column", "ms_sum", "pg_sum", "status"])
    w.writerows([r for r in sum_rows if r[-1] != "OK"])

print(f"common tables={len(common)} count_mismatches={mismatch_counts} numeric_sum_mismatches={mismatch_sums}")
print(f"rows ms={total_ms} pg={total_pg}")
for r in count_rows:
    if r[-1] != "OK":
        print("COUNT", r)
for r in sum_rows:
    if r[-1] != "OK":
        print("SUM", r)
print(f"wrote {OUT}\\all-counts.csv and all-sum-mismatches.csv")

