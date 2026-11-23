# Owner decisions — 2026-11-02

These are the explicit choices made by the owner. They override the earlier
"recommended" defaults in the roadmap where they differ.

| # | Topic | Decision | Consequence |
|---|---|---|---|
| 1 | True reboot cold-start capture | **Owner will reboot and run it.** | `Waseela Cold Start Capture` is enabled and runs 45 s after logon; it captures, then disables itself. `Waseela Preload` is disabled during the capture and re-enabled afterwards. |
| 2 | Original PowerBuilder source | **Lost in a fire; no source exists.** Owner is the rights holder and instructs reverse engineering. | The recovered artifacts (2,780 scripts, 8,748 DataWindows, 2,834 window/menu objects) are the source of truth. The client cannot be recompiled without a PB 12.5 compiler, so the executable path is the Rust/Tauri rebuild. Existing rebuild status: **2,030/2,062 windows open headlessly (98.4%)**, **8,607/8,666 DataWindow retrieves run against PostgreSQL in CI (99.3%)**. |
| 3 | SQL Server edition | **SQL Server 2022 Express installed and live.** | Free and production-legal: 10 GB DB, **1,409 MB buffer pool** measured, columnstore, compression, Query Store, scalar-UDF inlining, interleaved execution, **compat 160**. Developer edition is free but **not licensed for production**, so it is not used. Standard remains the paid option only if the Express caps bind. |
| 4 | Code signing | **Use any free certificate; users can grant one-time permission.** | A self-signed code-signing certificate `CN=Waseela ERP, O=Abuzar Consultancy, C=PK` was created (thumbprint `4CB4FD989CEF1FBB78B44BECD412601AD178351F`, valid to 2036) and installed in the machine's Trusted Root. `WaseelaLauncher.exe` is signed and verifies **Valid**. Other PCs must import `deploy\impl\WaseelaCodeSigning.cer` once. |
| 5 | `StockReport` retention | **Keep everything as-is.** | No purge or archive. The clustered index keeps queries fast; the table continues to grow (~160 MB/year). |
| 6 | `Purledger` orphan | **Leave the row; keep the FK untrusted.** | No data change. `Purledger.TaxCategoryCode='87'` remains; the FK is enabled but untrusted so the optimizer cannot rely on it. |
| 7 | `SP_CleanUp_Bad_Session` | **Leave it.** | 32 ms per login is accepted; no rewrite. |

## Current live state (2026-11-02)

- Client: `WASEELA ABUZAR V2 01.01.2022 : ADMIN : 02/11/26 12:50:22` main frame, responding, **91.8 MB**, one Waseela session on `.\SQLEXPRESS2022`; Cash Sale was verified with real rows at 10:59 (`impl-24-sql2022-cashsale.png`), and the return window `[Open Cash Sale Return]` opened successfully after restart.
- SQL Server: **16.0.1000.6 Express**, compatibility **160**, Query Store **ON**, page compression on the five hot tables, buffer pool **1,409 MB**.
- Old 2008 R2 database: **READ_ONLY**; old instance online as rollback.
- Maintenance task: retargeted to `SQLEXPRESS2022`, result **0**.
- Fiscalization: listener on **9111**, sessions on the new instance.

## Still pending a manual step

- **Reboot** for the true cold-start capture. After the reboot, inspect
  `C:\Projects\Abuzar\deploy\impl\cold\cold-boot-*`. The task disables itself.

## Still requiring an external dependency

- A **paid SQL Server Standard licence** if the 10 GB / 1.41 GB Express limits
  become binding. The free Express 2022 migration is the current path.
- **Code-signing certificate for redistribution**: the self-signed certificate
  works on this machine; each additional PC needs the `.cer` imported once, or
  a publicly trusted certificate (e.g. Azure Trusted Signing) can be purchased.
- **PowerBuilder 12.5 compiler** if the original client must ever be rebuilt.
  It is not required for the Rust/Tauri path.
