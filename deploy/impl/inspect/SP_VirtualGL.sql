
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
DECLARE @InvSys CHAR(1), @AutoPurgeVirtualGL CHAR(1)

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
SET @ln_AdvIncomeTaxPur = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxPur')
SET @ln_AdvIncomeTaxSale = (SELECT code FROM global WHERE name = 'GT_AdvIncomeTaxSale')
SET @ln_fbrposfeeacc = (SELECT code FROM global WHERE name = 'GT_FBRPOSFeeAcc')

SET @AutoPurgeVirtualGL = ISNULL((SELECT a=DBO.Fn_GetPreference( 'AutoPurgeVirtualGL')), 'N')


BEGIN TRANSACTION T1

IF @AutoPurgeVirtualGL = 'Y'
BEGIN
	TRUNCATE TABLE VirtualGL
	COMMIT TRANSACTION T1
	RETURN
END

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
EXECUTE DBO.SP_VirtualGL_Products
EXECUTE DBO.SP_VirtualGL_CashierShift

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
From VirtualGLTemp
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
	Credit= CASE DocumentType WHEN 'SV' THEN AdvIncomeTax WHEN 'PR' THEN AdvIncomeTax ELSE 0 END, 
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
