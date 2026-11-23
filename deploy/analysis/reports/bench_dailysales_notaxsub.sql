SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
SELECT
	saleinvcode = dbo.saleledger.saleinvcode,
	impactinventory = dbo.saleledger.impactinventory,
	date = dbo.saleledger.date,   
	saletype = (Select Name From SaleType Where SaleTypeCode = dbo.SaleLedger.SaleTypeCode) ,
	invdiscperc = dbo.saleledger.discperc,    
	flatdisc = dbo.saleledger.flatdisc,    
	misccharges = dbo.saleledger.misccharges, 
	invsalestax = dbo.saleledger.salestax,
	invgstperc1 = dbo.saleledger.invgstperc1,
	CustRefNo   = dbo.saleledger.CustRefNo,
	Patient     = dbo.saleledger.Remarks,
	posted = dbo.saleledger.posted,	
	rowid = dbo.saledetail.rowid,
	looseqty = dbo.saledetail.looseqty, 
	bonusqty = dbo.saledetail.bonusqty, 
	machinename=saleledger.machinename,
	machineuser=(select users.username from users where users.usercode=saleledger.salesmancode),
	packing=case when dbo.item.packcode IS Null then space(30) 	else dbo.itempacking.name end,
	itemflatdisc=saledetail.itemflatdisc,
	packqty  = saledetail.packqty,  
	price = dbo.saledetail.saleprice,    
	itemdiscperc = dbo.saledetail.discperc,    
	packunits = dbo.saledetail.packunits,    
	batch = dbo.saledetail.batch,    
	expiry = dbo.saledetail.expiry,    
	salestax  = saledetail.salestax,
	itemname = item.name,
	itemalias=item.customicode,
	unitsalestax = dbo.saledetail.unitsalestax ,    
	gstperc = dbo.saledetail.gstperc ,    
	datestring = Rtrim(LTrim(Str(DatePart(dd, saleledger.date)))) + '/' + Rtrim(LTrim(Str(DatePart(mm, saleledger.date)))) + '/' + Rtrim(LTrim(Str(DatePart(yy, saleledger.date)))), 
	Person = dbo.accounts.name,
	customeralias=accounts.aliasname,
	cust_add1=(select customer.address1 from customer where customer.custcode=saleledger.custcode),
	nic=(select customer.nic from customer where customer.custcode=saleledger.custcode),
	invnettotal = dbo.fn_getSaleInvTotal(dbo.saleledger.saleinvcode),
	/* 
	invnettotalexctax= (SELECT 
				  amountfg = Round( 
										 Sum (  SD.looseqty *  SD.saleprice)    
										 -  Round(Sum (Round((  SD.looseqty  * ( SD.saleprice -  SD.itemflatdisc) * ( SD.discperc * .01)) + ( SD.looseqty  *  SD.itemflatdisc),2)), 2)    
										 - Sum ( Round( SD.looseqty   * ( SD.saleprice  -  SD.itemflatdisc) * (1 - ( SD.discperc * .01)),2)) * ( SL.discperc /100)
										 + misccharges - flatdisc,0)
	
		 FROM dbo.saleledger SL , 
				dbo.saledetail SD
	
		 WHERE  (SL.saleinvcode = dbo.saleledger.saleinvcode )   and
				  (SL.saleinvcode = SD.saleinvcode )   
	
		 GROUP BY SL.misccharges,   
					 SL.flatdisc,   
					 SL.date,   
					 SL.saleinvcode, 
					 SL.invgstperc1, 
					 SL.discperc,  
					 SL.salestax 
	) , */
	totalsalestax = 0
	
FROM
	dbo.saleledger, 
	dbo.saledetail,    
	dbo.Item
	LEFT OUTER JOIN ItemPacking ON (Item.packcode=itempacking.packcode),
	dbo.accounts
	
WHERE  
	dbo.saleledger.date BETWEEN '2023-03-13' AND '2023-03-14'  AND
	dbo.saleledger.salecatcode IN (3) AND 
	1=1 AND 
	dbo.saleledger.saleinvcode = dbo.saledetail.saleinvcode AND
	dbo.saledetail.icode = item.icode AND 
	dbo.saleledger.custcode = dbo.accounts.acccode
UNION ALL
SELECT 
	saleinvcode = dbo.saleledger.saleinvcode,
	impactinventory = dbo.saleledger.impactinventory,
	date = dbo.saleledger.date,   
	saletype = (Select Name From SaleType Where SaleTypeCode = dbo.SaleLedger.SaleTypeCode) ,
	invdiscperc = dbo.saleledger.discperc,    
	flatdisc = dbo.saleledger.flatdisc,    
	misccharges = dbo.saleledger.misccharges, 
	invsalestax = dbo.saleledger.salestax,
	invgstperc1 = dbo.saleledger.invgstperc1,
	CustRefNo   = dbo.saleledger.CustRefNo,
	Patient     = dbo.saleledger.Remarks,
	posted = dbo.saleledger.posted,	
	rowid = sd.rowid,
	looseqty = sd.looseqty, 
	bonusqty = sd.bonusqty, 
	machinename=saleledger.machinename,
	machineuser=(select users.username from users where users.usercode=saleledger.salesmancode),
	packing=case when dbo.item.packcode IS Null then space(30) else dbo.itempacking.name end,
	itemflatdisc=sd.itemflatdisc,
	packqty  = 0,  
	price = sd.saleprice,    
	itemdiscperc = sd.discperc,    
	packunits = sd.packunits,    
	batch = sd.batch,    
	expiry = sd.expiry,    
	salestax  = 0,
	itemname = item.name,
	itemalias=item.customicode,
	unitsalestax = sd.unitsalestax ,    
	gstperc = sd.gstperc ,    
	datestring = Rtrim(LTrim(Str(DatePart(dd, saleledger.date)))) + '/' + Rtrim(LTrim(Str(DatePart(mm, saleledger.date)))) + '/' + Rtrim(LTrim(Str(DatePart(yy, saleledger.date)))), 
	Person = dbo.accounts.name,
	customeralias=accounts.aliasname,
	cust_add1=(select customer.address1 from customer where customer.custcode=saleledger.custcode),
	nic=(select customer.nic from customer where customer.custcode=saleledger.custcode),
	invnettotal = dbo.fn_getSaleInvTotal(dbo.saleledger.saleinvcode),
	totalsalestax = 0
	
FROM
	dbo.saleledger, 
	dbo.saleinvdetail sd,    
	dbo.Item
	LEFT OUTER JOIN ItemPacking ON (Item.packcode=itempacking.packcode),
	dbo.accounts
	
WHERE  
	dbo.saleledger.date BETWEEN '2023-03-13' and '2023-03-14'  and
	dbo.saleledger.salecatcode IN (3) and
	1=1 AND 
	dbo.saleledger.saleinvcode = sd.saleinvcode and  
	sd.icode = item.icode and 
	dbo.saleledger.custcode = dbo.accounts.acccode

Order By 
	saleinvcode, date, rowid

