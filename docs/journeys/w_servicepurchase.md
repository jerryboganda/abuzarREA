# w_servicepurchase

- title: Purchase Of Services
- library: servicepurcomponents (Services)
- ancestor: `w_multi_entry`
- size: 3087 x 4061 PBU
- reached from: (opened from code / other windows)
- script size: 1869 lines; 21 events, 58 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_retailsaleinvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_servicepurdetail`

## Data

- DataWindows: `d_groupallowedmoduleheader`, `d_groupsuppcategory_detail`, `d_itemstockinfo`, `d_mastercashierwindow_detail`, `d_retailsaleinvreport`, `d_servicecategory_list`, `d_servicepurdetail`, `d_servicetemplate_detail`, `d_servicetemplate_header`
- tables touched by embedded SQL: accounts, groupallowedservicecategory, groupsuppliercategory, into, item, mastercashwin, saledetail, saleledger, service, servicepurdetail, servicepurheader, supplier
- stored procedures: postpurofservice_suppwise, updateactivitymonitor, virtualgl
- global functions: f_generateheaderinvcode, f_getgroupcode, f_is_group_module_cashaccount_allowed, f_newtableid, f_numberpreferences, f_retrieve_servicelist, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_account_ledger, w_arg_supp_sinv_linv, w_choose_servicecategory, w_edit_servicetemplate, w_mastercashierwindow, w_popup_itemsearchcriteriaselection, w_preview_invoices, w_salesmanpassword, w_savesaleastemplate, w_select_single_servicecategry

## Events and functions

`w_servicepurchase.ue_save_withnocommit`, `w_servicepurchase.create`, `w_servicepurchase.destroy`, `w_servicepurchase.ue_save`, `w_servicepurchase.ue_newform`, `w_servicepurchase.ue_detail`, `w_servicepurchase.ue_newitem`, `w_servicepurchase.ue_deleteitem`, `w_servicepurchase.close`, `w_servicepurchase.ue_list`, `w_servicepurchase.ue_print`, `w_servicepurchase.ue_refreshddw`, `w_servicepurchase.ue_new`, `w_servicepurchase.ue_postopen`, `w_servicepurchase.open`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `w_servicepurchase.wf_genfullcode`, `w_servicepurchase.wf_getmaxdate`, `w_servicepurchase.wf_getsalesstockinfo`, `w_servicepurchase.wf_savastemplate`, `w_servicepurchase.wf_getitemassociategcode`, `w_servicepurchase.wf_retrievelistall`, `w_servicepurchase.wf_retrievelist`, `w_servicepurchase.wf_selectitembatches`, `w_servicepurchase.wf_closelist`, `w_servicepurchase.wf_setgodownoption`, `w_servicepurchase.wf_visible`, `w_servicepurchase.wf_initmodify`, `w_servicepurchase.wf_findfullcode`, `w_servicepurchase.wf_validateitem`, `w_servicepurchase.wf_inititeminfo`, `w_servicepurchase.wf_protectdw`, `w_servicepurchase.wf_grandtotal`, `w_servicepurchase.wf_selectprintreport`, `w_servicepurchase.wf_assigndatawindowobjects`, `w_servicepurchase.wf_post`, `w_servicepurchase.wf_editservicetemplate`, `w_servicepurchase.wf_refreshitemslist_catwise`, `w_servicepurchase.wf_refreshitemslist_itemname`, `w_servicepurchase.wf_refresh_singleservicecategory`, `w_servicepurchase.wf_initialize_lookup_table`, `w_servicepurchase.wf_refreshitemslist`, `w_servicepurchase.wf_assign_master_cash_win_object`, `w_servicepurchase.wf_set_cashaccount`, `w_servicepurchase.wf_show_mastercashierwindow`, `w_servicepurchase.wf_update_mastercashierwindow`, `w_servicepurchase.wf_show_accountledger`, `w_servicepurchase.wf_saveandpost`, `w_servicepurchase.wf_update_virtualgl`, `w_servicepurchase.wf_deleteserviceinvoice`, `w_servicepurchase.wf_find_suppcode`, `w_servicepurchase.wf_setsuppinfo`, `w_servicepurchase.wf_setsuppname`, `w_servicepurchase.wf_set_preferences`, `w_servicepurchase.wf_post_service_custwise`, `w_servicepurchase.wf_lockserviceinvoices`, `w_servicepurchase.wf_returnthisinvoice`, `w_servicepurchase.wf_apply_groupsuppliercategory`, `w_servicepurchase.wf_check_groupsuppliercategory`, `w_servicepurchase.wf_set_headersetting`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_footer.getfocus`, `dw_detail.itemerror`, `dw_detail.getfocus`, `dw_detail.editchanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/servicepurcomponents/w_servicepurchase.pbs`
