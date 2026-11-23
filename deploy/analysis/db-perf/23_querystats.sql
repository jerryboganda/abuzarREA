SET NOCOUNT ON;
SELECT 'PROC_STATS' AS k;
SELECT TOP 25 OBJECT_NAME(ps.object_id) AS proc_name, ps.execution_count,
  ps.total_worker_time/1000 AS total_cpu_ms, ps.total_worker_time/NULLIF(ps.execution_count,0)/1000 AS avg_cpu_ms,
  ps.total_logical_reads, ps.total_logical_reads/NULLIF(ps.execution_count,0) AS avg_reads,
  ps.total_elapsed_time/1000 AS total_elapsed_ms, ps.last_execution_time
FROM sys.dm_exec_procedure_stats ps
WHERE ps.database_id=DB_ID()
ORDER BY ps.total_logical_reads DESC;

SELECT 'QUERY_STATS' AS k;
SELECT TOP 20 qs.execution_count, qs.total_logical_reads, qs.total_logical_reads/NULLIF(qs.execution_count,0) AS avg_reads,
  qs.total_worker_time/1000 AS cpu_ms, qs.total_elapsed_time/1000 AS elapsed_ms,
  SUBSTRING(t.text,1,180) AS txt
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) t
ORDER BY qs.total_logical_reads DESC;
