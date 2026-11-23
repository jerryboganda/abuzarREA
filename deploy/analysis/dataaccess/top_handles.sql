SET NOCOUNT ON;
SELECT TOP 40
    CONVERT(varchar(130), qs.sql_handle, 1) AS handle,
    qs.execution_count AS execs,
    qs.total_logical_reads AS total_reads,
    qs.total_worker_time / 1000 AS cpu_ms,
    qs.total_elapsed_time / 1000 AS elapsed_ms,
    qs.total_logical_reads / NULLIF(qs.execution_count, 0) AS reads_per_exec,
    qs.statement_start_offset, qs.statement_end_offset
FROM sys.dm_exec_query_stats AS qs
ORDER BY qs.total_logical_reads DESC;
