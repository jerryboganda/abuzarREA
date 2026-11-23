# w_workorder

- title: Work Order
- library: saleorder (Sales, POS & reports)
- ancestor: `window`
- size: 3054 x 2080 PBU
- reached from: (opened from code / other windows)
- script size: 1469 lines; 34 events, 45 functions

## Controls (7)

- `cb_printorder` (commandbutton) text "&Print Order"
- `cb_cancel` (commandbutton) text "Cancel"
- `cb_ok` (commandbutton) text "Save"
- `tab_main` (tab)
- `dw_image` (u_dwstandard) dataobject `d_patientimage`
- `dw_print` (datawindow) dataobject `d_workorder_printout`
- `dw_dischargeslip` (u_dwstandard) dataobject `d_pic2014_dischargeslip`

## Data

- DataWindows: `d_mr_recordpointer`, `d_patientimage`, `d_pic2014_dischargeslip`, `d_workorder_printout`
- tables touched by embedded SQL: _tabmaxkey, accounts, customer, patient, patientimage, resource, serverdate, workorder
- stored procedures: getdatetime, getservice_aliasname
- global functions: f_numberpreferences, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_mr_record_pointer, w_customer_register, w_patientgallary, w_patientimage, w_preview_invoices

## Events and functions

`w_workorder.ue_close`, `w_workorder.ue_postopen`, `w_workorder.create`, `w_workorder.destroy`, `w_workorder.open`, `cb_printorder.clicked`, `cb_cancel.clicked`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `tab_main.create`, `tab_main.destroy`, `tabpage_header.create`, `tabpage_header.destroy`, `dw_header.ue_dwnkey`, `dw_header.ue_enterkey`, `dw_header.itemchanged`, `tabpage_assessment.create`, `tabpage_assessment.destroy`, `dw_assessment.ue_enterkey`, `tabpage_resources.create`, `tabpage_resources.destroy`, `dw_footer.ue_dwnkey`, `dw_footer.ue_enterkey`, `dw_detail.ue_dwnkey`, `dw_detail.ue_enterkey`, `dw_detail.itemchanged`, `dw_selectionlist.ue_setfocus`, `dw_selectionlist.clicked`, `tabpage_issue.create`, `tabpage_issue.destroy`, `tabpage_receipt.create`, `tabpage_receipt.destroy`, `tabpage_transfers.create`, `tabpage_transfers.destroy`, `w_workorder.wf_set_interface_adjustments`, `w_workorder.wf_set_tab_visibility`, `w_workorder.wf_connect`, `w_workorder.wf_tabnewid`, `w_workorder.wf_get_patient_info`, `w_workorder.wf_retrieve_tabs`, `w_workorder.wf_insert_row`, `w_workorder.wf_delete_row`, `w_workorder.wf_goto_record`, `w_workorder.wf_protectdw`, `w_workorder.wf_apply_protect_setting`, `w_workorder.wf_save`, `w_workorder.wf_print`, `w_workorder.wf_select_first_tab`, `w_workorder.wf_get_image`, `w_workorder.wf_populate_image`, `w_workorder.wf_update_image`, `w_workorder.wf_itemlist_initialization`, `w_workorder.wf_validateitem`, `w_workorder.wf_setimage`, `w_workorder.wf_show_patient_gallery`, `w_workorder.wf_validateserverdatetime`, `w_workorder.wf_print_dischargeslip`, `w_workorder.wf_findcustcode`, `w_workorder.wf_customerinfo`, `w_workorder.wf_inititeminfo`, `w_workorder.wf_find_service_fullcode`, `w_workorder.wf_grandtotal`, `w_workorder.wf_getserverdatetime`, `w_workorder.wf_printorder`, `w_workorder.wf_new_customerregisteration`, `w_workorder.wf_customer_retrieve`, `w_workorder.wf_validate_resource`, `w_workorder.wf_set_workorderinfo`, `tab_main.selectionchanged`, `dw_header.getfocus`, `dw_header.itemfocuschanged`, `dw_footer.getfocus`, `dw_detail.getfocus`, `dw_detail.itemfocuschanged`, `dw_detail.editchanged`, `dw_detail.itemerror`, `dw_detail.losefocus`, `dw_detail.rowfocuschanging`, `dw_selectionlist.doubleclicked`

Source: `recovered/scripts/saleorder/w_workorder.pbs`
