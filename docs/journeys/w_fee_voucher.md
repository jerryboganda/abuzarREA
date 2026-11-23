# w_fee_voucher

- title: (set at run time)
- library: accounts (Accounts & cash)
- ancestor: `w_multi_entry`
- size: 2962 x 3075 PBU
- reached from: (opened from code / other windows)
- script size: 2836 lines; 15 events, 62 functions

## Controls (4)

- `tab_retrieve` (tab_retrieve)
- `dw_voucherrep` (u_dwstandard) dataobject `d_voucherprint_half`
- `dw_vocherdetail` (datawindow) dataobject `d_voucherdetail_hidden`
- `dw_coucherreceipt` (datawindow)

## Data

- DataWindows: `d_VoucherDetail_hidden`, `d_creditsaleinvoices_balance`, `d_creditsaleinvoices_outstanding`, `d_creditsaleinvoices_outstanding2`, `d_purinvoices_balance`, `d_purinvoices_outstanding`, `d_serviceinvoices_balance`, `d_serviceinvoices_outstanding`, `d_servicepurinvoices_balance`, `d_servicepurinvoices_outstanding`, `d_student_outstanding_service`, `d_student_outstanding_service_select`, `d_voucherdetail_hidden`, `d_voucherprint_half`
- tables touched by embedded SQL: _utn, accounts, customer, gldetail, glheader, groupcashaccount, guest, guestcheckin, patient, patientadmission, purledger, saleledger, serviceheader, servicepurheader, student, virtualgl, vochercategory, vochercategoryheader
- stored procedures: checkunpostedpurinvintransactions, checkunpostedsaleinvintransactions, checkunpostedserviceinvintransactions, checkunpostedservicepurinvintransactions, getglobalcode, getmaxutn, getpurinvbalance, getsaleinvbalance, getserviceinvbalance, getservicepurinvbalance, isallowedcustomergroupcategory, lockpurinvoice, locksaleinvoice, lockserviceinvoice, lockservicepurinvoice, postgeneralledger, updateactivitymonitor, updatepurinvbalance, updatesaleinvbalance, updateserviceinvbalance, updateservicepurinvbalance, virtualgl
- global functions: f_getgroupcode, f_numberpreferences, f_rightexists, f_stringpreferences, f_validatedw
- windows opened: w_account_ledger, w_arg_academicclass, w_arg_areas, w_arg_cust_period_outstanding_inv, w_arg_cust_period_outstanding_serviceinv, w_arg_cust_sinv_linv, w_arg_sinvcode_linvcode, w_arg_subareas_areabased, w_arg_supp_period_outstanding_inv, w_arg_supp_period_outstanding_serviceinv, w_arg_supp_sinv_linv, w_patientdiscount, w_popup_partialsearch_selection_acc, w_preview_invoices, w_salesmanpassword, w_select_invoicepopulation_voucher, w_student_fine_waiver, w_student_ledger, w_studentsearch, w_studentsearchresult, w_studentsearchresult_classwise, w_summaccount_balance

## Events and functions

`w_fee_voucher.create`, `w_fee_voucher.destroy`, `w_fee_voucher.ue_newform`, `w_fee_voucher.ue_save`, `w_fee_voucher.ue_detail`, `w_fee_voucher.ue_newitem`, `w_fee_voucher.ue_refreshddw`, `w_fee_voucher.ue_list`, `w_fee_voucher.ue_postopen`, `w_fee_voucher.ue_print`, `w_fee_voucher.ue_deleteitem`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_dwnkey`, `dw_itemsdetail.ue_enterkey`, `w_fee_voucher.wf_assigndatawindowobjects`, `w_fee_voucher.wf_cleargroupbox`, `w_fee_voucher.wf_deleteallemptydetailrows`, `w_fee_voucher.wf_deleteemptydetailrow`, `w_fee_voucher.wf_deletevoucher`, `w_fee_voucher.wf_filter`, `w_fee_voucher.wf_findfullcode`, `w_fee_voucher.wf_getbalance`, `w_fee_voucher.wf_getfullcode`, `w_fee_voucher.wf_getinvinfo`, `w_fee_voucher.wf_getnewvouchercode`, `w_fee_voucher.wf_initglobalconstants`, `w_fee_voucher.wf_initmodify`, `w_fee_voucher.wf_lockinvoice`, `w_fee_voucher.wf_lockvoucher`, `w_fee_voucher.wf_lockvouchers`, `w_fee_voucher.wf_post`, `w_fee_voucher.wf_protectdw`, `w_fee_voucher.wf_returnvoucher`, `w_fee_voucher.wf_setaccountname`, `w_fee_voucher.wf_setbalance`, `w_fee_voucher.wf_setpatientname`, `w_fee_voucher.wf_validatedate`, `w_fee_voucher.wf_validategroupcustcat`, `w_fee_voucher.wf_validatepatient`, `w_fee_voucher.wf_validateregno`, `w_fee_voucher.wf_populatedetail`, `w_fee_voucher.wf_validateinvcode`, `w_fee_voucher.wf_populateinvoices`, `w_fee_voucher.wf_showsummaryaccountbalance`, `w_fee_voucher.wf_setvouchercategorysettings`, `w_fee_voucher.wf_setvouchertype`, `w_fee_voucher.wf_selectprintout`, `w_fee_voucher.wf_accountledger`, `w_fee_voucher.wf_retrievelist`, `w_fee_voucher.wf_retrievelistall`, `w_fee_voucher.wf_check_unique_refno`, `w_fee_voucher.wf_show_patientdiscount_window`, `w_fee_voucher.wf_isvoucherinuse`, `w_fee_voucher.wf_saveandpost`, `w_fee_voucher.wf_search_account`, `w_fee_voucher.wf_populate_outstanding_invoices`, `w_fee_voucher.wf_setinvoicedetail`, `w_fee_voucher.wf_setguestname`, `w_fee_voucher.wf_setstudentname`, `w_fee_voucher.wf_validateguest`, `w_fee_voucher.wf_validatestudent`, `w_fee_voucher.wf_validate_guestregno`, `w_fee_voucher.wf_validate_studentregno`, `w_fee_voucher.wf_search_student_receivables`, `w_fee_voucher.wf_show_student_fine_waiver`, `w_fee_voucher.wf_show_studentledger`, `w_fee_voucher.wf_validate_headercashaccount`, `w_fee_voucher.wf_populate_student_outstandings`, `w_fee_voucher.wf_search_student_receivables_classwise`, `w_fee_voucher.wf_populate_student_receivables`, `tab_retrieve.selectionchanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.editchanged`

Source: `recovered/scripts/accounts/w_fee_voucher.pbs`
