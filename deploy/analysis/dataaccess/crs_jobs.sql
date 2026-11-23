SET NOCOUNT ON;
SELECT j.job_id, j.name, j.enabled, j.date_created, j.date_modified
FROM msdb.dbo.sysjobs AS j;

SELECT j.name, s.name AS schedule_name, s.enabled AS sched_enabled,
       s.freq_type, s.freq_interval, s.freq_subday_type, s.freq_subday_interval,
       s.active_start_time, s.active_end_time
FROM msdb.dbo.sysjobs AS j
LEFT JOIN msdb.dbo.sysjobschedules AS js ON js.job_id = j.job_id
LEFT JOIN msdb.dbo.sysschedules AS s ON s.schedule_id = js.schedule_id;

SELECT COUNT(*) AS crs_tables FROM sys.tables WHERE name LIKE 'crs[_]%';
SELECT COUNT(*) AS crs_procs FROM sys.procedures WHERE name LIKE 'sp[_]crs[_]%';
SELECT TOP 15 t.name, SUM(p.rows) AS rows_
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
WHERE t.name LIKE 'crs[_]%'
GROUP BY t.name ORDER BY rows_ DESC;
