SET NOCOUNT ON;
SELECT c.session_id,
       (SELECT SUBSTRING(REPLACE(REPLACE([text], CHAR(13), ' '), CHAR(10), ' '), 1, 300)
          FROM sys.dm_exec_sql_text(c.most_recent_sql_handle)) AS last_sql
FROM sys.dm_exec_connections AS c
WHERE c.session_id > 50 AND c.session_id <> @@SPID;
