# w_itemsuppliers_form

- title: Supplier Wise Item Settings
- library: multientryitem (Shared framework & master data)
- ancestor: `w_multi_entry`
- size: 2948 x 2077 PBU
- reached from: (opened from code / other windows)
- script size: 1475 lines; 18 events, 52 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_godownitem_setting_rep`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_godownitem_setting_detail`

## Data

- DataWindows: `d_deliveryorder_half`, `d_godownitem_setting_detail`, `d_godownitem_setting_rep`, `d_issuereqdetail`, `d_issuereqheader`, `d_itemstockinfo`, `d_itemsuppliers`, `d_populate_itemsuppliers`, `d_populate_purchase_itemsuppliers`, `d_quotationdetail`, `d_quotationheader`
- tables touched by embedded SQL: customer, godown, godowndetail, groupallowedgodown, into, issuedetail, issueheader, item, itemcategory, itemsgroupcategory, itemsuppliers, saledetail, saleledger, supplier, usergroups
- stored procedures: getitemavgprice, getitemstockbatch, updateitemstockbatch
- global functions: f_newtableid, f_stringpreferences, f_validatedw
- windows opened: w_arg_manufacturers_v2, w_arg_sdate_ldate, w_arg_sinvcode_linvcode, w_copyissueinvoicefrom, w_editquotationform, w_previnvinfo, w_salesmanpassword, w_savesaleastemplate, w_setquantity, w_viewitemsuppliers

## Events and functions

`w_itemsuppliers_form.ue_printdo`, `w_itemsuppliers_form.create`, `w_itemsuppliers_form.destroy`, `w_itemsuppliers_form.ue_save`, `w_itemsuppliers_form.ue_newform`, `w_itemsuppliers_form.ue_detail`, `w_itemsuppliers_form.ue_newitem`, `w_itemsuppliers_form.ue_deleteitem`, `w_itemsuppliers_form.close`, `w_itemsuppliers_form.ue_list`, `w_itemsuppliers_form.ue_print`, `w_itemsuppliers_form.ue_refreshddw`, `w_itemsuppliers_form.ue_new`, `w_itemsuppliers_form.ue_postopen`, `w_itemsuppliers_form.open`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `w_itemsuppliers_form.wf_customerinfo`, `w_itemsuppliers_form.wf_visible`, `w_itemsuppliers_form.wf_genfullcode`, `w_itemsuppliers_form.wf_getmaxdate`, `w_itemsuppliers_form.wf_savastemplate`, `w_itemsuppliers_form.wf_validateitemnew`, `w_itemsuppliers_form.wf_editquotation`, `w_itemsuppliers_form.wf_dueitem`, `w_itemsuppliers_form.wf_deletesaleinvoice`, `w_itemsuppliers_form.wf_selectprintreport`, `w_itemsuppliers_form.wf_returnsaleinvoice`, `w_itemsuppliers_form.wf_assigndatawindowobjects`, `w_itemsuppliers_form.wf_closelist`, `w_itemsuppliers_form.wf_getitemassociategcode`, `w_itemsuppliers_form.wf_locksaleinvoice`, `w_itemsuppliers_form.wf_locksaleinvoices`, `w_itemsuppliers_form.wf_post`, `w_itemsuppliers_form.wf_preinvinfo`, `w_itemsuppliers_form.wf_print`, `w_itemsuppliers_form.wf_setsaletype`, `w_itemsuppliers_form.wf_setsuppinfo`, `w_itemsuppliers_form.wf_updatesaleprice`, `w_itemsuppliers_form.wf_validatefullcode`, `w_itemsuppliers_form.wf_validategodown`, `w_itemsuppliers_form.wf_retrievelist`, `w_itemsuppliers_form.wf_retrievelistall`, `w_itemsuppliers_form.wf_selectitembatches`, `w_itemsuppliers_form.wf_copyinvoice`, `w_itemsuppliers_form.wf_setgodownoption`, `w_itemsuppliers_form.wf_grandtotal`, `w_itemsuppliers_form.wf_initmodify`, `w_itemsuppliers_form.wf_protectdw`, `w_itemsuppliers_form.wf_validateitem`, `w_itemsuppliers_form.wf_findfullcode`, `w_itemsuppliers_form.wf_inititeminfo`, `w_itemsuppliers_form.wf_setqty`, `w_itemsuppliers_form.wf_allowissuemodification`, `w_itemsuppliers_form.wf_populateitems`, `w_itemsuppliers_form.wf_viewitemsuppliers`, `w_itemsuppliers_form.wf_getsalesstockinfo`, `w_itemsuppliers_form.wf_setiteminfo`, `w_itemsuppliers_form.wf_populate_supplier_purchaseitem`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/multientryitem/w_itemsuppliers_form.pbs`
