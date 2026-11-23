CREATE  PROCEDURE DBO.SP_DeletePostedTransactions
AS
DECLARE @err INT, @RowID INT, @Script VARCHAR(1000), @Stmt VARCHAR(100), @tablename VARCHAR(255)
DECLARE @maxlogid int, @KeepBal CHAR(1)

SET @KeepBal = DBO.Fn_GetPreference('keep_accbal_on_archive')
SET @KeepBal = ISNULL(@KeepBal,'Y')

IF @KeepBal='Y'
BEGIN
-- Fill up the a/c repository for later use
	EXECUTE @err = DBO.SP_VirtualGL 'A'
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RaisError('Problem in Executing Accounting Repository.', 16, 1)
		RETURN -1
	END
	
	SET @maxlogid = ISNULL((SELECT MAX(LogID) FROM AccountBalanceLog), 0) + 1
	IF @maxlogid <= 0
	BEGIN
		RaisError('Problem in fetching maximum log id.', 16, 1)
		RETURN -1
	END
	
	INSERT INTO AccountBalanceLog (LogID, Date, AccCode, Balance)
	SELECT 
		LogID = @maxlogid,
		Date = GETDATE(),
		A.AccCode, 
		Balance=Sum(ISNULL(V.Debit,0) - ISNULL(V.Credit, 0))
	FROM VirtualGL V, Accounts A
	WHERE V.AccCode = A.AccCode
	GROUP BY A.AccCode
	HAVING Sum(ISNULL(V.Debit,0) - ISNULL(V.Credit, 0)) <> 0
	
	SET @err = @@ERROR
	IF @@ERROR <> 0 OR @err <> 0
	BEGIN
		RaisError('Problem in Insert Account balance log.', 16, 1)
		RETURN -1
	END
END

CREATE TABLE #del_temp (ROWID INT, Stmt VARCHAR(100), TableName VARCHAR(255))

INSERT INTO #del_temp 
-- Purchase and Purchase Return Deletion
SELECT 40, 'TRUNCATE TABLE ', 'AvgPriceAdjDetail'
UNION ALL
SELECT 45, 'DELETE ', 'AvgPriceAdjHeader'
UNION ALL
SELECT 50, 'TRUNCATE TABLE ', 'PurExp'
UNION ALL
SELECT 60, 'DELETE ', 'PurDetail WHERE PurInvCode NOT IN (SELECT PurInvCode FROM PurLedger WHERE Posted=''N'')'
UNION ALL
SELECT 70, 'TRUNCATE TABLE ', 'ProformaPurDetail'
UNION ALL
SELECT 80, 'TRUNCATE TABLE ', 'AdvPurDetail'
UNION ALL
SELECT 85, 'TRUNCATE TABLE ', 'ImpPurExp'
UNION ALL
SELECT 90, 'TRUNCATE TABLE ', 'ImpPurDetail'
UNION ALL
SELECT 100, 'TRUNCATE TABLE ', 'PurRegisterDetail'
UNION ALL
SELECT 110, 'TRUNCATE TABLE ', 'PrDetail'
UNION ALL
SELECT 120, 'TRUNCATE TABLE ', 'PrAllocationDetail'
UNION ALL
SELECT 130, 'DELETE ', 'PrAllocationHeader'
UNION ALL
SELECT 140, 'DELETE ', 'PrLedger'
UNION ALL
SELECT 150, 'DELETE ', 'PurRegister'
UNION ALL
SELECT 160, 'DELETE ', 'ImpPurHeader'
UNION ALL
SELECT 170, 'DELETE ', 'AdvPurHeader'
UNION ALL
SELECT 175, 'DELETE ', 'PurPayment WHERE Posted=''Y'''
UNION ALL
SELECT 180, 'DELETE ', 'PurLedger WHERE Posted=''Y'''
-- Sale Sale Return and Due Deletion 
UNION ALL
SELECT 190, 'TRUNCATE TABLE ', 'SaleInvDetail'
UNION ALL
SELECT 200, 'TRUNCATE TABLE ', 'SaleDetail'
UNION ALL
SELECT 210, 'TRUNCATE TABLE ', 'SaleDetailLog'
UNION ALL
SELECT 220, 'TRUNCATE TABLE ', 'SRDetail'
UNION ALL
SELECT 230, 'TRUNCATE TABLE ', 'SRBufferDetail'
UNION ALL
SELECT 240, 'TRUNCATE TABLE ', 'SRAllocationDetail'
UNION ALL
SELECT 250, 'DELETE ', 'SRAllocationHeader'
UNION ALL
SELECT 260, 'TRUNCATE TABLE ', 'RefusedSaleDetail'
UNION ALL
SELECT 270, 'DELETE ', 'RefusedSaleHeader'
UNION ALL
SELECT 280, 'TRUNCATE TABLE ', 'CashierWindow'
UNION ALL
SELECT 290, 'TRUNCATE TABLE ', 'DueAdjDetail'
UNION ALL
SELECT 300, 'TRUNCATE TABLE ', 'DueDeleteDetail'
UNION ALL
SELECT 310, 'TRUNCATE TABLE ', 'DueSatisfyDetail'
UNION ALL
SELECT 320, 'DELETE ', 'DueSatisfyHeader'
UNION ALL
SELECT 330, 'DELETE ', 'DueAdjHeader'
UNION ALL
SELECT 340, 'DELETE ', 'SaleLedgerLog'
UNION ALL
SELECT 350, 'DELETE ', 'SRBufferLedger'
UNION ALL
SELECT 360, 'DELETE ', 'SRLedger'
UNION ALL
SELECT 362, 'DELETE ', 'SaleInvGroupDetail'
UNION ALL
SELECT 363, 'DELETE ', 'SaleInvGroup'
UNION ALL
SELECT 364, 'DELETE ', 'DispatchDetail'
UNION ALL
SELECT 365, 'DELETE ', 'DispatchHeader'
UNION ALL
SELECT 366, 'DELETE ', 'SaleSetsDetail'
UNION ALL
SELECT 367, 'DELETE ', 'SaleSetsOrigDetail'
UNION ALL
SELECT 368, 'DELETE ', 'SaleSetsHeader'
UNION ALL

SELECT 400, 'TRUNCATE TABLE ', 'ServicePrAllocationDetail'
UNION ALL
SELECT 401, 'DELETE ', 'ServicePrAllocationHeader'
UNION ALL
SELECT 402, 'TRUNCATE TABLE ', 'ServicePrDetail'
UNION ALL
SELECT 403, 'DELETE ', 'ServicePrHeader'
UNION ALL
SELECT 404, 'TRUNCATE TABLE ', 'ServicePurDetail'
UNION ALL
SELECT 405, 'DELETE ', 'ServicePurHeader'
UNION ALL
SELECT 406, 'TRUNCATE TABLE ', 'ServiceSrAllocationDetail'
UNION ALL
SELECT 407, 'DELETE ', 'ServiceSrAllocationHeader'
UNION ALL
SELECT 408, 'DELETE ', 'ServiceRDetail'
UNION ALL
SELECT 409, 'DELETE ', 'ServiceRHeader'
UNION ALL
SELECT 410, 'DELETE ', 'ServiceDetail'
UNION ALL
SELECT 411, 'DELETE ', 'ServiceHeader'
UNION ALL

SELECT 430, 'DELETE ', 'SaleLedger'
-- Stock Adjustment Deletion
UNION ALL
SELECT 440, 'TRUNCATE TABLE ', 'ItemConversionDetail'
UNION ALL
SELECT 441, 'DELETE ', 'ItemConversionHeader'
UNION ALL
SELECT 442, 'TRUNCATE TABLE ', 'AdjBufferDetail'
UNION ALL
SELECT 443, 'DELETE ', 'AdjBufferHeader'
UNION ALL
SELECT 444, 'TRUNCATE TABLE ', 'AdjDetail'
UNION ALL
SELECT 445, 'DELETE ', 'AdjHeader'
-- GodownTransfer
UNION ALL
SELECT 446, 'TRUNCATE TABLE ', 'TDetail'
UNION ALL
SELECT 450, 'DELETE ', 'Theader'
UNION ALL
SELECT 460, 'TRUNCATE TABLE ', 'TransferRequisitionDetail'
UNION ALL
SELECT 470, 'DELETE ', 'TransferRequisitionHeader'
-- Issue / Receipt Deletion
UNION ALL
SELECT 480, 'TRUNCATE TABLE ', 'ProdDetail'
UNION ALL
SELECT 490, 'TRUNCATE TABLE ', 'ProdBuffer'
UNION ALL
SELECT 500, 'DELETE ', 'ProdHeader'
UNION ALL
SELECT 510, 'TRUNCATE TABLE ', 'IssueDetail'
UNION ALL
SELECT 520, 'DELETE ', 'IssueHeader'
UNION ALL
SELECT 530, 'TRUNCATE TABLE ', 'IssueReqDetail'
UNION ALL
SELECT 540, 'DELETE ', 'IssueReqHeader'
UNION ALL
SELECT 550, 'TRUNCATE TABLE ', 'ReceiptDetail'
UNION ALL
SELECT 560, 'DELETE ', 'ReceiptHeader'
UNION ALL
-- A/c vouchers Deletion
SELECT 705, 'TRUNCATE TABLE ', 'TransactionDetail'
UNION ALL
SELECT 710, 'DELETE ', 'TransactionHeader'
UNION ALL
SELECT 720, 'TRUNCATE TABLE ', 'GLDetail'
UNION ALL
SELECT 730, 'DELETE ', 'GLHeader'
UNION ALL
SELECT 740, 'TRUNCATE TABLE ', 'NotesDetail'
UNION ALL
SELECT 750, 'DELETE ', 'Notes'

DECLARE C1 CURSOR FOR
SELECT RowID, Stmt, TableName
FROM #del_temp
ORDER BY ROWID

OPEN C1

FETCH NEXT FROM C1
INTO @RowID, @Stmt, @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TableName = 'SRBufferLedger'
	BEGIN
		UPDATE SaleLedger SET SRBufferInvCode = NULL WHERE SRBufferInvCode > 0
	END
	IF @TableName = 'SaleLedger'
	BEGIN
		UPDATE BillSummaryDetail SET SaleInvCode = NULL WHERE SaleInvCode > 0
		UPDATE BillSummaryDetail SET SaleInvCode = NULL WHERE SaleInvCode > 0
		UPDATE ServiceHeader SET SaleInvCode = NULL WHERE SaleInvCode > 0
	END

	SET @Script = @Stmt + @TableName
	EXECUTE (@Script)
	SET @err = @@Error
	IF @err <> 0
	BEGIN
		RAISERROR('Problem in Data Deletion. Problem in deleting %s', 16, 1, @TableName)
		CLOSE C1
		DEALLOCATE C1
		RETURN -1
	END
	FETCH NEXT FROM C1
	INTO @RowID, @Stmt, @TableName
END
CLOSE C1
DEALLOCATE C1

TRUNCATE TABLE VirtualGL

IF @KeepBal='Y'
BEGIN
	INSERT INTO VirtualGL (DocumentCode, DocumentType, AccCode, CatCode, AlternateAccCode, Debit, Credit, Date,
		CheckNo, Remarks, UserCode, PatientCode, VoucherCode, INVOICECODE, OUTSTANDINGAMT, BALANCE, 
		InvoiceType, VRow, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode)
	SELECT DocumentCode=1, DocumentType='TV', L.AccCode, CatCode=1, AlternateAccCode=NULL,
		Debit=SUM(CASE WHEN BALANCE > 0 THEN ABS(BALANCE) ELSE 0 END), 
		Credit=SUM(CASE WHEN BALANCE < 0 THEN ABS(BALANCE) ELSE 0 END), 
		L.Date,
		CheckNo=NULL, Remarks='Balance B/F:', UserCode=1, PatientCode=NULL, VoucherCode=1, 
		INVOICECODE=NULL, OUTSTANDINGAMT=0, BALANCE=0, 
		InvoiceType=NULL, VRow=0, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, 
		GuestCode=NULL, StudentCode=NULL
	FROM AccountBalanceLog L, Accounts A
	WHERE L.LogID = @maxlogid AND L.AccCode = A.AccCode
	GROUP BY L.AccCode, A.Name, L.Date
	ORDER BY A.Name
END
RETURN 0
