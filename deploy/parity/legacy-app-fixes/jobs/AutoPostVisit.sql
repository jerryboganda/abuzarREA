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

  WHERE (name = N'AutoPostVisit')       

  IF (@JobID IS NOT NULL)    

  BEGIN  

  -- Check if the job is a multi-server job  

  IF (EXISTS (SELECT  * 

              FROM    msdb.dbo.sysjobservers 

              WHERE   (job_id = @JobID) AND (server_id <> 0))) 

  BEGIN 

    -- There is, so abort the script 

    RAISERROR (N'Unable to import job ''AutoPostVisit'' since there is already a multi-server job with this name.', 16, 1) 

    GOTO QuitWithRollback  

  END 

  ELSE 

    -- Delete the [local] job 

    EXECUTE msdb.dbo.sp_delete_job @job_name = N'AutoPostVisit' 

    SELECT @JobID = NULL

  END 



BEGIN 


  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'AutoPostVisit', @owner_login_name = N'sa', @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_even
CREATE TABLE DBO.TaxCategory (

TaxCategoryCode SMALLINT NOT NULL CONSTRAINT PK_TaxCategory PRIMARY KEY (TaxCategoryCode),

Name VARCHAR(100) NOT NULL CONALTER TABLE DBO.SaleLedger ADD

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_SaleLedger_AdvanceTax DEFAULT ('N'),

AdvanceTaxAmt NUMERIC(12,2) CONSTRAINT DF_SaleLedger_AdvanceTaxAmt DEFAULT (0)ALALINSERT INTO InterfaceSetting (ModuleID, SequenceId, ColName, ColCaption, Visibility, WinType,InterfaceGroup)

SELECT ModuleID=24, SequenceId=80, ColName='customer_taxcategorycode', ColCaption='Tax Category:', Visibility=1, WinType=3,InterfaceGroup=0ALTER TABLE DBO.SaleLedgerLog ADD AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_SaleLedgerLog_AdvanceTax DEFAULT ('N'), AdvanceTaxAmt NUMERIC(12,2) CONSTRAINT DF_SaleLedgerLog_AdvanceTaxAmt DEFAULT (0)ALTER TABLE DBO.SaleLedger ADD AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_SaleLedger_AdvanceTax DEFAULT ('N'), AdvanceTaxAmt NUMERIC(12,2) CONSTRAINT DF_SaleLedger_AdvanceTaxAmt DEFAULT (0)ALTER TABLE DBO.PurLedger ADD

TaxCategoryCode SMALLINT NOT NULL CONSTRAINT DF_PurLedger_TaxCategory_TaxCategoryCode DEFAULT (1) 

CONSTRAINT FK_PurLedger_TaxCategory_TaxCategoryCode FOREIGN KEY (TaxCategoryCode) REFERENCES DBO.TaxCategory (TaxCategoryCode),

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_PurLedger_AdvanceTax DEFAULT ('N'),

AdvanceTaxAmt NUMERIC(12,2) CONSTRAINT DF_PurLedger_AdvanceTaxAmt DEFAULT (0)INSERT INTO Global (Name, TableName, Code, Description)

SELECT Name='GT_AdvIncomeTaxPur', TableName='accounts', Code=35, Description='ADVANCE INCOME TAX ON PURCHASE'

UNION ALL

SELECT Name='GT_AdvIncomeTaxSale', TableName='accounts', Code=36, Description='ADVANCE INCOME TAX ON PURCHASE SALE'CREATE TABLE DBO.TaxCategory (

TaxCategoryCode SMALLINT NOT NULL CONSTRAINT PK_TaxCategory PRIMARY KEY (TaxCategoryCode),

Name VARCHAR(100) NOT NULL CONSTRAINT UK_TaxCategory_Name UNIQUE (Name),

TaxPerc NUMERIC(5,2) NOT NULL CONSTRAINT DF_TaxCategory_TaxPerc DEFAULT(0)

)
INSERT INTO RightsClone (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 5248, 'Basic Data , Tax Category ', 'Tax Category', 2, '6,56,', 'A', 1

INSERT INTO Rights (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 5248, 'Basic Data , Tax Category ', 'Tax Category', 2, '6,56,', 'A', 1

INSERT INTO GroupRights (GroupCode, RightCode, Status) SELECT 2, 5248, 1
cle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=ISNULL(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice), 0),

	S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END

FROM saleledger S, saledetail D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND

	S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges, 

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt



INSERT INTO VirtualGLTemp	/*accounting for sales having impactinventory='Y' and account for ='Y'*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */ 

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

			WHEN 1 THEN 'Cash receipt on sale #: ' ELSE 'Receivable on cr. sale #: ' END +

	
INSERT INTO RightsClone (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1729, 'Reports , Sales Reports , Customer Sales , Customer Wise Advance Tax ', 'Customer Wise Advance Tax ', 4, '5,3,1,62,', 'A', 1 UNION ALL SELECT 1730, 'Reports , Purchase Reports , Supplier Wise , Advance Income Tax ', 'Advance Income Tax ', 4, '5,4,4,7,', 'A', 1

INSERT INTO Rights (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1729, 'Reports , Sales Reports , Customer Sales , Customer Wise Advance Tax ', 'Customer Wise Advance Tax ', 4, '5,3,1,62,', 'A', 1 UNION ALL SELECT 1730, 'Reports , Purchase Reports , Supplier Wise , Advance Income Tax ', 'Advance Income Tax ', 4, '5,4,4,7,', 'A', 1

INSERT INTO GroupRights (GroupCode, RightCode, Status) SELECT 2, 1729, 1 UNION ALL SELECT 2, 1730, 1
INSERT INTO DBO.SoftwarePreferences

SELECT 3195, 'AskContactCardForSMS', 'Ask Contact Card for SMS:', 'CHAR', 'N', 'No', 110, 3195, 1, 0, 'ddd_pref_yesno', 'Y', NULL, NULL, NULL
pe = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM srledger S

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.SRCatCode <> 8 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM srledger S, MasterCashWin D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.DocumentCode



RETURN

END
ALTER    FUNCTION DBO.Fn_GetUnposted_Services ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT



DECLARE @SvcRemks CHAR(1), @SvcRRemks CHAR(1)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SvcRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRemarksInLedger' ))

SET @SvcRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for s
ales of services*/

select  DocumentCode = h.serviceinvcode, 

	DocumentType = 'RS',

	catcode = h.ServiceCatCode,

	dr_acccode = Case h.ServiceCatCode when 10 THEN h.CashAccCode when 12 THEN h.CashAccCode else h.custcode End,

	cr_acccode = @ln_revfromservice,

	AlternateAccCode = CASE h.ServiceCatCode WHEN 10 THEN h.custcode /* Cash Sale Service*/ 

		WHEN 12 THEN h.custcode /* Cash Sale Service*/ ELSE NULL /* Credit Sale Service*/ END,

	Date = h.date, 

	SaleTax = Round(

		ISNULL(Sum((D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = CASE @SvcRemks WHEN 'Y' THEN h.Remarks

		ELSE CASE h.ServiceCatCode WHEN 10 THEN 'Cash receipt on service sale #: '

			WHEN 12 THEN 'Cash receipt on service sale #: '

			ELSE 'Receivable on cr. service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode)))+ 

			CASE WHEN h.saleinvcode is null Then '' 

			     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.saleinvcode))) END

		END,

	cr_remarks = CASE h.ServiceCatCode

			WHEN 6 THEN 'Revenue from cash service #: '

			ELSE 'Revenue from credit service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),

	saletax_remarks= 'Sales Tax Payable on Service Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),
	CheckNo = NULL, 

	UserCode=ISNULL(h.salesmancode, 0), vouchercode = h.serviceinvcode, invoicecode= h.serviceinvcode,

	invoicetype = 5 /* Service sales */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, Outstandin
ALTER PROCEDURE DBO.SP_VirtualGL_Sales

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0),

	@ln_AdvIncomeTaxSale NUMERIC(5, 0)

DECLARE @SRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT, @AdvIncomeTax CHAR(1)



SET @AdvIncomeTax = ISNULL((SELECT a=DBO.Fn_GetPreference('ApplyAdvanceIncomeTaxInSale')), 'N')

SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')

SET @SRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSaleRemarksInLedger' ))



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT  SaleInvCode FROM SaleLedger S

WHERE S.Posted = 'Y'	 and S.AccountFor = 'Y' AND 

	S.SaleInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SV')



INSERT INTO VirtualGLTemp	/*accounting for sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode  /* Cas
gAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

from serviceheader h, servicedetail d

where h.Posted ='N' AND h.serviceinvcode = d.serviceinvcode 

GROUP BY h.serviceinvcode, h.custcode, h.ServiceCatCode, h.cashacccode,

	 h.date, h.discperc, h.misccharges, h.flatdisc, h.serviceinvgstperc, h.salesmancode,

	 h.saleinvcode, h.patientcode, h.admissioncode, h.remarks, H.GuestCode, H.StudentCode

UNION ALL /*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.ServiceCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))), 

	cr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM serviceheader S


WHERE S.Posted ='N' AND S.ServiceCatCode <> 10 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.serviceCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM serviceheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'RS' AND S.serviceinvcode = D.documentcode 

UNION ALL /*accounting for sales returns of services*/

select  DocumentCode = h.serviceRinvcode, 

	DocumentType = 'RR',

	catcode = h.ServiceRCatCode,

	dr_acccode = @ln_revfromservice,

	cr_acccode = Case h.ServiceRCatCode when 13 THEN h.cashacccode when 15 THEN h.cashacccode else h.custcode End,

	AlternateAccCode = Case h.ServiceRCatCode when 13 THEN h.custcode when 15 THEN h.custcode else NULL End,

	Date    = h.date, 

	SaleTax = 

		Round(

		ISNULL(Sum((D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross   = IsNull(Round(sum( d.qty * (isnull(d.Ser
ALTER PROCEDURE DBO.SP_VirtualGL @ac_type CHAR(1)

AS



SET NOCOUNT ON

TRUNCATE TABLE VirtualGLTemp

DECLARE @rc int

SET @rc = (SELECT COUNT(*) FROM VirtualGL (TABLOCKX))



IF UPPER(@ac_type) IS NULL 

	SET @ac_type = 'A'



IF UPPER(@ac_type) <> 'S' AND UPPER(@ac_type) <> 'A' 

	SET @ac_type = 'A'



DECLARE @goodsacc smallint, @goodsissueacc smallint, @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), 

	@ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_salestaxonsvc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0), @ln_AdvIncomeTaxSale NUMERIC(5, 0)

DECLARE @InvSys CHAR(1)



SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @goodsissueacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 31)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'G
T_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')



BEGIN TRANSACTION T1



IF @ac_type <> 'C'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Purchase

	EXECUTE DBO.SP_VirtualGL_PurchaseReturn

	EXECUTE DBO.SP_VirtualGL_PurchaseServices

END



IF @ac_type <> 'S'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Sales

	EXECUTE DBO.SP_VirtualGL_SalesReturn

	EXECUTE DBO.SP_VirtualGL_Services

	EXECUTE DBO.SP_VirtualGL_SaleOrder

END



EXECUTE DBO.SP_VirtualGL_Receipt

EXECUTE DBO.SP_VirtualGL_Issue

EXECUTE DBO.SP_VirtualGL_Adjustment

EXECUTE DBO.SP_VirtualGL_Guest

EXECUTE DBO.SP_VirtualGL_Patient

EXECUTE DBO.SP_VirtualGL_Vouchers

EXECUTE DBO.SP_VirtualGL_Notes

EXECUTE DBO.SP_VirtualGL_TransactionWindow

EXECUTE DBO.SP_VirtualGL_Payroll



INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE WHEN dr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 

			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	Alternat
CREATE VIEW dbo.VIEW_SMS_SaleInvInfo2 AS

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

	PatientRegNo = (SELECT P.RegNo FROM Patient P WHERE P.PatientCode = H.PatientCode),

	PatientName = (SELECT P.Name FROM Patient P WHERE P.PatientCode = H.PatientCode),

	Agency = (SELECT G.Name FROM GoodsCompany G WHERE G.GCCode = H.GCCode),

	GRN = H.GRN,

	Vehicle = H.Vehicle,

	ShipTo = H.ShipTo,

	PreviousReading = LTRIM(RTRIM(STR(H.PreviousReading, 10, 0))),

	CurrentReading = LTRIM(RTRIM(STR(H.CurrentReading, 10, 0))),

	KiloMeters = LTRIM(RTRIM(STR((ISNULL(H.CurrentReading, 0) - ISNULL(H.Previ
		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

		END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

		WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received'

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode,

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END

FROM saleledger S, saleinvdetail D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges,

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt



INSERT INTO VirtualGLTemp	/*accounting for sales receivable Adjustments made at the time of invoicing*/

SELECT  documentcode = S.saleinvcode, docu
menttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE WHEN D.Debit > 0 THEN AccCode ELSE S.CustCode END,

	cr_acccode = CASE WHEN D.Debit > 0 THEN S.CustCode ELSE AccCode END,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = D.CheckNo, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S, SaleReceivableAdj D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))), 

	cr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CA
SE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S

WHERE S.SaleCatCode NOT IN (1, 3) AND S.CashCharged > 0 AND 

	S.saleinvcode IN (SELECT Code FROM #lsl)

UNION ALL

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S, CashierWindow D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 



TRUNCATE TABLE #lsl
ALTER PROCEDURE DBO.SP_VirtualGL_Adjustment

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)

DECLARE @SRemks CHAR(1), @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT AdjCode FROM AdjHeader

WHERE Posted = 'Y' AND

	AdjCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('AI','AD'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.AdjCode, documenttype    = CASE A.AdjCatCode WHEN 1 THEN 'AI' ELSE 'AD' END, catcode = A.AdjCatCode,

	dr_acccode = CASE A.AdjCatCode WHEN 1 THEN @ln_invacc ELSE A.AccCode END,

	cr_acccode = CASE A.AdjCatCode WHEN 1 THEN A.AccCode ELSE @ln_invacc  END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.looseqty * D.Price), 0),

	dr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	cr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.UserCode, vouchercode= A.AdjCode, invoicecode= A.AdjCode,

	
invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM AdjHeader A, AdjDetail D

WHERE A.AdjCode IN (SELECT Code FROM #lsl) AND

	A.AdjCode = D.AdjCode AND A.AccCode IS NOT NULL

GROUP BY A.AdjCode, A.AccCode, A.AdjCatCode, A.Date, A.UserCode, A.Remarks



TRUNCATE TABLE #lsl
ALTER PROCEDURE DBO.SP_VirtualGL_Guest

AS



SET NOCOUNT ON



CREATE TABLE #lt_guestcheckin (code INT NOT NULL)

INSERT INTO #lt_guestcheckin

SELECT P.guestcheckinCode 

FROM Guestcheckin P

WHERE 

	P.guestcheckinCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'GC') AND 

	(P.CashCharged > 0 OR P.guestcheckinCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.guestcheckinCode AND MCW.DocumentType = 'GC'))



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient guestcheckin*/

SELECT  documentcode = S.guestcheckinCode, documenttype    = 'GC', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = G.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Guest Check In ' + LTRIM(RTRIM(STR(S.guestcheckinCode, 10))), 

	cr_remarks = 'Cash Received during Guest Check In ' + LTRIM(RTRIM(STR(S.guestcheckinCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.guestcheckinCode, invoicecode= S.guestcheckinCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL, RN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL,

	GuestCode = S.GuestCode, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM Guestcheckin S, Guest G

WHERE S.CashCharged > 0 AND 

	S.GuestCode = G.GuestCode AND

	S.guestcheckinCode IN (SELECT Code FROM #lt_guestcheckin)

UNION ALL

SELECT  documentcode = S.guestcheckinCode, documenttype    = 'GC', catcode = 1,

	dr_acccode = D.AccCode,

	cr_acccode = G.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.guestcheckinCode, invoicecode= S.gues
tcheckinCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL,

	GuestCode = S.GuestCode, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM Guestcheckin S, MasterCashWin D, Guest G

WHERE 

	D.DocumentType = 'GC' AND 

	S.guestcheckinCode = D.documentcode AND

	S.GuestCode = G.GuestCode AND 

	S.guestcheckinCode IN (SELECT Code FROM #lt_guestcheckin)



TRUNCATE TABLE #lt_guestcheckin

TRUNCATE TABLE #lt_guestcheckin
ALTER  PROCEDURE DBO.SP_VirtualGL_Issue AS

SET NOCOUNT ON



DECLARE @invacc smallint, @goodsacc smallint

DECLARE @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @invacc = ISNULL((SELECT code FROM global WHERE name = 'GT_InventoryAcc'), 7)

SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 30)



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT IssueInvCode FROM IssueHeader

WHERE Posted = 'Y' AND

	IssueInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('ISU'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.IssueInvCode, documenttype = 'ISU', catcode = A.IssueCategoryCode,

	dr_acccode = A.DrAccCode,

	cr_acccode = CASE WHEN @InvSys <> 'P' THEN @invacc ELSE @goodsacc END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.qty * D.Price), 0),

	dr_remarks = CASE WHEN A.Remarks is null THEN 'Goods Issue against Issue Inv #' + LTRIM(RTRIM(STR(A.IssueInvCode))) ELSE A.Remarks END,

	cr_remarks = CASE WHEN A.Remarks is null THEN 'Goods Issue against Issue Inv #' + LTRIM(RTRIM(STR(A.IssueInvCode))) ELSE A.Remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.IssueCode, invoicecode= A.IssueInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM IssueHeader A, IssueDetail D

WHERE A.AccountFor = 'Y' AND A.DrAccCode IS NOT NULL AND A.IssueInvCode IN (SELECT Code FROM #lsl) AND

	A.IssueInvCode = D.IssueInvCode

GROUP BY A.IssueInvCode, A.IssueCode, A.DrAccCode, A.IssueCategoryCode, A.Date, A.SalesmanCode, A.Remarks



TRUNCATE TABLE #lsl
ALTER    PROCEDURE DBO.SP_VirtualGL_Notes

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_notes (code INT NOT NULL)



INSERT INTO #lt_notes

SELECT  NoteCode 

FROM    Notes

WHERE   Notes.NoteCode NOT IN 

	(SELECT DISTINCT DocumentCode FROM VirtualGL WHERE VirtualGL.DocumentType IN ('NR','NP')) AND Notes.Posted='Y'



/* Create Accounting Vouchers from Notes Receivables/PAyables that are entered by user But not accounted for yet (depending on VIRTUALGL Table). That is the posted Notes Receivables/PAyables Vouchers not in VIRTUALGL but in Notes table */

INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End, 

	catcode = Notes.NoteCatCode,

	acccode= Notes.Bankacccode, 

	AlternateAccCode = NULL, 

	Date    = Notes.PostDate, 

	debit   = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,

	credit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	remarks = notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.Vou
cherCode, 

	InvoiceCode = NULL, InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where 	Notes.NoteCode IN (SELECT Code FROM #lt_notes)

UNION ALL

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End,

	catcode = Notes.NoteCatCode,

	acccode= Notes.acccode, 

	AlternateAccCode = NULL, 

	Date   = Notes.PostDate, 

	debit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	credit = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,

	remarks= notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.VoucherCode, InvoiceCode = NULL, 

	InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where	Notes.NoteCode IN (SELECT Code FROM #lt_notes)



TRUNCATE TABLE #lt_notes
ALTER PROCEDURE DBO.SP_VirtualGL_Patient

AS



SET NOCOUNT ON



CREATE TABLE #lt_patient (code INT NOT NULL)

INSERT INTO #lt_patient

SELECT P.PatientCode 

FROM Patient P

WHERE 

	P.PatientCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PG') AND 

	(P.CashCharged > 0 OR P.PatientCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.PatientCode AND MCW.DocumentType = 'PG'))



CREATE TABLE #lt_admission (code INT NOT NULL)

INSERT INTO #lt_admission

SELECT P.AdmissionCode 

FROM PatientAdmission P

WHERE 

	P.AdmissionCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PA') AND 

	(P.CashCharged > 0 OR P.AdmissionCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.AdmissionCode AND MCW.DocumentType = 'PA'))



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient registration*/

SELECT  documentcode = S.PatientCode, documenttype    = 'PG', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Patient Reg.' + LTRIM(RTRIM(STR(S.PatientCode, 10))), 

	cr_remarks = 'Cash Received during Patient Reg.' + LTRIM(RTRIM(STR(S.PatientCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.PatientCode, invoicecode= S.PatientCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM Patient S

WHERE S.CashCharged > 0 AND 

	S.PatientCode IN (SELECT Code FROM #lt_patient)

UNION ALL

SELECT  documentcode = S.PatientCode, documenttype    = 'PG', catcode = 1,


	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.PatientCode, invoicecode= S.PatientCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM Patient S, MasterCashWin D

WHERE S.PatientCode IN (SELECT Code FROM #lt_patient) AND D.DocumentType = 'PG' AND S.PatientCode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient admission*/

SELECT  documentcode = S.AdmissionCode, documenttype    = 'PA', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = P.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Patient Admission ' + LTRIM(RTRIM(STR(S.AdmissionCode, 10))), 

	cr_remarks = 'Cash Received during Patient Admission ' + LTRIM(RTRIM(STR(S.AdmissionCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.AdmissionCode, invoicecode= S.AdmissionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM PatientAdmission S, Patient P

WHERE S.CashCharged > 0 AND 

	S.PatientCode = P.PatientCode AND

	S.AdmissionCode IN (SELECT Code FROM #lt_admission)

UNION ALL

SELECT  documentcode = S.AdmissionCode, documenttype    = 'PA', catcode = 1,

	dr
_acccode = D.AccCode,

	cr_acccode = P.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.AdmissionCode, invoicecode= S.AdmissionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM PatientAdmission S, MasterCashWin D, Patient P

WHERE 

	D.DocumentType = 'PA' AND 

	S.AdmissionCode = D.documentcode AND

	S.PatientCode = P.PatientCode AND 

	S.AdmissionCode IN (SELECT Code FROM #lt_admission)



TRUNCATE TABLE #lt_patient

TRUNCATE TABLE #lt_admission
00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE3 > 0 AND A.QE3_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE3_AccCode, A.QExp3_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE4_AccCode,

	cr_acccode = A.QExp4_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE4 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE4 > 0 AND A.QE4_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE4_AccCode, A.QExp4_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE5_AccCode,

	cr_acccode = A.QExp5_CrAccCode,

	AlternateAccCode
 = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE5 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE5 > 0 AND A.QE5_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE5_AccCode, A.QExp5_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE1_AccCode,

	cr_acccode = A.WExp1_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NU
LL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE1 > 0 AND A.WE1_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE1_AccCode, A.WExp1_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE2_AccCode,

	cr_acccode = A.WExp2_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE2 > 0 AND A.WE2_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A
.SalesmanCode, A.Remarks, A.WE2_AccCode, A.WExp2_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE3_AccCode,

	cr_acccode = A.WExp3_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE3 > 0 AND A.WE3_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE3_AccCode, A.WExp3_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE4_AccCode,

	cr_acccode = A.WExp4_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'I
tem Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE4 > 0 AND A.WE4_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE4_AccCode, A.WExp4_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE5_AccCode,

	cr_acccode = A.WExp5_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHe
ader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE5 > 0 AND A.WE5_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE5_AccCode, A.WExp5_CrAccCode



TRUNCATE TABLE #lsl
ALTER     PROCEDURE DBO.SP_VirtualGL_SaleOrder

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_saleorder (code INT NOT NULL)



INSERT INTO VirtualGLTemp	/*Accounting Advance on Sales Order */

SELECT  documentcode = S.saleordercode, documenttype    = 'SO', catcode = 1,

	dr_acccode = S.PaymentAccCode, cr_acccode = S.custcode, AlternateAccCode = Null,

	Date    = S.AmtDate, SaleTax= 0, 

	Gross= S.Amt,

	dr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	cr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	saletax_remarks= NULL, CheckNo = S.AmtReference, UserCode= S.AmtBy, vouchercode= S.SaleOrdercode,

	invoicecode= S.SaleOrderCode, invoicetype = NULL, Amt = 0, DrAmtAccCode = NULL,

	CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0, PatientCode= S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, Guestcode=NuLL, Studentcode=NuLL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM    SaleOrderHeader S

WHERE   S.SaleOrderCode IN (SELECT Code FROM #lt_saleorder)



TRUNCATE TABLE #lt_saleorder
T_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')



BEGIN TRANSACTION T1



IF @ac_type <> 'C'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Purchase

	EXECUTE DBO.SP_VirtualGL_PurchaseReturn

	EXECUTE DBO.SP_VirtualGL_PurchaseServices

END



IF @ac_type <> 'S'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Sales

	EXECUTE DBO.SP_VirtualGL_SalesReturn

	EXECUTE DBO.SP_VirtualGL_Services

	EXECUTE DBO.SP_VirtualGL_SaleOrder

END



EXECUTE DBO.SP_VirtualGL_Receipt

EXECUTE DBO.SP_VirtualGL_Issue

EXECUTE DBO.SP_VirtualGL_Adjustment

EXECUTE DBO.SP_VirtualGL_Guest

EXECUTE DBO.SP_VirtualGL_Patient

EXECUTE DBO.SP_VirtualGL_Vouchers

EXECUTE DBO.SP_VirtualGL_Notes

EXECUTE DBO.SP_VirtualGL_TransactionWindow

EXECUTE DBO.SP_VirtualGL_Payroll



INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE WHEN dr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 

			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	AlternateAccCode = CASE WHEN cr_Ac
cCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAm
t, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		WHEN 'SR' THEN 	'Paid during s/return no.' ELSE DR_Remarks END+ ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		WHEN 'SR' THEN 'Paid during s/return no.' ELSE CR_Remarks END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL /*When Perpetual Inv. System then 
cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit = 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



COMMIT TRANSACTION T1

TRUNCATE TABLE VirtualGLTemp
ALTER  PROCEDURE DBO.SP_VirtualGL_SalesReturn

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



CREATE TABLE #lt_sret (code INT NOT NULL)

INSERT INTO #lt_sret

SELECT  SRInvCode FROM SRLedger S

WHERE S.posted = 'Y'	 and S.accountfor = 'Y' AND

	S.SRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SR')



INSERT INTO VirtualGLTemp	/*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srp
rice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL,
 GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * CASE WHEN S.SaleInvCode > 0 THEN D.AvgPrice ELSE (D.SRPrice * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01)) END),0),

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00

FROM srledger S, srdetail D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00

FROM srledger S

WHERE S.SRCatCode NOT IN (6, 8) AND S.CashCharged > 0 AND 

	
S.srinvcode IN (SELECT Code FROM #lt_sret)

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00

FROM srledger S, MasterCashWin D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.DocumentCode



TRUNCATE TABLE #lt_sret
ALTER    PROCEDURE DBO.SP_VirtualGL_Services

AS



SET NOCOUNT ON



DECLARE @revfromservice INT

DECLARE @SvcRemks CHAR(1), @SvcRRemks CHAR(1)



SET @revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')



SET @SvcRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRemarksInLedger' ))

SET @SvcRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRetRemarksInLedger' ))



CREATE TABLE #lt_service (code INT NOT NULL)

INSERT INTO #lt_service

SELECT  ServiceInvCode FROM ServiceHeader S

WHERE   S.ServiceInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RS') AND S.posted = 'Y'



CREATE TABLE #lt_serviceret (code INT NOT NULL)

INSERT INTO #lt_serviceret

SELECT  ServiceRInvCode FROM ServiceRHeader S

WHERE   S.ServiceRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RR') AND S.posted = 'Y'



INSERT INTO VirtualGLTemp	/*accounting for sales of services*/

select  DocumentCode = h.serviceinvcode, 

	DocumentType = 'RS',

	catcode = h.ServiceCatCode,

	dr_acccode = h.custcode,

	cr_acccode = @revfromservice,

	AlternateAccCode = CASE WHEN h.ServiceCatCode = 10 THEN h.custcode WHEN h.ServiceCatCode = 12 THEN h.custcode ELSE NULL END,

	Date = h.date, 

	SaleTax = Round(

		ISNULL(Sum((D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = CASE @SvcRemks WHEN 'Y' THEN h.Remarks

		ELSE CASE h.ServiceCatCode WHEN 10 THEN 'Sale of Service on Inv. #: '

			WHEN 12 THEN 'Sale of Service on Inv. #: '

			ELSE 'Receivable on cr
. service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode)))+ 

			CASE WHEN h.saleinvcode is null Then '' 

			     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.saleinvcode))) END

		END,

	cr_remarks = CASE h.ServiceCatCode

			WHEN 10 THEN 'Revenue from cash service #: '

			ELSE 'Revenue from credit service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),

	saletax_remarks= 'Sales Tax Payable on Service Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),
	CheckNo = NULL, 

	UserCode=ISNULL(h.salesmancode, 0), vouchercode = h.serviceinvcode, invoicecode= h.serviceinvcode,

	invoicetype = 5 /* Service sales */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

from serviceheader h, servicedetail d

where h.serviceinvcode IN (SELECT Code FROM #lt_service) AND

	  h.serviceinvcode = d.serviceinvcode 

GROUP BY h.serviceinvcode, h.custcode, h.ServiceCatCode, h.cashacccode,

	 h.date, h.discperc, h.misccharges, h.flatdisc, h.serviceinvgstperc, h.salesmancode,

	 h.saleinvcode, h.patientcode, h.admissioncode, h.remarks, H.GuestCode, H.StudentCode



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.ServiceCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = NULL, Date    = S.date, SaleTax= 0,

	Gross =	CASE WHEN S.CashCharged > 0 THEN S.CashCharged ELSE 0 END,

	dr_remarks = 'Cash Received on Servi
ce Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))), 

	cr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM serviceheader S

WHERE S.CashCharged > 0 AND S.serviceinvcode IN (SELECT Code FROM #lt_service)

UNION ALL

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.serviceCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = D.Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM serviceheader S, MasterCashWin D

WHERE S.serviceinvcode IN (SELECT Code FROM #lt_service) AND
 D.DocumentType = 'RS' AND S.serviceinvcode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for sales returns of services*/

select  DocumentCode = h.serviceRinvcode, 

	DocumentType = 'RR',

	catcode = h.ServiceRCatCode,

	dr_acccode = @revfromservice,

	cr_acccode = h.custcode,

	AlternateAccCode = Case h.ServiceRCatCode when 13 THEN h.custcode when 15 THEN h.custcode else NULL End,

	Date    = h.date, 

	SaleTax = 

		Round(

		ISNULL(Sum((D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross   = IsNull(Round(sum( d.qty * (isnull(d.ServicePrice - d.serviceflatdisc, 0)) * (1 - (.01 * isnull(d.discperc, 0)))) * 

		  (1- (.01 * h.discperc)) + isnull(h.misccharges,0) - isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Revenue (reversal) for ' + CASE h.ServiceRCatCode

		WHEN 13 THEN 'cash' WHEN 15 THEN 'cash' ELSE 'cr.' END + 

		' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

		CASE WHEN h.serviceinvcode is null Then '' 

		     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END,

	cr_remarks = CASE @SvcRRemks WHEN 'Y' THEN h.Remarks

			ELSE CASE h.ServiceRCatCode WHEN 13 THEN 'cash paid on'

				WHEN 15 THEN 'cash paid on' ELSE 'Payable on cr.' END + 

				' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

				CASE WHEN h.serviceinvcode is null Then '' 

				     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END

			END,

	saletax_remarks= 'Sales Tax Payable (Reveral) on Service Ret Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))),
	CheckNo = NULL, UserCode=h.salesmancode, vouchercode = h.serviceRinvcode,

	invoicecode= h.serviceRinvcode, invoicetype = 7 /* Service Return */,


	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, 

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

from serviceRheader h, serviceRdetail d

where h.serviceRinvcode IN (SELECT Code FROM #lt_serviceret) AND

	 h.serviceRinvcode = d.serviceRinvcode 

GROUP BY h.serviceRinvcode, h.custcode, h.ServiceRCatCode, h.cashacccode, h.date, h.discperc, h.misccharges, 

	h.flatdisc, H.serviceinvgstperc, h.salesmancode, h.serviceinvcode, h.patientcode, h.admissioncode, h.Remarks, H.GuestCode, H.StudentCode



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service return */

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.ServiceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN S.CashCharged > 0 THEN S.CashCharged ELSE 0 END,

	dr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))), 

	cr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.servicerinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END
,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM servicerheader S

WHERE S.CashCharged > 0 AND S.serviceRinvcode IN (SELECT Code FROM #lt_serviceret)

UNION ALL

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.serviceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = D.Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceRinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM serviceRheader S, MasterCashWin D

WHERE S.serviceRinvcode IN (SELECT Code FROM #lt_serviceret) AND D.DocumentType = 'RR' AND S.serviceRinvcode = D.documentcode



DELETE VirtualGLTemp WHERE Gross = 0 AND Amt = 0 AND SaleTax=0 AND AdvIncomeTax=0.00



TRUNCATE TABLE #lt_service

TRUNCATE TABLE #lt_serviceret
ALTER  PROCEDURE DBO.SP_VirtualGL_TransactionWindow

AS



SET NOCOUNT ON



CREATE TABLE #lt_transaction (code INT NOT NULL)

INSERT INTO #lt_transaction

SELECT T.DocumentCode

FROM TransactionHeader T

WHERE 

	T.DocumentCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType IN (SELECT ShortName FROM TransactionType))



INSERT INTO VirtualGLTemp	/* accounting for cash received via transaction window */

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.CashAccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TD.AccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Recvd. Against Transacti
on Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TH.CashAccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2

UNION ALL


SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TD.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0



TRUNCATE TABLE #lt_transaction
ALTER    PROCEDURE DBO.SP_VirtualGL_Vouchers

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_voucher (code INT NOT NULL)



INSERT INTO #lt_voucher

SELECT  GLVochCode 

FROM    GLHeader H

WHERE   convert(varchar(5),H.VochCatCode) + '-' + convert(varchar(10),H.GLVochCode) NOT IN 

	(SELECT DISTINCT convert(varchar(5),CatCode) + '-' + convert(varchar(10),DocumentCode) FROM VirtualGL V WHERE V.DocumentType IN (SELECT VC.ShortName FROM VocherCategory VC)) AND H.Posted = 'Y'





/*  Create Accounting Vouchers that are manullay entered by user but not accounted for yet (depending on VIRTUALGL Table). That is the posted Accounting Vouchers not entered in VIRTUALGL but exist in GLHeader */

INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

Select	documentcode = H.glvochcode,

	documenttype    = VC.ShortName,

	catcode = H.VochCatCode,

	acccode = D.acccode, 

	AlternateAccCode = NULL, 

	date    = H.Date,

	debit   = D.debit, 

	credit  = D.credit,

	remarks = CASE WHEN h.acccode = d.acccode THEN H.Remarks ELSE D.remarks END,

	CheckNo = CASE WHEN h.acccode = d.acccode THEN H.ChkNo ELSE D.ChkNo END, 


	UserCode = H.salesmancode, H.VoucherCode, D.InvoiceCode, VC.InvoiceType, 

	OutstandingAmt= D.OutstandingAmt, Balance= D.Balance, 

	VRow = CASE D.DEBIT WHEN 0 THEN 1 ELSE 0 END, D.PatientCode,

	GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=D.GuestCode, StudentCode=D.StudentCode, H.CurrencyCode, H.ConversionRate

from glheader H, gldetail D, VocherCategory VC

where H.glvochcode IN (SELECT Code FROM #lt_voucher) AND

	H.glvochcode = D.glvochcode and H.vochcatcode = VC.vochcatcode



TRUNCATE TABLE #lt_voucher
ALTER PROCEDURE DBO.SP_VirtualGL @ac_type CHAR(1)

AS



SET NOCOUNT ON

TRUNCATE TABLE VirtualGLTemp

DECLARE @rc int

SET @rc = (SELECT COUNT(*) FROM VirtualGL (TABLOCKX))



IF UPPER(@ac_type) IS NULL 

	SET @ac_type = 'A'



IF UPPER(@ac_type) <> 'S' AND UPPER(@ac_type) <> 'A' 

	SET @ac_type = 'A'



DECLARE @goodsacc smallint, @goodsissueacc smallint, @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), 

	@ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_salestaxonsvc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0), @ln_AdvIncomeTaxSale NUMERIC(5, 0)

DECLARE @InvSys CHAR(1)



SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @goodsissueacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 31)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'G
ALTER PROCEDURE DBO.SP_VirtualGL_Purchase

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_purexpacc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0)

DECLARE @PRemks CHAR(1), @ReportPurOnPostDate CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT, @AdvIncomeTax CHAR(1)



SET @AdvIncomeTax = ISNULL((SELECT a=DBO.Fn_GetPreference('ApplyAdvanceIncomeTaxInPur')), 'N')

SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_purexpacc = (SELECT code FROM global WHERE name = 'GT_PurExpPayableAcc')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @PRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPurRemarksInLedger' ))

SET @ReportPurOnPostDate = (SELECT a=DBO.Fn_GetPreference( 'reportpurchaseonpostingdate' ))



IF @ReportPurOnPostDate IS NULL

	SET @ReportPurOnPostDate = 'Y'



CREATE TABLE #lt_pur (code INT NOT NULL)

INSERT INTO #lt_pur

SELECT  PurInvCode FROM PurLedger P 

WHERE P.Posted = 'Y' and P.AccountFor = 'Y' AND

	P.PurInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PV')



INSERT INTO VirtualGLTemp 	/*accounting for purchases*/ 

SELECT  documentcode = P.purinvcode, documenttyp
e='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Paya
ble on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END

FROM purledger P, purdetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND

	 P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor, P.AdvanceTaxAmt

UNION ALL				/* ImpactInventory = 'N' i.e. Accounted For Proforma Purcahses  */

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END, 

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcod
e END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM
(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END

FROM purledger P, ProformaPurdetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND

	 P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,
	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor, P.AdvanceTaxAmt

UNION ALL   /*Purchase Expenses treatment*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = PE.AccCode,

	cr_acccode = @ln_purexpacc,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= PE.Amount,

	dr_remarks = CASE WHEN LEN(PE.Remarks) > 0 THEN PE.Remarks ELSE 'Purchase Expenses on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=PE.AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, v
ouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurExp PE

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = PE.PurInvCode AND PE.Amount > 0

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE1_AccCode,

	cr_acccode = P.QExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE1 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE1 > 0 AND P.QE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE1_AccCode, P.QExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.Curre
ncyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE2_AccCode,

	cr_acccode = P.QExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE2 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE2 > 0 AND P.QE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE2_AccCode, P.QExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE3_AccCode,

	cr_acccode = P.QExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE3 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.
purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE3 > 0 AND P.QE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE3_AccCode, P.QExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE4_AccCode,

	cr_acccode = P.QExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE4 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, Stud
entCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE4 > 0 AND P.QE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE4_AccCode, P.QExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE5_AccCode,

	cr_acccode = P.QExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE5 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE5 > 0 AND P.QE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE5_AccCode, P.QExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 1*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catc
ode = P.PurCatCode,

	dr_acccode = P.WE1_AccCode,

	cr_acccode = P.WExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE1 > 0 AND P.WE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE1_AccCode, P.WExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 2*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE2_AccCode,

	cr_acccode = P.WExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode
=P.WE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE2 > 0 AND P.WE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE2_AccCode, P.WExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 3*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE3_AccCode,

	cr_acccode = P.WExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,


	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE3 > 0 AND P.WE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE3_AccCode, P.WExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 4*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE4_AccCode,

	cr_acccode = P.WExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE4 > 0 AND P.WE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE4_AccCode, P.WExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 5*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode
 = P.WE5_AccCode,

	cr_acccode = P.WExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE5 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE5 > 0 AND P.WE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor



TRUNCATE TABLE #lt_pur
ALTER    PROCEDURE DBO.SP_VirtualGL_PurchaseReturn

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)

DECLARE @PRRemks CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @PRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPRetRemarksInLedger' ))



CREATE TABLE #lt_pret (code INT NOT NULL)

INSERT INTO #lt_pret

SELECT  PRInvCode FROM PRLedger P

WHERE P.posted = 'Y' and P.accountfor = 'Y' AND 

	P.PRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PR')



INSERT INTO VirtualGLTemp		/*accounting for purchase returns*/ 

SELECT  documentcode = P.prinvcode, documenttype    = 'PR', catcode = P.PRCatCode,

		dr_acccode = CASE P.PRCatCode

		WHEN 6 THEN @ln_equityacc /* Opening P/RETURN */ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /* Cash/Credit P/RETURN */ END,

 	cr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseretacc ELSE @ln_invacc END,

	AlternateAccCode = Null,

 	date    = P.date,

	SaleTax= CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND(D.looseqty * D.prprice * (1 -
 (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM((D.looseqty * D.prprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

				P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo)

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

		ELSE

			ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) +

			ROUND(

			SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND(D.looseqty * D.prprice * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM((D.looseqty * D.prprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

				P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo)

		END,

	dr_remarks = CASE @PRRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.PrCatCode

				WHEN 6 THEN 'Open' ELSE 'Receivable on ' END + ' pur. return #: ' +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))) 

			END,

	cr_remarks = 'Stock returned on ' + CASE P.PrCatCode WHEN 6 THEN 'open' ELSE '' END +

		' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),

	saletax_remarks= 'S.Tax receivable on ' + 

			CASE P.PrCatCode WHEN 6 THEN 'open' ELSE ':' END + 

			' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),
	CheckNo = NULL, 

	UserCode = P.salesmancode, vouchercode=P.prinvcode, invoicecode=P.prinvcode,

	invoicetype = 4 /*4 stands for purchase return*/,

	Amt = P.Amt, DrAmtAccCode = P.PaymentAccCode, CrAmtAccCode = P.suppcode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM  prledger P, prdetail D
WHERE P.
prinvcode IN (SELECT Code FROM #lt_pret) AND P.prinvcode = D.prinvcode

GROUP BY P.prinvcode, P.suppcode, P.CustCode, P.prcatcode, P.date, P.discperc, P.misccharges, 

	P.salestax, P.flatdisc, P.invgstperc1, P.salesmancode, P.Amt, P.PaymentAccCode, 

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.Remarks, P.UpdateAvgPriceWithNetRate



TRUNCATE TABLE #lt_pret
ALTER  PROCEDURE DBO.SP_VirtualGL_PurchaseServices

AS



SET NOCOUNT ON



DECLARE @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_exponsvc NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_exponsvc  = (SELECT code FROM global WHERE name = 'GT_ExpensesOnServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_service (code INT NOT NULL)

CREATE TABLE #lt_servicePR (code INT NOT NULL)



INSERT INTO #lt_service

SELECT  ServicePurInvCode FROM ServicePurHeader

WHERE   Posted = 'Y' AND ServicePurInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SP')



INSERT INTO #lt_servicePR

SELECT  ServicePrInvCode FROM ServicePrHeader

WHERE   Posted = 'Y' AND ServicePrInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RP')



INSERT INTO VirtualGLTemp	/*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'SP', catcode = 1,

	dr_acccode = h.ExpAccCode, cr_acccode = h.SuppCode, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Purchased Services Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	cr_remarks = 'Payable On Services Purchased Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePurInvCode, invoicecode= h.ServicePurInvCode,

	invoicetype = 6, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL,
 ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

from servicepurheader h, servicepurdetail d

where h.ServicePurInvCode IN (SELECT Code FROM #lt_service) AND

	  h.ServicePurInvCode = d.ServicePurInvCode

GROUP BY h.ServicePurInvCode, h.suppcode, h.ExpAccCode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode,

	 h.OutStandingAmt, h.remarks



INSERT INTO VirtualGLTemp	/*accounting for cash Paid via master cash window during service sales*/

SELECT  documentcode = S.ServicePurInvCode , documenttype    = 'SP', catcode = 1,

	dr_acccode = S.SuppCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	cr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM ServicePurHeader S

WHERE S.CashCharged > 0 AND S.ServicePurInvCode IN (SELECT Code FROM #lt_service)

UNION ALL

SELECT  documentcode = S.ServicePurInvCode, documenttype = 'SP', catcode = 1,

	dr_acccode = S.SuppCode, cr_acccode = D.AccCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL
, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM servicePurheader S, MasterCashWin D

WHERE S.ServicePurInvCode IN (SELECT Code FROM #lt_service) AND D.DocumentType = 'SP' AND S.ServicePurInvCode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for Purchase of services*/

select  DocumentCode = h.ServicePrInvCode, DocumentType = 'RP', catcode = 1,

	dr_acccode = h.SuppCode, cr_acccode = @ln_exponsvc, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	cr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePrInvCode, invoicecode= h.ServicePrInvCode,

	invoicetype = 8, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

from serviceprheader h, serviceprdetail d

where h.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR) AND

	  h.ServicePrInvCode = d.ServicePrInvCode

GROUP BY h.Ser
vicePrInvCode, h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode, h.OutStandingAmt, h.remarks



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.ServicePrInvCode , documenttype    = 'RP', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.SuppCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	cr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM ServicePrHeader S

WHERE S.CashCharged > 0 AND S.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR)

UNION ALL

SELECT  documentcode = S.ServicePrInvCode, documenttype = 'RP', catcode = 1,

	dr_acccode = D.AccCode, cr_acccode = S.SuppCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingA
mt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM servicePrheader S, MasterCashWin D

WHERE S.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR) AND D.DocumentType = 'RP' AND S.ServicePrInvCode = D.documentcode 



TRUNCATE TABLE #lt_service

TRUNCATE TABLE #lt_servicePR
ALTER   PROCEDURE DBO.SP_VirtualGL_Receipt AS

SET NOCOUNT ON



DECLARE @invacc smallint, @goodsacc smallint, @receiptexppayableacc smallint

DECLARE @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @invacc = ISNULL((SELECT code FROM global WHERE name = 'GT_InventoryAcc'), 7)

SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @receiptexppayableacc = (SELECT code FROM global WHERE name = 'GT_ReceiptExpPayableAcc')



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT ReceiptInvCode FROM ReceiptHeader

WHERE Posted = 'Y' AND

	ReceiptInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('RCT'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = CASE WHEN @InvSys <> 'P' THEN @invacc ELSE @goodsacc END,

	cr_acccode = A.CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross=Round(SUM(D.qty * D.Price), 0),

	dr_remarks = CASE WHEN A.remarks is null THEN 'Goods Receipt against Receipt Inv #' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Goods Receipt against Receipt Inv #' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvC
ode

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE1_AccCode,

	cr_acccode = A.QExp1_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE1 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE1 > 0 AND A.QE1_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE1_AccCode, A.QExp1_CrAccCode 

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE2_AccCode,

	cr_acccode = A.QExp2_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE2 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CA
SE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE2 > 0 AND A.QE2_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE2_AccCode, A.QExp2_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE3_AccCode,

	cr_acccode = A.QExp3_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE3 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.
eAccCode = CASE WHEN cr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax Accounted For', CheckNo, UserCode, Vou
cherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		WHEN 'SR' THEN 	'Paid during s/return no.' ELSE DR_Remarks END+ ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		WHEN 'SR' THEN 'Paid during s/return no.' ELSE CR_Remarks END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	A
ALTER TABLE DBO.SaleLedgerLog ADD 

ContactCardCode INT NULL CONSTRAINT FK_SaleLedgerLog_ContactCardCode FOREIGN KEY (ContactCardCode) REFERENCES DBO.ContactCard (ContactCardCode)ALTER TABLE DBO.SaleLedger ADD 

ContactCardCode INT NULL CONSTRAINT FK_SaleLedger_ContactCardCode FOREIGN KEY (ContactCardCode) REFERENCES DBO.ContactCard (ContactCardCode)CREATE TABLE DBO.CustomerDeploymentDetail (

CustomerDeploymentCode INT NOT NULL CONSTRAINT FK_CustomerDeploymentDetail_CustomerDeployment FOREIGN KEY (CustomerDeploymentCode) REFERENCES DBO.CustomerDeployment (CustomerDeploymentCode),

LicenseID VARCHAR(20) NOT NULL CONSTRAINT FK_CustomerDeploymentDetail_CustomerConfig_LicenseID FOREIGN KEY (LicenseID) REFERENCES DBO.CustomerConfig (LicenseID),

Version VARCHAR(20) NOT NULL,

Waseela CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeploymentDetail_Waseela DEFAULT('Y'),

DataCarry CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeploymentDetail_DataCarry DEFAULT('N'),

BackupApps CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeploymentDetail_BackupApps DEFAULT('N'),

Fiscalization CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeploymentDetail_Fiscalization DEFAULT('N'),

PriceChecker CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeploymentDetail_PriceChecker DEFAULT('N'),

GeneratedOn DATETIME NULL,

RowID INT NOT NULL IDENTITY(1,1)

CONSTRAINT PK_CustomerDeploymentDetail PRIMARY KEY (CustomerDeploymentCode, LicenseID)

)CREATE TABLE DBO.CustomerDeployment (

CustomerDeploymentCode INT NOT NULL CONSTRAINT PK_CustomerDeployment PRIMARY KEY(CustomerDeploymentCode),

DATE DATETIME NOT NULL,

Details VARCHAR(1000) NULL,

UserCode SMALLINT NOT NULL CONSTRAINT FK_CustomerDeployment_Users_UserCode FOREIGN KEY (UserCode) REFERENCES DBO.Users (UserCode),

Posted CHAR(1) NOT NULL CONSTRAINT DF_CustomerDeployment_Posted DEFAULT ('N'),

PostedOn DATETIME NULL,

PostedBy SMALLINT NULL CONSTRAINT FK_CustomerDeployment_Users_PostedBy FOREIGN KEY (PostedBy) REFERENCES DBO.Users (UserCode)

)
mt > 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit = 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



COMMIT TRANSACTION T1

TRUNCATE TABLE VirtualGLTemp
ALTER       FUNCTION DBO.Fn_GetUnposted_Purchase ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT,  @ln_invacc INT,

	@ln_salestaxacc INT, @ln_purexpacc INT



DECLARE @PRemks CHAR(1), @ReportPurOnPostDate CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name
 = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_purexpacc = (SELECT code FROM global WHERE name = 'GT_PurExpPayableAcc')



SET @PRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPurRemarksInLedger' ))

SET @ReportPurOnPostDate = (SELECT a=DBO.Fn_GetPreference( 'reportpurchaseonpostingdate' ))



IF @ReportPurOnPostDate IS NULL

	SET @ReportPurOnPostDate = 'Y'



INSERT INTO @retTable /*accounting for purchases*/ 

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty)
 * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN P.AdvanceTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END

FROM purledger P, purdetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P
.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor,

	P.AdvanceTax, P.AdvanceTaxAmt

UNION ALL				/* ImpactInventory = 'N' i.e. Accounted For Proforma Purcahses  */

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose'
 WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN P.AdvanceTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END

FROM purledger P, ProformaPurdetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,
	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor,

	P.AdvanceTax, P.AdvanceTaxAmt

UNION ALL   /*Purchase Expenses treatment*/

SELECT  documentcode = P.purinvcode
, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = PE.AccCode,

	cr_acccode = @ln_purexpacc,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= PE.Amount,

	dr_remarks = CASE WHEN LEN(PE.Remarks) > 0 THEN PE.Remarks ELSE 'Purchase Expenses on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=PE.AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurExp PE

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = PE.PurInvCode AND PE.Amount > 0

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE1_AccCode,

	cr_acccode = P.QExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE1 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P
.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE1 > 0 AND P.QE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE1_AccCode, P.QExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE2_AccCode,

	cr_acccode = P.QExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE2 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE2 > 0 AND P.QE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE2_AccCode, P.QExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipT
o, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE3_AccCode,

	cr_acccode = P.QExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE3 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE3 > 0 AND P.QE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE3_AccCode, P.QExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE4_AccCode,

	cr_acccode = P.QExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE4 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR
(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE4 > 0 AND P.QE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE4_AccCode, P.QExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE5_AccCode,

	cr_acccode = P.QExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE5 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL
, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE5 > 0 AND P.QE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE5_AccCode, P.QExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 1*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE1_AccCode,

	cr_acccode = P.WExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE1 > 0 AND P.WE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE1_AccCode, P.WExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 2*/

SELECT  documentcode = P.purinvcod
e, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE2_AccCode,

	cr_acccode = P.WExp2_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE2 > 0 AND P.WE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE2_AccCode, P.WExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 3*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE3_AccCode,

	cr_acccode = P.WExp3_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM 
Accounts A WHERE A.AccCode=P.WE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE3 > 0 AND P.WE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE3_AccCode, P.WExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 4*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE4_AccCode,

	cr_acccode = P.WExp4_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.Currency
Code, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE4 > 0 AND P.WE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE4_AccCode, P.WExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 5*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE5_AccCode,

	cr_acccode = P.WExp5_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE5 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE5 > 0 AND P.WE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor



RETURN

END
ALTER   FUNCTION DBO.Fn_GetUnposted_Adjustment()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_invacc INT, @ln_cgs INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT

DECLARE @SRemks CHAR(1), @InvSys CHAR(1)



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



INSERT INTO @retTable

SELECT  d
ocumentcode = A.AdjCode, 

	documenttype = CASE A.AdjCatCode WHEN 1 THEN 'AI' ELSE 'AD' END, 

	catcode = A.AdjCatCode,

	dr_acccode = CASE A.AdjCatCode WHEN 1 THEN @ln_invacc ELSE A.AccCode END,

	cr_acccode = CASE A.AdjCatCode WHEN 1 THEN A.AccCode ELSE @ln_invacc  END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.looseqty * D.Price), 0),

	dr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	cr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.UserCode, vouchercode= A.AdjCode, invoicecode= A.AdjCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00

FROM AdjHeader A, AdjDetail D

WHERE A.Posted='N' AND A.AdjCode = D.AdjCode AND A.AccCode IS NOT NULL

GROUP BY A.AdjCode, A.AccCode, A.AdjCatCode, A.Date, A.UserCode, A.Remarks



RETURN

END
ALTER    FUNCTION DBO.Fn_GetUnposted_PurchaseReturn ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT, @ln_invacc INT



DECLARE @PRRemks CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))





SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_sale
staxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @PRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for purchase returns*/ 

SELECT  documentcode = P.prinvcode, documenttype    = 'PR', catcode = P.PRCatCode,

	dr_acccode = CASE P.PRCatCode WHEN 6 THEN @ln_equityacc /* Opening P/RETURN */ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /* Cash/Credit P/RETURN */ END,

	cr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseretacc ELSE @ln_invacc END,

	AlternateAccCode = Null,

 	date    = P.date,

	SaleTax= ROUND(

		SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

		SUM(ROUND(D.looseqty * D.prprice * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND((SUM((D.looseqty * D.prprice) * 

			(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

			P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo),

	Gross= ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

			P.misccharges + P.salestax - P.flatdisc, @RoundUpTo),

	dr_remarks = CASE @PRRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.PrCatCode

				WHEN 6 THEN 'Open' ELSE 'Receivable on ' END + ' pur. return #: ' +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))) 

			END,

	cr_remarks = 'Stock returned on ' + CASE P.PrCatCode WHEN 6 THEN 'open' ELSE '' END +

		' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),

	saletax_remarks= 'S.Tax receivable on ' + 

			CASE P.PrCatCode WHEN 6 THEN 'open' ELSE ':' END + 

			' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),
	CheckNo = NULL, 

	UserCode = P.salesmancode, vouchercode=P.prinvcode, invoicecode=P.prinvcode,

	invoicetype = 4 /*4 stands for purchase return*/,

	Amt = P.Amt, DrAmtAccCode = P.PaymentAccCode, CrAmtAccCode = P.suppcode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL
, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM  prledger P, prdetail D

WHERE P.posted = 'N' and P.accountfor = 'Y' AND P.prinvcode = D.prinvcode

GROUP BY P.prinvcode, P.suppcode, P.CustCode, P.prcatcode, P.date, P.discperc, P.misccharges, 

	P.salestax, P.flatdisc, P.invgstperc1, P.salesmancode, P.Amt, P.PaymentAccCode, 

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.Remarks



RETURN

END
ALTER   FUNCTION DBO.Fn_GetUnposted_PurServices ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_cashacc INT, @ln_equityacc INT, @ln_exponsvc INT, @ln_salestaxacc INT



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_exponsvc  = (SELECT code FROM global WHERE name = 'GT_ExpensesOnServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



INSERT INTO @retTable /*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'SP', catcode = 1,

	dr_acccode = @ln_exponsvc, cr_acccode = h.SuppCode, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Purchased Servi
ces Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	cr_remarks = 'Payable On Services Purchased Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePurInvCode, invoicecode= h.ServicePurInvCode,

	invoicetype = 6, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

from servicepurheader h, servicepurdetail d

where H.Posted = 'N' AND h.ServicePurInvCode = d.ServicePurInvCode

GROUP BY h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode,

	 h.OutStandingAmt, h.remarks

UNION ALL /*accounting for cash Paid via master cash window during service sales*/

SELECT  documentcode = S.ServicePurInvCode , documenttype    = 'SP', catcode = 1,

	dr_acccode = S.SuppCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	cr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ServicePurHeader S

WHERE S.Posted = 'N' AND S.CashCharged > 0

UNION ALL

SELEC
T  documentcode = S.ServicePurInvCode, documenttype = 'SP', catcode = 1,

	dr_acccode = S.SuppCode, cr_acccode = D.AccCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM servicePurheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'SP' AND S.ServicePurInvCode = D.documentcode 

UNION ALL /*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'RP', catcode = 1,

	dr_acccode = h.SuppCode, cr_acccode = @ln_exponsvc, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	cr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePrInvCode, invoicecode= h.ServicePrInvCode,

	invoicetype = 8, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, Out
standingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

from serviceprheader h, serviceprdetail d

where H.Posted = 'N' AND h.ServicePrInvCode = d.ServicePrInvCode

GROUP BY h.ServicePrInvCode, h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode, h.OutStandingAmt, h.remarks

UNION ALL /*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.ServicePrInvCode , documenttype    = 'RP', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.SuppCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	cr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM ServicePrHeader S

WHERE S.Posted = 'N' AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.ServicePrInvCode, documenttype = 'RP', catcode = 1,

	dr_acccode = D.AccCode, cr_acccode = S.SuppCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.
Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00

FROM servicePrheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'RP' AND S.ServicePurInvCode = D.documentcode 

RETURN

END
ALTER    FUNCTION DBO.Fn_GetUnposted_SaleOrder()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



INSERT INTO @retTable /*accounting for sale order*/

SELECT  documentcode = S.saleordercode, documenttype    = 'SO', catcode = 1,

	dr_acccode = S.PaymentAccCode, cr_acccode = S.custcode, AlternateAccCode = Null,

	Date    = S.AmtDate, SaleTax= 0, 


	Gross= S.Amt,

	dr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	cr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	saletax_remarks= NULL, CheckNo = S.AmtReference, UserCode= S.AmtBy, vouchercode= S.SaleOrdercode,

	invoicecode= S.SaleOrderCode, invoicetype = NULL, Amt = 0, DrAmtAccCode = NULL,

	CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0, PatientCode= S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, Guestcode=NuLL, Studentcode=NuLL,

	CGS=0, CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM    SaleOrderHeader S

WHERE   S.Posted = 'N' AND S.Amt <> 0 AND S.AmtDate IS NOT NULL

RETURN

END
ALTER      FUNCTION DBO.Fn_GetUnposted_SalesReturn ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT,

	@ln_invacc INT, @ln_cgs INT



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_sal
estaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTRIM(LTRIM(CONVERT(VARCHAR(12), S
.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * D.AvgPrice),0), S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM srledger S, srdetail D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate

UNION ALL /*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicety
vicePrice - d.serviceflatdisc, 0)) * (1 - (.01 * isnull(d.discperc, 0)))) * 

		  (1- (.01 * h.discperc)) + isnull(h.misccharges,0) - isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Revenue (reversal) for ' + CASE h.ServiceRCatCode

		WHEN 13 THEN 'cash' WHEN 15 THEN 'cash' ELSE 'cr.' END + 

		' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

		CASE WHEN h.serviceinvcode is null Then '' 

		     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END,

	cr_remarks = CASE @SvcRRemks WHEN 'Y' THEN h.Remarks

			ELSE CASE h.ServiceRCatCode WHEN 13 THEN 'cash paid on'

				WHEN 15 THEN 'cash paid on' ELSE 'Payable on cr.' END + 

				' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

				CASE WHEN h.serviceinvcode is null Then '' 

				     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END

			END,

	saletax_remarks= 'Sales Tax Payable (Reveral) on Service Ret Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))),
	CheckNo = NULL, UserCode=h.salesmancode, vouchercode = h.serviceRinvcode,

	invoicecode= h.serviceRinvcode, invoicetype = 7 /* Service Return */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, 

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

from serviceRheader h, serviceRdetail d

where h.Posted ='N' AND h.serviceRinvcode = d.serviceRinvcode 

GROUP BY h.serviceRinvcode, h.custcode, h.ServiceRCatCode, h.cashacccode, h.date, h.discperc, h.misccharges, 

	h.flatdisc, H.serviceinvgstperc, h.salesmancode, h.serviceinvcod
e, h.patientcode, h.admissioncode, h.Remarks, H.GuestCode, H.StudentCode

UNION ALL /*accounting for cash received via master cash window during service return */

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.ServiceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))), 

	cr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.servicerinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM servicerheader S

WHERE S.Posted ='N' AND S.ServiceRCatCode <> 13 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.serviceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceRinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.Admission
Code IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM serviceRheader S, MasterCashWin D

WHERE S.Posted ='N' AND D.DocumentType = 'RR' AND S.serviceRinvcode = D.documentcode

RETURN

END
ALTER   FUNCTION DBO.Fn_GetUnposted_TransWindow ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



INSERT INTO @retTable /* accounting for cash received via transaction window */

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.CashAccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	Pat
ientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TD.AccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TH.CashAccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.Document
Code, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TD.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

RETURN

END
ALTER     FUNCTION DBO.Fn_GetUnposted_Sales ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT,

	@ln_invacc INT, @ln_cgs INT

DECLARE @SRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SE
LECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSaleRemarksInLedger' ))



INSERT INTO @retTable	/*accounting for sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode  /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

			ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

				WHEN 1 THEN 'Cash receipt on sale #: ' 

				ELSE 'Receivable on cr. sale #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

			END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

			WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received' 

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash'

		ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for
 sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode, 

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference, 

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice), 0), S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN S.AdvanceTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END

FROM saleledger S, saledetail D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges, 

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate,

	S.AdvanceTax, S.AdvanceTaxAmt

UNION ALL /*accounting for sales having impactinventory='Y' and account for ='Y'*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */ 

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.sale
price - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

			WHEN 1 THEN 'Cash receipt on sale #: ' ELSE 'Receivable on cr. sale #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

		END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

		WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received'

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode,

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN S.AdvanceTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END

FROM saleledger S, saleinvdetail D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcod
e, S.salecatcode, S.date, S.discperc, S.misccharges,

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate,

	S.AdvanceTax, S.AdvanceTaxAmt

UNION ALL /*accounting for sales receivable Adjustments made at the time of invoicing*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE WHEN D.Debit > 0 THEN AccCode ELSE S.CustCode END,

	cr_acccode = CASE WHEN D.Debit > 0 THEN S.CustCode ELSE AccCode END,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = D.CheckNo, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S, SaleReceivableAdj D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

UNION ALL /*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 
'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))), 

	cr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.SaleCatCode <> 3 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00

FROM saleledger S, CashierWindow D

WHERE S.Posted = 
'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode



RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_AccTrans()

RETURNS @retTable TABLE (

DocumentCode INT NOT NULL,

DocumentType VARCHAR (20)  NOT NULL,

AccCode SMALLINT NOT NULL,

CatCode TINYINT NOT NULL,

AlternateAccCode SMALLINT NULL,

Debit NUMERIC(15, 2) NOT NULL,

Credit NUMERIC(15, 2) NOT NULL,

Date DATETIME NOT NULL,

CheckNo VARCHAR (20)  NULL,

Remarks VARCHAR (100)  NULL,

UserCode SMALLINT NOT NULL,

PatientCode INT NULL,

VoucherCode INT NULL,

INVOICECODE INT NULL,

OUTSTANDINGAMT NUMERIC(15, 2) NOT NULL,

BALANCE NUMERIC(15, 2) NOT NULL,

InvoiceType TINYINT NULL,

VRow TINYINT NOT NULL,

GRN VARCHAR (100)  NULL,

GCCode SMALLINT NULL,

Vehicle VARCHAR (100)  NULL,

ShipTo VARCHAR (100)  NULL,

GuestCode INT NULL,

StudentCode INT NULL,

CGS NUMERIC(15, 2) NOT NULL,

CurrencyCode SMALLINT NULL, 

ConversionRate NUMERIC(11,5) NULL

)

AS

BEGIN



DECLARE @UPTrans TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL)



DECLARE @ln_purchaseacc INT, @ln_casha
cc INT, @ln_equityacc INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT, @ln_invacc INT, @ln_cgs INT, @ln_salestaxonsvc INT,

	@ln_AdvIncomeTaxPur INT, @ln_AdvIncomeTaxSale INT

DECLARE @InvSys CHAR(1)



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')



INSERT INTO @UPTrans 

SELECT * FROM dbo.Fn_GetUnposted_Sales()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_SalesReturn()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_SaleOrder()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Services()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_TransWindow()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_PurServices()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Purchase()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_PurchaseReturn()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Adjustment()



INSERT INTO @retTable

	(DocumentCode, DocumentType, CatCode
, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE dr_AccCode WHEN @ln_cashacc THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 
			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	AlternateAccCode = CASE cr_AccCode WHEN @ln_cashacc THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax E
LSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		ELSE 'Paid during s/return no.' END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CG
S, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		ELSE 'Paid during s/return no.' END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	Amt > 0

UNION ALL /* Un-posted A/c Vouchers */

SELECT  documentcode = H.glvochcode,

	documenttype    = VC.ShortName,

	catcode = H.VochCatCode,

	acccode = D.acccode, 

	AlternateAccCode = NULL, 

	date    = H.Date,

	debit   = D.debit, 

	credit  = D.credit,

	remarks = CASE WHEN h.acccode = d.acccode THEN H.Remarks ELSE D.remarks END,

	CheckNo = CASE WHEN h.acccode = d.acccode THEN H.ChkNo ELSE D.ChkNo END, 

	UserCode = H.salesmancode, H.VoucherCode, D.InvoiceCode, VC.InvoiceType, 

	OutstandingAmt= D.OutstandingAmt, Balance= D.Balance, 

	VRow = CASE D.DEBIT WHEN 0 THEN 1 ELSE 0 END, D.PatientCode,

	GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=D.GuestCode, StudentCode=D.StudentCode, CGS=0, H.CurrencyCode, H.ConversionRate

from glheader H, gldetail D, VocherCategory VC

where H.Posted = 'N' AND H.glvochcode = D.glvochcode and H.vochcatcode = VC.vochcatcode

UNION ALL

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End, 

	catcode = Notes.NoteCatCode,

	acccode= Notes.Bankacccode, 

	AlternateAccCode = NULL, 

	Date   = CASE WHEN Notes.DueDate IS NULL THEN Notes.IssueDate ELSE Notes.D
ueDate END, 

	debit   = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,

	credit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	remarks = notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.VoucherCode, 

	InvoiceCode = NULL, InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where 	Notes.Posted = 'N' AND Notes.Bankacccode IS NOT NULL

UNION ALL /* Un-Posted Cheques */

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End,

	catcode = Notes.NoteCatCode,

	acccode= Notes.acccode, 

	AlternateAccCode = NULL, 

	Date   = CASE WHEN Notes.DueDate IS NULL THEN Notes.IssueDate ELSE Notes.DueDate END, 

	debit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	credit = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,

	remarks= notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.VoucherCode, InvoiceCode = NULL, 

	InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where	Notes.Posted = 'N' AND Notes.Bankacccode IS NOT NULL

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, User
Code, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit = 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



RETURN 

END
ousReading, 0)), 10, 0))),

	NextChange = LTRIM(RTRIM(STR(H.NextChange, 10, 0))),

	Mobile = CC.Mobile

FROM

	SaleLedger H,

	ContactCard CC

WHERE

	H.ContactCardCode IS NOT NULL AND

	H.ContactCardCode = CC.ContactCardCode AND

	CC.UseForSMS = 'Y'
INSERT INTO DBO.SoftwarePreferences

SELECT 820, 'Auto_Apply_FBR_POS_Fee_InSale', 'Auto Apply FBR POS Fee In Sale:', 'CHAR', 'Y', 'Yes', 66, 820, 1, 0, 'ddd_pref_yesno', 'N', NULL, NULL, NULL

UNION ALL

SELECT 821, 'Amount_For_FBR_POS_Fee_InSale', 'Amount For FBR POS Fee In Sale:', 'NUMERIC', '1.00', '1.00', 66, 821, 3, 2, 'w_pref_get_decimal', 'N', NULL, NULL, NULLINSERT INTO Accounts (AccCode, SubCode, Name, OpeningDate, AliasName, Active, Restricted, BalanceLimit, Remarks, AlertCode)

SELECT AccCode=37, SubCode=27, Name='FBR POS SERVICE FEE PAYABLE A/C.', OpeningDate=GETDATE(), AliasName='FBRPOSFEE', Active='Y', Restricted='N', BalanceLimit=NULL, Remarks='FBR POS SERVICE FEE PAYABLE A/C.', AlertCode=1INSERT INTO Global (Name, TableName, Code, Description)

SELECT Name='GT_FBRPOSFeeAcc', TableName='accounts', Code=37, Description='FBR POS SERVICE FEE PAYABLE A/C.'INSERT INTO SMS_DataDefinition (SMSDataCode, Name, ModuleId, ViewName, FilterOn, Enabled)

SELECT 24, 'Sale Invoice Information-Via Contact Card', 1, 'VIEW_SMS_SaleInvInfo2', 'SaleInvCode', 'Y'
v. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



COMMIT TRANSACTION T1

TRUNCATE TABLE VirtualGLTemp
ALTER  VIEW dbo.VIEW_SMS_SaleInvInfo AS

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

	NextChange = LT
ALTER  PROCEDURE DBO.SP_VirtualGL_Adjustment

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)

DECLARE @SRemks CHAR(1), @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT AdjCode FROM AdjHeader

WHERE Posted = 'Y' AND

	AdjCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('AI','AD'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.AdjCode, documenttype    = CASE A.AdjCatCode WHEN 1 THEN 'AI' ELSE 'AD' END, catcode = A.AdjCatCode,

	dr_acccode = CASE A.AdjCatCode WHEN 1 THEN @ln_invacc ELSE A.AccCode END,

	cr_acccode = CASE A.AdjCatCode WHEN 1 THEN A.AccCode ELSE @ln_invacc  END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.looseqty * D.Price), 0),

	dr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	cr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.UserCode, vouchercode= A.AdjCode, invoicecode= A.AdjCode,


	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM AdjHeader A, AdjDetail D

WHERE A.AdjCode IN (SELECT Code FROM #lsl) AND

	A.AdjCode = D.AdjCode AND A.AccCode IS NOT NULL

GROUP BY A.AdjCode, A.AccCode, A.AdjCatCode, A.Date, A.UserCode, A.Remarks



TRUNCATE TABLE #lsl
ALTER  PROCEDURE DBO.SP_VirtualGL_Guest

AS



SET NOCOUNT ON



CREATE TABLE #lt_guestcheckin (code INT NOT NULL)

INSERT INTO #lt_guestcheckin

SELECT P.guestcheckinCode 

FROM Guestcheckin P

WHERE 

	P.guestcheckinCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'GC') AND 

	(P.CashCharged > 0 OR P.guestcheckinCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.guestcheckinCode AND MCW.DocumentType = 'GC'))



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient guestcheckin*/

SELECT  documentcode = S.guestcheckinCode, documenttype    = 'GC', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = G.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Guest Check In ' + LTRIM(RTRIM(STR(S.guestcheckinCode, 10))), 

	cr_remarks = 'Cash Received during Guest Check In ' + LTRIM(RTRIM(STR(S.guestcheckinCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.guestcheckinCode, invoicecode= S.guestcheckinCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL, RN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL,

	GuestCode = S.GuestCode, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM Guestcheckin S, Guest G

WHERE S.CashCharged > 0 AND 

	S.GuestCode = G.GuestCode AND

	S.guestcheckinCode IN (SELECT Code FROM #lt_guestcheckin)

UNION ALL

SELECT  documentcode = S.guestcheckinCode, documenttype    = 'GC', catcode = 1,

	dr_acccode = D.AccCode,

	cr_acccode = G.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.guestcheckinCode, in
ALTER FUNCTION DBO.Fn_GetUnposted_PurServices ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_cashacc INT, @ln_equityacc INT, @ln_exponsvc INT, @ln_salestaxacc INT



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_exponsvc  = (SELECT code FROM global WHERE name = 'GT_ExpensesOnServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



INSERT INTO @retTable /*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'SP', catcode = 1,

	dr_acccode = @ln_exponsvc, cr_acccode = h.SuppCode, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0)
RIM(RTRIM(STR(H.NextChange, 10, 0))),

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
,

	dr_remarks = 'Purchased Services Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	cr_remarks = 'Payable On Services Purchased Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePurInvCode, invoicecode= h.ServicePurInvCode,

	invoicetype = 6, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

from servicepurheader h, servicepurdetail d

where H.Posted = 'N' AND h.ServicePurInvCode = d.ServicePurInvCode

GROUP BY h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode,

	 h.OutStandingAmt, h.remarks

UNION ALL /*accounting for cash Paid via master cash window during service sales*/

SELECT  documentcode = S.ServicePurInvCode , documenttype    = 'SP', catcode = 1,

	dr_acccode = S.SuppCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	cr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

FROM ServicePurHeade
voicecode= S.guestcheckinCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL,

	GuestCode = S.GuestCode, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM Guestcheckin S, MasterCashWin D, Guest G

WHERE 

	D.DocumentType = 'GC' AND 

	S.guestcheckinCode = D.documentcode AND

	S.GuestCode = G.GuestCode AND 

	S.guestcheckinCode IN (SELECT Code FROM #lt_guestcheckin)



TRUNCATE TABLE #lt_guestcheckin

TRUNCATE TABLE #lt_guestcheckin
ALTER   PROCEDURE DBO.SP_VirtualGL_Issue AS

SET NOCOUNT ON



DECLARE @invacc smallint, @goodsacc smallint

DECLARE @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @invacc = ISNULL((SELECT code FROM global WHERE name = 'GT_InventoryAcc'), 7)

SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 30)



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT IssueInvCode FROM IssueHeader

WHERE Posted = 'Y' AND

	IssueInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('ISU'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.IssueInvCode, documenttype = 'ISU', catcode = A.IssueCategoryCode,

	dr_acccode = A.DrAccCode,

	cr_acccode = CASE WHEN @InvSys <> 'P' THEN @invacc ELSE @goodsacc END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.qty * D.Price), 0),

	dr_remarks = CASE WHEN A.Remarks is null THEN 'Goods Issue against Issue Inv #' + LTRIM(RTRIM(STR(A.IssueInvCode))) ELSE A.Remarks END,

	cr_remarks = CASE WHEN A.Remarks is null THEN 'Goods Issue against Issue Inv #' + LTRIM(RTRIM(STR(A.IssueInvCode))) ELSE A.Remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.IssueCode, invoicecode= A.IssueInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM IssueHeader A, IssueDetail D

WHERE A.AccountFor = 'Y' AND A.DrAccCode IS NOT NULL AND A.IssueInvCode IN (SELECT Code FROM #lsl) AND

	A.IssueInvCode = D.IssueInvCode

GROUP BY A.IssueInvCode, A.IssueCode, A.DrAccCode, A.IssueCategoryCode, A.Date, A.SalesmanCode, A.Remarks



TRUNCATE TABLE #lsl
ALTER  PROCEDURE DBO.SP_VirtualGL_Patient

AS



SET NOCOUNT ON



CREATE TABLE #lt_patient (code INT NOT NULL)

INSERT INTO #lt_patient

SELECT P.PatientCode 

FROM Patient P

WHERE 

	P.PatientCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PG') AND 

	(P.CashCharged > 0 OR P.PatientCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.PatientCode AND MCW.DocumentType = 'PG'))



CREATE TABLE #lt_admission (code INT NOT NULL)

INSERT INTO #lt_admission

SELECT P.AdmissionCode 

FROM PatientAdmission P

WHERE 

	P.AdmissionCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PA') AND 

	(P.CashCharged > 0 OR P.AdmissionCode = (SELECT DISTINCT MCW.DocumentCode FROM MasterCashWin MCW WHERE MCW.DocumentCode = P.AdmissionCode AND MCW.DocumentType = 'PA'))



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient registration*/

SELECT  documentcode = S.PatientCode, documenttype    = 'PG', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Patient Reg.' + LTRIM(RTRIM(STR(S.PatientCode, 10))), 

	cr_remarks = 'Cash Received during Patient Reg.' + LTRIM(RTRIM(STR(S.PatientCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.PatientCode, invoicecode= S.PatientCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM Patient S

WHERE S.CashCharged > 0 AND 

	S.PatientCode IN (SELECT Code FROM #lt_patient)

UNION ALL

SELECT  documentcode = S.PatientCode, documenttype    = 'PG
', catcode = 1,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.PatientCode, invoicecode= S.PatientCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM Patient S, MasterCashWin D

WHERE S.PatientCode IN (SELECT Code FROM #lt_patient) AND D.DocumentType = 'PG' AND S.PatientCode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during patient admission*/

SELECT  documentcode = S.AdmissionCode, documenttype    = 'PA', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = P.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received during Patient Admission ' + LTRIM(RTRIM(STR(S.AdmissionCode, 10))), 

	cr_remarks = 'Cash Received during Patient Admission ' + LTRIM(RTRIM(STR(S.AdmissionCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.AdmissionCode, invoicecode= S.AdmissionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM PatientAdmission S, Patient P

WHERE S.CashCharged > 0 AND 

	S.PatientCode = P.PatientCode AND

	S.AdmissionCode IN (SELECT Code FROM #lt_admission)

UNION ALL

SELECT  documentcode = S.Admissi
onCode, documenttype    = 'PA', catcode = 1,

	dr_acccode = D.AccCode,

	cr_acccode = P.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.usercode, vouchercode= S.AdmissionCode, invoicecode= S.AdmissionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM PatientAdmission S, MasterCashWin D, Patient P

WHERE 

	D.DocumentType = 'PA' AND 

	S.AdmissionCode = D.documentcode AND

	S.PatientCode = P.PatientCode AND 

	S.AdmissionCode IN (SELECT Code FROM #lt_admission)



TRUNCATE TABLE #lt_patient

TRUNCATE TABLE #lt_admission
ALTER  PROCEDURE DBO.SP_VirtualGL_Purchase

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_purexpacc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0)

DECLARE @PRemks CHAR(1), @ReportPurOnPostDate CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT, @AdvIncomeTax CHAR(1)



SET @AdvIncomeTax = ISNULL((SELECT a=DBO.Fn_GetPreference('ApplyAdvanceIncomeTaxInPur')), 'N')

SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_purexpacc = (SELECT code FROM global WHERE name = 'GT_PurExpPayableAcc')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @PRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPurRemarksInLedger' ))

SET @ReportPurOnPostDate = (SELECT a=DBO.Fn_GetPreference( 'reportpurchaseonpostingdate' ))



IF @ReportPurOnPostDate IS NULL

	SET @ReportPurOnPostDate = 'Y'



CREATE TABLE #lt_pur (code INT NOT NULL)

INSERT INTO #lt_pur

SELECT  PurInvCode FROM PurLedger P 

WHERE P.Posted = 'Y' and P.AccountFor = 'Y' AND

	P.PurInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PV')



INSERT INTO VirtualGLTemp 	/*accounting for purchases*/ 

SELECT  documentcode = P.purinvcode, documentty
pe='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Pay
able on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END, FBRPosFee=0.0

FROM purledger P, purdetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND

	 P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor, P.AdvanceTaxAmt

UNION ALL				/* ImpactInventory = 'N' i.e. Accounted For Proforma Purcahses  */

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END, 

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCod
e ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', 
Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END, FBRPosFee=0.0

FROM purledger P, ProformaPurdetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND

	 P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,
	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor, P.AdvanceTaxAmt

UNION ALL   /*Purchase Expenses treatment*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = PE.AccCode,

	cr_acccode = @ln_purexpacc,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= PE.Amount,

	dr_remarks = CASE WHEN LEN(PE.Remarks) > 0 THEN PE.Remarks ELSE 'Purchase Expenses on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=PE.AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL
,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurExp PE

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = PE.PurInvCode AND PE.Amount > 0

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE1_AccCode,

	cr_acccode = P.QExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE1 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE1 > 0 AND P.QE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE1_AccCode, P.QExp1_CrAccCode, P.Remarks, P.salesmancode, P.
OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE2_AccCode,

	cr_acccode = P.QExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE2 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE2 > 0 AND P.QE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE2_AccCode, P.QExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE3_AccCode,

	cr_acccode = P.QExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE3 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remark
s ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE3 > 0 AND P.QE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE3_AccCode, P.QExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE4_AccCode,

	cr_acccode = P.QExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE4 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	G
RN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE4 > 0 AND P.QE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE4_AccCode, P.QExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE5_AccCode,

	cr_acccode = P.QExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE5 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.QE5 > 0 AND P.QE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE5_AccCode, P.QExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode
, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 1*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE1_AccCode,

	cr_acccode = P.WExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE1 > 0 AND P.WE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE1_AccCode, P.WExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 2*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE2_AccCode,

	cr_acccode = P.WExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchas
e Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE2 > 0 AND P.WE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE2_AccCode, P.WExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 3*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE3_AccCode,

	cr_acccode = P.WExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,


	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE3 > 0 AND P.WE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE3_AccCode, P.WExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 4*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE4_AccCode,

	cr_acccode = P.WExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE4 > 0 AND P.WE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE4_AccCode, P.WExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehic
le, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 5*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE5_AccCode,

	cr_acccode = P.WExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE5 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM PurLedger P, PurDetail D

WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 

	D.WE5 > 0 AND P.WE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor



TRUNCATE TABLE #lt_pur
ALTER PROCEDURE DBO.SP_VirtualGL_PurchaseReturn

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)

DECLARE @PRRemks CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @PRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPRetRemarksInLedger' ))



CREATE TABLE #lt_pret (code INT NOT NULL)

INSERT INTO #lt_pret

SELECT  PRInvCode FROM PRLedger P

WHERE P.posted = 'Y' and P.accountfor = 'Y' AND 

	P.PRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'PR')



INSERT INTO VirtualGLTemp		/*accounting for purchase returns*/ 

SELECT  documentcode = P.prinvcode, documenttype    = 'PR', catcode = P.PRCatCode,

		dr_acccode = CASE P.PRCatCode

		WHEN 6 THEN @ln_equityacc /* Opening P/RETURN */ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /* Cash/Credit P/RETURN */ END,

 	cr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseretacc ELSE @ln_invacc END,

	AlternateAccCode = Null,

 	date    = P.date,

	SaleTax= CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND(D.looseqty * D.prprice * (1 - (.
01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM((D.looseqty * D.prprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

				P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo)

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

		ELSE

			ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) +

			ROUND(

			SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND(D.looseqty * D.prprice * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM((D.looseqty * D.prprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

				P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo)

		END,

	dr_remarks = CASE @PRRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.PrCatCode

				WHEN 6 THEN 'Open' ELSE 'Receivable on ' END + ' pur. return #: ' +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))) 

			END,

	cr_remarks = 'Stock returned on ' + CASE P.PrCatCode WHEN 6 THEN 'open' ELSE '' END +

		' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),

	saletax_remarks= 'S.Tax receivable on ' + 

			CASE P.PrCatCode WHEN 6 THEN 'open' ELSE ':' END + 

			' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),
	CheckNo = NULL, 

	UserCode = P.salesmancode, vouchercode=P.prinvcode, invoicecode=P.prinvcode,

	invoicetype = 4 /*4 stands for purchase return*/,

	Amt = P.Amt, DrAmtAccCode = P.PaymentAccCode, CrAmtAccCode = P.suppcode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM  prledger P, prdetai
l D
WHERE P.prinvcode IN (SELECT Code FROM #lt_pret) AND P.prinvcode = D.prinvcode

GROUP BY P.prinvcode, P.suppcode, P.CustCode, P.prcatcode, P.date, P.discperc, P.misccharges, 

	P.salestax, P.flatdisc, P.invgstperc1, P.salesmancode, P.Amt, P.PaymentAccCode, 

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.Remarks, P.UpdateAvgPriceWithNetRate



TRUNCATE TABLE #lt_pret
ALTER   PROCEDURE DBO.SP_VirtualGL_PurchaseServices

AS



SET NOCOUNT ON



DECLARE @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_exponsvc NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_exponsvc  = (SELECT code FROM global WHERE name = 'GT_ExpensesOnServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_service (code INT NOT NULL)

CREATE TABLE #lt_servicePR (code INT NOT NULL)



INSERT INTO #lt_service

SELECT  ServicePurInvCode FROM ServicePurHeader

WHERE   Posted = 'Y' AND ServicePurInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SP')



INSERT INTO #lt_servicePR

SELECT  ServicePrInvCode FROM ServicePrHeader

WHERE   Posted = 'Y' AND ServicePrInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RP')



INSERT INTO VirtualGLTemp	/*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'SP', catcode = 1,

	dr_acccode = h.ExpAccCode, cr_acccode = h.SuppCode, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Purchased Services Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	cr_remarks = 'Payable On Services Purchased Against Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))),

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePurInvCode, invoicecode= h.ServicePurInvCode,

	invoicetype = 6, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL
, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

from servicepurheader h, servicepurdetail d

where h.ServicePurInvCode IN (SELECT Code FROM #lt_service) AND

	  h.ServicePurInvCode = d.ServicePurInvCode

GROUP BY h.ServicePurInvCode, h.suppcode, h.ExpAccCode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode,

	 h.OutStandingAmt, h.remarks



INSERT INTO VirtualGLTemp	/*accounting for cash Paid via master cash window during service sales*/

SELECT  documentcode = S.ServicePurInvCode , documenttype    = 'SP', catcode = 1,

	dr_acccode = S.SuppCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	cr_remarks = 'Cash Paid for Services Purchased on Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePurInvCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM ServicePurHeader S

WHERE S.CashCharged > 0 AND S.ServicePurInvCode IN (SELECT Code FROM #lt_service)

UNION ALL

SELECT  documentcode = S.ServicePurInvCode, documenttype = 'SP', catcode = 1,

	dr_acccode = S.SuppCode, cr_acccode = D.AccCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6, Amt = 0, DrAmtAccCode = NULL, 
CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.0

FROM servicePurheader S, MasterCashWin D

WHERE S.ServicePurInvCode IN (SELECT Code FROM #lt_service) AND D.DocumentType = 'SP' AND S.ServicePurInvCode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for Purchase of services*/

select  DocumentCode = h.ServicePrInvCode, DocumentType = 'RP', catcode = 1,

	dr_acccode = h.SuppCode, cr_acccode = @ln_exponsvc, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	cr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePrInvCode, invoicecode= h.ServicePrInvCode,

	invoicetype = 8, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

from serviceprheader h, serviceprdetail d

where h.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR)
 AND

	  h.ServicePrInvCode = d.ServicePrInvCode

GROUP BY h.ServicePrInvCode, h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode, h.OutStandingAmt, h.remarks



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.ServicePrInvCode , documenttype    = 'RP', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.SuppCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	cr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM ServicePrHeader S

WHERE S.CashCharged > 0 AND S.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR)

UNION ALL

SELECT  documentcode = S.ServicePrInvCode, documenttype = 'RP', catcode = 1,

	dr_acccode = D.AccCode, cr_acccode = S.SuppCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8, Amt = 0, DrAmtAccCode = NULL, C
rAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM servicePrheader S, MasterCashWin D

WHERE S.ServicePrInvCode IN (SELECT Code FROM #lt_servicePR) AND D.DocumentType = 'RP' AND S.ServicePrInvCode = D.documentcode 



TRUNCATE TABLE #lt_service

TRUNCATE TABLE #lt_servicePR
ALTER PROCEDURE DBO.SP_VirtualGL_Receipt AS

SET NOCOUNT ON



DECLARE @invacc smallint, @goodsacc smallint, @receiptexppayableacc smallint

DECLARE @InvSys CHAR(1)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @invacc = ISNULL((SELECT code FROM global WHERE name = 'GT_InventoryAcc'), 7)

SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @receiptexppayableacc = (SELECT code FROM global WHERE name = 'GT_ReceiptExpPayableAcc')



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT ReceiptInvCode FROM ReceiptHeader

WHERE Posted = 'Y' AND

	ReceiptInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType IN ('RCT'))



INSERT INTO VirtualGLTemp	/*accounting for */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = CASE WHEN @InvSys <> 'P' THEN @invacc ELSE @goodsacc END,

	cr_acccode = A.CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross=Round(SUM(D.qty * D.Price), 0),

	dr_remarks = CASE WHEN A.remarks is null THEN 'Goods Receipt against Receipt Inv #' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Goods Receipt against Receipt Inv #' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode =
 D.ReceiptInvCode

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE1_AccCode,

	cr_acccode = A.QExp1_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE1 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE1 > 0 AND A.QE1_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE1_AccCode, A.QExp1_CrAccCode 

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE2_AccCode,

	cr_acccode = A.QExp2_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE2 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.
remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE2 > 0 AND A.QE2_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE2_AccCode, A.QExp2_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE3_AccCode,

	cr_acccode = A.QExp3_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE3 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCod
e=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE3 > 0 AND A.QE3_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE3_AccCode, A.QExp3_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.QE4_AccCode,

	cr_acccode = A.QExp4_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE4 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE4 > 0 AND A.QE4_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE4_AccCode, A.QExp4_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr
_acccode = A.QE5_AccCode,

	cr_acccode = A.QExp5_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.QE5 * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.QE5 > 0 AND A.QE5_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.QE5_AccCode, A.QExp5_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE1_AccCode,

	cr_acccode = A.WExp1_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecod
e= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE1 > 0 AND A.WE1_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE1_AccCode, A.WExp1_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE2_AccCode,

	cr_acccode = A.WExp2_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AN
D D.WE2 > 0 AND A.WE2_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE2_AccCode, A.WExp2_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE3_AccCode,

	cr_acccode = A.WExp3_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE3 > 0 AND A.WE3_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE3_AccCode, A.WExp3_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE4_AccCode,

	cr_acccode = A.WExp4_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null TH
EN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE4 > 0 AND A.WE4_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE4_AccCode, A.WExp4_CrAccCode

UNION ALL     /* item receipt expenses */

SELECT  documentcode = A.ReceiptInvCode, documenttype = 'RCT', catcode = A.ReceiptCategoryCode,

	dr_acccode = A.WE5_AccCode,

	cr_acccode = A.WExp5_CrAccCode,

	AlternateAccCode = Null,

	Date    = A.postdate,

	SaleTax=0,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * D.Qty), 2), 0), 

	dr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	cr_remarks = CASE WHEN A.remarks is null THEN 'Item Receipt Exp. payable on Inv #: ' + LTRIM(RTRIM(STR(A.ReceiptInvCode))) ELSE A.remarks END,

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.SalesmanCode, vouchercode= A.ReceiptCode, invoicecode= A.ReceiptInvCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCo
de = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM ReceiptHeader A, ReceiptDetail D

WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND

	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE5 > 0 AND A.WE5_AccCode > 0

GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE5_AccCode, A.WExp5_CrAccCode



TRUNCATE TABLE #lsl
ALTER PROCEDURE DBO.SP_VirtualGL_SaleOrder

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



CREATE TABLE #lt_saleorder (code INT NOT NULL)



INSERT INTO VirtualGLTemp	/*Accounting Advance on Sales Order */

SELECT  documentcode = S.saleordercode, documenttype    = 'SO', catcode = 1,

	dr_acccode = S.PaymentAccCode, cr_acccode = S.custcode, AlternateAccCode = Null,

	Date    = S.AmtDate, SaleTax= 0, 

	Gross= S.Amt,

	dr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	cr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	saletax_remarks= NULL, CheckNo = S.AmtReference, UserCode= S.AmtBy, vouchercode= S.SaleOrdercode,

	invoicecode= S.SaleOrderCode, invoicetype = NULL, Amt = 0, DrAmtAccCode = NULL,

	CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0, PatientCode= S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, Guestcode=NuLL, Studentcode=NuLL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM    SaleOrderHeader S

WHERE   S.SaleOrderCode IN (SELECT Code FROM #lt_saleorder)



TRUNCATE TABLE #lt_saleorder
ALTER  PROCEDURE DBO.SP_VirtualGL_Sales

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0),

	@ln_AdvIncomeTaxSale NUMERIC(5, 0), @ln_fbrposfeeacc NUMERIC(5,0)

DECLARE @SRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT, @AdvIncomeTax CHAR(1)



SET @AdvIncomeTax = ISNULL((SELECT a=DBO.Fn_GetPreference('ApplyAdvanceIncomeTaxInSale')), 'N')

SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')

SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')



SET @SRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSaleRemarksInLedger' ))



CREATE TABLE #lsl (code INT NOT NULL)



INSERT INTO #lsl

SELECT  SaleInvCode FROM SaleLedger S

WHERE S.Posted = 'Y'	 and S.AccountFor = 'Y' AND 

	S.SaleInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SV')



INSERT INTO VirtualGLTemp	/*accounting for sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Cred
it Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode  /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

			ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

				WHEN 1 THEN 'Cash receipt on sale #: ' 

				ELSE 'Receivable on cr. sale #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

			END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

			WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received' 

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash'

		ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode, 

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference, 

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.Admissi
onCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=ISNULL(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice), 0),

	S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END, S.FBRPosFee

FROM saleledger S, saledetail D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND

	S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges, 

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt, S.FBRPosFee



INSERT INTO VirtualGLTemp	/*accounting for sales having impactinventory='Y' and account for ='Y'*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */ 

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

		ELSE CA
SE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

			WHEN 1 THEN 'Cash receipt on sale #: ' ELSE 'Receivable on cr. sale #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

		END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

		WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received'

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode,

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END, S.FBRPosFee

FROM saleledger S, saleinvdetail D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges,

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTax
Amt, S.FBRPosFee



INSERT INTO VirtualGLTemp	/*accounting for sales receivable Adjustments made at the time of invoicing*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE WHEN D.Debit > 0 THEN AccCode ELSE S.CustCode END,

	cr_acccode = CASE WHEN D.Debit > 0 THEN S.CustCode ELSE AccCode END,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = D.CheckNo, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S, SaleReceivableAdj D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))), 

	cr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 s
tands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S

WHERE S.SaleCatCode NOT IN (1, 3) AND S.CashCharged > 0 AND 

	S.saleinvcode IN (SELECT Code FROM #lsl)

UNION ALL

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S, CashierWindow D

WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 



TRUNCATE TABLE #lsl
ALTER PROCEDURE DBO.SP_VirtualGL_SalesReturn

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



CREATE TABLE #lt_sret (code INT NOT NULL)

INSERT INTO #lt_sret

SELECT  SRInvCode FROM SRLedger S

WHERE S.posted = 'Y'	 and S.accountfor = 'Y' AND

	S.SRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SR')



INSERT INTO VirtualGLTemp	/*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srpr
ice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL, 
GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * CASE WHEN S.SaleInvCode > 0 THEN D.AvgPrice ELSE (D.SRPrice * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01)) END),0),

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00, FBRPosFee=0.00

FROM srledger S, srdetail D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00, FBRPosFee=0.00

FROM srledger S

WHERE S.SRCatCode NOT IN (6, 8
) AND S.CashCharged > 0 AND 

	S.srinvcode IN (SELECT Code FROM #lt_sret)

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00, FBRPosFee=0.00

FROM srledger S, MasterCashWin D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.DocumentCode



TRUNCATE TABLE #lt_sret
ALTER PROCEDURE DBO.SP_VirtualGL_Services

AS



SET NOCOUNT ON



DECLARE @revfromservice INT

DECLARE @SvcRemks CHAR(1), @SvcRRemks CHAR(1)



SET @revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')



SET @SvcRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRemarksInLedger' ))

SET @SvcRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRetRemarksInLedger' ))



CREATE TABLE #lt_service (code INT NOT NULL)

INSERT INTO #lt_service

SELECT  ServiceInvCode FROM ServiceHeader S

WHERE   S.ServiceInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RS') AND S.posted = 'Y'



CREATE TABLE #lt_serviceret (code INT NOT NULL)

INSERT INTO #lt_serviceret

SELECT  ServiceRInvCode FROM ServiceRHeader S

WHERE   S.ServiceRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'RR') AND S.posted = 'Y'



INSERT INTO VirtualGLTemp	/*accounting for sales of services*/

select  DocumentCode = h.serviceinvcode, 

	DocumentType = 'RS',

	catcode = h.ServiceCatCode,

	dr_acccode = h.custcode,

	cr_acccode = @revfromservice,

	AlternateAccCode = CASE WHEN h.ServiceCatCode = 10 THEN h.custcode WHEN h.ServiceCatCode = 12 THEN h.custcode ELSE NULL END,

	Date = h.date, 

	SaleTax = Round(

		ISNULL(Sum((D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = CASE @SvcRemks WHEN 'Y' THEN h.Remarks

		ELSE CASE h.ServiceCatCode WHEN 10 THEN 'Sale of Service on Inv. #: '

			WHEN 12 THEN 'Sale of Service on Inv. #: '

			ELSE 'Receivable on cr. s
ervice #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode)))+ 

			CASE WHEN h.saleinvcode is null Then '' 

			     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.saleinvcode))) END

		END,

	cr_remarks = CASE h.ServiceCatCode

			WHEN 10 THEN 'Revenue from cash service #: '

			ELSE 'Revenue from credit service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),

	saletax_remarks= 'Sales Tax Payable on Service Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),
	CheckNo = NULL, 

	UserCode=ISNULL(h.salesmancode, 0), vouchercode = h.serviceinvcode, invoicecode= h.serviceinvcode,

	invoicetype = 5 /* Service sales */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

from serviceheader h, servicedetail d

where h.serviceinvcode IN (SELECT Code FROM #lt_service) AND

	  h.serviceinvcode = d.serviceinvcode 

GROUP BY h.serviceinvcode, h.custcode, h.ServiceCatCode, h.cashacccode,

	 h.date, h.discperc, h.misccharges, h.flatdisc, h.serviceinvgstperc, h.salesmancode,

	 h.saleinvcode, h.patientcode, h.admissioncode, h.remarks, H.GuestCode, H.StudentCode



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.ServiceCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = NULL, Date    = S.date, SaleTax= 0,

	Gross =	CASE WHEN S.CashCharged > 0 THEN S.CashCharged ELSE 0 END,

	dr_remarks = 'Cash Rece
ived on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))), 

	cr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM serviceheader S

WHERE S.CashCharged > 0 AND S.serviceinvcode IN (SELECT Code FROM #lt_service)

UNION ALL

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.serviceCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = D.Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM serviceheader S, MasterCashWin D

WHERE S.service
invcode IN (SELECT Code FROM #lt_service) AND D.DocumentType = 'RS' AND S.serviceinvcode = D.documentcode 



INSERT INTO VirtualGLTemp	/*accounting for sales returns of services*/

select  DocumentCode = h.serviceRinvcode, 

	DocumentType = 'RR',

	catcode = h.ServiceRCatCode,

	dr_acccode = @revfromservice,

	cr_acccode = h.custcode,

	AlternateAccCode = Case h.ServiceRCatCode when 13 THEN h.custcode when 15 THEN h.custcode else NULL End,

	Date    = h.date, 

	SaleTax = 

		Round(

		ISNULL(Sum((D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross   = IsNull(Round(sum( d.qty * (isnull(d.ServicePrice - d.serviceflatdisc, 0)) * (1 - (.01 * isnull(d.discperc, 0)))) * 

		  (1- (.01 * h.discperc)) + isnull(h.misccharges,0) - isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Revenue (reversal) for ' + CASE h.ServiceRCatCode

		WHEN 13 THEN 'cash' WHEN 15 THEN 'cash' ELSE 'cr.' END + 

		' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

		CASE WHEN h.serviceinvcode is null Then '' 

		     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END,

	cr_remarks = CASE @SvcRRemks WHEN 'Y' THEN h.Remarks

			ELSE CASE h.ServiceRCatCode WHEN 13 THEN 'cash paid on'

				WHEN 15 THEN 'cash paid on' ELSE 'Payable on cr.' END + 

				' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

				CASE WHEN h.serviceinvcode is null Then '' 

				     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END

			END,

	saletax_remarks= 'Sales Tax Payable (Reveral) on Service Ret Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))),
	CheckNo = NULL, UserCode=h.salesmancode, vouchercode = h.serviceRinvcode,

	invoicecode= h.serviceRi
nvcode, invoicetype = 7 /* Service Return */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, 

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

from serviceRheader h, serviceRdetail d

where h.serviceRinvcode IN (SELECT Code FROM #lt_serviceret) AND

	 h.serviceRinvcode = d.serviceRinvcode 

GROUP BY h.serviceRinvcode, h.custcode, h.ServiceRCatCode, h.cashacccode, h.date, h.discperc, h.misccharges, 

	h.flatdisc, H.serviceinvgstperc, h.salesmancode, h.serviceinvcode, h.patientcode, h.admissioncode, h.Remarks, H.GuestCode, H.StudentCode



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during service return */

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.ServiceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN S.CashCharged > 0 THEN S.CashCharged ELSE 0 END,

	dr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))), 

	cr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.servicerinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.Admission
Code = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM servicerheader S

WHERE S.CashCharged > 0 AND S.serviceRinvcode IN (SELECT Code FROM #lt_serviceret)

UNION ALL

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.serviceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = D.Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceRinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM serviceRheader S, MasterCashWin D

WHERE S.serviceRinvcode IN (SELECT Code FROM #lt_serviceret) AND D.DocumentType = 'RR' AND S.serviceRinvcode = D.documentcode



DELETE VirtualGLTemp WHERE Gross = 0 AND Amt = 0 AND SaleTax=0 AND AdvIncomeTax=0.00



TRUNCATE TABLE #lt_service

TRUNCATE TABLE #lt_serviceret
ALTER PROCEDURE DBO.SP_VirtualGL_TransactionWindow

AS



SET NOCOUNT ON



CREATE TABLE #lt_transaction (code INT NOT NULL)

INSERT INTO #lt_transaction

SELECT T.DocumentCode

FROM TransactionHeader T

WHERE 

	T.DocumentCode NOT IN 

		(SELECT DISTINCT V.DocumentCode FROM VirtualGL V WHERE V.DocumentType IN (SELECT ShortName FROM TransactionType))



INSERT INTO VirtualGLTemp	/* accounting for cash received via transaction window */

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.CashAccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TD.AccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Recvd. Ag
ainst Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TH.CashAccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionType
Code AND

	TT.TransactionCatCode = 2

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TD.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'Y' AND

	TH.DocumentCode IN (SELECT Code FROM #lt_transaction) AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0



TRUNCATE TABLE #lt_transaction
tCode, DueDate, SRBufferInvCode, CustRefNo5, GCCode, GRN, SuppInvCode,  Vehicle, ShipTo, GuaranteePersonCode, CashTendered, CashCharged, CashBack, CashAccCode, CustLicNo, CustLicExpiry, ModuleId, DocCode=SaleInvCode, SaleTypeInvNo, CRS_Transfered, CRS_TransferedOn, GuestCode, GuestCheckInCode, StudentCode, CustSiteCode, Transmit, Transmited, Fiscalized, FiscalizedOn, FiscalInvoiceNo FROM SaleLedger '

END

IF @SaleType = 2

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_AdvSaleLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 2, * FROM AdvSaleLedger '

END

IF @SaleType = 3

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SRLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 3, SRInvCode,SaleInvCode,Date,SRCatCode,CustCode,SalesmanCode,DiscPerc,FlatDisc,MiscCharges,Posted,PostDate,Remarks,SalesTax,OriginalDate,ModifiedBy,PostedBy,HeaderNo,InvGSTPerc1,Smancode,CustRefno,CustRefno2,CustRefno3,CustRefno4,PatientCode,MachineName,HeaderInvNo,AdmissionCode,invtotal,AccountFor,PaymentMode,PaymentAccCode,Amt,AmtBY,AmtDate,AmtReference,OutstandingAmt,Marked,PageSize,ReprintingCounter,DoctCode,ConsiderInPO,CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSummary,CRS_Transfered,CRS_TransferedOn,GuestCode,GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,FiscalizedOn,FiscalInvoiceNo,Transmit,Transmited FROM SRLedger '

END



IF @CustCode IS NULL

BEGIN

	SET @WHR = N' WHERE Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39)

END

ELSE

BEGIN

	SET @WHR = N' WHERE CustCode = ' + (SELECT LTRIM(RTRIM(STR(@CustCode, 8)))) + ' AND Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = 
r S

WHERE S.Posted = 'N' AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.ServicePurInvCode, documenttype = 'SP', catcode = 1,

	dr_acccode = S.SuppCode, cr_acccode = D.AccCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePurInvCode, invoicecode= S.ServicePurInvCode,

	invoicetype = 6, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

FROM servicePurheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'SP' AND S.ServicePurInvCode = D.documentcode 

UNION ALL /*accounting for Purchase of services*/

select  DocumentCode = h.ServicePurInvCode, DocumentType = 'RP', catcode = 1,

	dr_acccode = h.SuppCode, cr_acccode = @ln_exponsvc, AlternateAccCode = NULL,

	Date = h.date, SaleTax = 0,

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	cr_remarks = 'Services P/R Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePrInvCode))) + CASE WHEN h.ServicePurInvCode > 0 THEN ', Against Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.ServicePurInvCode))) ELSE '' END,

	saletax_remarks= '', CheckNo = NULL, UserCode=ISNULL(h.UserCode, 0), 

	vouchercode = h.ServicePrInvCode, invoicecode= h.ServicePrInvCode,

	invoicetype = 8, Amt =  0, DrAmtAccCod
ALTER FUNCTION DBO.Fn_GetUnposted_Adjustment()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_invacc INT, @ln_cgs INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT

DECLARE @SRemks CHAR(1), @InvSys CHAR(1)



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')




INSERT INTO @retTable

SELECT  documentcode = A.AdjCode, 

	documenttype = CASE A.AdjCatCode WHEN 1 THEN 'AI' ELSE 'AD' END, 

	catcode = A.AdjCatCode,

	dr_acccode = CASE A.AdjCatCode WHEN 1 THEN @ln_invacc ELSE A.AccCode END,

	cr_acccode = CASE A.AdjCatCode WHEN 1 THEN A.AccCode ELSE @ln_invacc  END,

	AlternateAccCode = Null,

	Date    = A.date,

	SaleTax=0,

	Gross=Round(SUM(D.looseqty * D.Price), 0),

	dr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	cr_remarks = CASE A.AdjCatCode WHEN 1 THEN 'Stock Adjustment Increase # ' ELSE 'Stock Adjustment Decrease # ' END + LTRIM(RTRIM(STR(A.AdjCode))),

	saletax_remarks= '',
	CheckNo = NULL, 

	UserCode= A.UserCode, vouchercode= A.AdjCode, invoicecode= A.AdjCode,

	invoicetype = NULL,

	Amt = 0,

	DrAmtAccCode = NULL, CrAmtAccCode = NULL, 

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0,

	PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM AdjHeader A, AdjDetail D

WHERE A.Posted='N' AND A.AdjCode = D.AdjCode AND A.AccCode IS NOT NULL

GROUP BY A.AdjCode, A.AccCode, A.AdjCatCode, A.Date, A.UserCode, A.Remarks



RETURN

END
ALTER  PROCEDURE DBO.SP_VirtualGL @ac_type CHAR(1)

AS



SET NOCOUNT ON

TRUNCATE TABLE VirtualGLTemp

DECLARE @rc int

SET @rc = (SELECT COUNT(*) FROM VirtualGL (TABLOCKX))



IF UPPER(@ac_type) IS NULL 

	SET @ac_type = 'A'



IF UPPER(@ac_type) <> 'S' AND UPPER(@ac_type) <> 'A' 

	SET @ac_type = 'A'



DECLARE @goodsacc smallint, @goodsissueacc smallint, @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), 

	@ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_salestaxonsvc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0), @ln_AdvIncomeTaxSale NUMERIC(5, 0), @ln_fbrposfeeacc NUMERIC(5,0)

DECLARE @InvSys CHAR(1)



SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @goodsissueacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 31)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT 
code FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')

SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')



BEGIN TRANSACTION T1



IF @ac_type <> 'C'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Purchase

	EXECUTE DBO.SP_VirtualGL_PurchaseReturn

	EXECUTE DBO.SP_VirtualGL_PurchaseServices

END



IF @ac_type <> 'S'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Sales

	EXECUTE DBO.SP_VirtualGL_SalesReturn

	EXECUTE DBO.SP_VirtualGL_Services

	EXECUTE DBO.SP_VirtualGL_SaleOrder

END



EXECUTE DBO.SP_VirtualGL_Receipt

EXECUTE DBO.SP_VirtualGL_Issue

EXECUTE DBO.SP_VirtualGL_Adjustment

EXECUTE DBO.SP_VirtualGL_Guest

EXECUTE DBO.SP_VirtualGL_Patient

EXECUTE DBO.SP_VirtualGL_Vouchers

EXECUTE DBO.SP_VirtualGL_Notes

EXECUTE DBO.SP_VirtualGL_TransactionWindow

EXECUTE DBO.SP_VirtualGL_Payroll



INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE WHEN dr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 

			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From Vi
rtualGLTemp

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	AlternateAccCode = CASE WHEN cr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= C
ASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  FBR POS FEE For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_fbrposfeeacc ELSE @ln_fbrposfeeacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'SR' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	SaleTax_Remarks='FBR POS Service Fee Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR') AND ISNULL(FBRPosFee, 0) <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		WHEN 'SR' THEN 	'Paid during s/return no.' ELSE DR_Remarks END+ ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCC
ode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		WHEN 'SR' THEN 'Paid during s/return no.' ELSE CR_Remarks END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit = 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R In
ALTER PROCEDURE dbo.SP_Transmit_ChildServerSales

	@CustCode INT,

	@StartDate DATETIME,

	@EndDate DATETIME,

	@SRV VARCHAR(255), 

	@PARENTSRV VARCHAR(255), 

	@DB VARCHAR(50), 

	@OWNER VARCHAR(20),

	@SaleType INT

AS



SET XACT_ABORT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



/* Variables to be used in import process */

DECLARE @INS VARCHAR(4000), @SQL VARCHAR(4000), @WHR VARCHAR(4000), @WHR_Cln VARCHAR(4000), @Query VARCHAR(4000), @stdate VARCHAR(100), @edate VARCHAR(100)

DECLARE @err INT, @rt_code INT

DECLARE @dt DATETIME



SET @stdate = (SELECT CONVERT(VARCHAR(100), @StartDate, 110) + ' ' + CONVERT(VARCHAR(100), @StartDate, 114))

SET @edate  = (SELECT CONVERT(VARCHAR(100), @EndDate, 110)   + ' ' + CONVERT(VARCHAR(100), @EndDate  , 114))



IF @SaleType = 1

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SaleLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 1, SaleInvCode, SaleCatCode , CustCode , SalesmanCode, date, DiscPerc, FlatDisc, MiscCharges, SalesTax, Posted, PostDate, Remarks, CustRefNo, headerno, headerinvno, OriginalDate, ModifiedBy, PostedBy, SPrice, QuotationNo, DoctCode, PatientCode, RePrintingCounter, CashReceived, InvGSTPerc1, PrintWaranty, PrintBatch, MessageCode, SManCode, InvoiceSize, CustRefno2, CustRefno3, CustRefno4, GSTNO, InvTotal, MachineName, ModifyCounter, itemdiscpercno, RelationCode, DiseaseCode, WardCode, AdmissionCode, ReturnCounter, Paid, BillingDate, UnReceivedBalance, TotalOfSaleReturns, ListOfSrInvoices, printbalance, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt, Marked, Transferable, Transfered, TransferedOn, TransferedBy, Imported, ImportedBy, deliveredby, SaleTypeCode, Balance, PptCustCode, DELETED, PresCode, ImpactInventory, SaleOrderCode, SaleComments1, SaleComments2, AlterSaleInvCode, RecurringInvoice, RecurringPeriod, LastRecurringInvCode, RecurringAgainst, ConsiderInPO, Visi
ALTER PROCEDURE DBO.SP_DeletePostedTransactions

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

SELECT 90, 'TRUNCATE TABLE ', 'ImpPurDetail'

UNION ALL

SELECT 100, 'TRUNCATE TABLE ', 'PurRegisterDetail'

UNION ALL

SELECT 110, 'TRUNCATE TABLE ', 'PrDetail'

UNION ALL

SELECT 120, 'TRUNCATE TABLE ', 'PrAllocationDetail'

UNION ALL

SELECT 130, 'DELETE ', '
ALTER FUNCTION DBO.Fn_GetUnposted_Purchase ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT,  @ln_invacc INT,

	@ln_salestaxacc INT, @ln_purexpacc INT



DECLARE @PRemks CHAR(1), @ReportPurOnPostDate CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELEC
T code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_purexpacc = (SELECT code FROM global WHERE name = 'GT_PurExpPayableAcc')



SET @PRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPurRemarksInLedger' ))

SET @ReportPurOnPostDate = (SELECT a=DBO.Fn_GetPreference( 'reportpurchaseonpostingdate' ))



IF @ReportPurOnPostDate IS NULL

	SET @ReportPurOnPostDate = 'Y'



INSERT INTO @retTable /*accounting for purchases*/ 

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((
SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode

				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN P.AdvanceTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END, FBRPOSFee=0.00

FROM purledger P, purdetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,

	P.AmtBy, P.AmtDate, P.Amt
Reference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor,

	P.AdvanceTax, P.AdvanceTaxAmt

UNION ALL				/* ImpactInventory = 'N' i.e. Accounted For Proforma Purcahses  */

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseacc ELSE @ln_invacc END,

	cr_acccode = CASE P.PurCatCode

		WHEN 3 THEN @ln_equityacc   /*Opening Purchase*/ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /*Credit Purhase*/ END,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=CASE P.UpdateAvgPriceWithNetRate 

		WHEN  'N' THEN 

			ROUND(

			SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

			SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

			ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

				(P.invgstperc1 * .01), 2), @RoundUpTo) 

		ELSE 0.00 END,

	Gross=  CASE P.UpdateAvgPriceWithNetRate 

			WHEN 'N' THEN

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo)

			ELSE

				ROUND(SUM((D.looseqty + D.packqty) * D.purprice * 

				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

				P.misccharges + P.salestax - P.flatdisc, @RoundUpTo) + 

				ROUND(

				SUM((D.looseqty + D.packqty + D.bonusqty) * D.unitsalestax) +

				SUM(ROUND((D.looseqty + D.packqty) * D.purprice * 

					(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

				ROUND((SUM(((D.looseqty + D.packqty) * D.purprice) * 

					(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) - P.flatdisc) * 

					(P.invgstperc1 * .01), 2), @RoundUpTo) 

			END,

	dr_remarks = 'Stock accounted for ' + CASE P.PurCatCode


				WHEN 3 THEN 'open.' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

				ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),

	cr_remarks = 

			CASE @PRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.suppinvcode WHEN NULL THEN 

				CASE P.PurCatCode

				WHEN 3 THEN 'Opening Purchase #: '

				WHEN 7 THEN 'Payable on loose purchase #: '

				WHEN 8 THEN 'Payable on loose purchase #: '

				ELSE 	    'Payable on pack purchase #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) ELSE 'Supp. Inv. # : ' + LTRIM(RTRIM(P.suppinvcode)) + ', Date : ' + LTRIM(RTRIM( convert(varchar(12), P.suppinvdate, 103))) END

			END,

	saletax_remarks= 'S.Tax payable on ' + 

			CASE P.PurCatCode WHEN 3 THEN 'open' WHEN 7 THEN 'loose' WHEN 8 THEN 'loose'

			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = P.Amt, DrAmtAccCode = P.suppcode, CrAmtAccCode = P.PaymentAccCode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = CASE WHEN P.AdvanceTax = 'Y' THEN ISNULL(P.AdvanceTaxAmt,0) ELSE 0 END, FBRPOSFee=0.00

FROM purledger P, ProformaPurdetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND P.purinvcode = D.purinvcode 

GROUP BY P.purinvcode, P.suppcode, P.CustCode, P.purcatcode, P.Date, P.postdate, P.discperc, P.misccharges,

	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,
	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,

	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor,

	P.AdvanceTax, P.AdvanceTaxAmt

UNION ALL   /*Purch
ase Expenses treatment*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = PE.AccCode,

	cr_acccode = @ln_purexpacc,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= PE.Amount,

	dr_remarks = CASE WHEN LEN(PE.Remarks) > 0 THEN PE.Remarks ELSE 'Purchase Expenses on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=PE.AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurExp PE

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = PE.PurInvCode AND PE.Amount > 0

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE1_AccCode,

	cr_acccode = P.QExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE1 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCod
e = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE1 > 0 AND P.QE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE1_AccCode, P.QExp1_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE2_AccCode,

	cr_acccode = P.QExp2_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE2 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE2 > 0 AND P.QE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE2
_AccCode, P.QExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE3_AccCode,

	cr_acccode = P.QExp3_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE3 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE3 > 0 AND P.QE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE3_AccCode, P.QExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE4_AccCode,

	cr_acccode = P.QExp4_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE4 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),


	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE4 > 0 AND P.QE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE4_AccCode, P.QExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Pur Exp*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.QE5_AccCode,

	cr_acccode = P.QExp5_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.QE5 * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.QE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAm
t = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.QE5 > 0 AND P.QE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.QE5_AccCode, P.QExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 1*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE1_AccCode,

	cr_acccode = P.WExp1_CrAccCode,

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE1 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE1_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE1 > 0 AND P.WE1_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE1_AccCode, P.WExp1_CrAccCode, P.Remarks, P.salesm
ancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 2*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE2_AccCode,

	cr_acccode = P.WExp2_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE2 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE2_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE2 > 0 AND P.WE2_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE2_AccCode, P.WExp2_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 3*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE3_AccCode,

	cr_acccode = P.WExp3_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0)
,

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE3_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE3 > 0 AND P.WE3_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE3_AccCode, P.WExp3_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 4*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE4_AccCode,

	cr_acccode = P.WExp4_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE4 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE4_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, Amt
Ref = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE4 > 0 AND P.WE4_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE4_AccCode, P.WExp4_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

UNION ALL   /*Item Weight Pur Exp 5*/

SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,

	dr_acccode = P.WE5_AccCode,

	cr_acccode = P.WExp5_CrAccCode, 

	AlternateAccCode = Null,

	date    = CASE @ReportPurOnPostDate WHEN 'Y' THEN P.postdate ELSE P.Date END,

	SaleTax=0.00,

	Gross= ISNULL(Round(SUM(D.WE5 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),

	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,

	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE5_AccCode) + ' Payable',

	saletax_remarks= NULL,
	CheckNo = NULL,

	usercode= P.salesmancode, vouchercode= P.purinvcode, invoicecode= P.purinvcode,

	invoicetype = 2 /*2 stands for purchase*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL,

	AmtBy = NULL, AmtDate = NULL, AmtRef = NULL,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM PurLedger P, PurDetail D

WHERE P.Posted = 'N' AND P.AccountFor = 'Y' AND 

	P.PurInvCode = D.PurInvCode AND 

	D.WE5 > 0 AND P.WE5_AccCode > 0

GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_Cr
AccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor



RETURN

END
e = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = h.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

from serviceprheader h, serviceprdetail d

where H.Posted = 'N' AND h.ServicePrInvCode = d.ServicePrInvCode

GROUP BY h.ServicePrInvCode, h.ServicePurInvCode, h.suppcode, h.date, h.discperc, h.misccharges, h.flatdisc, h.usercode, h.OutStandingAmt, h.remarks

UNION ALL /*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.ServicePrInvCode , documenttype    = 'RP', catcode = 1,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.SuppCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	cr_remarks = 'Cash Received for Services P/R Inv. #: ' + LTRIM(RTRIM(STR(S.ServicePrInvCode, 10))) + CASE WHEN S.ServicePurInvCode > 0 THEN ', Ref. Pur. # :' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.ServicePurInvCode))) ELSE '' END, 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.UserCode, vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0,

	PatientCode=NULL, GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, 

	GuestCode = NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

FROM ServicePrHeader S

WHERE S.Posted = 'N' AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.ServicePrInvCode, documenttype = 'RP', catcode = 1,

	dr_acccode = D.AccCode
, cr_acccode = S.SuppCode, AlternateAccCode = Null, 

	Date = S.date, SaleTax= 0, Gross = Amount, dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, UserCode= S.UserCode, 

	vouchercode= S.ServicePrInvCode, invoicecode= S.ServicePrInvCode,

	invoicetype = 8, Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, 

	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = S.OutStandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

FROM servicePrheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'RP' AND S.ServicePurInvCode = D.documentcode 

RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_PurchaseReturn ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT, @ln_invacc INT



DECLARE @PRRemks CHAR(1), @InvSys CHAR(1), @RoundUpTo TINYINT



SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))





SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_Purcha
seReturnsAccount')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @PRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for purchase returns*/ 

SELECT  documentcode = P.prinvcode, documenttype    = 'PR', catcode = P.PRCatCode,

	dr_acccode = CASE P.PRCatCode WHEN 6 THEN @ln_equityacc /* Opening P/RETURN */ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /* Cash/Credit P/RETURN */ END,

	cr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseretacc ELSE @ln_invacc END,

	AlternateAccCode = Null,

 	date    = P.date,

	SaleTax= ROUND(

		SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +

		SUM(ROUND(D.looseqty * D.prprice * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND((SUM((D.looseqty * D.prprice) * 

			(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -

			P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo),

	Gross= ROUND(SUM((D.looseqty * D.prprice) * (1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) + 

			P.misccharges + P.salestax - P.flatdisc, @RoundUpTo),

	dr_remarks = CASE @PRRemks WHEN 'Y' THEN P.Remarks

			ELSE CASE P.PrCatCode

				WHEN 6 THEN 'Open' ELSE 'Receivable on ' END + ' pur. return #: ' +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))) 

			END,

	cr_remarks = 'Stock returned on ' + CASE P.PrCatCode WHEN 6 THEN 'open' ELSE '' END +

		' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),

	saletax_remarks= 'S.Tax receivable on ' + 

			CASE P.PrCatCode WHEN 6 THEN 'open' ELSE ':' END + 

			' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),
	CheckNo = NULL, 

	UserCode = P.salesmancode, vouchercode=P.prinvcode, invoicecode=P.prinvcode,

	invoicetype = 4 /*4 stands for purchase return*/,

	Amt = P.Amt, DrAmtAccCode = P.PaymentAccCode, CrAmtAccCode = P.suppcode,

	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,

	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,

	GRN = NUL
L, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,

	AdvIncomeTax=0.00, FBRPOSFee=0.00

FROM  prledger P, prdetail D

WHERE P.posted = 'N' and P.accountfor = 'Y' AND P.prinvcode = D.prinvcode

GROUP BY P.prinvcode, P.suppcode, P.CustCode, P.prcatcode, P.date, P.discperc, P.misccharges, 

	P.salestax, P.flatdisc, P.invgstperc1, P.salesmancode, P.Amt, P.PaymentAccCode, 

	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.Remarks



RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_SaleOrder()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15,2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



INSERT INTO @retTable /*accounting for sale order*/

SELECT  documentcode = S.saleordercode, documenttype    = 'SO', catcode = 1,

	dr_acccode = S.PaymentAccCode, cr_acccode = S.custcode, AlternateAccCode = Null,

	Dat
e    = S.AmtDate, SaleTax= 0, 

	Gross= S.Amt,

	dr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	cr_remarks = 'Advance received on sale order #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleordercode))),

	saletax_remarks= NULL, CheckNo = S.AmtReference, UserCode= S.AmtBy, vouchercode= S.SaleOrdercode,

	invoicecode= S.SaleOrderCode, invoicetype = NULL, Amt = 0, DrAmtAccCode = NULL,

	CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, AmtRef = NULL, 

	OutstandingAmt = 0, Balance = 0, PatientCode= S.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, Guestcode=NuLL, Studentcode=NuLL,

	CGS=0, CurrencyCode = NULL, ConversionRate = NULL,

	AdvIncomeTax = 0.00, FBRPOSFee=0.00

FROM    SaleOrderHeader S

WHERE   S.Posted = 'N' AND S.Amt <> 0 AND S.AmtDate IS NOT NULL

RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_Sales ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT, 

	@ln_invacc INT, @ln_cgs INT, @ln_fbrposfeeacc NUMERIC(5,0)

DECLARE @SRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM glob
al WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')



SET @SRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSaleRemarksInLedger' ))



INSERT INTO @retTable	/*accounting for sales*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode  /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

			ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

				WHEN 1 THEN 'Cash receipt on sale #: ' 

				ELSE 'Receivable on cr. sale #: ' END +

				RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

			END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

			WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received' 

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash'

		ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.salein
vcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode, 

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference, 

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.LooseQty + D.BonusQty) * D.AvgPrice), 0), S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN S.AdvanceTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END, S.FBRPosFee

FROM saleledger S, saledetail D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges, 

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate,

	S.AdvanceTax, S.AdvanceTaxAmt, S.FBRPosFee

UNION ALL /*accounting for sales having impactinventory='Y' and account for ='Y'*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */ 

		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,

	cr_acccode = @ln_salesacc,

	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode /* Cash Sale */

		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,

	Date    = S.date,

	SaleTax=Round(

	SUM( (D.looseqty + D.bonusqt
y) * D.unitsalestax) + 

	SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

	ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *

		(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -

		S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross=Round(

	SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 

		S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = CASE @SRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SaleCatCode WHEN 3 THEN 'Cash receipt on sale #: '

			WHEN 1 THEN 'Cash receipt on sale #: ' ELSE 'Receivable on cr. sale #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) 

		END,

	cr_remarks = 'Revenue from ' + CASE S.SaleCatCode WHEN 3 THEN 'cash' 

		WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),

	saletax_remarks= 'S.Tax ' + CASE S.SaleCatCode WHEN 3 THEN 'received'

		WHEN 1 THEN 'received' ELSE 'receivable' END + ' on ' + 

		CASE S.SaleCatCode WHEN 3 THEN 'cash' WHEN 1 THEN 'cash' ELSE 'cr.' END + ' sale #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),
	CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = CASE S.SaleCatCode WHEN 2 THEN S.Amt ELSE 0 END,

	DrAmtAccCode = S.PaymentAccCode, CrAmtAccCode = S.Custcode,

	AmtBy = S.AmtBy, AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = CASE WHEN S.AdvanceTax = 'Y' THEN ISNULL(S.Advanc
eTaxAmt,0) ELSE 0 END, S.FBRPosFee

FROM saleledger S, saleinvdetail D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges,

	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,

	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,

	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate,

	S.AdvanceTax, S.AdvanceTaxAmt, S.FBRPosFee

UNION ALL /*accounting for sales receivable Adjustments made at the time of invoicing*/

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = CASE WHEN D.Debit > 0 THEN AccCode ELSE S.CustCode END,

	cr_acccode = CASE WHEN D.Debit > 0 THEN S.CustCode ELSE AccCode END,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = CASE WHEN D.Debit > 0 THEN D.Debit ELSE D.Credit END,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = D.CheckNo, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S, SaleReceivableAdj D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 

UNION ALL /*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.sale
invcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))), 

	cr_remarks = 'Cash Received on Sale Inv. No.' + LTRIM(RTRIM(STR(S.SaleInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.SaleCatCode <> 3 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.saleinvcode, invoicecode= S.saleinvcode,

	invoicetype = 1 /*1 stands for sales*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientC
ode END,

	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM saleledger S, CashierWindow D

WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode



RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_SalesReturn ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT,

	@ln_invacc INT, @ln_cgs INT



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT
_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTRI
M(LTRIM(CONVERT(VARCHAR(12), S.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * D.AvgPrice),0), S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM srledger S, srdetail D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate

UNION ALL /*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.sr
invcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM srledger S

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.SRCatCode <> 8 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM srledger S, MasterCashWin D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.DocumentCode



RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_Services ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT



DECLARE @SvcRemks CHAR(1), @SvcRRemks CHAR(1)



SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SvcRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRemarksInLedger' ))

SET @SvcRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSvcRetRemarksInLedger' ))



INSERT I
NTO @retTable /*accounting for sales of services*/

select  DocumentCode = h.serviceinvcode, 

	DocumentType = 'RS',

	catcode = h.ServiceCatCode,

	dr_acccode = Case h.ServiceCatCode when 10 THEN h.CashAccCode when 12 THEN h.CashAccCode else h.custcode End,

	cr_acccode = @ln_revfromservice,

	AlternateAccCode = CASE h.ServiceCatCode WHEN 10 THEN h.custcode /* Cash Sale Service*/ 

		WHEN 12 THEN h.custcode /* Cash Sale Service*/ ELSE NULL /* Credit Sale Service*/ END,

	Date = h.date, 

	SaleTax = Round(

		ISNULL(Sum((D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.Price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinvgstperc, 2),0)

		,0),

	Gross = IsNull(Round(sum( (d.qty * isnull(d.price - d.serviceflatdisc, 0)) * 

		(1 - (.01 * isnull(d.discperc, 0)))) * 

		(1 - (.01 * ISNULL(h.discperc, 0))) + isnull(h.misccharges,0) - 

		isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = CASE @SvcRemks WHEN 'Y' THEN h.Remarks

		ELSE CASE h.ServiceCatCode WHEN 10 THEN 'Cash receipt on service sale #: '

			WHEN 12 THEN 'Cash receipt on service sale #: '

			ELSE 'Receivable on cr. service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode)))+ 

			CASE WHEN h.saleinvcode is null Then '' 

			     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.saleinvcode))) END

		END,

	cr_remarks = CASE h.ServiceCatCode

			WHEN 6 THEN 'Revenue from cash service #: '

			ELSE 'Revenue from credit service #: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),

	saletax_remarks= 'Sales Tax Payable on Service Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),
	CheckNo = NULL, 

	UserCode=ISNULL(h.salesmancode, 0), vouchercode = h.serviceinvcode, invoicecode= h.serviceinvcode,

	invoicetype = 5 /* Service sales */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,

	AmtDate =
 NULL, AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

from serviceheader h, servicedetail d

where h.Posted ='N' AND h.serviceinvcode = d.serviceinvcode 

GROUP BY h.serviceinvcode, h.custcode, h.ServiceCatCode, h.cashacccode,

	 h.date, h.discperc, h.misccharges, h.flatdisc, h.serviceinvgstperc, h.salesmancode,

	 h.saleinvcode, h.patientcode, h.admissioncode, h.remarks, H.GuestCode, H.StudentCode

UNION ALL /*accounting for cash received via master cash window during service sales*/

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.ServiceCatCode,

	dr_acccode = S.CashAccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))), 

	cr_remarks = 'Cash Received on Service Inv. No.' + LTRIM(RTRIM(STR(S.ServiceInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL
, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM serviceheader S

WHERE S.Posted ='N' AND S.ServiceCatCode <> 10 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.serviceinvcode, documenttype    = 'RS', catcode = S.serviceCatCode,

	dr_acccode = D.AccCode,

	cr_acccode = S.CustCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceinvcode, invoicecode= S.serviceinvcode,

	invoicetype = 5,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM serviceheader S, MasterCashWin D

WHERE S.Posted = 'N' AND D.DocumentType = 'RS' AND S.serviceinvcode = D.documentcode 

UNION ALL /*accounting for sales returns of services*/

select  DocumentCode = h.serviceRinvcode, 

	DocumentType = 'RR',

	catcode = h.ServiceRCatCode,

	dr_acccode = @ln_revfromservice,

	cr_acccode = Case h.ServiceRCatCode when 13 THEN h.cashacccode when 15 THEN h.cashacccode else h.custcode End,

	AlternateAccCode = Case h.ServiceRCatCode when 13 THEN h.custcode when 15 THEN h.custcode else NULL End,

	Date    = h.date, 

	SaleTax = 

		Round(

		ISNULL(Sum((D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01 * D.servicegstPerc), 0) +

		ISNULL(Sum(D.qty * D.serviceflattax), 0) +

		ISNULL(Round((Sum(D.qty * (D.serviceprice - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc ) * 0.01 * H.serviceinv
gstperc, 2),0)

		,0),

	Gross   = IsNull(Round(sum( d.qty * (isnull(d.ServicePrice - d.serviceflatdisc, 0)) * (1 - (.01 * isnull(d.discperc, 0)))) * 

		  (1- (.01 * h.discperc)) + isnull(h.misccharges,0) - isnull(h.flatdisc, 0), 0), 0),

	dr_remarks = 'Revenue (reversal) for ' + CASE h.ServiceRCatCode

		WHEN 13 THEN 'cash' WHEN 15 THEN 'cash' ELSE 'cr.' END + 

		' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

		CASE WHEN h.serviceinvcode is null Then '' 

		     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END,

	cr_remarks = CASE @SvcRRemks WHEN 'Y' THEN h.Remarks

			ELSE CASE h.ServiceRCatCode WHEN 13 THEN 'cash paid on'

				WHEN 15 THEN 'cash paid on' ELSE 'Payable on cr.' END + 

				' service return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))) + 

				CASE WHEN h.serviceinvcode is null Then '' 

				     ELSE ', service #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))) END

			END,

	saletax_remarks= 'Sales Tax Payable (Reveral) on Service Ret Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))),
	CheckNo = NULL, UserCode=h.salesmancode, vouchercode = h.serviceRinvcode,

	invoicecode= h.serviceRinvcode, invoicetype = 7 /* Service Return */,

	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL, 

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN h.PatientCode IS NULL THEN 

			CASE WHEN h.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE h.AdmissionCode = A.AdmissionCode)

			END

		ELSE h.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = H.GuestCode, StudentCode=H.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

from serviceRheader h, serviceRdetail d

where h.Posted ='N' AND h.serviceRinvcode = d.serviceRinvcode 

GROUP BY h.serviceRinvcode, h.custcode, h.ServiceRCatCode, h.cashacccode, h.date, h.disc
perc, h.misccharges, 

	h.flatdisc, H.serviceinvgstperc, h.salesmancode, h.serviceinvcode, h.patientcode, h.admissioncode, h.Remarks, H.GuestCode, H.StudentCode

UNION ALL /*accounting for cash received via master cash window during service return */

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.ServiceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))), 

	cr_remarks = 'Cash paid on Service Ret. No.' + LTRIM(RTRIM(STR(S.ServiceRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.servicerinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM servicerheader S

WHERE S.Posted ='N' AND S.ServiceRCatCode <> 13 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.serviceRinvcode, documenttype    = 'RR', catcode = S.serviceRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.serviceRinvcode, invoicecode= S.serviceRinvcode,

	invoicetype = 7,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, Outstandin
gAmt = 0, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode = S.GuestCode, StudentCode=S.StudentCode,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM serviceRheader S, MasterCashWin D

WHERE S.Posted ='N' AND D.DocumentType = 'RR' AND S.serviceRinvcode = D.documentcode

RETURN

END
ALTER FUNCTION DBO.Fn_GetUnposted_TransWindow ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



INSERT INTO @retTable /* accounting for cash received via transaction window */

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.CashAccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, Outst
andingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TD.AccCode,

	cr_acccode = TH.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Recvd. Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 1 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TH.CashAccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TH.CashCharged,

	dr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Cash Paid A
gainst Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionType TT

WHERE TH.CashCharged > 0 AND TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2

UNION ALL

SELECT  

	documentcode = TH.documentcode, 

	documenttype    = TT.ShortName, 

	catcode = TH.TransactionTypeCode,

	dr_acccode = TH.AccCode,

	cr_acccode = TD.AccCode,

	AlternateAccCode = Null, Date    = TH.date, SaleTax= 0,

	Gross = TD.Amount,

	dr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	cr_remarks = 'Amount Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= TH.usercode, vouchercode= TH.TransactionCode, invoicecode= TH.TransactionCode,

	invoicetype = NULL,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,

	PatientCode=TH.PatientCode,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL,

	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM TransactionHeader TH, TransactionDetail TD, TransactionType TT

WHERE 

	TH.Posted = 'N' AND

	TH.TransactionTypeCode = TT.TransactionTypeCode AND

	TT.TransactionCatCode = 2 AND

	TH.DocumentCode = TD.DocumentCode AND

	TD.Amount > 0

RETURN

END
ALTER  FUNCTION DBO.Fn_GetUnposted_AccTrans()

RETURNS @retTable TABLE (

DocumentCode INT NOT NULL,

DocumentType VARCHAR (20)  NOT NULL,

AccCode SMALLINT NOT NULL,

CatCode TINYINT NOT NULL,

AlternateAccCode SMALLINT NULL,

Debit NUMERIC(15, 2) NOT NULL,

Credit NUMERIC(15, 2) NOT NULL,

Date DATETIME NOT NULL,

CheckNo VARCHAR (20)  NULL,

Remarks VARCHAR (100)  NULL,

UserCode SMALLINT NOT NULL,

PatientCode INT NULL,

VoucherCode INT NULL,

INVOICECODE INT NULL,

OUTSTANDINGAMT NUMERIC(15, 2) NOT NULL,

BALANCE NUMERIC(15, 2) NOT NULL,

InvoiceType TINYINT NULL,

VRow TINYINT NOT NULL,

GRN VARCHAR (100)  NULL,

GCCode SMALLINT NULL,

Vehicle VARCHAR (100)  NULL,

ShipTo VARCHAR (100)  NULL,

GuestCode INT NULL,

StudentCode INT NULL,

CGS NUMERIC(15, 2) NOT NULL,

CurrencyCode SMALLINT NULL, 

ConversionRate NUMERIC(11,5) NULL

)

AS

BEGIN



DECLARE @UPTrans TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)



DE
CLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT,

	@ln_salesacc INT, @ln_salesretacc INT, @ln_purchaseretacc INT,

	@ln_revfromservice INT, @ln_salestaxacc INT, @ln_invacc INT, @ln_cgs INT, @ln_salestaxonsvc INT,

	@ln_AdvIncomeTaxPur INT, @ln_AdvIncomeTaxSale INT, @ln_fbrposfeeacc NUMERIC(5,0)

DECLARE @InvSys CHAR(1)



SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')

SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')



INSERT INTO @UPTrans 

SELECT * FROM dbo.Fn_GetUnposted_Sales()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_SalesReturn()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_SaleOrder()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Services()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_TransWindow()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_PurServices()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Purchase()

UNION ALL

SELECT * FROM dbo.Fn_Ge
tUnposted_PurchaseReturn()

UNION ALL

SELECT * FROM dbo.Fn_GetUnposted_Adjustment()



INSERT INTO @retTable

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE dr_AccCode WHEN @ln_cashacc THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 
			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	AlternateAccCode = CASE cr_AccCode WHEN @ln_cashacc THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentTy
pe = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  FBR POS Fee */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_fbrposfeeacc ELSE @ln_fbrposfeeacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'SR' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	SaleTax_Remarks='FBR POS Service Fee Accounted For', CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode
, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR') AND ISNULL(FBRPosFee, 0) <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		ELSE 'Paid during s/return no.' END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		ELSE 'Paid during s/return no.' END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE 	Amt > 0

UNION ALL /* Un-posted A/c Vouchers */

SELECT  documentcode = H.glvochcode,

	documenttype    = VC.ShortName,

	catcode = H.VochCatCode,

	acccode = D.acccode, 

	AlternateAccCode = NULL, 

	date    = H.Date,

	debit   = D.debit, 

	credit  = D.c
redit,

	remarks = CASE WHEN h.acccode = d.acccode THEN H.Remarks ELSE D.remarks END,

	CheckNo = CASE WHEN h.acccode = d.acccode THEN H.ChkNo ELSE D.ChkNo END, 

	UserCode = H.salesmancode, H.VoucherCode, D.InvoiceCode, VC.InvoiceType, 

	OutstandingAmt= D.OutstandingAmt, Balance= D.Balance, 

	VRow = CASE D.DEBIT WHEN 0 THEN 1 ELSE 0 END, D.PatientCode,

	GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=D.GuestCode, StudentCode=D.StudentCode, CGS=0, H.CurrencyCode, H.ConversionRate

from glheader H, gldetail D, VocherCategory VC

where H.Posted = 'N' AND H.glvochcode = D.glvochcode and H.vochcatcode = VC.vochcatcode

UNION ALL

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End, 

	catcode = Notes.NoteCatCode,

	acccode= Notes.Bankacccode, 

	AlternateAccCode = NULL, 

	Date   = CASE WHEN Notes.DueDate IS NULL THEN Notes.IssueDate ELSE Notes.DueDate END, 

	debit   = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,

	credit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	remarks = notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.VoucherCode, 

	InvoiceCode = NULL, InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where 	Notes.Posted = 'N' AND Notes.Bankacccode IS NOT NULL

UNION ALL /* Un-Posted Cheques */

Select  DocumentCode = Notes.NoteCode, 

	DocumentType = Case Notes.NoteCatCode When 1 Then 'NR' Else 'NP' End,

	catcode = Notes.NoteCatCode,

	acccode= Notes.acccode, 

	AlternateAccCode = NULL, 

	Date   = CASE WHEN Notes.DueDate IS NULL THEN Notes.IssueDate ELSE Notes.DueDate END, 

	debit  = Case Notes.NoteCatCode When 2 Then Notes.Amount Else 0 End,

	credit = Case Notes.NoteCatCode When 1 Then Notes.Amount Else 0 End,


	remarks= notes.remarks, CheckNo = LEFT(notes.DocumentNumber, 20),

	UserCode=notes.Salesmancode, VoucherCode = Notes.VoucherCode, InvoiceCode = NULL, 

	InvoiceType=NULL, OutstandingAmt=0, Balance=0,

	VRow = Case Notes.NoteCatCode When 1 Then 0 Else 1 End,

	PatientCode=NULL, GRN=NULL, GCCode=NULL, Vehicle=NULL, ShipTo=NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL

from    Notes

where	Notes.Posted = 'N' AND Notes.Bankacccode IS NOT NULL

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit = 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate

From @UPTrans

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



RETURN 

END
PrAllocationHeader'

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

F
' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39)

END

SET @WHR_Cln = @WHR

SET @Query = @INS + @SQL + @WHR

EXECUTE (@Query)

SET @err = @@ERROR

IF @@ERROR <> 0 OR @err <> 0

BEGIN

	RAISERROR('Transmit Sales Data Problem: Error Transfering Sales Data From Server (%s) TO Server (%s) ', 16, 1, @SRV, @PARENTSRV)

	RETURN -1

END 

ELSE

BEGIN

	IF @SaleType = 1

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SaleDetail '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''', SaleInvcode, ICode, GCode, Batch, Expiry, PackQty, LooseQty, PackUnits, SalePrice, AvgPrice, Rate, DiscPerc, SalesTax, RowID, Due, SatisfiedDate, itemflatdisc, SaleItemDescription, PackPrice, UnitSalesTax, GSTPerc, SaleUtn, bonusqty, claimable, balancestock, RowGroup, ClaimableDiscPerc, ManfDate, PackQtyForSale, BonusPackQtyForSale, SaleOrderRowID, DescICode, SourceSaleInvCode=SaleInvCode, SaleRowID=NULL, IssueRowID=NULL, PurUnitRate, RPPUnitRate, TotalPieces, PiecesInHand, PackSalePrice, RefusalSaleRowID=NULL, AlternatePurPrice, CommissionPerUnit, CommissionPerc, AlternateCustomICode, BatchCost FROM SaleDetail WHERE SaleInvCode IN (SELECT SaleInvCode FROM SaleLedger '

	END

	IF @SaleType = 2

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_AdvSaleDetail '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''', * FROM AdvSaleDetail WHERE AdvSaleInvCode IN (SELECT AdvSaleInvCode FROM AdvSaleLedger '

	END

	IF @SaleType = 3

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SRDetail (ChildServer,SRInvcode,Icode,Gcode,Batch,Expiry,PackQty,LooseQty,PackUnits,SRPrice,DiscPerc,SalesTax,AvgPrice,UnitSalesTax,GSTPerc,SRUtn,BonusQty,SalePrice,SaleRowId,ReturnItemDescription,TotalPieces,PiecesInHand,AlternatePurPrice,CommissionPe
ROM #del_temp

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
ALTER PROCEDURE DBO.SP_AquirePostedTransactions @srv VARCHAR(100), @DB VARCHAR(255), @Owner VARCHAR(100)

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

SELECT 47, 'PurO
rderHeader', 'Y'

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

SELEC
T 390, 'AdjBufferHeader', 'Y'

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



FETCH
 NEXT FROM C1

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

			SET @QR
Y = N'INSERT INTO DBO.' + @TableName + ' (' + @List + ' )  ' + @SQL + @List + @FROM + @TableName

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
CREATE FUNCTION dbo.fn_getSRInvLoyaltyTotal ( @SRInvcode Int )

Returns NUMERIC(15, 2)

As

Begin

Declare @amount Numeric(15, 2)

SET @amount = ISNULL(

	(SELECT amount = Round(Sum((SD.looseqty * SD.srprice * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - SL.flatdisc + SL.MiscCharges), 0)

	FROM SRledger SL, SRdetail SD, Item I

	WHERE SL.SRInvCode = @srinvcode AND

		SL.srinvcode = SD.srinvcode AND 

		SD.ICode = I.ICode AND

		I.LoyaltyItem = 'Y'

	GROUP BY 

		SL.srinvcode, SL.flatdisc, SL.misccharges, SL.discperc), 0)

Return @amount

EndINSERT INTO RightsClone (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1731, 'Reports , Special Reports , Data Export Utility-Otsuka', 'Data Export Utility-Otsuka', 3, '5,16,64,', 'A', 13

INSERT INTO Rights (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1731, 'Reports , Special Reports , Data Export Utility-Otsuka', 'Data Export Utility-Otsuka', 3, '5,16,64,', 'A', 13

INSERT INTO GroupRights (GroupCode, RightCode, Status) SELECT 2, 1731, 1INSERT INTO InterfaceSetting (ModuleID, SequenceId, ColName, ColCaption, Visibility, WinType,InterfaceGroup)

SELECT ModuleID=24, SequenceId=81, ColName='customer_SalesTaxExemption', ColCaption='Sales Tax Exemption:', Visibility=1, WinType=3,InterfaceGroup=0CREATE TABLE DBO.IMP_MasterCashWin (

ChildServer VARCHAR(100) NOT NULL,

DocumentCode INT NOT NULL,

DocumentType VARCHAR(2) NOT NULL,

AccCode SMALLINT NOT NULL,

Date DATETIME NOT NULL,

Amount NUMERIC(15,2) NOT NULL,

Remarks VARCHAR(100) NULL,

RowID INT NOT NULL

)CREATE TABLE DBO.IMP_CashierWindow (

ChildServer VARCHAR(100) NOT NULL,

SaleInvCode INT NOT NULL,

AccCode SMALLINT NOT NULL,

Remarks VARCHAR(100) NULL,

Amount NUMERIC(12,2) NOT NULL,

RowID INT NOT NULL

)
ALTER   PROCEDURE sp_Translate_ChildeServer_SReturn

	@childserver VarChar(100), 

	@OldSRInvCode Int, 

	@usercode Int,

	@SRInvCode Int OUTPUT

AS



SET NOCOUNT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



DECLARE @Sale NUMERIC(15, 4)

Declare @Headerno Int, @GCode INT, @curr_rowid INT

Declare @module Int, @custcode Int, @saletypecode SmallInt, @srcatcode Int, @headerinvno Int, @continue Int, @rt_code Int, @Err Int, @totalrows Int, @rowcount Int, @invcounter Int, @counter Int

Declare @looseqty NUMERIC(15, 4), @bonusqty NUMERIC(15, 4), @item_in_inv_exist Int

Declare @srprice Numeric(12,2), @rate Numeric(12,2), @discperc Numeric(5,2), @itemflatdisc Numeric(15,2), @unitsalestax Numeric(12,2), @gstperc1 Numeric(6,2), @gstperc2 Numeric(6,2), @hold_avgprice Numeric(15,5)

Declare @icode Int, @anyitem_exist Int, @packunits Int

Declare @totalqty NUMERIC(15, 4), @givenqty NUMERIC(15, 4), @reqqty NUMERIC(15, 4), @batchqty NUMERIC(15, 4), @delqty NUMERIC(15, 4), @currqty NUMERIC(15, 4), @newqty NUMERIC(15, 4), @balancestock NUMERIC(15, 4)

Declare @batch VarChar(100), @returndesc VarChar(100), @itemname VarChar(60), @expiry DateTime, @serverdate DateTime

Declare @saleutn BigInt, @firsttime Bit

Declare @advsale_rowcount Int, @rowgroup Int, @lineitems_rowcount Int, @innercounter Int, @updateloyaltypoints CHAR(1)



Set @firsttime = 0

Set @custcode = 19

Set @srcatcode = 8 

Set @saletypecode = 2

Set @module = ( Select module from module where name = 'SALES RETURN' )

Set @serverdate = GETDATE()

Set @updateloyaltypoints = ISNULL((SELECT DBO.fn_GetPreference('ApplyLoyaltypolicyonsaleposting')),'N')



Create Table #salereturn ( 

	id int not null identity(1,1), 

	icode Int, 

	gcode int, 

	batch VARCHAR(100), 

	expiry datetime,

	looseqty NUMERIC(15, 4), 

	bonusqty NUMERIC(15, 4), 

	SRPrice  Numeric(12,2), 

	packunits smallint not null, 

	DiscPerc Numeric(8,2), 

	UnitSalesTax Numeric(12,2), 

	GstPerc Numeric(6,2),

	returndesc varchar(100))



Insert Into #salereturn 

	( icode, gcode, batch, 
expiry, looseqty, bonusqty, srprice, packunits, discperc, unitsalestax, gstperc, returndesc )

Select icode, gcode, batch, expiry, SUM(ABS(looseqty)), bonusqty=sum(ABS(bonusqty)), srprice, packunits, discperc, unitsalestax, gstperc, returnitemdescription

From IMP_SRDetail

Where ChildServer = @childserver AND SRInvCode = @OldSRInvCode

GROUP BY icode, gcode, batch, expiry, srprice, packunits, discperc, unitsalestax, gstperc, returnitemdescription

Order By ICODE



SET @Sale = ISNULL((SELECT SUM(LooseQty) FROM IMP_SRDetail Where ChildServer = @childserver AND SRInvCode = @OldSRInvCode AND LooseQty > 0), 0)

Set @advsale_rowcount = ISNULL((Select count(*) from IMP_SRDetail where ChildServer = @childserver AND SRInvCode = @OldSRInvCode), 0)

Set @anyitem_exist  = ( Select Sum(ABS(looseqty)) from #salereturn )

Set @Headerno = ( Select HeaderNo from IMP_SRLedger WHERE ChildServer = @childserver AND SRInvCode = @OldSRInvCode)

Set @continue = 0

Set @invcounter = 1

Set @rowgroup = 0



While @anyitem_exist > 0 And @continue >= 0

Begin

	Execute @rt_code = sp_GetTabMaxkey 'SRledger' , @SRInvCode Output

	Set @rowgroup = 0

	IF @@Error <> 0 OR @rt_code <>  0

	Begin

		Set @continue  = -1

	End

	Else

	Begin

		Execute @rt_code = sp_GetHeaderTabMaxkey @Headerno, @module,  @headerinvno Output 

		IF @@Error <> 0 OR @rt_code <>  0

		Begin

			Set @continue  = -1

		End

		Else

		Begin

			Set @Err = 0 

			Set @RowCount = 1

			Insert Into SRLedger (SRInvCode, SaleInvCode, Date, SRCatCode, CustCode, SalesmanCode, 

				DiscPerc, FlatDisc, MiscCharges, Posted, PostDate, Remarks, SalesTax, 

				OriginalDate, ModifiedBy, PostedBy, HeaderNo, InvGSTPerc1, Smancode, 

				CustRefno, CustRefno2, CustRefno3, CustRefno4, PatientCode, MachineName, 

				HeaderInvNo, AdmissionCode, InvTotal, AccountFor, PaymentMode, PaymentAccCode, 

				Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt, Marked, PageSize, ReprintingCounter, DoctCode, ConsiderInPO,

				CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSumma
ALTER PROCEDURE DBO.SP_GetSaleInvoice_JSON @SaleInvCode INT, @JSON VARCHAR(8000) OUTPUT

AS

SET NOCOUNT ON



DECLARE @Qry VARCHAR(8000), @Q VARCHAR(8000), @PosID VARCHAR(100)



SET @PosID = ISNULL(DBO.Fn_GetPreference('FBRPOSID'),'')

SET @Qry = ''



--910247



DECLARE C1 CURSOR FOR 

SELECT A

FROM 

(SELECT A='{"InvoiceNumber":"","POSID":"' + @PosID + '","USIN":"' + LTRIM(RTRIM(STR(SaleInvCode))) + 

'","DateTime":"' + CONVERT(VARCHAR(100), DATE, 121) + 

'","BuyerNTN":"","BuyerCNIC":"","BuyerName":"","BuyerPhoneNumber":"","TotalBillAmount":"' + LTRIM(RTRIM(STR(InvTotal,12, 2))) + 

'","TotalQuantity":"' + LTRIM(RTRIM(STR(ISNULL((SELECT SUM(D.LooseQty + D.BonusQty) FROM SaleDetail D WHERE D.SaleInvCode = @SaleInvCode),0)))) + '","TotalSaleValue":"' + LTRIM(RTRIM(STR(ISNULL(InvTotal,0) - ISNULL(DBO.fn_getTaxOnSaleInv(SaleInvCode),0),12, 2))) + 

'","TotalTaxCharged":"' + LTRIM(RTRIM(STR(DBO.fn_getTaxOnSaleInv(SaleInvCode), 12,2))) + 

'","Discount":"'+ LTRIM(RTRIM(STR(ISNULL((SELECT SUM(ROUND((D.LooseQty * D.ItemFlatDisc) + (D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (D.DiscPerc * 0.01)), 2)) FROM SaleDetail D WHERE D.SaleInvCode = @SaleInvCode),0),12,2)))  + '","FurtherTax":"0.0","PaymentMode":"1","RefUSIN":"null","InvoiceType":"1","Items":['

FROM SaleLedger 

WHERE SaleInvCode=@SaleInvCode

UNION ALL

SELECT A='{"ItemCode":"' + I.customICode + '","ItemName":"' + I.Name + '","Quantity":"' + LTRIM(RTRIM(STR(D.LooseQty + D.BonusQty, 10,4))) +

'","PCTCode":"' + P.Description + '","TaxRate":"' + LTRIM(RTRIM(STR(STS.TaxPerc, 6, 2))) + '","SaleValue":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SalePrice, 12, 2))) + '","TotalAmount":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SalePrice,12, 2))) + '","TaxCharged":"' + LTRIM(RTRIM(STR((D.LooseQty + D.BonusQty) * D.UnitSalesTax,12,2))) + '","Discount":"' + LTRIM(RTRIM(STR(ROUND((D.LooseQty * D.ItemFlatDisc) + (D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (D.DiscPerc * 0.01)), 2),12,2))) + '","FurtherTax":"0.0","InvoiceType":"1","RefUSIN":"null"},'

FROM SaleDetail
 D, Item I, PCT P, SalesTaxSchedule STS

WHERE D.SaleInvCode=@SaleInvCode AND D.ICode=I.ICode AND I.PCTCode = P.PCTCode AND I.SalesTaxScheduleCode=STS.SalesTaxScheduleCode) T 



OPEN C1



FETCH NEXT FROM C1

INTO @Q



WHILE @@FETCH_STATUS = 0

BEGIN

	SET @Qry = @Qry + @Q

	FETCH NEXT FROM C1

	INTO @Q

END

SET @JSON = ''



IF Right(@Qry, 1) = ',' 

	SET @Qry = LEFT(@Qry, LEN(@Qry) - 1)



SET @JSON = @Qry + ']}'



Print @JSon



CLOSE C1

DEALLOCATE C1

RETURN 0
ALTER  PROCEDURE DBO.SP_GetSRInvoice_JSON @SRInvCode INT, @JSON VARCHAR(8000) OUTPUT

AS

SET NOCOUNT ON



DECLARE @Qry VARCHAR(8000), @Q VARCHAR(8000), @PosID VARCHAR(100)



SET @PosID = ISNULL(DBO.Fn_GetPreference('FBRPOSID'),'')

SET @Qry = ''



--910247

DECLARE C1 CURSOR FOR 

SELECT A

FROM 

(SELECT A='{"InvoiceNumber":"","POSID":"' + @PosID + '","USIN":"' + LTRIM(RTRIM(STR(SRInvCode))) + 

'","DateTime":"' + CONVERT(VARCHAR(100), DATE, 121) + 

'","BuyerNTN":"","BuyerCNIC":"","BuyerName":"","BuyerPhoneNumber":"","TotalBillAmount":"' + LTRIM(RTRIM(STR(InvTotal,12, 2))) + 

'","TotalQuantity":"' + LTRIM(RTRIM(STR(ISNULL((SELECT SUM(D.LooseQty + D.BonusQty) FROM SRDetail D WHERE D.SRInvCode = @SRInvCode),0)))) + '","TotalSaleValue":"' + LTRIM(RTRIM(STR(ISNULL(InvTotal, 0) - ISNULL(DBO.fn_getTaxOnSRInv(SRInvCode),0),12, 2))) + 

'","TotalTaxCharged":"' + LTRIM(RTRIM(STR(DBO.fn_getTaxOnSRInv(SRInvCode), 12,2))) + 

'","Discount":"' + LTRIM(RTRIM(STR(ISNULL((SELECT SUM(ROUND((D.LooseQty * D.SRPrice * (D.DiscPerc * 0.01)), 2)) FROM SRDetail D WHERE D.SRInvCode = @SRInvCode),0),12,2))) + '","FurtherTax":"0.0","PaymentMode":"1","RefUSIN":"' + LTRIM(RTRIM(ISNULL(STR(SaleInvCode),'null'))) + '","InvoiceType":"3","Items":['

FROM SRLedger 

WHERE SRInvCode=@SRInvCode

UNION ALL

SELECT A='{"ItemCode":"' + I.customICode + '","ItemName":"' + I.Name + '","Quantity":"' + LTRIM(RTRIM(STR(D.LooseQty + D.BonusQty, 10,4))) +

'","PCTCode":"' + P.Description + '","TaxRate":"' + LTRIM(RTRIM(STR(STS.TaxPerc, 6, 2))) + '","SaleValue":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SRPrice, 12, 2))) + '","TotalAmount":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SRPrice,12, 2))) + '","TaxCharged":"' + LTRIM(RTRIM(STR((D.LooseQty + D.BonusQty) * D.UnitSalesTax,12,2))) + '","Discount":"' + LTRIM(RTRIM(STR(ROUND((D.LooseQty * D.SRPrice * (D.DiscPerc * 0.01)), 2),12,2))) + '","FurtherTax":"0.0","InvoiceType":"3","RefUSIN":"'+ LTRIM(RTRIM(ISNULL(STR(S.SaleInvCode),'null'))) + '"},'

FROM SRLedger S, SRDetail D, Item I, PCT P, SalesTaxSchedu
le STS

WHERE S.SRInvCode=@SRInvCode AND D.SRInvCode=@SRInvCode AND S.SRInvCode=D.SRInvCode AND D.ICode=I.ICode AND I.PCTCode = P.PCTCode AND I.SalesTaxScheduleCode=STS.SalesTaxScheduleCode) T 



OPEN C1



FETCH NEXT FROM C1

INTO @Q



WHILE @@FETCH_STATUS = 0

BEGIN

	SET @Qry = @Qry + @Q

	FETCH NEXT FROM C1

	INTO @Q

END

SET @JSON = ''



IF Right(@Qry, 1) = ',' 

	SET @Qry = LEFT(@Qry, LEN(@Qry) - 1)



SET @JSON = @Qry + ']}'



Print @JSon



CLOSE C1

DEALLOCATE C1

RETURN 0
ry,CRS_Transfered,CRS_TransferedOn,GuestCode,

				GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,

				FiscalizedOn,FiscalInvoiceNo,Transmit,Transmited)

			SELECT  @SRInvCode, SaleInvCode=NULL, Date, SRCatCode, CustCode, SalesManCode, 

				Discperc, Flatdisc, MiscCharges, Posted='Y', PostDate=GETDATE(), Remarks, SalesTax=0, 

				OriginalDate, ModifiedBy, PostedBy=@usercode, @HeaderNo, InvGSTPerc1, Smancode, 

				CustRefno, CustRefno2, CustRefno3, CustRefno4=LTRIM(RTRIM(STR(@OldSRInvCode))), PatientCode, MachineName, 

				@HeaderInvNo, AdmissionCode=NULL, InvTotal, AccountFor, PaymentMode, PaymentAccCode, 

				Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt, Marked='N', PageSize, ReprintingCounter, DoctCode, ConsiderInPO,

				CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSummary,CRS_Transfered,CRS_TransferedOn,GuestCode,

				GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,

				FiscalizedOn,FiscalInvoiceNo,Transmit='N',Transmited='N'

			FROM IMP_SRLedger

			WHERE ChildServer = @childserver AND SRInvCode = @OldSRInvCode



			Select @Err = @@Error, @RowCount = @@RowCount

			IF @Err <> 0 OR @RowCount = 0 

			Begin 

				RaisError( 'Error occured in inserting record into Sale Return Ledger : %d' ,16,1,  @SRInvCode)

				Set @continue  = -1

			End 

			Else

			Begin

				Set	@curr_rowid = 1

				Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

				Set @lineitems_rowcount =  @advsale_rowcount

				Set @innercounter = 1

				While ( @advsale_rowcount > 0 )  AND ( @anyitem_exist > 0 ) AND ( @innercounter <= @lineitems_rowcount ) AND ( @continue >= 0 )

				Begin

					Select @icode = icode , @Gcode = GCode, 

						@batch = Batch, 

						@expiry = EXPIRY, 

						@looseqty = looseqty, @bonusqty=bonusqty, @srprice = srprice, 

						@packunits = packunits, @discperc = discperc,  

						@unitsalestax = unitsalestax, @gstperc1 = gstperc, @returndesc=returndesc

					F
rUnit,CommissionPerc,AlternateCustomICode,NewAvgPrice,Claimable,ClaimableDiscPerc) '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''',SRInvcode,Icode,Gcode,Batch,Expiry,PackQty,LooseQty,PackUnits,SRPrice,DiscPerc,SalesTax,AvgPrice,UnitSalesTax,GSTPerc,SRUtn,BonusQty,SalePrice,SaleRowId,ReturnItemDescription=LTRIM(RTRIM(STR(SRUTN))),TotalPieces,PiecesInHand,AlternatePurPrice,CommissionPerUnit,CommissionPerc,AlternateCustomICode,NewAvgPrice,Claimable,ClaimableDiscPerc FROM SRDetail WHERE SRInvCode IN (SELECT SRInvCode FROM SRLedger '

	END



	IF @CustCode IS NULL

	BEGIN

		SET @WHR = N' WHERE Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39) + ')'

	END

	ELSE

	BEGIN

		SET @WHR = N' WHERE CustCode = ' + (SELECT LTRIM(RTRIM(STR(@CustCode, 8)))) + ' AND Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39) + ')'

	END

	SET @Query = @INS + @SQL + @WHR

	EXECUTE (@Query)

	SET @err = @@ERROR

	IF @@ERROR <> 0 OR @err <> 0

	BEGIN

		RAISERROR('Transmit Sales Data Detail Problem: Error Transfering Sales Data Detail From Server (%s) TO Server (%s) ', 16, 1, @SRV, @PARENTSRV)

		RETURN -1

	END 

	ELSE

	BEGIN

		IF @SaleType = 1

		BEGIN

			SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_CashierWindow SELECT ChildServer=' + CHAR(39) + @SRV + CHAR(39) + ', CW.* FROM CashierWindow CW WHERE CW.SaleInvCode IN (SELECT SaleInvCode FROM SaleLedger '

		END

		IF @SaleType = 3

		BEGIN

			SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_MasterCashWin SELECT ChildServer=' + CHAR(39) + @SRV + CHAR(39) + ', CW.* FROM MasterCashWin CW WHERE CW.DocumentType = ' + CHAR(39) + 'SR' + CHAR(39) + ' AND DocumentCod
e IN (SELECT SRInvCode FROM SRLedger '

		END

		SET @Query = @INS + @WHR

		EXECUTE (@Query)

		SET @err = @@ERROR

		IF @@ERROR <> 0 OR @err <> 0

		BEGIN

			RAISERROR('Transmit Sales Data Problem: Error Updating Master Cashier Window Related Data (%d)', 16, 1, @SaleType)

			RETURN -1

		END 



		IF @SaleType = 1

		BEGIN

			SET @Query = 'UPDATE SaleLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		IF @SaleType = 2

		BEGIN

			SET @Query = 'UPDATE AdvSaleLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		IF @SaleType = 3

		BEGIN

			SET @Query = 'UPDATE SRLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		

		EXECUTE (@Query)

		SET @err = @@ERROR

		IF @@ERROR <> 0 OR @err <> 0

		BEGIN

			RAISERROR('Transmit Sales Data Problem: Error Updating Sales Regarding Transmit Status', 16, 1)

			RETURN -1

		END 

	END

END



SET @dt = GETDATE()

Execute @rt_code = SP_Set_DateTime_Preference 'LastSaleTransmited', @dt

IF @@Error <> 0 OR @rt_code <> 0 

Begin

	RaisError( 'Unable to Record Last Sale Transmit Information in Software Preferences' , 16 , 1)

	RETURN -1								

End



RETURN 0
wndetail.icode = @icode 

								Order by priority, expiry, Currqty



								Open ItemBatch_Cursor

								Set @totalrows = @@Cursor_Rows

								Fetch Next From ItemBatch_Cursor

								Into 	@batch, @expiry, @currqty

								Set @counter = 1	

								While @@Fetch_Status = 0 And @counter <= @totalrows AND @reqqty > 0

								Begin

									Set @batchqty = @currqty

									IF @batchqty >= @ReqQty 

										Set @delqty = @reqqty

									Else

										Set @delqty = @batchqty

									Set @reqqty = @reqqty - @delqty



									Execute @rt_code = sp_maxutn 1, @saleutn Output

									IF @@Error <> 0 OR @rt_code <> 0

									Begin

										Set @continue  = -1															

									End 									



									Insert Into SaleDetail (SaleInvCode, icode, gcode, batch, expiry, packqty, looseqty, packunits, saleprice, avgprice, rate, discperc, salestax, itemflatdisc, packprice, unitsalestax, gstperc, saleutn, balancestock, rowgroup, SaleItemDescription)

									Values (@saleinvcode, @icode, @gcode, @batch, @expiry, 0, @delqty, @packunits, @saleprice, @hold_avgprice, @rate, @discperc, 0, @itemflatdisc, @rate * @packunits, @unitsalestax, @gstperc1, @saleutn, (@totalqty - @delqty), @rowgroup, @SaleDesc)

									Select @Err = @@Error, @RowCount = @@RowCount

									IF @Err <> 0 OR @RowCount = 0 

									Begin 

										RaisError( 'Error occured in inserting record into Sale Detail for Sale Inv. No. : %d' ,16,1, @SaleInvCode  )

										Set @continue  = -1

									End 							
									Else

									Begin

										Set @newqty = @currqty - @delqty

										IF @newqty > 0

											Execute @rt_code = sp_SaleUpdateItemStockBatch @gcode, @icode, @batch, @expiry, @newqty , @currqty

										Else

											Execute @rt_code = sp_DeleteItemStockBatch @gcode, @icode, @batch, @expiry, @delqty

										IF @@Error <> 0 OR @rt_code <> 0 

										Begin

											Set @continue  = -1								

										End

									End

									Set @counter = @counter + 1

									Fetch N
rom #salereturn

			        	Where id = @curr_rowid



					Select @RowCount = @@RowCount

					IF ( @RowCount = 1 ) AND  ( @looseqty > 0 )

					Begin

						Set @givenqty = @looseqty + @bonusqty

						Execute @rt_code = sp_GetItemAvgPrice @icode, @hold_avgprice OutPut

						IF @@Error <> 0 OR @rt_code <> 0

						Begin

							Set @continue  = -1

						End

						Else

						Begin

							Set @totalqty = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode  )

							Set @rowgroup = @rowgroup + 1

							IF @packunits = 0 OR @packunits Is Null 

							BEGIN

								Set @packunits = 1

							END



							IF @givenqty > 0

							Begin 

								Execute @rt_code = sp_maxutn 1, @saleutn Output

								IF @@Error <> 0 OR @rt_code <> 0

								Begin

									Set @continue  = -1

								End



								Insert Into SRDetail 

									(SRInvcode, Icode, Gcode, Batch, Expiry, PackQty, LooseQty, PackUnits, SRPrice, 

									DiscPerc, SalesTax, AvgPrice, UnitSalesTax, GSTPerc, SRUtn, BonusQty, SalePrice, SaleRowId, ReturnItemDescription)

								SELECT @SRInvCode, @icode, @gcode, @batch, @expiry, 0, @looseqty, @packunits, @srprice, 

									@discperc, 0, @hold_avgprice, @unitsalestax, @gstperc1, @saleutn, @bonusqty, @SRPrice, NULL,@returndesc



								Select @Err = @@Error, @RowCount = @@RowCount

								IF @Err <> 0 OR @RowCount = 0 

								Begin 

									RaisError( 'Error occured in inserting record into Sale Return Detail for Sale Return No. : %d' ,16,1, @SRInvCode  )

									Set @continue  = -1

								End 							
								Else

								Begin

									Set @currqty = 0

									Execute @rt_code = SP_GetItemStockBatch @GCode, @ICode, @Batch, @Expiry, @currqty output

									IF @@Error <> 0 OR @rt_code <> 0 

									Begin

										RaisError( 'Error occured in checking Batch details of some items during processing of Sale Return No. : %d' ,16,1, @SRInvCode  )

										Set @continue  = -1								

									End



		
ALTER PROCEDURE sp_Translate_ChildeServer_Sale

	@childserver VarChar(100), 

	@invtype int,

	@invcode Int, 

	@usercode Int,

	@refund NUMERIC(10, 2),

	@saleinvcode int output

AS

SET NOCOUNT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



Declare @Headerno Int, @GCode INT, @curr_rowid INT

Declare @module Int, @custcode Int, @saletypecode SmallInt, @salecatcode Int, @headerinvno Int, @continue Int, @rt_code Int, @Err Int, @totalrows Int, @rowcount Int, @invcounter Int, @counter Int

Declare @satisfiableqty NUMERIC(15, 4), @satisfiedqty NUMERIC(15, 4), @item_in_inv_exist Int

Declare @saleprice Numeric(12,2), @rate Numeric(12,2), @discperc Numeric(5,2), @itemflatdisc Numeric(15,2), @unitsalestax Numeric(12,2), @gstperc1 Numeric(6,2), @gstperc2 Numeric(6,2), @hold_avgprice Numeric(15,5)

Declare @icode Int, @anyitem_exist NUMERIC(15, 4), @packunits Int

Declare @totalqty NUMERIC(15, 4), @givenqty NUMERIC(15, 4), @reqqty NUMERIC(15, 4), @batchqty NUMERIC(15, 4), @delqty NUMERIC(15, 4), @currqty NUMERIC(15, 4), @newqty NUMERIC(15, 4), @balancestock NUMERIC(15, 4)

Declare @batch VarChar(100), @itemname VarChar(60), @expiry DateTime, @serverdate DateTime

Declare @saleutn BigInt

Declare @salerowcount Int, @rowgroup Int, @lineitems_rowcount Int, @innercounter Int

DECLARE @saledesc VARCHAR(100), @updateloyaltypoints CHAR(1)



Set @custcode = 19

Set @salecatcode = 3 

Set @saletypecode = 2

Set @module = ( Select module from module where name = 'Sales' )

Set @serverdate = GETDATE()

Set @updateloyaltypoints = ISNULL((SELECT DBO.fn_GetPreference('ApplyLoyaltypolicyonsaleposting')),'N')



Create Table #sale ( id int not null identity(1,1), icode Int, gcode int, satisfiableqty NUMERIC(15, 4), satisfiedqty NUMERIC(15, 4), SalePrice  Numeric(12,2), rate Numeric(12,2), packunits smallint not null, DiscPerc Numeric(8,2), ItemFlatDisc Numeric(12,2), UnitSalesTax Numeric(12,2), GstPerc Numeric(6,2), SaleDesc VARCHAR(100))

Insert Into #sale ( icode, gcode, satisfiableqty, satisfiedqty , saleprice, rate, pack
							Set @newqty = ISNULL(@currqty, 0) + ISNULL(@givenqty, 0)

									SELECT Row=@curr_rowid, Gcode=@GCode, Icode=@ICode, Batch=@Batch, Expiry=@Expiry, Qty=@CurrQty, thisqty = @givenqty, newqty=@newqty

									IF @newqty > 0

									BEGIN

										Execute @rt_code = SP_UpdateItemStockBatch  @GCode, @ICode, @Batch, @Expiry, @NewQty, Null

										IF @@Error <> 0 OR @rt_code <> 0 

										Begin

											RaisError( 'Error occured in updation of Batch details of some items during processing of Sale Return No. : %d' ,16,1, @SRInvCode  )

											Set @continue  = -1								

										End

									END

								End

								Set @counter = @counter + 1

							End

						End

					End	

					UPDATE #salereturn SET looseqty = 0, BonusQty=0 WHERE ID = @curr_rowid

					Set	@curr_rowid = @curr_rowid + 1

					Set @innercounter = @innercounter + 1

					Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

				End

			End

		End	

	End

	Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

End



Drop Table #salereturn



IF ( @continue >= 0 )

Begin

	IF @SRInvCode > 0

	BEGIN

		Update DBO.SRledger 

		Set InvTotal = ISNULL(dbo.fn_getSRInvTotal (SRLedger.SRInvCode), 0)

		Where SRInvCode = @SRInvCode

	

		Select @Err = @@Error, @Rowcount = @@RowCount

		IF  @Err <> 0 OR @RowCount = 0

		Begin

			RaisError( 'Unable to update Sale Return Invoices for Inv. total' , 16 , 1 )

			Set @continue  = -1

		End

		IF @updateloyaltypoints = 'Y'

		Begin

			Execute @rt_code = SP_ManageLoyaltyPoints 'SR', @SRInvCode

			IF @@Error <> 0 OR @rt_code <> 0

			Begin

				RaisError( 'Unable to update loyalty points On S/R Invoice : %d' ,16,1, @SRInvCode)

				Set @continue  = -1															

			End

		End

	END

End



Return @continue
units, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc)

Select icode, gcode, looseqty=ISNULL(SUM(looseqty), 0), 0, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc=LTRIM(RTRIM(STR(MAX(SaleUtn))))

From IMP_AdvSaleDetail

Where @invtype = 2 AND ChildServer = @childserver AND AdvSaleInvCode = @InvCode AND LooseQty > 0

GROUP BY icode, gcode, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc

UNION ALL

Select icode, gcode, looseqty=ISNULL(SUM(looseqty), 0), 0, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc=LTRIM(RTRIM(STR(MAX(SaleUtn))))

From IMP_SaleDetail

Where @invtype = 1 AND ChildServer = @childserver AND SaleInvCode = @InvCode AND LooseQty > 0

GROUP BY icode, gcode, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc

Order By Icode



IF @invtype = 1

	Set @salerowcount = ISNULL((Select count(*) from IMP_SaleDetail where SaleInvCode = @invcode AND childserver = @childserver), 0)

ELSE

	Set @salerowcount = ISNULL((Select count(*) from IMP_AdvSaleDetail where AdvSaleInvCode = @invcode AND childserver = @childserver), 0)



Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )



IF @invtype = 1

	Set @Headerno = ( Select HeaderNo from IMP_SaleLedger WHERE SaleInvCode = @invcode AND childserver = @childserver)

ELSE

	Set @Headerno = ( Select HeaderNo from IMP_AdvSaleLedger WHERE AdvSaleInvCode = @invcode AND childserver = @childserver)

Set @continue = 0

Set @invcounter = 1

Set @rowgroup = 0



While @anyitem_exist > 0 And @continue >= 0

Begin

	Execute @rt_code = sp_GetTabMaxkey 'Saleledger' , @SaleInvCode Output

	Set @rowgroup = 0

	IF @@Error <> 0 OR @rt_code <>  0

	Begin

		Set @continue  = -1

	End

	Else

	Begin

		Execute @rt_code = sp_GetHeaderTabMaxkey @Headerno, @module,  @headerinvno Output 

		IF @@Error <> 0 OR @rt_code <>  0

		Begin

			Set @continue  = -1

		End

		Else

		Begin



			Set @Err = 0 

			Set @RowCount = 1

			
Insert Into SaleLedger (SaleInvCode, SaleCatCode, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc, MiscCharges, SalesTax, Posted, PostDate, HeaderNo, HeaderInvNo, OriginalDate, InvTotal, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized, FiscalizedOn, FiscalInvoiceNo, ModuleID, DocCode , InvoiceSize , CashReceived, CashAccCode, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBy, AmtReference, OutStandingAmt, DueDate, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5, SaleComments1, SaleComments2, CashTendered, CashCharged, CashBack, SaleTypeInvNo)

			SELECT  @SaleInvCode, SaleCatCode, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc=FlatDisc + ISNULL(@refund, 0), MiscCharges, SalesTax=0, Posted='Y', Date, @HeaderNo, @HeaderInvNo, OriginalDate, InvTotal=0, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized, FiscalizedOn, FiscalInvoiceNo, ModuleID=-1, DocCode, InvoiceSize , CashReceived, CashAccCode, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBy, AmtReference, OutStandingAmt, DueDate, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5, SaleComments1, SaleComments2, CashTendered, CashCharged, CashBack, SaleTypeInvNo

			FROM IMP_SaleLedger

			WHERE @invtype = 1 AND SaleInvCode = @InvCode AND childserver = @childserver

			UNION ALL

			SELECT  @SaleInvCode, SaleCatCode = CASE invtype WHEN 1 THEN @salecatcode ELSE 2 END, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc=FlatDisc + ISNULL(@refund, 0), MiscCharges, SalesTax=0, Posted='Y', Date, @HeaderNo, @HeaderInvNo, OriginalDate, InvTotal=0, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized='N', FiscalizedOn=NULL, FiscalInvoiceNo=NULL, ModuleID=NULL, DocCode=NULL, InvoiceSize , CashAmt, CashAccCode=2, AccountFor='Y', PaymentMode'C', PaymentAccCode=NULL, Amt=0.00, AmtBy=NULL, AmtReference=NULL, OutStandingAmt=0.00, DueDate=Date, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5=NULL, SaleComments1, SaleComments2, CashTendered, CashAmt, CashBack=0.00, Sal
eTypeInvNo=0

			FROM IMP_AdvSaleLedger

			WHERE @invtype = 2 AND AdvSaleInvCode = @InvCode AND childserver = @childserver

			Select @Err = @@Error, @RowCount = @@RowCount



			IF @Err <> 0 OR @RowCount = 0 

			Begin 

				RaisError( 'Error occured in inserting record into Sale Ledger : %d' ,16,1,  @SaleInvCode  )

				Set @continue  = -1

			End 

			Else

			Begin

				Set @curr_rowid = 1

				Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

				Set @lineitems_rowcount =  @salerowcount

				Set @innercounter = 1

				While ( @salerowcount > 0 )  AND ( @anyitem_exist > 0 ) AND ( @innercounter <= @lineitems_rowcount ) AND ( @continue >= 0 )

				Begin

					Select @icode = icode , @Gcode = GCode, @satisfiableqty = satisfiableqty, @satisfiedqty = satisfiedqty, @saleprice = saleprice, @rate = rate, @packunits = packunits, @discperc = discperc,  @itemflatdisc = itemflatdisc, @unitsalestax = unitsalestax, @gstperc1 = gstperc, @saledesc=SaleDesc

					From #sale

				        Where id = @curr_rowid



					Select @RowCount = @@RowCount

					IF ( @RowCount = 1 ) AND  ( (@satisfiableqty - @satisfiedqty) > 0 )

					Begin

						Set @givenqty = @satisfiableqty - @satisfiedqty

						Execute @rt_code = sp_GetItemAvgPrice @icode, @hold_avgprice OutPut

						IF @@Error <> 0 OR @rt_code <> 0

						Begin

							Set @continue  = -1

						End

						Else

						Begin

							Set @totalqty = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode  )

							Set @rowgroup = @rowgroup + 1

							IF @packunits = 0 OR @packunits Is Null 

								Set @packunits = 1



							IF @givenqty > 0

							Begin 

								IF @totalqty >= @givenqty

									Set @reqqty = @givenqty

								ELSE

									Set @reqqty = @totalqty



								Declare ItemBatch_Cursor Cursor Static Forward_Only

								For 	Select  batch, expiry, Currqty 

								From    godowndetail 

								Where  godowndetail.gcode = @gcode and

									    godo
ALTER  PROCEDURE DBO.SP_PostSaleLedger 

	@ai_sInvCode integer, 

	@ai_lInvCode integer, 

	@ai_SalCatCode integer, 

	@ai_SalesmanCode integer, 

	@ai_custcode integer, 

	@ai_OneOrAll INTEGER, 

	@ac_impactinventory CHAR(1) 

AS



DECLARE @custcode INT, @saleinvcode INT, @RowID INT, @TotRows INT, @rt_code INT

DECLARE @balance NUMERIC(15, 5)

DECLARE @dt DATETIME

DECLARE @savebal CHAR(1), @ai_list VARCHAR(8000), @loyalty CHAR(1), @AutoFiscalize CHAR(1)

CREATE TABLE #lt_invoicelist (Code INT NOT NULL, ROWID INT NOT NULL IDENTITY(1,1))

SET @ai_list=''

SET @savebal = DBO.Fn_GetPreference ('SaveBalanceOnSalePosting')

SET @saleinvcode = @ai_sInvCode

SET @loyalty = DBO.Fn_GetPreference ('ApplyLoyaltypolicyonsaleposting')

SET @AutoFiscalize = ISNULL(DBO.Fn_GetPreference ('AutoFiscalizeOnPosting'),'N')



IF @ai_OneOrAll=0

BEGIN

	IF @savebal = 'Y'

	BEGIN

		IF @ai_SalCatCode = 3

		BEGIN

			INSERT INTO #lt_invoicelist 

			SELECT SaleInvCode

			FROM SaleLedger

			Where	SaleLedger.SaleInvCode BETWEEN @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleLedger.postdate = GetDate(),

				SaleLedger.postedby = @ai_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode BETWEEN @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

		ELSE

		BEGIN

			WHILE @saleinvcode <= @ai_LInvCode

			BEGIN

				SET @custcode = 0

				SET @balance = 0

			

				SET @custcode = 

					(SELECT custcode FROM SaleLedger 


ext From ItemBatch_Cursor

									Into 	@batch, @expiry, @currqty

								End

								Close ItemBatch_Cursor

								Deallocate ItemBatch_Cursor



								IF @totalqty < @givenqty

								BEGIN

									Set @givenqty = @givenqty - @totalqty

									IF @givenqty > 0

									BEGIN

										Execute @rt_code = sp_maxutn 1, @saleutn Output

										IF @@Error <> 0 OR @rt_code <> 0

										Begin

											Set @continue  = -1															

										End

										ELSE

										Begin

											Insert Into SaleDetail (SaleInvCode, icode, gcode, due, batch, expiry, packqty, looseqty, packunits, saleprice, avgprice, rate, discperc, salestax, itemflatdisc, packprice, unitsalestax, gstperc, saleutn, balancestock, rowgroup, SaleItemDescription)

											Values (@saleinvcode, @icode, @gcode, 'D', 'due', CONVERT(VARCHAR(100), GETDATE()+365, 101), 0, @givenqty, @packunits, @saleprice, @hold_avgprice, @rate, @discperc, 0, @itemflatdisc, @rate * @packunits, @unitsalestax, @gstperc1, @saleutn, 0, @rowgroup, @SaleDesc)

											Select @Err = @@Error, @RowCount = @@RowCount

											IF @Err <> 0 OR @RowCount = 0 

											Begin 

												RaisError( 'Error occured in inserting due record into Sale Detail for Sale Inv. No. : %d' ,16,1, @SaleInvCode  )

												Set @continue  = -1

											End 							
										End

									END

								END

							End

						End

					End	

					UPDATE #sale SET Satisfiedqty = Satisfiableqty WHERE ID = @curr_rowid



					Set	@curr_rowid = @curr_rowid + 1

					Set @innercounter = @innercounter + 1

					Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

				End

			End

		End	

	End

Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

End



Drop Table #sale



IF ( @continue >= 0 )

Begin

	IF @SaleInvCode > 0

	BEGIN

		INSERT INTO CashierWindow (SaleInvCode, AccCode, Remarks, Amount, RowID)

		SELECT @SaleInvCode, AccCode, Remarks, Amount, RowID 

		FROM IMP_CashierWindow

		WHERE
 childserver = @childserver AND SaleInvCode = @InvCode AND 

			SaleInvCode IN 

			(SELECT SaleInvCode FROM IMP_SaleLedger WHERE @invtype = 1 AND SaleInvCode = @InvCode AND childserver = @childserver)



		Update Saleledger 

		Set InvTotal = dbo.fn_getSaleInvTotal (Saleledger.saleinvcode)

		Where saleinvcode = @SaleInvCode

	

		Select @Err = @@Error, @Rowcount = @@RowCount

		IF  @Err <> 0 OR @RowCount = 0

		Begin

			RaisError( 'Unable to update Sale Invoice for Sale Inv. total' , 16 , 1 )

			Set @continue  = -1									

		End



		IF @updateloyaltypoints = 'Y'

		Begin

			Execute @rt_code = SP_ManageLoyaltyPoints 'SV', @SaleInvCode

			IF @@Error <> 0 OR @rt_code <> 0

			Begin

				RaisError( 'Unable to update loyalty points On Sale Invoice : %d' ,16,1, @SaleInvCode)

				Set @continue  = -1															

			End

		End

	END

End



Return @continue
					WHERE SaleInvCode = @saleinvcode AND 

						SaleLedger.SaleCatCode IN (1,2) AND 

						SaleLedger.CustCode = @ai_custcode AND 

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL)

				SET @dt = GetDate()

				IF @custcode IS NOT NULL

				BEGIN

					EXECUTE SP_OPENINGBALANCE @custcode, @dt, @balance OUTPUT	



					INSERT INTO #lt_invoicelist 

					SELECT SaleInvCode

					FROM SaleLedger

					Where SaleLedger.SaleInvCode = @saleinvcode AND

						SaleLedger.SaleCatCode IN (1,2) AND /* all credit sales */

						SaleLedger.CustCode = @ai_custcode AND

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL



					Update  SaleLedger

					Set  SaleLedger.posted   = 'Y',

						SaleLedger.postdate = GetDate(),

						SaleLedger.postedby = @ai_SalesmanCode,

						SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

						SaleLedger.Balance = @balance

					Where SaleLedger.SaleInvCode = @saleinvcode AND

						SaleLedger.SaleCatCode IN (1,2) AND /* all credit sales */

						SaleLedger.CustCode = @ai_custcode AND

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL

				END

			

				SET @saleinvcode = @saleinvcode + 1

			END

		END

	END

	ELSE

	BEGIN

		IF @ai_SalCatCode = 3

		BEGIN

			INSERT INTO #lt_invoicelist 

			SELECT SaleInvCode

			FROM SaleLedger

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleL
ALTER     PROCEDURE sp_ChildServer_Sale_Translation

	@childserver VarChar(100), 

	@invtype int,

	@custcode INT,

	@startdate DateTime, 

	@enddate DateTime,

	@usercode Int

AS



SET NOCOUNT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



DECLARE @refund NUMERIC(10, 2), @refundamt NUMERIC(10, 2), @InvTotal NUMERIC(15, 2), @Sale_InvTotal NUMERIC(15, 2), @Ret_InvTotal NUMERIC(15, 2), @InvTotal_Diff NUMERIC(15, 2)

DECLARE @SaleInvCode INT, @SRInvCode INT

Declare @sale_rowcount INT, @continue Int, @rt_code Int, @Err Int, @invcounter Int, @invcode int

DECLARE @sale NUMERIC(15, 4), @salereturn NUMERIC(15, 4)

DECLARE @ThisChildServer VARCHAR(100), @FLAG INT

DECLARE @dt DATETIME



Create Table #saletemp ( 

	id int not null identity(1,1), 

	ChildServer VARCHAR(100) NOT NULL, 

	InvCode int, 

	Sale NUMERIC(15, 4), 

	SaleReturn NUMERIC(15, 4), 

	RefundAmt NUMERIC(10, 2), 

	InvTotal NUMERIC(15, 2)

)



Insert Into #saletemp ( ChildServer, InvCode, Sale, SaleReturn, RefundAmt, InvTotal)

Select H.ChildServer, InvCode=H.SaleInvCode, 

	Sale=ISNULL((SELECT SUM(D.LooseQty) FROM IMP_SaleDetail D WHERE H.SaleInvCode = D.SaleInvCode AND D.LooseQty > 0), 0), 

	SaleReturn=0,

	RefundAmt=0, H.InvTotal

From IMP_SaleLedger H

Where 	@invtype = 1 AND

	H.CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE H.CustCode END AND

	H.ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE H.ChildServer END AND

	H.Transmit = 'Y' AND H.Transmited = 'N' AND 

	H.Date BETWEEN @startdate AND @enddate

UNION ALL

Select H.ChildServer, InvCode=H.SRInvCode, 

	Sale=0.00, 

	SaleReturn=ISNULL((SELECT SUM(D.LooseQty) FROM IMP_SRDetail D WHERE H.SRInvCode = D.SRInvCode AND D.LooseQty > 0), 0),

	RefundAmt=0, H.InvTotal

From IMP_SRLedger H

Where 	@invtype = 3 AND

	H.CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE H.CustCode END AND

	H.ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE H.ChildServer END AND

	H.Transmit = 'Y' AND H.Transmited = 'N' AND 

	H.Date BETWEEN @startdate 
ALTER    PROCEDURE DBO.SP_ManageLoyaltyPoints

	@InvType VARCHAR(2), 

	@InvoiceCode INTEGER

AS

/*

Author: Muhammad Azhar Inayat

Description:

This stored procedure is used to manage loyalty point an account is entitled for

On Sales --Points are added

On Sales Return --Points are reversed

On Loyalty Redemption -- Points are deducted

On Loyalty Adjustment -- Points +/-

*/

SET NOCOUNT ON

DECLARE @NetAmt NUMERIC(12,2), @LoyaltyAmt NUMERIC(12,2), @LoyaltyCardCode INT, @LoyaltyPoints INT, @PointsValue NUMERIC(12,2), @LoyaltyPolicyCode INT



IF @InvoiceCode IS NULL OR @InvoiceCode < 0 

BEGIN 

	SET @LoyaltyPoints = 0

	RaisError('Problem occured while fetching Invoice/Document Information' ,16,1)

	RETURN -1

END



DELETE LoyaltyCardLedger WHERE InvoiceType=@InvType AND InvoiceCode = @InvoiceCode



IF @InvType='SV' /*On Sales - Loyalty Points Addition*/

BEGIN

	SET @NetAmt = ISNULL((SELECT Amt=DBO.fn_GetSaleInvLoyaltyTotal(@InvoiceCode)), 0)

	SET @LoyaltyCardCode = (SELECT MIN(LoyaltyCardCode) FROM LoyaltyCard WHERE ExpiryDate >= CAST(CONVERT(VARCHAR(20), GETDATE(), 101) AS DATETIME) AND AccCode IN (SELECT CustCode FROM SaleLedger WHERE SaleInvCode=@InvoiceCode))

	SET @LoyaltyPolicyCode = (SELECT LoyaltyPolicyCode FROM LoyaltyCard WHERE LoyaltyCardCode = @LoyaltyCardCode)

	SET @LoyaltyAmt = @NetAmt

	SET @LoyaltyPoints = 0

	IF @LoyaltyPolicyCode > 0 AND @LoyaltyCardCode > 0

	BEGIN

		SELECT @LoyaltyPoints=A.LoyaltyPoints, @PointsValue=A.RedemptionValue

		FROM

		(SELECT D.LoyaltyPoints, D.RedemptionValue

		FROM 

			LoyaltyPolicyDetail D, 

			(SELECT SaleLimit=MIN(SaleLimit) 

			FROM LoyaltyPolicyDetail 

			WHERE LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

				SaleLimit >= @LoyaltyAmt

			UNION

			SELECT SaleLimit=MAX(SaleLimit) 

			FROM LoyaltyPolicyDetail 

			WHERE LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

			SaleLimit <= @LoyaltyAmt) T

		WHERE D.LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

			D.SaleLimit = T.SaleLimit AND

			T.SaleLimit <= @LoyaltyAmt) A



		IF @LoyaltyPoint
s > 0 OR @PointsValue > 0

			INSERT INTO LoyaltyCardLedger (LoyaltyCardCode, AccCode, Date, UserCode, PointsDebit, PointsCredit, Debit, Credit, Remarks, InvoiceType, InvoiceCode)

			SELECT L.LoyaltyCardCode, L.AccCode, Date=S.Date, S.SalesManCode, @LoyaltyPoints, 0, Debit=@PointsValue, Credit=0.00, 'Loyalty Points Earned', @InvType, @InvoiceCode

			FROM SaleLedger S, LoyaltyCard L

			WHERE S.SaleInvCode = @InvoiceCode AND

				L.LoyaltyCardCode = @LoyaltyCardCode AND

				S.CustCode = L.AccCode AND

				S.SaleInvCode NOT IN (SELECT DISTINCT InvoiceCode FROM LoyaltyCardLedger WHERE InvoiceType='SV')

	END

	ELSE

	BEGIN

		SET @LoyaltyPoints = 0

		RETURN 0

	END

END



IF @InvType='SR' /*On Sales Return - Loyalty Points Substraction */

BEGIN

	SET @NetAmt = ISNULL((SELECT Amt=DBO.fn_getSRInvLoyaltyTotal(@InvoiceCode)), 0)

	SET @LoyaltyCardCode = (SELECT MIN(LoyaltyCardCode) FROM LoyaltyCard WHERE ExpiryDate >= CAST(CONVERT(VARCHAR(20), GETDATE(), 101) AS DATETIME) AND AccCode IN (SELECT CustCode FROM SRLedger WHERE SRInvCode=@InvoiceCode))

	SET @LoyaltyPolicyCode = (SELECT LoyaltyPolicyCode FROM LoyaltyCard WHERE LoyaltyCardCode = @LoyaltyCardCode)

	SET @LoyaltyAmt = @NetAmt

	SET @LoyaltyPoints = 0

	IF @LoyaltyPolicyCode > 0 AND @LoyaltyCardCode > 0

	BEGIN

		SELECT @LoyaltyPoints=A.LoyaltyPoints, @PointsValue=A.RedemptionValue

		FROM

		(SELECT D.LoyaltyPoints, D.RedemptionValue

		FROM 

			LoyaltyPolicyDetail D, 

			(SELECT SaleLimit=MIN(SaleLimit) 

			FROM LoyaltyPolicyDetail 

			WHERE LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

				SaleLimit >= @LoyaltyAmt

			UNION

			SELECT SaleLimit=MAX(SaleLimit) 

			FROM LoyaltyPolicyDetail 

			WHERE LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

			SaleLimit <= @LoyaltyAmt) T

		WHERE D.LoyaltyPolicyCode=@LoyaltyPolicyCode AND 

			D.SaleLimit = T.SaleLimit AND

			T.SaleLimit <= @LoyaltyAmt) A



		IF @LoyaltyPoints > 0 OR @PointsValue > 0

			INSERT INTO LoyaltyCardLedger (LoyaltyCardCode, AccCode, Date, UserCode, PointsDebit, PointsCredit, 
Debit, Credit, Remarks, InvoiceType, InvoiceCode)

			SELECT L.LoyaltyCardCode, L.AccCode, Date=S.Date, S.SalesManCode, 0, @LoyaltyPoints, Debit=0.00, Credit=@PointsValue, 'Loyalty Points Reversed', @InvType, @InvoiceCode

			FROM SRLedger S, LoyaltyCard L

			WHERE S.SRInvCode = @InvoiceCode AND

				L.LoyaltyCardCode = @LoyaltyCardCode AND

				S.CustCode = L.AccCode AND

				S.SRInvCode NOT IN (SELECT DISTINCT InvoiceCode FROM LoyaltyCardLedger WHERE InvoiceType='SR')

	END

	ELSE

	BEGIN

		SET @LoyaltyPoints = 0

		RETURN 0

	END

END



IF @InvType='RD' /*On Loyalty Points Redemption*/

BEGIN

	INSERT INTO LoyaltyCardLedger (LoyaltyCardCode, AccCode, Date, UserCode, PointsDebit, PointsCredit, Debit, Credit, Remarks, InvoiceType, InvoiceCode)

	SELECT L.LoyaltyCardCode, L.AccCode, Date=LR.Date, LR.UserCode, PointsDebit=0, PointsCredit=LR.PointsRedeemed, Debit=0, Credit=LR.PointsValue, 'Loyalty Points Redeemed', @InvType, @InvoiceCode

	FROM LoyaltyRedemption LR, LoyaltyCard L

	WHERE LR.LoyaltyRedemptionCode = @InvoiceCode AND

		LR.LoyaltyCardCode = L.LoyaltyCardCode AND

		LR.LoyaltyRedemptionCode NOT IN (SELECT DISTINCT InvoiceCode FROM LoyaltyCardLedger WHERE InvoiceType='RD')

END



IF @InvType='AD' /*On Loyalty Points Adjustment*/

BEGIN

	INSERT INTO LoyaltyCardLedger (LoyaltyCardCode, AccCode, Date, UserCode, PointsDebit, PointsCredit, Debit, Credit, Remarks, InvoiceType, InvoiceCode)

	SELECT L.LoyaltyCardCode, L.AccCode, Date=LA.Date, LA.UserCode, 

		PointsDebit=CASE WHEN LA.AdjustmentTypeCode = 1 THEN LA.AdjustedPoints ELSE 0 END, 

		PointsCredit=CASE WHEN LA.AdjustmentTypeCode = 1 THEN 0 ELSE LA.AdjustedPoints END, 

		Debit=CASE WHEN LA.AdjustmentTypeCode = 1 THEN LA.AdjustmentValue ELSE 0 END, 

		Credit=CASE WHEN LA.AdjustmentTypeCode = 1 THEN 0 ELSE LA.AdjustmentValue END, 

		'Loyalty Points ' + CASE WHEN LA.AdjustmentTypeCode = 1 THEN 'Added ' ELSE 'Deducted' END, 

		@InvType, @InvoiceCode

	FROM LoyaltyPointAdjustment LA, LoyaltyCard L

	WHERE LA.AdjustmentCode = @InvoiceCo
de AND

		LA.LoyaltyCardCode = L.LoyaltyCardCode AND

		LA.AdjustmentCode NOT IN (SELECT DISTINCT InvoiceCode FROM LoyaltyCardLedger WHERE InvoiceType='AD')

END



RETURN 0
AND @enddate

UNION ALL

Select H.ChildServer, InvCode=H.AdvSaleInvCode, 

	Sale=ISNULL((SELECT SUM(D.LooseQty) FROM IMP_advsaleDetail D WHERE H.AdvSaleInvCode = D.AdvSaleInvCode AND D.LooseQty > 0), 0), 

	SaleReturn=ISNULL((SELECT SUM(ABS(D.LooseQty)) FROM IMP_advsaleDetail D WHERE H.AdvSaleInvCode = D.AdvSaleInvCode AND D.LooseQty < 0), 0),

	H.RefundAmt, H.InvTotal

From IMP_AdvSaleLedger H

Where 	@invtype = 2 AND

	H.CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE H.CustCode END AND

	H.ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE H.ChildServer END AND

	H.Transmit = 'Y' AND H.Transmited = 'N' AND 

	H.Date BETWEEN @startdate AND @enddate

Order By H.ChildServer, InvCode





IF @@Error <> 0 OR @@RowCount <= 0

BEGIN

	IF @invtype = 1

		RaisError( 'Unable to Fetch Information of Sale Inv. No. %d ' , 16 , 1 , @invcode)

	IF @invtype = 3

		RaisError( 'Unable to Fetch Information of S/R Inv. No. %d ' , 16 , 1 , @invcode)

	ELSE

		RaisError( 'Unable to Fetch Information of Advance Sale Inv. No. %d ' , 16 , 1 , @invcode)

	Set @continue  = -1								

END

ELSE

BEGIN

	Set @sale_rowcount = ISNULL((Select count(*) from #saletemp), 0)

	Set @continue = 0

	Set @invcounter = 1

END



While (@sale_rowcount > 0) And (@continue >= 0) AND (@invcounter <= @sale_rowcount)

Begin

	SELECT @invcode = InvCode, 

		@Sale = ISNULL(Sale, 0), 

		@SaleReturn = ISNULL(SaleReturn, 0),

		@refundamt = ISNULL(RefundAmt, 0),

		@ThisChildServer = ChildServer,

		@InvTotal = InvTotal,

		@SaleInvCode = NULL,

		@SRInvCode = NULL

	FROM #saletemp 

	WHERE ID = @invcounter

	

	IF @@Error <> 0 OR @@RowCount <= 0

	BEGIN

		IF @invtype = 1

			RaisError( 'Unable to Fetch Information of Sale Inv. No. %d ' , 16 , 1 , @invcode)

		IF @invtype = 3

			RaisError( 'Unable to Fetch Information of S/R Inv. No. %d ' , 16 , 1 , @invcode)

		ELSE

			RaisError( 'Unable to Fetch Information of Advance Sale Inv. No. %d ' , 16 , 1 , @invcode)

		Set @continue  = -1								

	END



	IF @Sale > 0 AND @co
ntinue=0

	BEGIN

		-- IF there is no sale return but refund amt on adv. sale exists then merge it with overall flat discount

		IF @refundamt > 0 AND @SaleReturn = 0 

			SET @refund = @refundamt

		ELSE

			SET @refund = 0



		set @continue = 0



		Execute @rt_code = sp_Translate_ChildeServer_Sale @ThisChildServer, @invtype, @invcode, @usercode, @refund, @SaleInvCode

		IF @@Error <> 0 OR @rt_code <> 0 

		Begin

			IF @invtype = 1

				RaisError( 'Unable to Generate Sale Invoice No. %d FROM Sale Inv. No. %d ' , 16 , 1 , @SaleInvCode, @invcode)

			ELSE

				RaisError( 'Unable to Generate Sale Invoice No. %d FROM Advance Sale Inv. No. %d ' , 16 , 1 , @SaleInvCode, @invcode)

			Set @continue  = -1								

		End



		IF @SaleInvCode > 0

			Set @Sale_InvTotal = dbo.fn_getSaleInvTotal (@SaleInvCode)

		ELSE

			Set @Sale_InvTotal = 0



		SET @FLAG = 1

	END

	IF @SaleReturn > 0 AND @continue = 0

	BEGIN

		IF @invtype = 2

		BEGIN

			-- IF refund amt on adv. sale exists then merge it with sales return

			IF @refundamt > 0

				SET @refund = @refundamt

			ELSE

				SET @refund = 0



			set @continue = 0

			Execute @rt_code = sp_Translate_ChildeServer_SaleReturn @ThisChildServer, @invcode, @usercode, @refund, @SRInvCode

			IF @@Error <> 0 OR @rt_code <> 0 

			Begin

				RaisError( 'Unable to Generate Sale Return No. %d FROM Advance Sale Inv. No. %d ' , 16 , 1 , @SRInvCode, @invcode)

				Set @continue  = -1								

			End

		END

		IF @invtype = 3

		BEGIN

			SET @refund = 0



			set @continue = 0

			Execute @rt_code = sp_Translate_ChildeServer_SReturn @ThisChildServer, @invcode, @usercode, @SRInvCode OUTPUT

			IF @@Error <> 0 OR @rt_code <> 0 

			Begin

				RaisError( 'Unable to Generate Sale Return No. %d FROM Old S/R No. %d ' , 16 , 1 , @SRInvCode, @invcode)

				Set @continue  = -1								

			End

		END

		



		IF @SRInvCode > 0

			Set @Ret_InvTotal = dbo.fn_getSRInvTotal (@SRInvCode)

		ELSE

			Set @Ret_InvTotal = 0



		SET @FLAG = 1

	END



	IF @invtype = 2

		SET @InvTotal_
edger.postdate = GetDate(),

				SaleLedger.postedby = @ai_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

		ELSE

		BEGIN

			INSERT INTO #lt_invoicelist 

			SELECT SaleInvCode

			FROM SaleLedger

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode IN (1, 2) AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleLedger.postdate = GetDate(),

				SaleLedger.postedby = @ai_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode IN (1, 2) AND

				SaleLedger.CustCode = @ai_custcode AND

				SaleLedger.Posted = 'N' AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

	END

END

ELSE

BEGIN

	IF @savebal = 'Y'

	BEGIN

		IF @ai_SalCatCode = 3

		BEGIN

			INSERT INTO #lt_invoicelist 

			SELECT SaleInvCode

			FROM SaleLedger

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleLedger.postdate = GetDate(),

				SaleLedger.postedby = @a
Diff = ISNULL(@InvTotal, 0) - ISNULL(@Sale_InvTotal, 0) - ISNULL(@Ret_InvTotal, 0)



	IF @SaleInvCode > 0

	BEGIN

		IF @InvTotal_Diff > 0

			UPDATE Dbo.SaleLedger SET MiscCharges = ISNULL(MiscCharges, 0) + @InvTotal_Diff WHERE SaleInvCode = @SaleInvCode



		IF @InvTotal_Diff < 0

		BEGIN

			IF @Sale_InvTotal > ABS(@InvTotal_Diff)

				UPDATE Dbo.SaleLedger SET FlatDisc = ISNULL(FlatDisc, 0) + ABS(@InvTotal_Diff) WHERE SaleInvCode = @SaleInvCode

			ELSE

				UPDATE Dbo.SaleLedger SET FlatDisc = ISNULL(FlatDisc, 0) + ISNULL(@Sale_InvTotal, 0) WHERE SaleInvCode = @SaleInvCode



			UPDATE Dbo.SaleLedger SET InvTotal = ISNULL(dbo.fn_getSaleInvTotal (@SaleInvCode), 0) WHERE SaleInvCode = @SaleInvCode

		END



		Set @Sale_InvTotal = dbo.fn_getSaleInvTotal (@SaleInvCode)

	END

	ELSE

		Set @Sale_InvTotal = 0



	SET @InvTotal_Diff = ISNULL(@InvTotal, 0) - ISNULL(@Sale_InvTotal, 0) - ISNULL(@Ret_InvTotal, 0)



	IF @SRInvCode > 0

	BEGIN

		-- If No sales but only return exists then swap flatdisc and mischarges to keep totals intact

		IF @sale <= 0 AND @invtype <> 3

			UPDATE Dbo.SRLedger 

			SET FlatDisc = ISNULL(MiscCharges, 0), 

				MiscCharges = ISNULL(FlatDisc, 0) 

			WHERE SRInvCode = @SRInvCode



		IF @InvTotal_Diff > 0 AND @SaleInvCode <= 0 AND @invtype <> 3

			IF @Ret_InvTotal > ABS(@InvTotal_Diff)

				UPDATE Dbo.SRLedger SET FlatDisc = ISNULL(FlatDisc, 0) + ABS(@InvTotal_Diff) WHERE SRInvCode = @SRInvCode

			ELSE

				UPDATE Dbo.SRLedger SET FlatDisc = ISNULL(FlatDisc, 0) + ABS(@Ret_InvTotal) WHERE SRInvCode = @SRInvCode



		IF @InvTotal_Diff < 0 AND @invtype <> 3

			UPDATE Dbo.SRLedger SET MiscCharges = ISNULL(MiscCharges, 0) + ABS(@InvTotal_Diff) WHERE SRInvCode = @SRInvCode



		UPDATE Dbo.SRLedger SET InvTotal = ISNULL(dbo.fn_getSRInvTotal (@SRInvCode), 0) WHERE SRInvCode = @SRInvCode



--		Set @Ret_InvTotal = dbo.fn_getSRInvTotal (@SRInvCode)

	END



	Set @invcounter = @invcounter + 1


End



IF @continue=0 

BEGIN

	IF @invtype = 1

		UPDATE IMP_SaleLedger SET Transmited 
= 'Y'

		WHERE CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE CustCode END AND

			ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE ChildServer END AND

			Transmit = 'Y' AND Transmited = 'N' AND 

			Date BETWEEN @startdate AND @enddate

	IF @invtype = 3

		UPDATE IMP_SRLedger SET Transmited = 'Y'

		WHERE CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE CustCode END AND

			ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE ChildServer END AND

			Transmit = 'Y' AND Transmited = 'N' AND 

			Date BETWEEN @startdate AND @enddate

	ELSE

		UPDATE IMP_AdvSaleLedger SET Transmited = 'Y'

		WHERE CustCode = CASE WHEN @CustCode > 0 THEN @CustCode ELSE CustCode END AND

			ChildServer = CASE WHEN LEN(@childserver) > 0 THEN @childserver ELSE ChildServer END AND

			Transmit = 'Y' AND Transmited = 'N' AND 

			Date BETWEEN @startdate AND @enddate

END



IF @continue=0 AND @FLAG=1

BEGIN

	SET @dt = GETDATE()

	set @continue = 0

	Execute @rt_code = SP_Set_DateTime_Preference 'LastSaleSynchronized', @dt

	IF @@Error <> 0 OR @rt_code <> 0 

	Begin

		RaisError( 'Unable to Record Last Sale Synchronization Information in Software Preferences' , 16 , 1)

		Set @continue  = -1								

	End

END



Drop Table #saletemp



Return @continue
ALTER  PROCEDURE DBO.SP_VirtualGL_SalesReturn

AS



SET NOCOUNT ON



DECLARE @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), @ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0)



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')



SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



CREATE TABLE #lt_sret (code INT NOT NULL)

INSERT INTO #lt_sret

SELECT  SRInvCode FROM SRLedger S

WHERE S.posted = 'Y'	 and S.accountfor = 'Y' AND

	S.SRInvCode NOT IN (SELECT DISTINCT DocumentCode FROM VirtualGL V WHERE V.DocumentType = 'SR')



INSERT INTO VirtualGLTemp	/*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srp
rice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL,
 GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * CASE WHEN S.SaleInvCode > 0 THEN D.AvgPrice ELSE (D.SRPrice * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01)) END),0),

	S.CurrencyCode, S.ConversionRate, AdvIncomeTax=ISNULL(S.AdvanceTaxAmt,0), FBRPosFee= ISNULL(S.FBRPosFee,0)

FROM srledger S, srdetail D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt, S.FBRPosFee



INSERT INTO VirtualGLTemp	/*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate, AdvIncomeT
i_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

		ELSE

		BEGIN

			WHILE @saleinvcode <= @ai_LInvCode

			BEGIN

				SET @custcode = 0

				SET @balance = 0

			

				SET @custcode = 

					(SELECT custcode FROM SaleLedger 

					WHERE SaleInvCode = @saleinvcode AND 

						SaleLedger.SaleCatCode  IN (1,2) AND 

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL)

				SET @dt = GetDate()

				IF @custcode IS NOT NULL

				BEGIN

					EXECUTE SP_OPENINGBALANCE @custcode, @dt, @balance OUTPUT

	

					INSERT INTO #lt_invoicelist 

					SELECT SaleInvCode

					FROM SaleLedger

					Where SaleLedger.SaleInvCode = @saleinvcode AND

						SaleLedger.SaleCatCode IN (1,2) AND /* all credit sales */

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL



					Update  SaleLedger

					Set  SaleLedger.posted   = 'Y',

						SaleLedger.postdate = GetDate(),

						SaleLedger.postedby = @ai_SalesmanCode,

						SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

						SaleLedger.Balance = @balance

					Where SaleLedger.SaleInvCode = @saleinvcode AND

						SaleLedger.SaleCatCode IN (1,2) AND /* all credit sales */

						SaleLedger.Posted = 'N' AND

						SaleLedger.Deleted = 'N' AND

						SaleLedger.ImpactInventory = @ac_impactinventory AND

						SaleLedger.AdmissionCode IS NULL

				END

			

				SET @saleinvcode = @saleinvcode + 1

	

			END

		END

	END

	ELSE

	BEGIN

		IF @ai_SalCatCode = 3

		BEGIN

			INSERT INTO #lt_invoicelist 

			SE
LECT SaleInvCode

			FROM SaleLedger

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleLedger.postdate = GetDate(),

				SaleLedger.postedby = @ai_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode = 3 AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

		ELSE

		BEGIN

			INSERT INTO #lt_invoicelist 

			SELECT SaleInvCode

			FROM SaleLedger

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode IN (1, 2) AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL



			Update  SaleLedger

			Set  SaleLedger.posted   = 'Y',

				SaleLedger.postdate = GetDate(),

				SaleLedger.postedby = @ai_SalesmanCode,

				SaleLedger.UnReceivedBalance = SaleLedger.InvTotal,

				SaleLedger.Balance = 0

			Where  	 SaleLedger.SaleInvCode Between @ai_sInvCode AND @ai_lInvCode AND

				SaleLedger.SaleCatCode IN (1, 2) AND

				SaleLedger.Posted = 'N'	AND

				SaleLedger.Deleted = 'N' AND

				SaleLedger.ImpactInventory = @ac_impactinventory AND

				SaleLedger.AdmissionCode IS NULL

		END

	END

END

SET @RowID = 1

SET @TotRows = ISNULL((SELECT COUNT(*) FROM #lt_invoicelist), 0)



WHILE @RowID <= @TotRows

BEGIN

	SET @SaleInvCode = (SELECT Code FROM #lt_invoicelist WHERE RowID = @RowID)

	IF @loyalty = 'Y'

	BEGIN

		EXECUTE @rt_code = DBO.SP_ManageLoyaltyPoints 'SV', @SaleInvCode

		IF @@ERROR
 <> 0 OR @rt_code <>  0

		BEGIN

			RaisError('Unable to Add Loyalty Points for Customer on Sale Posting' , 16 , 1)

			RETURN -1

		END

	END



/*	IF @AutoFiscalize = 'Y'

	BEGIN

		EXECUTE @rt_code = DBO.SP_FiscalizeSaleInvoice @SaleInvCode, @ai_SalesmanCode

		IF @@ERROR <> 0 OR @rt_code <>  0

		BEGIN

			RaisError('Unable to Fiscalize Sale Invoice on Sale Posting, Sale Invoice Code = #d' , 16 , 1, @SaleInvCode)

			RETURN -1

		END

	END

*/

	SET @ai_list = @ai_list + LTRIM(RTRIM(STR(@SaleInvCode,10))) + ','

	SET @RowID = @RowID + 1

END



IF Right(@ai_list,1) = ','

	SET @ai_list = LEFT(@ai_list, LEN(@ai_list) - 1)



EXECUTE @rt_code = DBO.SP_CreateAutoTriggerSMS @ai_list, 1, 'Posting'

IF @@ERROR <> 0 OR @rt_code <>  0

BEGIN

	RaisError('Unable to Create Auto Trigger SMS on Sale Posting' , 16 , 1)

	RETURN -1

END



EXECUTE @rt_code = DBO.SP_UpdateItemMeter @ai_list

IF @@ERROR <> 0 OR @rt_code <>  0

BEGIN

	RaisError('Unable to Update Item Meter on Sale Posting' , 16 , 1)

	RETURN -1

END



RETURN 0
ALTER  PROCEDURE DBO.SP_GetSaleInvoice_JSON @SaleInvCode INT, @JSON VARCHAR(8000) OUTPUT

AS

SET NOCOUNT ON



DECLARE @Qry VARCHAR(8000), @Q VARCHAR(8000), @PosID VARCHAR(100)



SET @PosID = ISNULL(DBO.Fn_GetPreference('FBRPOSID'),'')

SET @Qry = ''



--910247



DECLARE C1 CURSOR FOR 

SELECT A

FROM 

(SELECT A='{"InvoiceNumber":"","POSID":"' + @PosID + '","USIN":"' + LTRIM(RTRIM(STR(S.SaleInvCode))) + 

'","DateTime":"' + CONVERT(VARCHAR(100), S.DATE, 121) + 

'","BuyerNTN":"' + ISNULL(C.NTNNo,'') + '","BuyerCNIC":"' + ISNULL(C.NIC,'') + '","BuyerName":"' + ISNULL(A.Name,'') + '","BuyerPhoneNumber":"' + ISNULL(C.Phone,'') + '","TotalBillAmount":"' + LTRIM(RTRIM(STR(S.InvTotal,12, 2))) + 

'","TotalQuantity":"' + LTRIM(RTRIM(STR(ISNULL((SELECT SUM(D.LooseQty + D.BonusQty) FROM SaleDetail D WHERE D.SaleInvCode = @SaleInvCode),0)))) + '","TotalSaleValue":"' + LTRIM(RTRIM(STR(ISNULL(S.InvTotal,0) - ISNULL(DBO.fn_getTaxOnSaleInv(S.SaleInvCode),0),12, 2))) + 

'","TotalTaxCharged":"' + LTRIM(RTRIM(STR(DBO.fn_getTaxOnSaleInv(S.SaleInvCode), 12,2))) + 

'","Discount":"'+ LTRIM(RTRIM(STR(ISNULL((SELECT SUM(ROUND((D.LooseQty * D.ItemFlatDisc) + (D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (D.DiscPerc * 0.01)), 2)) FROM SaleDetail D WHERE D.SaleInvCode = @SaleInvCode),0),12,2)))  + '","FurtherTax":"0.0","PaymentMode":"1","RefUSIN":"null","InvoiceType":"1","Items":['

FROM SaleLedger S, Customer C, Accounts A

WHERE S.SaleInvCode=@SaleInvCode AND S.CustCode=C.CustCode AND S.CustCode=A.AccCode

UNION ALL

SELECT A='{"ItemCode":"' + I.customICode + '","ItemName":"' + I.Name + '","Quantity":"' + LTRIM(RTRIM(STR(D.LooseQty + D.BonusQty, 10,4))) +

'","PCTCode":"' + P.Description + '","TaxRate":"' + LTRIM(RTRIM(STR(STS.TaxPerc, 6, 2))) + '","SaleValue":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SalePrice, 12, 2))) + '","TotalAmount":"' + LTRIM(RTRIM(STR(D.LooseQty * D.SalePrice,12, 2))) + '","TaxCharged":"' + LTRIM(RTRIM(STR((D.LooseQty + D.BonusQty) * D.UnitSalesTax,12,2))) + '","Discount":"' + LTRIM(RTRIM(STR(ROUN
D((D.LooseQty * D.ItemFlatDisc) + 

(D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (D.DiscPerc * 0.01)), 2),12,2))) + '","FurtherTax":"0.0","InvoiceType":"1","RefUSIN":"null"},'

FROM SaleDetail D, Item I, PCT P, SalesTaxSchedule STS

WHERE D.SaleInvCode=@SaleInvCode AND D.ICode=I.ICode AND I.PCTCode = P.PCTCode AND I.SalesTaxScheduleCode=STS.SalesTaxScheduleCode) T 



OPEN C1



FETCH NEXT FROM C1

INTO @Q



WHILE @@FETCH_STATUS = 0

BEGIN

	SET @Qry = @Qry + @Q

	FETCH NEXT FROM C1

	INTO @Q

END

SET @JSON = ''



IF Right(@Qry, 1) = ',' 

	SET @Qry = LEFT(@Qry, LEN(@Qry) - 1)



SET @JSON = @Qry + ']}'



Print @JSon



CLOSE C1

DEALLOCATE C1

RETURN 0
ALTER  PROCEDURE dbo.SP_FiscalizeSaleInvoice @SaleInvCode INT, @UserCode SMALLINT

AS

SET NOCOUNT ON

DECLARE @Url varchar(1024), @HttpMethod varchar(10), @ParamsValues varchar(8000), @SoapAction varchar(1024), @Response varchar(8000)

DECLARE @rt_code INT, @UseTestSvc CHAR(1), @FiscalInvCode VARCHAR(100)



IF ISNULL((SELECT MAX(Fiscalized) FROM SaleLedger WHERE SaleInvCode = @SaleInvCode), 'N') = 'Y'

	RETURN 0



CREATE TABLE #ResonseTab (status varchar(50), statusText varchar(1024), response varchar(4000))



SET @UseTestSvc = ISNULL(DBO.Fn_GetPreference('UseFBRTestService'),'Y')

IF @UseTestSvc = 'Y'

BEGIN

	SET @Url = ISNULL(DBO.Fn_GetPreference('FBRTestServiceURL'), 'http://localhost:8524/api/IMSFiscal/Get')

	SET @HttpMethod = 'GET'

END

ELSE

BEGIN

	SET @Url = ISNULL(DBO.Fn_GetPreference('FBRInvoiceServiceURL'), 'http://localhost:8524/api/IMSFiscal/GetInvoiceNumberByModel')

	SET @HttpMethod = 'POST'

END

SET @SoapAction = null

SET @ParamsValues = ''



EXECUTE @rt_code = DBO.SP_GetSaleInvoice_JSON @SaleInvCode, @ParamsValues OUTPUT

IF @@ERROR <> 0 OR @rt_code <>  0

BEGIN

	RaisError('Unable to Generate JSON String for Fiscalization of Sale Invoice %d' , 16 , 1, @SaleInvCode)

	RETURN -1

END



IF LEN(@Url) > 0 AND LEN(@ParamsValues) > 0 AND LEN(@HttpMethod) > 0

BEGIN

	INSERT INTO #ResonseTab (status, statusText, response)	

	EXECUTE @rt_code = DBO.SP_RequestHttpWebService @Url, @HttpMethod, @ParamsValues, @SoapAction

	IF @@ERROR <> 0 OR @rt_code <>  0

	BEGIN

		RaisError('Unable to send web service request sucessfully for Fiscalization of Sale Invoice %d' , 16 , 1, @SaleInvCode)

		RETURN -1

	END



	SET @Response = (SELECT MAX(response) FROM #ResonseTab)

	PRINT @Response

	IF CHARINDEX('"Code":"100"', @Response, 1) > 0

	BEGIN

		IF CHARINDEX('{"InvoiceNumber":"', @Response, 1) > 0

		BEGIN

			SET @FiscalInvCode = ISNULL(SUBSTRING(@Response, 19, CHARINDEX('","Code":"100"', @Response, 1) - 19), '')



			PRINT @FiscalInvCode



			UPDATE SaleLedger SET Fiscalized = 'Y', Fisca
lizedOn = GETDATE(), FiscalInvoiceNo = ISNULL(@FiscalInvCode, '')

			WHERE SaleInvCode = @SaleInvCode

		END

	END

	ELSE

	BEGIN

		RaisError('Unable to Get Fiscal Invoice Code sucessfully for Sale Invoice %d' , 16 , 1, @SaleInvCode)

		RETURN -1

	END

END



RETURN 0
ALTER  FUNCTION DBO.Fn_GetUnposted_SalesReturn ()

RETURNS @retTable TABLE (

	documentcode INT NOT NULL,

	documenttype VARCHAR (20)  NOT NULL,

	catcode TINYINT NOT NULL ,

	dr_acccode SMALLINT NOT NULL ,

	cr_acccode SMALLINT NOT NULL ,

	AlternateAccCode SMALLINT NULL ,

	date DATETIME NOT NULL ,

	SaleTax NUMERIC(15, 2) NOT NULL ,

	Gross NUMERIC(15, 2) NOT NULL ,

	dr_remarks VARCHAR (100)  NULL ,

	cr_remarks VARCHAR (100)  NULL ,

	Saletax_remarks VARCHAR (100)  NULL ,

	checkNo VARCHAR (20)  NULL ,

	usercode SMALLINT NULL ,

	VoucherCode INT NULL ,

	InvoiceCode INT NULL ,

	InvoiceType TINYINT NULL ,

	Amt NUMERIC(15, 2) NOT NULL,

	DrAmtAccCode INT NULL ,

	CrAmtAccCode INT NULL ,

	AmtBy SMALLINT NULL ,

	AmtDate DATETIME NULL ,

	AmtRef VARCHAR (60)  NULL ,

	OutstandingAmt NUMERIC(15, 2) NOT NULL,

	Balance NUMERIC(15, 2) NOT NULL,

	PatientCode INT NULL ,

	GRN VARCHAR (100)  NULL ,

	GCCode SMALLINT NULL ,

	Vehicle VARCHAR (100) NULL ,

	ShipTo VARCHAR (100)  NULL ,

	GuestCode INT NULL ,

	StudentCode INT NULL,

	CGS NUMERIC(15, 2) NOT NULL,

	CurrencyCode SMALLINT NULL, 

	ConversionRate NUMERIC(11,5) NULL,

	AdvIncomeTax NUMERIC(12,2) NOT NULL,

	FBRPosFee NUMERIC(5,2) NOT NULL)

AS

BEGIN



DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT, @ln_salesacc INT, 

	@ln_salesretacc INT, @ln_purchaseretacc INT, @ln_revfromservice INT, @ln_salestaxacc INT,

	@ln_invacc INT, @ln_cgs INT



DECLARE @SRRemks CHAR(1), @InvSys CHAR(1), @RoundUpYo TINYINT



SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'G
T_SalesReturnACC')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')



SET @SRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowSRetRemarksInLedger' ))



INSERT INTO @retTable /*accounting for sales return*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = @ln_salesretacc,

	cr_acccode = CASE S.srCatCode WHEN 6 THEN S.CashAccCode /* Cash S/Return*/ 

		WHEN 8 THEN S.CashAccCode /* Cash S/Return*/ ELSE S.custcode /* Credit S/Return*/ END,

	AlternateAccCode = CASE S.srCatCode WHEN 6 THEN S.custcode /* Cash S/Return*/

		WHEN 8 THEN S.custcode /* Cash S/Return*/ ELSE NULL /* Credit S/Return*/ END,

	Date    = S.date,

	SaleTax=ROUND(

		SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 

		SUM(ROUND( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +

		ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

			(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo),

	Gross= Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 

		    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo),

	dr_remarks = 'Revenue (reversal) on ' + CASE S.SRCatCode WHEN 6 THEN 'cash'

		WHEN 8 THEN 'cash' ELSE 'cr.' END + ' sale ret. #: ' + 

		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,

	cr_remarks = CASE @SRRemks WHEN 'Y' THEN S.Remarks

		ELSE CASE S.SRCatCode WHEN 6 THEN 'Cash paid on sale ret.#: '

			WHEN 8 THEN 'Cash paid on sale ret.#: ' ELSE 'Payable on cr. sale ret.#: ' END +

			RTRIM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode))) + 

			CASE WHEN S.saleinvcode is null Then '' 

			     ELSE ', Sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END

		END,

	saletax_remarks= 'S.Tax ' + 

		CASE S.SRCatCode WHEN 6 THEN 'Paid' WHEN 8 THEN 'Paid' ELSE 'Payable' END + 

		' on sale ret. #: ' +  RTR
INSERT INTO RightsClone (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1732, 'Reports , Sales Reports , Category Wise , Category Wise Day Net Sale ', 'Category Wise Day Net Sale', 3, '5,3,2,23,', 'A', 1

INSERT INTO Rights (RightCode, RightName, MenuName, LevelIndex, IndicesString, Object, RightCatCode) SELECT 1732, 'Reports , Sales Reports , Category Wise , Category Wise Day Net Sale ', 'Category Wise Day Net Sale', 3, '5,3,2,23,', 'A', 1

INSERT INTO GroupRights (GroupCode, RightCode, Status) SELECT 2, 1732, 1ALTER TABLE DBO.IMP_SRDetail ADD

ItemAdvanceTaxPerc NUMERIC(5,2) NOT NULL CONSTRAINT DF_IMP_SRDetail_ItemAdvanceTaxPerc DEFAULT (0)ALTER TABLE DBO.IMP_SRLedger ADD 

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_IMP_SRLedger_AdvanceTax DEFAULT ('N'), 

AdvanceTaxAmt NUMERIC(12,2) NOT NULL CONSTRAINT DF_IMP_SRLedger_AdvanceTaxAmt DEFAULT (0),

FBRPOSFee NUMERIC(5,2) NOT NULL CONSTRAINT DF_IMP_SRLedger_FBRPOSFee DEFAULT (0)ALTER TABLE DBO.IMP_SaleDetail ADD

ItemAdvanceTaxPerc NUMERIC(5,2) NOT NULL CONSTRAINT DF_IMP_SaleDetail_ItemAdvanceTaxPerc DEFAULT (0)ALTER TABLE DBO.IMP_SaleLedger ADD 

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_IMP_SaleLedger_AdvanceTax DEFAULT ('N'), 

AdvanceTaxAmt NUMERIC(12,2) NOT NULL CONSTRAINT DF_IMP_SaleLedger_AdvanceTaxAmt DEFAULT (0),

FBRPOSFee NUMERIC(5,2) NOT NULL CONSTRAINT DF_IMP_SaleLedger_FBRPOSFee DEFAULT (0)ALTER TABLE DBO.SRBufferLedger ADD 

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_SRBufferLedger_AdvanceTax DEFAULT ('N'), 

AdvanceTaxAmt NUMERIC(12,2) NOT NULL CONSTRAINT DF_SRBufferLedger_AdvanceTaxAmt DEFAULT (0),

FBRPOSFee NUMERIC(5,2) NOT NULL CONSTRAINT DF_SRBufferLedger_FBRPOSFee DEFAULT (0)ALTER TABLE DBO.SRLedger ADD 

AdvanceTax CHAR(1) NOT NULL CONSTRAINT DF_SRLedger_AdvanceTax DEFAULT ('N'), 

AdvanceTaxAmt NUMERIC(12,2) NOT NULL CONSTRAINT DF_SRLedger_AdvanceTaxAmt DEFAULT (0),

FBRPOSFee NUMERIC(5,2) NOT NULL CONSTRAINT DF_SRLedger_FBRPOSFee DEFAULT (0)
IM(LTRIM(CONVERT(VARCHAR(12), S.srinvcode)))+ 

		CASE WHEN S.saleinvcode is null Then '' 

		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,
	CheckNo = NULL, 

	UserCode= ISNULL(S.salesmancode, 0), vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales return*/,

	Amt =  CASE S.SRCatCode WHEN 8 THEN 0 ELSE S.Amt END,

	DrAmtAccCode = S.Custcode, CrAmtAccCode = S.PaymentAccCode, AmtBy = S.AmtBy,

	AmtDate = S.AmtDate, AmtRef = S.AmtReference,

	OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

			CASE WHEN S.AdmissionCode IS NULL THEN NULL

			ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

			END

		ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode,

	CGS=ISNULL(SUM((D.looseqty + D.bonusqty) * D.AvgPrice),0), S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax=ISNULL(S.AdvanceTaxAmt,0), FBRPosFee= ISNULL(S.FBRPosFee,0)

FROM srledger S, srdetail D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.srinvcode 

GROUP BY S.srinvcode, S.custcode, S.srcatcode, S.CashAccCode, S.date, S.discperc, S.misccharges,

	 S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.saleinvcode, S.Amt,

	 S.PaymentAccCode, S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt,

	 S.PatientCode, S.AdmissionCode, S.CashAccCode, S.Remarks,

	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt, S.FBRPosFee

UNION ALL /*accounting for cash received via master cash window during sales*/

SELECT  documentcode = S.srinvcode, documenttype = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = S.CashAccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = S.CashCharged,

	dr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))), 

	cr_remarks = 'Cash Paid on S/R No.' + LTRIM(RTRIM(STR(S.SRInvCode, 10))),

	saletax_remarks
ax=0.00, FBRPosFee=0.00

FROM srledger S

WHERE S.SRCatCode NOT IN (6, 8) AND S.CashCharged > 0 AND 

	S.srinvcode IN (SELECT Code FROM #lt_sret)

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0,

	S.CurrencyCode, S.ConversionRate,AdvIncomeTax=0.00, FBRPosFee=0.00

FROM srledger S, MasterCashWin D

WHERE S.srinvcode IN (SELECT Code FROM #lt_sret) AND S.srinvcode = D.DocumentCode



TRUNCATE TABLE #lt_sret
ALTER  PROCEDURE dbo.SP_Transmit_ChildServerSales

	@CustCode INT,

	@StartDate DATETIME,

	@EndDate DATETIME,

	@SRV VARCHAR(255), 

	@PARENTSRV VARCHAR(255), 

	@DB VARCHAR(50), 

	@OWNER VARCHAR(20),

	@SaleType INT

AS



SET XACT_ABORT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



/* Variables to be used in import process */

DECLARE @INS VARCHAR(4000), @SQL VARCHAR(4000), @WHR VARCHAR(4000), @WHR_Cln VARCHAR(4000), @Query VARCHAR(4000), @stdate VARCHAR(100), @edate VARCHAR(100)

DECLARE @err INT, @rt_code INT

DECLARE @dt DATETIME



SET @stdate = (SELECT CONVERT(VARCHAR(100), @StartDate, 110) + ' ' + CONVERT(VARCHAR(100), @StartDate, 114))

SET @edate  = (SELECT CONVERT(VARCHAR(100), @EndDate, 110)   + ' ' + CONVERT(VARCHAR(100), @EndDate  , 114))



IF @SaleType = 1

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SaleLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 1, SaleInvCode, SaleCatCode , CustCode , SalesmanCode, date, DiscPerc, FlatDisc, MiscCharges, SalesTax, Posted, PostDate, Remarks, CustRefNo, headerno, headerinvno, OriginalDate, ModifiedBy, PostedBy, SPrice, QuotationNo, DoctCode, PatientCode, RePrintingCounter, CashReceived, InvGSTPerc1, PrintWaranty, PrintBatch, MessageCode, SManCode, InvoiceSize, CustRefno2, CustRefno3, CustRefno4, GSTNO, InvTotal, MachineName, ModifyCounter, itemdiscpercno, RelationCode, DiseaseCode, WardCode, AdmissionCode, ReturnCounter, Paid, BillingDate, UnReceivedBalance, TotalOfSaleReturns, ListOfSrInvoices, printbalance, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt, Marked, Transferable, Transfered, TransferedOn, TransferedBy, Imported, ImportedBy, deliveredby, SaleTypeCode, Balance, PptCustCode, DELETED, PresCode, ImpactInventory, SaleOrderCode, SaleComments1, SaleComments2, AlterSaleInvCode, RecurringInvoice, RecurringPeriod, LastRecurringInvCode, RecurringAgainst, ConsiderInPO, Vis
itCode, DueDate, SRBufferInvCode, CustRefNo5, GCCode, GRN, SuppInvCode,  Vehicle, ShipTo, GuaranteePersonCode, CashTendered, CashCharged, CashBack, CashAccCode, CustLicNo, CustLicExpiry, ModuleId, DocCode=SaleInvCode, SaleTypeInvNo, CRS_Transfered, CRS_TransferedOn, GuestCode, GuestCheckInCode, StudentCode, CustSiteCode, Transmit, Transmited, Fiscalized, FiscalizedOn, FiscalInvoiceNo, AdvanceTax, AdvanceTaxAmt, FBRPOSFee FROM SaleLedger '



END

IF @SaleType = 2

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_AdvSaleLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 2, * FROM AdvSaleLedger '

END

IF @SaleType = 3

BEGIN

	SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SRLedger '

	SET @SQL = N' SELECT ServerName=' + '''' + @SRV + ''', TransDate=GETDATE(), InvType = 3, SRInvCode,SaleInvCode,Date,SRCatCode,CustCode,SalesmanCode,DiscPerc,FlatDisc,MiscCharges,Posted,PostDate,Remarks,SalesTax,OriginalDate,ModifiedBy,PostedBy,HeaderNo,InvGSTPerc1,Smancode,CustRefno,CustRefno2,CustRefno3,CustRefno4,PatientCode,MachineName,HeaderInvNo,AdmissionCode,invtotal,AccountFor,PaymentMode,PaymentAccCode,Amt,AmtBY,AmtDate,AmtReference,OutstandingAmt,Marked,PageSize,ReprintingCounter,DoctCode,ConsiderInPO,CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSummary,CRS_Transfered,CRS_TransferedOn,GuestCode,GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,FiscalizedOn,FiscalInvoiceNo,Transmit,Transmited,AdvanceTax,AdvanceTaxAmt,FBRPOSFee FROM SRLedger '

END



IF @CustCode IS NULL

BEGIN

	SET @WHR = N' WHERE Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39)

END

ELSE

BEGIN

	SET @WHR = N' WHERE CustCode = ' + (SELECT LTRIM(RTRIM(STR(@CustCode, 
8)))) + ' AND Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39)

END

SET @WHR_Cln = @WHR

SET @Query = @INS + @SQL + @WHR

EXECUTE (@Query)

SET @err = @@ERROR

IF @@ERROR <> 0 OR @err <> 0

BEGIN

	RAISERROR('Transmit Sales Data Problem: Error Transfering Sales Data From Server (%s) TO Server (%s) ', 16, 1, @SRV, @PARENTSRV)

	RETURN -1

END 

ELSE

BEGIN

	IF @SaleType = 1

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SaleDetail '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''', SaleInvcode, ICode, GCode, Batch, Expiry, PackQty, LooseQty, PackUnits, SalePrice, AvgPrice, Rate, DiscPerc, SalesTax, RowID, Due, SatisfiedDate, itemflatdisc, SaleItemDescription, PackPrice, UnitSalesTax, GSTPerc, SaleUtn, bonusqty, claimable, balancestock, RowGroup, ClaimableDiscPerc, ManfDate, PackQtyForSale, BonusPackQtyForSale, SaleOrderRowID, DescICode, SourceSaleInvCode=SaleInvCode, SaleRowID=NULL, IssueRowID=NULL, PurUnitRate, RPPUnitRate, TotalPieces, PiecesInHand, PackSalePrice, RefusalSaleRowID=NULL, AlternatePurPrice, CommissionPerUnit, CommissionPerc, AlternateCustomICode, BatchCost, ItemAdvanceTaxPerc FROM SaleDetail WHERE SaleInvCode IN (SELECT SaleInvCode FROM SaleLedger '

	END

	IF @SaleType = 2

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_AdvSaleDetail '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''', * FROM AdvSaleDetail WHERE AdvSaleInvCode IN (SELECT AdvSaleInvCode FROM AdvSaleLedger '

	END

	IF @SaleType = 3

	BEGIN

		SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_SRDetail (ChildServer,SRInvcode,Icode,Gcode,Batch,Expiry,PackQty,LooseQty,PackUnits,SRPrice,DiscPerc,SalesTax,AvgPrice,UnitSalesTax,GSTPerc,SRUtn,BonusQty,S
= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sale return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM srledger S

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.SRCatCode <> 8 AND S.CashCharged > 0

UNION ALL

SELECT  documentcode = S.srinvcode, documenttype    = 'SR', catcode = S.SRCatCode,

	dr_acccode = S.CustCode,

	cr_acccode = D.AccCode,

	AlternateAccCode = Null, Date    = S.date, SaleTax= 0,

	Gross = Amount,

	dr_remarks = D.Remarks, cr_remarks = D.Remarks,

	saletax_remarks= '', CheckNo = NULL, 

	UserCode= S.salesmancode, vouchercode= S.srinvcode, invoicecode= S.srinvcode,

	invoicetype = 3 /*3 stands for sales Return*/,

	Amt = 0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL, AmtDate = NULL,

	AmtRef = NULL, OutstandingAmt = S.OutstandingAmt, Balance = 0,

	PatientCode=CASE WHEN S.PatientCode IS NULL THEN 

					CASE WHEN S.AdmissionCode IS NULL THEN NULL

					ELSE (SELECT A.Patientcode FROM PatientAdmission A WHERE S.AdmissionCode = A.AdmissionCode)

					END

				ELSE S.PatientCode END,

	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, S.GuestCode, S.StudentCode, CGS=0, S.CurrencyCode, S.ConversionRate,

	AdvIncomeTax = 0.00, FBRPosFee=0.00

FROM srledger S, MasterCashWin D

WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.DocumentCode



RETURN

END
alePrice,SaleRowId,ReturnItemDescription,TotalPieces,PiecesInHand,AlternatePurPrice,CommissionPerUnit,CommissionPerc,AlternateCustomICode,NewAvgPrice,Claimable,ClaimableDiscPerc,ItemAdvanceTaxPerc) '

		SET @SQL = N'SELECT ServerName=' + '''' + @SRV + ''',SRInvcode,Icode,Gcode,Batch,Expiry,PackQty,LooseQty,PackUnits,SRPrice,DiscPerc,SalesTax,AvgPrice,UnitSalesTax,GSTPerc,SRUtn,BonusQty,SalePrice,SaleRowId,ReturnItemDescription=LTRIM(RTRIM(STR(SRUTN))),TotalPieces,PiecesInHand,AlternatePurPrice,CommissionPerUnit,CommissionPerc,AlternateCustomICode,NewAvgPrice,Claimable,ClaimableDiscPerc,ItemAdvanceTaxPerc FROM SRDetail WHERE SRInvCode IN (SELECT SRInvCode FROM SRLedger '

	END



	IF @CustCode IS NULL

	BEGIN

		SET @WHR = N' WHERE Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39) + ')'

	END

	ELSE

	BEGIN

		SET @WHR = N' WHERE CustCode = ' + (SELECT LTRIM(RTRIM(STR(@CustCode, 8)))) + ' AND Transmit = ' + CHAR(39) + 'Y' + CHAR(39) + ' AND Transmited = ' + CHAR(39) + 'N' + CHAR(39) + ' AND DATE BETWEEN ' + CHAR(39) + @stdate+ CHAR(39) + ' AND ' + CHAR(39) + @edate + CHAR(39) + ')'

	END

	SET @Query = @INS + @SQL + @WHR

	EXECUTE (@Query)

	SET @err = @@ERROR

	IF @@ERROR <> 0 OR @err <> 0

	BEGIN

		RAISERROR('Transmit Sales Data Detail Problem: Error Transfering Sales Data Detail From Server (%s) TO Server (%s) ', 16, 1, @SRV, @PARENTSRV)

		RETURN -1

	END 

	ELSE

	BEGIN

		IF @SaleType = 1

		BEGIN

			SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_CashierWindow SELECT ChildServer=' + CHAR(39) + @SRV + CHAR(39) + ', CW.* FROM CashierWindow CW WHERE CW.SaleInvCode IN (SELECT SaleInvCode FROM SaleLedger '

		END

		IF @SaleType = 3

		BEGIN

			SET @INS = N'INSERT INTO ' + LTRIM(RTRIM(@PARENTSRV)) + '.' + LTRIM(RTRIM(@db)) + '.' + LTRIM(RTRIM(@owner)) + '.IMP_MasterCashWin SELECT ChildServer=' +
 CHAR(39) + @SRV + CHAR(39) + ', CW.* FROM MasterCashWin CW WHERE CW.DocumentType = ' + CHAR(39) + 'SR' + CHAR(39) + ' AND DocumentCode IN (SELECT SRInvCode FROM SRLedger '

		END

		SET @Query = @INS + @WHR

		EXECUTE (@Query)

		SET @err = @@ERROR

		IF @@ERROR <> 0 OR @err <> 0

		BEGIN

			RAISERROR('Transmit Sales Data Problem: Error Updating Master Cashier Window Related Data (%d)', 16, 1, @SaleType)

			RETURN -1

		END 



		IF @SaleType = 1

		BEGIN

			SET @Query = 'UPDATE SaleLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		IF @SaleType = 2

		BEGIN

			SET @Query = 'UPDATE AdvSaleLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		IF @SaleType = 3

		BEGIN

			SET @Query = 'UPDATE SRLedger SET Transmited = ' + CHAR(39) + 'Y' + CHAR(39) + @WHR_Cln

		END

		

		EXECUTE (@Query)

		SET @err = @@ERROR

		IF @@ERROR <> 0 OR @err <> 0

		BEGIN

			RAISERROR('Transmit Sales Data Problem: Error Updating Sales Regarding Transmit Status', 16, 1)

			RETURN -1

		END 

	END

END



SET @dt = GETDATE()

Execute @rt_code = SP_Set_DateTime_Preference 'LastSaleTransmited', @dt

IF @@Error <> 0 OR @rt_code <> 0 

Begin

	RaisError( 'Unable to Record Last Sale Transmit Information in Software Preferences' , 16 , 1)

	RETURN -1								

End



RETURN 0
ALTER  PROCEDURE sp_Translate_ChildeServer_Sale

	@childserver VarChar(100), 

	@invtype int,

	@invcode Int, 

	@usercode Int,

	@refund NUMERIC(10, 2),

	@saleinvcode int output

AS

SET NOCOUNT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



Declare @Headerno Int, @GCode INT, @curr_rowid INT

Declare @module Int, @custcode Int, @saletypecode SmallInt, @salecatcode Int, @headerinvno Int, @continue Int, @rt_code Int, @Err Int, @totalrows Int, @rowcount Int, @invcounter Int, @counter Int

Declare @satisfiableqty NUMERIC(15, 4), @satisfiedqty NUMERIC(15, 4), @item_in_inv_exist Int

Declare @saleprice Numeric(12,2), @rate Numeric(12,2), @discperc Numeric(5,2), @itemflatdisc Numeric(15,2), @unitsalestax Numeric(12,2), @gstperc1 Numeric(6,2), @gstperc2 Numeric(6,2), @hold_avgprice Numeric(15,5)

Declare @icode Int, @anyitem_exist NUMERIC(15, 4), @packunits Int

Declare @totalqty NUMERIC(15, 4), @givenqty NUMERIC(15, 4), @reqqty NUMERIC(15, 4), @batchqty NUMERIC(15, 4), @delqty NUMERIC(15, 4), @currqty NUMERIC(15, 4), @newqty NUMERIC(15, 4), @balancestock NUMERIC(15, 4), @ItemAdvanceTaxPerc NUMERIC(5,2)

Declare @batch VarChar(100), @itemname VarChar(60), @expiry DateTime, @serverdate DateTime

Declare @saleutn BigInt

Declare @salerowcount Int, @rowgroup Int, @lineitems_rowcount Int, @innercounter Int

DECLARE @saledesc VARCHAR(100), @updateloyaltypoints CHAR(1)



Set @custcode = 19

Set @salecatcode = 3 

Set @saletypecode = 2

Set @module = ( Select module from module where name = 'Sales' )

Set @serverdate = GETDATE()

Set @updateloyaltypoints = ISNULL((SELECT DBO.fn_GetPreference('ApplyLoyaltypolicyonsaleposting')),'N')



Create Table #sale ( id int not null identity(1,1), icode Int, gcode int, satisfiableqty NUMERIC(15, 4), satisfiedqty NUMERIC(15, 4), SalePrice  Numeric(12,2), rate Numeric(12,2), packunits smallint not null, DiscPerc Numeric(8,2), ItemFlatDisc Numeric(12,2), UnitSalesTax Numeric(12,2), GstPerc Numeric(6,2), SaleDesc VARCHAR(100), ItemAdvanceTaxPerc NUMERIC(5,2))

Insert Into #sale 
( icode, gcode, satisfiableqty, satisfiedqty , saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc, ItemAdvanceTaxPerc)

Select icode, gcode, looseqty=ISNULL(SUM(looseqty), 0), 0, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc=LTRIM(RTRIM(STR(MAX(SaleUtn)))), ItemAdvanceTaxPerc=0

From IMP_AdvSaleDetail

Where @invtype = 2 AND ChildServer = @childserver AND AdvSaleInvCode = @InvCode AND LooseQty > 0

GROUP BY icode, gcode, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc

UNION ALL

Select icode, gcode, looseqty=ISNULL(SUM(looseqty), 0), 0, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, SaleDesc=LTRIM(RTRIM(STR(MAX(SaleUtn)))), ItemAdvanceTaxPerc

From IMP_SaleDetail

Where @invtype = 1 AND ChildServer = @childserver AND SaleInvCode = @InvCode AND LooseQty > 0

GROUP BY icode, gcode, saleprice, rate, packunits, discperc, itemflatdisc, unitsalestax, gstperc, ItemAdvanceTaxPerc

Order By Icode



IF @invtype = 1

	Set @salerowcount = ISNULL((Select count(*) from IMP_SaleDetail where SaleInvCode = @invcode AND childserver = @childserver), 0)

ELSE

	Set @salerowcount = ISNULL((Select count(*) from IMP_AdvSaleDetail where AdvSaleInvCode = @invcode AND childserver = @childserver), 0)



Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )



IF @invtype = 1

	Set @Headerno = ( Select HeaderNo from IMP_SaleLedger WHERE SaleInvCode = @invcode AND childserver = @childserver)

ELSE

	Set @Headerno = ( Select HeaderNo from IMP_AdvSaleLedger WHERE AdvSaleInvCode = @invcode AND childserver = @childserver)

Set @continue = 0

Set @invcounter = 1

Set @rowgroup = 0



While @anyitem_exist > 0 And @continue >= 0

Begin

	Execute @rt_code = sp_GetTabMaxkey 'Saleledger' , @SaleInvCode Output

	Set @rowgroup = 0

	IF @@Error <> 0 OR @rt_code <>  0

	Begin

		Set @continue  = -1

	End

	Else

	Begin

		Execute @rt_code = sp_GetHeaderTabMaxkey @Headerno, @module,  @headerinvn
o Output 

		IF @@Error <> 0 OR @rt_code <>  0

		Begin

			Set @continue  = -1

		End

		Else

		Begin

			Set @Err = 0 

			Set @RowCount = 1

			Insert Into SaleLedger (SaleInvCode, SaleCatCode, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc, MiscCharges, SalesTax, Posted, PostDate, HeaderNo, HeaderInvNo, OriginalDate, InvTotal, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized, FiscalizedOn, FiscalInvoiceNo, ModuleID, DocCode , InvoiceSize , CashReceived, CashAccCode, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBy, AmtReference, OutStandingAmt, DueDate, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5, SaleComments1, SaleComments2, CashTendered, CashCharged, CashBack, SaleTypeInvNo, AdvanceTax, AdvanceTaxAmt, FBRPOSFee)

			SELECT  @SaleInvCode, SaleCatCode, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc=FlatDisc + ISNULL(@refund, 0), MiscCharges, SalesTax=0, Posted='Y', Date, @HeaderNo, @HeaderInvNo, OriginalDate, InvTotal=0, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized, FiscalizedOn, FiscalInvoiceNo, ModuleID=-1, DocCode, InvoiceSize , CashReceived, CashAccCode, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBy, AmtReference, OutStandingAmt, DueDate, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5, SaleComments1, SaleComments2, CashTendered, CashCharged, CashBack, SaleTypeInvNo, AdvanceTax, AdvanceTaxAmt, FBRPOSFee

			FROM IMP_SaleLedger

			WHERE @invtype = 1 AND SaleInvCode = @InvCode AND childserver = @childserver

			UNION ALL

			SELECT  @SaleInvCode, SaleCatCode = CASE invtype WHEN 1 THEN @salecatcode ELSE 2 END, CustCode, SPrice, SalesManCode, Date, Discperc, Flatdisc=FlatDisc + ISNULL(@refund, 0), MiscCharges, SalesTax=0, Posted='Y', Date, @HeaderNo, @HeaderInvNo, OriginalDate, InvTotal=0, MachineName, ModifyCounter, BillingDate, SaleTypeCode, Fiscalized='N', FiscalizedOn=NULL, FiscalInvoiceNo=NULL, ModuleID=NULL, DocCode=NULL, InvoiceSize , CashAmt, CashAccCode=2, AccountFor='Y', PaymentMode'C', PaymentA
ccCode=NULL, Amt=0.00, AmtBy=NULL, AmtReference=NULL, OutStandingAmt=0.00, DueDate=Date, CustRefNo, CustRefNo2, CustRefNo3, CustRefNo4, CustRefNo5=NULL, SaleComments1, SaleComments2, CashTendered, CashAmt, CashBack=0.00, SaleTypeInvNo=0, AdvanceTax='N', AdvanceTaxAmt=0, FBRPOSFee=0

			FROM IMP_AdvSaleLedger

			WHERE @invtype = 2 AND AdvSaleInvCode = @InvCode AND childserver = @childserver

			Select @Err = @@Error, @RowCount = @@RowCount



			IF @Err <> 0 OR @RowCount = 0 

			Begin 

				RaisError( 'Error occured in inserting record into Sale Ledger : %d' ,16,1,  @SaleInvCode  )

				Set @continue  = -1

			End 

			Else

			Begin

				Set @curr_rowid = 1

				Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

				Set @lineitems_rowcount =  @salerowcount

				Set @innercounter = 1

				While ( @salerowcount > 0 )  AND ( @anyitem_exist > 0 ) AND ( @innercounter <= @lineitems_rowcount ) AND ( @continue >= 0 )

				Begin

					Select @icode = icode , @Gcode = GCode, @satisfiableqty = satisfiableqty, @satisfiedqty = satisfiedqty, @saleprice = saleprice, @rate = rate, @packunits = packunits, @discperc = discperc,  @itemflatdisc = itemflatdisc, @unitsalestax = unitsalestax, @gstperc1 = gstperc, @saledesc=SaleDesc, @ItemAdvanceTaxPerc=ItemAdvanceTaxPerc

					From #sale

				        Where id = @curr_rowid



					Select @RowCount = @@RowCount

					IF ( @RowCount = 1 ) AND  ( (@satisfiableqty - @satisfiedqty) > 0 )

					Begin

						Set @givenqty = @satisfiableqty - @satisfiedqty

						Execute @rt_code = sp_GetItemAvgPrice @icode, @hold_avgprice OutPut

						IF @@Error <> 0 OR @rt_code <> 0

						Begin

							Set @continue  = -1

						End

						Else

						Begin

							Set @totalqty = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode  )

							Set @rowgroup = @rowgroup + 1

							IF @packunits = 0 OR @packunits Is Null 

								Set @packunits = 1



							IF @givenqty > 0

							Begin 

								IF @
ALTER PROCEDURE DBO.SP_VirtualGL @ac_type CHAR(1)

AS



SET NOCOUNT ON

TRUNCATE TABLE VirtualGLTemp

DECLARE @rc int

SET @rc = (SELECT COUNT(*) FROM VirtualGL (TABLOCKX))



IF UPPER(@ac_type) IS NULL 

	SET @ac_type = 'A'



IF UPPER(@ac_type) <> 'S' AND UPPER(@ac_type) <> 'A' 

	SET @ac_type = 'A'



DECLARE @goodsacc smallint, @goodsissueacc smallint, @ln_purchaseacc NUMERIC(5, 0), @ln_cashacc NUMERIC(5, 0), 

	@ln_equityacc NUMERIC(5, 0), @ln_invacc NUMERIC(5, 0), @ln_cgs NUMERIC(5, 0),

	@ln_salesacc NUMERIC(5, 0), @ln_salesretacc NUMERIC(5, 0), @ln_purchaseretacc NUMERIC(5, 0),

	@ln_revfromservice NUMERIC(5, 0), @ln_salestaxacc NUMERIC(5, 0), @ln_salestaxonsvc NUMERIC(5, 0),

	@ln_AdvIncomeTaxPur NUMERIC(5, 0), @ln_AdvIncomeTaxSale NUMERIC(5, 0), @ln_fbrposfeeacc NUMERIC(5,0)

DECLARE @InvSys CHAR(1)



SET @goodsacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsReceiptAcc'), 31)

SET @goodsissueacc = ISNULL((SELECT code FROM global WHERE name = 'GT_GoodsIssuedAcc'), 31)

SET @InvSys = ISNULL((SELECT a=DBO.Fn_GetPreference( 'InventorySystemUsed')), 'P')

SET @ln_invacc = (SELECT code FROM global WHERE name = 'GT_InventoryAcc')

SET @ln_cgs = (SELECT code FROM global WHERE name = 'GT_CostOfGoodsSoldAcc')

SET @ln_purchaseacc = (SELECT code FROM global WHERE name = 'GT_PurchaseAccount')

SET @ln_cashacc     = (SELECT code FROM global WHERE name = 'GT_CashACC')

SET @ln_equityacc	= (SELECT code FROM global WHERE name = 'GT_EquityACC')

SET @ln_salesacc    = (SELECT code FROM global WHERE name = 'GT_SalesACC')

SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')

SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')

SET @ln_revfromservice  = (SELECT code FROM global WHERE name = 'GT_RevenueFromServices')

SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @ln_salestaxonsvc	= (SELECT code FROM global WHERE name = 'GT_SalesTaxPayableOnServices')

SET @ln_AdvIncomeTaxPur = (SELECT c
ode FROM global WHERE name = 'GT_AdvIncomeTaxPur')

SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')

SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')



BEGIN TRANSACTION T1



IF @ac_type <> 'C'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Purchase

	EXECUTE DBO.SP_VirtualGL_PurchaseReturn

	EXECUTE DBO.SP_VirtualGL_PurchaseServices

END



IF @ac_type <> 'S'

BEGIN

	EXECUTE DBO.SP_VirtualGL_Sales

	EXECUTE DBO.SP_VirtualGL_SalesReturn

	EXECUTE DBO.SP_VirtualGL_Services

	EXECUTE DBO.SP_VirtualGL_SaleOrder

END



EXECUTE DBO.SP_VirtualGL_Receipt

EXECUTE DBO.SP_VirtualGL_Issue

EXECUTE DBO.SP_VirtualGL_Adjustment

EXECUTE DBO.SP_VirtualGL_Guest

EXECUTE DBO.SP_VirtualGL_Patient

EXECUTE DBO.SP_VirtualGL_Vouchers

EXECUTE DBO.SP_VirtualGL_Notes

EXECUTE DBO.SP_VirtualGL_TransactionWindow

EXECUTE DBO.SP_VirtualGL_Payroll



INSERT INTO VirtualGL

	(DocumentCode, DocumentType, CatCode, AccCode, AlternateAccCode, date, Debit, Credit, Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, Balance, VRow, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate)

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode,

	AlternateAccCode = CASE WHEN dr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = CASE

		WHEN dr_AccCode IN 

			(SELECT acccode FROM accounts 

			WHERE acccode IN 

				(@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, 

				@ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0)

		END, 

	Credit = 0, Dr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From Vir
tualGLTemp

UNION ALL /*Credit part of all transactions*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	cr_AccCode, 

	AlternateAccCode = CASE WHEN cr_AccCode IN (SELECT AccCode FROM Accounts WHERE SubCode IN (SELECT Code FROM Global WHERE Name = 'GT_CashSub')) THEN AlternateAccCode ELSE NULL END,

	date, 

	Debit = 0, 

	Credit = CASE WHEN cr_AccCode IN

		(SELECT acccode FROM accounts 

			WHERE acccode IN (@ln_invacc, @goodsacc, @goodsissueacc, @ln_purchaseacc, @ln_salesacc, @ln_salesretacc, @ln_purchaseretacc, @ln_revfromservice)) THEN Gross - ISNULL(AdvIncomeTax, 0) - ISNULL(FBRPosFee, 0)

		ELSE ISNULL(Gross, 0) + ISNULL(SaleTax, 0) END, 

	Cr_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=1, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

UNION ALL /*  Sales Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN SaleTax WHEN 'SR' THEN SaleTax WHEN 'RR' THEN SaleTax ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN SaleTax WHEN 'PR' THEN SaleTax WHEN 'RS' THEN SaleTax ELSE 0 END, 

	SaleTax_Remarks, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	SaleTax <> 0

UNION ALL /*  Advance Income Tax For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_AdvIncomeTaxSale ELSE @ln_AdvIncomeTaxPur END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'PV' THEN AdvIncomeTax WHEN 'SR' THEN AdvIncomeTax ELSE 0 END, 

	Credit= CA
totalqty >= @givenqty

									Set @reqqty = @givenqty

								ELSE

									Set @reqqty = @totalqty



								Declare ItemBatch_Cursor Cursor Static Forward_Only

								For 	Select  batch, expiry, Currqty 

								From    godowndetail 

								Where  godowndetail.gcode = @gcode and

									    godowndetail.icode = @icode 

								Order by priority, expiry, Currqty



								Open ItemBatch_Cursor

								Set @totalrows = @@Cursor_Rows

								Fetch Next From ItemBatch_Cursor

								Into 	@batch, @expiry, @currqty

								Set @counter = 1	

								While @@Fetch_Status = 0 And @counter <= @totalrows AND @reqqty > 0

								Begin

									Set @batchqty = @currqty

									IF @batchqty >= @ReqQty 

										Set @delqty = @reqqty

									Else

										Set @delqty = @batchqty

									Set @reqqty = @reqqty - @delqty



									Execute @rt_code = sp_maxutn 1, @saleutn Output

									IF @@Error <> 0 OR @rt_code <> 0

									Begin

										Set @continue  = -1															

									End 									



									Insert Into SaleDetail (SaleInvCode, icode, gcode, batch, expiry, packqty, looseqty, packunits, saleprice, avgprice, rate, discperc, salestax, itemflatdisc, packprice, unitsalestax, gstperc, saleutn, balancestock, rowgroup, SaleItemDescription, ItemAdvanceTaxPerc)

									Values (@saleinvcode, @icode, @gcode, @batch, @expiry, 0, @delqty, @packunits, @saleprice, @hold_avgprice, @rate, @discperc, 0, @itemflatdisc, @rate * @packunits, @unitsalestax, @gstperc1, @saleutn, (@totalqty - @delqty), @rowgroup, @SaleDesc, @ItemAdvanceTaxPerc)

									Select @Err = @@Error, @RowCount = @@RowCount

									IF @Err <> 0 OR @RowCount = 0 

									Begin 

										RaisError( 'Error occured in inserting record into Sale Detail for Sale Inv. No. : %d' ,16,1, @SaleInvCode  )

										Set @continue  = -1

									End 							
									Else

									Begin

										Set @newqty = @currqty - @delqty

										IF @newqty > 0

											Execute @rt_code = sp_SaleUpdateItemStockBatch
 @gcode, @icode, @batch, @expiry, @newqty , @currqty

										Else

											Execute @rt_code = sp_DeleteItemStockBatch @gcode, @icode, @batch, @expiry, @delqty

										IF @@Error <> 0 OR @rt_code <> 0 

										Begin

											Set @continue  = -1								

										End

									End

									Set @counter = @counter + 1

									Fetch Next From ItemBatch_Cursor

									Into 	@batch, @expiry, @currqty

								End

								Close ItemBatch_Cursor

								Deallocate ItemBatch_Cursor



								IF @totalqty < @givenqty

								BEGIN

									Set @givenqty = @givenqty - @totalqty

									IF @givenqty > 0

									BEGIN

										Execute @rt_code = sp_maxutn 1, @saleutn Output

										IF @@Error <> 0 OR @rt_code <> 0

										Begin

											Set @continue  = -1															

										End

										ELSE

										Begin

											Insert Into SaleDetail (SaleInvCode, icode, gcode, due, batch, expiry, packqty, looseqty, packunits, saleprice, avgprice, rate, discperc, salestax, itemflatdisc, packprice, unitsalestax, gstperc, saleutn, balancestock, rowgroup, SaleItemDescription)

											Values (@saleinvcode, @icode, @gcode, 'D', 'due', CONVERT(VARCHAR(100), GETDATE()+365, 101), 0, @givenqty, @packunits, @saleprice, @hold_avgprice, @rate, @discperc, 0, @itemflatdisc, @rate * @packunits, @unitsalestax, @gstperc1, @saleutn, 0, @rowgroup, @SaleDesc)

											Select @Err = @@Error, @RowCount = @@RowCount

											IF @Err <> 0 OR @RowCount = 0 

											Begin 

												RaisError( 'Error occured in inserting due record into Sale Detail for Sale Inv. No. : %d' ,16,1, @SaleInvCode  )

												Set @continue  = -1

											End 							
										End

									END

								END

							End

						End

					End	

					UPDATE #sale SET Satisfiedqty = Satisfiableqty WHERE ID = @curr_rowid



					Set	@curr_rowid = @curr_rowid + 1

					Set @innercounter = @innercounter + 1

					Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

				End

			E
nd

		End	

	End

Set @anyitem_exist  = ( Select Sum(Satisfiableqty - Satisfiedqty) from #sale )

End



Drop Table #sale



IF ( @continue >= 0 )

Begin

	IF @SaleInvCode > 0

	BEGIN

		INSERT INTO CashierWindow (SaleInvCode, AccCode, Remarks, Amount, RowID)

		SELECT @SaleInvCode, AccCode, Remarks, Amount, RowID 

		FROM IMP_CashierWindow

		WHERE childserver = @childserver AND SaleInvCode = @InvCode AND 

			SaleInvCode IN 

			(SELECT SaleInvCode FROM IMP_SaleLedger WHERE @invtype = 1 AND SaleInvCode = @InvCode AND childserver = @childserver)



		Update Saleledger 

		Set InvTotal = dbo.fn_getSaleInvTotal (Saleledger.saleinvcode)

		Where saleinvcode = @SaleInvCode

	

		Select @Err = @@Error, @Rowcount = @@RowCount

		IF  @Err <> 0 OR @RowCount = 0

		Begin

			RaisError( 'Unable to update Sale Invoice for Sale Inv. total' , 16 , 1 )

			Set @continue  = -1									

		End



		IF @updateloyaltypoints = 'Y'

		Begin

			Execute @rt_code = SP_ManageLoyaltyPoints 'SV', @SaleInvCode

			IF @@Error <> 0 OR @rt_code <> 0

			Begin

				RaisError( 'Unable to update loyalty points On Sale Invoice : %d' ,16,1, @SaleInvCode)

				Set @continue  = -1															

			End

		End

	END

End



Return @continue
ALTER    PROCEDURE sp_Translate_ChildeServer_SReturn

	@childserver VarChar(100), 

	@OldSRInvCode Int, 

	@usercode Int,

	@SRInvCode Int OUTPUT

AS



SET NOCOUNT ON

SET ANSI_NULLS ON

SET ANSI_WARNINGS ON



DECLARE @Sale NUMERIC(15, 4)

Declare @Headerno Int, @GCode INT, @curr_rowid INT

Declare @module Int, @custcode Int, @saletypecode SmallInt, @srcatcode Int, @headerinvno Int, @continue Int, @rt_code Int, @Err Int, @totalrows Int, @rowcount Int, @invcounter Int, @counter Int

Declare @looseqty NUMERIC(15, 4), @bonusqty NUMERIC(15, 4), @item_in_inv_exist Int

Declare @srprice Numeric(12,2), @rate Numeric(12,2), @discperc Numeric(5,2), @itemflatdisc Numeric(15,2), @unitsalestax Numeric(12,2), @gstperc1 Numeric(6,2), @gstperc2 Numeric(6,2), @hold_avgprice Numeric(15,5)

Declare @icode Int, @anyitem_exist Int, @packunits Int

Declare @totalqty NUMERIC(15, 4), @givenqty NUMERIC(15, 4), @reqqty NUMERIC(15, 4), @batchqty NUMERIC(15, 4), @delqty NUMERIC(15, 4), @currqty NUMERIC(15, 4), @newqty NUMERIC(15, 4), @balancestock NUMERIC(15, 4), @ItemAdvanceTaxPerc NUMERIC(5,2)

Declare @batch VarChar(100), @returndesc VarChar(100), @itemname VarChar(60), @expiry DateTime, @serverdate DateTime

Declare @saleutn BigInt, @firsttime Bit

Declare @advsale_rowcount Int, @rowgroup Int, @lineitems_rowcount Int, @innercounter Int, @updateloyaltypoints CHAR(1)



Set @firsttime = 0

Set @custcode = 19

Set @srcatcode = 8 

Set @saletypecode = 2

Set @module = ( Select module from module where name = 'SALES RETURN' )

Set @serverdate = GETDATE()

Set @updateloyaltypoints = ISNULL((SELECT DBO.fn_GetPreference('ApplyLoyaltypolicyonsaleposting')),'N')



Create Table #salereturn ( 

	id int not null identity(1,1), 

	icode Int, 

	gcode int, 

	batch VARCHAR(100), 

	expiry datetime,

	looseqty NUMERIC(15, 4), 

	bonusqty NUMERIC(15, 4), 

	SRPrice  Numeric(12,2), 

	packunits smallint not null, 

	DiscPerc Numeric(8,2), 

	UnitSalesTax Numeric(12,2), 

	GstPerc Numeric(6,2),

	returndesc varchar(100),

	ItemAdvanceTaxPe
rc NUMERIC(5,2))



Insert Into #salereturn 

	( icode, gcode, batch, expiry, looseqty, bonusqty, srprice, packunits, discperc, unitsalestax, gstperc, returndesc, ItemAdvanceTaxPerc)

Select icode, gcode, batch, expiry, SUM(ABS(looseqty)), bonusqty=sum(ABS(bonusqty)), srprice, packunits, discperc, unitsalestax, gstperc, returnitemdescription, ItemAdvanceTaxPerc

From IMP_SRDetail

Where ChildServer = @childserver AND SRInvCode = @OldSRInvCode

GROUP BY icode, gcode, batch, expiry, srprice, packunits, discperc, unitsalestax, gstperc, returnitemdescription, ItemAdvanceTaxPerc

Order By ICODE



SET @Sale = ISNULL((SELECT SUM(LooseQty) FROM IMP_SRDetail Where ChildServer = @childserver AND SRInvCode = @OldSRInvCode AND LooseQty > 0), 0)

Set @advsale_rowcount = ISNULL((Select count(*) from IMP_SRDetail where ChildServer = @childserver AND SRInvCode = @OldSRInvCode), 0)

Set @anyitem_exist  = ( Select Sum(ABS(looseqty)) from #salereturn )

Set @Headerno = ( Select HeaderNo from IMP_SRLedger WHERE ChildServer = @childserver AND SRInvCode = @OldSRInvCode)

Set @continue = 0

Set @invcounter = 1

Set @rowgroup = 0



While @anyitem_exist > 0 And @continue >= 0

Begin

	Execute @rt_code = sp_GetTabMaxkey 'SRledger' , @SRInvCode Output

	Set @rowgroup = 0

	IF @@Error <> 0 OR @rt_code <>  0

	Begin

		Set @continue  = -1

	End

	Else

	Begin

		Execute @rt_code = sp_GetHeaderTabMaxkey @Headerno, @module,  @headerinvno Output 

		IF @@Error <> 0 OR @rt_code <>  0

		Begin

			Set @continue  = -1

		End

		Else

		Begin

			Set @Err = 0 

			Set @RowCount = 1

			Insert Into SRLedger (SRInvCode, SaleInvCode, Date, SRCatCode, CustCode, SalesmanCode, 

				DiscPerc, FlatDisc, MiscCharges, Posted, PostDate, Remarks, SalesTax, 

				OriginalDate, ModifiedBy, PostedBy, HeaderNo, InvGSTPerc1, Smancode, 

				CustRefno, CustRefno2, CustRefno3, CustRefno4, PatientCode, MachineName, 

				HeaderInvNo, AdmissionCode, InvTotal, AccountFor, PaymentMode, PaymentAccCode, 

				Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt
, Marked, PageSize, ReprintingCounter, DoctCode, ConsiderInPO,

				CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSummary,CRS_Transfered,CRS_TransferedOn,GuestCode,

				GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,

				FiscalizedOn,FiscalInvoiceNo,Transmit,Transmited,AdvanceTax,AdvanceTaxAmt,FBRPOSFee)

			SELECT  @SRInvCode, SaleInvCode=NULL, Date, SRCatCode, CustCode, SalesManCode, 

				Discperc, Flatdisc, MiscCharges, Posted='Y', PostDate=GETDATE(), Remarks, SalesTax=0, 

				OriginalDate, ModifiedBy, PostedBy=@usercode, @HeaderNo, InvGSTPerc1, Smancode, 

				CustRefno, CustRefno2, CustRefno3, CustRefno4=LTRIM(RTRIM(STR(@OldSRInvCode))), PatientCode, MachineName, 

				@HeaderInvNo, AdmissionCode=NULL, InvTotal, AccountFor, PaymentMode, PaymentAccCode, 

				Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt, Marked='N', PageSize, ReprintingCounter, DoctCode, ConsiderInPO,

				CashAccCode,CashTendered,CashCharged,CashBack,RetViaBillSummary,CRS_Transfered,CRS_TransferedOn,GuestCode,

				GuestCheckInCode,StudentCode,Synced,SyncedOn,SyncedBy,CurrencyCode,ConversionRate,Fiscalized,

				FiscalizedOn,FiscalInvoiceNo,Transmit='N',Transmited='N',AdvanceTax,AdvanceTaxAmt,FBRPOSFee 

			FROM IMP_SRLedger

			WHERE ChildServer = @childserver AND SRInvCode = @OldSRInvCode



			Select @Err = @@Error, @RowCount = @@RowCount

			IF @Err <> 0 OR @RowCount = 0 

			Begin 

				RaisError( 'Error occured in inserting record into Sale Return Ledger : %d' ,16,1,  @SRInvCode)

				Set @continue  = -1

			End 

			Else

			Begin

				Set	@curr_rowid = 1

				Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

				Set @lineitems_rowcount =  @advsale_rowcount

				Set @innercounter = 1

				While ( @advsale_rowcount > 0 )  AND ( @anyitem_exist > 0 ) AND ( @innercounter <= @lineitems_rowcount ) AND ( @continue >= 0 )

				Begin

					Select @icode = icode , @Gcode = GCode, 

						@batch = Batch, 

						@expiry = EXPIRY, 

						@loose
qty = looseqty, @bonusqty=bonusqty, @srprice = srprice, 

						@packunits = packunits, @discperc = discperc,  

						@unitsalestax = unitsalestax, @gstperc1 = gstperc, @returndesc=returndesc,

						@ItemAdvanceTaxPerc=ItemAdvanceTaxPerc

					From #salereturn

			        	Where id = @curr_rowid



					Select @RowCount = @@RowCount

					IF ( @RowCount = 1 ) AND  ( @looseqty > 0 )

					Begin

						Set @givenqty = @looseqty + @bonusqty

						Execute @rt_code = sp_GetItemAvgPrice @icode, @hold_avgprice OutPut

						IF @@Error <> 0 OR @rt_code <> 0

						Begin

							Set @continue  = -1

						End

						Else

						Begin

							Set @totalqty = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode  )

							Set @rowgroup = @rowgroup + 1

							IF @packunits = 0 OR @packunits Is Null 

							BEGIN

								Set @packunits = 1

							END



							IF @givenqty > 0

							Begin 

								Execute @rt_code = sp_maxutn 1, @saleutn Output

								IF @@Error <> 0 OR @rt_code <> 0

								Begin

									Set @continue  = -1

								End



								Insert Into SRDetail 

									(SRInvcode, Icode, Gcode, Batch, Expiry, PackQty, LooseQty, PackUnits, SRPrice, 

									DiscPerc, SalesTax, AvgPrice, UnitSalesTax, GSTPerc, SRUtn, BonusQty, SalePrice, SaleRowId, ReturnItemDescription,ItemAdvanceTaxPerc)

								SELECT @SRInvCode, @icode, @gcode, @batch, @expiry, 0, @looseqty, @packunits, @srprice, 

									@discperc, 0, @hold_avgprice, @unitsalestax, @gstperc1, @saleutn, @bonusqty, @SRPrice, NULL, @returndesc, @ItemAdvanceTaxPerc



								Select @Err = @@Error, @RowCount = @@RowCount

								IF @Err <> 0 OR @RowCount = 0 

								Begin 

									RaisError( 'Error occured in inserting record into Sale Return Detail for Sale Return No. : %d' ,16,1, @SRInvCode  )

									Set @continue  = -1

								End 							
								Else

								Begin

									Set @currqty = 0

									Execute @rt_code = SP_GetItemStockBatch @GCode, @ICode, @Bat
SE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 

	SaleTax_Remarks='Adv. Income Tax ' + CASE WHEN DocumentType = 'SR' OR DocumentType = 'PR' THEN 'Reversed' ELSE 'Accounted For' END, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR' OR DocumentType = 'PV' OR DocumentType = 'PR') AND AdvIncomeTax <> 0

UNION ALL /*  FBR POS FEE For all the transactions either debit or credit */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	AccCode = CASE WHEN DocumentType = 'SV' OR DocumentType = 'SR' THEN @ln_fbrposfeeacc ELSE @ln_fbrposfeeacc END, 

	AlternateAccCode = NULL,

	date, 

	Debit = CASE DocumentType WHEN 'SR' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	Credit= CASE DocumentType WHEN 'SV' THEN ISNULL(FBRPosFee, 0) ELSE 0 END, 

	SaleTax_Remarks='FBR POS Service Fee ' + CASE DocumentType WHEN 'SR' THEN 'Reversed' ELSE 'Accounted For' END, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	(DocumentType = 'SV' OR DocumentType = 'SR') AND ISNULL(FBRPosFee, 0) <> 0

UNION ALL /*  Accounting Treatement for Amount Received/Paid during the transactions  First Debit Part of amount received/paid */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	DrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = Amt, 

	Credit= 0, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 	'Received during p/return no.' 

		WHEN 'SV' THEN 	'Received during sale inv. no.' 

		WHEN 'SR' THEN 	'Paid during s/return no.' ELSE DR_Remarks END+ ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_accc
ode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VROW=3, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL  /* Now Credit Part of amount received/paid during invoice */

SELECT 	DocumentCode,

	DocumentType, 

	CatCode,

	CrAmtAccCode, 

	AlternateAccCode = NULL,

	AmtDate, 

	Debit = 0, 

	Credit= Amt, 

	Remarks=CASE DocumentType WHEN 'PV' THEN 'Paid during pur. inv. no.' 

		WHEN 'PR' THEN 'Received during p/return no.' 

		WHEN 'SV' THEN 'Received during sale inv. no.' 

		WHEN 'SR' THEN 'Paid during s/return no.' ELSE CR_Remarks END + ':'+ LTRIM(RTRIM(STR(INVOICECODE))) + ' (' + ISNULL((SELECT LTRIM(RTRIM(A.Name)) FROM Accounts A WHERE A.AccCode = VirtualGLTemp.dr_acccode), '') + ')' , 

	CheckNo=AmtRef, AmtBy, VoucherCode, InvoiceCode, InvoiceType, OutstandingAmt, 

	Balance, VRow=4, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE 	Amt > 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_cgs ELSE @ln_invacc END,

	AlternateAccCode = NULL,

	date, 

	Debit = CGS, 

	Credit = 0, Remarks=CASE WHEN DocumentType ='SV' THEN 'Cost of Sale charged for Sale Inv. #' ELSE 'Inventory Accounted for S/R  Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0

UNION ALL /*When Perpetual Inv. System then cgs vouchers are used*/

SELECT

	DocumentCode,

	DocumentType, 

	CatCode,

	dr_AccCode=CASE WHEN DocumentType ='SV' THEN @ln_invacc ELSE @ln_cgs END,

	AlternateAccCode = NULL,

	date, 

	Debit 
= 0, 

	Credit = CGS, Remarks=CASE WHEN DocumentType ='SV' THEN 'Inventory Accounted for Sale Inv. #' ELSE 'Cost of Sale Reversed for S/R Inv. #' END + LTRIM(RTRIM(STR(DocumentCode))), 

	CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 

	OutstandingAmt, Balance, VRow=0, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CurrencyCode, ConversionRate

From VirtualGLTemp

WHERE @InvSys <> 'P' AND DocumentType IN ('SV', 'SR') AND CGS <> 0



COMMIT TRANSACTION T1

TRUNCATE TABLE VirtualGLTemp
ch, @Expiry, @currqty output

									IF @@Error <> 0 OR @rt_code <> 0 

									Begin

										RaisError( 'Error occured in checking Batch details of some items during processing of Sale Return No. : %d' ,16,1, @SRInvCode  )

										Set @continue  = -1								

									End



									Set @newqty = ISNULL(@currqty, 0) + ISNULL(@givenqty, 0)

									SELECT Row=@curr_rowid, Gcode=@GCode, Icode=@ICode, Batch=@Batch, Expiry=@Expiry, Qty=@CurrQty, thisqty = @givenqty, newqty=@newqty

									IF @newqty > 0

									BEGIN

										Execute @rt_code = SP_UpdateItemStockBatch  @GCode, @ICode, @Batch, @Expiry, @NewQty, Null

										IF @@Error <> 0 OR @rt_code <> 0 

										Begin

											RaisError( 'Error occured in updation of Batch details of some items during processing of Sale Return No. : %d' ,16,1, @SRInvCode  )

											Set @continue  = -1								

										End

									END

								End

								Set @counter = @counter + 1

							End

						End

					End	

					UPDATE #salereturn SET looseqty = 0, BonusQty=0 WHERE ID = @curr_rowid

					Set	@curr_rowid = @curr_rowid + 1

					Set @innercounter = @innercounter + 1

					Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

				End

			End

		End	

	End

	Set @anyitem_exist  = ( Select Sum(looseqty + bonusqty) from #salereturn )

End



Drop Table #salereturn



IF ( @continue >= 0 )

Begin

	IF @SRInvCode > 0

	BEGIN

		Update DBO.SRledger 

		Set InvTotal = ISNULL(dbo.fn_getSRInvTotal (SRLedger.SRInvCode), 0)

		Where SRInvCode = @SRInvCode

	

		Select @Err = @@Error, @Rowcount = @@RowCount

		IF  @Err <> 0 OR @RowCount = 0

		Begin

			RaisError( 'Unable to update Sale Return Invoices for Inv. total' , 16 , 1 )

			Set @continue  = -1

		End

		IF @updateloyaltypoints = 'Y'

		Begin

			Execute @rt_code = SP_ManageLoyaltyPoints 'SR', @SRInvCode

			IF @@Error <> 0 OR @rt_code <> 0

			Begin

				RaisError( 'Unable to update loyalty points On S/R Invoice : %d' ,16,1, @SRInvCode)

				Set @continue  = -
1															

			End

		End

	END

End



Return @continue
tlog = 0, @delete_level= 0

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoPostVisitstep-1', @command = N'exec sp_autopost_visit ', @database_name = @dbname, @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 



  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoPostVisitschedule', @enabled = 1, @freq_type = 4, @active_start_date = 20030825, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 10, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959

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
