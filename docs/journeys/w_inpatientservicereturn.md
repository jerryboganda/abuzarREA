# w_inpatientservicereturn

- title: In-Patient Service Return
- library: ipservices (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3379 x 3840 PBU
- reached from: (opened from code / other windows)
- script size: 1729 lines; 17 events, 63 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_print` (datawindow) dataobject `d_retailsaleretinvreport_full`

## Data

- DataWindows: `d_groups_discount`, `d_mastercashierwindow_detail`, `d_retailsaleretinvreport_full`
- tables touched by embedded SQL: accounts, customer, item, itemcategory, itemsgroupcategory, mastercashwin, patient, patientadmission, saleledger, serviceheader, servicerheader, srledger, usergroups
- stored procedures: getitemavgprice, getitemstockbatch, updateactivitymonitor, updateitemstockbatch
- global functions: f_getgroupcode, f_is_group_module_cashaccount_allowed, f_numberpreferences, f_set_headerlogo_service, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_mastercashierwindow, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_inpatientservicereturn.ue_accepttext`, `w_inpatientservicereturn.ue_save_withnocommit`, `w_inpatientservicereturn.create`, `w_inpatientservicereturn.destroy`, `w_inpatientservicereturn.ue_save`, `w_inpatientservicereturn.ue_newform`, `w_inpatientservicereturn.ue_detail`, `w_inpatientservicereturn.ue_newitem`, `w_inpatientservicereturn.close`, `w_inpatientservicereturn.ue_print`, `w_inpatientservicereturn.ue_refreshddw`, `w_inpatientservicereturn.ue_list`, `w_inpatientservicereturn.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `w_inpatientservicereturn.wf_visible`, `w_inpatientservicereturn.wf_visibleinvisiblediscount`, `w_inpatientservicereturn.wf_updatesalereturnitemsstock`, `w_inpatientservicereturn.wf_validatefullcode`, `w_inpatientservicereturn.wf_setsalereturntype`, `w_inpatientservicereturn.wf_showlist`, `w_inpatientservicereturn.wf_validateitem`, `w_inpatientservicereturn.wf_customername`, `w_inpatientservicereturn.wf_customerinfo`, `w_inpatientservicereturn.wf_deleteemptydetailrow`, `w_inpatientservicereturn.wf_duplicaterow`, `w_inpatientservicereturn.wf_editsaleinvoice`, `w_inpatientservicereturn.wf_find_header_no`, `w_inpatientservicereturn.wf_findfullcode`, `w_inpatientservicereturn.wf_findretailsaleinvoice`, `w_inpatientservicereturn.wf_findunpostedsalereturns`, `w_inpatientservicereturn.wf_findwholesaleinvoice`, `w_inpatientservicereturn.wf_genfullcode`, `w_inpatientservicereturn.wf_grandtotal`, `w_inpatientservicereturn.wf_inititeminfo`, `w_inpatientservicereturn.wf_initmodify`, `w_inpatientservicereturn.wf_locksaleinvoice`, `w_inpatientservicereturn.wf_locksaleretinvoice`, `w_inpatientservicereturn.wf_locksrinvoices`, `w_inpatientservicereturn.wf_protectdw`, `w_inpatientservicereturn.wf_retrievelist`, `w_inpatientservicereturn.wf_retrievelistall`, `w_inpatientservicereturn.wf_returnsaleretinvoice`, `w_inpatientservicereturn.wf_selectprintreport`, `w_inpatientservicereturn.wf_setfooterinfo`, `w_inpatientservicereturn.wf_assigndatawindowobjects`, `w_inpatientservicereturn.wf_setsaleinvinfo`, `w_inpatientservicereturn.wf_findregno`, `w_inpatientservicereturn.wf_validatesaleinvcode`, `w_inpatientservicereturn.wf_findpatientcode`, `w_inpatientservicereturn.wf_findpatientadmission`, `w_inpatientservicereturn.wf_getadmissioncode`, `w_inpatientservicereturn.wf_lockpatientadmission`, `w_inpatientservicereturn.wf_fetchreturnableservices`, `w_inpatientservicereturn.wf_admitted`, `w_inpatientservicereturn.wf_post`, `w_inpatientservicereturn.wf_setadmissiondetails`, `w_inpatientservicereturn.wf_assign_master_cash_win_object`, `w_inpatientservicereturn.wf_set_cashaccount`, `w_inpatientservicereturn.wf_show_mastercashierwindow`, `w_inpatientservicereturn.wf_update_mastercashierwindow`, `w_inpatientservicereturn.wf_validate_price_discount_matters`, `w_inpatientservicereturn.wf_itemprevretqty`, `w_inpatientservicereturn.wf_oninvoiceitemprevretqty`, `w_inpatientservicereturn.wf_validateqty`, `tab_retrieve.selectionchanged`, `dw_footer.itemerror`, `dw_footer.itemfocuschanged`, `dw_detail.itemerror`, `dw_detail.retrieveend`, `dw_detail.itemfocuschanged`, `dw_detail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.rowfocuschanging`

Source: `recovered/scripts/ipservices/w_inpatientservicereturn.pbs`
