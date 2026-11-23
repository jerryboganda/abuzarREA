-- Recreate the auto client backup job with the schedule name the legacy app
-- expects.  The vendor export split `autobackupscheduleclient` at an extraction
-- boundary, so the first creation produced a name containing a newline.
USE msdb;
GO
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'autobackupclient')
    EXEC msdb.dbo.sp_delete_job @job_name = N'autobackupclient';

DECLARE @JobID uniqueidentifier;

EXEC msdb.dbo.sp_add_job
    @job_id = @JobID OUTPUT,
    @job_name = N'autobackupclient',
    @owner_login_name = N'sa',
    @description = N'No description available.',
    @category_name = N'[Uncategorized (Local)]',
    @enabled = 1,
    @notify_level_email = 0,
    @notify_level_page = 0,
    @notify_level_netsend = 0,
    @notify_level_eventlog = 2,
    @delete_level = 0;

EXEC msdb.dbo.sp_add_jobstep
    @job_id = @JobID,
    @step_id = 1,
    @step_name = N'AutoBackUpClientStep-1',
    @command = N'c:\backupappclient\backup.exe',
    @database_name = N'',
    @server = N'',
    @database_user_name = N'',
    @subsystem = N'CmdExec',
    @cmdexec_success_code = 0,
    @flags = 0,
    @retry_attempts = 0,
    @retry_interval = 1,
    @output_file_name = N'',
    @on_success_step_id = 0,
    @on_success_action = 1,
    @on_fail_step_id = 0,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;

EXEC msdb.dbo.sp_add_jobschedule
    @job_id = @JobID,
    @name = N'autobackupscheduleclient',
    @enabled = 1,
    @freq_type = 4,
    @active_start_date = 20260101,
    @active_start_time = 0,
    @freq_interval = 1,
    @freq_subday_type = 8,
    @freq_subday_interval = 5,
    @freq_relative_interval = 0,
    @freq_recurrence_factor = 0,
    @active_end_date = 99991231,
    @active_end_time = 235959;

EXEC msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';

SELECT j.name, s.name
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobschedules js ON js.job_id = j.job_id
JOIN msdb.dbo.sysschedules s ON s.schedule_id = js.schedule_id
WHERE j.name = N'autobackupclient';
GO
