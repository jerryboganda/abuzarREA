-- Reconstructed from the SQL Server 2000-format V2 database file (catalog pages), schema only

-- GetAssociatedRecipientForSMS
CREATE VIEW DBO.GetAssociatedRecipientForSMS
AS
SELECT DISTINCT AR.SMSTemplateCode,ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(100)))), CC.Mobile
FROM SMS_AssociatedRecipient AR, ContactGroup CG, ContactGroupDetail CGD, ContactCard CC
WHERE AR.ContactGroupCode=CG.ContactGroupCode AND CG.ContactGroupCode=CGD.ContactGroupCode AND CGD.ContactCardCode=CC.ContactCardCode AND CC.UseForSMS='Y'
GO

-- sysconstraints
CREATE VIEW sysconstraints AS SELECT
	constid = convert(int, id),
	id = convert(int, parent_obj),
	colid = convert(smallint, info),
	spare1 = convert(tinyint, 0),
	status = convert(int,
			CASE xtype
				WHEN 'PK' THEN 1 WHEN 'UQ' THEN 2 WHEN 'F' THEN 3
				WHEN 'C' THEN 4 WHEN 'D' THEN 5 ELSE 0 END
			+ CASE WHEN info != 0			-- CNST_COLUMN / CNST_TABLE
					THEN (16) ELSE (32) END
			+ CASE WHEN (status & 16)!=0	-- CNST_CLINDEX
					THEN (512) ELSE 0 END
			+ CASE WHEN (status & 32)!=0	-- CNST_NCLINDEX
					THEN (1024) ELSE 0 END
			+ (2048)						-- CNST_NOTDEFERRABLE
			+ CASE WHEN (status & 256)!=0	-- CNST_DISABLE
					THEN (16384) ELSE 0 END
			+ CASE WHEN (status & 512)!=0	-- CNST_ENABLE
					THEN (32767) ELSE 0 END
			+ CASE WHEN (status & 4)!=0		-- CNST_NONAME
					THEN (131072) ELSE 0 END
			+ CASE WHEN (status & 1)!=0		-- CNST_NEW
					THEN (1048576) ELSE 0 END
			+ CASE WHEN (status & 1024)!=0	-- CNST_REPL
					THEN (2097152) ELSE 0 END),
	actions = convert(int,  4096),
	error = convert(int, 0)
FROM sysobjects WHERE xtype in ('C', 'F', 'PK', 'UQ', 'D')
					AND (status & 64) = 0
GO

-- syssegments
CREATE VIEW syssegments (segment, name, status) AS
	SELECT  0, 'system'     , 0  UNION
	SELECT	1, 'default'    , 1  UNION
	SELECT	2, 'logsegment' , 0
GO

-- V_Temp

/****** Object:  View dbo.V_Temp    Script Date: 4/23/02 4:29:57 PM ******/
CREATE VIEW V_Temp AS 
Select * from rights
GO

-- View_CRS_ItemStockPosition
CREATE VIEW DBO.View_CRS_ItemStockPosition
AS
SELECT 
	BranchName=CL.Name, ICode=I.ICode, 
	AliasName=I.CustomICode,
	ItemName=I.Name, 
	BranchStock=SUM(GD.CurrQty), 
	LastFetchedOn=MAX(GD.LastFetchedOn), 
	Age=ROUND(CAST(SUM(DATEDIFF(n, GD.LastFetchedOn, GETDATE())) / 60 AS INT),2) + Round(SUM(DATEDIFF(n, GD.LastFetchedOn, GETDATE())) % 60 / 60.00, 2)
FROM 
	DBO.CRS_GodownDetail GD, 
	DBO.CRS_ClientInstance CI, 
	DBO.CRS_ClientList CL,
	DBO.Item I
WHERE I.ICode = GD.ICode AND 
	GD.ClientInstanceID = CI.ClientInstanceID AND 
	CI.ClientID = CL.ClientID
GROUP BY I.ICode, I.CustomICode, I.Name, CL.Name
GO

-- View_DB_DropBox
CREATE VIEW DBO.View_DB_DropBox
AS
SELECT 
	E.SiteCode,
	E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'S',
	DocumentCode = E.SaleInvCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = CASE WHEN E.SaleCatCode = 3 THEN 'Retail' ELSE 'Credit' END,
	Amount = E.InvTotal,
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='Purchase',
	Remarks = E.Remarks,
	RefNo = E.CustRefNo, 
	RefNo2 = E.CustRefNo2, 
	RefNo3 = E.CustRefNo3, 
	RefNo4 = E.CustRefNo4, 
	RefNo5 = E.CustRefNo5
FROM 
	DB_SaleLedger E, Accounts A
WHERE 
	E.Custcode = A.Acccode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'SR',
	DocumentCode = E.SRInvCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = CASE WHEN E.SRCatCode = 8 THEN 'Retail' ELSE 'Credit' END,
	Amount = E.InvTotal,
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='P/Return',
	Remarks = E.Remarks,
	RefNo = E.CustRefNo, 
	RefNo2 = E.CustRefNo2, 
	RefNo3 = E.CustRefNo3, 
	RefNo4 = E.CustRefNo4, 
	RefNo5 = LTRIM(RTRIM(STR(E.SaleInvCode, 100)))
FROM 
	DB_SRLedger E, Accounts A
WHERE 
	E.Custcode = A.Acccode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'P',
	DocumentCode = E.PurInvCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = CASE WHEN E.PurCatCode < 3 THEN 'Pack' WHEN E.PurCatCode = 3 THEN 'Opening' ELSE 'Loose' END,
	Amount = E.InvTotal,
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='Sales',
	Remarks = E.Remarks,
	RefNo = E.SuppInvCode, 
	RefNo2 = E.GRN,
	RefNo3 = E.Vehicle, 
	RefNo4 = E.ShipTo, 
	RefNo5 = E.LCNo
FROM 
	DB_PurLedger E, Accounts A
WHERE 
	E.Suppcode = A.Acccode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'PR',
	DocumentCode = E.PRInvCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = 'Open',
	Amount = E.InvTotal,
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='S/Return',
	Remarks = E.Remarks,
	RefNo = E.Terms1, 
	RefNo2 = E.Terms2,
	RefNo3 = E.Terms3, 
	RefNo4 = E.Terms4, 
	RefNo5 = E.Terms5
FROM 
	DB_PRLedger E, Accounts A
WHERE 
	E.SuppCode = A.Acccode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'IS',
	DocumentCode = E.IssueInvCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = 'Issue',
	Amount = Round((SELECT SUM(D.Qty * D.Price) FROM DB_IssueDetail D WHERE D.SiteCode = E.SiteCode AND D.IssueInvCode=E.IssueInvCode),2),
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	Remarks = E.Remarks,
	RespondWith='Receipt',
	RefNo = E.ReferenceNo, 
	RefNo2 = E.RefNo2,
	RefNo3 = E.RefNo3, 
	RefNo4 = E.RefNo4, 
	RefNo5 = E.RefNo5
FROM 
	DB_IssueHeader E, Accounts A
WHERE 
	E.AccCode = A.Acccode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'PO',
	DocumentCode = E.POCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = PC.Name,
	Amount = Round((SELECT SUM(D.Qty * D.Rate) FROM DB_PurOrderDetail D WHERE D.SiteCode = E.SiteCode AND D.POCode=E.POCode), 2),
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='Quotation',
	Remarks = E.Remarks,
	RefNo = E.SupplierReference, 
	RefNo2 = E.DeliveryLocation,
	RefNo3 = E.Remarks, 
	RefNo4 = E.Remarks3, 
	RefNo5 = E.DemandDraftNo
FROM 
	DB_PurOrderHeader E, Accounts A, PurOrderCategory PC
WHERE 
	E.SuppCode = A.Acccode AND E.PurOrderCatCode=PC.PurOrderCatCode
UNION ALL
SELECT 
	SiteCode=E.SiteCode,
	TargetSiteCode=E.TargetSiteCode,
	SourceSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.SiteCode), 
	TargetSite=(SELECT S.Name FROM Site S WHERE S.SiteCode=E.TargetSiteCode),
	DocumentType = 'EI',
	DocumentCode = E.IntimationCode,
	AliasName = A.AliasName,
	Account = A.Name,
	Category = PC.Name,
	Amount = Round((SELECT SUM(D.Qty * D.Price) FROM DB_ExpiryIntimationDetail D WHERE D.SiteCode = E.SiteCode AND D.IntimationCode=E.IntimationCode), 2),
	Date=E.Date,
	PushedOn = E.PushedOn,
	Pulled = E.Pulled,
	PulledOn = E.PulledOn,
	PulledBy = (SELECT U.UserName FROM Users U WHERE U.UserCode=E.PulledBy), 
	RespondWith='Intimation',
	Remarks = E.Remarks1,
	RefNo = E.RefNo, 
	RefNo2 = E.Remarks2,
	RefNo3 = '', 
	RefNo4 = '', 
	RefNo5 = ''
FROM 
	DB_ExpiryIntimation E, Accounts A, IntimationType PC
WHERE 
	E.AccCode = A.Acccode AND E.IntimationTypeCode=PC.IntimationTypeCode
GO

-- View_ItemNotes
CREATE VIEW DBO.View_ItemNotes
AS
SELECT ICode, Notes = CAST(CAST(NOTES AS VarBinary(8000)) AS NVARCHAR(4000))
FROM ItemNotes
GO

-- View_PrintPostDatedCheques
CREATE VIEW DBO.View_PrintPostDatedCheques AS
SELECT 
	Code=N.NoteCode,
	VoucherCode = N.VoucherCode,
	IssueDate=N.IssueDate,
	Dt = CONVERT(VARCHAR(10), N.DueDate, 103),
	DueDate=N.DueDate,
	Amount = N.Amount,
	AccountName = (SELECT A.Name FROM Accounts A WHERE N.AccCode=A.AccCode),
	TransferredTo = (SELECT A.Name FROM Accounts A WHERE N.BankAccCode=A.AccCode),
	PayeeName = (SELECT S.BankAcc FROM Supplier S WHERE N.AccCode = S.SuppCode),
	BankName = N.BankName,
	ReferenceNo = N.DocumentNumber,
	Remarks = N.Remarks,
	NoteCategory = NC.Name,
	Posted = N.Posted,
	PostedBy = (SELECT U.UserName FROM Users U WHERE U.UserCode = N.PostedBy),
	PostDate = N.PostDate,
	UserName = (SELECT U.UserName FROM Users U WHERE U.UserCode = N.SalesManCode),
	Finalized = N.Finalized,
	FinalizedDate = N.FinalizedDate,
	FinalizedBy = (SELECT U.UserName FROM Users U WHERE U.UserCode = N.FinalizedBy)
FROM 
	Notes N,
	NotesCategory NC
WHERE
	N.NoteCatCode = NC.NoteCatCode
GO

-- VIEW_SMS_CustomerDebitIntimation
CREATE VIEW DBO.VIEW_SMS_CustomerDebitIntimation AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	GLVochCode = LTRIM(RTRIM(CAST(H.GLVochCode AS VARCHAR(10)))), 
	VoucherCode = LTRIM(RTRIM(CAST(H.VoucherCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END, 12, 2))),
	PreviousBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance > 0 THEN D.Balance ELSE ABS(D.Balance) END, 12, 2))) + ' ' + CASE WHEN D.Balance > 0 THEN 'DR' WHEN D.Balance < 0 THEN 'CR' ELSE '' END,
	NewBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN D.Balance + (D.Debit - D.Credit) ELSE ABS(D.Balance + (D.Debit - D.Credit)) END, 12, 2))) + ' ' + CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN 'DR' WHEN D.Balance + (D.Debit - D.Credit) < 0 THEN 'CR' ELSE '' END,
	PostDate = ISNULL(CONVERT(VARCHAR(10), H.PostDate, 103), ''),
	RefNo = ISNULL(LTRIM(RTRIM(D.ChkNo)), ''),
	Remarks = ISNULL(LTRIM(RTRIM(D.Remarks)), ''),
	AccountName = A.Name,
	Mobile = CC.Mobile
FROM
	GLHeader H,
	GLDetail D,
	Accounts A,
	Customer C,
	ContactCard CC
WHERE
	H.GLVochCode = D.GLVochCode AND
	D.AccCode = A.AccCode AND
	A.AccCode = C.CustCode AND
	D.Debit > 0 AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_CustomerInstallmentReceiptAcknowledgement
CREATE VIEW DBO.VIEW_SMS_CustomerInstallmentReceiptAcknowledgement AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	ReceiptCode = LTRIM(RTRIM(CAST(H.ReceiptCode AS VARCHAR(10)))), 
	SaleInvCode = LTRIM(RTRIM(CAST(H.SaleInvCode AS VARCHAR(10)))), 
	SaleInvoiceAmount = LTRIM(RTRIM(STR(H.NetAmt, 12, 2))),
	SaleInvoiceBalance = LTRIM(RTRIM(STR(H.OutstandingAmt, 12, 2))),
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	InstallmentAmount = LTRIM(RTRIM(STR(H.InstallmentAmount, 12, 2))),
	AmtReceived = LTRIM(RTRIM(STR(H.AmtReceived, 12, 2))),
	Discount = LTRIM(RTRIM(STR(H.Discount, 12, 2))),
	Fine = LTRIM(RTRIM(STR(H.Fine, 12, 2))),
	InstallmentBalance = LTRIM(RTRIM(STR(H.InstallmentBalance, 12, 2))),
	Remarks = ISNULL(LTRIM(RTRIM(H.Remarks)), ''),
	CustomerName = A.Name,
	RecoveryPerson = ISNULL((SELECT SM.Name FROM SalesMan SM WHERE SM.SalesmanCode = H.RecoveryPersonCode), ''),
	Mobile = CC.Mobile
FROM
	InstallmentReceipt H,
	SaleLedger S,
	Accounts A,
	Customer C,
	ContactCard CC
WHERE
	(H.AmtReceived > 0 OR H.Discount > 0 OR H.Fine > 0) AND
	H.SaleinvCode = S.SaleInvCode AND
	S.CustCode = C.CustCode AND
	A.AccCode = C.CustCode AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_CustomerLicenseInfo
CREATE VIEW DBO.VIEW_SMS_CustomerLicenseInfo AS
SELECT 
	ContactCardCode='1', 
	Code=LTRIM(RTRIM(CAST(CL.LicenseRowID AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), CL.Date, 103),
	AccCode = LTRIM(RTRIM(CAST(A.AccCode AS VARCHAR(10)))), 
	AliasName = ISNULL(A.AliasName, ''),
	CustomerName = ISNULL(A.Name, ''),
	ContactPerson = ISNULL(C.CP, ''),
	LicenseKeyInput = ISNULL(LTRIM(RTRIM(CL.LicenseKeyInput)), ''),
	LicenseKey = SUBSTRING(CL.LicenseKeyValue,1,4) + '-' + SUBSTRING(CL.LicenseKeyValue,5,4) + '-' + SUBSTRING(CL.LicenseKeyValue,9,4) + '-' + SUBSTRING(CL.LicenseKeyValue,13,4) + '-' + SUBSTRING(CL.LicenseKeyValue,17,4),
	Remarks = ISNULL(LTRIM(RTRIM(CL.Remarks)), ''),
	Mobile = CL.SMSTO
FROM
	CustomerLicense CL,
	CustomerConfig CC,
	Customer C,
	Accounts A
WHERE
	CL.SendSMS = 'Y' AND
	LEN(CL.SMSTo) > 0 AND
	CL.LicenseID = CC.LicenseID AND
	CC.CustCode = C.CustCode AND
	C.CustCode = A.AccCode
GO

-- VIEW_SMS_CustomerReceiptAcknowledgement
CREATE  VIEW DBO.VIEW_SMS_CustomerReceiptAcknowledgement AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	GLVochCode = LTRIM(RTRIM(CAST(H.GLVochCode AS VARCHAR(10)))), 
	VoucherCode = LTRIM(RTRIM(CAST(H.VoucherCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END, 12, 2))),
	PreviousBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance > 0 THEN D.Balance ELSE ABS(D.Balance) END, 12, 2))) + ' ' + CASE WHEN D.Balance > 0 THEN 'DR' WHEN D.Balance < 0 THEN 'CR' ELSE '' END,
	NewBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN D.Balance + (D.Debit - D.Credit) ELSE ABS(D.Balance + (D.Debit - D.Credit)) END, 12, 2))) + ' ' + CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN 'DR' WHEN D.Balance + (D.Debit - D.Credit) < 0 THEN 'CR' ELSE '' END,
	PostDate = ISNULL(CONVERT(VARCHAR(10), H.PostDate, 103), ''),
	RefNo = ISNULL(LTRIM(RTRIM(D.ChkNo)), ''),
	Remarks = ISNULL(LTRIM(RTRIM(D.Remarks)), ''),
	AccountName = A.Name,
	Mobile = CC.Mobile
FROM
	GLHeader H,
	GLDetail D,
	Accounts A,
	Customer C,
	ContactCard CC
WHERE
	H.GLVochCode = D.GLVochCode AND
	D.AccCode = A.AccCode AND
	A.AccCode = C.CustCode AND
	D.Credit > 0 AND
	D.GLVochCode IN 
		(SELECT MAX(GD.GLVochCode) 
		FROM GLDetail GD 
		WHERE GD.GLVochCode = D.GLVochCode AND GD.Debit > 0 AND GD.AccCode IN (SELECT A.AccCode FROM Accounts A WHERE A.SubCode IN (SELECT Code FROM Global WHERE Name IN ('GT_CashSub', 'GT_BankSub')))) AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_CustomerSaleInvInfo
CREATE VIEW DBO.VIEW_SMS_CustomerSaleInvInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(1 AS VARCHAR(10)))), 
	SaleInvCode = LTRIM(RTRIM(CAST(H.SaleInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0), 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	Message = ISNULL((SELECT M.Description FROM Message M WHERE M.MessageCode=H.MessageCode),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	Remarks = ISNULL(H.Remarks, ''),
	CustRefNo = ISNULL(H.CustRefNo, ''),
	CustRefNo2 = ISNULL(H.CustRefNo2, ''),
	CustRefNo3 = ISNULL(H.CustRefNo3, ''),
	CustRefNo4 = ISNULL(H.CustRefNo4, ''),
	CustRefNo5 = ISNULL(H.CustRefNo5, ''),
	Balance = LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance), 0), 12, 2) + CASE WHEN ISNULL(H.Balance, 0) >=0 THEN '' ELSE ' Cr.' END )),
	NewBalance=LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0))), 0), 12, 2) + CASE WHEN ISNULL(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0)), 0) >= 0 THEN '' ELSE ' Cr.' END)),
	PatientRegNo = (SELECT P.RegNo FROM Patient P WHERE P.PatientCode = H.PatientCode),
	PatientName = (SELECT P.Name FROM Patient P WHERE P.PatientCode = H.PatientCode),
	Agency = (SELECT G.Name FROM GoodsCompany G WHERE G.GCCode = H.GCCode),
	GRN = H.GRN,
	Vehicle = H.Vehicle,
	ShipTo = H.ShipTo,
	PreviousReading = LTRIM(RTRIM(STR(H.PreviousReading, 10, 0))),
	CurrentReading = LTRIM(RTRIM(STR(H.CurrentReading, 10, 0))),
	KiloMeters = LTRIM(RTRIM(STR((ISNULL(H.CurrentReading, 0) - ISNULL(H.PreviousReading, 0)), 10, 0))),
	NextChange = LTRIM(RTRIM(STR(H.NextChange, 10, 0))),
	Mobile = C.Phone
FROM
	SaleLedger H,
	Customer C,
	Accounts A
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode AND
	LEN(C.Phone) > 0
GO

-- VIEW_SMS_DailyHeaderWiseNetSalesSummary
CREATE VIEW DBO.VIEW_SMS_DailyHeaderWiseNetSalesSummary AS
SELECT 
	ContactCardCode='-1', 
	Date=CONVERT(VARCHAR(100), T.Date, 103),
	Code = '1',
	Report = (SELECT Rep=DBO.fn_GetHeaderWiseSaleSummary(T.Date)),
	Mobile = ''
FROM
	(SELECT GetDate() AS Date) AS T
GO

-- VIEW_SMS_DailySalesAndReturnSummary
CREATE VIEW DBO.VIEW_SMS_DailySalesAndReturnSummary AS
SELECT 
	ContactCardCode='-1', 
	Date=CONVERT(VARCHAR(100), GETDATE(), 103),
	Code = '1',
	TotalSales = LTRIM(RTRIM(CAST(SUM(Sales) AS VARCHAR(100)))), 
	SaleInvoices = LTRIM(RTRIM(CAST(SUM(InvCount) AS VARCHAR(100)))), 
	SalesReturn = LTRIM(RTRIM(CAST(SUM(SR) AS VARCHAR(100)))), 
	SaleReturnInvoices = LTRIM(RTRIM(CAST(SUM(SRCount) AS VARCHAR(100)))), 
	NetSales = LTRIM(RTRIM(CAST(SUM(Sales - SR) AS VARCHAR(100)))), 
	CGS = LTRIM(RTRIM(STR(ROUND(SUM(Cost),2), 15,2))), 
	GrossProfit = LTRIM(RTRIM(STR(ROUND(SUM(Sales - SR - Cost), 2), 15, 2))), 
	GPRate = LTRIM(RTRIM(STR(ROUND(ROUND(SUM(Sales - SR - Cost), 2) / CASE WHEN SUM(Sales - SR) = 0 THEN 1 ELSE SUM(Sales - SR) END * 100, 2),15, 2))), 
	Mobile = ''
FROM
	(SELECT Sales=ISNULL(SUM(H.InvTotal),0), InvCount=COUNT(H.SaleInvCode), SR=0, SRCount=0, Cost=0
	FROM SaleLedger H
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), GETDATE(), 103)
	UNION
	SELECT Sales=0, InvCount=0, SR=ISNULL(SUM(H.InvTotal),0), SRCount=COUNT(H.SRInvCode), Cost=0
	FROM SRLedger H
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), GETDATE(), 103)
	UNION 
	SELECT Sales=0, InvCount=0, SR=0, SRCount=0, Cost= ROUND(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice), 2)
	FROM SaleLedger H, SaleDetail D
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), GETDATE(), 103) AND H.SaleInvCode = D.SaleInvCode
	UNION
	SELECT Sales=0, InvCount=0, SR=0, SRCount=0, Cost= - Round(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice),2)
	FROM SRLedger H, SRDetail D
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), GETDATE(), 103) AND H.SRInvCode = D.SRInvCode) T
GO

-- VIEW_SMS_ManufacturerMonthlyNetSaleToDate
CREATE VIEW DBO.VIEW_SMS_ManufacturerMonthlyNetSaleToDate AS
SELECT 
	ContactCardCode='-1', 
	Date=CONVERT(VARCHAR(100), T.Date, 103),
	Code = '1',
	Report = (SELECT Rep=DBO.fn_GetManfWiseNetSaleToDate(T.Date)),
	Mobile = ''
FROM
	(SELECT GetDate() AS Date) AS T
GO

-- VIEW_SMS_PatientAdmissionInfo
CREATE VIEW DBO.VIEW_SMS_PatientAdmissionInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	AdmissionCode = LTRIM(RTRIM(CAST(PA.AdmissionCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), PA.Date, 103),
	AdmissionTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), PA.Date, 108))),
	PatientRegNo = P.RegNo,
	PatientName = P.Name,
	Customer = ISNULL((SELECT A.Name FROM Accounts A WHERE A.AccCode=P.CustCode),''),
	Doctor = ISNULL((SELECT D.Name FROM Doctors D WHERE D.DoctCode=PA.DoctorCode),''),
	CashCharged = LTRIM(RTRIM(STR(PA.CashCharged, 12, 2))),
	Location = ISNULL((SELECT L.Name FROM PatientLocation L WHERE L.LocationCode=PA.LocationCode),''),
	Disease = ISNULL((SELECT D.Name FROM Disease D WHERE D.DiseaseCode=PA.DiseaseCode),''),
	Diagnosis = ISNULL(PA.Diagnosis, ''),
	Remarks = ISNULL(PA.Remarks, ''),
	Mobile = ISNULL(P.MobileNo1, '') + CASE WHEN ISNULL(P.MobileNo1, '') = '' THEN '' ELSE ',' END + ISNULL((SELECT D.Phone FROM Doctors D WHERE D.DoctCode=PA.DoctorCode), '')
FROM
	PatientAdmission PA,
	Patient P
WHERE
	PA.Discharged1 = 'N' AND PA.Discharged='N' AND PA.PatientCode = P.PatientCode
GO

-- VIEW_SMS_PatientDischargeInfo
CREATE   VIEW DBO.VIEW_SMS_PatientDischargeInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	AdmissionCode = LTRIM(RTRIM(CAST(PA.AdmissionCode AS VARCHAR(10)))), 
	AdmissionDate = CONVERT(VARCHAR(10), PA.Date, 103),
	AdmissionTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), PA.Date, 108))),
	DischargeDate = CONVERT(VARCHAR(10), PA.DischargedOn, 103),
	DischargeTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), PA.DischargedOn, 108))),
	PatientRegNo = P.RegNo,
	PatientName = P.Name,
	Customer = ISNULL((SELECT A.Name FROM Accounts A WHERE A.AccCode=P.CustCode),''),
	Doctor = ISNULL((SELECT D.Name FROM Doctors D WHERE D.DoctCode=PA.DoctorCode),''),
	CashCharged = LTRIM(RTRIM(STR(PA.CashCharged, 12, 2))),
	Location = ISNULL((SELECT L.Name FROM PatientLocation L WHERE L.LocationCode=PA.LocationCode),''),
	Disease = ISNULL((SELECT D.Name FROM Disease D WHERE D.DiseaseCode=PA.DiseaseCode),''),
	Diagnosis = ISNULL(PA.Diagnosis, ''),
	Remarks = ISNULL(PA.Remarks, ''),
	DischargeNotes = ISNULL(PA.DischargeNotes, ''),
	Mobile = ISNULL(P.MobileNo1, '') + CASE WHEN ISNULL(P.MobileNo1, '') = '' THEN '' ELSE ',' END + ISNULL((SELECT D.Phone FROM Doctors D WHERE D.DoctCode=PA.DoctorCode), '')
FROM
	PatientAdmission PA,
	Patient P
WHERE
	PA.Discharged1 = 'Y' AND PA.Discharged='Y' AND PA.PatientCode = P.PatientCode
GO

-- VIEW_SMS_PatientRegistrationInfo
CREATE VIEW DBO.VIEW_SMS_PatientRegistrationInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	PatientCode = LTRIM(RTRIM(CAST(P.PatientCode AS VARCHAR(10)))), 
	RegistrationDate = CONVERT(VARCHAR(10), P.Date, 103),
	RegistrationTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), P.Date, 108))),
	PatientRegNo = P.RegNo,
	PatientName = P.Name,
	Customer = ISNULL((SELECT A.Name FROM Accounts A WHERE A.AccCode=P.CustCode),''),
	Doctor = ISNULL((SELECT D.Name FROM Doctors D WHERE D.DoctCode=P.DoctCode),''),
	CashCharged = LTRIM(RTRIM(STR(P.CashCharged, 12, 2))),
	Location = ISNULL((SELECT L.Name FROM PatientLocation L WHERE L.LocationCode=P.LocationCode),''),
	Disease = ISNULL((SELECT D.Name FROM Disease D WHERE D.DiseaseCode=P.DiseaseCode),''),
	Diagnosis = ISNULL(P.Diagnosis, ''),
	Gender = ISNULL(P.Gender, ''),
	NIC = ISNULL(P.NationalIDCard, ''),
	Ward = ISNULL(P.Ward, ''),
	RefNo1 = ISNULL(P.RefNo1, ''),
	RefNo2 = ISNULL(P.RefNo2, ''),
	RefNo3 = ISNULL(P.RefNo3, ''),
	RefNo4 = ISNULL(P.RefNo4, ''),
	RefNo5 = ISNULL(P.RefNo5, ''),
	RefNo6 = ISNULL(P.RefNo6, ''),
	RefNo7 = ISNULL(P.RefNo7, ''),
	Mobile = ISNULL(P.MobileNo1, '') + CASE WHEN ISNULL(P.MobileNo1, '') = '' THEN '' ELSE ',' END + ISNULL((SELECT D.Phone FROM Doctors D WHERE D.DoctCode=P.DoctCode), '')
FROM
	Patient P
GO

-- VIEW_SMS_PatientSaleInvInfo
CREATE  VIEW DBO.VIEW_SMS_PatientSaleInvInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	SaleInvCode = LTRIM(RTRIM(CAST(H.SaleInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0), 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	Message = ISNULL((SELECT M.Description FROM Message M WHERE M.MessageCode=H.MessageCode),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	Remarks = ISNULL(H.Remarks, ''),
	CustRefNo = ISNULL(H.CustRefNo, ''),
	CustRefNo2 = ISNULL(H.CustRefNo2, ''),
	CustRefNo3 = ISNULL(H.CustRefNo3, ''),
	CustRefNo4 = ISNULL(H.CustRefNo4, ''),
	CustRefNo5 = ISNULL(H.CustRefNo5, ''),
	Balance = LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance), 0), 12, 2) + CASE WHEN ISNULL(H.Balance, 0) >=0 THEN '' ELSE ' Cr.' END )),
	NewBalance=LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0))), 0), 12, 2) + CASE WHEN ISNULL(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0)), 0) >= 0 THEN '' ELSE ' Cr.' END)),
	PatientRegNo = (SELECT P.RegNo FROM Patient P WHERE P.PatientCode = H.PatientCode),
	PatientName = (SELECT P.Name FROM Patient P WHERE P.PatientCode = H.PatientCode),
	Agency = (SELECT G.Name FROM GoodsCompany G WHERE G.GCCode = H.GCCode),
	GRN = H.GRN,
	Vehicle = H.Vehicle,
	ShipTo = H.ShipTo,
	PreviousReading = LTRIM(RTRIM(STR(H.PreviousReading, 10, 0))),
	CurrentReading = LTRIM(RTRIM(STR(H.CurrentReading, 10, 0))),
	KiloMeters = LTRIM(RTRIM(STR((ISNULL(H.CurrentReading, 0) - ISNULL(H.PreviousReading, 0)), 10, 0))),
	NextChange = LTRIM(RTRIM(STR(H.NextChange, 10, 0))),
	Mobile = (SELECT P.MobileNo1 FROM Patient P WHERE P.PatientCode = H.PatientCode)
FROM
	SaleLedger H,
	Customer C,
	Accounts A
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode
GO

-- VIEW_SMS_SaleInvInfo
CREATE  VIEW dbo.VIEW_SMS_SaleInvInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	SaleInvCode = LTRIM(RTRIM(CAST(H.SaleInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0), 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	Message = ISNULL((SELECT M.Description FROM Message M WHERE M.MessageCode=H.MessageCode),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	Remarks = ISNULL(H.Remarks, ''),
	CustRefNo = ISNULL(H.CustRefNo, ''),
	CustRefNo2 = ISNULL(H.CustRefNo2, ''),
	CustRefNo3 = ISNULL(H.CustRefNo3, ''),
	CustRefNo4 = ISNULL(H.CustRefNo4, ''),
	CustRefNo5 = ISNULL(H.CustRefNo5, ''),
	Balance = LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance), 0), 12, 2) + CASE WHEN ISNULL(H.Balance, 0) >=0 THEN '' ELSE ' Cr.' END )),
	NewBalance=LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0))), 0), 12, 2) + CASE WHEN ISNULL(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0)), 0) >= 0 THEN '' ELSE ' Cr.' END)),
	PatientRegNo = (SELECT P.RegNo FROM Patient P WHERE P.PatientCode = H.PatientCode),
	PatientName = (SELECT P.Name FROM Patient P WHERE P.PatientCode = H.PatientCode),
	Agency = (SELECT G.Name FROM GoodsCompany G WHERE G.GCCode = H.GCCode),
	GRN = H.GRN,
	Vehicle = H.Vehicle,
	ShipTo = H.ShipTo,
	PreviousReading = LTRIM(RTRIM(STR(H.PreviousReading, 10, 0))),
	CurrentReading = LTRIM(RTRIM(STR(H.CurrentReading, 10, 0))),
	KiloMeters = LTRIM(RTRIM(STR((ISNULL(H.CurrentReading, 0) - ISNULL(H.PreviousReading, 0)), 10, 0))),
	NextChange = LTRIM(RTRIM(STR(H.NextChange, 10, 0))),
	Mobile = CC.Mobile
FROM
	SaleLedger H,
	Customer C,
	Accounts A,
	ContactCard CC
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_SaleInvInfo2
CREATE  VIEW dbo.VIEW_SMS_SaleInvInfo2 AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	SaleInvCode = LTRIM(RTRIM(CAST(H.SaleInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0), 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	Message = ISNULL((SELECT M.Description FROM Message M WHERE M.MessageCode=H.MessageCode),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = LTRIM(RTRIM(ISNULL(CC.Title,'') + ' ' + CC.Name)),
	Remarks = ISNULL(H.Remarks, ''),
	CustRefNo = ISNULL(H.CustRefNo, ''),
	CustRefNo2 = ISNULL(H.CustRefNo2, ''),
	CustRefNo3 = ISNULL(H.CustRefNo3, ''),
	CustRefNo4 = ISNULL(H.CustRefNo4, ''),
	CustRefNo5 = ISNULL(H.CustRefNo5, ''),
	Balance = LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance), 0), 12, 2) + CASE WHEN ISNULL(H.Balance, 0) >=0 THEN '' ELSE ' Cr.' END )),
	NewBalance=LTRIM(RTRIM(STR(ISNULL(ABS(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0))), 0), 12, 2) + CASE WHEN ISNULL(H.Balance + H.InvTotal - (ISNULL(H.CashCharged,0) + ISNULL(H.Amt,0) + ISNULL((SELECT SUM(CW.Amount) FROM CashierWindow CW WHERE CW.SaleInvCode=H.SaleInvCode),0)), 0) >= 0 THEN '' ELSE ' Cr.' END)),
	PatientRegNo = ISNULL((SELECT P.RegNo FROM Patient P WHERE P.PatientCode = H.PatientCode),''),
	PatientName = ISNULL((SELECT P.Name FROM Patient P WHERE P.PatientCode = H.PatientCode),''),
	Agency = ISNULL((SELECT G.Name FROM GoodsCompany G WHERE G.GCCode = H.GCCode),''),
	GRN = ISNULL(H.GRN,''),
	Vehicle = ISNULL(H.Vehicle,''),
	ShipTo = ISNULL(H.ShipTo,''),
	PreviousReading = LTRIM(RTRIM(STR(H.PreviousReading, 10, 0))),
	CurrentReading = LTRIM(RTRIM(STR(H.CurrentReading, 10, 0))),
	KiloMeters = LTRIM(RTRIM(STR((ISNULL(H.CurrentReading, 0) - ISNULL(H.PreviousReading, 0)), 10, 0))),
	NextChange = LTRIM(RTRIM(STR(H.NextChange, 10, 0))),
	Mobile = CC.Mobile
FROM
	SaleLedger H,
	ContactCard CC
WHERE
	H.ContactCardCode IS NOT NULL AND
	H.ContactCardCode = CC.ContactCardCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_SaleOrderInfo
CREATE  VIEW DBO.VIEW_SMS_SaleOrderInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	SaleOrderCode = LTRIM(RTRIM(CAST(H.SaleOrderCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	DeliveryDeadLine = ISNULL(CONVERT(VARCHAR(10), H.DeliveryDeadLine, 103), ''),
	Message = ISNULL((SELECT M.Description FROM Message M WHERE M.MessageCode=H.MessageCode),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	Remarks = ISNULL(H.Remarks, ''),
	CustRefNo = ISNULL(H.CustRefNo, ''),
	CustRefNo2 = ISNULL(H.CustRefNo2, ''),
	CustRefNo3 = ISNULL(H.CustRefNo3, ''),
	CustRefNo4 = ISNULL(H.CustRefNo4, ''),
	Mobile = CC.Mobile
FROM
	SaleOrderHeader H,
	Customer C,
	Accounts A,
	ContactCard CC
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_ServiceInvInfo
CREATE VIEW DBO.VIEW_SMS_ServiceInvInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	ServiceInvCode = LTRIM(RTRIM(CAST(H.ServiceInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL((SELECT SUM(CW.Amount) FROM MasterCashWin CW WHERE CW.DocumentType = 'RS' AND CW.DocumentCode=H.ServiceInvCode),0), 12, 2))),
	OutStandingAmount = LTRIM(RTRIM(STR(H.OutStandingAmt, 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	Remarks = ISNULL(H.Remarks, ''),
	Ref1 = ISNULL(H.Ref1, ''),
	Ref2 = ISNULL(H.Ref2, ''),
	Mobile = CC.Mobile
FROM
	ServiceHeader H,
	Customer C,
	Accounts A,
	ContactCard CC
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_ServiceInvPatientInfo
CREATE  VIEW DBO.VIEW_SMS_ServiceInvPatientInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	ServiceInvCode = LTRIM(RTRIM(CAST(H.ServiceInvCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(H.InvTotal, 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(H.CashCharged,0) + ISNULL((SELECT SUM(CW.Amount) FROM MasterCashWin CW WHERE CW.DocumentType = 'RS' AND CW.DocumentCode=H.ServiceInvCode),0), 12, 2))),
	OutStandingAmount = LTRIM(RTRIM(STR(H.OutStandingAmt, 12, 2))),
	DueDate = ISNULL(CONVERT(VARCHAR(10), H.DueDate, 103),''),
	CustCode = LTRIM(RTRIM(STR(H.CustCode, 10))),
	CustomerName = A.Name,
	PatientRegNo=P.RegNo,
	Patient = P.Name,
	Remarks = ISNULL(H.Remarks, ''),
	Ref1 = ISNULL(H.Ref1, ''),
	Ref2 = ISNULL(H.Ref2, ''),
	Mobile = P.MobileNo1
FROM
	ServiceHeader H,
	Customer C,
	Accounts A,
	Patient P
WHERE
	H.CustCode = C.CustCode AND
	C.CustCode = A.AccCode AND
	H.PatientCode = P.PatientCode AND LEN(P.MobileNo1) >= 10
GO

-- VIEW_SMS_SupplierCreditIntimation
CREATE VIEW DBO.VIEW_SMS_SupplierCreditIntimation AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	GLVochCode = LTRIM(RTRIM(CAST(H.GLVochCode AS VARCHAR(10)))), 
	VoucherCode = LTRIM(RTRIM(CAST(H.VoucherCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END, 12, 2))),
	PreviousBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance > 0 THEN D.Balance ELSE ABS(D.Balance) END, 12, 2))) + ' ' + CASE WHEN D.Balance > 0 THEN 'DR' WHEN D.Balance < 0 THEN 'CR' ELSE '' END,
	NewBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN D.Balance + (D.Debit - D.Credit) ELSE ABS(D.Balance + (D.Debit - D.Credit)) END, 12, 2))) + ' ' + CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN 'DR' WHEN D.Balance + (D.Debit - D.Credit) < 0 THEN 'CR' ELSE '' END,
	PostDate = ISNULL(CONVERT(VARCHAR(10), H.PostDate, 103), ''),
	RefNo = ISNULL(LTRIM(RTRIM(D.ChkNo)), ''),
	Remarks = ISNULL(LTRIM(RTRIM(D.Remarks)), ''),
	AccountName = A.Name,
	Mobile = CC.Mobile
FROM
	GLHeader H,
	GLDetail D,
	Accounts A,
	Supplier S,
	ContactCard CC
WHERE
	H.GLVochCode = D.GLVochCode AND
	D.AccCode = A.AccCode AND
	A.AccCode = S.SuppCode AND
	D.Credit > 0 AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_SupplierPaymentInfo
CREATE VIEW DBO.VIEW_SMS_SupplierPaymentInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
	GLVochCode = LTRIM(RTRIM(CAST(H.GLVochCode AS VARCHAR(10)))), 
	VoucherCode = LTRIM(RTRIM(CAST(H.VoucherCode AS VARCHAR(10)))), 
	Date = CONVERT(VARCHAR(10), H.Date, 103),
	Amount = LTRIM(RTRIM(STR(CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END, 12, 2))),
	PreviousBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance > 0 THEN D.Balance ELSE ABS(D.Balance) END, 12, 2))) + ' ' + CASE WHEN D.Balance > 0 THEN 'DR' WHEN D.Balance < 0 THEN 'CR' ELSE '' END,
	NewBalance = LTRIM(RTRIM(STR(CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN D.Balance + (D.Debit - D.Credit) ELSE ABS(D.Balance + (D.Debit - D.Credit)) END, 12, 2))) + ' ' + CASE WHEN D.Balance + (D.Debit - D.Credit) > 0 THEN 'DR' WHEN D.Balance + (D.Debit - D.Credit) < 0 THEN 'CR' ELSE '' END,
	PostDate = ISNULL(CONVERT(VARCHAR(10), H.PostDate, 103), ''),
	RefNo = ISNULL(LTRIM(RTRIM(D.ChkNo)), ''),
	Remarks = ISNULL(LTRIM(RTRIM(D.Remarks)), ''),
	AccountName = A.Name,
	Mobile = CC.Mobile
FROM
	GLHeader H,
	GLDetail D,
	Accounts A,
	Supplier S,
	ContactCard CC
WHERE
	H.GLVochCode = D.GLVochCode AND
	D.AccCode = A.AccCode AND
	A.AccCode = S.SuppCode AND
	D.Debit > 0 AND
	D.GLVochCode IN 
		(SELECT MAX(GD.GLVochCode) 
		FROM GLDetail GD 
		WHERE GD.GLVochCode = D.GLVochCode AND GD.Credit > 0 AND GD.AccCode IN (SELECT A.AccCode FROM Accounts A WHERE A.SubCode IN (SELECT Code FROM Global WHERE Name IN ('GT_CashSub', 'GT_BankSub')))) AND
	A.AccCode = CC.AccCode AND
	CC.UseForSMS = 'Y'
GO

-- VIEW_SMS_TotalServicesInfo
CREATE VIEW DBO.VIEW_SMS_TotalServicesInfo AS
SELECT 
	ContactCardCode='-1', 
	Code=LTRIM(RTRIM(CAST(1 AS VARCHAR(10)))), 
	Date = ISNULL(CONVERT(VARCHAR(10), GETDATE(), 103),''),
	ServiceRevenue = LTRIM(RTRIM(STR(ISNULL(SUM(H.InvTotal), 0), 12, 2))),
	Collection=LTRIM(RTRIM(STR(ISNULL(SUM(H.CashCharged),0) + ISNULL((SELECT SUM(CW.Amount) FROM MasterCashWin CW WHERE CW.DocumentType = 'RS' AND CW.DocumentCode IN (SELECT S.ServiceInvCode FROM ServiceHeader S WHERE CONVERT(VARCHAR(10), S.DATE, 103) = CONVERT(VARCHAR(10), GETDATE(), 103) )),0), 12, 2))),
	OutStandingAmount = LTRIM(RTRIM(STR(ISNULL(SUM(H.OutStandingAmt),0), 12, 2))),
	Mobile = ''
FROM
	ServiceHeader H
WHERE
	CONVERT(VARCHAR(10), H.DATE, 103) = CONVERT(VARCHAR(10), GETDATE(), 103)
GO

-- VIEW_SMS_VisitAppointmentInfo
CREATE VIEW DBO.VIEW_SMS_VisitAppointmentInfo AS
SELECT 
	ContactCardCode=LTRIM(RTRIM(CAST(-1 AS VARCHAR(10)))), 
	AppointmentCode = LTRIM(RTRIM(CAST(V.AppointmentCode AS VARCHAR(10)))), 
	BookingDate = CONVERT(VARCHAR(10), V.Date, 103),
	BookingTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), V.Date, 108))),
	AppointmentDate = CONVERT(VARCHAR(10), V.DueDate, 103),
	AppointmentTime = LTRIM(RTRIM(CONVERT(VARCHAR(20), V.DueDate, 108))),
	PatientRegNo = P.RegNo,
	PatientName = P.Name,
	Customer = ISNULL((SELECT A.Name FROM Accounts A WHERE A.AccCode=P.CustCode),''),
	Doctor = ISNULL((SELECT D.Name FROM Doctors D WHERE D.DoctCode=V.DoctCode),''),
	TokenNo = LTRIM(RTRIM(STR(V.TokenNo, 12))),
	AppointmentMethod = ISNULL((SELECT M.Name FROM AppointmentMethod M WHERE M.AppointmentMethodCode=V.AppointmentMethodCode),''),
	AppointmentStatus = ISNULL((SELECT S.Name FROM AppointmentStatus S WHERE S.AppointmentStatusCode=V.AppointmentStatusCode),''),
	Remarks = ISNULL(V.Remarks, ''),
	ReferredBy = ISNULL(V.ReferredBy, ''),
	Comments = ISNULL(V.Comments, ''),
	Mobile = ISNULL(P.MobileNo1, '') + CASE WHEN ISNULL(P.MobileNo1, '') = '' THEN '' ELSE ',' END + ISNULL((SELECT D.Phone FROM Doctors D WHERE D.DoctCode=V.DoctCode), '')
FROM
	VisitAppointment V,
	Patient P
WHERE
	V.PatientCode = P.PatientCode
GO

-- VIEW_SMS_ZonalSaleAndStock_CatWise_ToDate
CREATE VIEW DBO.VIEW_SMS_ZonalSaleAndStock_CatWise_ToDate AS
SELECT T.* 
FROM 
	(SELECT 
		ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
		Date=CONVERT(VARCHAR(100), T.Date, 103),
		Code = '1',
		Report = (SELECT Rep=DBO.fn_Get_ZonalSaleAndStock_CatWise_ToDate(Z.ZoneCode, T.Date)),
		Mobile = CC.Mobile
	FROM
		(SELECT GetDate() AS Date) AS T,
		Zone Z,
		ZoneContactGroup ZCG,
		ContactGroup CG,
		ContactGroupDetail CGD,
		ContactCard CC
	WHERE
		Z.UseForSMS = 'Y' AND
		Z.ZoneCode = ZCG.ZoneCode AND
		ZCG.ContactGroupCode = CG.ContactGroupCode AND
		CG.ContactGroupCode = CGD.ContactGroupCode AND
		CGD.ContactCardCode = CC.ContactCardCode AND
		CC.UseForSMS = 'Y') T
WHERE Report IS NOT NULL AND Report <> ''
GO

-- VIEW_SMS_Zone_SaleAndStock_CatWise_ToDate
CREATE VIEW DBO.VIEW_SMS_Zone_SaleAndStock_CatWise_ToDate AS
SELECT T.* 
FROM 
	(SELECT 
		ContactCardCode=LTRIM(RTRIM(CAST(CC.ContactCardCode AS VARCHAR(10)))), 
		Date=CONVERT(VARCHAR(100), T.Date, 103),
		Code = '1',
		ZoneCode = LTRIM(RTRIM(STR(Z.ZoneCode, 5, 0))),
		Report = (SELECT Rep=DBO.fn_Get_ZonalSaleAndStock_CatWise_ToDate(Z.ZoneCode, T.Date)),
		Mobile = CC.Mobile
	FROM
		(SELECT GetDate() AS Date) AS T,
		Zone Z,
		ZoneContactGroup ZCG,
		ContactGroup CG,
		ContactGroupDetail CGD,
		ContactCard CC
	WHERE
		Z.UseForSMS = 'Y' AND
		Z.ZoneCode = ZCG.ZoneCode AND
		ZCG.ContactGroupCode = CG.ContactGroupCode AND
		CG.ContactGroupCode = CGD.ContactGroupCode AND
		CGD.ContactCardCode = CC.ContactCardCode AND
		CC.UseForSMS = 'Y') T
WHERE Report IS NOT NULL AND Report <> ''
GO

-- VIEW_WaseelaMini_Customer
CREATE VIEW DBO.VIEW_WaseelaMini_Customer
AS
SELECT 
	CustCode=C.CustCode, 
	AliasName=A.AliasName, 
	CustomerName=A.Name, 
	CustomerCategory = CC.Name,
	ContactPerson = C.CP,
	ContactPerson2 = C.CP2,
	Address1 = C.Address1,
	Address2 = C.Address2,
	City = C.City,
	Country = C.Country,
	CellNo = C.CellNo,
	Phone = C.Phone,
	Fax = C.Fax,
	Email = C.Email,
	CreditLimit=C.CrLimit,
	DaysLimit = C.DaysLimit,
	LicenceNo = C.LicenceNo,
	LicenceEpiry = C.LicenceExpiry,
	SalesTaxRegNo = C.SalesTaxRegNo,
	Region = (SELECT R.Name FROM Region R WHERE R.RegionCode=AR.RegionCode),
	Area = AR.Name,
	SubArea = SA.Name,
	Message = (SELECT M.Description FROM Message M WHERE M.MessageCode=C.MessageCode),
	SalesPerson = (SELECT SM.Name FROM Salesman SM WHERE SM.SalesmanCode=C.SalesmanCode),
	Occupation = C.Occupation,
	Designation = C.Designation,
	Education = C.EduQualf,
	Bank = C.BankName,
	BankAddress = C.BankAdd,
	Gender = C.Gender,
	CNIC = C.NIC,
	NTN = C.NTNNo,
	Charges = C.Charges,
	TaxCategory = TC.Name,
	TaxPerc = TC.TaxPerc,
	SalesTaxExemption = C.SalesTaxExemption
FROM Customer C, Accounts A, CustomerCategory CC, Area AR, SubArea SA, TaxCategory TC
WHERE
	C.CustCode = A.AccCode AND
	C.CustCatCode = CC.CustCatCode AND
	C.AreaCode = AR.AreaCode AND
	C.SubAreaCode = SA.SubAreaCode AND
	C.TaxCategoryCode = TC.TaxCategoryCode
GO

-- VIEW_WaseelaMini_Item
CREATE VIEW DBO.VIEW_WaseelaMini_Item
AS
SELECT 
	ICode=I.ICode, 
	CustomICode=I.CustomICode, 
	ItemName=I.Name, 
	LocalItemName=I.LocalItemName,
	PackingDesc=I.PackingDesc,
	ItemClass=L.Name, 
	ItemCategory=C.Name,
	ItemPacking = (SELECT P.Name FROM ItemPacking P WHERE I.PackCode=P.PackCode),
	GenericItem=GI.Name,
	Manufacturer=M.Name,
	SalesTaxSchedule=ST.Name,
	TaxPerc = ST.TaxPerc,
	PCTCode=P.PCTCode,
	SalePrice=I.SalePrice,
	SalePrice2=I.SalePrice2,
	SalePrice3=I.SalePrice3,
	SalePrice4=I.SalePrice4,
	SalePrice5=I.SalePrice5,
	PurPrice=I.PurPrice,
	RetailPrice=I.RetailPrice,
	AvgPrice=I.AvgPrice,
	SaleFlatDisc=I.FlatDisc,
	SaleDiscPerc=I.SaleDiscPerc,
	PurFlatDisc=I.PurFlatDisc,
	PurDiscPerc=I.PurDiscPerc,
	PackUnits=I.PackUnits,
	Active=I.Active,
	Prescribed=I.Prescribed,
	Refrigrated=I.Refrigrated,
	Printable=I.Printable,
	Location=I.Location1,
	Remarks=I.Remarks1,
	AssociatedGodown=G.Name,
	AntiNorcotics=I.AntiNorcotix,
	GSTPerc1=I.GSTPerc1,
	GSTPerc2=I.GSTPerc2,
	PackSalesTax=I.PackSalesTax,
	PackingCost=I.PackingCost,
	RecentPurPrice = I.RecentPurPrice,
	RecentPurPrice2 = I.RecentPurPrice2,
	RecentPurPrice3 = I.RecentPurPrice3,
	RecentPurPrice4 = I.RecentPurPrice4,
	RecentPurPrice5 = I.RecentPurPrice5,
	TransitStock = I.TransitStock,
	Taxable=I.Taxable,
	CommissionPerUnit=I.CommissionPerUnit,
	CommissionPerc = I.CommissionPerc,
	AllowSaleInDecimalQty=I.AllowSaleInDecimalQty,
	Length=I.Length,
	Width=I.Width,
	Area=I.AreaVolume,
	Thickness=I.Thickness,
	PrintItemBatch=I.PrintItemBatch
FROM Item I, ItemClass L, ItemCategory C, Manufacturer M, GenericItem GI, Godown G, SalesTaxSchedule ST, PCT P
WHERE
	I.ICCode = L.ICCode AND 
	I.ICatCode = C.ICatCode AND
	I.ManfCode = M.ManfCode AND
	I.GenericCode = GI.GenericCode AND
	I.GCode = G.GCode AND
	I.SalesTaxScheduleCode = ST.SalesTaxScheduleCode AND
	I.PCTCode=P.PCTCode
GO

-- VIEW_WaseelaMini_Stock
CREATE VIEW DBO.VIEW_WaseelaMini_Stock
AS
SELECT 
	ICode=I.ICode, 
	CustomICode=I.CustomICode, 
	ItemName=I.Name, 
	LocalItemName=I.LocalItemName,
	PackingDesc=I.PackingDesc,
	Godwon=G.Name,
	Batch = GD.Batch,
	ManfDate = GD.ManfDate,
	Expiry = GD.Expiry,
	Qty = GD.CurrQty,
	Priority = GD.Priority
FROM Item I, GodownDetail GD, Godown G
WHERE
	I.ICode = GD.ICode AND 
	GD.GCode = G.Gcode
GO

-- VIEW_WaseelaMini_StockSummary
CREATE VIEW DBO.VIEW_WaseelaMini_StockSummary
AS
SELECT 
	ICode=ICode, 
	Qty = ISNULL(SUM(CurrQty),0)
FROM GodownDetail
GROUP BY Icode
GO

-- VIEW_WaseelaMini_Supplier
CREATE VIEW DBO.VIEW_WaseelaMini_Supplier
AS
SELECT 
	SuppCode=S.SuppCode, 
	AliasName=A.AliasName, 
	SupplierName=A.Name, 
	SupplierCategory = SC.Name,
	ContactPerson = S.CP,
	Address1 = S.Address1,
	Address2 = S.Address2,
	City = S.City,
	Country = S.Country,
	CellNo = S.MobileNo,
	Phone = S.Phone,
	Phone2 = S.Phone2,
	Fax = S.Fax,
	Email = S.Email,
	Email2 = S.Email2,
	Email3 = S.Email3,
	Web = WebSiteAdd,
	DaysLimit = S.DaysLimit,
	NTN = S.NTNNo,
	SalesTaxRegNo = S.SalesTaxRegNo,
	CNIC = S.CNIC,
	Bank = S.BankAcc,
	WithHoldingTaxPerc = S.WHPerc
FROM Supplier S, Accounts A, SupplierCategory SC
WHERE
	S.SuppCode = A.AccCode AND
	S.SuppCatCode = SC.SuppCatCode
GO
