
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
