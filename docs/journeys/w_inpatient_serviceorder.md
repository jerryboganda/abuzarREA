# w_inpatient_serviceorder

- title: Service Order
- library: ipservices (Sales, POS & reports)
- ancestor: `w_multi_entry`
- size: 2966 x 2413 PBU
- reached from: (opened from code / other windows)
- script size: 2630 lines; 23 events, 66 functions

## Controls (5)

- `tab_retrieve` (tab_retrieve)
- `dw_saleinvrep` (u_dwstandard) dataobject `d_retailsaleinvreport`
- `dw_saleinvdetail` (u_dwstandard) dataobject `d_serviceorder_detail`
- `dw_new_account` (datawindow) dataobject `d_new_account`
- `dw_new_customer` (datawindow) dataobject `d_new_customer`

## Data

- DataWindows: `d_customerbalances_in_sales`, `d_deliveryorder_half`, `d_faisalmemorial_ipserviceoinvreport`, `d_groups_discount`, `d_itemstockinfo`, `d_khyber_serviceoinvreport`, `d_new_account`, `d_new_customer`, `d_quotationdetail`, `d_quotationheader`, `d_retailsaleinvreport`, `d_sadafcd_serviceoinvreport`, `d_saletemplate_detail`, `d_serviceoinvreport`, `d_serviceorder_detail`, `d_servicetemplate_detail`, `d_servicetemplate_header`
- tables touched by embedded SQL: accounts, customer, into, item, itemcategory, itemsgroupcategory, patient, patientadmission, saledetail, saleledger, service, servicedetail, serviceheader, serviceodetail, serviceoheader, supplier, timeslot, usergroups
- stored procedures: createvoucher, deleteitemstockbatch, getdatetime, getglobalcode, getitemavgprice, locksaleinvoice, postserviceoheader, updateactivitymonitor, updateitemstockbatch, virtualgl
- global functions: f_newtableid, f_numberpreferences, f_retrieve_servicelist, f_setserviceqtystyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_sinvcode_linvcode, w_choose_servicecategory, w_copysaleinvoicefrom, w_edit_servicetemplate, w_editquotationform, w_inpatient_bill, w_mr_patient_prescription_view, w_patientadmission_form_popup, w_popup_bookingdetail, w_popup_customer, w_popup_itemsearchcriteriaselection, w_preview_invoices, w_previnvinfo, w_salesmanpassword, w_savesaleastemplate, w_searchserviceorderbyservicedate

## Events and functions

`w_inpatient_serviceorder.ue_printdo`, `w_inpatient_serviceorder.create`, `w_inpatient_serviceorder.destroy`, `w_inpatient_serviceorder.ue_save`, `w_inpatient_serviceorder.ue_newform`, `w_inpatient_serviceorder.ue_detail`, `w_inpatient_serviceorder.ue_newitem`, `w_inpatient_serviceorder.ue_deleteitem`, `w_inpatient_serviceorder.close`, `w_inpatient_serviceorder.ue_list`, `w_inpatient_serviceorder.ue_print`, `w_inpatient_serviceorder.ue_refreshddw`, `w_inpatient_serviceorder.ue_new`, `w_inpatient_serviceorder.ue_postopen`, `w_inpatient_serviceorder.open`, `w_inpatient_serviceorder.ue_callback_popupwindow`, `dw_detail.itemchanged`, `dw_detail.ue_dwnkey`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.clicked`, `dw_itemsdetail.ue_dwnkey`, `dw_itemsdetail.ue_enterkey`, `dw_itemslist.clicked`, `w_inpatient_serviceorder.wf_setsuppinfo`, `w_inpatient_serviceorder.wf_customerinfo`, `w_inpatient_serviceorder.wf_setiteminfo`, `w_inpatient_serviceorder.wf_getmaxdate`, `w_inpatient_serviceorder.wf_locksaleinvoice`, `w_inpatient_serviceorder.wf_savastemplate`, `w_inpatient_serviceorder.wf_getitemassociategcode`, `w_inpatient_serviceorder.wf_print`, `w_inpatient_serviceorder.wf_preinvinfo`, `w_inpatient_serviceorder.wf_updatesaleprice`, `w_inpatient_serviceorder.wf_selectitembatches`, `w_inpatient_serviceorder.wf_validateitemnew`, `w_inpatient_serviceorder.wf_dueitem`, `w_inpatient_serviceorder.wf_validategodown`, `w_inpatient_serviceorder.wf_validatefullcode`, `w_inpatient_serviceorder.wf_closelist`, `w_inpatient_serviceorder.wf_copyinvoice`, `w_inpatient_serviceorder.wf_editquotation`, `w_inpatient_serviceorder.wf_setgodownoption`, `w_inpatient_serviceorder.wf_deleteserviceinvoice`, `w_inpatient_serviceorder.wf_locksaleinvoices`, `w_inpatient_serviceorder.wf_selectprintreport`, `w_inpatient_serviceorder.wf_findcustcode`, `w_inpatient_serviceorder.wf_getsalesstockinfo`, `w_inpatient_serviceorder.wf_retrievelist`, `w_inpatient_serviceorder.wf_retrievelistall`, `w_inpatient_serviceorder.wf_protectdw`, `w_inpatient_serviceorder.wf_visible`, `w_inpatient_serviceorder.wf_returnsaleinvoice`, `w_inpatient_serviceorder.wf_grandtotal`, `w_inpatient_serviceorder.wf_findcustomerbyname`, `w_inpatient_serviceorder.wf_lockserviceinvoices`, `w_inpatient_serviceorder.wf_validateitem`, `w_inpatient_serviceorder.wf_genfullcode`, `w_inpatient_serviceorder.wf_findfullcode`, `w_inpatient_serviceorder.wf_populatesaledetail`, `w_inpatient_serviceorder.wf_post`, `w_inpatient_serviceorder.wf_getalias`, `w_inpatient_serviceorder.wf_newcustomer`, `w_inpatient_serviceorder.wf_searchserviceorderbyservicedate`, `w_inpatient_serviceorder.wf_assigndatawindowobjects`, `w_inpatient_serviceorder.wf_findadmissioncode`, `w_inpatient_serviceorder.wf_findpatientcode`, `w_inpatient_serviceorder.wf_setadmissiondetails`, `w_inpatient_serviceorder.wf_initmodify`, `w_inpatient_serviceorder.wf_admitted`, `w_inpatient_serviceorder.wf_generatecashreceipt`, `w_inpatient_serviceorder.wf_editservicetemplate`, `w_inpatient_serviceorder.wf_refreshitemslist_itemname`, `w_inpatient_serviceorder.wf_refreshitemslist_catwise`, `w_inpatient_serviceorder.wf_validate_price_discount_matters`, `w_inpatient_serviceorder.wf_inititeminfo`, `w_inpatient_serviceorder.wf_show_inpatientbill`, `w_inpatient_serviceorder.wf_open_item_form_popup`, `w_inpatient_serviceorder.wf_validate_admissioncode`, `tab_retrieve.selectionchanged`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/ipservices/w_inpatient_serviceorder.pbs`
