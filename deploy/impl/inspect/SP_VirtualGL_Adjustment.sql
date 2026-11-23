
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
