# Abuzar / Trader App v1 - reverse engineering and Tauri + Rust rebuild

Compiled PowerBuilder 12.5 ERP/POS ("Trader App v1", Abuzar Consultancy, FazalDin PP19 deployment). No source exists. Goal: rebuild it as **Tauri 2 + Rust backend (axum + sqlx) + PostgreSQL** with 100% UI/UX and functional parity.

## Read first
- **`PROJECT-MEMORY.md`** - operational deployment/performance state: live SQL Server 2022 Express, aliases, tasks, rollback, final metrics. Read before touching the running app.
- `REBUILD-PLAN.md` - phases and status. `RE-ANALYSIS.md` - technical findings (sections 11-17). `docs/` - architecture, navigation, flows, catalogs (generated, see `docs/README.md`).
- Recovered inputs: `db/` (schema), `recovered/datawindows/*.srd` (8,748), `recovered/objects/` (window/menu/control definitions, 2,834), `recovered/scripts/*.pbs` (all PowerScript, 37,895 routines), `recovered/pcode/` (machine-readable p-code + tables).
- Tools: `re-tools/` (see its file docstrings). 32-bit Python `C:\Tools\py32\python.exe` hosts `PBVM125.dll`/`pbdwe125.dll` (exporters); normal 64-bit `python -I` runs the decompiler (`re-tools/decomp_all.py`).

## Rules that must stay true
- **The git remote `origin` of this folder (`jerryboganda/abuzarREA`) is PUBLIC and the index holds the vendor's binaries (Application/, FiscalizationApp/). NEVER push this repository.** The rebuild lives in `rebuild/` with its own git repository (`jerryboganda/abuzar-rebuild`, made PUBLIC on 2026-11-04 by the user's permanent decision so GitHub Actions is free; it holds no vendor binaries, backups or credentials) and GitHub Actions.
- Never store, type or repeat the vendor backup/media passwords. The classic app login is kept only in the git-ignored `PROJECT-MEMORY.md` (owner's decision 2026-11-23); Claude may log in to the local app with `deploy\login.ps1`. Never put it in tracked files. Do not crack the `.BAK` files (SQL Server 2000 format v539, password protected). Do not bypass licensing/activation; only inventory it.
- No customer data is in the recovered artifacts; keep it that way (the DB schema has no rows except the migration seed in `db/seed/`).
- Local toolchain: no Rust/MSVC/PostgreSQL installed; builds and tests run in GitHub Actions (user decision).
- The conversion runs in `rebuild/` (own git repo `jerryboganda/abuzar-rebuild`, public since 2026-11-04, see its README.md and CLAUDE.md). `recovered/scripts` etc. are the complete export (37,895 routines); the first, incomplete export is kept as `recovered/*_v1`.

## State
See `docs/STATUS.md` for the authoritative done / not-done list (updated every session).

## Rebuild execution policy (2026-11-08)
Read `rebuild\AGENTS.md`, **Project execution policy**, for the authoritative
rules: defer browser tests until the agreed code scope is complete, then use
one consolidated final browser pass; resolve routine choices autonomously
using recommended defaults instead of repeated questions. Required approvals
and truthful verification reporting remain mandatory. These rules supersede
older per-slice browser-testing and routine confirmation instructions.
