# w_servicereturn

- title: Cash Service Return
- library: servicesalesreturn (Services)
- ancestor: `w_multi_entry`
- size: 3127 x 2749 PBU
- reached from: Sales > Service Return > Cash; Sales > Service Return > Credit
- script size: 2737 lines; 18 events, 79 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_print` (datawindow) dataobject `d_retailsaleretinvreport_full`

## Data

- DataWindows: `d_custallowedservice_detail`, `d_groupallowedmoduleheader`, `d_groups_discount`, `d_mastercashierwindow_detail`, `d_retailsaleretinvreport_full`
- tables touched by embedded SQL: accounts, cashiershift, cashiershiftusers, customer, guest, guestcheckin, item, itemcategory, itemsgroupcategory, mastercashwin, motorvehicle, patient, patientcatallowedmodule, saleledger, service, serviceheader, serviceresultdetail, servicerheader, servicetemplatedetail, srledger, student, usergroups
- stored procedures: checkunpostedserviceinvintransactions, createservicesrallocation, getglobalcode, getserviceinvbalance, getservicesrinvbalance, isallowedcustomergroupcategory, lockserviceinvoice, lockservicesrinvoice, updateactivitymonitor, updateserviceinvbalance, updateservicesrinvbalance, virtualgl
- global functions: f_generateheaderinvcode, f_getgroupcode, f_is_group_module_cashaccount_allowed, f_numberpreferences, f_retrieve_servicelist, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_choose_servicecategory, w_mastercashierwindow, w_popup_itemsearchcriteriaselection, w_preview_invoices, w_salesmanpassword, w_vehiclesearch, w_vehiclesearchresult

## Events and functions

`w_servicereturn.ue_accepttext`, `w_servicereturn.ue_save_withnocommit`, `w_servicereturn.create`, `w_servicereturn.destroy`, `w_servicereturn.ue_save`, `w_servicereturn.ue_newform`, `w_servicereturn.ue_detail`, `w_servicereturn.ue_newitem`, `w_servicereturn.close`, `w_servicereturn.ue_print`, `w_servicereturn.ue_refreshddw`, `w_servicereturn.ue_list`, `w_servicereturn.ue_postopen`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `w_servicereturn.wf_visible`, `w_servicereturn.wf_visibleinvisiblediscount`, `w_servicereturn.wf_updatesalereturnitemsstock`, `w_servicereturn.wf_validatefullcode`, `w_servicereturn.wf_setsalereturntype`, `w_servicereturn.wf_showlist`, `w_servicereturn.wf_validateitem`, `w_servicereturn.wf_customername`, `w_servicereturn.wf_customerinfo`, `w_servicereturn.wf_deleteemptydetailrow`, `w_servicereturn.wf_duplicaterow`, `w_servicereturn.wf_find_header_no`, `w_servicereturn.wf_findfullcode`, `w_servicereturn.wf_findretailsaleinvoice`, `w_servicereturn.wf_findunpostedsalereturns`, `w_servicereturn.wf_findwholesaleinvoice`, `w_servicereturn.wf_genfullcode`, `w_servicereturn.wf_grandtotal`, `w_servicereturn.wf_inititeminfo`, `w_servicereturn.wf_initmodify`, `w_servicereturn.wf_locksaleinvoice`, `w_servicereturn.wf_locksaleretinvoice`, `w_servicereturn.wf_locksrinvoices`, `w_servicereturn.wf_protectdw`, `w_servicereturn.wf_retrievelist`, `w_servicereturn.wf_retrievelistall`, `w_servicereturn.wf_returnsaleretinvoice`, `w_servicereturn.wf_setfooterinfo`, `w_servicereturn.wf_setsaleinvinfo`, `w_servicereturn.wf_validatesaleinvcode`, `w_servicereturn.wf_editsaleinvoice`, `w_servicereturn.wf_selectprintreport`, `w_servicereturn.wf_assigndatawindowobjects`, `w_servicereturn.wf_post`, `w_servicereturn.wf_refreshitemslist_catwise`, `w_servicereturn.wf_refreshitemslist_itemname`, `w_servicereturn.wf_assign_master_cash_win_object`, `w_servicereturn.wf_set_cashaccount`, `w_servicereturn.wf_show_mastercashierwindow`, `w_servicereturn.wf_update_mastercashierwindow`, `w_servicereturn.wf_validate_price_discount_matters`, `w_servicereturn.wf_setguestcheckin`, `w_servicereturn.wf_validateqty`, `w_servicereturn.wf_oninvoiceitemprevretqty`, `w_servicereturn.wf_itemprevretqty`, `w_servicereturn.wf_allocate_servicereturn`, `w_servicereturn.wf_update_virtualgl`, `w_servicereturn.wf_check_return_vs_outstandingamt`, `w_servicereturn.wf_patient_retrieve`, `w_servicereturn.wf_student_retrieve`, `w_servicereturn.wf_guest_retrieve`, `w_servicereturn.wf_findcustcode`, `w_servicereturn.wf_enforce_custallowedservices`, `w_servicereturn.wf_findpatientcode`, `w_servicereturn.wf_setpatientinfo`, `w_servicereturn.wf_findstudentcode`, `w_servicereturn.wf_findguestcode`, `w_servicereturn.wf_setguestinfo`, `w_servicereturn.wf_setstudentinfo`, `w_servicereturn.wf_get_studentinfo`, `w_servicereturn.wf_set_headersetting`, `w_servicereturn.wf_set_motorvehicleinfo`, `w_servicereturn.wf_find_motorvehiclecode`, `w_servicereturn.wf_motorvehicle_retrieve`, `w_servicereturn.wf_motorvehiclesearch`, `w_servicereturn.wf_link_to_cashiershift`, `w_servicereturn.wf_check_cashiershift_on_saving`, `tab_retrieve.selectionchanged`, `dw_footer.itemerror`, `dw_footer.itemfocuschanged`, `dw_detail.itemerror`, `dw_detail.retrieveend`, `dw_detail.itemfocuschanged`, `dw_detail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.editchanged`

Source: `recovered/scripts/servicesalesreturn/w_servicereturn.pbs`
