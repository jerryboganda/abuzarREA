# w_inpatientsalereturn

- title: In-Patient Sale Return
- library: salereturncomponents (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3081 x 2496 PBU
- reached from: (opened from code / other windows)
- script size: 2238 lines; 16 events, 67 functions

## Controls (5)

- `tab_retrieve` (tab_retrieve)
- `dw_print` (datawindow) dataobject `d_retailsaleretinvreport_full`
- `ic_comport` (olecustomcontrol)
- `ic_cashdrawer` (olecustomcontrol)
- `ic_cashdrawerprinter` (olecustomcontrol)

## Data

- DataWindows: `d_activemarkeditems`, `d_groupallowedmoduleheader`, `d_mastercashierwindow_detail`, `d_retailsaleretinvreport_full`, `d_srpostinvdetail`, `d_srpostinvheaders`, `ddd_inpatientretableitems`
- tables touched by embedded SQL: accounts, customer, godown, groupallowedgodown, item, mastercashwin, patient, patientadmission, saledetail, saleledger, srdetail, srledger
- stored procedures: getitemavgprice, getitemstockbatch, getitemstocktotal, getmaxutn, isactiveitem, postsrledger, setitemactivestatus, updateactivitymonitor, updatecashieractivity, updateitemstockbatch
- global functions: f_generateheaderinvcode, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_is_group_module_cashaccount_allowed, f_newtableid, f_numberpreferences, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_itemsalehistory, w_mastercashierwindow, w_preview_invoices, w_previnvinfo, w_salereturn_activeitemlist, w_salesmanpassword

## Events and functions

`w_inpatientsalereturn.ue_accepttext`, `w_inpatientsalereturn.ue_save_withnocommit`, `w_inpatientsalereturn.create`, `w_inpatientsalereturn.destroy`, `w_inpatientsalereturn.ue_save`, `w_inpatientsalereturn.ue_newform`, `w_inpatientsalereturn.ue_detail`, `w_inpatientsalereturn.ue_newitem`, `w_inpatientsalereturn.close`, `w_inpatientsalereturn.ue_print`, `w_inpatientsalereturn.ue_refreshddw`, `w_inpatientsalereturn.ue_list`, `w_inpatientsalereturn.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `ic_comport.ue_show`, `w_inpatientsalereturn.wf_visibleinvisiblediscount`, `w_inpatientsalereturn.wf_genfullcode`, `w_inpatientsalereturn.wf_locksaleretinvoice`, `w_inpatientsalereturn.wf_locksrinvoices`, `w_inpatientsalereturn.wf_post`, `w_inpatientsalereturn.wf_protectdw`, `w_inpatientsalereturn.wf_setfooterinfo`, `w_inpatientsalereturn.wf_setsalereturntype`, `w_inpatientsalereturn.wf_visible`, `w_inpatientsalereturn.wf_findunpostedsalereturns`, `w_inpatientsalereturn.wf_setsaleinvinfo`, `w_inpatientsalereturn.wf_retrievelist`, `w_inpatientsalereturn.wf_retrievelistall`, `w_inpatientsalereturn.wf_customerinfo`, `w_inpatientsalereturn.wf_customername`, `w_inpatientsalereturn.wf_duplicaterow`, `w_inpatientsalereturn.wf_editsaleinvoice`, `w_inpatientsalereturn.wf_findcustcode`, `w_inpatientsalereturn.wf_findregno`, `w_inpatientsalereturn.wf_updatesalereturnitemsstock`, `w_inpatientsalereturn.wf_validatefullcode`, `w_inpatientsalereturn.wf_returnsaleretinvoice`, `w_inpatientsalereturn.wf_allowreturnmodification`, `w_inpatientsalereturn.wf_assigndatawindowobjects`, `w_inpatientsalereturn.wf_find_header_no`, `w_inpatientsalereturn.wf_initmodify`, `w_inpatientsalereturn.wf_lockpatientadmission`, `w_inpatientsalereturn.wf_findpatientcode`, `w_inpatientsalereturn.wf_fetchreturnableitems`, `w_inpatientsalereturn.wf_selectprintreport`, `w_inpatientsalereturn.wf_itemsalehistory`, `w_inpatientsalereturn.wf_prevsaleinvinfo`, `w_inpatientsalereturn.wf_allowsalereturn`, `w_inpatientsalereturn.wf_findretailsaleinvoice`, `w_inpatientsalereturn.wf_findwholesaleinvoice`, `w_inpatientsalereturn.wf_findfullcode`, `w_inpatientsalereturn.wf_grandtotal`, `w_inpatientsalereturn.wf_setadmissiondetails`, `w_inpatientsalereturn.wf_admitted`, `w_inpatientsalereturn.wf_inititeminfo`, `w_inpatientsalereturn.wf_validateitem`, `w_inpatientsalereturn.wf_checkitemactiveness`, `w_inpatientsalereturn.wf_itemprevretqty`, `w_inpatientsalereturn.wf_validatebonusqty`, `w_inpatientsalereturn.wf_validateqty`, `w_inpatientsalereturn.wf_set_itemtotal_formatmask`, `w_inpatientsalereturn.wf_assign_master_cash_win_object`, `w_inpatientsalereturn.wf_set_cashaccount`, `w_inpatientsalereturn.wf_show_mastercashierwindow`, `w_inpatientsalereturn.wf_update_mastercashierwindow`, `w_inpatientsalereturn.wf_findadmissioncode`, `tab_retrieve.selectionchanged`, `dw_footer.itemerror`, `dw_footer.itemfocuschanged`, `dw_detail.itemerror`, `dw_detail.retrieveend`, `dw_detail.itemfocuschanged`, `dw_detail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.rowfocuschanging`, `dw_itemsdetail.editchanged`, `ic_comport.constructor`, `ic_cashdrawer.constructor`

Source: `recovered/scripts/salereturncomponents/w_inpatientsalereturn.pbs`
