USE msdb;
GO
DECLARE @dbname sysname = N'FazalDinPP19DataBaseV2';
BEGIN TRANSACTION            

  DECLARE @JobID BINARY(16)  

  DECLARE @ReturnCode INT    

  SELECT @ReturnCode = 0     

IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'[Uncategorized (Local)]') < 1 

  EXECUTE msdb.dbo.sp_add_category @name = N'[Uncategorized (Local)]'


  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     

  FROM   msdb.dbo.sysjobs    

  WHERE (name = N'AutoDataMigration')

  IF (@JobID IS NOT NULL)    

  BEGIN  

  -- Check if the job is a multi-server job  

  IF (EXISTS (SELECT  * 

              FROM    msdb.dbo.sysjobservers 

              WHERE   (job_id = @JobID) AND (server_id <> 0))) 

  BEGIN 

    -- There is, so abort the script 

    RAISERROR (N'Unable to import job ''AutoDataMigration'' since there is already a multi-server job with this name.', 16, 1) 

    GOTO QuitWithRollback  

  END 

  ELSE 

    -- Delete the [local] job 

    EXECUTE msdb.dbo.sp_delete_job @job_name = N'AutoDataMigration' 

    SELECT @JobID = NULL

  END 



BEGIN 


  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'AutoDataMigration', @owner_login_name = N'sa', @description = N'Automatically Purge Posted Sales.', @category_name = N'[Uncategorized (Local)]', @enabled = 0, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @
ALTER PROCEDURE sp_GenerateSale_From_PreSales

	@PreSaleInvCode INT,

	@UserCode SMALLINT,

	@NewSaleInvCode INT OUTPUT

AS



Declare @module Int, @headerinvno Int, @continue Int, @rt_code Int, @Err Int, @totalrows Int, @rowcount Int, @counter Int

Declare @SaleInvCode Int, @HeaderInvCode INT

Declare @saleprice Numeric(12,2), @rate Numeric(12,2), @discperc Numeric(5,2), @itemflatdisc Numeric(15,2), @unitsalestax Numeric(12,2), @gstperc1 Numeric(6,2), @gstperc2 Numeric(6,2), @hold_avgprice Numeric(15,5)

Declare @icode Int, @gcode int, @packunits Int

Declare @totalstock NUMERIC(15, 4), @totalqty NUMERIC(15, 4), @looseQty NUMERIC(15, 4), @BonusQty NUMERIC(15, 4), @totalbatchqty NUMERIC(15, 4), @delqty NUMERIC(15, 4), @currqty NUMERIC(15, 4), @newqty NUMERIC(15, 4), @balancestock NUMERIC(15, 4)

Declare @batch VarChar(100), @itemname VarChar(60), @expiry DateTime, @serverdate DateTime

Declare @saleutn BigInt, @custcode SMALLINT, @itemdescription VARCHAR(100)

DECLARE @Headerno INT, @MachineName VARCHAR(100)

Declare @rowgroup Int, @innercounter Int



Set @custcode = ISNULL((SELECT Custcode FROM PreSaleHeader WHERE PreSaleInvCode=@presaleinvcode), 19)

SET @Headerno = 1

Set @module = ( Select module from module where name = 'Sales' )

Set @serverdate = GETDATE()

SET @MachineName = LEFT(@@ServerName, 15)



Create Table #saletemp ( id int not null identity(1,1), icode Int , gcode smallint, batch varchar(100), expiry datetime, looseqty Int, bonusqty Int, SalePrice  Numeric(12,2), DiscPerc Numeric(8,2), ItemFlatDisc Numeric(12,2), UnitSalesTax Numeric(12,2), GstPerc Numeric(6,2), itemdescription varchar(100) )

Insert Into #saletemp ( icode, gcode, batch, expiry, looseqty, bonusqty , saleprice, discperc, itemflatdisc, unitsalestax, gstperc , itemdescription )

Select icode, gcode, batch, expiry, qty, 0, saleprice, discperc, itemflatdisc=0, unitsalestax=0, gstperc=0, itemdescription

From PreSaleDetail

Where PreSaleInvCode = @PreSaleInvCode AND (Qty + BonusQty) > 0

Order By rowid



Set @totalrows = 
oseqty + @bonusqty

				IF @totalqty > 0 AND @RowCount > 0 AND @Err = 0

				Begin

					Execute @rt_code = sp_GetItemAvgPrice @icode, @hold_avgprice OutPut

					IF @@Error <> 0 OR @rt_code <> 0

					Begin

						Set @continue = -1

					End

					ELSE

					Begin

						Set @totalstock = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode  )

						Set @totalbatchqty = (Select IsNull(Sum(currqty),0) From godowndetail where godowndetail.gcode = @gcode and godowndetail.icode = @icode and godowndetail.Batch = @batch and godowndetail.Expiry = @expiry)

						IF @totalbatchqty >= @totalqty

						Begin 

							Set @newqty = @totalbatchqty - @totalqty

							IF @newqty > 0

								Execute @rt_code = sp_SaleUpdateItemStockBatch @gcode, @icode, @batch, @expiry, @newqty , @totalbatchqty

							Else

								Execute @rt_code = sp_DeleteItemStockBatch @gcode, @icode, @batch, @expiry, @totalqty

	

							IF @@Error <> 0 OR @rt_code <> 0 

							Begin

								Set @continue  = -1								

							End

							ELSE

							BEGIN

								Set @rowgroup = @rowgroup + 1

								Select @rate = saleprice, @packunits = packunits

								From ITEM

								Where icode = @icode

			

								IF @packunits = 0 OR @packunits Is Null 

									Set @packunits = 1

		

								Execute @rt_code = sp_maxutn 1, @saleutn Output

								IF @@Error <> 0 OR @rt_code <> 0

								Begin

									Set @continue  = -1															

								End

								ELSE

								BEGIN

									Insert Into SaleDetail (SaleInvCode, icode, gcode, batch, expiry, packqty, looseqty, bonusqty, packunits, saleprice, avgprice, rate, discperc, salestax, itemflatdisc, packprice, unitsalestax, gstperc, saleutn, balancestock, rowgroup)

									Values (@saleinvcode, @icode, @gcode, @batch, @expiry, 0, @looseqty, @bonusqty, @packunits, @saleprice, @hold_avgprice, @rate / @packunits, @discperc, 0, @itemflatdisc, @rate, @unitsalestax, @gstperc1, @saleutn, 0, @rowgroup)

									Select @Er
r = @@Error, @RowCount = @@RowCount

									IF @Err <> 0 OR @RowCount = 0 

									Begin 

										RaisError( 'Error occured in inserting record into Sale Detail for Sale Inv. No. : %d' ,16,1, @SaleInvCode  )

										Set @continue  = -1

									End

								END

							END
						END

						ELSE

						Begin

							Set @itemname = (Select name from item where icode = @icode )	

							RaisError( 'Not enough stock for item (%s) to decrease for Sale Inv. No : %d' , 16 , 1, @itemname, @SaleInvCode  )

							Set @continue  = -1								

						End

					END

				End

				Set @innercounter = @innercounter + 1

			End



			IF ( @continue >= 0 ) and @innercounter > @totalrows

			Begin

				Update Saleledger 

				Set InvTotal = ISNULL(dbo.fn_getSaleInvTotal (Saleledger.saleinvcode), 0), OutStandingAmt=ISNULL(dbo.fn_getSaleInvTotal (Saleledger.saleinvcode), 0)

				Where saleinvcode = @saleinvcode

			

				Select @Err = @@Error, @Rowcount = @@RowCount

				IF  @Err <> 0 OR @RowCount = 0

				Begin

					RaisError( 'Unable to update Sale Inv. total for Sale Invoice %d' , @saleinvcode, 16 , 1 )

					Set @continue  = -1									

				End

			

				IF ( @continue >= 0 )

				BEGIN

					Update PreSaleHeader 

					SET Posted = 'Y', POSTDATE=GETDATE(), PostedBy = @UserCode, SaleInvCode=@SaleInvCode

					WHERE PreSaleInvCode = @PreSaleInvCode

			

					Select @Err = @@Error, @Rowcount = @@RowCount

					IF  @Err <> 0 OR @RowCount = 0

					BEGIN 

						RaisError( 'Unable to update Sale Order Status (Inv. No. %d)' , @PreSaleInvCode, 16 , 1 )

						Set @continue  = -1									

					END

				END

			

			End

		End

	End

End



Drop Table #saletemp



Return @continue
CREATE PROCEDURE DBO.SP_CopySBufferToSales

As    

DECLARE @errorno int, @rowsaffected int, @inv_posted_age INT



BEGIN TRANSACTION MyTrans



Insert Into SaleLedger With (TabLockX) 

	(SaleInvCode, SaleCatCode, CustCode, SalesmanCode, Date, DiscPerc, FlatDisc, MiscCHARges,

	SalesTax, Posted, PostDate, Remarks, CustRefNo, headerno, headerinvno, OriginalDate, ModifiedBy,

	PostedBy, SPrice, QuotationNo, DoctCode, PatientCode, RePrINTingCounter, CashReceived, InvGSTPerc1,

	PrINTWaranty, PrINTBatch, MessageCode, SManCode, InvoiceSize, CustRefno2, CustRefno3, CustRefno4,

	GSTNO, InvTotal, MachineName, ModifyCounter, ItemDiscPercNo, RelationCode, DiseaseCode, WardCode,

	AdmissionCode, ReturnCounter, Paid, BillingDate, UnReceivedBalance, TotalOfSaleReturns, ListOfSrInvoices,

	prINTbalance, AccountFor, PaymentMode, PaymentAccCode, Amt, AmtBY, AmtDate, AmtReference, OutstandingAmt,

	Marked, Transferable, Transfered, TransferedOn, TransferedBy, Imported, ImportedBy, deliveredby, SaleTypeCode,

	Balance, PptCustCode, DELETED, PresCode, ImpactInventory,  SaleOrderCode, SaleComments1, SaleComments2,

	AlterSaleInvCode, RecurringInvoice, RecurringPeriod, LastRecurringInvCode, RecurringAgainst, ConsiderInPO,

	VisitCode, DueDate, SRBufferInvCode, CustRefNo5, GCCode, GRN, SuppInvCode, Vehicle, ShipTo, GuaranteePersonCode,

	CashTendered, CashCHARged, CashBack, CashAccCode, CustLicNo, CustLicExpiry, ModuleId, DocCode, SaleTypeInvNo,

	CRS_Transfered, CRS_TransferedOn, GuestCode, GuestCheckInCode, StudentCode, CustSiteCode, Transmit, Transmited,

	CurrencyCode, ConversionRate, ShipToCustomer,

	PreviousReading, CurrentReading, NextChange, Synced, SyncedOn, SyncedBy,

	MiscCharges1, MiscCharges2, MiscCharges3, MiscCharges4, MiscCharges5) 

Select  

	SaleInvCode, SaleCatCode, CustCode, SalesmanCode, Date, DiscPerc, FlatDisc, MiscCHARges,

	SalesTax, Posted, PostDate, Remarks, CustRefNo, headerno, headerinvno, OriginalDate, ModifiedBy,

	PostedBy, SPrice, QuotationNo, DoctCode, PatientCode, RePrINTingCounter, Ca
notify_level_eventlog = 0, @delete_level= 0

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'AutoDataMigration_Step-1', @command = N'EXEC SP_AutoDataMigration', @database_name = @dbname , @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 



  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'AutoDataMigration_Schedule', @enabled = 1, @freq_type = 4, @active_start_date = 20121113, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 



  -- Add the Target Servers
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 



END

COMMIT TRANSACTION          

GOTO   EndSave              

QuitWithRollback:

  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 

EndSave:
GO
