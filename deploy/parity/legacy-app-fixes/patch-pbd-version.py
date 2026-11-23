#!/usr/bin/env python3
"""Make the legacy PowerBuilder client use its modern DataWindows on SQL Server 2022.

The original client switches `d_backupschedule` to `d_backupschedule_2012` only
when `sqlca.dbms_version()` contains the literal "SQL Server 2012".  On SQL
Server 2022 the string is "SQL Server 2022 (RTM) ...", so the client keeps the
old DataWindow, whose SQL still references the pre-SQL-2005 `SysJobSchedules`
columns (`Name`, `freq_subday_type`, ...).  That is the source of the
`Invalid column name 'Name'` dialog on Preferences (038) and Job Schedule (060).

This script replaces the UTF-16 literal `SQL Server 2012` with
`SQL Server 2022` in the PBDs that contain the version gate.  The replacement
has exactly the same byte length, so the PBD object layout is unchanged.

It writes a one-time `<file>.legacy-fix-backup` next to every changed PBD.
Run it while the legacy app is closed.

Usage:
    python patch-pbd-version.py
    python patch-pbd-version.py --app-dir "C:\\Projects\\Abuzar\\deploy\\Application"
    python patch-pbd-version.py --dry-run
"""
from __future__ import annotations

import argparse
import os
import shutil
import sys

FILES = [
    "abuzarapp.pbd",
    "datatransfercomponents.pbd",
    "functions.pbd",
    "preferences.pbd",
    "templates.pbd",
]
OLD = "SQL Server 2012".encode("utf-16le")
NEW = "SQL Server 2022".encode("utf-16le")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--app-dir",
        default=r"C:\Projects\Abuzar\deploy\Application",
        help="folder containing abuzar.exe and the PBDs",
    )
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    if not os.path.isdir(args.app_dir):
        print(f"app folder not found: {args.app_dir}", file=sys.stderr)
        return 2
    total = 0
    for name in FILES:
        path = os.path.join(args.app_dir, name)
        if not os.path.isfile(path):
            print(f"skip {name}: not found")
            continue
        data = open(path, "rb").read()
        count = data.count(OLD)
        if not count:
            print(f"ok   {name}: no 2012 literal (already patched or different build)")
            continue
        backup = path + ".legacy-fix-backup"
        if not args.dry_run and not os.path.exists(backup):
            shutil.copy2(path, backup)
        if not args.dry_run:
            open(path, "wb").write(data.replace(OLD, NEW))
        total += count
        print(f"{'would patch' if args.dry_run else 'patched'} {name}: {count} occurrence(s)")
    print(f"total occurrences: {total}")
    if total and not args.dry_run:
        print("close and restart abuzar.exe for the PBD change to take effect")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
