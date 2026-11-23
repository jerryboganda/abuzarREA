-- Reconstructed from the SQL Server 2000-format V2 database file (catalog pages), schema only

CREATE INDEX [IDX_subcode] ON [dbo].[Accounts] ([SubCode]);
GO
CREATE INDEX [AdjCode_Date_IDX] ON [dbo].[AdjHeader] ([Date], [AdjCode]);
GO
CREATE INDEX [AdjCode_PostedDate_IDX] ON [dbo].[AdjHeader] ([PostedDate], [AdjCode]);
GO
CREATE INDEX [IDX_AlternateItemAlias_ICode] ON [dbo].[AlternateItemAlias] ([ICode]);
GO
CREATE INDEX [IDX_AlternateItemAlias_CustomICode] ON [dbo].[AlternateItemAlias] ([CustomICode]);
GO
CREATE INDEX [IDX_CRS_GLDetail_AccCode] ON [dbo].[CRS_GLDetail] ([AccCode]);
GO
CREATE INDEX [IDX_CRS_GLHeader_AccCode] ON [dbo].[CRS_Glheader] ([AccCode]);
GO
CREATE INDEX [IDX_CRS_SaleDetail_ICode] ON [dbo].[CRS_SaleDetail] ([ICode]);
GO
CREATE INDEX [IDX_CRS_SaleLedger_ClientInstanceID_SaleInvCode_CustCode] ON [dbo].[CRS_SaleLedger] ([ClientInstanceID], [SaleInvCode], [CustCode]);
GO
CREATE INDEX [IDX_CRS_SaleLedger_CustCode] ON [dbo].[CRS_SaleLedger] ([CustCode]);
GO
CREATE INDEX [IDX_CRS_SRDetail_ICode] ON [dbo].[CRS_SRDetail] ([ICode]);
GO
CREATE INDEX [IDX_CRS_SRLedger_ClientInstanceID_SRInvCode_CustCode] ON [dbo].[CRS_SRLedger] ([ClientInstanceID], [SRInvCode], [CustCode]);
GO
CREATE INDEX [IDX_CRS_SRLedger_CustCode] ON [dbo].[CRS_SRLedger] ([CustCode]);
GO
CREATE INDEX [IDX_CRS_VirtualGL_ClientInstanceID_DocumentType_DocumentCode] ON [dbo].[CRS_VirtualGl] ([ClientInstanceID], [DocumentType], [DocumentCode]);
GO
CREATE INDEX [IDX_CRS_VirtualGL_DocumentType_DocumentCode] ON [dbo].[CRS_VirtualGl] ([DocumentType], [DocumentCode]);
GO
CREATE INDEX [IDX_CRS_VirtualGL_AccCode] ON [dbo].[CRS_VirtualGl] ([AccCode]);
GO
CREATE INDEX [IDX_CRS_VirtualGL_Date] ON [dbo].[CRS_VirtualGl] ([Date]);
GO
CREATE INDEX [IDX_DB_ExpiryIntimation_TargetSiteCode] ON [dbo].[DB_ExpiryIntimation] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_IssueHeader_TargetSiteCode] ON [dbo].[DB_IssueHeader] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_PRledger_TargetSiteCode] ON [dbo].[DB_PRLedger] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_Purledger_TargetSiteCode] ON [dbo].[DB_Purledger] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_PurOrderHeader_TargetSiteCode] ON [dbo].[DB_PurOrderHeader] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_SaleLedger_TargetSiteCode] ON [dbo].[DB_SaleLedger] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DB_SRledger_TargetSiteCode] ON [dbo].[DB_SRLedger] ([TargetSiteCode]);
GO
CREATE INDEX [IDX_DueSatisfyDetail_DueSatisfyCode] ON [dbo].[DueSatisfyDetail] ([DueSatisfyCode]);
GO
CREATE INDEX [GLVochCode_Date_IDX] ON [dbo].[Glheader] ([Date], [GLVochCode]);
GO
CREATE INDEX [I_GDITS] ON [dbo].[GodownDetail] ([GCode], [ICode]);
GO
CREATE INDEX [IDX_IssueDetail_IssueInvCode] ON [dbo].[IssueDetail] ([IssueInvCode]);
GO
CREATE INDEX [IDX_IssueDetail_IssRowId] ON [dbo].[IssueDetail] ([IssRowId]);
GO
CREATE INDEX [IDX_IssueDetail_Icode] ON [dbo].[IssueDetail] ([Icode]);
GO
CREATE INDEX [IDX_Item_LastUpdate1] ON [dbo].[Item] ([LastUpdate]);
GO
CREATE INDEX [IDX_ItemLog_LogDate] ON [dbo].[ItemLog] ([LogDate]);
GO
CREATE INDEX [IDX_ItemSuppliers_SuppCode_ICode] ON [dbo].[ItemSuppliers] ([SuppCode], [ICode]);
GO
CREATE UNIQUE INDEX [pbcatcol_idx] ON [dbo].[pbcatcol] ([pbc_tnam], [pbc_ownr], [pbc_cnam]);
GO
CREATE UNIQUE INDEX [pbcatedt_idx] ON [dbo].[pbcatedt] ([pbe_name], [pbe_seqn]);
GO
CREATE UNIQUE INDEX [pbcatfmt_idx] ON [dbo].[pbcatfmt] ([pbf_name]);
GO
CREATE UNIQUE INDEX [pbcattbl_idx] ON [dbo].[pbcattbl] ([pbt_tnam], [pbt_ownr]);
GO
CREATE UNIQUE INDEX [pbcatvld_idx] ON [dbo].[pbcatvld] ([pbv_name]);
GO
CREATE INDEX [idx_PRInvCode] ON [dbo].[PRdetail] ([PRInvCode]);
GO
CREATE INDEX [Date_PRInvCode_IDX] ON [dbo].[PRLedger] ([Date], [PRInvCode]);
GO
CREATE INDEX [IDX_PurDetail_ICode_Items] ON [dbo].[Purdetail] ([ICode]);
GO
CREATE INDEX [IDX_PurDetail_PurUTN_ItemUTNS] ON [dbo].[Purdetail] ([PurUtn]);
GO
CREATE INDEX [IDX_PurDetail_PurInvCode_ICode_PurItems] ON [dbo].[Purdetail] ([PurInvCode], [ICode]);
GO
CREATE INDEX [IDX_PurDetail_PurRowID] ON [dbo].[Purdetail] ([PurRowId]);
GO
CREATE INDEX [idx_purInvCode] ON [dbo].[Purdetail] ([PurInvCode]);
GO
CREATE INDEX [IDX_PurLedger_POCode] ON [dbo].[Purledger] ([POCode]);
GO
CREATE INDEX [date_purinvcode_IDX] ON [dbo].[Purledger] ([Date], [PurInvCode]);
GO
CREATE INDEX [IDX_PurOrderDetail_PORowID_POItems] ON [dbo].[PurOrderDetail] ([PORowId]);
GO
CREATE INDEX [IDX_PurOrderDetail_Item_ICode] ON [dbo].[PurOrderDetail] ([ICode], [PORowId]);
GO
CREATE INDEX [IDX_PurOrderHeader_SaleOrderCode] ON [dbo].[PurOrderHeader] ([SaleOrderCode]);
GO
CREATE INDEX [IDX_QuotationDetail_ROWID_QRows] ON [dbo].[QuotationDetail] ([RowID]);
GO
CREATE INDEX [IDX_QuotationDetail_ICode_QItems] ON [dbo].[QuotationDetail] ([ICode]);
GO
CREATE INDEX [IDX_QuotationDetail_QuotationCode_ICode_QItems] ON [dbo].[QuotationDetail] ([QuotationCode], [ICode]);
GO
CREATE INDEX [IDX_SaleDetail_SaleInvCode] ON [dbo].[Saledetail] ([SaleInvcode]);
GO
CREATE INDEX [IDX_SaleDetail_RowId] ON [dbo].[Saledetail] ([RowID]);
GO
CREATE INDEX [IDX_SaleDetail_Icode] ON [dbo].[Saledetail] ([ICode]);
GO
CREATE INDEX [IDX_SaleDetail_SaleOrderRowID] ON [dbo].[Saledetail] ([SaleOrderRowID]);
GO
CREATE INDEX [IDX_SaleDetail_QuotationCode] ON [dbo].[Saledetail] ([QuotationCode], [ICode], [RowID]);
GO
CREATE INDEX [IDX_SaleDetailDump_SaleInvCode] ON [dbo].[SaledetailDump] ([SaleInvcode]);
GO
CREATE INDEX [IDX_SaleDetailDump_RowId] ON [dbo].[SaledetailDump] ([RowID]);
GO
CREATE INDEX [IDX_SaleDetailDump_ICode] ON [dbo].[SaledetailDump] ([ICode]);
GO
CREATE INDEX [IDX_SaleDetailModified_SaleInvCode] ON [dbo].[SaleDetailModified] ([SaleInvcode]);
GO
CREATE INDEX [Date_SaleInvCode_IDX] ON [dbo].[SaleLedger] ([date], [SaleInvCode]);
GO
CREATE INDEX [IDX_SaleLedger_SaleOrderCode] ON [dbo].[SaleLedger] ([SaleOrderCode]);
GO
CREATE INDEX [IDX_SaleLedger_CustCode] ON [dbo].[SaleLedger] ([CustCode]);
GO
CREATE INDEX [SaleLedgerModified_Date_SaleInvCode_IDX] ON [dbo].[SaleLedgerModified] ([date], [SaleInvCode]);
GO
CREATE INDEX [IDX_SaleOrderDetail_ICode_Items] ON [dbo].[SaleOrderDetail] ([ICode]);
GO
CREATE INDEX [IDX_SaleOrderDetail_RowID_OrderItems] ON [dbo].[SaleOrderDetail] ([RowID]);
GO
CREATE INDEX [IDX_SaleOrderDetail_ICode_RowID] ON [dbo].[SaleOrderDetail] ([ICode], [RowID]);
GO
CREATE INDEX [IDX_SRBufferInvCode_Date] ON [dbo].[SRBufferLedger] ([Date]);
GO
CREATE INDEX [IDX_SrDetail_SrInvCode] ON [dbo].[SRdetail] ([SRInvcode]);
GO
CREATE INDEX [SRInvCode_Date_IDX] ON [dbo].[SRLedger] ([Date], [SRInvCode]);
GO
CREATE INDEX [IDX_StockLedger_UTN] ON [dbo].[StockLedger] ([UTN]);
GO
CREATE INDEX [IDX_StockLedger_ICode_UTN] ON [dbo].[StockLedger] ([ICode], [UTN]);
GO
CREATE INDEX [IDX_StockLedger_DocumentType_DocumentCode] ON [dbo].[StockLedger] ([DocumentType], [DocumentCode]);
GO
CREATE INDEX [IDX_StockReport_Date] ON [dbo].[StockReport] ([Date]);
GO
CREATE INDEX [IDX_VirtualGL_DocumentType_DocumentCode] ON [dbo].[VirtualGl] ([DocumentType], [DocumentCode]);
GO
CREATE INDEX [IDX_VirtualGL_AccCode] ON [dbo].[VirtualGl] ([AccCode]);
GO
CREATE INDEX [IDX_VirtualGL_PatientCode] ON [dbo].[VirtualGl] ([PatientCode]);
GO
CREATE INDEX [IDX_VirtualGL_StudentCode] ON [dbo].[VirtualGl] ([StudentCode]);
GO
CREATE INDEX [IDX_VirtualGL_GuestCode] ON [dbo].[VirtualGl] ([GuestCode]);
GO
