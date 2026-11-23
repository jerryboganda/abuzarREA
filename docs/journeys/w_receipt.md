# w_receipt

- title: Receipt
- library: receiptcomponents (Accounts & cash)
- ancestor: `w_multi_entry`
- size: 3024 x 2304 PBU
- reached from: (opened from code / other windows)
- script size: 3906 lines; 26 events, 70 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_purinvrep` (u_dwstandard) dataobject `d_receiptinvreport_half`

## Data

- DataWindows: `d_SaleOrderheader`, `d_general1`, `d_groupallowedmoduleheader`, `d_groupitemreceiptexptemplate_detail`, `d_issueheader`, `d_populate_issue_in_receipt`, `d_purchaseorderdetail`, `d_receiptdetail`, `d_receiptheader`, `d_receiptinvreport_half`, `d_receiptno`, `d_saleorderdetail_receipt_retrieve`, `d_saleorderdetail_sale_population`, `ddd_issueinvitems`
- tables touched by embedded SQL: godown, godowndetail, groupallowedgodown, issueheader, item, itemcategory, itemclass, itemimage, itemsgroupcategory, manufacturer, motorvehicle, prodheader, purorderheader, receiptcategory, receiptdetail, receiptheader, supplier, usergroups, workorder
- stored procedures: create, getallowedgroupcustomercategory, getfirstitemimagedetail, getitemavgprice, getitemstockall, getitemstockbatch, getitemstockinallowedgodown, getitemstocktotal, getitemtotalpiecesinhand, getmaxutn, markissueaspulled, marksaleinvoiceaspulled, updateactivitymonitor, updateitemavgprice, updateitemstockbatch, updateitemtotalpiecesinhand
- global functions: f_check_for_basicdata_sync, f_datepreferences, f_drilldown_itemsearch, f_fetch_sites, f_generateheaderinvcode, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_rightexists, f_setcolumnstyle, f_stringpreferences, f_validatedw, f_writeimgtofile
- windows opened: w_arg_item_batch_generation_receipt, w_arg_sinvcode_linvcode, w_edit_issue_posted, w_editpurchaseorderform, w_editsaleorder_in_receipt_form, w_itempurchasehistory, w_motorvehicle, w_passport_form_popup, w_populate_sale_from_datacarrydb, w_pref_get_date, w_pref_get_datetime, w_pref_get_decimal, w_pref_get_dropdown, w_pref_get_long, w_pref_get_password, w_pref_get_text, w_pref_get_text2, w_preview_invoices, w_pull_issue_from_dropbox, w_pull_sale_from_dropbox, w_salesmanpassword, w_selectformat_sale_receipt, w_vehiclesearch, w_vehiclesearchresult

## Events and functions

`w_receipt.ue_set_requiredcolumns`, `w_receipt.ue_populate_from_datacarrydb`, `w_receipt.ue_populate_and_post_from_datacarrydb`, `w_receipt.ue_pull_sale_from_dropbox`, `w_receipt.ue_pull_issue_from_dropbox`, `w_receipt.create`, `w_receipt.destroy`, `w_receipt.ue_save`, `w_receipt.ue_newform`, `w_receipt.ue_detail`, `w_receipt.ue_newitem`, `w_receipt.ue_deleteitem`, `w_receipt.close`, `w_receipt.ue_new`, `w_receipt.ue_list`, `w_receipt.ue_refreshddw`, `w_receipt.ue_print`, `w_receipt.ue_postopen`, `w_receipt.open`, `w_receipt.ue_callback_popupwindow`, `dw_footer.itemchanged`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_dwnkey`, `w_receipt.wf_validateitem`, `w_receipt.wf_retrievelistall`, `w_receipt.wf_assigndatawindowobjects`, `w_receipt.wf_genfullcode`, `w_receipt.wf_getpomanfcode`, `w_receipt.wf_grandtotal`, `w_receipt.wf_iteminfo`, `w_receipt.wf_protectdw`, `w_receipt.wf_releaselock`, `w_receipt.wf_retrievelist`, `w_receipt.wf_selectprintreport`, `w_receipt.wf_setpurchasetype`, `w_receipt.wf_setpurorderinfo`, `w_receipt.wf_setsuppinfo`, `w_receipt.wf_updateitemavgprice`, `w_receipt.wf_updateitempurprice`, `w_receipt.wf_updateitemstock`, `w_receipt.wf_updaterecentpurprice`, `w_receipt.wf_validatefullcode`, `w_receipt.wf_post`, `w_receipt.wf_setgodownoption`, `w_receipt.wf_initmodify`, `w_receipt.wf_findfullcode`, `w_receipt.wf_setiteminfo`, `w_receipt.wf_setitemprice`, `w_receipt.wf_allowreceiptmodification`, `w_receipt.wf_inititeminfo`, `w_receipt.wf_itemstockinfo`, `w_receipt.wf_post_receipt`, `w_receipt.wf_saveandpost`, `w_receipt.wf_duplicate_batch_in_receipt`, `w_receipt.wf_generatebatches`, `w_receipt.wf_itempurchasehistory`, `w_receipt.wf_populate_saleorder`, `w_receipt.wf_populatedetaildwfrompo`, `w_receipt.wf_open_item_form_popup`, `w_receipt.wf_validateworkorder`, `w_receipt.wf_item_image_setting`, `w_receipt.wf_set_itemimage`, `w_receipt.wf_populate_issue`, `w_receipt.wf_deleteallemptydetailrows`, `w_receipt.wf_update_manfdate`, `w_receipt.wf_autoreplacebatches`, `w_receipt.wf_get_preference`, `w_receipt.wf_genenerate_receiptcategory_counter`, `w_receipt.wf_lockinvoice`, `w_receipt.wf_lockinvoices`, `w_receipt.wf_lockreceiptinvoices`, `w_receipt.wf_set_itemexpense_interface`, `w_receipt.wf_motorvehicle_retrieve`, `w_receipt.wf_find_motorvehiclecode`, `w_receipt.wf_motorvehiclesearch`, `w_receipt.wf_set_motorvehicleinfo`, `w_receipt.wf_new_motorvehicle`, `w_receipt.wf_setitemslist`, `w_receipt.wf_itemslistcolvisibility`, `w_receipt.wf_validate_issue`, `w_receipt.wf_itemprevqty`, `w_receipt.wf_oninvoiceitemprevqty`, `w_receipt.wf_validate_receipt_on_saving`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/receiptcomponents/w_receipt.pbs`
