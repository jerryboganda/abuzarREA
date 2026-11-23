-- Reconstructed from the SQL Server 2000-format V2 database file (catalog pages), schema only

-- Fn_AccountBalance
CREATE FUNCTION Fn_AccountBalance (@Date DATETIME, @AccCode INT)
RETURNS NUMERIC(15, 5)
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Pre-Processing:
	SP_VirtualGL 'A' ( a stored procedure for updating accounting data must be called before this code)
Purpose:
	This function computes the account balance of an account depending on the 
	value of parameter named '@AccCode' uptill a specific date 
	(determined by Parameter '@Date').

PARAMETER DESCRIPTION :
	@Date = DateTime concerned uptill which the a/c balance info is required
	@AccCode = Concerned Account Code
*/

DECLARE @Balance NUMERIC(15, 5)

SET @Balance = ISNULL(
		(SELECT b=SUM(Debit - Credit) 
		FROM VirtualGL 
		WHERE AccCode = @AccCode), 0)

RETURN (@Balance)
END
GO

-- Fn_CustomerOverDueBalance
CREATE FUNCTION Fn_CustomerOverDueBalance ( @Type CHAR(1), @List VARCHAR(4000), @Date DATETIME, @OverDueDays INT)
RETURNS @retTable TABLE (AccCode SMALLINT, ODBalance NUMERIC(15,5))
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Pre-Processing:
	SP_VirtualGL 'A' ( a stored procedure for updating accounting data must be called before this code)
Purpose:
	This function computes the overdue balance of a customer depending on the 
	value of parameter named '@Type' untill a specific date (determined by Parameter '@Date'). 
	The overdue balance is different from account balance and is determined by the 
	parameter '@OverDueDays'
PARAMETER DESCRIPTION :
	@Type = 'S' stands for SalesMan 'A' for Area OR 'B' for Sub Area
	@List = Comma Separated List of SalesmanCode, AreaCode or SubAreaCode
	@Date = DateTime concerned uptill which the overdue info is required
	@OverDueDays = Overdue balance computation is based on this intger value assumed in days
*/

DECLARE @OldAccCode INT, @ll_AccCode INT, @RowID INT, @DaysOld INT
DECLARE @StartLimit INT, @EndLimit INT, @WeekOfMonth INT, @WeekDay INT
DECLARE @TDate DateTime
DECLARE @Amt Numeric(15,5), @Paid Numeric(15,5), @Pmt Numeric(15,5), @OverDueBal Numeric(15,5)

DECLARE @TypeList TABLE (CODE INT NOT NULL)

INSERT INTO @TypeList SELECT CODE FROM udf_StringToTabl(@List, ',')

DECLARE @lt_amt TABLE  (
	AccCode INT NOT NULL,
	Date DateTime Not Null,
	Amount Numeric(15,5) Not Null Default 0,
	Paid Numeric(15,5) Not Null Default 0,
	RowID INT IDENTITY(1,1) NOT NULL,
	DaysOld INT Not Null Default 0
)

DECLARE @lt_pmt TABLE (
	AccCode INT NOT NULL,
	Amount Numeric(15,5) Not Null Default 0
)

DECLARE @lt_Interval TABLE (
	IntervalID INT IDENTITY (0,1) NOT NULL,
	LowerLimit INT Not Null Default 0,
	UpperLimit INT Not Null Default 0
)

SELECT @StartLimit = 0
WHILE @StartLimit <= @OverDueDays
BEGIN
	SELECT @EndLimit = @StartLimit + CASE @StartLimit WHEN 0 THEN 0 ELSE @OverDueDays - 1 END
	SELECT @EndLimit = CASE WHEN @EndLimit > @OverDueDays THEN @OverDueDays ELSE @EndLimit END

	INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
	VALUES (@StartLimit, @EndLimit)

	SELECT @StartLimit = @EndLimit + 1
END

INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
VALUES (@StartLimit, 99999999)

IF @Type='S'
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Debit, Paid=0, DaysOld=DATEDIFF(day, date, @date)
	FROM VirtualGL
	WHERE
		Date <= @date AND 
		Debit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.SalesManCode)
	ORDER BY AccCode, Date, Debit
	
	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Credit)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Credit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.SalesManCode)
	GROUP BY AccCode
	ORDER BY AccCode
END

IF @Type='A'
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Debit, Paid=0, DaysOld=DATEDIFF(day, date, @date)
	FROM VirtualGL
	WHERE
		Date <= @date AND 
		Debit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.AreaCode)
	ORDER BY AccCode, Date, Debit
	
	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Credit)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Credit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.AreaCode)
	GROUP BY AccCode
	ORDER BY AccCode
END

IF @Type='B'
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Debit, Paid=0, DaysOld=DATEDIFF(day, date, @date)
	FROM VirtualGL
	WHERE
		Date <= @date AND 
		Debit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.SubAreaCode)
	ORDER BY AccCode, Date, Debit
	
	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Credit)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Credit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer C, @TypeList T WHERE T.Code = C.SubAreaCode)
	GROUP BY AccCode
	ORDER BY AccCode
END

DECLARE C1 CURSOR FOR SELECT * FROM @lt_amt
OPEN C1

FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Pmt=ISNULL((SELECT ISNULL(Amount, 0) FROM @lt_pmt WHERE AccCode = @ll_AccCode), 0)

	IF @Pmt <> 0
	BEGIN
		UPDATE @lt_amt
		SET Paid = Paid + CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END
		WHERE RowID = @RowID AND AccCode = @ll_AccCode
	
		SELECT @Pmt = @Pmt - (SELECT CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END)
	
		UPDATE @lt_pmt
		SET Amount = @Pmt 
		WHERE AccCode = @ll_AccCode
	END

	FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
END
CLOSE C1
DEALLOCATE C1

INSERT INTO @retTable
SELECT A.AccCode, OverDueBal = ISNULL(SUM(t.Amount - t.Paid), 0)
FROM Accounts A, @lt_amt t
WHERE A.AccCode = t.AccCode AND t.daysold > @OverDueDays
GROUP BY A.AccCode
ORDER BY A.AccCode

RETURN
END
GO

-- Fn_Get_DateTime_Preference
CREATE FUNCTION DBO.Fn_Get_DateTime_Preference( @PrefName VARCHAR(100) )
RETURNS DATETIME
AS
BEGIN
/*
Author : Muhammad Azhar Inayat

Purpose : This function finds the preference name pass as parameter to it and
returns the datetime value of that function
*/
DECLARE @PrefValue DATETIME

SET @PrefValue = CAST((SELECT LTRIM(RTRIM(PrefValue)) FROM DBO.SoftwarePreferences WHERE LOWER(Name) = LOWER(@prefname)) AS DATETIME)

RETURN @PrefValue
END
GO

-- Fn_Get_Int_Preference
CREATE FUNCTION DBO.Fn_Get_Int_Preference( @PrefName VARCHAR(100) )
RETURNS INT
AS
BEGIN
/*
Author : Muhammad Azhar Inayat

Purpose : This function finds the preference name pass as parameter to it and
returns the integer value of that function
*/
DECLARE @PrefValue INT

SET @PrefValue = CAST((SELECT LTRIM(RTRIM(PrefValue)) FROM DBO.SoftwarePreferences WHERE LOWER(Name) = LOWER(@prefname)) AS INT)

RETURN @PrefValue
END
GO

-- fn_Get_ZonalSaleAndStock_CatWise_ToDate
CREATE FUNCTION DBO.fn_Get_ZonalSaleAndStock_CatWise_ToDate (@ZoneCode SMALLINT, @Date DATETIME) RETURNS VARCHAR(8000)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	Generates Item Wise Net Sales Of the month upto the date passed to this code
*/
BEGIN
DECLARE @Rep VARCHAR(8000), @Name VARCHAR(100), @StartDate DATETIME, @EndDate DATETIME
DECLARE @RowCount INT, @RowID INT
DECLARE @Sale NUMERIC(15,4), @Stock NUMERIC(15,4), @TotSaleValue NUMERIC(15,2), @TotStockValue NUMERIC(15,2), @SaleValue NUMERIC(15,2), @StockValue NUMERIC(15,2)
DECLARE @lt_report TABLE (ROWID INT NOT NULL IDENTITY(1,1), Zone VARCHAR(100), ItemName VARCHAR(100), Sale NUMERIC(15, 4), SaleValue NUMERIC(15, 2), Stock NUMERIC(15, 4), StockValue NUMERIC(15, 2))

SET @StartDate = CAST(LTRIM(RTRIM(STR(MONTH(@Date)))) + '-01-' + LTRIM(RTRIM(STR(YEAR(@Date)))) AS DATETIME)
SET @EndDate = @Date

INSERT INTO @lt_report (Zone, ItemName, Sale, SaleValue, Stock, StockValue)
SELECT 
	Zone=S.Zone,
	ItemName=CASE WHEN I.ShortName IS NULL THEN LEFT(I.Name, 10) ELSE I.ShortName END,
	Sale = STR(Round(SUM(S.Sale), 2), 15, 0),
	SaleValue = STR(Round(SUM(S.SaleValue), 2), 15, 2),
	Stock = STR(Round(SUM(S.Stock), 2), 15, 0),
	StockValue = STR(Round(SUM(S.StockValue), 2), 15, 2)
FROM
	Item I,
	(SELECT 
		Zone=Z.Name,
		D.ICode,
		Sale = SUM(D.LooseQty + D.BonusQty),
		SaleValue = SUM(D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01)),
		Stock = 0.0000,
		StockValue = 0.0000
	FROM 
		SaleLedger S, SaleDetail D, Customer C, Area A, Zone Z, ZoneAreas ZA, Item I
	WHERE
		Z.ZoneCode = @ZoneCode AND
		Z.UseForSMS = 'Y' AND
		Z.ZoneCode = ZA.ZoneCode AND
		ZA.AreaCode = A.AreaCode AND
		A.AreaCode = C.AreaCode AND
		C.CustCode = S.CustCode AND
		S.Date BETWEEN @StartDate AND @EndDate AND
		S.SaleInvCode = D.SaleInvCode AND
		D.ICode = I.ICode AND
		I.ICatCode = Z.ICatCode
	GROUP BY
		Z.Name,
		D.ICode
	UNION ALL
	SELECT 
		Zone=Z.Name,
		D.ICode,
		Sale = - SUM(D.LooseQty + D.BonusQty),
		SaleValue = - SUM(D.LooseQty * D.SRPrice * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01)),
		Stock = 0.0000,
		StockValue = 0.0000
	FROM 
		SRLedger S, SRDetail D, Customer C, Area A, Zone Z, ZoneAreas ZA, Item I
	WHERE
		Z.ZoneCode = @ZoneCode AND
		Z.UseForSMS = 'Y' AND
		Z.ZoneCode = ZA.ZoneCode AND
		ZA.AreaCode = A.AreaCode AND
		A.AreaCode = C.AreaCode AND
		C.CustCode = S.CustCode AND
		S.Date BETWEEN @StartDate AND @EndDate AND
		S.SRInvCode = D.SRInvCode AND
		D.ICode = I.ICode AND
		I.ICatCode = Z.ICatCode
	GROUP BY
		Z.Name,
		D.ICode
	UNION ALL
	SELECT 
		Zone=Z.Name,
		D.ICode,
		Sale = 0.0000,
		SaleValue = 0.0000,
		Stock = SUM(D.CurrQty),
		StockValue = SUM(D.CurrQty * I.SalePrice)
	FROM 
		GodownDetail D, Zone Z, Item I
	WHERE
		Z.ZoneCode = @ZoneCode AND
		Z.UseForSMS = 'Y' AND
		Z.ICatCode = I.ICatCode AND
		D.ICode = I.ICode
	GROUP BY
		Z.Name,
		D.ICode) S
WHERE
	S.ICode = I.ICode
GROUP BY
	S.Zone,
	I.Name,
	I.ShortName
ORDER BY 
	Zone,
	ItemName

SET @RowCount = ISNULL((SELECT COUNT(*) FROM @lt_report), 0)
SET @RowID = 1
SET @Rep=''
SET @TotSaleValue = 0
SET @TotStockValue = 0
WHILE @RowID <= @RowCount
BEGIN
	SET @Sale = ISNULL((SELECT Sale FROM @lt_report WHERE RowID = @RowID),0)
	SET @SaleValue = ISNULL((SELECT SaleValue FROM @lt_report WHERE RowID = @RowID),0)
	SET @Stock = ISNULL((SELECT Stock FROM @lt_report WHERE RowID = @RowID),0)
	SET @StockValue = ISNULL((SELECT StockValue FROM @lt_report WHERE RowID = @RowID),0)
	SET @Name = ISNULL((SELECT ItemName FROM @lt_report WHERE RowID = @RowID),0)
	SET @Rep = @Rep + LTRIM(RTRIM(@Name)) + ':' + LTRIM(RTRIM(STR(ISNULL(@Sale, 0), 15, 0))) + '/' + LTRIM(RTRIM(STR(ISNULL(@Stock, 0), 15, 0))) + ', '
	SET @TotSaleValue = @TotSaleValue + ISNULL(@SaleValue, 0)
	SET @TotStockValue = @TotStockValue + ISNULL(@StockValue, 0)
	SET @RowID = @ROWID + 1
END

IF @RowCount > 0
BEGIN
	SET @Rep = @Rep + '** Group Sales Value: ' + LTRIM(RTRIM(STR(@TotSaleValue, 15, 2)))
	SET @Rep = @Rep + '** Stock Value: ' + LTRIM(RTRIM(STR(@TotStockValue, 15, 2)))
END
RETURN @Rep
END
GO

-- fn_GetAmountOfInProcessCheques
CREATE FUNCTION DBO.fn_GetAmountOfInProcessCheques (@AccCode INT) RETURNS NUMERIC(15, 2)
AS
BEGIN
	DECLARE @Amount NUMERIC(15, 2)
	SET @Amount = 
		ISNULL((SELECT 
			Amount = SUM(
				CASE NoteCatCode WHEN 1 THEN 
					CASE WHEN AccCode = @AccCode THEN -Amount ELSE Amount END 
				ELSE 
					CASE WHEN AccCode = @AccCode THEN Amount ELSE -Amount END  
				END)
		FROM 
			Notes 
		WHERE 
			(AccCode = @AccCode OR BankAccCode = @AccCode) AND 
			Finalized = 'Y' AND 
			Posted = 'N'), 0)
	RETURN (@Amount)
END
GO

-- fn_GetAvailableGodown
CREATE FUNCTION DBO.fn_GetAvailableGodown(@GroupCode SMALLINT, @Module SMALLINT)
RETURNS @GodownList TABLE (Code SMALLINT, RowID INT NOT NULL IDENTITY(1,1))
AS
BEGIN

INSERT INTO @GodownList (Code)
SELECT GCode
From GroupAllowedGodown
WHERE	
	GroupAllowedGodown.GroupCode = @GroupCode AND
	GroupAllowedGodown.Module = @Module
ORDER BY Priority, GCode

RETURN 
END
GO

-- Fn_GetColumnPrecision
CREATE FUNCTION DBO.Fn_GetColumnPrecision ( @col VARCHAR(60) )
RETURNS INT
AS
BEGIN
	Declare @colprecision INT
	SET @colprecision = (Select ColPrecision FROM ColumnPreferences WHERE ColumnName = @col)
	IF ( @colprecision Is Null ) Set @colprecision = 0
	RETURN @colprecision
END
GO

-- fn_getCopiedSaleInvTotal
CREATE  Function dbo.fn_getCopiedSaleInvTotal ( @saleinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2)
SELECT  @netamount = Case when Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc   +   misccharges), 2) IS NULL Then 0  Else Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc   +   misccharges, 0) End 
				+
				Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
				 +  
				(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), 0)

FROM Saleledgermodified SL, Saledetailmodified SD
WHERE  SL.SaleInvCode = @saleinvcode AND
		SL.saleinvcode = SD.saleinvcode 
GROUP BY	SL.saleinvcode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.invgstperc1

Return @netamount
End
GO

-- Fn_GetFormNoAndQty_DailyLedger
CREATE FUNCTION dbo.Fn_GetFormNoAndQty_DailyLedger ( 
	@custcode INTEGER,
	@Icode INT,
	@datetype VARCHAR(100),
	@start_date DATETIME, 
	@end_date DATETIME)
RETURNS VarChar(4000)
AS
/*
Author: Muhammad Azhar Inayat
Creation Date: September 08, 2009
*/
BEGIN
Declare @FormNoAndQty VarChar(4000)
Declare @temp  VarChar(200)

Declare tempcursor Cursor For
SELECT 
	FormNoAndQty = LTRIM(RTRIM(ISNULL(SL.CustRefNo, ''))) + '/' + LTRIM(RTRIM(STR(SUM(SD.LooseQty), 10, 0))) + '  '
FROM
	SaleLedger SL, SaleInvDetail SD
WHERE
	CASE 
	WHEN lower(@datetype) = 'originaldate' THEN SL.OriginalDate 
	WHEN lower(@datetype) = 'lastsavingdate' THEN SL.Date 
	WHEN lower(@datetype) = 'billingdate' THEN SL.BillingDate 
	ELSE SL.Date 
	End Between @start_date AND @end_date AND
	SL.CustCode = @custcode AND
	SL.Posted = 'Y' AND
	SL.SaleInvCode = SD.SaleInvCode AND
	SD.ICode = @ICode
GROUP BY
	SL.CustRefNo,
	SD.ICode
For Read Only

Open tempcursor

Fetch Next From tempCursor
Into @temp

Set @FormNoAndQty = ''

WHILE @@Fetch_Status = 0
Begin
	Set @FormNoAndQty = @FormNoAndQty + @temp
	Fetch Next From tempCursor Into @temp
End

Close tempcursor
Deallocate tempcursor

Return @FormNoAndQty

END
GO

-- fn_GetGodown
CREATE FUNCTION DBO.fn_GetGodown(@GroupCode SMALLINT, @Module SMALLINT)
RETURNS SMALLINT
AS
BEGIN
DECLARE @GCode AS SMALLINT

SET @GCode = 
	(SELECT TOP 1 GCode
	From GroupAllowedGodown
	WHERE	
		GroupAllowedGodown.GroupCode = @GroupCode AND
		GroupAllowedGodown.Module = @Module
	ORDER BY Priority, GCode)
RETURN @GCode
END
GO

-- fn_GetGroupCode
CREATE FUNCTION DBO.fn_GetGroupCode (@UserCode SMALLINT)
RETURNS SMALLINT
AS
BEGIN

/*
Author : Muhammad Azhar Inayat
Purpose: This function will be used to fetch Group Code of a user
*/
DECLARE @GroupCode SMALLINT
SET @GroupCode = 
	ISNULL((SELECT MIN(GroupCode) 
	FROM UserGroups 
	WHERE UserCode = @UserCode), 0)

RETURN @GroupCode
END
GO

-- fn_GetHeader
CREATE FUNCTION DBO.fn_GetHeader(@GroupCode SMALLINT, @Module SMALLINT)
RETURNS SMALLINT
AS
BEGIN
DECLARE @HeaderCode AS SMALLINT

SET @HeaderCode = 
	(SELECT TOP 1 HeaderCode
	From GroupAllowedHeader
	WHERE	
		GroupAllowedHeader.GroupCode = @GroupCode AND
		GroupAllowedHeader.Module = @Module
	ORDER BY Priority, HeaderCode)
RETURN @HeaderCode
END
GO

-- fn_GetHeaderWiseSaleSummary
CREATE FUNCTION fn_GetHeaderWiseSaleSummary (@Date DATETIME) RETURNS VARCHAR(8000)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function actually calls another function to parse the parameter @FilterBy using 
	comma ',' as a separator. Now on the basis of returned table/result set, it filters
	item codes from item table into table and returns the resultset to the caller of this
	function where further processing will be done on the basis of the returned resultset.
*/
BEGIN
DECLARE @Rep VARCHAR(8000)
DECLARE @RowCount INT, @RowID INT, @HeaderNO INT
DECLARE @TotNetSale NUMERIC(15,2), @NetSale NUMERIC(15,2)
DECLARE @lt_report TABLE (ROWID INT NOT NULL IDENTITY(1,1), HeaderNo INT, NetSale NUMERIC(15, 2))

INSERT INTO @lt_report (HeaderNo, NetSale)
SELECT HeaderNo, Sales=ISNULL(SUM(T.Sales),0) - ISNULL(SUM(T.SR),0)
FROM
	(SELECT HeaderNo, Sales=ISNULL(SUM(H.InvTotal),0), SR=0
	FROM SaleLedger H
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), @Date, 103)
	GROUP BY H.HeaderNo
	UNION ALL
	SELECT HeaderNo, Sales=0, SR=ISNULL(SUM(H.InvTotal),0)
	FROM SRLedger H
	WHERE CONVERT(VARCHAR(100), H.Date, 103) = CONVERT(VARCHAR(100), @Date, 103)
	GROUP BY H.HeaderNo) T
GROUP BY T.HeaderNo

SET @RowCount = ISNULL((SELECT COUNT(*) FROM @lt_report), 0)
SET @RowID = 1
SET @Rep=''
SET @TotNetSale=0
WHILE @RowID <= @RowCount
BEGIN
	SET @NetSale = ISNULL((SELECT NetSale FROM @lt_report WHERE RowID = @RowID),0)
	SET @HeaderNO = ISNULL((SELECT HeaderNO FROM @lt_report WHERE RowID = @RowID),0)
	SET @Rep = @Rep + 'Header : ' + LTRIM(RTRIM(STR(@HeaderNO, 10))) + ' , Net Sale : ' + LTRIM(RTRIM(STR(@NetSale, 15, 2))) + ' '
	SET @TotNetSale = @TotNetSale + @NetSale 
	SET @RowID = @ROWID + 1
END

IF @RowCount > 0
	SET @Rep = @Rep + '*** Total : ' + LTRIM(RTRIM(STR(@TotNetSale, 15, 2)))

RETURN @Rep
END
GO

-- fn_GetInProcessChequesList
CREATE FUNCTION DBO.fn_GetInProcessChequesList (@AccCode INT) RETURNS TABLE
AS
RETURN  
	(SELECT 
		NoteCode,
		VoucherCode,
		AccCode,
		DocumentNumber,
		TransferredTo=BankAccCode,
		Debit = CASE NoteCatCode WHEN 1 THEN 0 ELSE Amount END,
		Credit = CASE NoteCatCode WHEN 1 THEN Amount ELSE 0 END
	FROM 
		Notes 
	WHERE 
		AccCode = @AccCode AND 
		Finalized = 'Y' AND 
		Posted = 'N')
GO

-- Fn_GetItemCostHistory
CREATE FUNCTION DBO.Fn_GetItemCostHistory(@ICode INT, @Date DATETIME)
RETURNS NUMERIC(15,5)
AS
BEGIN
/*
Author : Muhammad Azhar Inayat
Purpose : This function fetches item cost from historical record and updates into the sale detail and return detail
*/
DECLARE @AvgPrice NUMERIC(15,5)
SET @AvgPrice = ISNULL(
		(SELECT AvgPrice
		FROM ItemCostHistory
		WHERE ItemCostHistory.ICode = @ICode AND ItemCostHistory.Date IN
			(SELECT Date=MAX(T.Date)
			FROM
				(SELECT Date=MAX(Date)
				FROM ItemCostHistory
				WHERE ItemCostHistory.ICode = @ICode AND ItemCostHistory.Date <= @Date
				UNION ALL
				SELECT Date=MIN(Date)
				FROM ItemCostHistory
				WHERE ItemCostHistory.ICode = @ICode AND ItemCostHistory.Date > @Date) T)), 0)
RETURN @AvgPrice
END
GO

-- Fn_GetItemDueQty
CREATE  FUNCTION Fn_GetItemDueQty ( @saleinvcode Int, @icode Int, @salerowid Int )
RETURNS NUMERIC(15, 4)
AS
BEGIN
	Declare @dueqty NUMERIC(15, 4)
	SELECT @dueqty = looseqty
	FROM   SaleDetail sd
	WHERE 	 sd.saleinvcode =  @saleinvcode And
			 sd.icode      	  =  @icode AND
			 sd.rowid      = @salerowid And
			 sd.Due             = 'D'
	IF ( @dueqty Is Null ) Set @dueqty = 0
	RETURN @dueqty
END
GO

-- Fn_GetItemDueQtyOnAllInv
CREATE   FUNCTION Fn_GetItemDueQtyOnAllInv ( @icode Int )
RETURNS NUMERIC(15, 4)
AS
BEGIN
	Declare @dueqty NUMERIC(15, 4)
	SET @dueqty = (Select Sum(looseqty) FROM SaleDetail WHERE icode = @icode And Due = 'D')
	IF ( @dueqty Is Null ) Set @dueqty = 0
	RETURN @dueqty
END
GO

-- Fn_GetItemDueSatisfiedQty
CREATE  FUNCTION Fn_GetItemDueSatisfiedQty ( @saleinvcode Int, @icode Int, @salerowid Int )
RETURNS NUMERIC(15, 4)
AS
BEGIN
	Declare @satisfiedqty NUMERIC(15, 4)
	SELECT @satisfiedqty = Sum(duesatisfyqty)
	FROM   DueSatisfyHeader dsh Inner Join DueSatisfyDetail dsd On dsh.duesatisfycode = dsd.duesatisfycode
	WHERE 	 dsh.saleinvcode = @saleinvcode And
			 dsd.icode      	   = @icode AND
			 dsd.salerowid     = @salerowid
	IF ( @satisfiedqty Is Null ) Set @satisfiedqty = 0
	RETURN @satisfiedqty
END
GO

-- Fn_GetItemPurQtyWRTDate
CREATE Function Fn_GetItemPurQtyWRTDate (@icode Int, @startdate DateTime, @enddate DateTime)
Returns NUMERIC(15, 4)
As
Begin
Declare @Purqty NUMERIC(15, 4)
	Set @Purqty = (Select 	Sum( CASE PL.PurCatCode When 1 THEN (PD.Packqty * PD.PackUnits) When 2 THEN (PD.Packqty * PD.PackUnits) Else PD.LooseQty END )
			From   	PurLedger PL Inner Join PurDetail PD ON
				PL.PurInvCode = PD.PurInvCode And
				PL.Posted = 'Y' And
				PL.Date Between @startdate And @enddate			
			Where   icode = @icode 
			)
	IF @Purqty Is Null 
		Set @Purqty = 0
	Return @Purqty
End
GO

-- Fn_GetItemPurReturnQtyWRTDate
CREATE   Function Fn_GetItemPurReturnQtyWRTDate (@icode Int, @startdate DateTime, @enddate DateTime)
Returns NUMERIC(15, 4)
As
Begin
Declare @PurReturnqty NUMERIC(15, 4)
	Set @PurReturnqty = (Select Sum(PD.LooseQty)
			From   	PRLedger PL Inner Join PRDetail PD ON
				PL.PRInvCode = PD.PRInvCode And
				PL.Date Between @startdate And @enddate			
			Where   icode = @icode 
			)
	IF @PurReturnqty Is Null 
		Set @PurReturnqty = 0
	Return @PurReturnqty
End
GO

-- Fn_GetItemReturnQtyWRTDate
CREATE  Function Fn_GetItemReturnQtyWRTDate (@icode Int, @startdate DateTime, @enddate DateTime)
Returns NUMERIC(15, 4)
As
Begin
Declare @returnqty NUMERIC(15, 4)
	Set @returnqty = 	(Select Sum(SD.looseqty)
				From   	SRLedger SL Inner Join SRDetail SD ON
					SL.SRInvCode = SD.SRInvCode And
					SL.Date Between @startdate And @enddate			
				Where   icode = @icode 
				)
	IF @returnqty Is Null 
		Set @returnqty = 0
	Return @returnqty
End
GO

-- Fn_GetItemSoldQtyWRTDate
CREATE  Function Fn_GetItemSoldQtyWRTDate (@icode Int, @startdate DateTime, @enddate DateTime)
Returns NUMERIC(15, 4)
As
Begin
Declare @soldqty NUMERIC(15, 4)
	Set @soldqty = (Select 	Sum(SD.looseqty)
			From   	SaleLedger SL Inner Join SaleDetail SD ON
				SL.SaleInvCode = SD.SaleInvCode And
				SL.Date Between @startdate And @enddate			
			Where   icode = @icode 
			)
	IF @soldqty Is Null 
		Set @soldqty = 0
	Return @soldqty
End
GO

-- Fn_GetItemStockInGodowns
CREATE  Function Fn_GetItemStockInGodowns (@icode Int, @sgcode Int , @lgcode Int)
Returns NUMERIC(15, 4)
As
Begin
Declare @qty NUMERIC(15, 4)
Set @qty = ( Select Sum(CurrQty) From GodownDetail Where icode = @icode AND gcode between @sgcode AND @lgcode Group By icode )
IF @qty Is Null
	Set @qty = 0
Return @qty
End
GO

-- fn_GetManfWiseNetSaleToDate
CREATE FUNCTION fn_GetManfWiseNetSaleToDate(@Date DATETIME) RETURNS VARCHAR(8000)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	Generates Manufacturer Wise Net Sales Of the month upto the date passed to this code
*/
BEGIN
DECLARE @Rep VARCHAR(8000), @Name VARCHAR(100), @StartDate DATETIME, @EndDate DATETIME
DECLARE @RowCount INT, @RowID INT
DECLARE @TotNetSale NUMERIC(15,2), @NetSale NUMERIC(15,2)
DECLARE @lt_report TABLE (ROWID INT NOT NULL IDENTITY(1,1), Name VARCHAR(100), NetSale NUMERIC(15, 2))

SET @StartDate = CAST(LTRIM(RTRIM(STR(MONTH(@Date)))) + '-01-' + LTRIM(RTRIM(STR(YEAR(@Date)))) AS DATETIME)
SET @EndDate = @Date

INSERT INTO @lt_report (Name, NetSale)
SELECT 
	Manufacturer=LEFT(M.Name, 10),
	NetSale = STR(Round(SUM(S.SaleValue), 2), 15, 2)
FROM
	Item I,
	Manufacturer M,
	(SELECT 
		D.ICode,
		SaleValue = SUM(D.LooseQty * (D.SalePrice - D.ItemFlatDisc) * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01))
	FROM 
		SaleLedger S, SaleDetail D
	WHERE
		S.Date BETWEEN @StartDate AND @EndDate AND
		S.SaleInvCode = D.SaleInvCode
	GROUP BY
		D.ICode
	UNION ALL
	SELECT 
		D.ICode,
		SaleValue = - SUM(D.LooseQty * D.SRPrice * (1 - D.DiscPerc * 0.01) * (1 - S.DiscPerc * 0.01))
	FROM 
		SRLedger S, SRDetail D
	WHERE
		S.Date BETWEEN @StartDate AND @EndDate AND
		S.SRInvCode = D.SRInvCode
	GROUP BY
		D.ICode) S
WHERE
	S.ICode = I.ICode AND I.ManfCode = M.ManfCode
GROUP BY
	M.Name
ORDER BY 
	M.Name

SET @RowCount = ISNULL((SELECT COUNT(*) FROM @lt_report), 0)
SET @RowID = 1
SET @Rep=''
SET @TotNetSale=0
WHILE @RowID <= @RowCount
BEGIN
	SET @NetSale = ISNULL((SELECT NetSale FROM @lt_report WHERE RowID = @RowID),0)
	SET @Name = ISNULL((SELECT Name FROM @lt_report WHERE RowID = @RowID),0)
	SET @Rep = @Rep + LTRIM(RTRIM(@Name)) + ':' + LTRIM(RTRIM(STR(@NetSale, 15, 2))) + ' '
	SET @TotNetSale = @TotNetSale + @NetSale 
	SET @RowID = @ROWID + 1
END

IF @RowCount > 0
	SET @Rep = @Rep + '** Total Sales : ' + LTRIM(RTRIM(STR(@TotNetSale, 15, 2)))

RETURN @Rep
END
GO

-- fn_GetModelListOfItemPart
CREATE FUNCTION fn_GetModelListOfItemPart (@IPartCode INT)
RETURNS VARCHAR(8000)
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Purpose:
	Returns a string containing a comma separated list of models for an 
	itempart fulfilling the criteria specified as parameter.

PARAMETER DESCRIPTION :
	@IPartCode = Determines the item part for which model list is needed
*/

DECLARE @Models TABLE (Name VARCHAR(100) NOT NULL, RowID INT IDENTITY(1,1))
DECLARE @RowID INT, @TotRows INT
DECLARE @List VARCHAR(8000)

INSERT INTO @Models
SELECT M.Name
FROM DBO.ItemPart IP, ItemPartInModel IPM, Model M
WHERE 
	IP.IPartCode = @IPartCode AND
	IP.IPartCode = IPM.IPartCode AND
	IPM.ModelCode = M.ModelCode

SET @TotRows = ISNULL((SELECT COUNT(*) FROM @Models), 0)
SET @RowID=1
SET @List = ''
WHILE @RowID <= @TotRows
BEGIN
	SET @List = @List + ISNULL((SELECT LTRIM(RTRIM(NAME))FROM @Models WHERE RowID = @RowID), '') + ',' 
	SET @RowID = @RowID + 1
END
RETURN @List
END
GO

-- Fn_GetPendingInvoices
CREATE FUNCTION dbo.Fn_GetPendingInvoices ( @Type CHAR(1), @AccCode int)
RETURNS VarChar(8000)
AS
/*
Author: Muhammad Azhar Inayat
Creation Date: April 06, 2022
*/
BEGIN
Declare @InvCode_String VarChar(8000)
Declare @holdInvCode  VarChar(800)

IF @Type = 'C'
	Declare tempcursor Cursor For
	Select '' + LTRIM(RTRIM(CAST(SaleInvCode As Varchar(25)))) + ':'  + LTRIM(RTRIM(CAST(OutstandingAmt As Varchar(25)))) +  ''
	From   SaleLedger
	Where OutstandingAmt <> 0 AND SaleCatCode <> 3 AND CustCode = @AccCode
	For Read Only
ELSE
	Declare tempcursor Cursor For
	Select '' + LTRIM(RTRIM(CAST(PurInvCode As Varchar(25)))) + ':'  + LTRIM(RTRIM(CAST(OutstandingAmt As Varchar(25)))) +  ''
	From   PurLedger
	Where OutstandingAmt <> 0 AND SuppCode = @AccCode
	For Read Only

Open tempcursor

Fetch Next From tempCursor
Into @holdInvCode

Set @InvCode_String = ''

WHILE @@Fetch_Status = 0
	Begin
		Set @InvCode_String = @InvCode_String  + @holdInvCode + ', '
		Fetch Next From tempCursor
		Into @holdInvCode
	End

Close tempcursor
Deallocate tempcursor

Return @InvCode_String

END
GO

-- fn_getPOInvTotal
Create Function dbo.fn_getPOInvTotal ( @POCode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2)
select @netamount=Round((Sum(Round(((POD.rate - POD.itemflatdisc)*(1 - POD.discperc*0.01))*POD.qty,2)) * (1 - POH.discperc*0.01)) - POH.flatdisc+POH.misccharges,0)+
		
		 Round(Sum(POD.packsalestax*(POD.Qty+POD.Bonusqty))+SUM(Round(Round(((POD.rate - POD.itemflatdisc)*(1 - POD.discperc*0.01))*POD.qty,2)* 0.01*POD.gstperc,2))+
		 ((Sum(Round(((POD.rate - POD.itemflatdisc)*(1 - POD.discperc*0.01))*POD.qty,2)) * (1 - POH.discperc*0.01)) - POH.flatdisc)* POH.invgstperc1*0.01 ,0)		 

from PurOrderDetail POD ,PurOrderHeader POH
where 	POH.pocode=@POCode and
	POH.pocode=POD.pocode
group by POH.pocode,
	 POH.flatdisc,
	 POH.Discperc,
	 POH.invgstperc1,
	 POH.misccharges


Return @netamount
End
GO

-- Fn_GetPreference
CREATE FUNCTION DBO.Fn_GetPreference( @PrefName VARCHAR(100) )
RETURNS VARCHAR(200)
AS
BEGIN
/*
Author : Muhammad Azhar Inayat

Purpose : This function finds the preference name pass as parameter to it and
returns the string value of that function
*/
DECLARE @PrefValue VARCHAR(200)

SET @PrefValue = ISNULL((SELECT PrefValue FROM DBO.SoftwarePreferences WHERE LOWER(Name) = LOWER(@prefname)), '')

RETURN LTRIM(RTRIM(@PrefValue))
END
GO

-- fn_getPurInvTotal
CREATE   Function dbo.fn_getPurInvTotal ( @Purinvcode Int )
Returns NUMERIC(15, 2)
As
Begin

Declare @netamount Numeric(15, 2), @RoundUpYo TINYINT
SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundpurinvon'))

SELECT  @netamount = ROUND(
			ISNULL(SUM((PD.looseqty + PD.packqty + PD.bonusqty) *
				PD.unitsalestax),0) +
			ISNULL(SUM(ROUND((PD.looseqty + PD.packqty) * PD.purprice * 
				(1 - (.01 * PD.discperc)) * PD.gstperc * .01, 2)),0) +
			ROUND(ISNULL((SUM(((PD.looseqty + PD.packqty) * PD.purprice) * 
				(1 - (.01 * PD.discperc))) * 
				(1- (.01 * PL.discperc)) - PL.flatdisc) * 
				(PL.invgstperc1 * .01), 2),0), @RoundUpYo) +
			ROUND(ISNULL(SUM((PD.looseqty + PD.packqty) * PD.purprice * 
				(1 - (.01 * PD.discperc))) * (1- (.01 * PL.discperc)),0) + 
				PL.misccharges + PL.salestax - PL.flatdisc, @RoundUpYo)

FROM Purledger PL, PurDetail PD
WHERE  PL.PurInvCode = @PurInvCode AND
		PL.PurInvCode = PD.PurInvCode 
GROUP BY	PL.PurInvCode,
			PL.flatdisc,
			PL.misccharges,
			PL.discperc,
			PL.invgstperc1,
			PL.salestax


Return @netamount
End
GO

-- fn_GetQuotationTotal
CREATE FUNCTION dbo.fn_GetQuotationTotal ( @code Int )
Returns NUMERIC(15, 2)
As
Begin

Declare @netamount Numeric(15, 2)

SET @netamount = ISNULL((SELECT  netamount = 
	Case when Round(Sum ((SD.qty * (SD.saleprice - SD.itemflatdisc)) *  (1 - SD.discperc/100) * (1 - SL.discperc /100) - flatdisc + misccharges), 2) IS NULL Then 0 
	Else Round(Sum(Round((SD.qty * (SD.saleprice - SD.itemflatdisc)) * (1 - SD.discperc /100) * (1 - SL.discperc / 100),2)) - flatdisc + misccharges, 2) End 
	+
	Round(Sum (Round ((SD.qty + SD.bonusqty)* SD.unitsalestax + Round ( Round (  SD.qty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 )) +  
	(Case when (Round(Sum ( (  SD.qty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.qty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), 2)
FROM 
	QuotationHeader SL, QuotationDetail SD
WHERE  
	SL.QuotationCode = @code AND
	SL.Quotationcode = SD.Quotationcode 
GROUP BY 
	SL.Quotationcode,
	SL.flatdisc,
	SL.misccharges,
	SL.discperc,
	SL.invgstperc1),0)

Return @netamount
END
GO

-- Fn_GetQuotProcessedRejectItemList
Create Function dbo.Fn_GetQuotProcessedRejectItemList ( @sdate DateTime, @edate DateTime )
Returns VarChar(2000)
As
/*
Author  : M.Usman
Version : 1.0
Purpose : Returns comma seperated list of quotations which are processed(populates in sale) 
	  but not enough stock during sale to fulfill the item quantities requests given in quotation.
*/
Begin
Declare @quotlist VarChar(2000)
Set     @quotlist = ''
Select  @quotlist = @quotlist + CASE @quotlist WHEN '' THEN '' Else ',' END + Cast(A.QuotationCode As VarChar(15)) 
From 
(
Select 	QH.QuotationCode, QD.icode As ICode, Sum(Case QH.LoosePack When 1 Then QD.qty When 2 Then QD.Qty * QD.PackUnits End) As Qty 
from 	QuotationHeader QH Inner Join QuotationDetail QD On QH.QuotationCode = QD.QuotationCode Inner Join SaleLedger SL On SL.QuotationNo = QH.QuotationCode
Where  	QH.Date Between @sdate And @edate
group by QH.QuotationCode, QD.icode
) A Left Outer Join 
(
Select 	 QH.QuotationCode, SD.Icode As ICode, Sum(SD.LooseQty) As Qty
From   	 QuotationHeader QH Inner Join QuotationDetail QD On QH.QuotationCode = QD.QuotationCode Inner Join SaleLedger SL ON QH.QuotationCode = SL.QuotationNo Inner Join SaleDetail SD On SL.SaleInvCode = SD.SaleInvCode
Where  	 QH.Date Between @sdate And @edate AND
	 QD.Icode = SD.ICode
Group By QH.QuotationCode, SD.ICode
) B On A.ICode = B.ICode And A.QuotationCode = B.QuotationCode

Where ( A.Qty - IsNull(B.Qty,0) ) > 0

Group By A.QuotationCode

Order By A.QuotationCode

Return @quotlist

End
GO

-- fn_getSaleInvLoyaltyTotal
CREATE FUNCTION dbo.fn_getSaleInvLoyaltyTotal ( @saleinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @amount Numeric(15, 2)
SET @amount = ISNULL(
	(SELECT amount = Round(Sum((SD.looseqty * (SD.saleprice - SD.itemflatdisc)) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01) - SL.flatdisc + SL.MiscCharges), 0)
	FROM Saleledger SL, Saledetail SD, Item I
	WHERE SL.SaleInvCode = @saleinvcode AND
		SL.saleinvcode = SD.saleinvcode AND 
		SD.ICode = I.ICode AND
		I.LoyaltyItem = 'Y'
	GROUP BY 
		SL.saleinvcode, SL.flatdisc, SL.misccharges, SL.discperc), 0)
Return @amount
End
GO

-- fn_getSaleInvTotal
CREATE Function dbo.fn_getSaleInvTotal ( @saleinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2), @RoundUpYo TINYINT
SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SELECT  @netamount = Case when Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc   +   misccharges), 2) IS NULL Then 0  Else Round(Sum ( Round((  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100),2) ) - flatdisc   +   misccharges, @RoundUpYo) End 
				+
				Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
				 +  
				(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), @RoundUpYo)
FROM Saleledger SL, Saledetail SD
WHERE  SL.SaleInvCode = @saleinvcode AND
		SL.saleinvcode = SD.saleinvcode 
GROUP BY	SL.saleinvcode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.invgstperc1
IF @@RowCOUNT = 0
	SELECT  @netamount = Case when Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc   +   misccharges), 2) IS NULL Then 0  Else Round(Sum ( Round((  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100),2) ) - flatdisc   +   misccharges, @RoundUpYo) End 
					+
					Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
					 +  
					(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), @RoundUpYo)
	FROM Saleledger SL, SaleInvdetail SD
	WHERE  SL.SaleInvCode = @saleinvcode AND
			SL.saleinvcode = SD.saleinvcode 
	GROUP BY	SL.saleinvcode,
				SL.flatdisc,
				SL.misccharges,
				SL.discperc,
				SL.invgstperc1

Return @netamount
End
GO

-- Fn_getSaleInvTotal_with_AssocSaleInv
CREATE  Function dbo.Fn_getSaleInvTotal_with_AssocSaleInv ( @saleinvcode Int )
Returns Numeric(15,2)
As
Begin
Declare @netamount Numeric(15,2)
Set @netamount = (Select dbo.Fn_getSaleInvTotal(@saleinvcode))
Select @netamount = @netamount + dbo.Fn_getSaleInvTotal(assocsaleinvcode)
From   AssocSaleInvList
Where  SaleInvCode = @SaleInvCode
Return @netamount
End
GO

-- fn_GetSaleQtyAndInvNoListForAnItem
CREATE FUNCTION DBO.fn_GetSaleQtyAndInvNoListForAnItem 
	(@ICode INT, @CustList VARCHAR(8000), @StartInvNo INT, @EndInvNo INT)
RETURNS VARCHAR(8000)
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Purpose:
	Returns a string containing a comma separated sale qty list fulfilling the criteria specified in the parameters.

PARAMETER DESCRIPTION :
	@ICode = Determines the item for which saleqty list is needed
	@CustList = A comma separated list of customer codes to be used in fetching sales record
	@StartInvNo = Determines the starting sale invoice
	@EndInvNo = Determines the ending sale invoice
*/

DECLARE @SaleInvoices TABLE (Qty NUMERIC(15, 4) NOT NULL, SaleInvCode INT NOT NULL, RowID INT IDENTITY(1,1))
DECLARE @RowID INT, @TotRows INT
DECLARE @List VARCHAR(8000)

INSERT INTO @SaleInvoices
SELECT Qty=SUM(SD.LooseQty), SD.SaleInvCode
FROM DBO.SaleLedger SL, DBO.SaleDetail SD
WHERE 
	SD.ICode = @ICode AND
	SD.saleinvcode = SL.saleinvcode AND
	SL.SaleInvCode BETWEEN @StartInvNo AND @EndInvNo AND
	SL.custcode IN (SELECT CODE FROM DBO.UDF_STRINGTOTABL(@CustList, ',') ) AND
	SL.salecatcode IN (1, 2, 3)
GROUP BY SD.SaleInvCode, SD.ICode

SET @TotRows = ISNULL((SELECT COUNT(Qty) FROM @SaleInvoices), 0)
SET @RowID=1
SET @List = ''
WHILE @RowID <= @TotRows
BEGIN
	SET @List = @List + ISNULL((SELECT LTRIM(RTRIM(STR(Qty, 10))) + '/' + LTRIM(RTRIM(STR(SaleInvCode, 10))) FROM @SaleInvoices WHERE RowID = @RowID),'') + ', ' 
	SET @RowID = @RowID + 1
END
RETURN @List
END
GO

-- fn_GetSaleQtyListForAnItem
CREATE  FUNCTION fn_GetSaleQtyListForAnItem 
	(@ICode INT, @CustList VARCHAR(8000), @StartDate DATETIME, @EndDate DATETIME)
RETURNS VARCHAR(8000)
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Purpose:
	Returns a string containing a comma separated sale qty list fulfilling the criteria specified in the parameters.

PARAMETER DESCRIPTION :
	@ICode = Determines the item for which saleqty list is needed
	@CustList = A comma separated list of customer codes to be used in fetching sales record
	@StartDate = Determines the date of starting period
	@EndDate = Determines the date of starting period
*/

DECLARE @SaleInvoices TABLE (Qty NUMERIC(15, 4) NOT NULL, RowID INT IDENTITY(1,1))
DECLARE @RowID INT, @TotRows INT
DECLARE @List VARCHAR(8000)

INSERT INTO @SaleInvoices
SELECT Qty=SUM(SD.LooseQty)
FROM DBO.SaleLedger SL, DBO.SaleDetail SD
WHERE 
	SD.ICode = @ICode AND
	SD.saleinvcode = SL.saleinvcode AND
	SL.originaldate >= @StartDate AND
	SL.originaldate <= @EndDate  AND 
	SL.custcode IN (SELECT CODE FROM DBO.UDF_STRINGTOTABL(@CustList, ',') ) AND
	SL.salecatcode IN (1, 2, 3)
GROUP BY SD.SaleInvCode, SD.ICode

SET @TotRows = ISNULL((SELECT COUNT(Qty) FROM @SaleInvoices), 0)
SET @RowID=1
SET @List = ''
WHILE @RowID <= @TotRows
BEGIN
	SET @List = @List + ISNULL((SELECT LTRIM(RTRIM(STR(Qty))) FROM @SaleInvoices WHERE RowID = @RowID), '') + ',' 
	SET @RowID = @RowID + 1
END
RETURN @List
END
GO

-- fn_getServiceInvTotal
CREATE  Function dbo.fn_getServiceInvTotal ( @invcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2)
SET @netamount = 
	(SELECT A = 	Round(Sum(SD.qty * (SD.price - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc + misccharges, 0)
			+
			Round(
			Sum((SD.qty * (SD.price - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01)) * 0.01*SD.servicegstPerc ) 
			+
			Sum(SD.qty * SD.serviceflattax ) 
			+
			Round((Sum(SD.qty * (SD.price - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc )*0.01*SL.serviceinvgstperc,2)
			,0)
	FROM ServiceHeader SL, ServiceDetail SD
	WHERE  SL.ServiceInvCode = @invcode AND
			SL.ServiceInvCode = SD.ServiceInvCode 
	GROUP BY	SL.ServiceInvCode,
				SL.flatdisc,
				SL.serviceinvgstperc,
				SL.misccharges,
				SL.discperc)

Return @netamount
End
GO

-- fn_getServiceOrderTotal
CREATE Function dbo.fn_getServiceOrderTotal ( @invcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2)
SET @netamount = 
	ISNULL((SELECT 
		NetAmt = 
			ISNULL((Round(SUM(D.Qty * (D.Price - D.ServiceFlatDisc) * (1 - D.DiscPerc * 0.01) * (1 - H.DiscPerc * 0.01)) - H.FlatDisc + H.MiscCharges, 0) + 
				Round(
				Sum((D.qty * (D.price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01)) * 0.01* D.servicegstPerc ) 			+
				Sum(D.qty * D.serviceflattax ) +
				Round((Sum(D.qty * (D.price - D.ServiceFlatDisc) * (1 - D.discperc * 0.01) * (1 - H.discperc * 0.01)) - H.flatdisc )*0.01*H.serviceinvgstperc,2), 0)), 0) + 
			CASE WHEN (SELECT COUNT(IH.IssueInvCode) FROM IssueHeader IH WHERE IH.ServiceOCode = H.ServiceOCode) > 0 THEN		
				ISNULL((SELECT NetAmt=SUM(ID.Qty * ID.Price)
					FROM IssueDetail ID, IssueHeader IH 
					WHERE IH.ServiceOCode = H.ServiceOCode AND IH.IssueInvCode = ID.IssueInvCode), 0)
			ELSE
				ISNULL((SELECT NetAmt=SUM(ID.Qty * ID.SalePrice)
					FROM IssueReqDetail ID, IssueReqHeader IH 
					WHERE H.ServiceOCode = IH.ServiceOCode AND IH.IssueReqInvCode = ID.IssueReqInvCode), 0)
			END
	FROM
		ServiceOHeader H, ServiceODetail D
	WHERE 
		H.ServiceOCode = @invcode AND
		H.ServiceOCode = D.ServiceOCode
	GROUP BY
		H.ServiceOCode,
		H.Date,
		H.Posted,
		H.Cancelled,
		H.ServiceOrderStatusCode,
		H.ServiceInvCode,
		H.SaleInvCode,
		H.CustCode,
		H.PatientCode,
		H.FlatDisc,
		H.DiscPerc,
		H.MiscCharges,
		H.ServiceInvGSTPerc), 0)

Return @netamount
End
GO

-- fn_getServiceReturnInvTotal
CREATE    Function dbo.fn_getServiceReturnInvTotal ( @invcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2)
SET @netamount = 
	(SELECT A = Round(Sum(SD.qty * (SD.serviceprice - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc + misccharges, 0) +
		Round(
		ISNULL(Sum((SD.qty * (SD.serviceprice - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01)) * 0.01 * SD.servicegstPerc), 0) +
		ISNULL(Sum(SD.qty * SD.serviceflattax), 0) +
		ISNULL(Round((Sum(SD.qty * (SD.serviceprice - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc ) * 0.01 * SL.serviceinvgstperc, 2),0)
		,0)
	FROM ServiceRHeader SL, ServiceRDetail SD
	WHERE  SL.ServiceRInvCode = @invcode AND
		SL.ServiceRInvCode = SD.ServiceRInvCode 
	GROUP BY	SL.ServiceRInvCode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.serviceinvgstperc)
Return @netamount
End
GO

-- Fn_getSRBufferInvTotal
CREATE Function dbo.Fn_getSRBufferInvTotal ( @srbufferinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15,2)
SELECT  @netamount = Round( sum( (srbufferdetail.looseqty * srbufferdetail.srprice) *
			    (1 - (.01 * srbufferdetail.discperc))) * 
			    (1- (.01 * srbufferledger.discperc)) + srbufferledger.misccharges + 
			    srbufferledger.salestax - srbufferledger.flatdisc, 0)
			+
		       ROUND(
			SUM( (srbufferdetail.looseqty + srbufferdetail.bonusqty) * srbufferdetail.unitsalestax) + 
			SUM(ROUND( (srbufferdetail.looseqty * srbufferdetail.srprice) *
			    (1 - (.01 * srbufferdetail.discperc)) * srbufferdetail.gstperc * .01, 2)) +
			ROUND( (sum( (srbufferdetail.looseqty * srbufferdetail.srprice) *
			    (1 - (.01 * srbufferdetail.discperc))) * 
			    (1- (.01 * srbufferledger.discperc)) - srbufferledger.flatdisc) * 
			    (srbufferledger.invgstperc1 * .01), 2), 0)
			From srbufferledger, srbufferdetail
			Where	srbufferledger.srbufferinvcode = @srbufferinvcode And
					srbufferledger.srbufferinvcode = srbufferdetail.srbufferinvcode
			GROUP BY 	srbufferledger.srbufferinvcode,
					srbufferledger.discperc,
					srbufferledger.misccharges,
					srbufferledger.salestax,
					srbufferledger.flatdisc,
					srbufferledger.invgstperc1
		
Return @netamount
End
GO

-- fn_getSRInvLoyaltyTotal
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
End
GO

-- Fn_GetSRInvoicesStringForSpecificSaleInvoice
CREATE FUNCTION dbo.Fn_GetSRInvoicesStringForSpecificSaleInvoice ( @saleinvcode int )
RETURNS VarChar(500)
AS
/*
Author: Muhammad Usman
Creation Date: November 07, 2003
*/
BEGIN
Declare @srInvCode_String VarChar(500)
Declare @holdsrInvCode  VarChar(50)
Declare tempcursor Cursor For
Select ' (' + CAST ( SrInvCode As Varchar(25) ) + ','  + CAST ( InvTotal As Varchar(25) ) +  ') '
From   SrLedger
Where SaleInvCode = @saleinvcode
For Read Only

Open tempcursor

Fetch Next From tempCursor
Into @holdsrInvCode

Set @srInvCode_String = ''

WHILE @@Fetch_Status = 0
	Begin
		Set @srInvCode_String = @srInvCode_String  + @holdsrInvCode + ','
		Fetch Next From tempCursor
		Into @holdsrInvCode
	End

Close tempcursor
Deallocate tempcursor

Return @srInvCode_String

END
GO

-- Fn_getSRInvTotal
CREATE    Function dbo.Fn_getSRInvTotal ( @srinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15,2), @RoundUpYo TINYINT
SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SELECT  @netamount = Round( sum( (srdetail.looseqty * srdetail.srprice) *
			    (1 - (.01 * srdetail.discperc))) * 
			    (1- (.01 * srledger.discperc)) + srledger.misccharges + 
			    srledger.salestax - srledger.flatdisc, @RoundUpYo)
			+
		       ROUND(
			SUM( (srdetail.looseqty + srdetail.bonusqty) * srdetail.unitsalestax) + 
			SUM(ROUND( (srdetail.looseqty * srdetail.srprice) *
			    (1 - (.01 * srdetail.discperc)) * srdetail.gstperc * .01, 2)) +
			ROUND( (sum( (srdetail.looseqty * srdetail.srprice) *
			    (1 - (.01 * srdetail.discperc))) * 
			    (1- (.01 * srledger.discperc)) - srledger.flatdisc) * 
			    (srledger.invgstperc1 * .01), 2), @RoundUpYo)
			From  		srledger, srdetail
			Where		srledger.srinvcode = @srinvcode And
					srledger.srinvcode = srdetail.srinvcode
			GROUP BY 	srledger.srinvcode,
					srledger.discperc,
					srledger.misccharges,
					srledger.salestax,
					srledger.flatdisc,
					srledger.invgstperc1
		
Return @netamount
End
GO

-- Fn_getSRTotalValue_ReferencedSale
CREATE Function dbo.Fn_getSRTotalValue_ReferencedSale ( @saleinvcode Int )
Returns Numeric(15,2)
As
Begin
Declare @netamount Numeric(15,2)
Set @netamount = ( 	Select Sum(InvTotal)
			From SrLedger
			Where SaleInvCode = @saleinvcode
		 )

Return @netamount
End
GO

-- fn_getTaxOnSaleInv
CREATE   Function fn_getTaxOnSaleInv ( @saleinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2), @RoundUpYo TINYINT
SET @RoundUpYo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsaleinvon'))

SELECT  @netamount = Round(Sum (Round (  (SD.looseqty + SD.bonusqty)*   SD.unitsalestax + Round ( Round (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc ) * (1 -   SD.discperc * 0.01 ), 2 ) *   SD.gstperc * 0.01 , 2 ) , 2 ) )
			 +  
		(Case when (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) - flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  Else (Round(Sum ( (  SD.looseqty * (  SD.saleprice -   SD.itemflatdisc)) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End ), @RoundUpYo)

FROM Saleledger SL, Saledetail SD
WHERE  SL.SaleInvCode = @saleinvcode AND
		SL.saleinvcode = SD.saleinvcode 
GROUP BY	SL.saleinvcode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.invgstperc1

Return @netamount
End
GO

-- fn_getTaxOnServiceInvoice
CREATE Function dbo.fn_getTaxOnServiceInvoice ( @invcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @taxamount Numeric(15, 2)
SET @taxamount = 
	(SELECT A = 	Round(
			Sum((SD.qty * (SD.price - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01)) * 0.01*SD.servicegstPerc ) 
			+
			Sum(SD.qty * SD.serviceflattax ) 
			+
			Round((Sum(SD.qty * (SD.price - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc )*0.01*SL.serviceinvgstperc,2)
			,0)
	FROM ServiceHeader SL, ServiceDetail SD
	WHERE  SL.ServiceInvCode = @invcode AND
			SL.ServiceInvCode = SD.ServiceInvCode 
	GROUP BY	SL.ServiceInvCode,
				SL.flatdisc,
				SL.serviceinvgstperc,
				SL.misccharges,
				SL.discperc)

Return @taxamount
End
GO

-- fn_getTaxOnServiceReturn
CREATE Function dbo.fn_getTaxOnServiceReturn ( @invcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @taxamount Numeric(15, 2)
SET @taxamount = 
	(SELECT A = 
		Round(
		ISNULL(Sum((SD.qty * (SD.serviceprice - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01)) * 0.01 * SD.servicegstPerc), 0) +
		ISNULL(Sum(SD.qty * SD.serviceflattax), 0) +
		ISNULL(Round((Sum(SD.qty * (SD.serviceprice - SD.ServiceFlatDisc) * (1 - SD.discperc * 0.01) * (1 - SL.discperc * 0.01)) - flatdisc ) * 0.01 * SL.serviceinvgstperc, 2),0)
		,0)
	FROM ServiceRHeader SL, ServiceRDetail SD
	WHERE  SL.ServiceRInvCode = @invcode AND
		SL.ServiceRInvCode = SD.ServiceRInvCode 
	GROUP BY	SL.ServiceRInvCode,
			SL.flatdisc,
			SL.misccharges,
			SL.discperc,
			SL.serviceinvgstperc)
Return @taxamount
End
GO

-- fn_getTaxOnSRInv
CREATE  Function DBO.fn_getTaxOnSRInv ( @srinvcode Int )
Returns NUMERIC(15, 2)
As
Begin
Declare @netamount Numeric(15, 2), @RoundUpTo TINYINT
SET @RoundUpTo = (SELECT A=dbo.Fn_Get_Int_Preference('roundsalereturninvon'))

SELECT 
	@netamount = Round(Sum (Round ((SD.looseqty + SD.bonusqty)* SD.unitsalestax + 
	Round(Round(SD.looseqty * SD.srprice * (1 - SD.discperc * 0.01), 2) * SD.gstperc * 0.01, 2), 2)) +  
	(Case when (Round(Sum ((SD.looseqty * SD.srprice) * (1 - SD.discperc /100) * (1 - SL.discperc /100) - SL.flatdisc), 2)) * SL.invgstperc1 * 0.01 IS NULL Then 0  
	Else (Round(Sum ( (  SD.looseqty * SD.srprice ) *  (1 -   SD.discperc /100) * (1 -   SL.discperc /100) ) - flatdisc ,2) ) * SL.invgstperc1 * 0.01 End), @RoundUpTo)
FROM
	SRledger SL, SRDetail SD
WHERE
	SL.SRInvCode = @sRinvcode AND SL.sRinvcode = SD.sRinvcode 
GROUP BY
	SL.sRinvcode,
	SL.flatdisc,
	SL.misccharges,
	SL.discperc,
	SL.invgstperc1

Return @netamount
End
GO

-- Fn_GetUnposted_AccTrans
CREATE   FUNCTION DBO.Fn_GetUnposted_AccTrans()
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

DECLARE @ln_purchaseacc INT, @ln_cashacc INT, @ln_equityacc INT,
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
SELECT * FROM dbo.Fn_GetUnposted_PurchaseReturn()
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
		WHEN dr_AccCode IN 			(SELECT acccode FROM accounts 
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
	AccCode = CASE WHEN DocumentType = 'RS' OR DocumentType = 'RR' THEN @ln_salestaxonsvc ELSE @ln_salestaxacc END, 
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
	SaleTax_Remarks='Adv. Income Tax ' + CASE WHEN DocumentType = 'SR' OR DocumentType = 'PR' THEN 'Reversed' ELSE 'Accounted For' END, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 
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
	SaleTax_Remarks='FBR POS Service Fee ' + CASE DocumentType WHEN 'SR' THEN 'Reversed' ELSE 'Accounted For' END, CheckNo, UserCode, VoucherCode, InvoiceCode, InvoiceType, 
	OutstandingAmt, Balance, VRow=2, PatientCode, GRN, GCCode, Vehicle, ShipTo, GuestCode, StudentCode, CGS, CurrencyCode, ConversionRate
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
GO

-- Fn_GetUnposted_Adjustment
CREATE FUNCTION DBO.Fn_GetUnposted_Adjustment()
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
	saletax_remarks= '',	CheckNo = NULL, 
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
GO

-- Fn_GetUnposted_Purchase
CREATE FUNCTION DBO.Fn_GetUnposted_Purchase ()
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
SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')
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
			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),	CheckNo = NULL,
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
	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,
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
			ELSE 'pack' END + ' pur. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))),	CheckNo = NULL,
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
	P.salestax, P.flatdisc, P.InvGSTPerc1, P.salesmancode, P.Amt, P.PaymentAccCode,	P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.suppinvcode, P.suppinvdate, P.Remarks,
	P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.UpdateAvgPriceWithNetRate, P.CurrencyCode, P.ConversionFactor,
	P.AdvanceTax, P.AdvanceTaxAmt
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	Gross= ISNULL(Round(SUM(D.WE3 * D.UnitWeight * (D.PackQty + D.LooseQty + D.BonusQty)), 2), 0),
	dr_remarks = CASE WHEN LEN(P.Remarks) > 0 THEN P.Remarks ELSE 'Item Purchase Exp. on Inv #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.purinvcode))) END,
	cr_remarks = (SELECT A.Name FROM Accounts A WHERE A.AccCode=P.WE3_AccCode) + ' Payable',
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
	saletax_remarks= NULL,	CheckNo = NULL,
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
GROUP BY P.purinvcode, P.PurCatCode, P.postdate, P.date, P.WE5_AccCode, P.WExp5_CrAccCode, P.Remarks, P.salesmancode, P.OutstandingAmt, P.GRN, P.GCCode, P.Vehicle, P.ShipTo, P.CurrencyCode, P.ConversionFactor

RETURN
END
GO

-- Fn_GetUnposted_PurchaseReturn
CREATE  FUNCTION DBO.Fn_GetUnposted_PurchaseReturn ()
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
SET @ln_purchaseretacc  = (SELECT code FROM global WHERE name = 'GT_PurchaseReturnsAccount')
SET @ln_salestaxacc	= (SELECT code FROM global WHERE name = 'GT_AdvanceSalesTaxACC')

SET @PRRemks = (SELECT a=DBO.Fn_GetPreference( 'ShowPRetRemarksInLedger' ))

INSERT INTO @retTable /*accounting for purchase returns*/ 
SELECT  documentcode = P.prinvcode, documenttype    = 'PR', catcode = P.PRCatCode,
	dr_acccode = CASE P.PRCatCode WHEN 6 THEN @ln_equityacc /* Opening P/RETURN */ ELSE CASE WHEN P.CustCode > 0 THEN P.CustCode ELSE P.suppcode END /* Cash/Credit P/RETURN */ END,
	cr_acccode = CASE WHEN @InvSys = 'P' THEN @ln_purchaseretacc ELSE @ln_invacc END,
	AlternateAccCode = Null,
 	date    = P.date,
	SaleTax= CASE P.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN 
			ROUND(
			SUM((D.looseqty + D.bonusqty) * D.unitsalestax) +
			SUM(ROUND(D.looseqty * D.prprice * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND((SUM((D.looseqty * D.prprice) * 
				(1 - (.01 * D.discperc))) * (1- (.01 * P.discperc)) -
				P.flatdisc) * (P.invgstperc1 * .01), 2), @RoundUpTo)
		ELSE 0.00 END,
	Gross= 
		CASE P.UpdateAvgPriceWithNetRate 
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
			' pur. return #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), P.prinvcode))),	CheckNo = NULL, 
	UserCode = P.salesmancode, vouchercode=P.prinvcode, invoicecode=P.prinvcode,
	invoicetype = 4 /*4 stands for purchase return*/,
	Amt = P.Amt, DrAmtAccCode = P.PaymentAccCode, CrAmtAccCode = P.suppcode,
	AmtBy = P.AmtBy, AmtDate = P.AmtDate, AmtRef = P.AmtReference,
	OutstandingAmt = P.OutstandingAmt, Balance = 0, PatientCode=NULL,
	GRN = NULL, GCCode = NULL, Vehicle = NULL, ShipTo = NULL, GuestCode=NULL, StudentCode=NULL, CGS=0, CurrencyCode=NULL, ConversionRate=NULL,
	AdvIncomeTax=0.00, FBRPOSFee=0.00
FROM  prledger P, prdetail D
WHERE P.posted = 'N' and P.accountfor = 'Y' AND P.prinvcode = D.prinvcode
GROUP BY P.prinvcode, P.suppcode, P.CustCode, P.prcatcode, P.date, P.discperc, P.misccharges, 
	P.salestax, P.flatdisc, P.invgstperc1, P.salesmancode, P.Amt, P.PaymentAccCode, 
	P.UpdateAvgPriceWithNetRate, P.AmtBy, P.AmtDate, P.AmtReference, P.OutstandingAmt, P.Remarks

RETURN
END
GO

-- Fn_GetUnposted_PurServices
CREATE FUNCTION DBO.Fn_GetUnposted_PurServices ()
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
		isnull(h.flatdisc, 0), 0), 0),
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
FROM ServicePurHeader S
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
	invoicetype = 8, Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,
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
	dr_acccode = D.AccCode, cr_acccode = S.SuppCode, AlternateAccCode = Null, 
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
GO

-- Fn_GetUnposted_SaleOrder
CREATE FUNCTION DBO.Fn_GetUnposted_SaleOrder()
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
	AdvIncomeTax = 0.00, FBRPOSFee=0.00
FROM    SaleOrderHeader S
WHERE   S.Posted = 'N' AND S.Amt <> 0 AND S.AmtDate IS NOT NULL
RETURN
END
GO

-- Fn_GetUnposted_Sales
CREATE  FUNCTION DBO.Fn_GetUnposted_Sales ()
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
SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')
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
	SaleTax=CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN
			Round(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -
				S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		ELSE 0.00 END,
	Gross=CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN 
			Round(
			SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 
				S.misccharges + S.salestax - S.flatdisc, @RoundUpYo)
		ELSE 
			Round(
			SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 
				S.misccharges + S.salestax - S.flatdisc, @RoundUpYo) +
			Round(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -
				S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		END,
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
		ELSE 'cr.' END + ' sale #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),	CheckNo = NULL, 
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
	S.UpdateAvgPriceWithNetRate, S.AdvanceTax, S.AdvanceTaxAmt, S.FBRPosFee
UNION ALL /*accounting for sales having impactinventory='Y' and account for ='Y'*/
SELECT  documentcode = S.saleinvcode, documenttype    = 'SV', catcode = S.SaleCatCode,
	dr_acccode = CASE S.saleCatCode	WHEN 1 THEN S.CashAccCode /* Cash Sale */ 
		WHEN 3 THEN S.CashAccCode /* Cash Sale */ ELSE S.custcode /* Credit Sale */ END,
	cr_acccode = @ln_salesacc,
	AlternateAccCode = CASE S.saleCatCode WHEN 1 THEN S.custcode /* Cash Sale */
		WHEN 3 THEN S.custcode  /* Cash Sale */ ELSE Null END,
	Date    = S.date,
	SaleTax=CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN 
			Round(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -
				S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		ELSE 0.00 END,
	Gross=CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN 
			Round(
			SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 
				S.misccharges + S.salestax - S.flatdisc, @RoundUpYo)
		ELSE 
			Round(
			SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *	(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) + 
				S.misccharges + S.salestax - S.flatdisc, @RoundUpYo) + 
			Round(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * (D.saleprice - D.itemflatdisc)) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (SUM((D.looseqty * (D.saleprice - D.itemflatdisc)) *
				(1 - (.01 * D.discperc))) * (1- (.01 * S.discperc)) -
				S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		END,
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
		RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))),	CheckNo = NULL, 
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
	AdvIncomeTax = CASE WHEN S.AdvanceTax = 'Y' THEN ISNULL(S.AdvanceTaxAmt,0) ELSE 0 END, S.FBRPosFee
FROM saleledger S, saleinvdetail D
WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode 
GROUP BY S.saleinvcode, S.custcode, S.salecatcode, S.date, S.discperc, S.misccharges,
	S.salestax, S.flatdisc, S.invgstperc1, S.salesmancode, S.Amt, S.PaymentAccCode,
	S.AmtBy, S.AmtDate, S.AmtReference, S.OutstandingAmt, S.patientcode, S.admissioncode, S.Remarks,
	S.GRN, S.GCCode, S.Vehicle, S.ShipTo, S.CashAccCode, S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate,
	S.UpdateAvgPriceWithNetRate, S.AdvanceTax, S.AdvanceTaxAmt, S.FBRPosFee
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
	AdvIncomeTax = 0.00, FBRPosFee=0.00
FROM saleledger S, CashierWindow D
WHERE S.Posted = 'N' AND S.AccountFor='Y' AND S.saleinvcode = D.saleinvcode

RETURN
END
GO

-- Fn_GetUnposted_SalesReturn
CREATE FUNCTION DBO.Fn_GetUnposted_SalesReturn ()
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
SET @ln_salesretacc = (SELECT code FROM global WHERE name = 'GT_SalesReturnACC')
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
	SaleTax=CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN
			ROUND(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 
				(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		ELSE 0.00 END,
	Gross= CASE S.UpdateAvgPriceWithNetRate 
		WHEN  'N' THEN
			Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 
			    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo)
		ELSE
			Round( sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 
			    (1- (.01 * S.discperc)) + S.misccharges + S.salestax - S.flatdisc, @RoundUpYo) + 
			ROUND(
			SUM( (D.looseqty + D.bonusqty) * D.unitsalestax) + 
			SUM(ROUND( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc)) * D.gstperc * .01, 2)) +
			ROUND( (sum( (D.looseqty * D.srprice) * (1 - (.01 * D.discperc))) * 
				(1- (.01 * S.discperc)) - S.flatdisc) * (S.invgstperc1 * .01), 2), @RoundUpYo)
		END,
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
		     ELSE ', sale #:' + RTRIM(LTRIM(CONVERT(VARCHAR(12), S.saleinvcode))) END,	CheckNo = NULL, 
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
	 S.GuestCode, S.StudentCode, S.CurrencyCode, S.ConversionRate, 
	 S.UpdateAvgPriceWithNetRate, S.AdvanceTaxAmt, S.FBRPosFee
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
WHERE S.posted = 'N' and S.AccountFor = 'Y' AND S.srinvcode = D.DocumentCode AND D.DocumentType = 'SR'

RETURN
END
GO

-- Fn_GetUnposted_Services
CREATE FUNCTION DBO.Fn_GetUnposted_Services ()
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

INSERT INTO @retTable /*accounting for sales of services*/
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
	saletax_remarks= 'Sales Tax Payable on Service Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceinvcode))),	CheckNo = NULL, 
	UserCode=ISNULL(h.salesmancode, 0), vouchercode = h.serviceinvcode, invoicecode= h.serviceinvcode,
	invoicetype = 5 /* Service sales */,
	Amt =  0, DrAmtAccCode = NULL, CrAmtAccCode = NULL, AmtBy = NULL,
	AmtDate = NULL, AmtRef = NULL, OutstandingAmt = 0, Balance = 0,
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
	CGS = 0 , CurrencyCode = NULL, ConversionRate = NULL, AdvIncomeTax = 0.00, FBRPosFee=0.00
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
	saletax_remarks= 'Sales Tax Payable (Reveral) on Service Ret Inv. #: ' + RTRIM(LTRIM(CONVERT(VARCHAR(12), h.serviceRinvcode))),	CheckNo = NULL, UserCode=h.salesmancode, vouchercode = h.serviceRinvcode,
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
GROUP BY h.serviceRinvcode, h.custcode, h.ServiceRCatCode, h.cashacccode, h.date, h.discperc, h.misccharges, 
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
	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,
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
GO

-- Fn_GetUnposted_TransWindow
CREATE FUNCTION DBO.Fn_GetUnposted_TransWindow ()
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
	AmtRef = NULL, OutstandingAmt = 0, Balance = 0,
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
	cr_remarks = 'Cash Paid Against Transaction Doc. Code: ' + LTRIM(RTRIM(STR(TH.DocumentCode, 10))), 
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
GO

-- Fn_LockSaleDetailRow
CREATE   FUNCTION Fn_LockSaleDetailRow (@saleinvcode Int, @icode Int, @salerowid Int)
RETURNS Int
AS
BEGIN
	Declare @count Int
	SELECT @count = count(*)
	FROM   SaleDetail WITH (UPDLOCK HOLDLOCK)
	WHERE 	 SaleDetail.SaleInvCode = @saleinvcode AND
			 SaleDetail.icode       = @icode AND
			 SaleDetail.rowid       = @salerowid
	RETURN @count
END
GO

-- Fn_OverDueBalance
CREATE FUNCTION Fn_OverDueBalance ( @Type CHAR(1), @Date DATETIME, @AccCode INT, @OverDueDays INT)
RETURNS NUMERIC(15, 5)
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Pre-Processing:
	SP_VirtualGL 'A' ( a stored procedure for updating accounting data must be called before this code)
Purpose:
	This function computes the overdue balance of a customer/supplier depending on the 
	value of parameter named '@Type' utill a specific date (determined by Parameter '@Date'). 
	The overdue balance is different from account balance and is determined by the 
	parameter '@OverDueDays'
PARAMETER DESCRIPTION :
	@Type = Customer/Supplier 'C' stands for Customer 'S' for Supplier
	@Date = DateTime concerned uptill which the overdue info is required
	@AccCode = Concerned Customer/Supplier Code 
	@OverDueDays = Overdue balance computation is based on this intger value assumed in days
*/

DECLARE @OldAccCode INT, @ll_AccCode INT, @RowID INT, @DaysOld INT
DECLARE @StartLimit INT, @EndLimit INT, @WeekOfMonth INT, @WeekDay INT
DECLARE @TDate DateTime
DECLARE @Amt Numeric(15,5), @Paid Numeric(15,5), @Pmt Numeric(15,5), @OverDueBal Numeric(15,5)

DECLARE @lt_amt TABLE  (
	AccCode INT NOT NULL,
	Date DateTime Not Null,
	Amount Numeric(15,5) Not Null Default 0,
	Paid Numeric(15,5) Not Null Default 0,
	RowID INT IDENTITY(1,1) NOT NULL,
	DaysOld INT Not Null Default 0
)

DECLARE @lt_pmt TABLE (
	AccCode INT NOT NULL,
	Amount Numeric(15,5) Not Null Default 0
)

DECLARE @lt_Interval TABLE (
	IntervalID INT IDENTITY (0,1) NOT NULL,
	LowerLimit INT Not Null Default 0,
	UpperLimit INT Not Null Default 0
)

SELECT @StartLimit = 0
WHILE @StartLimit <= @OverDueDays
BEGIN
	SELECT @EndLimit = @StartLimit + CASE @StartLimit WHEN 0 THEN 0 ELSE @OverDueDays - 1 END
	SELECT @EndLimit = CASE WHEN @EndLimit > @OverDueDays THEN @OverDueDays ELSE @EndLimit END

	INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
	VALUES (@StartLimit, @EndLimit)

	SELECT @StartLimit = @EndLimit + 1
END

INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
VALUES (@StartLimit, 99999999)

IF @Type='C'
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Debit, Paid=0, DaysOld=DATEDIFF(day, date, @date)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Debit > 0 AND 
		AccCode = @AccCode
	ORDER BY AccCode, Date, Debit

	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Credit)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Credit > 0 AND 
		AccCode = @AccCode
	GROUP BY AccCode
	ORDER BY AccCode
END
ELSE
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Credit, Paid=0, DaysOld=DATEDIFF(day, date, @Date)
	FROM VirtualGL 
	WHERE Date <= @Date AND Credit > 0 AND AccCode = @AccCode
	ORDER BY AccCode, Date, Credit

	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Debit)
	FROM VirtualGL 
	WHERE 	Date <= @Date AND 
		Debit > 0 AND AccCode = @AccCode
	GROUP BY AccCode
	ORDER BY AccCode
END

DECLARE C1 CURSOR FOR SELECT * FROM @lt_amt
OPEN C1

FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Pmt=ISNULL((SELECT ISNULL(Amount, 0) FROM @lt_pmt WHERE AccCode = @ll_AccCode), 0)

	IF @Pmt <> 0
	BEGIN
		UPDATE @lt_amt
		SET Paid = Paid + CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END
		WHERE RowID = @RowID
	
		SELECT @Pmt = @Pmt - (SELECT CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END)
	
		UPDATE @lt_pmt
		SET Amount = @Pmt 
		WHERE AccCode = @ll_AccCode
	END

	FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
END
CLOSE C1
DEALLOCATE C1

DELETE @lt_amt WHERE Amount - Paid = 0
SET @OverDueBal = ISNULL((SELECT b=SUM(Amount - Paid) FROM @lt_amt WHERE daysold > @OverDueDays), 0)

RETURN (@OverDueBal)
END
GO

-- Fn_OverDueBalanceAll
CREATE FUNCTION Fn_OverDueBalanceAll ( @Type CHAR(1), @Date DATETIME, @OverDueDays INT)
RETURNS @retTable TABLE (AccCode SMALLINT, ODBalance NUMERIC(15,5))
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Pre-Processing:
	SP_VirtualGL 'A' ( a stored procedure for updating accounting data must be called before this code)
Purpose:
	This function computes the overdue balance of a customer/supplier depending on the 
	value of parameter named '@Type' utill a specific date (determined by Parameter '@Date'). 
	The overdue balance is different from account balance and is determined by the 
	parameter '@OverDueDays'
PARAMETER DESCRIPTION :
	@Type = Customer/Supplier 'C' stands for Customer 'S' for Supplier
	@Date = DateTime concerned uptill which the overdue info is required
	@OverDueDays = Overdue balance computation is based on this intger value assumed in days
*/

DECLARE @OldAccCode INT, @ll_AccCode INT, @RowID INT, @DaysOld INT
DECLARE @StartLimit INT, @EndLimit INT, @WeekOfMonth INT, @WeekDay INT
DECLARE @TDate DateTime
DECLARE @Amt Numeric(15,5), @Paid Numeric(15,5), @Pmt Numeric(15,5), @OverDueBal Numeric(15,5)

DECLARE @lt_amt TABLE  (
	AccCode INT NOT NULL,
	Date DateTime Not Null,
	Amount Numeric(15,5) Not Null Default 0,
	Paid Numeric(15,5) Not Null Default 0,
	RowID INT IDENTITY(1,1) NOT NULL,
	DaysOld INT Not Null Default 0
)

DECLARE @lt_pmt TABLE (
	AccCode INT NOT NULL,
	Amount Numeric(15,5) Not Null Default 0
)

DECLARE @lt_Interval TABLE (
	IntervalID INT IDENTITY (0,1) NOT NULL,
	LowerLimit INT Not Null Default 0,
	UpperLimit INT Not Null Default 0
)

SELECT @StartLimit = 0
WHILE @StartLimit <= @OverDueDays
BEGIN
	SELECT @EndLimit = @StartLimit + CASE @StartLimit WHEN 0 THEN 0 ELSE @OverDueDays - 1 END
	SELECT @EndLimit = CASE WHEN @EndLimit > @OverDueDays THEN @OverDueDays ELSE @EndLimit END

	INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
	VALUES (@StartLimit, @EndLimit)

	SELECT @StartLimit = @EndLimit + 1
END

INSERT INTO @lt_Interval (LowerLimit, UpperLimit) 
VALUES (@StartLimit, 99999999)

IF @Type='C'
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Debit, Paid=0, DaysOld=DATEDIFF(day, date, @date)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Debit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer)
	ORDER BY AccCode, Date, Debit

	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Credit)
	FROM VirtualGL 
	WHERE
		Date <= @date AND 
		Credit > 0 AND 
		AccCode IN (SELECT CustCode FROM Customer)
	GROUP BY AccCode
	ORDER BY AccCode
END
ELSE
BEGIN
	INSERT INTO @lt_amt
	SELECT AccCode, Date, Amount=Credit, Paid=0, DaysOld=DATEDIFF(day, date, @Date)
	FROM VirtualGL 
	WHERE Date <= @Date AND Credit > 0 AND 
		AccCode IN (SELECT SuppCode FROM Supplier)
	ORDER BY AccCode, Date, Credit

	INSERT INTO @lt_pmt
	SELECT AccCode, Amount=SUM(Debit)
	FROM VirtualGL 
	WHERE Date <= @Date AND Debit > 0 AND 
		AccCode IN (SELECT SuppCode FROM Supplier)
	GROUP BY AccCode
	ORDER BY AccCode
END

DECLARE C1 CURSOR FOR SELECT * FROM @lt_amt
OPEN C1

FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Pmt=ISNULL((SELECT ISNULL(Amount, 0) FROM @lt_pmt WHERE AccCode = @ll_AccCode), 0)

	IF @Pmt <> 0
	BEGIN
		UPDATE @lt_amt
		SET Paid = Paid + CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END
		WHERE RowID = @RowID AND AccCode = @ll_AccCode
	
		SELECT @Pmt = @Pmt - (SELECT CASE WHEN @Amt >= @Pmt THEN @Pmt ELSE @Amt END)
	
		UPDATE @lt_pmt
		SET Amount = @Pmt 
		WHERE AccCode = @ll_AccCode
	END

	FETCH NEXT FROM C1 INTO @ll_AccCode, @TDate, @Amt, @Paid, @RowID, @DaysOld
END
CLOSE C1
DEALLOCATE C1

INSERT INTO @retTable
SELECT A.AccCode, OverDueBal = ISNULL(SUM(t.Amount - t.Paid), 0)
FROM Accounts A, @lt_amt t
WHERE A.AccCode = t.AccCode AND t.daysold > @OverDueDays
GROUP BY A.AccCode
ORDER BY A.AccCode

RETURN
END
GO

-- fn_Value
CREATE FUNCTION fn_Value(@string VARCHAR(100)) RETURNS INT
AS
BEGIN

	DECLARE @counter INT

	IF @string IS NULL OR @string='' OR LEN(@string) <= 0
		RETURN 0
	
	SET @counter = 1
	
	WHILE @counter <= LEN(@string)
	BEGIN
		IF ASCII(SUBSTRING(@string, @counter, 1)) < 48 OR ASCII(SUBSTRING(@string, @counter, 1)) > 57
			RETURN 0
		SET @counter = @counter + 1
	END 
	
	RETURN CAST(@string AS INT)
END
GO

-- Fn_WeekDayCountInMonth
CREATE FUNCTION Fn_WeekDayCountInMonth ( @date DATETIME )
RETURNS INT
AS
BEGIN
/*
Author :
	M. Azhar Inayat
Purpose:
	This function computes frequency of a day of week's occurence in a particular month.
	A date of that month is passed to this function. The function works as follows:- 
		1)	compute month (using the date passed as input)
		2)	compute year (using the date passed as input)
		3)	compute the day of week (using the date passed as input)
		4)	computes all the days of that month (determined by date passed as input)
		5)	compute the day of week for all the days
		6)	now it filters/counts day of week to which we concerned

PARAMETER DESCRIPTION :
	@Date = DateTime concerned
*/
DECLARE @day_freq INT, @date_month INT, @date_year INT

SET @date_month = MONTH(@Date)
SET @date_year = YEAR(@Date)

SET @day_freq = 
	(SELECT a=COUNT(DATEPART(dw, date))
	FROM udf_DaysOfMonthList( @date_month, @date_year )
	WHERE  DATEPART(dw, date) = DATEPART(dw, @Date) AND	date <= @Date)

RETURN @day_freq
END
GO

-- udf_Count_DayOfWeek
CREATE FUNCTION DBO.udf_Count_DayOfWeek (@StartDate DATETIME, @EndDate DateTime, @DayOfWeek VARCHAR(20)) RETURNS INT
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function takes 3 parameters 
	1) @startdate 2) @enddate 3) 
	3) @DayOfWeek is the day number of week which needs to be counted
	Then Count specific DayOfWeek from this period.

PARAMETER DESCRIPTION :
	@startdate = starting date of the period
	@enddate = ending date of the period
	@DayOfWeek = Day number of week which needs to be counted
*/

BEGIN
	DECLARE @Counter int, @tmpdate DATETIME
	SET @Counter = 0
	SET @tmpdate = @StartDate
	WHILE @tmpdate <= @EndDate
	BEGIN
		SET @tmpdate = @tmpdate + 1

		IF UPPER(DATENAME(dw, @tmpdate)) = UPPER(@DayOfWeek)
			SET @Counter = @Counter + 1
	END
	RETURN @Counter
END
GO

-- udf_DaysOfMonthList
CREATE FUNCTION udf_DaysOfMonthList (@month TINYINT, @Year INT)
RETURNS @retTable TABLE (Date smalldatetime NOT NULL)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function takes two parameters i.e. a month value and a year value.
	Then it generates a resultset/table containing all the valid dates for that 
	month and year. Its logic automatically rejects the invalid dates occuring in the process.

PARAMETER DESCRIPTION :
	@Month = A value ranging from 1 to 12 (if value is not in the range empty resultset is returned)
	@Year = A Value representing the year value
*/

BEGIN
	DECLARE @tmpdate datetime
	DECLARE @counter int
	SET @counter = 1

	WHILE ISDATE(rtrim(ltrim(str(@month))) + '-' + rtrim(ltrim(str(@counter))) + '-' + rtrim(ltrim(str(@year)))) = 1
	BEGIN
		SET @tmpdate = CONVERT(datetime, rtrim(ltrim(str(@month))) + '-' + rtrim(ltrim(str(@counter))) + '-' + rtrim(ltrim(str(@year))))
		INSERT INTO @retTable VALUES (@tmpdate)
		SET @counter = @counter + 1
	END
RETURN
END
GO

-- udf_GetSummaryAccountList
CREATE  FUNCTION udf_GetSummaryAccountList (@AccCode INT)
RETURNS @retTable TABLE (AccCode INT NOT NULL)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function actually is used to fetch a list/table containing 
	account codes that are contained in the same summary account

PARAMETER DESCRIPTION :
	@AccCode = An Account Code whose all associated accounts are needed
*/
BEGIN

INSERT @retTable

SELECT AccCode FROM SummaryAccountDetail 
WHERE SummaryAccCode IN 
	(SELECT SummaryAccCode 
	FROM SummaryAccountDetail 
	WHERE AccCode = @AccCode)
UNION
SELECT @AccCode
RETURN

END
GO

-- udf_GodownOpeningStock
CREATE   FUNCTION udf_GodownOpeningStock 
	(
	@ar_GCode smallint, 
	@ar_startdate datetime, 
	@ReportGrouping CHAR(1), 
	@GroupList VARCHAR(8000), 
	@PriceType tinyint)
RETURNS @retTable TABLE (Code int, qty NUMERIC(15, 4), value numeric(15,5))
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	Returns a result set containing itemcode, opening stock qty and its value for 
	items fulfilling the criteria specified in the parameters.

PARAMETER DESCRIPTION :
	@ar_GCode = Godown whose opening stock is required
	@ar_startdate = Determine the date whose opening stock is required
	@ReportGrouping = The criteria for grouping the items
	@GroupList = A comma separated list of values to be filtered while grouping the record set
	@Pricetype = 1 stands for Sale Price, 2 stands for Purchase Price, 3 stands for Average price
*/

BEGIN

DECLARE @Tab_ItemList TABLE (CODE INT NOT NULL)

INSERT INTO @Tab_ItemList
select CODE FROM udf_selectitems(@ReportGrouping, @GroupList)

INSERT INTO @retTable
SELECT a.icode, qty = sum(a.qty), 
	value=ROUND(SUM(a.qty * CASE @PriceType WHEN 1 THEN Round(i.saleprice/ CASE i.packunits WHEN 0 THEN 1 ELSE i.packunits END, 2) 
					WHEN 2 THEN Round(i.purprice / CASE i.packunits WHEN 0 THEN 1 ELSE i.packunits END, 2) WHEN 3 THEN i.avgprice END), 5)
FROM	
	(SELECT	pd.icode, qty = sum(isnull(case pl.purcatcode 
								when 1 THEN (pd.packqty + pd.bonusqty) * pd.packunits
								when 2 THEN (pd.packqty + pd.bonusqty) * pd.packunits
								else pd.looseqty + pd.bonusqty end, 0))
	FROM purledger pl, purdetail pd
	WHERE 
		pl.posted = 'Y' AND 
		pl.purinvcode = pd.purinvcode AND
		pl.PostDate < @ar_startdate and 
		pd.GCode = @ar_GCode AND
		pd.icode in (select CODE FROM @Tab_ItemList)
	Group By pd.icode
	UNION ALL
	SELECT pd.icode, qty  = - sum(pd.looseqty + pd.bonusqty + pd.packqty * pd.packunits)
	FROM prledger pl, prdetail pd
	WHERE pl.posted = 'Y' AND pl.prinvcode = pd.prinvcode AND
	      pl.date < @ar_startdate and 
		pd.GCode = @ar_GCode AND
		pd.icode in (select CODE FROM @Tab_ItemList)
	Group By pd.icode
	UNION ALL
	SELECT sd.icode, qty  = -sum(sd.looseqty + sd.bonusqty)
	FROM saleledger sl, saledetail sd
	WHERE sl.saleinvcode = sd.saleinvcode AND
	    sl.date < @ar_startdate AND sd.Due IS NULL and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty  = sum(sd.looseqty + sd.bonusqty)
	FROM srledger sl, srdetail sd
	WHERE sl.posted = 'Y' AND sl.srinvcode = sd.srinvcode AND
	    sl.PostDate < @ar_startdate and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty  = -sum(sd.qty)
	FROM issueheader sl, issuedetail sd
	WHERE sl.issueinvcode = sd.issueinvcode AND
	      sl.date < @ar_startdate  and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	select sd.icode, qty  = sum(sd.qty)
	FROM receiptheader sl, receiptdetail sd
	WHERE sl.posted = 'Y' AND sl.receiptinvcode = sd.receiptinvcode AND
	      sl.PostDate < @ar_startdate and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	select sd.icode, qty = sum(sd.looseqty)
	FROM Adjheader sl, Adjdetail sd
	WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 1 AND
	      sl.PostedDate < @ar_startdate and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty = -sum(sd.looseqty)
	FROM Adjheader sl, Adjdetail sd
	WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 2 AND
	      sl.PostedDate < @ar_startdate and 
		sd.GCode = @ar_GCode AND
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT d.icode, qty = -sum(d.duesatisfyqty)
	FROM duesatisfyheader h, duesatisfydetail d
	WHERE h.duesatisfycode=d.duesatisfycode AND
	      h.duesatisfydate < @ar_startdate and 
		d.GCode = @ar_GCode AND
		d.icode in (select CODE FROM @Tab_ItemList)
	Group By d.icode
	UNION ALL
	SELECT d.icode, qty = -sum(d.qty)
	FROM Theader h, Tdetail d
	WHERE h.TransCode=d.TransCode AND
	      h.date < @ar_startdate and 
		h.SGCode = @ar_GCode AND
		d.icode in (select CODE FROM @Tab_ItemList)
	Group By d.icode
	UNION ALL
	SELECT d.icode, qty = sum(d.qty)
	FROM Theader h, Tdetail d
	WHERE h.TransCode=d.TransCode AND
	      h.date < @ar_startdate and 
		h.DGCode = @ar_GCode AND
		d.icode in (select CODE FROM @Tab_ItemList)
	Group By d.icode) A, item i
WHERE i.icode = a.icode
GROUP BY a.icode
RETURN
END
GO

-- udf_openingstock
CREATE    FUNCTION udf_openingstock (@ar_startdate datetime, @ReportGrouping CHAR(1), @GroupList VARCHAR(8000), @PriceType tinyint)
RETURNS @retTable TABLE (Code int, qty NUMERIC(15, 4), value numeric(15,5))
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	Returns a result set containing itemcode, opening stock qty and its value for 
	items fulfilling the criteria specified in the parameters.

PARAMETER DESCRIPTION :
	@ar_startdate = Determine the date whose opening stock is required
	@ReportGrouping = The criteria for grouping the items
	@GroupList = A comma separated list of values to be filtered while grouping the record set
	@Pricetype = 1 stands for Sale Price, 2 stands for Purchase Price, 3 stands for Average price
*/

BEGIN

DECLARE @Tab_ItemList TABLE (CODE INT NOT NULL)

INSERT INTO @Tab_ItemList
select CODE FROM udf_selectitems(@ReportGrouping, @GroupList)

INSERT INTO @retTable
SELECT a.icode, qty = sum(a.qty), 
	value=ROUND(SUM(a.qty * CASE @PriceType WHEN 1 THEN Round(i.saleprice/ CASE i.packunits WHEN 0 THEN 1 ELSE i.packunits END, 2) 
					WHEN 2 THEN Round(i.purprice / CASE i.packunits WHEN 0 THEN 1 ELSE i.packunits END, 2) WHEN 3 THEN i.avgprice END), 5)
FROM	
	(SELECT	pd.icode, qty = sum(isnull(case pl.purcatcode 
								when 1 THEN (pd.packqty + pd.bonusqty) * pd.packunits
								when 2 THEN (pd.packqty + pd.bonusqty) * pd.packunits
								else pd.looseqty + pd.bonusqty end, 0))
	FROM purledger pl, purdetail pd
	WHERE 
		pl.posted = 'Y' AND 
		pl.purinvcode = pd.purinvcode AND
		pl.PostDate < @ar_startdate and 
		pd.icode in (select CODE FROM @Tab_ItemList)
	Group By pd.icode
	UNION ALL
	SELECT pd.icode, qty  = - sum(pd.looseqty + pd.bonusqty + pd.packqty * pd.packunits)
	FROM prledger pl, prdetail pd
	WHERE pl.posted = 'Y' AND pl.prinvcode = pd.prinvcode AND
	      pl.date < @ar_startdate and 
		pd.icode in (select CODE FROM @Tab_ItemList)
	Group By pd.icode
	UNION ALL
	SELECT sd.icode, qty  = -sum(sd.looseqty + sd.bonusqty)
	FROM saleledger sl, saledetail sd
	WHERE sl.saleinvcode = sd.saleinvcode AND
	    sl.date < @ar_startdate AND sd.Due IS NULL and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty  = sum(sd.looseqty + sd.bonusqty)
	FROM srledger sl, srdetail sd
	WHERE sl.posted = 'Y' AND sl.srinvcode = sd.srinvcode AND
	    sl.PostDate < @ar_startdate and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty  = -sum(sd.qty)
	FROM issueheader sl, issuedetail sd
	WHERE sl.issueinvcode = sd.issueinvcode AND
	      sl.date < @ar_startdate  and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	select sd.icode, qty  = sum(sd.qty)
	FROM receiptheader sl, receiptdetail sd
	WHERE sl.posted = 'Y' AND sl.receiptinvcode = sd.receiptinvcode AND
	      sl.PostDate < @ar_startdate and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	select sd.icode, qty = sum(sd.looseqty)
	FROM Adjheader sl, Adjdetail sd
	WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 1 AND
	      sl.PostedDate < @ar_startdate and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT sd.icode, qty = -sum(sd.looseqty)
	FROM Adjheader sl, Adjdetail sd
	WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 2 AND
	      sl.PostedDate < @ar_startdate and 
		sd.icode in (select CODE FROM @Tab_ItemList)
	Group By sd.icode
	UNION ALL
	SELECT d.icode, qty = -sum(d.duesatisfyqty)
	FROM duesatisfyheader h, duesatisfydetail d
	WHERE h.duesatisfycode=d.duesatisfycode AND
	      h.duesatisfydate < @ar_startdate and 
		d.icode in (select CODE FROM @Tab_ItemList)
	Group By d.icode) A, item i
WHERE i.icode = a.icode
GROUP BY a.icode
RETURN
END
GO

-- udf_openingstocksingleitem
CREATE FUNCTION udf_openingstocksingleitem ( @ar_startdate datetime, @ar_icode int) Returns Numeric(15,4) AS

Begin

Declare @qty Numeric(15,4)


Select @qty=sum(A.qty)

From

(SELECT	pd.icode, qty = sum(isnull(case pl.purcatcode 
									when 1 THEN (pd.packqty + pd.bonusqty) * pd.packunits
									when 2 THEN (pd.packqty + pd.bonusqty) * pd.packunits
									else pd.looseqty + pd.bonusqty end, 0)),
			openingdue=0
		FROM purledger pl, purdetail pd
		WHERE 
			pl.posted = 'Y' AND 
			pl.purinvcode = pd.purinvcode AND
			pl.PostDate <   @ar_startdate and 
			pd.icode in (  @ar_icode)
		Group By pd.icode
		UNION ALL
		SELECT pd.icode, qty  = - sum(pd.looseqty + pd.bonusqty + pd.packqty * pd.packunits), openingdue=0
		FROM prledger pl, prdetail pd
		WHERE pl.posted = 'Y' AND pl.prinvcode = pd.prinvcode AND
				pl.date <   @ar_startdate and 
			pd.icode in (  @ar_icode)
		Group By pd.icode
		UNION ALL
		SELECT sd.icode, qty  = -sum(sd.looseqty + sd.bonusqty), openingdue=0
		FROM saleledger sl, saledetail sd
		WHERE sl.saleinvcode = sd.saleinvcode AND
			 sl.date <   @ar_startdate AND sd.Due IS NULL and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		SELECT sd.icode, qty  = sum(sd.looseqty + sd.bonusqty), openingdue=0
		FROM srledger sl, srdetail sd
		WHERE sl.posted = 'Y' AND sl.srinvcode = sd.srinvcode AND
			 sl.PostDate <   @ar_startdate and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		SELECT sd.icode, qty  = -sum(sd.qty), openingdue=0
		FROM issueheader sl, issuedetail sd
		WHERE sl.issueinvcode = sd.issueinvcode AND
			sl.date <   @ar_startdate  and sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		select sd.icode, qty  = sum(sd.qty), openingdue=0
		FROM receiptheader sl, receiptdetail sd
		WHERE sl.posted = 'Y' AND sl.receiptinvcode = sd.receiptinvcode AND
				sl.PostDate <   @ar_startdate and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		select sd.icode, qty = sum(sd.looseqty), openingdue=0
		FROM Adjheader sl, Adjdetail sd
		WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 1 AND
				sl.PostedDate <   @ar_startdate and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		SELECT sd.icode, qty = -sum(sd.looseqty), openingdue=0
		FROM Adjheader sl, Adjdetail sd
		WHERE sl.posted = 'Y' AND sl.Adjcode = sd.Adjcode and sl.Adjcatcode = 2 AND
				sl.PostedDate <   @ar_startdate and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		SELECT d.icode, qty = -sum(d.duesatisfyqty), openingdue=-sum(d.duesatisfyqty)
		FROM duesatisfyheader h, duesatisfydetail d
		WHERE h.duesatisfycode=d.duesatisfycode AND
				h.duesatisfydate <   @ar_startdate and 
			d.icode in (  @ar_icode)
		Group By d.icode
		UNION ALL
		SELECT sd.icode, qty  = 0, openingdue= sum(sd.looseqty)
		FROM saleledger sl, saledetail sd
		WHERE sl.saleinvcode = sd.saleinvcode AND
			sl.date <   @ar_startdate AND sd.Due IS NOT NULL and 
			sd.icode in (  @ar_icode)
		Group By sd.icode
		UNION ALL
		SELECT d.icode, qty = -sum(d.deletedqty), openingdue=-sum(d.deletedqty)
		FROM duesatisfyheader h, duedeletedetail d
		WHERE h.duesatisfycode=d.duesatisfycode AND
				h.duesatisfydate <   @ar_startdate and 
			d.icode in (  @ar_icode)
		Group By d.icode

) AS A

Return @qty

END
GO

-- udf_salesmanscopebased_weekdaylist
CREATE FUNCTION DBO.udf_salesmanscopebased_weekdaylist (@salesmancode SMALLINT, @manfcode SMALLINT, @subareacode SMALLINT)
RETURNS VARCHAR(1000)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function takes 3 parameters i.e. a salesman code , a manufacturer code and a subareacode.
	Then it generates a resultset/table containing all the valid weekdays for that criteria

PARAMETER DESCRIPTION :
	@salesmancode = A salesman code
	@manfcode = A manufacturer code 
	@subareacode = A sub area code 
*/

BEGIN

DECLARE @weekdaylist TABLE (CODE INT, Name VARCHAR(100), RowID INT IDENTITY(1,1))
DECLARE @counter int, @rows INT, @daylist VARCHAR(1000), @RowID INT

INSERT INTO @weekdaylist (Code, Name)
SELECT  DISTINCT
	dbo.salesmanscope.WeekDayCode, WeekDays.Name
FROM 
	dbo.salesmanscope, WeekDays
WHERE 
	( dbo.salesmanscope.salesmancode IN (@salesmancode)) AND
	( dbo.salesmanscope.manfcode = @manfcode ) AND
	( dbo.salesmanscope.subareacode = @subareacode ) AND
	( dbo.salesmanscope.WeekDayCode = WeekDays.WeekDayCode )
ORDER BY 
	dbo.salesmanscope.WeekDayCode

SET @counter = 1
SET @rows = ISNULL((SELECT COUNT(*) FROM @weekdaylist), 0)
SET @RowID=1
SET @daylist=''

WHILE @counter <= @rows
BEGIN
	SET @daylist = @daylist + ISNULL((SELECT LEFT(Name,3) FROM @weekdaylist WHERE RowID=@RowID), '') + ','
	SET @counter = @counter + 1
	SET @RowID = @RowID + 1
END
RETURN @daylist
END
GO

-- udf_selectitems
CREATE  FUNCTION udf_selectitems (@FilterCriteria CHAR(1), @FilterBy VARCHAR(8000))
RETURNS @retTable TABLE (Code INT NOT NULL)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function actually calls another function to parse the parameter @FilterBy using 
	comma ',' as a separator. Now on the basis of returned table/result set, it filters
	item codes from item table into table and returns the resultset to the caller of this
	function where further processing will be done on the basis of the returned resultset.

PARAMETER DESCRIPTION :
	@FilterCriteria = A char representing the filter criteria e.g. 'M'->Manufacturer, 'C'->Item Category, etc.
	@FilterBy = A string in form of comma separated numeric values
*/
BEGIN

DECLARE @Tab_FilterBy TABLE (CODE INT NOT NULL)

INSERT INTO @Tab_FilterBy SELECT CODE FROM udf_StringToTabl(@FilterBy, ',')

INSERT @retTable
SELECT ICode
FROM ITEM
WHERE CASE @FilterCriteria 
	WHEN 'M' THEN MANFCODE
	WHEN 'C' THEN ICatCode
	WHEN 'L' THEN ICCode
	ELSE PACKCODE END IN (SELECT CODE FROM @Tab_FilterBy)
RETURN

END
GO

-- udf_StringToTabl
CREATE  FUNCTION udf_StringToTabl (@strList varchar(8000), @strSep char(1))
RETURNS @retTable TABLE (Code INT NOT NULL)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function actually works as a string parser. It aims to convert a [delimier] separated 
	value list (in form of a string) into a table/resultset (the delimiter may ',' etc.
	This table will be returned to the caller where the further processing will be done 
	on the basis of the returned resultset.

PARAMETER DESCRIPTION :
	@strList = A string in form of comma separated numeric values
	@strSep = A char used as a separator in the parameter @strList
*/
BEGIN
	DECLARE @retTemp TABLE (CODE INT NOT NULL)

	DECLARE @strLen int, @startPos int, @endPos int
	SET @strLen = LEN(@strList)
	SET @startPos = 1

	WHILE @startPos <= @strLen
	BEGIN
			SET @endPos = CHARINDEX(@strSep, @strList, @startPos)
			IF @endPos = 0 OR @endPos IS NULL
			BEGIN
				INSERT INTO @retTemp VALUES (CONVERT(INT, SUBSTRING(@strList, @startPos, @strLen + 1 - @startPos)))
				Set @startPos = @strLen + 1
			END
			ELSE
			BEGIN
				INSERT INTO @retTemp VALUES (CONVERT(INT, SUBSTRING(@strList, @startPos, @endPos - @startPos)))
				Set @startPos = @endPos + 1
			END
	END
INSERT @retTable SELECT DISTINCT CODE FROM @retTemp WHERE CODE IS NOT NULL
RETURN
END
GO

-- udf_StringToTabl_STRING
CREATE FUNCTION DBO.udf_StringToTabl_STRING (@strList varchar(8000), @strSep char(1))
RETURNS @retTable TABLE (Code VARCHAR(100) NOT NULL)
AS
/*
Author :
	M. Azhar Inayat
Purpose:
	This function actually works as a string parser. It aims to convert a [delimier] separated 
	value list (in form of a string) into a table/resultset (the delimiter may ',' etc.
	This table will be returned to the caller where the further processing will be done 
	on the basis of the returned resultset.

PARAMETER DESCRIPTION :
	@strList = A string in form of comma separated numeric values
	@strSep = A char used as a separator in the parameter @strList
*/
BEGIN
	DECLARE @retTemp TABLE (CODE VARCHAR(100) NOT NULL)

	DECLARE @strLen int, @startPos int, @endPos int
	SET @strLen = LEN(@strList)
	SET @startPos = 1

	WHILE @startPos <= @strLen
	BEGIN
			SET @endPos = CHARINDEX(@strSep, @strList, @startPos)
			IF @endPos = 0 OR @endPos IS NULL
			BEGIN
				INSERT INTO @retTemp VALUES (SUBSTRING(@strList, @startPos, @strLen + 1 - @startPos))
				Set @startPos = @strLen + 1
			END
			ELSE
			BEGIN
				INSERT INTO @retTemp VALUES (SUBSTRING(@strList, @startPos, @endPos - @startPos))
				Set @startPos = @endPos + 1
			END
	END
INSERT @retTable SELECT DISTINCT CODE FROM @retTemp WHERE CODE IS NOT NULL
RETURN
END
GO
