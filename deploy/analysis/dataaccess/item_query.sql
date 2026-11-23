SET SHOWPLAN_XML ON;
GO
SELECT
dbo.item.icode,
dbo.item.customicode,
dbo.item.name,
localitemname = dbo.item.localitemname,
dbo.item.manfcode, dbo.item.packunits,
dbo.item.purprice, SalePrice = CASE (SELECT G.SalePriceInItemList FROM Groups G WHERE G.GroupCode = 2) WHEN 2 THEN dbo.item.saleprice2
WHEN 3 THEN dbo.item.saleprice3
WHEN 4 THEN dbo.item.saleprice4
WHEN 5 THEN dbo.item.saleprice5
ELSE dbo.item.saleprice END, dbo.Manufacturer.name,
genericname=(select name from genericitem where genericitem.genericcode=item.genericcode),
stock = (select	sum(dbo.godowndetail.currqty)
from	dbo.godowndetail where	dbo.godowndetail.icode = dbo.item.icode),
sstock = CASE WHEN (SELECT salegodownstrategy FROM Groups Where GroupCode = 2) = 2 THEN
(select	sum(dbo.godowndetail.currqty)
from	dbo.godowndetail
where	dbo.godowndetail.icode = dbo.item.icode and
dbo.godowndetail.gcode = item.GCode)
ELSE
(select	sum(dbo.godowndetail.currqty)
from	dbo.godowndetail,
(SELECT DISTINCT GCode From GroupAllowedGodown
WHERE	GroupAllowedGodown.GroupCode = 2 AND
GroupAllowedGodown.Module = 1) T
where	dbo.godowndetail.icode = dbo.item.icode and
dbo.godowndetail.gcode = T.GCode)
END,
pstock = CASE WHEN (SELECT purchasegodownstrategy FROM Groups Where GroupCode = 2) = 2 THEN
(select	sum(dbo.godowndetail.currqty)
from	dbo.godowndetail
where	dbo.godowndetail.icode = dbo.item.icode and
dbo.godowndetail.gcode = item.GCode)
ELSE
(select	sum(dbo.godowndetail.currqty)
from	dbo.godowndetail,
(SELECT DISTINCT GCode From GroupAllowedGodown
WHERE	GroupAllowedGodown.GroupCode = 2 AND
GroupAllowedGodown.Module = 3) T
where	dbo.godowndetail.icode = dbo.item.icode and
dbo.godowndetail.gcode = T.GCode)
END,
Packing = dbo.itempacking.name,
packingdesc=item.packingdesc,
dbo.item.icatcode,
dbo.item.iccode,
dbo.item.packcode,
dbo.item.itemalertcode,
itemalerttypecode = (select ia.itemalerttypecode from itemalert ia where ia.itemalertcode = item.itemalertcode),
dbo.item.restricted,
dbo.item.location,
transitstock=item.transitstock,
BGColor = (SELECT IA.BGColor FROM ItemAlert IA WHERE IA.ItemAlertCode = dbo.item.itemalertcode)
FROM dbo.item LEFT OUTER JOIN dbo.itempacking ON (dbo.item.packcode = dbo.itempacking.packcode), dbo.Manufacturer
WHERE	dbo.item.Active = 1 and
dbo.Manufacturer.manfcode = dbo.item.manfcode ORDER BY dbo.item.name;
GO
SET SHOWPLAN_XML OFF;
GO
