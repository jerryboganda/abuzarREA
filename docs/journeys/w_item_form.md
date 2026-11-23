# w_item_form

- title: Item Form
- library: multientryitem (Shared framework & master data)
- ancestor: `w_multi_entry`
- size: 3039 x 2291 PBU
- reached from: Basic Data > Item .......... > Item
- script size: 1743 lines; 17 events, 38 functions

## Controls (7)

- `tab_retrieve` (tab_retrieve)
- `dw_itemassociation` (datawindow) dataobject `d_itemassociation`
- `dw_itemauthor` (u_dwstandard) dataobject `d_itemauthor`
- `dw_alternatealias` (datawindow) dataobject `d_alternateitemalias`
- `dw_itemimage` (u_dwstandard) dataobject `d_itemimage`
- `dw_pricepolicyheader` (u_dwstandard) dataobject `d_pricepolicyheader`
- `dw_pricepolicydetail` (u_dwstandard) dataobject `d_pricepolicydetail`

## Data

- DataWindows: `d_alternateitemalias`, `d_alternateitemaliasrequest`, `d_interfacesettingcols`, `d_interfacesettingcols_withallcolumns`, `d_item_list_groupitemcat`, `d_itemassociation`, `d_itemauthor`, `d_itemimage`, `d_itemlist`, `d_itemregrequest_detail`, `d_pricepolicydetail`, `d_pricepolicyheader`
- tables touched by embedded SQL: godowndetail, into, item, itemimage, itemnotes, itemregrequest, pricepolicy, quotationheader
- stored procedures: autocreatepricepolicy, checkuniquealiasname, checkunpostedtransactionofanitem, getitemstockall
- global functions: f_generateitemlog, f_getgroupcode, f_numberpreferences, f_rightexists, f_set_keyboard_english, f_set_keyboard_local, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_alternate_item_aliasname_form, w_arg_itemregrequest, w_item_form_notes, w_item_garments_wizard, w_item_pricepolicy_form, w_itemassociation_form, w_itemauthor_form, w_itemimage, w_iteminmodel_form, w_popup_comprehensicesearch_selection2, w_popup_responsivesearch_selection, w_salesmanpassword, w_selectitem_with_cat_setting, w_showunpostedtransactionreport, w_update_item_in_activequotations

## Events and functions

`w_item_form.ue_populate_newitem`, `w_item_form.create`, `w_item_form.destroy`, `w_item_form.ue_save`, `w_item_form.ue_detail`, `w_item_form.ue_newitem`, `w_item_form.ue_newform`, `w_item_form.ue_postopen`, `w_item_form.ue_list`, `w_item_form.open`, `tabpage_detail.create`, `tabpage_detail.destroy`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `rb_summary.clicked`, `rb_detail.clicked`, `dw_find.itemchanged`, `w_item_form.wf_duplicateitemno`, `w_item_form.wf_protectdw`, `w_item_form.wf_populate_ddlb`, `w_item_form.wf_populate_newitem`, `w_item_form.wf_retrievelistall`, `w_item_form.wf_validateitem`, `w_item_form.wf_selectmodels`, `w_item_form.wf_retrievelist`, `w_item_form.wf_set_item_association`, `w_item_form.wf_get_itemnotes`, `w_item_form.wf_insert_itemnotes`, `w_item_form.wf_set_itemnotes`, `w_item_form.wf_select_itemauthor`, `w_item_form.wf_invoke_graments_wizard`, `w_item_form.wf_select_alternateitemalias`, `w_item_form.wf_setimage`, `w_item_form.wf_get_itemimage`, `w_item_form.wf_populate_itemimage`, `w_item_form.wf_update_itemimage`, `w_item_form.wf_check_stock_and_unposted_trans`, `w_item_form.wf_show_unpostedtransactionreport`, `w_item_form.wf_select_itempricepolicy`, `w_item_form.wf_prepare_pricepolicy_for_saving`, `w_item_form.wf_duplicate_regno`, `w_item_form.wf_populate_itemregrequest`, `w_item_form.wf_update_item_in_activequotations`, `w_item_form.wf_update_activequtations_for_newitem`, `w_item_form.wf_set_changereason`, `dw_detail.itemerror`, `dw_detail.sqlpreview`, `dw_detail.itemfocuschanged`, `dw_detail.losefocus`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_find.keypressed`, `dw_find.editchanged`, `dw_find.itemerror`

Source: `recovered/scripts/multientryitem/w_item_form.pbs`
