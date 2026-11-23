# w_issue_request

- title: Issue Request
- library: issuereq (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 2959 x 1952 PBU
- reached from: Maintenance > Issue > Issue Request
- script size: 1619 lines; 18 events, 51 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_issuereqinvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_issuereqdetail`

## Data

- DataWindows: `d_deliveryorder_half`, `d_issuereqdetail`, `d_issuereqinvreport`, `d_itemstockinfo`, `d_quotationdetail`, `d_quotationheader`, `d_saletemplate_detail`
- tables touched by embedded SQL: customer, godown, godowndetail, groupallowedgodown, into, issuedetail, issuereqdetail, issuereqheader, item, itemcategory, itemsgroupcategory, saledetail, saleledger, supplier, usergroups
- stored procedures: deleteitemstockbatch, getitemavgprice, getitemstockbatch, getitemstocktotal, getmaxutn, postissuereq, saleupdateitemstockbatch, updateitemstockbatch
- global functions: f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_copysaleinvoicefrom, w_dueinfo, w_editquotationform, w_itemissuehistory, w_popup_partialsearch_selection, w_preview_invoices, w_previnvinfo, w_salesmanpassword, w_savesaleastemplate

## Events and functions

`w_issue_request.ue_printdo`, `w_issue_request.create`, `w_issue_request.destroy`, `w_issue_request.ue_save`, `w_issue_request.ue_newform`, `w_issue_request.ue_detail`, `w_issue_request.ue_newitem`, `w_issue_request.ue_deleteitem`, `w_issue_request.close`, `w_issue_request.ue_list`, `w_issue_request.ue_print`, `w_issue_request.ue_refreshddw`, `w_issue_request.ue_new`, `w_issue_request.ue_postopen`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `w_issue_request.wf_customerinfo`, `w_issue_request.wf_genfullcode`, `w_issue_request.wf_getmaxdate`, `w_issue_request.wf_getsalesstockinfo`, `w_issue_request.wf_savastemplate`, `w_issue_request.wf_validateitemnew`, `w_issue_request.wf_editquotation`, `w_issue_request.wf_dueitem`, `w_issue_request.wf_grandtotal`, `w_issue_request.wf_deletesaleinvoice`, `w_issue_request.wf_selectitembatches`, `w_issue_request.wf_returnsaleinvoice`, `w_issue_request.wf_assigndatawindowobjects`, `w_issue_request.wf_closelist`, `w_issue_request.wf_copyinvoice`, `w_issue_request.wf_getitemassociategcode`, `w_issue_request.wf_preinvinfo`, `w_issue_request.wf_print`, `w_issue_request.wf_protectdw`, `w_issue_request.wf_setiteminfo`, `w_issue_request.wf_setsaletype`, `w_issue_request.wf_setsuppinfo`, `w_issue_request.wf_retrievelist`, `w_issue_request.wf_retrievelistall`, `w_issue_request.wf_populatesaledetail`, `w_issue_request.wf_setgodownoption`, `w_issue_request.wf_initmodify`, `w_issue_request.wf_validateitem`, `w_issue_request.wf_updatesaleprice`, `w_issue_request.wf_validatefullcode`, `w_issue_request.wf_validategodown`, `w_issue_request.wf_visible`, `w_issue_request.wf_locksaleinvoices`, `w_issue_request.wf_locksaleinvoice`, `w_issue_request.wf_selectprintreport`, `w_issue_request.wf_findfullcode`, `w_issue_request.wf_post`, `w_issue_request.wf_allowissuemodification`, `w_issue_request.wf_inititeminfo`, `w_issue_request.wf_itemissuehistory`, `w_issue_request.wf_search_customer`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/issuereq/w_issue_request.pbs`
