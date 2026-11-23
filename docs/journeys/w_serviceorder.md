# w_serviceorder

- title: Service Order
- library: servicemodules (Services)
- ancestor: `w_multi_entry`
- size: 2959 x 2253 PBU
- reached from: Sales > Service Order
- script size: 2596 lines; 21 events, 60 functions

## Controls (5)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_serviceoinvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_serviceorder_detail`
- `dw_new_account` (datawindow) dataobject `d_new_account`
- `dw_new_customer` (datawindow) dataobject `d_new_customer`

## Data

- DataWindows: `d_customerbalances_in_sales`, `d_deliveryorder_half`, `d_faisalmemorial_serviceoinvreport`, `d_groups_discount`, `d_itemstockinfo`, `d_khyber_serviceoinvreport`, `d_new_account`, `d_new_customer`, `d_quotationdetail`, `d_quotationheader`, `d_rawaldentalhsp_serviceoinvreport`, `d_sadafcd_serviceoinvreport`, `d_saletemplate_detail`, `d_serviceoinvreport`, `d_serviceorder_detail`, `d_servicetemplate_detail`, `d_servicetemplate_header`
- tables touched by embedded SQL: accounts, customer, into, item, itemcategory, itemsgroupcategory, patient, patientadmission, saledetail, saleledger, service, servicedetail, serviceheader, serviceodetail, serviceoheader, supplier, timeslot, usergroups
- stored procedures: createvoucher, deleteitemstockbatch, getdatetime, getglobalcode, getitemavgprice, locksaleinvoice, postserviceoheader, updateactivitymonitor, updateitemstockbatch, virtualgl
- global functions: f_newtableid, f_numberpreferences, f_retrieve_servicelist, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_choose_servicecategory, w_copysaleinvoicefrom, w_edit_servicetemplate, w_editquotationform, w_popup_bookingdetail, w_popup_customer, w_popup_itemsearchcriteriaselection, w_preview_invoices, w_previnvinfo, w_salesmanpassword, w_savesaleastemplate, w_searchserviceorderbyservicedate

## Events and functions

`w_serviceorder.ue_printdo`, `w_serviceorder.create`, `w_serviceorder.destroy`, `w_serviceorder.ue_save`, `w_serviceorder.ue_newform`, `w_serviceorder.ue_detail`, `w_serviceorder.ue_newitem`, `w_serviceorder.ue_deleteitem`, `w_serviceorder.close`, `w_serviceorder.ue_list`, `w_serviceorder.ue_print`, `w_serviceorder.ue_refreshddw`, `w_serviceorder.ue_new`, `w_serviceorder.ue_postopen`, `w_serviceorder.open`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `dw_itemsdetail.ue_dwnkey`, `dw_itemsdetail.ue_enterkey`, `dw_itemslist.clicked`, `w_serviceorder.wf_setsuppinfo`, `w_serviceorder.wf_customerinfo`, `w_serviceorder.wf_setiteminfo`, `w_serviceorder.wf_getmaxdate`, `w_serviceorder.wf_locksaleinvoice`, `w_serviceorder.wf_savastemplate`, `w_serviceorder.wf_getitemassociategcode`, `w_serviceorder.wf_print`, `w_serviceorder.wf_preinvinfo`, `w_serviceorder.wf_updatesaleprice`, `w_serviceorder.wf_selectitembatches`, `w_serviceorder.wf_validateitemnew`, `w_serviceorder.wf_dueitem`, `w_serviceorder.wf_validategodown`, `w_serviceorder.wf_validatefullcode`, `w_serviceorder.wf_closelist`, `w_serviceorder.wf_copyinvoice`, `w_serviceorder.wf_editquotation`, `w_serviceorder.wf_setgodownoption`, `w_serviceorder.wf_deleteserviceinvoice`, `w_serviceorder.wf_locksaleinvoices`, `w_serviceorder.wf_selectprintreport`, `w_serviceorder.wf_findcustcode`, `w_serviceorder.wf_getsalesstockinfo`, `w_serviceorder.wf_retrievelist`, `w_serviceorder.wf_retrievelistall`, `w_serviceorder.wf_protectdw`, `w_serviceorder.wf_visible`, `w_serviceorder.wf_returnsaleinvoice`, `w_serviceorder.wf_grandtotal`, `w_serviceorder.wf_findcustomerbyname`, `w_serviceorder.wf_lockserviceinvoices`, `w_serviceorder.wf_validateitem`, `w_serviceorder.wf_inititeminfo`, `w_serviceorder.wf_genfullcode`, `w_serviceorder.wf_findfullcode`, `w_serviceorder.wf_populatesaledetail`, `w_serviceorder.wf_post`, `w_serviceorder.wf_getalias`, `w_serviceorder.wf_newcustomer`, `w_serviceorder.wf_searchserviceorderbyservicedate`, `w_serviceorder.wf_initmodify`, `w_serviceorder.wf_generatecashreceipt`, `w_serviceorder.wf_findpatientcode`, `w_serviceorder.wf_assigndatawindowobjects`, `w_serviceorder.wf_editservicetemplate`, `w_serviceorder.wf_refreshitemslist_catwise`, `w_serviceorder.wf_refreshitemslist_itemname`, `w_serviceorder.wf_validate_price_discount_matters`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/servicemodules/w_serviceorder.pbs`
