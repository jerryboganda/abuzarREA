# w_expiryintimation

- title: Expiry Intimation
- library: expiryintimation (Purchase & stock)
- ancestor: `w_multi_entry`
- size: 3233 x 4253 PBU
- reached from: (opened from code / other windows)
- script size: 2228 lines; 26 events, 49 functions

## Controls (6)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_expiryintimation_print`
- `ic_cashdrawerprinter` (olecustomcontrol)
- `ic_comport` (olecustomcontrol)
- `ic_drawerport` (olecustomcontrol)
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_expiryintimation_detail`

## Data

- DataWindows: `d_expiryintimation_detail`, `d_expiryintimation_print`, `d_populate_possible_expiryreport`
- tables touched by embedded SQL: accounts, customer, expiryintimation, expiryintimationdetail, grouprights, intimationtype, item, itemcategory, itemsgroupcategory, purdetail, purledger, saledetail, saleledger, supplier, usergroups
- stored procedures: consolidatedexpiryintimation, create, extractexpiryintimation, markexpiryintimationaspulled, pushexpiryintimationtodropbox
- global functions: f_check_for_basicdata_sync, f_datepreferences, f_drilldown_itemsearch, f_fetch_sites, f_getgroupcode, f_islicenseexpire, f_numberpreferences, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_grouping, w_arg_manfs_cats_classes_packs_dates, w_arg_sinvcode_linvcode, w_arg_supp_cust, w_expintimation_range_selection, w_populate_expintimation_from_datacarry, w_possiblebatchexpiry_expiryintimation, w_preview_invoices, w_printer_copies, w_pull_expintimation_from_dropbox, w_salesmanpassword, w_selectformat_suppitems_default, w_selection_manf_cat_class_packing

## Events and functions

`w_expiryintimation.ue_setitemfocus`, `w_expiryintimation.ue_enableprint`, `w_expiryintimation.ue_populate_expintimation_from_datacarry`, `w_expiryintimation.ue_pull_expiryintimation_from_dropbox`, `w_expiryintimation.create`, `w_expiryintimation.destroy`, `w_expiryintimation.ue_save`, `w_expiryintimation.ue_newform`, `w_expiryintimation.ue_detail`, `w_expiryintimation.ue_newitem`, `w_expiryintimation.ue_deleteitem`, `w_expiryintimation.close`, `w_expiryintimation.ue_list`, `w_expiryintimation.ue_print`, `w_expiryintimation.ue_refreshddw`, `w_expiryintimation.ue_new`, `w_expiryintimation.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_focusqty`, `dw_itemsdetail.ue_dwnkey`, `tabpage_list.create`, `tabpage_list.destroy`, `em_invno.ue_downkey`, `ic_comport.ue_show`, `w_expiryintimation.wf_assigndatawindowobjects`, `w_expiryintimation.wf_closelist`, `w_expiryintimation.wf_deleteallemptydetailrows`, `w_expiryintimation.wf_fetchserverdate`, `w_expiryintimation.wf_findfullcode`, `w_expiryintimation.wf_genfullcode`, `w_expiryintimation.wf_getmaxdate`, `w_expiryintimation.wf_isinvoiceinuse`, `w_expiryintimation.wf_isposted`, `w_expiryintimation.wf_print`, `w_expiryintimation.wf_protectdw`, `w_expiryintimation.wf_setfocuswithscroll`, `w_expiryintimation.wf_validatefullcode`, `w_expiryintimation.wf_validateitem`, `w_expiryintimation.wf_validateitemnew`, `w_expiryintimation.wf_grandtotal`, `w_expiryintimation.wf_selectprintreport`, `w_expiryintimation.wf_post`, `w_expiryintimation.wf_inititeminfo`, `w_expiryintimation.wf_initmodify`, `w_expiryintimation.wf_populatedetail`, `w_expiryintimation.wf_gen_sale_incentive_sheet`, `w_expiryintimation.wf_gen_pur_incentive_sheet`, `w_expiryintimation.wf_delete_expiryintimation`, `w_expiryintimation.wf_lockintimation`, `w_expiryintimation.wf_gen_intimation_serialno`, `w_expiryintimation.wf_set_accountinfo`, `w_expiryintimation.wf_findacccode`, `w_expiryintimation.wf_get_possible_batch_expiry`, `w_expiryintimation.wf_consolidatedexpiryintimation`, `w_expiryintimation.wf_extractexpiryintimation`, `w_expiryintimation.wf_fetch_lasttransaction_info`, `w_expiryintimation.wf_populate_possiblebatchexpiry`, `w_expiryintimation.wf_push_expiryintimation_to_dropbox`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_detail.itemfocuschanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanging`, `dw_itemsdetail.editchanged`, `ic_comport.constructor`, `ic_drawerport.constructor`

Source: `recovered/scripts/expiryintimation/w_expiryintimation.pbs`
