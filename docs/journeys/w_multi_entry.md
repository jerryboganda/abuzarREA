# w_multi_entry

- title: Multi Entry Base Window
- library: components (Shared framework & master data)
- ancestor: `w_entry_primitives`
- size: 3076 x 2301 PBU
- reached from: (opened from code / other windows)
- script size: 1871 lines; 57 events, 58 functions

## Controls (1)

- `tab_retrieve` (tab)

## Data

- DataWindows: -
- tables touched by embedded SQL: grouprights, item
- stored procedures: getaliasname_withqtyprice, getservice_aliasname
- global functions: f_binarysearch, f_binarysearch_date, f_binarysearch_long, f_binarysearch_string, f_binarysearchdesc_long, f_drilldown_itemsearch, f_getgroupcode, f_refreshitemlist, f_show_item_gallary, f_show_patient_gallary, f_stringpreferences, f_validatedw
- windows opened: w_arg_item_populate4, w_arg_manf_category_class_pack_oneorall, w_choose_itemcategory, w_group_itemcat_aliasname_range, w_popup_comprehensicesearch_selection, w_popup_comprehensicesearch_selection2, w_popup_criteriaselection, w_popup_criteriavaluesselection, w_popup_itemsearchcriteriaselection, w_popup_responsivesearch_selection, w_restoreitem, w_selectformat_itemrefreshtype

## Events and functions

`w_multi_entry.ue_getfocus`, `w_multi_entry.ue_newitem`, `w_multi_entry.ue_deleteitem`, `w_multi_entry.ue_refreshddw`, `w_multi_entry.ue_refreshddw_catwise`, `w_multi_entry.ue_deleteitem_row`, `w_multi_entry.ue_refreshddw_customize`, `w_multi_entry.ue_scrolltorow`, `w_multi_entry.ue_refreshddw_stockitemsonly`, `w_multi_entry.ue_refreshddw_itemname`, `w_multi_entry.ue_refreshddw_drilldown`, `w_multi_entry.ue_restoreitem`, `w_multi_entry.create`, `w_multi_entry.destroy`, `w_multi_entry.open`, `w_multi_entry.ue_detail`, `w_multi_entry.ue_list`, `w_multi_entry.ue_new`, `w_multi_entry.ue_retrieve`, `w_multi_entry.ue_save`, `w_multi_entry.ue_first`, `w_multi_entry.ue_last`, `w_multi_entry.ue_next`, `w_multi_entry.ue_previous`, `w_multi_entry.ue_newform`, `w_multi_entry.ue_exit`, `w_multi_entry.closequery`, `w_multi_entry.close`, `w_multi_entry.ue_postopen`, `tab_retrieve.ue_losefocus`, `tab_retrieve.create`, `tab_retrieve.destroy`, `tab_retrieve.key`, `tabpage_detail.ue_focusfooter`, `tabpage_detail.ue_focusheader`, `tabpage_detail.ue_focusdetail`, `tabpage_detail.create`, `tabpage_detail.destroy`, `dw_footer.ue_enterkey`, `dw_footer.itemchanged`, `dw_footer.ue_dwnkey`, `dw_detail.ue_enterkey`, `dw_detail.itemchanged`, `dw_itemsdetail.ue_restore`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_focusqty`, `dw_itemsdetail.ue_findnext`, `dw_itemslist.clicked`, `tabpage_list.create`, `tabpage_list.destroy`, `rb_ascending.clicked`, `rb_descending.clicked`, `cb_filter.clicked`, `dw_list.clicked`, `cb_retrieve.clicked`, `w_multi_entry.wf_sortdw`, `w_multi_entry.wf_setmenu`, `w_multi_entry.wf_grandtotal`, `w_multi_entry.wf_confirm_changes`, `w_multi_entry.wf_getitemname`, `w_multi_entry.wf_disconnect`, `w_multi_entry.wf_retrievelist`, `w_multi_entry.wf_retrievelistall`, `w_multi_entry.wf_filter`, `w_multi_entry.wf_selectunselectrow`, `w_multi_entry.wf_disabledetailtab`, `w_multi_entry.wf_showlist`, `w_multi_entry.wf_validatedate`, `w_multi_entry.wf_populate_ddlb`, `w_multi_entry.wf_deleteemptydetailrow`, `w_multi_entry.wf_refreshitemslist`, `w_multi_entry.wf_refreshitemslist_catwise`, `w_multi_entry.wf_iseditable`, `w_multi_entry.wf_connect`, `w_multi_entry.wf_group_itemcat_aliasname_range`, `w_multi_entry.wf_commitform`, `w_multi_entry.wf_refreshitemslist_customize`, `w_multi_entry.wf_searchitem_quicksearch`, `w_multi_entry.wf_refreshitemslist_stockitemsonly`, `w_multi_entry.wf_set_itemtotal_formatmask`, `w_multi_entry.wf_editpostedinvoice`, `w_multi_entry.wf_refreshitemslist_itemname`, `w_multi_entry.wf_refreshitemslist_drilldown`, `w_multi_entry.wf_set_itemcodetype`, `w_multi_entry.wf_retrievelist_datelimit`, `w_multi_entry.wf_show_itemgallery`, `w_multi_entry.wf_comprehensive_search`, `w_multi_entry.wf_show_patientgallery`, `w_multi_entry.wf_findfullcode`, `w_multi_entry.wf_find_service_fullcode`, `w_multi_entry.wf_check_module_rights`, `w_multi_entry.activate`, `tab_retrieve.selectionchanging`, `tab_retrieve.selectionchanged`, `dw_footer.editchanged`, `dw_footer.itemfocuschanged`, `dw_footer.getfocus`, `dw_detail.editchanged`, `dw_detail.itemfocuschanged`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.itemerror`, `ddlb_sort.selectionchanged`, `ddlb_filter_column.selectionchanged`, `ddlb_op.selectionchanged`, `ddlb_data.selectionchanged`, `dw_list.doubleclicked`, `dw_list.itemfocuschanged`, `dw_list.getfocus`, `dw_find.keypressed`, `dw_find.editchanged`

Source: `recovered/scripts/components/w_multi_entry.pbs`
