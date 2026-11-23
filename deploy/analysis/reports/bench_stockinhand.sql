SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;
GO
SELECT 
	Item.Name,  
	aliasname=item.customicode, 
	active=CASE item.active WHEN 1 THEN 'Y' ELSE 'N' END,
	saleprice=item.saleprice,
	Item.purprice,   
	Item.PackUnits,   
	QTY = isnull(sum(GodownDetail.CurrQty),0),   
	Manufacturer.name,  
	classname=itemclass.name,
	Category=itemcategory.name,
	UnitPrice = Case 1 
					WHEN 2 THEN Round(Item.purprice /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 1 THEN Round(max(Item.Saleprice) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 4 THEN Round(max(Item.Saleprice2) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 5 THEN Round(max(Item.Saleprice3) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 6 THEN Round(max(Item.Saleprice4) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 7 THEN Round(max(Item.Saleprice5) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 8 THEN Round(max(Item.Retailprice) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 3 THEN max(Item.avgprice)
				END ,
	PackQty =isnull( Round(sum(GodownDetail.CurrQty) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2),0),
	StockValue = isnull(Sum(GodownDetail.CurrQty),0) *
				 Case 1 
					 WHEN 2 THEN Round(Item.purprice /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					 WHEN 1 THEN Round(max(Item.Saleprice) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 4 THEN Round(max(Item.Saleprice2) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 5 THEN Round(max(Item.Saleprice3) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 6 THEN Round(max(Item.Saleprice4) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 7 THEN Round(max(Item.Saleprice5) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
					WHEN 8 THEN Round(max(Item.Retailprice) /  CASE WHEN Item.PackUnits > 0 THEN Item.PackUnits ELSE 1 END, 2)
		WHEN 3 THEN max(Item.avgprice)
				END
	
FROM 
	Manufacturer,   
	Item
	LEFT OUTER JOIN GodownDetail ON (Item.ICode = GodownDetail.ICode)
	LEFT OUTER JOIN ItemClass ON (Item.iccode=itemclass.iccode),
	ItemCategory

WHERE 
	( Item.ManfCode IN (SELECT ManfCode FROM Manufacturer ) ) and
	( Manufacturer.manfcode = Item.ManfCode ) and
	( Item.icatcode=itemcategory.icatcode) and
	( Item.active=1)
	
GROUP BY Item.name, item.customicode, Item.Active, Item.purprice, Item.PackUnits, 
	Manufacturer.name, item.saleprice, itemcategory.name, Itemclass.name

