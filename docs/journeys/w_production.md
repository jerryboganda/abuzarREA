# w_production

- title: Production
- library: issuereq (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3032 x 2029 PBU
- reached from: (opened from code / other windows)
- script size: 1949 lines; 18 events, 55 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_productioninvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_productiondetail`

## Data

- DataWindows: `d_deliveryorder_half`, `d_itemstockinfo`, `d_productiondetail`, `d_productioninvreport`, `d_quotationdetail`, `d_quotationheader`, `d_saletemplate_detail`
- tables touched by embedded SQL: customer, godown, godowndetail, groupallowedgodown, into, issuedetail, issueheader, issuereqdetail, item, itemcategory, itemsgroupcategory, prodheader, receiptheader, recipe, saledetail, saleledger, supplier, usergroups
- stored procedures: deleteitemstockbatch, finalize_production, getitemavgprice, getitemstockbatch, getitemstockinallowedgodown, getitemstocktotal, getmaxutn, postissue_from_production, postproduction, postreceipt_from_production, saleupdateitemstockbatch, updateactivitymonitor, updateitemstockbatch
- global functions: f_datepreferences, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_rightexists, f_setcolumnformat, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_copysaleinvoicefrom, w_dueinfo, w_editquotationform, w_popup_comprehensicesearch_selection2, w_preview_invoices, w_previnvinfo, w_prodbuffer, w_salesmanpassword, w_savesaleastemplate

## Events and functions

`w_production.ue_printdo`, `w_production.ue_enableprint`, `w_production.create`, `w_production.destroy`, `w_production.ue_save`, `w_production.ue_newform`, `w_production.ue_detail`, `w_production.ue_newitem`, `w_production.ue_deleteitem`, `w_production.close`, `w_production.ue_list`, `w_production.ue_print`, `w_production.ue_refreshddw`, `w_production.ue_new`, `w_production.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `w_production.wf_customerinfo`, `w_production.wf_genfullcode`, `w_production.wf_getmaxdate`, `w_production.wf_savastemplate`, `w_production.wf_validateitemnew`, `w_production.wf_editquotation`, `w_production.wf_dueitem`, `w_production.wf_grandtotal`, `w_production.wf_deletesaleinvoice`, `w_production.wf_selectitembatches`, `w_production.wf_returnsaleinvoice`, `w_production.wf_assigndatawindowobjects`, `w_production.wf_closelist`, `w_production.wf_copyinvoice`, `w_production.wf_getitemassociategcode`, `w_production.wf_preinvinfo`, `w_production.wf_print`, `w_production.wf_protectdw`, `w_production.wf_setiteminfo`, `w_production.wf_setsaletype`, `w_production.wf_setsuppinfo`, `w_production.wf_retrievelist`, `w_production.wf_retrievelistall`, `w_production.wf_populatesaledetail`, `w_production.wf_setgodownoption`, `w_production.wf_initmodify`, `w_production.wf_validateitem`, `w_production.wf_updatesaleprice`, `w_production.wf_validatefullcode`, `w_production.wf_validategodown`, `w_production.wf_visible`, `w_production.wf_selectprintreport`, `w_production.wf_post`, `w_production.wf_allowissuemodification`, `w_production.wf_inititeminfo`, `w_production.wf_retrieve_itemslist`, `w_production.wf_getsalesstockinfo`, `w_production.wf_findfullcode`, `w_production.wf_finalize`, `w_production.wf_lock_production`, `w_production.wf_lock_productions`, `w_production.wf_postissue`, `w_production.wf_postreceipt`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.editchanged`, `dw_find.keypressed`

Source: `recovered/scripts/issuereq/w_production.pbs`
