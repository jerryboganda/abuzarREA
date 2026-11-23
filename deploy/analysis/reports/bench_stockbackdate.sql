SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;
GO
SELECT 
	godown = case 'Y' when 'Y' then 'All Godown'
				else (select G.Name 
				 		From Godown G where G.Gcode = 1)
				end, 
	Date=S.Date,
	Code = CASE 'M' WHEN 'M' THEN I.ManfCode 
			WHEN 'C' THEN I.ICatCode 
			ELSE I.ICCode END,
	Name = CASE 'M' WHEN 'M' THEN M.name 
			WHEN 'C' THEN IC.name 
			ELSE  ICL.name END,
	AliasName=I.customicode, 
	Item=I.Name,
	active=CASE I.active WHEN 1 THEN 'Y' ELSE 'N' END,
	PurchasePrice=S.purchaseprice,
	PackUnits=S.PackUnits,   
	Stock = sum(S.Stock),   
	UnitPrice = Case 1
		WHEN 2 THEN Round(S.purchaseprice/ CASE WHEN S.PackUnits > 0 THEN S.PackUnits ELSE 1 END, 2)
		WHEN 1 THEN Round(max(S.Saleprice) / CASE WHEN S.PackUnits > 0 THEN S.PackUnits ELSE 1 END, 2)
		WHEN 3 THEN Round(max(S.avgprice), 2) END ,
	StockValue = Sum(S.Stock) * 
		Case 1
		WHEN 2 THEN Round(S.purchaseprice/ CASE WHEN S.PackUnits > 0 THEN S.PackUnits ELSE 1 END, 2)
		WHEN 1 THEN Round(max(S.Saleprice) / CASE WHEN S.PackUnits > 0 THEN S.PackUnits ELSE 1 END, 2)
		WHEN 3 THEN Round(max(S.avgprice), 2) END,
	Manufacturer=M.name,
	Class=ICL.name,
	Category=IC.name

FROM 
	StockReport S,
	Item I,
	Manufacturer M,   
	ItemCategory IC,
	ItemClass ICL
WHERE
	S.Date = '2024-12-31' AND
	( I.ICode = S.ICode ) AND 
	( S.GCode IN 
		(select case 'Y' when 'Y' then gcode else 1 end 
		from godown) ) AND
	( CASE 'M' 
		 WHEN 'M' THEN I.ManfCode
		 WHEN 'C' THEN I.ICatCode 
		 ELSE I.ICCode END IN (SELECT ManfCode FROM Manufacturer) ) AND
	( M.ManfCode = I.ManfCode ) and
	( I.ICatCode= IC.ICatCode) and
	( I.ICCode=ICL.ICCode)

GROUP BY 
	S.Date,
	I.Name, 
	I.CustomICode, 
	I.Active,
	S.PurchasePrice, 
	S.PackUnits, 
	I.ManfCode,
	M.Name, 
	I.ICatCode,
	IC.Name, 
	I.ICCode,
	ICL.Name

ORDER BY
	Name,
	CODE,
	Item,
	AliasName


