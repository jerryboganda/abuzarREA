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
