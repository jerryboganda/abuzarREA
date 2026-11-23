-- Reconstructed by re-tools/db_rebuild.py (static; not validated on SQL Server)

CREATE TABLE [dbo].[_HeaderTabMaxKey] (
    [HeaderCode] smallint NOT NULL,
    [Module] smallint NOT NULL,
    [TabMaxKey] int NOT NULL CONSTRAINT [DF__HeaderTabMaxKey_TabMaxKey] DEFAULT (0),
    CONSTRAINT [PK__HeaderTabMaxKey] PRIMARY KEY CLUSTERED ([HeaderCode], [Module])
);
GO

CREATE TABLE [dbo].[_TABMAXKEY] (
    [TABId] int NOT NULL,
    [TABName] char(32) NOT NULL,
    [TABMAXKEY] numeric(7,0) NOT NULL,
    CONSTRAINT [TableNamePK] PRIMARY KEY CLUSTERED ([TABName])
);
GO

CREATE TABLE [dbo].[_Utn] (
    [Utn] bigint NOT NULL
);
GO

CREATE TABLE [dbo].[A] (
    [ABC] numeric(15,2) NOT NULL CONSTRAINT [DF__A__ABC__7968E838] DEFAULT (0),
    [N] varchar(30) NOT NULL CONSTRAINT [DF__A__N__7A5D0C71] DEFAULT ('A'),
    [p] varchar(30) NULL CONSTRAINT [DF__A__p__7B5130AA] DEFAULT ('A')
);
GO

CREATE TABLE [dbo].[ABD_US] (
    [PatientCode] int NOT NULL,
    [VisitCode] int NULL,
    [AdmissionCode] int NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ABD_US_Date] DEFAULT (getdate()),
    [Liver_Size] varchar(60) NULL,
    [Liver_Parenchyma] varchar(60) NULL,
    [Liver_Details] varchar(500) NULL,
    [BileDuct_Size] varchar(60) NULL,
    [BileDuct_PortalVein] varchar(60) NULL,
    [BileDuct_Details] varchar(500) NULL,
    [GB_Size] varchar(60) NULL,
    [GB_Wall] varchar(60) NULL,
    [GB_Details] varchar(500) NULL,
    [Spleen_Size] varchar(60) NULL,
    [Spleen_Parenchyma] varchar(60) NULL,
    [Spleen_Details] varchar(500) NULL,
    [Pancreas_Size] varchar(60) NULL,
    [Pancreas_Parenchyma] varchar(60) NULL,
    [Pancreas_PancreaticDuct] varchar(60) NULL,
    [Pancreas_Details] varchar(500) NULL,
    [LeftKidney_Size] varchar(60) NULL,
    [LeftKidney_Parenchyma] varchar(60) NULL,
    [LeftKidney_Details] varchar(500) NULL,
    [RightKidney_Size] varchar(60) NULL,
    [RightKidney_Parenchyma] varchar(60) NULL,
    [RightKidney_Details] varchar(500) NULL,
    [UrinaryBladder_Size] varchar(60) NULL,
    [UrinaryBladder_Wall] varchar(60) NULL,
    [UrinaryBladder_Details] varchar(500) NULL,
    [GeneralFindings_Ascites] varchar(60) NULL,
    [GeneralFindings_LMP] varchar(60) NULL,
    [GeneralFindings_PER] varchar(60) NULL,
    [GeneralFindings_PEL] varchar(60) NULL,
    [GeneralFindings_Details] varchar(500) NULL,
    [Comments] varchar(1000) NULL
);
GO

CREATE TABLE [dbo].[AccountBalanceLog] (
    [LogID] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_AccountBalanceLog_Date] DEFAULT (getdate()),
    [Acccode] smallint NOT NULL,
    [Balance] numeric(15,2) NOT NULL CONSTRAINT [DF_AccountBalanceLog_Balance] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[AccountGodown] (
    [AccCode] smallint NOT NULL,
    [GCode] smallint NOT NULL,
    CONSTRAINT [PK_AccountGodown] PRIMARY KEY CLUSTERED ([AccCode], [GCode])
);
GO

CREATE TABLE [dbo].[Accounts] (
    [AccCode] smallint NOT NULL,
    [SubCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [OpeningDate] datetime NULL CONSTRAINT [DF_Accounts_OpeningDate_1__13] DEFAULT (getdate()),
    [AliasName] varchar(12) NULL,
    [Active] char(1) NULL CONSTRAINT [DF_Accounts_Active_1__10] DEFAULT ('Y'),
    [Restricted] char(1) NOT NULL CONSTRAINT [DF_Accounts_Restricted] DEFAULT ('N'),
    [BalanceLimit] numeric(15,2) NULL,
    [Remarks] varchar(1000) NULL,
    [AlertCode] smallint NOT NULL CONSTRAINT [DF_Accounts_AlertCode] DEFAULT (1),
    [LocalAccountName] nvarchar(255) NULL,
    CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([AccCode]),
    CONSTRAINT [AccNameUC] UNIQUE ([Name]),
    CONSTRAINT [IX_Accounts_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[ActivityMonitor] (
    [DocRowID] int IDENTITY(1,1) NOT NULL,
    [DocumentCode] int NOT NULL,
    [DocumentType] char(2) NOT NULL,
    [DocCatCode] smallint NOT NULL,
    [Category] varchar(100) NOT NULL,
    [Date] datetime NOT NULL,
    [PartyType] char(1) NOT NULL,
    [PartyCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_ActivityMonitor_Amount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [Printed] char(1) NOT NULL CONSTRAINT [DF_ActivityMonitor_Printed] DEFAULT ('N'),
    [MachineName] varchar(20) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NOT NULL,
    CONSTRAINT [PK_ActivityMonitor] PRIMARY KEY CLUSTERED ([DocumentType], [DocumentCode])
);
GO

CREATE TABLE [dbo].[AdditionalTaxRule] (
    [AdditionalTaxRuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_AdditionalTaxRule_AdditionalTaxRuleCode] PRIMARY KEY CLUSTERED ([AdditionalTaxRuleCode]),
    CONSTRAINT [UK_AdditionalTaxRule_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_AdditionalTaxRule_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AdjBufferDetail] (
    [AdjBufferCode] int NOT NULL,
    [ICode] int NOT NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [StockInHand] numeric(15,4) NOT NULL,
    [StockOnShelf] numeric(15,4) NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_AdjBufferDetail] PRIMARY KEY CLUSTERED ([AdjBufferCode], [ICode]),
    CONSTRAINT [CK_AdjBufferDetail_StockOnShelf] CHECK ([StockOnShelf] >= 0),
    CONSTRAINT [CK_AdjBufferDetail_StockInHand] CHECK ([StockInHand] >= 0)
);
GO

CREATE TABLE [dbo].[AdjBufferHeader] (
    [AdjBufferCode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Date] datetime NOT NULL,
    [ModifiedDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL,
    [PostedDate] datetime NULL,
    [PostedBy] smallint NULL,
    [UserCode] smallint NOT NULL,
    [AdjIncCode] int NULL,
    [AdjDecCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_AdjBufferHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_AdjBufferHeader] PRIMARY KEY CLUSTERED ([AdjBufferCode])
);
GO

CREATE TABLE [dbo].[AdjCategory] (
    [AdjCatCode] int NOT NULL,
    [Name] varchar(30) NOT NULL,
    CONSTRAINT [PK_AdjCategory_1__10] PRIMARY KEY CLUSTERED ([AdjCatCode])
);
GO

CREATE TABLE [dbo].[AdjDetail] (
    [AdjCode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdjDetail_LooseQty] DEFAULT (1),
    [Priority] tinyint NOT NULL CONSTRAINT [DF_AdjDetail_Priority_8__10] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_AdjDetail_Price] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdjDetail_AvgPrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_AdjDetail_PackUnits_4__10] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdjDetail_SalePrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdjDetail_PurPrice] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdjDetail_RecentPurPrice] DEFAULT (0),
    [AdjUtn] bigint NOT NULL,
    [UpdateAvgPrice] char(1) NOT NULL CONSTRAINT [DF_AdjDetail_UpdateAvgPrice] DEFAULT ('N'),
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_AdjDetail_7__10] PRIMARY KEY CLUSTERED ([AdjCode], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[AdjHeader] (
    [AdjCode] int NOT NULL,
    [AdjCatCode] int NOT NULL,
    [UserCode] int NOT NULL,
    [Remarks] varchar(100) NULL,
    [Date] datetime NOT NULL,
    [ModifiedDate] datetime NULL,
    [ModifiedBy] int NULL,
    [Posted] char(1) NOT NULL,
    [PostedDate] datetime NULL,
    [PostedBy] int NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_AdjHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [AccCode] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_AdjHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_AdjHeader_1__10] PRIMARY KEY CLUSTERED ([AdjCode])
);
GO

CREATE TABLE [dbo].[AdmittedPatientRecurringServices] (
    [AdmissionCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_AdmittedPatientRecurringServices_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdmittedPatientRecurringServices_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_AdmittedPatientRecurringServices_DiscPerc] DEFAULT (0),
    [RowId] int IDENTITY(1,1) NOT NULL,
    [SManCode] smallint NULL,
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_AdmittedPatientRecurringServices_ServiceFlatDisc] DEFAULT (0),
    [FrequencyHrs] int NOT NULL CONSTRAINT [DF_AdmittedPatientRecurringServices_FrequencyHrs] DEFAULT (24),
    [StartDate] datetime NULL,
    [NextRunOn] datetime NULL,
    CONSTRAINT [PK_AdmittedPatientRecurringServices] PRIMARY KEY CLUSTERED ([RowId])
);
GO

CREATE TABLE [dbo].[AdvPurDetail] (
    [AdvPurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvPurDetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvPurDetail_LooseQty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvPurDetail_BonusQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_AdvPurDetail_PackUnits] DEFAULT (1),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_ForeignPrice] DEFAULT (0),
    [PurPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_PurPrice] DEFAULT (0),
    [PurPrice2] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_PurPrice2] DEFAULT (0),
    [PurPrice3] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_PurPrice3] DEFAULT (0),
    [PurPrice4] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_PurPrice4] DEFAULT (0),
    [ItemFlatDisc] numeric(8,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_ItemFlatDisc] DEFAULT (0),
    [ItemFlatDisc2] numeric(8,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_ItemFlatDisc2] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_DiscPerc] DEFAULT (0),
    [DiscPerc2] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_DiscPerc2] DEFAULT (0),
    [UnitTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitTaxRuleCode] DEFAULT (1),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitSalesTax] DEFAULT (0),
    [GSTRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_GSTRuleCode] DEFAULT (1),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_GSTPerc] DEFAULT (0),
    [PurRowId] int IDENTITY(1,1) NOT NULL,
    [SalePrice] numeric(15,2) NOT NULL,
    [Rate] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_Rate] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_AvgPrice] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_NetRate] DEFAULT (0),
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_AdvPurDetail_CurrStock] DEFAULT (0),
    [PurUtn] bigint NULL,
    [ItemDescription] varchar(100) NULL,
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_SalePriceForItem] DEFAULT (0),
    [ItemFlatDiscAfterDiscperc] numeric(8,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_ItemFlatDiscAfterDiscperc] DEFAULT (0),
    [ValueDiscOnItem] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_ValueDiscOnItem] DEFAULT (0),
    [MeasureUnitCode] smallint NOT NULL CONSTRAINT [DF_AdvPurDetail_MeasureUnitCode] DEFAULT (1),
    [MeasureQty] numeric(9,4) NOT NULL CONSTRAINT [DF_AdvPurDetail_MeasureQty] DEFAULT (1),
    [MeasureUnitRate] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_MeasureUnitRate] DEFAULT (1),
    [GSTTYpeCode] smallint NOT NULL CONSTRAINT [DF_AdvPurDetail_GSTTYpeCode] DEFAULT (1),
    [RetailPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvPurDetail_RetailPrice] DEFAULT (0),
    [UnitIncomeTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitIncomeTaxRuleCode] DEFAULT (4),
    [UnitIncomeTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitIncomeTax] DEFAULT (0),
    [PercIncomeTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_PercIncomeTaxRuleCode] DEFAULT (4),
    [PercIncomeTax] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_PercIncomeTax] DEFAULT (0),
    [UnitAdditionalTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitAdditionalTaxRuleCode] DEFAULT (4),
    [UnitAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitAdditionalTax] DEFAULT (0),
    [PercAdditionalTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_PercAdditionalTaxRuleCode] DEFAULT (4),
    [PercAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_PercAdditionalTax] DEFAULT (0),
    [UnitExtraTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitExtraTaxRuleCode] DEFAULT (4),
    [UnitExtraTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitExtraTax] DEFAULT (0),
    [PercExtraTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_PercExtraTaxRuleCode] DEFAULT (4),
    [PercExtraTax] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_PercExtraTax] DEFAULT (0),
    [UnitCustomDutyRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitCustomDutyRuleCode] DEFAULT (4),
    [UnitCustomDuty] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_UnitCustomDuty] DEFAULT (0),
    [PercCustomDutyRuleCode] tinyint NOT NULL CONSTRAINT [DF_AdvPurDetail_PercCustomDutyRuleCode] DEFAULT (4),
    [PercCustomDuty] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_PercCustomDuty] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_RecentPurPrice] DEFAULT (0),
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_DiscountedSalePrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [CDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_CDiscPerc] DEFAULT (0),
    [CDiscPerc2] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_CDiscPerc2] DEFAULT (0),
    [CDiscPerc3] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurDetail_CDiscPerc3] DEFAULT (0),
    CONSTRAINT [PK_AdvPurDetail] PRIMARY KEY CLUSTERED ([AdvPurInvCode], [Gcode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[AdvPurHeader] (
    [AdvPurInvCode] int NOT NULL,
    [PurInvCode] int NULL,
    [PurCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SuppInvCode] varchar(10) NULL,
    [UserCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [POCode] int NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatDisc] DEFAULT (0),
    [FlatDisc2] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatDisc2] DEFAULT (0),
    [MiscCharges] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_MiscCharges] DEFAULT (0),
    [MiscCharges2] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_MiscCharges2] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SuppInvDate] datetime NULL,
    [GRN] varchar(15) NULL,
    [PORB] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_PORB] DEFAULT ('N'),
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_InvGSTPerc1] DEFAULT (0),
    [PurTypeCode] smallint NULL,
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_AdvPurHeader_HeaderNo] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_InvTotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_OutstandingAmt] DEFAULT (0),
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_PrintBalance] DEFAULT ('N'),
    [PurInvPageSize] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_PurInvPageSize] DEFAULT ('F'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_AdvPurHeader_CurrencyCode] DEFAULT (1),
    [ConversionFactor] numeric(11,5) NOT NULL CONSTRAINT [DF_AdvPurHeader_ConversionFactor] DEFAULT (1),
    [FlatIncomeTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatIncomeTax] DEFAULT (0),
    [PercIncomeTax] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_PercIncomeTax] DEFAULT (0),
    [FlatAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatAdditionalTax] DEFAULT (0),
    [PercAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_PercAdditionalTax] DEFAULT (0),
    [FlatExtraTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatExtraTax] DEFAULT (0),
    [PercExtraTax] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_PercExtraTax] DEFAULT (0),
    [FlatCustomDuty] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatCustomDuty] DEFAULT (0),
    [PercCustomDuty] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_PercCustomDuty] DEFAULT (0),
    [FlatExciseDuty] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FlatExciseDuty] DEFAULT (0),
    [PercExciseDuty] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_PercExciseDuty] DEFAULT (0),
    [FreightLocal] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FreightLocal] DEFAULT (0),
    [FreightForeign] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvPurHeader_FreightForeign] DEFAULT (0),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_AdvPurHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_AdvPurHeader] PRIMARY KEY CLUSTERED ([AdvPurInvCode])
);
GO

CREATE TABLE [dbo].[AdvSaleDetail] (
    [AdvSaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_AdvSaleDetail_PackQty] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_AdvSaleDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvSaleDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvSaleDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvSaleDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvSaleDetail_DiscPerc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [ItemFlatDisc] numeric(15,2) NULL CONSTRAINT [DF_AdvSaleDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NULL CONSTRAINT [DF_AdvSaleDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvSaleDetail_UnitTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_AdvSaleDetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_BonusQty] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_AdvSaleDetail_Claimable] DEFAULT ('N'),
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_AdvSaleDetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_AdvSaleDetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_BonusPackQtyForSale] DEFAULT (0),
    [DescICode] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_AdvSaleDetail_RPPUnitRate] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[AdvSaleLedger] (
    [AdvSaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DATE] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_MiscCharges] DEFAULT (0),
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_Posted] DEFAULT ('N'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_AdvSaleLedger_PostDate] DEFAULT (getdate()),
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(30) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [OriginalDATE] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [ReprintingCounter] tinyint NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_AdvSaleLedger_InvGSTPerc] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_PrintWaranty] DEFAULT ('Y'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_PrintBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_AdvSaleLedger_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_AdvSaleLedger_ItemDiscPercNo] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [BillingDate] datetime NULL,
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_PrintBalance] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDATE] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_OutstandingAmt] DEFAULT (0),
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_AdvSaleLedger_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_AdvSaleLedger_Balance] DEFAULT (0),
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_DELETED] DEFAULT ('N'),
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [CashAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_CashAmount] DEFAULT (0),
    [CreditAmt1] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_CreditAmt1] DEFAULT (0),
    [Credit1AccCode] smallint NULL,
    [CreditAmt2] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_CreditAmt2] DEFAULT (0),
    [Credit2AccCode] smallint NULL,
    [CreditAmt3] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_CreditAmt3] DEFAULT (0),
    [Credit3AccCode] smallint NULL,
    [RefundAmt] numeric(10,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_RefundAmt] DEFAULT (0),
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_AdvSaleLedger_Transmited] DEFAULT ('N'),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_AdvSaleLedger_CashTendered] DEFAULT (0),
    CONSTRAINT [PK_AdvSaleLedger] PRIMARY KEY CLUSTERED ([AdvSaleInvCode])
);
GO

CREATE TABLE [dbo].[AgingInterval] (
    [AgingIntervalCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_AgingInterval] PRIMARY KEY CLUSTERED ([AgingIntervalCode]),
    CONSTRAINT [UK_AgingInterval_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AgingIntervalDetail] (
    [AgingIntervalCode] smallint NOT NULL,
    [Limit] int NOT NULL CONSTRAINT [DF_AgingIntervalDetail_Limit] DEFAULT (0),
    CONSTRAINT [PK_AgingIntervalDetail] PRIMARY KEY CLUSTERED ([AgingIntervalCode], [Limit])
);
GO

CREATE TABLE [dbo].[Alert] (
    [AlertCode] smallint NOT NULL,
    [AlertTypeCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Detail] varchar(255) NOT NULL CONSTRAINT [DF_Alert_Detail] DEFAULT (''),
    CONSTRAINT [PK_Alert] PRIMARY KEY CLUSTERED ([AlertCode]),
    CONSTRAINT [UK_AlertType_Name1] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AlertType] (
    [AlertTypeCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_AlertType] PRIMARY KEY CLUSTERED ([AlertTypeCode]),
    CONSTRAINT [UK_AlertType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AlternateItemAlias] (
    [ICode] int NOT NULL,
    [CustomICode] varchar(75) NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_AlternateItemAlias_Qty] DEFAULT (1),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AlternateItemAlias_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AlternateItemAlias_SalePrice] DEFAULT (0),
    [PackingDesc] varchar(50) NULL,
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AlternateItemAlias_RetailPrice] DEFAULT (0),
    [Name] varchar(60) NOT NULL CONSTRAINT [DF_AlternateItemAlias_Name] DEFAULT (''),
    CONSTRAINT [PK_AlternateItemAlias] PRIMARY KEY CLUSTERED ([ICode], [CustomICode])
);
GO

CREATE TABLE [dbo].[AlternateItemAliasRequest] (
    [ItemRegReqCode] int NOT NULL,
    [CustomICode] varchar(75) NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_AlternateItemAliasRequest_Qty] DEFAULT (1),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AlternateItemAliasRequest_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AlternateItemAliasRequest_SalePrice] DEFAULT (0),
    [PackingDesc] varchar(50) NULL,
    CONSTRAINT [PK_AlternateItemAliasRequest] PRIMARY KEY CLUSTERED ([ItemRegReqCode], [CustomICode])
);
GO

CREATE TABLE [dbo].[AppointmentMethod] (
    [AppointmentMethodCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_AppointmentMethod_AppointmentMethodCode] PRIMARY KEY CLUSTERED ([AppointmentMethodCode]),
    CONSTRAINT [UK_AppointmentMethod_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AppointmentStatus] (
    [AppointmentStatusCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ColorValue] int NOT NULL CONSTRAINT [DF_AppointmentStatus_ColorCode] DEFAULT (255255255),
    CONSTRAINT [PK_AppointmentStatus_AppointmentStatusCode] PRIMARY KEY CLUSTERED ([AppointmentStatusCode]),
    CONSTRAINT [UK_AppointmentStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AppVersion] (
    [AppVersion] int NOT NULL,
    [Date] datetime NOT NULL,
    [UpdatedBy] varchar(50) NOT NULL,
    [MileStone] varchar(1000) NULL,
    [ScriptFiles] varchar(100) NULL,
    [LastReportRightID] int NOT NULL,
    [LastWindowRightID] int NOT NULL,
    [LastStartUpRightID] int NOT NULL,
    CONSTRAINT [PK_AppVersion] PRIMARY KEY CLUSTERED ([AppVersion])
);
GO

CREATE TABLE [dbo].[AppVersionDetail] (
    [AppVersion] int NOT NULL,
    [FeatureList] varchar(8000) NULL,
    [SubjectArea] varchar(100) NULL,
    [LicenseID] varchar(20) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[Area] (
    [AreaCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Manager] varchar(60) NULL,
    [RegionCode] smallint NULL,
    [ShortName] varchar(14) NOT NULL,
    [Tag] varchar(20) NOT NULL CONSTRAINT [DF_Area_Tag] DEFAULT ('Y'),
    CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED ([AreaCode]),
    CONSTRAINT [ANameUC] UNIQUE ([Name]),
    CONSTRAINT [IX_Area_ShortName] UNIQUE ([ShortName])
);
GO

CREATE TABLE [dbo].[AssocAdvSaleInvList] (
    [AdvSaleInvCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    CONSTRAINT [PK_AssocAdvSaleInvList] PRIMARY KEY CLUSTERED ([AdvSaleInvCode], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[AssociatedItemPart] (
    [IPartCode] int NOT NULL,
    [AssociatedIPartCode] int NOT NULL,
    CONSTRAINT [PK_AssociatedItemPart] PRIMARY KEY CLUSTERED ([IPartCode], [AssociatedIPartCode])
);
GO

CREATE TABLE [dbo].[AssocSaleInvList] (
    [SaleInvCode] int NOT NULL,
    [AssocSaleInvCode] int NOT NULL,
    CONSTRAINT [PK_AssocSaleInvList] PRIMARY KEY CLUSTERED ([SaleInvCode], [AssocSaleInvCode]),
    CONSTRAINT [UQ_AssocSaleInvList_AssocSaleInvCode] UNIQUE ([AssocSaleInvCode]),
    CONSTRAINT [CK_AssocSaleInvList_SaleInvCode_AssocSaleInvCode] CHECK ([SaleInvCode] <> [AssocSaleInvCode])
);
GO

CREATE TABLE [dbo].[Author] (
    [AuthorCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Remarks] varchar(400) NULL,
    CONSTRAINT [PK_Author_AuthorCode] PRIMARY KEY CLUSTERED ([AuthorCode]),
    CONSTRAINT [UK_Author_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[AutoSaleLog] (
    [ASLogCode] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_AutoSaleLog_Date] DEFAULT (getdate()),
    [SaleTemplateCode] int NOT NULL,
    [SSaleInvCode] int NOT NULL,
    [ESaleInvCode] int NOT NULL,
    [SDate] datetime NOT NULL,
    [EDate] datetime NOT NULL,
    CONSTRAINT [PK_AutoSaleLog_ASLogCode] PRIMARY KEY CLUSTERED ([ASLogCode])
);
GO

CREATE TABLE [dbo].[AvgPriceAdjDetail] (
    [DocumentCode] int NOT NULL,
    [ICODE] int NOT NULL,
    [UTN] bigint NOT NULL,
    [Stock] numeric(15,4) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_Stock] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_SalePrice] DEFAULT (0),
    [NewSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_NewSalePrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_PurPrice] DEFAULT (0),
    [NewPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_NewPurPrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_AvgPrice] DEFAULT (0),
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_AvgPriceAdjDetail_NewAvgPrice] DEFAULT (0),
    CONSTRAINT [PK_AvgPriceAdjDetail] PRIMARY KEY CLUSTERED ([DocumentCode], [ICODE])
);
GO

CREATE TABLE [dbo].[AvgPriceAdjHeader] (
    [DocumentCode] int NOT NULL,
    [DATE] datetime NOT NULL,
    [USERCODE] smallint NOT NULL,
    [REMARKS] varchar(100) NULL,
    [POSTED] char(1) NOT NULL CONSTRAINT [DF_AvgPriceAdjHeader_Posted] DEFAULT ('N'),
    [POSTDATE] datetime NOT NULL,
    [POSTEDBY] smallint NOT NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_AvgPriceAdjHeader_Amount] DEFAULT (0),
    [DR_ACCCODE] smallint NULL,
    [CR_ACCCODE] smallint NULL,
    [GLVOCHCODE] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_AvgPriceAdjHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_AvgPriceAdjHeader] PRIMARY KEY CLUSTERED ([DocumentCode])
);
GO

CREATE TABLE [dbo].[BillSummary] (
    [BillSummaryCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_BillSummary_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_BillSummary_Finalized] DEFAULT ('N'),
    [FinalizedOn] datetime NULL,
    [FinalizedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [BillSummaryTypeCode] smallint NOT NULL CONSTRAINT [DF_BillSummaryType_BillSummaryTypeCode] DEFAULT (1),
    CONSTRAINT [PK_BillSummary] PRIMARY KEY CLUSTERED ([BillSummaryCode])
);
GO

CREATE TABLE [dbo].[BillSummaryDetail] (
    [BillSummaryCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [AccBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_AccBalance] DEFAULT (0),
    [SaleInvCode] int NULL,
    [CashAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_CashAmt] DEFAULT (0),
    [CashAccCode] smallint NULL,
    [ChequeAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_ChequeAmt] DEFAULT (0),
    [BankAccCode] smallint NULL,
    [DebitNoteAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_DebitNoteAmt] DEFAULT (0),
    [DebitNoteAccCode] smallint NULL,
    [CreditNoteAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_CreditNoteAmt] DEFAULT (0),
    [CreditNoteAccCode] smallint NULL,
    [SRBufferInvCode] int NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_BillSummaryDetail_OutStandingAmt] DEFAULT (0),
    [BillsOnHandBreakup] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_BillSummaryDetail] PRIMARY KEY CLUSTERED ([BillSummaryCode], [CustCode], [RowID])
);
GO

CREATE TABLE [dbo].[BillSummaryType] (
    [BillSummaryTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_BillSummaryType] PRIMARY KEY CLUSTERED ([BillSummaryTypeCode]),
    CONSTRAINT [UK_BillSummaryType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[BioMetricMachine] (
    [MachineCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Manufacturer] varchar(100) NULL,
    [Model] varchar(100) NULL,
    [IPAddress] varchar(100) NOT NULL,
    [PORT] int NOT NULL,
    CONSTRAINT [PK_BioMetricMachine] PRIMARY KEY CLUSTERED ([MachineCode])
);
GO

CREATE TABLE [dbo].[BirthCertificate] (
    [BirthCertificateCode] int NOT NULL,
    [PatientCode] int NOT NULL,
    [VisitCode] int NULL,
    [AdmissionCode] int NULL,
    [UserCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_BirthCertificate_Date] DEFAULT (getdate()),
    [DOB] datetime NOT NULL CONSTRAINT [DF_BirthCertificate_DOB] DEFAULT (getdate()),
    [ChildName] varchar(100) NULL,
    [Gender] char(1) NULL CONSTRAINT [DF_BirthCertificate_Gender] DEFAULT ('M'),
    [FatherName] varchar(100) NULL,
    [FatherCNIC] varchar(100) NULL,
    [FatherCellNo] varchar(100) NULL,
    [MotherName] varchar(100) NULL,
    [MotherCNIC] varchar(100) NULL,
    [MotherCellNo] varchar(100) NULL,
    [AgeOfMother] varchar(100) NULL,
    [PlaceOfBirth] varchar(100) NULL,
    [DoctorName] varchar(100) NULL,
    [HospitalName] varchar(100) NULL,
    [IssuedTo] varchar(100) NULL,
    [IssuedToCNIC] varchar(100) NULL,
    [IssuedToCellNo] varchar(100) NULL,
    CONSTRAINT [PK_BirthCertificate] PRIMARY KEY CLUSTERED ([BirthCertificateCode])
);
GO

CREATE TABLE [dbo].[BonusPolicy] (
    [BonusPolicyCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_BonusPolicy_BonusPolicyCode] PRIMARY KEY CLUSTERED ([BonusPolicyCode]),
    CONSTRAINT [UK_BonusPolicy_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[BonusPolicyDetail] (
    [BonusPolicyCode] smallint NOT NULL,
    [QtyLimit] int NOT NULL,
    [SaleQty] int NOT NULL,
    [BonusQty] int NOT NULL,
    [ExpiryDate] datetime NOT NULL,
    CONSTRAINT [PK_BonusPolicyDetail_BonusPolicyCode_QtyLimit] PRIMARY KEY CLUSTERED ([BonusPolicyCode], [QtyLimit])
);
GO

CREATE TABLE [dbo].[CABG] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CABG_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [HadCABG] char(1) NULL,
    [HadCABGOn] datetime NULL,
    [Surgeon] varchar(255) NULL,
    [Institution] varchar(255) NULL,
    [Lima] char(1) NULL,
    [LimaValue] numeric(10,2) NULL,
    [SVG] char(1) NULL,
    [SVGValue] numeric(10,2) NULL,
    [Other] varchar(255) NULL,
    [Remarks] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_CABG_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_CABG_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[CashAccAllowedModule] (
    [ModuleID] smallint NOT NULL,
    CONSTRAINT [PK__CashAccAllowedMo__47133DEC] PRIMARY KEY CLUSTERED ([ModuleID])
);
GO

CREATE TABLE [dbo].[CashierActivity] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL,
    [ModuleID] smallint NOT NULL,
    [DocCode] int NULL,
    [CatCode] smallint NOT NULL,
    [Category] varchar(100) NOT NULL,
    [AccCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [MachineName] varchar(20) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_CashierActivity_Amount] DEFAULT (0),
    [CashAccCode] smallint NOT NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_CashierActivity_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_CashierActivity_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_CashierActivity_CashBack] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [CashierJobCode] int NULL,
    [Printed] char(1) NOT NULL CONSTRAINT [DF_CashierActivity_Printed] DEFAULT ('N'),
    [Supervised] char(1) NOT NULL CONSTRAINT [DF_CashierActivity_Supervised] DEFAULT ('N'),
    [SupervisedOn] datetime NULL,
    [GLVochCode] int NULL,
    CONSTRAINT [PK_CashierActivity] PRIMARY KEY CLUSTERED ([RowID])
);
GO

CREATE TABLE [dbo].[CashierJob] (
    [CashierJobCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CashierJob_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [JobOwner] smallint NOT NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_CashierJob_Active] DEFAULT ('Y'),
    [Remarks] varchar(100) NULL,
    [InactiveDate] datetime NULL,
    [ShowSupervisedDocuments] char(1) NOT NULL CONSTRAINT [DF_CashierJob_ShowSupervisedDocuments] DEFAULT ('Y'),
    [DefaultFilterCriteria] varchar(500) NULL,
    CONSTRAINT [PK_CashierJob] PRIMARY KEY CLUSTERED ([CashierJobCode])
);
GO

CREATE TABLE [dbo].[CashierJobModule] (
    [CashierJobCode] int NOT NULL,
    [ModuleID] smallint NOT NULL,
    CONSTRAINT [PK_CashierJobModule] PRIMARY KEY CLUSTERED ([CashierJobCode], [ModuleID])
);
GO

CREATE TABLE [dbo].[CashierShift] (
    [CashierShiftCode] int NOT NULL,
    [OpenedOn] datetime NOT NULL CONSTRAINT [DF_CashierShift_OpenedOn] DEFAULT (getdate()),
    [ClosedOn] datetime NULL,
    [OpenedBy] smallint NOT NULL,
    [ShiftOwner] smallint NOT NULL,
    [ShiftStatus] char(1) NOT NULL CONSTRAINT [DF_CashierShift_ShiftStatus] DEFAULT ('O'),
    [CashAccCode] smallint NOT NULL,
    [OpeningBalance] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_OpeningBalance] DEFAULT (0),
    [TotalAmount] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_TotalAmount] DEFAULT (0),
    [AmtTransfered] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_AmtTransfered] DEFAULT (0),
    [AmtTransferedTo] smallint NULL,
    [AmtTransferedOn] datetime NULL,
    [Remarks] varchar(100) NULL,
    [RefNo] varchar(20) NULL,
    [CashSales] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CashSales] DEFAULT (0),
    [CreditSales] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CreditSales] DEFAULT (0),
    [CashSR] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CashSR] DEFAULT (0),
    [CreditSR] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CreditSR] DEFAULT (0),
    [CashService] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CashService] DEFAULT (0),
    [CreditService] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CreditService] DEFAULT (0),
    [CashServiceReturn] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CashServiceReturn] DEFAULT (0),
    [CreditServiceReturn] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_CreditServiceReturn] DEFAULT (0),
    [TotalReceipts] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_TotalReceipts] DEFAULT (0),
    [TotalPayments] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_TotalPayments] DEFAULT (0),
    [NetAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_NetAmt] DEFAULT (0),
    [DiffAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShift_DiffAmt] DEFAULT (0),
    [DiffTransferedTo] smallint NULL,
    [ClosedBy] smallint NULL,
    CONSTRAINT [PK_CashierShift] PRIMARY KEY CLUSTERED ([CashierShiftCode])
);
GO

CREATE TABLE [dbo].[CashierShiftCashCount] (
    [CashierShiftCode] int NOT NULL,
    [CurrencyCode] smallint NOT NULL,
    [Type] char(1) NOT NULL CONSTRAINT [DF_CashierShiftCashCount_Type] DEFAULT ('C'),
    [Name] varchar(60) NOT NULL,
    [Denomination] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierShiftCashCount_Denomination] DEFAULT (1),
    [Qty] int NULL CONSTRAINT [DF_CashierShiftCashCount_Qty] DEFAULT (1),
    CONSTRAINT [PK_CashierShiftCashCount] PRIMARY KEY CLUSTERED ([CashierShiftCode], [CurrencyCode], [Type], [Denomination])
);
GO

CREATE TABLE [dbo].[CashierShiftUsers] (
    [CashierShiftCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_CashierShiftUsers] PRIMARY KEY CLUSTERED ([CashierShiftCode], [UserCode])
);
GO

CREATE TABLE [dbo].[CashierTemplate] (
    [InterfaceCode] tinyint NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [RowID] int NOT NULL,
    CONSTRAINT [PK_CashierTemplate] PRIMARY KEY CLUSTERED ([InterfaceCode], [AccCode], [RowID])
);
GO

CREATE TABLE [dbo].[CashierWindow] (
    [SaleInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_CashierWindow_Amount] DEFAULT (0),
    [RowID] int NOT NULL,
    CONSTRAINT [PK_CashierWindow] PRIMARY KEY CLUSTERED ([SaleInvCode], [AccCode], [RowID])
);
GO

CREATE TABLE [dbo].[CategoryAccounts] (
    [CatAccCode] smallint NOT NULL,
    [MainAccCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_CategoryAccounts] PRIMARY KEY CLUSTERED ([CatAccCode]),
    CONSTRAINT [CANameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CategorySegment] (
    [CategorySegmentCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CategorySegment] PRIMARY KEY CLUSTERED ([CategorySegmentCode]),
    CONSTRAINT [UK_CategorySegment_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CheckListItem] (
    [CheckListItemCode] int NOT NULL,
    [NAME] varchar(100) NOT NULL,
    [AutoCheck] char(1) NOT NULL CONSTRAINT [DF_CheckListItem_AutoCheck] DEFAULT ('Y'),
    CONSTRAINT [PK_CheckListItem] PRIMARY KEY CLUSTERED ([CheckListItemCode]),
    CONSTRAINT [UK_CheckListItem_Name] UNIQUE ([NAME])
);
GO

CREATE TABLE [dbo].[Class] (
    [ClassCode] int IDENTITY(1,1) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ClassYear] int NOT NULL CONSTRAINT [DF_Class_ClassYear] DEFAULT (datepart(year,getdate())),
    [GradeCode] smallint NOT NULL,
    [CreationDate] datetime NOT NULL CONSTRAINT [DF_Class_CreationDate] DEFAULT (getdate()),
    [FeeDueOn] tinyint NOT NULL CONSTRAINT [DF_Class_FeeDueOn] DEFAULT (1),
    [Fee] numeric(10,2) NOT NULL CONSTRAINT [DF_Class_Fee] DEFAULT (0),
    [Active] char(1) NOT NULL CONSTRAINT [DF_Class_Active] DEFAULT ('Y'),
    [ClassTypeCode] smallint NOT NULL CONSTRAINT [DF_Class_ClassTypeCode] DEFAULT (1),
    [ClassMediumCode] smallint NOT NULL CONSTRAINT [DF_Class_ClassMediumCode] DEFAULT (1),
    [SchoolBranchCode] smallint NOT NULL CONSTRAINT [DF_Class_SchoolBranchCode] DEFAULT (1),
    [ServiceForTuitionFee] int NULL,
    [SchoolCode] smallint NOT NULL CONSTRAINT [DF_Class_SchoolCode] DEFAULT (1),
    [Promoted] char(1) NOT NULL CONSTRAINT [DF_Class_Promoted] DEFAULT ('N'),
    [Graduated] char(1) NOT NULL CONSTRAINT [DF_Class_Graduated] DEFAULT ('N'),
    [ShortName] varchar(100) NOT NULL CONSTRAINT [DF_Class_ShortName] DEFAULT ('.'),
    [WhatsAppGroupName] varchar(100) NOT NULL CONSTRAINT [DF_Class_WhatsAppGroupName] DEFAULT ('.'),
    CONSTRAINT [PK_Class] PRIMARY KEY CLUSTERED ([ClassCode]),
    CONSTRAINT [UK_Class_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ClassGraduation] (
    [GraduationCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ClassGraduation_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [ClassCode] int NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ClassGraduation] PRIMARY KEY CLUSTERED ([GraduationCode])
);
GO

CREATE TABLE [dbo].[ClassGraduationDetail] (
    [GraduationCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [RollNo] varchar(40) NOT NULL,
    [Graduate] char(1) NOT NULL CONSTRAINT [DF_ClassGraduationDetail_Graduate] DEFAULT ('Y'),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ClassGraduationDetail] PRIMARY KEY CLUSTERED ([GraduationCode], [StudentCode])
);
GO

CREATE TABLE [dbo].[ClassMedium] (
    [ClassMediumCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ClassMedium] PRIMARY KEY CLUSTERED ([ClassMediumCode]),
    CONSTRAINT [UK_ClassMedium_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ClassPromotion] (
    [PromotionCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ClassPromotion_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [PromoteClassFrom] int NOT NULL,
    [PromoteClassTo] int NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ClassPromotion] PRIMARY KEY CLUSTERED ([PromotionCode])
);
GO

CREATE TABLE [dbo].[ClassPromotionDetail] (
    [PromotionCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [RollNo] varchar(40) NOT NULL,
    [Promote] char(1) NOT NULL CONSTRAINT [DF_ClassPromotionDetail_Promote] DEFAULT ('Y'),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ClassPromotionDetail] PRIMARY KEY CLUSTERED ([PromotionCode], [StudentCode])
);
GO

CREATE TABLE [dbo].[ClassType] (
    [ClassTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ClassType] PRIMARY KEY CLUSTERED ([ClassTypeCode]),
    CONSTRAINT [UK_ClassType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ClientInstance] (
    [Name] varchar(100) NOT NULL,
    [ClientID] smallint NULL,
    [ClientInstanceID] smallint NULL
);
GO

CREATE TABLE [dbo].[ClientSetup] (
    [LicenceNo] smallint NOT NULL,
    [HeaderNo] tinyint NOT NULL,
    [ClientName] varchar(100) NOT NULL,
    [Address1] varchar(100) NOT NULL,
    [Address2] varchar(100) NULL,
    [Phone] varchar(24) NULL,
    [Fax] varchar(24) NULL,
    [DrugLicenceNo] varchar(20) NULL,
    [OwnerName] varchar(30) NULL,
    [Email] varchar(60) NULL,
    CONSTRAINT [PK___2__13] PRIMARY KEY CLUSTERED ([LicenceNo], [HeaderNo])
);
GO

CREATE TABLE [dbo].[cmh_accounts] (
    [accode] decimal(5,0) NOT NULL,
    [subcode] decimal(3,0) NOT NULL,
    [name] char(60) NOT NULL,
    [opendate] datetime NOT NULL,
    [currbal] decimal(10,2) NOT NULL,
    [bbaldt] datetime NOT NULL,
    [bbal] decimal(15,2) NOT NULL,
    [cbal] decimal(15,2) NOT NULL,
    [sbal] decimal(15,2) NOT NULL,
    [aliasname] char(20) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_area] (
    [areacode] decimal(3,0) NOT NULL,
    [name] char(60) NOT NULL,
    [manager] char(60) NOT NULL,
    [regcode] decimal(3,0) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_customer] (
    [custcode] decimal(5,0) NOT NULL,
    [areacode] decimal(3,0) NOT NULL,
    [cp] char(60) NOT NULL,
    [address1] char(60) NOT NULL,
    [city] char(30) NOT NULL,
    [country] char(30) NOT NULL,
    [phone] char(30) NOT NULL,
    [fax] char(16) NOT NULL,
    [email] char(30) NOT NULL,
    [crlimit] decimal(10,2) NOT NULL,
    [dayslimit] decimal(5,0) NOT NULL,
    [custcatcod] decimal(2,0) NOT NULL,
    [address2] char(60) NOT NULL,
    [licenceno] char(30) NOT NULL,
    [licexpiry] datetime NOT NULL,
    [messno] decimal(2,0) NOT NULL,
    [smancode] decimal(3,0) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_custtype] (
    [custcatcod] decimal(2,0) NOT NULL,
    [name] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_godown] (
    [gcode] decimal(3,0) NOT NULL,
    [name] char(60) NOT NULL,
    [location] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_iclass] (
    [iccode] decimal(4,0) NOT NULL,
    [name] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_item] (
    [icode] decimal(10,0) NOT NULL,
    [name] char(60) NOT NULL,
    [iccode] decimal(4,0) NOT NULL,
    [icatcode] decimal(2,0) NOT NULL,
    [packcode] decimal(3,0) NOT NULL,
    [manfcode] decimal(4,0) NOT NULL,
    [saleprice] decimal(9,2) NOT NULL,
    [purprice] decimal(9,2) NOT NULL,
    [retailpric] decimal(9,2) NOT NULL,
    [avgprice] decimal(11,5) NOT NULL,
    [sdiscperc] decimal(5,2) NOT NULL,
    [pdiscperc] decimal(5,2) NOT NULL,
    [salestax] decimal(6,2) NOT NULL,
    [reorderqty] decimal(5,0) NOT NULL,
    [optimumqty] decimal(6,0) NOT NULL,
    [packunits] decimal(5,0) NOT NULL,
    [active] bit NOT NULL,
    [prescribed] decimal(1,0) NOT NULL,
    [refrigrate] bit NOT NULL,
    [printable] bit NOT NULL,
    [location] char(20) NOT NULL,
    [remarks] char(40) NOT NULL,
    [location1] char(20) NOT NULL,
    [remarks1] char(40) NOT NULL,
    [gcode] decimal(3,0) NOT NULL,
    [antinorcotixs] char(1) NOT NULL,
    [restricted] char(1) NOT NULL,
    [rpp] decimal(9,2) NOT NULL,
    [saleprice2] decimal(9,2) NOT NULL,
    [saleprice3] decimal(9,2) NOT NULL,
    [customicode] char(6) NOT NULL,
    [saleqty] decimal(3,0) NOT NULL,
    [bonusqty] decimal(3,0) NOT NULL,
    [pexpiry] decimal(1,0) NOT NULL,
    [packdesc] char(10) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_itemcat] (
    [icatcode] decimal(2,0) NOT NULL,
    [name] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_manufact] (
    [manfcode] decimal(4,0) NOT NULL,
    [name] char(60) NOT NULL,
    [shortname] char(40) NOT NULL,
    [address1] char(60) NOT NULL,
    [city] char(30) NOT NULL,
    [country] char(30) NOT NULL,
    [phone] char(30) NOT NULL,
    [fax] char(16) NOT NULL,
    [cp] char(60) NOT NULL,
    [email] char(30) NOT NULL,
    [address2] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[CMH_messages] (
    [messagecode] char(2) NOT NULL,
    [description] char(20) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_packing] (
    [packcode] decimal(3,0) NOT NULL,
    [name] char(20) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_region] (
    [regcode] decimal(3,0) NOT NULL,
    [regname] char(30) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_salesman] (
    [salemano] decimal(3,0) NOT NULL,
    [name] char(30) NOT NULL,
    [address] char(61) NOT NULL,
    [phone] char(20) NOT NULL
);
GO

CREATE TABLE [dbo].[cmh_supplier] (
    [suppcode] decimal(5,0) NOT NULL,
    [cp] char(60) NOT NULL,
    [address1] char(60) NOT NULL,
    [city] char(30) NOT NULL,
    [country] char(30) NOT NULL,
    [phone] char(30) NOT NULL,
    [fax] char(16) NOT NULL,
    [email] char(30) NOT NULL,
    [address2] char(60) NOT NULL
);
GO

CREATE TABLE [dbo].[ColumnEditStyle] (
    [ColumnName] varchar(60) NOT NULL,
    [ColPrecision] tinyint NOT NULL CONSTRAINT [DF__ColumnEdi__ColPr__4B97FBE7] DEFAULT (0),
    [StyleName] varchar(60) NOT NULL,
    [StyleDesc] varchar(60) NOT NULL,
    CONSTRAINT [PK_ColumnEditStyle] PRIMARY KEY CLUSTERED ([ColumnName], [ColPrecision])
);
GO

CREATE TABLE [dbo].[ColumnPreferences] (
    [ColumnName] varchar(60) NOT NULL,
    [ColPrecision] tinyint NOT NULL CONSTRAINT [DF_ColumnPreferences_ColPrecision] DEFAULT (0),
    CONSTRAINT [PK_ColumnPreferences] PRIMARY KEY CLUSTERED ([ColumnName]),
    CONSTRAINT [CK_ColumnPreferences_CoPrecision] CHECK ([ColPrecision] >= 0 and [ColPrecision] <= 4)
);
GO

CREATE TABLE [dbo].[CompanyHeader] (
    [Company] varchar(15) NOT NULL,
    [HeaderNo] int NOT NULL,
    [CreationDateTime] datetime NULL,
    [LastUpdation] datetime NULL,
    [Remarks] varchar(100) NULL,
    [ClientName] varchar(255) NULL,
    [Address1] varchar(255) NULL,
    [Address2] varchar(255) NULL,
    [Phone] varchar(255) NULL,
    [Fax] varchar(255) NULL,
    [DrugLicenceNo] varchar(255) NULL,
    [OwnerName] varchar(255) NULL,
    [Email] varchar(255) NULL,
    CONSTRAINT [PK_CompanyHeader] PRIMARY KEY CLUSTERED ([Company], [HeaderNo])
);
GO

CREATE TABLE [dbo].[ConfigSetting] (
    [Name] varchar(100) NOT NULL,
    [VALUE] varchar(200) NOT NULL,
    CONSTRAINT [PK_ConfigSetting_Name] PRIMARY KEY CLUSTERED ([Name])
);
GO

CREATE TABLE [dbo].[ContactCard] (
    [ContactCardCode] int NOT NULL,
    [AccCode] smallint NULL,
    [Title] varchar(50) NOT NULL CONSTRAINT [DF_ContactCard_Title] DEFAULT ('Mr.'),
    [Name] varchar(100) NOT NULL,
    [Address] varchar(1000) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Mobile] varchar(255) NULL,
    [UseForSMS] char(1) NOT NULL CONSTRAINT [DF_ContactCard_UseForSMS] DEFAULT ('N'),
    [Web] varchar(100) NULL,
    CONSTRAINT [PK_ContactCard] PRIMARY KEY CLUSTERED ([ContactCardCode])
);
GO

CREATE TABLE [dbo].[ContactGroup] (
    [ContactGroupCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ContactGroup] PRIMARY KEY CLUSTERED ([ContactGroupCode]),
    CONSTRAINT [UK_ContactGroup_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ContactGroupDetail] (
    [ContactGroupCode] smallint NOT NULL,
    [ContactCardCode] int NOT NULL,
    CONSTRAINT [PK_ContactGroupDetail] PRIMARY KEY CLUSTERED ([ContactGroupCode], [ContactCardCode])
);
GO

CREATE TABLE [dbo].[ContactPolicy] (
    [ContactPolicyCode] int NOT NULL,
    [AliasName] varchar(12) NOT NULL,
    [NAME] varchar(100) NOT NULL,
    [Remarks] varchar(400) NULL,
    CONSTRAINT [PK_ContactPolicy_ContactPolicyCode] PRIMARY KEY CLUSTERED ([ContactPolicyCode]),
    CONSTRAINT [UK_ContactPolicy_Name] UNIQUE ([NAME]),
    CONSTRAINT [UK_ContactPolicy_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[ContactPolicyDetail] (
    [ContactPolicyCode] int NOT NULL,
    [WeekDayCode] tinyint NOT NULL,
    [WeekOfMonth] tinyint NOT NULL,
    CONSTRAINT [PK_ContactPolicyDetail] PRIMARY KEY CLUSTERED ([ContactPolicyCode], [WeekDayCode], [WeekOfMonth])
);
GO

CREATE TABLE [dbo].[CoronoryAngiogram] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CoronoryAngiogram_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [HadCoronaryAngiogram] char(1) NULL,
    [HadCoronaryAngiogramon] datetime NULL,
    [NormalCoronaries] char(1) NULL,
    [MildCoronary] char(1) NULL,
    [ArteryDisease] char(1) NULL,
    [DiffuseCoronaryArteryDisease] char(1) NULL,
    [EctaticCoronayArteries] char(1) NULL,
    [SVCAD] char(1) NULL,
    [DVCAD] char(1) NULL,
    [TVCAD] char(1) NULL,
    [OtherAngiogramFeature] varchar(255) NULL,
    [Remarks] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_CoronoryAngiogram_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_CoronoryAngiogram_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[CoronoryAngioplasty] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CoronoryAngioplasty_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [HadCoronoryAngioplasty] char(1) NULL,
    [HadCoronoryAngioplastyOn] datetime NULL,
    [DESCoronoryAngioplasty] char(1) NULL,
    [DESQtyCoronoryAngioplasty] tinyint NULL,
    [DesLADCoronoryAngioplasty] char(1) NULL,
    [DesLcxCoronoryAngioplasty] char(1) NULL,
    [DesRCACoronoryAngioplasty] char(1) NULL,
    [DesDiagnolCoronoryAngioplasty] char(1) NULL,
    [DesOMCoronoryAngioplasty] char(1) NULL,
    [DesPDACoronoryAngioplasty] char(1) NULL,
    [DesOthersCoronoryAngioplasty] varchar(255) NULL,
    [BMSCoronoryAngioplasty] char(1) NULL,
    [BMSQtyCoronoryAngioplasty] tinyint NULL,
    [BMSLADCoronoryAngioplasty] char(1) NULL,
    [BMSLcxCoronoryAngioplasty] char(1) NULL,
    [BMSRCACoronoryAngioplasty] char(1) NULL,
    [BMSDiagnolCoronoryAngioplasty] char(1) NULL,
    [BMSOMCoronoryAngioplasty] char(1) NULL,
    [BMSPDACoronoryAngioplasty] char(1) NULL,
    [BMSOthersCoronoryAngioplasty] varchar(255) NULL,
    [HadPreviousISR] char(1) NULL,
    [HadPreviousISRON] datetime NULL,
    [DESPreviousISR] char(1) NULL,
    [DESQtyISR] tinyint NULL,
    [DESLADPreviousISR] char(1) NULL,
    [DESLcxPreviousISR] char(1) NULL,
    [DESRCAPreviousISR] char(1) NULL,
    [DESDiagnolPreviousISR] char(1) NULL,
    [DESOMPreviousISR] char(1) NULL,
    [DESPDAPreviousISR] char(1) NULL,
    [DESOtherPreviousISR] varchar(255) NULL,
    [BMSPreviousISR] char(1) NULL,
    [BMSQtyISR] tinyint NULL,
    [BMSLADPreviousISR] char(1) NULL,
    [BMSLcxPreviousISR] char(1) NULL,
    [BMSRCAPreviousISR] char(1) NULL,
    [BMSDiagnolPreviousISR] char(1) NULL,
    [BMSOMPreviousISR] char(1) NULL,
    [BMSPDAPreviousISR] char(1) NULL,
    [BMSOtherPreviousISR] varchar(255) NULL,
    [HadReStenting] char(1) NULL,
    [HadReStentingOn] datetime NULL,
    [DESReStenting] char(1) NULL,
    [DESQtyReStenting] tinyint NULL,
    [DESLADReStenting] char(1) NULL,
    [DESLcxReStenting] char(1) NULL,
    [DESRCAReStenting] char(1) NULL,
    [DESDiagnolReStenting] char(1) NULL,
    [DESOMReStenting] char(1) NULL,
    [DESPDAReStenting] char(1) NULL,
    [DESOtherReStenting] varchar(255) NULL,
    [BMSReStenting] char(1) NULL,
    [BMSQtyReStenting] tinyint NULL,
    [BMSLADReStenting] char(1) NULL,
    [BMSLcxReStenting] char(1) NULL,
    [BMSRCAReStenting] char(1) NULL,
    [BMSDiagnolReStenting] char(1) NULL,
    [BMSOMReStenting] char(1) NULL,
    [BMSPDAReStenting] char(1) NULL,
    [BMSOtherReStenting] varchar(255) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_CoronoryAngioplasty_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_CoronoryAngioplasty_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[County] (
    [CountyCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(200) NULL,
    CONSTRAINT [PK__County__20B88ADA] PRIMARY KEY CLUSTERED ([CountyCode])
);
GO

CREATE TABLE [dbo].[CrossTab_ReportData] (
    [Code1] int NULL,
    [Code2] int NULL,
    [Code3] int NULL,
    [Code4] int NULL,
    [Code5] int NULL,
    [Code6] int NULL,
    [Code7] int NULL,
    [Code8] int NULL,
    [Code9] int NULL,
    [Code10] int NULL,
    [Name1] varchar(100) NULL,
    [Name2] varchar(100) NULL,
    [Name3] varchar(100) NULL,
    [Name4] varchar(100) NULL,
    [Name5] varchar(100) NULL,
    [Name6] varchar(100) NULL,
    [Name7] varchar(100) NULL,
    [Name8] varchar(100) NULL,
    [Name9] varchar(100) NULL,
    [Name10] varchar(100) NULL,
    [Value1] numeric(15,5) NULL,
    [Value2] numeric(15,5) NULL,
    [Value3] numeric(15,5) NULL,
    [Value4] numeric(15,5) NULL,
    [Value5] numeric(15,5) NULL,
    [Value6] numeric(15,5) NULL,
    [Value7] numeric(15,5) NULL,
    [Value8] numeric(15,5) NULL,
    [Value9] numeric(15,5) NULL,
    [Value10] numeric(15,5) NULL,
    [Value11] numeric(15,5) NULL,
    [Value12] numeric(15,5) NULL,
    [Value13] numeric(15,5) NULL,
    [Value14] numeric(15,5) NULL,
    [Value15] numeric(15,5) NULL,
    [C_Code1] int NULL,
    [C_Code2] int NULL,
    [C_Code3] int NULL,
    [C_Code4] int NULL,
    [C_Code5] int NULL,
    [C_Code6] int NULL,
    [C_Code7] int NULL,
    [C_Code8] int NULL,
    [C_Code9] int NULL,
    [C_Code10] int NULL,
    [C_Code11] int NULL,
    [C_Code12] int NULL,
    [C_Code13] int NULL,
    [C_Name1] varchar(100) NULL,
    [C_Name2] varchar(100) NULL,
    [C_Name3] varchar(100) NULL,
    [C_Name4] varchar(100) NULL,
    [C_Name5] varchar(100) NULL,
    [C_Name6] varchar(100) NULL,
    [C_Name7] varchar(100) NULL,
    [C_Name8] varchar(100) NULL,
    [C_Name9] varchar(100) NULL,
    [C_Name10] varchar(100) NULL,
    [C_Name11] varchar(100) NULL,
    [C_Name12] varchar(100) NULL,
    [C_Name13] varchar(100) NULL,
    [Qty1] numeric(15,4) NULL,
    [Qty2] numeric(15,4) NULL,
    [Qty3] numeric(15,4) NULL,
    [Qty4] numeric(15,4) NULL,
    [Qty5] numeric(15,4) NULL,
    [Qty6] numeric(15,4) NULL,
    [Qty7] numeric(15,4) NULL,
    [Qty8] numeric(15,4) NULL,
    [Qty9] numeric(15,4) NULL,
    [Qty10] numeric(15,4) NULL,
    [Qty11] numeric(15,4) NULL,
    [Qty12] numeric(15,4) NULL,
    [Qty13] numeric(15,4) NULL,
    [Val1] numeric(15,5) NULL,
    [Val2] numeric(15,5) NULL,
    [Val3] numeric(15,5) NULL,
    [Val4] numeric(15,5) NULL,
    [Val5] numeric(15,5) NULL,
    [Val6] numeric(15,5) NULL,
    [Val7] numeric(15,5) NULL,
    [Val8] numeric(15,5) NULL,
    [Val9] numeric(15,5) NULL,
    [Val10] numeric(15,5) NULL,
    [Val11] numeric(15,5) NULL,
    [Val12] numeric(15,5) NULL,
    [Val13] numeric(15,5) NULL,
    [TotQty] numeric(15,4) NULL,
    [TotVal] numeric(15,5) NULL
);
GO

CREATE TABLE [dbo].[CRS_Accounts] (
    [ClientID] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [SubCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [OpeningDate] datetime NOT NULL,
    [AliasName] varchar(12) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_CRS_Accounts_Active] DEFAULT ('Y'),
    [Restricted] char(1) NOT NULL CONSTRAINT [DF_CRS_Accounts_Restricted] DEFAULT ('N'),
    CONSTRAINT [PK_CRS_Accounts] PRIMARY KEY CLUSTERED ([ClientID], [AccCode])
);
GO

CREATE TABLE [dbo].[CRS_AdjDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [AdjCode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [Priority] tinyint NOT NULL,
    [Price] numeric(12,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL,
    [RecentPurPrice] numeric(12,2) NOT NULL,
    [AdjUtn] bigint NOT NULL,
    [UpdateAvgPrice] char(1) NOT NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL,
    [CurrStock] numeric(15,4) NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_CRS_AdjDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [AdjCode], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[CRS_AdjHeader] (
    [ClientInstanceID] smallint NOT NULL,
    [AdjCode] int NOT NULL,
    [AdjCatCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Date] datetime NOT NULL,
    [ModifiedDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL,
    [PostedDate] datetime NULL,
    [PostedBy] smallint NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [AccCode] smallint NULL,
    [Synced] char(1) NULL CONSTRAINT [DF_CRS_AdjHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_CRS_AdjHeader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [AdjCode])
);
GO

CREATE TABLE [dbo].[CRS_Area] (
    [ClientID] smallint NOT NULL,
    [AreaCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Manager] varchar(100) NOT NULL,
    [RegionCode] smallint NOT NULL,
    [ShortName] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_Area] PRIMARY KEY CLUSTERED ([ClientID], [AreaCode])
);
GO

CREATE TABLE [dbo].[CRS_CashierWindow] (
    [ClientInstanceID] smallint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_CashierWindow_Amount] DEFAULT (0),
    [RowID] int NOT NULL,
    CONSTRAINT [PK_CRS_CashierWindow] PRIMARY KEY CLUSTERED ([ClientInstanceID], [SaleInvCode], [AccCode], [RowID])
);
GO

CREATE TABLE [dbo].[CRS_CategoryAccounts] (
    [ClientID] smallint NOT NULL,
    [CatAccCode] smallint NOT NULL,
    [MainAccCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_CategoryAccounts] PRIMARY KEY CLUSTERED ([ClientID], [CatAccCode])
);
GO

CREATE TABLE [dbo].[CRS_ClientInstance] (
    [ClientInstanceID] smallint NOT NULL,
    [ClientID] smallint NOT NULL,
    [Name] varchar(100) NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_CRS_ClientInstance_ClientInstanceID] PRIMARY KEY CLUSTERED ([ClientInstanceID]),
    CONSTRAINT [UK_CRS_ClientInstance_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CRS_ClientList] (
    [ClientID] smallint NOT NULL,
    [Name] varchar(100) NULL,
    [Address1] varchar(255) NULL,
    [Address2] varchar(255) NULL,
    [Phone] varchar(100) NULL,
    [Phone2] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Web] varchar(100) NULL,
    [CP] varchar(100) NULL,
    [CPPhone] varchar(100) NULL,
    [CPMobile] varchar(100) NULL,
    CONSTRAINT [PK_CRS_ClientList_ClientID] PRIMARY KEY CLUSTERED ([ClientID]),
    CONSTRAINT [UK_CRS_ClientList_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CRS_County] (
    [ClientID] smallint NOT NULL,
    [CountyCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(200) NULL,
    CONSTRAINT [PK_CRS_County] PRIMARY KEY CLUSTERED ([ClientID], [CountyCode])
);
GO

CREATE TABLE [dbo].[CRS_Currency] (
    [ClientID] smallint NOT NULL,
    [CurrencyCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(10) NULL,
    [ConversionFactor] numeric(11,5) NOT NULL,
    CONSTRAINT [PK_CRS_Currency] PRIMARY KEY CLUSTERED ([ClientID], [CurrencyCode])
);
GO

CREATE TABLE [dbo].[CRS_Customer] (
    [ClientID] smallint NOT NULL,
    [CustCode] smallint NOT NULL,
    [AreaCode] smallint NOT NULL,
    [CP] varchar(100) NULL,
    [Address1] varchar(100) NULL,
    [City] varchar(100) NULL,
    [Country] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [CrLimit] numeric(10,2) NOT NULL,
    [DaysLimit] smallint NOT NULL,
    [CustCatCode] smallint NULL,
    [Address2] varchar(100) NULL,
    [LicenceNo] varchar(100) NULL,
    [LicenceExpiry] datetime NULL,
    [PriceOnSale] smallint NULL,
    [DiscOnSale] smallint NULL,
    [SalesTaxRegNo] varchar(100) NULL,
    [DefaultGST] tinyint NOT NULL,
    [MessageCode] smallint NULL,
    [SalesManCode] smallint NULL,
    [InvDiscPerc] numeric(6,2) NOT NULL,
    [DefaultSalePrice] tinyint NOT NULL,
    [DefaultItemDiscPerc] tinyint NOT NULL,
    [SchedForPosting] char(1) NOT NULL,
    [Designation] varchar(1000) NULL,
    [SpecialInstructions] varchar(4000) NULL,
    [SubAreaCode] smallint NOT NULL,
    [BankName] varchar(100) NULL,
    [BankAdd] varchar(100) NULL,
    [AllowSaleBelowAvgPrice] char(1) NOT NULL,
    [SaleTypeCode] smallint NOT NULL,
    [CP2] varchar(100) NULL,
    [Gender] char(1) NOT NULL,
    [NIC] varchar(100) NULL,
    [DOB] datetime NULL,
    [Occupation] varchar(100) NULL,
    [EduQualf] varchar(100) NULL,
    [RefNo] varchar(100) NULL,
    [ConsiderInPO] char(1) NOT NULL,
    [MemberShipID] varchar(100) NULL,
    [NTNNo] varchar(100) NULL,
    [PrintWaranty] char(1) NOT NULL,
    [PostCode] varchar(100) NULL,
    [CountyCode] smallint NULL,
    [GCCode] smallint NULL,
    CONSTRAINT [PK_CRS_Customer] PRIMARY KEY CLUSTERED ([ClientID], [CustCode])
);
GO

CREATE TABLE [dbo].[CRS_CustomerCategory] (
    [ClientID] smallint NOT NULL,
    [CustCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AllowInCashSale] char(1) NOT NULL,
    [AllowInCreditSale] char(1) NOT NULL,
    [CustomerSegmentCode] smallint NOT NULL,
    CONSTRAINT [PK_CRS_CustomerCategory] PRIMARY KEY CLUSTERED ([ClientID], [CustCatCode])
);
GO

CREATE TABLE [dbo].[CRS_CustomerSegment] (
    [ClientID] smallint NOT NULL,
    [CustomerSegmentCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_CustomerSegment] PRIMARY KEY CLUSTERED ([ClientID], [CustomerSegmentCode])
);
GO

CREATE TABLE [dbo].[CRS_DataTransferLog] (
    [LogID] int IDENTITY(1,1) NOT NULL,
    [ClientInstanceID] smallint NOT NULL,
    [UserCode] smallint NULL,
    [StartDate] datetime NOT NULL CONSTRAINT [DF_CRS_DataTransferLog_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_CRS_DataTransferLog_EndDate] DEFAULT (getdate()),
    CONSTRAINT [PK_CRS_DataTransferLog] PRIMARY KEY CLUSTERED ([LogID])
);
GO

CREATE TABLE [dbo].[CRS_DataTransferLogDetail] (
    [LogID] int NOT NULL,
    [SourceTableName] varchar(100) NOT NULL,
    [StartDate] datetime NOT NULL CONSTRAINT [DF_CRS_DataTransferLogDetail_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_CRS_DataTransferLogDetail_EndDate] DEFAULT (getdate()),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_CRS_DataTransferLogDetail] PRIMARY KEY CLUSTERED ([LogID], [SourceTableName])
);
GO

CREATE TABLE [dbo].[CRS_Department] (
    [ClientID] smallint NOT NULL,
    [DeptCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_CRS_Department] PRIMARY KEY CLUSTERED ([ClientID], [DeptCode])
);
GO

CREATE TABLE [dbo].[CRS_Disease] (
    [ClientID] smallint NOT NULL,
    [DiseaseCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_CRS_Disease] PRIMARY KEY CLUSTERED ([ClientID], [DiseaseCode])
);
GO

CREATE TABLE [dbo].[CRS_Doctors] (
    [ClientID] smallint NOT NULL,
    [DoctCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AliasName] varchar(100) NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [City] varchar(100) NULL,
    [Country] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Des] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Fee] numeric(10,2) NOT NULL,
    [Title1] varchar(100) NULL,
    [Title2] varchar(100) NULL,
    [Title3] varchar(100) NULL,
    [Title4] varchar(100) NULL,
    [Footer1] varchar(100) NULL,
    [Footer2] varchar(100) NULL,
    [Footer3] varchar(100) NULL,
    [Footer4] varchar(100) NULL,
    CONSTRAINT [PK_CRS_Doctors] PRIMARY KEY CLUSTERED ([ClientID], [DoctCode])
);
GO

CREATE TABLE [dbo].[CRS_DueSatisfyDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [DueSatisfyCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [DueSatisfyQty] numeric(15,4) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [DueSatisfyUtn] bigint NULL,
    [PackSalePrice] numeric(12,2) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SaleRowID] int NULL
);
GO

CREATE TABLE [dbo].[CRS_DueSatisfyHeader] (
    [ClientInstanceID] smallint NOT NULL,
    [DueSatisfyCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [DueSatisfyDate] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [DueAdjCode] int NULL,
    CONSTRAINT [PK_CRS_DueSatisfyHeader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [DueSatisfyCode])
);
GO

CREATE TABLE [dbo].[CRS_GLDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [GLVochCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Debit] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_GLDetail_Debit] DEFAULT (0),
    [Credit] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_GLDetail_Credit] DEFAULT (0),
    [ChkNo] varchar(20) NULL,
    [Remarks] varchar(100) NULL,
    [GLRowID] int NOT NULL,
    [GLUTN] bigint NULL,
    [PatientCode] int NULL,
    [INVOICECODE] int NULL,
    [OUTSTANDINGAMT] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_GLDetail_OUTSTANDINGAMT] DEFAULT (0),
    [BALANCE] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_GLDetail_BALANCE] DEFAULT (0),
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [ForeignAmt] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_GLHeader_ForeignAmt] DEFAULT (0),
    CONSTRAINT [PK_CRS_GLDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [GLVochCode], [GLRowID])
);
GO

CREATE TABLE [dbo].[CRS_Glheader] (
    [ClientInstanceID] smallint NOT NULL,
    [GLVochCode] int NOT NULL,
    [VochCatCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [salesmancode] smallint NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [CHKNO] varchar(20) NULL,
    [VoucherCode] int NOT NULL CONSTRAINT [DF_CRS_GLHeader_VoucherCode] DEFAULT (0),
    [SManCode] smallint NULL,
    [TransferAble] char(1) NOT NULL CONSTRAINT [DF_CRS_GLHeader_TransferAble] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_CRS_GLHeader_Transfered] DEFAULT ('N'),
    [TransferedON] datetime NULL,
    [TransferedBY] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_CRS_GLHeader_Imported] DEFAULT ('N'),
    [ImportedBY] smallint NULL,
    [BillSummaryCode] int NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_CRS_GLHeader_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_CRS_GLHeader_ConversionRate] DEFAULT (1),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_GLHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_CRS_Glheader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [GLVochCode])
);
GO

CREATE TABLE [dbo].[CRS_Godown] (
    [ClientID] smallint NOT NULL,
    [GCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Location] varchar(100) NULL,
    [GodownGroupCode] smallint NOT NULL,
    CONSTRAINT [PK_CRS_Godown] PRIMARY KEY CLUSTERED ([ClientID], [GCode])
);
GO

CREATE TABLE [dbo].[CRS_GodownDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [CurrQty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_GodownDetail_CurrQty] DEFAULT (0),
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Priority] tinyint NOT NULL,
    [ManfDate] datetime NULL,
    [LastUpdated] datetime NOT NULL CONSTRAINT [DF_CRS_GdowonDetail_LastUpdated] DEFAULT (getdate()),
    CONSTRAINT [PK_CRS_GodownDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[CRS_GodownGroup] (
    [ClientID] smallint NOT NULL,
    [GodownGroupCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_CRS_GodownGroup] PRIMARY KEY CLUSTERED ([ClientID], [GodownGroupCode])
);
GO

CREATE TABLE [dbo].[CRS_GoodsCompany] (
    [ClientID] smallint NOT NULL,
    [GCCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [City] varchar(100) NULL,
    [Country] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Des] varchar(100) NULL,
    [Email] varchar(100) NULL,
    CONSTRAINT [PK_CRS_GoodsCompany] PRIMARY KEY CLUSTERED ([ClientID], [GCCode])
);
GO

CREATE TABLE [dbo].[CRS_GuaranteePerson] (
    [ClientID] smallint NOT NULL,
    [GuaranteePersonCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [FHName] varchar(100) NULL,
    [Address] varchar(300) NULL,
    [Phone] varchar(100) NULL,
    [Mobile] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Web] varchar(100) NULL,
    CONSTRAINT [PK_CRS_GuaranteePerson] PRIMARY KEY CLUSTERED ([ClientID], [GuaranteePersonCode])
);
GO

CREATE TABLE [dbo].[CRS_IssueCategory] (
    [ClientInstanceID] smallint NOT NULL,
    [IssueCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [Description] varchar(255) NULL,
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueCategory_AccountFor] DEFAULT ('Y'),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueCategory_Posted] DEFAULT ('N'),
    [Counter] int NOT NULL CONSTRAINT [DF_CRS_IssueCategory_Counter] DEFAULT (0),
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueCategory_Enabled] DEFAULT ('Y'),
    CONSTRAINT [PK_CRS_IssueCategory] PRIMARY KEY CLUSTERED ([ClientInstanceID], [IssueCategoryCode])
);
GO

CREATE TABLE [dbo].[CRS_IssueDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [IssueInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [GCode] smallint NOT NULL,
    [Priority] tinyint NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [PurchasePrice] numeric(12,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [MRPP] numeric(12,2) NOT NULL,
    [IssRowID] int NOT NULL,
    [IssueUtn] bigint NULL,
    [SectCode] smallint NULL,
    [Price] numeric(12,2) NOT NULL,
    [SaleOrderRowID] int NULL,
    [ItemDescription] varchar(100) NULL,
    [RowGroup] int NOT NULL,
    [IssueReqRowID] int NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_CRS_IssueDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_CRS_IssueDetail_PiecesInHand] DEFAULT (0),
    [ServiceIssueReqRowID] int NULL,
    [ServiceRowID] int NULL,
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CRS_IssueDetail_ClaimableDiscPerc] DEFAULT (0),
    [ReceiptRowID] int NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_IssueDetail_BalanceStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[CRS_IssueHeader] (
    [ClientInstanceID] smallint NOT NULL,
    [IssueInvCode] int NOT NULL,
    [DeptCode] smallint NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Deleted] char(1) NULL,
    [DeletedBy] smallint NULL,
    [Posted] char(1) NOT NULL,
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [SManCode] smallint NULL,
    [AreaCode] smallint NOT NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [IssueTypeCode] smallint NULL,
    [ReferenceNo] varchar(100) NULL,
    [ReferenceDate] datetime NULL,
    [PriceTypeCode] tinyint NOT NULL,
    [RecipientCode] smallint NOT NULL,
    [AccCode] smallint NULL,
    [RecipientSalesMan] smallint NULL,
    [Terms1] varchar(100) NULL,
    [Terms2] varchar(100) NULL,
    [PatientCode] int NULL,
    [CustSiteCode] int NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [OrderDate] datetime NULL,
    [ServiceOCode] int NULL,
    [WorkOrderCode] int NULL,
    [ServiceIssueRequestCode] int NULL,
    [ServiceInvCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [ReceiptInvCode] int NULL,
    [IssueCategoryCode] smallint NOT NULL CONSTRAINT [DF_CRS_IssueHeader_IssueCategoryCode] DEFAULT (1),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueHeader_AccountFor] DEFAULT ('N'),
    [DrAccCode] smallint NULL,
    [IssueCode] int NOT NULL CONSTRAINT [DF_CRS_IssueHeader_IssueCode] DEFAULT (0),
    [PrintWarranty] char(1) NOT NULL CONSTRAINT [DF_CRS_IssueHeader_PrintWarranty] DEFAULT ('N'),
    [QuotationCode] int NULL,
    [MotorVehicleCode] int NULL,
    CONSTRAINT [PK_CRS_IssueHeader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [IssueInvCode])
);
GO

CREATE TABLE [dbo].[CRS_IssueType] (
    [ClientID] smallint NOT NULL,
    [IssueTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_IssueType] PRIMARY KEY CLUSTERED ([ClientID], [IssueTypeCode])
);
GO

CREATE TABLE [dbo].[CRS_MainAccounts] (
    [ClientID] smallint NOT NULL,
    [MainAccCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_MainAccounts] PRIMARY KEY CLUSTERED ([ClientID], [MainAccCode])
);
GO

CREATE TABLE [dbo].[CRS_MasterCashWin] (
    [ClientInstanceID] smallint NOT NULL,
    [DocumentCode] int NOT NULL,
    [DocumentType] varchar(2) NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_MasterCashWin_Amount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [RowID] int NOT NULL,
    CONSTRAINT [PK_CRS_MasterCashWin] PRIMARY KEY CLUSTERED ([ClientInstanceID], [DocumentType], [DocumentCode], [AccCode])
);
GO

CREATE TABLE [dbo].[CRS_Message] (
    [ClientID] smallint NOT NULL,
    [MessageCode] smallint NOT NULL,
    [Description] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_Message] PRIMARY KEY CLUSTERED ([ClientID], [MessageCode])
);
GO

CREATE TABLE [dbo].[CRS_Notes] (
    [ClientInstanceID] smallint NOT NULL,
    [NoteCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [BankAccCode] smallint NULL,
    [IssueDate] datetime NOT NULL,
    [DueDate] datetime NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_Notes_Amount] DEFAULT (0),
    [BankName] varchar(40) NULL,
    [DocumentNumber] varchar(40) NULL,
    [Remarks] varchar(60) NULL,
    [NoteCatCode] tinyint NOT NULL,
    [Posted] char(1) NULL,
    [PostDate] datetime NULL,
    [SalesmanCode] smallint NULL,
    [VoucherCode] int NOT NULL CONSTRAINT [DF_CRS_Notes_VoucherCode] DEFAULT (0),
    [Modified] char(1) NOT NULL CONSTRAINT [DF_CRS_Notes_Modified] DEFAULT ('N'),
    [ModifiedBY] smallint NULL,
    [PostedBY] smallint NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_CRS_Notes_Finalized] DEFAULT ('N'),
    [FinalizedDate] datetime NULL,
    [FinalizedBy] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_Notes_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_CRS_Notes] PRIMARY KEY CLUSTERED ([ClientInstanceID], [NoteCode])
);
GO

CREATE TABLE [dbo].[CRS_NotesDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [NoteCode] int NOT NULL,
    [InvoiceCode] int NOT NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_NotesDetail_OutstandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_NotesDetail_Amt] DEFAULT (0),
    [NoteROWID] int NOT NULL,
    [NotesUTN] bigint NOT NULL,
    CONSTRAINT [PK_CRS_NotesDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [NoteCode], [InvoiceCode])
);
GO

CREATE TABLE [dbo].[CRS_Patient] (
    [ClientID] smallint NOT NULL,
    [PatientCode] int NOT NULL,
    [RegNo] varchar(100) NOT NULL,
    [Active] char(1) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [FName] varchar(100) NULL,
    [Gender] char(1) NOT NULL,
    [DOB] datetime NULL,
    [Date] datetime NULL,
    [CustCode] smallint NULL,
    [UserCode] smallint NOT NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [City] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [InactiveDate] datetime NULL,
    [DoctCode] smallint NULL,
    [EmployeeName] varchar(100) NULL,
    [CreatedBy] smallint NOT NULL,
    [InactivedBy] smallint NULL,
    [DiseaseCode] smallint NULL,
    [Diagnosis] varchar(100) NULL,
    [InactiveCount] int NOT NULL,
    [RecurringPeriod] int NOT NULL,
    [PatientCatCode] smallint NOT NULL,
    [Profession] varchar(100) NULL,
    [Reference] varchar(100) NULL,
    [CrLimit] numeric(10,2) NOT NULL,
    [RefNo1] varchar(100) NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [RefNo6] varchar(100) NULL,
    [RefNo7] varchar(100) NULL,
    [CashAccCode] smallint NOT NULL,
    [CashTendered] numeric(15,2) NOT NULL,
    [CashCharged] numeric(15,2) NOT NULL,
    [CashBack] numeric(15,2) NOT NULL,
    [Address3] varchar(100) NULL,
    [Institute] varchar(100) NULL,
    [Phone2] varchar(100) NULL,
    [Nationality] varchar(100) NULL,
    [MobileNo1] varchar(100) NULL,
    [MobileNo2] varchar(100) NULL,
    [MobileNo3] varchar(100) NULL,
    [FamilyMembers] varchar(20) NULL,
    [Brothers] varchar(20) NULL,
    [Sisters] varchar(20) NULL,
    [MotherName] varchar(100) NULL,
    [Profession2] varchar(100) NULL,
    [PassportNo] varchar(100) NULL,
    [AgeYears] smallint NULL,
    [AgeMonths] smallint NULL,
    [AgeDays] smallint NULL,
    CONSTRAINT [PK_CRS_Patient] PRIMARY KEY CLUSTERED ([ClientID], [PatientCode])
);
GO

CREATE TABLE [dbo].[CRS_PatientCategory] (
    [ClientID] smallint NOT NULL,
    [PatientCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_PatientCategory] PRIMARY KEY CLUSTERED ([ClientID], [PatientCatCode])
);
GO

CREATE TABLE [dbo].[CRS_PRDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [PRInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [BonusQty] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [PRPrice] numeric(12,2) NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [PackSalePrice] numeric(12,2) NOT NULL,
    [UnitSalesTax] numeric(12,2) NOT NULL,
    [GSTPerc] numeric(6,2) NOT NULL,
    [PRUtn] bigint NULL,
    [ItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL,
    [PiecesInHand] int NOT NULL,
    [PRRowID] int NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [HistoricalBatch] varchar(100) NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_PRDetail_BalanceStock] DEFAULT (0),
    CONSTRAINT [PK_CRS_PRDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PRInvCode], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[CRS_PRLedger] (
    [ClientInstanceID] smallint NOT NULL,
    [PRInvCode] int NOT NULL,
    [PurInvCode] int NULL,
    [PRCatCode] tinyint NULL,
    [SuppCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL,
    [MiscCharges] numeric(12,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [InvGSTPerc1] numeric(5,2) NOT NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL,
    [AccountFor] char(1) NOT NULL,
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL,
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(100) NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL,
    [Marked] char(1) NOT NULL,
    [PRTypeCode] smallint NULL,
    [Terms1] varchar(100) NULL,
    [Terms2] varchar(100) NULL,
    [Terms3] varchar(100) NULL,
    [Terms4] varchar(100) NULL,
    [Terms5] varchar(100) NULL,
    [PurchaseInvNo] varchar(100) NULL,
    [ICatCode] smallint NULL,
    [UpdateAvgPriceWithNetRate] char(1) NOT NULL CONSTRAINT [DF_CRS_PrLedger_UpdateAvgPriceWithNetRate] DEFAULT ('N'),
    [CustCode] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_PRLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [DataCarryCustCode] smallint NULL,
    CONSTRAINT [PK_CRS_PRLedger] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PRInvCode])
);
GO

CREATE TABLE [dbo].[CRS_ProformaPurDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_LooseQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_PurPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_AvgPrice] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_BonusQty] DEFAULT (0),
    [PurRowId] int NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_PurRowId] DEFAULT (1),
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_CRS_ProformaPurdetail_CurrStock] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_GSTPerc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_UnitSalesTax] DEFAULT (0),
    [PurUtn] bigint NULL,
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_SalePrice] DEFAULT (0),
    [itemdescription] varchar(100) NULL,
    [rate] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_rate] DEFAULT (0),
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_SalePriceForItem] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_ForeignPrice] DEFAULT (0),
    [PurPriceInAdvPur] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_PurPriceInAdvPur] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_ProformaPurDetail_NetRate] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_RecentPurPrice] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_CRS_ProformaPurdetail_PiecesInHand] DEFAULT (0),
    [ReceiptRowID] int NULL,
    CONSTRAINT [PK_CRS_ProformaPurdetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PurInvCode], [PurRowId])
);
GO

CREATE TABLE [dbo].[CRS_PurchaseType] (
    [ClientID] smallint NOT NULL,
    [PurTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_PurchaseType] PRIMARY KEY CLUSTERED ([ClientID], [PurTypeCode])
);
GO

CREATE TABLE [dbo].[CRS_PurDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [BonusQty] numeric(15,4) NOT NULL,
    [PurRowID] int NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL,
    [GSTPerc] numeric(6,2) NOT NULL,
    [UnitSalesTax] numeric(12,2) NOT NULL,
    [PurUtn] bigint NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [ItemDescription] varchar(100) NULL,
    [Rate] numeric(12,2) NOT NULL,
    [SalePriceForItem] numeric(12,2) NOT NULL,
    [ForeignPrice] numeric(15,5) NOT NULL,
    [PurPriceInAdvPur] numeric(15,5) NOT NULL,
    [NetRate] numeric(15,5) NOT NULL,
    [RecentPurPrice] numeric(12,2) NOT NULL,
    [TotalPieces] int NOT NULL,
    [PiecesInHand] int NOT NULL,
    [ReceiptRowID] int NULL,
    [ManfCodeForItem] smallint NULL,
    [DiscountedSalePrice] numeric(12,2) NOT NULL,
    [FlatDiscForItem] numeric(12,2) NOT NULL,
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_RetailPrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [ManfDate] datetime NULL,
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_CRS_PurDetail_UnitWeight] DEFAULT (1),
    [QE1] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_QE1] DEFAULT (0),
    [QE2] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_QE2] DEFAULT (0),
    [QE3] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_QE3] DEFAULT (0),
    [QE4] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_QE4] DEFAULT (0),
    [QE5] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_QE5] DEFAULT (0),
    [WE1] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_WE1] DEFAULT (0),
    [WE2] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_WE2] DEFAULT (0),
    [WE3] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_WE3] DEFAULT (0),
    [WE4] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_WE4] DEFAULT (0),
    [WE5] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_WE5] DEFAULT (0),
    [BatchSalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_BatchSalePrice] DEFAULT (0),
    [GodownStock] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_PurDetail_GodownStock] DEFAULT (0),
    [Location] varchar(100) NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurDetail_ItemFlatDisc] DEFAULT (0),
    [LockBatch] char(1) NOT NULL CONSTRAINT [DF_CRS_PurDetail_LockBatch] DEFAULT ('N'),
    [LockReasonCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurDetail_LockReasonCode] DEFAULT (1),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_CRS_PurDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [SalesTaxScheduleCode] smallint NULL,
    [PCTCode] int NULL,
    [ItemAlertCode] smallint NULL,
    CONSTRAINT [PK_CRS_PurDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PurInvCode], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[CRS_PurExp] (
    [ClientInstanceID] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_PurExp_Amount] DEFAULT (0),
    [RowID] int NOT NULL CONSTRAINT [DF_CRS_PurExp_RowID] DEFAULT (1),
    CONSTRAINT [PK_CRS_PurExp] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PurInvCode], [AccCode])
);
GO

CREATE TABLE [dbo].[CRS_PurLedger] (
    [ClientInstanceID] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [PurCatCode] tinyint NULL,
    [SuppCode] smallint NOT NULL,
    [SuppInvCode] varchar(100) NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [POCode] int NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL,
    [MiscCharges] numeric(12,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SuppInvDate] datetime NULL,
    [GRN] varchar(100) NULL,
    [PORB] char(1) NULL,
    [InvGSTPerc1] numeric(5,2) NOT NULL,
    [PurTypeCode] smallint NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL,
    [AccountFor] char(1) NOT NULL,
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL,
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(100) NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL,
    [Marked] char(1) NOT NULL,
    [PrintBalance] char(1) NOT NULL,
    [PurInvPageSize] char(1) NOT NULL,
    [CurrencyCode] smallint NOT NULL,
    [ConversionFactor] numeric(11,5) NOT NULL,
    [PrintCounter] tinyint NOT NULL,
    [AssociatedSaleOrderCode] int NULL,
    [AssociatedSaleInvCode] int NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [NewPurchaseOrderNo] varchar(100) NULL,
    [LCNO] varchar(100) NULL,
    [UpdateAvgPriceWithNetRate] char(1) NOT NULL,
    [ImpactInventory] char(1) NOT NULL,
    [ImpPurInvCode] int NULL,
    [CreditDays] int NULL,
    [SuppInvAmount] numeric(15,2) NOT NULL,
    [ICatCode] smallint NULL,
    [MonthlyCounter] int NOT NULL CONSTRAINT [DF_CRS_PurLedger_MonthlyCounter] DEFAULT (0),
    [DailyCounter] int NOT NULL CONSTRAINT [DF_CRS_PurLedger_DailyCounter] DEFAULT (0),
    [CustCode] smallint NULL,
    [QE1_AccCode] smallint NULL,
    [QE2_AccCode] smallint NULL,
    [QE3_AccCode] smallint NULL,
    [QE4_AccCode] smallint NULL,
    [QE5_AccCode] smallint NULL,
    [WE1_AccCode] smallint NULL,
    [WE2_AccCode] smallint NULL,
    [WE3_AccCode] smallint NULL,
    [WE4_AccCode] smallint NULL,
    [WE5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_QExp1_CrAccCode] DEFAULT (4),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_QExp2_CrAccCode] DEFAULT (4),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_QExp3_CrAccCode] DEFAULT (4),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_QExp4_CrAccCode] DEFAULT (4),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_QExp5_CrAccCode] DEFAULT (4),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_WExp1_CrAccCode] DEFAULT (4),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_WExp2_CrAccCode] DEFAULT (4),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_WExp3_CrAccCode] DEFAULT (4),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_WExp4_CrAccCode] DEFAULT (4),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_WExp5_CrAccCode] DEFAULT (4),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_PurLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [PurSlipPrintCounter] tinyint NOT NULL CONSTRAINT [DF_CRS_PurLedger_PurSlipPrintCounter] DEFAULT (0),
    [TaxCategoryCode] smallint NOT NULL CONSTRAINT [DF_CRS_PurLedger_TaxCategory_TaxCategoryCode] DEFAULT (1),
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_CRS_PurLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_CRS_PurLedger_AdvanceTaxAmt] DEFAULT (0),
    CONSTRAINT [PK_CRS_PurLedger] PRIMARY KEY CLUSTERED ([ClientInstanceID], [PurInvCode])
);
GO

CREATE TABLE [dbo].[CRS_ReceiptCategory] (
    [ClientInstanceID] smallint NOT NULL,
    [ReceiptCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [Description] varchar(255) NULL,
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_CRS_ReceiptCategory_AccountFor] DEFAULT ('Y'),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CRS_ReceiptCategory_Posted] DEFAULT ('N'),
    [Counter] int NOT NULL CONSTRAINT [DF_CRS_ReceiptCategory_Counter] DEFAULT (0),
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_CRS_ReceiptCategory_Enabled] DEFAULT ('Y'),
    CONSTRAINT [PK_CRS_ReceiptCategory] PRIMARY KEY CLUSTERED ([ClientInstanceID], [ReceiptCategoryCode])
);
GO

CREATE TABLE [dbo].[CRS_ReceiptDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [ReceiptInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [GCode] smallint NOT NULL,
    [Priority] tinyint NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [PurchasePrice] numeric(12,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [MRPP] numeric(12,2) NOT NULL,
    [ReceiptUtn] bigint NULL,
    [SectCode] smallint NULL,
    [Price] numeric(12,2) NOT NULL,
    [UpdateAvgPrice] char(1) NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL,
    [ItemDescription] varchar(100) NULL,
    [SaleOrderRowID] int NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_PiecesInHand] DEFAULT (0),
    [IssueRowID] int NULL,
    [ManfDate] datetime NULL,
    [ROWID] int NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_ROWID] DEFAULT (1),
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_UnitWeight] DEFAULT (1),
    [QE1] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_QE1] DEFAULT (0),
    [QE2] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_QE2] DEFAULT (0),
    [QE3] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_QE3] DEFAULT (0),
    [QE4] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_QE4] DEFAULT (0),
    [QE5] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_QE5] DEFAULT (0),
    [WE1] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_WE1] DEFAULT (0),
    [WE2] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_WE2] DEFAULT (0),
    [WE3] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_WE3] DEFAULT (0),
    [WE4] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_WE4] DEFAULT (0),
    [WE5] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_ReceiptDetail_WE5] DEFAULT (0),
    CONSTRAINT [PK_CRS_ReceiptDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [ReceiptInvCode], [GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[CRS_ReceiptHeader] (
    [ClientInstanceID] smallint NOT NULL,
    [ReceiptInvCode] int NOT NULL,
    [DeptCode] smallint NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Deleted] char(1) NULL,
    [DeletedBy] smallint NULL,
    [Posted] char(1) NOT NULL,
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [AreaCode] smallint NULL,
    [SManCode] smallint NULL,
    [ReferenceNo] varchar(100) NULL,
    [ReferenceDate] datetime NULL,
    [PriceTypeCode] tinyint NOT NULL,
    [RecipientCode] smallint NOT NULL,
    [AccCode] smallint NULL,
    [RecipientSalesMan] smallint NULL,
    [WorkOrderCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [ReceiptCategoryCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_ReceiptCategoryCode] DEFAULT (1),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_AccountFor] DEFAULT ('N'),
    [CrAccCode] smallint NULL,
    [ReceiptCode] int NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_ReceiptCode] DEFAULT (0),
    [QE1_AccCode] smallint NULL,
    [QE2_AccCode] smallint NULL,
    [QE3_AccCode] smallint NULL,
    [QE4_AccCode] smallint NULL,
    [QE5_AccCode] smallint NULL,
    [WE1_AccCode] smallint NULL,
    [WE2_AccCode] smallint NULL,
    [WE3_AccCode] smallint NULL,
    [WE4_AccCode] smallint NULL,
    [WE5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_QExp1_CrAccCode] DEFAULT (34),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_QExp2_CrAccCode] DEFAULT (34),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_QExp3_CrAccCode] DEFAULT (34),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_QExp34_CrAccCode] DEFAULT (34),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_QExp5_CrAccCode] DEFAULT (34),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_WExp1_CrAccCode] DEFAULT (34),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_WExp2_CrAccCode] DEFAULT (34),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_WExp3_CrAccCode] DEFAULT (34),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_WExp34_CrAccCode] DEFAULT (34),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_ReceiptHeader_WExp5_CrAccCode] DEFAULT (34),
    [MotorVehicleCode] int NULL,
    [IssueInvCode] int NULL,
    CONSTRAINT [PK_CRS_ReceiptHeader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [ReceiptInvCode])
);
GO

CREATE TABLE [dbo].[CRS_Region] (
    [ClientID] smallint NOT NULL,
    [RegionCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Manager] varchar(100) NOT NULL,
    [Remarks] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_Region] PRIMARY KEY CLUSTERED ([ClientID], [RegionCode])
);
GO

CREATE TABLE [dbo].[CRS_SaleDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [Rate] numeric(12,2) NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [RowID] int NOT NULL,
    [DUE] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL,
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL,
    [UnitSalesTax] numeric(12,2) NOT NULL,
    [GSTPerc] numeric(6,2) NOT NULL,
    [SaleUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL,
    [Claimable] char(1) NOT NULL,
    [BalanceStock] numeric(15,4) NOT NULL,
    [RowGroup] int NOT NULL,
    [ClaimableDiscPerc] numeric(6,2) NOT NULL,
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL,
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL,
    [RPPUnitRate] numeric(15,4) NOT NULL,
    [TotalPieces] int NOT NULL,
    [PiecesInHand] int NOT NULL,
    [PackSalePrice] numeric(15,4) NOT NULL,
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL,
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_BatchCost] DEFAULT (0),
    [InsCode] smallint NULL,
    [YourLotNo] varchar(100) NULL,
    [YourExpiry] datetime NULL,
    [YourPacking] varchar(100) NULL,
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_Width] DEFAULT (1),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_Length] DEFAULT (1),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_CRS_SaleDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CloneItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_CloneItemFlatDisc] DEFAULT (0),
    [CloneDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_CloneDiscPerc] DEFAULT (0),
    [GodownBalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SaleDetail_GodownBalanceStock] DEFAULT (0),
    CONSTRAINT [PK_CRS_SaleDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [SaleInvCode], [RowID])
);
GO

CREATE TABLE [dbo].[CRS_SaleInvDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_DiscPerc] DEFAULT (0),
    [RowID] int NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_RowID] DEFAULT (0),
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_BonusQty] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_RowGroup] DEFAULT (1),
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_BonusPackQtyForSale] DEFAULT (0),
    [SourceSaleInvcode] int NULL,
    [SaleRowID] int NULL,
    [DescICode] int NULL,
    [IssueRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_AlternatePurPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CRS_SaleInvDetail_ClaimableDiscPerc] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[CRS_SaleLedger] (
    [ClientInstanceID] smallint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NULL,
    [CustCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL,
    [MiscCharges] numeric(12,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [ReprintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(5,2) NULL,
    [PrintWaranty] char(1) NOT NULL,
    [PrintBatch] char(1) NOT NULL,
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL,
    [CustRefNo2] varchar(100) NULL,
    [CustRefNo3] varchar(100) NULL,
    [CustRefNo4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL,
    [InvTotal] numeric(15,2) NOT NULL,
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL,
    [DiseaseCode] smallint NULL,
    [ReturnCounter] int NOT NULL,
    [Paid] char(1) NOT NULL,
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL,
    [TotalOfSaleReturns] numeric(15,2) NOT NULL,
    [ListOfSRInvoices] varchar(500) NULL,
    [PrintBalance] char(1) NOT NULL,
    [AccountFor] char(1) NOT NULL,
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL,
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(100) NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL,
    [Marked] char(1) NOT NULL,
    [DeliveredBy] smallint NULL,
    [SaleTypeCode] smallint NOT NULL,
    [Balance] numeric(15,5) NOT NULL,
    [PPTCustCode] smallint NULL,
    [Deleted] char(1) NOT NULL,
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL,
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [ConsiderInPO] char(1) NOT NULL,
    [DueDate] datetime NOT NULL,
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL,
    [CashCharged] numeric(15,2) NOT NULL,
    [CashBack] numeric(15,2) NOT NULL,
    [CashAccCode] smallint NOT NULL,
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleID] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_CRS_SaleLedger_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_ConversionRate] DEFAULT (1),
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_MiscCharges5] DEFAULT (0),
    [SourceSaleInvCode] int NULL,
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_CRS_SaleLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SaleLedger_FBRPOSFee] DEFAULT (0),
    [CashierShiftCode] int NULL,
    [AdmissionCode] int NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    CONSTRAINT [PK_CRS_SaleLedger] PRIMARY KEY CLUSTERED ([ClientInstanceID], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[CRS_SalesMan] (
    [ClientID] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Address] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_CRS_SalesMan_Active] DEFAULT ('Y'),
    [NICNo] varchar(100) NULL,
    CONSTRAINT [PK_CRS_SalesMan] PRIMARY KEY CLUSTERED ([ClientID], [SalesManCode])
);
GO

CREATE TABLE [dbo].[CRS_SaleType] (
    [ClientID] smallint NOT NULL,
    [SaleTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_CRS_SaleType] PRIMARY KEY CLUSTERED ([ClientID], [SaleTypeCode])
);
GO

CREATE TABLE [dbo].[CRS_Section] (
    [ClientID] smallint NOT NULL,
    [SectCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    [DeptCode] smallint NULL,
    CONSTRAINT [PK_CRS_Section] PRIMARY KEY CLUSTERED ([ClientID], [SectCode])
);
GO

CREATE TABLE [dbo].[CRS_SRDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [SRInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SRPrice] numeric(12,2) NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [UnitSalesTax] numeric(12,2) NOT NULL,
    [GSTPerc] numeric(6,2) NOT NULL,
    [SRUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [SaleRowID] int NULL,
    [RowID] int NOT NULL,
    [ReturnItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL,
    [PiecesInHand] int NOT NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL,
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SRDetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SRDetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_CRS_SRDetail_NewAvgPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_CRS_SRDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CRS_SRDetail_ClaimableDiscPerc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SRDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CurrStock] numeric(15,4) NOT NULL CONSTRAINT [DF_CRS_SRDetail_CurrStock] DEFAULT (0),
    CONSTRAINT [PK_CRS_SRDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [SRInvCode], [RowID])
);
GO

CREATE TABLE [dbo].[CRS_SRLedger] (
    [ClientInstanceID] smallint NOT NULL,
    [SRInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [SRCatCode] tinyint NULL,
    [CustCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL,
    [MiscCharges] numeric(12,2) NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [HeaderNo] smallint NULL,
    [InvGSTPerc1] numeric(5,2) NULL,
    [SManCode] smallint NULL,
    [CustRefNo] varchar(100) NULL,
    [CustRefNo2] varchar(100) NULL,
    [CustRefNo3] varchar(100) NULL,
    [CustRefNo4] varchar(100) NULL,
    [PatientCode] int NULL,
    [MachineName] varchar(20) NULL,
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL,
    [AccountFor] char(1) NOT NULL,
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL,
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(100) NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL,
    [Marked] char(1) NOT NULL,
    [PageSize] char(1) NOT NULL,
    [ReprintingCounter] tinyint NULL,
    [DoctCode] smallint NULL,
    [ConsiderInPO] char(1) NOT NULL,
    [CashAccCode] smallint NOT NULL,
    [CashTendered] numeric(15,2) NOT NULL,
    [CashCharged] numeric(15,2) NOT NULL,
    [CashBack] numeric(15,2) NOT NULL,
    [RetViaBillSummary] char(1) NOT NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_CRS_SRLedger_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_CRS_SRLedger_ConversionRate] DEFAULT (1),
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_CRS_SRLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_CRS_SRLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_SRLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_SRLedger_FBRPOSFee] DEFAULT (0),
    [CashierShiftCode] int NULL,
    [AdmissionCode] int NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    CONSTRAINT [PK_CRS_SRLedger] PRIMARY KEY CLUSTERED ([ClientInstanceID], [SRInvCode])
);
GO

CREATE TABLE [dbo].[CRS_SubAccounts] (
    [ClientID] smallint NOT NULL,
    [SubAccCode] smallint NOT NULL,
    [CatAccCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_SubAccounts] PRIMARY KEY CLUSTERED ([ClientID], [SubAccCode])
);
GO

CREATE TABLE [dbo].[CRS_SubArea] (
    [ClientID] smallint NOT NULL,
    [SubAreaCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Manager] varchar(100) NOT NULL,
    [AreaCode] smallint NOT NULL,
    CONSTRAINT [PK_CRS_SubArea] PRIMARY KEY CLUSTERED ([ClientID], [SubAreaCode])
);
GO

CREATE TABLE [dbo].[CRS_Supplier] (
    [ClientID] smallint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [CP] varchar(100) NULL,
    [Address1] varchar(100) NULL,
    [City] varchar(100) NULL,
    [Country] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [SuppCatCode] smallint NOT NULL,
    [DefaultGST] tinyint NOT NULL,
    [SpecialInstructions] varchar(1000) NULL,
    [DaysLimit] smallint NOT NULL,
    [PostCode] varchar(100) NULL,
    [CountyCode] smallint NULL,
    [NTNNo] varchar(100) NULL,
    [SalesTaxRegNo] varchar(100) NULL,
    CONSTRAINT [PK_CRS_Supplier] PRIMARY KEY CLUSTERED ([ClientID], [SuppCode])
);
GO

CREATE TABLE [dbo].[CRS_SupplierCategory] (
    [ClientID] smallint NOT NULL,
    [SuppCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CRS_SupplierCategory] PRIMARY KEY CLUSTERED ([ClientID], [SuppCatCode])
);
GO

CREATE TABLE [dbo].[CRS_TDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [TransCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [ID] int NOT NULL,
    [TransferUtn] bigint NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [SourceStock] numeric(15,4) NOT NULL,
    [TargetStock] numeric(15,4) NOT NULL,
    [ReOrderQty] int NOT NULL,
    [OptimumQty] int NOT NULL,
    [RequiredQty] int NOT NULL,
    [PackQty] numeric(15,4) NOT NULL,
    [RowGroup] int NOT NULL,
    [TransReqRowID] int NULL,
    [ItemDescription] varchar(100) NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_CRS_TDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [TransCode], [ID])
);
GO

CREATE TABLE [dbo].[CRS_THeader] (
    [ClientInstanceID] smallint NOT NULL,
    [TransCode] int NOT NULL,
    [SGCode] tinyint NOT NULL,
    [DGCode] tinyint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [TTCode] smallint NOT NULL,
    [StartDate] datetime NOT NULL,
    [EndDate] datetime NOT NULL,
    [PostedBy] smallint NULL,
    [TransReqCode] int NULL,
    [SManCode] smallint NULL,
    [WorkOrderCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_CRS_Synced_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_CRS_THeader] PRIMARY KEY CLUSTERED ([ClientInstanceID], [TransCode])
);
GO

CREATE TABLE [dbo].[CRS_TransactionDetail] (
    [ClientInstanceID] smallint NOT NULL,
    [DocumentCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionDetail_Amount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [RowID] int NOT NULL,
    CONSTRAINT [PK_CRS_TransactionDetail] PRIMARY KEY CLUSTERED ([ClientInstanceID], [DocumentCode], [AccCode])
);
GO

CREATE TABLE [dbo].[CRS_TransactionHeader] (
    [ClientInstanceID] smallint NOT NULL,
    [DocumentCode] int NOT NULL,
    [TransactionTypeCode] smallint NOT NULL,
    [TransactionCode] int NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_TransactionCode] DEFAULT (0),
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [PatientCode] int NULL,
    [AdmissionCode] int NULL,
    [PatientBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_PatientBalance] DEFAULT (0),
    [AccCode] smallint NOT NULL,
    [AccBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_AccBalance] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_CashBack] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CRS_TransactionHeader_Posted] DEFAULT ('Y'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    CONSTRAINT [PK_CRS_TransactionHeader_DocumentCode] PRIMARY KEY CLUSTERED ([ClientInstanceID], [DocumentCode])
);
GO

CREATE TABLE [dbo].[CRS_TransferableData] (
    [SourceTableName] varchar(100) NOT NULL,
    [TransferType] char(1) NOT NULL CONSTRAINT [DF_CRS_TransferableData_TransferType] DEFAULT ('B'),
    [CRS_TableName] varchar(100) NOT NULL,
    [Priority] int NOT NULL,
    [AutoInsert] char(1) NOT NULL CONSTRAINT [DF_CRS_TransferableData_AutoInsert] DEFAULT ('Y'),
    [AutoUpdate] char(1) NOT NULL CONSTRAINT [DF_CRS_TransferableData_AutoUpdate] DEFAULT ('Y'),
    [AutoDelete] char(1) NOT NULL CONSTRAINT [DF_CRS_TransferableData_AutoDelete] DEFAULT ('Y'),
    [Enable] char(1) NOT NULL CONSTRAINT [DF_CRS_TransferableData_Enable] DEFAULT ('Y'),
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_CRS_TransferableData] PRIMARY KEY CLUSTERED ([SourceTableName]),
    CONSTRAINT [UK_CRS_TransferableData] UNIQUE ([Priority])
);
GO

CREATE TABLE [dbo].[CRS_Users] (
    [ClientID] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [UserName] varchar(100) NOT NULL,
    [Password] varchar(60) NULL,
    [FatherName] varchar(100) NULL,
    [Address] varchar(300) NULL,
    [Phone] varchar(100) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_CRS_Users_Active] DEFAULT ('Y'),
    CONSTRAINT [PK_CRS_Users] PRIMARY KEY CLUSTERED ([ClientID], [UserCode])
);
GO

CREATE TABLE [dbo].[CRS_VirtualGl] (
    [ClientInstanceID] smallint NULL,
    [DocumentCode] int NOT NULL,
    [DocumentType] varchar(20) NOT NULL,
    [AccCode] smallint NOT NULL,
    [CatCode] tinyint NOT NULL,
    [AlternateAccCode] smallint NULL,
    [Debit] numeric(15,2) NOT NULL,
    [Credit] numeric(15,2) NOT NULL,
    [Date] datetime NOT NULL,
    [CheckNo] varchar(20) NULL,
    [Remarks] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    [PatientCode] int NULL,
    [VoucherCode] int NULL,
    [INVOICECODE] int NULL,
    [OUTSTANDINGAMT] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGL_OUTSTANDINGAMT] DEFAULT (0),
    [BALANCE] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGL_BALANCE] DEFAULT (0),
    [InvoiceType] tinyint NULL,
    [VRow] tinyint NOT NULL CONSTRAINT [DF_CRS_VirtualGL_VROW] DEFAULT (0),
    [GRN] varchar(100) NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [CurrencyCode] smallint NULL,
    [ConversionRate] numeric(11,5) NULL
);
GO

CREATE TABLE [dbo].[CRS_VirtualGlTemp] (
    [ClientInstanceID] smallint NULL,
    [documentcode] int NOT NULL,
    [documenttype] varchar(20) NOT NULL,
    [catcode] tinyint NOT NULL,
    [dr_acccode] smallint NOT NULL,
    [cr_acccode] smallint NOT NULL,
    [AlternateAccCode] smallint NULL,
    [date] datetime NOT NULL,
    [SaleTax] numeric(15,2) NOT NULL,
    [Gross] numeric(15,2) NOT NULL,
    [dr_remarks] varchar(100) NULL,
    [cr_remarks] varchar(100) NULL,
    [Saletax_remarks] varchar(100) NULL,
    [checkNo] varchar(20) NULL,
    [usercode] smallint NULL,
    [VoucherCode] int NULL,
    [InvoiceCode] int NULL,
    [InvoiceType] tinyint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGlTemp_Amt] DEFAULT (0),
    [DrAmtAccCode] int NULL,
    [CrAmtAccCode] int NULL,
    [AmtBy] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtRef] varchar(60) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGlTemp_OutstandingAmt] DEFAULT (0),
    [Balance] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGlTemp_Balance] DEFAULT (0),
    [PatientCode] int NULL,
    [GRN] varchar(100) NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [CGS] numeric(15,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGLTemp_CGS] DEFAULT (0),
    [CurrencyCode] smallint NULL,
    [ConversionRate] numeric(11,5) NULL,
    [AdvIncomeTax] numeric(12,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGLTemp_AdvIncomeTax] DEFAULT (0),
    [FBRPosFee] numeric(5,2) NOT NULL CONSTRAINT [DF_CRS_VirtualGLTemp_FBRPosFee] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[CRS_VocherCategory] (
    [ClientInstanceID] smallint NOT NULL,
    [VochCatCode] smallint NOT NULL,
    [Name] varchar(30) NOT NULL,
    [ShortName] varchar(20) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_CRS_VoucherCategory_Counter] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CRS_VoucherCategory_Posted] DEFAULT ('N'),
    [SystemType] tinyint NOT NULL CONSTRAINT [DF_CRS_VoucherCategory_SystemType] DEFAULT (0),
    [JournalVoucher] tinyint NOT NULL CONSTRAINT [DF_CRS_VoucherCategory_JournalVoucher] DEFAULT (0),
    [HeaderTreatment] char(1) NULL,
    [DetailTreatment] char(1) NULL,
    [InvoiceBased] tinyint NOT NULL CONSTRAINT [DF_CRS_VoucherCategory_InvoiceBased] DEFAULT (0),
    [InvoiceType] tinyint NULL,
    [AutoPosting] char(1) NOT NULL CONSTRAINT [DF_CRS_VocherCategory_AutoPosting] DEFAULT ('N'),
    [VoucherOrder] tinyint NOT NULL CONSTRAINT [DF_CRS_VocherCategory_VoucherOrder] DEFAULT (1),
    [UseForSMS] char(1) NOT NULL CONSTRAINT [DF_CRS_VocherCategory_UseForSMS] DEFAULT ('N'),
    CONSTRAINT [PK_CRS_VocherCategory] PRIMARY KEY CLUSTERED ([ClientInstanceID], [VochCatCode]),
    CONSTRAINT [IX_CRS_VocherCategory_ShortName] UNIQUE ([ClientInstanceID], [ShortName]),
    CONSTRAINT [IX_CRS_VocherCategory_Name] UNIQUE ([ClientInstanceID], [Name])
);
GO

CREATE TABLE [dbo].[CTAngiogram] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CTAngiogram_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [HadCTCoronaryAngiogram] char(1) NULL,
    [HadCTCoronaryAngiogramOn] datetime NULL,
    [NormalCoronaries] char(1) NULL,
    [MildcoronaryArteryDisease] char(1) NULL,
    [DiffuseCoronaryArteryDisease] char(1) NULL,
    [EctaticCoronayArteries] char(1) NULL,
    [SVCAD] char(1) NULL,
    [DVCAD] char(1) NULL,
    [TVCAD] char(1) NULL,
    [Other] varchar(255) NULL,
    [Remarks] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_CTAngiogram_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_CTAngiogram_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[Currency] (
    [CurrencyCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [ConversionFactor] numeric(11,5) NOT NULL CONSTRAINT [DF_Currency_ConversionFactor] DEFAULT (1),
    CONSTRAINT [PK_Currency_CurrencyCode] PRIMARY KEY CLUSTERED ([CurrencyCode]),
    CONSTRAINT [UK_Currency_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_Currency_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CurrencyDenomination] (
    [CurrencyCode] smallint NOT NULL,
    [Type] char(1) NOT NULL CONSTRAINT [DF_CurrencyDenomination_Type] DEFAULT ('C'),
    [Name] varchar(60) NOT NULL,
    [Denomination] numeric(12,2) NOT NULL CONSTRAINT [DF_CurrencyDenomination_Denomination] DEFAULT (1),
    CONSTRAINT [PK_CurrencyDenomination] PRIMARY KEY CLUSTERED ([CurrencyCode], [Type], [Denomination])
);
GO

CREATE TABLE [dbo].[CustAllowedServices] (
    [CustCode] smallint NOT NULL,
    [ServiceCode] int NOT NULL,
    CONSTRAINT [PK_CustAllowedServices] PRIMARY KEY CLUSTERED ([CustCode], [ServiceCode])
);
GO

CREATE TABLE [dbo].[CustBalances] (
    [Acccode] decimal(5,0) NOT NULL,
    [Balance] decimal(15,5) NOT NULL
);
GO

CREATE TABLE [dbo].[CustGuaranteePerson] (
    [CustCode] smallint NOT NULL,
    [GuaranteePersonCode] smallint NOT NULL,
    CONSTRAINT [PK_CustGuaranteeperson] PRIMARY KEY CLUSTERED ([CustCode], [GuaranteePersonCode])
);
GO

CREATE TABLE [dbo].[CustItemCatAssociation] (
    [CustCode] smallint NOT NULL,
    [ICatCode] smallint NOT NULL,
    CONSTRAINT [PK_CustItemCatAssociation] PRIMARY KEY CLUSTERED ([CustCode], [ICatCode])
);
GO

CREATE TABLE [dbo].[CustItemCatWiseSaleDiscount] (
    [CustCatCode] tinyint NOT NULL,
    [ICatCode] smallint NOT NULL,
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_CustItemCatWiseSaleDiscount_DiscPerc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [ItemFlatDisc] numeric(7,2) NOT NULL CONSTRAINT [DF_CustItemCatWiseSaleDiscount_ItemFlatDisc] DEFAULT (0),
    [PreDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CustItemCatWiseSaleDiscount_PreDiscPerc] DEFAULT (0),
    CONSTRAINT [PK_CustItemCatWiseSaleDiscount] PRIMARY KEY CLUSTERED ([CustCatCode], [ICatCode])
);
GO

CREATE TABLE [dbo].[CustLicCategory] (
    [CustCode] smallint NOT NULL,
    [LicenseCategoryCode] smallint NOT NULL,
    CONSTRAINT [PK_CustLicCategory] PRIMARY KEY CLUSTERED ([CustCode], [LicenseCategoryCode])
);
GO

CREATE TABLE [dbo].[CustLog] (
    [CustLogID] int IDENTITY(1,1) NOT NULL,
    [CustCode] smallint NOT NULL,
    [ColumnName] varchar(100) NOT NULL,
    [LastValue] varchar(1000) NULL,
    [NewValue] varchar(1000) NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CustomerLog_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_CustLog_UserCode] DEFAULT (1),
    CONSTRAINT [PK_CustLog] PRIMARY KEY CLUSTERED ([CustLogID])
);
GO

CREATE TABLE [dbo].[CustomDutyRule] (
    [CustomDutyRuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_CustomDutyRule_CustomDutyRuleCode] PRIMARY KEY CLUSTERED ([CustomDutyRuleCode]),
    CONSTRAINT [UK_CustomDutyRule_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_CustomDutyRule_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Customer] (
    [CustCode] smallint NOT NULL,
    [AreaCode] smallint NOT NULL,
    [CP] varchar(60) NULL,
    [Address1] varchar(60) NULL,
    [City] varchar(60) NULL,
    [Country] varchar(60) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(60) NULL,
    [CrLimit] numeric(10,2) NOT NULL,
    [DaysLimit] smallint NOT NULL,
    [CustCatCode] tinyint NULL,
    [Address2] varchar(60) NULL,
    [LicenceNo] varchar(30) NULL,
    [LicenceExpiry] datetime NULL,
    [PriceOnSale] smallint NULL CONSTRAINT [DF_Customer_PriceOnSale_2__10] DEFAULT (1),
    [DiscOnSale] smallint NULL CONSTRAINT [DF_Customer_DiscOnSale_1__10] DEFAULT (1),
    [SalesTaxRegNo] varchar(50) NULL,
    [DefaultGST] tinyint NULL CONSTRAINT [DF_Customer_DefaultGST_1__10] DEFAULT (1),
    [MessageCode] smallint NULL,
    [SalesManCode] smallint NULL,
    [InvDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Customer_InvDiscPerc] DEFAULT (0),
    [DefaultSalePrice] tinyint NOT NULL CONSTRAINT [DF__Customer__Defaul__30B91D22] DEFAULT (1),
    [DefaultItemDiscPerc] tinyint NOT NULL CONSTRAINT [DF__Customer__Defaul__31AD415B] DEFAULT (1),
    [SchedForPosting] char(1) NOT NULL CONSTRAINT [DF_SchedForPosting] DEFAULT ('Y'),
    [Designation] varchar(60) NULL,
    [SpecialInstructions] varchar(4000) NULL,
    [SubAreaCode] smallint NOT NULL,
    [BankName] varchar(100) NULL,
    [BankAdd] varchar(200) NULL,
    [AllowSaleBelowAvgPrice] char(1) NOT NULL CONSTRAINT [DF_Customer_AllowSaleBelowAvgPrice] DEFAULT ('N'),
    [AssociatedQuotationCode] int NULL,
    [CollectionPolicyCode] int NOT NULL CONSTRAINT [DF_Customer_CollectionPolicyCode] DEFAULT (1),
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_Customer_SaleTypeCode] DEFAULT (1),
    [CP2] varchar(60) NULL,
    [Gender] char(1) NOT NULL CONSTRAINT [DF_Customer_Gender] DEFAULT ('M'),
    [NIC] varchar(30) NULL,
    [DOB] datetime NULL,
    [Occupation] varchar(60) NULL,
    [EduQualf] varchar(60) NULL,
    [RefNo] varchar(30) NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_Customer_ConsiderInPO] DEFAULT ('Y'),
    [MemberShipID] varchar(20) NOT NULL,
    [NTNNo] varchar(50) NULL,
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_Customer_PrintWaranty] DEFAULT ('Y'),
    [POAssociatedQuotationCode] int NULL,
    [PostCode] varchar(20) NULL,
    [CountyCode] smallint NULL,
    [GCCode] smallint NULL,
    [AssociatedServiceTemplateCode] int NULL,
    [PrintOutstandingServiceResult] char(1) NOT NULL CONSTRAINT [DF_Customer_PrintOutstandingServiceResult] DEFAULT ('Y'),
    [PrintAmtOnServiceInv] char(1) NOT NULL CONSTRAINT [DF_Customer_PrintAmtOnServiceInv] DEFAULT ('Y'),
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_customer_printbalance] DEFAULT ('Y'),
    [Charges] numeric(10,2) NOT NULL CONSTRAINT [DF_Customer_Charges] DEFAULT (0),
    [Block] char(1) NOT NULL CONSTRAINT [DF_Customer_Block] DEFAULT ('N'),
    [FullName] varchar(100) NOT NULL CONSTRAINT [DF_Customer_FullName] DEFAULT ('.'),
    [Owner] varchar(100) NOT NULL CONSTRAINT [DF_Customer_Owner] DEFAULT ('.'),
    [Address] varchar(1000) NOT NULL CONSTRAINT [DF_Customer_Address] DEFAULT ('.'),
    [IssuedLicenseNo] varchar(100) NOT NULL CONSTRAINT [DF_Customer_IssuedLicenseNo] DEFAULT ('.'),
    [MiscChargesPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Customer_miscchargesperc] DEFAULT (0),
    [AgeInYears] tinyint NOT NULL CONSTRAINT [DF_customer_AgeInYears] DEFAULT (0),
    [Married] char(1) NOT NULL CONSTRAINT [DF_customer_Married] DEFAULT ('N'),
    [NoOfDependents] tinyint NOT NULL CONSTRAINT [DF_customer_NoOfDependents] DEFAULT (0),
    [MonthlyIncome] numeric(15,2) NOT NULL CONSTRAINT [DF_customer_MonthlyIncome] DEFAULT (0),
    [CellNo] varchar(100) NULL,
    [AddressStatus] char(1) NOT NULL CONSTRAINT [DF_customer_AdressStatus] DEFAULT ('O'),
    [StayDuration] varchar(50) NULL,
    [OffAddress] varchar(300) NULL,
    [OffPhone] varchar(100) NULL,
    [JobDuration] varchar(100) NULL,
    [PastPurOnInst] char(1) NOT NULL CONSTRAINT [DF_customer_PastPurOnInst] DEFAULT ('N'),
    [PastInstCompany] varchar(200) NULL,
    [DescOfPastInstGoods] varchar(300) NULL,
    [CriticalLimit] numeric(15,2) NOT NULL CONSTRAINT [DF_Customer_CriticalLimit] DEFAULT (0),
    [ReportDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Customer_ReportDiscPerc] DEFAULT (0),
    [CustomerSectorCode] smallint NOT NULL CONSTRAINT [DF_Customer_CustomerSectorCode] DEFAULT (1),
    [TaxCategoryCode] smallint NOT NULL CONSTRAINT [DF_Customer_TaxCategory_TaxCategoryCode] DEFAULT (1),
    [SalesTaxExemption] char(1) NOT NULL CONSTRAINT [DF_Customer_SalesTaxExemption] DEFAULT ('N'),
    [PaymentAPI] varchar(100) NULL,
    [FName] varchar(100) NULL,
    [SiteCode] smallint NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustCode]),
    CONSTRAINT [UK_Customer_MemberShipID] UNIQUE ([MemberShipID])
);
GO

CREATE TABLE [dbo].[CustomerCategory] (
    [CustCatCode] tinyint NOT NULL,
    [Name] varchar(30) NOT NULL,
    [AllowInCashSale] char(1) NOT NULL CONSTRAINT [df_customercategory_allowincashsale] DEFAULT ('Y'),
    [AllowInCreditSale] char(1) NOT NULL CONSTRAINT [df_customercategory_allowincreditsale] DEFAULT ('Y'),
    [CustomerSegmentCode] smallint NOT NULL CONSTRAINT [DF_CustomerSegment_CustomerSegmentCode] DEFAULT (1),
    CONSTRAINT [PK___2__12] PRIMARY KEY CLUSTERED ([CustCatCode]),
    CONSTRAINT [CustCatname_UK] UNIQUE ([CustCatCode])
);
GO

CREATE TABLE [dbo].[CustomerComments] (
    [CommentCode] int IDENTITY(1,1) NOT NULL,
    [CustCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CustomerComments_Date] DEFAULT (getdate()),
    [Priority] tinyint NOT NULL CONSTRAINT [DF_CustomerComments_Priority] DEFAULT (10),
    [Comments] nvarchar(4000) NULL,
    [CommentedBy] smallint NOT NULL,
    [CommentedOn] datetime NOT NULL CONSTRAINT [DF_CustomerComments_CommentedOn] DEFAULT (getdate()),
    CONSTRAINT [PK_CustomerComments_CommentCode] PRIMARY KEY CLUSTERED ([CommentCode])
);
GO

CREATE TABLE [dbo].[CustomerConfig] (
    [LicenseID] varchar(20) NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [Date] datetime NOT NULL,
    [CustCode] smallint NOT NULL,
    [ServerName] varchar(100) NOT NULL,
    [DatabaseName] varchar(100) NOT NULL,
    [Licensed] char(1) NOT NULL CONSTRAINT [DF_CustomerConfig_Licensed] DEFAULT ('Y'),
    [DataCarry] char(1) NOT NULL CONSTRAINT [DF_CustomerConfig_DataCarry] DEFAULT ('N'),
    [SQLServerVersion] varchar(50) NOT NULL,
    [NoOfSystems] int NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(400) NULL,
    [Notes] varchar(400) NULL,
    [BackupServer] char(1) NOT NULL CONSTRAINT [DF_CustomerConfig_BackupServer] DEFAULT ('N'),
    [SourceLicenseID] varchar(20) NULL,
    [SecPathServerName] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_SecPathServerName] DEFAULT (''),
    [PWD] varchar(40) NOT NULL CONSTRAINT [DF_CustomerConfig_PWD] DEFAULT (''),
    [Company] varchar(15) NOT NULL CONSTRAINT [DF_CustomerConfig_Company] DEFAULT (''),
    [AddDays] smallint NOT NULL CONSTRAINT [DF_CustomerConfig_AddDays] DEFAULT (5),
    [AddInvoices] int NOT NULL CONSTRAINT [DF_CustomerConfig_AddInvoices] DEFAULT (25000),
    [FirstTimeInvoices] int NOT NULL CONSTRAINT [DF_CustomerConfig_FirstTimeInvoices] DEFAULT (50000),
    [ParentServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ParentServer] DEFAULT (''),
    [ParentServerLinkServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ParentServerLinkServer] DEFAULT ('ParentServer'),
    [ParentDB] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ParentDB] DEFAULT (''),
    [ParentOwner] varchar(15) NOT NULL CONSTRAINT [DF_CustomerConfig_ParentOwner] DEFAULT ('DBO'),
    [ReportServer] varchar(15) NOT NULL CONSTRAINT [DF_CustomerConfig_ReportServer] DEFAULT ('N'),
    [GSLocal] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_GSLocal] DEFAULT (''),
    [MasterServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_MasterServer] DEFAULT (''),
    [ArchiveServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ArchiveServer] DEFAULT (''),
    [ArchiveDB] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ArchiveDB] DEFAULT (''),
    [ArchiveLinkServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_ArchiveLinkServer] DEFAULT ('ARCHIVE'),
    [ArchiveOwner] varchar(15) NOT NULL CONSTRAINT [DF_CustomerConfig_ArchiveOwner] DEFAULT ('DBO'),
    [CRSServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_CRSServer] DEFAULT ('CRS_Server'),
    [CRSDB] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_CRSDB] DEFAULT (''),
    [CRSOwner] varchar(15) NOT NULL CONSTRAINT [DF_CustomerConfig_CRSOwner] DEFAULT ('DBO'),
    [SourceServer] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_SourceServer] DEFAULT (''),
    [SourceDB] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_SourceDB] DEFAULT (''),
    [SourcePWD] varchar(40) NOT NULL CONSTRAINT [DF_CustomerConfig_SourcePWD] DEFAULT (''),
    [OS] varchar(100) NOT NULL CONSTRAINT [DF_CustomerConfig_OS] DEFAULT ('Windows 32 Bit'),
    [SerialNo] int NOT NULL CONSTRAINT [DF_CustomerConfig_SerialNo] DEFAULT (0),
    CONSTRAINT [PK_CustomerConfig] PRIMARY KEY CLUSTERED ([LicenseID])
);
GO

CREATE TABLE [dbo].[CustomerDeployment] (
    [CustomerDeploymentCode] int NOT NULL,
    [DATE] datetime NOT NULL,
    [Details] varchar(1000) NULL,
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CustomerDeployment_Posted] DEFAULT ('N'),
    [PostedOn] datetime NULL,
    [PostedBy] smallint NULL,
    CONSTRAINT [PK_CustomerDeployment] PRIMARY KEY CLUSTERED ([CustomerDeploymentCode])
);
GO

CREATE TABLE [dbo].[CustomerDeploymentDetail] (
    [CustomerDeploymentCode] int NOT NULL,
    [LicenseID] varchar(20) NOT NULL,
    [Version] varchar(20) NOT NULL,
    [Waseela] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_Waseela] DEFAULT ('Y'),
    [DataCarry] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_DataCarry] DEFAULT ('N'),
    [BackupApps] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_BackupApps] DEFAULT ('N'),
    [Fiscalization] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_Fiscalization] DEFAULT ('N'),
    [PriceChecker] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_PriceChecker] DEFAULT ('N'),
    [GeneratedOn] datetime NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Attendance] char(1) NOT NULL CONSTRAINT [DF_CustomerDeploymentDetail_Attendance] DEFAULT ('N'),
    CONSTRAINT [PK_CustomerDeploymentDetail] PRIMARY KEY CLUSTERED ([CustomerDeploymentCode], [LicenseID])
);
GO

CREATE TABLE [dbo].[CustomerGroup] (
    [CustomerGroupCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Remarks] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_CustomerGroup] PRIMARY KEY CLUSTERED ([CustomerGroupCode]),
    CONSTRAINT [UK_CustomerGroup_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CustomerGroupCategory] (
    [GroupCode] smallint NOT NULL,
    [CustomerCategoryCode] tinyint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_CustomerGroupCategory_Status] DEFAULT (1),
    CONSTRAINT [PK_CustomerGroupCategory] PRIMARY KEY CLUSTERED ([GroupCode], [CustomerCategoryCode])
);
GO

CREATE TABLE [dbo].[CustomerGroupDetail] (
    [CustomerGroupCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_CustomerGroupDetail] PRIMARY KEY CLUSTERED ([CustomerGroupCode], [CustCode])
);
GO

CREATE TABLE [dbo].[CustomerLicense] (
    [LicenseRowID] int IDENTITY(1,1) NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [Date] datetime NOT NULL,
    [LicenseID] varchar(20) NOT NULL,
    [LicenseKeyInput] varchar(100) NOT NULL,
    [Duration] char(2) NOT NULL,
    [Iteration] char(2) NOT NULL,
    [LicenseDate] datetime NOT NULL,
    [FirstRand] int NOT NULL,
    [SecondRand] int NOT NULL,
    [LicenseKeyValue] varchar(20) NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(400) NULL,
    [RenewalDone] char(1) NOT NULL CONSTRAINT [DF_CustomerLicense_RenewalDone] DEFAULT ('N'),
    [Status] char(1) NULL,
    [StatusDetail] varchar(100) NULL,
    [StatusDate] datetime NULL,
    [StatusMarkedBy] smallint NULL,
    [LicenseRequestID] int NULL,
    [SendSMS] char(1) NOT NULL CONSTRAINT [DF_CustomerLicense_SendSMS] DEFAULT ('N'),
    [SMSTO] varchar(255) NULL,
    CONSTRAINT [PK_CustomerLicense] PRIMARY KEY CLUSTERED ([LicenseRowID])
);
GO

CREATE TABLE [dbo].[CustomerLicRequest] (
    [LicenseRequestID] int IDENTITY(1,1) NOT NULL,
    [CreatedOn] datetime NOT NULL,
    [CreatedBy] smallint NOT NULL,
    [LicenseID] varchar(20) NOT NULL,
    [LicenseKeyInput] varchar(100) NOT NULL,
    [LicReqStatusCode] tinyint NOT NULL CONSTRAINT [DF_CustomerLicRequest_LicReqStatusCode] DEFAULT (1),
    [Date] datetime NOT NULL,
    [ModifiedBy] smallint NULL,
    CONSTRAINT [PK_CustomerLicRequest] PRIMARY KEY CLUSTERED ([LicenseRequestID])
);
GO

CREATE TABLE [dbo].[CustomerSector] (
    [CustomerSectorCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AliasName] varchar(30) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_CustomerSector] PRIMARY KEY CLUSTERED ([CustomerSectorCode]),
    CONSTRAINT [UK_CustomerSector_AliasName] UNIQUE ([AliasName]),
    CONSTRAINT [UK_CustomerSector_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CustomerSegment] (
    [CustomerSegmentCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_CustomerSegment] PRIMARY KEY CLUSTERED ([CustomerSegmentCode]),
    CONSTRAINT [UK_CustomerSegment_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CustomerServiceTemplate] (
    [CustomerServiceTemplateCode] int NOT NULL,
    [Name] varchar(255) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CustomerServiceTemplate_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [ServiceCode] int NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CustomerServiceTemplate_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [SvcInvGenerated] char(1) NOT NULL CONSTRAINT [DF_CustomerServiceTemplate_SvcInvGenerated] DEFAULT ('N'),
    CONSTRAINT [PK_CustomerServiceTemplate] PRIMARY KEY CLUSTERED ([CustomerServiceTemplateCode]),
    CONSTRAINT [UK_CustomerServiceTemplate_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CustomerServiceTemplateDetail] (
    [CustomerServiceTemplateCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [TransportRouteCode] int NULL,
    [Qty] numeric(10,2) NOT NULL CONSTRAINT [DF_CustomerServiceTemplateDetail_Qty] DEFAULT (1),
    [Charges] numeric(12,2) NOT NULL CONSTRAINT [DF_CustomerServiceTemplateDetail_Charges] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CustomerServiceTemplateDetail_DiscPerc] DEFAULT (0),
    [ServiceFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_CustomerServiceTemplateDetail_ServiceFlatDisc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    [Status] char(1) NULL,
    [ServiceInvCode] int NULL,
    [VehicleCode] int NULL,
    CONSTRAINT [PK_CustomerServiceTemplateDetail] PRIMARY KEY CLUSTERED ([CustomerServiceTemplateCode], [CustCode])
);
GO

CREATE TABLE [dbo].[CustomerStudentServiceTemplate] (
    [CustomerStudentServiceTemplateCode] int NOT NULL,
    [Name] varchar(255) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplate_Date] DEFAULT (getdate()),
    [CustCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [ServiceCode] int NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplate_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [SvcInvGenerated] char(1) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplate_SvcInvGenerated] DEFAULT ('N'),
    CONSTRAINT [PK_CustomerStudentServiceTemplate] PRIMARY KEY CLUSTERED ([CustomerStudentServiceTemplateCode]),
    CONSTRAINT [UK_CustomerStudentServiceTemplate_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[CustomerStudentServiceTemplateDetail] (
    [CustomerStudentServiceTemplateCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [ClassCode] int NULL,
    [Qty] numeric(10,2) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplateDetail_Qty] DEFAULT (1),
    [Charges] numeric(12,2) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplateDetail_Charges] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplateDetail_DiscPerc] DEFAULT (0),
    [ServiceFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_CustomerStudentServiceTemplateDetail_ServiceFlatDisc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    [Status] char(1) NULL,
    [ServiceInvCode] int NULL,
    CONSTRAINT [PK_CustomerStudentServiceTemplateDetail] PRIMARY KEY CLUSTERED ([CustomerStudentServiceTemplateCode], [StudentCode])
);
GO

CREATE TABLE [dbo].[CustQualPerson] (
    [CustCode] smallint NOT NULL,
    [QualifiedPersonCode] int NOT NULL,
    CONSTRAINT [PK_CustQualPerson] PRIMARY KEY CLUSTERED ([CustCode], [QualifiedPersonCode])
);
GO

CREATE TABLE [dbo].[CustWiseItemCategory] (
    [CustCode] smallint NOT NULL,
    [ICatCode] smallint NOT NULL,
    CONSTRAINT [PK_CustWiseItemCategory] PRIMARY KEY CLUSTERED ([CustCode], [ICatCode])
);
GO

CREATE TABLE [dbo].[DataImportLog] (
    [LogID] int IDENTITY(1,1) NOT NULL,
    [LogDate] datetime NOT NULL CONSTRAINT [DF_DataImportLog_LogDate] DEFAULT (getdate()),
    [ImportedBy] smallint NOT NULL,
    [ImportType] varchar(20) NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_DataImportLog] PRIMARY KEY CLUSTERED ([LogID])
);
GO

CREATE TABLE [dbo].[DataTransferDate] (
    [ServerDataTime] datetime NULL
);
GO

CREATE TABLE [dbo].[DataTransferLog] (
    [TRANSFERLOGID] int NOT NULL,
    [LOGDATE] datetime NOT NULL,
    [TRANSFEREDBY] smallint NOT NULL,
    [INVOICECODE] int NOT NULL,
    [INVOICETYPE] tinyint NOT NULL,
    [DATE] datetime NOT NULL,
    [ACCCODE] int NULL,
    [SGCODE] smallint NULL,
    [DGCODE] smallint NULL,
    [STATUS] tinyint NULL
);
GO

CREATE TABLE [dbo].[DataTransferLogDetail] (
    [TRANSFERLOGID] int NOT NULL,
    [INVOICECODE] int NOT NULL,
    [INVOICETYPE] tinyint NOT NULL,
    [ICODE] int NOT NULL,
    [GCODE] smallint NULL,
    [BATCH] varchar(100) NULL,
    [EXPIRY] datetime NULL,
    [QTY] numeric(15,4) NOT NULL CONSTRAINT [DF_DataTransferLogDetail_Qty] DEFAULT (0),
    [BONUSQTY] numeric(15,4) NOT NULL CONSTRAINT [DF_DataTransferLogDetail_BonusQty] DEFAULT (0),
    [DUEQTY] numeric(15,4) NOT NULL CONSTRAINT [DF_DataTransferLogDetail_DueQty] DEFAULT (0),
    [PRICE] numeric(15,5) NOT NULL CONSTRAINT [DF_DataTransferLogDetail_Price] DEFAULT (0),
    [STATUS] tinyint NOT NULL CONSTRAINT [DF_DataTransferLogDetail_Status] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[DB_ExpiryIntimation] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [IntimationCode] int NOT NULL,
    [IntimationTypeCode] tinyint NOT NULL,
    [IntimationSerialNo] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DB_ExpiryIntimation_Date] DEFAULT (getdate()),
    [RefNo] varchar(100) NULL,
    [Remarks1] varchar(255) NULL,
    [Remarks2] varchar(255) NULL,
    [UserCode] smallint NOT NULL,
    [CustCode] smallint NULL,
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_ExpiryIntimation_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_ExpiryIntimation_IntimationCode] PRIMARY KEY ([SiteCode], [IntimationCode])
);
GO

CREATE TABLE [dbo].[DB_ExpiryIntimationDetail] (
    [SiteCode] smallint NOT NULL,
    [IntimationCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_ExpiryIntimationDetail_Qty] DEFAULT (0),
    [Packunits] smallint NOT NULL,
    [PackPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_ExpiryIntimationDetail_PackPrice] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_ExpiryIntimationDetail_Price] DEFAULT (0),
    [InvoiceCode] int NULL,
    [InvoiceDate] datetime NULL,
    [RefNo] varchar(100) NULL,
    [RefDate] datetime NULL,
    [RowID] int NOT NULL,
    [ManfCode] smallint NULL,
    [LastAccCode] smallint NULL,
    CONSTRAINT [PK_DB_ExpiryIntimationDetail] PRIMARY KEY ([SiteCode], [IntimationCode], [ICode], [Batch], [Expiry], [RowID])
);
GO

CREATE TABLE [dbo].[DB_IssueDetail] (
    [SiteCode] smallint NOT NULL,
    [IssueInvCode] int NOT NULL,
    [Icode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Gcode] smallint NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_IssueDetai_Priority] DEFAULT (10),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_IssueDetail_Qty] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_IssueDetail_SalePrice] DEFAULT (0),
    [PurchasePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_IssueDetail_PurchasePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_IssueDetail_AvgPrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_DB_IssueDetail_PackUnits] DEFAULT (1),
    [MRPP] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_IssueDetail_MRPP] DEFAULT (0),
    [IssRowId] int NOT NULL,
    [IssueUtn] bigint NULL,
    [SectCode] smallint NULL,
    [Price] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_IssueDetail_Price] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [itemdescription] varchar(100) NULL,
    [RowGroup] int NOT NULL CONSTRAINT [DF_DB_IssueDetail_RowGroup] DEFAULT (1),
    [IssueReqRowID] int NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_DB_IssueDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_DB_IssueDetail_PiecesInHand] DEFAULT (0),
    [ServiceIssueReqRowID] int NULL,
    [ServiceRowID] int NULL,
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_DB_IssueDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_IssueDetail_ClaimableDiscPerc] DEFAULT (0),
    [ReceiptRowID] int NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_IssueDetail_BalanceStock] DEFAULT (0),
    CONSTRAINT [PK_DB_IssueDetail] PRIMARY KEY ([SiteCode], [IssueInvCode], [IssRowId])
);
GO

CREATE TABLE [dbo].[DB_IssueHeader] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [IssueInvCode] int NOT NULL,
    [DeptCode] smallint NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [SmanCode] smallint NULL,
    [AreaCode] smallint NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [IssueTypeCode] smallint NULL,
    [ReferenceNo] char(50) NULL,
    [ReferenceDate] datetime NULL,
    [PriceTypeCode] tinyint NOT NULL CONSTRAINT [DF_DB_IssueHeader_PriceType] DEFAULT (1),
    [RecipientCode] smallint NOT NULL CONSTRAINT [DF_DB_IssueHeader_Recipient_RecipientCode] DEFAULT (1),
    [AccCode] smallint NULL,
    [RecipientSalesMan] smallint NULL,
    [Terms1] varchar(100) NULL,
    [Terms2] varchar(100) NULL,
    [PatientCode] int NULL,
    [CustSiteCode] int NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [OrderDate] datetime NULL,
    [ServiceIssueRequestCode] int NULL,
    [ServiceInvCode] int NULL,
    [ReceiptInvCode] int NULL,
    [IssueCategoryCode] smallint NOT NULL CONSTRAINT [DF_DB_IssueHeader_IssueCategoryCode] DEFAULT (1),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_DB_IssueHeader_AccountFor] DEFAULT ('N'),
    [DrAccCode] smallint NULL,
    [IssueCode] int NOT NULL CONSTRAINT [DF_DB_IssueHeader_IssueCode] DEFAULT (0),
    [PrintWarranty] char(1) NOT NULL CONSTRAINT [DF_DB_IssueHeader_PrintWarranty] DEFAULT ('N'),
    [QuotationCode] int NULL,
    [MotorVehicleCode] int NULL,
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_IssueHeader_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_IssueHeader] PRIMARY KEY ([SiteCode], [IssueInvCode])
);
GO

CREATE TABLE [dbo].[DB_PRdetail] (
    [SiteCode] smallint NOT NULL,
    [PRInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PRdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PRdetail_LooseQty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PRdetail_BonusQty] DEFAULT (0),
    [PackUnits] int NOT NULL,
    [PRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PRDetail_PRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_PRDetail_AvgPrice] DEFAULT (0),
    [PackSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PRDetail_PackSalePrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PRDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_PRdetail_GSTPerc] DEFAULT (0),
    [PrUtn] bigint NULL,
    [ItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_DB_PRDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_DB_PRDetail_PiecesInHand] DEFAULT (0),
    [PrRowId] int NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [HistoricalBatch] varchar(100) NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PRDetail_BalanceStock] DEFAULT (0),
    CONSTRAINT [PK_DB_PRDetail] PRIMARY KEY ([SiteCode], [PRInvCode], [PrRowId])
);
GO

CREATE TABLE [dbo].[DB_PRLedger] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [PRInvCode] int NOT NULL,
    [PurInvCode] int NULL,
    [PRCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PRLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PRLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Remarks] varchar(100) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_DB_PRLedger_GSTPerc1] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_DB_prledger_invtotal] DEFAULT (0),
    [Terms1] varchar(150) NULL,
    [Terms2] varchar(150) NULL,
    [Terms3] varchar(150) NULL,
    [Terms4] varchar(150) NULL,
    [Terms5] varchar(150) NULL,
    [PurchaseInvNo] varchar(100) NULL,
    [CustCode] smallint NULL,
    [DataCarryCustCode] smallint NULL,
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_PRLedger_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_PRLedger] PRIMARY KEY ([SiteCode], [PRInvCode])
);
GO

CREATE TABLE [dbo].[DB_Purdetail] (
    [SiteCode] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_Purdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_Purdetail_LooseQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_PurPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_PurDetail_AvgPrice] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_Purdetail_BonusQty] DEFAULT (0),
    [PurRowId] int NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_DB_Purdetail_CurrStock] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_Purdetail_GSTPerc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_UnitSalesTax] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL,
    [itemdescription] varchar(100) NULL,
    [rate] numeric(15,2) NOT NULL CONSTRAINT [DF_DB_Purdetail_rate] DEFAULT (0),
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_SalePriceForItem] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_PurDetail_NetRate] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_RecentPurPrice] DEFAULT (0),
    [ManfCodeForItem] smallint NULL,
    [FlatDiscForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_FlatDiscForItem] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_RetailPrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [ManfDate] datetime NULL,
    [Location] varchar(100) NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurDetail_ItemFlatDisc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_DB_PurDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    CONSTRAINT [PK_DB_PurDetail] PRIMARY KEY ([SiteCode], [PurInvCode], [PurRowId])
);
GO

CREATE TABLE [dbo].[DB_Purledger] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [PurCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SuppInvCode] varchar(100) NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Remarks] varchar(100) NULL,
    [SuppInvDate] datetime NULL,
    [GRN] varchar(100) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_DB_Purledger_InvGSTPerc1_1__10] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [df_DB_purledger_invtotal] DEFAULT (0),
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [NewPurchaseOrderNo] varchar(100) NULL,
    [LCNO] varchar(100) NULL,
    [CustCode] smallint NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_DB_PurLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_DB_PurLedger_AdvanceTaxAmt] DEFAULT (0),
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_PurLedger_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_PurLedger] PRIMARY KEY ([SiteCode], [PurInvCode])
);
GO

CREATE TABLE [dbo].[DB_PurOrderDetail] (
    [SiteCode] smallint NOT NULL,
    [POCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_Qty] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [PORowId] int NOT NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_BonusQty] DEFAULT (0),
    [Stock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_Stock] DEFAULT (0),
    [ReorderQty] int NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_ReorderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_OptimumQty] DEFAULT (0),
    [MinQty] int NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_MinQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_PackUnits] DEFAULT (1),
    [SoldQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_SoldQty] DEFAULT (0),
    [ReturnQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_ReturnQty] DEFAULT (0),
    [QtySatisfied] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_QtySatisfied] DEFAULT (0),
    [BonusQtySatisfied] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_BonusQtySatisfied] DEFAULT (0),
    [SaleOrderRequest] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_SaleOrderRequest] DEFAULT (0),
    [TransitStock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_TransitStock] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_ItemFlatDisc] DEFAULT (0),
    [PackSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_PackSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_GSTPerc] DEFAULT (0),
    [PurPrice] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_PurPrice] DEFAULT (0),
    [SalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_SalePrice] DEFAULT (0),
    [RPP] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_RPP] DEFAULT (0),
    [PackAvgPrice] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_PackAvgPrice] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_ForeignPrice] DEFAULT (0),
    [LastPurInvCode] int NULL,
    [LastPurDate] datetime NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [Discperc2] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_PurOrderDetail_Discperc2] DEFAULT (0),
    CONSTRAINT [PK_DB_PurOrderDetail] PRIMARY KEY ([SiteCode], [POCode], [ICode])
);
GO

CREATE TABLE [dbo].[DB_PurOrderHeader] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [POCode] int NOT NULL,
    [ManfCode] smallint NULL,
    [SuppCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [PurOrderTerms1] varchar(150) NULL,
    [PurOrderTerms2] varchar(150) NULL,
    [PurOrderTerms3] varchar(150) NULL,
    [PurOrderTerms4] varchar(150) NULL,
    [PurOrderTerms5] varchar(150) NULL,
    [PurOrderTerms6] varchar(150) NULL,
    [PurOrderTerms7] varchar(150) NULL,
    [PurOrderTerms8] varchar(150) NULL,
    [ProjectionPeriod] int NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_ProjectionPeriod] DEFAULT (0),
    [ZeroQty] tinyint NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_ZeroQty] DEFAULT (0),
    [StartDate] datetime NULL,
    [EndDate] datetime NULL,
    [PurOrderCatCode] smallint NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_PurOrderCatCode] DEFAULT (1),
    [DemandDraftNo] varchar(50) NULL,
    [Dated] datetime NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [Df_DB_PurOrderHeader_Amount] DEFAULT (0),
    [CustCode] smallint NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_DiscPerc] DEFAULT (0),
    [SupplierReference] varchar(50) NULL,
    [DeliveryLocation] varchar(50) NULL,
    [UsageLocation] varchar(50) NULL,
    [RequiredDate] datetime NULL,
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_InvGSTPerc1] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_MiscCharges] DEFAULT (0),
    [Remarks2] varchar(100) NULL,
    [Remarks3] varchar(100) NULL,
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_PurOrderHeader_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_PurOrderHeader] PRIMARY KEY ([SiteCode], [POCode])
);
GO

CREATE TABLE [dbo].[DB_Saledetail] (
    [SiteCode] smallint NOT NULL,
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DB_DF_Saledetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_DB_Saledetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_SaleDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_Saledetail_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_DB_Saledetail_SalesTax] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_Saledetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_Saledetail_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [DF_DB_SaleDetail_Claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_SaleDetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_DB_SaleDetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_SaleDetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    CONSTRAINT [PK_DB_Saledetail] PRIMARY KEY ([SiteCode], [SaleInvCode], [ICode], [RowGroup], [RowID])
);
GO

CREATE TABLE [dbo].[DB_SaleLedger] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SaleLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_DB_SaleLedger_InvGSTPerc1] DEFAULT (0),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_DB_SaleLedger_InvTotal] DEFAULT (0),
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_DB_SaleLedger_DueDate] DEFAULT (getdate()),
    [CustRefNo5] varchar(100) NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_DB_SaleLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_DB_SaleLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_SaleLedger_FBRPOSFee] DEFAULT (0),
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_SaleLedger_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_SaleLedger] PRIMARY KEY ([SiteCode], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[DB_SRdetail] (
    [SiteCode] smallint NOT NULL,
    [SRInvcode] int NOT NULL,
    [Icode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_SRDetail_LooseQty] DEFAULT (0),
    [PackUnits] int NOT NULL,
    [SRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_SRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_SRDetail_AvgPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_SRdetail_GSTPerc] DEFAULT (0),
    [SRUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_SRDetail_BonusQty] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_DB_SRdetail_SalePrice] DEFAULT (0),
    [SaleRowId] int NULL,
    [RowId] int NOT NULL,
    [ReturnItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_DB_SRDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_DB_SRDetail_PiecesInHand] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DB_SRDetail_NewAvgPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_DB_SRDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_ClaimableDiscPerc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_SRDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CurrStock] numeric(15,4) NOT NULL CONSTRAINT [DF_DB_SRDetail_CurrStock] DEFAULT (0),
    CONSTRAINT [PK_DB_SRDetail] PRIMARY KEY ([SiteCode], [SRInvCode], [RowId])
);
GO

CREATE TABLE [dbo].[DB_SRLedger] (
    [SiteCode] smallint NOT NULL,
    [TargetSiteCode] smallint NOT NULL,
    [SRInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [SRCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRLedger_MiscCharges] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_DB_SRLedger_InvGSTPerc1] DEFAULT (0),
    [Smancode] smallint NULL,
    [CustRefno] varchar(100) NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [invtotal] numeric(15,2) NOT NULL CONSTRAINT [DF_DB_SRLedger_invtotal] DEFAULT (0),
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_DB_SRLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_DB_SRLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_DB_SRLedger_FBRPOSFee] DEFAULT (0),
    [PushedOn] datetime NULL,
    [PushedBy] smallint NULL,
    [Pulled] char(1) NOT NULL CONSTRAINT [DF_DB_SRLedger_Pulled] DEFAULT ('N'),
    [PulledOn] datetime NULL,
    [PulledBy] smallint NULL,
    CONSTRAINT [PK_DB_SRLedger] PRIMARY KEY ([SiteCode], [SRInvCode])
);
GO

CREATE TABLE [dbo].[DBCC_History] (
    [ErrorID] int NULL,
    [LevelID] int NULL,
    [StateID] int NULL,
    [MessageText] varchar(7000) NULL,
    [RepairLevel] varchar(100) NULL,
    [StatusID] int NULL,
    [DbId] int NULL,
    [ObjectId] int NULL,
    [IndId] int NULL,
    [FileID] int NULL,
    [PageID] int NULL,
    [SlotID] int NULL,
    [RefFileID] int NULL,
    [RefPageID] int NULL,
    [RefSlotID] int NULL,
    [AllocationID] int NULL,
    [DB] varchar(255) NULL,
    [Object] varchar(255) NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DBCC_History_Date] DEFAULT (getdate()),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [DBFragID] int NULL,
    [PartitionID] int NULL,
    [AllocUnitID] int NULL,
    [RidDbId] int NULL,
    [RidPruId] int NULL,
    [RefDBID] int NULL,
    [RefPruID] int NULL
);
GO

CREATE TABLE [dbo].[DBRepairLog] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DBRepairLog_Date] DEFAULT (getdate()),
    [RepairLevel] varchar(30) NOT NULL CONSTRAINT [DF_DBRepairLog_RepairLevel] DEFAULT (''),
    [ObjectName] varchar(100) NULL,
    CONSTRAINT [PK_DBRepairLog] PRIMARY KEY CLUSTERED ([RowID])
);
GO

CREATE TABLE [dbo].[DeathCertificate] (
    [DeathCertificateCode] int NOT NULL,
    [PatientCode] int NOT NULL,
    [VisitCode] int NULL,
    [AdmissionCode] int NULL,
    [UserCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DeathCertificate_Date] DEFAULT (getdate()),
    [DOB] datetime NOT NULL CONSTRAINT [DF_DeathCertificate_DOB] DEFAULT (getdate()),
    [FullName] varchar(100) NULL,
    [Gender] char(1) NULL CONSTRAINT [DF_DeathCertificate_Gender] DEFAULT ('M'),
    [FatherName] varchar(100) NULL,
    [FatherCNIC] varchar(100) NULL,
    [FatherCellNo] varchar(100) NULL,
    [MotherName] varchar(100) NULL,
    [MotherCNIC] varchar(100) NULL,
    [MotherCellNo] varchar(100) NULL,
    [AgeOfMother] varchar(100) NULL,
    [DiseaseCode] smallint NULL,
    [PlaceOfDeath] varchar(100) NULL,
    [CauseofDeath] varchar(1000) NULL,
    [DoctorName] varchar(100) NULL,
    [HospitalName] varchar(100) NULL,
    [IssuedTo] varchar(100) NULL,
    [IssuedToCNIC] varchar(100) NULL,
    [IssuedToCellNo] varchar(100) NULL,
    [CNIC] varchar(100) NULL,
    CONSTRAINT [PK_DeathCertificate] PRIMARY KEY CLUSTERED ([DeathCertificateCode])
);
GO

CREATE TABLE [dbo].[DeletedSaleItem] (
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DeletedSaleItem_Qty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DeletedSaleItem_BonusQty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DeletedSaleItem_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DeletedSaleItem_DiscPerc] DEFAULT (0),
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DeletedSaleItem_ItemFlatDisc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_DeletedSaleItem_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_DeletedSaleItem_GSTPerc] DEFAULT (0),
    [Date] datetime NOT NULL CONSTRAINT [DF_DeletedSaleItem_Date] DEFAULT (getdate()),
    [MachineName] varchar(50) NOT NULL,
    [UserCode] smallint NOT NULL,
    [SaleInvCode] int NULL
);
GO

CREATE TABLE [dbo].[Department] (
    [DeptCode] smallint NOT NULL,
    [Name] varchar(40) NOT NULL,
    [Description] varchar(100) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_Department_Active] DEFAULT ('Y'),
    CONSTRAINT [PK___1__10] PRIMARY KEY CLUSTERED ([DeptCode])
);
GO

CREATE TABLE [dbo].[DiagnosticItem] (
    [DiagnosticItemCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [DiagnosticItemTypeCode] smallint NOT NULL,
    [DiagnosticUnitCode] smallint NOT NULL CONSTRAINT [DF_DiagnosticItem_DiagnosticUnitCode] DEFAULT (1),
    [Description] varchar(400) NULL,
    [MinValue] numeric(15,5) NOT NULL CONSTRAINT [DF_DiagnosticItem_MinValue] DEFAULT (0),
    [MaxValue] numeric(15,5) NOT NULL CONSTRAINT [DF_DiagnosticItem_MaxValue] DEFAULT (0),
    [NormalValue] numeric(15,5) NOT NULL CONSTRAINT [DF_DiagnosticItem_NormalValue] DEFAULT (0),
    CONSTRAINT [PK_DiagnosticItem_DiagnosticItemCode] PRIMARY KEY CLUSTERED ([DiagnosticItemCode])
);
GO

CREATE TABLE [dbo].[DiagnosticItemType] (
    [DiagnosticItemTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_DiagnosticType_DiagnosticTypeCode] PRIMARY KEY CLUSTERED ([DiagnosticItemTypeCode]),
    CONSTRAINT [UK_DiagnosticItemType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DiagnosticUnit] (
    [DiagnosticUnitCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_DiagnosticUnit_DiagnosticTypeCode] PRIMARY KEY CLUSTERED ([DiagnosticUnitCode]),
    CONSTRAINT [UK_DiagnosticUnit_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DischargePrescription] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DischargePrescription_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ICode] int NOT NULL,
    [DosageUnitCode] smallint NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DischargePrescription_Qty] DEFAULT (1),
    [DosageStrength] varchar(60) NULL,
    [DosageCode] smallint NOT NULL,
    [DosageFactor] smallint NOT NULL CONSTRAINT [DF_DischargePrescription_DosageFactor] DEFAULT (1),
    [RouteCode] smallint NOT NULL,
    [Duration] smallint NOT NULL CONSTRAINT [DF_DischargePrescription_Duration] DEFAULT (1),
    [StartDate] datetime NOT NULL CONSTRAINT [DF_DischargePrescription_StartDate] DEFAULT (getdate()),
    [InsCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_DischargePrescription_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_DischargePrescription_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[DischargeReason] (
    [DischargeReasonCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_DischargeReason] PRIMARY KEY CLUSTERED ([DischargeReasonCode]),
    CONSTRAINT [UK_DischargeReason_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DischargeRefferal] (
    [DischargeRefferalCode] smallint NOT NULL,
    [Name] varchar(100) NULL,
    CONSTRAINT [PK_DischargeRefferal] PRIMARY KEY CLUSTERED ([DischargeRefferalCode]),
    CONSTRAINT [UK_DischargeRefferal_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DiscountPolicy] (
    [DiscountPolicyCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_DiscountPolicy_DiscountPolicyCode] PRIMARY KEY CLUSTERED ([DiscountPolicyCode]),
    CONSTRAINT [UK_DiscountPolicy_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DiscountPolicyDetail] (
    [DiscountPolicyCode] smallint NOT NULL,
    [QtyLimit] int NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_DiscountPolicyDetail] DEFAULT (0),
    [ExpiryDate] datetime NOT NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_DiscountPolicyDetail_ItemFlatDisc] DEFAULT (0),
    CONSTRAINT [PK_DiscountPolicyDetail_DiscountPolicyCode_QtyLimit] PRIMARY KEY CLUSTERED ([DiscountPolicyCode], [QtyLimit])
);
GO

CREATE TABLE [dbo].[Disease] (
    [DiseaseCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [DiseaseTypeCode] smallint NOT NULL CONSTRAINT [DF_Disease_DiseaseTypeCode] DEFAULT (1),
    CONSTRAINT [PK_Disease] PRIMARY KEY CLUSTERED ([DiseaseCode]),
    CONSTRAINT [IX_DiseaseName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DiseaseTreatmentTemp] (
    [DiseaseTreatmentTempCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [DiseaseCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_DiseaseTreatmentTemp] PRIMARY KEY CLUSTERED ([DiseaseTreatmentTempCode]),
    CONSTRAINT [UK_DiseaseTreatmentTemp_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DiseaseTreatmentTempDetail] (
    [DiseaseTreatmentTempCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_DiseaseTreatmentTempDetail_Qty] DEFAULT (1),
    [DosageCode] smallint NULL,
    [DosageFactor] smallint NULL CONSTRAINT [DF_DiseaseTreatmentTempDetail_DosageFactor] DEFAULT (1),
    [RouteCode] smallint NULL,
    [Duration] smallint NULL CONSTRAINT [DF_DiseaseTreatmentTempDetail_Duration] DEFAULT (1),
    [InsCode] smallint NULL,
    [DosageUnitCode] smallint NOT NULL,
    [DosageStrength] varchar(60) NULL,
    [Details] varchar(100) NULL,
    [TotalQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DiseaseTreatmentTempDetail_TotalQty] DEFAULT (1),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_DiseaseTreatmentTempDetail] PRIMARY KEY CLUSTERED ([DiseaseTreatmentTempCode], [RowID])
);
GO

CREATE TABLE [dbo].[DiseaseType] (
    [DiseaseTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_DiseaseType] PRIMARY KEY CLUSTERED ([DiseaseTypeCode]),
    CONSTRAINT [UK_DiseaseType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DispatchDetail] (
    [DispCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    CONSTRAINT [PK___9__11] PRIMARY KEY CLUSTERED ([DispCode], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[DispatchHeader] (
    [DispCode] int NOT NULL,
    [GCCode] smallint NOT NULL,
    [CustCode] smallint NOT NULL,
    [BiltyNo] varchar(30) NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_DispatchHe_Posted_1__11] DEFAULT ('N'),
    [Date] datetime NOT NULL,
    [RecieverName] varchar(30) NULL,
    [RecieverTel] varchar(15) NULL,
    [Cartons] numeric(4,0) NOT NULL,
    [BankName] varchar(30) NULL,
    [BranchName] varchar(30) NULL,
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [SalesManCode] smallint NOT NULL,
    [BuiltyExpenses] numeric(10,2) NOT NULL CONSTRAINT [DF_DispatchHeader_BuiltyExpenses] DEFAULT (0),
    [DeliveredBy] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_DispatchHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK___8__11] PRIMARY KEY CLUSTERED ([DispCode])
);
GO

CREATE TABLE [dbo].[DoctorCategory] (
    [DoctorCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_DoctorCategory] PRIMARY KEY CLUSTERED ([DoctorCategoryCode]),
    CONSTRAINT [UK_DoctorCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DoctorDutyRoster] (
    [DoctorDutyRosterCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DoctorDutyRoster_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [StartDate] datetime NOT NULL,
    [EndDate] datetime NOT NULL,
    [Active] char(1) NULL CONSTRAINT [DF_DoctorDutyRoster_Active] DEFAULT ('Y'),
    CONSTRAINT [PK_DoctorDutyRoster] PRIMARY KEY CLUSTERED ([DoctorDutyRosterCode]),
    CONSTRAINT [UK_DoctorDutyRoster_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DoctorDutyRosterDetail] (
    [DoctorDutyRosterCode] int NOT NULL,
    [DoctCode] smallint NOT NULL,
    [StartDate] datetime NOT NULL CONSTRAINT [DF_DoctorDutyRosterDetail_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_DoctorDutyRosterDetail_EndDate] DEFAULT (getdate()),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_DoctorDutyRosterDetail] PRIMARY KEY CLUSTERED ([DoctorDutyRosterCode], [RowID])
);
GO

CREATE TABLE [dbo].[Doctors] (
    [DoctCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [AliasName] varchar(60) NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [City] varchar(20) NULL,
    [Country] varchar(25) NULL,
    [Phone] varchar(15) NULL,
    [Fax] varchar(20) NULL,
    [des] varchar(20) NULL,
    [Email] varchar(35) NULL,
    [Fee] numeric(10,2) NOT NULL CONSTRAINT [DF_Doctors_Fee] DEFAULT (0),
    [Title1] varchar(100) NULL,
    [Title2] varchar(100) NULL,
    [Title3] varchar(100) NULL,
    [Title4] varchar(100) NULL,
    [Footer1] varchar(100) NULL,
    [Footer2] varchar(100) NULL,
    [Footer3] varchar(100) NULL,
    [Footer4] varchar(100) NULL,
    [ServiceTemplateCode] int NULL,
    [LastTokenNo] int NOT NULL CONSTRAINT [DF_Doctors_TokenNo] DEFAULT (0),
    [EstPatientCountPerDay] int NOT NULL CONSTRAINT [DF_Doctors_EstPatientCountPerDay] DEFAULT (9999),
    [AccCode] smallint NULL,
    [TimeSlotInterval] int NOT NULL CONSTRAINT [DF_Doctors_TimeSlotInterval] DEFAULT (15),
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_Doctors_HeaderNo] DEFAULT (1),
    [Active] char(1) NOT NULL CONSTRAINT [DF_Doctors_Active] DEFAULT ('Y'),
    [Signature] image NULL,
    [DoctorCategoryCode] smallint NOT NULL CONSTRAINT [DF_DoctorCategory_DoctorCategoryCode] DEFAULT (1),
    CONSTRAINT [PK_Doctors_1__10] PRIMARY KEY CLUSTERED ([DoctCode])
);
GO

CREATE TABLE [dbo].[Dosage] (
    [DosageCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [DoseFactor] smallint NOT NULL,
    [Description] varchar(100) NULL,
    [LocalDosage] nvarchar(255) NULL,
    CONSTRAINT [PK_Dosage] PRIMARY KEY CLUSTERED ([DosageCode]),
    CONSTRAINT [UQ_Dosage_Name] UNIQUE ([Name]),
    CONSTRAINT [CK_Dosage_DoseFactor] CHECK ([dosefactor] > 0)
);
GO

CREATE TABLE [dbo].[DosageUnit] (
    [DosageUnitCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [LocalDosageUnit] nvarchar(255) NULL,
    CONSTRAINT [PK_DosageUnit_DosageUnitCode] PRIMARY KEY CLUSTERED ([DosageUnitCode]),
    CONSTRAINT [UK_DosageUnit_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[DropData] (
    [TableName] varchar(60) NOT NULL,
    [ColumnName] varchar(60) NOT NULL,
    [Priority] numeric(6,2) NOT NULL,
    CONSTRAINT [PK_DropData] PRIMARY KEY CLUSTERED ([TableName], [ColumnName]),
    CONSTRAINT [UK_DropData] UNIQUE ([Priority])
);
GO

CREATE TABLE [dbo].[DueAdjDetail] (
    [DueAdjCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [Icode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [SaleRowId] int NOT NULL,
    [DueQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DueAdjDetail_DueQty] DEFAULT (0),
    [SatisfiedQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DueAdjDetail_SatisfiedQty] DEFAULT (0),
    [SatisfiableQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DueAdjDetail_SatisfiableQty] DEFAULT (0),
    [DueDelete] char(1) NOT NULL CONSTRAINT [DF_DueAdjDetail_DueDelete] DEFAULT ('N'),
    CONSTRAINT [PK_DueAdjDetail] PRIMARY KEY CLUSTERED ([DueAdjCode], [SaleInvCode], [Icode], [SaleRowId])
);
GO

CREATE TABLE [dbo].[DueAdjHeader] (
    [DueAdjCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_DueAdjHeader_Date] DEFAULT (getdate()),
    [StartDate] datetime NOT NULL,
    [EndDate] datetime NOT NULL,
    [Remarks] varchar(60) NULL,
    [UserCode] smallint NOT NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_DueAdjHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_DueAdjHeader_DueAdjCode] PRIMARY KEY CLUSTERED ([DueAdjCode])
);
GO

CREATE TABLE [dbo].[DueDeleteDetail] (
    [DueSatisfyCode] int NOT NULL,
    [ICode] int NOT NULL,
    [DeletedQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DueDeleteDetail_DeletedQty] DEFAULT (1),
    [SaleRowId] int NOT NULL,
    CONSTRAINT [PK_DueDeleteDetail] PRIMARY KEY CLUSTERED ([DueSatisfyCode], [ICode], [SaleRowId])
);
GO

CREATE TABLE [dbo].[DueSatisfyDetail] (
    [DueSatisfyCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [DueSatisfyQty] numeric(15,4) NOT NULL CONSTRAINT [DF_DueSatisfyDetail_DueSatisfyQty] DEFAULT (1),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_DueSatisfyDetail_AvgPrice] DEFAULT (0),
    [DueSatisfyUtn] bigint NULL,
    [PackSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_DueSatisfyDetail_PackSalePrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_DueSatisfyDetail_PackUnits] DEFAULT (1),
    [SaleRowId] int NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_DueSatisfyDetail_BalanceStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[DueSatisfyHeader] (
    [DueSatisfyCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [DueSatisfyDate] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [DueAdjCode] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_DueSatisfyHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_DueSatisfyHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_DueSatisfyHeader_1__11] PRIMARY KEY CLUSTERED ([DueSatisfyCode])
);
GO

CREATE TABLE [dbo].[ECG] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ECG_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ECG] char(1) NULL,
    [ECGDate] datetime NULL,
    [WithinNormalLimit] char(1) NULL,
    [WithinNormalLimitECG] varchar(100) NULL,
    [NonSpecificFindings] char(1) NULL,
    [NonSpecificFindingsECG] varchar(100) NULL,
    [SymmetricalTinversions] char(1) NULL,
    [SymmetricalTinversionsECG] varchar(100) NULL,
    [AsymmetricalTInversions] char(1) NULL,
    [AsymmetricalTInversionsECG] varchar(100) NULL,
    [SignificantSTTChanges] char(1) NULL,
    [SignificantSTTChangesECG] varchar(100) NULL,
    [NonsignificantSTTChanges] char(1) NULL,
    [NonsignificantSTTChangesECG] varchar(100) NULL,
    [SignificantSTDepressions] char(1) NULL,
    [SignificantSTDepressionsECG] varchar(100) NULL,
    [NonSignificantSTDepressions] char(1) NULL,
    [NonSignificantSTDepressionsECG] varchar(100) NULL,
    [DynamicSTDepressions] char(1) NULL,
    [DynamicSTDepressionsECG] varchar(100) NULL,
    [SignificantSTElevations] char(1) NULL,
    [SignificantSTElevationsECG] varchar(100) NULL,
    [NonSignificantSTElevations] char(1) NULL,
    [NonSignificantSTElevationsECG] varchar(100) NULL,
    [SinusTachycardia] char(1) NULL,
    [SinusTachycardiaECG] varchar(100) NULL,
    [SinusBradycardia] char(1) NULL,
    [SinusBradycardiaECG] varchar(100) NULL,
    [BroadComplexTachycardia] char(1) NULL,
    [BroadComplexTachycardiaECG] varchar(100) NULL,
    [NarrowComplexTachycardia] char(1) NULL,
    [NarrowComplexTachycardiaECG] varchar(100) NULL,
    [LBBB] char(1) NULL,
    [LBBBECG] varchar(100) NULL,
    [RBBB] char(1) NULL,
    [RBBBECG] varchar(100) NULL,
    [LeftAxisDeviation] char(1) NULL,
    [LeftAxisDeviationECG] varchar(100) NULL,
    [RightAxisDeviation] char(1) NULL,
    [RightAxisDeviationECG] varchar(100) NULL,
    [CHB] char(1) NULL,
    [CHBECG] varchar(100) NULL,
    [AVDissociation] char(1) NULL,
    [AVDissociationECG] varchar(100) NULL,
    [AVBlock] char(1) NULL,
    [AVBlockECG] varchar(100) NULL,
    [BifascicularBlock] char(1) NULL,
    [BifascicularBlockECG] varchar(100) NULL,
    [TrifascicularBlock] char(1) NULL,
    [TrifascicularBlockECG] varchar(100) NULL,
    [ArrythmiasECG] char(1) NULL,
    [VTECG] char(1) NULL,
    [AFibECG] char(1) NULL,
    [SVTECG] char(1) NULL,
    [PSVTECG] char(1) NULL,
    [WPWECG] char(1) NULL,
    [OtherECG] varchar(255) NULL,
    [VFibEcg] char(1) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_ECG_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_ECG_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[Echo] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_Echo_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [Echo] char(1) NULL,
    [DateEcho] datetime NULL,
    [DoctorEcho] varchar(100) NULL,
    [InstitutionEcho] varchar(100) NULL,
    [NormalLV] char(1) NULL,
    [LVSystolicdysfunctionEcho] char(1) NULL,
    [LVSystolicdysfunctionValueEcho] char(1) NULL,
    [DilatedLV] char(1) NULL,
    [SWMAEcho] char(1) NULL,
    [SWMAValueEcho] char(1) NULL,
    [EF] char(1) NULL,
    [EFEcho] numeric(10,2) NULL,
    [RV] char(1) NULL,
    [RVsystolicdysfunctionEcho] char(1) NULL,
    [ValvularHeartDiseaseEcho] char(1) NULL,
    [MS] char(1) NULL,
    [MSEcho] char(1) NULL,
    [MR] char(1) NULL,
    [MREcho] char(1) NULL,
    [AR] char(1) NULL,
    [AREcho] char(1) NULL,
    [ASE] char(1) NULL,
    [ASEcho] char(1) NULL,
    [PS] char(1) NULL,
    [PSEcho] char(1) NULL,
    [TR] char(1) NULL,
    [TREcho] char(1) NULL,
    [ASD] char(1) NULL,
    [ASDEcho] char(1) NULL,
    [VSD] char(1) NULL,
    [VSDEcho] char(1) NULL,
    [TOF] char(1) NULL,
    [TOFEcho] char(1) NULL,
    [PulmonaryHypertension] char(1) NULL,
    [PulmonaryHypertensionEcho] char(1) NULL,
    [OtherEchoDetail] varchar(1000) NULL,
    [DialatedLVValue] char(1) NULL,
    [DialatedRVValue] char(1) NULL,
    [DialatedLAValue] char(1) NULL,
    [DialatedRAValue] char(1) NULL,
    [DialatedARValue] char(1) NULL,
    [RVSystolicDysfunctionValueecho] char(1) NULL,
    [DiastolicDysfunctionecho] char(1) NULL,
    [DiastolicDysfunctionValueecho] char(1) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_Echo_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_Echo_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[EmailTemplate] (
    [EmailTemplateCode] int NOT NULL,
    [Subject] varchar(800) NOT NULL,
    [Body] varchar(800) NULL,
    CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED ([EmailTemplateCode]),
    CONSTRAINT [UK_EmailTemplate_Subject] UNIQUE ([Subject])
);
GO

CREATE TABLE [dbo].[EMP_Advance] (
    [AdvanceCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_EMP_Advance_Date] DEFAULT (getdate()),
    [AccCode] smallint NOT NULL,
    [EmpAdvAccCode] smallint NOT NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Advance_Amount] DEFAULT (0),
    [ReturnedAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Advance_ReturnedAmt] DEFAULT (0),
    [Installment] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Advance_Installment] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [RefNo] varchar(20) NULL,
    [UserCode] smallint NOT NULL,
    [GLVochCode] int NULL,
    CONSTRAINT [PK_EMP_Advance] PRIMARY KEY CLUSTERED ([AdvanceCode])
);
GO

CREATE TABLE [dbo].[EMP_Allowance] (
    [AllowanceCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AttendanceWise] char(1) NOT NULL CONSTRAINT [DF_EMP_Allowance_AttendanceWise] DEFAULT ('N'),
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_Allowance_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_Allowance_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_Allowance] PRIMARY KEY CLUSTERED ([AllowanceCode]),
    CONSTRAINT [UK_EMP_Allowance] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_Attendance] (
    [AttendanceCode] bigint IDENTITY(1,1) NOT NULL,
    [EMPCode] int NOT NULL,
    [FingerCode] tinyint NOT NULL,
    [TIMEIN] datetime NOT NULL,
    [TIMEOUT] datetime NULL,
    [FingerCodeOut] tinyint NULL,
    [AttendanceStatusCode] tinyint NOT NULL,
    [Payed] char(1) NOT NULL CONSTRAINT [DF_EMP_Attendance_Payed] DEFAULT ('N'),
    [Comments] varchar(255) NULL,
    [Supervised] char(1) NOT NULL CONSTRAINT [DF_EMP_Attendance_Supervised] DEFAULT ('N'),
    [SupervisedOn] datetime NULL,
    [SupervisedBy] smallint NULL,
    CONSTRAINT [PK_EMP_Attendance] PRIMARY KEY CLUSTERED ([AttendanceCode])
);
GO

CREATE TABLE [dbo].[EMP_AttendanceStatus] (
    [AttendanceStatusCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Half] tinyint NOT NULL CONSTRAINT [DF_EMP_AttendanceStatus_Half] DEFAULT (0),
    [DeductionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_AttendanceStatus_Deduction] DEFAULT (0),
    [AutoSet] char(1) NULL CONSTRAINT [DF_EMP_AttendanceStatus_AutoSet] DEFAULT ('N'),
    [TimeType] tinyint NULL CONSTRAINT [DF_EMP_AttendanceStatus_TimeType] DEFAULT (1),
    [Margin] int NULL CONSTRAINT [DF_EMP_AttendanceStatus_Margin] DEFAULT (0),
    CONSTRAINT [PK_EMP_AttendanceStatus] PRIMARY KEY CLUSTERED ([AttendanceStatusCode]),
    CONSTRAINT [UK_EMP_AttendanceStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_Category] (
    [EmpCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_EMP_Category] PRIMARY KEY CLUSTERED ([EmpCatCode]),
    CONSTRAINT [UK_EMP_Category_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_Certification] (
    [CertificationCode] int IDENTITY(1,1) NOT NULL,
    [Name] varchar(255) NOT NULL,
    CONSTRAINT [PK_EMP_Certification] PRIMARY KEY CLUSTERED ([CertificationCode]),
    CONSTRAINT [UK_EMP_Certification_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_Deduction] (
    [DeductionCode] smallint NOT NULL,
    [Description] varchar(255) NULL,
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_Deduction_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_Deduction_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_Deduction] PRIMARY KEY CLUSTERED ([DeductionCode])
);
GO

CREATE TABLE [dbo].[EMP_Department] (
    [DeptCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_EMP_Department] PRIMARY KEY CLUSTERED ([DeptCode]),
    CONSTRAINT [UK_EMP_Department_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_DepartmentTiming] (
    [DeptCode] smallint NOT NULL,
    [WeekDayCode] tinyint NOT NULL,
    [FHTimeIn] datetime NULL,
    [FHTimeOut] datetime NULL,
    [SHTimeIn] datetime NULL,
    [SHTimeOut] datetime NULL,
    CONSTRAINT [PK_EMP_DepartmentTiming] PRIMARY KEY CLUSTERED ([DeptCode], [WeekDayCode])
);
GO

CREATE TABLE [dbo].[EMP_Designation] (
    [DesigCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_EMP_Designation] PRIMARY KEY CLUSTERED ([DesigCode]),
    CONSTRAINT [UK_EMP_Designation_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_Education] (
    [EducationCode] int IDENTITY(1,1) NOT NULL,
    [Name] varchar(255) NOT NULL,
    CONSTRAINT [PK_EMP_Education] PRIMARY KEY CLUSTERED ([EducationCode]),
    CONSTRAINT [UK_EMP_Education_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_EmpCertification] (
    [EmpCode] int NOT NULL,
    [CertificationCode] int NOT NULL,
    [Institute] varchar(100) NOT NULL,
    [FromDate] datetime NOT NULL,
    [TODate] datetime NULL,
    [Description] varchar(255) NULL,
    [Result] varchar(100) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_EmpEducation] (
    [EmpCode] int NOT NULL,
    [EducationCode] int NOT NULL,
    [Institute] varchar(100) NOT NULL,
    [FromDate] datetime NOT NULL,
    [TODate] datetime NULL,
    [Description] varchar(255) NULL,
    [Result] varchar(100) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_Employee] (
    [EmpCode] int NOT NULL,
    [EmpID] varchar(100) NOT NULL,
    [FullName] varchar(255) NOT NULL,
    [Gender] char(1) NOT NULL CONSTRAINT [DF_EMP_Employee_Gender] DEFAULT ('M'),
    [MaritalStatus] char(1) NOT NULL CONSTRAINT [DF_EMP_Employee_MaritalStatus] DEFAULT ('S'),
    [Date] datetime NOT NULL CONSTRAINT [DF_EMP_Employee_Date] DEFAULT (getdate()),
    [BirthDate] datetime NOT NULL CONSTRAINT [DF_EMP_Employee_BirthDate] DEFAULT (getdate()),
    [JoinDate] datetime NOT NULL CONSTRAINT [DF_EMP_Employee_JoinDate] DEFAULT (getdate()),
    [EmpCatCode] smallint NOT NULL,
    [DeptCode] smallint NOT NULL,
    [DesigCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [CNICNo] varchar(100) NULL,
    [FHName] varchar(255) NULL,
    [FHNICNo] varchar(100) NULL,
    [PMTAddress] varchar(255) NULL,
    [TmpAddress] varchar(255) NULL,
    [MobileNo] varchar(100) NULL,
    [PhoneNo] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Web] varchar(100) NULL,
    [Nationality] varchar(100) NULL,
    [Domicile] varchar(100) NULL,
    [Religion] varchar(100) NULL,
    [NTN] varchar(100) NULL,
    [BloodGroup] varchar(100) NULL,
    [ExitDate] datetime NULL,
    [ExitReason] varchar(255) NULL,
    [RefferedBy] varchar(100) NULL,
    [RefferedByContactNo] varchar(100) NULL,
    [RefferedByCNICNo] varchar(100) NULL,
    [RefferedByAdress] varchar(100) NULL,
    [RefferedByRelation] varchar(100) NULL,
    [AdvAccCode] smallint NULL,
    [Picture] image NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_EMP_Employee_Active] DEFAULT ('Y'),
    [AllowAttendanceViaID] char(1) NOT NULL CONSTRAINT [DF_EMP_Employee_AllowAttendanceViaID] DEFAULT ('N'),
    [MaxTimeInLimitInHrs] int NOT NULL CONSTRAINT [DF_EMP_Employee_MaxTimeInLimitInHrs] DEFAULT (12),
    [TransportRouteCode] int NULL,
    [VehicleCode] int NULL,
    [BankName] varchar(100) NULL,
    [BankBranch] varchar(100) NULL,
    [BankAccountNo] varchar(100) NULL,
    CONSTRAINT [PK_EMP_Employee] PRIMARY KEY CLUSTERED ([EmpCode]),
    CONSTRAINT [UK_EMP_Employee_EmpID] UNIQUE ([EmpID])
);
GO

CREATE TABLE [dbo].[EMP_EmpSkill] (
    [EmpCode] int NOT NULL,
    [SkillCode] int NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_Finger] (
    [FingerCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_EMP_Finger] PRIMARY KEY CLUSTERED ([FingerCode]),
    CONSTRAINT [UK_EMP_Finger_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EMP_FingerPrint] (
    [EmpCode] int NOT NULL,
    [FingerCode] tinyint NOT NULL,
    [FingerPrint] image NULL,
    [Features] ntext NULL,
    CONSTRAINT [PK_EMP_FingerPrint] PRIMARY KEY CLUSTERED ([EmpCode], [FingerCode])
);
GO

CREATE TABLE [dbo].[Emp_Holiday] (
    [HolidayID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL,
    [Name] varchar(100) NOT NULL,
    [PayRatePerc] numeric(5,2) NULL CONSTRAINT [DF_Emp_Holiday_PayRatePerc] DEFAULT (100),
    CONSTRAINT [PK_Emp_Holiday] PRIMARY KEY CLUSTERED ([HolidayID]),
    CONSTRAINT [UK_Emp_Holiday_Date] UNIQUE ([Date])
);
GO

CREATE TABLE [dbo].[EMP_Image] (
    [EmpCode] int NOT NULL,
    [ImageDescription] varchar(100) NULL,
    [ROWID] int NOT NULL,
    [Image] image NULL,
    [ImageType] varchar(100) NULL
);
GO

CREATE TABLE [dbo].[EMP_JobExp] (
    [EmpCode] int NOT NULL,
    [Designation] varchar(100) NOT NULL,
    [Oganization] varchar(100) NOT NULL,
    [FromDate] datetime NOT NULL,
    [ToDate] datetime NULL,
    [JobDescription] varchar(1000) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_Pay] (
    [EMPCode] int NOT NULL,
    [PayFrequency] tinyint NOT NULL CONSTRAINT [DF_EMP_Pay_PayFrequency] DEFAULT (1),
    [WorkingHours] numeric(4,2) NOT NULL CONSTRAINT [DF_EMP_Pay_WorkingHours] DEFAULT (8),
    [WorkingWeekDays] tinyint NOT NULL CONSTRAINT [DF_EMP_Pay_WorkingWeekDays] DEFAULT (6),
    [PayType] tinyint NOT NULL CONSTRAINT [DF_EMP_Pay_PayType] DEFAULT (1),
    [PerHourRate] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Pay_PerHourRate] DEFAULT (0),
    [BasicPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Pay_BasicPay] DEFAULT (0),
    [OverTime] char(1) NOT NULL CONSTRAINT [DF_EMP_Pay_OverTime] DEFAULT ('N'),
    [OverTimeRate] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_Pay_OverTimeRate] DEFAULT ('N'),
    [LastPayment] datetime NULL,
    [LastRaised] datetime NULL,
    [SundaysPaid] char(1) NOT NULL CONSTRAINT [DF_Emp_Pay_SundaysPaid] DEFAULT ('Y'),
    [HolidaysPaid] char(1) NOT NULL CONSTRAINT [DF_Emp_Pay_HolidaysPaid] DEFAULT ('Y'),
    [PayFrequencyFactor] smallint NOT NULL CONSTRAINT [DF_EMP_Pay_PayFrequencyFactor] DEFAULT (30),
    CONSTRAINT [PK_EMP_Pay] PRIMARY KEY CLUSTERED ([EMPCode])
);
GO

CREATE TABLE [dbo].[EMP_PayAllowance] (
    [EMPCode] int NOT NULL,
    [AllowanceCode] smallint NOT NULL,
    [AttendanceWise] char(1) NOT NULL CONSTRAINT [DF_EMP_PayAllowance_AttendanceWise] DEFAULT ('N'),
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_PayAllowance_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_PayAllowance_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_PayAllowance] PRIMARY KEY CLUSTERED ([EMPCode], [AllowanceCode])
);
GO

CREATE TABLE [dbo].[EMP_PayDeduction] (
    [EMPCode] int NOT NULL,
    [DeductionCode] smallint NOT NULL,
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_PayDeduction_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_PayDeduction_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_PayDeduction] PRIMARY KEY CLUSTERED ([EMPCode], [DeductionCode])
);
GO

CREATE TABLE [dbo].[EMP_Payroll] (
    [PayrollCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_EMP_Payroll_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_EMP_Payroll_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [LastSaved] datetime NOT NULL CONSTRAINT [DF_EMP_Payroll_LastSaved] DEFAULT (getdate()),
    [FromDate] datetime NULL,
    [ToDate] datetime NULL,
    [EmpCode] int NOT NULL,
    [WorkDays] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_WorkDays] DEFAULT (0),
    [Presents] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Presents] DEFAULT (0),
    [Absents] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Absents] DEFAULT (0),
    [Leaves] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Leaves] DEFAULT (0),
    [PerHourRate] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_PerHourRate] DEFAULT (0),
    [BasicPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_BasicPay] DEFAULT (0),
    [OverTimeHours] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_OverTimeHours] DEFAULT (0),
    [OverTimeRate] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_OverTimeRate] DEFAULT (0),
    [OverTime] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_OverTime] DEFAULT (0),
    [BonusPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_BonusPay] DEFAULT (0),
    [SpecialPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_SpecialPay] DEFAULT (0),
    [AdditionalPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_AdditionalPay] DEFAULT (0),
    [OtherPay] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_OtherPay] DEFAULT (0),
    [Fine] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Fine] DEFAULT (0),
    [Penalty] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Penalty] DEFAULT (0),
    [OtherCharge] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_OtherCharge] DEFAULT (0),
    [Advance] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Advance] DEFAULT (0),
    [NetPayable] numeric(12,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_NetPayable] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [Paid] char(1) NOT NULL CONSTRAINT [DF_EMP_Payroll_Paid] DEFAULT ('N'),
    [PaidVia] smallint NULL,
    [PaymentDate] datetime NULL CONSTRAINT [DF_EMP_Payroll_PaymentDate] DEFAULT (getdate()),
    [PaymentRefNo] varchar(20) NULL,
    [PaymentRemarks] varchar(100) NULL,
    [PaidBy] smallint NULL,
    [Sundays] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Sundays] DEFAULT (0),
    [Holidays] numeric(6,2) NOT NULL CONSTRAINT [DF_EMP_Payroll_Holidays] DEFAULT (0),
    [HoursWorked] numeric(10,4) NOT NULL CONSTRAINT [DF_EMP_Payroll_HoursWorked] DEFAULT (0),
    CONSTRAINT [PK_EMP_Payroll] PRIMARY KEY CLUSTERED ([PayrollCode])
);
GO

CREATE TABLE [dbo].[EMP_PayrollAllowances] (
    [PayrollCode] int NOT NULL,
    [AllowanceCode] smallint NOT NULL,
    [AttendanceWise] char(1) NOT NULL CONSTRAINT [DF_EMP_PayrollAllowances_AttendanceWise] DEFAULT ('N'),
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_PayrollAllowances_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_PayrollAllowances_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_PayrollAllowances] PRIMARY KEY CLUSTERED ([PayrollCode], [AllowanceCode])
);
GO

CREATE TABLE [dbo].[EMP_PayrollDeductions] (
    [PayrollCode] int NOT NULL,
    [DeductionCode] smallint NOT NULL,
    [Percentage] numeric(5,2) NOT NULL CONSTRAINT [DF_EMP_PayrollDeductions_Percentage] DEFAULT (0),
    [FlatAmount] numeric(10,2) NOT NULL CONSTRAINT [DF_EMP_PayrollDeductions_FlatAmount] DEFAULT (0),
    CONSTRAINT [PK_EMP_PayrollDeductions] PRIMARY KEY CLUSTERED ([PayrollCode], [DeductionCode])
);
GO

CREATE TABLE [dbo].[EMP_Project] (
    [EmpCode] int NOT NULL,
    [ProjectName] varchar(100) NOT NULL,
    [Oganization] varchar(100) NOT NULL,
    [FromDate] datetime NOT NULL,
    [ToDate] datetime NULL,
    [BriefDescription] varchar(1000) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_Reference] (
    [EmpCode] int NOT NULL,
    [PersonName] varchar(100) NOT NULL,
    [Organization] varchar(100) NULL,
    [Designation] varchar(100) NULL,
    [ContactNo] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Comments] varchar(1000) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[EMP_Skill] (
    [SkillCode] int IDENTITY(1,1) NOT NULL,
    [Name] varchar(255) NOT NULL,
    CONSTRAINT [PK_EMP_Skill] PRIMARY KEY CLUSTERED ([SkillCode]),
    CONSTRAINT [UK_EMP_Skill_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EmrLabInvestRec] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_EmrLabInvestRec_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [SetA] char(1) NULL,
    [SetA_CBC] char(1) NULL,
    [SetA_UreaCreatinine] char(1) NULL,
    [SetA_SerumNa] char(1) NULL,
    [SetA_K] char(1) NULL,
    [SetA_RandomBloodSugar] char(1) NULL,
    [SetA_CPK] char(1) NULL,
    [SetA_CKMB] char(1) NULL,
    [SetB] char(1) NULL,
    [SetB_TropTI] char(1) NULL,
    [SetB_CE] char(1) NULL,
    [SetB_PTINR] char(1) NULL,
    [SetB_APTT] char(1) NULL,
    [SetC] char(1) NULL,
    [SetC_SerumMagnesium] char(1) NULL,
    [SetC_SerumCalcium] char(1) NULL,
    [SetC_BNP] char(1) NULL,
    [SetC_DDimmer] char(1) NULL,
    [SetC_ASOTitre] char(1) NULL,
    [SetC_CRP] char(1) NULL,
    [SetC_CRPHighSensitive] char(1) NULL,
    [SetC_UrineCE] char(1) NULL,
    [Other] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_EmrLabInvestRec_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_EmrLabInvestRec_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[EventLog] (
    [EventID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_EventLog_Date] DEFAULT (getdate()),
    [EventType] varchar(100) NULL CONSTRAINT [DF_EventLog_EventType] DEFAULT ('Information'),
    [Module] varchar(100) NULL,
    [Detail] varchar(1000) NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_EventLog_EventID] PRIMARY KEY CLUSTERED ([EventID])
);
GO

CREATE TABLE [dbo].[ExpiryIntimation] (
    [IntimationCode] int NOT NULL,
    [IntimationTypeCode] tinyint NOT NULL,
    [IntimationSerialNo] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ExpiryIntimation_Date] DEFAULT (getdate()),
    [RefNo] varchar(100) NULL,
    [Remarks1] varchar(255) NULL,
    [Remarks2] varchar(255) NULL,
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ExpiryIntimation_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [CustCode] smallint NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_ExpiryIntimation_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_ExpiryIntimation_IntimationCode] PRIMARY KEY CLUSTERED ([IntimationCode])
);
GO

CREATE TABLE [dbo].[ExpiryIntimationDetail] (
    [IntimationCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ExpiryIntimationDetail_Qty] DEFAULT (0),
    [Packunits] smallint NOT NULL,
    [PackPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ExpiryIntimationDetail_PackPrice] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ExpiryIntimationDetail_Price] DEFAULT (0),
    [InvoiceCode] int NULL,
    [InvoiceDate] datetime NULL,
    [RefNo] varchar(100) NULL,
    [RefDate] datetime NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [ManfCode] smallint NULL,
    [LastAccCode] smallint NULL,
    CONSTRAINT [PK_ExpiryIntimationDetail] PRIMARY KEY CLUSTERED ([IntimationCode], [ICode], [Batch], [Expiry], [RowID])
);
GO

CREATE TABLE [dbo].[ExtraTaxRule] (
    [ExtraTaxRuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_ExtraTaxRule_AddionalTaxRuleCode] PRIMARY KEY CLUSTERED ([ExtraTaxRuleCode]),
    CONSTRAINT [UK_ExtraTaxRule_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_ExtraTaxRule_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[EyeVision] (
    [EyeVisionCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_EyeVision_EyeVisionCode] PRIMARY KEY CLUSTERED ([EyeVisionCode]),
    CONSTRAINT [UK_EyeVision_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Fzcity] (
    [city_code] int NULL,
    [zone_code] int NULL,
    [city] varchar(20) NULL
);
GO

CREATE TABLE [dbo].[GenericItem] (
    [GenericCode] int NOT NULL,
    [Name] varchar(150) NOT NULL,
    [Instruction] varchar(200) NULL,
    [Description] varchar(200) NULL,
    [GenericItemTypeCode] smallint NOT NULL CONSTRAINT [DF_GenericItem_GenericItemTypeCode] DEFAULT (1),
    CONSTRAINT [PK_GenericItem] PRIMARY KEY CLUSTERED ([GenericCode]),
    CONSTRAINT [IX_GenericItem_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GenericItemType] (
    [GenericItemTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_GenericItemType_GenericItemTypeCode] PRIMARY KEY CLUSTERED ([GenericItemTypeCode]),
    CONSTRAINT [UK_GenericItemType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Gestation] (
    [GestationCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_Gestation_GestationCode] PRIMARY KEY CLUSTERED ([GestationCode]),
    CONSTRAINT [UK_Gestation_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GLDetail] (
    [GLVochCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Debit] numeric(15,2) NOT NULL CONSTRAINT [DF_GLDetail_Debit_3__11] DEFAULT (0),
    [Credit] numeric(15,2) NOT NULL CONSTRAINT [DF_GLDetail_Credit_2__11] DEFAULT (0),
    [ChkNo] varchar(20) NULL,
    [Remarks] varchar(100) NULL,
    [GLRowID] int IDENTITY(1,1) NOT NULL,
    [GLUTN] bigint NULL,
    [PatientCode] int NULL,
    [INVOICECODE] int NULL,
    [OUTSTANDINGAMT] numeric(15,2) NOT NULL CONSTRAINT [DF_GLDetail_OUTSTANDINGAMT] DEFAULT (0),
    [BALANCE] numeric(15,2) NOT NULL CONSTRAINT [DF_GLDetail_BALANCE] DEFAULT (0),
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [ForeignAmt] numeric(15,5) NOT NULL CONSTRAINT [DF_GLHeader_ForeignAmt] DEFAULT (0),
    CONSTRAINT [PK_GLDetail] PRIMARY KEY CLUSTERED ([GLVochCode], [GLRowID])
);
GO

CREATE TABLE [dbo].[GLDocument] (
    [GLVochCode] int NOT NULL,
    [DocDescription] varchar(100) NULL,
    [RowID] int NOT NULL,
    [Document] image NULL,
    [DocumentType] varchar(100) NULL,
    CONSTRAINT [PK_GLDocument] PRIMARY KEY CLUSTERED ([GLVochCode], [RowID])
);
GO

CREATE TABLE [dbo].[Glheader] (
    [GLVochCode] int NOT NULL,
    [VochCatCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [salesmancode] smallint NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [CHKNO] varchar(20) NULL,
    [VoucherCode] int NOT NULL CONSTRAINT [DF_GLHeader_VoucherCode] DEFAULT (0),
    [SManCode] smallint NULL,
    [TransferAble] char(1) NOT NULL CONSTRAINT [DF_GLHeader_TransferAble] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_GLHeader_Transfered] DEFAULT ('N'),
    [TransferedON] datetime NULL,
    [TransferedBY] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_GLHeader_Imported] DEFAULT ('N'),
    [ImportedBY] smallint NULL,
    [BillSummaryCode] int NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_GLHeader_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_GLHeader_ConversionRate] DEFAULT (1),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_GLHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_GLHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    CONSTRAINT [PK_Glheader] PRIMARY KEY CLUSTERED ([GLVochCode]),
    CONSTRAINT [IX_GLHeader_VoucherCode] UNIQUE ([VochCatCode], [VoucherCode])
);
GO

CREATE TABLE [dbo].[Global] (
    [Name] varchar(30) NOT NULL,
    [TableName] varchar(30) NOT NULL,
    [Code] numeric(5,0) NOT NULL,
    [Description] varchar(40) NULL,
    CONSTRAINT [PK_Global] PRIMARY KEY CLUSTERED ([Name])
);
GO

CREATE TABLE [dbo].[Godown] (
    [GCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Location] varchar(60) NULL,
    [GodownGroupCode] smallint NOT NULL CONSTRAINT [DF_Godown_GodownGroupCode] DEFAULT (1),
    [AutoSatisfyDue] char(1) NOT NULL CONSTRAINT [DF_Godown_AutoSatisfyDue] DEFAULT ('N'),
    [ConsiderStockInPO] char(1) NOT NULL CONSTRAINT [DF_Godown_ConsiderStockInPO] DEFAULT ('Y'),
    [LocalGodownName] nvarchar(255) NULL,
    CONSTRAINT [PK_Godown] PRIMARY KEY CLUSTERED ([GCode]),
    CONSTRAINT [GNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GodownDetail] (
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [CurrQty] numeric(15,4) NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_GodownDeta_Priority_1__10] DEFAULT (10),
    [ManfDate] datetime NULL,
    [Locked] char(1) NOT NULL CONSTRAINT [DF_GodownDetail_Locked] DEFAULT ('N'),
    [LockReasonCode] smallint NOT NULL CONSTRAINT [DF_GodownDetail_LockReasonCode] DEFAULT (1),
    [LastUpdated] datetime NOT NULL CONSTRAINT [DF_GdowonDetail_LastUpdated] DEFAULT (getdate()),
    CONSTRAINT [PK_GodownDetail] PRIMARY KEY CLUSTERED ([GCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[GodownGroup] (
    [GodownGroupCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_GodownGroup_GodownGroupCode] PRIMARY KEY CLUSTERED ([GodownGroupCode]),
    CONSTRAINT [UK_GodownGroup_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GodownItemSetting] (
    [GCode] smallint NOT NULL,
    [Icode] int NOT NULL,
    [ReorderQty] int NOT NULL CONSTRAINT [DF_GodownItemSetting_ReorderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_GodownItemSetting_OptimumQty] DEFAULT (0),
    [Location] varchar(100) NULL,
    CONSTRAINT [PK_GodownItemSetting] PRIMARY KEY CLUSTERED ([GCode], [Icode])
);
GO

CREATE TABLE [dbo].[GoodsCompany] (
    [GCCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [City] varchar(20) NULL,
    [Country] varchar(25) NULL,
    [Phone] varchar(15) NULL,
    [Fax] varchar(20) NULL,
    [des] varchar(20) NULL,
    [Email] varchar(35) NULL,
    CONSTRAINT [PK___7__11] PRIMARY KEY CLUSTERED ([GCCode]),
    CONSTRAINT [GCNameUK] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GPE] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_GPE_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [Pulse] smallint NULL,
    [PulseType] char(1) NULL,
    [BP1] smallint NULL,
    [BP2] smallint NULL,
    [AnkleOedema] char(1) NULL,
    [Pallor] char(1) NULL,
    [Jaundice] char(1) NULL,
    [Clubbing] char(1) NULL,
    [Cyanosis] char(1) NULL,
    [Ascities] char(1) NULL,
    [JVP] char(1) NULL,
    [OTHERS] varchar(255) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_GPE_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_GPE_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[Grade] (
    [GradeCode] smallint IDENTITY(1,1) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [NumericalFactor] numeric(5,2) NOT NULL CONSTRAINT [DF_Grade_NumericalFactor] DEFAULT (0),
    CONSTRAINT [PK_Grade] PRIMARY KEY CLUSTERED ([GradeCode]),
    CONSTRAINT [UK_Grade_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GroupAllowedGodown] (
    [GroupCode] smallint NOT NULL,
    [GCode] smallint NOT NULL,
    [Module] smallint NOT NULL,
    [Priority] smallint NOT NULL,
    CONSTRAINT [PK_GroupAllowedGodown] PRIMARY KEY CLUSTERED ([GroupCode], [GCode], [Module])
);
GO

CREATE TABLE [dbo].[GroupAllowedGroups] (
    [GroupCode] smallint NOT NULL,
    [Module] smallint NOT NULL,
    [AllowedGroupCode] smallint NOT NULL,
    CONSTRAINT [PK_GroupAllowedGroups] PRIMARY KEY CLUSTERED ([GroupCode], [Module], [AllowedGroupCode])
);
GO

CREATE TABLE [dbo].[GroupAllowedHeader] (
    [GroupCode] smallint NOT NULL,
    [HeaderCode] smallint NOT NULL,
    [Module] smallint NOT NULL,
    [Priority] smallint NOT NULL,
    CONSTRAINT [PK_GroupAllowedHeader] PRIMARY KEY CLUSTERED ([GroupCode], [HeaderCode], [Module])
);
GO

CREATE TABLE [dbo].[GroupAllowedPrice] (
    [GroupCode] smallint NOT NULL,
    [Module] smallint NOT NULL,
    [PriceTypeCode] tinyint NOT NULL,
    CONSTRAINT [PK_GroupAllowedPrice] PRIMARY KEY CLUSTERED ([GroupCode], [Module], [PriceTypeCode])
);
GO

CREATE TABLE [dbo].[GroupAllowedRecipient] (
    [GroupCode] smallint NOT NULL,
    [ModuleID] smallint NOT NULL,
    [RecipientCode] smallint NOT NULL,
    [Priority] smallint NOT NULL CONSTRAINT [DF_GroupAllowedRecipient_Priority] DEFAULT (10),
    CONSTRAINT [PK_GroupAllowedRecipient] PRIMARY KEY CLUSTERED ([GroupCode], [ModuleID], [RecipientCode])
);
GO

CREATE TABLE [dbo].[GroupAllowedServiceCategory] (
    [GroupCode] smallint NOT NULL,
    [ServiceCatCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_Status_GroupAllowedServiceCategory] DEFAULT (0),
    CONSTRAINT [PK_GroupAllowedServiceCategory] PRIMARY KEY CLUSTERED ([GroupCode], [ServiceCatCode])
);
GO

CREATE TABLE [dbo].[GroupAllowedStartupRight] (
    [GroupCode] smallint NOT NULL,
    [RightCode] smallint NOT NULL,
    [Details] varchar(100) NULL,
    [Arguments] text NULL,
    CONSTRAINT [PK_GroupAllowedStartupRight] PRIMARY KEY CLUSTERED ([GroupCode], [RightCode])
);
GO

CREATE TABLE [dbo].[GroupCashAccount] (
    [GroupCode] smallint NOT NULL,
    [ModuleID] smallint NOT NULL,
    [CashAccCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_GroupCashAccount] PRIMARY KEY CLUSTERED ([GroupCode], [ModuleID], [CashAccCode])
);
GO

CREATE TABLE [dbo].[GroupPurExpTemplate] (
    [GroupCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_GroupPurExpTemplate] PRIMARY KEY CLUSTERED ([GroupCode], [AccCode])
);
GO

CREATE TABLE [dbo].[GroupRights] (
    [GroupCode] smallint NOT NULL,
    [RightCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_GroupRight_Status_6__11] DEFAULT (1),
    CONSTRAINT [PK___5__11] PRIMARY KEY CLUSTERED ([GroupCode], [RightCode])
);
GO

CREATE TABLE [dbo].[Groups] (
    [GroupCode] smallint NOT NULL,
    [GroupName] varchar(60) NOT NULL,
    [Remarks] varchar(100) NULL,
    [saleinvflatdisc] numeric(15,2) NOT NULL CONSTRAINT [DF__groups__saleinvf__2BF46805] DEFAULT (0),
    [saleItemdiscperc] numeric(6,2) NOT NULL CONSTRAINT [DF__groups__saleItem__32A16594] DEFAULT (0),
    [SaleGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_SaleGodownStrategy] DEFAULT (1),
    [SaleReturnGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_SaleReturnGodownStrategy] DEFAULT (1),
    [PurchaseGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_PurchaseGodownStrategy] DEFAULT (1),
    [PurchaseReturnGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_PurchaseReturnGodownStrategy] DEFAULT (1),
    [IssueGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_IssueGodownStrategy] DEFAULT (1),
    [ReceiptGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_ReceiptGodownStrategy] DEFAULT (1),
    [AdjustmentGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_AdjustmentGodownStrategy] DEFAULT (1),
    [TransferSourceGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_TransferSourceGodownStrategy] DEFAULT (1),
    [TransferTargetGodownStrategy] smallint NOT NULL CONSTRAINT [DF_GROUPS_TransferTargetGodownStrategy] DEFAULT (1),
    [DefaultServiceTemplateCode] int NULL,
    [QuotationGodownStrategy] smallint NOT NULL CONSTRAINT [DF_Groups_QuotationGodownStrategy] DEFAULT (1),
    [AutoRefreshItemList] char(1) NOT NULL CONSTRAINT [DF_Groups_AutoRefreshItemList] DEFAULT ('N'),
    [AutoRefreshItemListTime] int NOT NULL CONSTRAINT [DF_Groups_AutoRefreshItemListTime] DEFAULT (0),
    [AccumulatedDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Groups_AccumulatedDiscPerc] DEFAULT (0),
    [AccumDiscPercCaution] numeric(6,2) NOT NULL CONSTRAINT [DF_Groups_AccumDiscPercCaution] DEFAULT (0),
    [ServiceDiscPercLimit] numeric(5,2) NOT NULL CONSTRAINT [DF_Groups_ServiceDiscPercLimit] DEFAULT (100),
    [ServiceDeliveryTime] datetime NULL,
    [MaxServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_Groups_MaxServiceFlatDisc] DEFAULT (0),
    [MaxServiceInvFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_Groups_MaxServiceInvFlatDisc] DEFAULT (0),
    [SaleTypeCode] smallint NULL,
    [ConsiderAllDiscountsOnItem] char(1) NOT NULL CONSTRAINT [DF_Groups_ConsiderAllDiscountsOnItem] DEFAULT ('Y'),
    [SalePriceInItemList] tinyint NOT NULL CONSTRAINT [DF_Groups_SalePriceInItemList] DEFAULT (1),
    CONSTRAINT [PK___1__11] PRIMARY KEY CLUSTERED ([GroupCode])
);
GO

CREATE TABLE [dbo].[GroupSummaryAccount] (
    [GroupSummaryAccCode] int NOT NULL,
    [NAME] varchar(60) NOT NULL,
    CONSTRAINT [PK_GroupSummaryAccount_GroupSummaryAccCode] PRIMARY KEY CLUSTERED ([GroupSummaryAccCode]),
    CONSTRAINT [UK_GroupSummaryAccount_Name] UNIQUE ([NAME])
);
GO

CREATE TABLE [dbo].[GroupSupplierCategory] (
    [GroupCode] smallint NOT NULL,
    [SuppCatCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_GroupSupplierCategory_Status] DEFAULT (1),
    CONSTRAINT [PK_GroupSupplierCategory] PRIMARY KEY CLUSTERED ([GroupCode], [SuppCatCode])
);
GO

CREATE TABLE [dbo].[GroupVoucherCategory] (
    [GroupCode] smallint NOT NULL,
    [VochCatCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_GroupVoucherCategory_Status] DEFAULT (1),
    CONSTRAINT [PK_GroupVoucherCategory] PRIMARY KEY CLUSTERED ([GroupCode], [VochCatCode])
);
GO

CREATE TABLE [dbo].[GroupWiseImpExpTemplate] (
    [GroupCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [ExpenseType] char(1) NOT NULL CONSTRAINT [DF_GroupWiseImpExpTemplate_ExpenseType] DEFAULT ('L'),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_GroupWiseImpExpTemplate] PRIMARY KEY CLUSTERED ([GroupCode], [AccCode])
);
GO

CREATE TABLE [dbo].[GSTRules] (
    [RuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_GSTRules_RuleCode] PRIMARY KEY CLUSTERED ([RuleCode]),
    CONSTRAINT [UK_GSTRules_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_GSTRules_Name] UNIQUE ([RuleCode])
);
GO

CREATE TABLE [dbo].[GSTType] (
    [GSTTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_GSTType_GSTTypeCode] PRIMARY KEY CLUSTERED ([GSTTypeCode]),
    CONSTRAINT [UK_GSTType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GuaranteePerson] (
    [GuaranteePersonCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [FHName] varchar(100) NULL,
    [Address] varchar(300) NULL,
    [Phone] varchar(100) NULL,
    [Mobile] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(200) NULL,
    [Web] varchar(200) NULL,
    [NIC] varchar(30) NULL,
    [DOB] datetime NULL,
    [AgeInYears] tinyint NOT NULL CONSTRAINT [DF_guaranteeperson_AgeInYears] DEFAULT (0),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_guaranteeperson_Gender] DEFAULT ('M'),
    [Education] varchar(200) NULL,
    [Occupation] varchar(200) NULL,
    [MonthlyIncome] numeric(15,2) NOT NULL CONSTRAINT [DF_guaranteeperson_MonthlyIncome] DEFAULT (0),
    [TempAddress1] varchar(200) NULL,
    [TempAddress2] varchar(200) NULL,
    [OffAddress] varchar(300) NULL,
    [OffPhone] varchar(100) NULL,
    [Designation] varchar(100) NULL,
    [JobDuration] varchar(100) NULL,
    CONSTRAINT [PK_GuaranteePerson_GuaranteePersonCode] PRIMARY KEY CLUSTERED ([GuaranteePersonCode]),
    CONSTRAINT [UK_GuaranteePerson_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Guest] (
    [GuestCode] int NOT NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_Guest_Active] DEFAULT ('Y'),
    [Date] datetime NOT NULL CONSTRAINT [DF_Guest_Date] DEFAULT (getdate()),
    [RegNo] varchar(50) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [CustCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Gender] char(1) NOT NULL CONSTRAINT [DF_Guest_Gender] DEFAULT ('M'),
    [NIC] varchar(100) NOT NULL,
    [FHName] varchar(100) NULL,
    [Address] varchar(255) NULL,
    [Mobile] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Profession] varchar(100) NULL,
    [Nationality] varchar(100) NULL,
    [Passport] varchar(100) NULL,
    [Reference] varchar(100) NULL,
    CONSTRAINT [PK_Guest] PRIMARY KEY CLUSTERED ([GuestCode]),
    CONSTRAINT [UK_Guest_RegNo] UNIQUE ([RegNo])
);
GO

CREATE TABLE [dbo].[GuestCheckin] (
    [GuestCheckINCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_GuestCheckIN_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [GuestCode] int NOT NULL,
    [CurrentRoom] smallint NOT NULL,
    [CheckInRoom] smallint NOT NULL,
    [CheckInDate] datetime NOT NULL CONSTRAINT [DF_GuestCheckIN_CheckInDate] DEFAULT (getdate()),
    [CheckInBy] smallint NOT NULL,
    [CheckOut] char(1) NOT NULL CONSTRAINT [DF_GuestCheckIN_CheckOut] DEFAULT ('N'),
    [CheckOutDate] datetime NULL,
    [CheckOutBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [CashAccCode] smallint NOT NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_GuestCheckin_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_GuestCheckin_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_GuestCheckin_CashBack] DEFAULT (0),
    [Companions] varchar(255) NULL,
    [Relation] varchar(100) NULL,
    [ComingFrom] varchar(100) NULL,
    [VisitPurpose] varchar(100) NULL,
    [ArrivalDate] datetime NULL,
    [ArrivalPlace] varchar(100) NULL,
    [DepartureDate] datetime NULL,
    [StayPeriod] int NOT NULL CONSTRAINT [DF_GuestCheckin_StayPeriod] DEFAULT (1),
    [PersonCount] int NOT NULL CONSTRAINT [DF_GuestCheckin_PersonCount] DEFAULT (1),
    [RecurringServiceChargedOn] datetime NULL,
    [ServiceInvCode] int NULL,
    CONSTRAINT [PK_GuestCheckIN] PRIMARY KEY CLUSTERED ([GuestCheckINCode])
);
GO

CREATE TABLE [dbo].[GuestCheckInService] (
    [GuestCheckInCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_GuestCheckInService_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_GuestCheckInService_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_GuestCheckInService_DiscPerc] DEFAULT (0),
    [SManCode] smallint NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_GuestCheckInService_ServiceFlatDisc] DEFAULT (0),
    CONSTRAINT [PK_GuestCheckInService] PRIMARY KEY CLUSTERED ([GuestCheckInCode], [ServiceCode])
);
GO

CREATE TABLE [dbo].[GuestRoom] (
    [GuestRoomCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Capacity] smallint NOT NULL CONSTRAINT [DF_GuestRoom_Capacity] DEFAULT (1),
    [GuestRoomFloorCode] smallint NOT NULL,
    [GuestRoomTypeCode] smallint NOT NULL,
    [GuestRoomStatusCode] smallint NOT NULL,
    [Occupied] char(1) NOT NULL CONSTRAINT [DF_GuestRoom_Occupied] DEFAULT ('N'),
    CONSTRAINT [PK_GuestRoom] PRIMARY KEY CLUSTERED ([GuestRoomCode]),
    CONSTRAINT [UK_GuestRoom_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GuestRoomFloor] (
    [GuestRoomFloorCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_GuestRoomFloor] PRIMARY KEY CLUSTERED ([GuestRoomFloorCode]),
    CONSTRAINT [UK_GuestRoomFloor_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GuestRoomService] (
    [GuestRoomCode] smallint NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_GuestRoomService_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_GuestRoomService_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_GuestRoomService_DiscPerc] DEFAULT (0),
    [SManCode] smallint NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_GuestRoomService_ServiceFlatDisc] DEFAULT (0),
    CONSTRAINT [PK_GuestRoomService] PRIMARY KEY CLUSTERED ([GuestRoomCode], [ServiceCode])
);
GO

CREATE TABLE [dbo].[GuestRoomStatus] (
    [GuestRoomStatusCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_GuestRoomStatus] PRIMARY KEY CLUSTERED ([GuestRoomStatusCode]),
    CONSTRAINT [UK_GuestRoomStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GuestRoomType] (
    [GuestRoomTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_GuestRoomType] PRIMARY KEY CLUSTERED ([GuestRoomTypeCode]),
    CONSTRAINT [UK_GuestRoomType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[GuestTransfer] (
    [GuestTransferCode] int NOT NULL,
    [GuestCheckInCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_GuestTransfer_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [LastRoom] smallint NOT NULL,
    [NewRoom] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_GuestTransfer] PRIMARY KEY CLUSTERED ([GuestTransferCode])
);
GO

CREATE TABLE [dbo].[GYN_US] (
    [PatientCode] int NOT NULL,
    [VisitCode] int NULL,
    [AdmissionCode] int NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_GYN_US_Date] DEFAULT (getdate()),
    [Uterus_Size_L] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_Uterus_Size_L] DEFAULT (0),
    [Uterus_Size_W] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_Uterus_Size_W] DEFAULT (0),
    [Uterus_Size_T] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_Uterus_Size_T] DEFAULT (0),
    [Uterus_Detail] varchar(100) NULL,
    [Uterus_Appearance] char(1) NULL,
    [Uterus_Endometrium] varchar(100) NULL,
    [Uterus_Fibroid] varchar(100) NULL,
    [Uterus_Details] varchar(1000) NULL,
    [RtOv_Size_L] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_RtOv_Size_L] DEFAULT (0),
    [RtOv_Size_W] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_RtOv_Size_W] DEFAULT (0),
    [RtOv_Size_T] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_RtOv_Size_T] DEFAULT (0),
    [RtOv_Size] varchar(100) NULL,
    [RtOv_Appearance] varchar(100) NULL,
    [RtOv_Details] varchar(1000) NULL,
    [LtOv_Size_L] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_LtOv_Size_L] DEFAULT (0),
    [LtOv_Size_W] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_LtOv_Size_W] DEFAULT (0),
    [LtOv_Size_T] numeric(5,2) NULL CONSTRAINT [DF_GYN_US_LtOv_Size_T] DEFAULT (0),
    [LtOv_Size] varchar(100) NULL,
    [LtOv_Appearance] varchar(100) NULL,
    [LtOv_Details] varchar(1000) NULL,
    [POD] varchar(1000) NULL,
    [OTHER] varchar(1000) NULL,
    [Comments] varchar(1000) NULL
);
GO

CREATE TABLE [dbo].[HPC] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_HPC_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [HPC_ChestPain] char(1) NULL,
    [HPC_ChestpainSince] smallint NULL,
    [HPC_ChestPainTimeUnit] char(1) NULL,
    [HPC_ChestPainOnExertion] char(1) NULL,
    [HPC_ChestPainOnExertionSince] smallint NULL,
    [HPC_ChestPainOnExertionTimeUnit] char(1) NULL,
    [HPC_ChestHeavinessTightnessOnExertion] char(1) NULL,
    [HPC_ChestHeavinessTightnessOnExertionSince] smallint NULL,
    [HPC_ChestHeavinessTightnessOnExertionTimeUnit] char(1) NULL,
    [HPC_ChestHeavinessAssWithNausia] char(1) NULL,
    [HPC_ChestHeavinessAssWithVomitting] char(1) NULL,
    [HPC_ChestHeavinessAssWithSweating] char(1) NULL,
    [HPC_ChestHeavinessAssWithPalpitations] char(1) NULL,
    [HPC_ChestHeavinessAssWithSuffocation] char(1) NULL,
    [HPC_ChestHeavinessRadiatedToLeftArm] char(1) NULL,
    [HPC_ChestHeavinessRadiatedToRightArm] char(1) NULL,
    [HPC_ChestHeavinessRadiatedToBack] char(1) NULL,
    [HPC_ChestHeavinessRadiatedToJawNeck] char(1) NULL,
    [HPC_ChestHeavinessRadiatedToEpigastrium] char(1) NULL,
    [HPC_TypicalAnginaFunctionalClass] char(1) NULL,
    [HPC_TypicalAnginaFunctionalClassSince] smallint NULL,
    [HPC_TypicalAnginaFunctionalClassTimeUnit] char(1) NULL,
    [HPC_Type1AnginaFunctionalClass] char(1) NULL,
    [HPC_Type2AnginaFunctionalClass] char(1) NULL,
    [HPC_Type3AnginaFunctionalClass] char(1) NULL,
    [HPC_Type4AnginaFunctionalClass] char(1) NULL,
    [HPC_ShortnessofBreathAtRest] char(1) NULL,
    [HPC_ShortnessofBreathAtRestSince] smallint NULL,
    [HPC_ShortnessofBreathAtRestTimeUnit] char(1) NULL,
    [HPC_ShortnessofBreathOnExertion] char(1) NULL,
    [HPC_ShortnessofBreathOnExertionSince] smallint NULL,
    [HPC_ShortnessofBreathOnExertionTimeUnit] char(1) NULL,
    [HPC_RelievedAtRestIncreaseOnExertion] char(1) NULL,
    [HPC_RelievedAtRestIncreaseOnExertionSince] smallint NULL,
    [HPC_RelievedAtRestIncreaseOnExertionTimeUnit] char(1) NULL,
    [HPC_ShortnessofBreathAssWithNausia] char(1) NULL,
    [HPC_ShortnessofBreathAssWithVomitting] char(1) NULL,
    [HPC_ShortnessofBreathAssWithSweating] char(1) NULL,
    [HPC_ShortnessofBreathAssWithPalpitations] char(1) NULL,
    [HPC_ShortnessofBreathAssWithSuffocation] char(1) NULL,
    [HPC_SyncopeWithHOFall] char(1) NULL,
    [HPC_SyncopeWithHOFallSince] smallint NULL,
    [HPC_SyncopeWithHOFallTimeUnit] char(1) NULL,
    [HPC_SyncopeWithHOFallDetail] varchar(255) NULL,
    [HPC_SyncopeWithNoHOFall] char(1) NULL,
    [HPC_SyncopeWithNoHOFallSince] smallint NULL,
    [HPC_SyncopeWithNoHOFallTimeUnit] char(1) NULL,
    [HPC_SyncopeWithNoHOFallDetail] varchar(255) NULL,
    [HPC_Palpitations] char(1) NULL,
    [HPC_PalpitationsSince] smallint NULL,
    [HPC_PalpitationsTimeUnit] char(1) NULL,
    [HPC_Vertigo] char(1) NULL,
    [HPC_VertigoSince] smallint NULL,
    [HPC_VertigoTimeUnit] char(1) NULL,
    [HPC_Headache] char(1) NULL,
    [HPC_HeadacheSince] smallint NULL,
    [HPC_HeadacheTimeUnit] char(1) NULL,
    [HPC_Faintness] char(1) NULL,
    [HPC_FaintnessSince] smallint NULL,
    [HPC_FaintnessTimeUnit] char(1) NULL,
    [HPC_Dizziness] char(1) NULL,
    [HPC_DizzinessSince] smallint NULL,
    [HPC_DizzinessTimeUnit] char(1) NULL,
    [HPC_PreSyncope] char(1) NULL,
    [HPC_PreSyncopeSince] smallint NULL,
    [HPC_PreSyncopeTimeUnit] char(1) NULL,
    [HPC_Fever] char(1) NULL,
    [HPC_FeverSince] smallint NULL,
    [HPC_FeverTimeUnit] char(1) NULL,
    [HPC_PaininLeftLeg] char(1) NULL,
    [HPC_PaininLeftLegSince] smallint NULL,
    [HPC_PaininLeftLegTimeUnit] char(1) NULL,
    [HPC_PaininRightLeg] char(1) NULL,
    [HPC_PaininRightLegSince] smallint NULL,
    [HPC_PaininRightLegTimeUnit] char(1) NULL,
    [HPC_PaininLeftArm] char(1) NULL,
    [HPC_PaininLeftArmSince] smallint NULL,
    [HPC_PaininLeftArmTimeUnit] char(1) NULL,
    [HPC_PaininRightArm] char(1) NULL,
    [HPC_PaininRightArmSince] smallint NULL,
    [HPC_PaininRightArmTimeUnit] char(1) NULL,
    [HPC_PaininLowerLimb] char(1) NULL,
    [HPC_PaininLowerLimbSince] smallint NULL,
    [HPC_PaininLowerLimbTimeUnit] char(1) NULL,
    [HPC_PaininUpperLimb] char(1) NULL,
    [HPC_PaininUpperLimbSince] smallint NULL,
    [HPC_PaininUpperLimbTimeUnit] char(1) NULL,
    [HPC_PaininAbdomen] char(1) NULL,
    [HPC_PaininAbdomenSince] smallint NULL,
    [HPC_PaininAbdomenTimeUnit] char(1) NULL,
    [HPC_MusculoskeletonPain] char(1) NULL,
    [HPC_MusculoskeletonPainSince] smallint NULL,
    [HPC_MusculoskeletonPainTimeUnit] char(1) NULL,
    [HPC_OtherComplaints] varchar(255) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_HPC_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_HPC_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[IMP_AdvSaleDetail] (
    [ChildServer] varchar(100) NOT NULL,
    [AdvSaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_PackQty] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_DiscPerc] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [ItemFlatDisc] numeric(15,2) NULL CONSTRAINT [DF_IMP_AdvSaleDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NULL CONSTRAINT [DF_IMP_AdvSaleDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(10,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_UnitTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_BonusQty] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_Claimable] DEFAULT ('N'),
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_BonusPackQtyForSale] DEFAULT (0),
    [DescICode] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_AdvSaleDetail_RPPUnitRate] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[IMP_AdvSaleLedger] (
    [ChildServer] varchar(100) NOT NULL,
    [TransDate] datetime NOT NULL,
    [InvType] tinyint NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_InvType] DEFAULT (1),
    [AdvSaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DATE] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_FlatDisc] DEFAULT (0),
    [MiscCHARges] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_MiscCHARges] DEFAULT (0),
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_Posted] DEFAULT ('N'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_PostDate] DEFAULT (getdate()),
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(30) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [OriginalDATE] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [ReprINTingCounter] tinyint NULL,
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_InvGSTPerc] DEFAULT (0),
    [PrINTWaranty] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_PrINTWaranty] DEFAULT ('Y'),
    [PrINTBatch] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_PrINTBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_ItemDiscPercNo] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [BillingDate] datetime NULL,
    [PrINTBalance] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_PrINTBalance] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDATE] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_OutstandingAmt] DEFAULT (0),
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_Balance] DEFAULT (0),
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_DELETED] DEFAULT ('N'),
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [CashAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_CashAmount] DEFAULT (0),
    [CreditAmt1] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_CreditAmt1] DEFAULT (0),
    [Credit1AccCode] smallint NULL,
    [CreditAmt2] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_CreditAmt2] DEFAULT (0),
    [Credit2AccCode] smallint NULL,
    [CreditAmt3] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_CreditAmt3] DEFAULT (0),
    [Credit3AccCode] smallint NULL,
    [RefundAmt] numeric(10,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_RefundAmt] DEFAULT (0),
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_Transmited] DEFAULT ('N'),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_AdvSaleLedger_CashTendered] DEFAULT (0),
    CONSTRAINT [PK_IMP_AdvSaleLedger] PRIMARY KEY CLUSTERED ([ChildServer], [AdvSaleInvCode])
);
GO

CREATE TABLE [dbo].[IMP_CashierWindow] (
    [ChildServer] varchar(100) NOT NULL,
    [SaleInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Amount] numeric(12,2) NOT NULL,
    [RowID] int NOT NULL
);
GO

CREATE TABLE [dbo].[IMP_MasterCashWin] (
    [ChildServer] varchar(100) NOT NULL,
    [DocumentCode] int NOT NULL,
    [DocumentType] varchar(2) NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Amount] numeric(15,2) NOT NULL,
    [Remarks] varchar(100) NULL,
    [RowID] int NOT NULL
);
GO

CREATE TABLE [dbo].[IMP_Saledetail] (
    [ChildServer] varchar(100) NOT NULL,
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_IMP_Saledetail_PackQty_4__12] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_IMP_Saledetail_PackUnits_5__12] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_Saledetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_DiscPerc_2__12] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_SalesTax_8__12] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_Saledetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_GSTPerc_1__10] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [df_IMP_Saledetail_claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_IMP_Saledetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_BonusPackQtyForSale] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_RPPUnitRate] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_IMP_Saledetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_IMP_Saledetail_PiecesInHand] DEFAULT (0),
    [PackSalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_Saledetail_PackSalePrice] DEFAULT (0),
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_Saledetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_Saledetail_BatchCost] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SaleDetail_ItemAdvanceTaxPerc] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[IMP_SaleLedger] (
    [ChildServer] varchar(100) NOT NULL,
    [TransDate] datetime NOT NULL,
    [InvType] tinyint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(30) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_IMP_SaleLedger_InvGSTPerc_1__10] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_PrintWaranty] DEFAULT ('Y'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_PrintBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_IMP_SaleLedger_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [itemdiscpercno] tinyint NOT NULL CONSTRAINT [DF_IMP_Saleledger_ItemDiscPercNo] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Returncounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Paid] DEFAULT ('N'),
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_UnReceivedBalance] DEFAULT (0),
    [TotalOfSaleReturns] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_TotalOfReturns] DEFAULT (0),
    [ListOfSrInvoices] varchar(500) NULL,
    [printbalance] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_printbalance] DEFAULT ('Y'),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [deliveredby] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_IMP_SaleLedger_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Balance] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_DELETED] DEFAULT ('N'),
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_ImpactInventory] DEFAULT ('Y'),
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_IMP_SaleLedger_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_ConsiderInPO] DEFAULT ('Y'),
    [VisitCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_IMP_SaleLedger_DueDate] DEFAULT (getdate()),
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_CashBack] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_IMP_SaleLedger_CashAccCode] DEFAULT (2),
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleId] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [CustSiteCode] int NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Transmited] DEFAULT ('N'),
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SaleLedger_FBRPOSFee] DEFAULT (0),
    CONSTRAINT [PK_IMP_SaleLedger] PRIMARY KEY CLUSTERED ([ChildServer], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[IMP_SRDetail] (
    [ChildServer] varchar(100) NOT NULL,
    [SRInvcode] int NOT NULL,
    [Icode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_SRDetail_LooseQty] DEFAULT (0),
    [PackUnits] int NOT NULL CONSTRAINT [DF_IMP_SRDetail_PackUnits] DEFAULT (1),
    [SRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_SRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_SalesTax] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_SRDetail_AvgPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_GSTPerc] DEFAULT (0),
    [SRUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_IMP_SRDetail_BonusQty] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_SalePrice] DEFAULT (0),
    [SaleRowId] int NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [ReturnItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_IMP_SRDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_IMP_SRDetail_PiecesInHand] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IMP_SRDetail_NewAvgPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_IMP_SRDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_ClaimableDiscPerc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SRDetail_ItemAdvanceTaxPerc] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[IMP_SRLedger] (
    [ChildServer] varchar(100) NOT NULL,
    [TransDate] datetime NOT NULL,
    [InvType] tinyint NOT NULL,
    [SRInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [SRCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_MiscCharges] DEFAULT (0),
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Posted] DEFAULT ('Y'),
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [SalesTax] numeric(7,2) NULL CONSTRAINT [DF_IMP_SRLedger_SalesTax] DEFAULT (0),
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [HeaderNo] smallint NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_IMP_SRLedger_InvGSTPerc1] DEFAULT (0),
    [Smancode] smallint NULL,
    [CustRefno] varchar(100) NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [PatientCode] int NULL,
    [MachineName] varchar(20) NULL,
    [HeaderInvNo] int NULL,
    [AdmissionCode] int NULL,
    [invtotal] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Marked] DEFAULT ('N'),
    [PageSize] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_PageSize] DEFAULT ('Q'),
    [ReprintingCounter] tinyint NOT NULL CONSTRAINT [DF_IMP_SRLedger_ReprintingCounter] DEFAULT (0),
    [DoctCode] smallint NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_ConsiderInPO] DEFAULT ('Y'),
    [CashAccCode] smallint NOT NULL CONSTRAINT [FK_IMP_SRLedger_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_CashBack] DEFAULT (0),
    [RetViaBillSummary] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_RetViaBillSummary] DEFAULT ('N'),
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_IMP_SRLedger_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_IMP_SRLedger_ConversionRate] DEFAULT (1),
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_Transmited] DEFAULT ('N'),
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_IMP_SRLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_IMP_SRLedger_FBRPOSFee] DEFAULT (0),
    CONSTRAINT [PK_IMP_SRLedger] PRIMARY KEY CLUSTERED ([ChildServer], [SRInvCode])
);
GO

CREATE TABLE [dbo].[ImpPurDetail] (
    [ImpPurInvCode] int NOT NULL,
    [SuppCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ImpPurDetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ImpPurDetail_LooseQty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ImpPurDetail_BonusQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ImpPurDetail_PackUnits] DEFAULT (1),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_ForeignPrice] DEFAULT (0),
    [PurPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_PurPrice] DEFAULT (0),
    [PurPrice2] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_PurPrice2] DEFAULT (0),
    [PurPrice3] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_PurPrice3] DEFAULT (0),
    [PurPrice4] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_PurPrice4] DEFAULT (0),
    [ItemFlatDisc] numeric(8,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_ItemFlatDisc] DEFAULT (0),
    [ItemFlatDisc2] numeric(8,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_ItemFlatDisc2] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_DiscPerc] DEFAULT (0),
    [DiscPerc2] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_DiscPerc2] DEFAULT (0),
    [UnitTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitTaxRuleCode] DEFAULT (1),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitSalesTax] DEFAULT (0),
    [GSTRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_GSTRuleCode] DEFAULT (1),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_GSTPerc] DEFAULT (0),
    [PurRowId] int IDENTITY(1,1) NOT NULL,
    [SalePrice] numeric(15,2) NOT NULL,
    [Rate] numeric(15,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_Rate] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_AvgPrice] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_NetRate] DEFAULT (0),
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_ImpPurDetail_CurrStock] DEFAULT (0),
    [PurUtn] bigint NULL,
    [ItemDescription] varchar(100) NULL,
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_SalePriceForItem] DEFAULT (0),
    [ItemFlatDiscAfterDiscperc] numeric(8,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_ItemFlatDiscAfterDiscperc] DEFAULT (0),
    [ValueDiscOnItem] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_ValueDiscOnItem] DEFAULT (0),
    [MeasureUnitCode] smallint NOT NULL CONSTRAINT [DF_ImpPurDetail_MeasureUnitCode] DEFAULT (1),
    [MeasureQty] numeric(9,4) NOT NULL CONSTRAINT [DF_ImpPurDetail_MeasureQty] DEFAULT (1),
    [MeasureUnitRate] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_MeasureUnitRate] DEFAULT (1),
    [GSTTYpeCode] smallint NOT NULL CONSTRAINT [DF_ImpPurDetail_GSTTYpeCode] DEFAULT (1),
    [RetailPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurDetail_RetailPrice] DEFAULT (0),
    [UnitIncomeTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitIncomeTaxRuleCode] DEFAULT (4),
    [UnitIncomeTax] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitIncomeTax] DEFAULT (0),
    [PercIncomeTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_PercIncomeTaxRuleCode] DEFAULT (4),
    [PercIncomeTax] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_PercIncomeTax] DEFAULT (0),
    [UnitAdditionalTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitAdditionalTaxRuleCode] DEFAULT (4),
    [UnitAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitAdditionalTax] DEFAULT (0),
    [PercAdditionalTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_PercAdditionalTaxRuleCode] DEFAULT (4),
    [PercAdditionalTax] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_PercAdditionalTax] DEFAULT (0),
    [UnitExtraTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitExtraTaxRuleCode] DEFAULT (4),
    [UnitExtraTax] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitExtraTax] DEFAULT (0),
    [PercExtraTaxRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_PercExtraTaxRuleCode] DEFAULT (4),
    [PercExtraTax] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_PercExtraTax] DEFAULT (0),
    [UnitCustomDutyRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitCustomDutyRuleCode] DEFAULT (4),
    [UnitCustomDuty] numeric(10,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_UnitCustomDuty] DEFAULT (0),
    [PercCustomDutyRuleCode] tinyint NOT NULL CONSTRAINT [DF_ImpPurDetail_PercCustomDutyRuleCode] DEFAULT (4),
    [PercCustomDuty] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_PercCustomDuty] DEFAULT (0),
    [ProfitPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_ProfitPerc] DEFAULT (0),
    [NetDiscountedRate] numeric(12,2) NOT NULL CONSTRAINT [DF_ImpPurDetail_NetDiscountedRate] DEFAULT (0),
    CONSTRAINT [PK_ImpPurDetail] PRIMARY KEY CLUSTERED ([ImpPurInvCode], [SuppCode], [Gcode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[ImpPurExp] (
    [ImpPurInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [ExpenseType] char(1) NOT NULL CONSTRAINT [DF_ImpPurExp_ExpenseType] DEFAULT ('L'),
    [ForeignAmt] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurExp_ForeignAmt] DEFAULT (0),
    [LocalAmt] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurExp_LocalAmt] DEFAULT (0),
    CONSTRAINT [PK_ImpPurExp] PRIMARY KEY CLUSTERED ([ImpPurInvCode], [AccCode])
);
GO

CREATE TABLE [dbo].[ImpPurHeader] (
    [ImpPurInvCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ImpPurHeader_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_ImpPurHeader_HeaderNo] DEFAULT (1),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_ImpPurHeader_CurrencyCode] DEFAULT (1),
    [ConversionFactor] numeric(11,5) NULL CONSTRAINT [DF_ImpPurHeader_ConversionFactor] DEFAULT (1),
    [Container] varchar(60) NULL,
    [RefNo1] varchar(60) NULL,
    [RefNo2] varchar(60) NULL,
    [RefNo3] varchar(60) NULL,
    [RefNo4] varchar(60) NULL,
    [Remarks] varchar(100) NULL,
    [ForeignAmt] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurHeader_ForeignAmt] DEFAULT (0),
    [InvTotal] numeric(15,5) NOT NULL CONSTRAINT [DF_ImpPurHeader_InvTotal] DEFAULT (0),
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_ImpPurHeader_Finalized] DEFAULT ('N'),
    [FinalizedBy] smallint NULL,
    [FinalizedDate] datetime NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ImpPurHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostedDate] datetime NULL,
    [GLVochCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ImpPurHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_ImpPurHeader] PRIMARY KEY CLUSTERED ([ImpPurInvCode])
);
GO

CREATE TABLE [dbo].[IncentiveSheet] (
    [IncentiveDocCode] int NOT NULL,
    [DrAccCode] smallint NOT NULL,
    [CrAccCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_IncentiveSheet_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_IncentiveSheet_Posted] DEFAULT ('Y'),
    [PostDate] datetime NULL,
    [GLVochCode] int NULL,
    [StartDate] datetime NULL,
    [EndDate] datetime NULL,
    [Remarks] varchar(100) NULL,
    [PostedBY] smallint NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_IncentiveSheet_Amount] DEFAULT (0),
    CONSTRAINT [PK_IncentiveSheet_IncentiveDocCode] PRIMARY KEY CLUSTERED ([IncentiveDocCode])
);
GO

CREATE TABLE [dbo].[IncentiveSheetDetail] (
    [IncentiveDocCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_IncentiveSheetDetail_Qty] DEFAULT (0),
    [IncentiveRate] numeric(12,2) NOT NULL CONSTRAINT [DF_IncentiveSheetDetail_IncentiveRate] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_IncentiveSheetDetail] PRIMARY KEY CLUSTERED ([IncentiveDocCode], [RowID])
);
GO

CREATE TABLE [dbo].[IncomeTaxRule] (
    [IncomeTaxRuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_IncomeTaxRule_IncomeTaxRuleCode] PRIMARY KEY CLUSTERED ([IncomeTaxRuleCode]),
    CONSTRAINT [UK_IncomeTaxRule_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_IncomeTaxRule_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[InstallmentDetail] (
    [InstallmentCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_InstallmentDetail_Date] DEFAULT (getdate()),
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_Amount] DEFAULT (0),
    [AmtReceived] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_AmtReceived] DEFAULT (0),
    [Discount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_Discount] DEFAULT (0),
    [Fine] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_Fine] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Cancelled] char(1) NOT NULL CONSTRAINT [DF_InstallmentDetail_Cancelled] DEFAULT ('N'),
    [CancelledOn] datetime NULL,
    [CancelledBy] smallint NULL,
    CONSTRAINT [PK_InstallmentDetail] PRIMARY KEY CLUSTERED ([InstallmentCode], [Date])
);
GO

CREATE TABLE [dbo].[InstallmentGuarantor] (
    [InstallmentCode] int NOT NULL,
    [GuaranteePersonCode] smallint NOT NULL,
    CONSTRAINT [PK_InstallmentGuarantor] PRIMARY KEY CLUSTERED ([InstallmentCode], [GuaranteePersonCode])
);
GO

CREATE TABLE [dbo].[InstallmentHeader] (
    [InstallmentCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_InstallmentHeader_Date] DEFAULT (getdate()),
    [CustCode] smallint NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_InstallmentHeader_PackUnits] DEFAULT (1),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_InstallmentHeader_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_SalePrice] DEFAULT (0),
    [ItemFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_ItemFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_DiscPerc] DEFAULT (0),
    [MarkupAmt] numeric(10,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_MarkupAmt] DEFAULT (0),
    [ProcessingFee] numeric(10,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_ProcessingFee] DEFAULT (0),
    [DownPayment] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentHeader_DownPayment] DEFAULT (0),
    [InstallmentFrequency] smallint NOT NULL CONSTRAINT [DF_InstallmentHeader_InstallmentFrequency] DEFAULT (1),
    [NoOfInstallments] int NOT NULL CONSTRAINT [DF_InstallmentHeader_NoOfInstallments] DEFAULT (1),
    [FirstDueDate] datetime NOT NULL CONSTRAINT [DF_InstallmentHeader_FirstDueDate] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(255) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_InstallmentHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [SaleInvCode] int NULL,
    [Approved] char(1) NOT NULL CONSTRAINT [DF_InstallmentHeader_Approved] DEFAULT ('N'),
    [ApprovedBy] smallint NULL,
    [ApprovedOn] datetime NULL,
    [SManCode] smallint NULL,
    [InquiryPersonCode] smallint NULL,
    [Rejected] char(1) NOT NULL CONSTRAINT [DF_InstallmentHeader_Rejected] DEFAULT ('N'),
    [RejectedBy] smallint NULL,
    [RejectedOn] datetime NULL,
    [ModifiedBy] smallint NULL,
    [ModifyCount] smallint NULL,
    CONSTRAINT [PK_InstallmentHeader] PRIMARY KEY CLUSTERED ([InstallmentCode])
);
GO

CREATE TABLE [dbo].[InstallmentReceipt] (
    [ReceiptCode] int NOT NULL,
    [DATE] datetime NOT NULL CONSTRAINT [DF_InstallmentReceipt_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [SaleInvCode] int NOT NULL,
    [NetAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_NetAmt] DEFAULT (0),
    [OutstandingAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_OutstandingAmt] DEFAULT (0),
    [InstallmentRowID] int NOT NULL,
    [InstallmentAmount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_InstallmentAmount] DEFAULT (0),
    [InstallmentBalance] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_InstallmentBalance] DEFAULT (0),
    [AmtReceived] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_AmtReceived] DEFAULT (0),
    [Discount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_Discount] DEFAULT (0),
    [Fine] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceipt_Fine] DEFAULT (0),
    [GLVochCode] int NULL,
    [GLVochCodeDisount] int NULL,
    [GLVochCodeFine] int NULL,
    [Remarks] varchar(100) NULL,
    [RecoveryPersonCode] smallint NULL,
    CONSTRAINT [PK_InstallmentReceipt] PRIMARY KEY CLUSTERED ([ReceiptCode])
);
GO

CREATE TABLE [dbo].[InstallmentReceiptDetail] (
    [ReceiptCode] int NOT NULL,
    [InstallmentRowID] int NOT NULL,
    [InstallmentAmount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_InstallmentAmount] DEFAULT (0),
    [InstallmentBalance] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_InstallmentBalance] DEFAULT (0),
    [AmtReceived] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_AmtReceived] DEFAULT (0),
    [Discount] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_Discount] DEFAULT (0),
    [Fine] numeric(12,2) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_Fine] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [ReceivedOn] datetime NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_ReceivedOn] DEFAULT (getdate()),
    [ReceivedAccCode] smallint NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_ReceivedAccCode] DEFAULT (2),
    [PaymentMode] char(1) NOT NULL CONSTRAINT [DF_InstallmentReceiptDetail_PaymentMode] DEFAULT ('C'),
    [RefNo] varchar(20) NULL,
    [GlVochCode] int NULL,
    [GlVochCodeDiscount] int NULL,
    [GlVochCodeFine] int NULL,
    CONSTRAINT [PK_InstallmentReceiptDetail] PRIMARY KEY CLUSTERED ([ReceiptCode], [InstallmentRowID])
);
GO

CREATE TABLE [dbo].[InstallmentSecurity] (
    [InstallmentCode] int NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Bank] varchar(100) NULL,
    [Branch] varchar(100) NULL,
    [ChequeNo] varchar(100) NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_InstallmentSecurity_Amount] DEFAULT (0),
    [Remarks] varchar(1000) NULL,
    CONSTRAINT [PK_InstallmentSecurity] PRIMARY KEY CLUSTERED ([InstallmentCode], [RowID])
);
GO

CREATE TABLE [dbo].[Instruction] (
    [InsCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [LocalInstruction] nvarchar(255) NULL,
    CONSTRAINT [PK_Instruction] PRIMARY KEY CLUSTERED ([InsCode]),
    CONSTRAINT [UQ_Instruction] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[InterfaceSetting] (
    [ModuleId] smallint NOT NULL,
    [sequenceid] int NOT NULL,
    [colname] varchar(100) NOT NULL,
    [colcaption] varchar(100) NOT NULL,
    [visibility] tinyint NOT NULL,
    [WinType] smallint NOT NULL,
    [InterfaceGroup] smallint NOT NULL CONSTRAINT [DF_InterfaceSetting_InterfaceGroup] DEFAULT (0),
    CONSTRAINT [Pk_InterfaceSetting] PRIMARY KEY CLUSTERED ([ModuleId], [colname], [WinType])
);
GO

CREATE TABLE [dbo].[IntimationType] (
    [IntimationTypeCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_IntimationType_Counter] DEFAULT (0),
    CONSTRAINT [PK_IntimationType_IntimationTypeCode] PRIMARY KEY CLUSTERED ([IntimationTypeCode]),
    CONSTRAINT [UK_IntimationType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[InvDetail] (
    [InvVochCode] int NOT NULL,
    [AccCode] smallint NULL,
    [InvCode] int NULL,
    [Debit] numeric(11,2) NOT NULL,
    [Credit] numeric(11,2) NOT NULL,
    [ChkNo] varchar(20) NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_InvDetail_1__13] PRIMARY KEY CLUSTERED ([RowId])
);
GO

CREATE TABLE [dbo].[InvLedger] (
    [InvVochCode] int NOT NULL,
    [InvVochCatCode] smallint NOT NULL,
    [AccCode] smallint NULL,
    [Date] datetime NOT NULL,
    [salesmancode] smallint NOT NULL,
    [Posted] char(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NOT NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    CONSTRAINT [PK_InvLedger_1__13] PRIMARY KEY CLUSTERED ([InvVochCode])
);
GO

CREATE TABLE [dbo].[IOLPower] (
    [IOLPowerCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_IOLPower_IOLPowerCode] PRIMARY KEY CLUSTERED ([IOLPowerCode]),
    CONSTRAINT [UK_IOLPower_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[IssueCategory] (
    [IssueCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [Description] varchar(255) NULL,
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_IssueCategory_AccountFor] DEFAULT ('Y'),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_IssueCategory_Posted] DEFAULT ('N'),
    [Counter] int NOT NULL CONSTRAINT [DF_IssueCategory_Counter] DEFAULT (0),
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_IssueCategory_Enabled] DEFAULT ('Y'),
    CONSTRAINT [PK_IssueCategory] PRIMARY KEY CLUSTERED ([IssueCategoryCode]),
    CONSTRAINT [UK_IssueCategory_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_IssueCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[IssueCategoryAccounts] (
    [IssueCategoryCode] smallint NOT NULL,
    [SubAccCode] smallint NOT NULL,
    CONSTRAINT [PK_IssueCategoryAccounts] PRIMARY KEY CLUSTERED ([IssueCategoryCode], [SubAccCode])
);
GO

CREATE TABLE [dbo].[IssueDetail] (
    [IssueInvCode] int NOT NULL,
    [Icode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Gcode] smallint NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_IssueDetai_Priority_4__13] DEFAULT (10),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_IssueDetail_Qty] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IssueDetail_SalePrice] DEFAULT (0),
    [PurchasePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IssueDetail_PurchasePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IssueDetail_AvgPrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_IssueDetai_PackUnits_3__15] DEFAULT (1),
    [MRPP] numeric(12,2) NOT NULL CONSTRAINT [DF_IssueDetail_MRPP] DEFAULT (0),
    [IssRowId] int IDENTITY(1,1) NOT NULL,
    [IssueUtn] bigint NULL,
    [SectCode] smallint NULL,
    [Price] numeric(15,5) NOT NULL CONSTRAINT [DF_IssueDetail_Price] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [itemdescription] varchar(100) NULL,
    [RowGroup] int NOT NULL CONSTRAINT [DF_IssueDetail_RowGroup] DEFAULT (1),
    [IssueReqRowID] int NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_IssueDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_IssueDetail_PiecesInHand] DEFAULT (0),
    [ServiceIssueReqRowID] int NULL,
    [ServiceRowID] int NULL,
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_IssueDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IssueDetail_ClaimableDiscPerc] DEFAULT (0),
    [ReceiptRowID] int NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_IssueDetail_BalanceStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[IssueHeader] (
    [IssueInvCode] int NOT NULL,
    [DeptCode] smallint NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Deleted] char(1) NULL,
    [DeletedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_IssueHeade_Posted_1__13] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [SmanCode] smallint NULL,
    [AreaCode] smallint NOT NULL CONSTRAINT [DF_IssueHeader_AreaCode] DEFAULT (1),
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [IssueTypeCode] smallint NULL,
    [ReferenceNo] char(50) NULL,
    [ReferenceDate] datetime NULL,
    [PriceTypeCode] tinyint NOT NULL CONSTRAINT [DF_IssueHeader_PriceType] DEFAULT (1),
    [RecipientCode] smallint NOT NULL CONSTRAINT [DF_Recipient_RecipientCode] DEFAULT (1),
    [AccCode] smallint NULL,
    [RecipientSalesMan] smallint NULL,
    [Terms1] varchar(100) NULL,
    [Terms2] varchar(100) NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_IssueHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [PatientCode] int NULL,
    [CustSiteCode] int NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [OrderDate] datetime NULL,
    [ServiceOCode] int NULL,
    [WorkOrderCode] int NULL,
    [ServiceIssueRequestCode] int NULL,
    [ServiceInvCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_IssueHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [ReceiptInvCode] int NULL,
    [IssueCategoryCode] smallint NOT NULL CONSTRAINT [DF_IssueHeader_IssueCategoryCode] DEFAULT (1),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_IssueHeader_AccountFor] DEFAULT ('N'),
    [DrAccCode] smallint NULL,
    [IssueCode] int NOT NULL CONSTRAINT [DF_IssueHeader_IssueCode] DEFAULT (0),
    [PrintWarranty] char(1) NOT NULL CONSTRAINT [DF_IssueHeader_PrintWarranty] DEFAULT ('N'),
    [QuotationCode] int NULL,
    [MotorVehicleCode] int NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_IssueHeader_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_IssueHeader_2__13] PRIMARY KEY CLUSTERED ([IssueInvCode]),
    CONSTRAINT [CK_IssueHeader] CHECK ([DeptCode] is not null or [AccCode] is not null or [RecipientSalesMan] is not null)
);
GO

CREATE TABLE [dbo].[IssueReqDetail] (
    [IssueReqInvCode] int NOT NULL,
    [Icode] int NOT NULL,
    [Qty] int NOT NULL CONSTRAINT [DF_IssueReqDetail_Qty] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IssueReqDetail_SalePrice] DEFAULT (0),
    [PurchasePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_IssueReqDetail_PurchasePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_IssueReqDetail_AvgPrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_IssueReqDetail_PackUnits] DEFAULT (1),
    [IssueReqRowId] int IDENTITY(1,1) NOT NULL,
    [SectCode] smallint NULL,
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_IssueReqDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_IssueReqDetail_ClaimableDiscPerc] DEFAULT (0),
    CONSTRAINT [PK_IssueReqDetail] PRIMARY KEY CLUSTERED ([IssueReqInvCode], [Icode])
);
GO

CREATE TABLE [dbo].[IssueReqHeader] (
    [IssueReqInvCode] int NOT NULL,
    [DeptCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_IssueReqHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [SmanCode] smallint NULL,
    [AreaCode] smallint NOT NULL CONSTRAINT [DF_IssueReqHeader_AreaCode] DEFAULT (1),
    [AccCode] smallint NULL,
    [ServiceOCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_IssueReqHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_IssueReqHeader_IssueReqInvCode] PRIMARY KEY CLUSTERED ([IssueReqInvCode])
);
GO

CREATE TABLE [dbo].[IssueType] (
    [IssueTypeCode] smallint NOT NULL,
    [Name] varchar(200) NOT NULL,
    CONSTRAINT [PK_IssueType] PRIMARY KEY CLUSTERED ([IssueTypeCode]),
    CONSTRAINT [UK_IssueType_name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Item] (
    [ICode] int NOT NULL,
    [CustomICode] varchar(75) NULL,
    [Name] varchar(60) NOT NULL,
    [ICCode] smallint NOT NULL CONSTRAINT [DF_ITEM_ICCode] DEFAULT (1),
    [ICatCode] smallint NOT NULL CONSTRAINT [DF_ITEM_ICatCode] DEFAULT (1),
    [Packcode] smallint NOT NULL CONSTRAINT [DF_ITEM_PackCode] DEFAULT (1),
    [ManfCode] smallint NOT NULL CONSTRAINT [DF_ITEM_Manfcode] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_SalePrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_PurPrice] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_RetailPrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_Item_AvgPrice] DEFAULT (0),
    [SaleDiscPerc] numeric(5,2) NOT NULL,
    [PurDiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [ReorderQty] int NOT NULL,
    [OptimumQty] int NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Active] tinyint NOT NULL CONSTRAINT [DF_Item_Active_1__10] DEFAULT (1),
    [Prescribed] tinyint NOT NULL CONSTRAINT [DF_Item_Prescribed_2__10] DEFAULT (0),
    [Refrigrated] tinyint NOT NULL CONSTRAINT [DF_Item_Refrigrated_4__10] DEFAULT (0),
    [Printable] tinyint NOT NULL CONSTRAINT [DF_Item_Printable_3__10] DEFAULT (1),
    [Location1] varchar(100) NOT NULL CONSTRAINT [DF_Item_Location1_1__10] DEFAULT ('No'),
    [Remarks1] varchar(100) NOT NULL CONSTRAINT [DF_Item_Remarks1_2__10] DEFAULT ('No'),
    [Location] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [Gcode] int NULL,
    [ReorderLevel] int NULL,
    [OptimumLevel] int NULL,
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_RecentPurPrice] DEFAULT (0),
    [SalePrice2] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_SalePrice2] DEFAULT (0),
    [SalePrice3] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_SalePrice3] DEFAULT (0),
    [GReorderQty] int NULL,
    [GOptimumQty] int NULL,
    [AntiNorCotix] char(1) NULL CONSTRAINT [DF_Item_AntiNorCotix_1__11] DEFAULT ('N'),
    [Restricted] char(1) NULL CONSTRAINT [DF_Item_Restricted_1__10] DEFAULT ('N'),
    [GSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_Item_GSTPerc1_1__10] DEFAULT (0),
    [GSTPerc2] numeric(6,2) NULL CONSTRAINT [DF_Item_GSTPerc2_2__10] DEFAULT (0),
    [PackSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_PackSalesTax] DEFAULT (0),
    [PackingDesc] varchar(50) NULL,
    [SaleQty] int NOT NULL CONSTRAINT [DF_Item_SaleQty] DEFAULT (0),
    [BonusQty] int NOT NULL CONSTRAINT [DF_Item_BonusQty] DEFAULT (0),
    [PrintExpiry] char(1) NOT NULL CONSTRAINT [DF_Item_PrintExpiry] DEFAULT ('Y'),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_Item_UserCode] DEFAULT (1),
    [LastUpdate] datetime NOT NULL CONSTRAINT [DF_Item_LastUpdate] DEFAULT (getdate()),
    [FlatDisc] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_FlatDisc] DEFAULT (0),
    [LockSalePrice] char(1) NOT NULL CONSTRAINT [DF_Item_LockSalePrice] DEFAULT ('N'),
    [LockDiscPerc] char(1) NOT NULL CONSTRAINT [DF_Item_LockDiscPerc] DEFAULT ('N'),
    [PackingCost] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_PackingCost] DEFAULT (0),
    [RecentPurPrice2] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_RecentPurPrice2] DEFAULT (0),
    [RecentPurPrice3] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_RecentPurPrice3] DEFAULT (0),
    [RecentPurPrice4] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_RecentPurPrice4] DEFAULT (0),
    [RecentPurPrice5] numeric(15,2) NOT NULL CONSTRAINT [DF_Item_RecentPurPrice5] DEFAULT (0),
    [SaleDiscPerc2] numeric(5,2) NULL CONSTRAINT [DF__Item__SaleDiscPe__263B8EAF] DEFAULT (0),
    [SaleDiscPerc3] numeric(5,2) NULL CONSTRAINT [DF__Item__SaleDiscPe__272FB2E8] DEFAULT (0),
    [SaleDiscPerc4] numeric(5,2) NULL CONSTRAINT [DF__Item__SaleDiscPe__2823D721] DEFAULT (0),
    [ISizeCode] smallint NOT NULL CONSTRAINT [DF_Item_ISizeCode] DEFAULT (1),
    [IStyleCode] smallint NOT NULL CONSTRAINT [DF_Item_IStyleCode] DEFAULT (1),
    [IColourCode] smallint NOT NULL CONSTRAINT [DF_Item_IColourCode] DEFAULT (1),
    [ISleeveCode] smallint NOT NULL CONSTRAINT [DF_Item_ISleeveCode] DEFAULT (1),
    [IYarnCode] smallint NOT NULL CONSTRAINT [DF_Item_IYarnCode] DEFAULT (1),
    [IFabricCode] smallint NOT NULL CONSTRAINT [DF_Item_IFabricCode] DEFAULT (1),
    [IBrandCode] smallint NOT NULL CONSTRAINT [DF_Item_IBrandCode] DEFAULT (1),
    [SalePrice4] numeric(15,2) NOT NULL CONSTRAINT [df_Item_SalePrice4] DEFAULT (0),
    [SalePrice5] numeric(15,2) NOT NULL CONSTRAINT [df_Item_SalePrice5] DEFAULT (0),
    [SaleDiscPerc5] numeric(5,2) NULL CONSTRAINT [df_Item_salediscperc5] DEFAULT (0),
    [MinQty] int NOT NULL CONSTRAINT [DF_Item_MinQty] DEFAULT (0),
    [IPartCode] int NOT NULL CONSTRAINT [DF_ITEM_IPartCode] DEFAULT (1),
    [OldPartCode] int NULL,
    [ItemYear] varchar(15) NULL,
    [RemarksForPurchase] varchar(100) NULL,
    [SizeDescription] varchar(100) NULL,
    [ModelDescription] varchar(100) NULL,
    [TypeDescription] varchar(100) NULL,
    [GenericCode] int NOT NULL CONSTRAINT [DF_item_GenericCode] DEFAULT (1),
    [TransitStock] numeric(15,4) NOT NULL CONSTRAINT [DF_Item_TransitStock] DEFAULT (0),
    [PackingFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_PackingFactor_Item] DEFAULT (1),
    [ItemTypeCode] int NOT NULL CONSTRAINT [DF_ItemType_Item] DEFAULT (1),
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_DiscountedSalePrice] DEFAULT (0),
    [DiscountedPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_DiscountedPurPrice] DEFAULT (0),
    [SalePriceChangeMargin] numeric(5,2) NOT NULL CONSTRAINT [DF_ITEM_SalePriceChangeMargin] DEFAULT (0),
    [GeneratePO] char(1) NOT NULL CONSTRAINT [DF_Item_GeneratePO] DEFAULT ('Y'),
    [QtyUsed] int NOT NULL CONSTRAINT [DF_Item_QtyUsed] DEFAULT (0),
    [MeasureUnitCode] smallint NOT NULL CONSTRAINT [DF_Item_MeasureUnitCode] DEFAULT (1),
    [MaxSaleDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Item_MaxSaleDiscPerc] DEFAULT (100.00),
    [BonusPolicyCode] smallint NULL,
    [DiscountPolicyCode] smallint NULL,
    [ItemDesignCode] int NOT NULL CONSTRAINT [DF_Item_ItemDesignCode] DEFAULT (1),
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_Item_UnitWeight] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_Item_TotalPieces] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_AlternatePurPrice] DEFAULT (0),
    [PurFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_Item_PurFlatDisc] DEFAULT (0),
    [ItemAlertCode] smallint NOT NULL CONSTRAINT [DF_Item_ItemAlterCode] DEFAULT (1),
    [MinSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_MinSalePrice] DEFAULT (0),
    [Taxable] char(1) NOT NULL CONSTRAINT [DF_Item_Taxable] DEFAULT ('N'),
    [ForcePatientDoctorRecordInSale] char(1) NOT NULL CONSTRAINT [DF_Item_ForcePatientDoctorRecordInSale] DEFAULT ('N'),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_Item_ForeignPrice] DEFAULT (0),
    [CheckUpperSaleQtyLimit] char(1) NOT NULL CONSTRAINT [DF_Item_CheckUpperSaleQtyLimit] DEFAULT ('N'),
    [UpperSaleQtyLimit] int NOT NULL CONSTRAINT [DF_Item_UpperSaleQtyLimit] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_Item_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Item_CommissionPerc] DEFAULT (0),
    [AllowDue] char(1) NOT NULL CONSTRAINT [DF_Item_AllowDue] DEFAULT ('Y'),
    [LocalItemName] nvarchar(255) NULL,
    [ConfirmExpiry] char(1) NOT NULL CONSTRAINT [DF_Item_ConfirmExpiry] DEFAULT ('N'),
    [AllowSaleInDecimalQty] char(1) NOT NULL CONSTRAINT [DF_Item_AllowSaleInDecimalQty] DEFAULT ('N'),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_Item_Length] DEFAULT (1),
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_Item_Width] DEFAULT (1),
    [AreaVolume] numeric(16,8) NOT NULL CONSTRAINT [DF_Item_AreaVolume] DEFAULT (1),
    [Thickness] numeric(12,4) NOT NULL CONSTRAINT [DF_Item_Thickness] DEFAULT (1),
    [Sheets] int NOT NULL CONSTRAINT [DF_Item_Sheets] DEFAULT (1),
    [Ingredients1] varchar(255) NULL,
    [Ingredients2] varchar(255) NULL,
    [ShortName] varchar(100) NULL,
    [LoyaltyItem] char(1) NOT NULL CONSTRAINT [DF_Item_LoyaltyItem] DEFAULT ('Y'),
    [RegdNo] varchar(100) NOT NULL CONSTRAINT [DF_Item_RegdNo] DEFAULT (''),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_Item_Gender] DEFAULT ('M'),
    [Nationality] varchar(100) NULL,
    [BirthDate] datetime NULL,
    [IssueDate] datetime NULL,
    [ExpiryDate] datetime NULL,
    [PrefferedSaleQty] numeric(15,4) NOT NULL CONSTRAINT [DF_Item_PrefferedSaleQty] DEFAULT (1),
    [PackCapacity] numeric(12,4) NOT NULL CONSTRAINT [DF_Item_PackCapacity] DEFAULT (1),
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_Item_OriginalDate] DEFAULT (getdate()),
    [SalesTaxScheduleCode] smallint NOT NULL CONSTRAINT [DF_Item_SalesTaxScheduleCode] DEFAULT (1),
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_Item_HeaderNo] DEFAULT (1),
    [PCTCode] int NOT NULL CONSTRAINT [DF_Item_PCTCode] DEFAULT (1),
    [RedemptionDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Item_RedemptionDiscPerc] DEFAULT (0),
    [ClaimableDiscperc] numeric(5,2) NOT NULL CONSTRAINT [DF_Item_ClaimableDiscperc] DEFAULT (0),
    [PrintItemBatch] char(1) NOT NULL CONSTRAINT [DF_Item_PrintItemBatch] DEFAULT ('Y'),
    [ItemThicknessCode] smallint NOT NULL CONSTRAINT [DF_Item_ItemThicknessCode] DEFAULT (1),
    [ItemThicknessCode2] smallint NULL,
    [ItemColourCode2] smallint NULL,
    [ChangeReason] varchar(100) NULL,
    [Module] varchar(100) NULL,
    [AllowSalePriceBelowAvgPrice] char(1) NOT NULL CONSTRAINT [DF_Item_AllowSalePriceBelowAvgPrice] DEFAULT ('N'),
    CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED ([ICode]),
    CONSTRAINT [UK_Item_RegdNo] UNIQUE ([RegdNo]),
    CONSTRAINT [INameUC] UNIQUE ([Name]),
    CONSTRAINT [ICustomICodeUC] UNIQUE ([CustomICode])
);
GO

CREATE TABLE [dbo].[ItemAlert] (
    [ItemAlertCode] smallint NOT NULL,
    [ItemAlertTypeCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AlertDetail] varchar(255) NOT NULL,
    [BGColor] int NOT NULL CONSTRAINT [DF_ItemAlert_BGColor] DEFAULT (16777215),
    CONSTRAINT [PK_ItemAlert_ItemAlertCode] PRIMARY KEY CLUSTERED ([ItemAlertCode]),
    CONSTRAINT [UK_ItemAlert_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemAlertType] (
    [ItemAlertTypeCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ItemAlertType_ItemAlertTypeCode] PRIMARY KEY CLUSTERED ([ItemAlertTypeCode]),
    CONSTRAINT [UK_ItemAlertType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemAllowedMeter] (
    [ICode] int NOT NULL,
    [ItemMeterCode] smallint NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_ItemAllowedMeter_Priority] DEFAULT (0),
    CONSTRAINT [PK_ItemAllowedMeter] PRIMARY KEY CLUSTERED ([ICode], [ItemMeterCode])
);
GO

CREATE TABLE [dbo].[ItemAssociation] (
    [ICode] int NOT NULL,
    [AssocICode] int NOT NULL,
    CONSTRAINT [PK_ItemAssociation_ICode_AssocIcode] PRIMARY KEY CLUSTERED ([ICode], [AssocICode]),
    CONSTRAINT [CK_ItemAssociation] CHECK ([Icode] <> [AssocIcode])
);
GO

CREATE TABLE [dbo].[ItemAuthor] (
    [ICode] int NOT NULL,
    [AuthorCode] int NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_ItemAuthor_Priority] DEFAULT (1),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ItemAuthor] PRIMARY KEY CLUSTERED ([ICode], [AuthorCode])
);
GO

CREATE TABLE [dbo].[ItemBatches] (
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemBatches_Date] DEFAULT (getdate()),
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_ItemBatches_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_ItemBatches_Expiry] DEFAULT (getdate()),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemBatches_Qty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ItemBatches_PackUnits] DEFAULT (1),
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemBatches_CostPrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemBatches_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemBatches_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemBatches_AvgPrice] DEFAULT (0),
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemBatches_NewAvgPrice] DEFAULT (0),
    [CurrStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemBatches_CurrStock] DEFAULT (1),
    CONSTRAINT [PK_ItemBatches] PRIMARY KEY CLUSTERED ([ICode], [GCode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[ItemBatchPricing] (
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL CONSTRAINT [DF_ItemBatchPricing_Expiry] DEFAULT (getdate()),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemBatchPricing_SalePrice] DEFAULT (0),
    [ArrivedOn] datetime NOT NULL CONSTRAINT [DF_ItemBatchPricing_ArrivedOn] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [LastModified] datetime NULL CONSTRAINT [DF_ItemBatchPricing_LastModified] DEFAULT (getdate()),
    [LastModifiedBy] smallint NULL,
    CONSTRAINT [PK_ItemBatchPricing] PRIMARY KEY CLUSTERED ([ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[ItemBrand] (
    [IBrandCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemBrand] PRIMARY KEY CLUSTERED ([IBrandCode]),
    CONSTRAINT [IX_BrandName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemCategory] (
    [ICatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [NumericalFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemCategory_NumericalFactor] DEFAULT (1),
    [SaleExpiryDays] int NOT NULL CONSTRAINT [DF_ItemCategory_SaleExpiryDays] DEFAULT (90),
    [PurMonthlyCounter] int NOT NULL CONSTRAINT [DF_ItemCategory_PurMonthlyCounter] DEFAULT (0),
    [PurDailyCounter] int NOT NULL CONSTRAINT [DF_ItemCategory_PurDailyCounter] DEFAULT (0),
    [CategorySegmentCode] smallint NOT NULL CONSTRAINT [DF_ItemCategory_CategorySegmentCode] DEFAULT (1),
    CONSTRAINT [PK_ItemCategory] PRIMARY KEY CLUSTERED ([ICatCode]),
    CONSTRAINT [ICATNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemCategoryWiseUpdation] (
    [ICatCode] smallint NOT NULL,
    [UpdatePurPrice] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdatePurPrice] DEFAULT ('N'),
    [UpdateSalePrice] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSalePrice] DEFAULT ('N'),
    [UpdateSalePrice2] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSalePrice2] DEFAULT ('N'),
    [UpdateSalePrice3] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSalePrice3] DEFAULT ('N'),
    [UpdateSalePrice4] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSalePrice4] DEFAULT ('N'),
    [UpdateSalePrice5] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSalePrice5] DEFAULT ('N'),
    [UpdateSaleDiscPerc] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSaleDiscPerc] DEFAULT ('N'),
    [UpdateSaleDiscPerc2] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSaleDiscPerc2] DEFAULT ('N'),
    [UpdateSaleDiscPerc3] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSaleDiscPerc3] DEFAULT ('N'),
    [UpdateSaleDiscPerc4] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSaleDiscPerc4] DEFAULT ('N'),
    [UpdateSaleDiscPerc5] char(1) NOT NULL CONSTRAINT [DF_ItemCategoryWiseUpdation_UpdateSaleDiscPerc5] DEFAULT ('N'),
    CONSTRAINT [PK_ItemCategoryWiseUpdation] PRIMARY KEY CLUSTERED ([ICatCode])
);
GO

CREATE TABLE [dbo].[ItemClass] (
    [ICCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [NumericalFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemClass_NumericalFactor] DEFAULT (1),
    CONSTRAINT [PK_ItemClass] PRIMARY KEY CLUSTERED ([ICCode]),
    CONSTRAINT [ICNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemColour] (
    [IColourCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemColour] PRIMARY KEY CLUSTERED ([IColourCode]),
    CONSTRAINT [IX_ColourName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemConversionDetail] (
    [ItemConversionCode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [PackUnits] int NOT NULL CONSTRAINT [DF_ItemConversionDetail_PackUnits] DEFAULT (1),
    [GodownStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionDetail_GodownStock] DEFAULT (0),
    [TotalStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionDetail_TotalStock] DEFAULT (0),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionDetail_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemConversionDetail_SalePrice] DEFAULT (0),
    [UnitPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemConversionDetail_UnitPrice] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_ItemConversionDetail] PRIMARY KEY CLUSTERED ([ItemConversionCode], [GCode], [ICode])
);
GO

CREATE TABLE [dbo].[ItemConversionEffect] (
    [ItemConversionEffectCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ItemConversionEffect_ItemConversionEffectCode] PRIMARY KEY CLUSTERED ([ItemConversionEffectCode]),
    CONSTRAINT [FK_ItemConversionEffect_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemConversionHeader] (
    [ItemConversionCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemConversionHeader_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ItemConversionHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBY] smallint NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [PackUnits] int NOT NULL CONSTRAINT [DF_ItemConversionHeader_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemConversionHeader_SalePrice] DEFAULT (0),
    [UnitPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemConversionHeader_UnitPrice] DEFAULT (0),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionHeader_Qty] DEFAULT (0),
    [GodownStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionHeader_GodownStock] DEFAULT (0),
    [TotalStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemConversionHeader_TotalStock] DEFAULT (0),
    [ItemConversionEffectCode] tinyint NOT NULL,
    [Remarks] varchar(100) NULL,
    [AdjIncreaseCode] int NULL,
    [AdjDecreaseCode] int NULL,
    [HeaderNo] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ItemConversionHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_ItemConversionHeader_ItemConversionCode] PRIMARY KEY CLUSTERED ([ItemConversionCode])
);
GO

CREATE TABLE [dbo].[ItemCostHistory] (
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemCostHistory_Date] DEFAULT (getdate()),
    [ICode] int NOT NULL,
    [AvgPRice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemCostHistory_AvgPRice] DEFAULT (0),
    CONSTRAINT [PK_ItemCostHistory] PRIMARY KEY CLUSTERED ([Date], [ICode])
);
GO

CREATE TABLE [dbo].[ItemDesign] (
    [ItemDesignCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemDesign_ItemDesignCode] PRIMARY KEY CLUSTERED ([ItemDesignCode]),
    CONSTRAINT [UK_ItemDesign_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemFabric] (
    [IFabricCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemFabric] PRIMARY KEY CLUSTERED ([IFabricCode]),
    CONSTRAINT [IX_FabricName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemGroup] (
    [ItemGroupCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ItemGroup_ItemGroupCode] PRIMARY KEY CLUSTERED ([ItemGroupCode]),
    CONSTRAINT [UK_ItemGroup_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemGroupDetail] (
    [ItemGroupCode] int NOT NULL,
    [ICode] int NOT NULL,
    CONSTRAINT [PK_ItemGroupDetail] PRIMARY KEY CLUSTERED ([ItemGroupCode], [ICode])
);
GO

CREATE TABLE [dbo].[ItemImage] (
    [ICode] int NOT NULL,
    [ImageDescription] varchar(100) NULL,
    [ROWID] int NOT NULL,
    [ItemImage] image NULL,
    [ImageType] varchar(100) NULL,
    CONSTRAINT [PK_ItemImage] PRIMARY KEY CLUSTERED ([ICode], [ROWID])
);
GO

CREATE TABLE [dbo].[ItemInModel] (
    [ICode] int NOT NULL,
    [ModelCode] smallint NOT NULL,
    CONSTRAINT [PK_ItemInModel] PRIMARY KEY CLUSTERED ([ICode], [ModelCode])
);
GO

CREATE TABLE [dbo].[ItemInquiry] (
    [ItemInquiryCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemInquiry_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [MachineName] varchar(30) NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ItemInquiry] PRIMARY KEY CLUSTERED ([ItemInquiryCode])
);
GO

CREATE TABLE [dbo].[ItemInquiryDetail] (
    [ItemInquiryCode] int NOT NULL,
    [ICode] int NULL,
    [UnKnownItemName] varchar(100) NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemInquiry_Qty] DEFAULT (1),
    [TotalStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemInquiry_TotalStock] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    [PendingDue] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemInquiryDetail_PendingDue] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[ItemLog] (
    [ItemRowID] bigint IDENTITY(1,1) NOT NULL,
    [LogDate] datetime NOT NULL CONSTRAINT [DF_ItemLog_LogDate] DEFAULT (getdate()),
    [NewSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_NewSalePrice] DEFAULT (0),
    [Stock] int NOT NULL,
    [ICode] int NOT NULL,
    [CustomICode] varchar(75) NULL,
    [Name] varchar(60) NOT NULL,
    [ICCode] smallint NULL,
    [ICatCode] smallint NULL,
    [Packcode] smallint NULL,
    [ManfCode] smallint NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_SalePrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_PurPrice] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_RetailPrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemLog_AvgPrice] DEFAULT (0),
    [SaleDiscPerc] numeric(5,2) NOT NULL,
    [PurDiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [ReorderQty] int NOT NULL,
    [OptimumQty] int NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Active] tinyint NOT NULL CONSTRAINT [DF_ItemLog_Active_1__10] DEFAULT (1),
    [Prescribed] tinyint NOT NULL CONSTRAINT [DF_ItemLog_Prescribed_2__10] DEFAULT (0),
    [Refrigrated] tinyint NOT NULL CONSTRAINT [DF_ItemLog_Refrigrated_4__10] DEFAULT (0),
    [Printable] tinyint NOT NULL CONSTRAINT [DF_ItemLog_Printable_3__10] DEFAULT (1),
    [Location1] varchar(100) NOT NULL CONSTRAINT [DF_ItemLog_Location1_1__10] DEFAULT ('No'),
    [Remarks1] varchar(100) NOT NULL CONSTRAINT [DF_ItemLog_Remarks1_2__10] DEFAULT ('No'),
    [Location] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [Gcode] int NULL,
    [ReorderLevel] int NULL,
    [OptimumLevel] int NULL,
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_RecentPurPrice] DEFAULT (0),
    [SalePrice2] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_SalePrice2] DEFAULT (0),
    [SalePrice3] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_SalePrice3] DEFAULT (0),
    [GReorderQty] int NULL,
    [GOptimumQty] int NULL,
    [AntiNorCotix] char(1) NULL CONSTRAINT [DF_ItemLog_AntiNorCotix_1__11] DEFAULT ('N'),
    [Restricted] char(1) NULL CONSTRAINT [DF_ItemLog_Restricted_1__10] DEFAULT ('N'),
    [GSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_ItemLog_GSTPerc1_1__10] DEFAULT (0),
    [GSTPerc2] numeric(6,2) NULL CONSTRAINT [DF_ItemLog_GSTPerc2_2__10] DEFAULT (0),
    [PackSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_PackSalesTax] DEFAULT (0),
    [PackingDesc] varchar(50) NULL,
    [SaleQty] int NOT NULL CONSTRAINT [DF_ItemLog_SaleQty] DEFAULT (0),
    [BonusQty] int NOT NULL CONSTRAINT [DF_ItemLog_BonusQty] DEFAULT (0),
    [PrintExpiry] char(1) NOT NULL CONSTRAINT [DF_ItemLog_PrintExpiry] DEFAULT ('Y'),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_UserCode] DEFAULT (1),
    [LastUpdate] datetime NOT NULL CONSTRAINT [DF_ItemLog_LastUpdate] DEFAULT (getdate()),
    [FlatDisc] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_FlatDisc] DEFAULT (0),
    [LockSalePrice] char(1) NOT NULL CONSTRAINT [DF_ItemLog_LockSalePrice] DEFAULT ('N'),
    [LockDiscPerc] char(1) NOT NULL CONSTRAINT [DF_ItemLog_LockDiscPerc] DEFAULT ('N'),
    [PackingCost] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_PackingCost] DEFAULT (0),
    [RecentPurPrice2] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_RecentPurPrice2] DEFAULT (0),
    [RecentPurPrice3] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_RecentPurPrice3] DEFAULT (0),
    [RecentPurPrice4] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_RecentPurPrice4] DEFAULT (0),
    [RecentPurPrice5] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_RecentPurPrice5] DEFAULT (0),
    [SaleDiscPerc2] numeric(5,2) NULL CONSTRAINT [DF__Itemlog__SaleDis__2917FB5A] DEFAULT (0),
    [SaleDiscPerc3] numeric(5,2) NULL CONSTRAINT [DF__Itemlog__SaleDis__2A0C1F93] DEFAULT (0),
    [SaleDiscPerc4] numeric(5,2) NULL CONSTRAINT [DF__Itemlog__SaleDis__2B0043CC] DEFAULT (0),
    [ISizeCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_ISizeCode] DEFAULT (1),
    [IStyleCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_IStyleCode] DEFAULT (1),
    [IColourCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_IColourCode] DEFAULT (1),
    [ISleeveCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_ISleeveCode] DEFAULT (1),
    [IYarnCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_IYarnCode] DEFAULT (1),
    [IFabricCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_IFabricCode] DEFAULT (1),
    [IBrandCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_IBrandCode] DEFAULT (1),
    [SalePrice4] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_SalePrice4] DEFAULT (0),
    [SalePrice5] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemLog_SalePrice5] DEFAULT (0),
    [SaleDiscPerc5] numeric(5,2) NULL CONSTRAINT [DF_ItemLog_SaleDiscPerc5] DEFAULT (0),
    [MinQty] int NOT NULL CONSTRAINT [DF_ItemLog_MinQty] DEFAULT (0),
    [IPartCode] int NOT NULL CONSTRAINT [DF_ITEMLOG_IPartCode] DEFAULT (1),
    [OldPartCode] int NULL,
    [ItemYear] varchar(15) NULL,
    [RemarksForPurchase] varchar(100) NULL,
    [SizeDescription] varchar(100) NULL,
    [ModelDescription] varchar(100) NULL,
    [TypeDescription] varchar(100) NULL,
    [GenericCode] int NOT NULL CONSTRAINT [DF_itemlog_GenericCode] DEFAULT (1),
    [TransitStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemLog_TransitStock] DEFAULT (0),
    [PackingFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_PackingFactor_ItemLog] DEFAULT (1),
    [ItemTypeCode] int NOT NULL CONSTRAINT [DF_ItemType_ItemLog] DEFAULT (1),
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_DiscountedSalePrice] DEFAULT (0),
    [DiscountedPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_DiscountedPurPrice] DEFAULT (0),
    [SalePriceChangeMargin] numeric(5,2) NOT NULL CONSTRAINT [DF_ITEMLOG_SalePriceChangeMargin] DEFAULT (0),
    [GeneratePO] char(1) NOT NULL CONSTRAINT [DF_ItemLog_GeneratePO] DEFAULT ('Y'),
    [QtyUsed] int NOT NULL CONSTRAINT [DF_ItemLog_QtyUsed] DEFAULT (0),
    [MeasureUnitCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_MeasureUnitCode] DEFAULT (1),
    [MaxSaleDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemLog_MaxSaleDiscPerc] DEFAULT (100.00),
    [BonusPolicyCode] smallint NULL,
    [DiscountPolicyCode] smallint NULL,
    [ItemDesignCode] int NOT NULL CONSTRAINT [DF_ItemLog_ItemDesignCode] DEFAULT (1),
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemLog_UnitWeight] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ItemLog_TotalPieces] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_AlternatePurPrice] DEFAULT (0),
    [PurFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ItemLog_PurFlatDisc] DEFAULT (0),
    [ItemAlertCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_ItemAlterCode] DEFAULT (1),
    [MinSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemLog_MinSalePrice] DEFAULT (0),
    [Taxable] char(1) NOT NULL CONSTRAINT [DF_ItemLog_Taxable] DEFAULT ('N'),
    [ForcePatientDoctorRecordInSale] char(1) NOT NULL CONSTRAINT [DF_ItemLog_ForcePatientDoctorRecordInSale] DEFAULT ('N'),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemLog_ForeignPrice] DEFAULT (0),
    [CheckUpperSaleQtyLimit] char(1) NOT NULL CONSTRAINT [DF_ItemLog_CheckUpperSaleQtyLimit] DEFAULT ('N'),
    [UpperSaleQtyLimit] int NOT NULL CONSTRAINT [DF_ItemLog_UpperSaleQtyLimit] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_Itemlog_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Itemlog_CommissionPerc] DEFAULT (0),
    [AllowDue] char(1) NOT NULL CONSTRAINT [DF_ItemLog_AllowDue] DEFAULT ('Y'),
    [LocalItemName] nvarchar(255) NULL,
    [ConfirmExpiry] char(1) NOT NULL CONSTRAINT [DF_ItemLog_ConfirmExpiry] DEFAULT ('N'),
    [AllowSaleInDecimalQty] char(1) NOT NULL CONSTRAINT [DF_ItemLog_AllowSaleInDecimalQty] DEFAULT ('N'),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemLog_Length] DEFAULT (1),
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemLog_Width] DEFAULT (1),
    [AreaVolume] numeric(16,8) NOT NULL CONSTRAINT [DF_ItemLog_AreaVolume] DEFAULT (1),
    [Thickness] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemLog_Thickness] DEFAULT (1),
    [Sheets] int NOT NULL CONSTRAINT [DF_ItemLog_Sheets] DEFAULT (1),
    [Ingredients1] varchar(255) NULL,
    [Ingredients2] varchar(255) NULL,
    [ShortName] varchar(100) NULL,
    [LoyaltyItem] char(1) NOT NULL CONSTRAINT [DF_ItemLog_LoyaltyItem] DEFAULT ('Y'),
    [RegdNo] varchar(100) NOT NULL CONSTRAINT [DF_ItemLog_RegdNo] DEFAULT (''),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_ItemLog_Gender] DEFAULT ('M'),
    [Nationality] varchar(100) NULL,
    [BirthDate] datetime NULL,
    [IssueDate] datetime NULL,
    [ExpiryDate] datetime NULL,
    [PrefferedSaleQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemLog_PrefferedSaleQty] DEFAULT (1),
    [PackCapacity] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemLog_PackCapacity] DEFAULT (1),
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ItemLog_OriginalDate] DEFAULT (getdate()),
    [SalesTaxScheduleCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_SalesTaxScheduleCode] DEFAULT (1),
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_ItemLog_HeaderNo] DEFAULT (1),
    [PCTCode] int NOT NULL CONSTRAINT [DF_ItemLog_PCTCode] DEFAULT (1),
    [RedemptionDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemLog_RedemptionDiscPerc] DEFAULT (0),
    [ClaimableDiscperc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemLog_ClaimableDiscperc] DEFAULT (0),
    [PrintItemBatch] char(1) NOT NULL CONSTRAINT [DF_ItemLog_PrintItemBatch] DEFAULT ('Y'),
    [ItemThicknessCode] smallint NOT NULL CONSTRAINT [DF_ItemLog_ItemThicknessCode] DEFAULT (1),
    [ItemThicknessCode2] smallint NULL,
    [ItemColourCode2] smallint NULL,
    [ChangeReason] varchar(100) NULL,
    [Module] varchar(100) NULL,
    [AllowSalePriceBelowAvgPrice] char(1) NOT NULL CONSTRAINT [DF_ItemLog_AllowSalePriceBelowAvgPrice] DEFAULT ('N'),
    CONSTRAINT [PK_ItemLog] PRIMARY KEY CLUSTERED ([ICode], [ItemRowID]),
    CONSTRAINT [ILCustomICodeUC] UNIQUE ([CustomICode], [ItemRowID]),
    CONSTRAINT [ILNameUC] UNIQUE ([Name], [ItemRowID])
);
GO

CREATE TABLE [dbo].[ItemMeter] (
    [ItemMeterCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    [CurrentReading] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemMeter_CurrentReading] DEFAULT (0),
    CONSTRAINT [PK_ItemMeter_ItemMeterCode] PRIMARY KEY CLUSTERED ([ItemMeterCode]),
    CONSTRAINT [UK_ItemMeter_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemMeterLog] (
    [ItemMeterLogID] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemMeterLog_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [ItemMeterCode] smallint NOT NULL,
    [MeterReading] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemMeterLog_MeterReading] DEFAULT (0),
    [Reason] varchar(255) NULL,
    [NewReading] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemMeterLog_NewReading] DEFAULT (0),
    CONSTRAINT [PK_ItemMeterLog] PRIMARY KEY CLUSTERED ([ItemMeterLogID])
);
GO

CREATE TABLE [dbo].[ItemNotes] (
    [ICode] int NOT NULL,
    [Notes] image NULL,
    CONSTRAINT [PK_ItemNotes] PRIMARY KEY CLUSTERED ([ICode])
);
GO

CREATE TABLE [dbo].[ItemPacking] (
    [PackCode] smallint NOT NULL,
    [Name] varchar(20) NOT NULL,
    [NumericalFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemPacking_NumericalFactor] DEFAULT (1),
    CONSTRAINT [PK_ItemPacking] PRIMARY KEY CLUSTERED ([PackCode]),
    CONSTRAINT [IPNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemPart] (
    [IPartCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [Application] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [MasterIPartCode] int NULL,
    [ICatCode] smallint NOT NULL CONSTRAINT [DF_ItemPart_ICatCode] DEFAULT (1),
    [ICCode] smallint NOT NULL CONSTRAINT [DF_ItemPart_ICCode] DEFAULT (1),
    [ManfCode] smallint NOT NULL CONSTRAINT [DF_ItemPart_ManfCode] DEFAULT (1),
    [GCode] smallint NOT NULL CONSTRAINT [DF_ItemPart_GCODE] DEFAULT (1),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemPart_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemPart_SalePrice] DEFAULT (0),
    [ReorderLevel] int NOT NULL CONSTRAINT [DF_ItemPart_ReorderLevel] DEFAULT (0),
    [MinLevel] int NOT NULL CONSTRAINT [DF_ItemPart_MinLevel] DEFAULT (0),
    [MaxLevel] int NOT NULL CONSTRAINT [DF_ItemPart_MaxLevel] DEFAULT (0),
    [QtyUsed] int NOT NULL CONSTRAINT [DF_ItemPart_QtyUsed] DEFAULT (0),
    CONSTRAINT [PK_ItemPart] PRIMARY KEY CLUSTERED ([IPartCode]),
    CONSTRAINT [UQ_ItemPartName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemPartInModel] (
    [IPartCode] int NOT NULL,
    [ModelCode] smallint NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ItemPartInModel] PRIMARY KEY CLUSTERED ([IPartCode], [ModelCode])
);
GO

CREATE TABLE [dbo].[ItemPurExpTemplate] (
    [GroupCode] smallint NOT NULL,
    [QExp1_Caption] varchar(100) NULL,
    [QExp1_AccCode] smallint NULL,
    [QExp2_Caption] varchar(100) NULL,
    [QExp2_AccCode] smallint NULL,
    [QExp3_Caption] varchar(100) NULL,
    [QExp3_AccCode] smallint NULL,
    [QExp4_Caption] varchar(100) NULL,
    [QExp4_AccCode] smallint NULL,
    [QExp5_Caption] varchar(100) NULL,
    [QExp5_AccCode] smallint NULL,
    [WExp1_Caption] varchar(100) NULL,
    [WExp1_AccCode] smallint NULL,
    [WExp2_Caption] varchar(100) NULL,
    [WExp2_AccCode] smallint NULL,
    [WExp3_Caption] varchar(100) NULL,
    [WExp3_AccCode] smallint NULL,
    [WExp4_Caption] varchar(100) NULL,
    [WExp4_AccCode] smallint NULL,
    [WExp5_Caption] varchar(100) NULL,
    [WExp5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_QExp1_CrAccCode] DEFAULT (4),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_QExp2_CrAccCode] DEFAULT (4),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_QExp3_CrAccCode] DEFAULT (4),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_QExp4_CrAccCode] DEFAULT (4),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_QExp5_CrAccCode] DEFAULT (4),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_WExp1_CrAccCode] DEFAULT (4),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_WExp2_CrAccCode] DEFAULT (4),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_WExp3_CrAccCode] DEFAULT (4),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_WExp4_CrAccCode] DEFAULT (4),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemPurExpTemplate_WExp5_CrAccCode] DEFAULT (4),
    CONSTRAINT [PK_ItemPurExpTemplate] PRIMARY KEY CLUSTERED ([GroupCode])
);
GO

CREATE TABLE [dbo].[ItemReceiptExpTemplate] (
    [GroupCode] smallint NOT NULL,
    [QExp1_Caption] varchar(100) NULL,
    [QExp1_AccCode] smallint NULL,
    [QExp2_Caption] varchar(100) NULL,
    [QExp2_AccCode] smallint NULL,
    [QExp3_Caption] varchar(100) NULL,
    [QExp3_AccCode] smallint NULL,
    [QExp4_Caption] varchar(100) NULL,
    [QExp4_AccCode] smallint NULL,
    [QExp5_Caption] varchar(100) NULL,
    [QExp5_AccCode] smallint NULL,
    [WExp1_Caption] varchar(100) NULL,
    [WExp1_AccCode] smallint NULL,
    [WExp2_Caption] varchar(100) NULL,
    [WExp2_AccCode] smallint NULL,
    [WExp3_Caption] varchar(100) NULL,
    [WExp3_AccCode] smallint NULL,
    [WExp4_Caption] varchar(100) NULL,
    [WExp4_AccCode] smallint NULL,
    [WExp5_Caption] varchar(100) NULL,
    [WExp5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_QExp1_CrAccCode] DEFAULT (34),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_QExp2_CrAccCode] DEFAULT (34),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_QExp3_CrAccCode] DEFAULT (34),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_QExp4_CrAccCode] DEFAULT (34),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_QExp5_CrAccCode] DEFAULT (34),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_WExp1_CrAccCode] DEFAULT (34),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_WExp2_CrAccCode] DEFAULT (34),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_WExp3_CrAccCode] DEFAULT (34),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_WExp4_CrAccCode] DEFAULT (34),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ItemReceiptExpTemplate_WExp5_CrAccCode] DEFAULT (34),
    CONSTRAINT [PK_ItemReceiptExpTemplate] PRIMARY KEY CLUSTERED ([GroupCode])
);
GO

CREATE TABLE [dbo].[ItemRegRequest] (
    [ItemRegReqCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ItemRegRequest_Date] DEFAULT (getdate()),
    [ServerName] varchar(100) NOT NULL,
    [MachineName] varchar(100) NOT NULL,
    [Sent] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_Sent] DEFAULT ('N'),
    [SentOn] datetime NULL,
    [SentBy] smallint NULL,
    [ServerItemRegReqCode] int NULL,
    [ICode] int NULL,
    [CustomICode] varchar(75) NULL,
    [Name] varchar(60) NOT NULL,
    [ICCode] smallint NULL,
    [ICatCode] smallint NULL,
    [Packcode] smallint NULL,
    [ManfCode] smallint NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_PurPrice] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_RetailPrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemRegRequest_AvgPrice] DEFAULT (0),
    [SaleDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SaleDiscPerc] DEFAULT (0),
    [PurDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_PurDiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalesTax] DEFAULT (0),
    [ReorderQty] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_ReorderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_ItemRegRequest_OptimumQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_PackUnits] DEFAULT (1),
    [Active] tinyint NOT NULL CONSTRAINT [DF_ItemRegRequest_Active] DEFAULT (1),
    [Prescribed] tinyint NOT NULL CONSTRAINT [DF_ItemRegRequest_Prescribed] DEFAULT (0),
    [Refrigrated] tinyint NOT NULL CONSTRAINT [DF_ItemRegRequest_Refrigrated] DEFAULT (0),
    [PrINTable] tinyint NOT NULL CONSTRAINT [DF_ItemRegRequest_Printable] DEFAULT (1),
    [Location1] varchar(100) NOT NULL CONSTRAINT [DF_ItemRegRequest_Location1] DEFAULT ('No'),
    [Remarks1] varchar(100) NOT NULL CONSTRAINT [DF_ItemRegRequest_Remarks1] DEFAULT ('No'),
    [Location] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [Gcode] int NULL,
    [ReorderLevel] int NULL,
    [OptimumLevel] int NULL,
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_RecentPurPrice] DEFAULT (0),
    [SalePrice2] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePrice2] DEFAULT (0),
    [SalePrice3] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePrice3] DEFAULT (0),
    [GReorderQty] int NULL,
    [GOptimumQty] int NULL,
    [AntiNorCotix] char(1) NULL CONSTRAINT [DF_ItemRegRequest_AntiNorCotix] DEFAULT ('N'),
    [Restricted] char(1) NULL CONSTRAINT [DF_ItemRegRequest_Restricted] DEFAULT ('N'),
    [GSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_ItemRegRequest_GSTPerc1] DEFAULT (0),
    [GSTPerc2] numeric(6,2) NULL CONSTRAINT [DF_ItemRegRequest_GSTPerc2] DEFAULT (0),
    [PackSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_PackSalesTax] DEFAULT (0),
    [PackingDesc] varchar(50) NULL,
    [SaleQty] int NOT NULL CONSTRAINT [DF_ItemRegRequest_SaleQty] DEFAULT (0),
    [BonusQty] int NOT NULL CONSTRAINT [DF_ItemRegRequest_BonusQty] DEFAULT (0),
    [PrINTExpiry] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_PrintExpiry] DEFAULT ('Y'),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_UserCode] DEFAULT (1),
    [LastUpdate] datetime NOT NULL,
    [FlatDisc] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_FlatDisc] DEFAULT (0),
    [LockSalePrice] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_LockSalePrice] DEFAULT ('N'),
    [LockDiscPerc] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_LockDiscPerc] DEFAULT ('N'),
    [PackingCost] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_PackingCost] DEFAULT (0),
    [RecentPurPrice2] numeric(15,2) NULL CONSTRAINT [DF_ItemRegRequest_RecentPurPrice2] DEFAULT (0),
    [RecentPurPrice3] numeric(15,2) NULL CONSTRAINT [DF_ItemRegRequest_RecentPurPrice3] DEFAULT (0),
    [RecentPurPrice4] numeric(15,2) NULL CONSTRAINT [DF_ItemRegRequest_RecentPurPrice4] DEFAULT (0),
    [RecentPurPrice5] numeric(15,2) NULL CONSTRAINT [DF_ItemRegRequest_RecentPurPrice5] DEFAULT (0),
    [SaleDiscPerc2] numeric(5,2) NULL CONSTRAINT [DF_ItemRegRequest_SaleDiscPerc2] DEFAULT (0),
    [SaleDiscPerc3] numeric(5,2) NULL CONSTRAINT [DF_ItemRegRequest_SaleDiscPerc3] DEFAULT (0),
    [SaleDiscPerc4] numeric(5,2) NULL CONSTRAINT [DF_ItemRegRequest_SaleDiscPerc4] DEFAULT (0),
    [ISizeCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_ISizeCode] DEFAULT (1),
    [IStyleCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_IStyleCode] DEFAULT (1),
    [IColourCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_IColourCode] DEFAULT (1),
    [ISleeveCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_ISleeveCode] DEFAULT (1),
    [IYarnCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_IYarnCode] DEFAULT (1),
    [IFabricCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_IFabricCode] DEFAULT (1),
    [IBrandCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_IBrandCode] DEFAULT (1),
    [SalePrice4] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePrice4] DEFAULT (0),
    [SalePrice5] numeric(15,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePrice5] DEFAULT (0),
    [SaleDiscPerc5] numeric(5,2) NULL CONSTRAINT [DF_ItemRegRequest_salediscperc5] DEFAULT (0),
    [MinQty] int NOT NULL CONSTRAINT [DF_ItemRegRequest_MinQty] DEFAULT (0),
    [IPartCode] int NOT NULL CONSTRAINT [DF_ItemRegRequest_IPartCode] DEFAULT (1),
    [OldPartCode] int NULL,
    [ItemYear] varchar(15) NULL,
    [RemarksForPurchase] varchar(100) NULL,
    [SizeDescription] varchar(100) NULL,
    [ModelDescription] varchar(100) NULL,
    [TypeDescription] varchar(100) NULL,
    [GenericCode] int NOT NULL CONSTRAINT [DF_ItemRegRequest_GenericCode] DEFAULT (1),
    [TransitStock] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_TransitStock] DEFAULT (0),
    [PackingFactor] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemRegRequest_PackingFactor] DEFAULT (1),
    [ItemTypeCode] int NOT NULL CONSTRAINT [DF_ItemRegRequest_ItemType] DEFAULT (1),
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_DiscountedSalePrice] DEFAULT (0),
    [DiscountedPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_DiscountedPurPrice] DEFAULT (0),
    [SalePriceChangeMargin] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_SalePriceChangeMargin] DEFAULT (0),
    [GeneratePO] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_GeneratePO] DEFAULT ('Y'),
    [QtyUsed] int NOT NULL CONSTRAINT [DF_ItemRegRequest_QtyUsed] DEFAULT (0),
    [MeasureUnitCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_MeasureUnitCode] DEFAULT (1),
    [MaxSaleDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_MaxSaleDiscPerc] DEFAULT (100.00),
    [BonusPolicyCode] smallint NULL,
    [DiscountPolicyCode] smallint NULL,
    [ItemDesignCode] int NOT NULL CONSTRAINT [DF_ItemRegRequest_ItemDesignCode] DEFAULT (1),
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_ItemRegRequest_UnitWeight] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ItemRegRequest_TotalPieces] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_AlternatePurPrice] DEFAULT (0),
    [PurFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_PurFlatDisc] DEFAULT (0),
    [ItemAlertCode] smallint NOT NULL CONSTRAINT [DF_ItemRegRequest_ItemAlterCode] DEFAULT (1),
    [MinSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_MinSalePrice] DEFAULT (0),
    [Taxable] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_Taxable] DEFAULT ('N'),
    [ForcePatientDoctorRecordInSale] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_ForcePatientDoctorRecordInSale] DEFAULT ('N'),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ItemRegRequest_ForeignPrice] DEFAULT (0),
    [CheckUpperSaleQtyLimit] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_CheckUpperSaleQtyLimit] DEFAULT ('N'),
    [UpperSaleQtyLimit] int NOT NULL CONSTRAINT [DF_ItemRegRequest_UpperSaleQtyLimit] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ItemRegRequest_CommissionPerc] DEFAULT (0),
    [AllowDue] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_AllowDue] DEFAULT ('Y'),
    [LocalItemName] nvarchar(255) NULL,
    [ConfirmExpiry] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_ConfirmExpiry] DEFAULT ('N'),
    [AllowSaleInDecimalQty] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_AllowSaleInDecimalQty] DEFAULT ('N'),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_Length] DEFAULT (1),
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_Width] DEFAULT (1),
    [AreaVolume] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_AreaVolume] DEFAULT (1),
    [Thickness] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_Thickness] DEFAULT (1),
    [Sheets] int NOT NULL CONSTRAINT [DF_ItemRegRequest_Sheets] DEFAULT (1),
    [Ingredients1] varchar(255) NULL,
    [Ingredients2] varchar(255) NULL,
    [ShortName] varchar(100) NULL,
    [LoyaltyItem] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_LoyaltyItem] DEFAULT ('Y'),
    [RegdNo] varchar(100) NOT NULL CONSTRAINT [DF_ItemRegRequest_RegdNo] DEFAULT (''),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_Gender] DEFAULT ('M'),
    [Nationality] varchar(100) NULL,
    [BirthDate] datetime NULL,
    [IssueDate] datetime NULL,
    [ExpiryDate] datetime NULL,
    [PrefferedSaleQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_PrefferedSaleQty] DEFAULT (1),
    [PackCapacity] numeric(12,4) NOT NULL CONSTRAINT [DF_ItemRegRequest_PackCapacity] DEFAULT (1),
    [Status] char(1) NOT NULL CONSTRAINT [DF_ItemRegRequest_Status] DEFAULT ('P'),
    CONSTRAINT [PK_ItemRegRequest] PRIMARY KEY CLUSTERED ([ItemRegReqCode])
);
GO

CREATE TABLE [dbo].[items_corrupted] (
    [date] datetime NOT NULL,
    [icode] int NOT NULL,
    [name] varchar(100) NOT NULL,
    [stockinhand] numeric(15,2) NOT NULL,
    [stockshouldbe] numeric(15,2) NOT NULL
);
GO

CREATE TABLE [dbo].[ItemsGroupCategory] (
    [GroupCode] smallint NOT NULL,
    [ItemsCategoryCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_ItemsGroup_Status_1__10] DEFAULT (1),
    CONSTRAINT [PK_ItemsGroupCategory_2__10] PRIMARY KEY CLUSTERED ([GroupCode], [ItemsCategoryCode])
);
GO

CREATE TABLE [dbo].[ItemSize] (
    [ISizeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemSize] PRIMARY KEY CLUSTERED ([ISizeCode]),
    CONSTRAINT [IX_SizeName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemSleeve] (
    [ISleeveCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemSleeve] PRIMARY KEY CLUSTERED ([ISleeveCode]),
    CONSTRAINT [IX_SleeveName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemStyle] (
    [IStyleCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemStyle] PRIMARY KEY CLUSTERED ([IStyleCode]),
    CONSTRAINT [IX_StyleName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemSuppliers] (
    [ICode] int NOT NULL,
    [SuppCode] smallint NOT NULL,
    [Priority] tinyint NOT NULL CONSTRAINT [DF_ItemSuppli_Priority_1__12] DEFAULT (10),
    [Rate] numeric(15,2) NOT NULL CONSTRAINT [DF_itemsuppliers_Rate] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_itemsuppliers_discperc] DEFAULT (0),
    [SaleQty] int NOT NULL CONSTRAINT [DF_itemsuppliers_SaleQty] DEFAULT (0),
    [BonusQty] int NOT NULL CONSTRAINT [DF_itemsuppliers_BonusQty] DEFAULT (0),
    [days] int NOT NULL CONSTRAINT [DF_itemsuppliers_days] DEFAULT (0),
    CONSTRAINT [PK_ItemSuppliers_2__12] PRIMARY KEY CLUSTERED ([ICode], [SuppCode]),
    CONSTRAINT [ItemSuppliers_ICode_Priority_UK] UNIQUE ([ICode], [Priority])
);
GO

CREATE TABLE [dbo].[ItemThickness] (
    [ItemThicknessCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemThickness] PRIMARY KEY CLUSTERED ([ItemThicknessCode]),
    CONSTRAINT [UK_ItemThickness_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemType] (
    [ItemTypeCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_ItemType] PRIMARY KEY CLUSTERED ([ItemTypeCode]),
    CONSTRAINT [UQ_ItemType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ItemYarn] (
    [IYarnCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_ItemYarn] PRIMARY KEY CLUSTERED ([IYarnCode]),
    CONSTRAINT [IX_YarnName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LabInvestRec] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_LabInvestRec_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [CBC] char(1) NULL,
    [RFTs] char(1) NULL,
    [LFTs] char(1) NULL,
    [UricAcid] char(1) NULL,
    [SerumElectrolytes] char(1) NULL,
    [UreaCreatinine] char(1) NULL,
    [FastingLipidProfile] char(1) NULL,
    [FastingBloodSugar] char(1) NULL,
    [RandomBloodSugar] char(1) NULL,
    [HbA1C] char(1) NULL,
    [CardiacEnzymes] char(1) NULL,
    [TropT] char(1) NULL,
    [TropI] char(1) NULL,
    [PTINR] char(1) NULL,
    [APTT] char(1) NULL,
    [BNP] char(1) NULL,
    [DDimmer] char(1) NULL,
    [ASOTitre] char(1) NULL,
    [CRP] char(1) NULL,
    [CRPHighSensitive] char(1) NULL,
    [PSA] char(1) NULL,
    [ThyroidFunctionTest] char(1) NULL,
    [Other] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_LabInvestRec_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_LabInvestRec_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[LastPurchaseHistory] (
    [PurInvCode] int NOT NULL,
    [Supplier] varchar(100) NOT NULL,
    [Date] datetime NOT NULL,
    [PurCatCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_LooseQty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_BonusQty] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_PurPrice] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_ItemFlatDisc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_GSTPerc] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_NetRate] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_LastPurchaseHistory_AvgPrice] DEFAULT (0),
    [NewAvgPrice] numeric(15,5) NULL,
    [InvDiscPerc] numeric(5,2) NOT NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_LastPurchaseHistory_CurrStock] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_LastPurchaseHistory_ItemAdvanceTaxPerc] DEFAULT (0),
    [SalesTaxScheduleCode] smallint NULL,
    [PCTCode] int NULL
);
GO

CREATE TABLE [dbo].[License] (
    [LicenseCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_License_Date] DEFAULT (getdate()),
    [CustCode] smallint NOT NULL,
    [ValidFrom] datetime NOT NULL CONSTRAINT [DF_License_ValidFrom] DEFAULT (getdate()),
    [ValidUpTo] datetime NOT NULL CONSTRAINT [DF_License_ValidUpTo] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(1000) NULL,
    CONSTRAINT [PK_License] PRIMARY KEY CLUSTERED ([LicenseCode])
);
GO

CREATE TABLE [dbo].[LicenseCategory] (
    [LicenseCategoryCode] smallint IDENTITY(1,1) NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_LicenseCategory] PRIMARY KEY CLUSTERED ([LicenseCategoryCode]),
    CONSTRAINT [UK_LicenseCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LicRequestStatus] (
    [LicReqStatusCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_LicRequestStatus] PRIMARY KEY CLUSTERED ([LicReqStatusCode]),
    CONSTRAINT [UK_LicRequestStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Locker] (
    [LockerCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [LockerCatCode] smallint NOT NULL,
    [Occupied] char(1) NOT NULL CONSTRAINT [DF_Locker_Occupied] DEFAULT ('N'),
    [LastServiceInvCode] int NULL,
    CONSTRAINT [PK_Locker] PRIMARY KEY CLUSTERED ([LockerCode]),
    CONSTRAINT [UK_Locker_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LockerCategory] (
    [LockerCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_LockerCategory] PRIMARY KEY CLUSTERED ([LockerCatCode]),
    CONSTRAINT [UK_LockerCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LockReason] (
    [LockReasonCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_LockReason] PRIMARY KEY CLUSTERED ([LockReasonCode]),
    CONSTRAINT [UK_LockReason_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LoyaltyCard] (
    [LoyaltyCardCode] int NOT NULL,
    [LoyaltyCardID] varchar(100) NOT NULL,
    [LoyaltyPolicyCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_LoyaltyCard_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [ExpiryDate] datetime NOT NULL CONSTRAINT [DF_LoyaltyCard_ExpiryDate] DEFAULT (getdate()),
    CONSTRAINT [PK_LoyaltyCard] PRIMARY KEY CLUSTERED ([LoyaltyCardCode]),
    CONSTRAINT [UK_LoyaltyCard_LoyaltyCardID] UNIQUE ([LoyaltyCardID])
);
GO

CREATE TABLE [dbo].[LoyaltyCardLedger] (
    [LoyaltyCardCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_LoyaltyCardLedger_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [PointsDebit] int NOT NULL CONSTRAINT [DF_LoyaltyCardLedger_PointsDebit] DEFAULT (0),
    [PointsCredit] int NOT NULL CONSTRAINT [DF_LoyaltyCardLedger_PointsCredit] DEFAULT (0),
    [Debit] numeric(12,2) NOT NULL CONSTRAINT [DF_LoyaltyCardLedger_Debit] DEFAULT (0),
    [Credit] numeric(12,2) NOT NULL CONSTRAINT [DF_LoyaltyCardLedger_Credit] DEFAULT (0),
    [Remarks] varchar(255) NULL,
    [InvoiceType] varchar(2) NULL,
    [InvoiceCode] int NULL
);
GO

CREATE TABLE [dbo].[LoyaltyPointAdjustment] (
    [AdjustmentCode] int NOT NULL,
    [AdjustmentTypeCode] tinyint NOT NULL CONSTRAINT [DF_LoyaltyPointAdjustment_AdjustmentTypeCode] DEFAULT (1),
    [Date] datetime NOT NULL CONSTRAINT [DF_LoyaltyPointAdjustment_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [LoyaltyCardCode] int NOT NULL,
    [PointsBalance] int NOT NULL CONSTRAINT [DF_LoyaltyPointAdjustment_PointsBalance] DEFAULT (0),
    [AdjustedPoints] int NOT NULL CONSTRAINT [DF_LoyaltyPointAdjustment_AdjustedPoints] DEFAULT (0),
    [AdjustmentValue] int NOT NULL CONSTRAINT [DF_LoyaltyPointAdjustment_AdjustmentValue] DEFAULT (0),
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_LoyaltyPointAdjustment] PRIMARY KEY CLUSTERED ([AdjustmentCode])
);
GO

CREATE TABLE [dbo].[LoyaltyPolicy] (
    [LoyaltyPolicyCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_LoyaltyPolicy_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_LoyaltyPolicy] PRIMARY KEY CLUSTERED ([LoyaltyPolicyCode]),
    CONSTRAINT [UK_LoyaltyPolicy_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[LoyaltyPolicyDetail] (
    [LoyaltyPolicyCode] int NOT NULL,
    [SaleLimit] numeric(12,2) NOT NULL CONSTRAINT [DF_LoyaltyPolicy_SaleLimit] DEFAULT (0),
    [LoyaltyPoints] int NOT NULL CONSTRAINT [DF_LoyaltyPolicy_LoyaltyPoints] DEFAULT (0),
    [RedemptionValue] numeric(12,2) NOT NULL CONSTRAINT [DF_LoyaltyPolicy_RedemptionValue] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[LoyaltyRedemption] (
    [LoyaltyRedemptionCode] int NOT NULL,
    [LoyaltyCardCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_LoyaltyRedemption_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [PointsBalance] int NOT NULL CONSTRAINT [DF_LoyaltyRedemption_PointsBalance] DEFAULT (0),
    [PointsRedeemed] int NOT NULL CONSTRAINT [DF_LoyaltyRedemption_PointsRedeemed] DEFAULT (0),
    [PointsValue] numeric(12,2) NOT NULL CONSTRAINT [DF_LoyaltyRedemption_PointsValue] DEFAULT (0),
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_LoyaltyRedemption] PRIMARY KEY CLUSTERED ([LoyaltyRedemptionCode])
);
GO

CREATE TABLE [dbo].[MainAccounts] (
    [MainAccCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_MainAccounts] PRIMARY KEY CLUSTERED ([MainAccCode]),
    CONSTRAINT [MANameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Manufacturer] (
    [ManfCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(40) NULL,
    [Address1] varchar(60) NULL,
    [City] varchar(30) NULL,
    [Country] varchar(30) NULL,
    [Phone] varchar(30) NULL,
    [Fax] varchar(16) NULL,
    [CP] varchar(60) NULL,
    [Email] varchar(30) NULL,
    [Address2] varchar(60) NULL,
    [AliasName] varchar(5) NULL CONSTRAINT [DF_Manufactur_AliasName_1__12] DEFAULT (1),
    [PurOrderBasePeriodDays] int NOT NULL CONSTRAINT [DF_Manufacturer_PurOrderBasePeriodDays] DEFAULT (45),
    [PurOrderProjPeriodDays] int NOT NULL CONSTRAINT [DF_Manufacturer_PurOrderProjPeriodDays] DEFAULT (30),
    [POPolicyCode] int NOT NULL CONSTRAINT [DF_Manufacturer_POPolicyCode] DEFAULT (1),
    [ManfCatCode] smallint NOT NULL CONSTRAINT [DF_Manufacturer_ManfCatCode] DEFAULT (1),
    [LicenseNo] varchar(100) NULL,
    [ManufacturerTypeCode] smallint NOT NULL CONSTRAINT [DF_Manufacturer_ManufacturerTypeCode] DEFAULT (1),
    CONSTRAINT [PK_Manufacturer] PRIMARY KEY CLUSTERED ([ManfCode]),
    CONSTRAINT [MFNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ManufacturerCategory] (
    [ManfCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_ManufacturerCategory] PRIMARY KEY CLUSTERED ([ManfCatCode]),
    CONSTRAINT [UQ_ManufacturerCategory] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ManufacturerType] (
    [ManufacturerTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ManufacturerType_ManufacturerType] PRIMARY KEY ([ManufacturerTypeCode]),
    CONSTRAINT [UK_ManufacturerType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[MasterCashWin] (
    [DocumentCode] int NOT NULL,
    [DocumentType] varchar(2) NOT NULL,
    [AccCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_MasterCashWin_Amount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_MasterCashWin] PRIMARY KEY CLUSTERED ([DocumentType], [DocumentCode], [AccCode])
);
GO

CREATE TABLE [dbo].[MeasuringUnit] (
    [MeasureUnitCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [MeasureQty] numeric(9,4) NOT NULL CONSTRAINT [DF_MeasuringUnit_MeasureQty] DEFAULT (1),
    CONSTRAINT [PK_MeasuringUnit_MeasureUnitCode] PRIMARY KEY CLUSTERED ([MeasureUnitCode]),
    CONSTRAINT [UK_MeasuringUnit_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[MembershipRenewal] (
    [RenewalCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_MemeberShipRenewal_UserCode] DEFAULT (1),
    [Date] datetime NOT NULL CONSTRAINT [DF__Membership__Date__422E8D3E] DEFAULT (getdate()),
    [postdate] datetime NOT NULL CONSTRAINT [DF__Membershi__postd__4322B177] DEFAULT (getdate()),
    [Posted] char(1) NOT NULL CONSTRAINT [DF__Membershi__Poste__4416D5B0] DEFAULT ('Y'),
    [PostedBy] smallint NOT NULL CONSTRAINT [DF_MemeberShipRenewal_PostedBy] DEFAULT (1),
    [OldAliasName] varchar(12) NOT NULL,
    [OldLicExpiry] datetime NOT NULL,
    [NewAliasName] varchar(12) NOT NULL,
    [NewLicExpiry] datetime NOT NULL,
    [PatientCode] int NULL,
    CONSTRAINT [PK_MemberShipRenewal_RenewalCode] PRIMARY KEY CLUSTERED ([RenewalCode])
);
GO

CREATE TABLE [dbo].[Message] (
    [MessageCode] smallint NOT NULL,
    [Description] varchar(50) NOT NULL,
    CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED ([MessageCode])
);
GO

CREATE TABLE [dbo].[Model] (
    [ModelCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Model] PRIMARY KEY CLUSTERED ([ModelCode]),
    CONSTRAINT [UQ_ModelName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Module] (
    [Module] smallint NOT NULL,
    [Name] varchar(30) NOT NULL,
    CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED ([Module])
);
GO

CREATE TABLE [dbo].[ModuleEvent] (
    [ModuleID] smallint NOT NULL,
    [Event] varchar(50) NOT NULL,
    CONSTRAINT [PK_ModuleEvent] PRIMARY KEY CLUSTERED ([ModuleID], [Event])
);
GO

CREATE TABLE [dbo].[MotorVehicle] (
    [MotorVehicleCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [MotorVehicleTypeCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_MotorVehicle_OriginalDate] DEFAULT (getdate()),
    [Date] datetime NOT NULL CONSTRAINT [DF_MotorVehicle_Date] DEFAULT (getdate()),
    [ChasisNo] varchar(100) NOT NULL,
    [EngineNo] varchar(100) NULL,
    [Model] varchar(100) NULL,
    [Color] varchar(100) NULL,
    [EnginePower] varchar(100) NULL,
    [Area] varchar(100) NULL,
    [CustCode] smallint NOT NULL,
    [RegNo] varchar(100) NULL,
    [RefNo] varchar(100) NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [ToolKit] char(1) NOT NULL CONSTRAINT [DF_MotorVehicle_ToolKit] DEFAULT ('N'),
    [SpareTyre] char(1) NOT NULL CONSTRAINT [DF_MotorVehicle_SpareTyre] DEFAULT ('N'),
    [OriginalKeys] varchar(100) NOT NULL CONSTRAINT [DF_MotorVehicle_OriginalKeys] DEFAULT ('2'),
    [WarrantyBook] char(1) NOT NULL CONSTRAINT [DF_MotorVehicle_WarrantyBook] DEFAULT ('N'),
    CONSTRAINT [PK_MotorVehicle] PRIMARY KEY CLUSTERED ([MotorVehicleCode]),
    CONSTRAINT [UK_MotorVehicle_ChasisNo] UNIQUE ([ChasisNo])
);
GO

CREATE TABLE [dbo].[MotorVehicleType] (
    [MotorVehicleTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_MotorVehicleType] PRIMARY KEY CLUSTERED ([MotorVehicleTypeCode]),
    CONSTRAINT [UK_MotorVehicleType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[NewManufacturer] (
    [ManfCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(40) NULL,
    [Address1] varchar(60) NULL,
    [City] varchar(30) NULL,
    [Country] varchar(30) NULL,
    [Phone] varchar(30) NULL,
    [Fax] varchar(16) NULL,
    [CP] varchar(60) NULL,
    [Email] varchar(30) NULL,
    [Address2] varchar(60) NULL,
    CONSTRAINT [PK_NewManufacturer_1__23] PRIMARY KEY CLUSTERED ([ManfCode])
);
GO

CREATE TABLE [dbo].[Notes] (
    [NoteCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [BankAccCode] smallint NULL,
    [IssueDate] datetime NOT NULL,
    [DueDate] datetime NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_Notes_Amount] DEFAULT (0),
    [BankName] varchar(40) NULL,
    [DocumentNumber] varchar(40) NULL,
    [Remarks] varchar(60) NULL,
    [NoteCatCode] tinyint NOT NULL,
    [Posted] char(1) NULL,
    [PostDate] datetime NULL,
    [SalesmanCode] smallint NULL,
    [VoucherCode] int NOT NULL CONSTRAINT [DF_Notes_VoucherCode] DEFAULT (0),
    [Modified] char(1) NOT NULL CONSTRAINT [DF_Notes_Modified] DEFAULT ('N'),
    [ModifiedBY] smallint NULL,
    [PostedBY] smallint NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_Notes_Finalized] DEFAULT ('N'),
    [FinalizedDate] datetime NULL,
    [FinalizedBy] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_Notes_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_Notes_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    CONSTRAINT [PK_Notes_1__13] PRIMARY KEY CLUSTERED ([NoteCode]),
    CONSTRAINT [IX_Notes_VoucherCode] UNIQUE ([NoteCatCode], [VoucherCode]),
    CONSTRAINT [test] CHECK ([NoteCode] > 0)
);
GO

CREATE TABLE [dbo].[NotesCategory] (
    [NoteCatCode] tinyint NOT NULL,
    [Name] varchar(30) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_NotesCategory_Counter] DEFAULT (0),
    CONSTRAINT [PK_NotesCategory_1__13] PRIMARY KEY CLUSTERED ([NoteCatCode])
);
GO

CREATE TABLE [dbo].[NotesDetail] (
    [NoteCode] int NOT NULL,
    [InvoiceCode] int NOT NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_NotesDetail_OutstandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_NotesDetail_Amt] DEFAULT (0),
    [NoteROWID] int IDENTITY(1,1) NOT NULL,
    [NotesUTN] bigint NOT NULL,
    CONSTRAINT [PK_NotesDetail] PRIMARY KEY CLUSTERED ([NoteCode], [InvoiceCode])
);
GO

CREATE TABLE [dbo].[OBS_US] (
    [PatientCode] int NOT NULL,
    [VisitCode] int NULL,
    [AdmissionCode] int NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_OBS_US_Date] DEFAULT (getdate()),
    [LMP] datetime NULL,
    [LMPDetails] varchar(100) NULL,
    [EDD] datetime NULL,
    [Gestation] char(1) NULL,
    [Viability_Seen_FH] char(1) NULL,
    [Viability_Seen_FM] char(1) NULL,
    [Viability_NotSeen_FH] char(1) NULL,
    [Viability_NotSeen_FM] char(1) NULL,
    [Presentation] char(1) NULL,
    [Lie] char(1) NULL,
    [Placenta] char(1) NULL,
    [Previa_Type] varchar(100) NULL,
    [AmnioticFluid] char(1) NULL,
    [FetalMorph_CNS_POC] char(1) NULL,
    [FetalMorph_CNS_POO] char(1) NULL,
    [FetalMorph_CNS_NormalSpine] char(1) NULL,
    [FetalMorph_Chest_FCV] char(1) NULL,
    [FetalMorph_Chest_AOA] char(1) NULL,
    [FetalMorph_Chest_CM] char(1) NULL,
    [FetalMorph_Abdomen_Stomach] char(1) NULL,
    [FetalMorph_Abdomen_Kidneys] char(1) NULL,
    [FetalMorph_Abdomen_Bladder] char(1) NULL,
    [FetalMorph_UmbilicalCord] char(1) NULL,
    [Biometry_DOGS] numeric(5,2) NULL CONSTRAINT [DF_OBS_US_Biometry_DOGS] DEFAULT (0),
    [Biometry_BPD] numeric(5,2) NULL CONSTRAINT [DF_OBS_US_Biometry_BPD] DEFAULT (0),
    [Biometry_GestationAge] varchar(100) NULL,
    [Biometry_CRL] numeric(5,2) NULL CONSTRAINT [DF_OBS_US_Biometry_CRL] DEFAULT (0),
    [Biometry_FemurLength] numeric(5,2) NULL CONSTRAINT [DF_OBS_US_Biometry_FemurLength] DEFAULT (0),
    [Biometry_Details] varchar(1000) NULL,
    [Comments] varchar(1000) NULL
);
GO

CREATE TABLE [dbo].[old_MembershipRenewal] (
    [id] int IDENTITY(1,1) NOT NULL,
    [CustCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [OldAliasName] varchar(12) NOT NULL,
    [OldLiscExpiry] datetime NOT NULL
);
GO

CREATE TABLE [dbo].[Organ] (
    [OrganCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_Organ_OrganCode] PRIMARY KEY CLUSTERED ([OrganCode]),
    CONSTRAINT [UK_Organ_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[p_manufacturer1] (
    [manfcode] int NULL,
    [name] varchar(30) NULL,
    [address1] varchar(30) NULL,
    [address2] varchar(30) NULL,
    [city] varchar(15) NULL,
    [country] varchar(15) NULL,
    [phone] varchar(20) NULL,
    [fax] varchar(20) NULL,
    [email] varchar(50) NULL
);
GO

CREATE TABLE [dbo].[PackingCaseCapacity] (
    [ICatCode] smallint NOT NULL,
    [PackCode] smallint NOT NULL,
    [OCQty] int NOT NULL CONSTRAINT [DF_PackingCaseCapacity_OCQty] DEFAULT (1),
    [MCQty] int NOT NULL CONSTRAINT [DF_PackingCaseCapacity_MCQty] DEFAULT (1),
    [SCQty] int NOT NULL CONSTRAINT [DF_PackingCaseCapacity_SCQty] DEFAULT (1),
    CONSTRAINT [PK_PackingCaseCapacity] PRIMARY KEY CLUSTERED ([ICatCode], [PackCode])
);
GO

CREATE TABLE [dbo].[PackingJob] (
    [PackingJobCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PackingJob_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PackingJob_Posted] DEFAULT ('Y'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_PackingJob_PostDate] DEFAULT (getdate()),
    [PostedBY] smallint NOT NULL CONSTRAINT [DF_PackingJob_PostedBY] DEFAULT (1),
    CONSTRAINT [PK_PackingJob] PRIMARY KEY CLUSTERED ([PackingJobCode])
);
GO

CREATE TABLE [dbo].[PackingJobDetail] (
    [PackingJobCode] int NOT NULL,
    [PackingLayoutCode] tinyint NOT NULL,
    [CaseNo] smallint NOT NULL,
    [MasterCartonNo] smallint NOT NULL,
    [CartonNo] smallint NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(12,4) NOT NULL CONSTRAINT [DF_PackingJobDetail_Qty] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_PackingJobDetail_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_PackingJobDetail_Expiry] DEFAULT (getdate()),
    CONSTRAINT [PK_PackingJobDetail] PRIMARY KEY CLUSTERED ([PackingJobCode], [PackingLayoutCode], [CaseNo], [MasterCartonNo], [CartonNo], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[PackingJobPending] (
    [PackingJobCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(12,4) NOT NULL CONSTRAINT [DF_PackingJobPending_Qty] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_PackingJobPending_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_PackingJobPending_Expiry] DEFAULT (getdate()),
    CONSTRAINT [PK_PackingJobPending] PRIMARY KEY CLUSTERED ([PackingJobCode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[PackingJobSource] (
    [PackingJobCode] int NOT NULL,
    [ModuleID] smallint NOT NULL,
    [DocCode] int NOT NULL,
    CONSTRAINT [PK_PackingJobSource] PRIMARY KEY CLUSTERED ([PackingJobCode], [ModuleID], [DocCode])
);
GO

CREATE TABLE [dbo].[PackingLayout] (
    [PackingLayoutCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_PackingLayout] PRIMARY KEY CLUSTERED ([PackingLayoutCode]),
    CONSTRAINT [UK_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Patient] (
    [PatientCode] int NOT NULL,
    [RegNo] varchar(50) NOT NULL,
    [Active] char(1) NOT NULL,
    [Name] varchar(60) NOT NULL,
    [FName] varchar(60) NULL,
    [Gender] char(1) NOT NULL,
    [DOB] datetime NULL,
    [Date] datetime NOT NULL,
    [CustCode] smallint NULL,
    [UserCode] smallint NOT NULL,
    [Address1] varchar(100) NULL,
    [Address2] varchar(100) NULL,
    [NationalIDCard] varchar(25) NULL,
    [City] varchar(25) NULL,
    [Phone] varchar(30) NULL,
    [Fax] varchar(30) NULL,
    [Email] varchar(35) NULL,
    [Ward] varchar(100) NULL,
    [RankCode] smallint NOT NULL CONSTRAINT [DF_Patient_RankCode] DEFAULT (1),
    [UnitCode] smallint NOT NULL CONSTRAINT [DF_Patient_UnitCode] DEFAULT (1),
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_Patient_OriginalDate] DEFAULT (getdate()),
    [InactiveDate] datetime NULL,
    [RelationCode] smallint NULL,
    [DoctCode] smallint NULL,
    [WardCode] smallint NULL,
    [EmployeeName] varchar(60) NULL,
    [CreatedBy] smallint NOT NULL CONSTRAINT [DF_Patient_CreatedBy] DEFAULT (1),
    [InActivedBy] smallint NULL,
    [DiseaseCode] smallint NULL,
    [LocationCode] smallint NULL,
    [Diagnosis] varchar(100) NULL,
    [InActiveCount] int NOT NULL CONSTRAINT [DF_Patient_InActiveCount] DEFAULT (0),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_Patient_RecurringPeriod] DEFAULT (0),
    [PatientCatCode] smallint NOT NULL CONSTRAINT [DF_Patient_PatientCatCode] DEFAULT (1),
    [Profession] varchar(100) NULL,
    [Reference] varchar(100) NULL,
    [GestationCode] tinyint NOT NULL CONSTRAINT [DF_Patient_GestationCode] DEFAULT (1),
    [CrLimit] numeric(10,2) NOT NULL CONSTRAINT [DF_Patient_CrLimit] DEFAULT (0),
    [RefNo1] varchar(100) NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [RefNo6] varchar(100) NULL,
    [RefNo7] varchar(100) NULL,
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_Patient_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_Patient_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_Patient_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_Patient_CashBack] DEFAULT (0),
    [Address3] varchar(100) NULL,
    [Institute] varchar(100) NULL,
    [Phone2] varchar(100) NULL,
    [Nationality] varchar(100) NULL,
    [MobileNo1] varchar(100) NULL,
    [MobileNo2] varchar(100) NULL,
    [MobileNo3] varchar(100) NULL,
    [FamilyMembers] varchar(20) NULL,
    [Brothers] varchar(20) NULL,
    [Sisters] varchar(20) NULL,
    [MotherName] varchar(100) NULL,
    [Profession2] varchar(100) NULL,
    [PassportNo] varchar(100) NULL,
    [AutoGenRecurringServiceInv] char(1) NOT NULL CONSTRAINT [DF_Patient_AutoGenRecurringServiceInv] DEFAULT ('N'),
    [RecurringServicesChargedOn] datetime NULL,
    [ServiceInvCode] int NULL,
    [AgeYears] smallint NULL,
    [AgeMonths] smallint NULL,
    [AgeDays] smallint NULL,
    [PrincipalPatient] int NULL,
    [Allergies] varchar(100) NULL,
    [CountyCode] smallint NULL,
    [LicenseExpiry] datetime NULL,
    [FatherHusband] char(1) NULL,
    [MemberShipID] varchar(20) NOT NULL,
    [IsPrincipalPatient] char(1) NOT NULL CONSTRAINT [DF_Patient_IsPrincipalPatient] DEFAULT ('N'),
    CONSTRAINT [PK_Patient_2__11] PRIMARY KEY CLUSTERED ([PatientCode]),
    CONSTRAINT [RegNoUK] UNIQUE ([RegNo]),
    CONSTRAINT [UK_Patient_MemberShipID] UNIQUE ([MemberShipID]),
    CONSTRAINT [PatientGednerCHK] CHECK ([gender] = 'M' or [Gender] = 'F' or [Gender] = 'O')
);
GO

CREATE TABLE [dbo].[PatientAdmission] (
    [AdmissionCode] int NOT NULL,
    [PatientCode] int NOT NULL,
    [LocationCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [DoctorCode] smallint NULL,
    [Discharged1] char(1) NOT NULL CONSTRAINT [DF_PatientAdmission_Discharged1] DEFAULT ('N'),
    [Discharged1On] datetime NULL,
    [Discharged1By] smallint NULL,
    [Discharged] char(1) NOT NULL CONSTRAINT [DF_PatientAdmission_Discharged] DEFAULT ('N'),
    [DischargedOn] datetime NULL,
    [DischargedBy] smallint NULL,
    [Diagnosis] varchar(100) NULL,
    [DiseaseCode] smallint NOT NULL CONSTRAINT [DF_PatientAdmission_DiseaseCode] DEFAULT (1),
    [RecurringServicesChargedOn] datetime NULL,
    [ServiceInvCode] int NULL,
    [Remarks] varchar(100) NULL,
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_PatientAdmission_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_PatientAdmission_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_PatientAdmission_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_PatientAdmission_CashBack] DEFAULT (0),
    [NextOfKins] varchar(100) NULL,
    [RelationCode] smallint NULL,
    [NextOfKinsContactNo] varchar(100) NULL,
    [DischargeRefferalCode] smallint NULL,
    [DischargeNotes] varchar(1000) NULL,
    [CustCode] smallint NOT NULL CONSTRAINT [DF_PatientAdmission_CustCode] DEFAULT (19),
    [Ref1] varchar(100) NULL,
    [Ref2] varchar(100) NULL,
    [Ref3] varchar(100) NULL,
    [Ref4] varchar(100) NULL,
    [ProcedureRequired] int NULL,
    [ProcedureCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PatientAdmission_ProcedureCharges] DEFAULT (0),
    [ProcedureGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PatientAdmission_ProcedureGSTPerc] DEFAULT (0),
    [TransportCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PatientAdmission_TransportCharges] DEFAULT (0),
    [DischargeReasonCode] smallint NOT NULL CONSTRAINT [DF_PatientAdmission_DischargeReasonCode] DEFAULT (1),
    CONSTRAINT [PK_PatientAdmission] PRIMARY KEY CLUSTERED ([AdmissionCode])
);
GO

CREATE TABLE [dbo].[PatientCatAllowedModule] (
    [PatientCatCode] smallint NOT NULL,
    [ModuleID] smallint NOT NULL,
    CONSTRAINT [PK_PatientCategoryAllowedModule] PRIMARY KEY CLUSTERED ([PatientCatCode], [ModuleID])
);
GO

CREATE TABLE [dbo].[PatientCategory] (
    [PatientCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(12) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_PatientCategory_Counter] DEFAULT (0),
    CONSTRAINT [PK_PatientCategory_PatientCatCode] PRIMARY KEY CLUSTERED ([PatientCatCode]),
    CONSTRAINT [UK_PatientCategory_Name] UNIQUE ([Name]),
    CONSTRAINT [UK_PatientCategory_ShortName] UNIQUE ([ShortName])
);
GO

CREATE TABLE [dbo].[PatientFirstContact] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PatientFirstContact_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [DoctCode] smallint NOT NULL,
    [OptionCode] tinyint NOT NULL,
    [Details] varchar(255) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_PatientFirstContact_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_PatientFirstContact_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[PatientFirstContactOptions] (
    [OptionCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_PatientFirstContactOptions] PRIMARY KEY CLUSTERED ([OptionCode]),
    CONSTRAINT [UK_PatientFirstContactOptions_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[PatientImage] (
    [PatientCode] int NOT NULL,
    [ImageDescription] varchar(100) NULL,
    [ROWID] int NOT NULL,
    [PatientImage] image NULL,
    [ImageType] varchar(100) NULL,
    [AdmissionCode] int NULL,
    [VisitCode] int NULL,
    CONSTRAINT [PK_PatientImage] PRIMARY KEY CLUSTERED ([PatientCode], [ROWID])
);
GO

CREATE TABLE [dbo].[PatientLocation] (
    [LocationCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [WardCode] smallint NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_PatientLocation] PRIMARY KEY CLUSTERED ([LocationCode]),
    CONSTRAINT [IX_PatientLocation] UNIQUE ([Name], [WardCode])
);
GO

CREATE TABLE [dbo].[PatientModule] (
    [ModuleID] smallint NOT NULL,
    CONSTRAINT [PK_PatientModule] PRIMARY KEY CLUSTERED ([ModuleID])
);
GO

CREATE TABLE [dbo].[PatientRecServices] (
    [PatientCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_PatientRecServices_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PatientRecServices_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PatientRecServices_DiscPerc] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [SManCode] smallint NULL,
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_PatientRecServices_ServiceFlatDisc] DEFAULT (0),
    CONSTRAINT [PK_PatientRecServices] PRIMARY KEY CLUSTERED ([PatientCode], [ServiceCode])
);
GO

CREATE TABLE [dbo].[PatientTransfer] (
    [TransferCode] int NOT NULL,
    [AdmissionCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [SourceLocation] smallint NOT NULL,
    [TargetLocation] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [DoctCode] smallint NULL,
    CONSTRAINT [PK_PatientTransfer] PRIMARY KEY CLUSTERED ([TransferCode])
);
GO

CREATE TABLE [dbo].[pbcatcol] (
    [pbc_tnam] char(30) NULL,
    [pbc_tid] int NULL,
    [pbc_ownr] char(30) NULL,
    [pbc_cnam] char(30) NULL,
    [pbc_cid] smallint NULL,
    [pbc_labl] varchar(254) NULL,
    [pbc_lpos] smallint NULL,
    [pbc_hdr] varchar(254) NULL,
    [pbc_hpos] smallint NULL,
    [pbc_jtfy] smallint NULL,
    [pbc_mask] varchar(31) NULL,
    [pbc_case] smallint NULL,
    [pbc_hght] smallint NULL,
    [pbc_wdth] smallint NULL,
    [pbc_ptrn] varchar(31) NULL,
    [pbc_bmap] char(1) NULL,
    [pbc_init] varchar(254) NULL,
    [pbc_cmnt] varchar(254) NULL,
    [pbc_edit] varchar(31) NULL,
    [pbc_tag] varchar(254) NULL
);
GO

CREATE TABLE [dbo].[pbcatedt] (
    [pbe_name] varchar(30) NOT NULL,
    [pbe_edit] varchar(254) NULL,
    [pbe_type] smallint NOT NULL,
    [pbe_cntr] int NULL,
    [pbe_seqn] smallint NOT NULL,
    [pbe_flag] int NULL,
    [pbe_work] char(32) NULL
);
GO

CREATE TABLE [dbo].[pbcatfmt] (
    [pbf_name] varchar(30) NOT NULL,
    [pbf_frmt] varchar(254) NOT NULL,
    [pbf_type] smallint NOT NULL,
    [pbf_cntr] int NULL
);
GO

CREATE TABLE [dbo].[pbcattbl] (
    [pbt_tnam] char(30) NULL,
    [pbt_tid] int NULL,
    [pbt_ownr] char(30) NULL,
    [pbd_fhgt] smallint NULL,
    [pbd_fwgt] smallint NULL,
    [pbd_fitl] char(1) NULL,
    [pbd_funl] char(1) NULL,
    [pbd_fchr] smallint NULL,
    [pbd_fptc] smallint NULL,
    [pbd_ffce] char(18) NULL,
    [pbh_fhgt] smallint NULL,
    [pbh_fwgt] smallint NULL,
    [pbh_fitl] char(1) NULL,
    [pbh_funl] char(1) NULL,
    [pbh_fchr] smallint NULL,
    [pbh_fptc] smallint NULL,
    [pbh_ffce] char(18) NULL,
    [pbl_fhgt] smallint NULL,
    [pbl_fwgt] smallint NULL,
    [pbl_fitl] char(1) NULL,
    [pbl_funl] char(1) NULL,
    [pbl_fchr] smallint NULL,
    [pbl_fptc] smallint NULL,
    [pbl_ffce] char(18) NULL,
    [pbt_cmnt] varchar(254) NULL
);
GO

CREATE TABLE [dbo].[pbcatvld] (
    [pbv_name] varchar(30) NOT NULL,
    [pbv_vald] varchar(254) NOT NULL,
    [pbv_type] smallint NOT NULL,
    [pbv_cntr] int NULL,
    [pbv_msg] varchar(254) NULL
);
GO

CREATE TABLE [dbo].[PC] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PC_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ChestPain] char(1) NULL,
    [ChestpainSince] smallint NULL,
    [ChestPainTimeUnit] char(1) NULL,
    [ChestPainATypical] char(1) NULL,
    [ChestPainATypicalSince] smallint NULL,
    [ChestPainATypicalTimeUnit] char(1) NULL,
    [ShortnessofBreath] char(1) NULL,
    [ShortnessofBreathSince] smallint NULL,
    [ShortnessofBreathTimeUnit] char(1) NULL,
    [RelievedAtRestIncreaseOnExertion] char(1) NULL,
    [RelievedAtRestIncreaseOnExertionSince] smallint NULL,
    [RelievedAtRestIncreaseOnExertionTimeUnit] char(1) NULL,
    [ChestDiscomfort] char(1) NULL,
    [ChestDiscomfortSince] smallint NULL,
    [ChestDiscomforttimeUnit] char(1) NULL,
    [ChestHeavinessTightnessOnExertion] char(1) NULL,
    [ChestHeavinessTightnessOnExertionFor] smallint NULL,
    [ChestHeavinessTightnessOnExertionTimeUnit] char(1) NULL,
    [ChestHeavinessTightnessOnExertionReason] varchar(255) NULL,
    [PressureLikeSymtomsInChest] char(1) NULL,
    [PressureLikeSymtomsInChestSince] smallint NULL,
    [PressureLikeSymtomsInChestTimeUnit] char(1) NULL,
    [TypicalAnginaFunctionalClass] char(1) NULL,
    [TypicalAnginaFunctionalClassSince] smallint NULL,
    [TypicalAnginaFunctionalClassTimeUnit] char(1) NULL,
    [Type1AnginaFunctionalClass] char(1) NULL,
    [Type2AnginaFunctionalClass] char(1) NULL,
    [Type3AnginaFunctionalClass] char(1) NULL,
    [Type4AnginaFunctionalClass] char(1) NULL,
    [DysnaeonExertionFunctionalClass] char(1) NULL,
    [DysnaeonExertionFunctionalClassSince] smallint NULL,
    [DysnaeonExertionFunctionalClassTimeUnit] char(1) NULL,
    [Type1DysnaeonExertionFunctionalClass] char(1) NULL,
    [Type2DysnaeonExertionFunctionalClass] char(1) NULL,
    [Type3DysnaeonExertionFunctionalClass] char(1) NULL,
    [Type4DysnaeonExertionFunctionalClass] char(1) NULL,
    [SyncopeWithHOFall] char(1) NULL,
    [SyncopeWithHOFallSince] smallint NULL,
    [SyncopeWithHOFallTimeUnit] char(1) NULL,
    [SyncopeWithHOFallDetail] varchar(255) NULL,
    [SyncopeWithNoHOFall] char(1) NULL,
    [SyncopeWithNoHOFallSince] smallint NULL,
    [SyncopeWithNoHOFallTimeUnit] char(1) NULL,
    [SyncopeWithNoHOFallDetail] varchar(255) NULL,
    [PatientPresentation] char(1) NULL,
    [PatientPresentationDetails] varchar(255) NULL,
    [Palpitations] char(1) NULL,
    [PalpitationsSince] smallint NULL,
    [PalpitationsTimeUnit] char(1) NULL,
    [Vertigo] char(1) NULL,
    [VertigoSince] smallint NULL,
    [VertigoTimeUnit] char(1) NULL,
    [Headache] char(1) NULL,
    [HeadacheSince] smallint NULL,
    [HeadacheTimeUnit] char(1) NULL,
    [Faintness] char(1) NULL,
    [FaintnessSince] smallint NULL,
    [FaintnessTimeUnit] char(1) NULL,
    [Dizziness] char(1) NULL,
    [DizzinessSince] smallint NULL,
    [DizzinessTimeUnit] char(1) NULL,
    [PreSyncope] char(1) NULL,
    [PreSyncopeSince] smallint NULL,
    [PreSyncopeTimeUnit] char(1) NULL,
    [Fever] char(1) NULL,
    [FeverSince] smallint NULL,
    [FeverTimeUnit] char(1) NULL,
    [PaininLeftLeg] char(1) NULL,
    [PaininLeftLegSince] smallint NULL,
    [PaininLeftLegTimeUnit] char(1) NULL,
    [PaininRightLeg] char(1) NULL,
    [PaininRightLegSince] smallint NULL,
    [PaininRightLegTimeUnit] char(1) NULL,
    [PaininLeftArm] char(1) NULL,
    [PaininLeftArmSince] smallint NULL,
    [PaininLeftArmTimeUnit] char(1) NULL,
    [PaininRightArm] char(1) NULL,
    [PaininRightArmSince] smallint NULL,
    [PaininRightArmTimeUnit] char(1) NULL,
    [PaininLowerLimb] char(1) NULL,
    [PaininLowerLimbSince] smallint NULL,
    [PaininLowerLimbTimeUnit] char(1) NULL,
    [PaininUpperLimb] char(1) NULL,
    [PaininUpperLimbSince] smallint NULL,
    [PaininUpperLimbTimeUnit] char(1) NULL,
    [PaininAbdomen] char(1) NULL,
    [PaininAbdomenSince] smallint NULL,
    [PaininAbdomenTimeUnit] char(1) NULL,
    [MusculoskeletonPain] char(1) NULL,
    [MusculoskeletonPainSince] smallint NULL,
    [MusculoskeletonPainTimeUnit] char(1) NULL,
    [OtherComplaints] varchar(255) NULL,
    [ReceivedDead] char(1) NULL,
    [IssueDeathCertificate] char(1) NULL,
    [Diabetic] char(1) NULL,
    [DiabeticSince] smallint NULL,
    [DiabeticTimeUnit] char(1) NULL,
    [HyperTension] char(1) NULL,
    [HyperTensionSince] smallint NULL,
    [HyperTensionTimeUnit] char(1) NULL,
    [Smoking] char(1) NULL,
    [SmokingSince] smallint NULL,
    [SmokingTimeUnit] char(1) NULL,
    [Obesity] char(1) NULL,
    [ObesitySince] smallint NULL,
    [ObesityTimeUnit] char(1) NULL,
    [FamilyIHD] char(1) NULL,
    [FamilyIHDToMother] char(1) NULL,
    [FamilyIHDToFather] char(1) NULL,
    [FamilyIHDToSiblings] char(1) NULL,
    [FamilyIHDTo] varchar(255) NULL,
    [OtherCardiacComplaints] varchar(255) NULL,
    [COPD] char(1) NULL,
    [Asthma] char(1) NULL,
    [CVA] char(1) NULL,
    [CKD] char(1) NULL,
    [CLD] char(1) NULL,
    [Allergy] char(1) NULL,
    [AllergyDetails] varchar(255) NULL,
    [OtherComorbidCondition] varchar(255) NULL,
    [PastHistoryIHD] char(1) NULL,
    [PastHistoryIHDSince] smallint NULL,
    [PastHistoryIHDTimeUnit] char(1) NULL,
    [PastHistorySTEMI] char(1) NULL,
    [PastHistorySTEMISince] smallint NULL,
    [PastHistorySTEMITimeUnit] char(1) NULL,
    [PastHistoryNSTEMI] char(1) NULL,
    [PastHistoryNSTEMISince] smallint NULL,
    [PastHistoryNSTEMITimeUnit] char(1) NULL,
    [PastHistoryUSA] char(1) NULL,
    [PastHistoryUSASince] smallint NULL,
    [PastHistoryUSATimeUnit] char(1) NULL,
    [PastHistoryACS] char(1) NULL,
    [PastHistoryACSSince] smallint NULL,
    [PastHistoryACSTimeUnit] char(1) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_PC_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_PC_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[PCT] (
    [PCTCode] int NOT NULL,
    [Description] varchar(100) NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_PCT_PCTCode] PRIMARY KEY CLUSTERED ([PCTCode]),
    CONSTRAINT [UK_PCT_Description] UNIQUE ([Description])
);
GO

CREATE TABLE [dbo].[PhysicalExam] (
    [PhysicalExamCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(400) NULL,
    [OrganCode] smallint NULL,
    CONSTRAINT [PK_PhysicalExam_PhysicalExamCode] PRIMARY KEY CLUSTERED ([PhysicalExamCode])
);
GO

CREATE TABLE [dbo].[POPolicy] (
    [POPolicyCode] int NOT NULL,
    [AliasName] varchar(12) NOT NULL,
    [NAME] varchar(100) NOT NULL,
    [Remarks] varchar(400) NULL,
    CONSTRAINT [PK_POPolicy_POPolicyCode] PRIMARY KEY CLUSTERED ([POPolicyCode]),
    CONSTRAINT [UK_POPolicy_Name] UNIQUE ([NAME]),
    CONSTRAINT [UK_POPolicy_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[POPolicyDetail] (
    [POPolicyCode] int NOT NULL,
    [WeekDayCode] tinyint NOT NULL,
    [WeekOfMonth] tinyint NOT NULL,
    CONSTRAINT [PK_POPolicyDetail] PRIMARY KEY CLUSTERED ([POPolicyCode], [WeekDayCode], [WeekOfMonth])
);
GO

CREATE TABLE [dbo].[PostedInvoiceEditingLog] (
    [LogId] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PostedInvoiceEditingLog_Date] DEFAULT (getdate()),
    [DocumentType] varchar(20) NOT NULL,
    [DocumentCode] int NOT NULL,
    [Machine] varchar(100) NOT NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_PostedInvoiceEditingLog_LogID] PRIMARY KEY CLUSTERED ([LogId])
);
GO

CREATE TABLE [dbo].[PRAllocationDetail] (
    [PRAllocationCode] int NOT NULL,
    [PurInvCode] int NOT NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PRAllocationDetail_OutstandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_PRAllocationDetail_Amt] DEFAULT (0),
    [PRAllocationROWID] int IDENTITY(1,1) NOT NULL,
    [PRAllocationUTN] bigint NOT NULL,
    CONSTRAINT [PK_PRAllocationDetail] PRIMARY KEY CLUSTERED ([PRAllocationCode], [PurInvCode])
);
GO

CREATE TABLE [dbo].[PRAllocationHeader] (
    [PRAllocationCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [PRInvCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [Modified] char(1) NOT NULL CONSTRAINT [DF_PRAllocationHeader_Modified] DEFAULT ('N'),
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PRAllocationHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PRAllocationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_PRAllocationHeader] PRIMARY KEY CLUSTERED ([PRAllocationCode])
);
GO

CREATE TABLE [dbo].[PRdetail] (
    [PRInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PRdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PRdetail_LooseQty] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PRdetail_BonusQty] DEFAULT (0),
    [PackUnits] int NOT NULL,
    [PRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PRDetail_PRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PRDetail_AvgPrice] DEFAULT (0),
    [PackSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PRDetail_PackSalePrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_PRDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PRdetail_GSTPerc_1__10] DEFAULT (0),
    [PrUtn] bigint NULL,
    [ItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_PRDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_PRDetail_PiecesInHand] DEFAULT (0),
    [PrRowId] int IDENTITY(1,1) NOT NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [HistoricalBatch] varchar(100) NULL,
    [BalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_PRDetail_BalanceStock] DEFAULT (0),
    CONSTRAINT [PK_PRdetail] PRIMARY KEY CLUSTERED ([PRInvCode], [ICode], [Gcode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[Precaution] (
    [PrecautionCode] smallint NOT NULL,
    [Name] varchar(255) NOT NULL,
    [LocalPrecaution] nvarchar(500) NULL,
    CONSTRAINT [PK_Precaution] PRIMARY KEY CLUSTERED ([PrecautionCode]),
    CONSTRAINT [UK_Precaution_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Preferences] (
    [UserId] smallint NOT NULL CONSTRAINT [DF_Preference_UserId_12__16] DEFAULT (1),
    [QuartTerms1] varchar(100) NULL,
    [PageSize] char(1) NOT NULL CONSTRAINT [DF_Preference_PageSize_7__16] DEFAULT ('Q'),
    [HeaderNo] tinyint NOT NULL CONSTRAINT [DF_Preference_HeaderNo_3__16] DEFAULT (1),
    [POFooter] varchar(100) NULL,
    [ItemDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Preference_ItemDiscPer5__16] DEFAULT (0),
    [InvDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Preference_InvDiscPerc4__16] DEFAULT (0),
    [Batch] varchar(15) NOT NULL CONSTRAINT [DF_Preference_Batch_1__16] DEFAULT ('.'),
    [Expiry] smallint NOT NULL CONSTRAINT [DF_Preference_Expiry_2__16] DEFAULT (365),
    [UpdateSalePrice] char(1) NOT NULL CONSTRAINT [DF_Preference_UpdateSale11__16] DEFAULT ('N'),
    [UpdatePurPrice] char(1) NOT NULL CONSTRAINT [DF_Preference_UpdatePurP10__16] DEFAULT ('N'),
    [ReorderLevel] int NOT NULL CONSTRAINT [DF_Preference_ReorderLeve9__16] DEFAULT (100),
    [OptimumLevel] int NOT NULL CONSTRAINT [DF_Preference_OptimumLeve6__16] DEFAULT (1000),
    [Priority] tinyint NOT NULL CONSTRAINT [DF_Preference_Priority_8__16] DEFAULT (10),
    [Act1] varchar(100) NULL,
    [Act2] varchar(100) NULL,
    [Act3] varchar(100) NULL,
    [DefaultGcode] int NULL,
    [SaleGodownOption] tinyint NULL,
    [PurchaseGodownOption] tinyint NULL,
    [RetailSalePosting] char(1) NULL CONSTRAINT [DF_Preference_SalePosting1__14] DEFAULT ('Y'),
    [Salesalesmanwindow] char(1) NULL CONSTRAINT [DF_Preference_Salesalesma1__11] DEFAULT ('Y'),
    [InSaleCustomerBalance] char(1) NULL CONSTRAINT [DF_Preference_InSaleCusto2__11] DEFAULT ('Y'),
    [ItemFlatDisc] char(1) NULL CONSTRAINT [DF_Preference_ItemFlatDis3__11] DEFAULT ('Y'),
    [MultiGodown] char(1) NULL CONSTRAINT [DF_Preference_MultiGodown4__11] DEFAULT ('Y'),
    [HeaderOnSaleInv] char(1) NULL CONSTRAINT [DF_Preference_HeaderOnSal1__14] DEFAULT ('N'),
    [PurBatch] char(1) NULL CONSTRAINT [DF_Preference_PurBatch_1__14] DEFAULT ('Y'),
    [PurExpiry] char(1) NULL CONSTRAINT [DF_Preference_PurExpiry_2__14] DEFAULT ('Y'),
    [SaleInvFormat] char(4) NULL CONSTRAINT [DF_Preference_SaleInvForm1__12] DEFAULT ('FZ'),
    [DueItem] char(1) NULL CONSTRAINT [DF_Preference_DueItem_1__12] DEFAULT ('Y'),
    [RefreshTime] int NULL CONSTRAINT [DF_Preference_RefreshTime1__11] DEFAULT (5),
    [SaleItemDescription] char(1) NULL CONSTRAINT [DF_Preference_SaleItemDis1__13] DEFAULT ('N'),
    [ItemName] char(1) NULL CONSTRAINT [DF_Preference_ItemName_1__14] DEFAULT ('N'),
    [Manufacturer] char(1) NULL CONSTRAINT [DF_Preference_Manufacture2__14] DEFAULT ('N'),
    [Packing] char(1) NULL CONSTRAINT [DF_Preference_Packing_3__14] DEFAULT ('N'),
    [PackUnits] char(1) NULL CONSTRAINT [DF_Preference_PackUnits_4__14] DEFAULT ('N'),
    [SalePrice] char(1) NULL CONSTRAINT [DF_Preference_SalePrice_5__14] DEFAULT ('N'),
    [Stock] char(1) NULL CONSTRAINT [DF_Preference_Stock_6__14] DEFAULT ('N'),
    [ItemCode] char(1) NULL CONSTRAINT [DF_Preference_ItemCode_1__10] DEFAULT ('N'),
    [Priceinloosepur] char(1) NULL CONSTRAINT [DF_Preference_Priceinloos1__15] DEFAULT ('N'),
    [TransferGodownOption] tinyint NULL,
    [CaSPNo] char(1) NULL CONSTRAINT [DF_Preference_CaSPNo_1__16] DEFAULT ('N'),
    [CrSPNo] char(1) NULL CONSTRAINT [DF_Preference_CrSPNo_2__16] DEFAULT ('N'),
    [SalePriceInPackpur] char(1) NULL CONSTRAINT [DF_Preference_PriceInPack1__11] DEFAULT ('N'),
    [UpdatePurDisc] char(1) NULL CONSTRAINT [DF_Preference_UpdatePurDi1__10] DEFAULT ('N'),
    [AliasName] char(1) NULL CONSTRAINT [DF_Preference_AliasName_1__10] DEFAULT ('N'),
    [SaleDoctId] char(1) NULL CONSTRAINT [DF_Preference_SaleDoctId_1__12] DEFAULT ('N'),
    [ServiceDoctId] char(1) NULL CONSTRAINT [DF_Preference_ServiceDoct2__12] DEFAULT ('N'),
    [Issueposting] char(1) NULL CONSTRAINT [DF_Preference_Issuepostin1__10] DEFAULT ('N'),
    [ItemDefaultCategory] smallint NULL,
    [ItemDefaultClass] smallint NULL,
    [ItemDefaultManfcode] smallint NULL,
    [ItemDefaultPackCode] smallint NULL,
    [ItemDefaultAssociatedGCode] smallint NULL,
    [PromptBeforePrinting] char(1) NULL CONSTRAINT [DF_Preference_PromptBefor1__11] DEFAULT ('N'),
    [SalePromptForReorder] char(1) NULL CONSTRAINT [DF_Preference_SalePromptF2__10] DEFAULT ('N'),
    [CustBalanceOnPrintOut] char(1) NULL CONSTRAINT [DF_Preference_CustBalance1__10] DEFAULT ('N'),
    [GroupCategoryRights] char(1) NULL CONSTRAINT [DF_Preference_GroupCatego3__10] DEFAULT ('N'),
    [DefaultHeaderOnRetailSale] smallint NULL,
    [DefaultHeaderOnCreditSale] smallint NULL,
    [CreditInvFoooter] varchar(255) NULL,
    [CreditSalePosting] char(1) NULL CONSTRAINT [DF_Preference_CreditSaleP1__10] DEFAULT ('N'),
    [FullPageFooter] text NULL,
    [PatientOnRetailSale] char(1) NULL CONSTRAINT [DF_Preference_PatientOnRe2__11] DEFAULT ('N'),
    [PatientOnCreditSale] char(1) NULL CONSTRAINT [DF_Preference_PatientOnCr1__11] DEFAULT ('N'),
    [VisibleSaleCategory] char(1) NULL CONSTRAINT [DF_Preference_VisibleSale1__10] DEFAULT ('N'),
    [SaleCashWindow] char(1) NULL,
    [DisplayPool] char(1) NULL CONSTRAINT [DF_Preference_DisplayPool2__11] DEFAULT ('N'),
    [CashDrawer] char(1) NULL CONSTRAINT [DF_Preference_CashDrawer_1__11] DEFAULT ('N'),
    [VisiblePORB] char(1) NULL CONSTRAINT [DF_Preference_VisiblePORB1__11] DEFAULT ('N'),
    [QuartTerms2] varchar(100) NULL,
    [FullPageFooter2] varchar(150) NULL,
    [ItemGSTPerc] char(1) NULL CONSTRAINT [DF_Preference_ItemGSTPerc2__11] DEFAULT ('N'),
    [ItemUnitTax] char(1) NULL CONSTRAINT [DF_Preference_ItemUnitTax3__11] DEFAULT ('N'),
    [InvGSTPerc] char(1) NULL CONSTRAINT [DF_Preference_InvGSTPerc_1__11] DEFAULT ('N'),
    [SaleOnZeroPrice] char(1) NULL CONSTRAINT [DF_Preference_SaleOnZeroP1__11] DEFAULT ('N'),
    [WarantyLine1] varchar(150) NULL,
    [WarantyLine2] varchar(150) NULL,
    [WarantyLine3] varchar(150) NULL,
    [WarantyLine4] varchar(150) NULL,
    [WarantyLine5] varchar(150) NULL,
    [WarantyLine6] varchar(150) NULL,
    [WarantyLine7] varchar(150) NULL,
    [OwnerTaxRegNo] varchar(100) NULL,
    [WarantyLine8] varchar(150) NULL,
    [MaxAllowDate] smallint NULL,
    [BonusInSale] char(1) NULL CONSTRAINT [DF_Preferences_BonusInSale] DEFAULT ('N'),
    [DisplayWaranty] char(1) NULL CONSTRAINT [DF_Preferences_DisplayWaranty] DEFAULT ('N'),
    [DefaultWaranty] char(1) NULL CONSTRAINT [DF_Preferences_DefaultWaranty] DEFAULT ('N'),
    [SaleInvBatch] char(1) NULL CONSTRAINT [DF_Preferences_SaleInvBatch] DEFAULT ('N'),
    [MessageInSale] char(1) NULL CONSTRAINT [DF_Preferences_MessageInSale] DEFAULT ('N'),
    [SalesManInSale] char(1) NULL CONSTRAINT [DF_Preferences_InvoiceSize] DEFAULT ('N'),
    [InvSizeInSale] char(1) NULL CONSTRAINT [DF_Preferences_InvSizeInSale] DEFAULT ('N'),
    [SaleCustRefno2] char(1) NULL CONSTRAINT [DF_Preferences_SaleCustRef2] DEFAULT ('N'),
    [SaleCustRefno3] char(1) NULL CONSTRAINT [DF_Preferences_SaleCustRef3] DEFAULT ('N'),
    [SaleCustRefno4] char(1) NULL CONSTRAINT [DF_Preferences_SaleCustRef4] DEFAULT ('N'),
    [AliasNameInTrans] char(1) NULL CONSTRAINT [DF_Preferences_AliasNameInTrans] DEFAULT ('N'),
    [QuotationTerms1] varchar(150) NULL,
    [QuotationTerms2] varchar(150) NULL,
    [QuotationTerms3] varchar(150) NULL,
    [QuotationTerms4] varchar(150) NULL,
    [PurUserWindow] char(1) NULL CONSTRAINT [DF_Preferences_PurUserWindow] DEFAULT ('N'),
    [TransUserWindow] char(1) NULL CONSTRAINT [DF_Preferences_TransUserWindow] DEFAULT ('N'),
    [ItemLocation] char(1) NULL CONSTRAINT [DF_Preferences_ItemLocation] DEFAULT ('N'),
    [BonusInPurchase] char(1) NULL CONSTRAINT [DF_Preferences_BonusInPurchase] DEFAULT ('N'),
    [SaleAskForCopies] char(1) NULL CONSTRAINT [DF_Preferences_SaleAskForCopies] DEFAULT ('N'),
    [PromptStockInPOS] char(1) NULL CONSTRAINT [DF_Preferences_PromptStockInPOS] DEFAULT ('N'),
    [QuotationTerms5] varchar(150) NULL,
    [QuotationTerms6] varchar(150) NULL,
    [QuotationTerms7] varchar(150) NULL,
    [QuotationTerms8] varchar(150) NULL,
    [SalesManInService] char(1) NULL CONSTRAINT [DF_Preferences_SalesManInService] DEFAULT ('N'),
    [ServiceCategory] char(1) NULL CONSTRAINT [DF_Preferences_ServiceCategory] DEFAULT ('N'),
    [DefaultItemLockSaleprice] char(1) NULL CONSTRAINT [DF_Preferences_DefaultItemLockSaleprice] DEFAULT ('N'),
    [DefaultItemlockDiscPerc] char(1) NULL CONSTRAINT [DF_Preferences_DefaultItemDiscPerc] DEFAULT ('N'),
    [InServiceCustomerBalance] char(1) NULL CONSTRAINT [DF__Preferenc__InSer__17ED6F58] DEFAULT ('N'),
    [DisplayPoolCompany] varchar(50) NULL,
    [ServiceSalesManWindow] char(1) NULL CONSTRAINT [DF__PREFERENC__Servi__25476A76] DEFAULT ('N'),
    [SaleDisplayItemDiscPerc] char(1) NULL CONSTRAINT [DF__preferenc__SaleD__2ED0D4B0] DEFAULT ('N'),
    [SaleAvgPriceCheck] char(1) NULL CONSTRAINT [DF__preferenc__SaleA__2FC4F8E9] DEFAULT ('N'),
    [CashDrawerPrinter] varchar(50) NULL,
    [CashDrawerWithPrinter] char(1) NULL CONSTRAINT [DF__PREFERENC__CashD__339589CD] DEFAULT ('N'),
    [ServiceOrderPosting] char(1) NULL CONSTRAINT [DF__Preferenc__Servi__3D1EF407] DEFAULT ('N'),
    [saleclaimable] char(1) NOT NULL CONSTRAINT [df_preferences_claimable] DEFAULT ('N'),
    [pursuppbalance] char(1) NOT NULL CONSTRAINT [df_preference_pursuppbalance] DEFAULT ('N'),
    [HeaderOnPurchaseInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnPurchaseInv] DEFAULT ('N'),
    [HeaderOnTransferInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnTransferInv] DEFAULT ('N'),
    [HeaderOnAdjustmentInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnAdjustmentInv] DEFAULT ('N'),
    [DiscPercInRetail] char(1) NOT NULL CONSTRAINT [df_prferences_DiscpercInRetail] DEFAULT ('Y'),
    [DiscPercInCredit] char(1) NOT NULL CONSTRAINT [df_prferences_DiscpercInCredit] DEFAULT ('Y'),
    [HeaderOnSaleReturnInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnSaleReturnInv] DEFAULT ('N'),
    [HeaderOnPurchaseReturnInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnPurchaseReturnInv] DEFAULT ('N'),
    [PatientOnRetailSalePopUpWindow] char(1) NULL CONSTRAINT [DF__PREFERENC__Patie__3B01A16B] DEFAULT ('N'),
    [PatientOnCreditSalePopUpWindow] char(1) NULL CONSTRAINT [DF__PREFERENC__Patie__3BF5C5A4] DEFAULT ('N'),
    [CreditSaleAutoPopUpWindow] char(1) NULL CONSTRAINT [DF__PREFERENC__Credi__3CE9E9DD] DEFAULT ('N'),
    [HeaderOnIssueInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnIssueInv] DEFAULT ('N'),
    [HeaderOnReceiptInv] char(1) NOT NULL CONSTRAINT [df_preferences_HeaderOnReceiptInv] DEFAULT ('N'),
    [DefaultComPort] tinyint NULL CONSTRAINT [DF__PREFERENC__Defau__3FC65688] DEFAULT (2),
    [PatientInTransaction] char(1) NOT NULL CONSTRAINT [df_preferences_PatientInTransaction] DEFAULT ('N'),
    [PurOrderTerms1] varchar(150) NULL,
    [PurOrderTerms2] varchar(150) NULL,
    [PurOrderTerms3] varchar(150) NULL,
    [PurOrderTerms4] varchar(150) NULL,
    [PurOrderTerms5] varchar(150) NULL,
    [PurOrderTerms6] varchar(150) NULL,
    [PurOrderTerms7] varchar(150) NULL,
    [PurOrderTerms8] varchar(150) NULL,
    [SaleCheckExpiry] char(1) NOT NULL CONSTRAINT [df_salecheckexpiry] DEFAULT ('N'),
    [saleexpirydays] int NOT NULL CONSTRAINT [df_saleexpirydays] DEFAULT (100),
    [cashsaleautopostingtime] int NULL CONSTRAINT [DF__Preferenc__cashs__4FFCBE51] DEFAULT (10),
    [creditsaleautopostingtime] int NULL CONSTRAINT [DF__Preferenc__credi__50F0E28A] DEFAULT (10),
    [puritemdescription] char(1) NOT NULL CONSTRAINT [df_preferences_puritemdescription] DEFAULT ('N'),
    [PreserveSaleInvHistory] char(1) NOT NULL CONSTRAINT [df_preferences_PreserveSaleInvHistory] DEFAULT ('N'),
    [UnpostedCustSaleInvAlert] char(1) NOT NULL CONSTRAINT [df_preferences_UnpostedCustSaleInvAlert] DEFAULT ('N'),
    [UpdSaleUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__UpdSa__2F5AE495] DEFAULT ('N'),
    [ModSaleUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__ModSa__304F08CE] DEFAULT ('N'),
    [UpdSPriceUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__UpdSP__31432D07] DEFAULT ('N'),
    [UpdBonusQtyUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__UpdBo__32375140] DEFAULT ('N'),
    [UpdDiscPercUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__UpdDi__332B7579] DEFAULT ('N'),
    [UpdFlatDiscUsingCustLatestSale] char(1) NULL CONSTRAINT [DF__PREFERENC__UpdFl__341F99B2] DEFAULT ('N'),
    [PurchaseReturnPosting] char(1) NULL CONSTRAINT [DF__PREFERENC__Purch__3607E224] DEFAULT ('N'),
    [POS_ItemFlatDisc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__74F938D6] DEFAULT ('N'),
    [POS_ItemGstPerc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__75ED5D0F] DEFAULT ('N'),
    [POS_ItemUnitTax] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__76E18148] DEFAULT ('N'),
    [POS_InvGstPerc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__77D5A581] DEFAULT ('N'),
    [POS_SalesMan] char(1) NULL CONSTRAINT [DF__Preferenc__POS_S__78C9C9BA] DEFAULT ('N'),
    [POS_InvSize] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__79BDEDF3] DEFAULT ('N'),
    [POS_ItemDiscPerc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__7AB2122C] DEFAULT ('N'),
    [POS_MiscCharges] char(1) NULL CONSTRAINT [DF__Preferenc__POS_M__7BA63665] DEFAULT ('N'),
    [POS_InvDiscPerc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__7C9A5A9E] DEFAULT ('N'),
    [POS_InvFlatDisc] char(1) NULL CONSTRAINT [DF__Preferenc__POS_I__7D8E7ED7] DEFAULT ('N'),
    [ShowAllInvInCreditSaleList] char(1) NULL CONSTRAINT [DF__Preferenc__ShowA__137DBFF6] DEFAULT ('N'),
    [SetCustWiseItemInfo] char(1) NULL CONSTRAINT [DF__Preferenc__SetCu__1471E42F] DEFAULT ('N'),
    [PurReplaceItemSaleDisc] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurReplaceItemSaleDisc] DEFAULT ('N'),
    [GroupCustomerCategory] char(1) NULL CONSTRAINT [DF__Preferenc__Group__20D7BB14] DEFAULT (1),
    [GroupCustCatInBasicData] char(1) NULL CONSTRAINT [DF__Preferenc__Group__2878DCDC] DEFAULT ('N'),
    [GroupCustCatInTrans] char(1) NULL CONSTRAINT [DF__Preferenc__Group__296D0115] DEFAULT ('N'),
    [GroupItemCatInBasicData] char(1) NOT NULL CONSTRAINT [DF__Preferenc__Group__49D9D0A7] DEFAULT ('N'),
    [SaleCopyItemRemarks] char(1) NOT NULL CONSTRAINT [DF_preferences_SaleCopyItemremarks] DEFAULT ('N'),
    [ShowAccountForinSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowAccountForinSale] DEFAULT ('N'),
    [ShowAccountForinSaleReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowAccountForinSaleReturn] DEFAULT ('N'),
    [ShowAccountForinPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowAccountForinPurchase] DEFAULT ('N'),
    [ShowAccountForinPurchaseReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowAccountForinPurchaseReturn] DEFAULT ('N'),
    [SaleAccountFor] char(1) NOT NULL CONSTRAINT [DF_Preferences_SaleAccountFor] DEFAULT ('Y'),
    [SaleReturnAccountFor] char(1) NOT NULL CONSTRAINT [DF_Preferences_SaleReturnAccountFor] DEFAULT ('Y'),
    [PurchaseAccountFor] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurchaseAccountFor] DEFAULT ('Y'),
    [PurchaseReturnAccountFor] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurchaseReturnAccountFor] DEFAULT ('Y'),
    [AskAmtOnCreditSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskAmtOnCreditSale] DEFAULT ('N'),
    [SalePaymentMode] char(1) NULL,
    [SalePaymentAccCode] smallint NULL,
    [AskAmtOnCreditSaleReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskAmtOnCreditSaleReturn] DEFAULT ('N'),
    [SaleReturnPaymentMode] char(1) NULL,
    [SaleReturnPaymentAccCode] smallint NULL,
    [AskAmtOnPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskAmtOnPurchase] DEFAULT ('N'),
    [PurchasePaymentMode] char(1) NULL,
    [PurchasePaymentAccCode] smallint NULL,
    [AskAmtOnPurchaseReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskAmtOnPurchaseReturn] DEFAULT ('N'),
    [PurchaseReturnPaymentMode] char(1) NULL,
    [PurchaseReturnPaymentAccCode] smallint NULL,
    [AskDateInTrans] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskDateInTrans] DEFAULT ('Y'),
    [VoucherPrintingFormat] smallint NOT NULL CONSTRAINT [DF_Preferences_VoucherPrintingFormat] DEFAULT (1),
    [VoucherPrintingPageSize] char(1) NOT NULL CONSTRAINT [DF_Preferences_VoucherPrintingPageSize] DEFAULT ('F'),
    [MerckDistCode] varchar(20) NOT NULL CONSTRAINT [DF_Preferences_MerckDistCode] DEFAULT ('90'),
    [OutputFilePath] varchar(200) NOT NULL CONSTRAINT [DF_Preferences_OutputFilePath] DEFAULT ('C:\'),
    [ShowPurchaseTypeInPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPurchaseTypeInPurchase] DEFAULT ('Y'),
    [ShowPurchaseOrderInPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPurchaseOrderInPurchase] DEFAULT ('Y'),
    [AllowDupItemsInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowDupItemsInSale] DEFAULT ('N'),
    [itempackingdesc] char(1) NOT NULL CONSTRAINT [df_preferences_itempackingdesc] DEFAULT ('N'),
    [DefaultBatch] varchar(10) NOT NULL CONSTRAINT [DF_Preferences_DefaultBatch] DEFAULT ('.'),
    [DefaultExpiry] datetime NOT NULL CONSTRAINT [DF_Preferences_DefaultExpiry] DEFAULT (convert(varchar(10),dateadd(year,5,getdate()),101) + ' 00:00:00.000'),
    [SaleDefaultPrintBatch] char(1) NOT NULL CONSTRAINT [DF_pereferences_SaleDefaultPrintBatch] DEFAULT ('Y'),
    [UpdateSalePriceForItem] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdateSalePriceForItem] DEFAULT ('N'),
    [PurchaseOnZeroPrice] char(1) NOT NULL CONSTRAINT [DF_preferences_purchaseonzeroprice] DEFAULT ('Y'),
    [AskUserPasswordInItem] char(1) NOT NULL CONSTRAINT [DF_PREFERENCES_AskUserPasswordInItem] DEFAULT ('N'),
    [SaleReturnPageSize] char(1) NOT NULL CONSTRAINT [DF_preferences_SaleReturnPageSize] DEFAULT ('Q'),
    [ShowClaimableDiscPercInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowClaimableDiscPercInSale] DEFAULT ('N'),
    [AppName] varchar(30) NULL,
    [SalesPersonInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_SalesPersonInIssue] DEFAULT ('Y'),
    [IssueTypeInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_IssueTypeInIssue] DEFAULT ('Y'),
    [SectionInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_SectionInIssue] DEFAULT ('Y'),
    [AreaInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_AreaInIssue] DEFAULT ('Y'),
    [SalesPersonInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_SalesPersonInReceipt] DEFAULT ('Y'),
    [SectionInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_SectionInReceipt] DEFAULT ('Y'),
    [AreaInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_AreaInReceipt] DEFAULT ('Y'),
    [BarCodePriceStartsWith] varchar(3) NOT NULL CONSTRAINT [DF_Preferences_BarCodePriceStartsWith] DEFAULT (''),
    [BarCodePriceEndsWith] varchar(3) NOT NULL CONSTRAINT [DF_Preferences_BarCodePriceEndsWith] DEFAULT (''),
    [PurReplaceItemSalediscno] int NOT NULL CONSTRAINT [DF_Preferences_PurReplaceItemSaleDiscNo] DEFAULT (1),
    [SaveBalanceOnSalePosting] char(1) NOT NULL CONSTRAINT [DF_PREFERENCES_SaveBalanceOnSalePosting] DEFAULT ('N'),
    [PrintBalanceOnPostedSales] char(1) NOT NULL CONSTRAINT [DF_PREFERENCES_PrintBalanceOnPostedSales] DEFAULT ('N'),
    [PurchaseAutoPosting] char(1) NOT NULL CONSTRAINT [DF_PREFERENCES_PurchaseAutoPosting] DEFAULT ('N'),
    [VochCatForPriceAdj] smallint NOT NULL CONSTRAINT [DF_PREFERENCES_VochCatForPriceAdj] DEFAULT (18),
    [UseBarCodePrinter] char(1) NOT NULL CONSTRAINT [DF_Preferences_UseBarCodePrinter] DEFAULT ('N'),
    [BarCodePrinterName] char(60) NULL,
    [CashDrawerComPort] tinyint NOT NULL CONSTRAINT [DF_Preferences_CashDrawerComPort] DEFAULT (2),
    [ShowHeaderInBarCodeModule] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowHeaderInBarCodeModule] DEFAULT ('Y'),
    [ShowStartsEndsInBarCodeModule] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowStartsEndsInBarCodeModule] DEFAULT ('N'),
    [ReportTerm1] varchar(150) NULL,
    [ReportTerm2] varchar(150) NULL,
    [ReportTerm3] varchar(150) NULL,
    [ReportTerm4] varchar(150) NULL,
    [CashSaleDefaultFocusSetting] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_CashSaleDefaultFocusSetting] DEFAULT ('detailwindow'),
    [CreditSaleDefaultFocusSetting] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_CreditSaleDefaultFocusSetting] DEFAULT ('custcode'),
    [PackingDescinSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_PackingDescinSale] DEFAULT ('N'),
    [PackingDescinSaleReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_PackingDescinSaleReturn] DEFAULT ('N'),
    [PackingDescinPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_PackingDescinPurchase] DEFAULT ('N'),
    [PackingDescinPurchaseReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_PackingDescinPurchaseReturn] DEFAULT ('N'),
    [CreditSalePageSize] char(1) NOT NULL CONSTRAINT [DF_Preferences_CreditSalePageSize] DEFAULT ('Q'),
    [CreditSaleAskUserPassword] char(1) NOT NULL CONSTRAINT [DF_Preferences_CreditSaleAskUserPassword] DEFAULT ('N'),
    [CashSaleDetailWindowFormat] smallint NOT NULL CONSTRAINT [DF_preferences_CashSaleDetailWindowFormat] DEFAULT (1),
    [CreditSaleDetailWindowFormat] smallint NOT NULL CONSTRAINT [DF_preferences_CreditSaleDetailWindowFormat] DEFAULT (1),
    [DoctNameForNorcotix] char(1) NOT NULL CONSTRAINT [DF_preferences_DoctNameForNorcotix] DEFAULT ('Y'),
    [ShowPackQtyInTransfer] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPackQtyInTransfer] DEFAULT ('N'),
    [ReportTerm5] varchar(150) NULL,
    [ReportTerm6] varchar(150) NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [SalePersonInTrans] char(1) NOT NULL CONSTRAINT [DF_Preferences_SalePersonInTrans] DEFAULT ('N'),
    [PriceInTransferPrint] tinyint NOT NULL CONSTRAINT [DF_Preferences_PriceInTransferPrint] DEFAULT (1),
    [SaleDefaultPrintBalOpt] char(1) NOT NULL CONSTRAINT [DF_preferences_SaleDefaultPrintBalOpt] DEFAULT ('Y'),
    [ShowPurInvGSTPerc] char(1) NOT NULL CONSTRAINT [DF_preferences_ShowPurInvGSTPerc] DEFAULT ('N'),
    [ShowPurItemGSTPerc] char(1) NOT NULL CONSTRAINT [DF_preferences_ShowPurItemGSTPerc] DEFAULT ('N'),
    [ShowPurItemUnitTax] char(1) NOT NULL CONSTRAINT [DF_preferences_ShowPurItemUnitTax] DEFAULT ('N'),
    [TransferAutoPosting] char(1) NOT NULL CONSTRAINT [DF_Preferences_TransferAutoPosting] DEFAULT ('N'),
    [AutoSaleReturnAllocation] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoSaleReturnAllocation] DEFAULT ('N'),
    [AutoPostSaleReturnAllocation] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoPostSaleReturnAllocation] DEFAULT ('N'),
    [PurInvPageSize] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurInvPageSize] DEFAULT ('F'),
    [DefaultArgSDate] datetime NOT NULL CONSTRAINT [DF_preferences_DefaultArgSDate] DEFAULT (getdate()),
    [ApplyArgSDate] char(1) NOT NULL CONSTRAINT [DF_preferences_ApplyArgSDate] DEFAULT ('N'),
    [SigOnSaleInv] char(1) NOT NULL CONSTRAINT [DF_Preferences_SigOnSaleInv] DEFAULT ('N'),
    [SigOnSaleInvImg] image NULL,
    [AllowDupItemsInTransfer] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowDupItemsInTransfer] DEFAULT ('N'),
    [PurRetAskPrintCopies] char(1) NOT NULL CONSTRAINT [DF_preferences_PurRetAskPrintCopies] DEFAULT ('N'),
    [PurPrice2InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurPrice2InAdvPur] DEFAULT ('N'),
    [PurPrice3InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurPrice3InAdvPur] DEFAULT ('N'),
    [PurPrice4InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_PurPrice4InAdvPur] DEFAULT ('N'),
    [TotPurPriceInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_TotPurPriceInAdvPur] DEFAULT ('N'),
    [ItemFlatDiscInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemFlatDiscInAdvPur] DEFAULT ('N'),
    [UnitTaxRuleCodeInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_UnitTaxRuleCodeInAdvPur] DEFAULT ('N'),
    [DefaultUnitTaxRuleInAdvPur] tinyint NOT NULL CONSTRAINT [DF_Preferences_DefaultUnitTaxRuleInAdvPur] DEFAULT (4),
    [GSTRuleCodeInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_GSTRuleCodeInAdvPur] DEFAULT ('N'),
    [DefaultGSTRuleInAdvPur] tinyint NOT NULL CONSTRAINT [DF_Preferences_DefaultGSTRuleInAdvPur] DEFAULT (4),
    [ItemFlatDisc2InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemFlatDisc2InAdvPur] DEFAULT ('N'),
    [DiscPerc2InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_DiscPerc2InAdvPur] DEFAULT ('N'),
    [FlatDisc2InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_FlatDisc2InAdvPur] DEFAULT ('N'),
    [MiscCharges2InAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_MiscCharges2InAdvPur] DEFAULT ('N'),
    [AutoCreatePurInvoiceFromAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoCreatePurInvoiceFromAdvPur] DEFAULT ('Y'),
    [AutoPostPurInvoiceFromAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoPostPurInvoiceFromAdvPur] DEFAULT ('Y'),
    [ItmFlatDisAftDisPrcInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemFlatDiscAfterDiscPercInAdvPur] DEFAULT ('N'),
    [ValueDiscOnItemInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ValueDiscOnItemInAdvPur] DEFAULT ('N'),
    [OverwriteBatchOnPurPosting] char(1) NOT NULL CONSTRAINT [DF_Preferences_OverwriteBatchOnPurPosting] DEFAULT ('N'),
    [AutoMonthSaleInvCode] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoMonthSaleInvCode] DEFAULT ('N'),
    [AllowedGroupsInSalesList] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowedGroupsInSalesList] DEFAULT ('N'),
    [SepSaleInvCounterForCashCredit] char(1) NOT NULL CONSTRAINT [DF_Preferences_SepSaleInvCounterForCashCredit] DEFAULT ('N'),
    [IssuePriceInPrint] tinyint NOT NULL CONSTRAINT [DF_Preferences_IssuePriceInPrint] DEFAULT (1),
    [ReceiptPriceInPrint] tinyint NOT NULL CONSTRAINT [DF_Preferences_ReceiptPriceInPrint] DEFAULT (1),
    [InitialSManCodeInService] smallint NULL,
    [ShowItemAdvanceInServiceOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowItemAdvanceInServiceOrder] DEFAULT ('Y'),
    [ShowInvAdvanceInServiceOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowInvAdvanceInServiceOrder] DEFAULT ('Y'),
    [ShowAmtInIssueInv] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowAmtInIssueInv] DEFAULT ('Y'),
    [ShowSaleRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowSaleRemarksInLedger] DEFAULT ('N'),
    [ShowSRetRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowSRetRemarksInLedger] DEFAULT ('N'),
    [ShowPurRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPurRemarksInLedger] DEFAULT ('N'),
    [ShowPRetRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPRetRemarksInLedger] DEFAULT ('N'),
    [ShowSvcRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowSvcRemarksInLedger] DEFAULT ('N'),
    [ShowSvcRetRemarksInLedger] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowSvcRetRemarksInLedger] DEFAULT ('N'),
    [IssuePriceTypeCode] tinyint NOT NULL CONSTRAINT [DF_Preferences_IssuePriceTypeCode] DEFAULT (1),
    [ReceiptPriceTypeCode] tinyint NOT NULL CONSTRAINT [DF_Preferences_ReceiptPriceTypeCode] DEFAULT (4),
    [ShowIssuePriceTypeCode] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowIssuePriceTypeCode] DEFAULT ('Y'),
    [ShowReceiptPriceTypeCode] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowReceiptPriceTypeCode] DEFAULT ('Y'),
    [ShowItemRemarksInPurOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowItemRemarksInPurOrder] DEFAULT ('N'),
    [ShowSuppRefInPurOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowSuppRefInPurOrder] DEFAULT ('N'),
    [ShowDeliveryLocationInPurOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowDeliveryLocationInPurOrder] DEFAULT ('N'),
    [ShowUsageLocationInPurOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowUsageLocationInPurOrder] DEFAULT ('N'),
    [ShowReqDateInPurOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowReqDateInPurOrder] DEFAULT ('N'),
    [AskUserPwdInPatientReg] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskUserPwdInPatientReg] DEFAULT ('N'),
    [AutoFinalizeSaleOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoFinalizeSaleOrder] DEFAULT ('N'),
    [AutoPostSaleOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoPostSaleOrder] DEFAULT ('N'),
    [AutoUpdateTransitStock] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoUpdateTransitStock] DEFAULT ('N'),
    [QuartTerms3] varchar(100) NULL,
    [QuartTerms4] varchar(100) NULL,
    [ShowPriceInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPriceInReceipt] DEFAULT ('Y'),
    [ShowPriceInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPriceInIssue] DEFAULT ('Y'),
    [UniqueRefNoInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_UniqueRefNoInSale] DEFAULT ('N'),
    [PurSlipSize] char(1) NOT NULL CONSTRAINT [DF_preferences_PurSlipSize] DEFAULT ('F'),
    [AskForRecAdjInCreditSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskForRecAdjInCreditSale] DEFAULT ('N'),
    [RecAdjSampleSaleInvCode] int NULL,
    [ValidateCustLicExpiryInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ValidateCustLicExpiryInSale] DEFAULT ('N'),
    [DecimalsForQtyInRecipe] tinyint NOT NULL CONSTRAINT [DF_Preferences_DecimalsForQtyInRecipe] DEFAULT (7),
    [SaleSets] char(1) NOT NULL CONSTRAINT [DF_Preferences_SaleSets] DEFAULT ('N'),
    [CheckCrLimitInCrSales] char(1) NOT NULL CONSTRAINT [DF_CheckCrLimitInCrSales_Preferences] DEFAULT ('N'),
    [AutoPostProduction] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoPostProduction] DEFAULT ('N'),
    [ApplyCustomerQuotationOnSaving] char(1) NOT NULL CONSTRAINT [DF_Preferences_ApplyCustomerQuotationOnSaving] DEFAULT ('N'),
    [AutoProductionInPOS] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoProductionInPOS] DEFAULT ('N'),
    [CashServicePageSize] char(1) NOT NULL CONSTRAINT [DF_Preferences_CashServicePageSize] DEFAULT ('Q'),
    [CreditServicePageSize] char(1) NOT NULL CONSTRAINT [DF_Preferences_CreditServicePageSize] DEFAULT ('Q'),
    [UniqueRefNoInTrans] char(1) NOT NULL CONSTRAINT [DF_Preferences_UniqueRefNoInTrans] DEFAULT ('N'),
    [AutoRefNoInTrans] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoRefNoInTrans] DEFAULT ('N'),
    [AllowCustomerInCashSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowCustomerInCashSale] DEFAULT ('N'),
    [EnableServiceCatRights] char(1) NOT NULL CONSTRAINT [DF_Preferences_EnableServiceCatRights] DEFAULT ('N'),
    [SalePriceInPR] char(1) NOT NULL CONSTRAINT [DF_Preferences_SalePriceInPR] DEFAULT ('N'),
    [EnableQuickPrefferedSearch] char(1) NOT NULL CONSTRAINT [DF_Preferences_EnableQuickPrefferedSearch] DEFAULT ('N'),
    [QuickPrefferedSearchType] char(1) NOT NULL CONSTRAINT [DF_Preferences_QuickPrefferedSearchType] DEFAULT ('X'),
    [SaleRetItemDescription] char(1) NOT NULL CONSTRAINT [DF_preferences_SaleRetItemDescription] DEFAULT ('N'),
    [PurRetItemDescription] char(1) NOT NULL CONSTRAINT [DF_preferences_PurRetItemDescription] DEFAULT ('N'),
    [AskUserPwdInSaleReturn] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskUserPwdInSaleReturn] DEFAULT ('Y'),
    [AskUserPwdInAdjustment] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskUserPwdInAdjustment] DEFAULT ('Y'),
    [ApplySalePriceChangeMargin] char(1) NOT NULL CONSTRAINT [DF_Preferences_ApplySalePriceChangeMargin] DEFAULT ('Y'),
    [PatientRegFormatInSale] tinyint NOT NULL CONSTRAINT [DF_Preferences_PatientRegFormatInSale] DEFAULT (1),
    [ShowNetRateInPurchase] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowNetRateInPurchase] DEFAULT ('Y'),
    [PopQuotInSale_Post_UnPost_All] tinyint NOT NULL CONSTRAINT [DF_Preferences_PopQuotInSale_Post_UnPost_All] DEFAULT (1),
    [AllowDupQuotInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowDupQuotInSale] DEFAULT ('Y'),
    [DefaultQtyInQuot] tinyint NOT NULL CONSTRAINT [DF_Preferences_DefaultQtyInQuot] DEFAULT (1),
    [ChangeSPForItemDescInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ChangeSPForItemDescInSale] DEFAULT ('Y'),
    [CashSaleAllowNullPatient] char(1) NOT NULL CONSTRAINT [DF_preferences_CashSaleAllowNullPatient] DEFAULT ('Y'),
    [CreditSaleAllowNullPatient] char(1) NOT NULL CONSTRAINT [DF_preferences_CreditSaleAllowNullPatient] DEFAULT ('Y'),
    [ItemFlatDiscInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemFlatDiscInPO] DEFAULT ('N'),
    [ItemUnitTaxInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemUnitTaxInPO] DEFAULT ('N'),
    [ItemGSTPercInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_ItemGSTPercInPO] DEFAULT ('N'),
    [InvGSTPercInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_InvGSTPercInPO] DEFAULT ('N'),
    [InvFlatDiscInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_InvFlatDiscInPO] DEFAULT ('N'),
    [InvMiscChargesInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_InvMiscChargesInPO] DEFAULT ('N'),
    [InvDiscPercInPO] char(1) NOT NULL CONSTRAINT [DF_Preferences_InvDiscPercInPO] DEFAULT ('Y'),
    [ShowTransitStockInItemList] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowTransitStockInItemList] DEFAULT ('N'),
    [ShowMeasuringUnitInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowMeasuringUnitInAdvPur] DEFAULT ('N'),
    [ShowGSTTypeInAdvPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowGSTTypeInAdvPur] DEFAULT ('N'),
    [AssocSaleInvListInPos] char(1) NOT NULL CONSTRAINT [DF_Preferences_AssocSaleInvListInPos] DEFAULT ('N'),
    [ShowHeaderInQuotation] char(1) NOT NULL CONSTRAINT [DF_Preferences_HeaderInQuotation] DEFAULT ('Y'),
    [BarCodeLenInPrint] tinyint NOT NULL CONSTRAINT [DF_Preferences_BarCodeLenInPrint] DEFAULT (20),
    [PrintHeaderOnSalePrintOut] char(1) NOT NULL CONSTRAINT [DF_preference_PrintHeaderOnSalePrintOut] DEFAULT ('Y'),
    [IssueItemDescription] char(1) NOT NULL CONSTRAINT [DF_preferences_IssueItemDescription] DEFAULT ('N'),
    [UpdAvgPriceInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdAvgPriceInReceipt] DEFAULT ('Y'),
    [UpdAvgPriceInAdjInc] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdAvgPriceInAdjInc] DEFAULT ('Y'),
    [ShowUpdAvgPriceInReceipt] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowUpdAvgPriceInReceipt] DEFAULT ('N'),
    [ShowUpdAvgPriceInAdjInc] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowUpdAvgPriceInAdjInc] DEFAULT ('N'),
    [PrintStoreSummWithSInv] char(1) NOT NULL CONSTRAINT [DF_Preferences_PrintStoreSummWithSInv] DEFAULT ('N'),
    [ShowPurUnitRateInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPurUnitRateInSale] DEFAULT ('N'),
    [IsolateBonusInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_IsolateBonusInSale] DEFAULT ('N'),
    [AutoSelectLastGodownInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoSelectLastGodownInSale] DEFAULT ('N'),
    [UpdateMinQty_PO_Save] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdateMinQty_PO_Save] DEFAULT ('N'),
    [UpdateReorderQty_PO_Save] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdateReorderQty_PO_Save] DEFAULT ('N'),
    [UpdateOptQty_PO_Save] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdateOptQty_PO_Save] DEFAULT ('N'),
    [AutoDueSatisfyOnPurPost] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoDueSatisfyOnPurPost] DEFAULT ('N'),
    [CheckDueRightOnPOS_Save] char(1) NOT NULL CONSTRAINT [DF_Preferences_CheckDueRightOnPOS_Save] DEFAULT ('N'),
    [ReceiptAutoPosting] char(1) NOT NULL CONSTRAINT [DF_Preferences_ReceiptAutoPosting] DEFAULT ('N'),
    [FormatForAmtInSale] varchar(30) NOT NULL CONSTRAINT [DF_Preferences_FormatForAmtInSale] DEFAULT ('###,##,##,##0.00'),
    [FormatForAmtInSRet] varchar(30) NOT NULL CONSTRAINT [DF_Preferences_FormatForAmtInSRet] DEFAULT ('###,##,##,##0.00'),
    [FormatForAmtInPur] varchar(30) NOT NULL CONSTRAINT [DF_Preferences_FormatForAmtInPur] DEFAULT ('###,##,##,##0.00'),
    [FormatForAmtInPRet] varchar(30) NOT NULL CONSTRAINT [DF_Preferences_FormatForAmtInPRet] DEFAULT ('###,##,##,##0.00'),
    [AskShiftInServiceOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskShiftInServiceOrder] DEFAULT ('Y'),
    [AskTimeSlotInServiceOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskTimeSlotInServiceOrder] DEFAULT ('Y'),
    [AskDateInServiceOrder] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskDateInServiceOrder] DEFAULT ('Y'),
    [AskServiceOrderInService] char(1) NOT NULL CONSTRAINT [DF_Preferences_AskServiceOrderInService] DEFAULT ('N'),
    [FetchRefNoFromCustomer] char(1) NOT NULL CONSTRAINT [DF_Preferences_FetchRefNoFromCustomer] DEFAULT ('N'),
    [AutoGeneratePatientRegNo] char(1) NOT NULL CONSTRAINT [DF_Preferences_AutoGeneratePatientRegNo] DEFAULT ('N'),
    [FroceMaxSaleDiscPerc] char(1) NOT NULL CONSTRAINT [DF_Preferences_FroceMaxSaleDiscPerc] DEFAULT ('N'),
    [ReComputeCostInProduction] char(1) NOT NULL CONSTRAINT [DF_Preferences_ReComputeCostInProduction] DEFAULT ('N'),
    [CashierWindowOnPOS] char(1) NOT NULL CONSTRAINT [DF_Preferences_CashierWindowOnPOS] DEFAULT ('Y'),
    [AllowSaleBelowRPP] char(1) NOT NULL CONSTRAINT [DF_Preferences_AllowSaleBelowRPP] DEFAULT ('N'),
    [ForceBonusPolicyOnSavingSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ForceBonusPolicyOnSavingSale] DEFAULT ('N'),
    [ForceDiscPolicyOnSavingSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ForceDiscPolicyOnSavingSale] DEFAULT ('N'),
    [ForcePricePolicyOnSavingSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ForcePricePolicyOnSavingSale] DEFAULT ('N'),
    [ForceUniqueSuppInvNoInPur] char(1) NOT NULL CONSTRAINT [DF_Preferences_ForceUniqueSuppInvNoInPur] DEFAULT ('Y'),
    [ShowRemoteSaleInQuot] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowRemoteSaleInQuot] DEFAULT ('N'),
    [ShowRemoteStockInQuot] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowRemoteStockInQuot] DEFAULT ('N'),
    [ShowManufactInQuot] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowManufactInQuot] DEFAULT ('N'),
    [TransferDefaultFocusSetting] char(100) NOT NULL CONSTRAINT [DF_Preferences_TransferDefaultFocusSetting] DEFAULT ('ttcode'),
    [IncSaleInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSaleInActMonitor] DEFAULT ('N'),
    [IncSRInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSRInActMonitor] DEFAULT ('N'),
    [IncPurInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncPurInActMonitor] DEFAULT ('N'),
    [IncPRInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncPRInActMonitor] DEFAULT ('N'),
    [IncPOInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncPOInActMonitor] DEFAULT ('N'),
    [IncSOInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSOInActMonitor] DEFAULT ('N'),
    [IncIssInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncIssInActMonitor] DEFAULT ('N'),
    [IncRecInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncRecInActMonitor] DEFAULT ('N'),
    [IncAdjInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncAdjInActMonitor] DEFAULT ('N'),
    [IncTransferInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncTransferInActMonitor] DEFAULT ('N'),
    [IncVochInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncVochInActMonitor] DEFAULT ('N'),
    [IncBRBPInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncBRBPInActMonitor] DEFAULT ('N'),
    [IncQuotInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncQuotInActMonitor] DEFAULT ('N'),
    [ActMonRefreshTime] int NOT NULL CONSTRAINT [DF_Preferences_ActMonRefreshTime] DEFAULT (15),
    [ActMonPeriod] int NOT NULL CONSTRAINT [DF_Preferences_ActMonPeriod] DEFAULT (30),
    [IncSvcSaleInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSvcSaleInActMonitor] DEFAULT ('N'),
    [IncSvcSRInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSvcSRInActMonitor] DEFAULT ('N'),
    [IncSvcSOInActMonitor] char(1) NOT NULL CONSTRAINT [DF_Preferences_IncSvcSOInActMonitor] DEFAULT ('N'),
    [ShowPODisparityOnPurSaving] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPODisparityOnPurSaving] DEFAULT ('N'),
    [LastDataImport] datetime NULL,
    [LastDataSynchronization] datetime NULL,
    [LastSaleTransmited] datetime NULL,
    [LastSaleSynchronized] datetime NULL,
    [UpdRPPOnLoosePurPosting] char(1) NOT NULL CONSTRAINT [DF_Preferences_UpdRPPOnLoosePurPosting] DEFAULT ('Y'),
    [ReportRateDeviationUsing] char(1) NOT NULL CONSTRAINT [DF_Preferences_ReportRateDeviationUsing] DEFAULT ('A'),
    [AcceptFutureExpiryDays] int NOT NULL CONSTRAINT [DF_Preferences_AcceptFutureExpiryDays] DEFAULT (90),
    [ShowUnitWeightInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowUnitWeightInSale] DEFAULT ('N'),
    [ShowPackingFactorInSale] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPackingFactorInSale] DEFAULT ('N'),
    [UnitWeightCaptionInSale] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_UnitWeightCaptionInSale] DEFAULT ('Weight(kg)'),
    [PackingFactorCaptionInSale] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_PackingFactorCaptionInSale] DEFAULT ('Area'),
    [ShowUnitWeightInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowUnitWeightInIssue] DEFAULT ('N'),
    [ShowPackingFactorInIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_ShowPackingFactorInIssue] DEFAULT ('N'),
    [UnitWeightCaptionInIssue] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_UnitWeightCaptionInIssue] DEFAULT ('Weight(kg)'),
    [PackingFactorCaptionInIssue] varchar(100) NOT NULL CONSTRAINT [DF_Preferences_PackingFactorCaptionInIssue] DEFAULT ('Area'),
    [PrintStoreSummWithIssue] char(1) NOT NULL CONSTRAINT [DF_Preferences_PrintStoreSummWithIssue] DEFAULT ('N'),
    [IssueTerms1] varchar(100) NULL,
    [IssueTerms2] varchar(100) NULL,
    CONSTRAINT [PK_Preferences_13__16] PRIMARY KEY CLUSTERED ([UserId])
);
GO

CREATE TABLE [dbo].[PreferencesCategory] (
    [CatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_PreferencesCategory_CatCode] PRIMARY KEY CLUSTERED ([CatCode]),
    CONSTRAINT [UK_PreferencesCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[PreferencesSubCategory] (
    [SubCatCode] smallint NOT NULL,
    [CatCode] smallint NOT NULL,
    [FormOrder] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_PreferencesSubCategory_SubCatCode] PRIMARY KEY CLUSTERED ([SubCatCode]),
    CONSTRAINT [UK_PreferencesSubCategory_SubCategoryForACategory] UNIQUE ([CatCode], [Name])
);
GO

CREATE TABLE [dbo].[PreSaleDetail] (
    [PreSaleInvCode] int NOT NULL,
    [PurInvCode] int NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_PreSaleDetail_Qty] DEFAULT (1),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PreSaleDetail_BonusQty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PreSaleDetail_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_PreSaleDetail_DiscPerc] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [PurRowID] int NULL,
    [ItemDescription] varchar(100) NULL
);
GO

CREATE TABLE [dbo].[PreSaleHeader] (
    [PreSaleInvCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PreSaleHeader_Date] DEFAULT (getdate()),
    [CustCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PreSaleHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [SaleInvCode] int NULL,
    [CustRefNo] varchar(30) NULL,
    [CustRefNo2] varchar(100) NULL,
    [CustRefNo3] varchar(100) NULL,
    [CustRefNo4] varchar(100) NULL,
    [OrderDate] datetime NULL,
    CONSTRAINT [PK_PreSaleHeader] PRIMARY KEY CLUSTERED ([PreSaleInvCode])
);
GO

CREATE TABLE [dbo].[PrescriptionDeleteDetail] (
    [PresCode] int NOT NULL,
    [ICode] int NOT NULL,
    [RowId] int NOT NULL CONSTRAINT [DF_PrescriptionDeleteDetail_RowId] DEFAULT ((-1)),
    [NoOfUnits] smallint NOT NULL,
    [DosageCode] smallint NOT NULL,
    [DoseFactor] smallint NOT NULL,
    [RouteCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Duration] smallint NOT NULL,
    [InsCode] smallint NULL,
    [DeleteDate] datetime NOT NULL,
    CONSTRAINT [CK_PrescriptionDeleteDetail_DoseFactor] CHECK ([DoseFactor] > 0),
    CONSTRAINT [CK_PrescriptionDeleteDetail_NoOfUnits] CHECK ([NoOfUnits] > 0),
    CONSTRAINT [CK_PrescriptionDeleteDetail_Duration] CHECK ([Duration] > 0)
);
GO

CREATE TABLE [dbo].[PrescriptionDetail] (
    [PresCode] int NOT NULL,
    [Icode] int NOT NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [NoOfUnits] smallint NOT NULL,
    [DosageCode] smallint NOT NULL,
    [DoseFactor] smallint NOT NULL,
    [RouteCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Duration] smallint NOT NULL,
    [InsCode] smallint NULL,
    CONSTRAINT [PK_PrescriptionDetail_PresCode_Icode] PRIMARY KEY CLUSTERED ([PresCode], [Icode]),
    CONSTRAINT [CK_PrescriptionDetail_DoseFactor] CHECK ([DoseFactor] > 0),
    CONSTRAINT [CK_PrescriptionDetail_NoOfUnits] CHECK ([NoOfUnits] > 0),
    CONSTRAINT [CK_PrescriptionDetail_Duration] CHECK ([Duration] > 0)
);
GO

CREATE TABLE [dbo].[PrescriptionDetailLog] (
    [LogId] int NOT NULL,
    [PresCode] int NOT NULL,
    [Icode] int NOT NULL,
    [RowId] int NOT NULL,
    [NoOfUnits] smallint NOT NULL,
    [DosageCode] smallint NOT NULL,
    [DoseFactor] smallint NOT NULL,
    [RouteCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Duration] smallint NOT NULL,
    [InsCode] smallint NULL,
    CONSTRAINT [PK_PrescriptionDetailLog_LogId_PresCode_Icode] PRIMARY KEY CLUSTERED ([LogId], [PresCode], [Icode]),
    CONSTRAINT [CK_PrescriptionDetailLog_DoseFactor] CHECK ([DoseFactor] > 0),
    CONSTRAINT [CK_PrescriptionDetailLog_Duration] CHECK ([Duration] > 0),
    CONSTRAINT [CK_PrescriptionDetailLog_NoOfUnits] CHECK ([NoOfUnits] > 0)
);
GO

CREATE TABLE [dbo].[PrescriptionHeader] (
    [PresCode] int NOT NULL,
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [DoctCode] smallint NULL,
    [OriginalDate] datetime NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CreatedBy] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [ModifyCounter] int NOT NULL CONSTRAINT [DF_PrescriptionHeader_ModifyCounter] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PrescriptionHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [RefNo] varchar(30) NULL,
    CONSTRAINT [PK_PrescriptionHeader] PRIMARY KEY CLUSTERED ([PresCode])
);
GO

CREATE TABLE [dbo].[PrescriptionHeaderLog] (
    [LogId] int NOT NULL,
    [LogDate] datetime NOT NULL,
    [PresCode] int NOT NULL,
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [DoctCode] smallint NULL,
    [OriginalDate] datetime NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CreatedBy] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [ModifyCounter] int NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PrescriptionHeaderLog_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    CONSTRAINT [PK_PrescriptionHeaderLog_LogId_PresCode] PRIMARY KEY NONCLUSTERED ([LogId], [PresCode]),
    CONSTRAINT [UQ_PrescriptionHeaderLog_LogId] UNIQUE ([LogId])
);
GO

CREATE TABLE [dbo].[PrevAbnormalLabs] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [PrevAbnormalLabs] varchar(1000) NULL,
    [IncUC] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_IncUC] DEFAULT ('N'),
    [IncLFTs] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_IncLFTs] DEFAULT ('N'),
    [IncPotK] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_IncPotK] DEFAULT ('N'),
    [DecHB] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_DecHB] DEFAULT ('N'),
    [IncPTINR] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_IncPTINR] DEFAULT ('N'),
    [DecMeg] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_DecMeg] DEFAULT ('N'),
    [DecCal] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_DecCal] DEFAULT ('N'),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_AttendingDoctCode] DEFAULT (1),
    [DecInPotK] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_DecInPotK] DEFAULT ('N'),
    [IncInHb] char(1) NOT NULL CONSTRAINT [DF_PrevAbnormalLabs_IncInHb] DEFAULT ('N')
);
GO

CREATE TABLE [dbo].[PreviousSaleHistory] (
    [Date] datetime NOT NULL,
    [ICode] int NOT NULL,
    [SaleQty] numeric(19,4) NOT NULL CONSTRAINT [DF_PreviousSaleHistory_SaleQty] DEFAULT (0),
    [ReturnQty] numeric(19,4) NOT NULL CONSTRAINT [DF_PreviousSaleHistory_ReturnQty] DEFAULT (0),
    [SaleValue] numeric(19,4) NOT NULL CONSTRAINT [DF_PreviousSaleHistory_SaleValue] DEFAULT (0),
    [ReturnValue] numeric(19,4) NOT NULL CONSTRAINT [DF_PreviousSaleHistory_ReturnValue] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[PriceChanges] (
    [TableName] varchar(100) NOT NULL,
    [ColumnName] varchar(100) NOT NULL,
    [PRIORITY] numeric(5,2) NOT NULL,
    [NewDataType] varchar(100) NOT NULL,
    CONSTRAINT [PK_PriceChanges_PRIORITY] PRIMARY KEY CLUSTERED ([PRIORITY])
);
GO

CREATE TABLE [dbo].[PricePolicy] (
    [PricePolicyCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ICode] int NOT NULL,
    CONSTRAINT [PK_PricePolicy_PricePolicyCode] PRIMARY KEY CLUSTERED ([PricePolicyCode]),
    CONSTRAINT [UK_Item_PricePolicyDetail_Icode] UNIQUE ([ICode]),
    CONSTRAINT [UK_PricePolicy_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[PricePolicyDetail] (
    [PricePolicyCode] int NOT NULL,
    [QtyLimit] int NOT NULL,
    [Price] numeric(15,4) NOT NULL CONSTRAINT [DF_PricePolicyDetail] DEFAULT (0),
    [ExpiryDate] datetime NOT NULL,
    [ItemFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_PricePolicyDetail_ItemFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_PricePolicyDetail_DiscPerc] DEFAULT (0),
    CONSTRAINT [PK_PricePolicyDetail_PricePolicyCode_QtyLimit] PRIMARY KEY CLUSTERED ([PricePolicyCode], [QtyLimit])
);
GO

CREATE TABLE [dbo].[PriceType] (
    [PriceTypeCode] tinyint NOT NULL,
    [Name] varchar(40) NOT NULL,
    CONSTRAINT [PK_PriceType] PRIMARY KEY CLUSTERED ([PriceTypeCode]),
    CONSTRAINT [UK_PriceType_Name] UNIQUE ([PriceTypeCode])
);
GO

CREATE TABLE [dbo].[PRLedger] (
    [PRInvCode] int NOT NULL,
    [PurInvCode] int NULL,
    [PRCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PRLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PRLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_PRLedger_GSTPerc1_1__10] DEFAULT (0),
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [df_prledger_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_PRLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_PRLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PRLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_PRLedger_Marked] DEFAULT ('N'),
    [prtypecode] smallint NULL,
    [Terms1] varchar(150) NULL,
    [Terms2] varchar(150) NULL,
    [Terms3] varchar(150) NULL,
    [Terms4] varchar(150) NULL,
    [Terms5] varchar(150) NULL,
    [PurchaseInvNo] varchar(100) NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_PRLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [ICatCode] smallint NULL,
    [UpdateAvgPriceWithNetRate] char(1) NOT NULL CONSTRAINT [DF_PrLedger_UpdateAvgPriceWithNetRate] DEFAULT ('N'),
    [CustCode] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PRLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [DataCarryCustCode] smallint NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_PRLedger_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_PRLedger] PRIMARY KEY CLUSTERED ([PRInvCode])
);
GO

CREATE TABLE [dbo].[ProdBuffer] (
    [ProdCode] int NOT NULL,
    [ProdRowID] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,7) NOT NULL CONSTRAINT [DF_ProdBuffer_Qty] DEFAULT (0),
    [Remarks] varchar(200) NULL,
    [PackUnits] smallint NOT NULL,
    [PackPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdBuffer_PackPrice] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdBuffer_Price] DEFAULT (0),
    [ItemFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ProdBuffer_ItemFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ProdBuffer_DiscPerc] DEFAULT (0),
    [ProcessCharge] numeric(10,2) NOT NULL CONSTRAINT [DF_ProdBuffer_ProcessCharge] DEFAULT (0),
    [ProcessChargePerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ProdBuffer_ProcessChargePerc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ProdBuffer] PRIMARY KEY CLUSTERED ([ProdCode], [ProdRowID], [RowID])
);
GO

CREATE TABLE [dbo].[ProdDetail] (
    [ProdCode] int NOT NULL,
    [ICode] int NOT NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_ProdDetail_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_ProdDetail_Expiry] DEFAULT (getdate()),
    CONSTRAINT [PK_ProdDetail] PRIMARY KEY CLUSTERED ([ProdCode], [ICode], [RowId]),
    CONSTRAINT [CK_ProdDetail_Qty] CHECK ([Qty] > 0)
);
GO

CREATE TABLE [dbo].[ProdHeader] (
    [ProdCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [PostDate] datetime NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ProdHeader_Posted] DEFAULT ('N'),
    [Remarks] varchar(100) NULL,
    [IssueGCode] smallint NOT NULL,
    [ReceiptGCode] smallint NOT NULL,
    [CreatedBy] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [IssueInvCode] int NULL,
    [ReceiptInvCode] int NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_ProdHeader_Finalized] DEFAULT ('N'),
    [FinalizedOn] datetime NULL,
    [FinalizedBy] smallint NULL,
    [IssueDeptCode] smallint NOT NULL CONSTRAINT [DF_ProdHeader_IssueDeptCode] DEFAULT (1),
    [ReceiptDeptCode] smallint NOT NULL CONSTRAINT [DF_ProdHeader_ReceiptDeptCode] DEFAULT (1),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ProdHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_ProdHeader] PRIMARY KEY CLUSTERED ([ProdCode])
);
GO

CREATE TABLE [dbo].[ProdNote] (
    [ProdNoteCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ProdNote_Date] DEFAULT (getdate()),
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ProdNote_OriginalDate] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [IssueDeptCode] smallint NOT NULL,
    [ReceiptDeptCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ProdNote_Posted] DEFAULT ('N'),
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [IssueInvCode] int NULL,
    [ReceiptInvCode] int NULL,
    [QE1_AccCode] smallint NULL,
    [QE2_AccCode] smallint NULL,
    [QE3_AccCode] smallint NULL,
    [QE4_AccCode] smallint NULL,
    [QE5_AccCode] smallint NULL,
    [WE1_AccCode] smallint NULL,
    [WE2_AccCode] smallint NULL,
    [WE3_AccCode] smallint NULL,
    [WE4_AccCode] smallint NULL,
    [WE5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_QExp1_CrAccCode] DEFAULT (34),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_QExp2_CrAccCode] DEFAULT (34),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_QExp3_CrAccCode] DEFAULT (34),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_QExp34_CrAccCode] DEFAULT (34),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_QExp5_CrAccCode] DEFAULT (34),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_WExp1_CrAccCode] DEFAULT (34),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_WExp2_CrAccCode] DEFAULT (34),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_WExp3_CrAccCode] DEFAULT (34),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_WExp34_CrAccCode] DEFAULT (34),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ProdNote_WExp5_CrAccCode] DEFAULT (34),
    CONSTRAINT [PK_ProdNote] PRIMARY KEY CLUSTERED ([ProdNoteCode])
);
GO

CREATE TABLE [dbo].[ProdNoteIssue] (
    [ProdNoteCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ProdNoteIssue_Qty] DEFAULT (1),
    [Price] numeric(15,5) NOT NULL CONSTRAINT [DF_ProdNoteIssue_Price] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ProdNoteIssue_PackUnits] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ProdNoteIssue_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_ProdNoteIssue_PiecesInHand] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[ProdNoteReceipt] (
    [ProdNoteCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_Qty] DEFAULT (1),
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_ProdNoteReceipt_Expiry] DEFAULT (getdate() + 365),
    [Price] numeric(15,5) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_Price] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ProdNoteReceipt_PackUnits] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ProdNoteReceipt_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_ProdNoteReceipt_PiecesInHand] DEFAULT (0),
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_UnitWeight] DEFAULT (1),
    [QE1] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_QE1] DEFAULT (0),
    [QE2] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_QE2] DEFAULT (0),
    [QE3] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_QE3] DEFAULT (0),
    [QE4] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_QE4] DEFAULT (0),
    [QE5] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_QE5] DEFAULT (0),
    [WE1] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_WE1] DEFAULT (0),
    [WE2] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_WE2] DEFAULT (0),
    [WE3] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_WE3] DEFAULT (0),
    [WE4] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_WE4] DEFAULT (0),
    [WE5] numeric(12,2) NOT NULL CONSTRAINT [DF_ProdNoteReceipt_WE5] DEFAULT (0),
    CONSTRAINT [PK_ProdNoteReceipt] PRIMARY KEY CLUSTERED ([ProdNoteCode], [ICode], [GCode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[Product] (
    [ProductCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_Product_OriginalDate] DEFAULT (getdate()),
    [Date] datetime NOT NULL CONSTRAINT [DF_Product_Date] DEFAULT (getdate()),
    [Name] varchar(100) NOT NULL,
    [ChasisNo] varchar(100) NOT NULL,
    [EngineNo] varchar(100) NOT NULL,
    [EnginePower] varchar(100) NULL,
    [ModelCode] smallint NOT NULL,
    [ProductPurposeCode] smallint NOT NULL,
    [ProductTypeCode] smallint NOT NULL,
    [IColourCode] smallint NOT NULL,
    [Area] varchar(100) NULL,
    [ToolKit] char(1) NOT NULL CONSTRAINT [DF_Product_ToolKit] DEFAULT ('N'),
    [SpareTyre] char(1) NOT NULL CONSTRAINT [DF_Product_SpareTyre] DEFAULT ('N'),
    [WarrantyBook] char(1) NOT NULL CONSTRAINT [DF_Product_WarrantyBook] DEFAULT ('N'),
    [Deck] char(1) NOT NULL CONSTRAINT [DF_Product_Deck] DEFAULT ('N'),
    [OriginalKeys] varchar(100) NOT NULL CONSTRAINT [DF_Product_OriginalKeys] DEFAULT ('2'),
    [OriginalKeysDetails] varchar(100) NULL,
    [Others1] char(1) NOT NULL CONSTRAINT [DF_Product_Others1] DEFAULT ('N'),
    [Others1Details] varchar(100) NULL,
    [Others2] char(1) NOT NULL CONSTRAINT [DF_Product_Others2] DEFAULT ('N'),
    [Others2Details] varchar(100) NULL,
    [InvoiceIssued] char(1) NOT NULL CONSTRAINT [DF_Product_InvoiceIssued] DEFAULT ('N'),
    [FirmCommission] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_FirmCommission] DEFAULT (0),
    [SalesPersonCommission] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_SalesPersonCommission] DEFAULT (0),
    [RefNo] varchar(100) NULL,
    [RefNo2] varchar(100) NULL,
    [RefNo3] varchar(100) NULL,
    [RefNo4] varchar(100) NULL,
    [RefNo5] varchar(100) NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_Product_Finalized] DEFAULT ('N'),
    [FinalizedOn] datetime NOT NULL CONSTRAINT [DF_Product_FinalizedOn] DEFAULT (getdate()),
    [FinalizedBy] smallint NULL,
    [PurchasePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_PurchasePrice] DEFAULT (0),
    [Transportation] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_Transportation] DEFAULT (0),
    [FirmCommissionReceived] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_FirmCommissionReceived] DEFAULT (0),
    [SuppCode] smallint NULL,
    [Aquired] char(1) NOT NULL CONSTRAINT [DF_Product_Aquired] DEFAULT ('N'),
    [AquiredOn] datetime NOT NULL CONSTRAINT [DF_Product_AquiredOn] DEFAULT (getdate()),
    [AquiredBy] smallint NULL,
    [CustCode] smallint NULL,
    [SalesManCode] smallint NULL,
    [CompanyInvoiceReceived] char(1) NOT NULL CONSTRAINT [DF_Product_CompanyInvoiceReceived] DEFAULT ('N'),
    [RegistrationRequired] char(1) NOT NULL CONSTRAINT [DF_Product_RegistrationRequired] DEFAULT ('N'),
    [Delivered] char(1) NOT NULL CONSTRAINT [DF_Product_Delivered] DEFAULT ('N'),
    [DeliveredOn] datetime NOT NULL CONSTRAINT [DF_Product_DeliveredOn] DEFAULT (getdate()),
    [DeliveredBy] smallint NULL,
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_SalePrice] DEFAULT (0),
    [Discount] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_Discount] DEFAULT (0),
    [RegistrationAmount] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_RegistrationAmount] DEFAULT (0),
    [RegistrationReceived] numeric(15,2) NOT NULL CONSTRAINT [DF_Product_RegistrationReceived] DEFAULT (0),
    [Sold] char(1) NOT NULL CONSTRAINT [DF_Product_Sold] DEFAULT ('N'),
    [SoldOn] datetime NOT NULL CONSTRAINT [DF_Product_SoldOn] DEFAULT (getdate()),
    [SoldBy] smallint NULL,
    CONSTRAINT [PK_Product_ProductCode] PRIMARY KEY CLUSTERED ([ProductCode]),
    CONSTRAINT [UK_Product_EngineNo] UNIQUE ([EngineNo]),
    CONSTRAINT [UK_Product_ChasisNo] UNIQUE ([ChasisNo])
);
GO

CREATE TABLE [dbo].[ProductPurpose] (
    [ProductPurposeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ProductPurpose_ProductPurposeCode] PRIMARY KEY CLUSTERED ([ProductPurposeCode]),
    CONSTRAINT [UK_ProductPurpose_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ProductType] (
    [ProductTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ProductType_ProductTypeCode] PRIMARY KEY CLUSTERED ([ProductTypeCode]),
    CONSTRAINT [UK_ProductType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ProformaPurDetail] (
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ProformaPurdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ProformaPurdetail_LooseQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ProformaPurDetail_PurPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ProformaPurDetail_AvgPrice] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_ProformaPurdetail_BonusQty] DEFAULT (0),
    [PurRowId] int IDENTITY(1,1) NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_ProformaPurdetail_CurrStock] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ProformaPurdetail_GSTPerc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ProformaPurDetail_UnitSalesTax] DEFAULT (0),
    [PurUtn] bigint NULL,
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_ProformaPurdetail_SalePrice] DEFAULT (0),
    [itemdescription] varchar(100) NULL,
    [rate] numeric(15,2) NOT NULL CONSTRAINT [DF_ProformaPurdetail_rate] DEFAULT (0),
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_ProformaPurDetail_SalePriceForItem] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ProformaPurdetail_ForeignPrice] DEFAULT (0),
    [PurPriceInAdvPur] numeric(15,5) NOT NULL CONSTRAINT [DF_ProformaPurDetail_PurPriceInAdvPur] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_ProformaPurDetail_NetRate] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ProformaPurdetail_RecentPurPrice] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ProformaPurdetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_ProformaPurdetail_PiecesInHand] DEFAULT (0),
    [ReceiptRowID] int NULL,
    CONSTRAINT [PK_ProformaPurdetail] PRIMARY KEY CLUSTERED ([PurInvCode], [PurRowId])
);
GO

CREATE TABLE [dbo].[ProspectiveCustomer] (
    [PptCustCode] smallint NOT NULL,
    [AliasName] varchar(12) NULL,
    [Name] varchar(60) NOT NULL,
    [CP] varchar(60) NULL,
    [Designation] varchar(60) NULL,
    [Address1] varchar(60) NULL,
    [Address2] varchar(60) NULL,
    [City] varchar(30) NULL,
    [Country] varchar(30) NULL,
    [Phone] varchar(30) NULL,
    [Fax] varchar(20) NULL,
    [Email] varchar(30) NULL,
    [CustCatCode] tinyint NULL,
    [LicenseNo] varchar(30) NULL,
    [LicenseExpiry] datetime NULL,
    [SalesTaxRegNo] varchar(50) NULL,
    [MessageCode] smallint NULL,
    [SalesManCode] smallint NULL,
    [AreaCode] smallint NOT NULL,
    [SubAreaCode] smallint NOT NULL,
    [SpecialInstructions] varchar(4000) NULL,
    CONSTRAINT [PK_ProspectiveCustomer_PptCustCode] PRIMARY KEY CLUSTERED ([PptCustCode]),
    CONSTRAINT [UQ_ProspectiveCustomer_Name] UNIQUE ([Name]),
    CONSTRAINT [UQ_ProspectiveCustomer_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[ProvDiag] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ProvDiag_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ProvisionalDiagnosis] varchar(255) NULL,
    [Details] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_ProvDiag_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_ProvDiag_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[PurCategory] (
    [PurCatCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_PurCategory] PRIMARY KEY CLUSTERED ([PurCatCode]),
    CONSTRAINT [PCNameUK] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[PurchaseDocument] (
    [PurInvCode] int NOT NULL,
    [DocDescription] varchar(100) NULL,
    [ROWID] int NOT NULL,
    [Document] image NULL,
    [DocumentType] varchar(100) NULL,
    CONSTRAINT [PK_PurchaseDocument] PRIMARY KEY CLUSTERED ([PurInvCode], [ROWID])
);
GO

CREATE TABLE [dbo].[PurchaseType] (
    [PurTypeCode] smallint NOT NULL,
    [Name] varchar(100) NULL,
    CONSTRAINT [PK_PurchaseType] PRIMARY KEY CLUSTERED ([PurTypeCode]),
    CONSTRAINT [IX_purchasttypename] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Purdetail] (
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_Purdetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_Purdetail_LooseQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_PurPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurDetail_AvgPrice] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_Purdetail_BonusQty] DEFAULT (0),
    [PurRowId] int IDENTITY(1,1) NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_Purdetail_CurrStock] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Purdetail_GSTPerc_1__10] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_UnitSalesTax] DEFAULT (0),
    [PurUtn] bigint NULL,
    [SalePrice] numeric(15,2) NOT NULL,
    [itemdescription] varchar(100) NULL,
    [rate] numeric(15,2) NOT NULL CONSTRAINT [DF_Purdetail_rate] DEFAULT (0),
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_SalePriceForItem] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurDetail_ForeignPrice] DEFAULT (0),
    [PurPriceInAdvPur] numeric(15,5) NOT NULL CONSTRAINT [DF_PurDetail_PurPriceInAdvPur] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_PurDetail_NetRate] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_RecentPurPrice] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_PurDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_PurDetail_PiecesInHand] DEFAULT (0),
    [ReceiptRowID] int NULL,
    [ManfCodeForItem] smallint NULL,
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_DiscountedSalePrice] DEFAULT (0),
    [FlatDiscForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_FlatDiscForItem] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_RetailPrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [ManfDate] datetime NULL,
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_PurDetail_UnitWeight] DEFAULT (1),
    [QE1] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_QE1] DEFAULT (0),
    [QE2] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_QE2] DEFAULT (0),
    [QE3] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_QE3] DEFAULT (0),
    [QE4] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_QE4] DEFAULT (0),
    [QE5] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_QE5] DEFAULT (0),
    [WE1] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_WE1] DEFAULT (0),
    [WE2] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_WE2] DEFAULT (0),
    [WE3] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_WE3] DEFAULT (0),
    [WE4] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_WE4] DEFAULT (0),
    [WE5] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_WE5] DEFAULT (0),
    [BatchSalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_PurDetail_BatchSalePrice] DEFAULT (0),
    [GodownStock] numeric(15,4) NOT NULL CONSTRAINT [DF_PurDetail_GodownStock] DEFAULT (0),
    [Location] varchar(100) NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurDetail_ItemFlatDisc] DEFAULT (0),
    [LockBatch] char(1) NOT NULL CONSTRAINT [DF_PurDetail_LockBatch] DEFAULT ('N'),
    [LockReasonCode] smallint NOT NULL CONSTRAINT [DF_PurDetail_LockReasonCode] DEFAULT (1),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_PurDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [SalesTaxScheduleCode] smallint NULL,
    [PCTCode] int NULL,
    [ItemAlertCode] smallint NULL,
    CONSTRAINT [PK_Purdetail_2__12] PRIMARY KEY CLUSTERED ([PurInvCode], [Gcode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[PurdetailMod] (
    [PurInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurdetailMod_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurdetailMod_LooseQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_PurPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurdetailMod_AvgPrice] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurdetailMod_BonusQty] DEFAULT (0),
    [PurRowId] int NOT NULL,
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL CONSTRAINT [DF_PurdetailMod_CurrStock] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PurdetailMod_GSTPerc_1__10] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_UnitSalesTax] DEFAULT (0),
    [PurUtn] bigint NULL,
    [SalePrice] numeric(15,2) NOT NULL,
    [itemdescription] varchar(100) NULL,
    [rate] numeric(15,2) NOT NULL CONSTRAINT [DF_PurdetailMod_rate] DEFAULT (0),
    [SalePriceForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_SalePriceForItem] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurdetailMod_ForeignPrice] DEFAULT (0),
    [PurPriceInAdvPur] numeric(15,5) NOT NULL CONSTRAINT [DF_PurdetailMod_PurPriceInAdvPur] DEFAULT (0),
    [NetRate] numeric(15,5) NOT NULL CONSTRAINT [DF_PurdetailMod_NetRate] DEFAULT (0),
    [RecentPurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_RecentPurPrice] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_PurdetailMod_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_PurdetailMod_PiecesInHand] DEFAULT (0),
    [ReceiptRowID] int NULL,
    [ManfCodeForItem] smallint NULL,
    [DiscountedSalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_DiscountedSalePrice] DEFAULT (0),
    [FlatDiscForItem] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_FlatDiscForItem] DEFAULT (0),
    [RetailPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurdetailMod_RetailPrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [ManfDate] datetime NULL,
    CONSTRAINT [PK_PurdetailMod_2__12] PRIMARY KEY CLUSTERED ([PurInvCode], [Gcode], [ICode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[PurExp] (
    [PurInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Amount] numeric(12,2) NOT NULL CONSTRAINT [DF_PurExp_Amount] DEFAULT (0),
    [RowID] int NOT NULL,
    CONSTRAINT [PK_PurExp] PRIMARY KEY CLUSTERED ([PurInvCode], [AccCode])
);
GO

CREATE TABLE [dbo].[Purledger] (
    [PurInvCode] int NOT NULL,
    [PurCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SuppInvCode] varchar(100) NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [POCode] int NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [postdate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SuppInvDate] datetime NULL,
    [GRN] varchar(100) NULL,
    [PORB] char(1) NULL CONSTRAINT [DF_Purledger_PORB_1__11] DEFAULT ('N'),
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_Purledger_InvGSTPerc1_1__10] DEFAULT (0),
    [purtypecode] smallint NULL,
    [HeaderNo] smallint NULL CONSTRAINT [DF_Purledger_HeaderNo] DEFAULT (1),
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [df_purledger_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_PurLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_Purledger_PrintBalance] DEFAULT ('N'),
    [PurInvPageSize] char(1) NOT NULL CONSTRAINT [DF_PurLedger_PurInvPageSize] DEFAULT ('F'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_CurrencyCode] DEFAULT (1),
    [ConversionFactor] numeric(11,5) NOT NULL CONSTRAINT [DF_PurLedger_ConversionFactor] DEFAULT (1),
    [PrintCounter] tinyint NOT NULL CONSTRAINT [df_purledger_printcounter] DEFAULT (0),
    [AssociatedSaleOrderCode] int NULL,
    [AssociatedSaleInvCode] int NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [NewPurchaseOrderNo] varchar(100) NULL,
    [LCNO] varchar(100) NULL,
    [UpdateAvgPriceWithNetRate] char(1) NOT NULL CONSTRAINT [DF_PurLedger_UpdateAvgPriceWithNetRate] DEFAULT ('N'),
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_PurLedger_ImpactInventory] DEFAULT ('Y'),
    [ImpPurInvCode] int NULL,
    [CreditDays] int NOT NULL CONSTRAINT [DF_PurLedger_CreditDays] DEFAULT (0),
    [SuppInvAmount] numeric(15,2) NOT NULL CONSTRAINT [DF_PurLedger_SuppInvAmount] DEFAULT (0),
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_PurLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [ICatCode] smallint NULL,
    [MonthlyCounter] int NOT NULL CONSTRAINT [DF_PurLedger_MonthlyCounter] DEFAULT (0),
    [DailyCounter] int NOT NULL CONSTRAINT [DF_PurLedger_DailyCounter] DEFAULT (0),
    [CustCode] smallint NULL,
    [QE1_AccCode] smallint NULL,
    [QE2_AccCode] smallint NULL,
    [QE3_AccCode] smallint NULL,
    [QE4_AccCode] smallint NULL,
    [QE5_AccCode] smallint NULL,
    [WE1_AccCode] smallint NULL,
    [WE2_AccCode] smallint NULL,
    [WE3_AccCode] smallint NULL,
    [WE4_AccCode] smallint NULL,
    [WE5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_QExp1_CrAccCode] DEFAULT (4),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_QExp2_CrAccCode] DEFAULT (4),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_QExp3_CrAccCode] DEFAULT (4),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_QExp4_CrAccCode] DEFAULT (4),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_QExp5_CrAccCode] DEFAULT (4),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_WExp1_CrAccCode] DEFAULT (4),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_WExp2_CrAccCode] DEFAULT (4),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_WExp3_CrAccCode] DEFAULT (4),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_WExp4_CrAccCode] DEFAULT (4),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_WExp5_CrAccCode] DEFAULT (4),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [PurSlipPrintCounter] tinyint NOT NULL CONSTRAINT [DF_PurLedger_PurSlipPrintCounter] DEFAULT (0),
    [TaxCategoryCode] smallint NOT NULL CONSTRAINT [DF_PurLedger_TaxCategory_TaxCategoryCode] DEFAULT (1),
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_PurLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_PurLedger_AdvanceTaxAmt] DEFAULT (0),
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_PurLedger_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_PurLedger_MiscCharges5] DEFAULT (0),
    CONSTRAINT [PK_Purledger] PRIMARY KEY CLUSTERED ([PurInvCode])
);
GO

CREATE TABLE [dbo].[PurledgerMod] (
    [PurInvCode] int NOT NULL,
    [PurCatCode] tinyint NOT NULL,
    [SuppCode] smallint NOT NULL,
    [SuppInvCode] varchar(100) NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [POCode] int NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurledgerMod_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PurledgerMod_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [postdate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SuppInvDate] datetime NULL,
    [GRN] varchar(100) NULL,
    [PORB] char(1) NULL CONSTRAINT [DF_PurledgerMod_PORB_1__11] DEFAULT ('N'),
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_PurledgerMod_InvGSTPerc1_1__10] DEFAULT (0),
    [purtypecode] smallint NULL,
    [HeaderNo] smallint NULL CONSTRAINT [DF_PurledgerMod_HeaderNo] DEFAULT (1),
    [HeaderInvNo] int NULL,
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [df_PurledgerMod_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurledgerMod_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurledgerMod_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_PrintBalance] DEFAULT ('N'),
    [PurInvPageSize] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_PurInvPageSize] DEFAULT ('F'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_PurledgerMod_CurrencyCode] DEFAULT (1),
    [ConversionFactor] numeric(11,5) NOT NULL CONSTRAINT [DF_PurledgerMod_ConversionFactor] DEFAULT (1),
    [PrintCounter] tinyint NOT NULL CONSTRAINT [df_PurledgerMod_printcounter] DEFAULT (0),
    [AssociatedSaleOrderCode] int NULL,
    [AssociatedSaleInvCode] int NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [NewPurchaseOrderNo] varchar(100) NULL,
    [LCNO] varchar(100) NULL,
    [UpdateAvgPriceWithNetRate] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_UpdateAvgPriceWithNetRate] DEFAULT ('N'),
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_ImpactInventory] DEFAULT ('Y'),
    [ImpPurInvCode] int NULL,
    [CreditDays] int NOT NULL CONSTRAINT [DF_PurledgerMod_CreditDays] DEFAULT (0),
    [SuppInvAmount] numeric(15,2) NOT NULL CONSTRAINT [DF_PurledgerMod_SuppInvAmount] DEFAULT (0),
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_PurledgerMod_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [ICatCode] smallint NULL,
    [MonthlyCounter] int NOT NULL CONSTRAINT [DF_PurledgerMod_MonthlyCounter] DEFAULT (0),
    [DailyCounter] int NOT NULL CONSTRAINT [DF_PurledgerMod_DailyCounter] DEFAULT (0),
    [CustCode] smallint NULL,
    CONSTRAINT [PK_PurledgerMod] PRIMARY KEY CLUSTERED ([PurInvCode])
);
GO

CREATE TABLE [dbo].[PurOrderCategory] (
    [PurOrderCatCode] smallint NOT NULL,
    [Name] varchar(50) NOT NULL,
    CONSTRAINT [PK_PurOrderCategory] PRIMARY KEY CLUSTERED ([PurOrderCatCode]),
    CONSTRAINT [UK_PurOrderCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[PurOrderDetail] (
    [POCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_Qty] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_PurOrderDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [PORowId] int IDENTITY(1,1) NOT NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_BonusQty] DEFAULT (0),
    [Stock] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_Stock] DEFAULT (0),
    [ReorderQty] int NOT NULL CONSTRAINT [DF_PurOrderDetail_ReorderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_PurOrderDetail_OptimumQty] DEFAULT (0),
    [MinQty] int NOT NULL CONSTRAINT [DF_PurOrderDetail_MinQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_PurOrderDetail_PackUnits] DEFAULT (1),
    [SoldQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_SoldQty] DEFAULT (0),
    [ReturnQty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_ReturnQty] DEFAULT (0),
    [QtySatisfied] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_QtySatisfied] DEFAULT (0),
    [BonusQtySatisfied] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_BonusQtySatisfied] DEFAULT (0),
    [SaleOrderRequest] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_SaleOrderRequest] DEFAULT (0),
    [TransitStock] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_TransitStock] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurOrderDetail_ItemFlatDisc] DEFAULT (0),
    [PackSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_PurOrderDetail_PackSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PurOrderDetail_GSTPerc] DEFAULT (0),
    [PurPrice] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_PurPrice] DEFAULT (0),
    [SalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_SalePrice] DEFAULT (0),
    [RPP] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_RPP] DEFAULT (0),
    [PackAvgPrice] numeric(15,4) NOT NULL CONSTRAINT [DF_PurOrderDetail_PackAvgPrice] DEFAULT (0),
    [ForeignPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurOrderDetail_ForeignPrice] DEFAULT (0),
    [LastPurInvCode] int NULL,
    [LastPurDate] datetime NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [Discperc2] numeric(5,2) NOT NULL CONSTRAINT [DF_PurOrderDetail_Discperc2] DEFAULT (0),
    [ItemAlertCode] smallint NULL,
    CONSTRAINT [PK_PurOrderDetail_1__11] PRIMARY KEY CLUSTERED ([POCode], [ICode]),
    CONSTRAINT [CK_PurOrderDetail_BonusQtySatisfied] CHECK ([BonusQtySatisfied] >= 0),
    CONSTRAINT [CK_PurOrderDetail_QtySatisfied] CHECK ([QtySatisfied] >= 0)
);
GO

CREATE TABLE [dbo].[PurOrderHeader] (
    [POCode] int NOT NULL,
    [ManfCode] smallint NULL,
    [SuppCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [PurOrderTerms1] varchar(150) NULL,
    [PurOrderTerms2] varchar(150) NULL,
    [PurOrderTerms3] varchar(150) NULL,
    [PurOrderTerms4] varchar(150) NULL,
    [PurOrderTerms5] varchar(150) NULL,
    [PurOrderTerms6] varchar(150) NULL,
    [PurOrderTerms7] varchar(150) NULL,
    [PurOrderTerms8] varchar(150) NULL,
    [ProjectionPeriod] int NOT NULL CONSTRAINT [DF_PurOrderHeader_ProjectionPeriod] DEFAULT (0),
    [ZeroQty] tinyint NOT NULL CONSTRAINT [DF_PurOrderHeader_ZeroQty] DEFAULT (0),
    [StartDate] datetime NULL,
    [EndDate] datetime NULL,
    [PurOrderCatCode] smallint NOT NULL CONSTRAINT [DF_PurOrderHeader_PurOrderCatCode] DEFAULT (1),
    [DemandDraftNo] varchar(50) NULL,
    [Dated] datetime NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [Df_PurOrderHeader_Amount] DEFAULT (0),
    [CustCode] smallint NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_PurOrderHeader_DiscPerc] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PurOrderHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NOT NULL CONSTRAINT [DF_PurOrderHeader_PostDate] DEFAULT (getdate()),
    [SaleOrderCode] int NULL,
    [SupplierReference] varchar(50) NULL,
    [DeliveryLocation] varchar(50) NULL,
    [UsageLocation] varchar(50) NULL,
    [RequiredDate] datetime NULL,
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_PurOrderHeader_InvGSTPerc1] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurOrderHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PurOrderHeader_MiscCharges] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_PurOrderHeader_Marked] DEFAULT ('N'),
    [Remarks2] varchar(100) NULL,
    [Remarks3] varchar(100) NULL,
    [PurQuotationCode] int NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_PurOrderHeader_CurrencyCode] DEFAULT (1),
    [ConversionFactor] numeric(11,5) NOT NULL CONSTRAINT [DF_PurOrderHeader_ConversionFactor] DEFAULT (0),
    [PurTypeCode] smallint NULL,
    [ICatCode] smallint NULL,
    [ListOfPurInvoices] varchar(500) NULL,
    [TotalOfPurchases] numeric(15,2) NOT NULL CONSTRAINT [DF_PurOrderHeader_TotalOfPurchases] DEFAULT (0),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PurOrderHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_PurOrderHeader_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_PurOrderHeader_1__11] PRIMARY KEY CLUSTERED ([POCode])
);
GO

CREATE TABLE [dbo].[PurPayment] (
    [PurPaymentCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_PurPayment_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [PurInvCode] int NOT NULL,
    [NetAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurPayment_NetAmt] DEFAULT (0),
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurPayment_OutstandingAmt] DEFAULT (0),
    [AccCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PurPayment_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [PaymentMode] char(1) NOT NULL CONSTRAINT [DF_PurPayment_PaymentMode] DEFAULT ('C'),
    [PaymentAccCode] smallint NOT NULL,
    [PaymentAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurPayment_PaymentAmt] DEFAULT (0),
    [PaymentCheckNo] varchar(20) NULL,
    [PaymentRemarks] varchar(100) NULL,
    [WHTaxAccCode] smallint NOT NULL CONSTRAINT [DF_PurPayment_WHTaxAccCode] DEFAULT (28),
    [WHTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_PurPayment_WHTaxPerc] DEFAULT (0),
    [WHTaxBaseAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurPayment_WHTaxBaseAmt] DEFAULT (0),
    [WHTaxAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_PurPayment_WHTaxAmt] DEFAULT (0),
    [WHTaxCheckNo] varchar(20) NULL,
    [WHTaxRemarks] varchar(100) NULL,
    [GLVochCode] int NULL,
    CONSTRAINT [PK_PurPayment] PRIMARY KEY CLUSTERED ([PurPaymentCode])
);
GO

CREATE TABLE [dbo].[PurQuotationDetail] (
    [PurQuotationCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Qty] int NOT NULL CONSTRAINT [DF_PurQuotationDetail_Qty] DEFAULT (0),
    [BonusQty] int NOT NULL CONSTRAINT [DF_PurQuotationDetail_BonusQty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_PurQuotationDetail_PackUnits] DEFAULT (1),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurQuotationDetail_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_PurQuotationDetail_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PurQuotationDetail_DiscPerc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_PurQuotationDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PurQuotationDetail_GSTPerc] DEFAULT (0),
    [ItemDescription] varchar(100) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_PurQuotationDetail] PRIMARY KEY CLUSTERED ([PurQuotationCode], [GCode], [ICode])
);
GO

CREATE TABLE [dbo].[PurQuotationHeader] (
    [PurQuotationCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [Remarks] varchar(150) NULL,
    [Remarks2] varchar(150) NULL,
    [Remarks3] varchar(150) NULL,
    [Remarks4] varchar(150) NULL,
    [Remarks5] varchar(150) NULL,
    [RefNo] varchar(30) NULL,
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_PurQuotationHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_PurQuotationHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_PurQuotationHeader_MiscCharges] DEFAULT (0),
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_PurQuotationHeader_InvGSTPerc1] DEFAULT (0),
    [Price] tinyint NOT NULL CONSTRAINT [DF_PurQuotationHeader_Price] DEFAULT (1),
    [ValidUpTo] datetime NOT NULL CONSTRAINT [DF_PurQuotationHeader_ValidUpTo] DEFAULT (getdate()),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PurQuotationHeader_Posted] DEFAULT ('N'),
    [PageSize] char(1) NOT NULL CONSTRAINT [DF_PurQuotationHeader_PageSize] DEFAULT ('Q'),
    [OriginalDate] datetime NULL,
    [PostDate] datetime NULL,
    [SuppCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [PostedBY] smallint NULL,
    [ModifiedBY] smallint NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_PurQuotationHeader_Active] DEFAULT ('Y'),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PurQuotationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_PurQuotationHeader] PRIMARY KEY CLUSTERED ([PurQuotationCode])
);
GO

CREATE TABLE [dbo].[PurRegister] (
    [PurRegisterCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [SuppCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [AreaCode] smallint NOT NULL,
    [ICatCode] smallint NULL,
    [LotNo] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_PurRegister_TotalPieces] DEFAULT (1),
    [TotalMeasure] numeric(15,4) NOT NULL CONSTRAINT [DF_PurRegister_TotalMeasure] DEFAULT (1),
    [TotalAmount] numeric(12,2) NOT NULL CONSTRAINT [DF_PurRegister_TotalAmount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [ReferenceNo] varchar(100) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_PurRegister_Posted] DEFAULT ('N'),
    [PostedBY] smallint NULL,
    [PostDate] datetime NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_PurRegister_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_PurRegister_PurRegisterCode] PRIMARY KEY CLUSTERED ([PurRegisterCode])
);
GO

CREATE TABLE [dbo].[PurRegisterDetail] (
    [PurRegisterCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_PurRegisterDetail_Qty] DEFAULT (1),
    [PurPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_PurRegisterDetail_PurPrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_PurRegisterDetail_PackUnits] DEFAULT (1),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_PurRegisterDetail_TotalPieces] DEFAULT (1),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_PurRegisterDetail] PRIMARY KEY CLUSTERED ([PurRegisterCode], [ICode])
);
GO

CREATE TABLE [dbo].[QualifiedPerson] (
    [QualifiedPersonCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [NIC] varchar(100) NOT NULL,
    [FName] varchar(100) NOT NULL CONSTRAINT [DF_QualifiedPerson_FName] DEFAULT ('.'),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_QualifiedPerson_Gender] DEFAULT ('M'),
    [Address] varchar(1000) NOT NULL CONSTRAINT [DF_QualifiedPerson_Address] DEFAULT ('.'),
    [PhoneNo] varchar(100) NULL,
    [Mobile] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_QualifiedPerson_Date] DEFAULT (getdate()),
    [Degree] varchar(100) NULL,
    [Institute] varchar(100) NULL,
    [PassingYear] varchar(100) NULL,
    CONSTRAINT [PK_QualifiedPerson] PRIMARY KEY CLUSTERED ([QualifiedPersonCode]),
    CONSTRAINT [UK_QualifiedPerson_NIC] UNIQUE ([NIC])
);
GO

CREATE TABLE [dbo].[QualifiedPersonImage] (
    [QualifiedPersonCode] int NOT NULL,
    [ImageDescription] varchar(100) NULL,
    [RowID] int NOT NULL,
    [Img] image NULL,
    [ImageType] varchar(100) NULL,
    CONSTRAINT [PK_QualifiedPersonImage] PRIMARY KEY CLUSTERED ([QualifiedPersonCode], [RowID])
);
GO

CREATE TABLE [dbo].[QuotationDetail] (
    [QuotationCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_QuotationDetail_Qty] DEFAULT (0),
    [PackUnits] smallint NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationDetail_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationDetail_ItemFlatDisc] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_QuotationDetail_BonusQty] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_QuotationDetail_GSTPerc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationDetail_UnitSalesTax] DEFAULT (0),
    [ItemDescription] varchar(100) NULL,
    [gcode] int NOT NULL CONSTRAINT [DF_quotationdetail_gcode] DEFAULT (1),
    [RemoteNetSaleQty] numeric(15,4) NOT NULL CONSTRAINT [DF_QuotationDetail_RemoteNetSaleQty] DEFAULT (0),
    [RemoteStock] numeric(15,4) NOT NULL CONSTRAINT [DF_QuotationDetail_RemoteStock] DEFAULT (0),
    [PORate] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationDetail_PORate] DEFAULT (0),
    [PODiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_QuotationDetail_PODiscPerc] DEFAULT (0),
    [SpecialRate] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationDetail_SpecialRate] DEFAULT (0),
    [RefNo] varchar(100) NULL,
    [ClaimableDiscperc] numeric(5,2) NOT NULL CONSTRAINT [DF_QuotationDetail_ClaimableDiscperc] DEFAULT (0),
    [Color] varchar(100) NULL
);
GO

CREATE TABLE [dbo].[QuotationHeader] (
    [QuotationCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_QuotationHeader_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [SPrice] numeric(1,0) NOT NULL,
    [ValidateUpTo] datetime NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(30) NULL,
    [headerno] smallint NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [Posted] varchar(1) NULL CONSTRAINT [DF_QuotationH_Posted_1__11] DEFAULT ('N'),
    [InvGSTPerc1] numeric(6,2) NOT NULL CONSTRAINT [DF_QuotationHeader_InvGSTPerc1] DEFAULT (0),
    [Remarks2] varchar(150) NULL,
    [Remarks3] varchar(150) NULL,
    [Remarks4] varchar(150) NULL,
    [Remarks5] varchar(150) NULL,
    [Remarks6] varchar(150) NULL,
    [Remarks7] varchar(150) NULL,
    [Remarks8] varchar(150) NULL,
    [Remarks9] varchar(150) NULL,
    [Pagesize] char(1) NOT NULL CONSTRAINT [DF_quotationheader_pagesize] DEFAULT ('Q'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [LoosePack] tinyint NOT NULL CONSTRAINT [DF_QuotationHeader_LoosePack] DEFAULT (1),
    [ConsolidatedSaleOrder] int NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_QuotationHeader_Active] DEFAULT ('Y'),
    [Locked] char(1) NOT NULL CONSTRAINT [DF_QuotationHeader_Locked] DEFAULT ('N'),
    [AutoInsertNewItems] char(1) NOT NULL CONSTRAINT [DF_QuotationHeader_AutoInsertNewItems] DEFAULT ('N'),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_QuotationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [DeliveryDays] int NOT NULL CONSTRAINT [DF_QuotationHeader_DeliveryDays] DEFAULT (0),
    [ValidityDays] int NOT NULL CONSTRAINT [DF_QuotationHeader_ValidityDays] DEFAULT (0),
    [PaymentTo] varchar(100) NULL,
    CONSTRAINT [PK_QuotationHeader_1__10] PRIMARY KEY CLUSTERED ([QuotationCode])
);
GO

CREATE TABLE [dbo].[Rank] (
    [RankCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Rank] PRIMARY KEY CLUSTERED ([RankCode]),
    CONSTRAINT [IX_RankName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ReceiptCategory] (
    [ReceiptCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [Description] varchar(255) NULL,
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_ReceiptCategory_AccountFor] DEFAULT ('Y'),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ReceiptCategory_Posted] DEFAULT ('N'),
    [Counter] int NOT NULL CONSTRAINT [DF_ReceiptCategory_Counter] DEFAULT (0),
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_ReceiptCategory_Enabled] DEFAULT ('Y'),
    CONSTRAINT [PK_ReceiptCategory] PRIMARY KEY CLUSTERED ([ReceiptCategoryCode]),
    CONSTRAINT [UK_ReceiptCategory_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_ReceiptCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ReceiptCategoryAccounts] (
    [ReceiptCategoryCode] smallint NOT NULL,
    [SubAccCode] smallint NOT NULL,
    CONSTRAINT [PK_ReceiptCategoryAccounts] PRIMARY KEY CLUSTERED ([ReceiptCategoryCode], [SubAccCode])
);
GO

CREATE TABLE [dbo].[ReceiptDetail] (
    [ReceiptInvCode] int NOT NULL,
    [Icode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Gcode] smallint NOT NULL,
    [Priority] tinyint NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ReceiptDetail_Qty] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_ReceiptDet_PackUnits_3__15] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_SalePrice] DEFAULT (0),
    [PurchasePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_PurchasePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ReceiptDetail_AvgPrice] DEFAULT (0),
    [MRPP] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_MRPP] DEFAULT (0),
    [ReceiptUTN] bigint NULL,
    [SectCode] smallint NULL,
    [Price] numeric(15,5) NOT NULL CONSTRAINT [DF_ReceiptDetail_Price] DEFAULT (0),
    [UpdateAvgPrice] char(1) NOT NULL CONSTRAINT [DF_ReceiptDetail_UpdateAvgPrice] DEFAULT ('N'),
    [NewAvgPrice] numeric(15,5) NULL,
    [CurrStock] numeric(15,4) NULL,
    [itemdescription] varchar(100) NULL,
    [SaleOrderRowID] int NULL,
    [AlternateCustomICode] varchar(75) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_ReceiptDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_ReceiptDetail_PiecesInHand] DEFAULT (0),
    [IssueRowID] int NULL,
    [ManfDate] datetime NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [UnitWeight] numeric(9,3) NOT NULL CONSTRAINT [DF_ReceiptDetail_UnitWeight] DEFAULT (1),
    [QE1] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_QE1] DEFAULT (0),
    [QE2] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_QE2] DEFAULT (0),
    [QE3] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_QE3] DEFAULT (0),
    [QE4] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_QE4] DEFAULT (0),
    [QE5] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_QE5] DEFAULT (0),
    [WE1] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_WE1] DEFAULT (0),
    [WE2] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_WE2] DEFAULT (0),
    [WE3] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_WE3] DEFAULT (0),
    [WE4] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_WE4] DEFAULT (0),
    [WE5] numeric(12,2) NOT NULL CONSTRAINT [DF_ReceiptDetail_WE5] DEFAULT (0),
    CONSTRAINT [PK_ReceiptDetail_1__18] PRIMARY KEY CLUSTERED ([ReceiptInvCode], [Gcode], [Icode], [Batch], [Expiry])
);
GO

CREATE TABLE [dbo].[ReceiptHeader] (
    [ReceiptInvCode] int NOT NULL,
    [DeptCode] smallint NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Deleted] char(1) NULL,
    [DeletedBy] smallint NULL,
    [Posted] char(1) NOT NULL,
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [AreaCode] smallint NULL,
    [SmanCode] smallint NULL,
    [ReferenceNo] varchar(100) NULL,
    [ReferenceDate] datetime NULL,
    [PriceTypeCode] tinyint NOT NULL CONSTRAINT [DF_ReceiptHeader_PriceType] DEFAULT (4),
    [RecipientCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_RecipientCode] DEFAULT (1),
    [AccCode] smallint NULL,
    [RecipientSalesMan] smallint NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_ReceiptHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [WorkOrderCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ReceiptHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [ReceiptCategoryCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_ReceiptCategoryCode] DEFAULT (1),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_ReceiptHeader_AccountFor] DEFAULT ('N'),
    [CrAccCode] smallint NULL,
    [ReceiptCode] int NOT NULL CONSTRAINT [DF_ReceiptHeader_ReceiptCode] DEFAULT (0),
    [QE1_AccCode] smallint NULL,
    [QE2_AccCode] smallint NULL,
    [QE3_AccCode] smallint NULL,
    [QE4_AccCode] smallint NULL,
    [QE5_AccCode] smallint NULL,
    [WE1_AccCode] smallint NULL,
    [WE2_AccCode] smallint NULL,
    [WE3_AccCode] smallint NULL,
    [WE4_AccCode] smallint NULL,
    [WE5_AccCode] smallint NULL,
    [QExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_QExp1_CrAccCode] DEFAULT (34),
    [QExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_QExp2_CrAccCode] DEFAULT (34),
    [QExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_QExp3_CrAccCode] DEFAULT (34),
    [QExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_QExp34_CrAccCode] DEFAULT (34),
    [QExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_QExp5_CrAccCode] DEFAULT (34),
    [WExp1_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_WExp1_CrAccCode] DEFAULT (34),
    [WExp2_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_WExp2_CrAccCode] DEFAULT (34),
    [WExp3_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_WExp3_CrAccCode] DEFAULT (34),
    [WExp4_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_WExp34_CrAccCode] DEFAULT (34),
    [WExp5_CrAccCode] smallint NOT NULL CONSTRAINT [DF_ReceiptHeader_WExp5_CrAccCode] DEFAULT (34),
    [MotorVehicleCode] int NULL,
    [IssueInvCode] int NULL,
    CONSTRAINT [PK_ReceiptHeader_1__18] PRIMARY KEY CLUSTERED ([ReceiptInvCode]),
    CONSTRAINT [CK_ReceiptHeader] CHECK ([DeptCode] is not null or [AccCode] is not null or [RecipientSalesMan] is not null)
);
GO

CREATE TABLE [dbo].[Recipe] (
    [RecipeCode] int NOT NULL,
    [AliasName] varchar(12) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(400) NULL,
    [ResultedItem] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [Date] datetime NOT NULL,
    [Priority] int NOT NULL CONSTRAINT [DF_RecipeDetail_Priority] DEFAULT (1),
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_Recipe_Qty] DEFAULT (1),
    CONSTRAINT [PK_Recipe_RecipeCode] PRIMARY KEY CLUSTERED ([RecipeCode]),
    CONSTRAINT [UK_Recipe_Name] UNIQUE ([Name]),
    CONSTRAINT [UK_Recipe_AliasName] UNIQUE ([AliasName]),
    CONSTRAINT [UK_Recipe_ResultedItem_Priority] UNIQUE ([ResultedItem], [Priority])
);
GO

CREATE TABLE [dbo].[RecipeDetail] (
    [RecipeCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,7) NOT NULL CONSTRAINT [DF_RecipeDetail_Qty] DEFAULT (1),
    [Remarks] varchar(200) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_RecipeDetail_PackUnits] DEFAULT (1),
    [PackPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_RecipeDetail_PackPrice] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_RecipeDetail_Price] DEFAULT (0),
    [ItemFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_RecipeDetail_ItemFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_RecipeDetail_DiscPerc] DEFAULT (0),
    [ProcessCharge] numeric(10,2) NOT NULL CONSTRAINT [DF_RecipeDetail_ProcessCharge] DEFAULT (0),
    [ProcessChargePerc] numeric(5,2) NOT NULL CONSTRAINT [DF_RecipeDetail_ProcessChargePerc] DEFAULT (0),
    CONSTRAINT [PK_RecipeDetail] PRIMARY KEY CLUSTERED ([RecipeCode], [RowID])
);
GO

CREATE TABLE [dbo].[Recipient] (
    [RecipientCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_Recipient] PRIMARY KEY CLUSTERED ([RecipientCode])
);
GO

CREATE TABLE [dbo].[RefusedSaleDetail] (
    [RefusedSaleInvCode] int NOT NULL,
    [ReasonCode] tinyint NOT NULL,
    [ICode] int NULL,
    [UnknownItemName] varchar(60) NULL,
    [Remarks] varchar(100) NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_RefusedSaleDetail_Qty] DEFAULT (1),
    [TotalStock] numeric(15,4) NOT NULL CONSTRAINT [DF_RefusedSaleDetail_TotalStock] DEFAULT (1),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_RefusedSaleDetail_SalePrice] DEFAULT (0),
    CONSTRAINT [CK_RefusedSaleDetail_ICode_UnknownItemName] CHECK ([ICode] is null and [UnknownItemName] is not null or [ICode] is not null and [UnknownItemName] is null)
);
GO

CREATE TABLE [dbo].[RefusedSaleHeader] (
    [RefusedSaleInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NULL,
    [Remarks] varchar(100) NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_RefusedSaleHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_RefusedSaleHeader_RefusedSaleInvCode] PRIMARY KEY CLUSTERED ([RefusedSaleInvCode])
);
GO

CREATE TABLE [dbo].[Region] (
    [RegionCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Manager] varchar(60) NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_Region_1__10] PRIMARY KEY CLUSTERED ([RegionCode]),
    CONSTRAINT [REGUK] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Relation] (
    [RelationCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Relation] PRIMARY KEY CLUSTERED ([RelationCode]),
    CONSTRAINT [IX_RelationName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ReportData] (
    [code1] numeric(15,4) NULL,
    [code2] numeric(15,4) NULL,
    [value1] numeric(15,2) NULL,
    [value2] numeric(15,2) NULL,
    [value3] numeric(15,2) NULL,
    [date1] datetime NULL,
    [date2] datetime NULL,
    [name1] varchar(100) NULL,
    [name2] varchar(100) NULL,
    [name3] varchar(100) NULL,
    [name4] varchar(100) NULL,
    [value4] numeric(15,2) NULL,
    [value5] numeric(15,2) NULL,
    [value6] numeric(15,2) NULL,
    [value7] numeric(15,2) NULL,
    [value8] numeric(15,2) NULL,
    [code3] numeric(15,4) NULL,
    [Code4] numeric(15,4) NULL,
    [Code5] numeric(15,4) NULL,
    [Name5] varchar(100) NULL,
    [Code6] numeric(15,4) NULL,
    [Code7] numeric(15,4) NULL,
    [Code8] numeric(15,4) NULL,
    [Code9] numeric(15,4) NULL,
    [Code10] numeric(15,4) NULL,
    [Value9] numeric(15,2) NULL,
    [Code11] numeric(15,4) NULL,
    [name6] varchar(100) NULL,
    [NAME7] varchar(100) NULL,
    [NAME8] varchar(100) NULL,
    [Value10] numeric(15,5) NULL,
    [Value11] numeric(15,5) NULL,
    [Value12] numeric(15,5) NULL,
    [Value13] numeric(15,5) NULL,
    [Value14] numeric(15,5) NULL,
    [Value15] numeric(15,5) NULL,
    [Value16] numeric(15,5) NULL,
    [name10] varchar(255) NULL,
    [name11] varchar(255) NULL,
    [value17] numeric(18,2) NULL,
    [value18] numeric(18,2) NULL,
    [BigValue1] bigint NULL,
    [BigValue2] bigint NULL,
    [BigValue3] bigint NULL,
    [BigValue4] bigint NULL,
    [BigValue5] bigint NULL,
    [BigValue6] bigint NULL,
    [BigValue7] bigint NULL,
    [BigValue8] bigint NULL,
    [BigValue9] bigint NULL,
    [BigValue10] bigint NULL
);
GO

CREATE TABLE [dbo].[ReportFilter] (
    [ReportIdentifier] varchar(100) NOT NULL,
    [FilterName] varchar(100) NOT NULL,
    [FilterExpression] varchar(4000) NOT NULL,
    CONSTRAINT [PK_ReportFilter] PRIMARY KEY CLUSTERED ([ReportIdentifier], [FilterName])
);
GO

CREATE TABLE [dbo].[ReportTitles] (
    [ReportId] int NOT NULL,
    [ReportMenu] varchar(150) NOT NULL,
    [ReportTitle] varchar(200) NOT NULL,
    CONSTRAINT [PK_ReportTitle] PRIMARY KEY CLUSTERED ([ReportId])
);
GO

CREATE TABLE [dbo].[Resource] (
    [ResourceCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ResourceCatCode] smallint NOT NULL CONSTRAINT [DF_Resource_ResourceCatCode] DEFAULT (1),
    [Description] varchar(200) NULL,
    [Cost] numeric(15,2) NOT NULL CONSTRAINT [DF_Resource_Cost] DEFAULT (0),
    CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED ([ResourceCode]),
    CONSTRAINT [UK_Resource_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ResourceCategory] (
    [ResourceCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(200) NULL,
    CONSTRAINT [PK_ResourceCatCode] PRIMARY KEY CLUSTERED ([ResourceCatCode]),
    CONSTRAINT [UK_ResourceCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Rights] (
    [RightCode] smallint NOT NULL,
    [RightName] varchar(150) NOT NULL,
    [MenuName] varchar(60) NULL,
    [LevelIndex] smallint NOT NULL,
    [IndicesString] varchar(30) NOT NULL,
    [Object] char(1) NOT NULL CONSTRAINT [DF_Rights_Object_5__11] DEFAULT ('A'),
    [RightCatCode] smallint NOT NULL CONSTRAINT [DF_Rights_RightCatCode] DEFAULT (1),
    CONSTRAINT [PK___4__11] PRIMARY KEY CLUSTERED ([RightCode])
);
GO

CREATE TABLE [dbo].[RightsCategory] (
    [RightCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_RightsCategory] PRIMARY KEY CLUSTERED ([RightCatCode]),
    CONSTRAINT [UQ_RightsCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Rightsclone] (
    [RightCode] smallint NOT NULL,
    [RightName] varchar(150) NOT NULL,
    [MenuName] varchar(60) NULL,
    [LevelIndex] smallint NOT NULL,
    [IndicesString] varchar(30) NOT NULL,
    [Object] char(1) NOT NULL,
    [RightCatCode] smallint NOT NULL CONSTRAINT [DF_RightsClone_RightCatCode] DEFAULT (1),
    CONSTRAINT [PK_Rightsclone] PRIMARY KEY CLUSTERED ([RightCode])
);
GO

CREATE TABLE [dbo].[Route] (
    [RouteCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [LocalRoute] nvarchar(255) NULL,
    CONSTRAINT [PK_Route] PRIMARY KEY CLUSTERED ([RouteCode]),
    CONSTRAINT [UQ_Route_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SaleCategory] (
    [SaleCatCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_SaleCategory] PRIMARY KEY CLUSTERED ([SaleCatCode]),
    CONSTRAINT [SCNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Saledetail] (
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_Saledetail_PackQty_4__12] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_Saledetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_Saledetail_PackUnits_5__12] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Saledetail_DiscPerc_2__12] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_Saledetail_SalesTax_8__12] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Saledetail_GSTPerc_1__10] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_Saledetail_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [df_saledetail_claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaleDetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleDetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_BonusPackQtyForSale] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_RPPUnitRate] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SaleDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SaleDetail_PiecesInHand] DEFAULT (0),
    [PackSalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_PackSalePrice] DEFAULT (0),
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_saledetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_saledetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetail_BatchCost] DEFAULT (0),
    [ItemMeterCode] smallint NULL,
    [MeterReading] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_MeterReading] DEFAULT (0),
    [InsCode] smallint NULL,
    [YourLotNo] varchar(100) NULL,
    [YourExpiry] datetime NULL,
    [YourPacking] varchar(100) NULL,
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_SaleDetail_Width] DEFAULT (1),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_SaleDetail_Length] DEFAULT (1),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_SaleDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CloneItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetail_CloneItemFlatDisc] DEFAULT (0),
    [CloneDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleDetail_CloneDiscPerc] DEFAULT (0),
    [GodownBalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetail_GodownBalanceStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[SaledetailDump] (
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_SaledetailDump_PackQty] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaledetailDump_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaledetailDump_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaledetailDump_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_SaledetailDump_SalesTax] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaledetailDump_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaledetailDump_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [DF_SaledetailDump_claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaledetailDump_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaledetailDump_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_BonusPackQtyForSale] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_RPPUnitRate] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SaledetailDump_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SaledetailDump_PiecesInHand] DEFAULT (0),
    [PackSalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_PackSalePrice] DEFAULT (0),
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_SaledetailDump_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaledetailDump_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_SaledetailDump_BatchCost] DEFAULT (0),
    [ItemMeterCode] smallint NULL,
    [MeterReading] numeric(15,4) NOT NULL CONSTRAINT [DF_SaledetailDump_MeterReading] DEFAULT (0),
    [InsCode] smallint NULL
);
GO

CREATE TABLE [dbo].[SaledetailLog] (
    [SaleLedgerLogID] int NOT NULL,
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_SaledetailLog_PackQty] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaledetailLog_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetailLog_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaledetailLog_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_SaledetailLog_SalesTax] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [Itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetailLog_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaledetailLog_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [Bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_BonusQty] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [df_saledetailLog_Claimable] DEFAULT ('N'),
    [Balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaleDetailLog_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_BonusPackQtyForSale] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_RPPUnitRate] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SaleDetailLog_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SaleDetailLog_PiecesInHand] DEFAULT (0),
    [PackSalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_PackSalePrice] DEFAULT (0),
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_saledetaillog_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_saledetaillog_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetailLog_BatchCost] DEFAULT (0),
    [ItemMeterCode] smallint NULL,
    [MeterReading] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_MeterReading] DEFAULT (0),
    [InsCode] smallint NULL,
    [YourLotNo] varchar(100) NULL,
    [YourExpiry] datetime NULL,
    [YourPacking] varchar(100) NULL,
    [Width] numeric(12,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_Width] DEFAULT (1),
    [Length] numeric(12,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_Length] DEFAULT (1),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_SaleDetailLog_ItemAdvanceTaxPerc] DEFAULT (0),
    [CloneItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_CloneItemFlatDisc] DEFAULT (0),
    [CloneDiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleDetailLog_CloneDiscPerc] DEFAULT (0),
    [GodownBalanceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailLog_GodownBalanceStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[SaleDetailModified] (
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailModified_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailModified_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaleDetailModified_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetailModified_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_SalesTax] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleDetailModified_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleDetailModified_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailModified_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [DF_SaleDetailModified_claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleDetailModified_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaleDetailModified_RowGroup] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[SaleDocument] (
    [SaleInvCode] int NOT NULL,
    [DocDescription] varchar(100) NULL,
    [ROWID] int NOT NULL,
    [Document] image NULL,
    [DocumentType] varchar(100) NULL,
    CONSTRAINT [PK_SaleDocument] PRIMARY KEY CLUSTERED ([SaleInvCode], [ROWID])
);
GO

CREATE TABLE [dbo].[SaleInterface] (
    [InterfaceCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_SaleInterface_InterfaceCode] PRIMARY KEY CLUSTERED ([InterfaceCode]),
    CONSTRAINT [UK_SaleInterface_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SaleInvDetail] (
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleInvDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaleInvDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleInvDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_DiscPerc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleInvDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleInvDetail_BonusQty] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaleInvDetail_RowGroup] DEFAULT (1),
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleInvDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleInvDetail_BonusPackQtyForSale] DEFAULT (0),
    [SourceSaleInvcode] int NULL,
    [SaleRowID] int NULL,
    [DescICode] int NULL,
    [IssueRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_AlternatePurPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_SaleInvDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleInvDetail_ClaimableDiscPerc] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[SaleInvGroup] (
    [SaleInvGroupCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SaleInvGroup_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_SaleInvGroup_SaleInvGroupCode] PRIMARY KEY CLUSTERED ([SaleInvGroupCode])
);
GO

CREATE TABLE [dbo].[SaleInvGroupDetail] (
    [SaleInvGroupCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_SaleInvGroupDetail] PRIMARY KEY CLUSTERED ([SaleInvGroupCode], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[SaleLedger] (
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SaleLedger_InvGSTPerc_1__10] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_PrintWaranty] DEFAULT ('Y'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_PrintBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SaleLedger_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [itemdiscpercno] tinyint NOT NULL CONSTRAINT [DF__saleledge__itemd__2DDCB077] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [df_returncounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [df_SaleLedger_Paid] DEFAULT ('N'),
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_UnReceivedBalance] DEFAULT (0),
    [TotalOfSaleReturns] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_TotalOfReturns] DEFAULT (0),
    [ListOfSrInvoices] varchar(500) NULL,
    [printbalance] char(1) NOT NULL CONSTRAINT [DF_Saleledger_printbalance] DEFAULT ('Y'),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [deliveredby] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_SaleLedger_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleLedger_Balance] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_SALELEDGER_DELETED] DEFAULT ('N'),
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_ImpactInventory] DEFAULT ('Y'),
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_SaleLedger_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_ConsiderInPO] DEFAULT ('Y'),
    [VisitCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_SaleLedger_DueDate] DEFAULT (getdate()),
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedger_CashBack] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_SaleLedger_CashAccCode] DEFAULT (2),
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleId] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [CustSiteCode] int NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Transmited] DEFAULT ('N'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_SaleLedger_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_SaleLedger_ConversionRate] DEFAULT (1),
    [ShipToCustomer] smallint NULL,
    [PreviousReading] int NULL,
    [CurrentReading] int NULL,
    [NextChange] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedger_MiscCharges5] DEFAULT (0),
    [SourceSaleInvCode] int NULL,
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_SaleLedger_AdvanceTaxAmt] DEFAULT (0),
    [ContactCardCode] int NULL,
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleLedger_FBRPOSFee] DEFAULT (0),
    [PaidViaAPI] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_PaidViaAPI] DEFAULT ('N'),
    [PaymentAPI] varchar(100) NULL,
    [PaymentAPITranNo] varchar(10) NULL,
    [PaymentAPIOTP] varchar(20) NULL,
    [MotorVehicleCode] int NULL,
    [CashierShiftCode] int NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_SaleLedger_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_SaleLedger] PRIMARY KEY CLUSTERED ([SaleInvCode])
);
GO

CREATE TABLE [dbo].[SaleLedgerDump] (
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_FlatDisc] DEFAULT (0),
    [MiscCHARges] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_MiscCHARges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrINTingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SaleLedgerDump_InvGSTPerc] DEFAULT (0),
    [PrINTWaranty] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_PrINTWaranty] DEFAULT ('Y'),
    [PrINTBatch] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_PrINTBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerDump_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerDump_ItemDiscPercNo] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [DF_SaleLedgerDump_ReturnCounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Paid] DEFAULT ('N'),
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_UnReceivedBalance] DEFAULT (0),
    [TotalOfSaleReturns] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_TotalOfReturns] DEFAULT (0),
    [ListOfSrInvoices] varchar(500) NULL,
    [prINTbalance] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_prINTbalance] DEFAULT ('Y'),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [deliveredby] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerDump_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Balance] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_DELETED] DEFAULT ('N'),
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_ImpactInventory] DEFAULT ('Y'),
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_SaleLedgerDump_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_ConsiderInPO] DEFAULT ('Y'),
    [VisitCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_SaleLedgerDump_DueDate] DEFAULT (getdate()),
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_CashTendered] DEFAULT (0),
    [CashCHARged] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_CashCHARged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerDump_CashBack] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerDump_CashAccCode] DEFAULT (2),
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleId] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [CustSiteCode] int NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerDump_Transmited] DEFAULT ('N'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerDump_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_SaleLedgerDump_ConversionRate] DEFAULT (1),
    [ShipToCustomer] smallint NULL,
    CONSTRAINT [PK_SaleLedgerDump] PRIMARY KEY CLUSTERED ([SaleInvCode])
);
GO

CREATE TABLE [dbo].[SaleLedgerLog] (
    [SaleLedgerLogID] int NOT NULL,
    [SaleLogDate] datetime NOT NULL CONSTRAINT [DF_SaleLedgerLog_SaleLogDate] DEFAULT (getdate()),
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SaleLedgerLog_InvGSTPerc1] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_PrintWaranty] DEFAULT ('Y'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_PrintBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerLog_GSTNo] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerLog_Itemdiscpercno] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [DF_SaleLedgerLog_RreturnCounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [df_SaleLedgerLog_Paid] DEFAULT ('N'),
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_UnReceivedBalance] DEFAULT (0),
    [TotalOfSaleReturns] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_TotalOfReturns] DEFAULT (0),
    [ListOfSrInvoices] varchar(500) NULL,
    [printbalance] char(1) NOT NULL CONSTRAINT [DF_Saleledgerlog_printbalance] DEFAULT ('Y'),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [deliveredby] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerLog_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Balance] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_SALELEDGERLOG_DELETED] DEFAULT ('N'),
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_ImpactInventory] DEFAULT ('Y'),
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_SaleLedgerLog_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_ConsiderInPO] DEFAULT ('Y'),
    [VisitCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_SaleLedgerLog_DueDate] DEFAULT (getdate()),
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_CashBack] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerLog_CashAccCode] DEFAULT (2),
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleId] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [CustSiteCode] int NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Transmited] DEFAULT ('N'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_SaleLedgerLog_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_SaleLedgerLog_ConversionRate] DEFAULT (1),
    [ShipToCustomer] smallint NULL,
    [PreviousReading] int NULL,
    [CurrentReading] int NULL,
    [NextChange] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_MiscCharges5] DEFAULT (0),
    [SourceSaleInvCode] int NULL,
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_SaleLedgerLog_AdvanceTaxAmt] DEFAULT (0),
    [ContactCardCode] int NULL,
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleLedgerLog_FBRPOSFee] DEFAULT (0),
    [PaidViaAPI] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_PaidViaAPI] DEFAULT ('N'),
    [PaymentAPI] varchar(100) NULL,
    [PaymentAPITranNo] varchar(10) NULL,
    [PaymentAPIOTP] varchar(20) NULL,
    [MotorVehicleCode] int NULL,
    [CashierShiftCode] int NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerLog_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_SaleLedgerLog] PRIMARY KEY CLUSTERED ([SaleLedgerLogID])
);
GO

CREATE TABLE [dbo].[SaleLedgerModified] (
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerModified_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleLedgerModified_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SaleLedgerModified_InvGSTPerc1] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_PrintWaranty] DEFAULT ('Y'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_PrintBatch] DEFAULT ('Y'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerModified_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleLedgerModified_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_SaleLedgerModified_ItemDiscPercNo] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [DF_SaleLedgerModified_Returncounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_Paid] DEFAULT ('N'),
    [EditableSaleInvCode] int NULL,
    [PrintBalance] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_PrintBalance] DEFAULT ('N'),
    [DeliveredBy] smallint NULL,
    [BillingDate] datetime NULL,
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleLedgerModified_Balance] DEFAULT (0),
    [Amt] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleLedgerModified_Amt] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_saleledgermodified_SaleTypeCode] DEFAULT (1),
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_SaleLedgerModified_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_SaleLedgerModified_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_SaleLedgerModified_DueDate] DEFAULT (getdate()),
    [CustRefNo5] varchar(100) NULL,
    [CustSiteCode] int NULL,
    [PreviousReading] int NULL,
    [CurrentReading] int NULL,
    [NextChange] int NULL,
    CONSTRAINT [PK_SaleLedgerModified] PRIMARY KEY CLUSTERED ([SaleInvCode])
);
GO

CREATE TABLE [dbo].[SaleOrderCategory] (
    [SOCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(10) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_SaleOrderCategory_Counter] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_SaleOrderCategory_Posted] DEFAULT ('N'),
    CONSTRAINT [PK_SaleOrderCategory] PRIMARY KEY CLUSTERED ([SOCatCode]),
    CONSTRAINT [UK_SaleOrderCategory_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_SaleOrderCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SaleOrderDetail] (
    [SaleOrderCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleOrderDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaleOrderDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleOrderDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_DiscPerc] DEFAULT (0),
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SaleOrderDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_UnitSalestax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_GSTPerc] DEFAULT (0),
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleOrderDetail_BonusQty] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SaleOrderDetail_RowGroup] DEFAULT (1),
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleOrderDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleOrderDetail_BonusPackQtyForSale] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [SaleOrderItemStatusCode] smallint NULL,
    [QuotationRowID] int NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [PrescriptionRowID] int NULL,
    [Batch] varchar(100) NOT NULL CONSTRAINT [DF_SaleOrderDetail_Batch] DEFAULT ('.'),
    [Expiry] datetime NOT NULL CONSTRAINT [DF_SaleOrderDetail_Expiry] DEFAULT (getdate()),
    [StrengthPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_StrengthPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_SaleOrderDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_ClaimableDiscPerc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderDetail_ItemAdvanceTaxPerc] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[SaleOrderHeader] (
    [SaleOrderCode] int NOT NULL,
    [QuotationCode] int NULL,
    [CustCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NULL,
    [BillingDate] datetime NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges] DEFAULT (0),
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SaleOrderHeader_InvGSTPerc1] DEFAULT (0),
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_SaleOrderHeader_PostDate] DEFAULT (getdate()),
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_InvoiceSize] DEFAULT ('Q'),
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SaleOrderHeader_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_InvTotal] DEFAULT (0),
    [SPrice] numeric(1,0) NULL,
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(100) NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [RePrintingCounter] tinyint NULL,
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [ItemDiscPercNo] tinyint NOT NULL CONSTRAINT [DF_SaleOrderHeader_ItemDiscPercNo] DEFAULT (1),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [DeliveredBy] smallint NULL,
    [PptCustCode] smallint NULL,
    [Deleted] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_Deleted] DEFAULT ('N'),
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_Finalized] DEFAULT ('N'),
    [PresCode] int NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [SOCatCode] smallint NOT NULL CONSTRAINT [DF_SaleOrderHeader_SOCatCode] DEFAULT (1),
    [OrderCode] int NOT NULL CONSTRAINT [DF_SaleOrderHeader_OrderCode] DEFAULT (0),
    [DeliveryDeadLine] datetime NULL,
    [LateDeliveryCharges] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_LateDeliveryCharges] DEFAULT (0),
    [CustSiteCode] int NULL,
    [ClientInstanceID] smallint NULL,
    [CRS_Sent] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_CRS_Sent] DEFAULT ('N'),
    [CRS_SentOn] datetime NULL,
    [SectCode] smallint NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [OldSaleInvCode] int NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_SaleOrderHeader_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NULL CONSTRAINT [DF_SaleOrderHeader_AdvanceTaxAmt] DEFAULT (0),
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_MiscCharges5] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleOrderHeader_FBRPOSFee] DEFAULT (0),
    CONSTRAINT [PK_SaleOrderHeader] PRIMARY KEY CLUSTERED ([SaleOrderCode])
);
GO

CREATE TABLE [dbo].[SaleOrderItemStatus] (
    [SaleOrderItemStatusCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_SaleOrderItemStatus] PRIMARY KEY CLUSTERED ([SaleOrderItemStatusCode]),
    CONSTRAINT [UK_SaleOrderItemStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[salepricecategory] (
    [SalePriceCatCode] smallint NOT NULL,
    [Name] varchar(30) NOT NULL,
    CONSTRAINT [PK_salepricecategory_1__10] PRIMARY KEY CLUSTERED ([SalePriceCatCode])
);
GO

CREATE TABLE [dbo].[SalePromotion] (
    [SalePromotionCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_SalePromotion_Active] DEFAULT ('Y'),
    [CustomerGroupCode] int NOT NULL,
    [DefaultItemDiscPerc] smallint NOT NULL CONSTRAINT [DF_SalePromotion_DefaultItemDiscPerc] DEFAULT (1),
    [WeekDayCode] tinyint NOT NULL CONSTRAINT [DF_SalePromotion_WeekDayCode] DEFAULT (0),
    [StartDate] datetime NOT NULL CONSTRAINT [DF_SalePromotion_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_SalePromotion_EndDate] DEFAULT (getdate() + 365),
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_SalePromotion] PRIMARY KEY CLUSTERED ([SalePromotionCode]),
    CONSTRAINT [UK_SalePromotion_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SaleReceivableAdj] (
    [SaleInvCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Debit] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleReceivableAdj_Debit] DEFAULT (0),
    [Credit] numeric(15,2) NOT NULL CONSTRAINT [DF_SaleReceivableAdj_Credit] DEFAULT (0),
    [CheckNo] varchar(20) NULL,
    [Remarks] varchar(100) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[SaleRefusalReason] (
    [ReasonCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_SaleRefusalReason_ReasonCode] PRIMARY KEY CLUSTERED ([ReasonCode]),
    CONSTRAINT [UK_SaleRefusalReason_Reason] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SalesDiscountPolicy] (
    [SaleLimit] numeric(15,2) NOT NULL CONSTRAINT [DF_SalesDiscountPolicy_SaleLimit] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SalesDiscountPolicy_DiscPerc] DEFAULT (0),
    CONSTRAINT [PK_SalesDiscountPolicy] PRIMARY KEY CLUSTERED ([SaleLimit])
);
GO

CREATE TABLE [dbo].[SaleSetsDetail] (
    [SetCode] int NOT NULL,
    [ICode] int NOT NULL,
    [RowGroup] int NOT NULL,
    CONSTRAINT [PK_SaleSetsDetail] PRIMARY KEY CLUSTERED ([SetCode], [ICode], [RowGroup])
);
GO

CREATE TABLE [dbo].[SaleSetsHeader] (
    [SetCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [SetICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleSetsHeader_SalePrice] DEFAULT (0),
    [RecipeCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SaleSetsHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_SaleSetsHeader] PRIMARY KEY CLUSTERED ([SetCode])
);
GO

CREATE TABLE [dbo].[SaleSetsOrigDetail] (
    [SetCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_SalePrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_PackUnits] DEFAULT (0),
    [ItemFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_ItemFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_DiscPerc] DEFAULT (0),
    [ProcessCharge] numeric(10,2) NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_ProcessCharge] DEFAULT (0),
    [ProcessChargePerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SaleSetsOrigDetail_ProcessChargePerc] DEFAULT (0),
    [Remarks] varchar(200) NULL,
    CONSTRAINT [PK_SaleSetsOrigDetail] PRIMARY KEY CLUSTERED ([SetCode], [ICode])
);
GO

CREATE TABLE [dbo].[SalesMan] (
    [SalesManCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Address] varchar(100) NULL,
    [Phone] varchar(20) NULL,
    [ACTIVE] char(1) NOT NULL CONSTRAINT [DF_SalesMan_Active] DEFAULT ('Y'),
    [NICNo] varchar(100) NULL,
    [OutstandingLimit] numeric(12,2) NOT NULL CONSTRAINT [DF_SalesMan_OutstandingLimit] DEFAULT (0),
    [SalePerson] char(1) NULL CONSTRAINT [DF_SalesMan_SalePerson] DEFAULT ('Y'),
    [DeliveryPerson] char(1) NULL CONSTRAINT [DF_SalesMan_DeliveryPerson] DEFAULT ('Y'),
    [RecoveryPerson] char(1) NULL CONSTRAINT [DF_SalesMan_RecoveryPerson] DEFAULT ('Y'),
    [SaleTarget] numeric(15,2) NOT NULL CONSTRAINT [DF_Salesman_SaleTarget] DEFAULT (0),
    CONSTRAINT [PK___SalesManCode] PRIMARY KEY CLUSTERED ([SalesManCode]),
    CONSTRAINT [SalesManNameUK] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SalesManScope] (
    [SalesManCode] smallint NOT NULL,
    [ManfCode] smallint NOT NULL,
    [SubAreaCode] smallint NOT NULL,
    [WeekDayCode] tinyint NOT NULL,
    CONSTRAINT [PK_SalesManScope] PRIMARY KEY CLUSTERED ([SalesManCode], [ManfCode], [SubAreaCode], [WeekDayCode])
);
GO

CREATE TABLE [dbo].[SalesTaxSchedule] (
    [SalesTaxScheduleCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [TaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SalesTaxSchedule_TaxPerc] DEFAULT (0),
    [TaxType] char(1) NOT NULL CONSTRAINT [DF_SalesTaxSchedule_TaxType] DEFAULT ('S'),
    [Applicable] char(1) NOT NULL CONSTRAINT [DF_SalesTaxSchedule_Applicable] DEFAULT ('Y'),
    CONSTRAINT [PK_SalesTaxSchedule] PRIMARY KEY CLUSTERED ([SalesTaxScheduleCode]),
    CONSTRAINT [UK_SalesTaxSchedule_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SalesTeam] (
    [SaleTeamCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ManfCode] smallint NOT NULL,
    [Manager] varchar(60) NULL,
    [Remarks] varchar(60) NOT NULL,
    CONSTRAINT [PK_SalesTeam] PRIMARY KEY CLUSTERED ([SaleTeamCode]),
    CONSTRAINT [UK_SalesTeam_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SalesTeamMember] (
    [SaleTeamCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    CONSTRAINT [PK_SalesTeamMember] PRIMARY KEY CLUSTERED ([SaleTeamCode], [SalesManCode])
);
GO

CREATE TABLE [dbo].[SaleTemplateDetail] (
    [SaleTemplateCode] int NOT NULL,
    [icode] int NOT NULL,
    [Rowid] int IDENTITY(1,1) NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_SaleTempla_PackQty_3__10] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(8,2) NOT NULL CONSTRAINT [DF_SaleTempla_DiscPerc_2__10] DEFAULT (0),
    [ItemFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_ItemFlatDisc] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_UnitSalesTax] DEFAULT (0),
    [GstPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_GstPerc] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SaleTemplateDetail_PackUnits] DEFAULT (1),
    [Remarks] varchar(100) NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_BonusQty] DEFAULT (0),
    [SaleInvCode] int NULL,
    [SaleDate] datetime NULL,
    [CustCode] smallint NULL,
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SaleTemplateDetail_Marked] DEFAULT ('Y'),
    [SaleCatCode] tinyint NULL
);
GO

CREATE TABLE [dbo].[SaleTemplateHeader] (
    [SaleTemplateCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [Modified] datetime NOT NULL,
    [Name] varchar(100) NOT NULL,
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_SaleTemplateHeader_HeaderNo] DEFAULT (1),
    CONSTRAINT [PK_SaleTemplateHeader_1__10] PRIMARY KEY CLUSTERED ([SaleTemplateCode])
);
GO

CREATE TABLE [dbo].[SaleType] (
    [SaleTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_SaleType_Counter] DEFAULT (0),
    CONSTRAINT [PK_SaleType_SaleTypeCode] PRIMARY KEY CLUSTERED ([SaleTypeCode]),
    CONSTRAINT [UQ_SaleType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SampleDetail] (
    [SampleCode] int NOT NULL,
    [SampleTypeCode] smallint NOT NULL,
    [ServiceRowID] int NOT NULL,
    [Volume] numeric(10,5) NOT NULL CONSTRAINT [DF_SampleDetail_Volume] DEFAULT (0),
    [Color] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_SampleDetail] PRIMARY KEY CLUSTERED ([SampleCode], [SampleTypeCode], [ServiceRowID])
);
GO

CREATE TABLE [dbo].[Samples] (
    [SampleCode] int NOT NULL,
    [SampleDate] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Comments] varchar(1000) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_Samples_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBY] smallint NULL,
    [Processed] char(1) NOT NULL CONSTRAINT [DF_Samples_Processed] DEFAULT ('N'),
    [ProcessedDate] datetime NULL,
    [ProcessedBy] smallint NULL,
    [Finalized] char(1) NOT NULL CONSTRAINT [DF_Samples_Finalized] DEFAULT ('N'),
    [ServiceInvCode] int NOT NULL CONSTRAINT [DF_Samples_ServiceInvCode] DEFAULT (1),
    CONSTRAINT [PK_Samples_SampleCode] PRIMARY KEY CLUSTERED ([SampleCode])
);
GO

CREATE TABLE [dbo].[SampleType] (
    [SampleTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_SampleType_SampleTypeCode] PRIMARY KEY CLUSTERED ([SampleTypeCode]),
    CONSTRAINT [UK_SampleType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SBuffer] (
    [SaleInvCode] int NOT NULL,
    [SaleCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [date] datetime NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SBuffer_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_SBuffer_SalesTax] DEFAULT (0),
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_SBuffer_Posted] DEFAULT ('N'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_SBuffer_PostDate] DEFAULT (getdate()),
    [Remarks] varchar(100) NULL,
    [CustRefNo] varchar(30) NULL,
    [headerno] smallint NULL,
    [headerinvno] int NULL,
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [SPrice] numeric(1,0) NULL,
    [QuotationNo] int NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [RePrintingCounter] tinyint NULL,
    [CashReceived] numeric(15,2) NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SBuffer_InvGSTPerc1] DEFAULT (0),
    [PrintWaranty] char(1) NOT NULL CONSTRAINT [DF_SBuffer_PrintWaranty] DEFAULT ('N'),
    [PrintBatch] char(1) NOT NULL CONSTRAINT [DF_SBuffer_PrintBatch] DEFAULT ('N'),
    [MessageCode] smallint NULL,
    [SManCode] smallint NULL,
    [InvoiceSize] char(1) NOT NULL CONSTRAINT [DF_SBuffer_InvoiceSize] DEFAULT ('Q'),
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [GSTNO] tinyint NOT NULL CONSTRAINT [DF_SBuffer_GSTNO] DEFAULT (1),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_InvTotal] DEFAULT (0),
    [MachineName] varchar(20) NULL,
    [ModifyCounter] tinyint NULL,
    [itemdiscpercno] tinyint NOT NULL CONSTRAINT [DF_SBuffer_itemdiscpercno] DEFAULT (1),
    [RelationCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [WardCode] smallint NULL,
    [AdmissionCode] int NULL,
    [ReturnCounter] int NOT NULL CONSTRAINT [DF_SBuffer_returncounter] DEFAULT (0),
    [Paid] char(1) NOT NULL CONSTRAINT [df_SBuffer_Paid] DEFAULT ('N'),
    [BillingDate] datetime NULL,
    [UnReceivedBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_UnReceivedBalance] DEFAULT (0),
    [TotalOfSaleReturns] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_TotalOfReturns] DEFAULT (0),
    [ListOfSrInvoices] varchar(500) NULL,
    [printbalance] char(1) NOT NULL CONSTRAINT [DF_SBuffer_printbalance] DEFAULT ('Y'),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SBuffer_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Marked] DEFAULT ('N'),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [deliveredby] smallint NULL,
    [SaleTypeCode] smallint NOT NULL CONSTRAINT [DF_SBuffer_SaleTypeCode] DEFAULT (1),
    [Balance] numeric(15,5) NOT NULL CONSTRAINT [DF_SBuffer_Balance] DEFAULT (0),
    [PptCustCode] smallint NULL,
    [DELETED] char(1) NOT NULL CONSTRAINT [DF_SBuffer_DELETED] DEFAULT ('N'),
    [PresCode] int NULL,
    [ImpactInventory] char(1) NOT NULL CONSTRAINT [DF_SBuffer_ImpactInventory] DEFAULT ('Y'),
    [SaleOrderCode] int NULL,
    [SaleComments1] varchar(150) NULL,
    [SaleComments2] varchar(150) NULL,
    [AlterSaleInvCode] int NULL,
    [RecurringInvoice] char(1) NOT NULL CONSTRAINT [DF_SBuffer_RecurringInvoice] DEFAULT ('N'),
    [RecurringPeriod] int NOT NULL CONSTRAINT [DF_SBuffer_RecurringPeriod] DEFAULT (0),
    [LastRecurringInvCode] int NULL,
    [RecurringAgainst] int NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_SBuffer_ConsiderInPO] DEFAULT ('Y'),
    [VisitCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_SBuffer_DueDate] DEFAULT (getdate()),
    [SRBufferInvCode] int NULL,
    [CustRefNo5] varchar(100) NULL,
    [GCCode] smallint NULL,
    [GRN] varchar(100) NULL,
    [SuppInvCode] varchar(100) NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuaranteePersonCode] smallint NULL,
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SBuffer_CashBack] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_SBuffer_CashAccCode] DEFAULT (2),
    [CustLicNo] varchar(100) NULL,
    [CustLicExpiry] datetime NULL,
    [ModuleId] int NULL,
    [DocCode] int NULL,
    [SaleTypeInvNo] int NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_SBuffer_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [CustSiteCode] int NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Transmited] DEFAULT ('N'),
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_SBuffer_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_SBuffer_ConversionRate] DEFAULT (1),
    [ShipToCustomer] smallint NULL,
    [PreviousReading] int NULL,
    [CurrentReading] int NULL,
    [NextChange] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SBuffer_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [MiscCharges1] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges1] DEFAULT (0),
    [MiscCharges2] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges2] DEFAULT (0),
    [MiscCharges3] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges3] DEFAULT (0),
    [MiscCharges4] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges4] DEFAULT (0),
    [MiscCharges5] numeric(12,2) NOT NULL CONSTRAINT [DF_SBuffer_MiscCharges5] DEFAULT (0),
    CONSTRAINT [PK_SBuffer] PRIMARY KEY CLUSTERED ([SaleInvCode])
);
GO

CREATE TABLE [dbo].[SBufferDetail] (
    [SaleInvcode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL CONSTRAINT [DF_SBufferDetail_PackQty] DEFAULT (1),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_LooseQty] DEFAULT (1),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF_SBufferDetail_PackUnits] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_SalePrice] DEFAULT (0),
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SBufferDetail_AvgPrice] DEFAULT (0),
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SBufferDetail_DiscPerc] DEFAULT (0),
    [SalesTax] numeric(7,2) NOT NULL CONSTRAINT [DF_SBufferDetail_SalesTax] DEFAULT (0),
    [RowID] int NOT NULL,
    [Due] char(1) NULL,
    [SatisfiedDate] datetime NULL,
    [itemflatdisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_ItemFlatDisc] DEFAULT (0),
    [SaleItemDescription] varchar(100) NULL,
    [PackPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SBufferDetail_PackPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SBufferDetail_GSTPerc] DEFAULT (0),
    [SaleUtn] bigint NULL,
    [bonusqty] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_BonusQty] DEFAULT (0),
    [claimable] char(1) NOT NULL CONSTRAINT [df_SBufferDetail_claimable] DEFAULT ('N'),
    [balancestock] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_BalanceStock] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_SBufferDetail_RowGroup] DEFAULT (1),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SBufferDetail_ClaimableDiscPerc] DEFAULT (0),
    [ManfDate] datetime NULL,
    [PackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_PackQtyForSale] DEFAULT (0),
    [BonusPackQtyForSale] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_BonusPackQtyForSale] DEFAULT (0),
    [SaleOrderRowID] int NULL,
    [DescICode] int NULL,
    [SourceSaleInvCode] int NULL,
    [SaleRowID] int NULL,
    [IssueRowID] int NULL,
    [PurUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_PurUnitRate] DEFAULT (0),
    [RPPUnitRate] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_RPPUnitRate] DEFAULT (0),
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SBufferDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SBufferDetail_PiecesInHand] DEFAULT (0),
    [PackSalePrice] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_PackSalePrice] DEFAULT (0),
    [RefusalSaleRowID] int NULL,
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_SBufferDetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SBufferDetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [BatchCost] numeric(15,5) NOT NULL CONSTRAINT [DF_SBufferDetail_BatchCost] DEFAULT (0),
    [ItemMeterCode] smallint NULL,
    [MeterReading] numeric(15,4) NOT NULL CONSTRAINT [DF_SBufferDetail_MeterReading] DEFAULT (0),
    [InsCode] smallint NULL
);
GO

CREATE TABLE [dbo].[School] (
    [SchoolCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_School] PRIMARY KEY CLUSTERED ([SchoolCode]),
    CONSTRAINT [UK_School_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SchoolBranch] (
    [SchoolBranchCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_SchoolBranch] PRIMARY KEY CLUSTERED ([SchoolBranchCode]),
    CONSTRAINT [UK_SchoolBranch_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SchoolLeaving] (
    [SchoolLeavingCode] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_SchoolLeaving_Date] DEFAULT (getdate()),
    [StudentCode] int NOT NULL,
    [ClassCode] int NOT NULL,
    [RollNo] varchar(40) NOT NULL,
    [AdmissionDate] datetime NOT NULL CONSTRAINT [DF_SchoolLeaving_AdmissionDate] DEFAULT (getdate()),
    [LastServiceInvCode] int NULL,
    [LastServiceInvDate] datetime NULL,
    [Reason] varchar(255) NULL,
    [UserCode] smallint NOT NULL,
    [GraduationRowID] int NULL,
    CONSTRAINT [PK_SchoolLeaving] PRIMARY KEY CLUSTERED ([SchoolLeavingCode])
);
GO

CREATE TABLE [dbo].[SE] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_SE_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [CVSExam] smallint NULL,
    [PericardialRubExam] char(1) NULL,
    [S3Exam] char(1) NULL,
    [S4Exam] char(1) NULL,
    [OSExam] char(1) NULL,
    [OtherExam] varchar(255) NULL,
    [ChestExaminationExam] char(1) NULL,
    [BilateralNormalVesicularBreathingExam] char(1) NULL,
    [BilateralCrepitationExam] char(1) NULL,
    [RonchiExam] char(1) NULL,
    [WheezingExam] char(1) NULL,
    [RightBronchialBreathingExam] char(1) NULL,
    [LeftBronchialBreathingExam] char(1) NULL,
    [BilateralBronchialBreathingExam] char(1) NULL,
    [AbsentAirEntryExam] char(1) NULL,
    [PeripheralPulsesExaminationExam] char(1) NULL,
    [PalpablebilaterallyinupperandlowerlimbExam] char(1) NULL,
    [AbsentinLeftExam] char(1) NULL,
    [RadialAbsentinLeftExam] char(1) NULL,
    [UlnarAbsentinLeftExam] char(1) NULL,
    [BrachialAbsentinLeftExam] char(1) NULL,
    [AbsentinRightExam] char(1) NULL,
    [RadialAbsentinRightExam] char(1) NULL,
    [UlnarAbsentinRightExam] char(1) NULL,
    [BrachialAbsentinRightExam] char(1) NULL,
    [AbsentinLeft2Exam] char(1) NULL,
    [FemoralAbsentinLeft2Exam] char(1) NULL,
    [PoplitialAbsentinLeft2Exam] char(1) NULL,
    [PosteriorTibbialAbsentinLeft2Exam] char(1) NULL,
    [DorsalisPaedisAbsentinLeft2Exam] char(1) NULL,
    [AbsentinRight2Exam] char(1) NULL,
    [FemoralAbsentinRight2Exam] char(1) NULL,
    [PoplitialAbsentinRight2Exam] char(1) NULL,
    [PosteriorTibbialAbsentinRight2Exam] char(1) NULL,
    [DorsalisPaedisAbsentinRight2Exam] char(1) NULL,
    [OtherSystemicAbnormalFindingsExam] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_SE_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_SE_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[Section] (
    [SectCode] smallint NOT NULL,
    [Name] varchar(40) NOT NULL,
    [Description] varchar(100) NULL,
    [Deptcode] smallint NULL,
    CONSTRAINT [PK_Section_SectCode] PRIMARY KEY CLUSTERED ([SectCode]),
    CONSTRAINT [UQ_Section_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Sequence] (
    [SequenceId] numeric(18,0) NOT NULL,
    [AppVersion] numeric(18,0) NOT NULL,
    [DBStatus] tinyint NOT NULL
);
GO

CREATE TABLE [dbo].[ServerDate] (
    [LastTransDate] datetime NOT NULL
);
GO

CREATE TABLE [dbo].[ServerDateMonth] (
    [LastMonthDate] datetime NOT NULL CONSTRAINT [DF_ServerDateMonth_LastMonthDate] DEFAULT (getdate())
);
GO

CREATE TABLE [dbo].[ServerDateMonthPur] (
    [LastMonthDate] datetime NOT NULL CONSTRAINT [DF_ServerDateMonthPur_LastMonthDate] DEFAULT (getdate())
);
GO

CREATE TABLE [dbo].[Service] (
    [ServiceCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_Price] DEFAULT (0),
    [Description] varchar(1000) NULL,
    [ServiceCatCode] smallint NOT NULL CONSTRAINT [DF_Service_ServiceCatCode] DEFAULT (1),
    [Commission] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_Commission] DEFAULT (0),
    [ProcessDays] int NOT NULL CONSTRAINT [DF_Service_ProcessDays] DEFAULT (0),
    [ProcessHours] int NOT NULL CONSTRAINT [DF_Service_ProcessHours] DEFAULT (0),
    [ProcessMin] int NOT NULL CONSTRAINT [DF_Service_ProcessMin] DEFAULT (0),
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_Service_CostPrice] DEFAULT (0),
    [ResultRequired] char(1) NOT NULL CONSTRAINT [DF_Services_ResultRequired] DEFAULT ('N'),
    [PrintOnNewPage] char(1) NOT NULL CONSTRAINT [DF_Service_PrintOnNewPage] DEFAULT ('N'),
    [ServiceResultTemplate] int NULL,
    [Printable] char(1) NOT NULL CONSTRAINT [DF_Service_Printable] DEFAULT ('Y'),
    [TicketRequired] char(1) NOT NULL CONSTRAINT [DF_Service_TicketRequired] DEFAULT ('N'),
    [AliasName] varchar(60) NOT NULL CONSTRAINT [DF_Service_AliasName] DEFAULT (''),
    [ServicePricePolicyCode] int NULL,
    [ServiceResultStyleCode] tinyint NOT NULL CONSTRAINT [DF_Service_ServiceResultStyleCode] DEFAULT (1),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_Service_ServiceFlatDisc] DEFAULT (0),
    [AllowSaleInDecimal] char(1) NOT NULL CONSTRAINT [DF_Service_AllowSaleInDecimal] DEFAULT ('N'),
    [ServiceTypeCode] smallint NOT NULL CONSTRAINT [DF_Service_ServiceTypeCode] DEFAULT (1),
    [LockPrice] char(1) NOT NULL CONSTRAINT [DF_Service_LockPrice] DEFAULT ('N'),
    [LockDiscPerc] char(1) NOT NULL CONSTRAINT [DF_Service_LockDiscPerc] DEFAULT ('N'),
    [LockServiceFlatDisc] char(1) NOT NULL CONSTRAINT [DF_Service_LockServiceFlatDisc] DEFAULT ('N'),
    [Active] char(1) NOT NULL CONSTRAINT [DF_Service_Active] DEFAULT ('Y'),
    [ServiceGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Service_ServiceGSTPerc] DEFAULT (0),
    [ServiceFlatTax] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_ServiceFlatTax] DEFAULT (0),
    [SharePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_Service_SharePerc] DEFAULT (0),
    [AdditionalCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_AdditionalCharges] DEFAULT (0),
    [MinPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_MinPrice] DEFAULT (0),
    [MaxPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_Service_MaxPrice] DEFAULT (0),
    [TicketsToGenerate] int NOT NULL CONSTRAINT [DF_Service_TicketsToGenerate] DEFAULT (1),
    [TicketIntervalInDays] int NOT NULL CONSTRAINT [DF_Service_TicketIntervalInDays] DEFAULT (1),
    [TicketExpiryInDays] int NOT NULL CONSTRAINT [DF_Service_TicketExpiryInDays] DEFAULT (1),
    [Tokenable] char(1) NOT NULL CONSTRAINT [DF_Service_Tokenable] DEFAULT ('N'),
    CONSTRAINT [PK_Service_1__10] PRIMARY KEY CLUSTERED ([ServiceCode]),
    CONSTRAINT [UK_Service_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[ServiceBreakUp] (
    [ServiceCode] int NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [ServiceHead] varchar(100) NULL,
    [ServiceComponentCode] int NOT NULL,
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceBreakUp_CostPrice] DEFAULT (0),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceBreakUp_SalePrice] DEFAULT (0),
    [Priority] smallint NOT NULL CONSTRAINT [DF_ServiceBreakUp_Priority] DEFAULT (1),
    [PrintOnReport] char(1) NOT NULL CONSTRAINT [DF_ServiceBreakUp_PrintOnReport] DEFAULT ('Y'),
    CONSTRAINT [PK_ServiceBreakUp] PRIMARY KEY CLUSTERED ([ServiceCode], [ServiceComponentCode])
);
GO

CREATE TABLE [dbo].[ServiceCategory] (
    [ServiceCatCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(200) NULL,
    [ServiceLogo] image NULL,
    CONSTRAINT [PK_ServiceCatCode] PRIMARY KEY CLUSTERED ([ServiceCatCode]),
    CONSTRAINT [UK_ServiceCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceComponent] (
    [ServiceComponentCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ServiceComponentTypeCode] smallint NOT NULL,
    [ServiceComponentUnitCode] smallint NULL,
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceComponent_CostPrice] DEFAULT (0),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceComponent_SalePrice] DEFAULT (0),
    [PrintRefRange] char(1) NOT NULL CONSTRAINT [DF_ServiceComponent_PrintRefRange] DEFAULT ('Y'),
    [RefDescription] varchar(4000) NULL,
    [PrintOnServiceResult] char(1) NOT NULL CONSTRAINT [DF_ServiceComponent_PrintOnServiceResult] DEFAULT ('Y'),
    [CutOffValue] varchar(100) NULL,
    CONSTRAINT [PK_ServiceComponent_ServiceComponentCode] PRIMARY KEY CLUSTERED ([ServiceComponentCode]),
    CONSTRAINT [UK_ServiceComponent_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceComponentComment] (
    [ServiceComponentCode] int NOT NULL,
    [RowID] int NOT NULL CONSTRAINT [DF_ServiceComponentComment_RowID] DEFAULT (1),
    [Description] varchar(100) NULL,
    [Comments] varchar(4000) NULL,
    CONSTRAINT [PK_ServiceComponentComment] PRIMARY KEY CLUSTERED ([ServiceComponentCode], [RowID])
);
GO

CREATE TABLE [dbo].[ServiceComponentOption] (
    [ServiceComponentCode] int NOT NULL,
    [OptionID] int NOT NULL,
    [OptionName] varchar(100) NOT NULL,
    CONSTRAINT [PK_ServiceComponentOption] PRIMARY KEY CLUSTERED ([ServiceComponentCode], [OptionName])
);
GO

CREATE TABLE [dbo].[ServiceComponentRefValue] (
    [ServiceComponentCode] int NOT NULL,
    [RowID] int NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_RowID] DEFAULT (1),
    [Gender] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_Gender] DEFAULT ('M'),
    [AgeUnit] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_AgeUnit] DEFAULT ('Y'),
    [LowerAgeLimit] int NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_LowerAgeLimit] DEFAULT (0),
    [UpperAgeLimit] int NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_UpperAgeLimit] DEFAULT (0),
    [LowerReferenceValue] varchar(100) NOT NULL,
    [UpperReferenceValue] varchar(100) NOT NULL,
    [GestationCode] tinyint NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_GestationCode] DEFAULT (1),
    [TestMachineCode] smallint NOT NULL CONSTRAINT [DF_ServiceComponentRefValue_TestMachineCode] DEFAULT (1),
    CONSTRAINT [PK_ServiceComponentRefValue] PRIMARY KEY CLUSTERED ([ServiceComponentCode], [Gender], [AgeUnit], [GestationCode], [TestMachineCode], [LowerAgeLimit], [UpperAgeLimit])
);
GO

CREATE TABLE [dbo].[ServiceComponentSaleDetail] (
    [SvcCompSaleInvCode] int NOT NULL,
    [RowID] int NOT NULL CONSTRAINT [DF_SvcCompSaleDetail_RowID] DEFAULT (0),
    [ServiceHead] varchar(100) NULL,
    [ServiceComponentCode] int NOT NULL,
    [ServiceComponentUnitCode] smallint NULL,
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SvcCompSaleDetail_CostPrice] DEFAULT (0),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SvcCompSaleDetail_SalePrice] DEFAULT (0),
    [ComponentValue] varchar(100) NULL,
    [LowerReferenceValue] varchar(100) NULL,
    [UpperReferenceValue] varchar(100) NULL,
    [Comments] varchar(4000) NOT NULL,
    CONSTRAINT [PK_ServiceComponentSaleDetail] PRIMARY KEY CLUSTERED ([SvcCompSaleInvCode], [ServiceComponentCode])
);
GO

CREATE TABLE [dbo].[ServiceComponentSaleHeader] (
    [SvcCompSaleInvCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [SampleCode] int NULL,
    [ServiceRowID] int NOT NULL,
    [Remarks] varchar(100) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentSaleHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    CONSTRAINT [PK_ServiceComponentSaleHeader_SvcCompSaleInvCode] PRIMARY KEY CLUSTERED ([SvcCompSaleInvCode])
);
GO

CREATE TABLE [dbo].[ServiceComponentType] (
    [ServiceComponentTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AskUnit] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentType_AskUnit] DEFAULT ('Y'),
    [AskRefRange] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentType_AskRefRange] DEFAULT ('Y'),
    [AskOptions] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentType_AskOptions] DEFAULT ('Y'),
    [AskComments] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentType_AskComments] DEFAULT ('Y'),
    [AskCutOff] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentType_AskCutOff] DEFAULT ('N'),
    CONSTRAINT [PK_ServiceComponentType_ServiceComponentTypeCode] PRIMARY KEY CLUSTERED ([ServiceComponentTypeCode]),
    CONSTRAINT [UK_ServiceComponentType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceComponentUnit] (
    [ServiceComponentUnitCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ValueType] char(1) NOT NULL CONSTRAINT [DF_ServiceComponentUnit_ValueType] DEFAULT ('S'),
    CONSTRAINT [PK_ServiceComponentUnit_ServiceComponentUnitCode] PRIMARY KEY CLUSTERED ([ServiceComponentUnitCode]),
    CONSTRAINT [UK_ServiceComponentUnit_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceConsumableItem] (
    [ServiceCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ServiceConsumableItem_Qty] DEFAULT (0),
    [ProcessCharge] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceConsumableItem_ProcessCharge] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ServiceConsumableItem] PRIMARY KEY CLUSTERED ([ServiceCode], [ICode])
);
GO

CREATE TABLE [dbo].[ServiceDetail] (
    [ServiceInvCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceDetail_Price] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceDet_DiscPerc_1__12] DEFAULT (0),
    [SrvRowId] int IDENTITY(1,1) NOT NULL,
    [SmanCode] smallint NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServiceDetail_Qty] DEFAULT (0),
    [Commission] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceDetail_Commission] DEFAULT (0),
    [DeliveryDate] datetime NULL,
    [SampleTaken] char(1) NOT NULL CONSTRAINT [DF_ServiceDetail_SampleTaken] DEFAULT ('N'),
    [ReportMade] char(1) NOT NULL CONSTRAINT [DF_ServiceDetail_ReportMade] DEFAULT ('N'),
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceDetail_CostPrice] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceDetail_ServiceFlatDisc] DEFAULT (0),
    [ServiceGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceDetail_ServiceGSTPerc] DEFAULT (0),
    [ServiceFlatTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceDetail_ServiceFlatTax] DEFAULT (0),
    [TransportRouteCode] int NULL,
    [VehicleCode] int NULL,
    [SharePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceDetail_SharePerc] DEFAULT (0),
    CONSTRAINT [Pk_ServiceDetail] PRIMARY KEY CLUSTERED ([SrvRowId])
);
GO

CREATE TABLE [dbo].[ServiceHeader] (
    [ServiceInvCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ServiceCatCode] tinyint NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NOT NULL,
    [ModifiedBy] smallint NULL,
    [Date] datetime NOT NULL,
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [HeaderNo] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceHea_DiscPerc_1__12] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceHeader_MiscCharges] DEFAULT (0),
    [SaleInvCode] int NULL,
    [Posted] char(1) NULL CONSTRAINT [DF_ServiceHea_Posted_2__10] DEFAULT ('N'),
    [DoctCode] smallint NULL,
    [RePrintingCounter] tinyint NULL,
    [ServiceOCode] int NULL,
    [CashReceived] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_CashReceived] DEFAULT (0),
    [PatientCode] int NULL,
    [AdmissionCode] int NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_ServiceHeader_DueDate] DEFAULT (getdate()),
    [FullPatientName] varchar(100) NULL,
    [PatientAge] varchar(60) NULL,
    [PatientSex] char(1) NOT NULL CONSTRAINT [DF_ServiceHeader_PatientSex] DEFAULT ('M'),
    [PatientRefBy] varchar(100) NULL,
    [Ref1] varchar(60) NULL,
    [Ref2] varchar(60) NULL,
    [CashAccCode] smallint NOT NULL CONSTRAINT [FK_ServiceHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_CashBack] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_InvTotal] DEFAULT (0),
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceHeader_OutStandingAmt] DEFAULT (0),
    [TokenNo] smallint NOT NULL CONSTRAINT [DF_ServiceHeader_TokenNo] DEFAULT (0),
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [Marked] char(1) NOT NULL CONSTRAINT [DF_ServiceHeader_Marked] DEFAULT ('N'),
    [ServiceInvTypeCode] smallint NOT NULL CONSTRAINT [DF_ServiceHeader_ServiceInvTypeCode] DEFAULT (1),
    [MessageCode] smallint NULL,
    [ServiceInvGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceHeader_ServiceGSTPerc] DEFAULT (0),
    [LockerCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServiceHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [HeaderInvNo] int NULL,
    [MotorVehicleCode] int NULL,
    [SurgeryCode] smallint NULL,
    [SurgeryProcedureCode] smallint NULL,
    [EyeVisionCode] smallint NULL,
    [IOLPowerCode] smallint NULL,
    [DiseaseCode] smallint NULL,
    [Mobile] varchar(100) NULL,
    [Item] varchar(100) NULL,
    [CashierShiftCode] int NULL,
    CONSTRAINT [PK_ServiceHeader_1__10] PRIMARY KEY CLUSTERED ([ServiceInvCode])
);
GO

CREATE TABLE [dbo].[ServiceInvPurTempDetail] (
    [ServiceInvCode] int NOT NULL,
    [SRVRowID] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [SuppCode] smallint NOT NULL,
    [Qty] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_Qty] DEFAULT (0),
    [PriceRule] tinyint NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_PriceRule] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_SalePrice] DEFAULT (0),
    [SalePricePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_SalePricePerc] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_PurPrice] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_ServiceFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceInvPurTempDetail_DiscPerc] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ServiceInvPurTempDetail] PRIMARY KEY CLUSTERED ([ServiceInvCode], [ROWID])
);
GO

CREATE TABLE [dbo].[ServiceInvPurTempHeader] (
    [ServiceInvCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ServiceInvPurTempHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ServiceInvPurTempHeader] PRIMARY KEY CLUSTERED ([ServiceInvCode])
);
GO

CREATE TABLE [dbo].[ServiceInvType] (
    [ServiceInvTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ServiceInvType] PRIMARY KEY CLUSTERED ([ServiceInvTypeCode]),
    CONSTRAINT [UK_ServiceInvType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceIssueRequest] (
    [ServiceIssueRequestCode] int NOT NULL,
    [DeptCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ServiceIssueRequest_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [Remarks] varchar(100) NULL,
    [PostDate] datetime NULL,
    [SmanCode] smallint NULL,
    [AreaCode] smallint NOT NULL CONSTRAINT [DF_ServiceIssueRequest_AreaCode] DEFAULT (1),
    [AccCode] smallint NULL,
    [ServiceInvCode] int NULL,
    CONSTRAINT [PK_ServiceIssueRequest_ServiceIssueRequestCode] PRIMARY KEY CLUSTERED ([ServiceIssueRequestCode])
);
GO

CREATE TABLE [dbo].[ServiceIssueRequestDetail] (
    [ServiceIssueRequestCode] int NOT NULL,
    [ServiceRowID] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] int NOT NULL CONSTRAINT [DF_ServiceIssueRequestDetail_Qty] DEFAULT (1),
    [ProcessCharge] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceIssueRequestDetail_ProcessCharge] DEFAULT (0),
    [RowId] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ServiceIssueRequestDetail] PRIMARY KEY CLUSTERED ([ServiceIssueRequestCode], [ServiceRowID], [ICode])
);
GO

CREATE TABLE [dbo].[ServiceLockerDetail] (
    [ServiceInvCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_ServiceLockerDetail] DEFAULT (1),
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ServiceLockerDetail] PRIMARY KEY CLUSTERED ([ServiceInvCode], [ICode])
);
GO

CREATE TABLE [dbo].[ServiceODetail] (
    [ServiceOCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServiceODetail_Qty] DEFAULT (0),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceODetail_Price] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceODetail_DiscPerc] DEFAULT (0),
    [SManCode] smallint NULL,
    [SrvORowId] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServiceODetail_date] DEFAULT (getdate()),
    [TsCode] smallint NOT NULL CONSTRAINT [DF_ServiceODetail_tscode] DEFAULT (1),
    [CashReceived] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceODetail_CashReceived] DEFAULT (0),
    [ShiftCode] smallint NOT NULL CONSTRAINT [DF__ServiceOD__Shift__226AFDCB] DEFAULT (1),
    [ServiceStatus] char(1) NULL CONSTRAINT [DF__ServiceOD__Servi__3489AE06] DEFAULT ('N'),
    [CancelStatus] char(1) NULL CONSTRAINT [DF_ServiceODetail_CancelStatus] DEFAULT ('N'),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceODetail_ServiceFlatDisc] DEFAULT (0),
    [ServiceGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceODetail_ServiceGSTPerc] DEFAULT (0),
    [ServiceFlatTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceODetail_ServiceFlatTax] DEFAULT (0),
    CONSTRAINT [PK_ServiceODetail] PRIMARY KEY CLUSTERED ([SrvORowId])
);
GO

CREATE TABLE [dbo].[ServiceOHeader] (
    [ServiceOCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [Date] datetime NOT NULL,
    [ModifiedBy] smallint NULL,
    [HeaderNo] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceOHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceOHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceOHeader_MiscCharges] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [Posted] char(1) NULL,
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [DoctCode] smallint NULL,
    [CashReceived] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceOHeader_CashReceived] DEFAULT (0),
    [PatientCode] int NULL,
    [AdmissionCode] int NULL,
    [Reference1] varchar(100) NULL,
    [Reference2] varchar(100) NULL,
    [Reference3] varchar(100) NULL,
    [Reference4] varchar(100) NULL,
    [Reference5] varchar(100) NULL,
    [SaleInvCode] int NULL,
    [ServiceInvCode] int NULL,
    [ServiceOrderStatusCode] smallint NOT NULL CONSTRAINT [DF_ServiceOHeader_ServiceOrderStatusCode] DEFAULT (1),
    [OperationDate] datetime NULL,
    [DischargeDate] datetime NULL,
    [NextOfKins] varchar(100) NULL,
    [NextOfKinsRelationCode] smallint NULL,
    [NextOfKinsCNIC] varchar(100) NULL,
    [NextOfKinsPhone] varchar(100) NULL,
    [NextOfKinsAddress] varchar(1000) NULL,
    [FullPatientName] varchar(100) NULL,
    [PatientAge] varchar(60) NULL,
    [PatientSex] char(1) NOT NULL CONSTRAINT [DF_ServiceOHeader_PatientSex] DEFAULT ('M'),
    [PatientRefBy] varchar(100) NULL,
    [ServiceInvTypeCode] smallint NOT NULL CONSTRAINT [DF_ServiceOHeader_ServiceInvTypeCode] DEFAULT (1),
    [MessageCode] smallint NULL,
    [ServiceInvGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceOHeader_ServiceInvGSTPerc] DEFAULT (0),
    [Cancelled] char(1) NOT NULL CONSTRAINT [DF_ServiceOHeader_Cancelled] DEFAULT ('N'),
    [CancelledOn] datetime NULL,
    [CancelledBy] smallint NULL,
    CONSTRAINT [PK_ServiceOHeader] PRIMARY KEY CLUSTERED ([ServiceOCode])
);
GO

CREATE TABLE [dbo].[ServiceOrderStatus] (
    [ServiceOrderStatusCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ServiceOrderStatus] PRIMARY KEY CLUSTERED ([ServiceOrderStatusCode]),
    CONSTRAINT [UK_ServiceOrderStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServicePRAllocationDetail] (
    [ServicePRAllocationCode] int NOT NULL,
    [ServicePurInvCode] int NOT NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRAllocationDetail_OutStandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRAllocationDetail_Amt] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [UTN] bigint NOT NULL,
    CONSTRAINT [PK_ServicePRAllocationDetail] PRIMARY KEY CLUSTERED ([ServicePRAllocationCode], [ServicePurInvCode])
);
GO

CREATE TABLE [dbo].[ServicePRAllocationHeader] (
    [ServicePRAllocationCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServicePRAllocationHeader_Date] DEFAULT (getdate()),
    [ServicePRInvCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ServicePRAllocationHeader_OriginalDate] DEFAULT (getdate()),
    [Modified] char(1) NULL CONSTRAINT [DF_ServicePRAllocationHeader_Modified] DEFAULT ('N'),
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [Posted] char(1) NULL CONSTRAINT [DF_ServicePRAllocationHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [Remarks] varchar(100) NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServicePrAllocationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_ServicePRAllocationHeader] PRIMARY KEY CLUSTERED ([ServicePRAllocationCode])
);
GO

CREATE TABLE [dbo].[ServicePRDetail] (
    [ServicePRInvCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServicePRDetail_Qty] DEFAULT (1),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePRDetail_Price] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServicePRDetail_ServiceFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServicePRDetail_DiscPerc] DEFAULT (0),
    [SRVRowID] int NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ServicePRDetail] PRIMARY KEY CLUSTERED ([RowId])
);
GO

CREATE TABLE [dbo].[ServicePRHeader] (
    [ServicePRInvCode] int NOT NULL,
    [ServicePurInvCode] int NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServicePRHeader_Date] DEFAULT (getdate()),
    [SuppCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ServicePRHeader_OriginalDate] DEFAULT (getdate()),
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [Posted] char(1) NULL CONSTRAINT [DF_ServicePRHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_ServicePRHeader_HeaderNo] DEFAULT (1),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_MiscCharges] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_ServicePRHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_CashBack] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_InvTotal] DEFAULT (0),
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePRHeader_OutStandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_ServicePRHeader_Marked] DEFAULT ('N'),
    [Ref1] varchar(60) NULL,
    [Ref2] varchar(60) NULL,
    [Ref3] varchar(60) NULL,
    [Ref4] varchar(60) NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServicePrHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [HeaderInvNo] int NULL,
    CONSTRAINT [PK_ServicePRHeader] PRIMARY KEY CLUSTERED ([ServicePRInvCode])
);
GO

CREATE TABLE [dbo].[ServicePricePolicy] (
    [ServicePricePolicyCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ServiceCode] int NOT NULL,
    [StartDate] datetime NOT NULL CONSTRAINT [DF_ServicePricePolicy_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_ServicePricePolicy_EndDate] DEFAULT (getdate()),
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ServicePricePolicy] PRIMARY KEY CLUSTERED ([ServicePricePolicyCode]),
    CONSTRAINT [UK_ServicePricePolicy] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServicePricePolicyDetail] (
    [ServicePricePolicyCode] int NOT NULL,
    [WeekDayCode] tinyint NOT NULL,
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePricePolicyDetail_Price] DEFAULT (0),
    CONSTRAINT [PK_ServicePricePolicyDetail] PRIMARY KEY CLUSTERED ([ServicePricePolicyCode], [WeekDayCode])
);
GO

CREATE TABLE [dbo].[ServicePurDetail] (
    [ServicePurInvCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServicePurDetail_Qty] DEFAULT (1),
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePurDetail_Price] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServicePurDetail_ServiceFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServicePurDetail_DiscPerc] DEFAULT (0),
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    [SrvRowID] int NULL,
    CONSTRAINT [Pk_ServicePurDetail] PRIMARY KEY CLUSTERED ([RowId])
);
GO

CREATE TABLE [dbo].[ServicePurHeader] (
    [ServicePurInvCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServicePurHeader_Date] DEFAULT (getdate()),
    [SuppCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ServicePurHeader_OriginalDate] DEFAULT (getdate()),
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [Posted] char(1) NULL CONSTRAINT [DF_ServicePurHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [HeaderNo] smallint NOT NULL CONSTRAINT [DF_ServicePurHeader_HeaderNo] DEFAULT (1),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_DiscPerc] DEFAULT (0),
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_MiscCharges] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_SServicePurHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_CashBack] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_InvTotal] DEFAULT (0),
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServicePurHeader_OutStandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_ServicePurHeader_Marked] DEFAULT ('N'),
    [Ref1] varchar(60) NULL,
    [Ref2] varchar(60) NULL,
    [Ref3] varchar(60) NULL,
    [Ref4] varchar(60) NULL,
    [ServiceInvCode] int NULL,
    [ExpAccCode] smallint NOT NULL CONSTRAINT [DF_ServicePurHeader_ExpAccCode] DEFAULT (24),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServicePurHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [HeaderInvNo] int NULL,
    CONSTRAINT [PK_ServicePurHeader] PRIMARY KEY CLUSTERED ([ServicePurInvCode])
);
GO

CREATE TABLE [dbo].[ServicePurTempDetail] (
    [ServicePurTempCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [SuppCode] smallint NOT NULL,
    [Qty] numeric(10,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_Qty] DEFAULT (0),
    [PriceRule] tinyint NOT NULL CONSTRAINT [DF_ServicePurTempDetail_PriceRule] DEFAULT (1),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_SalePrice] DEFAULT (0),
    [SalePricePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_SalePricePerc] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_PurPrice] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_ServiceFlatDisc] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServicePurTempDetail_DiscPerc] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[ServicePurTempHeader] (
    [ServicePurTempCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServicePurTempHeader_Date] DEFAULT (getdate()),
    [Remarks] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_ServicePurTempHeader] PRIMARY KEY CLUSTERED ([ServicePurTempCode]),
    CONSTRAINT [UK_ServicePurTempHeader_ServiceCode] UNIQUE ([ServiceCode])
);
GO

CREATE TABLE [dbo].[ServiceRDetail] (
    [ServiceRInvCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [ServicePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_ServicePrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [SrvRRowId] int IDENTITY(1,1) NOT NULL,
    [SmanCode] smallint NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServiceRDetail_Qty] DEFAULT (0),
    [SrvRowId] int NULL,
    [Commission] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_Commission] DEFAULT (0),
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceRDetail_CostPrice] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_ServiceFlatDisc] DEFAULT (0),
    [ServiceGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_ServiceGSTPerc] DEFAULT (0),
    [ServiceFlatTax] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_ServiceFlatTax] DEFAULT (0),
    [SharePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceRDetail_SharePerc] DEFAULT (0),
    CONSTRAINT [Pk_ServiceRDetail] PRIMARY KEY CLUSTERED ([SrvRRowId])
);
GO

CREATE TABLE [dbo].[ServiceResultDetail] (
    [ServiceResultCode] int NOT NULL,
    [ServiceRowID] int NOT NULL,
    [RowID] int NOT NULL CONSTRAINT [DF_ServiceResultDetail_RowID] DEFAULT (0),
    [ServiceHead] varchar(100) NULL,
    [ServiceComponentCode] int NOT NULL,
    [ServiceComponentUnitCode] smallint NULL,
    [TestMachineCode] smallint NOT NULL CONSTRAINT [DF_TestMachine_ServiceResultDetail_TestMachineCode] DEFAULT (1),
    [CostPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceResultDetail_CostPrice] DEFAULT (0),
    [SalePrice] numeric(15,5) NOT NULL CONSTRAINT [DF_ServiceResultDetail_SalePrice] DEFAULT (0),
    [ComponentValue] varchar(100) NULL,
    [LowerReferenceValue] varchar(100) NULL,
    [UpperReferenceValue] varchar(100) NULL,
    [Comments] varchar(4000) NULL,
    [Remarks] varchar(100) NULL,
    [ComponentValue2] varchar(100) NULL,
    [DeliveryDate] datetime NOT NULL CONSTRAINT [DF_ServiceResultDetail_DeliveryDate] DEFAULT (getdate()),
    [PrintOnReport] char(1) NOT NULL CONSTRAINT [DF_ServiceResultDetail_PrintOnReport] DEFAULT ('Y'),
    CONSTRAINT [PK_ServiceResultDetail] PRIMARY KEY CLUSTERED ([ServiceResultCode], [ServiceRowID], [RowID])
);
GO

CREATE TABLE [dbo].[ServiceResultHeader] (
    [ServiceResultCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [ServiceInvCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_ServiceResultHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBY] smallint NULL,
    [Remarks] varchar(100) NULL,
    [ServiceResultStampCode] smallint NOT NULL CONSTRAINT [DF_ServiceResultHeader_ServiceResultStampCode] DEFAULT (1),
    CONSTRAINT [PK_ServiceResultHeader] PRIMARY KEY CLUSTERED ([ServiceResultCode])
);
GO

CREATE TABLE [dbo].[ServiceResultStamp] (
    [ServiceResultStampCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Detail1] varchar(400) NULL,
    [Detail2] varchar(400) NULL,
    [Detail3] varchar(400) NULL,
    [Detail4] varchar(400) NULL,
    [Detail5] varchar(400) NULL,
    [Detail6] varchar(400) NULL,
    CONSTRAINT [PK_ServiceResultStamp] PRIMARY KEY CLUSTERED ([ServiceResultStampCode]),
    CONSTRAINT [UK_ServiceResultStamp_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceResultStyle] (
    [ServiceResultStyleCode] tinyint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [DataObject] varchar(100) NOT NULL,
    CONSTRAINT [PK_ServiceResultStyle] PRIMARY KEY CLUSTERED ([ServiceResultStyleCode]),
    CONSTRAINT [UK_ServiceResultStyle_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceRHeader] (
    [ServiceRInvcode] int NOT NULL,
    [ServiceInvCode] int NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [ServiceRCatCode] tinyint NOT NULL,
    [Remarks] varchar(100) NULL,
    [OriginalDate] datetime NOT NULL,
    [ModifiedBy] smallint NULL,
    [Date] datetime NOT NULL,
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [HeaderNo] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_MiscCharges] DEFAULT (0),
    [SaleInvCode] int NULL,
    [Posted] char(1) NULL,
    [DoctCode] smallint NULL,
    [PatientCode] int NULL,
    [AdmissionCode] int NULL,
    [CashAccCode] smallint NOT NULL CONSTRAINT [FK_ServiceRHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_CashBack] DEFAULT (0),
    [InvTotal] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_InvTotal] DEFAULT (0),
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_OutStandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_ServiceRHeader_Marked] DEFAULT ('N'),
    [ServiceInvGSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceRHeader_ServiceGSTPerc] DEFAULT (0),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServiceRHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [HeaderInvNo] int NULL,
    [MotorVehicleCode] int NULL,
    [CashierShiftCode] int NULL,
    CONSTRAINT [PK_ServiceRHeader_1__12] PRIMARY KEY CLUSTERED ([ServiceRInvcode])
);
GO

CREATE TABLE [dbo].[ServiceSampleRequirement] (
    [ServiceCode] int NOT NULL,
    [SampleTypeCode] smallint NOT NULL,
    [Volume] numeric(10,5) NOT NULL CONSTRAINT [DF_ServiceSampleRequirement_Volume] DEFAULT (0),
    [Color] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_ServiceSampleRequirement] PRIMARY KEY CLUSTERED ([ServiceCode], [SampleTypeCode])
);
GO

CREATE TABLE [dbo].[ServiceSRAllocationDetail] (
    [ServiceSRAllocationCode] int NOT NULL,
    [ServiceInvCode] int NOT NULL,
    [OutStandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceSRAllocationDetail_OutStandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_ServiceSRAllocationDetail_Amt] DEFAULT (0),
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [UTN] bigint NOT NULL,
    CONSTRAINT [PK_ServiceSRAllocationDetail] PRIMARY KEY CLUSTERED ([ServiceSRAllocationCode], [ServiceInvCode])
);
GO

CREATE TABLE [dbo].[ServiceSRAllocationHeader] (
    [ServiceSRAllocationCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServiceSRAllocationHeader_Date] DEFAULT (getdate()),
    [ServiceRInvCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [OriginalDate] datetime NOT NULL CONSTRAINT [DF_ServiceSRAllocationHeader_OriginalDate] DEFAULT (getdate()),
    [Modified] char(1) NULL CONSTRAINT [DF_ServiceSRAllocationHeader_Modified] DEFAULT ('N'),
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [Posted] char(1) NULL CONSTRAINT [DF_ServiceSRAllocationHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [Remarks] varchar(100) NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_ServiceSrAllocationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_ServiceSRAllocationHeader] PRIMARY KEY CLUSTERED ([ServiceSRAllocationCode])
);
GO

CREATE TABLE [dbo].[ServiceTemplateDetail] (
    [ServiceTemplateCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Qty] numeric(10,2) NULL CONSTRAINT [DF_ServiceTemplateDetail_Qty] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceTemplateDetail_SalePrice] DEFAULT (0),
    [DiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceTemplateDetail_DiscPerc] DEFAULT (0),
    [RowId] int IDENTITY(1,1) NOT NULL,
    [SManCode] smallint NULL,
    [Commission] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceTemplateDetail_Commission] DEFAULT (0),
    [ServiceFlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_ServiceTemplateDetail_ServiceFlatDisc] DEFAULT (0),
    [SharePerc] numeric(6,2) NOT NULL CONSTRAINT [DF_ServiceTemplateDetail_SharePerc] DEFAULT (0),
    CONSTRAINT [PK_ServiceTemplateDetail] PRIMARY KEY CLUSTERED ([RowId])
);
GO

CREATE TABLE [dbo].[ServiceTemplateHeader] (
    [ServiceTemplateCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_ServiceTemplateHeader] PRIMARY KEY CLUSTERED ([ServiceTemplateCode]),
    CONSTRAINT [UK_ServiceTemplateHeader_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ServiceTicket] (
    [ServiceTicketCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ServiceTicket_Date] DEFAULT (getdate()),
    [ServiceInvCode] int NOT NULL,
    [ServiceCode] int NOT NULL,
    [Price] numeric(12,2) NOT NULL CONSTRAINT [DF_ServiceTicket_Price] DEFAULT (0),
    [ExpiresOn] datetime NOT NULL CONSTRAINT [DF_ServiceTicket_ExpiresOn] DEFAULT (getdate()),
    [TicketUsed] char(1) NOT NULL CONSTRAINT [DF_ServiceTicket_TicketUsed] DEFAULT ('N'),
    [TicketUsedOn] datetime NULL,
    [UserCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_ServiceTicket_DiscPerc] DEFAULT (0),
    CONSTRAINT [PK_ServiceTicket] PRIMARY KEY CLUSTERED ([ServiceTicketCode])
);
GO

CREATE TABLE [dbo].[ServiceType] (
    [ServiceTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_ServiceType] PRIMARY KEY CLUSTERED ([ServiceTypeCode]),
    CONSTRAINT [UK_ServiceType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Setup] (
    [LicenceNo] smallint NOT NULL,
    [CreationDateTime] datetime NOT NULL,
    [LastUpdation] datetime NOT NULL,
    [Software] varchar(30) NOT NULL,
    [Version] varchar(10) NOT NULL,
    [TotalHeaders] tinyint NOT NULL,
    [InvoiceHeaders] char(1) NOT NULL,
    [Drive] char(1) NOT NULL,
    [SerialNo] char(9) NOT NULL,
    [Remarks] varchar(60) NULL,
    CONSTRAINT [PK___1__13] PRIMARY KEY CLUSTERED ([LicenceNo])
);
GO

CREATE TABLE [dbo].[SeverityLevel] (
    [SeverityLevelCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_SeverityLevel_SeverityLevelCode] PRIMARY KEY CLUSTERED ([SeverityLevelCode]),
    CONSTRAINT [UK_SeverityLevel_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Shift] (
    [ShiftCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Shift] PRIMARY KEY CLUSTERED ([ShiftCode]),
    CONSTRAINT [IX_ShiftName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Site] (
    [SiteCode] smallint NOT NULL,
    [InstanceID] varchar(100) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_Site_Active] DEFAULT ('Y'),
    CONSTRAINT [PK_Site_SiteCode] PRIMARY KEY ([SiteCode]),
    CONSTRAINT [UK_Site_InstanceID] UNIQUE ([InstanceID])
);
GO

CREATE TABLE [dbo].[SMS_AssociatedRecipient] (
    [SMSTemplateCode] int NOT NULL,
    [ContactGroupCode] smallint NOT NULL,
    CONSTRAINT [PK_SMS_AssociatedRecipient] PRIMARY KEY CLUSTERED ([SMSTemplateCode], [ContactGroupCode])
);
GO

CREATE TABLE [dbo].[SMS_Center] (
    [SMSCode] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_SMS_Center_Date] DEFAULT (getdate()),
    [SMSTO] varchar(255) NOT NULL,
    [SMSText] varchar(4000) NULL,
    [SMSTypeCode] tinyint NOT NULL,
    [SMSStatusCode] tinyint NULL,
    [SMSTemplateCode] int NULL,
    [SentDate] datetime NULL,
    [Expiry] datetime NOT NULL CONSTRAINT [DF_SMS_Center_Expiry] DEFAULT (getdate() + 1),
    CONSTRAINT [PK_SMS_Center] PRIMARY KEY CLUSTERED ([SMSCode])
);
GO

CREATE TABLE [dbo].[SMS_DataDefinition] (
    [SMSDataCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [ModuleID] smallint NULL,
    [ViewName] varchar(100) NOT NULL,
    [FilterOn] varchar(255) NOT NULL,
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_SMS_DataDefinition_Enabled] DEFAULT ('N'),
    CONSTRAINT [PK_SMS_DataDefinition] PRIMARY KEY CLUSTERED ([SMSDataCode]),
    CONSTRAINT [UK_SMS_DataDefinition_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SMS_Status] (
    [SMSStatusCode] tinyint NOT NULL,
    [Name] varchar(255) NOT NULL,
    CONSTRAINT [PK_SMS_Status] PRIMARY KEY CLUSTERED ([SMSStatusCode]),
    CONSTRAINT [UK_SMS_Status] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SMS_Template] (
    [SMSTemplateCode] int NOT NULL,
    [Name] varchar(255) NOT NULL,
    [SMSTypeCode] tinyint NOT NULL,
    [SMSDataCode] int NULL,
    [SMSTemplate] varchar(4000) NULL,
    [Enabled] char(1) NOT NULL CONSTRAINT [DF_SMS_Template_Enabled] DEFAULT ('N'),
    [ModuleID] smallint NULL,
    [Event] varchar(50) NULL,
    [Scheduled] char(1) NOT NULL CONSTRAINT [DF_SMS_Template_Scheduled] DEFAULT ('N'),
    [ScheduleType] tinyint NOT NULL CONSTRAINT [DF_SMS_Template_ScheduleType] DEFAULT (1),
    [RunOnce] datetime NOT NULL CONSTRAINT [DF_SMS_Template_RunOnce] DEFAULT ('1900-01-01 00:00:00'),
    [RunEvery] tinyint NOT NULL CONSTRAINT [DF_SMS_Template_RunEvery] DEFAULT (10),
    [RunEveryFreq] tinyint NOT NULL CONSTRAINT [DF_SMS_Template_RunEveryFreq] DEFAULT (1),
    [Executed] char(1) NOT NULL CONSTRAINT [DF_SMS_Template_Executed] DEFAULT ('N'),
    [ExecutedOn] datetime NULL,
    [NextRunOn] datetime NULL,
    [RunParameters] varchar(100) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_SMS_Template_Active] DEFAULT ('Y'),
    CONSTRAINT [PK_SMS_Template] PRIMARY KEY CLUSTERED ([SMSTemplateCode]),
    CONSTRAINT [UK_SMS_Template_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SMS_Type] (
    [SMSTypeCode] tinyint NOT NULL,
    [Name] varchar(255) NOT NULL,
    CONSTRAINT [PK_SMS_Type] PRIMARY KEY CLUSTERED ([SMSTypeCode]),
    CONSTRAINT [UK_SMS_Type] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SOCheckListItem] (
    [ServiceOCode] int NOT NULL,
    [CheckListItemCode] int NOT NULL,
    [Qty] int NOT NULL CONSTRAINT [DF_SOCheckListItem_Qty] DEFAULT (1),
    [Description] varchar(100) NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_SOCheckListItem] PRIMARY KEY CLUSTERED ([ServiceOCode], [CheckListItemCode])
);
GO

CREATE TABLE [dbo].[SoftwarePreferences] (
    [PrefID] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Caption] varchar(100) NOT NULL,
    [PrefDataType] varchar(20) NOT NULL,
    [PrefValue] varchar(200) NOT NULL,
    [PrefValue2] varchar(200) NOT NULL,
    [SubCatCode] smallint NOT NULL,
    [FormOrder] int NOT NULL,
    [ColWidth] smallint NOT NULL,
    [decimals] tinyint NOT NULL,
    [UsedObject] varchar(200) NOT NULL,
    [Visible] char(1) NOT NULL CONSTRAINT [DF_SoftwarePreferences_Visible] DEFAULT ('Y'),
    [PrefImage] image NULL,
    [AssocPrefName] varchar(100) NULL,
    [AssocRightCode] int NULL,
    CONSTRAINT [PK_SoftwarePreferences_Name] PRIMARY KEY CLUSTERED ([Name]),
    CONSTRAINT [UK_SoftwarePreferences_PrefID] UNIQUE ([PrefID])
);
GO

CREATE TABLE [dbo].[SOReceipt] (
    [SOReceiptCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_SOReceipt_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_SOReceipt_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [ServiceOCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [PatientCode] int NULL,
    [SOAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SOReceipt_SOAmt] DEFAULT (0),
    [ReceiptMode] char(1) NOT NULL CONSTRAINT [DF_SOReceipt_ReceiptMode] DEFAULT ('C'),
    [ReceiptAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SOReceipt_ReceiptAmt] DEFAULT (0),
    [ReceiptAccCode] smallint NOT NULL,
    [ReceiptRefNo] varchar(20) NULL,
    [ReceiptRemarks] varchar(100) NULL,
    [WHTaxAccCode] smallint NULL,
    [WHTaxBaseAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SOReceipt_WHTaxBaseAmt] DEFAULT (0),
    [WHTaxPerc] numeric(15,2) NOT NULL CONSTRAINT [DF_SOReceipt_WHTaxPerc] DEFAULT (0),
    [WHTaxAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SOReceipt_WHTaxAmt] DEFAULT (0),
    [WHTaxRefNo] varchar(20) NULL,
    [WHTaxRemarks] varchar(100) NULL,
    [GLVochCode] int NULL,
    [Deduction1] numeric(12,2) NOT NULL CONSTRAINT [DF_SOReceipt_Deduction1] DEFAULT (0),
    [Deduction1_AccCode] smallint NULL,
    [Deduction1_Ref] varchar(20) NULL,
    [Deduction1_Remarks] varchar(100) NULL,
    [Deduction2] numeric(12,2) NOT NULL CONSTRAINT [DF_SOReceipt_Deduction2] DEFAULT (0),
    [Deduction2_AccCode] smallint NULL,
    [Deduction2_Ref] varchar(20) NULL,
    [Deduction2_Remarks] varchar(100) NULL,
    [Deduction3] numeric(12,2) NOT NULL CONSTRAINT [DF_SOReceipt_Deduction3] DEFAULT (0),
    [Deduction3_AccCode] smallint NULL,
    [Deduction3_Ref] varchar(20) NULL,
    [Deduction3_Remarks] varchar(100) NULL,
    [Deduction4] numeric(12,2) NOT NULL CONSTRAINT [DF_SOReceipt_Deduction4] DEFAULT (0),
    [Deduction4_AccCode] smallint NULL,
    [Deduction4_Ref] varchar(20) NULL,
    [Deduction4_Remarks] varchar(100) NULL,
    [Deduction5] numeric(12,2) NOT NULL CONSTRAINT [DF_SOReceipt_Deduction5] DEFAULT (0),
    [Deduction5_AccCode] smallint NULL,
    [Deduction5_Ref] varchar(20) NULL,
    [Deduction5_Remarks] varchar(100) NULL,
    CONSTRAINT [PK_SOReceipt] PRIMARY KEY CLUSTERED ([SOReceiptCode])
);
GO

CREATE TABLE [dbo].[SpecialRight] (
    [RightID] varchar(100) NOT NULL,
    [RightName] varchar(100) NOT NULL,
    [Enable] char(1) NOT NULL CONSTRAINT [DF__SpecialRi__Enabl__2EB1A476] DEFAULT ('N'),
    [RightPwd] varchar(100) NOT NULL CONSTRAINT [DF__SpecialRi__Right__2FA5C8AF] DEFAULT ('spcadminsecrets'),
    CONSTRAINT [PK_SpecialRight_RightID] PRIMARY KEY CLUSTERED ([RightID])
);
GO

CREATE TABLE [dbo].[SPO] (
    [SPOCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Gender] char(1) NOT NULL CONSTRAINT [DF_SPO_Gender] DEFAULT ('M'),
    [FatherName] varchar(100) NULL,
    [HusbandName] varchar(100) NULL,
    [Address] varchar(255) NULL,
    [Address2] varchar(255) NULL,
    [MobileNo] varchar(100) NULL,
    [Phone] varchar(100) NULL,
    [Fax] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_SPO] PRIMARY KEY CLUSTERED ([SPOCode])
);
GO

CREATE TABLE [dbo].[SPOTeam] (
    [SPOTeamCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_SPOTeam] PRIMARY KEY CLUSTERED ([SPOTeamCode]),
    CONSTRAINT [UK_SPOTeam_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SPOTeamCategory] (
    [SPOTeamCode] smallint NOT NULL,
    [ICatCode] smallint NOT NULL,
    CONSTRAINT [PK_SPOTeamCategory] PRIMARY KEY CLUSTERED ([SPOTeamCode], [ICatCode])
);
GO

CREATE TABLE [dbo].[SPOTeamMember] (
    [SPOTeamCode] smallint NOT NULL,
    [SPOCode] smallint NOT NULL,
    [SharePerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SPOTeamMember_SharePerc] DEFAULT (0),
    CONSTRAINT [PK_SPOTeamMember] PRIMARY KEY CLUSTERED ([SPOTeamCode], [SPOCode])
);
GO

CREATE TABLE [dbo].[SPOTeamSubArea] (
    [SPOTeamCode] smallint NOT NULL,
    [SubAreaCode] smallint NOT NULL,
    CONSTRAINT [PK_SPOTeamSubArea] PRIMARY KEY CLUSTERED ([SPOTeamCode], [SubAreaCode])
);
GO

CREATE TABLE [dbo].[SRAllocationDetail] (
    [SRAllocationCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRAllocationDetail_OutstandingAmt] DEFAULT (0),
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRAllocationDetail_Amt] DEFAULT (0),
    [SRAllocationROWID] int IDENTITY(1,1) NOT NULL,
    [SRAllocationUTN] bigint NOT NULL,
    CONSTRAINT [PK_SRAllocationDetail] PRIMARY KEY CLUSTERED ([SRAllocationCode], [SaleInvCode])
);
GO

CREATE TABLE [dbo].[SRAllocationHeader] (
    [SRAllocationCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [SRInvCode] int NOT NULL,
    [UserCode] smallint NOT NULL,
    [Modified] char(1) NOT NULL CONSTRAINT [DF_SRAllocationHeader_Modified] DEFAULT ('N'),
    [ModifiedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_SRAllocationHeader_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SRAllocationHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_SRAllocationHeader] PRIMARY KEY CLUSTERED ([SRAllocationCode])
);
GO

CREATE TABLE [dbo].[SRBufferDetail] (
    [SRBufferInvcode] int NOT NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Icode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SRBufferDetail_PackQty] DEFAULT (0),
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SRBufferDetail_LooseQty] DEFAULT (0),
    [PackUnits] int NOT NULL,
    [SRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferDetail_SRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SRBufferDetail_AvgPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SRBufferDetail_GSTPerc] DEFAULT (0),
    [SRUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SRBufferDetail_BonusQty] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferDetail_SalePrice] DEFAULT (0),
    [SaleRowId] int NULL,
    [ReturnItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SRBufferDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SRBufferDetail_PiecesInHand] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferDetail_AlternatePurPrice] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SRBufferDetail_NewAvgPrice] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NULL CONSTRAINT [DF_SRBufferDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CurrStock] numeric(15,4) NOT NULL CONSTRAINT [DF_SRBufferDetail_CurrStock] DEFAULT (0),
    CONSTRAINT [PK_SRBufferDetail_SRBufferInvCode_RowId] PRIMARY KEY CLUSTERED ([SRBufferInvcode], [RowId])
);
GO

CREATE TABLE [dbo].[SRBufferLedger] (
    [SRBufferInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [SRCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_MiscCharges] DEFAULT (0),
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [SalesTax] numeric(7,2) NULL CONSTRAINT [DF_SRBufferLedger_SalesTax] DEFAULT (0),
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [HeaderNo] smallint NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SRBufferLedger_InvGSTPerc] DEFAULT (0),
    [Smancode] smallint NULL,
    [CustRefno] varchar(100) NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [PatientCode] int NULL,
    [MachineName] varchar(20) NULL,
    [HeaderInvNo] int NULL,
    [AdmissionCode] int NULL,
    [invtotal] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_Marked] DEFAULT ('N'),
    [PageSize] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_PageSize] DEFAULT ('Q'),
    [CashAccCode] smallint NOT NULL CONSTRAINT [FK_SRBufferLedger_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_CashBack] DEFAULT (0),
    [RetViaBillSummary] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_RetViaBillSummary] DEFAULT ('N'),
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_SRBufferLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_SRBufferLedger_FBRPOSFee] DEFAULT (0),
    [CashierShiftCode] int NULL,
    CONSTRAINT [PK_SRBufferLedger] PRIMARY KEY CLUSTERED ([SRBufferInvCode])
);
GO

CREATE TABLE [dbo].[SRdetail] (
    [SRInvcode] int NOT NULL,
    [Icode] int NOT NULL,
    [Gcode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [PackQty] int NOT NULL,
    [LooseQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SRDetail_LooseQty] DEFAULT (0),
    [PackUnits] int NOT NULL,
    [SRPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SRDetail_SRPrice] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [SalesTax] numeric(7,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SRDetail_AvgPrice] DEFAULT (0),
    [UnitSalesTax] numeric(12,2) NOT NULL CONSTRAINT [DF_SRDetail_UnitSalesTax] DEFAULT (0),
    [GSTPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SRdetail_GSTPerc_1__10] DEFAULT (0),
    [SRUtn] bigint NULL,
    [BonusQty] numeric(15,4) NOT NULL CONSTRAINT [DF_SRDetail_BonusQty] DEFAULT (0),
    [SalePrice] numeric(15,2) NOT NULL CONSTRAINT [DF_SRdetail_SalePrice] DEFAULT (0),
    [SaleRowId] int NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [ReturnItemDescription] varchar(100) NULL,
    [TotalPieces] int NOT NULL CONSTRAINT [DF_SRDetail_TotalPieces] DEFAULT (0),
    [PiecesInHand] int NOT NULL CONSTRAINT [DF_SRDetail_PiecesInHand] DEFAULT (0),
    [AlternatePurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SRDetail_AlternatePurPrice] DEFAULT (0),
    [CommissionPerUnit] numeric(12,2) NOT NULL CONSTRAINT [DF_srdetail_CommissionPerUnit] DEFAULT (0),
    [CommissionPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_srdetail_CommissionPerc] DEFAULT (0),
    [AlternateCustomICode] varchar(75) NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_SRDetail_NewAvgPrice] DEFAULT (0),
    [Claimable] char(1) NOT NULL CONSTRAINT [DF_SRDetail_Claimable] DEFAULT ('N'),
    [ClaimableDiscPerc] numeric(6,2) NOT NULL CONSTRAINT [DF_SRDetail_ClaimableDiscPerc] DEFAULT (0),
    [ItemAdvanceTaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_SRDetail_ItemAdvanceTaxPerc] DEFAULT (0),
    [CurrStock] numeric(15,4) NOT NULL CONSTRAINT [DF_SRDetail_CurrStock] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[SRLedger] (
    [SRInvCode] int NOT NULL,
    [SaleInvCode] int NULL,
    [Date] datetime NOT NULL,
    [SRCatCode] tinyint NOT NULL,
    [CustCode] smallint NOT NULL,
    [SalesmanCode] smallint NOT NULL,
    [DiscPerc] numeric(5,2) NOT NULL,
    [FlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_SRLedger_FlatDisc] DEFAULT (0),
    [MiscCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_SRLedger_MiscCharges] DEFAULT (0),
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [SalesTax] numeric(7,2) NULL CONSTRAINT [DF_SRLedger_SalesTax_1__13] DEFAULT (0),
    [OriginalDate] datetime NULL,
    [ModifiedBy] smallint NULL,
    [PostedBy] smallint NULL,
    [HeaderNo] smallint NULL,
    [InvGSTPerc1] numeric(6,2) NULL CONSTRAINT [DF_SRLedger_InvGSTPerc1_1__10] DEFAULT (0),
    [Smancode] smallint NULL,
    [CustRefno] varchar(100) NULL,
    [CustRefno2] varchar(100) NULL,
    [CustRefno3] varchar(100) NULL,
    [CustRefno4] varchar(100) NULL,
    [PatientCode] int NULL,
    [MachineName] varchar(20) NULL,
    [HeaderInvNo] int NULL,
    [AdmissionCode] int NULL,
    [invtotal] numeric(15,2) NOT NULL CONSTRAINT [df_srledger_invtotal] DEFAULT (0),
    [AccountFor] char(1) NOT NULL CONSTRAINT [DF_SRLedger_AccountFor] DEFAULT ('Y'),
    [PaymentMode] char(1) NULL,
    [PaymentAccCode] smallint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRLedger_Amt] DEFAULT (0),
    [AmtBY] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtReference] varchar(20) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_SRLedger_OutstandingAmt] DEFAULT (0),
    [Marked] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Marked] DEFAULT ('N'),
    [PageSize] char(1) NOT NULL CONSTRAINT [DF_SRLedger_PageSize] DEFAULT ('Q'),
    [ReprintingCounter] tinyint NOT NULL CONSTRAINT [DF_srledger_ReprintingCounter] DEFAULT (0),
    [DoctCode] smallint NULL,
    [ConsiderInPO] char(1) NOT NULL CONSTRAINT [DF_SRLedger_ConsiderInPO] DEFAULT ('Y'),
    [CashAccCode] smallint NOT NULL CONSTRAINT [FK_SRLedger_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_SRLedger_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_SRLedger_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_SRLedger_CashBack] DEFAULT (0),
    [RetViaBillSummary] char(1) NOT NULL CONSTRAINT [DF_SRLedger_RetViaBillSummary] DEFAULT ('N'),
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_SRLedger_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [GuestCode] int NULL,
    [GuestCheckInCode] int NULL,
    [StudentCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [CurrencyCode] smallint NOT NULL CONSTRAINT [DF_SRLedger_CurrencyCode] DEFAULT (1),
    [ConversionRate] numeric(11,5) NOT NULL CONSTRAINT [DF_SRLedger_ConversionRate] DEFAULT (1),
    [Fiscalized] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Fiscalized] DEFAULT ('N'),
    [FiscalizedOn] datetime NULL,
    [FiscalInvoiceNo] varchar(100) NULL,
    [Transmit] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Transmit] DEFAULT ('Y'),
    [Transmited] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Transmited] DEFAULT ('N'),
    [AdvanceTax] char(1) NOT NULL CONSTRAINT [DF_SRLedger_AdvanceTax] DEFAULT ('N'),
    [AdvanceTaxAmt] numeric(12,2) NOT NULL CONSTRAINT [DF_SRLedger_AdvanceTaxAmt] DEFAULT (0),
    [FBRPOSFee] numeric(5,2) NOT NULL CONSTRAINT [DF_SRLedger_FBRPOSFee] DEFAULT (0),
    [MotorVehicleCode] int NULL,
    [CashierShiftCode] int NULL,
    [SiteCode] smallint NULL,
    [Pushed] char(1) NOT NULL CONSTRAINT [DF_SRLedger_Pushed] DEFAULT ('N'),
    [PushedBy] smallint NULL,
    [PushedOn] datetime NULL,
    [TargetSiteCode] smallint NULL,
    CONSTRAINT [PK_SRLedger] PRIMARY KEY CLUSTERED ([SRInvCode])
);
GO

CREATE TABLE [dbo].[StartupRight] (
    [RightCode] smallint NOT NULL,
    [RightType] char(1) NOT NULL CONSTRAINT [DF_StartupRight_RightType] DEFAULT ('R'),
    [RightName] varchar(255) NOT NULL,
    [ObjectName] varchar(100) NULL,
    [Allowed] char(1) NOT NULL CONSTRAINT [DF_StartupRight_Allowed] DEFAULT ('N'),
    CONSTRAINT [PK_StartupRight] PRIMARY KEY CLUSTERED ([RightCode]),
    CONSTRAINT [UK_StartupRight] UNIQUE ([RightName])
);
GO

CREATE TABLE [dbo].[StockLedger] (
    [DocumentCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [DocumentType] varchar(2) NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Qty] numeric(15,4) NOT NULL,
    [Bonus] numeric(15,4) NOT NULL,
    [PackUnits] smallint NOT NULL,
    [Rate] numeric(12,2) NOT NULL CONSTRAINT [DF_StockLedger_Rate] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL,
    [InvDiscPerc] numeric(5,2) NOT NULL,
    [Stock] numeric(15,4) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_StockLedger_AVGPrice] DEFAULT (0),
    [NewStock] numeric(15,4) NOT NULL,
    [NewAvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_StockLedger_NewAvgPrice] DEFAULT (0),
    [UTN] bigint NOT NULL,
    [Due] char(1) NULL
);
GO

CREATE TABLE [dbo].[StockReport] (
    [Date] datetime NOT NULL,
    [GCode] smallint NOT NULL,
    [ICode] int NOT NULL,
    [Stock] numeric(15,4) NOT NULL,
    [PurchasePrice] numeric(15,2) NOT NULL,
    [SalePrice] numeric(15,2) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL,
    [RecentPurchasePrice] numeric(15,5) NOT NULL,
    [PackUnits] smallint NOT NULL
);
GO

CREATE TABLE [dbo].[Student] (
    [StudentCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [RegNo] varchar(60) NOT NULL,
    [Name] varchar(100) NOT NULL,
    [FName] varchar(100) NOT NULL,
    [Gender] char(1) NOT NULL CONSTRAINT [DF_Student_Gender] DEFAULT ('M'),
    [BirthDate] datetime NOT NULL CONSTRAINT [DF_Student_BirthDate] DEFAULT (getdate()),
    [CurrentAddress] varchar(1000) NULL,
    [PermanentAddress] varchar(1000) NULL,
    [Nationality] varchar(50) NOT NULL CONSTRAINT [DF_Student_Nationality] DEFAULT ('PAKISTANI'),
    [Religion] varchar(50) NOT NULL CONSTRAINT [DF_Student_Religion] DEFAULT ('ISLAM'),
    [Phone] varchar(60) NULL,
    [Mobile] varchar(60) NULL,
    [Email] varchar(100) NULL,
    [PrevSchool] varchar(100) NULL,
    [PrevClass] varchar(100) NULL,
    [PrevClassResult] varchar(100) NULL,
    [AdmissionReqIn] smallint NULL,
    [FNIC] varchar(50) NULL,
    [FOccupation] varchar(100) NULL,
    [FDesignation] varchar(100) NULL,
    [FMonthlyIncome] numeric(15,2) NULL,
    [FMobile] varchar(60) NULL,
    [MName] varchar(100) NULL,
    [MNIC] varchar(50) NULL,
    [MOccupation] varchar(100) NULL,
    [MDesignation] varchar(100) NULL,
    [MMonthlyIncome] numeric(15,2) NULL,
    [MMobile] varchar(60) NULL,
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Student_DiscPerc] DEFAULT (0),
    [Status] char(1) NOT NULL CONSTRAINT [DF_Student_Status] DEFAULT ('R'),
    [RegisteredBy] smallint NOT NULL,
    [RegisteredOn] datetime NOT NULL CONSTRAINT [DF_Student_RegisteredOn] DEFAULT (getdate()),
    [LastUpdate] datetime NOT NULL CONSTRAINT [DF_Student_LastUpdate] DEFAULT (getdate()),
    [LastUpdateBy] smallint NOT NULL,
    [AdmittedTo] int NULL,
    [AdmittedBy] smallint NULL,
    [FlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DF_Student_FlatDisc] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [FeePaidUptill] datetime NOT NULL CONSTRAINT [DF_Student_FeePaidUptill] DEFAULT ('2012-12-12'),
    [CurrentClass] int NULL,
    [DefaulterListInstruction] varchar(255) NULL,
    [DefaulterListInstructionExpiresOn] datetime NOT NULL CONSTRAINT [DF_Student_DefaulterListInstructionExpiresOn] DEFAULT ('2012-12-12'),
    [OmitSpecialCharges] char(1) NOT NULL CONSTRAINT [DF_Student_OmitSpecialCharges] DEFAULT ('N'),
    [FeeComment] varchar(255) NULL,
    CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED ([StudentCode]),
    CONSTRAINT [UK_Student_RegNo] UNIQUE ([RegNo])
);
GO

CREATE TABLE [dbo].[StudentClass] (
    [ClassCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [RollNo] varchar(40) NOT NULL,
    [AdmissionDate] datetime NOT NULL CONSTRAINT [DF_StudentClass_AdmissionDate] DEFAULT (getdate()),
    [ServiceInvCode] int NULL,
    [LastServiceInvDate] datetime NULL,
    [PromotionRowID] int NULL,
    [GraduationRowID] int NULL,
    CONSTRAINT [PK_StudentClass] PRIMARY KEY CLUSTERED ([ClassCode], [StudentCode]),
    CONSTRAINT [UK_StudentClass_RollNo] UNIQUE ([ClassCode], [RollNo])
);
GO

CREATE TABLE [dbo].[StudentClassTransfer] (
    [TransferCode] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_StudentClassTransfer_Date] DEFAULT (getdate()),
    [StudentCode] int NOT NULL,
    [SourceClass] int NOT NULL,
    [SourceClassRollNo] varchar(40) NOT NULL,
    [SourceClassAdmissionDate] datetime NOT NULL,
    [SourceClassLastServiceInvCode] int NULL,
    [SourceClassLastServiceInvDate] datetime NULL,
    [TargetClass] int NOT NULL,
    [Reason] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    CONSTRAINT [PK_StudentClassTransfer] PRIMARY KEY CLUSTERED ([TransferCode])
);
GO

CREATE TABLE [dbo].[StudentFeeSheet] (
    [StudentFeeSheetCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_StudentFeeSheet_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_StudentFeeSheet_Posted] DEFAULT ('N'),
    [PostedBy] smallint NULL,
    [PostedOn] datetime NULL,
    [Remarks] varchar(100) NULL,
    CONSTRAINT [PK_StudentFeeSheet] PRIMARY KEY CLUSTERED ([StudentFeeSheetCode])
);
GO

CREATE TABLE [dbo].[StudentFeeSheetDetail] (
    [StudentFeeSheetCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [ClassCode] int NOT NULL,
    [RollNo] varchar(40) NOT NULL,
    [ServiceCode] int NOT NULL,
    [Fee] numeric(10,2) NOT NULL CONSTRAINT [DK_StudentFeeSheetDetail_Fee] DEFAULT (0),
    [FlatDisc] numeric(10,2) NOT NULL CONSTRAINT [DK_StudentFeeSheetDetail_FlatDisc] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DK_StudentFeeSheetDetail_DiscPerc] DEFAULT (0),
    [FeePaidUptill] datetime NULL,
    [ServiceInvCode] int NULL,
    [ServiceTemplateCode] int NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_StudentFeeSheetDetail_DueDate] DEFAULT (getdate()),
    CONSTRAINT [PK_StudentFeeSheetDetail] PRIMARY KEY ([StudentFeeSheetCode], [ClassCode], [StudentCode], [ServiceCode])
);
GO

CREATE TABLE [dbo].[StudentImage] (
    [StudentCode] int NOT NULL,
    [ImageDescription] varchar(100) NULL,
    [RowID] int NOT NULL,
    [Img] image NULL,
    [ImageType] varchar(100) NULL,
    CONSTRAINT [PK_StudentImage] PRIMARY KEY CLUSTERED ([StudentCode], [RowID])
);
GO

CREATE TABLE [dbo].[StudentServiceTemplate] (
    [StudentServiceTemplateCode] int NOT NULL,
    [Name] varchar(255) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_StudentServiceTemplate_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [ServiceCode] int NOT NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_StudentServiceTemplate_Posted] DEFAULT ('N'),
    [PostDate] datetime NULL,
    [PostedBy] smallint NULL,
    [SvcInvGenerated] char(1) NOT NULL CONSTRAINT [DF_StudentServiceTemplate_SvcInvGenerated] DEFAULT ('N'),
    CONSTRAINT [PK_StudentServiceTemplate] PRIMARY KEY CLUSTERED ([StudentServiceTemplateCode]),
    CONSTRAINT [UK_StudentServiceTemplate_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[StudentServiceTemplateDetail] (
    [StudentServiceTemplateCode] int NOT NULL,
    [StudentCode] int NOT NULL,
    [TransportRouteCode] int NULL,
    [Qty] numeric(10,2) NOT NULL CONSTRAINT [DF_StudentServiceTemplateDetail_Qty] DEFAULT (1),
    [Charges] numeric(12,2) NOT NULL CONSTRAINT [DF_StudentServiceTemplateDetail_Charges] DEFAULT (0),
    [DiscPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_StudentServiceTemplateDetail_DiscPerc] DEFAULT (0),
    [ServiceFlatDisc] numeric(12,2) NOT NULL CONSTRAINT [DF_StudentServiceTemplateDetail_ServiceFlatDisc] DEFAULT (0),
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Remarks] varchar(100) NULL,
    [Status] char(1) NULL,
    [ServiceInvCode] int NULL,
    [VehicleCode] int NULL,
    CONSTRAINT [PK_StudentServiceTemplateDetail] PRIMARY KEY CLUSTERED ([StudentServiceTemplateCode], [StudentCode])
);
GO

CREATE TABLE [dbo].[SubAccounts] (
    [SubAccCode] smallint NOT NULL,
    [CatAccCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_SubAccounts] PRIMARY KEY CLUSTERED ([SubAccCode]),
    CONSTRAINT [SANameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SubArea] (
    [SubAreaCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [manager] varchar(60) NOT NULL,
    [Areacode] smallint NOT NULL,
    [Distance] numeric(10,4) NOT NULL CONSTRAINT [DF_SubArea_Distance] DEFAULT (0),
    CONSTRAINT [PK_SubArea_SubAreaCode] PRIMARY KEY CLUSTERED ([SubAreaCode]),
    CONSTRAINT [UK_SubArea_name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SummaryAccount] (
    [SummaryAccCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [AliasName] varchar(12) NOT NULL,
    [GroupSummaryAccCode] int NOT NULL CONSTRAINT [DF_SummaryAccount_GroupSummaryAccCode] DEFAULT (1),
    CONSTRAINT [PK_SummaryAccount_SummaryAccCode] PRIMARY KEY CLUSTERED ([SummaryAccCode]),
    CONSTRAINT [UK_SummaryAccount_AliasName] UNIQUE ([AliasName])
);
GO

CREATE TABLE [dbo].[SummaryAccountDetail] (
    [SummaryAccCode] smallint NOT NULL,
    [AccCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_SummaryAccountDetail] PRIMARY KEY CLUSTERED ([SummaryAccCode], [AccCode]),
    CONSTRAINT [UK_SummaryAccountDetail_AccCode] UNIQUE ([AccCode])
);
GO

CREATE TABLE [dbo].[Supplier] (
    [SuppCode] smallint NOT NULL,
    [CP] varchar(60) NULL,
    [Address1] varchar(60) NULL,
    [City] varchar(30) NULL,
    [Country] varchar(30) NULL,
    [Phone] varchar(30) NULL,
    [Fax] varchar(16) NULL,
    [Email] varchar(30) NULL,
    [Address2] varchar(60) NULL,
    [SuppCatCode] smallint NOT NULL CONSTRAINT [DF_Supplier_SuppCatCode] DEFAULT (1),
    [DefaultGST] tinyint NOT NULL CONSTRAINT [DF_Supplier_DefaultGST] DEFAULT (1),
    [SpecialInstructions] varchar(4000) NULL,
    [DaysLimit] smallint NOT NULL CONSTRAINT [DF_Supplier_DaysLimit] DEFAULT (0),
    [PostCode] varchar(20) NULL,
    [CountyCode] smallint NULL,
    [NTNno] varchar(50) NULL,
    [SalesTaxRegNo] varchar(50) NULL,
    [CNIC] varchar(50) NULL,
    [MobileNo] varchar(50) NULL,
    [WebSiteAdd] varchar(150) NULL,
    [Phone2] varchar(50) NULL,
    [EMAIL2] varchar(50) NULL,
    [EMAIL3] varchar(50) NULL,
    [BankAcc] varchar(100) NULL,
    [WHPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_Supplier_WHPerc] DEFAULT (0),
    [PurQuotationCode] int NULL,
    [SiteCode] smallint NULL,
    CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([SuppCode])
);
GO

CREATE TABLE [dbo].[SupplierCategory] (
    [SuppCatCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_SupplierCategory] PRIMARY KEY CLUSTERED ([SuppCatCode])
);
GO

CREATE TABLE [dbo].[SupplierManufacturers] (
    [SuppCode] smallint NOT NULL,
    [ManfCode] smallint NOT NULL,
    CONSTRAINT [PK___1__16] PRIMARY KEY CLUSTERED ([SuppCode], [ManfCode])
);
GO

CREATE TABLE [dbo].[Surgery] (
    [SurgeryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_Surgery_SurgeryCode] PRIMARY KEY CLUSTERED ([SurgeryCode]),
    CONSTRAINT [UK_Surgery_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SurgeryProcedure] (
    [SurgeryProcedureCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(255) NULL,
    CONSTRAINT [PK_SurgeryProcedure_SurgeryProcedureCode] PRIMARY KEY CLUSTERED ([SurgeryProcedureCode]),
    CONSTRAINT [UK_SurgeryProcedure_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SurveyDetail] (
    [SurveyCode] int NOT NULL,
    [RowId] int IDENTITY(1,1) NOT NULL,
    [Icode] int NOT NULL,
    [ManfCode] smallint NOT NULL,
    [PackCode] smallint NOT NULL,
    [Price1] numeric(12,2) NOT NULL CONSTRAINT [DF_SurveyDetail_Price1] DEFAULT (0),
    [Price2] numeric(12,2) NOT NULL CONSTRAINT [DF_SurveyDetail_Price2] DEFAULT (0),
    [ReqPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_SurveyDetail_ReqPrice] DEFAULT (0),
    CONSTRAINT [PK_SurveyDetail] PRIMARY KEY CLUSTERED ([SurveyCode], [Icode], [ManfCode], [PackCode])
);
GO

CREATE TABLE [dbo].[SurveyHeader] (
    [SurveyCode] int NOT NULL,
    [OriginalDate] datetime NOT NULL,
    [Date] datetime NOT NULL,
    [PptCustCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [CreatedBy] smallint NOT NULL,
    [ModifiedBy] smallint NULL,
    CONSTRAINT [PK_SurveyHeader_SurveyCode] PRIMARY KEY CLUSTERED ([SurveyCode])
);
GO

CREATE TABLE [dbo].[Symptom] (
    [SymptomCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [SymptomTypeCode] smallint NOT NULL,
    [Description] varchar(400) NULL,
    CONSTRAINT [PK_Symptom_SymptomCode] PRIMARY KEY CLUSTERED ([SymptomCode]),
    CONSTRAINT [UK_Symptom_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[SymptomType] (
    [SymptomTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_SymptomType_SymptomTypeCode] PRIMARY KEY CLUSTERED ([SymptomTypeCode]),
    CONSTRAINT [UK_SymptomType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[syscatelog] (
    [fcatid] smallint NOT NULL,
    [stat] smallint NULL,
    [flag] smallint NULL,
    [fcatvalue] int NULL,
    [fcatlength] numeric(3,0) NOT NULL CONSTRAINT [DF_SysCatelog_fcatlength] DEFAULT (0),
    CONSTRAINT [PK_syscatelog] PRIMARY KEY CLUSTERED ([fcatid])
);
GO

CREATE TABLE [dbo].[syscommants] (
    [id] int NOT NULL,
    [lid] int NOT NULL,
    [cache] int NOT NULL,
    [keyid] int NOT NULL,
    [keycache] int NOT NULL,
    [stat] int NOT NULL
);
GO

CREATE TABLE [dbo].[systextcatalog] (
    [textcatalogid] int IDENTITY(1,1) NOT NULL,
    [textcatalog] varchar(200) NOT NULL,
    [cataloglength] int NOT NULL,
    [textlength] int NOT NULL,
    [status] smallint NOT NULL,
    [cache] smallint NOT NULL
);
GO

CREATE TABLE [dbo].[TaxCategory] (
    [TaxCategoryCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [TaxPerc] numeric(5,2) NOT NULL CONSTRAINT [DF_TaxCategory_TaxPerc] DEFAULT (0),
    CONSTRAINT [PK_TaxCategory] PRIMARY KEY CLUSTERED ([TaxCategoryCode]),
    CONSTRAINT [UK_TaxCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Tdetail] (
    [TransCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Batch] varchar(100) NOT NULL,
    [Expiry] datetime NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_TDetail_Qty] DEFAULT (0),
    [id] int IDENTITY(1,1) NOT NULL,
    [TransferUtn] bigint NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_TDetail_AvgPrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_TDetail_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_TDetail_SalePrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF__TDETAIL__PackUni__037C6257] DEFAULT (1),
    [SourceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_TDetail_SourceStock] DEFAULT (0),
    [TargetStock] numeric(15,4) NOT NULL CONSTRAINT [DF_TDetail_TargetStock] DEFAULT (0),
    [ReOrderQty] int NOT NULL CONSTRAINT [DF_TDetail_ReOrderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_TDetail_OptimumQty] DEFAULT (0),
    [RequiredQty] numeric(15,4) NOT NULL CONSTRAINT [DF_TDetail_RequiredQty] DEFAULT (0),
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_TDetail_PackQty] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_TDetail_RowGroup] DEFAULT (1),
    [TransReqRowID] int NULL,
    [ItemDescription] varchar(100) NULL,
    [AlternateCustomICode] varchar(75) NULL,
    CONSTRAINT [PK_TDetail_TransCode_Id] PRIMARY KEY CLUSTERED ([TransCode], [id])
);
GO

CREATE TABLE [dbo].[temp_GroupRights] (
    [GroupCode] smallint NOT NULL,
    [RightCode] smallint NOT NULL,
    [Status] tinyint NOT NULL
);
GO

CREATE TABLE [dbo].[temp_saleinvcode] (
    [saleinvcode] int NOT NULL
);
GO

CREATE TABLE [dbo].[TestMachine] (
    [TestMachineCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_TestMachine_TestMachineCode] PRIMARY KEY CLUSTERED ([TestMachineCode]),
    CONSTRAINT [UK_TestMachine_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ThaliumScan] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_ThaliumScan_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ThaliumScan] char(1) NULL,
    [DateThaliumScan] datetime NULL,
    [DoctorThaliumScan] varchar(100) NULL,
    [InstitutionThaliumScan] varchar(100) NULL,
    [ReversibleIschemiaPresent] char(1) NULL,
    [ReversibleIschemiaPresentThaliumScan] char(1) NULL,
    [NoReversibleIschemia] char(1) NULL,
    [NoReversibleIschemiaThaliumScan] char(1) NULL,
    [MyocardiumViability] char(1) NULL,
    [MyocardiumViabilityThaliumScan] char(1) NULL,
    [EF] char(1) NULL,
    [EFThaliumScan] numeric(10,2) NULL,
    [Others] varchar(100) NULL,
    [Remarks] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_ThaliumScan_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_ThaliumScan_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[Theader] (
    [TransCode] int NOT NULL,
    [SGCode] smallint NOT NULL,
    [DGCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Posted] varchar(1) NOT NULL,
    [PostDate] datetime NOT NULL,
    [Remarks] varchar(100) NULL,
    [HeaderNo] smallint NULL,
    [HeaderInvNo] int NULL,
    [TTCode] int NOT NULL CONSTRAINT [DF_THeader_TTCode] DEFAULT (1),
    [StartDate] datetime NOT NULL CONSTRAINT [DF_THeader_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_THeader_EndDate] DEFAULT (getdate()),
    [Transferable] char(1) NOT NULL CONSTRAINT [DF_Theader_Transferable] DEFAULT ('N'),
    [Transfered] char(1) NOT NULL CONSTRAINT [DF_Theader_Transfered] DEFAULT ('N'),
    [TransferedOn] datetime NULL,
    [TransferedBy] smallint NULL,
    [Imported] char(1) NOT NULL CONSTRAINT [DF_Theader_Imported] DEFAULT ('N'),
    [ImportedBy] smallint NULL,
    [PostedBy] smallint NOT NULL CONSTRAINT [DF_THeader_PostedBy] DEFAULT (1),
    [TransReqCode] int NULL,
    [SMANCode] smallint NOT NULL CONSTRAINT [DF_THeader_SManCode] DEFAULT (1),
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_THeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    [WorkOrderCode] int NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_v_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_Theader_1__10] PRIMARY KEY CLUSTERED ([TransCode])
);
GO

CREATE TABLE [dbo].[TimeSlot] (
    [TSCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    [ShiftCode] smallint NOT NULL CONSTRAINT [DF__TIMESLOT__ShiftC__2082B559] DEFAULT (1),
    CONSTRAINT [PK_TimeSlot] PRIMARY KEY CLUSTERED ([TSCode]),
    CONSTRAINT [IX_TimeSlot_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[TransactionCategory] (
    [TransactionCatCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_TransactionCategory] PRIMARY KEY CLUSTERED ([TransactionCatCode]),
    CONSTRAINT [UK_TransactionCategory_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[TransactionDetail] (
    [DocumentCode] int NOT NULL,
    [AccCode] smallint NOT NULL,
    [Amount] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionDetail_Amount] DEFAULT (0),
    [Remarks] varchar(100) NULL,
    [RowID] int NOT NULL,
    CONSTRAINT [PK_TransactionDetail] PRIMARY KEY CLUSTERED ([DocumentCode], [AccCode])
);
GO

CREATE TABLE [dbo].[TransactionHeader] (
    [DocumentCode] int NOT NULL,
    [TransactionTypeCode] smallint NOT NULL,
    [TransactionCode] int NOT NULL CONSTRAINT [DF_TransactionHeader_TransactionCode] DEFAULT (0),
    [Date] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(100) NULL,
    [PatientCode] int NULL,
    [AdmissionCode] int NULL,
    [PatientBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionHeader_PatientBalance] DEFAULT (0),
    [AccCode] smallint NOT NULL,
    [AccBalance] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionHeader_AccBalance] DEFAULT (0),
    [CashAccCode] smallint NOT NULL CONSTRAINT [DF_TransactionHeader_CashAccCode] DEFAULT (2),
    [CashTendered] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionHeader_CashTendered] DEFAULT (0),
    [CashCharged] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionHeader_CashCharged] DEFAULT (0),
    [CashBack] numeric(15,2) NOT NULL CONSTRAINT [DF_TransactionHeader_CashBack] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_TransactionHeader_Posted] DEFAULT ('Y'),
    [PostedBy] smallint NULL,
    [PostDate] datetime NULL,
    [Synced] char(1) NOT NULL CONSTRAINT [DF_TransactionHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    [CRS_Transfered] char(1) NOT NULL CONSTRAINT [DF_TransactionHeader_CRS_Transfered] DEFAULT ('N'),
    [CRS_TransferedOn] datetime NULL,
    CONSTRAINT [PK_TransactionHeader_DocumentCode] PRIMARY KEY CLUSTERED ([DocumentCode])
);
GO

CREATE TABLE [dbo].[TransactionType] (
    [TransactionTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(2) NOT NULL,
    [TransactionCatCode] tinyint NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_TransactionType_Counter] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_TransactionType_Posted] DEFAULT ('N'),
    [AutoPost] char(1) NOT NULL CONSTRAINT [DF_TransactionType_AutoPost] DEFAULT ('Y'),
    CONSTRAINT [PK_TransactionType] PRIMARY KEY CLUSTERED ([TransactionTypeCode]),
    CONSTRAINT [UK_TransactionType_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_TransactionType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[TransferableData] (
    [TABLENAME] varchar(50) NOT NULL,
    [PRIORITY] int NOT NULL,
    [AUTOINSERT] char(1) NOT NULL CONSTRAINT [DF_TransferableData_AutoInsert] DEFAULT ('Y'),
    [AUTOUPDATE] char(1) NOT NULL CONSTRAINT [DF_TransferableData_AutoUpdate] DEFAULT ('Y'),
    [AUTODELETE] char(1) NOT NULL CONSTRAINT [DF_TransferableData_AutoDelete] DEFAULT ('N'),
    [UPDATETABMAXKEY] char(1) NOT NULL CONSTRAINT [DF_TransferableData_UpdateTabMaxKey] DEFAULT ('N'),
    [Enable] char(1) NOT NULL CONSTRAINT [DF_TransferableData_Enable] DEFAULT ('Y'),
    CONSTRAINT [PK_TransferableData] PRIMARY KEY CLUSTERED ([TABLENAME]),
    CONSTRAINT [UK_TransferableData_Priority] UNIQUE ([PRIORITY])
);
GO

CREATE TABLE [dbo].[TransferableData_ExportRestrictedColumns] (
    [TableName] varchar(50) NOT NULL,
    [ColumnName] varchar(50) NOT NULL,
    CONSTRAINT [PK_TransferableData_ExportRestrictedColumns] PRIMARY KEY CLUSTERED ([TableName], [ColumnName])
);
GO

CREATE TABLE [dbo].[TransferableData_RestrictedColumns] (
    [TableName] varchar(50) NOT NULL,
    [ColumnName] varchar(50) NOT NULL,
    CONSTRAINT [PK_TransferableData_RestrictedColumns] PRIMARY KEY CLUSTERED ([TableName], [ColumnName])
);
GO

CREATE TABLE [dbo].[TransferRequisitionDetail] (
    [TransReqCode] int NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_Qty] DEFAULT (0),
    [id] int IDENTITY(1,1) NOT NULL,
    [AvgPrice] numeric(15,5) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_AvgPrice] DEFAULT (0),
    [PurPrice] numeric(12,2) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_PurPrice] DEFAULT (0),
    [SalePrice] numeric(12,2) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_SalePrice] DEFAULT (0),
    [PackUnits] smallint NOT NULL CONSTRAINT [DF__TransferRequisitionDetail__PackUni__18427513] DEFAULT (1),
    [SourceStock] numeric(15,4) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_SourceStock] DEFAULT (0),
    [TargetStock] numeric(15,4) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_TargetStock] DEFAULT (0),
    [ReOrderQty] int NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_ReOrderQty] DEFAULT (0),
    [OptimumQty] int NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_OptimumQty] DEFAULT (0),
    [RequiredQty] numeric(15,4) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_RequiredQty] DEFAULT (0),
    [PackQty] numeric(15,4) NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_PackQty] DEFAULT (0),
    [RowGroup] int NOT NULL CONSTRAINT [DF_TransferRequisitionDetail_RowGroup] DEFAULT (1),
    [AlternateCustomICode] varchar(75) NULL,
    [ItemDescription] varchar(100) NULL,
    CONSTRAINT [PK_TransferRequisitionDetail_TransReqCode_Id] PRIMARY KEY CLUSTERED ([TransReqCode], [id])
);
GO

CREATE TABLE [dbo].[TransferRequisitionHeader] (
    [TransReqCode] int NOT NULL,
    [SGCode] smallint NOT NULL,
    [DGCode] smallint NOT NULL,
    [SalesManCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [Posted] varchar(1) NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_Posted] DEFAULT ('N'),
    [PostDate] datetime NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_PostDate] DEFAULT (getdate()),
    [PostedBy] smallint NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_PostedBy] DEFAULT (1),
    [TTCode] int NOT NULL,
    [Remarks] varchar(100) NULL,
    [StartDate] datetime NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_StartDate] DEFAULT (getdate()),
    [EndDate] datetime NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_EndDate] DEFAULT (getdate()),
    [Synced] char(1) NOT NULL CONSTRAINT [DF_TransferRequisitionHeader_Synced] DEFAULT ('N'),
    [SyncedOn] datetime NULL,
    [SyncedBy] smallint NULL,
    CONSTRAINT [PK_TransferRequisitionHeader_TransReqCode] PRIMARY KEY CLUSTERED ([TransReqCode])
);
GO

CREATE TABLE [dbo].[TransferType] (
    [TTCode] int NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_TransferType] PRIMARY KEY CLUSTERED ([TTCode]),
    CONSTRAINT [UQ_TransferType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[TransportRoute] (
    [TransportRouteCode] int NOT NULL,
    [Name] varchar(255) NOT NULL,
    [TransportCharges] numeric(12,2) NOT NULL CONSTRAINT [DF_TransportRoute_TransportCharges] DEFAULT (0),
    CONSTRAINT [PK_TransportRoute] PRIMARY KEY CLUSTERED ([TransportRouteCode]),
    CONSTRAINT [UK_TransportRoute_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[TreatmentGiven] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_TreatmentGiven_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [ICode] int NOT NULL,
    [DosageUnitCode] smallint NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_TreatmentGiven_Qty] DEFAULT (1),
    [DosageStrength] varchar(60) NULL,
    [DosageCode] smallint NOT NULL,
    [DosageFactor] smallint NOT NULL CONSTRAINT [DF_TreatmentGiven_DosageFactor] DEFAULT (1),
    [RouteCode] smallint NOT NULL,
    [Duration] smallint NOT NULL CONSTRAINT [DF_TreatmentGiven_Duration] DEFAULT (1),
    [StartDate] datetime NOT NULL CONSTRAINT [DF_TreatmentGiven_StartDate] DEFAULT (getdate()),
    [InsCode] smallint NOT NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_TreatmentGiven_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_TreatmentGiven_AttendingDoctCode] DEFAULT (1)
);
GO

CREATE TABLE [dbo].[TryDueSatisfyDetail] (
    [DueSatisfyCode] int NOT NULL,
    [ICode] int NOT NULL,
    [GCode] smallint NOT NULL,
    [Batch] varchar(10) NOT NULL,
    [Expiry] datetime NOT NULL,
    [DueSatisfyQty] int NOT NULL
);
GO

CREATE TABLE [dbo].[TryDueSatisfyHeader] (
    [DueSatisfyCode] int NOT NULL,
    [SaleInvCode] int NOT NULL,
    [DueSatisfyDate] datetime NOT NULL,
    [UserCode] smallint NOT NULL
);
GO

CREATE TABLE [dbo].[Unit] (
    [UnitCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Unit] PRIMARY KEY CLUSTERED ([UnitCode]),
    CONSTRAINT [IX_UnitName] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[UnitSalesTaxRules] (
    [RuleCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [ShortName] varchar(5) NOT NULL,
    CONSTRAINT [PK_UnitSalesTaxRules_RuleCode] PRIMARY KEY CLUSTERED ([RuleCode]),
    CONSTRAINT [UK_UnitSalesTaxRules_ShortName] UNIQUE ([ShortName]),
    CONSTRAINT [UK_UnitSalesTaxRules_Name] UNIQUE ([RuleCode])
);
GO

CREATE TABLE [dbo].[UserAllowedDoctor] (
    [UserCode] smallint NOT NULL,
    [DoctCode] smallint NOT NULL,
    CONSTRAINT [PK_UserAllowedDoctor_UserCode] PRIMARY KEY CLUSTERED ([UserCode], [DoctCode])
);
GO

CREATE TABLE [dbo].[UserAttendance] (
    [UserCode] smallint NOT NULL,
    [TimeIn] datetime NOT NULL,
    [TimeOut] datetime NULL,
    [Remarks] varchar(100) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[UserAuthenticationInfo] (
    [AuthenticationKey] varchar(20) NOT NULL
);
GO

CREATE TABLE [dbo].[UserGroups] (
    [UserCode] smallint NOT NULL,
    [GroupCode] smallint NOT NULL,
    [ModifiedBy] smallint NOT NULL CONSTRAINT [DF_UserGroups_ModifiedBy] DEFAULT (1),
    CONSTRAINT [PK___3__11] PRIMARY KEY CLUSTERED ([UserCode], [GroupCode])
);
GO

CREATE TABLE [dbo].[UserGroupsLog] (
    [LogDate] datetime NOT NULL,
    [UserCode] smallint NOT NULL,
    [GroupCode] smallint NOT NULL,
    [ModifiedBy] smallint NOT NULL,
    CONSTRAINT [PK_UserGroupsLog] PRIMARY KEY CLUSTERED ([LogDate], [UserCode], [GroupCode])
);
GO

CREATE TABLE [dbo].[UserRights] (
    [UserCode] smallint NOT NULL,
    [RightCode] smallint NOT NULL,
    [Status] tinyint NOT NULL CONSTRAINT [DF_UserRights_Status_7__11] DEFAULT (1),
    CONSTRAINT [PK___6__11] PRIMARY KEY CLUSTERED ([UserCode], [RightCode])
);
GO

CREATE TABLE [dbo].[Users] (
    [UserCode] smallint NOT NULL,
    [UserName] varchar(60) NOT NULL,
    [Password] varchar(60) NOT NULL,
    [FatherName] varchar(60) NULL,
    [Address] varchar(100) NULL,
    [Phone] varchar(20) NULL,
    [Active] char(1) NOT NULL CONSTRAINT [DF_Users_Active] DEFAULT ('Y'),
    CONSTRAINT [PK___2__11] PRIMARY KEY CLUSTERED ([UserCode])
);
GO

CREATE TABLE [dbo].[VaccineSchedule] (
    [Code] int IDENTITY(1,1) NOT NULL,
    [PatientCode] int NOT NULL,
    [ICode] int NOT NULL,
    [DueDate] datetime NOT NULL CONSTRAINT [DF_VaccineSchedule_DueDate] DEFAULT (getdate() + 30),
    [Remarks] varchar(1000) NULL,
    [VaccineStatusCode] tinyint NOT NULL,
    [LastRemindedOn] datetime NULL,
    [LastRemindedBy] smallint NULL,
    [LastPendedOn] datetime NULL,
    [LastPendedBy] smallint NULL,
    [VaccinatedOn] datetime NULL,
    [VaccinatedBy] smallint NULL,
    [DoctCode] smallint NULL,
    [SaleTemplateRowID] int NULL,
    [ScheduleDate] datetime NOT NULL CONSTRAINT [DF_VaccineSchedule_ScheduleDate] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_VaccineSchedule_UserCode] DEFAULT (1),
    [ModifiedOn] datetime NULL,
    [ModifiedBy] smallint NULL,
    [StoppedOn] datetime NULL,
    [StoppedBy] smallint NULL,
    CONSTRAINT [PK_VaccineSchedule] PRIMARY KEY CLUSTERED ([Code])
);
GO

CREATE TABLE [dbo].[VaccineStatus] (
    [VaccineStatusCode] tinyint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_VaccineStatus] PRIMARY KEY CLUSTERED ([VaccineStatusCode]),
    CONSTRAINT [UK_VaccineStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Vehicle] (
    [VehicleCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [VehicleTypeCode] smallint NOT NULL,
    [DriverName] varchar(100) NULL,
    CONSTRAINT [PK_Vehicle] PRIMARY KEY CLUSTERED ([VehicleCode]),
    CONSTRAINT [UK_Vehicle_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[VehicleRoute] (
    [VehicleCode] int NOT NULL,
    [TransportRouteCode] int NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_VehicleRoute] PRIMARY KEY CLUSTERED ([VehicleCode], [TransportRouteCode])
);
GO

CREATE TABLE [dbo].[VehicleType] (
    [VehicleTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    CONSTRAINT [PK_VehicleType] PRIMARY KEY CLUSTERED ([VehicleTypeCode]),
    CONSTRAINT [UK_VehicleType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[VirtualGl] (
    [DocumentCode] int NOT NULL,
    [DocumentType] varchar(20) NOT NULL,
    [AccCode] smallint NOT NULL,
    [CatCode] tinyint NOT NULL,
    [AlternateAccCode] smallint NULL,
    [Debit] numeric(15,2) NOT NULL,
    [Credit] numeric(15,2) NOT NULL,
    [Date] datetime NOT NULL,
    [CheckNo] varchar(20) NULL,
    [Remarks] varchar(100) NULL,
    [UserCode] smallint NOT NULL,
    [PatientCode] int NULL,
    [VoucherCode] int NULL,
    [INVOICECODE] int NULL,
    [OUTSTANDINGAMT] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGL_OUTSTANDINGAMT] DEFAULT (0),
    [BALANCE] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGL_BALANCE] DEFAULT (0),
    [InvoiceType] tinyint NULL,
    [VRow] tinyint NOT NULL CONSTRAINT [DF_VirtualGL_VROW] DEFAULT (0),
    [GRN] varchar(100) NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [CurrencyCode] smallint NULL,
    [ConversionRate] numeric(11,5) NULL
);
GO

CREATE TABLE [dbo].[VirtualGlTemp] (
    [documentcode] int NOT NULL,
    [documenttype] varchar(20) NOT NULL,
    [catcode] tinyint NOT NULL,
    [dr_acccode] smallint NOT NULL,
    [cr_acccode] smallint NOT NULL,
    [AlternateAccCode] smallint NULL,
    [date] datetime NOT NULL,
    [SaleTax] numeric(15,2) NOT NULL,
    [Gross] numeric(15,2) NOT NULL,
    [dr_remarks] varchar(100) NULL,
    [cr_remarks] varchar(100) NULL,
    [Saletax_remarks] varchar(100) NULL,
    [checkNo] varchar(20) NULL,
    [usercode] smallint NULL,
    [VoucherCode] int NULL,
    [InvoiceCode] int NULL,
    [InvoiceType] tinyint NULL,
    [Amt] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGlTemp_Amt] DEFAULT (0),
    [DrAmtAccCode] int NULL,
    [CrAmtAccCode] int NULL,
    [AmtBy] smallint NULL,
    [AmtDate] datetime NULL,
    [AmtRef] varchar(60) NULL,
    [OutstandingAmt] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGlTemp_OutstandingAmt] DEFAULT (0),
    [Balance] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGlTemp_Balance] DEFAULT (0),
    [PatientCode] int NULL,
    [GRN] varchar(100) NULL,
    [GCCode] smallint NULL,
    [Vehicle] varchar(100) NULL,
    [ShipTo] varchar(100) NULL,
    [GuestCode] int NULL,
    [StudentCode] int NULL,
    [CGS] numeric(15,2) NOT NULL CONSTRAINT [DF_VirtualGLTemp_CGS] DEFAULT (0),
    [CurrencyCode] smallint NULL,
    [ConversionRate] numeric(11,5) NULL,
    [AdvIncomeTax] numeric(12,2) NOT NULL CONSTRAINT [DF_VirtualGLTemp_AdvIncomeTax] DEFAULT (0),
    [FBRPosFee] numeric(5,2) NOT NULL CONSTRAINT [DF_VirtualGLTemp_FBRPosFee] DEFAULT (0)
);
GO

CREATE TABLE [dbo].[Visit] (
    [VisitCode] int NOT NULL,
    [Date] datetime NOT NULL,
    [AppointmentCode] int NULL,
    [DoctCode] smallint NOT NULL,
    [VisitTypeCode] smallint NOT NULL CONSTRAINT [DF_Visit_VisitTypeCode] DEFAULT (1),
    [VisitStatusCode] smallint NOT NULL CONSTRAINT [DF_Visit_VisitStatusCode] DEFAULT (1),
    [PatientCode] int NULL,
    [PatientDetails] varchar(100) NULL,
    [Diagnosis] varchar(400) NULL,
    [Remarks] varchar(100) NULL,
    [ReferredBy] varchar(100) NULL,
    [FollowUpDays] int NOT NULL CONSTRAINT [DF_Visit_FollowUpDays] DEFAULT (7),
    [VisitFee] numeric(10,2) NOT NULL CONSTRAINT [DF_Visit_VisitFee] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_Visit_Posted] DEFAULT ('N'),
    [UserCode] smallint NOT NULL,
    [PreviousDiagnosis] varchar(400) NULL,
    [Recommendations] varchar(400) NULL,
    [FollowUpDate] datetime NULL,
    [Precautions] varchar(400) NULL,
    CONSTRAINT [PK_Visit_VisitCode] PRIMARY KEY CLUSTERED ([VisitCode])
);
GO

CREATE TABLE [dbo].[VisitAppointment] (
    [AppointmentCode] int NOT NULL,
    [DoctCode] smallint NOT NULL,
    [Date] datetime NOT NULL,
    [TokenNo] smallint NOT NULL,
    [AppointmentMethodCode] smallint NOT NULL CONSTRAINT [DF_VisitAppointment_AppointmentMethodCode] DEFAULT (1),
    [AppointmentStatusCode] smallint NOT NULL CONSTRAINT [DF_VisitAppointment_AppointmentStatusCode] DEFAULT (1),
    [PatientCode] int NULL,
    [PatientDetails] varchar(100) NULL,
    [ReferredBy] varchar(100) NULL,
    [Remarks] varchar(100) NULL,
    [Comments] varchar(400) NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_VisitAppointment_Posted] DEFAULT ('N'),
    [UserCode] smallint NOT NULL CONSTRAINT [DF_VisitAppointment_UserCode] DEFAULT (1),
    [DueDate] datetime NOT NULL CONSTRAINT [DF_VisitAppointment_DueDate] DEFAULT (getdate()),
    CONSTRAINT [PK_VisitAppointment_AppointmentCode] PRIMARY KEY CLUSTERED ([AppointmentCode])
);
GO

CREATE TABLE [dbo].[VisitDiagnostics] (
    [VisitCode] int NOT NULL,
    [DiagnosticItemCode] int NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [DiagnosticValue] numeric(15,5) NOT NULL CONSTRAINT [DF_VisitDiagnostics_DiagnosticValue] DEFAULT (0),
    [Details] varchar(400) NULL,
    CONSTRAINT [PK_VisitDiagnostics] PRIMARY KEY CLUSTERED ([VisitCode], [ROWID])
);
GO

CREATE TABLE [dbo].[VisitPhysicalExam] (
    [VisitCode] int NOT NULL,
    [PhysicalExamCode] int NOT NULL,
    [Details] varchar(400) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_VisitPhysicalExam] PRIMARY KEY CLUSTERED ([VisitCode], [RowID])
);
GO

CREATE TABLE [dbo].[VisitPrecaution] (
    [VisitCode] int NOT NULL,
    [PrecautionCode] smallint NOT NULL,
    CONSTRAINT [PK_VisitPrecaution] PRIMARY KEY CLUSTERED ([VisitCode], [PrecautionCode])
);
GO

CREATE TABLE [dbo].[VisitPrescription] (
    [VisitCode] int NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    [ICode] int NOT NULL,
    [Qty] numeric(15,4) NOT NULL CONSTRAINT [DF_VisitPrescription_Qty] DEFAULT (1),
    [DiseaseCode] smallint NULL CONSTRAINT [DF_VisitPrescription_DiseaseCode] DEFAULT (1),
    [DosageCode] smallint NULL,
    [DosageFactor] smallint NULL,
    [RouteCode] smallint NULL,
    [Duration] smallint NULL,
    [Date] datetime NULL,
    [InsCode] smallint NULL,
    [Details] varchar(400) NULL,
    [DosageUnitCode] smallint NOT NULL CONSTRAINT [DF_VisitPrescription_DosageUnitCode] DEFAULT (1),
    [DosageStrength] varchar(60) NULL,
    [TotalQty] numeric(15,4) NOT NULL CONSTRAINT [DF_VisitPrescription_TotalQty] DEFAULT (1),
    CONSTRAINT [PK_VisitPrescription] PRIMARY KEY CLUSTERED ([VisitCode], [ROWID])
);
GO

CREATE TABLE [dbo].[VisitStatus] (
    [VisitStatusCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_VisitStatus_VisitStatusCode] PRIMARY KEY CLUSTERED ([VisitStatusCode]),
    CONSTRAINT [UK_VisitStatus_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[VisitSymptoms] (
    [VisitCode] int NOT NULL,
    [SymptomCode] int NOT NULL,
    [SeverityLevelCode] smallint NOT NULL,
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Duration] int NULL,
    [Details] varchar(400) NULL,
    CONSTRAINT [PK_VisitSymptoms] PRIMARY KEY CLUSTERED ([VisitCode], [RowID])
);
GO

CREATE TABLE [dbo].[VisitType] (
    [VisitTypeCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [PK_VisitType_VisitTypeCode] PRIMARY KEY CLUSTERED ([VisitTypeCode]),
    CONSTRAINT [UK_VisitType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[VisitVitals] (
    [VisitCode] int NOT NULL,
    [Height1] smallint NULL,
    [HeightUnit1] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_HeightUnit1] DEFAULT ('FT.'),
    [Height2] smallint NULL,
    [HeightUnit2] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_HeightUnit2] DEFAULT ('INCH'),
    [Weight1] smallint NULL,
    [WeightUnit1] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_WeightUnit1] DEFAULT ('KG'),
    [Weight2] smallint NULL,
    [WeightUnit2] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_WeightUnit2] DEFAULT ('G'),
    [TemperatureValue] numeric(5,2) NULL,
    [TemperatureUnit] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_TemperatureUnit] DEFAULT ('FH'),
    [PulseRate] smallint NULL,
    [PulseRhythm] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_PulseRhythm] DEFAULT ('R'),
    [Respiration] smallint NULL,
    [RespirationRhythm] varchar(5) NOT NULL CONSTRAINT [DF_VisitVitals_RespirationRhythm] DEFAULT ('R'),
    [BloodPressureSystolic] smallint NULL,
    [BloodPressureDiastolic] smallint NULL,
    [VitalNotes] varchar(400) NULL,
    [BMI] numeric(8,4) NULL,
    [BSAMethod] tinyint NULL,
    [BSA] numeric(8,4) NULL,
    [SPO2] varchar(100) NULL,
    CONSTRAINT [PK_VisitVitals_VisitCode] PRIMARY KEY CLUSTERED ([VisitCode])
);
GO

CREATE TABLE [dbo].[VocherCategory] (
    [VochCatCode] smallint NOT NULL,
    [Name] varchar(30) NOT NULL,
    [ShortName] varchar(20) NOT NULL,
    [Counter] int NOT NULL CONSTRAINT [DF_VoucherCategory_Counter] DEFAULT (0),
    [Posted] char(1) NOT NULL CONSTRAINT [DF_VoucherCategory_Posted] DEFAULT ('N'),
    [SystemType] tinyint NOT NULL CONSTRAINT [DF_VoucherCategory_SystemType] DEFAULT (0),
    [JournalVoucher] tinyint NOT NULL CONSTRAINT [DF_VoucherCategory_JournalVoucher] DEFAULT (0),
    [HeaderTreatment] char(1) NULL,
    [DetailTreatment] char(1) NULL,
    [InvoiceBased] tinyint NOT NULL CONSTRAINT [DF_VoucherCategory_InvoiceBased] DEFAULT (0),
    [InvoiceType] tinyint NULL,
    [AutoPosting] char(1) NOT NULL CONSTRAINT [DF_VocherCategory_AutoPosting] DEFAULT ('N'),
    [VoucherOrder] tinyint NOT NULL CONSTRAINT [DF_VocherCategory_VoucherOrder] DEFAULT (1),
    [UseForSMS] char(1) NOT NULL CONSTRAINT [DF_VocherCategory_UseForSMS] DEFAULT ('N'),
    CONSTRAINT [PK_VocherCategory] PRIMARY KEY CLUSTERED ([VochCatCode]),
    CONSTRAINT [VCNameUC] UNIQUE ([Name]),
    CONSTRAINT [IX_VocherCategory_ShortName] UNIQUE ([ShortName])
);
GO

CREATE TABLE [dbo].[VocherCategoryDetail] (
    [VochCatCode] smallint NOT NULL,
    [SubAccCode] smallint NOT NULL,
    CONSTRAINT [PK_VocherCategoryDetail] PRIMARY KEY CLUSTERED ([VochCatCode], [SubAccCode])
);
GO

CREATE TABLE [dbo].[VocherCategoryHeader] (
    [VochCatCode] smallint NOT NULL,
    [SubAccCode] smallint NOT NULL,
    CONSTRAINT [PK_VocherCategoryHeader] PRIMARY KEY CLUSTERED ([VochCatCode], [SubAccCode])
);
GO

CREATE TABLE [dbo].[Ward] (
    [WardCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Description] varchar(100) NULL,
    CONSTRAINT [PK_Ward] PRIMARY KEY CLUSTERED ([WardCode]),
    CONSTRAINT [IX_Ward] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[WeekDays] (
    [WeekDayCode] tinyint NOT NULL,
    [Name] varchar(15) NOT NULL,
    CONSTRAINT [PK_WeekDayCode_WeekDays] PRIMARY KEY CLUSTERED ([WeekDayCode]),
    CONSTRAINT [UK_WeekDayCode_WeekDays] UNIQUE ([WeekDayCode])
);
GO

CREATE TABLE [dbo].[WeekOfMonth] (
    [WeekOfMonth] tinyint NOT NULL,
    [NAME] varchar(20) NOT NULL,
    CONSTRAINT [PK_WeekOfMonth] PRIMARY KEY CLUSTERED ([WeekOfMonth]),
    CONSTRAINT [UK_WeekOfMonth] UNIQUE ([NAME])
);
GO

CREATE TABLE [dbo].[WeighingScale] (
    [WeighingScaleCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Manufacturer] varchar(100) NULL,
    [MODEL] varchar(100) NULL,
    [ScaleID] varchar(10) NOT NULL CONSTRAINT [DF_ScaleID_WeighingScale] DEFAULT ('98'),
    [ScaleIDPos] smallint NOT NULL CONSTRAINT [DF_ScaleIDPos_WeighingScale] DEFAULT (1),
    [BarCodeLen] smallint NOT NULL CONSTRAINT [DF_BarCodeLen_WeighingScale] DEFAULT (13),
    [ItemStartPos] smallint NOT NULL CONSTRAINT [DF_ItemStartPos_WeighingScale] DEFAULT (3),
    [ItemEndPos] smallint NOT NULL CONSTRAINT [DF_ItemEndPos_WeighingScale] DEFAULT (7),
    [WeightStartPos] smallint NOT NULL CONSTRAINT [DF_WeightStartPos_WeighingScale] DEFAULT (8),
    [WeightEndPos] smallint NOT NULL CONSTRAINT [DF_WeightEndPos_WeighingScale] DEFAULT (12),
    CONSTRAINT [PK_WeighingScale] PRIMARY KEY CLUSTERED ([WeighingScaleCode]),
    CONSTRAINT [UK_WeighingScale_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[WindowType] (
    [WinType] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    CONSTRAINT [Pk_WindowType] PRIMARY KEY CLUSTERED ([WinType]),
    CONSTRAINT [Uq_WindowType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[WorkOrder] (
    [WorkOrderCode] int NOT NULL,
    [CustCode] smallint NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_WorkOrder_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [InitiatedBy] varchar(100) NULL,
    [Address] varchar(255) NULL,
    [ContactNo] varchar(100) NULL,
    [Email] varchar(100) NULL,
    [AvailabilityToVisit] varchar(100) NULL,
    [Complaint] varchar(4000) NULL,
    [Demand] varchar(4000) NULL,
    [Remarks] varchar(255) NULL,
    [Approved] char(1) NOT NULL CONSTRAINT [DF_WorkOrder_Approved] DEFAULT ('N'),
    [ApprovedOn] datetime NULL,
    [ApprovedBy] smallint NULL,
    [Posted] char(1) NOT NULL CONSTRAINT [DF_WorkOrder_Posted] DEFAULT ('N'),
    [PostedOn] datetime NULL,
    [PostedBy] smallint NULL,
    [WorkOrderAccCode] int NOT NULL CONSTRAINT [DF_WorkOrder_WorkOrderAccCode] DEFAULT (1),
    [WorkOrderTypeCode] smallint NOT NULL CONSTRAINT [DF_WorkOrder_WorkOrderTypeCode] DEFAULT (1),
    CONSTRAINT [PK_WorkOrder] PRIMARY KEY CLUSTERED ([WorkOrderCode])
);
GO

CREATE TABLE [dbo].[WorkOrderAccount] (
    [WorkOrderAccCode] int NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(1000) NULL,
    [Limit] numeric(12,2) NOT NULL CONSTRAINT [DF_WorkOrderAccCode_Limit] DEFAULT (0),
    [DrCr] char(1) NOT NULL CONSTRAINT [DF_WorkOrderAccCode_DrCr] DEFAULT ('D'),
    CONSTRAINT [PK_WorkOrderAccount] PRIMARY KEY CLUSTERED ([WorkOrderAccCode]),
    CONSTRAINT [UK_WorkOrderAccCode_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[WorkOrderAssessment] (
    [WorkOrderCode] int NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_WorkOrderAssessment_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [AssessedOn] datetime NULL,
    [AssessedBy] varchar(255) NULL,
    [Assessment] varchar(4000) NULL,
    [ActionProposed] varchar(4000) NULL,
    [Remarks] varchar(255) NULL,
    CONSTRAINT [PK_WorkOrderAssessment] PRIMARY KEY CLUSTERED ([WorkOrderCode])
);
GO

CREATE TABLE [dbo].[WorkOrderResource] (
    [WorkOrderCode] int NOT NULL,
    [ResourceCode] int NOT NULL,
    [Qty] int NOT NULL CONSTRAINT [DF_WorkOrderResource_Qty] DEFAULT (1),
    [Cost] numeric(15,2) NOT NULL CONSTRAINT [DF_WorkOrderResource_Cost] DEFAULT (0),
    [EstTimeReq] datetime NULL,
    [TimeTaken] datetime NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_WorkOrderResource_Date] DEFAULT (getdate()),
    [UserCode] smallint NOT NULL,
    [Remarks] varchar(255) NULL,
    [RowID] int IDENTITY(1,1) NOT NULL
);
GO

CREATE TABLE [dbo].[WorkOrderType] (
    [WorkOrderTypeCode] smallint NOT NULL,
    [Name] varchar(100) NOT NULL,
    [Description] varchar(1000) NULL,
    CONSTRAINT [PK_WorkOrderType] PRIMARY KEY CLUSTERED ([WorkOrderTypeCode]),
    CONSTRAINT [UK_WorkOrderType_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[wrongitemtable] (
    [icode] int NULL,
    [date] datetime NULL
);
GO

CREATE TABLE [dbo].[XRay] (
    [RowID] int IDENTITY(1,1) NOT NULL,
    [Date] datetime NOT NULL CONSTRAINT [DF_XRay_Date] DEFAULT (getdate()),
    [PatientCode] int NOT NULL,
    [AdmissionCode] int NULL,
    [Xray] char(1) NULL,
    [XrayDate] datetime NULL,
    [FindingswithinNormalLimits] char(1) NULL,
    [FindingswithinNormalLimitsXRay] varchar(255) NULL,
    [Cardiomegaloy] char(1) NULL,
    [CardiomegaloyXRay] varchar(255) NULL,
    [FindingSuggestiveofXRay] char(1) NULL,
    [PulmonaryEdemaXRay] char(1) NULL,
    [PulmonaryEmbolismXRay] char(1) NULL,
    [HeartFailureXRay] char(1) NULL,
    [ChestInfectionXRay] char(1) NULL,
    [PleuralEffusionXRay] char(1) NULL,
    [PulmonaryCocksXRay] char(1) NULL,
    [MassConsolidationXRay] char(1) NULL,
    [BronchiactasisXRay] char(1) NULL,
    [PhenuthoraxXRay] char(1) NULL,
    [HaemothoraxXRay] char(1) NULL,
    [COPDXRay] char(1) NULL,
    [OtherXray] varchar(1000) NULL,
    [UserCode] smallint NOT NULL CONSTRAINT [DF_XRay_UserCode] DEFAULT (1),
    [AttendingDoctCode] smallint NOT NULL CONSTRAINT [DF_XRay_AttendingDoctCode] DEFAULT (1),
    [XrayAdvised] char(1) NOT NULL CONSTRAINT [DF_XRay_XrayAdvised] DEFAULT ('N'),
    [AdviseDetail] varchar(100) NULL
);
GO

CREATE TABLE [dbo].[Zone] (
    [ZoneCode] smallint NOT NULL,
    [ManfCode] smallint NOT NULL,
    [Name] varchar(60) NOT NULL,
    [Manager] varchar(60) NULL,
    [Remarks] varchar(60) NULL,
    [ICatCode] smallint NULL,
    [UseForSMS] char(1) NOT NULL CONSTRAINT [DF_Zone_UseForSMS] DEFAULT ('N'),
    CONSTRAINT [PK_Zone_1__10] PRIMARY KEY CLUSTERED ([ZoneCode]),
    CONSTRAINT [ZNameUC] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[ZoneAreas] (
    [ZoneCode] smallint NOT NULL,
    [AreaCode] smallint NOT NULL,
    [ROWID] int IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_ZoneAreas_1__10] PRIMARY KEY CLUSTERED ([ZoneCode], [AreaCode])
);
GO

CREATE TABLE [dbo].[ZoneContactGroup] (
    [ZoneCode] smallint NOT NULL,
    [ContactGroupCode] smallint NOT NULL,
    CONSTRAINT [PK_ZoneContactGroup] PRIMARY KEY CLUSTERED ([ZoneCode], [ContactGroupCode])
);
GO
