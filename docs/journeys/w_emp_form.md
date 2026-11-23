# w_emp_form

- title: Employee Form
- library: employee (Employees / HR)
- ancestor: `window`
- size: 3087 x 2093 PBU
- reached from: (opened from code / other windows)
- script size: 1832 lines; 45 events, 56 functions

## Controls (6)

- `dw_advance` (datawindow) dataobject `d_account_detail`
- `dw_account` (datawindow) dataobject `d_account_detail`
- `tab_main` (tab)
- `dw_image` (u_dwstandard) dataobject `d_employeeimage`
- `cb_ok` (commandbutton) text "Save"
- `cb_cancel` (commandbutton) text "Cancel"

## Data

- DataWindows: `d_account_detail`, `d_emp_allowances_list`, `d_emp_deduction_list`, `d_emp_payallowances_notused`, `d_emp_paydeduction_notused`, `d_emp_recordpointer`, `d_employeeimage`
- tables touched by embedded SQL: _tabmaxkey, accounts, emp_employee, emp_image, into, transportroute
- stored procedures: -
- global functions: f_rightexists, f_validatedw, f_writeimgtofile
- windows opened: w_arg_emp_record_pointer, w_employeegallary, w_employeeimage

## Events and functions

`w_emp_form.ue_close`, `w_emp_form.create`, `w_emp_form.destroy`, `w_emp_form.open`, `tab_main.create`, `tab_main.destroy`, `tabpage_emp.create`, `tabpage_emp.destroy`, `dw_emp.ue_enterkey`, `dw_emp.ue_dwnkey`, `dw_emp.itemchanged`, `dw_emp.clicked`, `tabpage_edu.create`, `tabpage_edu.destroy`, `dw_edu.ue_enterkey`, `dw_edu.ue_dwnkey`, `tabpage_cert.create`, `tabpage_cert.destroy`, `dw_cert.ue_dwnkey`, `dw_cert.ue_enterkey`, `tabpage_skill.create`, `tabpage_skill.destroy`, `dw_skill.ue_dwnkey`, `dw_skill.ue_enterkey`, `tabpage_jobexp.create`, `tabpage_jobexp.destroy`, `dw_jobexp.ue_dwnkey`, `dw_jobexp.ue_enterkey`, `tabpage_proj.create`, `tabpage_proj.destroy`, `dw_proj.ue_enterkey`, `dw_proj.ue_dwnkey`, `tabpage_ref.create`, `tabpage_ref.destroy`, `dw_ref.ue_dwnkey`, `dw_ref.ue_enterkey`, `tabpage_pay.create`, `tabpage_pay.destroy`, `dw_pay.itemchanged`, `dw_pay.ue_enterkey`, `dw_deduction.ue_enterkey`, `dw_allowance.ue_enterkey`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `cb_cancel.clicked`, `w_emp_form.wf_set_interface_adjustments`, `w_emp_form.wf_set_tab_visibility`, `w_emp_form.wf_connect`, `w_emp_form.wf_tabnewid`, `w_emp_form.wf_retrieve_tabs`, `w_emp_form.wf_insert_row`, `w_emp_form.wf_delete_row`, `w_emp_form.wf_goto_record`, `w_emp_form.wf_protectdw`, `w_emp_form.wf_apply_protect_setting`, `w_emp_form.wf_save`, `w_emp_form.wf_print`, `w_emp_form.wf_select_first_tab`, `w_emp_form.wf_get_image`, `w_emp_form.wf_populate_image`, `w_emp_form.wf_update_image`, `w_emp_form.wf_setimage`, `w_emp_form.wf_get_emp_info`, `w_emp_form.wf_duplicate_accname`, `w_emp_form.wf_duplicate_aliasname`, `w_emp_form.wf_duplicate_empid`, `w_emp_form.wf_prepare_for_update`, `w_emp_form.wf_set_employee_picture`, `w_emp_form.wf_get_employee_picture`, `w_emp_form.wf_update_employee_picture`, `w_emp_form.wf_show_employee_gallery`, `w_emp_form.wf_populate_allowances`, `w_emp_form.wf_populate_deductions`, `w_emp_form.wf_update_salary`, `w_emp_form.wf_duplicate_adv_acc`, `w_emp_form.wf_duplicate_adv_acc_alias`, `w_emp_form.wf_validate_transportroutecode`, `w_emp_form.wf_delete_empty_allowances_deductions`, `w_emp_form.wf_adjust_allowances`, `w_emp_form.wf_adjust_deductions`, `tab_main.selectionchanged`, `dw_emp.getfocus`, `dw_emp.itemfocuschanged`, `dw_emp.editchanged`, `dw_edu.getfocus`, `dw_edu.itemfocuschanged`, `dw_cert.getfocus`, `dw_cert.itemfocuschanged`, `dw_skill.getfocus`, `dw_skill.itemfocuschanged`, `dw_jobexp.getfocus`, `dw_jobexp.itemfocuschanged`, `dw_proj.itemfocuschanged`, `dw_proj.getfocus`, `dw_ref.itemfocuschanged`, `dw_ref.getfocus`, `dw_pay.getfocus`, `dw_deduction.getfocus`, `dw_deduction.editchanged`, `dw_allowance.getfocus`, `dw_allowance.editchanged`

Source: `recovered/scripts/employee/w_emp_form.pbs`
