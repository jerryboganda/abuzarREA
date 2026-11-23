# w_saletemplate

- title: Sale Template
- library: templates (Application shell & settings)
- ancestor: `w_multi_entry`
- size: 3077 x 1880 PBU
- reached from: Basic Data > Sale Template
- script size: 1683 lines; 15 events, 23 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_analyzerprint` (datawindow)

## Data

- DataWindows: `d_adjust_saletemplate_wrt_stock`, `d_groupallowedmoduleheader`, `d_populateditems_active_stockitems`, `d_populateditems_and_active_stockitems`, `d_saletemplate_report`, `d_saletemplate_report_alhaqcorp`, `d_saletemplate_report_alhaqcorp2`
- tables touched by embedded SQL: godowndetail, grouprights, item, itemcategory, itemsgroupcategory, saletemplatedetail, saletemplateheader, usergroups
- stored procedures: generateautosale, generatemarkedsalefromtemplate, getitemstockall, getitemstocktotal, importsales, templatemarking
- global functions: f_get_colprecision, f_getgroupcode, f_newtableid, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_tostring, f_validatedw
- windows opened: w_arg_godown_sdate_ldate_v1, w_arg_grouping, w_arg_item_populate2, w_arg_only_decimal_input, w_arg_percentage_reduce_raise, w_arg_sdate_ldate, w_preview_invoices, w_saletemplate_saleestimates, w_select_templateanalyzer, w_select_templatemanipulator, w_selectformat_summary_detail, w_selection_manf_cat_class_packing, w_setgstperc, w_templatemanipulater_cust_sdate_ldate

## Events and functions

`w_saletemplate.ue_enableprint`, `w_saletemplate.ue_print_2`, `w_saletemplate.create`, `w_saletemplate.destroy`, `w_saletemplate.ue_save`, `w_saletemplate.ue_detail`, `w_saletemplate.ue_newitem`, `w_saletemplate.ue_postopen`, `w_saletemplate.ue_print`, `w_saletemplate.ue_list`, `w_saletemplate.ue_newform`, `tabpage_detail.create`, `tabpage_detail.destroy`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `w_saletemplate.wf_duplicatename`, `w_saletemplate.wf_inititeminfo`, `w_saletemplate.wf_validateitem`, `w_saletemplate.wf_isinvoiceinuse`, `w_saletemplate.wf_generatesale`, `w_saletemplate.wf_findfullcode`, `w_saletemplate.wf_updateprices`, `w_saletemplate.wf_deleteemptydetailrows`, `w_saletemplate.wf_populatefiltereditems`, `w_saletemplate.wf_grandtotal`, `w_saletemplate.wf_filteritems`, `w_saletemplate.wf_updatesaleprice_basicdata`, `w_saletemplate.wf_set_gstperc`, `w_saletemplate.wf_import_sales`, `w_saletemplate.wf_launch_analyzer`, `w_saletemplate.wf_launch_manipulator`, `w_saletemplate.wf_generate_sales_from_marked_items`, `w_saletemplate.wf_adjust_template_wrt_stock`, `w_saletemplate.wf_adjust_template_wrt_saleestimates`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanged`

Source: `recovered/scripts/templates/w_saletemplate.pbs`
