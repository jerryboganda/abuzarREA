# Final evidence - 2026-11-04

All items below were produced from the **final built assets**, not dev source.

## 1. Final binaries

| File | Bytes | SHA-256 |
|---|---:|---|
| `deploy/parity/rebuild-dist/trader-server.exe` | 10,675,696 | `1956B992FA9C253999BE77422A895FB1FF5DAF383B5A365D488C6F13B1CC1344` |
| `deploy/parity/rebuild-dist/trader-desktop.exe` | 59,394,530 | `6EFE720757926FDA32548D31B72840AB2514544AF3C19318E3CADDB12D8E8646` |
| `deploy/parity/rebuild-dist/Trader_0.1.0_x64-setup.exe` | 36,413,692 | `93F4294C2CBC044E183BBB202FAC1CBDFC0B76C3037B64C396BE59AE96D79981` |

Installed `%LOCALAPPDATA%\Trader\trader-desktop.exe` has the same size and
SHA-256 as the deployed desktop binary. Build instructions:
`BUILD-WINDOWS.md`.

## 2. Full 210-screen walk (final assets)

`MENU-WALK-2026-11-04-FINAL.md`, `MENU-WALK.md`, `menu-walk.json`

| Outcome | Count |
|---|---:|
| Opened OK after focused retry | **200** |
| Caller-parameter dialog (`w_arg_group`) | **2** |
| Correct no-data dialog (Cashier Activity Window; `CashierJob` = 0 rows in live and clone) | **1** |
| Safety-policy skips | **7** |
| **Real screen failures** | **0** |

The baseline run handled all 210 actionable leaves in 1,352 s with 8 periodic
browser resets and no `ERR_INSUFFICIENT_RESOURCES`.

## 3. Transaction flows (final assets)

`TRANSACTION-FLOWS.md` section 7

| Flow | Invoice | Measured result |
|---|---|---|
| Cash Sale | **588885** | posted Y, stock 18,034 -> 18,033 |
| Cash Sale Save And Post | **588887** | posted Y, stock 18,038 -> 18,037, GL 3 rows, debit 11 / credit 11 |
| Purchase | **12281** | posted N, stock unchanged |
| Purchase Save And Post | **12282** | posted Y, stock 18,033 -> 18,038, all posting RPCs 0 |
| Cash Sale Return | **61604** | posted Y, stock 18,038 -> 18,039, `newavgprice=4.87435` |
| Credit Sale | **588886** | customer 22, posted Y, stock -1, defaults 0.00 |

## 4. Reports and comparisons

| Evidence | File |
|---|---|
| Net Cash report (final assets) | `real/68-final-report-netcash.png` - 58,569,818.00 sales, 4,945,353.00 returns, **53,624,465.00 net cash**, 0 px overflow |
| Login: original vs final | `real/67-login-dialog-compare.png` |
| Main: original vs final | `real/64-main-original-vs-final.png` |
| Cash Sale: original vs final | `real/65-cashsale-original-vs-final.png` |
| Pack Purchase: original vs final | `real/71-purchase-original-vs-final.png` |
| Final installed main | `real/58-final-main-full.png` |
| Final installed Cash Sale | `real/60-final-cashsale-full.png` |

## 5. SQL audit

`SQL-DIALECT-GAPS.md` sections 10-11

- **11,120** statements/DataWindows `PREPARE` clean.
- **57** remaining: **30/30** pass a typed `PREPARE`; **26** reference
  objects/columns absent from live SQL Server; **1** is a 16-into-15 insert that
  is equally invalid in the original T-SQL.
- All 11 formerly missing DataWindows mapped; six real report-query bugs and the
  one-argument `sp_CRS_Fetch_ItemStockPosition` fixed.
- Runtime self-heal re-applies 12 SQL corrections to a stripped `sql.json`.

## 6. Live data integrity

`trader` (live) after every run:

```text
SaleLedger      588,865 rows / max 588,871
SaleDetail      1,306,102
SRLedger         61,601 / max 61,602
PurLedger       12,276 rows / max 12,276
VirtualGL       2,004,033
```

No live sale, purchase, return, GL or preference row was changed.

## 7. Remaining external dependency

**Real fiscal service/device on port 9111 with its credentials.** The relay is
implemented, built and deployed; a mock service received `S588884` from a real
Cash Sale. Without the device the original `Connection refused` path is used and
the sale continues.

A fresh original-side **report** screenshot is also a manual production-machine
step. The pristine `Application\abuzar.exe` fails with the Windows error
`ATL71.DLL was not found`; the safe `deploy\Application` copy starts, but its
PowerBuilder DataWindow login could not be driven reliably in this session. The
live database was verified unchanged after the attempt. Existing original
captures cover login, main, Cash Sale and Purchase; the report is verified
against its original DataWindow definition and measured layout.
