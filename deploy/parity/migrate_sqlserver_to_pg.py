"""
Copy SQL Server tables into the rebuild's PostgreSQL schema.

The schema must already be applied (Apply-RebuildSchema.ps1). Rows are copied
with COPY for speed; tables with identity/generated columns go through a temp
table and INSERT ... OVERRIDING SYSTEM VALUE. Foreign keys and user triggers are
disabled for the session (session_replication_role=replica); the live rows are
already the post-trigger state.

Usage:
  python migrate_sqlserver_to_pg.py --dry-run
  python migrate_sqlserver_to_pg.py --pilot
  python migrate_sqlserver_to_pg.py --all
  python migrate_sqlserver_to_pg.py --tables Item Customer SaleLedger
"""
import argparse
import sys
import pyodbc
import psycopg
from psycopg import sql

MSSQL = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=.\\SQLEXPRESS2022;DATABASE=FazalDinPP19DataBaseV2;"
    "Trusted_Connection=yes;TrustServerCertificate=yes;"
)
PG = "dbname=trader user=postgres password=postgres host=127.0.0.1 port=5432"

PILOT = [
    "Users", "Groups", "Rights", "GroupRights", "UserGroups",
    "Item", "ItemPacking", "GodownDetail", "Godown",
    "Customer", "SaleLedger", "SaleDetail", "VirtualGl",
    "StockReport", "StockLedger",
]


def ms_tables(cur):
    return [r[0] for r in cur.execute(
        "SELECT t.name FROM sys.tables t JOIN sys.schemas s ON t.schema_id=s.schema_id "
        "WHERE t.is_ms_shipped=0 AND s.name='dbo' ORDER BY t.name")]


def pg_tables(cur):
    return [r[0] for r in cur.execute(
        "SELECT table_name FROM information_schema.tables "
        "WHERE table_schema='dbo' AND table_type='BASE TABLE' ORDER BY table_name")]


def ms_columns(cur, table):
    rows = cur.execute(
        "SELECT c.name, c.is_identity, c.is_computed FROM sys.columns c "
        "WHERE c.object_id=OBJECT_ID(?) AND c.is_computed=0 ORDER BY c.column_id",
        (f"dbo.{table}",)).fetchall()
    return [(r[0], bool(r[1]), bool(r[2])) for r in rows]


def pg_columns(cur, table):
    rows = cur.execute(
        "SELECT column_name, is_identity, is_generated, data_type "
        "FROM information_schema.columns WHERE table_schema='dbo' AND table_name=%s "
        "ORDER BY ordinal_position", (table,)).fetchall()
    return [(r[0], r[1] == "YES", r[2] == "ALWAYS", r[3]) for r in rows]


def adapt_row(row, pg_names, pg_types):
    """SQL Server `bit` arrives as Python bool; the generated schema stores
    those as smallint.  PostgreSQL int types will not accept psycopg's bool
    literal (`t`), so convert to the live 1/0 value unless the target is a
    real boolean column."""
    out = []
    for i, v in enumerate(row):
        if isinstance(v, bool) and pg_types.get(pg_names[i]) != "boolean":
            out.append(int(v))
        else:
            out.append(v)
    return tuple(out)


def copy_table(ms_cur, pg, table, pg_table, pairs, identity, pg_types, dry):
    pg_names = [p for p, _ in pairs]
    ms_names = [m for _, m in pairs]
    col_sql = sql.SQL(", ").join(sql.Identifier(c) for c in pg_names)
    ms_select = "SELECT " + ", ".join("[" + c + "]" for c in ms_names) + f" FROM [dbo].[{table}]"
    target = sql.SQL("dbo.") + sql.Identifier(pg_table)
    if dry:
        print(f"  {table} -> dbo.{pg_table}: {len(pairs)} columns")
        return 0
    ms_cur.execute(ms_select)
    n = 0
    if identity:
        tmp = "tmp_" + pg_table
        pg.execute(sql.SQL("DROP TABLE IF EXISTS {}").format(sql.Identifier(tmp)))
        pg.execute(sql.SQL("CREATE TEMP TABLE {} AS SELECT * FROM {} WITH NO DATA").format(
            sql.Identifier(tmp), target))
        with pg.cursor().copy(sql.SQL("COPY {} ({}) FROM STDIN").format(
                sql.Identifier(tmp), col_sql)) as cp:
            while True:
                batch = ms_cur.fetchmany(2000)
                if not batch:
                    break
                for row in batch:
                    cp.write_row(adapt_row(row, pg_names, pg_types))
                    n += 1
        pg.execute(sql.SQL("INSERT INTO {} ({}) OVERRIDING SYSTEM VALUE SELECT {} FROM {}").format(
            target, col_sql, col_sql, sql.Identifier(tmp)))
        pg.execute(sql.SQL("DROP TABLE {}").format(sql.Identifier(tmp)))
    else:
        with pg.cursor().copy(sql.SQL("COPY {} ({}) FROM STDIN").format(target, col_sql)) as cp:
            while True:
                batch = ms_cur.fetchmany(2000)
                if not batch:
                    break
                for row in batch:
                    cp.write_row(adapt_row(row, pg_names, pg_types))
                    n += 1
    return n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pilot", action="store_true")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--tables", nargs="*")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    ms = pyodbc.connect(MSSQL, autocommit=True)
    pg = psycopg.connect(PG, autocommit=False)
    ms_cur = ms.cursor()
    pg_cur = pg.cursor()
    pg_cur.execute("SET session_replication_role = replica")

    all_ms = {t.lower(): t for t in ms_tables(ms_cur)}
    all_pg = pg_tables(pg_cur)
    common = [p for p in all_pg if p.lower() in all_ms]
    missing = [p for p in all_pg if p.lower() not in all_ms]
    print(f"SQL Server tables={len(all_ms)} PostgreSQL tables={len(all_pg)} common={len(common)} missing_in_sqlserver={len(missing)}")
    if missing:
        print("missing in SQL Server:", ", ".join(missing[:20]), "..." if len(missing) > 20 else "")

    wanted = None
    if args.pilot:
        wanted = {t.lower() for t in PILOT}
    elif args.tables:
        wanted = {t.lower() for t in args.tables}

    loaded = []
    for pg_table in common:
        if wanted is not None and pg_table.lower() not in wanted:
            continue
        ms_table = all_ms[pg_table.lower()]
        pg_cols = pg_columns(pg_cur, pg_table)
        pg_types = {c[0]: c[3] for c in pg_cols}
        ms_cols = ms_columns(ms_cur, ms_table)
        ms_by = {c[0].lower(): c for c in ms_cols}
        common_pairs = []
        identity = False
        for name, is_id, is_gen, typ in pg_cols:
            if is_gen:
                continue
            mc = ms_by.get(name.lower())
            if not mc:
                continue
            common_pairs.append((name, mc[0]))
            if is_id:
                identity = True
        if not common_pairs:
            print(f"  SKIP {pg_table}: no common columns")
            continue
        print(f"=== {ms_table} -> dbo.{pg_table}: {len(common_pairs)} columns, identity={identity} ===")
        try:
            n = copy_table(ms_cur, pg, ms_table, pg_table, common_pairs, identity, pg_types, args.dry_run)
            if not args.dry_run:
                pg.commit()
            print(f"  copied {n} rows")
            loaded.append((pg_table, n))
        except Exception as e:
            pg.rollback()
            print(f"  FAILED {pg_table}: {e}")

    if not args.dry_run:
        pg_cur.execute("SET session_replication_role = DEFAULT")
        # Reset sequences for every serial/identity column to MAX(col).
        seq_rows = pg_cur.execute("""
            SELECT table_name, column_name FROM information_schema.columns
            WHERE table_schema='dbo' AND (is_identity='YES' OR column_default LIKE 'nextval%')
        """).fetchall()
        for table, col in seq_rows:
            try:
                pg_cur.execute(
                    sql.SQL("SELECT setval(pg_get_serial_sequence(%s, %s), "
                            "COALESCE((SELECT MAX({}) FROM {}), 1))").format(
                        sql.Identifier(col), sql.SQL("dbo.") + sql.Identifier(table)),
                    (f"dbo.{table}", col))
            except Exception as e:
                pg.rollback()
                print(f"  sequence reset skipped {table}.{col}: {e}")
        pg.commit()
        pg_cur.execute("ANALYZE")
        pg.commit()
    pg.close()
    ms.close()
    print(f"done; loaded {len(loaded)} tables")
    return 0


if __name__ == "__main__":
    sys.exit(main())
