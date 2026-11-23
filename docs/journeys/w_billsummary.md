# w_billsummary

- title: Bill Summary
- library: billsummary (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3067 x 3868 PBU
- reached from: (opened from code / other windows)
- script size: 1684 lines; 18 events, 37 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_invdetail` (datawindow) dataobject `d_billsummarydetail`
- `dw_print` (u_dwstandard) dataobject `d_billsummaryprint`

## Data

- DataWindows: `d_amintraders_billsummary_saleinvreport`, `d_amintraders_billsummary_storesummary`, `d_billsummary_population`, `d_billsummary_population_invbased`, `d_billsummary_population_invbased_period`, `d_billsummary_population_period`, `d_billsummary_saleinvreport`, `d_billsummary_storesummary_print`, `d_billsummarydetail`, `d_billsummaryprint`, `d_custwise_sreturnsummary_viabillsummary`, `d_galaxydist_billsumm_storesummary_print`, `d_glaxydist_saleinvreport_billsummary`, `d_maxpharmadist_billsummary_saleinvces`, `d_storesummary_sreturn_viabillsummary`, `ddd_vouchheaderaccounts`
- tables touched by embedded SQL: accounts, billsummary, billsummarydetail, customer, saleledger, srbufferledger
- stored procedures: checkunpostedsaleinvintransactions, finalizebillsummary, getsaleinvbalance, lockbillsummary, postbillsummary, updatesaleinvbalance, virtualgl
- global functions: f_numberpreferences, f_stringpreferences, f_validatedw
- windows opened: w_account_ledger, w_arg_billsummary_pop_invbased_period, w_arg_billsummary_population, w_arg_billsummary_population_invbased, w_arg_billsummary_population_period, w_arg_sinvcode_linvcode, w_billsummary_acccountselection, w_preview_invoices, w_preview_invoices2, w_salereturnbuffer_popup, w_salesmanpassword, w_select_invoicerange_period

## Events and functions

`w_billsummary.create`, `w_billsummary.destroy`, `w_billsummary.ue_save`, `w_billsummary.ue_newform`, `w_billsummary.ue_newitem`, `w_billsummary.close`, `w_billsummary.ue_list`, `w_billsummary.ue_deleteitem`, `w_billsummary.ue_postopen`, `w_billsummary.ue_detail`, `w_billsummary.ue_print`, `w_billsummary.ue_callback_popupwindow`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_dwnkey`, `dw_itemsdetail.ue_enterkey`, `tabpage_list.create`, `tabpage_list.destroy`, `w_billsummary.wf_deleteallemptydetailrows`, `w_billsummary.wf_deleteemptydetailrow`, `w_billsummary.wf_lockinvoice`, `w_billsummary.wf_populateinvoices`, `w_billsummary.wf_assigndatawindowobjects`, `w_billsummary.wf_setbalance`, `w_billsummary.wf_findcustcode`, `w_billsummary.wf_setcustomerinfo`, `w_billsummary.wf_execute_virtualgl`, `w_billsummary.wf_refreshitemslist`, `w_billsummary.wf_savedetail`, `w_billsummary.wf_deletebillsummarydetail`, `w_billsummary.wf_protectdw`, `w_billsummary.wf_set_account`, `w_billsummary.wf_assign_sr_dataobjects`, `w_billsummary.wf_show_salereturn`, `w_billsummary.wf_save_salereturn`, `w_billsummary.wf_set_salereturn_amount`, `w_billsummary.wf_open_item_form_popup`, `w_billsummary.wf_request_open_salereturn`, `w_billsummary.wf_request_referenced_salereturn`, `w_billsummary.wf_finalize_billsummary`, `w_billsummary.wf_post`, `w_billsummary.wf_return_billsummary`, `w_billsummary.wf_set_initial_accounts`, `w_billsummary.wf_setbillsummarytype`, `w_billsummary.wf_set_column_on_off`, `w_billsummary.wf_setinvoicedetail`, `w_billsummary.wf_validateinvcode`, `w_billsummary.wf_selectprintout`, `w_billsummary.wf_print_storekeepersummary`, `w_billsummary.wf_print_saleinvoices`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.rowfocuschanging`, `dw_find.keypressed`

Source: `recovered/scripts/billsummary/w_billsummary.pbs`
