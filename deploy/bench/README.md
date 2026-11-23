# Waseela performance bench

Two small, read-only measurement helpers.

## 1. Query bench

```powershell
powershell -ExecutionPolicy Bypass -File .\Measure-Queries.ps1 -Label after-indexes
```

Runs the same four SQL probes used in the implementation report and appends a row to `results\summary.csv`.

- `StockReport` one-day aggregate
- `VirtualGl` account-month aggregate
- `SaleLedger` customer-month aggregate
- `fn_getSaleInvTotal` over 1,000 invoices

The output includes `SET STATISTICS IO/TIME ON`, so the logical reads and elapsed ms are captured verbatim.

## 2. Startup bench

```powershell
powershell -ExecutionPolicy Bypass -File .\Measure-Startup.ps1
```

Stops `abuzar.exe`, starts `WaseelaLauncher.exe`, and records the wall time until the first visible `abuzar` window (the Login window) appears. It appends to `results\startup.csv`.

- Use a quiet machine, no backup/AV scan, no other app.
- Run 5 cold (reboot) and 20 warm samples for a meaningful p50/p95.
- The script leaves the app at the Login window.

## Notes

- The app is single-threaded; do not run the bench while a long report is open.
- Do not run `DBCC DROPCLEANBUFFERS` on production; use a restored copy for cold-cache comparisons.
- The full implementation evidence is in `deploy\impl\logs\` and `deploy\IMPLEMENTATION-REPORT.md`.
