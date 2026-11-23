CREATE PROCEDURE DBO.SP_AquirePostedTransactions @srv VARCHAR(100), @DB VARCHAR(255), @Owner VARCHAR(100)
AS
DECLARE @err INT, @RowID INT, @tablename VARCHAR(255), @ArchAccData CHAR(1), @Synchronize CHAR(1), @Del_Qry NVARCHAR(4000)
DECLARE @Qry NVARCHAR(4000), @SQL NVARCHAR(4000), @LIST NVARCHAR(4000), @FROM VARCHAR(255)

SET @ArchAccData = DBO.Fn_GetPreference('archiveaccountingdata')
SET @ArchAccData = ISNULL(@ArchAccData,'N')
SET @FROM = N' FROM ' + LTRIM(RTRIM(@srv)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.'
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
CREATE TABLE #ins_temp (ROWID INT, TableName VARCHAR(255), Synchronize CHAR(1))

INSERT INTO #ins_temp 
-- Truncate General Tables
SELECT 10, 'ActivityMonitor', 'Y'
UNION ALL
SELECT 15, 'CashierJob', 'Y'
UNION ALL
SELECT 20, 'CashierActivity', 'Y'
UNION ALL
SELECT 40, 'StockLedger', 'Y'
-- Purchase and Purchase Return Deletion
UNION ALL
SELECT 41, 'PurQuotationHeader', 'Y'
UNION ALL
SELECT 42, 'PurQuotationDetail', 'Y'
UNION ALL
SELECT 43, 'SaleOrderHeader', 'Y'
UNION ALL
SELECT 44, 'SaleOrderDetail', 'Y'
UNION ALL
SELECT 45, 'QuotationHeader', 'Y'
UNION ALL
SELECT 46, 'QuotationDetail', 'Y'
UNION ALL
SELECT 47, 'PurOrderHeader', 'Y'
UNION ALL
SELECT 48, 'PurOrderDetail', 'Y'
UNION ALL
SELECT 50, 'PurRegister', 'Y'
UNION ALL
SELECT 60, 'ImpPurHeader', 'Y'
UNION ALL
SELECT 70, 'PurLedger', 'Y'
UNION ALL
SELECT 80, 'AdvPurHeader', 'Y'
UNION ALL
SELECT 90, 'PurExp', 'Y'
UNION ALL
SELECT 100, 'PurDetail', 'Y'
UNION ALL
SELECT 105, 'PurPayment', 'Y'
UNION ALL
SELECT 110, 'ProformaPurDetail', 'Y'
UNION ALL
SELECT 120, 'AdvPurDetail', 'Y'
UNION ALL
SELECT 130, 'ImpPurDetail', 'Y'
UNION ALL
SELECT 140, 'PurRegisterDetail', 'Y'
UNION ALL
SELECT 150, 'PRLedger', 'Y'
UNION ALL
SELECT 160, 'PRAllocationHeader', 'Y'
UNION ALL
SELECT 170, 'PRDetail', 'Y'
UNION ALL
SELECT 180, 'PRAllocationDetail', 'Y'

-- Sale Sale Return and Due Deletion 
UNION ALL
SELECT 190, 'DueAdjHeader', 'Y'
UNION ALL
SELECT 200, 'SaleLedger', 'Y'
UNION ALL
SELECT 201, 'SaleInvGroup', 'Y'
UNION ALL
SELECT 202, 'SaleInvGroupDetail', 'Y'
UNION ALL
SELECT 203, 'DispatchHeader', 'Y'
UNION ALL
SELECT 204, 'DispatchDetail', 'Y'
UNION ALL
SELECT 205, 'SaleSetsHeader', 'Y'
UNION ALL
SELECT 206, 'SaleSetsOrigDetail', 'Y'
UNION ALL
SELECT 207, 'SaleSetsDetail', 'Y'
UNION ALL
SELECT 210, 'DueSatisfyHeader', 'Y'
--UNION ALL
--SELECT 220, 'SaleLedgerLog'
UNION ALL
SELECT 230, 'SRBufferLedger', 'Y'
UNION ALL
SELECT 240, 'SRLedger', 'Y'
UNION ALL
SELECT 250, 'SaleInvDetail', 'Y'
UNION ALL
SELECT 260, 'SaleDetail', 'Y'
--UNION ALL
--SELECT 270, 'SaleDetailLog'
UNION ALL
SELECT 280, 'SRDetail', 'Y'
UNION ALL
SELECT 290, 'SRBufferDetail', 'Y'
UNION ALL
SELECT 300, 'SRAllocationHeader', 'Y'
UNION ALL
SELECT 310, 'SRAllocationDetail', 'Y'
UNION ALL
SELECT 320, 'RefusedSaleHeader', 'Y'
UNION ALL
SELECT 330, 'RefusedSaleDetail', 'Y'
UNION ALL
SELECT 340, 'CashierWindow', 'Y'
UNION ALL
SELECT 350, 'DueAdjDetail', 'Y'
UNION ALL
SELECT 360, 'DueDeleteDetail', 'Y'
UNION ALL
SELECT 370, 'DueSatisfyDetail', 'Y'
-- Stock Adjustment Deletion
UNION ALL
SELECT 380, 'AdjHeader', 'Y'
UNION ALL
SELECT 390, 'AdjBufferHeader', 'Y'
UNION ALL
SELECT 400, 'AdjDetail', 'Y'
UNION ALL
SELECT 410, 'ItemConversionHeader', 'Y'
UNION ALL
SELECT 420, 'ItemConversionDetail', 'Y'
UNION ALL
SELECT 430, 'AdjBufferDetail', 'Y'
-- GodownTransfer
UNION ALL
SELECT 440, 'TransferRequisitionHeader', 'Y'
UNION ALL
SELECT 450, 'TransferRequisitionDetail', 'Y'
UNION ALL
SELECT 460, 'Theader', 'Y'
UNION ALL
SELECT 470, 'TDetail', 'Y'
-- Issue / Receipt
UNION ALL
SELECT 480, 'IssueReqHeader', 'Y'
UNION ALL
SELECT 490, 'IssueReqDetail', 'Y'
UNION ALL
SELECT 500, 'IssueHeader', 'Y'
UNION ALL
SELECT 510, 'ReceiptHeader', 'Y'
UNION ALL
SELECT 520, 'IssueDetail', 'Y'
UNION ALL
SELECT 530, 'ReceiptDetail', 'Y'
UNION ALL
SELECT 540, 'ProdHeader', 'Y'
UNION ALL
SELECT 550, 'ProdDetail', 'Y'
UNION ALL
SELECT 560, 'ProdBuffer', 'Y'
--Service Tables
UNION ALL
SELECT 700, 'ServiceHeader', 'Y'
UNION ALL
SELECT 710, 'ServiceDetail', 'Y'
UNION ALL
SELECT 720, 'ServiceRHeader', 'Y'
UNION ALL
SELECT 730, 'ServiceRDetail', 'Y'
UNION ALL
SELECT 740, 'ServiceSrAllocationHeader', 'Y'
UNION ALL
SELECT 750, 'ServiceSrAllocationDetail', 'Y'
UNION ALL
SELECT 760, 'ServicePurHeader', 'Y'
UNION ALL
SELECT 770, 'ServicePurDetail', 'Y'
UNION ALL
SELECT 780, 'ServicePrHeader', 'Y'
UNION ALL
SELECT 790, 'ServicePrDetail', 'Y'
UNION ALL
SELECT 800, 'ServicePrAllocationHeader', 'Y'
UNION ALL
SELECT 810, 'ServicePrAllocationDetail', 'Y'
--Accounting Tables
UNION ALL
SELECT 1010, 'GLHeader', @ArchAccData
UNION ALL
SELECT 1020, 'GLDetail', @ArchAccData
UNION ALL
SELECT 1030, 'Notes', @ArchAccData
UNION ALL
SELECT 1040, 'NotesDetail', @ArchAccData
UNION ALL
SELECT 1050, 'TransactionHeader', @ArchAccData
UNION ALL
SELECT 1060, 'TransactionDetail', @ArchAccData
UNION ALL
SELECT 1065, 'AvgPriceAdjHeader', @ArchAccData
UNION ALL
SELECT 1070, 'AvgPriceAdjDetail', @ArchAccData

DECLARE C1 CURSOR FOR
SELECT RowID, TableName, Synchronize
FROM #ins_temp
ORDER BY ROWID

OPEN C1

FETCH NEXT FROM C1
INTO @RowID, @TableName, @Synchronize
WHILE @@FETCH_STATUS = 0
BEGIN
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

	IF @TableName = 'PurQuotationHeader' OR @TableName = 'SaleOrderHeader' OR @TableName = 'QuotationHeader' OR @TableName = 'PurOrderHeader' OR @TableName = 'StockLedger' OR @TableName = 'ActivityMonitor' OR @TableName = 'CashierJob' OR @TableName = 'SaleLedger' OR @TableName = 'SaleLedgerLog'
	BEGIN
		IF @TableName = 'PurQuotationHeader'
		BEGIN
			TRUNCATE TABLE PurQuotationDetail

			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE PurQuotationCode NOT IN (SELECT T.PurQuotationCode FROM DBO.PurQuotationHeader T)' 
		END
		IF @TableName = 'SaleOrderHeader'
		BEGIN
			TRUNCATE TABLE SaleOrderDetail
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE SaleOrderCode NOT IN (SELECT T.SaleOrderCode FROM DBO.SaleOrderHeader T)' 
		END
		IF @TableName = 'QuotationHeader'
		BEGIN
			TRUNCATE TABLE QuotationDetail
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE QuotationCode NOT IN (SELECT T.QuotationCode FROM DBO.QuotationHeader T)' 
		END
		IF @TableName = 'PurOrderHeader'
		BEGIN
			TRUNCATE TABLE PurOrderDetail
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE POCode NOT IN (SELECT T.POCode FROM DBO.PurOrderHeader T)' 
		END
		IF @TableName = 'StockLedger'
		BEGIN
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE UTN NOT IN (SELECT T.UTN FROM DBO.StockLedger T)' 
		END
		IF @TableName = 'ActivityMonitor'
		BEGIN
			TRUNCATE TABLE ActivityMonitor
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName
		END
		IF @TableName = 'CashierJob'
		BEGIN
			TRUNCATE TABLE CashierActivity
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE CashierJobCode NOT IN (SELECT T.CashierJobCode FROM DBO.CashierJob T)' 
		END
		IF @TableName = 'SaleLedger' OR @TableName = 'SaleLedgerLog'
		BEGIN
			SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + REPLACE(@List, 'SRBufferInvCode', 'SRBufferInvCode=NULL') + @FROM + @TableName + ' WHERE SaleInvCode NOT IN (SELECT T.SaleInvCode FROM DBO.SaleLedger T)' 
		END
	END
	ELSE
	BEGIN
		IF @Synchronize='Y'
		BEGIN
			IF @TableName = 'PurLedger'
			BEGIN
				SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE Posted=''Y'''
			END
			IF @TableName = 'PurDetail'
			BEGIN
				SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE PurInvCode NOT IN (SELECT PurInvCode ' + @FROM + 'PurLedger WHERE Posted=''N''' + ')'
			END
			IF @TableName = 'PurExp'
			BEGIN
				SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE PurInvCode NOT IN (SELECT PurInvCode ' + @FROM + 'PurLedger WHERE Posted=''N''' + ')'
			END
			IF @TableName <> 'PurLedger' AND @TableName <> 'PurDetail' AND @TableName <> 'PurExp'
			BEGIN
				SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName
			END
			IF @TableName = 'PurPayment'
			BEGIN
				SET @QRY = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName + ' WHERE Posted=''Y'''
			END
		END
	END
	EXECUTE (@Qry)
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RAISERROR('Data Insertion: Error Transfering %s Data', 16, 1, @TableName)
		CLOSE C1
		DEALLOCATE C1
		RETURN -1
	END 

	FETCH NEXT FROM C1
	INTO @RowID, @TableName, @Synchronize
END
CLOSE C1
DEALLOCATE C1
SET @TableName = 'VirtualGl'
SET @QRY = 'TRUNCATE TABLE DBO.VirtualGl'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Truncation: Error Truncating %s ', 16, 1, @TableName)
	RETURN -1
END 

SET @TableName = 'GodownDetail'
SET @QRY = 'TRUNCATE TABLE DBO.GodownDetail'
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Truncation: Error Truncating %s ', 16, 1, @TableName)
	RETURN -1
END 

SET @QRY = N'INSERT INTO DBO.GodownDetail SELECT * ' + @FROM + @TableName
EXECUTE (@Qry)
SET @err = @@ERROR
IF @@ERROR <> 0 OR @err <> 0
BEGIN
	RAISERROR('Data Insertion: Error Transfering %s Data', 16, 1, @TableName)
	RETURN -1
END 
INSERT INTO DataImportLog (LogDate, ImportedBy, ImportType, Remarks)
VALUES (GetDate(), 1, 'Trans. Acquired', 'Data Import')

RETURN 0
