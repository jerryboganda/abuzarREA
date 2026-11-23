
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
	A.ReceiptInvCode = D.ReceiptInvCode
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
	dr_acccode = A.QE5_AccCode,
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
	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE2 > 0 AND A.WE2_AccCode > 0
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
	AdvIncomeTax=0.00, FBRPosFee=0.00
FROM ReceiptHeader A, ReceiptDetail D
WHERE A.AccountFor = 'Y' AND A.crAccCode IS NOT NULL AND A.ReceiptInvCode IN (SELECT Code FROM #lsl) AND
	A.ReceiptInvCode = D.ReceiptInvCode AND D.WE5 > 0 AND A.WE5_AccCode > 0
GROUP BY A.ReceiptInvCode, A.ReceiptCode, A.CrAccCode, A.ReceiptCategoryCode, A.PostDate, A.SalesmanCode, A.Remarks, A.WE5_AccCode, A.WExp5_CrAccCode

TRUNCATE TABLE #lsl
