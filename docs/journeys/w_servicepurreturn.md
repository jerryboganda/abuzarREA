# w_servicepurreturn

- title: Purchase Return of Services
- library: servicepurcomponents (Services)
- ancestor: `w_multi_entry`
- size: 3178 x 2346 PBU
- reached from: (opened from code / other windows)
- script size: 1546 lines; 17 events, 52 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_print` (datawindow) dataobject `d_retailsaleretinvreport_full`

## Data

- DataWindows: `d_groupallowedmoduleheader`, `d_groupsuppcategory_detail`, `d_mastercashierwindow_detail`, `d_retailsaleretinvreport_full`
- tables touched by embedded SQL: groupsuppliercategory, item, itemcategory, itemsgroupcategory, mastercashwin, serviceprheader, servicepurheader, supplier, usergroups
- stored procedures: updateactivitymonitor
- global functions: f_generateheaderinvcode, f_getgroupcode, f_is_group_module_cashaccount_allowed, f_numberpreferences, f_retrieve_servicelist, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_choose_servicecategory, w_mastercashierwindow, w_popup_itemsearchcriteriaselection, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_servicepurreturn.ue_accepttext`, `w_servicepurreturn.ue_save_withnocommit`, `w_servicepurreturn.create`, `w_servicepurreturn.destroy`, `w_servicepurreturn.ue_save`, `w_servicepurreturn.ue_newform`, `w_servicepurreturn.ue_detail`, `w_servicepurreturn.ue_newitem`, `w_servicepurreturn.close`, `w_servicepurreturn.ue_print`, `w_servicepurreturn.ue_refreshddw`, `w_servicepurreturn.ue_list`, `w_servicepurreturn.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `w_servicepurreturn.wf_visible`, `w_servicepurreturn.wf_visibleinvisiblediscount`, `w_servicepurreturn.wf_updatesalereturnitemsstock`, `w_servicepurreturn.wf_validatefullcode`, `w_servicepurreturn.wf_showlist`, `w_servicepurreturn.wf_validateitem`, `w_servicepurreturn.wf_deleteemptydetailrow`, `w_servicepurreturn.wf_duplicaterow`, `w_servicepurreturn.wf_findfullcode`, `w_servicepurreturn.wf_grandtotal`, `w_servicepurreturn.wf_inititeminfo`, `w_servicepurreturn.wf_initmodify`, `w_servicepurreturn.wf_protectdw`, `w_servicepurreturn.wf_retrievelist`, `w_servicepurreturn.wf_retrievelistall`, `w_servicepurreturn.wf_returnsaleretinvoice`, `w_servicepurreturn.wf_editsaleinvoice`, `w_servicepurreturn.wf_selectprintreport`, `w_servicepurreturn.wf_assigndatawindowobjects`, `w_servicepurreturn.wf_post`, `w_servicepurreturn.wf_refreshitemslist_catwise`, `w_servicepurreturn.wf_refreshitemslist_itemname`, `w_servicepurreturn.wf_assign_master_cash_win_object`, `w_servicepurreturn.wf_set_cashaccount`, `w_servicepurreturn.wf_show_mastercashierwindow`, `w_servicepurreturn.wf_update_mastercashierwindow`, `w_servicepurreturn.wf_validateqty`, `w_servicepurreturn.wf_oninvoiceitemprevretqty`, `w_servicepurreturn.wf_supplierinfo`, `w_servicepurreturn.wf_find_header_no`, `w_servicepurreturn.wf_find_service_pur_invoice`, `w_servicepurreturn.wf_itemprevretqty`, `w_servicepurreturn.wf_lock_service_pr_invoices`, `w_servicepurreturn.wf_lock_servicepur_invoice`, `w_servicepurreturn.wf_setfooterinfo`, `w_servicepurreturn.wf_set_servicepur_info`, `w_servicepurreturn.wf_validate_service_purinvcode`, `w_servicepurreturn.wf_apply_groupsuppliercategory`, `w_servicepurreturn.wf_check_groupsuppliercategory`, `w_servicepurreturn.wf_findunpostedreturns`, `w_servicepurreturn.wf_set_headersetting`, `tab_retrieve.selectionchanged`, `dw_footer.itemerror`, `dw_footer.itemfocuschanged`, `dw_detail.itemerror`, `dw_detail.itemfocuschanged`, `dw_detail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.editchanged`

Source: `recovered/scripts/servicepurcomponents/w_servicepurreturn.pbs`
