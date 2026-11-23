# w_serviceresult_form

- title: Service Result Form
- library: serviceresult (Services)
- ancestor: `w_multi_entry`
- size: 3314 x 3388 PBU
- reached from: (opened from code / other windows)
- script size: 1259 lines; 11 events, 27 functions

## Controls (0)


## Data

- DataWindows: `d_service_result_template`, `d_servicebreakup`, `d_servicecomponent_comments`, `d_servicecomponent_options`, `d_servicecomponent_refvalue`, `d_serviceinv_service_result_required`
- tables touched by embedded SQL: patient, servicecomponent, servicecomponenttype, servicedetail, serviceheader, serviceresultheader
- stored procedures: getserviceinfo, getserviceinvbalance, gettransactionamount, updateserviceinvbalance
- global functions: f_newtableid, f_rightexists, f_stringpreferences, f_validatedw
- windows opened: w_arg_serviceinvoice_services, w_arg_serviceresultstyle, w_arg_sinvcode_linvcode, w_componentvalue2_text, w_componentvalue_decimal, w_componentvalue_dropdown, w_componentvalue_long, w_componentvalue_text, w_preview_invoices, w_salesmanpassword, w_serviceresult_rowid_comments

## Events and functions

`w_serviceresult_form.create`, `w_serviceresult_form.destroy`, `w_serviceresult_form.ue_save`, `w_serviceresult_form.ue_newform`, `w_serviceresult_form.ue_newitem`, `w_serviceresult_form.ue_detail`, `w_serviceresult_form.ue_postopen`, `w_serviceresult_form.ue_deleteitem`, `w_serviceresult_form.ue_list`, `w_serviceresult_form.ue_new`, `w_serviceresult_form.ue_print`, `w_serviceresult_form.wf_duplicatename`, `w_serviceresult_form.wf_validateitem`, `w_serviceresult_form.wf_set_service_info`, `w_serviceresult_form.wf_protectdw`, `w_serviceresult_form.wf_populate_services`, `w_serviceresult_form.wf_set_ref_value`, `w_serviceresult_form.wf_check_options`, `w_serviceresult_form.wf_deleteemptydetailrow`, `w_serviceresult_form.wf_edit_comments`, `w_serviceresult_form.wf_get_servicecomponenttype_info`, `w_serviceresult_form.wf_initmodify`, `w_serviceresult_form.wf_set_patient_gestation`, `w_serviceresult_form.wf_lock_service_result`, `w_serviceresult_form.wf_post`, `w_serviceresult_form.wf_set_machine_based_ref_value`, `w_serviceresult_form.wf_populate_ddlb`, `w_serviceresult_form.wf_set_remarks`, `w_serviceresult_form.wf_set_servicecomponent_comments`, `w_serviceresult_form.wf_set_template_result`, `w_serviceresult_form.wf_edit_componentvalue2`, `w_serviceresult_form.wf_set_servicebalance`, `w_serviceresult_form.wf_populate_servicecomponent`, `w_serviceresult_form.wf_set_serviceresultformat`, `w_serviceresult_form.wf_set_styleformat`, `w_serviceresult_form.wf_set_singleformat`, `w_serviceresult_form.wf_getserviceinfo`, `w_serviceresult_form.wf_edit_componentvalue`

Source: `recovered/scripts/serviceresult/w_serviceresult_form.pbs`
