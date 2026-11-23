# Session timezone for write paths - fixed

**Date:** 2026-11-03  
**Problem:** sqlx opens PostgreSQL sessions with `TimeZone=UTC`, overriding database/role settings and connection options. Reads were patched to Karachi time in the SQL map, but stored procedures and write paths still used UTC.

## Fix

`rebuild/web/src/app/httpdb.ts` now sends:

```sql
SET TIME ZONE 'Asia/Karachi'
```

through `/api/query` immediately after every `/api/session` and after every `/api/rollback` (because `SET` is transactional and a rollback restores the server default). The setting is sent through the read path, so it does not mark the session dirty or trigger the 8-hour reaper.

## Verified

After a real login, the app's own `sqlca` session returned:

```json
["Asia/Karachi", "2026-11-03 05:08:20.81", "2026-11-03 05:08:20.81"]
```

for `current_setting('TimeZone')`, `localtimestamp(3)`, and `(now() AT TIME ZONE 'Asia/Karachi')::timestamp(3)`.

A direct API session likewise returned `Asia/Karachi`.

## Result

- Runtime reads: already explicit Karachi time in the SQL map.
- Stored procedures called through any app session: now see Karachi time.
- Write/audit rules using `now()`, `localtimestamp`, or `CURRENT_DATE`: now run in the same timezone as the live SQL Server installation.
- No server rebuild is required for this correction.
