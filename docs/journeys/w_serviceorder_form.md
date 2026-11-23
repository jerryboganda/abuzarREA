# w_serviceorder_form

- title: Service Order Details
- library: servicemodules (Services)
- ancestor: `window`
- size: 3068 x 2259 PBU
- reached from: (opened from code / other windows)
- script size: 2576 lines; 42 events, 69 functions

## Controls (8)

- `dw_netamt` (datawindow) dataobject `d_so_estimatedamt`
- `cb_printorder` (commandbutton) text "&Print Order"
- `cb_cancel` (commandbutton) text "Cancel"
- `cb_ok` (commandbutton) text "Save"
- `tab_main` (tab)
- `dw_image` (u_dwstandard) dataobject `d_patientimage`
- `dw_print` (datawindow) dataobject `d_serviceorder_issuereq_printout`
- `dw_print2` (u_dwstandard) dataobject `d_serviceoinvreport`

## Data

- DataWindows: `d_issuereqheader_serviceorder`, `d_mr_recordpointer`, `d_patient_comprehensive_list`, `d_patientimage`, `d_serviceoinvreport`, `d_serviceorder_issuereq_printout`, `d_so_estimatedamt`
- tables touched by embedded SQL: _tabmaxkey, accounts, customer, item, itemcategory, itemsgroupcategory, patient, patientimage, serverdate, service, sochecklistitem, usergroups
- stored procedures: getdatetime, getservice_aliasname
- global functions: f_drilldown_itemsearch, f_numberpreferences, f_prefered_itemsearch, f_retrieve_servicelist, f_rightexists, f_setserviceqtystyle, f_show_patient_gallary, f_stringpreferences, f_validatedw
- windows opened: w_arg_mr_record_pointer, w_customer_register, w_itemsalehistory, w_patientgallary, w_patientimage, w_patientregistration, w_popup_comprehensicesearch_selection, w_popup_partialsearch_selection, w_preview_invoices, w_salesmanpassword, w_servicesalehistory

## Events and functions

`w_serviceorder_form.ue_close`, `w_serviceorder_form.ue_postopen`, `w_serviceorder_form.create`, `w_serviceorder_form.destroy`, `w_serviceorder_form.open`, `w_serviceorder_form.key`, `cb_printorder.clicked`, `cb_cancel.clicked`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `tab_main.create`, `tab_main.destroy`, `tab_main.key`, `tabpage_header.create`, `tabpage_header.destroy`, `dw_header.ue_dwnkey`, `dw_header.ue_enterkey`, `dw_header.itemchanged`, `tabpage_checklist.create`, `tabpage_checklist.destroy`, `tabpage_detail.create`, `tabpage_detail.destroy`, `dw_footer.ue_dwnkey`, `dw_footer.ue_enterkey`, `dw_detail.ue_dwnkey`, `dw_detail.ue_enterkey`, `dw_detail.itemchanged`, `dw_selectionlist.ue_setfocus`, `dw_selectionlist.clicked`, `tabpage_itemreq.create`, `tabpage_itemreq.destroy`, `dw_selection_req.ue_setfocus`, `dw_selection_req.clicked`, `dw_itemreq.itemchanged`, `dw_itemreq.ue_dwnkey`, `dw_itemreq.ue_enterkey`, `tabpage_issue.create`, `tabpage_issue.destroy`, `tabpage_service.create`, `tabpage_service.destroy`, `tabpage_sale.create`, `tabpage_sale.destroy`, `w_serviceorder_form.wf_set_interface_adjustments`, `w_serviceorder_form.wf_set_tab_visibility`, `w_serviceorder_form.wf_connect`, `w_serviceorder_form.wf_tabnewid`, `w_serviceorder_form.wf_get_patient_info`, `w_serviceorder_form.wf_retrieve_tabs`, `w_serviceorder_form.wf_insert_row`, `w_serviceorder_form.wf_delete_row`, `w_serviceorder_form.wf_goto_record`, `w_serviceorder_form.wf_protectdw`, `w_serviceorder_form.wf_apply_protect_setting`, `w_serviceorder_form.wf_save`, `w_serviceorder_form.wf_print`, `w_serviceorder_form.wf_select_first_tab`, `w_serviceorder_form.wf_get_image`, `w_serviceorder_form.wf_populate_image`, `w_serviceorder_form.wf_update_image`, `w_serviceorder_form.wf_validateitem`, `w_serviceorder_form.wf_setimage`, `w_serviceorder_form.wf_show_patient_gallery`, `w_serviceorder_form.wf_validateserverdatetime`, `w_serviceorder_form.wf_print_dischargeslip`, `w_serviceorder_form.wf_validate_service`, `w_serviceorder_form.wf_findcustcode`, `w_serviceorder_form.wf_customerinfo`, `w_serviceorder_form.wf_inititeminfo`, `w_serviceorder_form.wf_find_service_fullcode`, `w_serviceorder_form.wf_grandtotal`, `w_serviceorder_form.wf_getserverdatetime`, `w_serviceorder_form.wf_printorder`, `w_serviceorder_form.wf_new_customerregisteration`, `w_serviceorder_form.wf_customer_retrieve`, `w_serviceorder_form.wf_findpatientcode`, `w_serviceorder_form.wf_new_patientregistration`, `w_serviceorder_form.wf_patient_retrieve`, `w_serviceorder_form.wf_comprehensive_search`, `w_serviceorder_form.wf_setpatientinfo`, `w_serviceorder_form.wf_show_patientgallery`, `w_serviceorder_form.wf_servicelist_initialization`, `w_serviceorder_form.wf_itemlist_initialization`, `w_serviceorder_form.wf_validateitem_req`, `w_serviceorder_form.wf_inititeminfo_req`, `w_serviceorder_form.wf_findfullcode`, `w_serviceorder_form.wf_validate_req`, `w_serviceorder_form.wf_show_salehistory`, `w_serviceorder_form.wf_show_servicesalehistory`, `w_serviceorder_form.wf_presave`, `tab_main.selectionchanged`, `dw_header.getfocus`, `dw_header.itemfocuschanged`, `dw_checklist.getfocus`, `dw_footer.getfocus`, `dw_detail.getfocus`, `dw_detail.itemfocuschanged`, `dw_detail.editchanged`, `dw_detail.itemerror`, `dw_detail.losefocus`, `dw_detail.rowfocuschanging`, `dw_selectionlist.doubleclicked`, `dw_selection_req.doubleclicked`, `dw_itemreq.editchanged`, `dw_itemreq.getfocus`, `dw_itemreq.itemerror`, `dw_itemreq.itemfocuschanged`, `dw_itemreq.losefocus`, `dw_itemreq.rowfocuschanged`, `dw_issue.getfocus`, `dw_service.getfocus`, `dw_sale.getfocus`

Source: `recovered/scripts/servicemodules/w_serviceorder_form.pbs`
