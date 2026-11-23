USE msdb;
GO
DECLARE @dbname sysname = N'FazalDinPP19DataBaseV2';
BEGIN TRANSACTION            

  DECLARE @JobID BINARY(16)  

  DECLARE @ReturnCode INT    

  SELECT @ReturnCode = 0     

IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'[Uncategorized (Local)]') < 1 

  EXECUTE msdb.dbo.sp_add_category @name = N'[Uncategorized (Local)]'


  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     

  FROM   msdb.dbo.sysjobs    

  WHERE (name = N'AutoRestrictSelectedClassItems')

  IF (@JobID IS NOT NULL)    

  BEGIN  

  -- Check if the job is a multi-server job  

  IF (EXISTS (SELECT  * 

              FROM    msdb.dbo.sysjobservers 

              WHERE   (job_id = @JobID) AND (server_id <> 0))) 

  BEGIN 

    -- There is, so abort the script 

    RAISERROR (N'Unable to import job ''AutoRestrictSelectedClassItems'' since there is already a multi-server job with this name.', 16, 1) 

    GOTO QuitWithRollback  

  END 

  ELSE 

    -- Delete the [local] job 

    EXECUTE msdb.dbo.sp_delete_job @job_name = N'AutoRestrictSelectedClassItems' 

    SELECT @JobID = NULL

  END 



BEGIN 


  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'AutoRestrictSelectedClassItems', @owner_login_name = N'sa', @description = N'Automatically Create Scheduled SMS.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0
CREATE TABLE DBO.LicenseCategory (

LicenseCategoryCode SMALLINT NOT NULL CONSTRAINT PK_LicenseCategory PRIMARY KEY (LicenseCategoryCode),

Name VARCHAR(100) NOT NULL CONSTRAINT UK_LicenseCategory_Name UNIQUE (Name)

)INSERT INTO Interfacesetting VALUES(24,55,'customer_block','Blocked',0,3,0)

INSERT INTO Interfacesetting VALUES(24,56,'customer_charges','Charges',0,3,0)ALTER TABLE Customer ADD Charges NUMERIC(10,2) NOT NULL CONSTRAINT DF_Customer_Charges DEFAULT(0)

ALTER TABLE Customer ADD Block CHAR NOT NULL CONSTRAINT DF_Customer_Block DEFAULT('N')INSERT INTO Rights

VALUES(1373,'Reports , Sales Reports , Area/Region/Zone ... Wise , Sub Area / Item Wise Targetable Customer List','Sub Area / Item Wise Targetable Customer List',4,'5,3,7,21,','A',1)

INSERT INTO RightsClone

VALUES(1373,'Reports , Sales Reports , Area/Region/Zone ... Wise , Sub Area / Item Wise Targetable Customer List','Sub Area / Item Wise Targetable Customer List',4,'5,3,7,21,','A',1)

INSERT INTO GroupRights VALUES(2,1373,1)CREATE PROCEDURE DBO.SP_RestrictSelectedClassItems

AS

/* Restrict Items of Class 2 IF time is over 7 am and below than 11 pm*/

UPDATE Item SET Restricted = 'Y' WHERE ICCode = 2 AND (DatePart(hh, GETDATE()) > 7 AND DatePart(hh, GETDATE()) < 23)



/* Un-Restrict Items of Class 2 IF time is over 7 am or below 11 pm*/

UPDATE Item SET Restricted = 'N' WHERE ICCode = 2 AND NOT (DatePart(hh, GETDATE()) > 7 AND DatePart(hh, GETDATE()) < 23)



/* Un-Restrict Items of Class 3 IF time is over 7 am and below than 11 pm*/

UPDATE Item SET Restricted = 'N' WHERE ICCode = 3 AND (DatePart(hh, GETDATE()) > 7 AND DatePart(hh, GETDATE()) < 23)



/* Restrict Items of Class 3 IF time is over 7 am or below 11 pm*/

UPDATE Item SET Restricted = 'Y' WHERE ICCode = 3 AND NOT (DatePart(hh, GETDATE()) > 7 AND DatePart(hh, GETDATE()) < 23)
ALTER TABLE DBO.Customer ADD

Address VARCHAR(1000) NOT NULL CONSTRAINT DF_Customer_Address DEFAULT('.'),

Owner VARCHAR(100) NOT NULL CONSTRAINT DF_Customer_Owner DEFAULT('.'),

IssuedLicenseNo VARCHAR(100) NOT NULL CONSTRAINT DF_Customer_IssuedLicenseNo DEFAULT('.'),

FullName VARCHAR(100) NOT NULL CONSTRAINT DF_Customer_FullName DEFAULT('.')CREATE TABLE DBO.LicenseCategory (

LicenseCategoryCode SMALLINT NOT NULL IDENTITY(1,1) CONSTRAINT PK_LicenseCategory PRIMARY KEY (LicenseCategoryCode),

Name VARCHAR(100) NOT NULL CONSTRAINT UK_LicenseCategory_Name UNIQUE (Name)

)CREATE TABLE DBO.QualifiedPersonImage (

QualifiedPersonCode INT NOT NULL CONSTRAINT FK_QualifiedPersonImage_QualifiedPerson_QualifiedPersonCode FOREIGN KEY (QualifiedPersonCode) REFERENCES DBO.QualifiedPerson (QualifiedPersonCode),

ImageDescription VARCHAR(100) NULL,

RowID INT NOT NULL,

Img IMAGE NULL,

ImageType VARCHAR(100) NULL

CONSTRAINT PK_QualifiedPersonImage PRIMARY KEY (QualifiedPersonCode, RowID)

)CREATE TABLE DBO.QualifiedPerson (

QualifiedPersonCode INT NOT NULL CONSTRAINT PK_QualifiedPerson PRIMARY KEY (QualifiedPersonCode),

Name VARCHAR(100) NOT NULL,

NIC VARCHAR(100) NOT NULL CONSTRAINT UK_QualifiedPerson_NIC UNIQUE (NIC),

FName VARCHAR(100) NOT NULL CONSTRAINT DF_QualifiedPerson_FName DEFAULT('.'),

Gender CHAR(1) NOT NULL CONSTRAINT DF_QualifiedPerson_Gender DEFAULT('M'),

Address VARCHAR(1000) NOT NULL CONSTRAINT DF_QualifiedPerson_Address DEFAULT '.',

PhoneNo VARCHAR(100) NULL,

Mobile VARCHAR(100) NULL,

Email VARCHAR(100) NULL,

UserCode SMALLINT NOT NULL CONSTRAINT FK_Users_QualifiedPerson_UserCode FOREIGN KEY (UserCode) REFERENCES DBO.Users (UserCode),

Date DATETIME NOT NULL CONSTRAINT DF_QualifiedPerson_Date DEFAULT (GETDATE()),

Degree VARCHAR(100) NULL,

Institute VARCHAR(100) NULL,

PassingYear VARCHAR(100) NULL

)
, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 0, @delete_level= 0

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoRestrictSelectedClassItems_Step-1', @command = N'exec SP_RestrictSelectedClassItems', @database_name = @dbname , @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 



  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoRestrictSelectedClassItems_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20121113, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959

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
