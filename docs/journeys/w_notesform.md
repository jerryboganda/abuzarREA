# w_notesform

- title: Notes
- library: notescomponents (Shared framework & master data)
- ancestor: `w_multi_entry`
- size: 2966 x 2240 PBU
- reached from: Transactions > Post Dated Cheques Receivables; Transactions > Post Dated Cheques Payables
- script size: 1644 lines; 19 events, 42 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_print` (u_dwstandard) dataobject `d_notes_printout`
- `dw_invdetail` (u_dwstandard) dataobject `d_notesdetail`

## Data

- DataWindows: `d_notes_printout`, `d_notesdetail`, `d_notesdetail_pur`
- tables touched by embedded SQL: accounts, notes, notescategory, notesdetail, purledger, saleledger
- stored procedures: checkunpostedpurinvintransactions, checkunpostedsaleinvintransactions, finalizenotes, getmaxutn, getpurinvbalance, getsaleinvbalance, locknote, lockpurinvoice, locksaleinvoice, postnote, postnotes, updateactivitymonitor, updatepurinvbalance, updatesaleinvbalance
- global functions: f_rightexists, f_stringpreferences, f_validatedw
- windows opened: w_account_ledger, w_arg_account_sinv_linv, w_arg_sdate, w_arg_sinvcode_linvcode, w_preview_invoices, w_printcheques, w_salesmanpassword

## Events and functions

`w_notesform.create`, `w_notesform.destroy`, `w_notesform.ue_save`, `w_notesform.ue_newform`, `w_notesform.ue_detail`, `w_notesform.ue_newitem`, `w_notesform.close`, `w_notesform.ue_list`, `w_notesform.ue_refreshddw`, `w_notesform.ue_new`, `w_notesform.ue_postopen`, `w_notesform.ue_deleteitem`, `w_notesform.ue_print`, `dw_detail.itemchanged`, `dw_itemsdetail.ue_focusaccount`, `dw_itemsdetail.itemchanged`, `tabpage_list.create`, `tabpage_list.destroy`, `em_invno.ue_downkey`, `w_notesform.wf_deletenote`, `w_notesform.wf_detailrowcount`, `w_notesform.wf_getinvinfo`, `w_notesform.wf_getnewvouchercode`, `w_notesform.wf_grandtotal`, `w_notesform.wf_initmodify`, `w_notesform.wf_lockinvoice`, `w_notesform.wf_locknote`, `w_notesform.wf_locknotes`, `w_notesform.wf_populate_ddlb`, `w_notesform.wf_post`, `w_notesform.wf_print`, `w_notesform.wf_protectdw`, `w_notesform.wf_returnnote`, `w_notesform.wf_setaccountinfo`, `w_notesform.wf_setaliasname`, `w_notesform.wf_validateamt`, `w_notesform.wf_validateinvcode`, `w_notesform.wf_validateacccode`, `w_notesform.wf_deleteallemptydetailrows`, `w_notesform.wf_deleteemptydetailrow`, `w_notesform.wf_retrieveinvoicelist`, `w_notesform.wf_retrievelist`, `w_notesform.wf_assigndatawindowobjects`, `w_notesform.wf_populatedetail`, `w_notesform.wf_finalize`, `w_notesform.wf_locknotes_for_finalize`, `w_notesform.wf_selectprintreport`, `w_notesform.wf_retrievelistall`, `w_notesform.wf_postwithdate`, `w_notesform.wf_printcheque`, `w_notesform.wf_invoke_crystalreport`, `w_notesform.wf_accountledger`, `tab_retrieve.selectionchanged`, `dw_detail.itemerror`, `dw_detail.editchanged`, `dw_detail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`

Source: `recovered/scripts/notescomponents/w_notesform.pbs`
