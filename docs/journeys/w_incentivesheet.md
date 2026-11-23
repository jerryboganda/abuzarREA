# w_incentivesheet

- title: Incentive Sheet
- library: incentivesheet (Purchase & stock)
- ancestor: `w_multi_entry`
- size: 3141 x 2768 PBU
- reached from: (opened from code / other windows)
- script size: 1627 lines; 24 events, 39 functions

## Controls (6)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_incentivesheet_print`
- `ic_cashdrawerprinter` (olecustomcontrol)
- `ic_comport` (olecustomcontrol)
- `ic_drawerport` (olecustomcontrol)
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_incentivesheet_detail`

## Data

- DataWindows: `d_gen_pur_incentive_sheet`, `d_gen_sale_incentive_sheet`, `d_incentivesheet_detail`, `d_incentivesheet_print`, `d_post_incentivesheet`
- tables touched by embedded SQL: grouprights, incentivesheet, incentivesheetdetail, item, itemcategory, itemsgroupcategory, saleledger, usergroups
- stored procedures: createvoucher, lockincentivesheet
- global functions: f_drilldown_itemsearch, f_getglobalcode, f_getgroupcode, f_islicenseexpire, f_numberpreferences, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_cust_sdate_ldate, w_arg_grouping, w_arg_sinvcode_linvcode, w_arg_supp_sdate_ldate, w_preview_invoices, w_printer_copies, w_salesmanpassword, w_selection_manf_cat_class_packing

## Events and functions

`w_incentivesheet.ue_setitemfocus`, `w_incentivesheet.ue_enableprint`, `w_incentivesheet.create`, `w_incentivesheet.destroy`, `w_incentivesheet.ue_save`, `w_incentivesheet.ue_newform`, `w_incentivesheet.ue_detail`, `w_incentivesheet.ue_newitem`, `w_incentivesheet.ue_deleteitem`, `w_incentivesheet.close`, `w_incentivesheet.ue_list`, `w_incentivesheet.ue_print`, `w_incentivesheet.ue_refreshddw`, `w_incentivesheet.ue_new`, `w_incentivesheet.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_focusqty`, `dw_itemsdetail.ue_dwnkey`, `tabpage_list.create`, `tabpage_list.destroy`, `em_invno.ue_downkey`, `ic_comport.ue_show`, `w_incentivesheet.wf_assigndatawindowobjects`, `w_incentivesheet.wf_closelist`, `w_incentivesheet.wf_deleteallemptydetailrows`, `w_incentivesheet.wf_fetchserverdate`, `w_incentivesheet.wf_findfullcode`, `w_incentivesheet.wf_genfullcode`, `w_incentivesheet.wf_getmaxdate`, `w_incentivesheet.wf_isinvoiceinuse`, `w_incentivesheet.wf_isposted`, `w_incentivesheet.wf_print`, `w_incentivesheet.wf_protectdw`, `w_incentivesheet.wf_setfocuswithscroll`, `w_incentivesheet.wf_validatefullcode`, `w_incentivesheet.wf_validateitem`, `w_incentivesheet.wf_validateitemnew`, `w_incentivesheet.wf_grandtotal`, `w_incentivesheet.wf_selectprintreport`, `w_incentivesheet.wf_post`, `w_incentivesheet.wf_inititeminfo`, `w_incentivesheet.wf_initmodify`, `w_incentivesheet.wf_lockincentivedocument`, `w_incentivesheet.wf_populatedetail`, `w_incentivesheet.wf_deleteincentivesheet`, `w_incentivesheet.wf_gen_sale_incentive_sheet`, `w_incentivesheet.wf_gen_pur_incentive_sheet`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanging`, `dw_itemsdetail.editchanged`, `ic_comport.constructor`, `ic_drawerport.constructor`

Source: `recovered/scripts/incentivesheet/w_incentivesheet.pbs`
