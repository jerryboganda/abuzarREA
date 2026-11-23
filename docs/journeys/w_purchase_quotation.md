# w_purchase_quotation

- title: Purchase Quotation
- library: quotation (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3076 x 2224 PBU
- reached from: (opened from code / other windows)
- script size: 1583 lines; 19 events, 49 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (datawindow) dataobject `d_purquotation_full`

## Data

- DataWindows: `d_deliveryorder_half`, `d_husnainmedicine_purquotationinvreport`, `d_purquotation_full`, `d_purquotation_half`, `d_purquotation_quarter`, `d_saleinvinfo`, `d_saletemplate_detail`
- tables touched by embedded SQL: accounts, godown, groupallowedgodown, into, item, itemcategory, itemsgroupcategory, purquotationdetail, purquotationheader, saleledger, supplier, usergroups
- stored procedures: getitemstockall, getitemstocktotal, mark_purquotation_active_inactive
- global functions: f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_copysaleinvoicefrom, w_popup_partialsearch_selection, w_preview_invoices, w_previnvinfo, w_quotationremarks, w_salesmanpassword, w_savesaleastemplate

## Events and functions

`w_purchase_quotation.ue_printdo`, `w_purchase_quotation.ue_enableprint`, `w_purchase_quotation.create`, `w_purchase_quotation.destroy`, `w_purchase_quotation.ue_save`, `w_purchase_quotation.ue_newform`, `w_purchase_quotation.ue_detail`, `w_purchase_quotation.ue_newitem`, `w_purchase_quotation.ue_deleteitem`, `w_purchase_quotation.close`, `w_purchase_quotation.ue_list`, `w_purchase_quotation.ue_print`, `w_purchase_quotation.ue_refreshddw`, `w_purchase_quotation.ue_new`, `w_purchase_quotation.ue_postopen`, `w_purchase_quotation.open`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `w_purchase_quotation.wf_print`, `w_purchase_quotation.wf_preinvinfo`, `w_purchase_quotation.wf_assigndatawindowobjects`, `w_purchase_quotation.wf_closelist`, `w_purchase_quotation.wf_copyinvoice`, `w_purchase_quotation.wf_deleteinvoice`, `w_purchase_quotation.wf_findfullcode`, `w_purchase_quotation.wf_genfullcode`, `w_purchase_quotation.wf_getitemassociategcode`, `w_purchase_quotation.wf_getmaxdate`, `w_purchase_quotation.wf_inititeminfo`, `w_purchase_quotation.wf_initmodify`, `w_purchase_quotation.wf_search_customer`, `w_purchase_quotation.wf_setgodownoption`, `w_purchase_quotation.wf_setremarks`, `w_purchase_quotation.wf_updatesaleprice`, `w_purchase_quotation.wf_validatefullcode`, `w_purchase_quotation.wf_validategodown`, `w_purchase_quotation.wf_validateitem`, `w_purchase_quotation.wf_validateitemnew`, `w_purchase_quotation.wf_visible`, `w_purchase_quotation.wf_protectdw`, `w_purchase_quotation.wf_retrievelist`, `w_purchase_quotation.wf_retrievelistall`, `w_purchase_quotation.wf_savastemplate`, `w_purchase_quotation.wf_grandtotal`, `w_purchase_quotation.wf_supplierinfo`, `w_purchase_quotation.wf_setsuppname`, `w_purchase_quotation.wf_findsuppcode`, `w_purchase_quotation.wf_lockquotationinvoice`, `w_purchase_quotation.wf_lockquotationinvoices`, `w_purchase_quotation.wf_post`, `w_purchase_quotation.wf_allowquotationmodification`, `w_purchase_quotation.wf_setiteminfo`, `w_purchase_quotation.wf_selectprintreport`, `w_purchase_quotation.wf_markactiveinactive`, `w_purchase_quotation.wf_unpost`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_detail.itemfocuschanged`, `dw_detail.editchanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/quotation/w_purchase_quotation.pbs`
