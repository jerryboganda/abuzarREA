# w_patientvisit_form

- title: Patient Visit
- library: patientvisitcomp (Hospital / clinic)
- ancestor: `window`
- size: 3149 x 2304 PBU
- reached from: (opened from code / other windows)
- script size: 2937 lines; 62 events, 73 functions

## Controls (11)

- `cb_rx_history` (commandbutton) text "Rx (History)"
- `cb_image` (commandbutton) text "Image(s)"
- `cb_visithistory` (commandbutton) text "History"
- `cb_patientsearch` (commandbutton) text "Search"
- `cb_print` (commandbutton) text "&Print"
- `cb_cancel` (commandbutton) text "Cancel"
- `cb_ok` (commandbutton) text "&Save"
- `tab_main` (tab)
- `dw_print` (datawindow) dataobject `d_visitprescription_print`
- `dw_image` (u_dwstandard) dataobject `d_patientimage`
- `dw_print2` (datawindow)

## Data

- DataWindows: `d_diseasetreatmenttemplate_detail`, `d_mr_recordpointer`, `d_patientimage`, `d_populate_visit_prescription`, `d_visit_detail`, `d_visit_prescription`, `d_visit_prescription_value`, `d_visitprescription_print`
- tables touched by embedded SQL: _tabmaxkey, diseasetreatmenttemp, doctors, dosage, into, item, patient, patientcatallowedmodule, patientimage, serverdate, visit, visitdiagnostics, visitphysicalexam, visitprecaution, visitsymptoms
- stored procedures: getdatetime
- global functions: f_drilldown_itemsearch, f_get_user_doctor, f_numberpreferences, f_prefered_itemsearch, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_disease_diseasetype, w_arg_diseasetreatmenttemplate, w_arg_diseasetreatmenttemplate_disease, w_arg_diseasetype, w_arg_mr_record_pointer, w_patientgallary, w_patientimage, w_patientregistration, w_patientsearch, w_patientsearchresult, w_preview_invoices, w_visit_prescription_assistant, w_visit_prescription_history, w_visithistory

## Events and functions

`w_patientvisit_form.ue_close`, `w_patientvisit_form.create`, `w_patientvisit_form.destroy`, `w_patientvisit_form.open`, `w_patientvisit_form.key`, `cb_rx_history.clicked`, `cb_image.clicked`, `cb_visithistory.clicked`, `cb_patientsearch.clicked`, `cb_print.clicked`, `cb_cancel.clicked`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `tab_main.create`, `tab_main.destroy`, `tabpage_vd.create`, `tabpage_vd.destroy`, `dw_vd.itemchanged`, `dw_vd.ue_dwnkey`, `dw_vd.ue_enterkey`, `tabpage_vitals.create`, `tabpage_vitals.destroy`, `dw_vitals.ue_enterkey`, `dw_vitals.itemchanged`, `dw_vitals.ue_dwnkey`, `tabpage_symptoms.create`, `tabpage_symptoms.destroy`, `dw_symptoms.ue_enterkey`, `dw_symptoms.ue_dwnkey`, `dw_symptoms.itemchanged`, `tabpage_pexam.create`, `tabpage_pexam.destroy`, `dw_pexam.ue_enterkey`, `dw_pexam.ue_dwnkey`, `dw_pexam.itemchanged`, `tabpage_precautions.create`, `tabpage_precautions.destroy`, `dw_precautions.ue_enterkey`, `dw_precautions.ue_dwnkey`, `tabpage_diagnostics.create`, `tabpage_diagnostics.destroy`, `dw_diagnostics.ue_enterkey`, `dw_diagnostics.ue_dwnkey`, `tabpage_rx.create`, `tabpage_rx.destroy`, `dw_rx.ue_dwnkey`, `dw_rx.ue_enterkey`, `dw_rx.itemchanged`, `dw_selectionlist.ue_setfocus`, `dw_selectionlist.clicked`, `tabpage_obs_us.create`, `tabpage_obs_us.destroy`, `dw_obs_us.ue_enterkey`, `dw_obs_us.ue_dwnkey`, `tabpage_gyn_us.create`, `tabpage_gyn_us.destroy`, `dw_gyn_us.ue_enterkey`, `dw_gyn_us.ue_dwnkey`, `tabpage_abd_us.create`, `tabpage_abd_us.destroy`, `dw_abd_us.ue_enterkey`, `dw_abd_us.ue_dwnkey`, `w_patientvisit_form.wf_set_interface_adjustments`, `w_patientvisit_form.wf_set_tab_visibility`, `w_patientvisit_form.wf_connect`, `w_patientvisit_form.wf_tabnewid`, `w_patientvisit_form.wf_get_patient_info`, `w_patientvisit_form.wf_retrieve_tabs`, `w_patientvisit_form.wf_insert_row`, `w_patientvisit_form.wf_delete_row`, `w_patientvisit_form.wf_goto_record`, `w_patientvisit_form.wf_protectdw`, `w_patientvisit_form.wf_apply_protect_setting`, `w_patientvisit_form.wf_save`, `w_patientvisit_form.wf_select_first_tab`, `w_patientvisit_form.wf_get_image`, `w_patientvisit_form.wf_populate_image`, `w_patientvisit_form.wf_update_image`, `w_patientvisit_form.wf_itemlist_initialization`, `w_patientvisit_form.wf_validateitem`, `w_patientvisit_form.wf_inititeminfo`, `w_patientvisit_form.wf_get_dosefactor`, `w_patientvisit_form.wf_itemlist_initialization_pod`, `w_patientvisit_form.wf_setimage`, `w_patientvisit_form.wf_show_patient_gallery`, `w_patientvisit_form.wf_validateserverdatetime`, `w_patientvisit_form.wf_set_bmi`, `w_patientvisit_form.wf_retrieve_appointments`, `w_patientvisit_form.wf_set_appointmentinfo`, `w_patientvisit_form.wf_find_patient_regno`, `w_patientvisit_form.wf_findpatientcode`, `w_patientvisit_form.wf_patientsearch`, `w_patientvisit_form.wf_registerpatient`, `w_patientvisit_form.wf_visithistory`, `w_patientvisit_form.wf_presave`, `w_patientvisit_form.wf_dosageinfo`, `w_patientvisit_form.wf_update_totalqty`, `w_patientvisit_form.wf_print`, `w_patientvisit_form.wf_select_printout`, `w_patientvisit_form.wf_validate_rx`, `w_patientvisit_form.wf_populate_diseasetreatment_template`, `w_patientvisit_form.wf_show_rx_history`, `w_patientvisit_form.wf_show_rx_value`, `w_patientvisit_form.wf_populate_diseasetemplate`, `w_patientvisit_form.wf_getnestedreport`, `w_patientvisit_form.wf_select_obs_us_print`, `w_patientvisit_form.wf_select_gyn_us_print`, `w_patientvisit_form.wf_select_abd_us_print`, `w_patientvisit_form.wf_help_prescription_population`, `w_patientvisit_form.wf_patient_retrieve`, `w_patientvisit_form.wf_validate_patient`, `tab_main.selectionchanged`, `dw_vd.getfocus`, `dw_vd.itemfocuschanged`, `dw_vitals.getfocus`, `dw_vitals.itemfocuschanged`, `dw_vitals.itemerror`, `dw_symptoms.getfocus`, `dw_symptoms.itemfocuschanged`, `dw_pexam.getfocus`, `dw_precautions.getfocus`, `dw_precautions.itemfocuschanged`, `dw_diagnostics.getfocus`, `dw_diagnostics.itemfocuschanged`, `dw_rx.getfocus`, `dw_rx.itemfocuschanged`, `dw_rx.editchanged`, `dw_rx.itemerror`, `dw_rx.losefocus`, `dw_rx.rowfocuschanged`, `dw_rx.rowfocuschanging`, `dw_selectionlist.doubleclicked`, `dw_obs_us.getfocus`, `dw_gyn_us.getfocus`, `dw_abd_us.getfocus`

Source: `recovered/scripts/patientvisitcomp/w_patientvisit_form.pbs`
