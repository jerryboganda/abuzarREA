/* 
	First Delete Reports Older than @DailyReportDays passed as first argument 
	to this script. But Don't Delete Reports for 1st, 10th and 20th day of month.
*/
/**** Deletion Stopped C/O Rashid/Shakil/Azhar 05-JUN-2023  ****/
--DELETE StockReport WHERE DATE <= GETDATE() - @DailyReportDays AND DATEPART(dy, DATE) NOT IN (1, 10, 20)

/* 
	Now Delete Reports Older than @ArchiveReportDays passed as 2nd argument 
	to this script. This will Delete Reports for 1st, 10th and 20th day of month
	as well.
*/
/**** Deletion Stopped C/O Rashid/Shakil/Azhar 05-JUN-2023  ****/
--DELETE StockReport WHERE DATE <= GETDATE() - @ArchiveReportDays

/*
	Now check whether the today's report is submitted/saved or not. If yes than no 
	need to save it again else store it.
*/
INSERT INTO StockReport (Date, GCode, ICode, Stock, PurchasePrice, SalePrice, 
	AvgPrice, RecentPurchasePrice, PackUnits)
SELECT
	Date=GETDATE(),
	Gcode=Gd.GCode,
	ICode=Gd.ICode,
	Stock=SUM(Gd.CurrQty),
	PurchasePrice=I.PurPrice,
	SalePrice=I.SalePrice,
	AvPrice=I.AvgPrice,
	RecentPurchasePrice=I.RecentPurPrice,
	PackUnits=I.PackUnits
FROM
	GodownDetail Gd,
	Item I
WHERE
	Gd.ICode = I.ICode AND
	CONVERT(DATETIME, RTRIM(LTRIM(STR(DATEPART(month, GETDATE())))) + '-' +
	RTRIM(LTRIM(STR(DATEPART(day, GETDATE()))))  + '-' +
	RTRIM(LTRIM(STR(DATEPART(year, GETDATE()))))) NOT IN
	(SELECT DISTINCT 
		CONVERT(DATETIME, RTRIM(LTRIM(STR(DATEPART(month, DATE)))) + '-' +
		RTRIM(LTRIM(STR(DATEPART(day, DATE))))  + '-' +
		RTRIM(LTRIM(STR(DATEPART(year, DATE)))))
	FROM STOCKREPORT)

GROUP BY
	Gd.GCode,
	Gd.ICode,
	I.PurPrice,
	I.SalePrice,
	I.AvgPrice,
	I.RecentPurPrice,
	I.PackUnits
