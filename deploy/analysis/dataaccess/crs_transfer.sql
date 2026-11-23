CREATE  PROCEDURE DBO.SP_CRS_ClientDataTransfer
	@SRV VARCHAR(50), 
	@DB VARCHAR(50), 
	@OWNER VARCHAR(20),
	@UserCode SMALLINT = NULL
AS

SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @err int, @VersionSyn TINYINT, @ClientID SMALLINT, @InstanceID SMALLINT
DECLARE @SequenceID int, @LocalSequenceID INT, @LogID INT
DECLARE @AppVersion int, @LocalAppVersion INT
DECLARE @DBStatus int, @LocalDBStatus INT
DECLARE @InstanceName VARCHAR(100), @Remarks VARCHAR(255), @TableName VARCHAR(255), @LastTableName VARCHAR(255), @LocalUPD VARCHAR(1000)
DECLARE @Query VARCHAR(1000), @TablePrefix VARCHAR(255), @TransferType CHAR(1)
DECLARE @ClientID_STR VARCHAR(100), @InstanceID_STR VARCHAR(100), @LogID_STR VARCHAR(100)

SET @TablePrefix = @SRV + '.' + @DB + '.' + @OWNER + '.'
SET @VersionSyn = 0

EXECUTE @err = DBO.SP_GetVersionInfo @SRV, @DB, @OWNER, @SequenceID OUTPUT , @AppVersion OUTPUT , @DBStatus OUTPUT
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('CRS Version Fetch: Unable to fetch CRS Server version info', 16, 1)
	RETURN -1
END

SET @LocalSequenceID = ISNULL((SELECT SequenceID FROM Sequence), 0)
SET @LocalAppVersion = ISNULL((SELECT AppVersion FROM Sequence), 0)
SET @LocalDBStatus = ISNULL((SELECT DBStatus FROM Sequence), 0)

IF @SequenceID = @LocalSequenceID AND @AppVersion = @LocalAppVersion AND @DBStatus = @LocalDBStatus
	SET @VersionSyn = 1

IF @VersionSyn = 0
BEGIN
	RAISERROR('Unable to Continue due to CRS Server and CRS Client version Conflicts.', 16, 1)
	RETURN -1
END

SET @InstanceName = ISNULL((SELECT Name FROM ClientInstance) ,'')

EXECUTE @err = DBO.SP_CRS_GetClientInstanceInfo @SRV, @DB, @OWNER, @InstanceName, @ClientID OUTPUT , @InstanceID OUTPUT
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('CRS Instance Verification: Unable to make CRS Instance Verification From CRS Server.', 16, 1)
	RETURN -1
END 

IF @ClientID IS NULL OR @ClientID=0 OR @InstanceID IS NULL OR @InstanceID=0
BEGIN
	RAISERROR('CRS Instance Validation: Unable to Validate CRS Instance From CRS Server.', 16, 1)
	RETURN -1
END 
--Update this clientid and instanceid into current database
UPDATE ClientInstance SET ClientID=@ClientID, ClientInstanceID=@InstanceID

SET @ClientID_STR = LTRIM(RTRIM(CAST(@ClientID AS VARCHAR(100))))
SET @InstanceID_STR = LTRIM(RTRIM(CAST(@InstanceID AS VARCHAR(100))))
/*
Get Primary Key value for fresh crs_datatransferlog instance
*/
SET @Query = 'INSERT INTO ' + @TablePrefix + 'CRS_DataTransferLog (ClientInstanceID, UserCode, StartDate, EndDate) VALUES (' + @InstanceID_STR + ', ' + ISNULL(STR(@UserCode), 'NULL') + ', GETDATE(), GETDATE())'
EXECUTE (@Query)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0 OR @@RowCount = 0
BEGIN
	RaisError('CRS Data Transfer Error: Problem in generating data transfer log header row', 16, 1)
	RETURN -1
END

SET @Query = 'INSERT INTO REPORTDATA (Code1, Name1) SELECT LOGID=MAX(LogID), Name1 = ''CRS_DataTransferLog'' FROM ' + @TablePrefix + 'CRS_DataTransferLog WHERE ClientInstanceID = ' + @InstanceID_STR
EXECUTE (@Query)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0 OR @@RowCount = 0
BEGIN
	RaisError('CRS Data Transfer Error: Problem in generating data transfer log header row', 16, 1)
	RETURN -1
END

SET @LOGID = ISNULL((SELECT MAX(Code1) FROM ReportData WHERE Name1='CRS_DataTransferLog'), 0)
SET @LogID_STR = LTRIM(RTRIM(CAST(@LOGID AS VARCHAR(100))))
IF @LogID <= 0 OR  @LogID IS NULL
BEGIN
	RaisError('CRS Data Transfer Error: Problem in generating data transfer log header row', 16, 1)
	RETURN -1
END

/*Variables to be used in delete, update and insert processes*/
DECLARE TmpCrs1 CURSOR FOR
SELECT SourceTableName, Remarks, TransferType
FROM CRS_TransferableData 
WHERE Enable='Y'
ORDER BY TransferType, Priority

OPEN TmpCrs1

FETCH NEXT FROM TmpCrs1 INTO @TableName, @Remarks, @TransferType
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Query = 'INSERT INTO ' + @TablePrefix + 'CRS_DataTransferLogDetail (LogID, SourceTableName, StartDate, EndDate) VALUES (' + @LogID_STR + ', ''' + @TableName + ''', GETDATE(), GETDATE())'
	EXECUTE (@Query)
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RaisError('CRS Data Transfer Error: Problem in generating data transfer log detail row', 16, 1)
		RETURN -1
	END

	EXECUTE @err = DBO.SP_CRS_TransferClientTable @SRV, @DB, @OWNER, @ClientID, @InstanceID, @TableName
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RAISERROR('CRS Data Transfer Error: Unable to Transfer Object, Name = %s.', 16, 1, @TableName)
		CLOSE TmpCrs1
		DEALLOCATE TmpCrs1
		RETURN -1
	END 
	IF @TransferType = 'T' AND RIGHT(UPPER(@TableName), 6) = 'DETAIL' AND UPPER(@TableName) <> 'GODOWNDETAIL'
	BEGIN
		IF UPPER(@LastTableName) = 'DUESATISFYHEADER'
			SET @LocalUPD = 'UPDATE ' + @LastTableName + ' SET CRS_Transfered = ''Y'', CRS_TransferedON = GETDATE() WHERE CRS_Transfered = ''N'''
		ELSE
			SET @LocalUPD = 'UPDATE ' + @LastTableName + ' SET CRS_Transfered = ''Y'', CRS_TransferedON = GETDATE() WHERE CRS_Transfered = ''N'' AND Posted=''Y'' '
		EXECUTE (@LocalUPD)
		SET @err = @@ERROR
		IF @@ERROR <> 0 OR @err <> 0
		BEGIN
			RAISERROR('CRS Data Transfer Error: Unable to Update Status of Object, Name = %s.', 16, 1, @LastTableName)
			CLOSE TmpCrs1
			DEALLOCATE TmpCrs1
			RETURN -1
		END
	END
	SET @Query = 'UPDATE ' + @TablePrefix + 'CRS_DataTransferLogDetail SET EndDate = GETDATE() WHERE LogID = ' + @LogID_STR  + ' AND SourceTableName = ''' + @TableName + ''''
	EXECUTE (@Query)
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RaisError('CRS Data Transfer Error: Problem in marking end date for data transfer log detail row', 16, 1)
		RETURN -1
	END
	SET @LastTableName = @TableName
	FETCH NEXT FROM TmpCrs1 INTO @TableName, @Remarks, @TransferType
END
CLOSE TmpCrs1
DEALLOCATE TmpCrs1

SET @Query = 'UPDATE ' + @TablePrefix + 'CRS_DataTransferLog SET EndDate = GETDATE() WHERE LogID = ' + @LogID_STR
EXECUTE (@Query)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RaisError('CRS Data Transfer Error: Problem in marking end date for data transfer log', 16, 1)
	RETURN -1
END

EXECUTE @err = DBO.SP_CRS_FetchFinalizedSaleOrders @SRV, @DB, @OWNER, @InstanceID, @UserCode
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('CRS Sale Order Data Transfer: Unable to fetch From CRS Server.', 16, 1)
	RETURN -1
END 

RETURN 0
