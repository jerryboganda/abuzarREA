SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
USE msdb;
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoCreateScheduledSMS')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoCreateScheduledSMS';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoCreateScheduledSMS', @owner_login_name = N'sa', @description = N'Automatically Create Scheduled SMS.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoCreateScheduledSMS_Step-1', @command = N'exec SP_CreateScheduledSMS', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoCreateScheduledSMS_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoDataFetchFromChildServer')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoDataFetchFromChildServer';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoDataFetchFromChildServer', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'FetchData', @command = N'BEGIN DISTRIBUTED TRANSACTION T1  DECLARE @rtcode int  EXECUTE @rtcode = DBO.SP_Fetch_ChildServerSales', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoDataFetchFromChildServer_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 2, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoDataMigration')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoDataMigration';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoDataMigration', @owner_login_name = N'sa', @description = N'Automatically Purge Posted Sales.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoDataMigration_Step-1', @command = N'EXEC SP_AutoDataMigration', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoDataMigration_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoDoctorTokenReset')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoDoctorTokenReset';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoDoctorTokenReset', @owner_login_name = N'sa', @description = N'Automatically Purge Posted Sales.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoDoctorTokenReset_Step-1', @command = N'EXEC SP_AutoDoctorTokenReset', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoDoctorTokenReset_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoEmployeeTimout')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoEmployeeTimout';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoEmployeeTimout', @owner_login_name = N'sa', @description = N'Auto Timeout Employees with ideal timeout elapsed.', @category_name = N'[Uncategorized (Local)]', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoEmployeeTimout_Step-1', @command = N'exec SP_AutoTimeOut_Attendance', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'SP_AutoTimeOut_Attendance_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'autocreditsaleposting')
  EXEC msdb.dbo.sp_delete_job @job_name = N'autocreditsaleposting';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'autocreditsaleposting', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'autocreditsalepostingstep-1', @command = N'exec sp_autosaleposting 2', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'autocreditsalepostingschedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'autoinpatientservice')
  EXEC msdb.dbo.sp_delete_job @job_name = N'autoinpatientservice';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'autoinpatientservice', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'autoinpatientservicestep-1', @command = N'exec SP_Generate_Svc_From_AdmPatientRecSvc', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'autoinpatientserviceschedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 225959, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 24, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoPatientRecService')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoPatientRecService';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoPatientRecService', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoPatientRecServicestep-1', @command = N'exec SP_Generate_Svc_From_PatientRecSvc', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoPatientRecServiceschedule', @enabled = 1, @freq_type = 16, @active_start_date = 20260101, @active_start_time = 90000, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 24, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoPostVisit')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoPostVisit';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoPostVisit', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoPostVisitstep-1', @command = N'exec sp_autopost_visit', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoPostVisitschedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoPostVisitAppointment')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoPostVisitAppointment';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoPostVisitAppointment', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoPostVisitAppointmentstep-1', @command = N'exec sp_autopost_visitappointment', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoPostVisitAppointmentschedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoPurgePostedSales')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoPurgePostedSales';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoPurgePostedSales', @owner_login_name = N'sa', @description = N'Automatically Purge Posted Sales.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoPurgePostedSales_Step-1', @command = N'EXEC SP_CopyInvoicesToSBuffer', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoPurgePostedSales_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoRestrictSelectedClassItems')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoRestrictSelectedClassItems';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoRestrictSelectedClassItems', @owner_login_name = N'sa', @description = N'Automatically Create Scheduled SMS.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoRestrictSelectedClassItems_Step-1', @command = N'exec SP_RestrictSelectedClassItems', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoRestrictSelectedClassItems_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoSatisfyDue')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoSatisfyDue';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoSatisfyDue', @owner_login_name = N'sa', @description = N'Automatically Satisfy Due.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoSatisfyDue_Step-1', @command = N'exec SP_AutoSatisfyDue', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoSatisfyDue_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'AutoStockVerification')
  EXEC msdb.dbo.sp_delete_job @job_name = N'AutoStockVerification';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'AutoStockVerification', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'autostockverification', @command = N'exec sp_autostockverification', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'autostockverification', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 8, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO

DECLARE @JobID uniqueidentifier, @ReturnCode int, @dbname sysname = N'FazalDinPP19DataBaseV2';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'TSQL_Job_StockReport')
  EXEC msdb.dbo.sp_delete_job @job_name = N'TSQL_Job_StockReport';
EXEC @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT, @job_name = N'TSQL_Job_StockReport', @owner_login_name = N'sa', @description = N'Stock report snapshot job (legacy app scheduler)', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level = 0;
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'TSQL_Job_StockReportStep 1', @command = N'EXEC SP_StockReport 30, 365', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2;
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1;
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'TSQL_Job_StockReportSchedule 1', @enabled = 1, @freq_type = 4, @active_start_date = 20260101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 1, @active_end_date = 99991231, @active_end_time = 235959;
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)';
GO
