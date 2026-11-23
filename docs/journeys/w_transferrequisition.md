# w_transferrequisition

- title: Inter Godown Transfer Requisition
- library: transfer (Application shell & settings)
- ancestor: `w_multi_entry`
- size: 3046 x 3469 PBU
- reached from: (opened from code / other windows)
- script size: 2591 lines; 27 events, 50 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_transferinvreport_full`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_transferrequisition_detail`

## Data

- DataWindows: `d_IssueReqdetail_temp`, `d_OpenWholeSaleReturnDetail`, `d_WholeSaleDetail`, `d_alnaseeb_transferrequisition_print`, `d_godownwise_consumption`, `d_godownwise_itemreorder`, `d_greorderdetail`, `d_greorderdetail_and`, `d_groupallowedmoduleheader`, `d_item_transferqty`, `d_loosepurchasedetail`, `d_normalpurchasedetail`, `d_quart_transferrequisition_invreport`, `d_saletemplate_detail`, `d_sourcebasedtransfer`, `d_sourcebasedtransfer_and`, `d_transfer_detail`, `d_transferinfo`, `d_transferinvreport_full`, `d_transferrequisition_detail`, `ddd_sourcegodownitems`, `ddd_sourcegodownitems_cat`
- tables touched by embedded SQL: customer, godown, godowndetail, godownitemsetting, groupallowedgodown, into, item, itemcategory, itemsgroupcategory, saleledger, supplier, transferrequisitionheader, usergroups
- stored procedures: getitemreqqtyfortransfer, getitemstocktotal, locksaleinvoice
- global functions: f_drilldown_itemsearch, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_numberpreferences, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_categories_transfer, w_arg_item_populate2, w_arg_item_populate_all_withoutgodown, w_arg_sinvcode_linvcode, w_copysaleinvoicefrom, w_popup_itempriority_settings, w_preview_invoices, w_printer_copies, w_salesmanpassword, w_savesaleastemplate, w_sourcebasedtransfer_stockperc, w_transfer_itemlist

## Events and functions

`w_transferrequisition.ue_generate`, `w_transferrequisition.ue_generate_godownreorderlevel`, `w_transferrequisition.ue_generate_godownwise_consumption`, `w_transferrequisition.ue_enableprint`, `w_transferrequisition.ue_generate_sourcebased`, `w_transferrequisition.ue_selectfirstrow`, `w_transferrequisition.ue_enforcedefaultfocussettings`, `w_transferrequisition.ue_setitemfocus`, `w_transferrequisition.create`, `w_transferrequisition.destroy`, `w_transferrequisition.ue_save`, `w_transferrequisition.ue_newform`, `w_transferrequisition.ue_detail`, `w_transferrequisition.ue_newitem`, `w_transferrequisition.ue_deleteitem`, `w_transferrequisition.close`, `w_transferrequisition.ue_list`, `w_transferrequisition.ue_print`, `w_transferrequisition.ue_refreshddw`, `w_transferrequisition.ue_new`, `w_transferrequisition.ue_postopen`, `dw_detail.itemchanged`, `dw_itemsdetail.ue_focusgodown`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `dw_itemsdetail.ue_focusqty`, `dw_itemsdetail.ue_dwnkey`, `w_transferrequisition.duplicategodown`, `w_transferrequisition.wf_visible`, `w_transferrequisition.wf_locksaleinvoice`, `w_transferrequisition.wf_locktransferinvoices`, `w_transferrequisition.wf_setsaletype`, `w_transferrequisition.wf_setsuppinfo`, `w_transferrequisition.wf_updatesaleprice`, `w_transferrequisition.wf_validatefullcode`, `w_transferrequisition.wf_validategodown`, `w_transferrequisition.wf_protectdw`, `w_transferrequisition.wf_savastemplate`, `w_transferrequisition.wf_setgodownoption`, `w_transferrequisition.wf_getmaxdate`, `w_transferrequisition.wf_grandtotal`, `w_transferrequisition.wf_initmodify`, `w_transferrequisition.wf_returnsaleinvoice`, `w_transferrequisition.wf_retrievelist`, `w_transferrequisition.wf_retrievelistall`, `w_transferrequisition.wf_validateitemnew`, `w_transferrequisition.wf_iseditable`, `w_transferrequisition.wf_selectprintreport`, `w_transferrequisition.wf_print`, `w_transferrequisition.wf_cleanupdetailrows`, `w_transferrequisition.wf_assigndatawindowobjects`, `w_transferrequisition.wf_customerinfo`, `w_transferrequisition.wf_deleterows`, `w_transferrequisition.wf_deletesaleinvoice`, `w_transferrequisition.wf_fetchitemlist`, `w_transferrequisition.wf_findfullcode`, `w_transferrequisition.wf_genfullcode`, `w_transferrequisition.wf_settransfertype`, `w_transferrequisition.wf_inititeminfo`, `w_transferrequisition.wf_validateitem`, `w_transferrequisition.wf_saveandpost`, `w_transferrequisition.wf_allowtransfermodification`, `w_transferrequisition.wf_post`, `w_transferrequisition.wf_setiteminfo`, `w_transferrequisition.wf_copyinvoice`, `w_transferrequisition.wf_set_postingstatus`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_detail.itemfocuschanged`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/transfer/w_transferrequisition.pbs`
