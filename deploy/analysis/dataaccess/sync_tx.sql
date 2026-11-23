CREATE  PROCEDURE DBO.SP_SyncTransactionData_OnRemote @srv VARCHAR(100), @DB VARCHAR(255), @Owner VARCHAR(100)
AS
SET XACT_ABORT ON
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON

DECLARE @err INT, @SyncableRows INT, @RowID INT, @tablename VARCHAR(255), @ArchAccData CHAR(1), @Synchronize CHAR(1), @Del_Qry NVARCHAR(4000), @RemoteRef NVARCHAR(1000), @Frm NVARCHAR(100)
DECLARE @ParentTable VARCHAR(255), @ParentPK VARCHAR(255), @UpdateParent CHAR(1), @Posted CHAR(1)
DECLARE @Qry NVARCHAR(4000), @SQL NVARCHAR(4000), @LIST NVARCHAR(4000), @FROM VARCHAR(255), @LIST2 NVARCHAR(4000)
SET @Frm = ' FROM DBO.'
SET @ArchAccData = DBO.Fn_GetPreference('archiveaccountingdata')
SET @ArchAccData = ISNULL(@ArchAccData,'N')
IF LTRIM(RTRIM(@srv)) = ''
	SET @FROM = N' FROM ' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.'
ELSE
	SET @FROM = N' FROM ' + LTRIM(RTRIM(@srv)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.'

IF LTRIM(RTRIM(@srv)) = ''
	SET @RemoteRef = N'' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.'
ELSE
	SET @RemoteRef = N'' + LTRIM(RTRIM(@srv)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.'

/*
SET @Del_Qry  = N'Delete ' + @FROM + 'PurExp WHERE PurInvCode IN (SELECT PurInvCode ' + @FROM + 'PurLedger WHERE Posted=''N'')'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Deletion: Error Deleting Unposted Purchases Detail', 16, 1)
	RETURN -1
END 

SET @Del_Qry  = N'Delete ' + @FROM + 'PurDetail WHERE PurInvCode IN (SELECT PurInvCode ' + @FROM + 'PurLedger WHERE Posted=''N'')'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Deletion: Error Deleting Unposted Purchases Detail', 16, 1)
	RETURN -1
END 

SET @Del_Qry  = N'Delete ' + @FROM + 'PurLedger WHERE Posted=''N'''
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Deletion: Error Deleting Unposted Purchases', 16, 1)
	RETURN -1
END 
*/
CREATE TABLE #ins_temp (ROWID INT, TableName VARCHAR(255), Synchronize CHAR(1), ParentTable VARCHAR(255), ParentPK VARCHAR(255), UpdateParent CHAR(1), Posted CHAR(1))

INSERT INTO #ins_temp 
-- Truncate General Tables
/*
SELECT 10, 'ActivityMonitor', 'Y'
UNION ALL
SELECT 15, 'CashierJob', 'Y'
UNION ALL
SELECT 20, 'CashierActivity', 'Y'
UNION ALL
SELECT 40, 'StockLedger', 'Y'
UNION ALL
-- Purchase and Purchase Return Deletion
*/
SELECT 41, 'PurQuotationHeader', 'Y', NULL, 'PurQuotationCode', 'N', 'Y'
UNION ALL
SELECT 42, 'PurQuotationDetail', 'Y', 'PurQuotationHeader', 'PurQuotationCode', 'Y', 'Y'
UNION ALL
SELECT 43, 'SaleOrderHeader', 'Y', NULL, 'SaleOrderCode', 'N', 'Y'
UNION ALL
SELECT 44, 'SaleOrderDetail', 'Y', 'SaleOrderHeader', 'SaleOrderCode', 'Y', 'Y'
UNION ALL
SELECT 45, 'QuotationHeader', 'Y', NULL, 'QuotationCode', 'N', 'Y'
UNION ALL
SELECT 46, 'QuotationDetail', 'Y', 'QuotationHeader', 'QuotationCode', 'Y', 'Y'
UNION ALL
SELECT 47, 'PurOrderHeader', 'Y', NULL, 'POCode', 'N', 'Y'
UNION ALL
SELECT 48, 'PurOrderDetail', 'Y', 'PurOrderHeader', 'POCode', 'Y', 'Y'
UNION ALL
SELECT 50, 'PurRegister', 'Y', NULL, 'PurRegisterCode', 'N', 'Y'
UNION ALL
SELECT 60, 'ImpPurHeader', 'Y', NULL, 'ImpPurInvCode', 'N', 'Y'
UNION ALL
SELECT 70, 'PurLedger', 'Y', NULL, 'PurInvCode', 'N', 'Y'
UNION ALL
SELECT 80, 'AdvPurHeader', 'Y', NULL, 'AdvPurInvCode', 'N', 'Y'
UNION ALL
SELECT 90, 'PurExp', 'Y', 'PurLedger', 'PurInvCode', 'N', 'Y'
UNION ALL
SELECT 100, 'ProformaPurDetail', 'Y', 'PurLedger', 'PurInvCode', 'N', 'Y'
UNION ALL
SELECT 110, 'PurDetail', 'Y', 'PurLedger', 'PurInvCode', 'Y', 'Y'
UNION ALL
SELECT 120, 'AdvPurDetail', 'Y', 'AdvPurHeader', 'AdvPurInvCode', 'Y', 'Y'
UNION ALL
SELECT 130, 'ImpPurDetail', 'Y', 'ImpPurHeader', 'ImpPurInvCode', 'Y', 'Y'
UNION ALL
SELECT 140, 'PurRegisterDetail', 'Y', 'PurRegister', 'PurRegisterCode', 'Y', 'Y'
UNION ALL
SELECT 150, 'PRLedger', 'Y', NULL, 'PRInvCode', 'N', 'Y'
UNION ALL
SELECT 160, 'PRAllocationHeader', 'Y', NULL, 'PRAllocationCode', 'N', 'Y'
UNION ALL
SELECT 170, 'PRDetail', 'Y', 'PRLedger', 'PRInvCode', 'Y', 'Y'
UNION ALL
SELECT 180, 'PRAllocationDetail', 'Y', 'PRAllocationHeader', 'PRAllocationCode', 'Y', 'Y'

-- Sale Sale Return and Due Deletion 
UNION ALL
SELECT 190, 'DueAdjHeader', 'Y', NULL, 'DueAdjCode', 'N', 'N'
UNION ALL
SELECT 200, 'SaleLedger', 'Y', NULL, 'SaleInvCode', 'N', 'Y'
UNION ALL
SELECT 201, 'SaleInvGroup', 'Y', NULL, 'SaleInvGroupCode', 'N', 'N'
UNION ALL
SELECT 202, 'SaleInvGroupDetail', 'Y', 'SaleInvGroup', 'SaleInvGroupCode', 'Y', 'N'
UNION ALL
SELECT 203, 'DispatchHeader', 'Y', NULL, 'DispCode', 'N', 'Y'
UNION ALL
SELECT 204, 'DispatchDetail', 'Y', 'DispatchHeader', 'DispCode', 'Y', 'Y'
UNION ALL
SELECT 205, 'SaleSetsHeader', 'Y', 'SaleSetsHeader', 'SetCode', 'N', 'N'
UNION ALL
SELECT 206, 'SaleSetsDetail', 'Y', 'SaleSetsHeader', 'SetCode', 'N', 'N'
UNION ALL
SELECT 207, 'SaleSetsOrigDetail', 'Y', 'SaleSetsHeader', 'SetCode', 'Y', 'N'
UNION ALL
SELECT 210, 'DueSatisfyHeader', 'Y', NULL, 'DueSatisfyCode', 'N', 'N'
UNION ALL
SELECT 220, 'SaleLedgerLog', 'Y', 'SaleLedger', 'SaleInvCode',  'N', 'Y'
UNION ALL
SELECT 230, 'SRBufferLedger', 'Y', NULL, 'SRBufferInvCode', 'N', 'Y'
UNION ALL
SELECT 240, 'SRLedger', 'Y', NULL, 'SRInvCode', 'N', 'Y'
UNION ALL
SELECT 245, 'CashierWindow', 'Y', 'SaleLedger', 'SaleInvCode', 'Y', 'Y'
UNION ALL
SELECT 250, 'SaleInvDetail', 'Y', 'SaleLedger', 'SaleInvCode', 'N', 'Y'
UNION ALL
SELECT 260, 'SaleDetailLog', 'Y', 'SaleLedger', 'SaleInvCode', 'N', 'Y'
UNION ALL
SELECT 270, 'SaleDetail', 'Y', 'SaleLedger', 'SaleInvCode', 'Y', 'Y'
UNION ALL
SELECT 280, 'SRDetail', 'Y', 'SRLedger', 'SRInvCode', 'Y', 'Y'
UNION ALL
SELECT 290, 'SRBufferDetail', 'Y', 'SRBufferLedger', 'SRBufferInvCode', 'Y', 'Y'
UNION ALL
SELECT 300, 'SRAllocationHeader', 'Y', NULL, 'SRAllocationCode', 'N', 'Y'
UNION ALL
SELECT 310, 'SRAllocationDetail', 'Y', 'SRAllocationHeader', 'SRAllocationCode', 'Y', 'Y'
UNION ALL
SELECT 320, 'RefusedSaleHeader', 'Y', NULL, 'RefusedSaleInvCode', 'N', 'N'
UNION ALL
SELECT 330, 'RefusedSaleDetail', 'Y', 'RefusedSaleHeader', 'RefusedSaleInvCode', 'Y', 'N'
UNION ALL
SELECT 350, 'DueDeleteDetail', 'Y', 'DueSatisfyHeader', 'DueSatisfyCode', 'N', 'N'
UNION ALL
SELECT 360, 'DueSatisfyDetail', 'Y', 'DueSatisfyHeader', 'DueSatisfyCode', 'Y', 'N'
UNION ALL
SELECT 370, 'DueAdjDetail', 'Y', 'DueAdjHeader', 'DueAdjCode', 'Y', 'N'
-- Stock Adjustment Deletion
UNION ALL
SELECT 380, 'AdjHeader', 'Y', NULL, 'AdjCode', 'N', 'Y'
UNION ALL
SELECT 390, 'AdjBufferHeader', 'Y', NULL, 'AdjBufferCode', 'N', 'Y'
UNION ALL
SELECT 400, 'AdjDetail', 'Y', 'AdjHeader', 'AdjCode', 'Y', 'Y'
UNION ALL
SELECT 410, 'ItemConversionHeader', 'Y', NULL, 'ItemConversionCode', 'N', 'Y'
UNION ALL
SELECT 420, 'ItemConversionDetail', 'Y', 'ItemConversionHeader', 'ItemConversionCode', 'Y', 'Y'
UNION ALL
SELECT 430, 'AdjBufferDetail', 'Y', 'AdjBufferHeader', 'AdjBufferCode', 'Y', 'Y'
-- GodownTransfer
UNION ALL
SELECT 440, 'TransferRequisitionHeader', 'Y', NULL, 'TransReqCode', 'N', 'N'
UNION ALL
SELECT 450, 'TransferRequisitionDetail', 'Y', 'TransferRequisitionHeader', 'TransReqCode', 'Y', 'N'
UNION ALL
SELECT 460, 'Theader', 'Y', NULL, 'TransCode', 'N', 'Y'
UNION ALL
SELECT 470, 'TDetail', 'Y', 'Theader', 'TransCode', 'Y', 'Y'
-- Issue / Receipt
UNION ALL
SELECT 480, 'IssueReqHeader', 'Y', NULL, 'IssueReqInvCode', 'N', 'Y'
UNION ALL
SELECT 490, 'IssueReqDetail', 'Y', 'IssueReqHeader', 'IssueReqInvCode', 'Y', 'Y'
UNION ALL
SELECT 500, 'IssueHeader', 'Y', NULL, 'IssueInvCode', 'N', 'Y'
UNION ALL
SELECT 510, 'ReceiptHeader', 'Y', NULL, 'ReceiptInvCode', 'N', 'Y'
UNION ALL
SELECT 520, 'IssueDetail', 'Y', 'IssueHeader', 'IssueInvCode', 'Y', 'Y'
UNION ALL
SELECT 530, 'ReceiptDetail', 'Y', 'ReceiptHeader', 'ReceiptInvCode', 'Y', 'Y'
UNION ALL
SELECT 540, 'ProdHeader', 'Y', NULL, 'ProdCode', 'N', 'Y'
UNION ALL
SELECT 550, 'ProdBuffer', 'Y', 'ProdHeader', 'ProdCode', 'N', 'Y'
UNION ALL
SELECT 560, 'ProdDetail', 'Y', 'ProdHeader', 'ProdCode', 'Y', 'Y'
--Service Tables
UNION ALL
SELECT 700, 'ServiceHeader', 'Y', NULL, 'ServiceInvCode', 'N', 'Y'
UNION ALL
SELECT 710, 'ServiceDetail', 'Y', 'ServiceHeader', 'ServiceInvCode', 'Y', 'Y'
UNION ALL
SELECT 720, 'ServiceRHeader', 'Y', NULL, 'ServiceRInvCode', 'N', 'Y'
UNION ALL
SELECT 730, 'ServiceRDetail', 'Y', 'ServiceRHeader', 'ServiceRInvCode', 'Y', 'Y'
UNION ALL
SELECT 740, 'ServiceSrAllocationHeader', 'Y', NULL, 'ServiceSrAllocationCode', 'N', 'Y'
UNION ALL
SELECT 750, 'ServiceSrAllocationDetail', 'Y', 'ServiceSrAllocationHeader', 'ServiceSrAllocationCode', 'Y', 'Y'
UNION ALL
SELECT 760, 'ServicePurHeader', 'Y', NULL, 'ServicePurInvCode', 'N', 'Y'
UNION ALL
SELECT 770, 'ServicePurDetail', 'Y', 'ServicePurHeader', 'ServicePurInvCode', 'Y', 'Y'
UNION ALL
SELECT 780, 'ServicePrHeader', 'Y', NULL, 'ServicePrInvCode', 'N', 'Y'
UNION ALL
SELECT 790, 'ServicePrDetail', 'Y', 'ServicePrHeader', 'ServicePrInvCode', 'Y', 'Y'
UNION ALL
SELECT 800, 'ServicePrAllocationHeader', 'Y', NULL, 'ServicePrAllocationCode', 'N', 'Y'
UNION ALL
SELECT 810, 'ServicePrAllocationDetail', 'Y', 'ServicePrAllocationHeader', 'ServicePrAllocationCode', 'Y', 'Y'
--Accounting Tables
UNION ALL
SELECT 1010, 'GLHeader', @ArchAccData, NULL, 'GLVochCode', 'N', 'Y'
UNION ALL
SELECT 1020, 'GLDetail', @ArchAccData, 'GLHeader', 'GLVochCode', 'Y', 'Y'
UNION ALL
SELECT 1030, 'Notes', @ArchAccData, NULL, 'NoteCode', 'Y', 'Y'
UNION ALL
SELECT 1040, 'NotesDetail', @ArchAccData, 'Notes', 'NoteCode', 'Y', 'Y'
UNION ALL
SELECT 1050, 'TransactionHeader', @ArchAccData, NULL, 'DocumentCode', 'N', 'Y'
UNION ALL
SELECT 1060, 'TransactionDetail', @ArchAccData, 'TransactionHeader', 'DocumentCode', 'Y', 'Y'
UNION ALL
SELECT 1065, 'AvgPriceAdjHeader', @ArchAccData, NULL, 'DocumentCode', 'N', 'Y'
UNION ALL
SELECT 1070, 'AvgPriceAdjDetail', @ArchAccData, 'AvgPriceAdjHeader', 'DocumentCode', 'Y', 'Y'

DECLARE C1 CURSOR FOR
SELECT RowID, TableName, Synchronize, ParentTable, ParentPK, UpdateParent, Posted
FROM #ins_temp
ORDER BY ROWID

OPEN C1

FETCH NEXT FROM C1
INTO @RowID, @TableName, @Synchronize, @ParentTable, @ParentPK, @UpdateParent, @Posted
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @QRY = N''
	DELETE REPORTDATA
	IF @ParentTable IS NULL
		IF @Posted = 'Y'
			SET @QRY = N'INSERT INTO REPORTDATA (Code1) SELECT ISNULL(COUNT(*), 0) FROM ' + @TableName + ' WHERE Posted = ''Y'' AND Synced = ''N''' 
		ELSE
			SET @QRY = N'INSERT INTO REPORTDATA (Code1) SELECT ISNULL(COUNT(*), 0) FROM ' + @TableName + ' WHERE Synced = ''N''' 
	ELSE
		IF @Posted = 'Y'
			SET @QRY = N'INSERT INTO REPORTDATA (Code1) SELECT ISNULL(COUNT(*), 0) FROM ' + @TableName + ' WHERE ' + @ParentPK + ' IN (SELECT ' + @ParentPK + ' FROM ' + @ParentTable + ' WHERE Posted = ''Y'' AND Synced = ''N'')' 
		ELSE
			SET @QRY = N'INSERT INTO REPORTDATA (Code1) SELECT ISNULL(COUNT(*), 0) FROM ' + @TableName + ' WHERE ' + @ParentPK + ' IN (SELECT ' + @ParentPK + ' FROM ' + @ParentTable + ' WHERE Synced = ''N'')' 
--	PRINT @QRY
	EXECUTE (@QRY)
	SET @SyncableRows = ISNULL((SELECT SUM(Code1) FROM REPORTDATA), 0)

	IF @Synchronize='Y' AND @SyncableRows > 0
	BEGIN
		SET @QRY = N''
		SET @SQL = N' SELECT '
		SET @LIST=''
		EXECUTE @err = SP_COLUMNLIST @OWNER, @TableName, @LIST OUTPUT
		SET @err = @@ERROR
		IF @@ERROR <> 0 OR @err <> 0
		BEGIN
			CLOSE C1
			DEALLOCATE C1
			RETURN -1
		END
	
		IF @ParentTable IS NULL
		BEGIN
			IF @Posted='Y'
				IF LEFT(@TableName,10) = 'SaleLedger'
				BEGIN
					SET @List2 = @List
					SET @List2 = REPLACE(@List2, 'SRBufferInvCode', 'NULL') 
					SET @List2 = REPLACE(@List2, 'SaleOrderCode', 'NULL')
					SET @QRY = N'INSERT INTO ' + @RemoteRef + @TableName + ' (' + @List + ' )  ' + @SQL + @List2 + @Frm + @TableName + ' WHERE Posted = ''Y'' AND Synced = ''N''' 
				END
				ELSE
				BEGIN
					SET @QRY = N'INSERT INTO ' + @RemoteRef + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @Frm + @TableName + ' WHERE Posted = ''Y'' AND Synced = ''N''' 
				END
			ELSE
				SET @QRY = N'INSERT INTO ' + @RemoteRef + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @Frm + @TableName + ' WHERE Synced = ''N''' 
		END
		ELSE
		BEGIN
			IF @Posted='Y'
				SET @QRY = N'INSERT INTO ' + @RemoteRef + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @Frm + @TableName + ' WHERE ' + @ParentPK + ' IN (SELECT ' + @ParentPK + ' FROM ' + @ParentTable + ' WHERE Posted = ''Y'' AND Synced = ''N'')' 
			ELSE
				SET @QRY = N'INSERT INTO ' + @RemoteRef + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @Frm + @TableName + ' WHERE ' + @ParentPK + ' IN (SELECT ' + @ParentPK + ' FROM ' + @ParentTable + ' WHERE Synced = ''N'')' 
		END
		
		IF LEN(LTRIM(RTRIM(@Qry))) > 0
		BEGIN
			print @Qry
			EXECUTE (@Qry)
			SET @err = @@ERROR
			IF @@ERROR <> 0 OR @err <> 0
			BEGIN
				RAISERROR('Data Insertion: Error Transfering %s Data', 16, 1, @TableName)
				CLOSE C1
				DEALLOCATE C1
				RETURN -1
			END
			IF @UpdateParent = 'Y'
			BEGIN
				IF @Posted='Y'
					SET @Qry = 'UPDATE ' + @ParentTable + ' SET Synced = ''Y'', SyncedOn=GETDATE(), SyncedBy=1 WHERE Posted = ''Y'' AND Synced = ''N'''
				ELSE
					SET @Qry = 'UPDATE ' + @ParentTable + ' SET Synced = ''Y'', SyncedOn=GETDATE(), SyncedBy=1 WHERE Synced = ''N'''

				print @Qry
				EXECUTE (@Qry)
				SET @err = @@ERROR
				IF @@ERROR <> 0 OR @err <> 0
				BEGIN
					RAISERROR('Data Updation: Error Updating Sync. Status for %s Data', 16, 1, @ParentTable)
					CLOSE C1
					DEALLOCATE C1
					RETURN -1
				END
			END
		END
	END
	FETCH NEXT FROM C1
	INTO @RowID, @TableName, @Synchronize, @ParentTable, @ParentPK, @UpdateParent, @Posted
END
CLOSE C1
DEALLOCATE C1

SET @QRY = N'DELETE ' + @RemoteRef + 'GodownDetail'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Truncation Error: Error Transfering %s Data', 16, 1, 'GodownDetail')
	RETURN -1
END 

SET @QRY = N'INSERT INTO ' + @RemoteRef + 'GodownDetail SELECT * FROM GodownDetail'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Insertion: Error Transfering %s Data', 16, 1, 'GodownDetail')
	RETURN -1
END 

INSERT INTO DataImportLog (LogDate, ImportedBy, ImportType, Remarks)
VALUES (GetDate(), 1, 'Trans. Synced', 'Data Synced')

RETURN 0
