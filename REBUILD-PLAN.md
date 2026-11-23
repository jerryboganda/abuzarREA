# Rebuild plan: Trader App v1 (PowerBuilder) -> Rust

Goal: 100% UI/UX parity and 100% functional parity, Rust backend, PostgreSQL.
Assumption: you own or hold the rights to this software. License/activation checks are inventoried only, never bypassed.

## Proposed stack (change any line you disagree with)

| Layer | Choice | Why |
|---|---|---|
| Database | PostgreSQL 17 | Closest fit for the 630-table relational model; T-SQL maps to PL/pgSQL or Rust |
| Backend | Rust: axum + sqlx (+ tokio) | As requested |
| Desktop shell + UI | Tauri 2 with a web renderer driven by extracted layout JSON | Pixel-exact absolute layouts (PowerBuilder windows are absolute-positioned) are easiest to reproduce with a data-driven renderer; keeps the app a native Windows desktop program |
| Reports/print | DataWindow engine in Rust (SQL + band layout + expressions) -> PDF/HTML | 8,748 DataWindows are ~75% of the app |

## Phases (each ends with something checkable)

| # | Phase | Output | Status |
|---|---|---|---|
| 0 | Inventory of the compiled app | `RE-ANALYSIS.md`, `re-tools/` | done |
| 1 | **Database truth** | Authoritative schema (tables, columns, keys, indexes, procs, views, triggers) -> PostgreSQL DDL | schema done (761 tables, 642 procedures) and validated on SQL Server 2025 (`db/`); PostgreSQL port still to do |
| 2 | **See the original** | Screenshot of every window/report from the running original app (visual parity reference) | **blocked**: needs a licensed working installation + database that the user logs in to themselves (no licence bypass, no use of the backups) |
| 2b | **Behaviour documentation** | Navigation, rights model, start-up/session flow, architecture, catalogs, journey cards | **done**: `docs/` |
| 3 | **UI extraction** | One JSON per window/menu: every control, x/y/w/h, font, colour, text, tab order, events | **done**: 2,062 windows, 156 menus, 100 user objects, 54 structures in `recovered/objects/` (properties, controls, instance variables) |
| 4 | **DataWindow extraction** | One JSON per DataWindow: SQL, columns, bands, computed fields, formats, grouping | **done**: 8,748 / 8,748 in `recovered/` |
| 5 | **Script decompiler** | PowerScript source for all window/user-object/function events from p-code | **done**: 28,140 routines -> `recovered/scripts/` (579k lines, 7,450 SQL statements, 0 flagged, 0 unresolved names; 29 `goto` left) |
| 6 | **Code generation + Rust app** | Rust services + UI renderer, module by module (accounts -> sales -> purchase -> stock -> ... -> hospital/school/hotel -> reports) | after 3-5 |
| 7 | **Parity tests** | Pixel diff per window vs phase-2 screenshots; query-result diff per report/procedure on the same data | continuous |

## Honest scale

~2,062 windows, 8,748 DataWindows, 553 stored procedures, 630 tables, 460 global functions. Phases 3-5 are building three decoders; once they exist, the conversion is mostly automated generation plus review. Expect this to take many sessions, not one.
