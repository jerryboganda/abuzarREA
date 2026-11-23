# docs/ - index

Everything here was derived from the compiled application (no source existed). Start with **STATUS.md**.

| document | what it holds |
|---|---|
| [STATUS.md](STATUS.md) | authoritative done / not-done list and known limits |
| [IMPROVEMENT-ROADMAP.md](IMPROVEMENT-ROADMAP.md) | 2026-11-23: all improvements for the PowerBuilder app itself, the source-regeneration + PBAutoBuild pipeline, phases, open owner decisions |
| [ARCHITECTURE.md](ARCHITECTURE.md) | layers, inheritance skeleton, data access, sessions, licensing (inventory), printing |
| [SECURITY-AND-RIGHTS.md](SECURITY-AND-RIGHTS.md) | users/groups/rights model, menu index paths, where vendor secrets live (never copy them) |
| [STARTUP-AND-SESSION-FLOW.md](STARTUP-AND-SESSION-FLOW.md) | application `open` sequence, login, session rows, schema upgrade |
| [NAVIGATION.md](NAVIGATION.md) | full menu tree with right codes and window targets |
| [UI-STRUCTURE.md](UI-STRUCTURE.md) | window types, controls, fonts, colours, DataWindow styles |
| [CATALOG.md](CATALOG.md), [catalog/](catalog) | every window / user object / menu / global function by module |
| [journeys/](journeys) | one card per large window (controls, data, events, menu path) |
| [DATA-ACCESS.md](DATA-ACCESS.md) | tables most used by windows, functions and DataWindows |
| [EXTERNAL-COMPONENTS.md](EXTERNAL-COMPONENTS.md) | DLL / EXE dependencies |
| [data/](data) | machine-readable versions (menus, catalog, datawindows, table_usage, libraries, inheritance, external_libs) for the rebuild |

Regenerate the generated parts: `python -I re-tools/docs_build.py` then `python -I re-tools/docs_md.py`. Hand-written documents: STATUS, ARCHITECTURE, SECURITY-AND-RIGHTS, STARTUP-AND-SESSION-FLOW, UI-STRUCTURE.
