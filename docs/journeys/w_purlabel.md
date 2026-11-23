# w_purlabel

- title: Label Printing
- library: barcodecomponents (Reports, printing & utilities)
- ancestor: `w_multi_entry`
- size: 2966 x 2102 PBU
- reached from: Reports > BarCode Printing > Using BarCode Printer
- script size: 1557 lines; 18 events, 48 functions

## Controls (3)

- `tab_retrieve` (tab_retrieve)
- `dw_purinvrep` (u_dwstandard)
- `dw_labelprint` (datawindow) dataobject `d_test`

## Data

- DataWindows: `d_normalpurchasedetail`, `d_normalpurchaseheader`, `d_populateditems_active`, `d_populateditems_active_and`, `d_purchaseorderdetail`, `d_purinvno`, `d_test`
- tables touched by embedded SQL: accounts, godowndetail, item, itemcategory, itemsgroupcategory, manufacturer, purledger, purorderheader, supplier, usergroups
- stored procedures: getglobalcode, getitemavgprice, getitemstockall, getitemstockbatch, getitemstocktotal, updateitemavgprice, updateitemstockbatch
- global functions: f_checkdate, f_newtableid, f_reportheaderinfo, f_stringpreferences, f_validatedw
- windows opened: w_arg_item_populate3, w_arg_sinvcode_linvcode, w_salesmanpassword

## Events and functions

`w_purlabel.create`, `w_purlabel.destroy`, `w_purlabel.ue_save`, `w_purlabel.ue_newform`, `w_purlabel.ue_detail`, `w_purlabel.ue_newitem`, `w_purlabel.ue_deleteitem`, `w_purlabel.close`, `w_purlabel.ue_new`, `w_purlabel.ue_list`, `w_purlabel.ue_refreshddw`, `w_purlabel.ue_print`, `w_purlabel.ue_postopen`, `w_purlabel.open`, `dw_footer.itemchanged`, `dw_detail.itemchanged`, `dw_itemsdetail.itemchanged`, `dw_itemsdetail.ue_enterkey`, `w_purlabel.wf_setsuppinfo`, `w_purlabel.wf_releaselock`, `w_purlabel.wf_setpurorderinfo`, `w_purlabel.wf_getpomanfcode`, `w_purlabel.wf_lockpurchaseinvoice`, `w_purlabel.wf_retrievelist`, `w_purlabel.wf_retrievelistall`, `w_purlabel.wf_setpurchasetype`, `w_purlabel.wf_lockloosepurinvoices`, `w_purlabel.wf_updateitemavgprice`, `w_purlabel.wf_validatefullcode`, `w_purlabel.wf_protectdw`, `w_purlabel.wf_updateitempurdisc`, `w_purlabel.wf_locknormalpurinvoices`, `w_purlabel.wf_getitemsaleprice`, `w_purlabel.wf_genfullcode`, `w_purlabel.wf_findsuppcode`, `w_purlabel.wf_populatedetaildwfrompo`, `w_purlabel.wf_updateitempurprice`, `w_purlabel.wf_updaterecentpurprice`, `w_purlabel.wf_selectprintreport`, `w_purlabel.wf_lockpurinvoices`, `w_purlabel.wf_lockopeningpurinvoices`, `w_purlabel.wf_post`, `w_purlabel.wf_initmodify`, `w_purlabel.wf_grandtotal`, `w_purlabel.wf_setgodownoption`, `w_purlabel.wf_validateitem`, `w_purlabel.wf_inititeminfo`, `w_purlabel.wf_iteminfo`, `w_purlabel.wf_findfullcode`, `w_purlabel.wf_assigndatawindowobjects`, `w_purlabel.wf_populatefiltereditems`, `w_purlabel.wf_populatepurinvoices`, `w_purlabel.wf_itemstockinfo`, `w_purlabel.wf_setiteminfo`, `w_purlabel.wf_updateitemstock`, `tab_retrieve.selectionchanging`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/barcodecomponents/w_purlabel.pbs`
