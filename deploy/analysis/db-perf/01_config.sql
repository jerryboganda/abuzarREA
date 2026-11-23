SET NOCOUNT ON;
SELECT 'DBPROP' AS k
 , name, compatibility_level, recovery_model_desc, page_verify_option_desc
 , is_auto_close_on, is_auto_shrink_on, is_auto_create_stats_on, is_auto_update_stats_on
 , is_auto_update_stats_async_on, is_read_committed_snapshot_on, snapshot_isolation_state_desc
 , is_ansi_null_default_on, is_ansi_nulls_on, is_ansi_padding_on, is_ansi_warnings_on
 , is_arithabort_on, is_concat_null_yields_null_on, is_quoted_identifier_on
 , is_numeric_roundabort_on, is_cursor_close_on_commit_on, is_local_cursor_default
 , is_fulltext_enabled, is_parameterization_forced, is_trustworthy_on
 , log_reuse_wait_desc
FROM sys.databases WHERE database_id = DB_ID();

SELECT 'SERVERCFG' AS k, name, value, value_in_use, minimum, maximum, is_dynamic, is_advanced
FROM sys.configurations
WHERE name IN ('max degree of parallelism','cost threshold for parallelism','max server memory (MB)',
 'min server memory (MB)','optimize for ad hoc workloads','backup compression default',
 'fill factor (%)','max worker threads','query governor cost limit','cursor threshold',
 'blocked process threshold (s)','lightweight pooling','priority boost',
 'affinity mask','network packet size (B)');

SELECT 'FILE' AS k, f.name, f.type_desc, f.physical_name, f.size*8/1024 AS size_mb
 , f.max_size, f.growth, f.is_percent_growth, f.is_read_only
FROM sys.database_files f;
