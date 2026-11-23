# w_sms_center

- title: SMS Center
- library: smscomponents (SMS)
- ancestor: `window`
- size: 2864 x 2045 PBU
- reached from: (opened from code / other windows)
- script size: 2641 lines; 63 events, 48 functions

## Controls (5)

- `dw_print` (datawindow)
- `tab_smscenter` (tab)
- `ole_device` (olecustomcontrol)
- `timing_2` (timing)
- `timing_1` (timing)

## Data

- DataWindows: `d_khyber_thermal_saleinvrep`, `d_smscenter_contactgroup_selection`, `d_smscenter_contactselection`, `d_smscenter_patientselection_detail`
- tables touched by embedded SQL: saleledger, sms_center, sms_template, srledger, sysjobs
- stored procedures: activatejob, adjustjobschedule, createdatasms, createsms
- global functions: f_getsaleprintout, f_numberpreferences, f_reportheaderinfo, f_rightexists, f_set_headerlogo, f_stringpreferences
- windows opened: w_arg_academicclass, w_arg_classwise_studentselection_forsms, w_arg_contactselection_smscenter, w_arg_emp_category, w_arg_emp_department, w_arg_emp_designation, w_arg_employeeselection_forsms, w_arg_patientcategory_only, w_arg_patients, w_arg_patientselection_smscenter, w_arg_schollbranch, w_arg_schollbranch_sdate_ldate_age_total, w_arg_school, w_arg_sdate_ldate, w_arg_smscenter, w_arg_smstemplate_data_enabled, w_arg_zone, w_select_school_branch_class_defaulter, w_selectformat_emp_cat_dept_desig, w_sms_finalizedsaleorder, w_sms_postedsales, w_smscenter_preview

## Events and functions

`w_sms_center.create`, `w_sms_center.destroy`, `w_sms_center.open`, `tab_smscenter.create`, `tab_smscenter.destroy`, `tabpage_device.create`, `tabpage_device.destroy`, `cb_set_smscentre.clicked`, `cb_refresh.clicked`, `dw_device.itemchanged`, `dw_device.ue_enterkey`, `tabpage_compose.create`, `tabpage_compose.destroy`, `cb_reset.clicked`, `cb_send.clicked`, `dw_compose.ue_enterkey`, `dw_compose.ue_dwnkey`, `dw_compose.itemchanged`, `tabpage_outbox.create`, `tabpage_outbox.destroy`, `cb_mark_outbox_expired.clicked`, `cb_sendselected.clicked`, `cb_mark_outbox.clicked`, `cb_sort_outbox.clicked`, `cb_filter_outbox.clicked`, `cb_retrieve_outbox.clicked`, `cb_send_outbox.clicked`, `dw_outbox.ue_enterkey`, `tabpage_sent.create`, `tabpage_sent.destroy`, `cb_deleteall.clicked`, `cb_delete.clicked`, `cb_mark_unsent.clicked`, `cb_sort_sent.clicked`, `cb_filter_sent.clicked`, `cb_retrieve_sent.clicked`, `dw_sent.ue_dwnkey`, `tabpage_expired.create`, `tabpage_expired.destroy`, `cb_expired_deleteall.clicked`, `cb_expired_delete.clicked`, `cb_expired_mark_unsent.clicked`, `cb_expired_sort.clicked`, `cb_expired_filter.clicked`, `cb_expired_retrieve.clicked`, `tabpage_schedule.create`, `tabpage_schedule.destroy`, `cb_save_schedule.clicked`, `rb_every.clicked`, `rb_once.clicked`, `cbx_activate.clicked`, `tabpage_summary.create`, `tabpage_summary.destroy`, `tabpage_graph.create`, `tabpage_graph.destroy`, `gr_graph.create`, `gr_graph.destroy`, `gr_graph.ue_rbuttonup`, `gr_graph.clicked`, `timing_2.create`, `timing_2.destroy`, `timing_1.create`, `timing_1.destroy`, `w_sms_center.wf_set_autoprint`, `w_sms_center.wf_settimer`, `w_sms_center.wf_refresh`, `w_sms_center.wf_select_printslip`, `w_sms_center.wf_selectprintreport`, `w_sms_center.wf_set_preferences`, `w_sms_center.wf_initialize`, `w_sms_center.wf_get_make`, `w_sms_center.wf_wait`, `w_sms_center.wf_get_model`, `w_sms_center.wf_set_motorola_textmode`, `w_sms_center.wf_getdevices`, `w_sms_center.wf_identifydevices`, `w_sms_center.wf_setdevicedetail`, `w_sms_center.wf_get_groupcontacts`, `w_sms_center.wf_validate_phoneno`, `w_sms_center.wf_get_contactlist`, `w_sms_center.wf_get_smstemplatetext`, `w_sms_center.wf_sendsms`, `w_sms_center.wf_update_smsstatus`, `w_sms_center.wf_remove_whitespace`, `w_sms_center.wf_get_imei`, `w_sms_center.wf_generate_datasms`, `w_sms_center.wf_open_port`, `w_sms_center.wf_sendsms_textmode`, `w_sms_center.wf_encode_pdu`, `w_sms_center.wf_sendsms_from_outbox`, `w_sms_center.wf_get_jobschedule`, `w_sms_center.wf_update_summary_and_graph`, `w_sms_center.wf_update_sent_outbox_info`, `w_sms_center.wf_apply_rights`, `w_sms_center.wf_sendsms_pdumode`, `w_sms_center.wf_get_sms_center`, `w_sms_center.wf_set_sms_centre`, `w_sms_center.wf_get_signal_strength`, `w_sms_center.wf_get_battery_status`, `w_sms_center.wf_encode_sms_in_pdu`, `w_sms_center.wf_send_websms`, `w_sms_center.wf_get_patientsforsms`, `w_sms_center.wf_update_expired_smsstatus`, `w_sms_center.timer`, `tab_smscenter.selectionchanged`, `dw_compose.editchanged`, `dw_outbox.rowfocuschanged`, `dw_outbox.editchanged`, `dw_outbox.doubleclicked`, `dw_sent.doubleclicked`, `gr_graph.rbuttondown`

Source: `recovered/scripts/smscomponents/w_sms_center.pbs`
