# w_newpreferences

- title: Preferences
- library: abuzarapp (Application shell & settings)
- ancestor: `window`
- size: 2779 x 1860 PBU
- reached from: (opened from code / other windows)
- script size: 1684 lines; 97 events, 9 functions

## Controls (3)

- `cb_cancel` (commandbutton) text "&Cancel"
- `cb_ok` (commandbutton) text "&Ok"
- `tab_preferences` (tab)

## Data

- DataWindows: -
- tables touched by embedded SQL: rights, sysjobs
- stored procedures: activatejob, adjustjobschedule
- global functions: f_getglobalcode, f_startup_rightsmodification, f_validatedw
- windows opened: -

## Events and functions

`w_newpreferences.create`, `w_newpreferences.destroy`, `w_newpreferences.open`, `cb_cancel.ue_enterkey`, `cb_cancel.clicked`, `cb_ok.ue_enterkey`, `cb_ok.clicked`, `tab_preferences.create`, `tab_preferences.destroy`, `tabpage_general.create`, `tabpage_general.destroy`, `dw_general1.ue_enterkey`, `tabpage_sale.create`, `tabpage_sale.destroy`, `dw_saleamountoninv.ue_enterkey`, `dw_saleamountoninv.itemchanged`, `cbx_askamtoncreditsale.clicked`, `dw_sale.ue_enterkey`, `dw_sale.itemchanged`, `tabpage_salereturn.create`, `tabpage_salereturn.destroy`, `dw_salereturn.ue_enterkey`, `dw_sretamountoninv.ue_enterkey`, `dw_sretamountoninv.itemchanged`, `cbx_askamtoncreditsalereturn.clicked`, `tabpage_purchase.create`, `tabpage_purchase.destroy`, `dw_purchase.ue_enterkey`, `dw_purchase.itemchanged`, `dw_puramountoninv.ue_enterkey`, `dw_puramountoninv.itemchanged`, `cbx_askamtonpurchase.clicked`, `tabpage_purchasereturn.create`, `tabpage_purchasereturn.destroy`, `dw_purchasereturn.ue_enterkey`, `dw_prretamountoninv.ue_enterkey`, `dw_prretamountoninv.itemchanged`, `cbx_askamtonpurchasereturn.clicked`, `tabpage_account.create`, `tabpage_account.destroy`, `dw_accountpreferences.ue_enterkey`, `tabpage_report.create`, `tabpage_report.destroy`, `dw_reportpreferences.ue_enterkey`, `tabpage_basicdata.create`, `tabpage_basicdata.destroy`, `dw_default_itemsetting.ue_enterkey`, `tabpage_quotation.create`, `tabpage_quotation.destroy`, `dw_quotationterms.ue_enterkey`, `tabpage_service.create`, `tabpage_service.destroy`, `dw_servicepreferences.ue_enterkey`, `tabpage_issue.create`, `tabpage_issue.destroy`, `dw_issuepreferences.ue_enterkey`, `tabpage_schedule.create`, `tabpage_schedule.destroy`, `cbx_inpatientrecurringservices.clicked`, `cbx_activateautocreditsaleposting.clicked`, `cbx_activateautocashsaleposting.clicked`, `rb_backupevery.clicked`, `rb_backuponce.clicked`, `cbx_activateautobackup.clicked`, `tabpage_adjustment.create`, `tabpage_adjustment.destroy`, `dw_adjustmentpreferences.ue_enterkey`, `tabpage_transfer.create`, `tabpage_transfer.destroy`, `dw_transferpreferences.ue_enterkey`, `tabpage_receipt.create`, `tabpage_receipt.destroy`, `dw_receiptpreferences.ue_enterkey`, `tabpage_purorder.create`, `tabpage_purorder.destroy`, `dw_purorderterms.ue_enterkey`, `tabpage_others.create`, `tabpage_others.destroy`, `dw_otherspref.ue_enterkey`, `dw_otherspref.clicked`, `tabpage_barcode.create`, `tabpage_barcode.destroy`, `dw_barcode.ue_enterkey`, `tabpage_itempriceadj.create`, `tabpage_itempriceadj.destroy`, `dw_itempriceadj.ue_enterkey`, `tabpage_saleorder.create`, `tabpage_saleorder.destroy`, `dw_saleorder.ue_enterkey`, `tabpage_recipe.create`, `tabpage_recipe.destroy`, `dw_recipe.ue_enterkey`, `tabpage_production.create`, `tabpage_production.destroy`, `dw_production.ue_enterkey`, `tabpage_patientpref.create`, `tabpage_patientpref.destroy`, `w_newpreferences.wf_assigndatawindowchild`, `w_newpreferences.wf_insertandscrollto`, `w_newpreferences.wf_showerrmessage`, `w_newpreferences.wf_updatesigfile`, `w_newpreferences.wf_assigndatawindow`, `w_newpreferences.wf_setadvancepurchasepref`, `w_newpreferences.systemkey`, `dw_sale.buttonclicked`, `dw_purchase.getfocus`

Source: `recovered/scripts/abuzarapp/w_newpreferences.pbs`
