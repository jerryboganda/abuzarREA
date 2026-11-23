
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
SELECT  documentcode = P.purinvcode, documenttype='PV', catcode = P.PurCatCode,
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
	CheckNo = NULL,
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
	GRN = P.GRN, GCCode = P.GCCode, Vehicle = P.Vehicle, ShipTo = P.ShipTo, GuestCode=NULL, StudentCode=NULL, CGS=0, P.CurrencyCode, P.ConversionFactor,
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
	AdvIncomeTax = 0.00, FBRPosFee=0.0
FROM PurLedger P, PurDetail D
WHERE P.purinvcode IN (SELECT Code FROM #lt_pur) AND P.PurInvCode = D.PurInvCode AND 
	D.WE5 > 0 AND P.WE5_AccCode > 0
GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

TRUNCATE TABLE #lt_pur
