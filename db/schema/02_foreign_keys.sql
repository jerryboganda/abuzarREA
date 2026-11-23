-- Reconstructed from the SQL Server 2000-format V2 database file (catalog pages), schema only

ALTER TABLE [dbo].[ABD_US] ADD CONSTRAINT [FK_ABD_US_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ABD_US] ADD CONSTRAINT [FK_ABD_US_Visit_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[ABD_US] ADD CONSTRAINT [FK_ABD_US_PatientAdmission_VisitCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[AccountGodown] ADD CONSTRAINT [FK_Accounts_AccountGodown_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AccountGodown] ADD CONSTRAINT [FK_Godown_AccountGodown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [AccSubCodeFK] FOREIGN KEY ([SubCode]) REFERENCES [dbo].[SubAccounts] ([SubAccCode]);
GO
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [FK_Alert_Accounts_AlertCode] FOREIGN KEY ([AlertCode]) REFERENCES [dbo].[Alert] ([AlertCode]);
GO
ALTER TABLE [dbo].[AdjBufferDetail] ADD CONSTRAINT [FK_AdjBufferDetail_AdjBufferHeader] FOREIGN KEY ([AdjBufferCode]) REFERENCES [dbo].[AdjBufferHeader] ([AdjBufferCode]);
GO
ALTER TABLE [dbo].[AdjBufferDetail] ADD CONSTRAINT [FK_AdjBufferDetail_Item] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_Godown] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_Users] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_AdjHeader_AdjIncCode] FOREIGN KEY ([AdjIncCode]) REFERENCES [dbo].[AdjHeader] ([AdjCode]);
GO
ALTER TABLE [dbo].[AdjBufferHeader] ADD CONSTRAINT [FK_AdjBufferHeader_AdjHeader_AdjDecCode] FOREIGN KEY ([AdjDecCode]) REFERENCES [dbo].[AdjHeader] ([AdjCode]);
GO
ALTER TABLE [dbo].[AdjHeader] ADD CONSTRAINT [PK_Accounts_AdjHeader_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AdjHeader] ADD CONSTRAINT [ADCatCodeFK] FOREIGN KEY ([AdjCatCode]) REFERENCES [dbo].[AdjCategory] ([AdjCatCode]);
GO
ALTER TABLE [dbo].[AdmittedPatientRecurringServices] ADD CONSTRAINT [FK_SalesMan_AdmittedPatientRecurringServices_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_IncomeTaxRule_AdvPurDetail_UnitIncomeTaxRuleCode] FOREIGN KEY ([UnitIncomeTaxRuleCode]) REFERENCES [dbo].[IncomeTaxRule] ([IncomeTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_IncomeTaxRule_AdvPurDetail_PercIncomeTaxRuleCode] FOREIGN KEY ([PercIncomeTaxRuleCode]) REFERENCES [dbo].[IncomeTaxRule] ([IncomeTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_AdditionalTaxRule_AdvPurDetail_UnitAdditionalTaxRuleCode] FOREIGN KEY ([UnitAdditionalTaxRuleCode]) REFERENCES [dbo].[AdditionalTaxRule] ([AdditionalTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_AdditionalTaxRule_AdvPurDetail_PercAdditionalTaxRuleCode] FOREIGN KEY ([PercAdditionalTaxRuleCode]) REFERENCES [dbo].[AdditionalTaxRule] ([AdditionalTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_ExtraTaxRule_AdvPurDetail_UnitExtraTaxRuleCode] FOREIGN KEY ([UnitExtraTaxRuleCode]) REFERENCES [dbo].[ExtraTaxRule] ([ExtraTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_ExtraTaxRule_AdvPurDetail_PercExtraTaxRuleCode] FOREIGN KEY ([PercExtraTaxRuleCode]) REFERENCES [dbo].[ExtraTaxRule] ([ExtraTaxRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_CustomDutyRule_AdvPurDetail_UnitCustomDutyRuleCode] FOREIGN KEY ([UnitCustomDutyRuleCode]) REFERENCES [dbo].[CustomDutyRule] ([CustomDutyRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_CustomDutyRule_AdvPurDetail_PercCustomDutyRuleCode] FOREIGN KEY ([PercCustomDutyRuleCode]) REFERENCES [dbo].[CustomDutyRule] ([CustomDutyRuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_AdvPurHeader_AdvPurDetail_AdvPurInvCode] FOREIGN KEY ([AdvPurInvCode]) REFERENCES [dbo].[AdvPurHeader] ([AdvPurInvCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_Item_AdvPurDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_Godown_AdvPurDetail_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_UnitSalesTaxRules_AdvPurDetail_UnitTaxRuleCode] FOREIGN KEY ([UnitTaxRuleCode]) REFERENCES [dbo].[UnitSalesTaxRules] ([RuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_GSTRules_AdvPurDetail_GSTRuleCode] FOREIGN KEY ([GSTRuleCode]) REFERENCES [dbo].[GSTRules] ([RuleCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_MeasuringUnit_AdvPurDetail_MeasureUnitCode] FOREIGN KEY ([MeasureUnitCode]) REFERENCES [dbo].[MeasuringUnit] ([MeasureUnitCode]);
GO
ALTER TABLE [dbo].[AdvPurDetail] ADD CONSTRAINT [FK_GSTTYpe_AdvPurDetail_GSTTYpeCode] FOREIGN KEY ([GSTTYpeCode]) REFERENCES [dbo].[GSTType] ([GSTTypeCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Currency_AdvPurHeader_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_PurchaseType_AdvPurHeader_PurTypeCode] FOREIGN KEY ([PurTypeCode]) REFERENCES [dbo].[PurchaseType] ([PurTypeCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Accounts_AdvPurHeader_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Users_AdvPurHeader_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_PurCategory_AdvPurHeader_PurCatCode] FOREIGN KEY ([PurCatCode]) REFERENCES [dbo].[PurCategory] ([PurCatCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Supplier_AdvPurHeader_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Users_AdvPurHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Users_AdvPurHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvPurHeader] ADD CONSTRAINT [FK_Users_AdvPurHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvSaleDetail] ADD CONSTRAINT [FK_AdvSaleDetail_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AdvSaleDetail] ADD CONSTRAINT [FK_AdvSaleLedger_AdvSaleDetail_AdvSaleInvcode] FOREIGN KEY ([AdvSaleInvcode]) REFERENCES [dbo].[AdvSaleLedger] ([AdvSaleInvCode]);
GO
ALTER TABLE [dbo].[AdvSaleDetail] ADD CONSTRAINT [FK_Item_AdvSaleDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AdvSaleDetail] ADD CONSTRAINT [FK_Godown_AdvSaleDetail_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_SaleCategory_AdvSaleLedger_SaleCatCode] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Customer_AdvSaleLedger_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Users_AdvSaleLedger_SalesManCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Users_AdvSaleLedger_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Users_AdvSaleLedger_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Doctors_AdvSaleLedger_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Patient_AdvSaleLedger_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Customer_AdvSaleLedger_Credit1AccCode] FOREIGN KEY ([Credit1AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Customer_AdvSaleLedger_Credit2AccCode] FOREIGN KEY ([Credit2AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Customer_AdvSaleLedger_Credit3AccCode] FOREIGN KEY ([Credit3AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Message_AdvSaleLedger_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_SalesMan_AdvSaleLedger_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Relation_AdvSaleLedger_RelationCode] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Disease_AdvSaleLedger_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Ward_AdvSaleLedger_WardCode] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Accounts_AdvSaleLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_Users_AdvSaleLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AdvSaleLedger] ADD CONSTRAINT [FK_SaleType_AdvSaleLedger] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[AgingIntervalDetail] ADD CONSTRAINT [FK_AgingIntervalDetail] FOREIGN KEY ([AgingIntervalCode]) REFERENCES [dbo].[AgingInterval] ([AgingIntervalCode]);
GO
ALTER TABLE [dbo].[Alert] ADD CONSTRAINT [FK_AlertType_Altert_AlertTypeCode] FOREIGN KEY ([AlertTypeCode]) REFERENCES [dbo].[AlertType] ([AlertTypeCode]);
GO
ALTER TABLE [dbo].[AlternateItemAlias] ADD CONSTRAINT [FK_Item_AlternateItemAlias_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AlternateItemAliasRequest] ADD CONSTRAINT [FK_ItemRegRequest_AlternateItemAliasRequest_ItemRegReqCode] FOREIGN KEY ([ItemRegReqCode]) REFERENCES [dbo].[ItemRegRequest] ([ItemRegReqCode]);
GO
ALTER TABLE [dbo].[AppVersionDetail] ADD CONSTRAINT [FK_AppVersionDetail_AppVersion] FOREIGN KEY ([AppVersion]) REFERENCES [dbo].[AppVersion] ([AppVersion]);
GO
ALTER TABLE [dbo].[Area] ADD CONSTRAINT [AreaRegionCodeFK] FOREIGN KEY ([RegionCode]) REFERENCES [dbo].[Region] ([RegionCode]);
GO
ALTER TABLE [dbo].[AssocAdvSaleInvList] ADD CONSTRAINT [FK_AdvSaleLedger_AssocAdvSaleInvList_AdvSaleInvCode] FOREIGN KEY ([AdvSaleInvCode]) REFERENCES [dbo].[AdvSaleLedger] ([AdvSaleInvCode]);
GO
ALTER TABLE [dbo].[AssocAdvSaleInvList] ADD CONSTRAINT [FK_SaleLedger_AssocAdvSaleInvList_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[AssociatedItemPart] ADD CONSTRAINT [FK_ItemPart_AssociatedItemPart_IPartCode] FOREIGN KEY ([IPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[AssociatedItemPart] ADD CONSTRAINT [FK_ItemPart_AssociatedItemPart_AssociatedIPartCode] FOREIGN KEY ([AssociatedIPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[AssocSaleInvList] ADD CONSTRAINT [FK_SaleLedger_AssocSaleInvList_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[AssocSaleInvList] ADD CONSTRAINT [FK_SaleLedger_AssocSaleInvList_AssocSaleInvCode] FOREIGN KEY ([AssocSaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[AutoSaleLog] ADD CONSTRAINT [FK_SaleTemplateHeader_AutoSaleLog] FOREIGN KEY ([SaleTemplateCode]) REFERENCES [dbo].[SaleTemplateHeader] ([SaleTemplateCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjDetail] ADD CONSTRAINT [FK_Item_AvgPriceAdjDetail_DocumentCode] FOREIGN KEY ([DocumentCode]) REFERENCES [dbo].[AvgPriceAdjHeader] ([DocumentCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjDetail] ADD CONSTRAINT [FK_Item_AvgPriceAdjDetail_ICode] FOREIGN KEY ([ICODE]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjHeader] ADD CONSTRAINT [FK_Users_AvgPriceAdjHeader_UserCode] FOREIGN KEY ([USERCODE]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjHeader] ADD CONSTRAINT [FK_Users_AvgPriceAdjHeader_PostedBy] FOREIGN KEY ([POSTEDBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjHeader] ADD CONSTRAINT [FK_Accounts_AvgPriceAdjHeader_Dr_AccCode] FOREIGN KEY ([DR_ACCCODE]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjHeader] ADD CONSTRAINT [FK_Accounts_AvgPriceAdjHeader_Cr_AccCode] FOREIGN KEY ([CR_ACCCODE]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[AvgPriceAdjHeader] ADD CONSTRAINT [FK_GLHeader_AvgPriceAdjHeader_GLVochCode] FOREIGN KEY ([GLVOCHCODE]) REFERENCES [dbo].[Glheader] ([GLVochCode]);
GO
ALTER TABLE [dbo].[BillSummary] ADD CONSTRAINT [FK_Users_BillSummary_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[BillSummary] ADD CONSTRAINT [FK_Users_BillSummary_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[BillSummary] ADD CONSTRAINT [FK_Users_BillSummary_FinalizedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[BillSummary] ADD CONSTRAINT [FK_BillSummaryType_BillSummary_BillSummaryTypeCode] FOREIGN KEY ([BillSummaryTypeCode]) REFERENCES [dbo].[BillSummaryType] ([BillSummaryTypeCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_BillSummary_BillSummaryDetail_BillSummaryCode] FOREIGN KEY ([BillSummaryCode]) REFERENCES [dbo].[BillSummary] ([BillSummaryCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_Customer_BillSummaryDetail_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_SaleLedger_BillSummaryDetail_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_Accounts_BillSummaryDetail_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_Accounts_BillSummaryDetail_BankAccCode] FOREIGN KEY ([BankAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_Accounts_BillSummaryDetail_DebitNoteAccCode] FOREIGN KEY ([DebitNoteAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_Accounts_BillSummaryDetail_CreditNoteAccCode] FOREIGN KEY ([CreditNoteAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[BillSummaryDetail] ADD CONSTRAINT [FK_SRBufferLedger_BillSummaryDetail_SRBufferInvCode] FOREIGN KEY ([SRBufferInvCode]) REFERENCES [dbo].[SRBufferLedger] ([SRBufferInvCode]);
GO
ALTER TABLE [dbo].[BirthCertificate] ADD CONSTRAINT [FK_BirthCertificate_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[BirthCertificate] ADD CONSTRAINT [FK_BirthCertificate_Visit_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[BirthCertificate] ADD CONSTRAINT [FK_BirthCertificate_PatientAdmission_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[BirthCertificate] ADD CONSTRAINT [FK_BirthCertificate_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[BonusPolicyDetail] ADD CONSTRAINT [FK_BonusPolicyDetail_BonusPolicyCode] FOREIGN KEY ([BonusPolicyCode]) REFERENCES [dbo].[BonusPolicy] ([BonusPolicyCode]);
GO
ALTER TABLE [dbo].[CABG] ADD CONSTRAINT [FK_Users_CABG_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CABG] ADD CONSTRAINT [FK_Users_CABG_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[CABG] ADD CONSTRAINT [FK_Patient_CABG_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[CABG] ADD CONSTRAINT [FK_PatientAdmission_CABG_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[CashAccAllowedModule] ADD CONSTRAINT [FK_Module_CashAccAllowedModule_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[CashierActivity] ADD CONSTRAINT [FK_Users_CashierActivity_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierActivity] ADD CONSTRAINT [FK_Accounts_CashierActivity_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CashierActivity] ADD CONSTRAINT [FK_CashierJob_CashierActivity_CashierJobCode] FOREIGN KEY ([CashierJobCode]) REFERENCES [dbo].[CashierJob] ([CashierJobCode]);
GO
ALTER TABLE [dbo].[CashierJob] ADD CONSTRAINT [FK_Users_CashierJob_JobOwner] FOREIGN KEY ([JobOwner]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierJob] ADD CONSTRAINT [FK_Users_CashierJob_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierJobModule] ADD CONSTRAINT [FK_CashierJob_CashierJobModule_CashierJobCode] FOREIGN KEY ([CashierJobCode]) REFERENCES [dbo].[CashierJob] ([CashierJobCode]);
GO
ALTER TABLE [dbo].[CashierJobModule] ADD CONSTRAINT [FK_CashierJob_CashierJobModule_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [FK_CashierShift_Accounts_DiffTransferedTo] FOREIGN KEY ([DiffTransferedTo]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [DF_CashierShift_ClosedBy] FOREIGN KEY ([ClosedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [FK_CashierShift_Users_OpenedBy] FOREIGN KEY ([OpenedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [FK_CashierShift_Users_ShiftOwner] FOREIGN KEY ([ShiftOwner]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [FK_CashierShift_Accounts_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CashierShift] ADD CONSTRAINT [FK_CashierShift_Accounts_AmtTransferedTo] FOREIGN KEY ([AmtTransferedTo]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CashierShiftCashCount] ADD CONSTRAINT [FK_CashierShiftCashCount_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[CashierShiftCashCount] ADD CONSTRAINT [FK_CashierShiftCashCount_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[CashierShiftUsers] ADD CONSTRAINT [FK_CashierShiftUsers_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[CashierShiftUsers] ADD CONSTRAINT [FK_CashierShiftUsers_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CashierTemplate] ADD CONSTRAINT [FK_SaleInterface_CashierTemplate_InterfaceCode] FOREIGN KEY ([InterfaceCode]) REFERENCES [dbo].[SaleInterface] ([InterfaceCode]);
GO
ALTER TABLE [dbo].[CashierTemplate] ADD CONSTRAINT [FK_Accounts_CashierTemplate_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CashierWindow] ADD CONSTRAINT [FK_SaleLedger_CashierWindow_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[CashierWindow] ADD CONSTRAINT [FK_Accounts_CashierWindow_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[CategoryAccounts] ADD CONSTRAINT [CAMainAccCodeFK] FOREIGN KEY ([MainAccCode]) REFERENCES [dbo].[MainAccounts] ([MainAccCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_Class_Grade_GradeCode] FOREIGN KEY ([GradeCode]) REFERENCES [dbo].[Grade] ([GradeCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_Service_Class_ServiceForTuitionFee] FOREIGN KEY ([ServiceForTuitionFee]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_ClassType_Class] FOREIGN KEY ([ClassTypeCode]) REFERENCES [dbo].[ClassType] ([ClassTypeCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_ClassMedium_Class] FOREIGN KEY ([ClassMediumCode]) REFERENCES [dbo].[ClassMedium] ([ClassMediumCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_SchoolBranch_Class] FOREIGN KEY ([SchoolBranchCode]) REFERENCES [dbo].[SchoolBranch] ([SchoolBranchCode]);
GO
ALTER TABLE [dbo].[Class] ADD CONSTRAINT [FK_School_Class] FOREIGN KEY ([SchoolCode]) REFERENCES [dbo].[School] ([SchoolCode]);
GO
ALTER TABLE [dbo].[ClassGraduation] ADD CONSTRAINT [FK_Users_ClassGraduation_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ClassGraduation] ADD CONSTRAINT [FK_Class_ClassGraduation_ClassCode] FOREIGN KEY ([ClassCode]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[ClassGraduationDetail] ADD CONSTRAINT [FK_ClassGraduation_ClassGraduationDetail_GraduationCode] FOREIGN KEY ([GraduationCode]) REFERENCES [dbo].[ClassGraduation] ([GraduationCode]);
GO
ALTER TABLE [dbo].[ClassGraduationDetail] ADD CONSTRAINT [FK_Student_ClassGraduationDetail_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[ClassPromotion] ADD CONSTRAINT [FK_Users_ClassPromotion_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ClassPromotion] ADD CONSTRAINT [FK_Class_ClassPromotion_PromoteClassFrom] FOREIGN KEY ([PromoteClassFrom]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[ClassPromotion] ADD CONSTRAINT [FK_Class_ClassPromotion_PromoteClassTO] FOREIGN KEY ([PromoteClassTo]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[ClassPromotionDetail] ADD CONSTRAINT [FK_ClassPromotion_ClassPromotionDetail_PromotionCode] FOREIGN KEY ([PromotionCode]) REFERENCES [dbo].[ClassPromotion] ([PromotionCode]);
GO
ALTER TABLE [dbo].[ClassPromotionDetail] ADD CONSTRAINT [FK_Student_ClassPromotionDetail_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[ClientSetup] ADD CONSTRAINT [SetupLicenceNoFK] FOREIGN KEY ([LicenceNo]) REFERENCES [dbo].[Setup] ([LicenceNo]);
GO
ALTER TABLE [dbo].[ColumnEditStyle] ADD CONSTRAINT [FK_ColumnPreferences_ColumnEditStyle_ColumnName] FOREIGN KEY ([ColumnName]) REFERENCES [dbo].[ColumnPreferences] ([ColumnName]);
GO
ALTER TABLE [dbo].[ContactCard] ADD CONSTRAINT [FK_ContactCard_Accounts_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ContactGroupDetail] ADD CONSTRAINT [FK_ContactGroupDetail_ContactGroup_ContactGroupCode] FOREIGN KEY ([ContactGroupCode]) REFERENCES [dbo].[ContactGroup] ([ContactGroupCode]);
GO
ALTER TABLE [dbo].[ContactGroupDetail] ADD CONSTRAINT [FK_ContactGroupDetail_ContactCard_ContactCardCode] FOREIGN KEY ([ContactCardCode]) REFERENCES [dbo].[ContactCard] ([ContactCardCode]);
GO
ALTER TABLE [dbo].[ContactPolicyDetail] ADD CONSTRAINT [FK_ContactPolicy_ContactPolicyDetail_ContactPolicyCode] FOREIGN KEY ([ContactPolicyCode]) REFERENCES [dbo].[ContactPolicy] ([ContactPolicyCode]);
GO
ALTER TABLE [dbo].[ContactPolicyDetail] ADD CONSTRAINT [FK_WeekDays_ContactPolicyDetail_WeekDayCode] FOREIGN KEY ([WeekDayCode]) REFERENCES [dbo].[WeekDays] ([WeekDayCode]);
GO
ALTER TABLE [dbo].[ContactPolicyDetail] ADD CONSTRAINT [FK_WeekOfMonth_ContactPolicyDetail_WeekOfMonth] FOREIGN KEY ([WeekOfMonth]) REFERENCES [dbo].[WeekOfMonth] ([WeekOfMonth]);
GO
ALTER TABLE [dbo].[CoronoryAngiogram] ADD CONSTRAINT [FK_Patient_CoronoryAngiogram_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[CoronoryAngiogram] ADD CONSTRAINT [FK_PatientAdmission_CoronoryAngiogram_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[CoronoryAngiogram] ADD CONSTRAINT [FK_Users_CoronoryAngiogram_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CoronoryAngiogram] ADD CONSTRAINT [FK_Users_CoronoryAngiogram_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[CoronoryAngioplasty] ADD CONSTRAINT [FK_Patient_CoronoryAngioplasty_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[CoronoryAngioplasty] ADD CONSTRAINT [FK_PatientAdmission_CoronoryAngioplasty_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[CoronoryAngioplasty] ADD CONSTRAINT [FK_Users_CoronoryAngioplasty_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CoronoryAngioplasty] ADD CONSTRAINT [FK_Users_CoronoryAngioplasty_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[CRS_Accounts] ADD CONSTRAINT [FK_CRS_Accounts_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_AdjDetail] ADD CONSTRAINT [FK_CRS_AdjDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_AdjHeader] ADD CONSTRAINT [FK_CRS_AdjHeader_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_Area] ADD CONSTRAINT [FK_CRS_Area_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_CategoryAccounts] ADD CONSTRAINT [FK_CRS_CategoryAccounts_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_ClientInstance] ADD CONSTRAINT [FK_CRS_ClientList_CRS_ClientInstance_ClientID] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_County] ADD CONSTRAINT [FK_CRS_County_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Currency] ADD CONSTRAINT [FK_CRS_Currency_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Customer] ADD CONSTRAINT [FK_CRS_Customer_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_CustomerCategory] ADD CONSTRAINT [FK_CRS_CustomerCategory_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_CustomerSegment] ADD CONSTRAINT [FK_CRS_CustomerSegment_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_DataTransferLog] ADD CONSTRAINT [FK_CRS_DataTransferLog_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_DataTransferLogDetail] ADD CONSTRAINT [FK_CRS_DataTransferLogDetail_CRS_DataTransferLog] FOREIGN KEY ([LogID]) REFERENCES [dbo].[CRS_DataTransferLog] ([LogID]);
GO
ALTER TABLE [dbo].[CRS_Department] ADD CONSTRAINT [FK_CRS_Department_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Disease] ADD CONSTRAINT [FK_CRS_Disease_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Doctors] ADD CONSTRAINT [FK_CRS_Doctors_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_DueSatisfyDetail] ADD CONSTRAINT [FK_CRS_DueSatisfyDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_DueSatisfyHeader] ADD CONSTRAINT [FK_CRS_DueSatisfyHeader_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_Godown] ADD CONSTRAINT [FK_CRS_Godown_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_GodownDetail] ADD CONSTRAINT [FK_CRS_GodownDetail_CRS_ClientInstance_ClientInstanceID] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_GodownGroup] ADD CONSTRAINT [FK_CRS_GodownGroup_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_GoodsCompany] ADD CONSTRAINT [FK_CRS_GoodsCompany_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_GuaranteePerson] ADD CONSTRAINT [FK_CRS_GuaranteePerson_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_IssueDetail] ADD CONSTRAINT [FK_CRS_IssueDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_IssueHeader] ADD CONSTRAINT [FK_CRS_IssueHeader_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_IssueType] ADD CONSTRAINT [FK_CRS_IssueType_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_MainAccounts] ADD CONSTRAINT [FK_CRS_MainAccounts_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Message] ADD CONSTRAINT [FK_CRS_Message_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Patient] ADD CONSTRAINT [FK_CRS_Patient_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_PatientCategory] ADD CONSTRAINT [FK_CRS_PatientCategory_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_PRDetail] ADD CONSTRAINT [FK_CRS_PRDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_PRLedger] ADD CONSTRAINT [FK_CRS_PRLedger_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_PurchaseType] ADD CONSTRAINT [FK_CRS_PurchaseType_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_PurDetail] ADD CONSTRAINT [FK_CRS_PurDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_PurLedger] ADD CONSTRAINT [FK_CRS_PurLedger_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_ReceiptDetail] ADD CONSTRAINT [FK_CRS_ReceiptDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_ReceiptHeader] ADD CONSTRAINT [FK_CRS_ReceiptHeader_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_Region] ADD CONSTRAINT [FK_CRS_Region_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_SaleDetail] ADD CONSTRAINT [FK_CRS_SaleDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_SaleLedger] ADD CONSTRAINT [FK_CRS_SaleLedger_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_SalesMan] ADD CONSTRAINT [FK_CRS_SalesMan_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_SaleType] ADD CONSTRAINT [FK_CRS_SaleType_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Section] ADD CONSTRAINT [FK_CRS_Section_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_SRDetail] ADD CONSTRAINT [FK_CRS_SRDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_SRLedger] ADD CONSTRAINT [FK_CRS_SRLedger_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_SubAccounts] ADD CONSTRAINT [FK_CRS_SubAccounts_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_SubArea] ADD CONSTRAINT [FK_CRS_SubArea_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_Supplier] ADD CONSTRAINT [FK_CRS_Supplier_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_SupplierCategory] ADD CONSTRAINT [FK_CRS_SupplierCategory_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CRS_TDetail] ADD CONSTRAINT [FK_CRS_TDetail_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_THeader] ADD CONSTRAINT [FK_CRS_THeader_CRS_ClientInstance] FOREIGN KEY ([ClientInstanceID]) REFERENCES [dbo].[CRS_ClientInstance] ([ClientInstanceID]);
GO
ALTER TABLE [dbo].[CRS_Users] ADD CONSTRAINT [FK_CRS_Users_CRS_ClientList] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[CRS_ClientList] ([ClientID]);
GO
ALTER TABLE [dbo].[CTAngiogram] ADD CONSTRAINT [FK_Patient_CTAngiogram_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[CTAngiogram] ADD CONSTRAINT [FK_PatientAdmission_CTAngiogram_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[CTAngiogram] ADD CONSTRAINT [FK_Users_CTAngiogram_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CTAngiogram] ADD CONSTRAINT [FK_Users_CTAngiogram_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[CurrencyDenomination] ADD CONSTRAINT [FK_CurrencyDenomination_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[CustAllowedServices] ADD CONSTRAINT [FK_Customer_CustAllowedServices_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustAllowedServices] ADD CONSTRAINT [FK_Service_CustAllowedServices_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[CustGuaranteePerson] ADD CONSTRAINT [FK_Customer_CustGuaranteeperson_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustGuaranteePerson] ADD CONSTRAINT [FK_GuaranteePerson_CustGuaranteeperson_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[CustItemCatAssociation] ADD CONSTRAINT [FK_Customer_CustItemCatAssociation] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustItemCatAssociation] ADD CONSTRAINT [FK_ItemCategory_CustItemCatAssocation] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[CustItemCatWiseSaleDiscount] ADD CONSTRAINT [FK_CustomerCategory_CustItemCatWiseSaleDiscount] FOREIGN KEY ([CustCatCode]) REFERENCES [dbo].[CustomerCategory] ([CustCatCode]);
GO
ALTER TABLE [dbo].[CustItemCatWiseSaleDiscount] ADD CONSTRAINT [FK_ItemCategory_CustItemCatWiseSaleDiscount] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[CustLicCategory] ADD CONSTRAINT [FK_Customer_CustLicCategory_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustLicCategory] ADD CONSTRAINT [FK_LicenseCategory_CustLicCategory_LicenseCategoryCode] FOREIGN KEY ([LicenseCategoryCode]) REFERENCES [dbo].[LicenseCategory] ([LicenseCategoryCode]);
GO
ALTER TABLE [dbo].[CustLog] ADD CONSTRAINT [FK_Customer_CustLog_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustLog] ADD CONSTRAINT [FK_Users_CustLog_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_TaxCategory_TaxCategoryCode] FOREIGN KEY ([TaxCategoryCode]) REFERENCES [dbo].[TaxCategory] ([TaxCategoryCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_GoodsCompany_Customer_GCCode] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustomerSalesmanCode_FK] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustAreaCodeFK] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_subarea] FOREIGN KEY ([SubAreaCode]) REFERENCES [dbo].[SubArea] ([SubAreaCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_StateProvinceCode] FOREIGN KEY ([StateProvinceCode]) REFERENCES [dbo].[StateProvince] ([StateProvinceCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustCustCatCodeFK] FOREIGN KEY ([CustCatCode]) REFERENCES [dbo].[CustomerCategory] ([CustCatCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_ContactPolicy_Customer_CollectionPolicyCode] FOREIGN KEY ([CollectionPolicyCode]) REFERENCES [dbo].[ContactPolicy] ([ContactPolicyCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_CustomerSector_CustomerSectorCode] FOREIGN KEY ([CustomerSectorCode]) REFERENCES [dbo].[CustomerSector] ([CustomerSectorCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_Countycode] FOREIGN KEY ([CountyCode]) REFERENCES [dbo].[County] ([CountyCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Quotation_Customer_AssociatedQuotationCode] FOREIGN KEY ([AssociatedQuotationCode]) REFERENCES [dbo].[QuotationHeader] ([QuotationCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_SaleTypeCode] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustomerMessageCode_FK] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[CustomerCategory] ADD CONSTRAINT [FK_CustomerSegment_CustomerCategory_CustomerSegmentCode] FOREIGN KEY ([CustomerSegmentCode]) REFERENCES [dbo].[CustomerSegment] ([CustomerSegmentCode]);
GO
ALTER TABLE [dbo].[CustomerComments] ADD CONSTRAINT [FK_CustomerComments_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustomerComments] ADD CONSTRAINT [FK_CustomerComments_Users_CommentedBy] FOREIGN KEY ([CommentedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerConfig] ADD CONSTRAINT [FK_CustomerConfig_CustomerConfig_SourceLicenseID] FOREIGN KEY ([SourceLicenseID]) REFERENCES [dbo].[CustomerConfig] ([LicenseID]);
GO
ALTER TABLE [dbo].[CustomerConfig] ADD CONSTRAINT [FK_Customer_CustomerConfig_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustomerConfig] ADD CONSTRAINT [FK_UserCode_CustomerConfig] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerDeployment] ADD CONSTRAINT [FK_CustomerDeployment_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerDeployment] ADD CONSTRAINT [FK_CustomerDeployment_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerDeploymentDetail] ADD CONSTRAINT [FK_CustomerDeploymentDetail_CustomerDeployment] FOREIGN KEY ([CustomerDeploymentCode]) REFERENCES [dbo].[CustomerDeployment] ([CustomerDeploymentCode]);
GO
ALTER TABLE [dbo].[CustomerDeploymentDetail] ADD CONSTRAINT [FK_CustomerDeploymentDetail_CustomerConfig_LicenseID] FOREIGN KEY ([LicenseID]) REFERENCES [dbo].[CustomerConfig] ([LicenseID]);
GO
ALTER TABLE [dbo].[CustomerGroup] ADD CONSTRAINT [FK_Users_CustomerGroup_Usercode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerGroupCategory] ADD CONSTRAINT [FK_CustGroupCategory_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[CustomerGroupCategory] ADD CONSTRAINT [FK_CustomerGroupCategory_CustomerCategory] FOREIGN KEY ([CustomerCategoryCode]) REFERENCES [dbo].[CustomerCategory] ([CustCatCode]);
GO
ALTER TABLE [dbo].[CustomerGroupDetail] ADD CONSTRAINT [FK_CustomerGroup_CustomerGroupDetail] FOREIGN KEY ([CustomerGroupCode]) REFERENCES [dbo].[CustomerGroup] ([CustomerGroupCode]);
GO
ALTER TABLE [dbo].[CustomerGroupDetail] ADD CONSTRAINT [FK_Customer_CustomerGroupDetail_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustomerLicense] ADD CONSTRAINT [FK_CustomerLicRequest_CustomerLicense_LicenseRequestID] FOREIGN KEY ([LicenseRequestID]) REFERENCES [dbo].[CustomerLicRequest] ([LicenseRequestID]);
GO
ALTER TABLE [dbo].[CustomerLicense] ADD CONSTRAINT [FK_CustomerConfig_CustomerLicense] FOREIGN KEY ([LicenseID]) REFERENCES [dbo].[CustomerConfig] ([LicenseID]);
GO
ALTER TABLE [dbo].[CustomerLicense] ADD CONSTRAINT [FK_UserCode_LicenseIteration] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerLicRequest] ADD CONSTRAINT [FK_Users_CustomerLicRequest_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerLicRequest] ADD CONSTRAINT [FK_CustomerConfig_CustomerLicRequest] FOREIGN KEY ([LicenseID]) REFERENCES [dbo].[CustomerConfig] ([LicenseID]);
GO
ALTER TABLE [dbo].[CustomerLicRequest] ADD CONSTRAINT [FK_LicRequestStatus_CustomerLicRequest_LicReqStatusCode] FOREIGN KEY ([LicReqStatusCode]) REFERENCES [dbo].[LicRequestStatus] ([LicReqStatusCode]);
GO
ALTER TABLE [dbo].[CustomerLicRequest] ADD CONSTRAINT [FK_Users_CustomerLicRequest_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplate] ADD CONSTRAINT [FK_CustomerServiceTemplate_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplate] ADD CONSTRAINT [FK_CustomerServiceTemplate_Service_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplate] ADD CONSTRAINT [FK_CustomerServiceTemplate_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerServiceTemplate_CustomerServiceTemplateDetail_CustomerServiceTemplateCode] FOREIGN KEY ([CustomerServiceTemplateCode]) REFERENCES [dbo].[CustomerServiceTemplate] ([CustomerServiceTemplateCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerServiceTemplateDetail_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerServiceTemplateDetail_TransportRoute_TransportRouteCode] FOREIGN KEY ([TransportRouteCode]) REFERENCES [dbo].[TransportRoute] ([TransportRouteCode]);
GO
ALTER TABLE [dbo].[CustomerServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerServiceTemplateDetail_Vehicle_VehicleCode] FOREIGN KEY ([VehicleCode]) REFERENCES [dbo].[Vehicle] ([VehicleCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplate] ADD CONSTRAINT [FK_CustomerStudentServiceTemplate_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplate] ADD CONSTRAINT [FK_CustomerStudentServiceTemplate_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplate] ADD CONSTRAINT [FK_CustomerStudentServiceTemplate_Service_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplate] ADD CONSTRAINT [FK_CustomerStudentServiceTemplate_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerStudentServiceTemplateDetail_Class_ClassCode] FOREIGN KEY ([ClassCode]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerStudentServiceTemplate_CustomerStudentServiceTemplateDetail_CustomerStudentServiceTemplateCode] FOREIGN KEY ([CustomerStudentServiceTemplateCode]) REFERENCES [dbo].[CustomerStudentServiceTemplate] ([CustomerStudentServiceTemplateCode]);
GO
ALTER TABLE [dbo].[CustomerStudentServiceTemplateDetail] ADD CONSTRAINT [FK_CustomerStudentServiceTemplateDetail_Student_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[CustQualPerson] ADD CONSTRAINT [FK_Customer_CustQualPerson_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustQualPerson] ADD CONSTRAINT [FK_QualifiedPerson_CustQualPerson_QualifiedPersonCode] FOREIGN KEY ([QualifiedPersonCode]) REFERENCES [dbo].[QualifiedPerson] ([QualifiedPersonCode]);
GO
ALTER TABLE [dbo].[CustWiseItemCategory] ADD CONSTRAINT [FK_Customer_CustWiseItemCategory_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[CustWiseItemCategory] ADD CONSTRAINT [FK_Item_CustWiseItemCategory_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[DB_ExpiryIntimation] ADD CONSTRAINT [FK_DB_ExpiryIntimation_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_ExpiryIntimation] ADD CONSTRAINT [FK_DB_ExpiryIntimation_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_ExpiryIntimationDetail] ADD CONSTRAINT [FK_DB_ExpiryIntimationDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_IssueDetail] ADD CONSTRAINT [FK_DB_IssueDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_IssueHeader] ADD CONSTRAINT [FK_DB_IssueHeader_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_IssueHeader] ADD CONSTRAINT [FK_DB_IssueHeader_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PRdetail] ADD CONSTRAINT [FK_DB_PRDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PRLedger] ADD CONSTRAINT [FK_DB_PRLedger_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PRLedger] ADD CONSTRAINT [FK_DB_PRLedger_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_Purdetail] ADD CONSTRAINT [FK_DB_PurDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_Purledger] ADD CONSTRAINT [FK_DB_PurLedger_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_Purledger] ADD CONSTRAINT [FK_DB_PurLedger_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PurOrderDetail] ADD CONSTRAINT [FK_DB_PurOrderDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PurOrderHeader] ADD CONSTRAINT [FK_DB_PurOrderHeader_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_PurOrderHeader] ADD CONSTRAINT [FK_DB_PurOrderHeader_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_Saledetail] ADD CONSTRAINT [FK_DB_SaleDetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_SaleLedger] ADD CONSTRAINT [FK_DB_SaleLedger_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_SaleLedger] ADD CONSTRAINT [FK_DB_SaleLedger_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_SRdetail] ADD CONSTRAINT [FK_DB_SRdetail_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_SRLedger] ADD CONSTRAINT [FK_DB_SRLedger_Site_SiteCode] FOREIGN KEY ([SiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DB_SRLedger] ADD CONSTRAINT [FK_DB_SRLedger_Site_TargetSiteCode] FOREIGN KEY ([TargetSiteCode]) REFERENCES [dbo].[Site] ([SiteCode]);
GO
ALTER TABLE [dbo].[DeathCertificate] ADD CONSTRAINT [FK_DeathCertificate_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[DeathCertificate] ADD CONSTRAINT [FK_DeathCertificate_PatientAdmission_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[DeathCertificate] ADD CONSTRAINT [FK_DeathCertificate_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DeathCertificate] ADD CONSTRAINT [FK_DeathCertificate_Visit_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[DiagnosticItem] ADD CONSTRAINT [FK_DiagnosticItemType_DiagnosticItem_DiagnosticItemTypeCode] FOREIGN KEY ([DiagnosticItemTypeCode]) REFERENCES [dbo].[DiagnosticItemType] ([DiagnosticItemTypeCode]);
GO
ALTER TABLE [dbo].[DiagnosticItem] ADD CONSTRAINT [FK_DiagnosticUnit_DiagnosticItem_DiagnosticUnitCode] FOREIGN KEY ([DiagnosticUnitCode]) REFERENCES [dbo].[DiagnosticUnit] ([DiagnosticUnitCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Patient_DischargePrescription_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_PatientAdmission_DischargePrescription_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Item_DischargePrescription_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_DosageUnit_DischargePrescription_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Dosage_DischargePrescription_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Route_DischargePrescription_RouteCode] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Instruction_DischargePrescription_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Users_DischargePrescription_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DischargePrescription] ADD CONSTRAINT [FK_Users_DischargePrescription_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[DiscountPolicyDetail] ADD CONSTRAINT [FK_DiscountPolicyDetail_DiscountPolicyCode] FOREIGN KEY ([DiscountPolicyCode]) REFERENCES [dbo].[DiscountPolicy] ([DiscountPolicyCode]);
GO
ALTER TABLE [dbo].[Disease] ADD CONSTRAINT [FK_Disease_DiseaseType_DiseaseTypeCode] FOREIGN KEY ([DiseaseTypeCode]) REFERENCES [dbo].[DiseaseType] ([DiseaseTypeCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTemp] ADD CONSTRAINT [FK_DiseaseTreatmentTemp_Disease_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_DiseaseTreatmentTemp_DiseaseTreatmentTempCode] FOREIGN KEY ([DiseaseTreatmentTempCode]) REFERENCES [dbo].[DiseaseTreatmentTemp] ([DiseaseTreatmentTempCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_Dosage_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_Route_RouteCode] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_Instruction_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[DiseaseTreatmentTempDetail] ADD CONSTRAINT [FK_DiseaseTreatmentTempDetail_DosageUnit_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[DispatchDetail] ADD CONSTRAINT [DispDDispInvCodeFK] FOREIGN KEY ([DispCode]) REFERENCES [dbo].[DispatchHeader] ([DispCode]);
GO
ALTER TABLE [dbo].[DispatchDetail] ADD CONSTRAINT [DispDSaleInvCodeFK] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[DispatchHeader] ADD CONSTRAINT [FK_DispatchHeader_SalesMan_DeliveredBy] FOREIGN KEY ([DeliveredBy]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[DispatchHeader] ADD CONSTRAINT [DispCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[DispatchHeader] ADD CONSTRAINT [DispGCCode] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[DispatchHeader] ADD CONSTRAINT [DispPostedbByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DispatchHeader] ADD CONSTRAINT [DispUserCodeFK] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DoctorDutyRoster] ADD CONSTRAINT [FK_Users_DoctorDutyRoster_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DoctorDutyRosterDetail] ADD CONSTRAINT [FK_DoctorDutyRoster_DoctorDutyRosterDetail] FOREIGN KEY ([DoctorDutyRosterCode]) REFERENCES [dbo].[DoctorDutyRoster] ([DoctorDutyRosterCode]);
GO
ALTER TABLE [dbo].[DoctorDutyRosterDetail] ADD CONSTRAINT [FK_Doctors_DoctorDutyRosterDetail_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[Doctors] ADD CONSTRAINT [FK_ServiceTemplateHeader_Doctors_ServiceTemplateCode] FOREIGN KEY ([ServiceTemplateCode]) REFERENCES [dbo].[ServiceTemplateHeader] ([ServiceTemplateCode]);
GO
ALTER TABLE [dbo].[Doctors] ADD CONSTRAINT [FK_Doctors_DoctorCategory_DoctorCategoryCode] FOREIGN KEY ([DoctorCategoryCode]) REFERENCES [dbo].[DoctorCategory] ([DoctorCategoryCode]);
GO
ALTER TABLE [dbo].[Doctors] ADD CONSTRAINT [FK_Doctors_Accounts_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[DueAdjDetail] ADD CONSTRAINT [FK_DueAdjHeader_DueAdjDetail_DueAdjCode] FOREIGN KEY ([DueAdjCode]) REFERENCES [dbo].[DueAdjHeader] ([DueAdjCode]);
GO
ALTER TABLE [dbo].[DueAdjDetail] ADD CONSTRAINT [FK_SaleLedger_DueAdjDetail_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[DueAdjDetail] ADD CONSTRAINT [FK_Item_DueAdjDetail_ICode] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[DueAdjDetail] ADD CONSTRAINT [FK_Godown_DueAdjDetail_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[DueAdjHeader] ADD CONSTRAINT [FK_Users_DueAdjHeader] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DueDeleteDetail] ADD CONSTRAINT [DDDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[DueDeleteDetail] ADD CONSTRAINT [DDDDueSatisfyCodeFK] FOREIGN KEY ([DueSatisfyCode]) REFERENCES [dbo].[DueSatisfyHeader] ([DueSatisfyCode]);
GO
ALTER TABLE [dbo].[DueSatisfyDetail] ADD CONSTRAINT [DSDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[DueSatisfyDetail] ADD CONSTRAINT [DSDDueSatisfyCodeFK] FOREIGN KEY ([DueSatisfyCode]) REFERENCES [dbo].[DueSatisfyHeader] ([DueSatisfyCode]);
GO
ALTER TABLE [dbo].[DueSatisfyDetail] ADD CONSTRAINT [DSDGCodeFK] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[DueSatisfyHeader] ADD CONSTRAINT [DSHUserCodeFK] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[DueSatisfyHeader] ADD CONSTRAINT [DSHSaleInvCodeFK] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[DueSatisfyHeader] ADD CONSTRAINT [FK_DueAdjHeader_DueSatisfyHeader] FOREIGN KEY ([DueAdjCode]) REFERENCES [dbo].[DueAdjHeader] ([DueAdjCode]);
GO
ALTER TABLE [dbo].[ECG] ADD CONSTRAINT [FK_Patient_ECG_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ECG] ADD CONSTRAINT [FK_PatientAdmission_ECG_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ECG] ADD CONSTRAINT [FK_Users_ECG_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ECG] ADD CONSTRAINT [FK_Users_ECG_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[Echo] ADD CONSTRAINT [FK_Patient_Echo_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[Echo] ADD CONSTRAINT [FK_PatientAdmission_Echo_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[Echo] ADD CONSTRAINT [FK_Users_Echo_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Echo] ADD CONSTRAINT [FK_Users_Echo_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[EMP_Advance] ADD CONSTRAINT [FK_Accounts_EMP_Advance_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_Advance] ADD CONSTRAINT [FK_Accounts_EMP_Advance_EmpAdvAccCode] FOREIGN KEY ([EmpAdvAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_Advance] ADD CONSTRAINT [FK_Users_EMP_Advance_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[EMP_Attendance] ADD CONSTRAINT [FK_EMP_Employee_EMP_Attendance_EmpCode] FOREIGN KEY ([EMPCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_Attendance] ADD CONSTRAINT [FK_EMP_Finger_EMP_Attendance_FingerCode] FOREIGN KEY ([FingerCode]) REFERENCES [dbo].[EMP_Finger] ([FingerCode]);
GO
ALTER TABLE [dbo].[EMP_Attendance] ADD CONSTRAINT [FK_EMP_Finger_EMP_Attendance_FingerCodeOut] FOREIGN KEY ([FingerCodeOut]) REFERENCES [dbo].[EMP_Finger] ([FingerCode]);
GO
ALTER TABLE [dbo].[EMP_Attendance] ADD CONSTRAINT [FK_EMP_AttendanceStatus_EMP_Attendance_AttendanceStatusCode] FOREIGN KEY ([AttendanceStatusCode]) REFERENCES [dbo].[EMP_AttendanceStatus] ([AttendanceStatusCode]);
GO
ALTER TABLE [dbo].[EMP_Deduction] ADD CONSTRAINT [FK_Accounts_EMP_Deduction_DeductionCode] FOREIGN KEY ([DeductionCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_DepartmentTiming] ADD CONSTRAINT [FK_EMP_Department_EMP_DepartmentTiming_DeptCode] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[EMP_Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[EMP_DepartmentTiming] ADD CONSTRAINT [FK_WeekDays_EMP_DepartmentTiming_WeekDayCode] FOREIGN KEY ([WeekDayCode]) REFERENCES [dbo].[WeekDays] ([WeekDayCode]);
GO
ALTER TABLE [dbo].[EMP_EmpCertification] ADD CONSTRAINT [FK_EMP_Employee_EMP_EmpCertification] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_EmpCertification] ADD CONSTRAINT [FK_EMP_Certification_EMP_EmpCertification_CertificationCode] FOREIGN KEY ([CertificationCode]) REFERENCES [dbo].[EMP_Certification] ([CertificationCode]);
GO
ALTER TABLE [dbo].[EMP_EmpEducation] ADD CONSTRAINT [FK_EMP_Employee_EMP_EmpEducation] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_EmpEducation] ADD CONSTRAINT [FK_EMP_Education_EMP_EmpEducation] FOREIGN KEY ([EducationCode]) REFERENCES [dbo].[EMP_Education] ([EducationCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_EMP_Category_EMP_Employee_EmpCatCode] FOREIGN KEY ([EmpCatCode]) REFERENCES [dbo].[EMP_Category] ([EmpCatCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_EMP_Department_EMP_Employee_DeptCode] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[EMP_Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_EMP_Designation_EMP_Employee_DesigCode] FOREIGN KEY ([DesigCode]) REFERENCES [dbo].[EMP_Designation] ([DesigCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_Accounts_EMP_Employee_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_Accounts_EMP_Employee_AdvAccCode] FOREIGN KEY ([AdvAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_EMP_Employee_TransportRoute_TransportRouteCode] FOREIGN KEY ([TransportRouteCode]) REFERENCES [dbo].[TransportRoute] ([TransportRouteCode]);
GO
ALTER TABLE [dbo].[EMP_Employee] ADD CONSTRAINT [FK_EMP_Employee_Vehicle_VehicleCode] FOREIGN KEY ([VehicleCode]) REFERENCES [dbo].[Vehicle] ([VehicleCode]);
GO
ALTER TABLE [dbo].[EMP_EmpSkill] ADD CONSTRAINT [FK_EMP_Employee_EMP_EmpSkill] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_EmpSkill] ADD CONSTRAINT [FK_EMP_Skill_EMP_EmpSkill_SkillCode] FOREIGN KEY ([SkillCode]) REFERENCES [dbo].[EMP_Skill] ([SkillCode]);
GO
ALTER TABLE [dbo].[EMP_FingerPrint] ADD CONSTRAINT [FK_EMP_Employee_EMP_FingerPrint_EmpCode] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_FingerPrint] ADD CONSTRAINT [FK_EMP_Finger_EMP_FingerPrint_FingerCode] FOREIGN KEY ([FingerCode]) REFERENCES [dbo].[EMP_Finger] ([FingerCode]);
GO
ALTER TABLE [dbo].[EMP_Image] ADD CONSTRAINT [FK_EMP_Employee_EMP_Image] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_JobExp] ADD CONSTRAINT [FK_EMP_Employee_EMP_JobExp] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_Pay] ADD CONSTRAINT [FK_EMP_Employee_EMP_Pay_EmpCode] FOREIGN KEY ([EMPCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_PayAllowance] ADD CONSTRAINT [FK_EMP_Employee_EMP_PayAllowance] FOREIGN KEY ([EMPCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_PayAllowance] ADD CONSTRAINT [FK_EMP_Allowance_EMP_PayAllowance] FOREIGN KEY ([AllowanceCode]) REFERENCES [dbo].[EMP_Allowance] ([AllowanceCode]);
GO
ALTER TABLE [dbo].[EMP_PayDeduction] ADD CONSTRAINT [FK_EMP_Employee_EMP_PayDeduction] FOREIGN KEY ([EMPCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_PayDeduction] ADD CONSTRAINT [FK_EMP_Deduction_EMP_PayDeduction] FOREIGN KEY ([DeductionCode]) REFERENCES [dbo].[EMP_Deduction] ([DeductionCode]);
GO
ALTER TABLE [dbo].[EMP_Payroll] ADD CONSTRAINT [FK_Accounts_EMP_Payroll_PaidVia] FOREIGN KEY ([PaidVia]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[EMP_Payroll] ADD CONSTRAINT [FK_Users_EMP_Payroll_PaidBy] FOREIGN KEY ([PaidBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[EMP_Payroll] ADD CONSTRAINT [FK_Users_EMP_Payroll_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[EMP_Payroll] ADD CONSTRAINT [FK_EMP_Employee_EMP_Payroll_EmpCode] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_Payroll] ADD CONSTRAINT [FK_Users_EMP_Payroll_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[EMP_PayrollAllowances] ADD CONSTRAINT [FK_EMP_Payroll_EMP_PayrollAllowances_PayrollCode] FOREIGN KEY ([PayrollCode]) REFERENCES [dbo].[EMP_Payroll] ([PayrollCode]);
GO
ALTER TABLE [dbo].[EMP_PayrollAllowances] ADD CONSTRAINT [FK_EMP_Allowance_EMP_PayrollAllowances_AllowanceCode] FOREIGN KEY ([AllowanceCode]) REFERENCES [dbo].[EMP_Allowance] ([AllowanceCode]);
GO
ALTER TABLE [dbo].[EMP_PayrollDeductions] ADD CONSTRAINT [FK_EMP_Payroll_EMP_PayrollDeductions_PayrollCode] FOREIGN KEY ([PayrollCode]) REFERENCES [dbo].[EMP_Payroll] ([PayrollCode]);
GO
ALTER TABLE [dbo].[EMP_PayrollDeductions] ADD CONSTRAINT [FK_EMP_Deduction_EMP_PayrollDeductions_DeductionCode] FOREIGN KEY ([DeductionCode]) REFERENCES [dbo].[EMP_Deduction] ([DeductionCode]);
GO
ALTER TABLE [dbo].[EMP_Project] ADD CONSTRAINT [FK_EMP_Employee_EMP_Project] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EMP_Reference] ADD CONSTRAINT [FK_EMP_Employee_EMP_Reference] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[EMP_Employee] ([EmpCode]);
GO
ALTER TABLE [dbo].[EmrLabInvestRec] ADD CONSTRAINT [FK_Users_EmrLabInvestRec_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[EmrLabInvestRec] ADD CONSTRAINT [FK_Users_EmrLabInvestRec_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[EmrLabInvestRec] ADD CONSTRAINT [FK_Patient_EmrLabInvestRec_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[EmrLabInvestRec] ADD CONSTRAINT [FK_PatientAdmission_EmrLabInvestRec_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimation] ADD CONSTRAINT [FK_ExpiryIntimation_IntimationType_IntimationTypeCode] FOREIGN KEY ([IntimationTypeCode]) REFERENCES [dbo].[IntimationType] ([IntimationTypeCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimation] ADD CONSTRAINT [FK_ExpiryIntimation_Accounts_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimation] ADD CONSTRAINT [FK_ExpiryIntimation_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimation] ADD CONSTRAINT [FK_ExpiryIntimation_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimation] ADD CONSTRAINT [FK_ExpiryIntimation_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimationDetail] ADD CONSTRAINT [FK_ExpiryIntimationDetail_ExpiryIntimation_IntimationCode] FOREIGN KEY ([IntimationCode]) REFERENCES [dbo].[ExpiryIntimation] ([IntimationCode]);
GO
ALTER TABLE [dbo].[ExpiryIntimationDetail] ADD CONSTRAINT [FK_ExpiryIntimationDetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[FBR_DI_Scenario] ADD CONSTRAINT [FK_FBR_DI_Scenario_FBR_DI_TransactionType] FOREIGN KEY ([TransTypeCode]) REFERENCES [dbo].[FBR_DI_TransactionType] ([TransTypeCode]);
GO
ALTER TABLE [dbo].[GenericItem] ADD CONSTRAINT [FK_GenericItem_GenericItemType_GenericItemTypeCode] FOREIGN KEY ([GenericItemTypeCode]) REFERENCES [dbo].[GenericItemType] ([GenericItemTypeCode]);
GO
ALTER TABLE [dbo].[GLDetail] ADD CONSTRAINT [FK_Guest_GLDetail_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[GLDetail] ADD CONSTRAINT [FK_Student_GLDetail_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[GLDetail] ADD CONSTRAINT [FK_GLDetail_Patient] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[GLDetail] ADD CONSTRAINT [GLDAccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[GLDetail] ADD CONSTRAINT [GLDGLVochCode] FOREIGN KEY ([GLVochCode]) REFERENCES [dbo].[Glheader] ([GLVochCode]);
GO
ALTER TABLE [dbo].[GLDocument] ADD CONSTRAINT [FK_GLDocument_GLHeader_GLVochCode] FOREIGN KEY ([GLVochCode]) REFERENCES [dbo].[Glheader] ([GLVochCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [FK_GLHeader_Users_TransferedBy] FOREIGN KEY ([TransferedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [FK_GLHeader_Users_ImportedBy] FOREIGN KEY ([ImportedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [GHModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [GHPostedByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [GHVochCatCodeFK] FOREIGN KEY ([VochCatCode]) REFERENCES [dbo].[VocherCategory] ([VochCatCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [FK_SalesMan_GLHeader_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [GLAccCodeFK] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [GLSalesManCodeFK] FOREIGN KEY ([salesmancode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [FK_BillSummary_GLHeader_BillSummaryCode] FOREIGN KEY ([BillSummaryCode]) REFERENCES [dbo].[BillSummary] ([BillSummaryCode]);
GO
ALTER TABLE [dbo].[Glheader] ADD CONSTRAINT [FK_GLHeader_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[Godown] ADD CONSTRAINT [FK_Godown_GodownGroup_GodownGroupCode] FOREIGN KEY ([GodownGroupCode]) REFERENCES [dbo].[GodownGroup] ([GodownGroupCode]);
GO
ALTER TABLE [dbo].[GodownDetail] ADD CONSTRAINT [GDGCodeFK] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[GodownDetail] ADD CONSTRAINT [GDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[GodownDetail] ADD CONSTRAINT [FK_GodownDetail_LockReason_LockReasonCode] FOREIGN KEY ([LockReasonCode]) REFERENCES [dbo].[LockReason] ([LockReasonCode]);
GO
ALTER TABLE [dbo].[GPE] ADD CONSTRAINT [FK_Users_GPE_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GPE] ADD CONSTRAINT [FK_Users_GPE_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[GPE] ADD CONSTRAINT [FK_Patient_GPE_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[GPE] ADD CONSTRAINT [FK_PatientAdmission_GPE_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[GroupAllowedGodown] ADD CONSTRAINT [FK_GroupAllowedGodown_Module] FOREIGN KEY ([Module]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupAllowedGodown] ADD CONSTRAINT [FK_GroupAllowedGodown_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedGodown] ADD CONSTRAINT [FK_GroupAllowedGodown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[GroupAllowedGroups] ADD CONSTRAINT [FK_Groups_GroupAllowedGroups_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedGroups] ADD CONSTRAINT [FK_Module_GroupAllowedGroups] FOREIGN KEY ([Module]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupAllowedGroups] ADD CONSTRAINT [FK_Groups_GroupAllowedGroups_AllowedGroupCode] FOREIGN KEY ([AllowedGroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedHeader] ADD CONSTRAINT [FK_GroupAllowedHeader_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedHeader] ADD CONSTRAINT [FK_GroupAllowedHeader_Module] FOREIGN KEY ([Module]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupAllowedPrice] ADD CONSTRAINT [FK_PriceType_GroupAllowedPrice] FOREIGN KEY ([PriceTypeCode]) REFERENCES [dbo].[PriceType] ([PriceTypeCode]);
GO
ALTER TABLE [dbo].[GroupAllowedPrice] ADD CONSTRAINT [FK_Module_GroupAllowedPrice] FOREIGN KEY ([Module]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupAllowedRecipient] ADD CONSTRAINT [FK_Groups_GroupAllowedRecipient_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedRecipient] ADD CONSTRAINT [FK_Module_GroupAllowedRecipient_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupAllowedRecipient] ADD CONSTRAINT [FK_Recipient_GroupAllowedRecipient_RecipientCode] FOREIGN KEY ([RecipientCode]) REFERENCES [dbo].[Recipient] ([RecipientCode]);
GO
ALTER TABLE [dbo].[GroupAllowedServiceCategory] ADD CONSTRAINT [FK_Groups_GroupAllowedServiceCategory_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedServiceCategory] ADD CONSTRAINT [FK_ServiceCategory_GroupAllowedServiceCategory_ServiceCatCode] FOREIGN KEY ([ServiceCatCode]) REFERENCES [dbo].[ServiceCategory] ([ServiceCatCode]);
GO
ALTER TABLE [dbo].[GroupAllowedStartupRight] ADD CONSTRAINT [FK_Groups_GroupAllowedStartupRight] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupAllowedStartupRight] ADD CONSTRAINT [FK_StartupRight_GroupAllowedStartupRight] FOREIGN KEY ([RightCode]) REFERENCES [dbo].[StartupRight] ([RightCode]);
GO
ALTER TABLE [dbo].[GroupCashAccount] ADD CONSTRAINT [FK_Accounts_GroupCashAccount_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[GroupCashAccount] ADD CONSTRAINT [FK_Groups_GroupCashAccount_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupCashAccount] ADD CONSTRAINT [FK_Module_GroupCashAccount_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[GroupPurExpTemplate] ADD CONSTRAINT [FK_Groups_GroupPurExpTemplate_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupPurExpTemplate] ADD CONSTRAINT [FK_Accounts_GroupPurExpTemplate_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[GroupRights] ADD CONSTRAINT [GRRightCodeFK] FOREIGN KEY ([RightCode]) REFERENCES [dbo].[Rights] ([RightCode]);
GO
ALTER TABLE [dbo].[GroupRights] ADD CONSTRAINT [GRGroupCodeFK] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[Groups] ADD CONSTRAINT [FK_ServiceTemplateHeader_Groups] FOREIGN KEY ([DefaultServiceTemplateCode]) REFERENCES [dbo].[ServiceTemplateHeader] ([ServiceTemplateCode]);
GO
ALTER TABLE [dbo].[Groups] ADD CONSTRAINT [FK_SaleType_Groups_SaleTypeCode] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[GroupSupplierCategory] ADD CONSTRAINT [FK_GroupSupplierCategory_Groups_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupSupplierCategory] ADD CONSTRAINT [FK_GroupSupplierCategory_SupplierCategory_SuppCatCode] FOREIGN KEY ([SuppCatCode]) REFERENCES [dbo].[SupplierCategory] ([SuppCatCode]);
GO
ALTER TABLE [dbo].[GroupVoucherCategory] ADD CONSTRAINT [FK_GroupVoucherCategory_Groups] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupVoucherCategory] ADD CONSTRAINT [FK_GroupVoucherCategory_VocherCategory] FOREIGN KEY ([VochCatCode]) REFERENCES [dbo].[VocherCategory] ([VochCatCode]);
GO
ALTER TABLE [dbo].[GroupWiseImpExpTemplate] ADD CONSTRAINT [FK_Groups_GroupWiseImpExpTemplate_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[GroupWiseImpExpTemplate] ADD CONSTRAINT [FK_Accounts_GroupWiseImpExpTemplate_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Guest] ADD CONSTRAINT [FK_Customer_Guest_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[Guest] ADD CONSTRAINT [FK_User_Guest_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_Users_GuestCheckin_CheckInBy] FOREIGN KEY ([CheckInBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_Users_GuestCheckin_CheckOutBy] FOREIGN KEY ([CheckOutBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_Accounts_GuestCheckin_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_Users_GuestCheckin_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_Guest_GuestCheckin_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_GuestRoom_GuestCheckin_CurrentRoom] FOREIGN KEY ([CurrentRoom]) REFERENCES [dbo].[GuestRoom] ([GuestRoomCode]);
GO
ALTER TABLE [dbo].[GuestCheckin] ADD CONSTRAINT [FK_GuestRoom_GuestCheckin_CheckInRoom] FOREIGN KEY ([CheckInRoom]) REFERENCES [dbo].[GuestRoom] ([GuestRoomCode]);
GO
ALTER TABLE [dbo].[GuestCheckInService] ADD CONSTRAINT [FK_GuestCheckIn_GuestCheckInService_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[GuestCheckInService] ADD CONSTRAINT [FK_Service_GuestCheckInService_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[GuestCheckInService] ADD CONSTRAINT [FK_GuestCheckInService_SalesMan_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[GuestRoom] ADD CONSTRAINT [FK_GuestRoomFloor_GuestRoom_GuestRoomFloorCode] FOREIGN KEY ([GuestRoomFloorCode]) REFERENCES [dbo].[GuestRoomFloor] ([GuestRoomFloorCode]);
GO
ALTER TABLE [dbo].[GuestRoom] ADD CONSTRAINT [FK_GuestRoomType_GuestRoom_GuestRoomTypeCode] FOREIGN KEY ([GuestRoomTypeCode]) REFERENCES [dbo].[GuestRoomType] ([GuestRoomTypeCode]);
GO
ALTER TABLE [dbo].[GuestRoom] ADD CONSTRAINT [FK_GuestRoomStatus_GuestRoom_GuestRoomStatusCode] FOREIGN KEY ([GuestRoomStatusCode]) REFERENCES [dbo].[GuestRoomStatus] ([GuestRoomStatusCode]);
GO
ALTER TABLE [dbo].[GuestRoomService] ADD CONSTRAINT [FK_GuestRoomService_GuestRoom_GuestRoomCode] FOREIGN KEY ([GuestRoomCode]) REFERENCES [dbo].[GuestRoom] ([GuestRoomCode]);
GO
ALTER TABLE [dbo].[GuestRoomService] ADD CONSTRAINT [FK_Service_GuestRoom_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[GuestRoomService] ADD CONSTRAINT [FK_GuestRoomService_SalesMan_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[GuestTransfer] ADD CONSTRAINT [FK_GuestCheckIn_GuestTransfer_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[GuestTransfer] ADD CONSTRAINT [FK_Users_GuestTransfer_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[GuestTransfer] ADD CONSTRAINT [FK_GuestRoom_GuestTransfer_LastRoom] FOREIGN KEY ([LastRoom]) REFERENCES [dbo].[GuestRoom] ([GuestRoomCode]);
GO
ALTER TABLE [dbo].[GuestTransfer] ADD CONSTRAINT [FK_GuestRoom_GuestTransfer_NewRoom] FOREIGN KEY ([NewRoom]) REFERENCES [dbo].[GuestRoom] ([GuestRoomCode]);
GO
ALTER TABLE [dbo].[GYN_US] ADD CONSTRAINT [FK_GYN_US_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[GYN_US] ADD CONSTRAINT [FK_GYN_US_Visit_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[GYN_US] ADD CONSTRAINT [FK_GYN_US_PatientAdmission_VisitCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[HPC] ADD CONSTRAINT [FK_Users_HPC_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[HPC] ADD CONSTRAINT [FK_Users_HPC_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[HPC] ADD CONSTRAINT [FK_Patient_HPC_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[HPC] ADD CONSTRAINT [FK_PatientAdmission_HPC_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleDetail] ADD CONSTRAINT [FK_IMP_AdvSaleDetail_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleDetail] ADD CONSTRAINT [FK_Item_IMP_AdvSaleDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleDetail] ADD CONSTRAINT [FK_Godown_IMP_AdvSaleDetail_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_SalesMan_IMP_AdvSaleLedger_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Relation_IMP_AdvSaleLedger_RelationCode] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Disease_IMP_AdvSaleLedger_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Ward_IMP_AdvSaleLedger_WardCode] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Accounts_IMP_AdvSaleLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Users_IMP_AdvSaleLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_SaleType_IMP_AdvSaleLedger] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Customer_IMP_AdvSaleLedger_Credit1AccCode] FOREIGN KEY ([Credit1AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Customer_IMP_AdvSaleLedger_Credit2AccCode] FOREIGN KEY ([Credit2AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Customer_IMP_AdvSaleLedger_Credit3AccCode] FOREIGN KEY ([Credit3AccCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_SaleCategory_IMP_AdvSaleLedger_SaleCatCode] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Customer_IMP_AdvSaleLedger_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Users_IMP_AdvSaleLedger_SalesManCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Users_IMP_AdvSaleLedger_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Users_IMP_AdvSaleLedger_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Doctors_IMP_AdvSaleLedger_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Patient_IMP_AdvSaleLedger_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IMP_AdvSaleLedger] ADD CONSTRAINT [FK_Message_IMP_AdvSaleLedger_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[IMP_Saledetail] ADD CONSTRAINT [FK_IMP_Saledetail_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IMP_Saledetail] ADD CONSTRAINT [FK_IMP_Saledetail_Godown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[IMP_Saledetail] ADD CONSTRAINT [FK_IMP_Saledetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_GuaranteePerson_IMP_SaleLedger_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Guest_IMP_SaleLedger_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_GuestCheckIn_IMP_SaleLedger_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_PrescriptionHeader_IMP_SaleLedger] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_ProspectiveCustomer_IMP_SaleLedger] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Relation_IMP_SaleLedger] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_deliveredby] FOREIGN KEY ([deliveredby]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_PatientAdmission] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_IMP_SaleLedger_RecurringAgainst] FOREIGN KEY ([RecurringAgainst]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_SRBufferLedger_SRBufferInvCode] FOREIGN KEY ([SRBufferInvCode]) REFERENCES [dbo].[SRBufferLedger] ([SRBufferInvCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_SaleOrderHeader_IMP_SaleLedger] FOREIGN KEY ([SaleOrderCode]) REFERENCES [dbo].[SaleOrderHeader] ([SaleOrderCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_SaleType_IMP_SaleLedger] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Student_IMP_SaleLedger_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Users_IMP_SaleLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Visit_IMP_SaleLedger_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Ward_IMP_SaleLedger] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [IMP_SaleLedgerPatientCodeFK] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FL_IMP_SaleLedger_Doctors_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Message_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Accounts_IMP_SaleLedger_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Accounts_IMP_SaleLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_Disease_IMP_SaleLedger] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_GoodsCompany_IMP_SaleLedger] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_SaleCategory_SaleCatCode] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_Users_SalesManCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SaleLedger] ADD CONSTRAINT [FK_IMP_SaleLedger_SalesMan_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IMP_SRDetail] ADD CONSTRAINT [FK_IMP_SRDetail_Item_ICode] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IMP_SRDetail] ADD CONSTRAINT [FK_IMP_SRDetail_Godown_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_SaleCategory_SRCatCode] FOREIGN KEY ([SRCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Users_SalesmanCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Users_Posted] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_SalesMan_SmanCode] FOREIGN KEY ([Smancode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_IMP_SRLedger_PatientAdmission] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Accounts_IMP_SRLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Users_IMP_SRLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Doctors_IMP_SRLedger_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Accounts_IMP_SRLedger_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Guest_IMP_SRLedger_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_GuestCheckIn_IMP_SRLedger_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[IMP_SRLedger] ADD CONSTRAINT [FK_Student_IMP_SRLedger_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_UnitSalesTaxRules_ImpPurDetail_UnitTaxRuleCode] FOREIGN KEY ([UnitTaxRuleCode]) REFERENCES [dbo].[UnitSalesTaxRules] ([RuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_GSTRules_ImpPurDetail_GSTRuleCode] FOREIGN KEY ([GSTRuleCode]) REFERENCES [dbo].[GSTRules] ([RuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_CustomDutyRule_ImpPurDetail_UnitCustomDutyRuleCode] FOREIGN KEY ([UnitCustomDutyRuleCode]) REFERENCES [dbo].[CustomDutyRule] ([CustomDutyRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_CustomDutyRule_ImpPurDetail_PercCustomDutyRuleCode] FOREIGN KEY ([PercCustomDutyRuleCode]) REFERENCES [dbo].[CustomDutyRule] ([CustomDutyRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_AdditionalTaxRule_ImpPurDetail_PercAdditionalTaxRuleCode] FOREIGN KEY ([PercAdditionalTaxRuleCode]) REFERENCES [dbo].[AdditionalTaxRule] ([AdditionalTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_ExtraTaxRule_ImpPurDetail_UnitExtraTaxRuleCode] FOREIGN KEY ([UnitExtraTaxRuleCode]) REFERENCES [dbo].[ExtraTaxRule] ([ExtraTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_ExtraTaxRule_ImpPurDetail_PercExtraTaxRuleCode] FOREIGN KEY ([PercExtraTaxRuleCode]) REFERENCES [dbo].[ExtraTaxRule] ([ExtraTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_MeasuringUnit_ImpPurDetail_MeasureUnitCode] FOREIGN KEY ([MeasureUnitCode]) REFERENCES [dbo].[MeasuringUnit] ([MeasureUnitCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_GSTTYpe_ImpPurDetail_GSTTYpeCode] FOREIGN KEY ([GSTTYpeCode]) REFERENCES [dbo].[GSTType] ([GSTTypeCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_IncomeTaxRule_ImpPurDetail_UnitIncomeTaxRuleCode] FOREIGN KEY ([UnitIncomeTaxRuleCode]) REFERENCES [dbo].[IncomeTaxRule] ([IncomeTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_IncomeTaxRule_ImpPurDetail_PercIncomeTaxRuleCode] FOREIGN KEY ([PercIncomeTaxRuleCode]) REFERENCES [dbo].[IncomeTaxRule] ([IncomeTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_AdditionalTaxRule_ImpPurDetail_UnitAdditionalTaxRuleCode] FOREIGN KEY ([UnitAdditionalTaxRuleCode]) REFERENCES [dbo].[AdditionalTaxRule] ([AdditionalTaxRuleCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_ImpPurHeader_ImpPurDetail_ImpPurInvCode] FOREIGN KEY ([ImpPurInvCode]) REFERENCES [dbo].[ImpPurHeader] ([ImpPurInvCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_Supplier_ImpPurDetail_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_Item_ImpPurDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ImpPurDetail] ADD CONSTRAINT [FK_Godown_ImpPurDetail_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ImpPurExp] ADD CONSTRAINT [FK_ImpPurHeader_ImpPurExp_ImpPurInvCode] FOREIGN KEY ([ImpPurInvCode]) REFERENCES [dbo].[ImpPurHeader] ([ImpPurInvCode]);
GO
ALTER TABLE [dbo].[ImpPurExp] ADD CONSTRAINT [FK_Accounts_ImpPurExp_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ImpPurHeader] ADD CONSTRAINT [FK_Users_ImpPurHeader_FinalizedBy] FOREIGN KEY ([FinalizedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ImpPurHeader] ADD CONSTRAINT [FK_Users_ImpPurHeader_PostedBy] FOREIGN KEY ([FinalizedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ImpPurHeader] ADD CONSTRAINT [FK_Users_ImpPurHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ImpPurHeader] ADD CONSTRAINT [FK_Currency_ImpPurHeader_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[IncentiveSheet] ADD CONSTRAINT [FK_Accounts_IncentiveSheet_DrAccCode] FOREIGN KEY ([DrAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IncentiveSheet] ADD CONSTRAINT [FK_Accounts_IncentiveSheet_CrAccCode] FOREIGN KEY ([CrAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IncentiveSheet] ADD CONSTRAINT [FK_Users_IncentiveSheet_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IncentiveSheet] ADD CONSTRAINT [FK_Users_IncentiveSheet_PostedBy] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IncentiveSheetDetail] ADD CONSTRAINT [FK_IncentiveSheet_IncentiveSheetDetail_IncentiveDocCode] FOREIGN KEY ([IncentiveDocCode]) REFERENCES [dbo].[IncentiveSheet] ([IncentiveDocCode]);
GO
ALTER TABLE [dbo].[IncentiveSheetDetail] ADD CONSTRAINT [FK_Item_IncentiveSheetDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[InstallmentDetail] ADD CONSTRAINT [FK_InstallmentHeader_InstallmentDetail] FOREIGN KEY ([InstallmentCode]) REFERENCES [dbo].[InstallmentHeader] ([InstallmentCode]);
GO
ALTER TABLE [dbo].[InstallmentDetail] ADD CONSTRAINT [FK_InstallmentDetail_Users_CancelledBy] FOREIGN KEY ([CancelledBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentGuarantor] ADD CONSTRAINT [FK_InstallmentGuarantor_InstallmentHeader_InstallmentCode] FOREIGN KEY ([InstallmentCode]) REFERENCES [dbo].[InstallmentHeader] ([InstallmentCode]);
GO
ALTER TABLE [dbo].[InstallmentGuarantor] ADD CONSTRAINT [FK_InstallmentGuarantor_GuaranteePerson_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_InstallmentHeader_Users_RejectedBy] FOREIGN KEY ([RejectedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_InstallmentHeader_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_Users_InstallmentHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_InstallmentHeader_Users_ApprovedBy] FOREIGN KEY ([ApprovedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_Users_InstallmentHeader_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_Godown_InstallmentHeader_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_Item_InstallmentHeader_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_Users_InstallmentHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_InstallmentHeader_SalesMan_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[InstallmentHeader] ADD CONSTRAINT [FK_InstallmentHeader_SalesMan_InquiryPersonCode] FOREIGN KEY ([InquiryPersonCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[InstallmentReceipt] ADD CONSTRAINT [FK_Users_InstallmentReceipt_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InstallmentReceipt] ADD CONSTRAINT [FK_SaleLedger_InstallmentReceipt_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[InstallmentReceipt] ADD CONSTRAINT [FK_InstallmentReceipt_SalesMan_RecoveryPersonCode] FOREIGN KEY ([RecoveryPersonCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[InstallmentReceiptDetail] ADD CONSTRAINT [FK_InstallmentReceiptDetail_InstallmentReceipt_ReceiptCode] FOREIGN KEY ([ReceiptCode]) REFERENCES [dbo].[InstallmentReceipt] ([ReceiptCode]);
GO
ALTER TABLE [dbo].[InstallmentSecurity] ADD CONSTRAINT [FK_InstallmentSecurity_InstallmentHeader_InstallmentCode] FOREIGN KEY ([InstallmentCode]) REFERENCES [dbo].[InstallmentHeader] ([InstallmentCode]);
GO
ALTER TABLE [dbo].[InterfaceSetting] ADD CONSTRAINT [Fk_WindowType_InterfaceSetting] FOREIGN KEY ([WinType]) REFERENCES [dbo].[WindowType] ([WinType]);
GO
ALTER TABLE [dbo].[InterfaceSetting] ADD CONSTRAINT [FK_Module_ModuleId] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[InvLedger] ADD CONSTRAINT [InvLAccCodeFK] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[InvLedger] ADD CONSTRAINT [InvLSalesmanFK] FOREIGN KEY ([salesmancode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[InvLedger] ADD CONSTRAINT [InvLVochCatCodeFK] FOREIGN KEY ([InvVochCatCode]) REFERENCES [dbo].[VocherCategory] ([VochCatCode]);
GO
ALTER TABLE [dbo].[IssueCategoryAccounts] ADD CONSTRAINT [FK_IssueCategoryAccounts_IssueCategory_IssueCategoryCode] FOREIGN KEY ([IssueCategoryCode]) REFERENCES [dbo].[IssueCategory] ([IssueCategoryCode]);
GO
ALTER TABLE [dbo].[IssueCategoryAccounts] ADD CONSTRAINT [FK_IssueCategoryAccounts_SubAccounts_SubAccCode] FOREIGN KEY ([SubAccCode]) REFERENCES [dbo].[SubAccounts] ([SubAccCode]);
GO
ALTER TABLE [dbo].[IssueDetail] ADD CONSTRAINT [ISDICodeFK] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IssueDetail] ADD CONSTRAINT [FK_Section_IssueDetail] FOREIGN KEY ([SectCode]) REFERENCES [dbo].[Section] ([SectCode]);
GO
ALTER TABLE [dbo].[IssueDetail] ADD CONSTRAINT [ISDIssueInvCodeFK] FOREIGN KEY ([IssueInvCode]) REFERENCES [dbo].[IssueHeader] ([IssueInvCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_ServiceOHeader_ServiceOCode] FOREIGN KEY ([ServiceOCode]) REFERENCES [dbo].[ServiceOHeader] ([ServiceOCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_WorkOrderCode] FOREIGN KEY ([WorkOrderCode]) REFERENCES [dbo].[WorkOrder] ([WorkOrderCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [ISDeletedByFK] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [ISDeptCodeFK] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [ISModifiedBYFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [ISPostedByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [ISSalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [IssSmanCodeFK] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_IssueCategory_IssueCategoryCode] FOREIGN KEY ([IssueCategoryCode]) REFERENCES [dbo].[IssueCategory] ([IssueCategoryCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_Accounts_DrAccCode] FOREIGN KEY ([DrAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_IssueTypeCode] FOREIGN KEY ([IssueTypeCode]) REFERENCES [dbo].[IssueType] ([IssueTypeCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_Accounts_IssueHeader_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_SalesMan_IssueHeader_RecipientSalesMan] FOREIGN KEY ([RecipientSalesMan]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_Recipient_IssueHeader_RecipientCode] FOREIGN KEY ([RecipientCode]) REFERENCES [dbo].[Recipient] ([RecipientCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_IssueHeader_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [FK_PriceType_IssueHeader_PriceTypeCode] FOREIGN KEY ([PriceTypeCode]) REFERENCES [dbo].[PriceType] ([PriceTypeCode]);
GO
ALTER TABLE [dbo].[IssueHeader] ADD CONSTRAINT [IssAreaCode_FK] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[IssueReqDetail] ADD CONSTRAINT [FK_Section_IssueReqDetail] FOREIGN KEY ([SectCode]) REFERENCES [dbo].[Section] ([SectCode]);
GO
ALTER TABLE [dbo].[IssueReqDetail] ADD CONSTRAINT [FK_Item_IssueReqDetail] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[IssueReqDetail] ADD CONSTRAINT [FK_IssueReqHeader_IssueReqDetail] FOREIGN KEY ([IssueReqInvCode]) REFERENCES [dbo].[IssueReqHeader] ([IssueReqInvCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Department_IssueReqHeader] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Users_IssueReqHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Users_IssueReqHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Users_IssueReqHeader_Salesmancode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Area_IssueReqHeader_Area] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_SalesMan_IssueReqHeader] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_Accounts_IssueReqHeader_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[IssueReqHeader] ADD CONSTRAINT [FK_IssueReqHeader_ServiceOHeader_ServiceOCode] FOREIGN KEY ([ServiceOCode]) REFERENCES [dbo].[ServiceOHeader] ([ServiceOCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_GenericItem_item] FOREIGN KEY ([GenericCode]) REFERENCES [dbo].[GenericItem] ([GenericCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [IICatCodeFK] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [IICCodeFK] FOREIGN KEY ([ICCode]) REFERENCES [dbo].[ItemClass] ([ICCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_MeasuringUnit_Item_MeasureUnitCode] FOREIGN KEY ([MeasureUnitCode]) REFERENCES [dbo].[MeasuringUnit] ([MeasureUnitCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [IManfCodeFk] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [IPackcodeFK] FOREIGN KEY ([Packcode]) REFERENCES [dbo].[ItemPacking] ([PackCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [ItemUserCode_FK] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_Item_ItemThickness_ItemThicknessCode] FOREIGN KEY ([ItemThicknessCode]) REFERENCES [dbo].[ItemThickness] ([ItemThicknessCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_Item_ItemThickness_ItemThicknessCode2] FOREIGN KEY ([ItemThicknessCode2]) REFERENCES [dbo].[ItemThickness] ([ItemThicknessCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_Item_ItemColour_ItemColourCode2] FOREIGN KEY ([ItemColourCode2]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemType_Item] FOREIGN KEY ([ItemTypeCode]) REFERENCES [dbo].[ItemType] ([ItemTypeCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_Item_SalesTaxSchedule_SalesTaxScheduleCode] FOREIGN KEY ([SalesTaxScheduleCode]) REFERENCES [dbo].[SalesTaxSchedule] ([SalesTaxScheduleCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemDesign_Item_ItemDesignCode] FOREIGN KEY ([ItemDesignCode]) REFERENCES [dbo].[ItemDesign] ([ItemDesignCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemPart_Item_IPartCode] FOREIGN KEY ([IPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemPart_Item_OldPartCode] FOREIGN KEY ([OldPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_DiscountPolicy_Item_DiscountPolicyCode] FOREIGN KEY ([DiscountPolicyCode]) REFERENCES [dbo].[DiscountPolicy] ([DiscountPolicyCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemAlert_Item_ItemAlertCode] FOREIGN KEY ([ItemAlertCode]) REFERENCES [dbo].[ItemAlert] ([ItemAlertCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_BonusPolicy_Item_BonusPolicyCode] FOREIGN KEY ([BonusPolicyCode]) REFERENCES [dbo].[BonusPolicy] ([BonusPolicyCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemSize_Item] FOREIGN KEY ([ISizeCode]) REFERENCES [dbo].[ItemSize] ([ISizeCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemStyle_Item] FOREIGN KEY ([IStyleCode]) REFERENCES [dbo].[ItemStyle] ([IStyleCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemColour_Item] FOREIGN KEY ([IColourCode]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemSleeve_Item] FOREIGN KEY ([ISleeveCode]) REFERENCES [dbo].[ItemSleeve] ([ISleeveCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemYarn_Item] FOREIGN KEY ([IYarnCode]) REFERENCES [dbo].[ItemYarn] ([IYarnCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemFabric_Item] FOREIGN KEY ([IFabricCode]) REFERENCES [dbo].[ItemFabric] ([IFabricCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_ItemBrand_Item] FOREIGN KEY ([IBrandCode]) REFERENCES [dbo].[ItemBrand] ([IBrandCode]);
GO
ALTER TABLE [dbo].[Item] ADD CONSTRAINT [FK_Item_PCT_PCTCode] FOREIGN KEY ([PCTCode]) REFERENCES [dbo].[PCT] ([PCTCode]);
GO
ALTER TABLE [dbo].[ItemAlert] ADD CONSTRAINT [FK_ItemAlertType_ItemAlert_ItemAlertTypeCode] FOREIGN KEY ([ItemAlertTypeCode]) REFERENCES [dbo].[ItemAlertType] ([ItemAlertTypeCode]);
GO
ALTER TABLE [dbo].[ItemAllowedMeter] ADD CONSTRAINT [FK_ItemAllowedMeter_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemAllowedMeter] ADD CONSTRAINT [FK_ItemAllowedMeter_ItemMeter_ItemMeterCode] FOREIGN KEY ([ItemMeterCode]) REFERENCES [dbo].[ItemMeter] ([ItemMeterCode]);
GO
ALTER TABLE [dbo].[ItemAssociation] ADD CONSTRAINT [FK_Item_ItemAssociation_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemAssociation] ADD CONSTRAINT [FK_Item_ItemAssociation_AssocICode] FOREIGN KEY ([AssocICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemAuthor] ADD CONSTRAINT [FK_Item_ItemAuthor_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemAuthor] ADD CONSTRAINT [FK_Author_ItemAuthor_AuthorCode] FOREIGN KEY ([AuthorCode]) REFERENCES [dbo].[Author] ([AuthorCode]);
GO
ALTER TABLE [dbo].[ItemBatches] ADD CONSTRAINT [FK_Item_ItemBatches_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemBatches] ADD CONSTRAINT [FK_Godown_ItemBatches_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ItemBatchPricing] ADD CONSTRAINT [FK_ItemBatchPricing_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemBatchPricing] ADD CONSTRAINT [FK_ItemBatchPricing_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemBatchPricing] ADD CONSTRAINT [FK_ItemBatchPricing_Users_LastModifiedBy] FOREIGN KEY ([LastModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemCategory] ADD CONSTRAINT [FK_ItemCategory_CategorySegment_CategorySegmentCode] FOREIGN KEY ([CategorySegmentCode]) REFERENCES [dbo].[CategorySegment] ([CategorySegmentCode]);
GO
ALTER TABLE [dbo].[ItemCategoryWiseUpdation] ADD CONSTRAINT [FK_ItemCategoryWiseUpdation_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ItemColourAndSize] ADD CONSTRAINT [FK_ItemColourAndSize_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemColourAndSize] ADD CONSTRAINT [FK_ItemColourAndSize_ItemColour_IColourCode] FOREIGN KEY ([IColourCode]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[ItemColourAndSize] ADD CONSTRAINT [FK_ItemColourAndSize_ItemSize_ISizeCode] FOREIGN KEY ([ISizeCode]) REFERENCES [dbo].[ItemSize] ([ISizeCode]);
GO
ALTER TABLE [dbo].[ItemConversionDetail] ADD CONSTRAINT [FK_ItemConversionDetail_ItemConversionHeader_ItemConversionCode] FOREIGN KEY ([ItemConversionCode]) REFERENCES [dbo].[ItemConversionHeader] ([ItemConversionCode]);
GO
ALTER TABLE [dbo].[ItemConversionDetail] ADD CONSTRAINT [FK_ItemConversionDetail_Godown_Gcode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ItemConversionDetail] ADD CONSTRAINT [FK_ItemConversionDetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemConversionHeader] ADD CONSTRAINT [FK_ItemConversionHeader_User_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemConversionHeader] ADD CONSTRAINT [FK_ItemConversionHeader_User_PostedBy] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemConversionHeader] ADD CONSTRAINT [FK_ItemConversionHeader_Godown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ItemConversionHeader] ADD CONSTRAINT [FK_ItemConversionHeader_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemConversionHeader] ADD CONSTRAINT [FK_ItemConversionHeader_ItemConversionEffect_ItemConversionEffectCode] FOREIGN KEY ([ItemConversionEffectCode]) REFERENCES [dbo].[ItemConversionEffect] ([ItemConversionEffectCode]);
GO
ALTER TABLE [dbo].[ItemCostHistory] ADD CONSTRAINT [FK_ItemCostHistory_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemGroupDetail] ADD CONSTRAINT [FK_ItemGroup_ItemGroupDetail_ItemGroupCode] FOREIGN KEY ([ItemGroupCode]) REFERENCES [dbo].[ItemGroup] ([ItemGroupCode]);
GO
ALTER TABLE [dbo].[ItemGroupDetail] ADD CONSTRAINT [FK_Item_ItemGroupDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemImage] ADD CONSTRAINT [FK_Item_ItemImage] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemInModel] ADD CONSTRAINT [FK_Model_ItemInModel] FOREIGN KEY ([ModelCode]) REFERENCES [dbo].[Model] ([ModelCode]);
GO
ALTER TABLE [dbo].[ItemInModel] ADD CONSTRAINT [FK_Item_ItemInModel] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemInquiry] ADD CONSTRAINT [FK_Users_ItemInquiry_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemInquiryDetail] ADD CONSTRAINT [FK_ItemInquiry_ItemInquiryDetail_ItemInquiryCode] FOREIGN KEY ([ItemInquiryCode]) REFERENCES [dbo].[ItemInquiry] ([ItemInquiryCode]);
GO
ALTER TABLE [dbo].[ItemInquiryDetail] ADD CONSTRAINT [FK_Item_ItemInquiryDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_GenericItem_itemlog] FOREIGN KEY ([GenericCode]) REFERENCES [dbo].[GenericItem] ([GenericCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_MeasuringUnit_ItemLog_MeasureUnitCode] FOREIGN KEY ([MeasureUnitCode]) REFERENCES [dbo].[MeasuringUnit] ([MeasureUnitCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemType_ItemLog] FOREIGN KEY ([ItemTypeCode]) REFERENCES [dbo].[ItemType] ([ItemTypeCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemDesign_ItemLog_ItemDesignCode] FOREIGN KEY ([ItemDesignCode]) REFERENCES [dbo].[ItemDesign] ([ItemDesignCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemLog_SalesTaxSchedule_SalesTaxScheduleCode] FOREIGN KEY ([SalesTaxScheduleCode]) REFERENCES [dbo].[SalesTaxSchedule] ([SalesTaxScheduleCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_BonusPolicy_ItemLog_BonusPolicyCode] FOREIGN KEY ([BonusPolicyCode]) REFERENCES [dbo].[BonusPolicy] ([BonusPolicyCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_DiscountPolicy_ItemLog_DiscountPolicyCode] FOREIGN KEY ([DiscountPolicyCode]) REFERENCES [dbo].[DiscountPolicy] ([DiscountPolicyCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemAlert_ItemLog_ItemAlertCode] FOREIGN KEY ([ItemAlertCode]) REFERENCES [dbo].[ItemAlert] ([ItemAlertCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemLog_ItemThickness_ItemThicknessCode] FOREIGN KEY ([ItemThicknessCode]) REFERENCES [dbo].[ItemThickness] ([ItemThicknessCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemLog_ItemThickness_ItemThicknessCode2] FOREIGN KEY ([ItemThicknessCode2]) REFERENCES [dbo].[ItemThickness] ([ItemThicknessCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemLog_ItemColour_ItemColourCode2] FOREIGN KEY ([ItemColourCode2]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemSize_ItemLog] FOREIGN KEY ([ISizeCode]) REFERENCES [dbo].[ItemSize] ([ISizeCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemStyle_ItemLog] FOREIGN KEY ([IStyleCode]) REFERENCES [dbo].[ItemStyle] ([IStyleCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemColour_ItemLog] FOREIGN KEY ([IColourCode]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemSleeve_ItemLog] FOREIGN KEY ([ISleeveCode]) REFERENCES [dbo].[ItemSleeve] ([ISleeveCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemYarn_ItemLog] FOREIGN KEY ([IYarnCode]) REFERENCES [dbo].[ItemYarn] ([IYarnCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemFabric_ItemLog] FOREIGN KEY ([IFabricCode]) REFERENCES [dbo].[ItemFabric] ([IFabricCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemBrand_ItemLog] FOREIGN KEY ([IBrandCode]) REFERENCES [dbo].[ItemBrand] ([IBrandCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemPart_ItemLog_IPartCode] FOREIGN KEY ([IPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemPart_ItemLog_OldPartCode] FOREIGN KEY ([OldPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [ILICatCodeFK] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [ILICCodeFK] FOREIGN KEY ([ICCode]) REFERENCES [dbo].[ItemClass] ([ICCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [ILManfCodeFk] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [ILUserCodeFk] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [ILPackcodeFK] FOREIGN KEY ([Packcode]) REFERENCES [dbo].[ItemPacking] ([PackCode]);
GO
ALTER TABLE [dbo].[ItemLog] ADD CONSTRAINT [FK_ItemLog_PCT_PCTCode] FOREIGN KEY ([PCTCode]) REFERENCES [dbo].[PCT] ([PCTCode]);
GO
ALTER TABLE [dbo].[ItemMeterLog] ADD CONSTRAINT [FK_ItemMeterLog_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ItemMeterLog] ADD CONSTRAINT [FK_ItemMeterLog_ItemMeter_ItemMeterCode] FOREIGN KEY ([ItemMeterCode]) REFERENCES [dbo].[ItemMeter] ([ItemMeterCode]);
GO
ALTER TABLE [dbo].[ItemNotes] ADD CONSTRAINT [FK_Item_ItemNotes] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemPart] ADD CONSTRAINT [FK_ItemPart_IPartCode_MasterIPartCode] FOREIGN KEY ([MasterIPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemPart] ADD CONSTRAINT [FK_ItemCategory_ItemPart_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ItemPart] ADD CONSTRAINT [FK_ItemClass_ItemPart_ICCode] FOREIGN KEY ([ICCode]) REFERENCES [dbo].[ItemClass] ([ICCode]);
GO
ALTER TABLE [dbo].[ItemPart] ADD CONSTRAINT [FK_Manufacturer_ItemPart_ManfCode] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[ItemPart] ADD CONSTRAINT [FK_Godown_ItemPart_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ItemPartInModel] ADD CONSTRAINT [FK_ItemPart_ItemPartInModel_IPartCode] FOREIGN KEY ([IPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemPartInModel] ADD CONSTRAINT [FK_Model_ItemPartInModel_ModelCode] FOREIGN KEY ([ModelCode]) REFERENCES [dbo].[Model] ([ModelCode]);
GO
ALTER TABLE [dbo].[ItemPurExpTemplate] ADD CONSTRAINT [FK_ItemPurExpTemplate_Groups_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[ItemReceiptExpTemplate] ADD CONSTRAINT [FK_ItemReceiptExpTemplate_Groups_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_MeasuringUnit_ItemRegRequest_MeasureUnitCode] FOREIGN KEY ([MeasureUnitCode]) REFERENCES [dbo].[MeasuringUnit] ([MeasureUnitCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_BonusPolicy_ItemRegRequest_BonusPolicyCode] FOREIGN KEY ([BonusPolicyCode]) REFERENCES [dbo].[BonusPolicy] ([BonusPolicyCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_DiscountPolicy_ItemRegRequest_DiscountPolicyCode] FOREIGN KEY ([DiscountPolicyCode]) REFERENCES [dbo].[DiscountPolicy] ([DiscountPolicyCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemDesign_ItemRegRequest_ItemDesignCode] FOREIGN KEY ([ItemDesignCode]) REFERENCES [dbo].[ItemDesign] ([ItemDesignCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemAlert_ItemRegRequest_ItemAlertCode] FOREIGN KEY ([ItemAlertCode]) REFERENCES [dbo].[ItemAlert] ([ItemAlertCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemPart_ItemRegRequest_IPartCode] FOREIGN KEY ([IPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemPart_ItemRegRequest_OldPartCode] FOREIGN KEY ([OldPartCode]) REFERENCES [dbo].[ItemPart] ([IPartCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_GenericItem_ItemRegRequest_GenericCode] FOREIGN KEY ([GenericCode]) REFERENCES [dbo].[GenericItem] ([GenericCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemType_ItemRegRequest_ItemTypeCode] FOREIGN KEY ([ItemTypeCode]) REFERENCES [dbo].[ItemType] ([ItemTypeCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemSize_ItemRegRequest_ISizeCode] FOREIGN KEY ([ISizeCode]) REFERENCES [dbo].[ItemSize] ([ISizeCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemStyle_ItemRegRequest_IStyleCode] FOREIGN KEY ([IStyleCode]) REFERENCES [dbo].[ItemStyle] ([IStyleCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemColour_ItemRegRequest_IColourCode] FOREIGN KEY ([IColourCode]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemSleeve_ItemRegRequest_ISleeveCode] FOREIGN KEY ([ISleeveCode]) REFERENCES [dbo].[ItemSleeve] ([ISleeveCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemYarn_ItemRegRequest_IYarnCode] FOREIGN KEY ([IYarnCode]) REFERENCES [dbo].[ItemYarn] ([IYarnCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemFabric_ItemRegRequest_IFabricCode] FOREIGN KEY ([IFabricCode]) REFERENCES [dbo].[ItemFabric] ([IFabricCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemBrand_ItemRegRequest_IBrandCode] FOREIGN KEY ([IBrandCode]) REFERENCES [dbo].[ItemBrand] ([IBrandCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_IemClass_ItemRegRequest_ICCode] FOREIGN KEY ([ICCode]) REFERENCES [dbo].[ItemClass] ([ICCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_IemCategory_ItemRegRequest_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_ItemPacking_ItemRegRequest_PackCode] FOREIGN KEY ([Packcode]) REFERENCES [dbo].[ItemPacking] ([PackCode]);
GO
ALTER TABLE [dbo].[ItemRegRequest] ADD CONSTRAINT [FK_Manufacturer_ItemRegRequest_ManfCode] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[ItemsGroupCategory] ADD CONSTRAINT [ITEMCATGroupcodeFK] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[ItemsGroupCategory] ADD CONSTRAINT [ItemsCategoryFK] FOREIGN KEY ([ItemsCategoryCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ItemSuppliers] ADD CONSTRAINT [ITEMSUPPICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ItemSuppliers] ADD CONSTRAINT [ITEMSUPPSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[LabInvestRec] ADD CONSTRAINT [FK_Patient_LabInvestRec_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[LabInvestRec] ADD CONSTRAINT [FK_PatientAdmission_LabInvestRec_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[LabInvestRec] ADD CONSTRAINT [FK_Users_LabInvestRec_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[LabInvestRec] ADD CONSTRAINT [FK_Users_LabInvestRec_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[License] ADD CONSTRAINT [FK_Customer_License_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[License] ADD CONSTRAINT [FK_Users_License_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Locker] ADD CONSTRAINT [FK_Locker_LockerCategory_LockerCatCode] FOREIGN KEY ([LockerCatCode]) REFERENCES [dbo].[LockerCategory] ([LockerCatCode]);
GO
ALTER TABLE [dbo].[LoyaltyCard] ADD CONSTRAINT [FK_LoyaltyPolicy_LoyaltyCard_LoyaltyPolicyCode] FOREIGN KEY ([LoyaltyPolicyCode]) REFERENCES [dbo].[LoyaltyPolicy] ([LoyaltyPolicyCode]);
GO
ALTER TABLE [dbo].[LoyaltyCard] ADD CONSTRAINT [FK_Accounts_LoyaltyCard_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[LoyaltyCard] ADD CONSTRAINT [FK_Users_LoyaltyCard_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[LoyaltyCardLedger] ADD CONSTRAINT [FK_LoyaltyCard_LoyaltyCardLedger] FOREIGN KEY ([LoyaltyCardCode]) REFERENCES [dbo].[LoyaltyCard] ([LoyaltyCardCode]);
GO
ALTER TABLE [dbo].[LoyaltyCardLedger] ADD CONSTRAINT [FK_Accounts_LoyaltyCardLedger_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[LoyaltyCardLedger] ADD CONSTRAINT [FK_Users_LoyaltyCardLedger_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[LoyaltyPointAdjustment] ADD CONSTRAINT [FK_Users_LoyaltyPointAdjustment_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[LoyaltyPointAdjustment] ADD CONSTRAINT [FK_LoyaltyCard_LoyaltyPointAdjustment_LoyaltyCardCode] FOREIGN KEY ([LoyaltyCardCode]) REFERENCES [dbo].[LoyaltyCard] ([LoyaltyCardCode]);
GO
ALTER TABLE [dbo].[LoyaltyPolicy] ADD CONSTRAINT [FK_Users_LoyaltyPolicy_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[LoyaltyPolicyDetail] ADD CONSTRAINT [FK_LoyaltyPolicy_LoyaltyPolicyDetail_LoyaltyPolicyCode] FOREIGN KEY ([LoyaltyPolicyCode]) REFERENCES [dbo].[LoyaltyPolicy] ([LoyaltyPolicyCode]);
GO
ALTER TABLE [dbo].[LoyaltyRedemption] ADD CONSTRAINT [FK_LoyaltyCard_LoyaltyRedemption] FOREIGN KEY ([LoyaltyCardCode]) REFERENCES [dbo].[LoyaltyCard] ([LoyaltyCardCode]);
GO
ALTER TABLE [dbo].[LoyaltyRedemption] ADD CONSTRAINT [FK_Users_LoyaltyRedemption_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Manufacturer] ADD CONSTRAINT [DF_ManufacturerCategory_Manufacturer] FOREIGN KEY ([ManfCatCode]) REFERENCES [dbo].[ManufacturerCategory] ([ManfCatCode]);
GO
ALTER TABLE [dbo].[Manufacturer] ADD CONSTRAINT [FK_POPolicy_Manufacturer_POPolicyCode] FOREIGN KEY ([POPolicyCode]) REFERENCES [dbo].[POPolicy] ([POPolicyCode]);
GO
ALTER TABLE [dbo].[Manufacturer] ADD CONSTRAINT [FK_Manufacturer_ManufacturerType_ManufacturerTypeCode] FOREIGN KEY ([ManufacturerTypeCode]) REFERENCES [dbo].[ManufacturerType] ([ManufacturerTypeCode]);
GO
ALTER TABLE [dbo].[MasterCashWin] ADD CONSTRAINT [FK_Accounts_MasterCashWin_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[MembershipRenewal] ADD CONSTRAINT [FK_MemberShipRenewal_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[MembershipRenewal] ADD CONSTRAINT [FK_MembershipRenewal_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[MembershipRenewal] ADD CONSTRAINT [FK_MemberShipRenewal_Usercode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[MembershipRenewal] ADD CONSTRAINT [FK_MemberShipRenewal_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ModuleEvent] ADD CONSTRAINT [FK_Module_ModuleEvent_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[MotorVehicle] ADD CONSTRAINT [FK_MotorVehicle_MotorVehicleType_MotorVehicleTypeCode] FOREIGN KEY ([MotorVehicleTypeCode]) REFERENCES [dbo].[MotorVehicleType] ([MotorVehicleTypeCode]);
GO
ALTER TABLE [dbo].[MotorVehicle] ADD CONSTRAINT [FK_MotorVehicle_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [FK_Accounts_Notes_BankAccCode] FOREIGN KEY ([BankAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [FK_Accounts_Notes_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [FK_Users_Notes_FinalizedBy] FOREIGN KEY ([FinalizedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [NNoteCatCode] FOREIGN KEY ([NoteCatCode]) REFERENCES [dbo].[NotesCategory] ([NoteCatCode]);
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [NSalesManCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[NotesDetail] ADD CONSTRAINT [FK_Notes_NotesDetail] FOREIGN KEY ([NoteCode]) REFERENCES [dbo].[Notes] ([NoteCode]);
GO
ALTER TABLE [dbo].[OBS_US] ADD CONSTRAINT [FK_OBS_US_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[OBS_US] ADD CONSTRAINT [FK_OBS_US_Visit_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[OBS_US] ADD CONSTRAINT [FK_OBS_US_PatientAdmission_VisitCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PackingCaseCapacity] ADD CONSTRAINT [FK_ItemCategory_PackingCaseCapacity_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[PackingCaseCapacity] ADD CONSTRAINT [FK_ItemPacking_PackingCaseCapacity_PackCode] FOREIGN KEY ([PackCode]) REFERENCES [dbo].[ItemPacking] ([PackCode]);
GO
ALTER TABLE [dbo].[PackingJob] ADD CONSTRAINT [FK_Users_PackingJob_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PackingJob] ADD CONSTRAINT [FK_Users_PackingJob_PostedBY] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PackingJobDetail] ADD CONSTRAINT [FK_PackingJob_PackingJobDetail_PackingJobCode] FOREIGN KEY ([PackingJobCode]) REFERENCES [dbo].[PackingJob] ([PackingJobCode]);
GO
ALTER TABLE [dbo].[PackingJobDetail] ADD CONSTRAINT [FK_PackingLayout_PackingJobDetail_PackingLayoutCode] FOREIGN KEY ([PackingLayoutCode]) REFERENCES [dbo].[PackingLayout] ([PackingLayoutCode]);
GO
ALTER TABLE [dbo].[PackingJobDetail] ADD CONSTRAINT [FK_Item_PackingJobDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PackingJobPending] ADD CONSTRAINT [FK_PackingJob_PackingJobPending_PackingJobCode] FOREIGN KEY ([PackingJobCode]) REFERENCES [dbo].[PackingJob] ([PackingJobCode]);
GO
ALTER TABLE [dbo].[PackingJobPending] ADD CONSTRAINT [FK_Item_PackingJobPending_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PackingJobSource] ADD CONSTRAINT [FK_PackingJob_PackingJobSource_PackingJobCode] FOREIGN KEY ([PackingJobCode]) REFERENCES [dbo].[PackingJob] ([PackingJobCode]);
GO
ALTER TABLE [dbo].[PackingJobSource] ADD CONSTRAINT [FK_Module_PackingJobSource_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Gestation_Patient_GestationCode] FOREIGN KEY ([GestationCode]) REFERENCES [dbo].[Gestation] ([GestationCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Rank_Patient] FOREIGN KEY ([RankCode]) REFERENCES [dbo].[Rank] ([RankCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_PatientCategory_Patient_PatientCatCode] FOREIGN KEY ([PatientCatCode]) REFERENCES [dbo].[PatientCategory] ([PatientCatCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Unit_Patient] FOREIGN KEY ([UnitCode]) REFERENCES [dbo].[Unit] ([UnitCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Relation_Patient] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Doctors_Patient] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Ward_Patient] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_County_CountyCode] FOREIGN KEY ([CountyCode]) REFERENCES [dbo].[County] ([CountyCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Accounts_Patient_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [PatientCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [PatientUserCodeFK] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_PrincipalPatient] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Users_Patient_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Users_Patient_InActivedBy] FOREIGN KEY ([InActivedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Disease_Patient_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_PatientLocation_Patient_LocationCode] FOREIGN KEY ([LocationCode]) REFERENCES [dbo].[PatientLocation] ([LocationCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_DischargeReason] FOREIGN KEY ([DischargeReasonCode]) REFERENCES [dbo].[DischargeReason] ([DischargeReasonCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_Disease_PatientAdmission_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_Relation_RelationCode] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_ServiceHeader_PatientAdmission] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_Service_ProcedureRequired] FOREIGN KEY ([ProcedureRequired]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_LocationCode] FOREIGN KEY ([LocationCode]) REFERENCES [dbo].[PatientLocation] ([LocationCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_DoctorCode] FOREIGN KEY ([DoctorCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_DischargeRefferal_PatientAdmission_DischargeRefferalCode] FOREIGN KEY ([DischargeRefferalCode]) REFERENCES [dbo].[DischargeRefferal] ([DischargeRefferalCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_Discharged1By] FOREIGN KEY ([Discharged1By]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_DischargedBy] FOREIGN KEY ([DischargedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_Accounts_PatientAdmission_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PatientAdmission] ADD CONSTRAINT [FK_PatientAdmission_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PatientCatAllowedModule] ADD CONSTRAINT [FK_PatientCategory_PatientCategoryAllowedModule_PatientCatCode] FOREIGN KEY ([PatientCatCode]) REFERENCES [dbo].[PatientCategory] ([PatientCatCode]);
GO
ALTER TABLE [dbo].[PatientCatAllowedModule] ADD CONSTRAINT [FK_PatientModule_PatientCategoryAllowedModule_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[PatientModule] ([ModuleID]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_Users_PatientFirstContact_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_Users_PatientFirstContact_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_Patient_PatientFirstContact_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_PatientAdmission_PatientFirstContact_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_Doctors_PatientFirstContact_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PatientFirstContact] ADD CONSTRAINT [FK_PatientFirstContactOptions_PatientFirstContact_OptionCode] FOREIGN KEY ([OptionCode]) REFERENCES [dbo].[PatientFirstContactOptions] ([OptionCode]);
GO
ALTER TABLE [dbo].[PatientImage] ADD CONSTRAINT [PK_PatientAdmission_PatientImage_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PatientImage] ADD CONSTRAINT [PK_Visit_PatientImage_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[PatientImage] ADD CONSTRAINT [FK_Patient_PatientImage] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PatientLocation] ADD CONSTRAINT [FK_PatientLocation_WardCode] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[PatientModule] ADD CONSTRAINT [FK_Module_PatientModule_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[PatientRecServices] ADD CONSTRAINT [FK_Patient_PatientRecServices_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PatientRecServices] ADD CONSTRAINT [FK_Service_PatientRecServices_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[PatientRecServices] ADD CONSTRAINT [FK_SalesMan_PatientRecServices_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[PatientTransfer] ADD CONSTRAINT [FK_PatientTransfer_SourceLocation] FOREIGN KEY ([SourceLocation]) REFERENCES [dbo].[PatientLocation] ([LocationCode]);
GO
ALTER TABLE [dbo].[PatientTransfer] ADD CONSTRAINT [FK_PatientTransfer_TargetLocation] FOREIGN KEY ([TargetLocation]) REFERENCES [dbo].[PatientLocation] ([LocationCode]);
GO
ALTER TABLE [dbo].[PatientTransfer] ADD CONSTRAINT [FK_PatientTransfer_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PatientTransfer] ADD CONSTRAINT [FK_PatientTransfer_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PatientTransfer] ADD CONSTRAINT [DF_PatientTransfer_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PC] ADD CONSTRAINT [FK_Users_PC_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PC] ADD CONSTRAINT [FK_Users_PC_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PC] ADD CONSTRAINT [FK_Patient_PC_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PC] ADD CONSTRAINT [FK_PatientAdmission_PC_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PhysicalExam] ADD CONSTRAINT [FK_Organ_PhysicalExam_OrganCode] FOREIGN KEY ([OrganCode]) REFERENCES [dbo].[Organ] ([OrganCode]);
GO
ALTER TABLE [dbo].[POPolicyDetail] ADD CONSTRAINT [FK_POPolicy_POPolicyDetail_POPolicyCode] FOREIGN KEY ([POPolicyCode]) REFERENCES [dbo].[POPolicy] ([POPolicyCode]);
GO
ALTER TABLE [dbo].[POPolicyDetail] ADD CONSTRAINT [FK_WeekDays_POPolicyDetail_WeekDayCode] FOREIGN KEY ([WeekDayCode]) REFERENCES [dbo].[WeekDays] ([WeekDayCode]);
GO
ALTER TABLE [dbo].[POPolicyDetail] ADD CONSTRAINT [FK_WeekOfMonth_POPolicyDetail_WeekOfMonth] FOREIGN KEY ([WeekOfMonth]) REFERENCES [dbo].[WeekOfMonth] ([WeekOfMonth]);
GO
ALTER TABLE [dbo].[PRAllocationDetail] ADD CONSTRAINT [FK_PurLedger_PRAllocationDetail] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[PRAllocationDetail] ADD CONSTRAINT [FK_PRAllocationHeader_PRAllocationDetail] FOREIGN KEY ([PRAllocationCode]) REFERENCES [dbo].[PRAllocationHeader] ([PRAllocationCode]);
GO
ALTER TABLE [dbo].[PRAllocationHeader] ADD CONSTRAINT [FK_PRLedger_PRAllocationHeader] FOREIGN KEY ([PRInvCode]) REFERENCES [dbo].[PRLedger] ([PRInvCode]);
GO
ALTER TABLE [dbo].[PRAllocationHeader] ADD CONSTRAINT [FK_Users_PRAllocationHeader] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRAllocationHeader] ADD CONSTRAINT [FK_Users_PRAllocationHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRAllocationHeader] ADD CONSTRAINT [FK_Users_PRAllocationHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRdetail] ADD CONSTRAINT [PRDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PRdetail] ADD CONSTRAINT [PRDPRInvCodeFK] FOREIGN KEY ([PRInvCode]) REFERENCES [dbo].[PRLedger] ([PRInvCode]);
GO
ALTER TABLE [dbo].[PRdetail] ADD CONSTRAINT [PRGCodeFK] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Preferences] ADD CONSTRAINT [FK_PriceType_Preferences_IssuePriceTypeCode] FOREIGN KEY ([IssuePriceTypeCode]) REFERENCES [dbo].[PriceType] ([PriceTypeCode]);
GO
ALTER TABLE [dbo].[Preferences] ADD CONSTRAINT [FK_PriceType_Preferences_ReceiptPriceTypeCode] FOREIGN KEY ([ReceiptPriceTypeCode]) REFERENCES [dbo].[PriceType] ([PriceTypeCode]);
GO
ALTER TABLE [dbo].[PreferencesSubCategory] ADD CONSTRAINT [FK_PreferencesSubCategory_PreferencesCategory_CatCode] FOREIGN KEY ([CatCode]) REFERENCES [dbo].[PreferencesCategory] ([CatCode]);
GO
ALTER TABLE [dbo].[PreSaleDetail] ADD CONSTRAINT [FK_PreSaleDetail_PreSaleHeader_PreSaleInvCode] FOREIGN KEY ([PreSaleInvCode]) REFERENCES [dbo].[PreSaleHeader] ([PreSaleInvCode]);
GO
ALTER TABLE [dbo].[PreSaleDetail] ADD CONSTRAINT [FK_PreSaleDetail_PurLedger_PurInvCode] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[PreSaleDetail] ADD CONSTRAINT [FK_PreSaleDetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PreSaleDetail] ADD CONSTRAINT [FK_PreSaleDetail_Godown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[PreSaleHeader] ADD CONSTRAINT [FK_PreSaleHeader_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PreSaleHeader] ADD CONSTRAINT [FK_PreSaleHeader_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PreSaleHeader] ADD CONSTRAINT [FK_PreSaleHeader_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionDeleteDetail] ADD CONSTRAINT [FK_PrescriptionHeader_PrescriptionDeleteDetail] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[PrescriptionDeleteDetail] ADD CONSTRAINT [FK_Item_PrescriptionDeleteDetail] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PrescriptionDeleteDetail] ADD CONSTRAINT [FK_Dosage_PrescriptionDeleteDetail] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[PrescriptionDeleteDetail] ADD CONSTRAINT [FK_Route_PrescriptionDeleteDetail] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[PrescriptionDeleteDetail] ADD CONSTRAINT [FK_Instruction_PrescriptionDeleteDetail] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetail] ADD CONSTRAINT [FK_PrescriptionHeader_PrescriptionDetail] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetail] ADD CONSTRAINT [FK_Item_PrescriptionDetail] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PrescriptionDetail] ADD CONSTRAINT [FK_Dosage_PrescriptionDetail] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetail] ADD CONSTRAINT [FK_Route_PrescriptionDetail] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetail] ADD CONSTRAINT [FK_Instruction_PrescriptionDetail] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_Dosage_PrescriptionDetailLog] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_Route_PrescriptionDetailLog] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_Instruction_PrescriptionDetailLog] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_PrescriptionHeaderLog_PrescriptionDetailLog] FOREIGN KEY ([LogId]) REFERENCES [dbo].[PrescriptionHeaderLog] ([LogId]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_PrescriptionHeader_PrescriptionDetailLog_PresCode] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[PrescriptionDetailLog] ADD CONSTRAINT [FK_Item_PrescriptionDetailLog] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_Patient_PrescriptionHeader] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_PatientAdmission_PrescriptionHeader] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_Doctors_PrescriptionHeader] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_Users_PrescriptionHeader_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_Users_PrescriptionHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeader] ADD CONSTRAINT [FK_Users_PrescriptionHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_PrescriptionHeader_PrescriptionHeaderLog] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_Patient_PrescriptionHeaderLog] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_PatientAdmission_PrescriptionHeaderLog] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_Doctors_PrescriptionHeaderLog] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_Users_PrescriptionHeaderLog_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_Users_PrescriptionHeaderLog_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrescriptionHeaderLog] ADD CONSTRAINT [FK_Users_PrescriptionHeaderLog_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrevAbnormalLabs] ADD CONSTRAINT [FK_Patient_PrevAbnormalLabs_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[PrevAbnormalLabs] ADD CONSTRAINT [FK_PatientAdmission_PrevAbnormalLabs_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[PrevAbnormalLabs] ADD CONSTRAINT [FK_Users_PrevAbnormalLabs_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PrevAbnormalLabs] ADD CONSTRAINT [FK_Users_PrevAbnormalLabs_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PricePolicy] ADD CONSTRAINT [FK_Item_PricePolicyDetail_Icode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PricePolicyDetail] ADD CONSTRAINT [FK_PricePolicyDetail_PricePolicyCode] FOREIGN KEY ([PricePolicyCode]) REFERENCES [dbo].[PricePolicy] ([PricePolicyCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [FK_PRLedger_Customer_DataCarryCustCode] FOREIGN KEY ([DataCarryCustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRLPurInvCodeFK] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRLPostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRLPRCatCodeFK] FOREIGN KEY ([PRCatCode]) REFERENCES [dbo].[PurCategory] ([PurCatCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRLSalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRLSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [PRModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [FK_Accounts_PRLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [FK_Users_PRLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PRLedger] ADD CONSTRAINT [FK_PrLedger_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[ProdBuffer] ADD CONSTRAINT [FK_ProdBuffer_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ProdBuffer] ADD CONSTRAINT [FK_ProdBuffer_ProdHeader_ProdCode] FOREIGN KEY ([ProdCode]) REFERENCES [dbo].[ProdHeader] ([ProdCode]);
GO
ALTER TABLE [dbo].[ProdDetail] ADD CONSTRAINT [FK_ProdHeader_ProdDetail] FOREIGN KEY ([ProdCode]) REFERENCES [dbo].[ProdHeader] ([ProdCode]);
GO
ALTER TABLE [dbo].[ProdDetail] ADD CONSTRAINT [FK_Item_ProdDetail_Icode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_ProdHeader_Department_IssueDeptCode] FOREIGN KEY ([IssueDeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_ProdHeader_Department_ReceiptDeptCode] FOREIGN KEY ([ReceiptDeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Users_ProdHeader_FinalizedBy] FOREIGN KEY ([FinalizedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Godown_ProdHeader_IssueGCode] FOREIGN KEY ([IssueGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Godown_ProdHeader_ReceiptGCode] FOREIGN KEY ([ReceiptGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Users_ProdHeader_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Users_ProdHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_Users_ProdHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_IssueHeader_ProdHeader] FOREIGN KEY ([IssueInvCode]) REFERENCES [dbo].[IssueHeader] ([IssueInvCode]);
GO
ALTER TABLE [dbo].[ProdHeader] ADD CONSTRAINT [FK_ReceiptHeader_ProdHeader] FOREIGN KEY ([ReceiptInvCode]) REFERENCES [dbo].[ReceiptHeader] ([ReceiptInvCode]);
GO
ALTER TABLE [dbo].[ProdNote] ADD CONSTRAINT [FK_ProdNote_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdNote] ADD CONSTRAINT [FK_ProdNote_Department_IssueDeptCode] FOREIGN KEY ([IssueDeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ProdNote] ADD CONSTRAINT [FK_ProdNote_Department_ReceiptDeptCode] FOREIGN KEY ([ReceiptDeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ProdNote] ADD CONSTRAINT [FK_ProdNote_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProdNoteIssue] ADD CONSTRAINT [FK_ProdNoteIssue_ProdNote_ProdNoteCode] FOREIGN KEY ([ProdNoteCode]) REFERENCES [dbo].[ProdNote] ([ProdNoteCode]);
GO
ALTER TABLE [dbo].[ProdNoteIssue] ADD CONSTRAINT [FK_ProdNoteIssue_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ProdNoteIssue] ADD CONSTRAINT [FK_ProdNoteIssue_Godown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ProdNoteReceipt] ADD CONSTRAINT [FK_ProdNoteReceipt_ProdNote_ProdNoteCode] FOREIGN KEY ([ProdNoteCode]) REFERENCES [dbo].[ProdNote] ([ProdNoteCode]);
GO
ALTER TABLE [dbo].[ProdNoteReceipt] ADD CONSTRAINT [FK_ProdNoteReceipt_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ProdNoteReceipt] ADD CONSTRAINT [FK_ProdNoteReceipt_Godown_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Model_ModelCode] FOREIGN KEY ([ModelCode]) REFERENCES [dbo].[Model] ([ModelCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_ProductPurpose_ProductPurposeCode] FOREIGN KEY ([ProductPurposeCode]) REFERENCES [dbo].[ProductPurpose] ([ProductPurposeCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_ProductType_ProductTypeCode] FOREIGN KEY ([ProductTypeCode]) REFERENCES [dbo].[ProductType] ([ProductTypeCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_ItemColour_IColourCode] FOREIGN KEY ([IColourCode]) REFERENCES [dbo].[ItemColour] ([IColourCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Users_DeliveredBy] FOREIGN KEY ([DeliveredBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Users_SoldBy] FOREIGN KEY ([SoldBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Users_FinalizedBy] FOREIGN KEY ([FinalizedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Supplier_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Users_AquiredBy] FOREIGN KEY ([AquiredBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [FK_Product_SalesMan_SalesManCode] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ProformaPurDetail] ADD CONSTRAINT [FK_ProformaPurdetail_Godown_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ProformaPurDetail] ADD CONSTRAINT [FK_ProformaPurdetail_ICode_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ProformaPurDetail] ADD CONSTRAINT [FK_ProformaPurdetail_PurLedger_PurInvCode] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[ProspectiveCustomer] ADD CONSTRAINT [FK_SubArea_ProspectiveCustomer] FOREIGN KEY ([SubAreaCode]) REFERENCES [dbo].[SubArea] ([SubAreaCode]);
GO
ALTER TABLE [dbo].[ProspectiveCustomer] ADD CONSTRAINT [FK_CustomerCategory_ProspectiveCustomer] FOREIGN KEY ([CustCatCode]) REFERENCES [dbo].[CustomerCategory] ([CustCatCode]);
GO
ALTER TABLE [dbo].[ProspectiveCustomer] ADD CONSTRAINT [FK_Message_ProspectiveCustomer] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[ProspectiveCustomer] ADD CONSTRAINT [FK_SalesMan_ProspectiveCustomer] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ProspectiveCustomer] ADD CONSTRAINT [FK_Area_ProspectiveCustomer] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[ProvDiag] ADD CONSTRAINT [FK_Patient_ProvDiag_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ProvDiag] ADD CONSTRAINT [FK_PatientAdmission_ProvDiag_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ProvDiag] ADD CONSTRAINT [FK_Users_ProvDiag_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ProvDiag] ADD CONSTRAINT [FK_Users_ProvDiag_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[PurchaseDocument] ADD CONSTRAINT [FK_PurchaseDocument_PurLedger_PurInvCode] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [PDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [PDGCodeFK] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [FK_puredetail_manfcodeforitem] FOREIGN KEY ([ManfCodeForItem]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [FK_PurDetailDetail_LockReason_LockReasonCode] FOREIGN KEY ([LockReasonCode]) REFERENCES [dbo].[LockReason] ([LockReasonCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [PDPurInvCode_Fk] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [FK_PurDetail_SalesTaxSchedule_SalesTaxScheduleCode] FOREIGN KEY ([SalesTaxScheduleCode]) REFERENCES [dbo].[SalesTaxSchedule] ([SalesTaxScheduleCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [FK_PurDetail_PCT_PCTCode] FOREIGN KEY ([PCTCode]) REFERENCES [dbo].[PCT] ([PCTCode]);
GO
ALTER TABLE [dbo].[Purdetail] ADD CONSTRAINT [FK_PurDetail_ItemAlert_ItemAlertCode] FOREIGN KEY ([ItemAlertCode]) REFERENCES [dbo].[ItemAlert] ([ItemAlertCode]);
GO
ALTER TABLE [dbo].[PurdetailMod] ADD CONSTRAINT [FK_Manufacturer_PurdetailMod_manfcodeforitem] FOREIGN KEY ([ManfCodeForItem]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[PurdetailMod] ADD CONSTRAINT [FK_Godown_PurdetailMod_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[PurdetailMod] ADD CONSTRAINT [FK_Item_PurdetailMod_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PurdetailMod] ADD CONSTRAINT [FK_PurLedgerMod_PurdetailMod_PurInvCode] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[PurledgerMod] ([PurInvCode]);
GO
ALTER TABLE [dbo].[PurExp] ADD CONSTRAINT [FK_PurLedger_PurExp_PurInvCode] FOREIGN KEY ([PurInvCode]) REFERENCES [dbo].[Purledger] ([PurInvCode]);
GO
ALTER TABLE [dbo].[PurExp] ADD CONSTRAINT [FK_Accounts_PurExp_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_GoodsCompany_PurLedger] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_PurLedger_TaxCategory_TaxCategoryCode] FOREIGN KEY ([TaxCategoryCode]) REFERENCES [dbo].[TaxCategory] ([TaxCategoryCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_PurLedger_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_PurLedger_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_Purledger_PurchaseType] FOREIGN KEY ([purtypecode]) REFERENCES [dbo].[PurchaseType] ([PurTypeCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [PLCatCodeFK] FOREIGN KEY ([PurCatCode]) REFERENCES [dbo].[PurCategory] ([PurCatCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [PLModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [PLPostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [PLSalesManCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [PLSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_Currency_PurLedger_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_Accounts_PurLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_Users_PurLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Purledger] ADD CONSTRAINT [FK_PurLedger_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Accounts_PurledgerMod_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Currency_PurledgerMod_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_GoodsCompany_PurledgerMod_GCCode] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Customer_PurledgerMod_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_User_PurledgerMod_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_PurchaseType_PurledgerMod_purtypecode] FOREIGN KEY ([purtypecode]) REFERENCES [dbo].[PurchaseType] ([PurTypeCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Users_PurledgerMod_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Users_PurledgerMod_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_PurCategory_PurLedgerMod_PurCatCode] FOREIGN KEY ([PurCatCode]) REFERENCES [dbo].[PurCategory] ([PurCatCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Users_PurLedgerMod_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Users_PurLedgerMod_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Users_PurLedgerMod_SalesManCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurledgerMod] ADD CONSTRAINT [FK_Supplier_PurLedgerMod_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[PurOrderDetail] ADD CONSTRAINT [PODICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PurOrderDetail] ADD CONSTRAINT [PODPOCodeFK] FOREIGN KEY ([POCode]) REFERENCES [dbo].[PurOrderHeader] ([POCode]);
GO
ALTER TABLE [dbo].[PurOrderDetail] ADD CONSTRAINT [FK_PurOrderDetail_ItemAlert_ItemAlertCode] FOREIGN KEY ([ItemAlertCode]) REFERENCES [dbo].[ItemAlert] ([ItemAlertCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [POHSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_PurOrderHeader_PurOrderCategory] FOREIGN KEY ([PurOrderCatCode]) REFERENCES [dbo].[PurOrderCategory] ([PurOrderCatCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_Currency_PurOrderHeader_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_PurOrderHeader_Customer] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_SaleOrderHeader_PurOrderHeader] FOREIGN KEY ([SaleOrderCode]) REFERENCES [dbo].[SaleOrderHeader] ([SaleOrderCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [POHManfCodeFK] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_PurQuotationHeader_PurOrderHeader_PurQuotationCode] FOREIGN KEY ([PurQuotationCode]) REFERENCES [dbo].[PurQuotationHeader] ([PurQuotationCode]);
GO
ALTER TABLE [dbo].[PurOrderHeader] ADD CONSTRAINT [FK_PurOrderHeader_Users] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurPayment] ADD CONSTRAINT [FK_PurPayment_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurPayment] ADD CONSTRAINT [FK_PurPayment_Accounts_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PurPayment] ADD CONSTRAINT [FK_PurPayment_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurPayment] ADD CONSTRAINT [FK_PurPayment_Accounts_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PurPayment] ADD CONSTRAINT [FK_PurPayment_Accounts_WHTaxAccCode] FOREIGN KEY ([WHTaxAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[PurQuotationDetail] ADD CONSTRAINT [FK__PurQuotat__PurQu__0020D2BF] FOREIGN KEY ([PurQuotationCode]) REFERENCES [dbo].[PurQuotationHeader] ([PurQuotationCode]);
GO
ALTER TABLE [dbo].[PurQuotationDetail] ADD CONSTRAINT [FK_Item_PurQuotationDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[PurQuotationDetail] ADD CONSTRAINT [FK_Godown_PurQuotationDetail_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[PurQuotationHeader] ADD CONSTRAINT [FK_Supplier_PurQuotationHeader_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[PurQuotationHeader] ADD CONSTRAINT [FK_Users_PurQuotationHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurQuotationHeader] ADD CONSTRAINT [FK_Users_PurQuotationHeader_PostedBY] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurQuotationHeader] ADD CONSTRAINT [FK_Users_PurQuotationHeader_ModifiedBY] FOREIGN KEY ([ModifiedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurRegister] ADD CONSTRAINT [FK_Supplier_PurRegister_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[PurRegister] ADD CONSTRAINT [FK_Users_PurRegister_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurRegister] ADD CONSTRAINT [FK_Area_PurRegister_AreaCode] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[PurRegister] ADD CONSTRAINT [FK_ItemCategory_PurRegister_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[PurRegister] ADD CONSTRAINT [FK_Users_PurRegister_PostedBy] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[PurRegisterDetail] ADD CONSTRAINT [FK_PurRegister_PurRegisterDetail_PurRegisterCode] FOREIGN KEY ([PurRegisterCode]) REFERENCES [dbo].[PurRegister] ([PurRegisterCode]);
GO
ALTER TABLE [dbo].[PurRegisterDetail] ADD CONSTRAINT [FK_Item_PurRegisterDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[QualifiedPerson] ADD CONSTRAINT [FK_Users_QualifiedPerson_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[QualifiedPersonImage] ADD CONSTRAINT [FK_QualifiedPersonImage_QualifiedPerson_QualifiedPersonCode] FOREIGN KEY ([QualifiedPersonCode]) REFERENCES [dbo].[QualifiedPerson] ([QualifiedPersonCode]);
GO
ALTER TABLE [dbo].[QuotationDetail] ADD CONSTRAINT [QDIcodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[QuotationDetail] ADD CONSTRAINT [QDQuotationCodeFK] FOREIGN KEY ([QuotationCode]) REFERENCES [dbo].[QuotationHeader] ([QuotationCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [QHCustomer_FK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [QHModifyBy_FK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [QHPostedBy_FK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [QHSalesmanFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [FK_Message_QuotationHeader] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[QuotationHeader] ADD CONSTRAINT [FK_SalesMan_QuotationHeader_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ReceiptCategoryAccounts] ADD CONSTRAINT [FK_ReceiptCategoryAccounts_ReceiptCategory_ReceiptCategoryCode] FOREIGN KEY ([ReceiptCategoryCode]) REFERENCES [dbo].[ReceiptCategory] ([ReceiptCategoryCode]);
GO
ALTER TABLE [dbo].[ReceiptCategoryAccounts] ADD CONSTRAINT [FK_ReceiptCategoryAccounts_SubAccounts_SubAccCode] FOREIGN KEY ([SubAccCode]) REFERENCES [dbo].[SubAccounts] ([SubAccCode]);
GO
ALTER TABLE [dbo].[ReceiptDetail] ADD CONSTRAINT [FK_Section_ReceiptDetail] FOREIGN KEY ([SectCode]) REFERENCES [dbo].[Section] ([SectCode]);
GO
ALTER TABLE [dbo].[ReceiptDetail] ADD CONSTRAINT [REDGCodeFK] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[ReceiptDetail] ADD CONSTRAINT [REDReceiptinvCodeFK] FOREIGN KEY ([ReceiptInvCode]) REFERENCES [dbo].[ReceiptHeader] ([ReceiptInvCode]);
GO
ALTER TABLE [dbo].[ReceiptDetail] ADD CONSTRAINT [REDIcodeFK] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_ReceiptHeader_WorkOrderCode] FOREIGN KEY ([WorkOrderCode]) REFERENCES [dbo].[WorkOrder] ([WorkOrderCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [ReDeptCodeFk] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [RESalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_Accounts_ReceiptHeader_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_SalesMan_ReceiptHeader_RecipientSalesMan] FOREIGN KEY ([RecipientSalesMan]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_Recipient_ReceiptHeader_RecipientCode] FOREIGN KEY ([RecipientCode]) REFERENCES [dbo].[Recipient] ([RecipientCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_ReceiptHeader_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_ReceiptHeader_ReceiptCategory_ReceiptCategoryCode] FOREIGN KEY ([ReceiptCategoryCode]) REFERENCES [dbo].[ReceiptCategory] ([ReceiptCategoryCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_ReceiptHeader_Accounts_CrAccCode] FOREIGN KEY ([CrAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_Area_ReceiptHeader] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_Salesman_ReceiptHeader] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ReceiptHeader] ADD CONSTRAINT [FK_PriceType_ReceiptHeader_PriceTypeCode] FOREIGN KEY ([PriceTypeCode]) REFERENCES [dbo].[PriceType] ([PriceTypeCode]);
GO
ALTER TABLE [dbo].[Recipe] ADD CONSTRAINT [FK_Item_Recipe_ResultedItem] FOREIGN KEY ([ResultedItem]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[Recipe] ADD CONSTRAINT [FK_Users_Recipe_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[RecipeDetail] ADD CONSTRAINT [FK_Recipe_RecipeDetail_RecipeCode] FOREIGN KEY ([RecipeCode]) REFERENCES [dbo].[Recipe] ([RecipeCode]);
GO
ALTER TABLE [dbo].[RecipeDetail] ADD CONSTRAINT [FK_Item_RecipeDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[RefusedSaleDetail] ADD CONSTRAINT [FK_RefusedSaleHeader_RefusedSaleDetail] FOREIGN KEY ([RefusedSaleInvCode]) REFERENCES [dbo].[RefusedSaleHeader] ([RefusedSaleInvCode]);
GO
ALTER TABLE [dbo].[RefusedSaleDetail] ADD CONSTRAINT [FK_SaleRefusalReason_ReasonCode_ReasonCode] FOREIGN KEY ([ReasonCode]) REFERENCES [dbo].[SaleRefusalReason] ([ReasonCode]);
GO
ALTER TABLE [dbo].[RefusedSaleDetail] ADD CONSTRAINT [FK_Item_RefusedSaleDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[RefusedSaleHeader] ADD CONSTRAINT [FK_SaleLedger_RefusedSaleHeader_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[RefusedSaleHeader] ADD CONSTRAINT [FK_Users_RefusedSaleHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Resource] ADD CONSTRAINT [FK_ResourceCategory_Resource_ResourceCatCode] FOREIGN KEY ([ResourceCatCode]) REFERENCES [dbo].[ResourceCategory] ([ResourceCatCode]);
GO
ALTER TABLE [dbo].[Rights] ADD CONSTRAINT [FK_Rights_RightsCategory] FOREIGN KEY ([RightCatCode]) REFERENCES [dbo].[RightsCategory] ([RightCatCode]);
GO
ALTER TABLE [dbo].[Rightsclone] ADD CONSTRAINT [FK_RightsClone_RightsCategory] FOREIGN KEY ([RightCatCode]) REFERENCES [dbo].[RightsCategory] ([RightCatCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [SDGCodeFK] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [FK_SaleDetail_Instruction_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [FK_SaleDetail_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [SDICodeFk] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [SDSaleInvCodeFK] FOREIGN KEY ([SaleInvcode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [FK_SaleDetail_ItemMeter_ItemMeterCode] FOREIGN KEY ([ItemMeterCode]) REFERENCES [dbo].[ItemMeter] ([ItemMeterCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [FK_SaleDetail_DosageUnit_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[Saledetail] ADD CONSTRAINT [FK_SaleDetail_Dosage_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_Instruction_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_ItemMeter_ItemMeterCode] FOREIGN KEY ([ItemMeterCode]) REFERENCES [dbo].[ItemMeter] ([ItemMeterCode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaledetailDump] ADD CONSTRAINT [FK_SaledetailDump_SaleInvCode] FOREIGN KEY ([SaleInvcode]) REFERENCES [dbo].[SaleLedgerDump] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleDetailLog_ItemMeter_ItemMeterCode] FOREIGN KEY ([ItemMeterCode]) REFERENCES [dbo].[ItemMeter] ([ItemMeterCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_GCode_SaleDetailLog] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_ICode_SaleDetailLog] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleLedgerLogID_SaleDetailLog] FOREIGN KEY ([SaleLedgerLogID]) REFERENCES [dbo].[SaleLedgerLog] ([SaleLedgerLogID]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleInvCode_SaleDetailLog] FOREIGN KEY ([SaleInvcode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleDetailLog_Instruction_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleDetailLog_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleDetailLog_DosageUnit_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[SaledetailLog] ADD CONSTRAINT [FK_SaleDetailLog_Dosage_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[SaleDetailModified] ADD CONSTRAINT [FK_Godown_SaleDetailModified] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SaleDetailModified] ADD CONSTRAINT [FK_Item_SaleDetailModified] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleDetailModified] ADD CONSTRAINT [FK_SaleLedgerModified_SaleDetailModified] FOREIGN KEY ([SaleInvcode]) REFERENCES [dbo].[SaleLedgerModified] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleDocument] ADD CONSTRAINT [FK_SaleDocument_SaleLedger_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleInvDetail] ADD CONSTRAINT [FK_SaleInvDetail_DescICode] FOREIGN KEY ([DescICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleInvDetail] ADD CONSTRAINT [FK_SaleLedger_SaleInvDetail_SourceSaleInvcode] FOREIGN KEY ([SourceSaleInvcode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleInvDetail] ADD CONSTRAINT [FK_SaleLedger_SaleInvDetail_SaleInvCode] FOREIGN KEY ([SaleInvcode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleInvDetail] ADD CONSTRAINT [FK_Item_SaleInvDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleInvDetail] ADD CONSTRAINT [FK_Godown_SaleInvDetail_GCode] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SaleInvGroup] ADD CONSTRAINT [FK_Users_SaleInvGroup_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleInvGroupDetail] ADD CONSTRAINT [FK_SaleInvGroup_SaleInvGroupDetail_SaleInvGroupCode] FOREIGN KEY ([SaleInvGroupCode]) REFERENCES [dbo].[SaleInvGroup] ([SaleInvGroupCode]);
GO
ALTER TABLE [dbo].[SaleInvGroupDetail] ADD CONSTRAINT [FK_SaleLedger_SaleInvGroupDetail_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_ProspectiveCustomer_SaleLedger] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_GoodsCompany_SaleLedger] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_PrescriptionHeader_SaleLedger] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_deliveredby] FOREIGN KEY ([deliveredby]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Relation_SaleLedger] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Disease_SaleLedger] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Ward_SaleLedger] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleType_SaleLedger] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleOrderHeader_SaleLedger] FOREIGN KEY ([SaleOrderCode]) REFERENCES [dbo].[SaleOrderHeader] ([SaleOrderCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_SaleLedger_RecurringAgainst] FOREIGN KEY ([RecurringAgainst]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_ContactCardCode] FOREIGN KEY ([ContactCardCode]) REFERENCES [dbo].[ContactCard] ([ContactCardCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_PatientAdmission] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Accounts_SaleLedger_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_GuaranteePerson_SaleLedger_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Visit_SaleLedger_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_SRBufferLedger_SRBufferInvCode] FOREIGN KEY ([SRBufferInvCode]) REFERENCES [dbo].[SRBufferLedger] ([SRBufferInvCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Guest_SaleLedger_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_GuestCheckIn_SaleLedger_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Student_SaleLedger_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_SaleLedger_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLSalesManCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLMessageCode_FK] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLSManCode_FK] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Accounts_SaleLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [FK_Users_SaleLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SaleLedgerPatientCodeFK] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLDoctCodeFK] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLPostedByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedger] ADD CONSTRAINT [SLSaleCatCodeFK] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Disease_SaleLedgerDump] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_GoodsCompany_SaleLedgerDump] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_GuaranteePerson_SaleLedgerDump_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Guest_SaleLedgerDump_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_ProspectiveCustomer_SaleLedgerDump] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Relation_SaleLedgerDump] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_deliveredby] FOREIGN KEY ([deliveredby]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleType_SaleLedgerDump] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Student_SaleLedgerDump_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Users_SaleLedgerDump_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Visit_SaleLedgerDump_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Ward_SaleLedgerDump] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_SaleCatCode] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_SalesManCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_SaleLedgerDump_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Accounts_SaleLedgerDump_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedgerDump] ADD CONSTRAINT [FK_Accounts_SaleLedgerDump_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_ProspectiveCustomer_SaleLedgerLog] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_GoodsCompany_SaleLedgerLog] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Student_SaleLedgerLog_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_PrescriptionHeader_SaleLedgerLog] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_deliveredby] FOREIGN KEY ([deliveredby]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleType_SaleLedgerLog] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleOrderHeader_SaleLedgerLog] FOREIGN KEY ([SaleOrderCode]) REFERENCES [dbo].[SaleOrderHeader] ([SaleOrderCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_ContactCardCode] FOREIGN KEY ([ContactCardCode]) REFERENCES [dbo].[ContactCard] ([ContactCardCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedger_SaleLedgerLog_RecurringAgainst] FOREIGN KEY ([RecurringAgainst]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Accounts_SaleLedgerLog_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_GuaranteePerson_SaleLedgerLog_GuaranteePersonCode] FOREIGN KEY ([GuaranteePersonCode]) REFERENCES [dbo].[GuaranteePerson] ([GuaranteePersonCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Visit_SaleLedgerLog_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_SRBufferLedger_SRBufferInvCode] FOREIGN KEY ([SRBufferInvCode]) REFERENCES [dbo].[SRBufferLedger] ([SRBufferInvCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Guest_SaleLedgerLog_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_GuestCheckIn_SaleLedgerLog_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleinvCode_SaleLedgerLog] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_DiseaseCode_SaleLedgerLog] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_RelationCode_SaleLedgerLog] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_AdmissionCode_SaleLedgerLog] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_WardCode_SaleLedgerLog] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_CustCode_SaleLedgerLog] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_DoctCode_SaleLedgerLog] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_MessageCode_SaleLedgerLog] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_ModifiedBy_SaleLedgerLog] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_PatientCode_SaleLedgerLog] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_PostedBy_SaleLedgerLog] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleCatCode_SaleLedgerLog] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SalesManCode_SaleLedgerLog] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SmanCode_SaleLedgerLog] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_SaleLedgerLog_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Accounts_SaleLedgerLog_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleLedgerLog] ADD CONSTRAINT [FK_Users_SaleLedgerLog_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Doctors_SaleLedgerModified] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Message_SaleLedgerModified] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_UsersModifiedBy_SaleLedgerModified] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_UsersPostedBy_SaleLedgerModified] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_SaleCategory_SaleLedgerModified] FOREIGN KEY ([SaleCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_UsersSalesmancode_SaleLedgerModified] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_SalesMan_SaleLedgerModified] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_SaleLedgerModified_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Disease_SaleLedgerModified] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Relation_SaleLedgerModified] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_PatientAdmission_SaleLedgerModified] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Ward_SaleLedgerModified] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Patient_SaleLedgerModified] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_Customer_SaleLedgerModified] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SaleLedgerModified] ADD CONSTRAINT [FK_saleledgermodified_SaleTypeCode] FOREIGN KEY ([SaleTypeCode]) REFERENCES [dbo].[SaleType] ([SaleTypeCode]);
GO
ALTER TABLE [dbo].[SaleOrderDetail] ADD CONSTRAINT [FK_Godown_SaleOrderDetail] FOREIGN KEY ([GCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SaleOrderDetail] ADD CONSTRAINT [FK_SaleOrderItemStatus_SaleOrderDetail] FOREIGN KEY ([SaleOrderItemStatusCode]) REFERENCES [dbo].[SaleOrderItemStatus] ([SaleOrderItemStatusCode]);
GO
ALTER TABLE [dbo].[SaleOrderDetail] ADD CONSTRAINT [FK_SaleOrderHeader_SaleOrderDetail] FOREIGN KEY ([SaleOrderCode]) REFERENCES [dbo].[SaleOrderHeader] ([SaleOrderCode]);
GO
ALTER TABLE [dbo].[SaleOrderDetail] ADD CONSTRAINT [FK_Item_SaleOrderDetail] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_SaleOrderHeader_Section_SectCode] FOREIGN KEY ([SectCode]) REFERENCES [dbo].[Section] ([SectCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_PrescriptionHeader_SaleOrderHeader_PresCode] FOREIGN KEY ([PresCode]) REFERENCES [dbo].[PrescriptionHeader] ([PresCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_GoodsCompany_SaleOrderHeader] FOREIGN KEY ([GCCode]) REFERENCES [dbo].[GoodsCompany] ([GCCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Quotation_SaleOrderHeader] FOREIGN KEY ([QuotationCode]) REFERENCES [dbo].[QuotationHeader] ([QuotationCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Users_SaleOrderHeader_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_SaleOrderHeader_Deliveredby] FOREIGN KEY ([DeliveredBy]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_ProspectiveCustomer_SaleOrderHeader] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_SaleOrderHeader_Patient_CustSiteCode] FOREIGN KEY ([CustSiteCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Customer_SaleOrderHeader] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Users_SaleOrderHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Users_SaleOrderHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Users_SaleOrderHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Doctors_SaleOrderHeader] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Patient_SaleOrderHeader] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Message_SaleOrderHeader] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_SalesMan_SaleOrderHeader_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Relation_SaleOrderHeader] FOREIGN KEY ([RelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Disease_SaleOrderHeader] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Ward_SaleOrderHeader] FOREIGN KEY ([WardCode]) REFERENCES [dbo].[Ward] ([WardCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_Accounts_SaleOrderHeader_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleOrderHeader] ADD CONSTRAINT [FK_SaleOrderCategory_SaleOrderHeader_SOCatCode] FOREIGN KEY ([SOCatCode]) REFERENCES [dbo].[SaleOrderCategory] ([SOCatCode]);
GO
ALTER TABLE [dbo].[SalePromotion] ADD CONSTRAINT [FK_SalePromotion_CustomerGroupCode] FOREIGN KEY ([CustomerGroupCode]) REFERENCES [dbo].[CustomerGroup] ([CustomerGroupCode]);
GO
ALTER TABLE [dbo].[SaleReceivableAdj] ADD CONSTRAINT [FK_SaleLedger_SaleReceivableAdj] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleReceivableAdj] ADD CONSTRAINT [FK_Accounts_SaleReceivableAdj] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SaleSetsDetail] ADD CONSTRAINT [FK_SaleSetsHeader_SaleSetsDetail_SetCode] FOREIGN KEY ([SetCode]) REFERENCES [dbo].[SaleSetsHeader] ([SetCode]);
GO
ALTER TABLE [dbo].[SaleSetsDetail] ADD CONSTRAINT [FK_Item_SaleSetsDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleSetsHeader] ADD CONSTRAINT [FK_SaleLedger_SaleSetsHeader] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SaleSetsHeader] ADD CONSTRAINT [FK_Item_SaleSetsHeader_SetICode] FOREIGN KEY ([SetICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleSetsHeader] ADD CONSTRAINT [FK_Receipe_SaleSetsHeader_RecipeCode] FOREIGN KEY ([RecipeCode]) REFERENCES [dbo].[Recipe] ([RecipeCode]);
GO
ALTER TABLE [dbo].[SaleSetsOrigDetail] ADD CONSTRAINT [FK_SaleSetsHeader_SaleSetsOrigDetail_SetCode] FOREIGN KEY ([SetCode]) REFERENCES [dbo].[SaleSetsHeader] ([SetCode]);
GO
ALTER TABLE [dbo].[SaleSetsOrigDetail] ADD CONSTRAINT [FK_Item_SaleSetsOrigDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SalesManScope] ADD CONSTRAINT [FK_SalesManScope_SalesMan_SalesManCode] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SalesManScope] ADD CONSTRAINT [FK_SalesManScope_Manufacturer_ManfCode] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[SalesManScope] ADD CONSTRAINT [FK_SalesManScope_SubArea_SubAreaCode] FOREIGN KEY ([SubAreaCode]) REFERENCES [dbo].[SubArea] ([SubAreaCode]);
GO
ALTER TABLE [dbo].[SalesManScope] ADD CONSTRAINT [FK_SalesManScope_WeekDays_WeekDayCode] FOREIGN KEY ([WeekDayCode]) REFERENCES [dbo].[WeekDays] ([WeekDayCode]);
GO
ALTER TABLE [dbo].[SalesTeam] ADD CONSTRAINT [FK_Manufacturer_SalesTeam] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[SalesTeamMember] ADD CONSTRAINT [FK_SalesMan_SalesTeamMember] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SaleTemplateDetail] ADD CONSTRAINT [FK_Item_SaleTemplateDetail_ICode] FOREIGN KEY ([icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SaleTemplateDetail] ADD CONSTRAINT [STSaleTemplateCodeFK] FOREIGN KEY ([SaleTemplateCode]) REFERENCES [dbo].[SaleTemplateHeader] ([SaleTemplateCode]);
GO
ALTER TABLE [dbo].[SampleDetail] ADD CONSTRAINT [FK_Samples_SampleDetail_SampleCode] FOREIGN KEY ([SampleCode]) REFERENCES [dbo].[Samples] ([SampleCode]);
GO
ALTER TABLE [dbo].[SampleDetail] ADD CONSTRAINT [FK_SampleType_SampleDetail] FOREIGN KEY ([SampleTypeCode]) REFERENCES [dbo].[SampleType] ([SampleTypeCode]);
GO
ALTER TABLE [dbo].[SampleDetail] ADD CONSTRAINT [FK_ServiceDetail_SampleDetail_ServiceRowID] FOREIGN KEY ([ServiceRowID]) REFERENCES [dbo].[ServiceDetail] ([SrvRowId]);
GO
ALTER TABLE [dbo].[Samples] ADD CONSTRAINT [FK_ServiceHeader_Samples_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[Samples] ADD CONSTRAINT [FK_Users_Samples_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Samples] ADD CONSTRAINT [FK_Users_Samples_PostedBy] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Samples] ADD CONSTRAINT [FK_Users_Samples_ProcessedBy] FOREIGN KEY ([ProcessedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SchoolLeaving] ADD CONSTRAINT [FK_Student_SchoolLeaving_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SchoolLeaving] ADD CONSTRAINT [FK_Class_SchoolLeaving_ClassCode] FOREIGN KEY ([ClassCode]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[SchoolLeaving] ADD CONSTRAINT [FK_Users_SchoolLeaving_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SE] ADD CONSTRAINT [FK_Users_SE_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SE] ADD CONSTRAINT [FK_Users_SE_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SE] ADD CONSTRAINT [FK_Patient_SE_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SE] ADD CONSTRAINT [FK_PatientAdmission_SE_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[Section] ADD CONSTRAINT [FK_Section_DeptCode] FOREIGN KEY ([Deptcode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[Service] ADD CONSTRAINT [FK_ServiceType_Service] FOREIGN KEY ([ServiceTypeCode]) REFERENCES [dbo].[ServiceType] ([ServiceTypeCode]);
GO
ALTER TABLE [dbo].[Service] ADD CONSTRAINT [FK_ServicePricePolicy_Service] FOREIGN KEY ([ServicePricePolicyCode]) REFERENCES [dbo].[ServicePricePolicy] ([ServicePricePolicyCode]);
GO
ALTER TABLE [dbo].[Service] ADD CONSTRAINT [FK_ServiceCategory_Service_ServiceCatCode] FOREIGN KEY ([ServiceCatCode]) REFERENCES [dbo].[ServiceCategory] ([ServiceCatCode]);
GO
ALTER TABLE [dbo].[Service] ADD CONSTRAINT [FK_Service_PCT_PCTCode] FOREIGN KEY ([PCTCode]) REFERENCES [dbo].[PCT] ([PCTCode]);
GO
ALTER TABLE [dbo].[Service] ADD CONSTRAINT [FK_ServiceResultStyle_Service] FOREIGN KEY ([ServiceResultStyleCode]) REFERENCES [dbo].[ServiceResultStyle] ([ServiceResultStyleCode]);
GO
ALTER TABLE [dbo].[ServiceBreakUp] ADD CONSTRAINT [FK_Service_ServiceBreakUp] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceBreakUp] ADD CONSTRAINT [FK_ServiceComponent_ServiceBreakUp] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceComponent] ADD CONSTRAINT [FK_ServiceComponentType_ServiceComponent_ServiceComponentTypeCode] FOREIGN KEY ([ServiceComponentTypeCode]) REFERENCES [dbo].[ServiceComponentType] ([ServiceComponentTypeCode]);
GO
ALTER TABLE [dbo].[ServiceComponent] ADD CONSTRAINT [FK_ServiceComponentUnit_ServiceComponent_ServiceComponentUnitCode] FOREIGN KEY ([ServiceComponentUnitCode]) REFERENCES [dbo].[ServiceComponentUnit] ([ServiceComponentUnitCode]);
GO
ALTER TABLE [dbo].[ServiceComponentComment] ADD CONSTRAINT [FK_ServiceComponent_ServiceComponentComment_ServiceComponentCode] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceComponentOption] ADD CONSTRAINT [FK_ServiceComponent_ServiceComponentOption_ServiceComponentCode] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceComponentRefValue] ADD CONSTRAINT [FK_TestMachine_ServiceComponentRefValue_TestMachineCode] FOREIGN KEY ([TestMachineCode]) REFERENCES [dbo].[TestMachine] ([TestMachineCode]);
GO
ALTER TABLE [dbo].[ServiceComponentRefValue] ADD CONSTRAINT [FK_Gestation_ServiceComponentRefValue_GestationCode] FOREIGN KEY ([GestationCode]) REFERENCES [dbo].[Gestation] ([GestationCode]);
GO
ALTER TABLE [dbo].[ServiceComponentRefValue] ADD CONSTRAINT [FK_ServiceComponent_ServiceComponentRefValue_ServiceComponentCode] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleDetail] ADD CONSTRAINT [FK_ServiceComponentSaleHeader_ServiceComponentSaleDetail_SvcCompSaleInvCode] FOREIGN KEY ([SvcCompSaleInvCode]) REFERENCES [dbo].[ServiceComponentSaleHeader] ([SvcCompSaleInvCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleDetail] ADD CONSTRAINT [FK_ServiceComponent_ServiceComponentSaleDetail_ServiceComponentCode] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleDetail] ADD CONSTRAINT [FK_ServiceComponentUnit_ServiceComponentSaleDetail_ServiceComponentUnitCode] FOREIGN KEY ([ServiceComponentUnitCode]) REFERENCES [dbo].[ServiceComponentUnit] ([ServiceComponentUnitCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleHeader] ADD CONSTRAINT [FK_Users_ServiceComponentSaleHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleHeader] ADD CONSTRAINT [FK_Samples_ServiceComponentSaleHeader_SampleCode] FOREIGN KEY ([SampleCode]) REFERENCES [dbo].[Samples] ([SampleCode]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleHeader] ADD CONSTRAINT [FK_ServiceDetail_ServiceComponentSaleHeader_ServiceRowID] FOREIGN KEY ([ServiceRowID]) REFERENCES [dbo].[ServiceDetail] ([SrvRowId]);
GO
ALTER TABLE [dbo].[ServiceComponentSaleHeader] ADD CONSTRAINT [FK_Users_ServiceComponentSaleHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceConsumableItem] ADD CONSTRAINT [FK_Service_ServiceConsumableItem_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceConsumableItem] ADD CONSTRAINT [FK_Item_ServiceConsumableItem_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ServiceDetail] ADD CONSTRAINT [FK_ServiceDetail_TransportRoute_TransportRouteCode] FOREIGN KEY ([TransportRouteCode]) REFERENCES [dbo].[TransportRoute] ([TransportRouteCode]);
GO
ALTER TABLE [dbo].[ServiceDetail] ADD CONSTRAINT [FK_ServiceDetail_Vehicle_VehicleCode] FOREIGN KEY ([VehicleCode]) REFERENCES [dbo].[Vehicle] ([VehicleCode]);
GO
ALTER TABLE [dbo].[ServiceDetail] ADD CONSTRAINT [SERDSmanCode_FK] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ServiceDetail] ADD CONSTRAINT [SERServiceCodeFK] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceDetail] ADD CONSTRAINT [SERServiceInvCodeFK] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [SERCatCodeFK] FOREIGN KEY ([ServiceCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Accounts_ServiceHeader_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Message_ServiceHeader_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceInvType_ServiceHeader] FOREIGN KEY ([ServiceInvTypeCode]) REFERENCES [dbo].[ServiceInvType] ([ServiceInvTypeCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Guest_ServiceHeader_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_GuestCheckIn_ServiceHeader_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Student_ServiceHeader_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [SERCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [SERDoctCodeFK] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceOHeader_ServicHeader] FOREIGN KEY ([ServiceOCode]) REFERENCES [dbo].[ServiceOHeader] ([ServiceOCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [SERSalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Users_ServiceHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_Users_ServiceHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_Locker_LockerCode] FOREIGN KEY ([LockerCode]) REFERENCES [dbo].[Locker] ([LockerCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_Surgery_SurgeryCode] FOREIGN KEY ([SurgeryCode]) REFERENCES [dbo].[Surgery] ([SurgeryCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_SurgeryProcedure_SurgeryProcedureCode] FOREIGN KEY ([SurgeryProcedureCode]) REFERENCES [dbo].[SurgeryProcedure] ([SurgeryProcedureCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_EyeVision_EyeVisionCode] FOREIGN KEY ([EyeVisionCode]) REFERENCES [dbo].[EyeVision] ([EyeVisionCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_IOLPower_IOLPowerCode] FOREIGN KEY ([IOLPowerCode]) REFERENCES [dbo].[IOLPower] ([IOLPowerCode]);
GO
ALTER TABLE [dbo].[ServiceHeader] ADD CONSTRAINT [FK_ServiceHeader_Disease_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempDetail] ADD CONSTRAINT [FK_ServiceInvPurTempHeader_ServiceInvPurTempDetail_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceInvPurTempHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempDetail] ADD CONSTRAINT [FK_ServiceDetail_ServiceInvPurTempDetail_SRVRowID] FOREIGN KEY ([SRVRowID]) REFERENCES [dbo].[ServiceDetail] ([SrvRowId]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempDetail] ADD CONSTRAINT [FK_Service_ServiceInvPurTempDetail_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempDetail] ADD CONSTRAINT [FK_Supplier_ServiceInvPurTempDetail_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempHeader] ADD CONSTRAINT [FK_Users_ServiceInvPurTempHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempHeader] ADD CONSTRAINT [FK_ServiceHeader_ServiceInvPurTempHeader_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceInvPurTempHeader] ADD CONSTRAINT [FK_Users_ServiceInvPurTempHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Department_ServiceIssueRequest] FOREIGN KEY ([DeptCode]) REFERENCES [dbo].[Department] ([DeptCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Users_ServiceIssueRequest_Salesmancode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Users_ServiceIssueRequest_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Users_ServiceIssueRequest_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_SalesMan_ServiceIssueRequest] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Area_ServiceIssueRequest_Area] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequest] ADD CONSTRAINT [FK_Accounts_ServiceIssueRequest_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequestDetail] ADD CONSTRAINT [FK_ServiceIssueRequest_ServiceIssueRequestDetail] FOREIGN KEY ([ServiceIssueRequestCode]) REFERENCES [dbo].[ServiceIssueRequest] ([ServiceIssueRequestCode]);
GO
ALTER TABLE [dbo].[ServiceIssueRequestDetail] ADD CONSTRAINT [FK_Item_ServiceIssueRequestDetail] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ServiceLockerDetail] ADD CONSTRAINT [FK_ServiceLockerDetail_ServiceHeader_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceLockerDetail] ADD CONSTRAINT [FK_ServiceLockerDetail_Item_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[ServiceODetail] ADD CONSTRAINT [FK_ServiceODetail_SalesMan] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ServiceODetail] ADD CONSTRAINT [FK_ServiceODetail_Shift] FOREIGN KEY ([ShiftCode]) REFERENCES [dbo].[Shift] ([ShiftCode]);
GO
ALTER TABLE [dbo].[ServiceODetail] ADD CONSTRAINT [FK_ServiceODetail_Service] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceODetail] ADD CONSTRAINT [Fk_TimeSlot_ServiceODetail] FOREIGN KEY ([TsCode]) REFERENCES [dbo].[TimeSlot] ([TSCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_Customer] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_Doctors] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_Users] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_ServiceInvType_ServiceInvTypeCode] FOREIGN KEY ([ServiceInvTypeCode]) REFERENCES [dbo].[ServiceInvType] ([ServiceInvTypeCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_Message_MessageCode] FOREIGN KEY ([MessageCode]) REFERENCES [dbo].[Message] ([MessageCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_ServiceOrderStatus_ServiceOrderStatusCode] FOREIGN KEY ([ServiceOrderStatusCode]) REFERENCES [dbo].[ServiceOrderStatus] ([ServiceOrderStatusCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_ServiceOHeader_Relation_NextOfKinsRelationCode] FOREIGN KEY ([NextOfKinsRelationCode]) REFERENCES [dbo].[Relation] ([RelationCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_Patient_ServiceOHeader] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ServiceOHeader] ADD CONSTRAINT [FK_PatientAdmission_ServiceOHeader] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationDetail] ADD CONSTRAINT [FK_ServicePRAllocationHeader_ServicePRAllocationDetail_ServicePRAllocationCode] FOREIGN KEY ([ServicePRAllocationCode]) REFERENCES [dbo].[ServicePRAllocationHeader] ([ServicePRAllocationCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationDetail] ADD CONSTRAINT [FK_ServicePurHeader_ServicePRAllocationDetail_ServicePurInvCode] FOREIGN KEY ([ServicePurInvCode]) REFERENCES [dbo].[ServicePurHeader] ([ServicePurInvCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationHeader] ADD CONSTRAINT [FK_ServicePRHeader_ServicePRAllocationHeader_ServicePRInvCode] FOREIGN KEY ([ServicePRInvCode]) REFERENCES [dbo].[ServicePRHeader] ([ServicePRInvCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationHeader] ADD CONSTRAINT [FK_Users_ServicePRAllocationHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationHeader] ADD CONSTRAINT [FK_Users_ServicePRAllocationHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePRAllocationHeader] ADD CONSTRAINT [FK_Users_ServicePRAllocationHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePRDetail] ADD CONSTRAINT [FK_ServicePRHeader_ServicePRDetail_ServicePRInvCode] FOREIGN KEY ([ServicePRInvCode]) REFERENCES [dbo].[ServicePRHeader] ([ServicePRInvCode]);
GO
ALTER TABLE [dbo].[ServicePRDetail] ADD CONSTRAINT [FK_Service_ServicePRDetail_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_Accounts_ServicePRHeader_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_Users_ServicePRHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_Users_ServicePRHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_ServicePurHeader_ServicePRHeader_ServicePurInvCode] FOREIGN KEY ([ServicePurInvCode]) REFERENCES [dbo].[ServicePurHeader] ([ServicePurInvCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_Supplier_ServicePRHeader_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[ServicePRHeader] ADD CONSTRAINT [FK_Users_ServicePRHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePricePolicy] ADD CONSTRAINT [FK_Service_ServicePricePolicy] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServicePricePolicyDetail] ADD CONSTRAINT [FK_ServicePricePolicy_ServicePricePolicyDetail] FOREIGN KEY ([ServicePricePolicyCode]) REFERENCES [dbo].[ServicePricePolicy] ([ServicePricePolicyCode]);
GO
ALTER TABLE [dbo].[ServicePricePolicyDetail] ADD CONSTRAINT [FK_WeekDays_ServicePricePolicyDetail] FOREIGN KEY ([WeekDayCode]) REFERENCES [dbo].[WeekDays] ([WeekDayCode]);
GO
ALTER TABLE [dbo].[ServicePurDetail] ADD CONSTRAINT [FK_ServicePurHeader_ServicePurDetail_ServicePurInvCode] FOREIGN KEY ([ServicePurInvCode]) REFERENCES [dbo].[ServicePurHeader] ([ServicePurInvCode]);
GO
ALTER TABLE [dbo].[ServicePurDetail] ADD CONSTRAINT [FK_Service_ServicePurDetail_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_Supplier_ServicePurHeader_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_Users_ServicePurHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_Users_ServicePurHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_Users_ServicePurHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_Accounts_ServicePurHeader_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_ServiceHeader_ServicePurHeader_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServicePurHeader] ADD CONSTRAINT [FK_ServicePurHeader_Accounts_ExpAccCode] FOREIGN KEY ([ExpAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServicePurTempDetail] ADD CONSTRAINT [FK_ServicePurTempHeader_ServicePurTempDetail_ServicePurTempCode] FOREIGN KEY ([ServicePurTempCode]) REFERENCES [dbo].[ServicePurTempHeader] ([ServicePurTempCode]);
GO
ALTER TABLE [dbo].[ServicePurTempDetail] ADD CONSTRAINT [FK_Service_ServicePurTempDetail_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServicePurTempDetail] ADD CONSTRAINT [FK_Supplier_ServicePurTempDetail_SuppCode] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[ServicePurTempHeader] ADD CONSTRAINT [FK_Service_ServicePurTempHeader_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServicePurTempHeader] ADD CONSTRAINT [FK_Users_ServicePurTempHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceRDetail] ADD CONSTRAINT [SERRDSmanCode_FK] FOREIGN KEY ([SmanCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ServiceRDetail] ADD CONSTRAINT [FK_ServiceDetail_ServiceRDetail_SrvRowID] FOREIGN KEY ([SrvRowId]) REFERENCES [dbo].[ServiceDetail] ([SrvRowId]);
GO
ALTER TABLE [dbo].[ServiceRDetail] ADD CONSTRAINT [SERRDServiceCodeFK] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceRDetail] ADD CONSTRAINT [SERRDServiceInvCodeFK] FOREIGN KEY ([ServiceRInvCode]) REFERENCES [dbo].[ServiceRHeader] ([ServiceRInvcode]);
GO
ALTER TABLE [dbo].[ServiceResultDetail] ADD CONSTRAINT [FK_ServiceResultHeader_ServiceResultDetail] FOREIGN KEY ([ServiceResultCode]) REFERENCES [dbo].[ServiceResultHeader] ([ServiceResultCode]);
GO
ALTER TABLE [dbo].[ServiceResultDetail] ADD CONSTRAINT [FK_ServiceDetail_ServiceResultDetail_ServiceRowID] FOREIGN KEY ([ServiceRowID]) REFERENCES [dbo].[ServiceDetail] ([SrvRowId]);
GO
ALTER TABLE [dbo].[ServiceResultDetail] ADD CONSTRAINT [FK_ServiceComponent_ServiceResultDetail_ServiceComponentCode] FOREIGN KEY ([ServiceComponentCode]) REFERENCES [dbo].[ServiceComponent] ([ServiceComponentCode]);
GO
ALTER TABLE [dbo].[ServiceResultDetail] ADD CONSTRAINT [FK_ServiceComponentUnit_ServiceResultDetail_ServiceComponentUnitCode] FOREIGN KEY ([ServiceComponentUnitCode]) REFERENCES [dbo].[ServiceComponentUnit] ([ServiceComponentUnitCode]);
GO
ALTER TABLE [dbo].[ServiceResultHeader] ADD CONSTRAINT [FK_ServiceHeader_ServiceResultHeader_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceResultHeader] ADD CONSTRAINT [FK_Users_ServiceResultHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceResultHeader] ADD CONSTRAINT [FK_Users_ServiceResultHeader_PostedBY] FOREIGN KEY ([PostedBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceResultHeader] ADD CONSTRAINT [FK_ServiceResultStamp_ServiceResultHeader_ServiceResultStampCode] FOREIGN KEY ([ServiceResultStampCode]) REFERENCES [dbo].[ServiceResultStamp] ([ServiceResultStampCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRCatCodeFK] FOREIGN KEY ([ServiceRCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRCustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRDoctCodeFK] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRPostedByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRSalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [SERRServiceInvcodeFK] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_Guest_ServiceRHeader_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_GuestCheckIn_ServiceRHeader_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_ServiceRHeader_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_Student_ServiceRHeader_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_ServiceRHeader_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_ServiceRHeader_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_ServiceRHeader_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[ServiceRHeader] ADD CONSTRAINT [FK_Accounts_ServiceRHeader_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[ServiceSampleRequirement] ADD CONSTRAINT [FK_Service_ServiceSampleRequirement] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceSampleRequirement] ADD CONSTRAINT [FK_SampleType_ServiceSampleRequirement] FOREIGN KEY ([SampleTypeCode]) REFERENCES [dbo].[SampleType] ([SampleTypeCode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationDetail] ADD CONSTRAINT [FK_ServiceSRAllocationHeader_ServiceSRAllocationDetail_ServiceSRAllocationCode] FOREIGN KEY ([ServiceSRAllocationCode]) REFERENCES [dbo].[ServiceSRAllocationHeader] ([ServiceSRAllocationCode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationDetail] ADD CONSTRAINT [FK_ServiceHeader_ServiceSRAllocationDetail_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationHeader] ADD CONSTRAINT [FK_ServiceRHeader_ServiceSRAllocationHeader_ServiceRInvCode] FOREIGN KEY ([ServiceRInvCode]) REFERENCES [dbo].[ServiceRHeader] ([ServiceRInvcode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationHeader] ADD CONSTRAINT [FK_Users_ServiceSRAllocationHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationHeader] ADD CONSTRAINT [FK_Users_ServiceSRAllocationHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceSRAllocationHeader] ADD CONSTRAINT [FK_Users_ServiceSRAllocationHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceTemplateDetail] ADD CONSTRAINT [FK_Service_ServiceTemplateDetail_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceTemplateDetail] ADD CONSTRAINT [FK_SalesMan_ServiceTemplateDetail_SManCode] FOREIGN KEY ([SManCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[ServiceTemplateDetail] ADD CONSTRAINT [FK_SaleTemplateHeader_ServiceTemplateDetail] FOREIGN KEY ([ServiceTemplateCode]) REFERENCES [dbo].[ServiceTemplateHeader] ([ServiceTemplateCode]);
GO
ALTER TABLE [dbo].[ServiceTemplateHeader] ADD CONSTRAINT [FK_Users_ServiceTemplateHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceTicket] ADD CONSTRAINT [FK_Service_ServiceTicket_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[ServiceTicket] ADD CONSTRAINT [FK_User_ServiceTicket_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ServiceTicket] ADD CONSTRAINT [FK_ServiceHeader_ServiceTicket_ServiceInvCode] FOREIGN KEY ([ServiceInvCode]) REFERENCES [dbo].[ServiceHeader] ([ServiceInvCode]);
GO
ALTER TABLE [dbo].[SMS_AssociatedRecipient] ADD CONSTRAINT [FK_SMS_Template_SMS_AssociatedRecipient] FOREIGN KEY ([SMSTemplateCode]) REFERENCES [dbo].[SMS_Template] ([SMSTemplateCode]);
GO
ALTER TABLE [dbo].[SMS_AssociatedRecipient] ADD CONSTRAINT [FK_ContactGroup_SMS_AssociatedRecipient] FOREIGN KEY ([ContactGroupCode]) REFERENCES [dbo].[ContactGroup] ([ContactGroupCode]);
GO
ALTER TABLE [dbo].[SMS_Center] ADD CONSTRAINT [FK_SMS_Center_SMS_Type_SMSTypeCode] FOREIGN KEY ([SMSTypeCode]) REFERENCES [dbo].[SMS_Type] ([SMSTypeCode]);
GO
ALTER TABLE [dbo].[SMS_Center] ADD CONSTRAINT [FK_FK_SMS_Center_SMS_Status_SMSStatusCode] FOREIGN KEY ([SMSStatusCode]) REFERENCES [dbo].[SMS_Status] ([SMSStatusCode]);
GO
ALTER TABLE [dbo].[SMS_Center] ADD CONSTRAINT [FK_SMS_Center_SMS_Template_SMSTemplateCode] FOREIGN KEY ([SMSTemplateCode]) REFERENCES [dbo].[SMS_Template] ([SMSTemplateCode]);
GO
ALTER TABLE [dbo].[SMS_DataDefinition] ADD CONSTRAINT [FK_SMS_DataDefinition_Module] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[SMS_Template] ADD CONSTRAINT [FK_Module_SMS_Template_ModuleID] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Module] ([Module]);
GO
ALTER TABLE [dbo].[SMS_Template] ADD CONSTRAINT [FK_SMS_Type_SMS_Template] FOREIGN KEY ([SMSTypeCode]) REFERENCES [dbo].[SMS_Type] ([SMSTypeCode]);
GO
ALTER TABLE [dbo].[SMS_Template] ADD CONSTRAINT [FK_SMS_Template_SMS_DataDefinition] FOREIGN KEY ([SMSDataCode]) REFERENCES [dbo].[SMS_DataDefinition] ([SMSDataCode]);
GO
ALTER TABLE [dbo].[SOCheckListItem] ADD CONSTRAINT [FK_SOCheckListItem_ServiceOHeader_ServiceOCode] FOREIGN KEY ([ServiceOCode]) REFERENCES [dbo].[ServiceOHeader] ([ServiceOCode]);
GO
ALTER TABLE [dbo].[SOCheckListItem] ADD CONSTRAINT [FK_SOCheckListItem_CheckListItem] FOREIGN KEY ([CheckListItemCode]) REFERENCES [dbo].[CheckListItem] ([CheckListItemCode]);
GO
ALTER TABLE [dbo].[SoftwarePreferences] ADD CONSTRAINT [FK_SoftwarePreferences_PreferencesSubCategory_SubCatCode] FOREIGN KEY ([SubCatCode]) REFERENCES [dbo].[PreferencesSubCategory] ([SubCatCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_ServiceOHeader_ServiceOCode] FOREIGN KEY ([ServiceOCode]) REFERENCES [dbo].[ServiceOHeader] ([ServiceOCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Patient_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_Deduction1_AccCode] FOREIGN KEY ([Deduction1_AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_Deduction2_AccCode] FOREIGN KEY ([Deduction2_AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_Deduction3_AccCode] FOREIGN KEY ([Deduction3_AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_Deduction4_AccCode] FOREIGN KEY ([Deduction4_AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_Deduction5_AccCode] FOREIGN KEY ([Deduction5_AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_ReceiptAccCode] FOREIGN KEY ([ReceiptAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SOReceipt] ADD CONSTRAINT [FK_SOReceipt_Accounts_WHTaxAccCode] FOREIGN KEY ([WHTaxAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SPOTeamCategory] ADD CONSTRAINT [FK_SPOTeamCategory_SPOTeam_SPOTeamCode] FOREIGN KEY ([SPOTeamCode]) REFERENCES [dbo].[SPOTeam] ([SPOTeamCode]);
GO
ALTER TABLE [dbo].[SPOTeamCategory] ADD CONSTRAINT [FK_SPOTeamCategory_ItemCategory_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[SPOTeamMember] ADD CONSTRAINT [FK_SPOTeamMember_SPOTeam_SPOTeamCode] FOREIGN KEY ([SPOTeamCode]) REFERENCES [dbo].[SPOTeam] ([SPOTeamCode]);
GO
ALTER TABLE [dbo].[SPOTeamMember] ADD CONSTRAINT [FK_SPOTeamMember_SPO_SPOCode] FOREIGN KEY ([SPOCode]) REFERENCES [dbo].[SPO] ([SPOCode]);
GO
ALTER TABLE [dbo].[SPOTeamSubArea] ADD CONSTRAINT [FK_SPOTeamSubArea_SPOTeam_SPOTeamCode] FOREIGN KEY ([SPOTeamCode]) REFERENCES [dbo].[SPOTeam] ([SPOTeamCode]);
GO
ALTER TABLE [dbo].[SPOTeamSubArea] ADD CONSTRAINT [FK_SPOTeamSubArea_SubArea_SubAreaCode] FOREIGN KEY ([SubAreaCode]) REFERENCES [dbo].[SubArea] ([SubAreaCode]);
GO
ALTER TABLE [dbo].[SRAllocationDetail] ADD CONSTRAINT [FK_SaleLedger_SRAllocationDetail] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SRAllocationDetail] ADD CONSTRAINT [FK_SRAllocationHeader_SRAllocationDetail] FOREIGN KEY ([SRAllocationCode]) REFERENCES [dbo].[SRAllocationHeader] ([SRAllocationCode]);
GO
ALTER TABLE [dbo].[SRAllocationHeader] ADD CONSTRAINT [FK_SRLedger_SRAllocationHeader] FOREIGN KEY ([SRInvCode]) REFERENCES [dbo].[SRLedger] ([SRInvCode]);
GO
ALTER TABLE [dbo].[SRAllocationHeader] ADD CONSTRAINT [FK_Users_SRAllocationHeader] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRAllocationHeader] ADD CONSTRAINT [FK_Users_SRAllocationHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRAllocationHeader] ADD CONSTRAINT [FK_Users_SRAllocationHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRBufferDetail] ADD CONSTRAINT [FK_Godown_SRBufferDetail_GCode] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SRBufferDetail] ADD CONSTRAINT [FK_Item_SRBufferDetail_ICode] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SRBufferDetail] ADD CONSTRAINT [FK_SRBufferLedger_SRBufferDetail_SRBufferInvCode] FOREIGN KEY ([SRBufferInvcode]) REFERENCES [dbo].[SRBufferLedger] ([SRBufferInvCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Guest_SRBufferLedger_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_GuestCheckIn_SRBufferLedger_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Student_SRBufferLedger_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_SRBufferLedger_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_SaleLedger_SRBufferLedger_SaleInvCode] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Users_SRBufferLedger_SalesmanCode] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_SalesMan_SRBufferLedger_SmanCode] FOREIGN KEY ([Smancode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Accounts_SRBufferLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_PatientAdmission_SRBufferLedger_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Users_SRBufferLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Customer_SRBufferLedger_Customer] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Accounts_SRBufferLedger_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Users_SRBufferLedger_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Patient_SRBufferLedger_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_Users_SRBufferLedger_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRBufferLedger] ADD CONSTRAINT [FK_SaleCategory_SRBufferLedger_SaleCatCode] FOREIGN KEY ([SRCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[SRdetail] ADD CONSTRAINT [SRDSRInvCodeFK] FOREIGN KEY ([SRInvcode]) REFERENCES [dbo].[SRLedger] ([SRInvCode]);
GO
ALTER TABLE [dbo].[SRdetail] ADD CONSTRAINT [SRDGCodeFK] FOREIGN KEY ([Gcode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[SRdetail] ADD CONSTRAINT [SRDICodeFK] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLSmanCode_FK] FOREIGN KEY ([Smancode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Guest_SRLedger_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_GuestCheckIn_SRLedger_GuestCheckInCode] FOREIGN KEY ([GuestCheckInCode]) REFERENCES [dbo].[GuestCheckin] ([GuestCheckINCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Student_SRLedger_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLPatientCode_FK] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Doctors_SRLedger_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_SRLedger_PatientAdmission] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_SRLedger_CashierShift_CashierShiftCode] FOREIGN KEY ([CashierShiftCode]) REFERENCES [dbo].[CashierShift] ([CashierShiftCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_SRLedger_Currency_CurrencyCode] FOREIGN KEY ([CurrencyCode]) REFERENCES [dbo].[Currency] ([CurrencyCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_SRLedger_MotorVehicle] FOREIGN KEY ([MotorVehicleCode]) REFERENCES [dbo].[MotorVehicle] ([MotorVehicleCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLSalesmanCodeFK] FOREIGN KEY ([SalesmanCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLSaleInvCodeFK] FOREIGN KEY ([SaleInvCode]) REFERENCES [dbo].[SaleLedger] ([SaleInvCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Accounts_SRLedger_PaymentAccCode] FOREIGN KEY ([PaymentAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Users_SRLedger_AmtBY] FOREIGN KEY ([AmtBY]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [FK_Accounts_SRLedger_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLCustCodeFK] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLModifiedByFK] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLPostedByFK] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SRLedger] ADD CONSTRAINT [SRLSaleCatCodeFK] FOREIGN KEY ([SRCatCode]) REFERENCES [dbo].[SaleCategory] ([SaleCatCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Users_RegisteredBy] FOREIGN KEY ([RegisteredBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Users_LastUpdateBy] FOREIGN KEY ([LastUpdateBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Class_AdmittedTo] FOREIGN KEY ([AdmittedTo]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Users_AdmittedBy] FOREIGN KEY ([AdmittedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Class_Student_CurrentClass] FOREIGN KEY ([CurrentClass]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Class_AdmissionReqIn] FOREIGN KEY ([AdmissionReqIn]) REFERENCES [dbo].[Grade] ([GradeCode]);
GO
ALTER TABLE [dbo].[StudentClass] ADD CONSTRAINT [FK_StudentClass_Class_ClassCode] FOREIGN KEY ([ClassCode]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[StudentClass] ADD CONSTRAINT [FK_StudentClass_Student_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[StudentClassTransfer] ADD CONSTRAINT [FK_Sudent_StudentClassTransfer_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[StudentClassTransfer] ADD CONSTRAINT [FK_Class_StudentClassTransfer_SourceClass] FOREIGN KEY ([SourceClass]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[StudentClassTransfer] ADD CONSTRAINT [FK_Class_StudentClassTransfer_TargetClass] FOREIGN KEY ([TargetClass]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[StudentClassTransfer] ADD CONSTRAINT [FK_Users_StudentClassTransfer_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheet] ADD CONSTRAINT [FK_StudentFeeSheet_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheet] ADD CONSTRAINT [FK_StudentFeeSheet_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheetDetail] ADD CONSTRAINT [FK_StudentFeeSheetDetail_Service_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheetDetail] ADD CONSTRAINT [FK_StudentFeeSheetDetail_StudentFeeSheet_StudentFeeSheetCode] FOREIGN KEY ([StudentFeeSheetCode]) REFERENCES [dbo].[StudentFeeSheet] ([StudentFeeSheetCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheetDetail] ADD CONSTRAINT [FK_StudentFeeSheetDetail_Student_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[StudentFeeSheetDetail] ADD CONSTRAINT [FK_StudentFeeSheetDetail_Class_ClassCode] FOREIGN KEY ([ClassCode]) REFERENCES [dbo].[Class] ([ClassCode]);
GO
ALTER TABLE [dbo].[StudentImage] ADD CONSTRAINT [FK_StudentImage_Student_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplate] ADD CONSTRAINT [FK_StudentServiceTemplate_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplate] ADD CONSTRAINT [FK_StudentServiceTemplate_Service_ServiceCode] FOREIGN KEY ([ServiceCode]) REFERENCES [dbo].[Service] ([ServiceCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplate] ADD CONSTRAINT [FK_StudentServiceTemplate_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplateDetail] ADD CONSTRAINT [FK_StudentServiceTemplate_StudentServiceTemplateDetail_StudentServiceTemplateCode] FOREIGN KEY ([StudentServiceTemplateCode]) REFERENCES [dbo].[StudentServiceTemplate] ([StudentServiceTemplateCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplateDetail] ADD CONSTRAINT [FK_StudentServiceTemplateDetail_Student_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplateDetail] ADD CONSTRAINT [FK_StudentServiceTemplateDetail_TransportRoute_TransportRouteCode] FOREIGN KEY ([TransportRouteCode]) REFERENCES [dbo].[TransportRoute] ([TransportRouteCode]);
GO
ALTER TABLE [dbo].[StudentServiceTemplateDetail] ADD CONSTRAINT [FK_StudentServiceTemplateDetail_Vehicle_VehicleCode] FOREIGN KEY ([VehicleCode]) REFERENCES [dbo].[Vehicle] ([VehicleCode]);
GO
ALTER TABLE [dbo].[SubAccounts] ADD CONSTRAINT [SACatAccCodeFK] FOREIGN KEY ([CatAccCode]) REFERENCES [dbo].[CategoryAccounts] ([CatAccCode]);
GO
ALTER TABLE [dbo].[SubArea] ADD CONSTRAINT [FK_SubArea_areacode] FOREIGN KEY ([Areacode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[SummaryAccount] ADD CONSTRAINT [FK_GroupSummaryAccount_SummaryAccount_GroupSummaryAccCode] FOREIGN KEY ([GroupSummaryAccCode]) REFERENCES [dbo].[GroupSummaryAccount] ([GroupSummaryAccCode]);
GO
ALTER TABLE [dbo].[SummaryAccountDetail] ADD CONSTRAINT [FK_SummaryAccount_SummaryAccCode] FOREIGN KEY ([SummaryAccCode]) REFERENCES [dbo].[SummaryAccount] ([SummaryAccCode]);
GO
ALTER TABLE [dbo].[SummaryAccountDetail] ADD CONSTRAINT [FK_Accounts_SummaryAccountDetail] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT [SuppSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT [FK_Supplier_SupplierCategory] FOREIGN KEY ([SuppCatCode]) REFERENCES [dbo].[SupplierCategory] ([SuppCatCode]);
GO
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT [FK_Supplier_StateProvinceCode] FOREIGN KEY ([StateProvinceCode]) REFERENCES [dbo].[StateProvince] ([StateProvinceCode]);
GO
ALTER TABLE [dbo].[Supplier] ADD CONSTRAINT [FK_Supplier_Countycode] FOREIGN KEY ([CountyCode]) REFERENCES [dbo].[County] ([CountyCode]);
GO
ALTER TABLE [dbo].[SupplierManufacturers] ADD CONSTRAINT [SMManfCodeFK] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[SupplierManufacturers] ADD CONSTRAINT [SMSuppCodeFK] FOREIGN KEY ([SuppCode]) REFERENCES [dbo].[Supplier] ([SuppCode]);
GO
ALTER TABLE [dbo].[SurveyDetail] ADD CONSTRAINT [FK_SurveyHeader_SurveyDetail_SurveyCode] FOREIGN KEY ([SurveyCode]) REFERENCES [dbo].[SurveyHeader] ([SurveyCode]);
GO
ALTER TABLE [dbo].[SurveyDetail] ADD CONSTRAINT [FK_Item_SurveyDetail_Icode] FOREIGN KEY ([Icode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[SurveyDetail] ADD CONSTRAINT [FK_Manufacturer_SurveyDetail_ManfCode] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[SurveyDetail] ADD CONSTRAINT [FK_ItemPacking_SurveyDetail_PackCode] FOREIGN KEY ([PackCode]) REFERENCES [dbo].[ItemPacking] ([PackCode]);
GO
ALTER TABLE [dbo].[SurveyHeader] ADD CONSTRAINT [FK_ProspectiveCustomer_PptCustCode] FOREIGN KEY ([PptCustCode]) REFERENCES [dbo].[ProspectiveCustomer] ([PptCustCode]);
GO
ALTER TABLE [dbo].[SurveyHeader] ADD CONSTRAINT [FK_Users_SurveyHeader_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[SurveyHeader] ADD CONSTRAINT [FK_Users_SurveyHeader_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Symptom] ADD CONSTRAINT [FK_SymptomType_Symptom_SymptomTypeCode] FOREIGN KEY ([SymptomTypeCode]) REFERENCES [dbo].[SymptomType] ([SymptomTypeCode]);
GO
ALTER TABLE [dbo].[Tdetail] ADD CONSTRAINT [TDICodeFK] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[Tdetail] ADD CONSTRAINT [TDTranCodeFK] FOREIGN KEY ([TransCode]) REFERENCES [dbo].[Theader] ([TransCode]);
GO
ALTER TABLE [dbo].[ThaliumScan] ADD CONSTRAINT [FK_Users_ThaliumScan_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[ThaliumScan] ADD CONSTRAINT [FK_Users_ThaliumScan_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[ThaliumScan] ADD CONSTRAINT [FK_Patient_ThaliumScan_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[ThaliumScan] ADD CONSTRAINT [FK_PatientAdmission_ThaliumScan_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [THSGCodeFK] FOREIGN KEY ([SGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_THeader_TransferedBy] FOREIGN KEY ([TransferedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_THeader_ImportedBy] FOREIGN KEY ([ImportedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_THeader_WorkOrderCode] FOREIGN KEY ([WorkOrderCode]) REFERENCES [dbo].[WorkOrder] ([WorkOrderCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [DF_THeader_TransferRequisitionHeader_TransReqCode] FOREIGN KEY ([TransReqCode]) REFERENCES [dbo].[TransferRequisitionHeader] ([TransReqCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_SalesMan_THeader] FOREIGN KEY ([SMANCode]) REFERENCES [dbo].[SalesMan] ([SalesManCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_THeader_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [FK_THeader_TransferType] FOREIGN KEY ([TTCode]) REFERENCES [dbo].[TransferType] ([TTCode]);
GO
ALTER TABLE [dbo].[Theader] ADD CONSTRAINT [THDGCodeFK] FOREIGN KEY ([DGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[TimeSlot] ADD CONSTRAINT [FK_TimeSlot_Shift] FOREIGN KEY ([ShiftCode]) REFERENCES [dbo].[Shift] ([ShiftCode]);
GO
ALTER TABLE [dbo].[TransactionDetail] ADD CONSTRAINT [FK_TransactionHeader_TransactionDetail_DocumentCode] FOREIGN KEY ([DocumentCode]) REFERENCES [dbo].[TransactionHeader] ([DocumentCode]);
GO
ALTER TABLE [dbo].[TransactionDetail] ADD CONSTRAINT [FK_Accounts_TransactionDetail_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_TransactionType_TransactionHeader_TransactionTypeCode] FOREIGN KEY ([TransactionTypeCode]) REFERENCES [dbo].[TransactionType] ([TransactionTypeCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_Users_TransactionHeader_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_Patient_TransactionHeader_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_PatientAdmission_TransactionHeader_PatientAdmission] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_Accounts_TransactionHeader_AccCode] FOREIGN KEY ([AccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_Accounts_TransactionHeader_CashAccCode] FOREIGN KEY ([CashAccCode]) REFERENCES [dbo].[Accounts] ([AccCode]);
GO
ALTER TABLE [dbo].[TransactionHeader] ADD CONSTRAINT [FK_Users_TransactionHeader_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[TransactionType] ADD CONSTRAINT [FK_TransactionCategory_TransactionType_TransactionCatCode] FOREIGN KEY ([TransactionCatCode]) REFERENCES [dbo].[TransactionCategory] ([TransactionCatCode]);
GO
ALTER TABLE [dbo].[TransferableData_ExportRestrictedColumns] ADD CONSTRAINT [FK_TransferableData_ExportRestrictedColumns_TableName] FOREIGN KEY ([TableName]) REFERENCES [dbo].[TransferableData] ([TABLENAME]);
GO
ALTER TABLE [dbo].[TransferableData_RestrictedColumns] ADD CONSTRAINT [FK_TransferableData_RestrictedColumns_TableName] FOREIGN KEY ([TableName]) REFERENCES [dbo].[TransferableData] ([TABLENAME]);
GO
ALTER TABLE [dbo].[TransferRequisitionDetail] ADD CONSTRAINT [FK_TransferRequisitionHeader_TransferRequisitionDetail_TransReqCode] FOREIGN KEY ([TransReqCode]) REFERENCES [dbo].[TransferRequisitionHeader] ([TransReqCode]);
GO
ALTER TABLE [dbo].[TransferRequisitionDetail] ADD CONSTRAINT [FK_Item_TransferRequisitionDetail_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[TransferRequisitionHeader] ADD CONSTRAINT [FK_Godown_TransferRequisitionHeader_SGCode] FOREIGN KEY ([SGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[TransferRequisitionHeader] ADD CONSTRAINT [FK_Godown_TransferRequisitionHeader_DGCode] FOREIGN KEY ([SGCode]) REFERENCES [dbo].[Godown] ([GCode]);
GO
ALTER TABLE [dbo].[TransferRequisitionHeader] ADD CONSTRAINT [FK_TransferRequisitionHeader_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[TransferRequisitionHeader] ADD CONSTRAINT [FK_TransferType_TransferRequisitionHeader_TTCode] FOREIGN KEY ([TTCode]) REFERENCES [dbo].[TransferType] ([TTCode]);
GO
ALTER TABLE [dbo].[TransferRequisitionHeader] ADD CONSTRAINT [FK_Users_TransferRequisitionHeader_SalesManCode] FOREIGN KEY ([SalesManCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Users_TreatmentGiven_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Users_TreatmentGiven_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Route_TreatmentGiven_RouteCode] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Instruction_TreatmentGiven_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Patient_TreatmentGiven_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_PatientAdmission_TreatmentGiven_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Item_TreatmentGiven_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_DosageUnit_TreatmentGiven_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[TreatmentGiven] ADD CONSTRAINT [FK_Dosage_TreatmentGiven_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[UserAllowedDoctor] ADD CONSTRAINT [FK_Users_UserAllowedDoctor_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserAllowedDoctor] ADD CONSTRAINT [FK_Doctors_UserAllowedDoctor_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[UserAttendance] ADD CONSTRAINT [FK_Users_UserAttandence_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserGroups] ADD CONSTRAINT [UGGroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[UserGroups] ADD CONSTRAINT [UGUserCodeFK] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserGroupsLog] ADD CONSTRAINT [FK_Users_UserGroups_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserGroupsLog] ADD CONSTRAINT [FK_Groups_UserGroupsLog_GroupCode] FOREIGN KEY ([GroupCode]) REFERENCES [dbo].[Groups] ([GroupCode]);
GO
ALTER TABLE [dbo].[UserGroupsLog] ADD CONSTRAINT [FK_Users_UserGroups_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserRights] ADD CONSTRAINT [URUserCodeFK] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[UserRights] ADD CONSTRAINT [URRightCodeFK] FOREIGN KEY ([RightCode]) REFERENCES [dbo].[Rights] ([RightCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Doctors_VaccineSchedule_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Patient_VaccineSchedule_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Item_VaccineSchedule_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_VaccineStatus_VaccineSchedule] FOREIGN KEY ([VaccineStatusCode]) REFERENCES [dbo].[VaccineStatus] ([VaccineStatusCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_LastRemindedBy] FOREIGN KEY ([LastRemindedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_LastPendedBy] FOREIGN KEY ([LastPendedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_VaccinatedBy] FOREIGN KEY ([VaccinatedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VaccineSchedule] ADD CONSTRAINT [FK_Users_VaccineSchedule_StoppedBy] FOREIGN KEY ([StoppedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[Vehicle] ADD CONSTRAINT [FK_Vehicle_VehicleType_VehicleTypeCode] FOREIGN KEY ([VehicleTypeCode]) REFERENCES [dbo].[VehicleType] ([VehicleTypeCode]);
GO
ALTER TABLE [dbo].[VehicleRoute] ADD CONSTRAINT [FK_VehicleRoute_Vehicle_VehicleCode] FOREIGN KEY ([VehicleCode]) REFERENCES [dbo].[Vehicle] ([VehicleCode]);
GO
ALTER TABLE [dbo].[VehicleRoute] ADD CONSTRAINT [FK_VehicleRoute_TransportRoute_TransportRouteCode] FOREIGN KEY ([TransportRouteCode]) REFERENCES [dbo].[TransportRoute] ([TransportRouteCode]);
GO
ALTER TABLE [dbo].[VirtualGl] ADD CONSTRAINT [FK_Guest_VirtualGL_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[VirtualGl] ADD CONSTRAINT [FK_Student_VirtualGL_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[VirtualGlTemp] ADD CONSTRAINT [FK_Guest_VirtualGLTemp_GuestCode] FOREIGN KEY ([GuestCode]) REFERENCES [dbo].[Guest] ([GuestCode]);
GO
ALTER TABLE [dbo].[VirtualGlTemp] ADD CONSTRAINT [FK_Student_VirtualGLTemp_StudentCode] FOREIGN KEY ([StudentCode]) REFERENCES [dbo].[Student] ([StudentCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_VisitAppointment_Visit_AppointmentCode] FOREIGN KEY ([AppointmentCode]) REFERENCES [dbo].[VisitAppointment] ([AppointmentCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_Doctors_Visit_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_VisitType_Visit_VisitTypeCode] FOREIGN KEY ([VisitTypeCode]) REFERENCES [dbo].[VisitType] ([VisitTypeCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_VisitStatus_Visit_VisitStatusCode] FOREIGN KEY ([VisitStatusCode]) REFERENCES [dbo].[VisitStatus] ([VisitStatusCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_Patient_Appointment_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[Visit] ADD CONSTRAINT [FK_Users_Visit_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VisitAppointment] ADD CONSTRAINT [FK_Doctors_VisitAppointment_DoctCode] FOREIGN KEY ([DoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[VisitAppointment] ADD CONSTRAINT [FK_AppointmentMethod_VisitAppointment_AppointmentMethodCode] FOREIGN KEY ([AppointmentMethodCode]) REFERENCES [dbo].[AppointmentMethod] ([AppointmentMethodCode]);
GO
ALTER TABLE [dbo].[VisitAppointment] ADD CONSTRAINT [FK_AppointmentStatus_VisitAppointment_AppointmentStatusCode] FOREIGN KEY ([AppointmentMethodCode]) REFERENCES [dbo].[AppointmentStatus] ([AppointmentStatusCode]);
GO
ALTER TABLE [dbo].[VisitAppointment] ADD CONSTRAINT [FK_Patient_VisitAppointment_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[VisitAppointment] ADD CONSTRAINT [FK_Users_VisitAppointment_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[VisitDiagnostics] ADD CONSTRAINT [FK_Visit_VisitDiagnostics_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitDiagnostics] ADD CONSTRAINT [FK_DiagnosticItem_Visit_DiagnosticItemCode] FOREIGN KEY ([DiagnosticItemCode]) REFERENCES [dbo].[DiagnosticItem] ([DiagnosticItemCode]);
GO
ALTER TABLE [dbo].[VisitICD] ADD CONSTRAINT [FK_VisitICD_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitICD] ADD CONSTRAINT [FK_VisitICD_ICDList_ICDListCode] FOREIGN KEY ([ICDListCode]) REFERENCES [dbo].[ICDList] ([ICDListCode]);
GO
ALTER TABLE [dbo].[VisitPhysicalExam] ADD CONSTRAINT [FK_Visit_VisitPhysicalExam_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitPhysicalExam] ADD CONSTRAINT [FK_PhysicalExam_Visit_PhysicalExamCode] FOREIGN KEY ([PhysicalExamCode]) REFERENCES [dbo].[PhysicalExam] ([PhysicalExamCode]);
GO
ALTER TABLE [dbo].[VisitPrecaution] ADD CONSTRAINT [FK_Visit_VisitPrecaution_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitPrecaution] ADD CONSTRAINT [FK_Precaution_VisitPrecaution_PrecautionCode] FOREIGN KEY ([PrecautionCode]) REFERENCES [dbo].[Precaution] ([PrecautionCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Visit_VisitPrescription_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Item_VisitPrescription_ICode] FOREIGN KEY ([ICode]) REFERENCES [dbo].[Item] ([ICode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Disease_VisitPrescription_DiseaseCode] FOREIGN KEY ([DiseaseCode]) REFERENCES [dbo].[Disease] ([DiseaseCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Dosage_VisitPrescription_DosageCode] FOREIGN KEY ([DosageCode]) REFERENCES [dbo].[Dosage] ([DosageCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Route_VisitPrescription_RouteCode] FOREIGN KEY ([RouteCode]) REFERENCES [dbo].[Route] ([RouteCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_Instruction_VisitPrescription_InsCode] FOREIGN KEY ([InsCode]) REFERENCES [dbo].[Instruction] ([InsCode]);
GO
ALTER TABLE [dbo].[VisitPrescription] ADD CONSTRAINT [FK_DosageUnit_VisitPrescription_DosageUnitCode] FOREIGN KEY ([DosageUnitCode]) REFERENCES [dbo].[DosageUnit] ([DosageUnitCode]);
GO
ALTER TABLE [dbo].[VisitSymptoms] ADD CONSTRAINT [FK_Visit_VisitSymptoms_VisitCode] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VisitSymptoms] ADD CONSTRAINT [FK_Symptom_Visit_SymptomCode] FOREIGN KEY ([SymptomCode]) REFERENCES [dbo].[Symptom] ([SymptomCode]);
GO
ALTER TABLE [dbo].[VisitSymptoms] ADD CONSTRAINT [FK_SeverityLevel_Visit_SeverityLevelCode] FOREIGN KEY ([SeverityLevelCode]) REFERENCES [dbo].[SeverityLevel] ([SeverityLevelCode]);
GO
ALTER TABLE [dbo].[VisitVitals] ADD CONSTRAINT [FK_Visit_VisitVitals] FOREIGN KEY ([VisitCode]) REFERENCES [dbo].[Visit] ([VisitCode]);
GO
ALTER TABLE [dbo].[VocherCategoryDetail] ADD CONSTRAINT [FK_SubAccounts_VocherCategoryDetail] FOREIGN KEY ([SubAccCode]) REFERENCES [dbo].[SubAccounts] ([SubAccCode]);
GO
ALTER TABLE [dbo].[VocherCategoryDetail] ADD CONSTRAINT [FK_VocherCategory_VocherCategoryDetail] FOREIGN KEY ([VochCatCode]) REFERENCES [dbo].[VocherCategory] ([VochCatCode]);
GO
ALTER TABLE [dbo].[VocherCategoryHeader] ADD CONSTRAINT [FK_SubAccounts_VocherCategoryHeader] FOREIGN KEY ([SubAccCode]) REFERENCES [dbo].[SubAccounts] ([SubAccCode]);
GO
ALTER TABLE [dbo].[VocherCategoryHeader] ADD CONSTRAINT [FK_VocherCategory_VocherCategoryHeader] FOREIGN KEY ([VochCatCode]) REFERENCES [dbo].[VocherCategory] ([VochCatCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_Users_ApprovedBy] FOREIGN KEY ([ApprovedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_Users_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_WorkOrderAccount_WorkOrderAccCode] FOREIGN KEY ([WorkOrderAccCode]) REFERENCES [dbo].[WorkOrderAccount] ([WorkOrderAccCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_WorkOrderType_WorkOrderTypeCode] FOREIGN KEY ([WorkOrderTypeCode]) REFERENCES [dbo].[WorkOrderType] ([WorkOrderTypeCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_Customer_CustCode] FOREIGN KEY ([CustCode]) REFERENCES [dbo].[Customer] ([CustCode]);
GO
ALTER TABLE [dbo].[WorkOrder] ADD CONSTRAINT [FK_WorkOrder_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[WorkOrderAssessment] ADD CONSTRAINT [FK_WorkOrderAssessment_WorkOrder_WorkOrderCode] FOREIGN KEY ([WorkOrderCode]) REFERENCES [dbo].[WorkOrder] ([WorkOrderCode]);
GO
ALTER TABLE [dbo].[WorkOrderAssessment] ADD CONSTRAINT [FK_WorkOrderAssessment_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[WorkOrderResource] ADD CONSTRAINT [FK_WorkOrderResource_WorkOrderCode] FOREIGN KEY ([WorkOrderCode]) REFERENCES [dbo].[WorkOrder] ([WorkOrderCode]);
GO
ALTER TABLE [dbo].[WorkOrderResource] ADD CONSTRAINT [FK_WorkOrderResource_Resource_ResourceCode] FOREIGN KEY ([ResourceCode]) REFERENCES [dbo].[Resource] ([ResourceCode]);
GO
ALTER TABLE [dbo].[WorkOrderResource] ADD CONSTRAINT [FK_WorkOrderResource_Users_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[XRay] ADD CONSTRAINT [FK_PatientAdmission_XRay_AdmissionCode] FOREIGN KEY ([AdmissionCode]) REFERENCES [dbo].[PatientAdmission] ([AdmissionCode]);
GO
ALTER TABLE [dbo].[XRay] ADD CONSTRAINT [FK_Users_XRay_UserCode] FOREIGN KEY ([UserCode]) REFERENCES [dbo].[Users] ([UserCode]);
GO
ALTER TABLE [dbo].[XRay] ADD CONSTRAINT [FK_Users_XRay_AttendingDoctCode] FOREIGN KEY ([AttendingDoctCode]) REFERENCES [dbo].[Doctors] ([DoctCode]);
GO
ALTER TABLE [dbo].[XRay] ADD CONSTRAINT [FK_Patient_XRay_PatientCode] FOREIGN KEY ([PatientCode]) REFERENCES [dbo].[Patient] ([PatientCode]);
GO
ALTER TABLE [dbo].[Zone] ADD CONSTRAINT [ZManfCodeFK] FOREIGN KEY ([ManfCode]) REFERENCES [dbo].[Manufacturer] ([ManfCode]);
GO
ALTER TABLE [dbo].[Zone] ADD CONSTRAINT [FK_Zone_ItemCategory_ICatCode] FOREIGN KEY ([ICatCode]) REFERENCES [dbo].[ItemCategory] ([ICatCode]);
GO
ALTER TABLE [dbo].[ZoneAreas] ADD CONSTRAINT [ZAAreaCodeFK] FOREIGN KEY ([AreaCode]) REFERENCES [dbo].[Area] ([AreaCode]);
GO
ALTER TABLE [dbo].[ZoneAreas] ADD CONSTRAINT [ZAZoneCode] FOREIGN KEY ([ZoneCode]) REFERENCES [dbo].[Zone] ([ZoneCode]);
GO
ALTER TABLE [dbo].[ZoneContactGroup] ADD CONSTRAINT [FK_ZoneContactGroup_Zone_ZoneCode] FOREIGN KEY ([ZoneCode]) REFERENCES [dbo].[Zone] ([ZoneCode]);
GO
ALTER TABLE [dbo].[ZoneContactGroup] ADD CONSTRAINT [FK_ZoneContactGroup_ContactGroup_ContactGroupCode] FOREIGN KEY ([ContactGroupCode]) REFERENCES [dbo].[ContactGroup] ([ContactGroupCode]);
GO
