SET NOCOUNT ON;
SELECT TOP 30
    qs.execution_count AS execs,
    qs.total_logical_reads AS total_reads,
    qs.total_worker_time / 1000 AS cpu_ms,
    qs.total_elapsed_time / 1000 AS elapsed_ms,
    qs.total_logical_reads / NULLIF(qs.execution_count, 0) AS reads_per_exec,
    (SELECT SUBSTRING(REPLACE(REPLACE([text], CHAR(13), ' '), CHAR(10), ' '), 1, 200)
       FROM sys.dm_exec_sql_text(qs.sql_handle)) AS sql_text
FROM sys.dm_exec_query_stats AS qs
WHERE (SELECT dbid FROM sys.dm_exec_sql_text(qs.sql_handle)) = DB_ID()
  AND qs.execution_count > 2
ORDER BY qs.total_logical_reads DESC;
