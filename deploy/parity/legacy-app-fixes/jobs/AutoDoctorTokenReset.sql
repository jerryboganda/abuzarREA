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

  WHERE (name = N'AutoDoctorTokenReset')

  IF (@JobID IS NOT NULL)    

  BEGIN  

  -- Check if the job is a multi-server job  

  IF (EXISTS (SELECT  * 

              FROM    msdb.dbo.sysjobservers 

              WHERE   (job_id = @JobID) AND (server_id <> 0))) 

  BEGIN 

    -- There is, so abort the script 

    RAISERROR (N'Unable to import job ''AutoDoctorTokenReset'' since there is already a multi-server job with this name.', 16, 1) 

    GOTO QuitWithRollback  

  END 

  ELSE 

    -- Delete the [local] job 

    EXECUTE msdb.dbo.sp_delete_job @job_name = N'AutoDoctorTokenReset' 

    SELECT @JobID = NULL

  END 



BEGIN 


  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'AutoDoctorTokenReset', @owner_login_name = N'sa', @description = N'Automatically Purge Posted Sales.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_ne
ALTER PROCEDURE DBO.SP_Select_Service @col VARCHAR(255), @tablename VARCHAR(255)

AS

DECLARE @QRY NVARCHAR(4000)

DECLARE @columnname VARCHAR(255)

SET @columnname = (SELECT MAX(Name) FROM SysColumns WHERE ID IN (SELECT ID FROM SysObjects WHERE name=@tablename) AND Name = @col)

IF @columnname IS NULL

	SET @QRY = 'SELECT '''' AS Mycolumn WHERE 1=2'

ELSE

	SET @QRY = N'SELECT DISTINCT mycolumn=' + @col + ' FROM ' + @tablename

EXECUTE(@QRY)INSERT INTO RightsClone (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) 

SELECT 1666, 'Basic Data , Patient , Birth Certificate', 'Birth Certificate', 3, '6,23,19,', 'A', 4CREATE TABLE DBO.BirthCertificate (

BirthCertificateCode INT NOT NULL CONSTRAINT PK_BirthCertificate PRIMARY KEY (BirthCertificateCode),

PatientCode INT NOT NULL CONSTRAINT FK_BirthCertificate_Patient_PatientCode FOREIGN KEY (PatientCode) REFERENCES DBO.Patient (PatientCode),

VisitCode INT NULL CONSTRAINT FK_BirthCertificate_Visit_VisitCode FOREIGN KEY (VisitCode) REFERENCES DBO.Visit (VisitCode),

AdmissionCode INT NULL CONSTRAINT FK_BirthCertificate_PatientAdmission_AdmissionCode FOREIGN KEY (AdmissionCode) REFERENCES DBO.PatientAdmission (AdmissionCode),

UserCode SMALLINT NOT NULL CONSTRAINT FK_BirthCertificate_Users_UserCode FOREIGN KEY (UserCode) REFERENCES DBO.Users (UserCode),

Date DATETIME NOT NULL CONSTRAINT DF_BirthCertificate_Date DEFAULT (GETDATE()),

DOB DATETIME NOT NULL CONSTRAINT DF_BirthCertificate_DOB DEFAULT (GETDATE()),

ChildName VARCHAR(100) NULL,

Gender CHAR(1) NULL CONSTRAINT DF_BirthCertificate_Gender DEFAULT ('M'),

FatherName VARCHAR(100) NULL,

FatherCNIC VARCHAR(100) NULL,

FatherCellNo VARCHAR(100) NULL,

MotherName VARCHAR(100) NULL,

MotherCNIC VARCHAR(100) NULL,

MotherCellNo VARCHAR(100) NULL,

AgeOfMother VARCHAR(100) NULL,

PlaceOfBirth VARCHAR(100) NULL,

DoctorName VARCHAR(100) NULL,

HospitalName VARCHAR(100) NULL,

IssuedTo VARCHAR(100) NULL,

IssuedToCNIC VARCHAR(100) NULL,

IssuedToCellNo VARCHAR(100) NULL

)
tsend = 0, @notify_level_eventlog = 0, @delete_level= 0

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoDoctorTokenReset_Step-1', @command = N'EXEC SP_AutoDoctorTokenReset', @database_name = @dbname , @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 



  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoDoctorTokenReset_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20121113, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959

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
