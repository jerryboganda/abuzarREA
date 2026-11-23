# w_sale_modified

- title: Cash Sale
- library: salemodified (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 3076 x 2700 PBU
- reached from: Maintenance > Copied Sale Invoices > Edit Copied Credit Sale Invoices; Maintenance > Copied Sale Invoices > Edit Copied Cash Sale Invoices
- script size: 4075 lines; 28 events, 80 functions

## Controls (6)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_retailsaleinvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_saledetail`
- `ic_cashdrawerprinter` (olecustomcontrol)
- `ic_comport` (olecustomcontrol)
- `ic_drawerport` (olecustomcontrol)

## Data

- DataWindows: `d_customerbalances_in_sales`, `d_deliveryorder_batchexpiry_half`, `d_deliveryorder_half`, `d_groupallowedmoduleheader`, `d_itemstockinfo`, `d_marshal_deliveryorder_full`, `d_marshal_deliveryorder_half`, `d_quotationdetail`, `d_quotationheader`, `d_retailsaleinvreport`, `d_sah_deliveryorder_full`, `d_saledetail`, `d_saleinvinfo`, `d_wholesaleHeader`
- tables touched by embedded SQL: accounts, customer, godown, godowndetail, groupallowedgodown, into, item, itemcategory, itemsgroupcategory, patient, patientcatallowedmodule, saledetail, saledetailmodified, saleledger, saleledgermodified, softwarepreferences, supplier, usergroups
- stored procedures: absoluteopeningbalance, getcustwiselatestitemsale, getglobalcode, getitemavgprice, getitemstockall, getitemstockbatch, getitemstocktotal, postsaleledger, updateitemstockbatch, virtualgl
- global functions: f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_setcolumnstyle, f_stringpreferences, f_validatedw, f_writeimgtofile
- windows opened: w_arg_cust_sinvcode_linvcode, w_arg_sinvcode_linvcode, w_arg_sinvcode_linvcode_cust_v4, w_arg_sinvcode_linvcode_disc_salemod, w_copysaleinvformodifiedsale, w_customerinfo, w_dueinfo, w_editquotationform, w_iteminfo, w_itemsalehistory, w_patientregistration, w_popup_areaselection, w_popup_customerselectionareawise, w_popup_itempriority_settings, w_preview_invoices, w_previnvinfo, w_printer_copies, w_salesmanpassword, w_salesmanpassword_invtype, w_savesaleastemplate, w_view_saleheader

## Events and functions

`w_sale_modified.ue_printdo`, `w_sale_modified.ue_enableprint`, `w_sale_modified.create`, `w_sale_modified.destroy`, `w_sale_modified.ue_save`, `w_sale_modified.ue_newform`, `w_sale_modified.ue_detail`, `w_sale_modified.ue_newitem`, `w_sale_modified.ue_deleteitem`, `w_sale_modified.close`, `w_sale_modified.ue_list`, `w_sale_modified.ue_print`, `w_sale_modified.ue_refreshddw`, `w_sale_modified.ue_new`, `w_sale_modified.ue_postopen`, `w_sale_modified.open`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.ue_focuscustomer`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `dw_itemsdetail.ue_enterkey`, `dw_itemsdetail.ue_focusqty`, `dw_itemsdetail.ue_dwnkey`, `tabpage_list.create`, `tabpage_list.destroy`, `em_invno.ue_downkey`, `ic_comport.ue_show`, `w_sale_modified.wf_getmaxdate`, `w_sale_modified.wf_savastemplate`, `w_sale_modified.wf_getitemassociategcode`, `w_sale_modified.wf_deletesaleinvoice`, `w_sale_modified.wf_preinvinfo`, `w_sale_modified.wf_setsuppinfo`, `w_sale_modified.wf_updatesaleprice`, `w_sale_modified.wf_validateitemnew`, `w_sale_modified.wf_closelist`, `w_sale_modified.wf_genfullcode`, `w_sale_modified.wf_print`, `w_sale_modified.wf_findpatientcode`, `w_sale_modified.wf_setsaletype`, `w_sale_modified.wf_visibleinvisiblediscount`, `w_sale_modified.wf_customermessagevalidation`, `w_sale_modified.wf_validatefullcode`, `w_sale_modified.wf_returnsaleinvoice`, `w_sale_modified.wf_dueitem`, `w_sale_modified.wf_protectdw`, `w_sale_modified.wf_visible`, `w_sale_modified.wf_itemnetprice`, `w_sale_modified.wf_populate_ddlb`, `w_sale_modified.wf_grandtotal`, `w_sale_modified.wf_assigndatawindowobjects`, `w_sale_modified.wf_setiteminfo`, `w_sale_modified.wf_validategodown`, `w_sale_modified.wf_findcustcode`, `w_sale_modified.wf_selectcustomerareawise`, `w_sale_modified.wf_allowsalemodification`, `w_sale_modified.wf_setcustomer`, `w_sale_modified.wf_setcustomername`, `w_sale_modified.wf_itemsalehistory`, `w_sale_modified.wf_getcustomerinfo`, `w_sale_modified.wf_setnormalsale`, `w_sale_modified.wf_setgodownoption`, `w_sale_modified.wf_validateitem`, `w_sale_modified.wf_editquotation`, `w_sale_modified.wf_customerinfo`, `w_sale_modified.wf_retrievelistall`, `w_sale_modified.wf_retrievelist`, `w_sale_modified.wf_setitemdataoncustlatestsale`, `w_sale_modified.wf_inititeminfo`, `w_sale_modified.wf_setcustomerinfo`, `w_sale_modified.wf_populatesaledetail`, `w_sale_modified.wf_copyinvoice`, `w_sale_modified.wf_setrowgroup`, `w_sale_modified.wf_post`, `w_sale_modified.wf_findfullcode`, `w_sale_modified.wf_viewheader`, `w_sale_modified.wf_patient_retrieve`, `w_sale_modified.wf_new_patientregistration`, `w_sale_modified.wf_initmodify`, `w_sale_modified.wf_locksaleinvoices`, `w_sale_modified.wf_allowinvoice`, `w_sale_modified.wf_locksaleinvoice`, `w_sale_modified.wf_isinvoiceinuse`, `w_sale_modified.wf_getsalesstockinfo`, `w_sale_modified.wf_selectitembatches`, `w_sale_modified.wf_selectprintreport`, `w_sale_modified.wf_set_itemtotal_formatmask`, `w_sale_modified.wf_view_iteminfo`, `w_sale_modified.wf_update_invprice_with_selected_price`, `w_sale_modified.wf_update_itemdiscperc_for_rangeinv`, `w_sale_modified.wf_setimgonprint`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_detail.editchanged`, `dw_detail.itemfocuschanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`, `dw_itemsdetail.rowfocuschanging`, `dw_itemsdetail.editchanged`, `ic_comport.constructor`, `ic_drawerport.constructor`

Source: `recovered/scripts/salemodified/w_sale_modified.pbs`
