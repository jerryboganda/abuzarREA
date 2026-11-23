# Security, licensing, startup integrity & deployment — findings

## Executive verdict

- **"Trusted desktop" is not a security model.** Every client is `sa`; the password is recoverable from the PBDs; `xp_cmdshell` is on; `Application` is writable by `Authenticated Users`; `BUILTIN\Users` is a login. One SQL injection or one local user = full server compromise.
- **Licensing is obfuscation, not a licence.** No MAC/signature, the 9-char payload is ignored at login, the trust anchor is a DB row the app must write, and the vendor "help" path drops that table.
- **The startup integrity checks are theatre and waste.** Two `cmd.exe` spawns for a filename test, three `RESTORE HEADERONLY` calls for a cosmetic dialog, and a DB licence check with a write: **~175–320 ms locally; 0.5–2 s on a real LAN/AV host.** None detects tampering.
- **Signed licence + signed binaries + least privilege + Argon2id is safer and faster** — removes ~200–300 ms of startup work and the per-window licence write. But these checks are only ~2–5 % of a multi-second PB startup [hypothesis: 4–10 s]; fix them because they are pure waste and one is RCE-grade, not because they alone make the app slow.

## Evidence base

- 2,780 recovered PowerScript files, 8,748 DataWindow sources, DB metadata, 213 client files (701.4 MB; 120 PBDs = 636.9 MB), `Script.mdb` (7,968 rows).
- Live: SQL 2008 R2 Express on Windows 11 26H1; `sa` enabled; 5 sysadmins; mixed mode; `ForceEncryption=0`; no audit; `xp_cmdshell=1`; TCP all IPs (dynamic 53107) + named pipes; compat **80**; one `abuzar.exe` holds **4 `sa` sessions**.
- Measured: `SP_WayToMoon` ×10 = **496 ms** (49.6 ms/call); `xp_fileexist` ×10 = **6 ms**; one `xp_cmdshell 'dir'` = **23.3 ms**; `RESTORE HEADERONLY` = **36/62 ms** per device; licence SELECTs ×1,000 = **16/6/6/0 ms** server-side.
- 4 backups = **11.26 GB**, `Users: Read`; `Authenticated Users: Modify` on `Application`, `Backup`, `AutoBackup`, `Junk`, `C:\waseela_temp`.

## Findings — security, licensing, deployment

| ID | Finding | Evidence | Why it costs time | Fix | Gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| S1 | Client is `sa` with a hardcoded password | `w_login1.pbs:95,101,185,210`; `f_get_database_status.pbs:20-22`; 4 live `sa` sessions | Forces sysadmin; blocks every other control | Per-user Windows auth or `waseela_app` login | Enables all fixes | XL (PB) / M (rebuild) | High: app does DDL/BACKUP |
| S2 | `xp_cmdshell` on; `SP_WayToMoon` concatenates caller input into `cmd.exe` | `f_firsttime_waytomoon.pbs:9`; DB `SP_WayToMoon`; `README-DEPLOY.md:85-97` | **49.6 ms/login** + 2 process spawns + AV | Disable; use `xp_fileexist` or delete the check | **~48 ms/login**, removes RCE | S | Low |
| S3 | `Script.mdb` is an unauthenticated 7,968-statement startup migration channel | Jet `script(seq,date,query)`; row **5456** creates `SP_WayToMoon`, row **7858** `OPENROWSET`; 317 `DROP`, 2,876 `ALTER`; writable by `Authenticated Users` | 28 MB Jet scan if rows apply [hypothesis: 50–300 ms] | Sign, read-only, privileged migration tool | Removes a code-exec channel | S/M | High: rows run as `sa` |
| S4 | Passwords plaintext, compared client-side; no lockout/policy | `Users.Password`; 9 rows, 1–12 chars, **8/9 ≤3 chars**; `w_login1.pbs:226,260`; retry counter resets on reopen | ~100 ms once per login for a real hash | Argon2id (64 MiB, t=3), server-side verify, rate limit, rehash-on-login, drop plaintext | Login +100 ms, net faster after S2 | M | Medium: PB needs a helper |
| S5 | Other secrets plaintext | `SpecialRight.RightPwd` (4 rows); `SoftwarePreferences` (`SMTPPassword`, `WEBSMSPassword`, `WebSMSAPIKey`, `CustomerPaymentAPIKey/Password`); `CustomerConfig.PWD/SourcePWD`; `UserAuthenticationInfo.AuthenticationKey` | None | Hash one-way secrets; DPAPI/Credential Manager for service creds | Security only | M | Medium: integrations |
| S6 | User backup path concatenated into `RESTORE FILELISTONLY` as `sa`; "verify" restores a 3 GB copy to `C:\waseela_temp` | `w_dbbackup1.pbs:59` → `f_verify_backup_file.pbs:53,56,82-84`; temp dir is `Authenticated Users: Modify` | Full restore = minutes of I/O | Validate/parameterise path; `RESTORE VERIFYONLY`; never restore to prod host | Removes SQLi + 3 GB restore | M | High: sysadmin-only op |
| S7 | Backups unencrypted; "password" is hardcoded/derivable; DB files are world-writable | `w_dbbackup1.pbs:97`; `f_getbackupinfo.pbs:104`; `f_autorecover.pbs:136,176`; `w_autorecovery.pbs:145,300`; 4 × 2.82 GB, `Users: Read`; `deploy\db` MDF/LDF are `Authenticated Users: Modify` | None at runtime | BitLocker/EFS + ACL + off-host; 2014+ `WITH ENCRYPTION` | Security only | S/M | Medium: keys |
| S9 | Credentials logged or in URLs | `nv_remote_datawindow.pbs:2132` logs `trans.logpass`; `w_sms_center.pbs:1260` writes SMS user/password to `C:\mySoapLog.log`; `:1282` password in query string | None | Redact; remove SOAP log; POST + OAuth | Security only | S | Low |
| S10 | Unsigned binaries, writable install dir, unsigned `.ext` duplicate, decompilable p-code; app also points at a UNC into server `system32` | `abuzar.exe`/`abuzar.ext` identical SHA-256, `NotSigned`; `mdsys.exe` unsigned (2010); `Authenticated Users: Modify`; 568 k lines recovered; `f_set_client_info.pbs:30`, `w_login1.pbs:187-196` | SMB dependency on login [hypothesis] | Authenticode + Ed25519 manifest, signed updater, per-user install, read-only Program Files; drop the UNC | Stops local escalation/supply-chain | M | Medium: signing key custody |
| S11 | Vendor "administrator key" is a predictable numeric check and **drops `SysTextCatalog`** | `w_administrator_key.pbs:6-8,78`; `w_activation.pbs:147,154-159` | Destroys licence history | Remove window + `DROP TABLE` path | Removes licence-reset backdoor | S | Low |
| S12 | Licence has no integrity; DB row is trust anchor; 9-char key ignored at login | `f_getlicinfo.pbs:15-57`; `f_islicenseexpire.pbs:25,32,50-54,63,83`; `w_activation.pbs:233-279` | 6 RT + 1 write per call; startup + every sale/purchase `ue_postopen` | Ed25519 file, machine binding, grace, revocation, cache | **10–60 ms/startup + per-window** | M | Medium: rollout |
| S13 | Unsupported stack, mixed mode, no forced TLS/audit, `BUILTIN\Users` login, SQL Browser exposed | SQL 2008 R2 (EOL 2019) on Win11 26H1; `LoginMode=2`; `ForceEncryption=0`; 0 audits; `BUILTIN\Users` enabled; SQLBrowser Automatic, TCP all IPs | TLS ~5–15 % CPU [est.]; audit adds a login write | Upgrade SQL; TLS 1.2; remove login; audit; firewall to POS subnet; disable Browser | Security; TLS cost small vs I/O | L | High: version jump |
| S14 | 106 dynamic-SQL procs; 74 take server/db/owner and concatenate; arbitrary-SQL gadgets | `SP_MyExecuteLocal` (`EXECUTE(@Qry)`), `sp_executelocal`, `SP_WaseelaMini_Droptable/Truncate`, `SP_Select_Service`, `SP_Get_ResultSet_From_Excel` (`OPENROWSET` Jet), `SP_CheckForNewItemInDataCarry` | Blocks plan reuse/least privilege | Drop unused; `sp_executesql` + `QUOTENAME`; allowlist identifiers | Security + some plan reuse | M/L | Medium: many call sites |
| S16 | Startup does DDL, BACKUP/RESTORE and `xp_cmdshell`, so the app must be `db_owner`/`sa` | `f_firsttime_script.pbs:5`; `f_firsttimewks_limit.pbs:5,13`; `f_firsttimelic.pbs:15`; `f_getbackupinfo.pbs:104` | None; blocks least privilege | Move migrations/backup to a privileged tool; app = read/write + EXECUTE | Enables S1 | L | High: broad regression |

## Findings — startup/performance overlap

| ID | Finding | Evidence | Cost | Fix | Gain | Effort | Risk |
|---|---|---|---|---|---|---|---|
| P1 | Two `cmd.exe` spawns per login for a filename test | `SP_WayToMoon` | **49.6 ms** measured | `xp_fileexist` or remove | **~48 ms** | S | Low |
| P2 | Three `RESTORE HEADERONLY` on the UI thread for a cosmetic dialog | `w_startup.pbs:58-71` → `f_getbackupinfo.pbs:104` | **36–62 ms** each; 110–190 ms total | `msdb.dbo.backupset` or async | **110–190 ms** | S | Low |
| P3 | Licence: 6 RT + write, app-open and every sale/purchase `ue_postopen` | `f_islicenseexpire.pbs:25-113`; `w_sale.pbs:16510`; `w_purchase.pbs:6713` | 10–60 ms/startup [hypothesis]; 2–10 ms/window | Signed file + cache; never in `ue_postopen` | **10–60 ms + per-window** | M | Medium |

## SQL injection risk ranking

1. **Critical — `f_verify_backup_file` → `RESTORE FILELISTONLY FROM <path>`** (file dialog, `w_dbbackup1.pbs:59`): runs as `sa`, `RESTORE` is sysadmin, a quote in the path = arbitrary SQL.
2. **Critical — `SP_Get_ResultSet_From_Excel @File` → `OPENROWSET(... ' + @File + '...)`**: arbitrary file read/ACE if Ad Hoc is enabled (currently off).
3. **Critical — `SP_WayToMoon @fl/@fl2` → `xp_cmdshell`**: any EXEC caller can append `& command`; runs as `NETWORK SERVICE`.
4. **High — 74 `@SRV`/identifier procs** (`SP_Select_Service`, `SP_WaseelaMini_*`, `SP_Update_ItemHistoricalCost @DBName`): second-order/identifier injection, no `QUOTENAME`.
5. **Medium — `u_waytomoon` (computer/DB name) and `w_login1` (typed server/DB into the OLE DB string)**: injection at login; also lets a user target any server with the embedded `sa` password.

"Desktop is trusted" fails because the server accepts `sa` from any LAN host, `BUILTIN\Users` is a login, and the password is in every PBD.

`sys.sql_modules` scan: **106** procs use `EXEC(...)`; **0** use `sp_executesql`; 1 `OPENROWSET`; 1 `xp_cmdshell`; **0** linked servers, `BULK INSERT`, `xp_dirtree`, `xp_fileexist`, `sp_add_job`. Every dynamic statement is concatenated; none is parameterised. The `.pbs` scan found the same pattern in `u_waytomoon`, `w_normal_initialization` and the backup/restore paths.

### Why the licence design is weak *and* slow

- **No integrity.** 20 chars from a 10-symbol alphabet; only duration (2), iteration (2) and start-date serial (5) are decoded. No checksum/MAC. `f_islicenseexpire` does not even use the 9-char "key" — it validates only numbers. Anyone reading the PBD (everyone; 568 k lines recovered) can construct a valid one.
- **The 375-day rule is not tamper detection.** It is `daysafter(last_access, expiry) > 375` — a staleness check for a licence unused for >375 days. `last_access` is the writable `cataloglength` column.
- **The DB row is the anchor, but the app must write it.** `f_islicenseexpire:63` updates `cataloglength` on every call, so any login that can run the app can set `status`/expiry. Startup DDL forces `db_owner`; `db_datawriter` on the licence row is enough. Weak by construction, not misconfiguration.
- **Row count is a sequence.** `:46` rejects `ll_rows <> ll_iteration`; restoring an older backup or deleting a row locks the site out with "Inconsistent License Information" — their own auto-recovery can trigger it.
- **Startup dependency.** No DB → no licence → no app. Each login/window pays 6 RT + `UPDATE`/`COMMIT` on one hot row shared by four terminals. `f_firsttimelic:15` can recreate the table from `gs_key`/`gs_sdate`; the only recovered assignment is the per-customer hardcoding in `f_set_client_info.pbs:8-33`, so the DB row is not authoritative.

Replacement: Ed25519 over `{licence_id, customer_id, product, max_users, max_clients, issued_at, not_before, expires_at, grace_days, features[], machine_fingerprint, revocation_epoch}`. Pinned key; site fingerprint (host + volume serial + SMBIOS UUID); 30-day offline grace with a monotonic last-seen file; in-memory cache; append-only hash-chained audit log of activation/verification failures. **1–3 ms cold, 0 ms warm.**

## Startup security check inventory

| Check | Where | Cost | Risk | Replacement | Speedup |
|---|---|---|---|---|---|
| DLL existence ×2 via `xp_cmdshell` | `SP_WayToMoon` | **49.6 ms** (measured) | None: a 256-byte placeholder passes, no hash/signature | Remove or `xp_fileexist` (0.6 ms) | ~48 ms |
| Backup header ×3 via `RESTORE HEADERONLY` | `w_startup` → `f_getbackupinfo` | **36–62 ms** each; 110–190 ms | None: cosmetic "Backup Age" | `msdb.dbo.backupset` or async | 110–190 ms |
| Licence check (startup + per window) | `f_islicenseexpire` | 6 RT + write; 10–60 ms/startup [hypothesis]; 2–10 ms/window | Weak: DB row editable by the app | Ed25519 file, cached | 10–60 ms + per-window |
| DDL probes ×4 | `f_firsttime_*` | 3–12 ms [hypothesis] | None | `SchemaVersion`/migration tool | 3–12 ms |
| Session-limit tempdb DDL | `u_waytomoon`/`u_session` | 3–10 ms [hypothesis] | Weak: race, crash leak | `sp_getapplock` | 3–10 ms |
| `Script.mdb` scan | startup/upgrade | 50–300 ms if read [hypothesis] | Negative: writable code channel | Signed/read-only migrations | 50–300 ms |
| `mdsys.exe` activation | `w_activation` | 0.2–1 s, one-time [hypothesis] | Weak: MD5, unsigned | Ed25519 | 0.2–1 s on activation |
| **Total** | | **~175–320 ms local; 0.5–2 s LAN/AV** | | **~15–65 ms** | **~150–300 ms** |

DLL-check design options, best first: (a) **remove** — the DLLs are optional for the normal screens; (b) **single compile-time/link-time check** of the one DLL actually loaded (`LoadLibrary` failure), not `dir`; (c) **signed manifest** if a real integrity guarantee is needed; (d) **`xp_fileexist`** as a temporary stop-gap.

## Credential / secret inventory (no secrets printed)

| Location | Type | Risk | Fix |
|---|---|---|---|
| `w_login1.pbs:95,185` | Hardcoded SQL `sa` password for named servers | Shared secret in every binary; full DB/OS compromise | Remove; Windows auth; rotate |
| `w_login1.pbs:101,210`; `f_get_database_status.pbs:20-22` | `logid="sa"`, `logpass=gs_password` | Client is sysadmin | Least-privilege login |
| `f_set_client_info.pbs:8-15` | Hardcoded server, DB, company, licence key, regid, start date (another customer) | Cross-customer data/licence leak | Remove build-time customer config |
| `w_dbbackup1.pbs:97`; `f_getbackupinfo.pbs:104`; `f_verify_backup_file.pbs:56,84`; `f_autorecover.pbs:136,176`; `w_autorecovery.pbs:145,300`; `w_normal_initialization.pbs:207,251,394` | Hardcoded backup/media passwords derived from server name | Backups readable/restorable by anyone who knows the host | Remove; real encryption + key management |
| `f_set_source_server_info.pbs:6`; `f_set_dropbox_server_info.pbs:6` | `gs_source_pwd`, `gs_dropbox_pwd` globals | Remote DB passwords in memory/connection strings | Windows auth / secret store |
| `w_crystal_report_viewer.pbs:17` | `sa` + `gs_password` to Crystal | Report engine is sysadmin | Read-only report login |
| `nv_remote_datawindow.pbs:2132` | Logs `trans.logpass` | Password in a text log | Redact |
| `w_sms_center.pbs:1260,1282` | SMS user/password in `C:\mySoapLog.log` and in a URL query | World-readable/proxy-log credential leak | Remove log option; DPAPI; POST + OAuth |
| `SoftwarePreferences` | `SMTPPassword`, `WEBSMSPassword`, `WebSMSAPIKey`, `CustomerPaymentAPIKey/Password` | Plaintext credentials in DB | DPAPI/Credential Manager; encrypt |
| `Users.Password`; `SpecialRight.RightPwd`; `CRS_Users.Password`; `UserAuthenticationInfo.AuthenticationKey`; `CustomerConfig.PWD/SourcePWD` | Plaintext passwords/PINs | Any DB reader gets them; 8/9 users ≤3 chars | Argon2id/hash; drop plaintext |
| `deploy/README-DEPLOY.md:9,11`; `deploy/login.ps1:3` | `sa` and app passwords in local notes/script | Local credential leak | Remove/rotate; secret manager |
| `Script.mdb` rows 5456/7858 | Creates `xp_cmdshell`/`OPENROWSET` procs; writable | Arbitrary SQL as `sa` at next startup | Sign, read-only, privileged migration |
| `mdsys.exe`, `abuzar.ext`, `abuzar.exe` | Unsigned; `.ext` duplicate | Binary replacement/DLL planting | Authenticode + signed manifest |

## Hardening checklist by effort

**Quick (S, <1 day)**
- Disable `xp_cmdshell`; replace `SP_WayToMoon` with `xp_fileexist` or drop it (S2/P1).
- Remove `BUILTIN\Users`; firewall SQL to the POS subnet; keep one protocol (S13).
- Remove `Authenticated Users: Modify` from `Application`, `Backup`, `AutoBackup`, `Junk`, `C:\waseela_temp` (S7/S10).
- Delete `C:\mySoapLog.log`; redact `trans.logpass`; stop URL-encoding SMS passwords (S9).
- Rotate `sa`, SMS, SMTP, payment-API and backup passwords; scrub `README-DEPLOY.md`/`login.ps1` (S1/S5).
- Drop unused `SP_Get_ResultSet_From_Excel`, `SP_MyExecuteLocal`, `SP_WaseelaMini_*`; remove `w_administrator_key` and the `DROP TABLE` path (S11/S14).
- Replace the startup `RESTORE HEADERONLY` with an async `msdb` query (P2).

**Medium (M, 1–5 days)**
- Argon2id + server-side verify + attempt table; dual-run, rehash on login, drop plaintext (S4).
- Ed25519 licence file + machine binding + grace + revocation; remove DB dependency (S12/P3).
- Parameterise `f_verify_backup_file`; `RESTORE VERIFYONLY`; never restore to `C:\waseela_temp` (S6).
- Move startup DDL/migrations to a signed privileged tool; then least privilege (S16); use `sp_getapplock` for session limits.
- Code-sign exe/DLL/installer + signed manifest; per-user install; read-only Program Files (S10).
- Force encryption/IPSec; login audit; remove `sa` from Crystal (credential inventory).

**Large (L/XL)**
- Upgrade SQL Server to a supported edition; TLS 1.2; backup encryption (2014+); TDE needs Enterprise/Developer (S13).
- Rebuild in Rust/Tauri: Windows auth/Entra, OS keychain, `sqlx`/`tiberius` parameterised queries, no `sa` (S1).
- Rewrite the 74 `@SRV` procs; review all 106 dynamic-SQL procs; add a privacy programme (S14).

## Secure + fast startup design (ordered)

1. **Launcher:** OS verifies Authenticode on `waseela.exe`; verify an Ed25519 manifest for DLLs/PBDs (hash the 5 DLLs loaded at startup; PBD hashes lazily). **5–20 ms.**
2. **Licence:** read `%ProgramData%\Waseela\license.lic`; verify Ed25519, machine binding, expiry, grace, revocation epoch; cache in memory. **1–3 ms; no DB.**
3. **Connect:** DPAPI-protected profile; Windows auth (no password) or Credential Manager; one connection. **10–50 ms.**
4. **Entitlement:** one `SELECT` for schema version + `sp_getapplock` for max clients (session-scoped, crash-safe). **1 RT, ~1 ms.**
5. **Show `w_main` first;** run backup-age, update check and audit flush on a background thread. **0 ms critical path.**
6. **Migrations:** signed `waseela-migrate.exe` (privileged) at install/upgrade; app runs as read/write + EXECUTE only.
7. **Re-check licence** only on file mtime change or 24 h; never in `ue_postopen`.
8. **Updates:** signed manifest (version, min version, URL, SHA-256), staged download, verify, atomic swap; no `.ext` rename.

**Result: ~15–65 ms of security work vs ~175–320 ms now (a ~150–300 ms saving); no per-window write, no `cmd.exe`, no `sa`.**

## Top 10 by ROI (ranked)

1. **Disable `xp_cmdshell` + replace the DLL check** — 50 ms/login and removes RCE (S2/P1).
2. **Fix directory ACLs and `c:\waseela_temp`** — stops local binary/data replacement (S7/S10).
3. **Stop the licence DB write; signed file** — 10–60 ms/startup + per-window, and real licensing (S12/P3).
4. **Move the backup-header check off startup** — 110–190 ms (P2).
5. **Argon2id + server-side verify + rate limit** — closes the worst privacy hole (S4).
6. **Remove hardcoded backup/media passwords and the full restore** — protects 11.26 GB of data (S6/S7).
7. **Remove the `w_administrator_key` backdoor** — closes a licence reset/table drop (S11).
8. **Sign binaries/updates; per-user install** — stops DLL planting and `.ext` replacement (S10).
9. **Drop arbitrary-SQL/OPENROWSET procs; parameterise the top 10** — shrinks the blast radius (S14).
10. **Upgrade SQL Server + TLS + audit** — the only way to get security patches (S13).

## Implementation plan (ordered)

1. **Rotate secrets, then disable `xp_cmdshell`.** Validation: login works; `EXEC xp_cmdshell 'whoami'` returns 15281; no `cmd.exe` in Procmon.
2. **Replace `SP_WayToMoon` with `xp_fileexist`** (or patch the client). Validation: 0 with DLLs, 1 when renamed; 0.6 ms/call.
3. **ACL + temp/log cleanup.** Validation: a standard user cannot write the app/backup/temp dirs; no `C:\mySoapLog.log`.
4. **Async backup-age check.** Validation: no `RESTORE` before `w_main`; 110–190 ms saved.
5. **Argon2id migration.** Validation: all 9 users log in; ≤250 ms on the oldest POS; plaintext column dropped; 5 failures = 5-min lockout.
6. **Ed25519 licence file.** Validation: tamper/expiry/clock-rollback/machine-move tests; no `SysTextCatalog` read/write at login.
7. **Least privilege.** Validation: capture one day with Profiler, grant exactly that set, smoke-test sale, purchase, backup, reports.
8. **Signing/updater.** Validation: `sigcheck -a` Valid; tampered PBD/exe rejected; bad-hash update rolls back.
9. **SQL upgrade + rebuild.** Validation: compat 130/150, TLS 1.2 only, audit file, restore test; Rust/Tauri cold start <1 s with no DB credential in the binary.

## What NOT to do

- **Do not enable `xp_cmdshell` in production.** If enabled for a one-off, disable it and drop `SP_WayToMoon` immediately.
- **Do not keep `sa` in the client, scripts, README or installer.** Network-isolate the legacy client until it is rebuilt.
- **Do not "fix" licensing by editing `SysTextCatalog` or using `w_administrator_key`.** The latter drops the table; the former destroys the audit trail and is not a trust anchor.
- **Do not use `BACKUP … WITH PASSWORD` as encryption.** On 2008 R2 it is a weak restore gate; newer versions removed the option.
- **Do not store backups on the same host/share with `Users: Modify`.**
- **Do not enable Ad Hoc/`OPENROWSET` for Excel imports.** Use a controlled import service.
- **Do not grant `db_owner` just to make startup DDL pass.** Remove the DDL.
- **Do not hash with MD5/SHA1 or unsalted `HASHBYTES`.** Use Argon2id (or PBKDF2-HMAC-SHA256 with high iterations).
- **Do not log `trans.logpass`, SMS passwords or connection strings.**
- **Do not disable Defender/AV to speed up `xp_cmdshell`;** remove the check instead.
- **Do not run from a writable share or write `sysdrv.dll` to CWD.**
- **Do not publish the licence key layout** (already in `README-DEPLOY.md:60-67`).

## Measurements still needed

- Procmon/ETW of a real login on the customer's hardware, timestamping each check (the 175–320 ms is a local estimate).
- `SP_WayToMoon` vs `xp_fileexist` on the customer's server with AV/EDR (49.6 ms may be 100–300 ms there).
- `RESTORE HEADERONLY` cold and warm on the backup share.
- 100 × `SELECT 1` from a POS to measure real RTT (the licence check is 6 RTs).
- Argon2id timing on the oldest POS CPU (target ≤250 ms).
- Procmon filter `abuzar.exe` + `Script.mdb` to confirm it is read at startup and how many rows apply.
- Test `BUILTIN\Users` authentication from a non-admin account; lab clock-rollback test for `sqlca.getdatetime`.

**Privacy note (proportionate):** immediate risks are plaintext passwords (8/9 users ≤3 chars), SMS/SMTP/payment credentials in a plaintext table, and 11.26 GB of unencrypted backups with customer/patient data on a world-readable volume. Fix those first; a full PDPA/GDPR programme can follow.
