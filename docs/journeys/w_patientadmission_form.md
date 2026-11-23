# w_patientadmission_form

- title: Patient Admission Form
- library: patientcomponents (Hospital / clinic)
- ancestor: `w_multi_entry`
- size: 2940 x 1981 PBU
- reached from: Basic Data > Patient > Admission
- script size: 1688 lines; 17 events, 53 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_patientadmission_print`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_admitedpatient_recurringservices2`

## Data

- DataWindows: `d_admitedpatient_recurringservices2`, `d_amanchildcare_patientadmission_p`, `d_group_servicetemplate`, `d_mastercashierwindow_detail`, `d_patientadmission_fatimapharmacy`, `d_patientadmission_meharhsp_print`, `d_patientadmission_nazeerhsp_print`, `d_patientadmission_print`, `d_servicetemplate_detail`
- tables touched by embedded SQL: admittedpatientrecurringservices, mastercashwin, patient, patientadmission, patientlocation, patienttransfer, saleledger, serverdate, service, servicetemplateheader
- stored procedures: createautotriggersms, virtualgl
- global functions: f_datepreferences, f_getgroupcode, f_is_group_module_cashaccount_allowed, f_numberpreferences, f_rightexists, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_disease_diseasetype, w_arg_diseasetype, w_arg_sdate, w_arg_single_servicetemplate, w_arg_sinvcode_linvcode, w_inpatient_bill, w_mastercashierwindow, w_patientinfo, w_patientregistration, w_patientsearch, w_patientsearchresult, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_patientadmission_form.ue_save_withnocommit`, `w_patientadmission_form.create`, `w_patientadmission_form.destroy`, `w_patientadmission_form.ue_save`, `w_patientadmission_form.ue_newform`, `w_patientadmission_form.ue_detail`, `w_patientadmission_form.ue_newitem`, `w_patientadmission_form.ue_deleteitem`, `w_patientadmission_form.close`, `w_patientadmission_form.ue_list`, `w_patientadmission_form.ue_print`, `w_patientadmission_form.ue_refreshddw`, `w_patientadmission_form.ue_new`, `w_patientadmission_form.ue_postopen`, `w_patientadmission_form.open`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `w_patientadmission_form.wf_print`, `w_patientadmission_form.wf_retrievelist`, `w_patientadmission_form.wf_retrievelistall`, `w_patientadmission_form.wf_returnsaleinvoice`, `w_patientadmission_form.wf_visible`, `w_patientadmission_form.wf_validateitemnew`, `w_patientadmission_form.wf_validatefullcode`, `w_patientadmission_form.wf_duplicatetemplatename`, `w_patientadmission_form.wf_getmaxdate`, `w_patientadmission_form.wf_getwardcode`, `w_patientadmission_form.wf_grandtotal`, `w_patientadmission_form.wf_inititeminfo`, `w_patientadmission_form.wf_initmodify`, `w_patientadmission_form.wf_lockserviceinvoices`, `w_patientadmission_form.wf_validateitem`, `w_patientadmission_form.wf_validategodown`, `w_patientadmission_form.wf_deleteemptydetailrow`, `w_patientadmission_form.wf_populate_group_servicetemplate`, `w_patientadmission_form.wf_protectdw`, `w_patientadmission_form.wf_closelist`, `w_patientadmission_form.wf_deleteserviceinvoice`, `w_patientadmission_form.wf_findpatientcode`, `w_patientadmission_form.wf_findregno`, `w_patientadmission_form.wf_locationoccupied`, `w_patientadmission_form.wf_registerpatient`, `w_patientadmission_form.wf_assign_master_cash_win_object`, `w_patientadmission_form.wf_set_cashaccount`, `w_patientadmission_form.wf_show_mastercashierwindow`, `w_patientadmission_form.wf_update_mastercashierwindow`, `w_patientadmission_form.wf_retrievelist_datelimit`, `w_patientadmission_form.wf_admitted`, `w_patientadmission_form.wf_populate_servicetemplate`, `w_patientadmission_form.wf_get_startdate`, `w_patientadmission_form.wf_retrieve`, `w_patientadmission_form.wf_show_inpatientbill`, `w_patientadmission_form.wf_select_diseasetype_disease`, `w_patientadmission_form.wf_update_customer`, `w_patientadmission_form.wf_show_patientinfo`, `w_patientadmission_form.wf_fetch_procedure_info`, `w_patientadmission_form.wf_patient_retrieve`, `w_patientadmission_form.wf_validate_patient`, `w_patientadmission_form.wf_patientsearch`, `w_patientadmission_form.wf_find_patient_regno`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.editchanged`, `dw_find.keypressed`

Source: `recovered/scripts/patientcomponents/w_patientadmission_form.pbs`
