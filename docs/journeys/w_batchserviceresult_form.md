# w_batchserviceresult_form

- title: Service Result (Batch Entry Form)
- library: serviceresult (Services)
- ancestor: `w_multi_entry`
- size: 3223 x 2708 PBU
- reached from: (opened from code / other windows)
- script size: 1478 lines; 22 events, 39 functions

## Controls (1)

- `tab_retrieve` (tab_retrieve)

## Data

- DataWindows: `d_service_result_template`, `d_servicebreakup`, `d_servicecomponent_comments`, `d_servicecomponent_options`, `d_servicecomponent_refvalue`, `d_serviceinv_service_result_required`
- tables touched by embedded SQL: patient, servicecomponent, servicecomponenttype, servicedetail, serviceheader, serviceresultheader
- stored procedures: getserviceinfo, getserviceinvbalance, gettransactionamount, regenerateserviceresult, updateserviceinvbalance
- global functions: f_drilldown_itemsearch, f_newtableid, f_rightexists, f_stringpreferences, f_validatedw
- windows opened: w_arg_serviceresult_deliverydate, w_arg_serviceresultstyle, w_arg_sinvcode_linvcode, w_componentvalue2_text, w_componentvalue_decimal, w_componentvalue_dropdown, w_componentvalue_long, w_componentvalue_text, w_preview_invoices, w_salesmanpassword, w_serviceresult_rowid_comments

## Events and functions

`w_batchserviceresult_form.create`, `w_batchserviceresult_form.destroy`, `w_batchserviceresult_form.ue_save`, `w_batchserviceresult_form.ue_newform`, `w_batchserviceresult_form.ue_newitem`, `w_batchserviceresult_form.ue_detail`, `w_batchserviceresult_form.ue_postopen`, `w_batchserviceresult_form.ue_deleteitem`, `w_batchserviceresult_form.ue_list`, `w_batchserviceresult_form.ue_new`, `w_batchserviceresult_form.ue_print`, `w_batchserviceresult_form.open`, `tabpage_detail.create`, `tabpage_detail.destroy`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `tabpage_list.create`, `tabpage_list.destroy`, `cb_selectall.clicked`, `cb_selectnone.clicked`, `w_batchserviceresult_form.wf_duplicatename`, `w_batchserviceresult_form.wf_validateitem`, `w_batchserviceresult_form.wf_set_service_info`, `w_batchserviceresult_form.wf_protectdw`, `w_batchserviceresult_form.wf_populate_services`, `w_batchserviceresult_form.wf_set_ref_value`, `w_batchserviceresult_form.wf_check_options`, `w_batchserviceresult_form.wf_deleteemptydetailrow`, `w_batchserviceresult_form.wf_edit_comments`, `w_batchserviceresult_form.wf_edit_componentvalue`, `w_batchserviceresult_form.wf_get_servicecomponenttype_info`, `w_batchserviceresult_form.wf_initmodify`, `w_batchserviceresult_form.wf_set_patient_gestation`, `w_batchserviceresult_form.wf_getserviceinfo`, `w_batchserviceresult_form.wf_lock_service_result`, `w_batchserviceresult_form.wf_post`, `w_batchserviceresult_form.wf_set_machine_based_ref_value`, `w_batchserviceresult_form.wf_populate_ddlb`, `w_batchserviceresult_form.wf_set_remarks`, `w_batchserviceresult_form.wf_set_servicecomponent_comments`, `w_batchserviceresult_form.wf_set_template_result`, `w_batchserviceresult_form.wf_edit_componentvalue2`, `w_batchserviceresult_form.wf_set_servicebalance`, `w_batchserviceresult_form.wf_set_form_values`, `w_batchserviceresult_form.wf_sortdw`, `w_batchserviceresult_form.wf_set_printout`, `w_batchserviceresult_form.wf_populate_servicecomponent`, `w_batchserviceresult_form.wf_retrievelistall`, `w_batchserviceresult_form.wf_retrievelist`, `w_batchserviceresult_form.wf_set_delivery_date_retrieval`, `w_batchserviceresult_form.wf_retrieve`, `dw_detail.itemerror`, `dw_detail.getfocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.doubleclicked`, `dw_find.keypressed`

Source: `recovered/scripts/serviceresult/w_batchserviceresult_form.pbs`
