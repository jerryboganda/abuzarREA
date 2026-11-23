SET NOCOUNT ON;
DECLARE @dbid int; SET @dbid = DB_ID('FazalDinPP19DataBaseV2');

SELECT 'UPTIME' AS k;
SELECT sqlserver_start_time, DATEDIFF(hour,sqlserver_start_time,GETDATE()) AS uptime_hours
FROM sys.dm_os_sys_info;

SELECT 'MEMORY' AS k;
SELECT physical_memory_in_bytes/1048576 AS physical_mb, virtual_memory_in_bytes/1048576 AS virtual_mb,
       bpool_committed*8/1024 AS bp_committed_mb, bpool_visible*8/1024 AS bp_visible_mb
FROM sys.dm_os_sys_info;

SELECT 'PERF_COUNTERS' AS k;
SELECT counter_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters
WHERE (object_name LIKE '%Buffer Manager%'
  AND counter_name IN ('Page life expectancy','Buffer cache hit ratio','Buffer cache hit ratio base',
    'Database pages','Free pages','Stolen pages','Lazy writes/sec','Page reads/sec','Page writes/sec',
    'Checkpoint pages/sec','Target pages'))
   OR (object_name LIKE '%Plan Cache%' AND counter_name IN ('Cache Pages','Cache Object Counts'))
   OR (object_name LIKE '%SQL Statistics%' AND counter_name IN ('Batch Requests/sec','SQL Compilations/sec',
       'SQL Re-Compilations/sec','Number of Deadlocks/sec','Auto-Param Attempts/sec','Failed Auto-Params/sec'));

SELECT 'WAITS' AS k;
SELECT TOP 20 wait_type, waiting_tasks_count, wait_time_ms, signal_wait_time_ms,
       CAST(100.0*wait_time_ms/SUM(wait_time_ms) OVER() AS DECIMAL(6,2)) AS pct
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK',
 'SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','WAITFOR','LOGMGR_QUEUE','CHECKPOINT_QUEUE','REQUEST_FOR_DEADLOCK_SEARCH',
 'XE_TIMER_EVENT','BROKER_TO_FLUSH','BROKER_TASK_STOP','CLR_MANUAL_EVENT','CLR_AUTO_EVENT','DISPATCHER_QUEUE_SEMAPHORE',
 'FT_IFTS_SCHEDULER_IDLE_WAIT','XE_DISPATCHER_WAIT','XE_DISPATCHER_JOIN','SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
 'BROKER_EVENTHANDLER','BROKER_RECEIVE_WAITFOR','PREEMPTIVE_OS_GETPROCADDRESS','PREEMPTIVE_OS_AUTHENTICATIONOPS',
 'BROKER_OTHERWISE_WAIT','HADR_FILESTREAM_IOMGR_IOCOMPLETION','SP_SERVER_DIAGNOSTICS_SLEEP')
ORDER BY wait_time_ms DESC;

SELECT 'PLAN_CACHE' AS k;
SELECT objtype, COUNT(*) AS plans, SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS mb,
       SUM(usecounts) AS execs, AVG(CAST(size_in_bytes AS bigint)) AS avg_bytes
FROM sys.dm_exec_cached_plans GROUP BY objtype ORDER BY SUM(CAST(size_in_bytes AS bigint)) DESC;

SELECT 'ACTIVITY' AS k;
SELECT s.session_id, s.login_name, s.status, s.host_name, s.program_name,
       r.status AS req_status, r.command, r.wait_type, r.wait_time, r.cpu_time, r.logical_reads,
       SUBSTRING(t.text,1,120) AS sql_text
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON r.session_id=s.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE s.is_user_process=1;

SELECT 'DB_USAGE_BY_INDEX' AS k;
SELECT TOP 30 OBJECT_NAME(us.object_id, us.database_id) AS tbl, us.index_id,
  i.name AS idx_name,
  SUM(us.user_seeks) AS seeks, SUM(us.user_scans) AS scans, SUM(us.user_lookups) AS lookups,
  SUM(us.user_updates) AS updates, SUM(us.user_seeks+us.user_scans+us.user_lookups) AS reads,
  MAX(us.last_user_seek) AS last_seek, MAX(us.last_user_scan) AS last_scan, MAX(us.last_user_update) AS last_upd
FROM sys.dm_db_index_usage_stats us
LEFT JOIN sys.indexes i ON i.object_id=us.object_id AND i.index_id=us.index_id
WHERE us.database_id=@dbid
GROUP BY us.object_id, us.index_id, i.name, us.database_id
ORDER BY SUM(us.user_seeks+us.user_scans+us.user_lookups) DESC;

SELECT 'DB_USAGE_TOTALS' AS k;
SELECT COUNT(DISTINCT object_id) AS objects_touched, COUNT(*) AS index_entries,
  SUM(user_seeks) AS seeks, SUM(user_scans) AS scans, SUM(user_lookups) AS lookups, SUM(user_updates) AS updates
FROM sys.dm_db_index_usage_stats WHERE database_id=@dbid;

SELECT 'DB_IO' AS k;
SELECT DB_NAME(vfs.database_id) AS db, vfs.file_id, vfs.io_stall, vfs.num_of_reads, vfs.num_of_writes,
  vfs.num_of_bytes_read/1048576 AS mb_read, vfs.num_of_bytes_written/1048576 AS mb_written,
  CAST(vfs.io_stall*1.0/NULLIF(vfs.num_of_reads+vfs.num_of_writes,0) AS DECIMAL(10,2)) AS avg_stall_ms
FROM sys.dm_io_virtual_file_stats(DB_ID('FazalDinPP19DataBaseV2'), NULL) vfs;
