# w_purregister

- title: Advanced Purchase (in Packs)
- library: advancedpurchase (Purchase & stock)
- ancestor: `w_multi_entry`
- size: 3269 x 6868 PBU
- reached from: (opened from code / other windows)
- script size: 1773 lines; 20 events, 53 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_purinvrep` (u_dwstandard) dataobject `d_purregister_printout`
- `dw_changeprice_foritemlog` (datawindow) dataobject `d_purdetail_changeprice_foritemlog`

## Data

- DataWindows: `d_normalpurchasedetail`, `d_populateditems_active`, `d_populateditems_active_and`, `d_purdetail_changeprice_foritemlog`, `d_purregister_list_for_posting`, `d_purregister_printout`
- tables touched by embedded SQL: accounts, godowndetail, item, itemcategory, itemsgroupcategory, measuringunit, purdetail, purledger, purregister, supplier, usergroups
- stored procedures: createpurchase_from_purregister, getitemavgprice, getitemstockall, getitemstockbatch, getitemstockinallowedgodown, getmaxutn, purchasebased_satisfydue, updateactivitymonitor, updateitemavgprice, updateitemstockbatch, updateitemtotalpiecesinhand, updatetransitstock
- global functions: f_generateitemlog, f_getgroupcode, f_newtableid, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_item_populate3, w_arg_sinvcode_linvcode, w_itempurchasehistory, w_preview_invoices, w_salesmanpassword, w_setquantity

## Events and functions

`w_purregister.create`, `w_purregister.destroy`, `w_purregister.ue_save`, `w_purregister.ue_newform`, `w_purregister.ue_detail`, `w_purregister.ue_newitem`, `w_purregister.ue_deleteitem`, `w_purregister.close`, `w_purregister.ue_new`, `w_purregister.ue_list`, `w_purregister.ue_refreshddw`, `w_purregister.ue_print`, `w_purregister.ue_postopen`, `w_purregister.open`, `w_purregister.closequery`, `dw_footer.itemchanged`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_focusqty`, `w_purregister.wf_setsuppinfo`, `w_purregister.wf_setsuppname`, `w_purregister.wf_validateitem`, `w_purregister.wf_protectdw`, `w_purregister.wf_releaselock`, `w_purregister.wf_assigndatawindowobjects`, `w_purregister.wf_fetchserverdate`, `w_purregister.wf_findfullcode`, `w_purregister.wf_findsuppcode`, `w_purregister.wf_genfullcode`, `w_purregister.wf_getitemsaleprice`, `w_purregister.wf_initmodify`, `w_purregister.wf_isinvoiceinuse`, `w_purregister.wf_iteminfo`, `w_purregister.wf_itempurchasehistory`, `w_purregister.wf_lockpurinvoices`, `w_purregister.wf_populatefiltereditems`, `w_purregister.wf_retrievelist`, `w_purregister.wf_retrievelistall`, `w_purregister.wf_setquantity`, `w_purregister.wf_updateitemavgprice`, `w_purregister.wf_validatefullcode`, `w_purregister.wf_selectprintreport`, `w_purregister.wf_saveandpost`, `w_purregister.wf_inititeminfo`, `w_purregister.wf_grandtotal`, `w_purregister.wf_allowpurchasemodification`, `w_purregister.wf_apply_advancepurchase_pref`, `w_purregister.wf_itemstockinfo`, `w_purregister.wf_setiteminfo`, `w_purregister.wf_updateitemstock`, `w_purregister.wf_post_purchase`, `w_purregister.wf_lockpurregister`, `w_purregister.wf_lockpurregistersingle`, `w_purregister.wf_locknormalpurchases`, `w_purregister.wf_post_register`, `w_purregister.wf_post`, `w_purregister.wf_changeitemcategory`, `w_purregister.wf_filteritemlist`, `w_purregister.wf_deleteallemptydetailrow`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_detail.itemfocuschanged`, `dw_detail.editchanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanging`

Source: `recovered/scripts/advancedpurchase/w_purregister.pbs`
