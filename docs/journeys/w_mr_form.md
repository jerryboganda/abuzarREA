# w_mr_form

- title: Patient Medical Record
- library: patientcomponents (Hospital / clinic)
- ancestor: `window`
- size: 3072 x 2083 PBU
- reached from: (opened from code / other windows)
- script size: 2879 lines; 97 events, 79 functions

## Controls (8)

- `cb_discharge` (commandbutton) text "Discharge Now"
- `cb_printlab` (commandbutton) text "Print Lab Requisition"
- `cb_cancel` (commandbutton) text "Cancel"
- `cb_ok` (commandbutton) text "Save"
- `tab_main` (tab)
- `dw_image` (u_dwstandard) dataobject `d_patientimage`
- `dw_labprint` (datawindow) dataobject `d_pic2014_lab_print`
- `dw_dischargeslip` (u_dwstandard) dataobject `d_pic2014_dischargeslip`

## Data

- DataWindows: `d_mr_recordpointer`, `d_patientimage`, `d_pic2014_dischargeslip`, `d_pic2014_lab_print`
- tables touched by embedded SQL: _tabmaxkey, dosage, into, item, patient, patientadmission, patientimage, serverdate
- stored procedures: getdatetime, getpatientdischargeability
- global functions: f_get_user_doctor, f_numberpreferences, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_mr_record_pointer, w_patientgallary, w_patientimage, w_preview_invoices

## Events and functions

`w_mr_form.ue_close`, `w_mr_form.create`, `w_mr_form.destroy`, `w_mr_form.open`, `w_mr_form.key`, `cb_discharge.clicked`, `cb_printlab.clicked`, `cb_cancel.clicked`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `tab_main.create`, `tab_main.destroy`, `tab_main.key`, `tabpage_pc.create`, `tabpage_pc.destroy`, `dw_pc.ue_dwnkey`, `dw_pc.ue_enterkey`, `tabpage_hpc.create`, `tabpage_hpc.destroy`, `dw_hpc.ue_enterkey`, `dw_hpc.ue_dwnkey`, `tabpage_gpe.create`, `tabpage_gpe.destroy`, `dw_gpe.ue_enterkey`, `dw_gpe.ue_dwnkey`, `tabpage_se.create`, `tabpage_se.destroy`, `dw_se.ue_enterkey`, `dw_se.ue_dwnkey`, `tabpage_ecg.create`, `tabpage_ecg.destroy`, `dw_ecg.ue_enterkey`, `dw_ecg.ue_dwnkey`, `dw_ecg.itemchanged`, `tabpage_xray.create`, `tabpage_xray.destroy`, `dw_xray.ue_enterkey`, `dw_xray.ue_dwnkey`, `tabpage_pal.create`, `tabpage_pal.destroy`, `dw_pal.ue_enterkey`, `dw_pal.ue_dwnkey`, `tabpage_elir.create`, `tabpage_elir.destroy`, `dw_elir.ue_enterkey`, `dw_elir.itemchanged`, `dw_elir.ue_dwnkey`, `tabpage_lir.create`, `tabpage_lir.destroy`, `dw_lir.ue_enterkey`, `dw_lir.ue_dwnkey`, `tabpage_echo.create`, `tabpage_echo.destroy`, `dw_echo.ue_enterkey`, `dw_echo.ue_dwnkey`, `tabpage_tscan.create`, `tabpage_tscan.destroy`, `dw_tscan.ue_enterkey`, `dw_tscan.ue_dwnkey`, `tabpage_cang.create`, `tabpage_cang.destroy`, `dw_cang.ue_enterkey`, `dw_cang.ue_dwnkey`, `tabpage_ctang.create`, `tabpage_ctang.destroy`, `dw_ctang.ue_enterkey`, `dw_ctang.ue_dwnkey`, `tabpage_pci.create`, `tabpage_pci.destroy`, `dw_pci.ue_enterkey`, `dw_pci.ue_dwnkey`, `tabpage_cabg.create`, `tabpage_cabg.destroy`, `dw_cabg.ue_enterkey`, `dw_cabg.ue_dwnkey`, `tabpage_provdiag.create`, `tabpage_provdiag.destroy`, `dw_provdiag.ue_enterkey`, `dw_provdiag.ue_dwnkey`, `tabpage_tg.create`, `tabpage_tg.destroy`, `dw_tg.ue_dwnkey`, `dw_tg.ue_enterkey`, `dw_tg.itemchanged`, `dw_selectionlist.ue_setfocus`, `dw_selectionlist.clicked`, `tabpage_pod.create`, `tabpage_pod.destroy`, `dw_selectionlistpod.ue_setfocus`, `dw_selectionlistpod.clicked`, `dw_pod.itemchanged`, `dw_pod.ue_dwnkey`, `dw_pod.ue_enterkey`, `tabpage_patientdischarge.create`, `tabpage_patientdischarge.destroy`, `dw_patientdischarge.ue_dwnkey`, `dw_patientdischarge.ue_enterkey`, `w_mr_form.wf_set_interface_adjustments`, `w_mr_form.wf_set_tab_visibility`, `w_mr_form.wf_connect`, `w_mr_form.wf_tabnewid`, `w_mr_form.wf_get_patient_info`, `w_mr_form.wf_retrieve_tabs`, `w_mr_form.wf_insert_row`, `w_mr_form.wf_delete_row`, `w_mr_form.wf_goto_record`, `w_mr_form.wf_protectdw`, `w_mr_form.wf_apply_protect_setting`, `w_mr_form.wf_save`, `w_mr_form.wf_print`, `w_mr_form.wf_select_first_tab`, `w_mr_form.wf_get_image`, `w_mr_form.wf_populate_image`, `w_mr_form.wf_update_image`, `w_mr_form.wf_itemlist_initialization`, `w_mr_form.wf_validateitem`, `w_mr_form.wf_inititeminfo`, `w_mr_form.wf_get_dosefactor`, `w_mr_form.wf_validate_treatment_given`, `w_mr_form.wf_itemlist_initialization_pod`, `w_mr_form.wf_validate_pod`, `w_mr_form.wf_validateitem_pod`, `w_mr_form.wf_setimage`, `w_mr_form.wf_show_patient_gallery`, `w_mr_form.wf_printlab`, `w_mr_form.wf_validateserverdatetime`, `w_mr_form.wf_print_dischargeslip`, `tab_main.selectionchanged`, `dw_pc.getfocus`, `dw_pc.itemfocuschanged`, `dw_hpc.getfocus`, `dw_hpc.itemfocuschanged`, `dw_gpe.getfocus`, `dw_gpe.itemfocuschanged`, `dw_se.getfocus`, `dw_se.itemfocuschanged`, `dw_ecg.getfocus`, `dw_xray.getfocus`, `dw_xray.itemfocuschanged`, `dw_pal.getfocus`, `dw_pal.itemfocuschanged`, `dw_elir.getfocus`, `dw_elir.itemfocuschanged`, `dw_elir.losefocus`, `dw_lir.getfocus`, `dw_lir.itemfocuschanged`, `dw_echo.getfocus`, `dw_echo.itemfocuschanged`, `dw_tscan.getfocus`, `dw_tscan.itemfocuschanged`, `dw_cang.getfocus`, `dw_cang.itemfocuschanged`, `dw_ctang.getfocus`, `dw_ctang.itemfocuschanged`, `dw_pci.getfocus`, `dw_pci.itemfocuschanged`, `dw_cabg.getfocus`, `dw_cabg.itemfocuschanged`, `dw_provdiag.getfocus`, `dw_provdiag.itemfocuschanged`, `dw_tg.getfocus`, `dw_tg.itemfocuschanged`, `dw_tg.editchanged`, `dw_tg.itemerror`, `dw_tg.losefocus`, `dw_tg.rowfocuschanging`, `dw_selectionlist.doubleclicked`, `dw_selectionlistpod.doubleclicked`, `dw_pod.editchanged`, `dw_pod.getfocus`, `dw_pod.itemerror`, `dw_pod.itemfocuschanged`, `dw_pod.losefocus`, `dw_pod.rowfocuschanging`, `dw_patientdischarge.getfocus`, `dw_patientdischarge.itemfocuschanged`

Source: `recovered/scripts/patientcomponents/w_mr_form.pbs`
