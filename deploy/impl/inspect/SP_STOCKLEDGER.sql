/* Aquire Table Level Exclusive Lock so that no other user can make read/write operation during the transaction */
SELECT COUNT(*) FROM STOCKLEDGER WITH (TABLOCKX)

/* INSERT Purchases into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=pl.purinvcode,  
	date=pl.postdate,
	documenttype='PV',
	pd.icode,
	pd.gcode,
	pd.batch,
	pd.expiry,
	qty = isnull(case pl.purcatcode 
			when 1 THEN packqty * packunits
			when 2 THEN packqty * packunits
			else looseqty
			end, 0),
	bonus = isnull(case pl.purcatcode 
			when 1 THEN bonusqty * packunits
			when 2 THEN bonusqty * packunits
			else bonusqty
			end, 0),
	pd.packunits, 
	rate=pd.purprice, 
	pd.discperc, 
	invdiscperc=pl.discperc, 
	stock=isnull(pd.currstock, 0),
	avgprice=isnull(pd.avgprice, 0),
	newstock = isnull(pd.currstock, 0) +
		isnull(case pl.purcatcode 
			when 1 THEN packqty * packunits
			when 2 THEN packqty * packunits
			else looseqty
			end, 0) + isnull(case pl.purcatcode 
			when 1 THEN bonusqty * packunits
			when 2 THEN bonusqty * packunits
			else bonusqty
			end, 0),
	newavgprice=isnull(pd.newavgprice, 0),
	utn=pd.purutn,
	due=NULL
FROM purledger pl, purdetail pd
WHERE pl.posted = 'Y' AND pl.purinvcode = pd.purinvcode and
	NOT EXISTS (select purutn=st.utn from stockledger st where st.documenttype='PV' and pd.purutn=st.utn)

/* INSERT Purchase Returns into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=pl.prinvcode,  
	date=pl.date,
	documenttype='PR',
	pd.icode,
	pd.gcode,
	pd.batch,
	pd.expiry, 
	qty = pd.looseqty + pd.packqty * pd.packunits,
	bonus = pd.bonusqty,
	pd.packunits, 
	rate=pd.prprice, 
	pd.discperc, 
	invdiscperc=pl.discperc, 
	stock=isnull(pd.balancestock + (pd.looseqty + bonusqty) + (pd.packqty * pd.packunits), 0),
	avgprice=isnull(pd.avgprice, 0),
	newstock = isnull(pd.balancestock, 0),
	newavgprice=isnull(pd.avgprice, 0),
	utn=pd.prutn,
	due=NULL
FROM prledger pl, prdetail pd
WHERE pl.posted = 'Y' AND pl.prinvcode = pd.prinvcode and
	NOT EXISTS (select prutn=st.utn from stockledger st where st.documenttype='PR' and pd.prutn = st.utn)

/* Insert sales into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=sl.saleinvcode, 
	date = sl.date,
	documenttype='SV',
	sd.icode,
	sd.gcode,
	sd.batch,
	sd.expiry, 
	qty = sd.looseqty + (sd.packqty * sd.packunits),
	bonus = sd.bonusqty,
	sd.packunits, 
	rate=sd.saleprice, 
	discperc=sd.discperc, 
	invdiscperc=sl.discperc, 
	stock=ISNULL(CASE WHEN sd.due IS null THEN sd.balancestock + sd.looseqty + sd.bonusqty ELSE sd.balancestock END,0),
	sd.avgprice,
	newstock=isnull(sd.balancestock,0),
	newavgprice=sd.avgprice,
	utn=sd.saleutn,
	due=sd.due
FROM saleledger sl, saledetail sd
WHERE sl.posted = 'Y' AND sl.saleinvcode = sd.saleinvcode and
	NOT EXISTS (select saleutn=st.utn from stockledger st where st.documenttype='SV' and sd.saleutn = st.utn)

/* Insert sales return into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=sl.srinvcode, 
	date = sl.postdate,
	documenttype='SR',
	sd.icode,
	sd.gcode,
	sd.batch,
	sd.expiry, 
	qty = sd.looseqty + sd.packqty * sd.packunits,
	bonus = sd.bonusqty,
	sd.packunits, 
	rate=sd.srprice, 
	discperc=sd.discperc, 
	invdiscperc=sl.discperc, 
	stock=ISNULL(sd.currstock, 0),
	sd.avgprice,
	newstock=isnull(sd.currstock + sd.looseqty + sd.bonusqty + (sd.packqty * sd.packunits),0),
	newavgprice=sd.newavgprice,
	utn=sd.srutn,
	due=NULL
FROM srledger sl, srdetail sd
WHERE sl.posted = 'Y' AND sl.srinvcode = sd.srinvcode and
	NOT EXISTS (select srutn=st.utn from stockledger st where st.documenttype='SR' AND sd.srutn = st.utn)

/* Insert receipts into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=rh.receiptinvcode, 
	date = rh.postdate,
	documenttype='RV',
	rd.icode,
	rd.gcode,
	rd.batch,
	rd.expiry, 
	qty = rd.qty,
	bonus = 0,
	rd.packunits, 
	rate=rd.price, 
	discperc=0, 
	invdiscperc=0, 
	stock=ISNULL(rd.currstock, 0),
	avgprice=rd.avgprice,
	newstock=isnull(rd.currstock + rd.qty,0),
	newavgprice=rd.newavgprice,
	utn=rd.receiptutn,
	due=NULL
FROM receiptheader rh, receiptdetail rd
WHERE rh.posted = 'Y' AND rh.receiptinvcode = rd.receiptinvcode and
	 NOT EXISTS (select receiptutn=st.utn from stockledger st where st.documenttype='RV' and rd.receiptutn=st.utn)

/* Insert Issue into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=ih.issueinvcode, 
	date = ih.date,
	documenttype='IV',
	isd.icode,
	isd.gcode,
	isd.batch,
	isd.expiry, 
	qty = isd.qty,
	bonus = 0,
	isd.packunits, 
	rate=isd.saleprice, 
	discperc=0, 
	invdiscperc=0, 
	stock= isnull(isd.balancestock + isd.qty, 0),
	avgprice=isd.avgprice,
	newstock=isnull(isd.balancestock,0),
	newavgprice=isd.avgprice,
	utn=isd.issueutn,
	due=NULL
FROM issueheader ih, issuedetail isd
WHERE ih.posted = 'Y' AND ih.issueinvcode = isd.issueinvcode and
	NOT EXISTS (select issueutn=st.utn from stockledger st where st.documenttype='IV' and isd.issueutn=st.utn)

/* Insert Adjustment Increase into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=ah.adjcode, 
	date = ah.posteddate,
	documenttype='AI',
	ad.icode,
	ad.gcode,
	ad.batch,
	ad.expiry, 
	qty = ad.looseqty,
	bonus = 0,
	ad.packunits, 
	rate=ad.price, 
	discperc=0, 
	invdiscperc=0, 
	stock= ISNULL(ad.currstock, 0),
	avgprice=ad.avgprice,
	newstock=isnull(ad.currstock + ad.looseqty,0),
	newavgprice=ad.newavgprice,
	utn=ad.adjutn,
	due=NULL
FROM adjheader ah, adjdetail ad
WHERE ah.adjcatcode = 1 and ah.posted = 'Y' AND ah.adjcode = ad.adjcode and
	NOT EXISTS (select adjutn=st.utn from stockledger st where st.documenttype='AI' AND ad.adjutn=st.utn)

/* Insert Adjustment Decrease into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=ah.adjcode, 
	date = ah.posteddate,
	documenttype='AD',
	ad.icode,
	ad.gcode,
	ad.batch,
	ad.expiry, 
	qty = ad.looseqty,
	bonus = 0,
	ad.packunits, 
	rate=ad.price, 
	discperc=0, 
	invdiscperc=0, 
	stock= ISNULL(ad.currstock, 0),
	avgprice=ad.avgprice,
	newstock=isnull(ad.currstock - ad.looseqty,0),
	newavgprice=ad.avgprice,
	utn=ad.adjutn,
	due=NULL
FROM adjheader ah, adjdetail ad
WHERE ah.adjcatcode = 2 and ah.posted = 'Y' AND ah.adjcode = ad.adjcode and
	NOT EXISTS (select adjutn=st.utn from stockledger st where st.documenttype='AD' AND ad.adjutn=st.utn)

/* Insert Due Satisfied into stock ledger table */
INSERT INTO STOCKLEDGER (documentcode, date, documenttype, icode, gcode, batch, expiry, qty,
	bonus, packunits, rate, discperc, invdiscperc, stock, avgprice, newstock, newavgprice, utn, due)
select  documentcode=dh.duesatisfycode, 
	date = dh.duesatisfydate,
	documenttype='DS',
	dsd.icode,
	dsd.gcode,
	dsd.batch,
	dsd.expiry, 
	qty = dsd.duesatisfyqty,
	bonus = 0,
	packunits=1, 
	rate=0, 
	discperc=0, 
	invdiscperc=0, 
	stock= ISNULL(dsd.balancestock + dsd.duesatisfyqty, 0),
	avgprice=dsd.avgprice,
	newstock=isnull(dsd.balancestock, 0),
	newavgprice=dsd.avgprice,
	utn=dsd.duesatisfyutn,
	due=NULL
FROM duesatisfyheader dh, duesatisfydetail dsd
WHERE dh.duesatisfycode = dsd.duesatisfycode and
	NOT EXISTS (select duesatisfyutn=st.utn from stockledger st where st.documenttype='DS' and dsd.duesatisfyutn=st.utn)
