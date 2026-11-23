
/****** Object:  Stored Procedure dbo.sp_IncomeStatment    Script Date: 4/23/02 4:29:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_IncomeStatment    Script Date: 4/8/02 6:26:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_IncomeStatment    Script Date: 3/6/02 3:39:37 PM ******/
/****** Object:  Stored Procedure dbo.sp_IncomeStatment    Script Date: 7/20/01 6:52:01 PM ******/
CREATE PROCEDURE sp_IncomeStatment @ad_SDate DateTime, @ad_EDate DateTime AS

/* Declaration of local Variables to be used in the script later */

declare @ln_cashacc numeric(5, 0)
declare @ln_equityacc numeric(5, 0)
declare @ln_freightacc numeric(5, 0)
declare @ln_octroiacc numeric(5, 0)
declare @ln_salestaxacc numeric(5, 0)
declare @ln_inventoryacc numeric(5, 0)
declare @ln_favourableacc numeric(5, 0)
declare @ln_unfavourableacc numeric(5, 0)
declare @ln_avgpurcostacc numeric(5, 0)
declare @ln_salesacc numeric(5, 0)
declare @ln_salesfixdiscacc numeric(5, 0)
declare @ln_miscchargesacc numeric(5, 0)
declare @ln_salesretacc numeric(5, 0)
declare @ln_purchaseacc numeric(5, 0)
declare @ln_revfromservices numeric(5, 0)

select @ln_cashacc      = (Select code from global where name = 'GT_CashACC')
select @ln_equityacc	= (Select code from global where name = 'GT_EquityACC')
select @ln_freightacc	= (Select code from global where name = 'GT_FreightACC')
select @ln_octroiacc	= (Select code from global where name = 'GT_OctroiACC')
select @ln_salestaxacc	= (Select code from global where name = 'GT_AdvanceSalesTaxACC')
select @ln_inventoryacc	= (Select code from global where name = 'GT_InventoryACC')
select @ln_favourableacc= (Select code from global where name = 'GT_FavourableACC')
select @ln_unfavourableacc = (Select code from global where name = 'GT_UnFavourableACC')
/*select @ln_avgpurcostacc = (Select code from global where name = 'GT_AvgPurCostACC'*/
select @ln_salesacc        = (Select code from global where name = 'GT_SalesACC')
select @ln_salesfixdiscacc = (Select code from global where name = 'GT_SalesFixDiscountACC')
select @ln_miscchargesacc  = (Select code from global where name = 'GT_MiscChargesACC')
select @ln_salesretacc     = (Select code from global where name = 'GT_SalesReturnACC')
select @ln_purchaseacc     = (Select code from global where name = 'GT_PurchaseACC')
select @ln_revfromservices = (Select code from global where name = 'GT_RevenueFromServices')

/* Declaration of Temporary Table to be used for records to be returned by this script */

create table #lt_Accounts
(
	acccode      numeric (5,  0) NOT NULL,
	type	     numeric (2,  0) NOT NULL,
	currbalance  numeric (25, 5) NOT NULL
)

Insert #lt_Accounts
Select a.acccode, 0, 0
from   accounts a
where acccode not in (@ln_revfromservices, @ln_salesretacc, @ln_salesacc)

/**********************************************************************/
/******************* Purchase Module's effects ************************/
/**********************************************************************/

create table #lt_PurchaseSummary
(
	acccode      numeric (5,  0) NOT NULL,
	NetAmt       numeric (25, 2) NOT NULL,    /*Net Cost including flat discounts, misc charges*/
	flatdisc     numeric (11, 2) NOT NULL,
	misccharges  numeric (11, 2) NOT NULL,
	salestax     numeric (11, 2) NOT NULL
)

insert  #lt_PurchaseSummary
select  Case purledger.PurCatCode
		when 1 THEN @ln_cashacc     /* Purchase Purchase Cash */
		when 3 THEN @ln_equityacc   /* Opening Purchase  */
		when 7 THEN @ln_cashacc     /* Cash Purchase Loose */	
		else   purledger.suppcode   /* Credit Purhase Pack (2) or Loose (8)  */
	end,
	IsNull( Round(sum(( (purdetail.looseqty + purdetail.packqty * purdetail.packunits) * purdetail.purprice) * (1 - (.01 * purdetail.discperc))) * (1- (.01 * purledger.discperc)) + purledger.misccharges + purledger.salestax - purledger.flatdisc, 0), 0),
	purledger.flatdisc,
	purledger.misccharges,
	purledger.salestax 

from     purledger,	 
	 purdetail 

where    purledger.date >= @ad_SDate and purledger.date <= @ad_EDate and
	 purledger.posted = 'Y' and
	 purledger.purinvcode = purdetail.purinvcode 

group by purledger.purinvcode,
	 purledger.purcatcode,
	 purledger.date,
	 purledger.discperc,
	 purledger.misccharges,
	 purledger.salestax,
	 purledger.flatdisc,	
	 purledger.suppcode 


/********************** Credit flatdiscount (Income A/c) ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(flatdisc), 0) from #lt_PurchaseSummary)
where  #lt_accounts.acccode = @ln_freightacc

/********************** Debit misc charges (Income A/c) ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(misccharges), 0) from #lt_PurchaseSummary)
where  #lt_accounts.acccode = @ln_octroiacc

/********************** Debit salestax (Current Asset A/c) ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(salestax), 0) from #lt_PurchaseSummary)
where  #lt_accounts.acccode = @ln_salestaxacc

/******************Credit supplier/cash/equity account********************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(#lt_PurchaseSummary.NetAmt), 0) from #lt_PurchaseSummary where #lt_PurchaseSummary.acccode = #lt_accounts.acccode)
from   #lt_accounts, #lt_PurchaseSummary
where  #lt_accounts.acccode = #lt_PurchaseSummary.acccode 

Drop table #lt_PurchaseSummary

/**********************************************************************/
/**************** Purchase Return Module's Effects*********************/
/**********************************************************************/

create table #lt_PurRetSummary
(
	acccode      numeric (5,  0) NOT NULL,
	NetAmt       numeric (15, 2) NOT NULL,    /*Net Cost including flat discounts, misc charges*/
	flatdisc     numeric (11, 2) NOT NULL,
	misccharges  numeric (11, 2) NOT NULL,
	salestax     numeric (11, 2) NOT NULL
)

insert  #lt_PurRetSummary
select  Case prledger.PRCatCode
		when 4 THEN @ln_cashacc     /* Cash Purchase Return */
		when 6 THEN @ln_equityacc   /* Opening Purchase Return */
		else   prledger.suppcode    /* Credit Purhase Return */
	end,

	IsNull(Round(sum((( prdetail.looseqty + prdetail.packqty * prdetail.packunits) * prdetail.prprice) * (1 - (.01 * prdetail.discperc))) * (1- (.01 * prledger.discperc)) + prledger.misccharges + prledger.salestax - prledger.flatdisc, 0), 0),
	prledger.flatdisc,
	prledger.misccharges,
	prledger.salestax

from     prledger,	 
	 prdetail		

where    prledger.date >= @ad_SDate and prledger.date <= @ad_EDate and
	 prledger.posted = 'Y' and
	 prledger.prinvcode = prdetail.prinvcode

group by prledger.prinvcode,
	 prledger.suppcode, 
	 prledger.prcatcode,
	 prledger.date,
	 prledger.discperc,
	 prledger.misccharges,
	 prledger.salestax,
	 prledger.flatdisc		

/**********************Debit flatdiscount ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(flatdisc), 0) from #lt_PurRetSummary)
where  #lt_accounts.acccode = @ln_freightacc

/**********************Credit misc charges ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(misccharges), 0) from #lt_PurRetSummary)
where  #lt_accounts.acccode = @ln_octroiacc

/**********************Credit salestax***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(salestax), 0) from #lt_PurRetSummary)
where  #lt_accounts.acccode = @ln_salestaxacc

/******************Debit supplier/cash/equity account********************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(#lt_PurRetSummary.netAmt), 0) from #lt_PurRetSummary where #lt_PurRetSummary.acccode = #lt_accounts.acccode) 
from   #lt_accounts, #lt_PurRetSummary
where  #lt_accounts.acccode = #lt_PurRetSummary.acccode 

Drop table #lt_PurRetSummary

/**********************************************************************/
/**************************** Sale ***********************************/
/**********************************************************************/

create table #lt_SaleSummary
(
	acccode      numeric (5,  0) NOT NULL,
	InventoryAmt numeric (15, 5) NOT NULL,    /*Average cost of goods*/
	NetAmt       numeric (15, 5) NOT NULL,    /*Net sale price including flat discounts, misc charges etc*/
	salecatcode  numeric (1,  0) NOT NULL,
	flatdisc     numeric (11, 2) NOT NULL,
	misccharges  numeric (11, 2) NOT NULL,
	salestax     numeric (11, 2) NOT NULL
)

insert  #lt_SaleSummary
select  Case saleledger.saleCatCode
		when 1 THEN @ln_cashacc     /* Cash Sale */
		when 3 THEN @ln_cashacc     /* Cash Sale */
		else   saleledger.custcode     /* Credit Sale */
	end,
	IsNull(sum( (saledetail.looseqty + saledetail.packqty * saledetail.packunits) * saledetail.avgprice), 0),
	IsNull(Round(sum(( (saledetail.looseqty + saledetail.packqty * saledetail.packunits) * (saledetail.saleprice - saledetail.itemflatdisc)) * (1 - (.01 * saledetail.discperc))) * (1- (.01 * saleledger.discperc)) + saleledger.misccharges + saleledger.salestax - saleledger.flatdisc, 0), 0),
	saleledger.salecatcode,
	saleledger.flatdisc,
	saleledger.misccharges,
	saleledger.salestax

from     saleledger,	 
	 saledetail		

where    saleledger.date >= @ad_SDate and saleledger.date <= @ad_EDate and
	 saleledger.posted = 'Y' and
	 saleledger.saleinvcode = saledetail.saleinvcode 

group by saleledger.saleinvcode,
	 saleledger.custcode, 
	 saleledger.salecatcode,
	 saleledger.date,
	 saleledger.discperc,
	 saleledger.misccharges,
	 saleledger.salestax,
	 saleledger.flatdisc		

/**********************Debit Average Purchase Cost***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(InventoryAmt), 0) from #lt_SaleSummary)
where  #lt_accounts.acccode = @ln_purchaseacc

/**********************Debit flatdiscount ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(flatdisc), 0) from #lt_SaleSummary)
where  #lt_accounts.acccode = @ln_salesfixdiscacc

/**********************Credit misc charges ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(misccharges), 0) from #lt_SaleSummary)
where  #lt_accounts.acccode = @ln_miscchargesacc

/**********************Credit salestax***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(salestax), 0) from #lt_SaleSummary)
where  #lt_accounts.acccode = @ln_salestaxacc

/**********************Credit Sales***********************/
Insert #lt_accounts
Select distinct @ln_salesacc, salecatcode, 0
from #lt_SaleSummary

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(NetAmt), 0) from #lt_SaleSummary where #lt_SaleSummary.salecatcode = #lt_accounts.type)
from   #lt_accounts
where  #lt_accounts.acccode = @ln_salesacc

/******************Debit customer/cash/equity account********************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(#lt_SaleSummary.NetAmt), 0) from #lt_SaleSummary where #lt_SaleSummary.acccode = #lt_accounts.acccode) 
from   #lt_accounts, #lt_SaleSummary
where  #lt_accounts.acccode = #lt_SaleSummary.acccode 

Drop table #lt_SaleSummary

/**********************************************************************/
/**************************** Sale Return ********************************/
/**********************************************************************/

create table #lt_SaleRetSummary
(
	acccode      numeric (5,  0) NOT NULL,
	InventoryAmt numeric (15, 5) NOT NULL,    /*Average cost of goods*/
	NetAmt       numeric (15, 5) NOT NULL,    /*Sale price of items and disc on total item sale price*/
	srcatcode    numeric (1,  0) NOT NULL,
	flatdisc     numeric (11, 2) NOT NULL,
	misccharges  numeric (11, 2) NOT NULL,
	salestax     numeric (11, 2) NOT NULL
)

insert  #lt_SaleRetSummary
select  Case srledger.srCatCode
		when 6 THEN @ln_cashacc     /* Cash Sale Return*/
		when 8 THEN @ln_cashacc     /* Cash Sale Return*/
		else   srledger.custcode     /* Credit Sale Return*/
	end,
	IsNull( sum(((srdetail.looseqty + srdetail.packqty * srdetail.packunits) * srdetail.srprice) * (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)), 0),
	IsNull(Round(sum(((srdetail.looseqty + srdetail.packqty * srdetail.packunits) * srdetail.srprice) * (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)) + srledger.misccharges + srledger.salestax - srledger.flatdisc, 0), 0),
	srledger.srcatcode,
	srledger.flatdisc,
	srledger.misccharges,
	srledger.salestax

from     srledger,	 
	 srdetail		

where    srledger.date >= @ad_SDate and srledger.date <= @ad_EDate and
	 srledger.posted = 'Y' and
	 srledger.srinvcode = srdetail.srinvcode 

group by srledger.srinvcode,
	 srledger.custcode, 
	 srledger.srcatcode,
	 srledger.date,
	 srledger.discperc,
	 srledger.misccharges,
	 srledger.salestax,
	 srledger.flatdisc		

/**********************Credit Purchase ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(InventoryAmt), 0) from #lt_SaleRetSummary)
where  #lt_accounts.acccode = @ln_purchaseacc

/**********************Credit flatdiscount ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(flatdisc), 0) from #lt_SaleRetSummary)
where  #lt_accounts.acccode = @ln_salesfixdiscacc

/**********************Debit misc charges ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(misccharges), 0) from #lt_SaleRetSummary)
where  #lt_accounts.acccode = @ln_miscchargesacc

/**********************Debit salestax***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(salestax), 0) from #lt_SaleRetSummary)
where  #lt_accounts.acccode = @ln_salestaxacc

/**********************Debit Sales Return ***********************/
Insert #lt_accounts
Select distinct @ln_salesretacc, srcatcode, 0
from #lt_SaleRetSummary

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(NetAmt), 0) from #lt_SaleRetSummary where #lt_SaleRetSummary.srcatcode = #lt_accounts.type)
from   #lt_accounts
where  #lt_accounts.acccode = @ln_salesretacc

/******************credit customer/cash/equity account********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(NetAmt), 0) from #lt_SaleRetSummary where #lt_SaleRetSummary.acccode = #lt_accounts.acccode)
from   #lt_accounts, #lt_SaleRetSummary
where  #lt_accounts.acccode = #lt_SaleRetSummary.acccode 

Drop table #lt_SaleRetSummary

/**********************************************************************/
/**************************** Accounting Vouchers ************************/
/**********************************************************************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(gldetail.debit - gldetail.credit), 0) from glheader, gldetail where glheader.date >= @ad_SDate and glheader.date <= @ad_EDate and glheader.posted = 'Y' and glheader.glvochcode =  gldetail.glvochcode and gldetail.acccode = #lt_accounts.acccode ) 
from   #lt_accounts
where  #lt_accounts.acccode IN (Select distinct acccode from gldetail) 


/**********************************************************************/
/********************* Bills Receivables/Payables **********************/
/**********************************************************************/

/* Credit the Customer A/c for B/R and Debit the Supplier A/c for B/P */
/* that is decrease the balance for Customer or Supplier */

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + 
	(Select IsNull(sum(Case NoteCatCode When 1 Then Amount * -1 Else Notes.Amount      End), 0)
		from Notes 
		where Notes.postdate >= @ad_SDate and Notes.postdate <= @ad_EDate and Notes.posted = 'Y' and 
		Notes.acccode = #lt_accounts.acccode )
from   #lt_accounts
where  #lt_accounts.acccode IN (Select distinct acccode from Notes ) 

/* Credit the Bank A/c for B/P and Debit the Bank A/c for B/R */
/* that is Increase the balance for Customer and Decrease for Supplier */

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + 
	(Select IsNull(sum(Case NoteCatCode When 1 Then Amount    Else Notes.Amount * -1   End), 0)
		from Notes 
		where Notes.postdate >= @ad_SDate and Notes.postdate <= @ad_EDate and Notes.posted = 'Y' and 
		Notes.bankacccode = #lt_accounts.acccode ) 
from   #lt_accounts
where  #lt_accounts.acccode IN (Select distinct bankacccode from Notes ) 

/**********************************************************************/
/********************* Stock Adjustment Decrease **********************/
/**********************************************************************/

create table #lt_Stockadj
(
	AccCode      numeric (5,  0) NOT NULL,
	NetAmt       numeric (15, 5) NOT NULL,    /*Net Cost including flat discounts, misc charges*/
)

/* Accounting impact of Stock Adjustments for Decrease */

insert  #lt_Stockadj

Select 	h.AccCode,
	round(sum((d.looseqty + d.bonusqty) * d.price), 0) as NetAmt

From AdjHeader h, AdjDetail d

where   h.Date >= @ad_SDate and h.Date <= @ad_EDate and
	h.Posted = 'Y' and
	h.AdjCatCode = 2 and
	h.AdjCode = d.AdjCode

group by h.AdjCode,
	 h.AccCode

/**********************Debit Relevant Expense Account ******************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + 
	(Select IsNull(sum(NetAmt), 0) from #lt_Stockadj)
from   #lt_accounts, #lt_Stockadj
where  #lt_accounts.acccode = #lt_Stockadj.acccode

Drop table #lt_Stockadj

/**********************************************************************/
/********************* Stock Adjustment Increase **********************/
/**********************************************************************/

create table #lt_Stockadj2
(
	AccCode      numeric (5,  0) NOT NULL,
	NetAmt       numeric (15, 5) NOT NULL,    /*Net Cost including flat discounts, misc charges*/
)

insert  #lt_Stockadj2

Select 	h.AccCode,
	round(sum((d.looseqty + d.bonusqty) * d.price), 0) as NetAmt

From AdjHeader h, AdjDetail d

where   h.PostedDate >= @ad_SDate and h.PostedDate <= @ad_EDate and
	h.Posted = 'Y' and
	h.AdjCatCode = 1 and
	h.AdjCode = d.AdjCode

group by h.AdjCode,
	 h.AccCode

/**********************Credit Relevant Income Account ******************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance -
	(Select IsNull(sum(NetAmt), 0) from #lt_Stockadj2)
from   #lt_accounts, #lt_Stockadj2
where  #lt_accounts.acccode = #lt_Stockadj2.acccode

Drop table #lt_Stockadj2

/**********************************************************************/
/************************** Sale of Services **************************/
/**********************************************************************/

create table #lt_Services
(
	acccode      	numeric (5,  0) NOT NULL,
	NetAmt       	numeric (15, 5) NOT NULL,    /*Net sale price including flat discounts, misc charges etc*/
	servicecatcode	numeric (2,  0) NOT NULL,
	flatdisc     	numeric (11, 2) NOT NULL,
	misccharges  	numeric (11, 2) NOT NULL
)

insert #lt_Services
Select  Case h.serviceCatCode
	    When 10 THEN @ln_cashacc   /* Cash Service Sale (Retail Cash) */
	    When 12 THEN @ln_cashacc   /* Cash Service Sale (Immediate Cash) */
	    Else   	 h.custcode    /* Credit Service Sale */
	End,
	IsNull(Round(sum( (isnull(d.price, 0) * 
		(1 - (.01 * isnull(d.discperc, 0)))) * 
		(1- (.01 * h.discperc)) + isnull(h.misccharges,0) - 
		isnull(h.flatdisc, 0)), 0), 0),
	h.servicecatcode,
	isnull(h.flatdisc, 0) as flatdisc, 
	isnull(h.misccharges, 0) as misccharges

from     serviceheader h,	 
	 servicedetail d
where    h.date >= @ad_SDate and h.date <= @ad_EDate and
	 h.posted = 'Y' and
	 h.serviceinvcode = d.serviceinvcode 

group by h.serviceinvcode,
	 h.custcode, 
	 h.servicecatcode,
	 h.date,
	 h.discperc,
	 h.misccharges,
	 h.flatdisc

/*******************Credit Revenue From Services A/c ********************/
insert #lt_accounts
select distinct @ln_revfromservices, servicecatcode, 0
from #lt_Services

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(NetAmt), 0) from #lt_Services where #lt_Services.servicecatcode = #lt_accounts.type)
from   #lt_accounts
where  #lt_accounts.acccode = @ln_revfromservices

/******************Debit customer/cash account********************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + 
	(Select IsNull(sum(#lt_Services.NetAmt), 0) from #lt_Services where #lt_Services.acccode = #lt_accounts.acccode) 
from   #lt_accounts, #lt_Services
where  #lt_accounts.acccode = #lt_Services.acccode 

/**********************Debit flatdiscount ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(flatdisc), 0) from #lt_Services)
where  #lt_accounts.acccode = @ln_salesfixdiscacc

/**********************Credit misc charges ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(misccharges), 0) from #lt_Services)
where  #lt_accounts.acccode = @ln_miscchargesacc

Drop table #lt_Services

/**********************************************************************/
/********************** Sale Returns of Services **********************/
/**********************************************************************/

create table #lt_ServicesRet
(
	acccode      	numeric (5,  0) NOT NULL,
	NetAmt       	numeric (15, 5) NOT NULL,    /*Net sale price including flat discounts, misc charges etc*/
	servicecatcode	numeric (2,  0) NOT NULL,
	flatdisc     	numeric (11, 2) NOT NULL,
	misccharges  	numeric (11, 2) NOT NULL
)

insert #lt_ServicesRet
Select  Case h.serviceRCatCode
	    When 13 THEN @ln_cashacc   /* Cash Service Sale Return (Retail Cash) */
	    When 15 THEN @ln_cashacc   /* Cash Service Sale Return (Immediate Cash) */
	    Else   	 h.custcode    /* Credit Service Sale Return */
	End,
	IsNull(Round(sum( (isnull(d.Serviceprice, 0) * 
		(1 - (.01 * isnull(d.discperc, 0)))) * 
		(1- (.01 * h.discperc)) + isnull(h.misccharges,0) - 
		isnull(h.flatdisc, 0)), 0), 0),
	h.serviceRcatcode,
	isnull(h.flatdisc, 0) as flatdisc, 
	isnull(h.misccharges, 0) as misccharges

from     serviceRheader h,	 
	 serviceRdetail d
where    h.date >= @ad_SDate and h.date <= @ad_EDate and
	 h.posted = 'Y' and
	 h.serviceRinvcode = d.serviceRinvcode 

group by h.serviceRinvcode,
	 h.custcode, 
	 h.serviceRcatcode,
	 h.date,
	 h.discperc,
	 h.misccharges,
	 h.flatdisc

/******************* Debit Revenue From Services A/c ********************/
insert #lt_accounts
select distinct @ln_revfromservices, servicecatcode, 0
from #lt_ServicesRet

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(NetAmt), 0) from #lt_ServicesRet where #lt_ServicesRet.servicecatcode = #lt_accounts.type)
from   #lt_accounts
where  #lt_accounts.acccode = @ln_revfromservices

/******************** Credit customer/cash account **********************/

Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - 
	(Select IsNull(sum(#lt_ServicesRet.NetAmt), 0) from #lt_ServicesRet where #lt_ServicesRet.acccode = #lt_accounts.acccode) 
from   #lt_accounts, #lt_ServicesRet
where  #lt_accounts.acccode = #lt_ServicesRet.acccode 

/********************** Credit flatdiscount ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance - (Select IsNull(sum(flatdisc), 0) from #lt_ServicesRet)
where  #lt_accounts.acccode = @ln_salesfixdiscacc

/********************** Debit misc charges ***********************/
Update #lt_accounts
set    #lt_accounts.currbalance = #lt_accounts.currbalance + (Select IsNull(sum(misccharges), 0) from #lt_ServicesRet)
where  #lt_accounts.acccode = @ln_miscchargesacc

Drop table #lt_ServicesRet

/**************************Final Housing Keeping *********************/

create table #lt_Amt
(
	AccCode int NOT NULL ,
	SubAccCode smallint NOT NULL ,
	CatAccCode smallint NOT NULL ,
	MainAccCode smallint NOT NULL ,
	AcName varchar (60) NOT NULL ,
	SubAcName varchar (60) NOT NULL ,
	CatAcName varchar (60) NOT NULL ,
	MainAcName varchar (60) NOT NULL ,
	Value1 numeric(25, 5) NULL,
	Type numeric(2, 0) NOT NULL
)

Insert #lt_Amt (acccode, subacccode, catacccode, mainacccode, acname, 
	subacname, catacname, mainacname, value1, type)

Select a.acccode, s.subacccode, c.catacccode, m.mainacccode, a.name, s.name, c.name, m.name, 
	#lt_Accounts.currbalance, #lt_Accounts.type

from   #lt_Accounts, accounts a, subaccounts s, categoryaccounts c, mainaccounts m
where #lt_Accounts.acccode = a.acccode and a.subcode = s.subacccode and 
	s.catacccode = c.catacccode and c.mainacccode = m.mainacccode and
	m.mainacccode in (4, 5) and #lt_Accounts.currbalance <> 0

Update #lt_Amt
set   #lt_Amt.Acname = salecategory.name
from #lt_Amt, salecategory
where 	#lt_Amt.acccode in (@ln_revfromservices, @ln_salesretacc, @ln_salesacc) and
	#lt_Amt.type = salecategory.salecatcode

/* */
Delete ReportData

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select 	Code1=AccCode,
	Code2=SubAccCode,
	AcName,
	SubAcName,
	MainAcName,
	Value1,
	0,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_salesacc

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select 	Code1 = AccCode,
	Code2 = SubAccCode,
	AcName="TOTAL SALES FOR THE PERIOD",
	SubAcName,
	MainAcName,
	Value1 = 0,
	Value2 = sum(value1),
	date1=@ad_SDate,
	date2=@ad_EDate

from #lt_Amt
where Acccode = @ln_salesacc
group by AccCode,
	CatAccCode,
	SubAccCode,
	MainAccCode,
	SubAcName,
	CatAcName,
	MainAcName

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select 	code1=AccCode,
	code2=SubAccCode,
	AcName,
	SubAcName,
	MainAcName,
	Value1,
	0,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_salesretacc

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  code1=AccCode,
	code2=SubAccCode,
	AcName="TOTAL RETURNS FOR THE PERIOD",
	SubAcName,
	MainAcName,
	Value1 = 0,
	Value2 = sum(value1),
	date1=@ad_SDate,
	date2=@ad_EDate

from #lt_Amt
where Acccode = @ln_salesretacc
group by AccCode,
	CatAccCode,
	SubAccCode,
	MainAccCode,
	SubAcName,
	CatAcName,
	MainAcName
	
/* */
declare @ln_netsal numeric(25, 5)
declare @ln_gp numeric(25, 5)
declare @ln_other_income_exp numeric(25, 5)

/* */
select @ln_netsal = sum(value2) from ReportData

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select distinct 
	code1=AccCode,
	code2=SubAccCode,
	AcName="NET SALES FOR THE PERIOD",
	SubAcName,
	MainAcName,
	Value1 = 0,
	Value2 = (select sum(i.value1) from Reportdata i),
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
Where AccCode = @ln_salesretacc

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  code1= AccCode,
	code2= SubAccCode,
	AcName = "COST OF SALES",
	SubAcName,
	MainAcName,
	Value1=0,
	Value2=Value1,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_purchaseacc
Select @ln_gp = @ln_netsal + sum(i.value2) from reportdata i
			where i.code1 = @ln_purchaseacc
/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  code1=AccCode,
	code2=SubAccCode,
	AcName = "GROSS PROFIT/(LOSS)",
	SubAcName,
	MainAcName,
	Value1= 0,
	value2 = @ln_gp,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_purchaseacc

/* */
select @ln_other_income_exp = sum(Value1)
from #lt_Amt
where Acccode not in (select i.code1 from reportdata i)

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  code1=AccCode,
	code2=SubAccCode,
	AcName,
	SubAcName = "Misc. Sales Income",
	MainAcName,
	Value1 = 0,
	value2 = Value1,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_miscchargesacc

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select 	code1=AccCode,
	code2=SubAccCode,
	AcName,
	SubAcName,
	MainAcName,
	Value1=0,
	vlaue2=value1,
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode = @ln_revfromservices

/* */
insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  subacccode,
	subacccode,
	acname,
	subacname,
	mainacname,
	value1=0,
	value2=sum(value2),
	date1 = date1,
	date2 = date2
from (

select  Acccode,
	SubAccCode,
	AcName=SubAcName,
	Subacname,
	Mainacname,	Value1 = 0,
	Value2 = sum(Value1),
	date1=@ad_SDate,
	date2=@ad_EDate
from #lt_Amt
where Acccode not in (select i.code1 from reportdata i)
GRoup BY MainAccCode,
	 CatAccCode,
	 SubAccCode,
	 AccCode,
	 SubAcName,
	 MainAcName,
	 AcName) AS abc

Group BY SubAccCode,
	 SubAcName,
	 MainAcName,
	 Acname,
	 date1,
	 date2

ORDER BY SubAccCode

insert ReportData (code1, code2, name1, name2, name3, value1, value2, date1, date2)
select  code1=null,
	code2=null,
	AcName= 'NET PROFIT/(LOSS)',
	null,
	null,
	Value1 = 0,
	Value2 = @ln_other_income_exp + @ln_gp,
	date1=@ad_SDate,
	date2=@ad_EDate

Drop table #lt_Accounts




