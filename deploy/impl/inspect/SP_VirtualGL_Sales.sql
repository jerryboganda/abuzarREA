
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
	GRN = S.GRN, GCCode = S.GCCode, Vehicle = S.Vehicle, ShipTo = S.ShipTo, S.GuestCode, S.StudentCode, CGS=0,
	S.CurrencyCode, S.ConversionRate,
	AdvIncomeTax = CASE WHEN @AdvIncomeTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END, S.FBRPosFee
FROM saleledger S, saleinvdetail D
WHERE S.saleinvcode IN (SELECT Code FROM #lsl) AND S.saleinvcode = D.saleinvcode 
GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges,
	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,
	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,
	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, S.AdvanceTaxAmt, S.FBRPosFee

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
