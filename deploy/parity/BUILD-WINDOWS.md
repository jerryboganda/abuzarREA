# Rebuilding the Windows server, desktop and installer

These are the exact commands used to produce the 2026-11-04 binaries.

## Toolchain

- Rust `1.99.1` with the **GNU** target:
  ```powershell
  winget install Rustlang.Rustup
  rustup toolchain install stable-x86_64-pc-windows-gnu --profile minimal
  ```
- Tauri CLI (no global install needed): `npx --yes @tauri-apps/cli@2`.
- Node 26 (for `web/tools/build-static.ts`).
- No Microsoft Visual Studio / MSVC is required.

## 1. Build the web assets

```powershell
cd C:\Projects\Abuzar\rebuild\web
node tools\build-static.ts dist
```

The static build strips TypeScript, rewrites `.ts` imports to `.js`, copies
`public/` (classes, DataWindows, `sql.json`, fonts) and points `index.html` at
`/src/main.js`.

## 2. Build the server

```powershell
cd C:\Projects\Abuzar\rebuild
$env:Path="$env:USERPROFILE\.cargo\bin;$env:Path"
cargo +stable-x86_64-pc-windows-gnu build -p trader-server --release
# output: target\release\trader-server.exe
```

Output: `target\x86_64-pc-windows-gnu\release\trader-server.exe`.

The binary is statically linked for the GNU runtime (no `libgcc`/`libwinpthread`
DLLs needed). It contains `POST /api/fiscal` for fiscal-service relay.

## 3. Build the desktop shell

```powershell
cd C:\Projects\Abuzar\rebuild
$env:Path="$env:USERPROFILE\.cargo\bin;$env:Path"
$env:RUSTUP_TOOLCHAIN='stable-x86_64-pc-windows-gnu'
cargo +stable-x86_64-pc-windows-gnu build -p trader-desktop --release
# output: target\release\trader-desktop.exe
```

Output: `target\x86_64-pc-windows-gnu\release\trader-desktop.exe` and
`WebView2Loader.dll`.

## 4. Build the NSIS installer

```powershell
cd C:\Projects\Abuzar\rebuild
$env:Path="$env:USERPROFILE\.cargo\bin;$env:Path"
$env:RUSTUP_TOOLCHAIN='stable-x86_64-pc-windows-gnu'
npx --yes @tauri-apps/cli@2 build
```

Output:
`target\release\bundle\nsis\Trader_0.1.0_x64-setup.exe`.

The installer was silently installed and the installed app was verified to reach
the login dialog and the main menu.

## Runtime files

The desktop app reads `DATABASE_URL` or the first line of `trader.conf` next to
the executable. Without either, it uses:

```text
postgres://postgres@127.0.0.1:5432/trader
```

`BIND` selects the embedded server address (default `127.0.0.1:8787`).

The server and desktop read PostgreSQL preferences, so the fiscal host/port are
the application's `FiscalizationMachine` / `FiscalizationAppPort` values.

## Known warning

The GNU linker prints:

```text
.rsrc merge failure: multiple non-default manifests
```

This is a warning from Tauri's generated resource file. The produced desktop exe
launches, shows the login dialog, logs in and renders the main window.

## Final binaries - 2026-11-04

| File | Bytes |
|---|---:|
| `trader-server.exe` | 10,675,696 |
| `trader-desktop.exe` | 59,394,530 |
| `Trader_0.1.0_x64-setup.exe` | 36,413,692 |
| `WebView2Loader.dll` | 160,880 |

The desktop build caches the embedded `web/dist`; after changing the frontend,
touch `src-tauri/src/main.rs` before `cargo build` (or run the Tauri CLI), then
confirm the new asset text behaves as expected in the installed app. The final
shell was installed silently and verified to log in and open Cash Sale with the
item list hidden, matching the original startup state.
