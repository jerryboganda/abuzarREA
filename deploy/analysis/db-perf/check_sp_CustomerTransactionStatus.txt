
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 4/23/02 4:29:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 4/8/02 6:26:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 3/6/02 3:39:36 PM ******/
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 7/20/01 6:52:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 7/12/01 10:16:17 AM ******/
/****** Object:  Stored Procedure dbo.sp_CustomerTransactionStatus    Script Date: 7/11/01 1:28:49 PM ******/
CREATE PROCEDURE sp_CustomerTransactionStatus @ad_date datetime ,@ad_ldate datetime AS

create table #lt_pvamts 
(
	debit  numeric (15, 2) NOT NULL,
	credit numeric (15, 2) NOT NULL,
	code   numeric (5,0) NOT NULL,
	name varchar(50) NOT NULL
)

/***************************** Credit Sales Transactions **********************************/

insert #lt_pvamts
select   Debit = Isnull(Round(SUM(saledetail.looseqty * saledetail.unitsalestax) + 
	 SUM(ROUND( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc)) * saledetail.gstperc * .01, 2)) +
	 Round( (sum( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc))) * (1- (.01 * saleledger.discperc)) - saleledger.flatdisc) * (saleledger.invgstperc1 * .01), 2), 0) +
	 Round( sum( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc))) * (1- (.01 * saleledger.discperc)) + saleledger.misccharges + saleledger.salestax - saleledger.flatdisc, 0), 0),
	 credit = 0.0,
	 custcode=saleledger.custcode	,
	 name=(select accounts.name from accounts where acccode=saleledger.custcode)
     
from     saleledger, saledetail  
where    saleledger.saleinvcode = saledetail.saleinvcode and
	 saleledger.salecatcode = 2   and 
 	 saleledger.date < @ad_date  and
	 saleledger.posted = 'Y' 
	 
group by saleledger.saleinvcode,
	 salecatcode, 
         saleledger.custcode,
	 saleledger.date,
	 saleledger.discperc,
	 saleledger.misccharges,
	 saleledger.salestax,
	 saleledger.invgstperc1,
	 saleledger.flatdisc

/************************** Credit Sales Returns Transactions ******************************/

insert #lt_pvamts
select   Debit = 0.0,
	 Credit = Isnull(Round(SUM(srdetail.looseqty * srdetail.unitsalestax) + 
	 SUM(ROUND( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc)) * srdetail.gstperc * .01, 2)) +
	 Round( (sum( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)) - srledger.flatdisc) * (srledger.invgstperc1 * .01), 2), 0) +
	 Round( sum( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)) + srledger.misccharges + srledger.salestax - srledger.flatdisc, 0), 0),
         custcode=srledger.custcode,
	 name=(select accounts.name from accounts where acccode=srledger.custcode)
from     srledger, srdetail
where    srledger.srinvcode = srdetail.srinvcode and
	 srledger.srcatcode = 7     and 
 	 srledger.date < @ad_date  and
	 srledger.posted = 'Y' 	 
group by srledger.srinvcode,
	 srledger.srcatcode,
         srledger.custcode,
	 srledger.date,
	 srledger.discperc,
	 srledger.misccharges,
	 srledger.salestax,
	 srledger.invgstperc1,
	 srledger.flatdisc

/***************************** Credit Services Transactions ********************************/

insert #lt_pvamts

select  debit = IsNull( sum(IsNull(servicedetail.price, 0) * 
	(1 - (.01 * servicedetail.discperc))) * (1- (.01 * serviceheader.discperc)) +
	serviceheader.misccharges - serviceheader.flatdisc,0),
	credit= 0.0,
        custcode=serviceheader.custcode	,
	name=(select accounts.name from accounts where acccode=serviceheader.custcode)
from     serviceheader, servicedetail
where    serviceheader.serviceinvcode = servicedetail.serviceinvcode and
	 serviceheader.servicecatcode = 11     and 
 	 serviceheader.date < @ad_date  and
	 serviceheader.posted = 'Y' 
	

group by serviceheader.serviceinvcode,
	 serviceheader.servicecatcode,
         serviceheader.custcode,
	 serviceheader.date,
	 serviceheader.discperc,
	 serviceheader.misccharges,
	 serviceheader.flatdisc

/************************* Credit Services Returns Transactions ***************************/

insert #lt_pvamts

select  debit = 0.0,
	credit= IsNull( sum(IsNull(serviceRdetail.ServicePrice, 0) * 
		(1 - (.01 * serviceRdetail.discperc))) * (1- (.01 * serviceRheader.discperc)) +
	serviceRheader.misccharges - serviceRheader.flatdisc,0),
        custcode=serviceRheader.custcode,
	name=(select accounts.name from accounts where acccode=serviceRheader.custcode)

from     serviceRheader, serviceRdetail

where    serviceRheader.serviceRinvcode = serviceRdetail.serviceRinvcode and
	 serviceRheader.serviceRcatcode = 14 and 
 	 serviceRheader.date < @ad_date  and
	 serviceRheader.posted = 'Y' 

group by serviceRheader.serviceRinvcode,
	 serviceRheader.serviceRcatcode,
         serviceRheader.custcode,
	 serviceRheader.date,
	 serviceRheader.discperc,
	 serviceRheader.misccharges,
	 serviceRheader.flatdisc
/**************************** Any Acccounting Transactions ********************************/

insert #lt_pvamts
select  IsNull( sum(gldetail.debit), 0),
        IsNull( sum(gldetail.credit), 0),
        custcode=gldetail.acccode	,
	name=(select accounts.name from accounts where accounts.acccode=gldetail.acccode)
	 
from     glheader, gldetail  
where    glheader.glvochcode = gldetail.glvochcode and 
 	 glheader.date < @ad_date  and
	 glheader.posted = 'Y' and
         gldetail.acccode IN (select custcode from customer) 
GROUP BY gldetail.acccode	 

/******************************* Any Bills Receivables ***********************************/

insert #lt_pvamts
select  0,
        IsNull( sum(notes.amount), 0),
        custcode=notes.acccode,
        name=(select accounts.name from accounts where accounts.acccode=notes.acccode)
    
	 
from     notes
where    notes.notecatcode = 1 and
	 notes.posted = 'Y' and
	 notes.postdate < @ad_date  and
	 notes.acccode IN (select custcode from customer) 
GROUP BY notes.acccode



/******** Collecting the result and assigning to the relevent reference variable *********/
delete from reportdata
insert into reportdata(code1,name1,value1,value2,value3)
select code,name,IsNull(sum(debit) - sum(credit),0),0,0
	from   #lt_pvamts 
	group by name,
                 code 

insert into reportdata(code1,value1,value2,value3)
select customer.custcode,0,0,0

from  customer

where 
	 customer.custcode Not IN (select code1 from reportdata) 


update 	reportdata
set 	name1=accounts.name
from 	accounts,reportdata
where	reportdata.name1=Null and
	reportdata.code1=accounts.acccode



delete from #lt_pvamts





/*-----------------------------For Transactions Within The Period----------------*/
/*===============================================================================*/


/***************************** Credit Sales Transactions **********************************/

insert #lt_pvamts
select   Debit = Isnull(Round(SUM(saledetail.looseqty * saledetail.unitsalestax) + 
	 SUM(ROUND( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc)) * saledetail.gstperc * .01, 2)) +
	 Round( (sum( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc))) * (1- (.01 * saleledger.discperc)) - saleledger.flatdisc) * (saleledger.invgstperc1 * .01), 2), 0) +
	 Round( sum( (saledetail.looseqty * (saledetail.saleprice - saledetail.itemflatdisc)) *
	    (1 - (.01 * saledetail.discperc))) * (1- (.01 * saleledger.discperc)) + saleledger.misccharges + saleledger.salestax - saleledger.flatdisc, 0), 0),
	 credit = 0.0,
	 custcode=saleledger.custcode,
	 name=(select accounts.name from accounts where acccode=saleledger.custcode)
from     saleledger, saledetail  
where    saleledger.saleinvcode = saledetail.saleinvcode and
	 saleledger.salecatcode = 2   and 
 	 saleledger.date >= @ad_date  and
	 saleledger.date <= @ad_ldate  and
	 saleledger.posted = 'Y' 
	 
group by saleledger.saleinvcode,
	 salecatcode, 
         saleledger.custcode,
	 saleledger.date,
	 saleledger.discperc,
	 saleledger.misccharges,
	 saleledger.salestax,
	 saleledger.invgstperc1,
	 saleledger.flatdisc

/************************** Credit Sales Returns Transactions ******************************/

insert #lt_pvamts
select   Debit = 0.0,
	 Credit = Isnull(Round(SUM(srdetail.looseqty * srdetail.unitsalestax) + 
	 SUM(ROUND( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc)) * srdetail.gstperc * .01, 2)) +
	 Round( (sum( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)) - srledger.flatdisc) * (srledger.invgstperc1 * .01), 2), 0) +
	 Round( sum( (srdetail.looseqty * srdetail.srprice) *
	    (1 - (.01 * srdetail.discperc))) * (1- (.01 * srledger.discperc)) + srledger.misccharges + srledger.salestax - srledger.flatdisc, 0), 0),
         Custcode=srledger.custcode,
	 Name=(select accounts.name from accounts where acccode=srledger.custcode)
from     srledger, srdetail
where    srledger.srinvcode = srdetail.srinvcode and
	 srledger.srcatcode = 7     and 
 	 srledger.date >= @ad_date  and
	 srledger.date <= @ad_ldate  and
	 srledger.posted = 'Y' 	 

group by srledger.srinvcode,
	 srledger.srcatcode,
         srledger.custcode,
	 srledger.date,
	 srledger.discperc,
	 srledger.misccharges,
	 srledger.salestax,
	 srledger.invgstperc1,
	 srledger.flatdisc

/***************************** Credit Services Transactions ********************************/

insert #lt_pvamts

select  debit = IsNull( sum(IsNull(servicedetail.price, 0) * 
	(1 - (.01 * servicedetail.discperc))) * (1- (.01 * serviceheader.discperc)) +
	serviceheader.misccharges - serviceheader.flatdisc,0),
	credit= 0.0,
        custcode=serviceheader.custcode	,
	name=(select accounts.name from accounts where acccode=serviceheader.custcode)
from     serviceheader, servicedetail
where    serviceheader.serviceinvcode = servicedetail.serviceinvcode and
	 serviceheader.servicecatcode = 11     and 
 	 serviceheader.date >= @ad_date  and
   	 serviceheader.date <= @ad_ldate  and
	 serviceheader.posted = 'Y' 
	

group by serviceheader.serviceinvcode,
	 serviceheader.servicecatcode,
         serviceheader.custcode,
	 serviceheader.date,
	 serviceheader.discperc,
	 serviceheader.misccharges,
	 serviceheader.flatdisc

/************************* Credit Services Returns Transactions ***************************/

insert #lt_pvamts

select  debit = 0.0,
	credit= IsNull( sum(IsNull(serviceRdetail.ServicePrice, 0) * 
		(1 - (.01 * serviceRdetail.discperc))) * (1- (.01 * serviceRheader.discperc)) +
	serviceRheader.misccharges - serviceRheader.flatdisc,0),
        custcode=serviceRheader.custcode,
	name=(select accounts.name from accounts where acccode=serviceRheader.custcode)

from     serviceRheader, serviceRdetail

where    serviceRheader.serviceRinvcode = serviceRdetail.serviceRinvcode and
	 serviceRheader.serviceRcatcode = 14 and 
 	 serviceRheader.date >= @ad_date  and
	 serviceRheader.date <= @ad_ldate  and
	 serviceRheader.posted = 'Y' 

group by serviceRheader.serviceRinvcode,
	 serviceRheader.serviceRcatcode,
         serviceRheader.custcode,
	 serviceRheader.date,
	 serviceRheader.discperc,
	 serviceRheader.misccharges,
	 serviceRheader.flatdisc
/**************************** Any Acccounting Transactions ********************************/

insert #lt_pvamts
select  IsNull( sum(gldetail.debit), 0),
        IsNull( sum(gldetail.credit), 0),
        custcode=gldetail.acccode	,
	name=(select accounts.name from accounts where accounts.acccode=gldetail.acccode)
	 
from     glheader, gldetail  
where    glheader.glvochcode = gldetail.glvochcode and 
 	 glheader.date >= @ad_date  and
	 glheader.date <= @ad_ldate  and
	 glheader.posted = 'Y' and
         gldetail.acccode IN (select custcode from customer) 
GROUP BY gldetail.acccode	 

/******************************* Any Bills Receivables ***********************************/

insert #lt_pvamts
select  0,
        IsNull( sum(notes.amount), 0),
        custcode=notes.acccode,
        name=(select accounts.name from accounts where accounts.acccode=notes.acccode)
    
	 
from     notes
where    notes.notecatcode = 1 and
	 notes.posted = 'Y' and
	 notes.postdate >= @ad_date  and
         notes.postdate <= @ad_ldate  and
	 notes.acccode IN (select custcode from customer) 
GROUP BY notes.acccode



/******** Collecting the result and assigning to the relevent reference variable *********/


update reportdata

set value2=A.ddebit,value3=A.dcredit

from

(select code,name,ddebit=IsNull(sum(debit) ,0),dcredit=IsNull(sum(credit),0)
	from   #lt_pvamts 
	group by name,
                 code) as A

where reportdata.code1=A.code
 
drop table #lt_pvamts




