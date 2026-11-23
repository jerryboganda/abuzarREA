SET NOCOUNT ON;
SELECT c.session_id, c.cursor_id, c.name, c.properties, c.status, c.fetch_status, c.creation_time, c.is_open,
       c.rows_affected, c.rows_returned, DB_NAME(c.database_id) AS db
FROM sys.dm_exec_cursors(0) AS c
WHERE c.session_id > 50
ORDER BY c.session_id;

SELECT session_id, user_objects_alloc_page_count, user_objects_dealloc_page_count,
       internal_objects_alloc_page_count, internal_objects_dealloc_page_count
FROM sys.dm_db_session_space_usage
WHERE session_id > 50;

SELECT TOP 20 request_session_id, resource_type, resource_description, request_mode, request_status, COUNT(*) AS n
FROM sys.dm_tran_locks
WHERE request_session_id > 50
GROUP BY request_session_id, resource_type, resource_description, request_mode, request_status
ORDER BY request_session_id, n DESC;
