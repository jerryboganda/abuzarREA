USE msdb;
GO
BEGIN TRANSACTION            

  DECLARE @JobID BINARY(16)  

  DECLARE @ReturnCode INT    

  SELECT @ReturnCode = 0     

IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'[Uncategorized (Local)]') < 1 

  EXECUTE msdb.dbo.sp_add_category @name = N'[Uncategorized (Local)]'


  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     

  FROM   msdb.dbo.sysjobs    

  WHERE (name = N'AutoCreateScheduledSMS')

  IF (@JobID IS NOT NULL)    

  BEGIN  

  -- Check if the job is a multi-server job  

  IF (EXISTS (SELECT  * 

              FROM    msdb.dbo.sysjobservers 

              WHERE   (job_id = @JobID) AND (server_id <> 0))) 

  BEGIN 

    -- There is, so abort the script 

    RAISERROR (N'Unable to import job ''AutoCreateScheduledSMS'' since there is already a multi-server job with this name.', 16, 1) 

    GOTO QuitWithRollback  

  END 

  ELSE 

    -- Delete the [local] job 

    EXECUTE msdb.dbo.sp_delete_job @job_name = N'AutoCreateScheduledSMS' 

    SELECT @JobID = NULL

  END 



BEGIN 


  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'AutoCreateScheduledSMS', @owner_login_name = N'sa', @description = N'Automatically Create Scheduled SMS.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notif
UPDATE RightsClone SET RightName = 'Maintenance , Modify Last Transaction Date', MenuName='Modify Last Transaction Date ' WHERE RightCode = 231

UPDATE RightsClone SET RightName = 'Maintenance , Item Priority , Rights , Modify Batch and Expiry ', MenuName='Item Priority , Rights , Modify Batch and Expiry ' WHERE RightCode = 548

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Auto Batch Generation ' WHERE RightCode = 641

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Modify Date ' WHERE RightCode = 693

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Modify Receipt ' WHERE RightCode = 562

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Populate Sale Order ' WHERE RightCode = 735

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Receipt Posting ' WHERE RightCode = 561

UPDATE RightsClone SET RightName = 'Maintenance , Receipt , Rights , Save and Post ' WHERE RightCode = 621

UPDATE RightsClone SET RightName = 'Maintenance , User Time-in , Modify Date & Time' WHERE RightCode = 709

UPDATE RightsClone SET RightName = 'Maintenance , User Time-out , Modify Date & Time' WHERE RightCode = 710
y_level_netsend = 0, @notify_level_eventlog = 0, @delete_level= 0

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoCreateScheduledSMS_Step-1', @command = N'exec SP_CreateScheduledSMS', @database_name = @dbname , @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 



  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoCreateScheduledSMS_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20121113, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 



  -- Add the Target Servers
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 



END

COMMIT TRANSACTION          

GOTO   EndSave              

QuitWithRollback:

  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 

EndSave:
GO
