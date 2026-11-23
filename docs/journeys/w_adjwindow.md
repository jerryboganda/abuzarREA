# w_adjwindow

- title: Adjustment Decrease
- library: adjustment (Purchase & stock)
- ancestor: `w_multi_entry`
- size: 3383 x 3901 PBU
- reached from: Maintenance > Adjustment > Decrease
- script size: 1241 lines; 14 events, 29 functions

## Controls (1)

- `dw_adjreport` (u_dwstandard) dataobject `d_adjustmentreport`

## Data

- DataWindows: `d_adjdetail1`, `d_adjustmentreport`, `d_groupallowedmoduleheader`, `d_itemstockinfo`, `d_populateditems`, `d_populateditems_and`
- tables touched by embedded SQL: adjdetail, adjheader, godown, godowndetail, groupallowedgodown, item, itemcategory, itemsgroupcategory, usergroups
- stored procedures: deleteitemstockbatch, getitemavgprice, getitemstockall, getitemstockbatch, getitemstockinallowedgodown, getitemstocktotal, getmaxutn, postadjledger, saleupdateitemstockbatch, updateactivitymonitor, updateitemstockbatch
- global functions: f_generateheaderinvcode, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_item_populate3, w_arg_sinvcode_linvcode, w_itemadjustmenthistory, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_adjwindow.ue_accepttext`, `w_adjwindow.create`, `w_adjwindow.destroy`, `w_adjwindow.ue_save`, `w_adjwindow.ue_newform`, `w_adjwindow.ue_detail`, `w_adjwindow.close`, `w_adjwindow.ue_deleteitem`, `w_adjwindow.ue_newitem`, `w_adjwindow.ue_new`, `w_adjwindow.ue_list`, `w_adjwindow.ue_refreshddw`, `w_adjwindow.ue_print`, `w_adjwindow.ue_postopen`, `w_adjwindow.wf_assigndatawindowobjects`, `w_adjwindow.wf_deleteadjustmentinvoice`, `w_adjwindow.wf_finditem`, `w_adjwindow.wf_genfullcode`, `w_adjwindow.wf_grandtotal`, `w_adjwindow.wf_inititeminfo`, `w_adjwindow.wf_initmodify`, `w_adjwindow.wf_iteminfo`, `w_adjwindow.wf_lockadjinvoice`, `w_adjwindow.wf_populateadjinvds`, `w_adjwindow.wf_post`, `w_adjwindow.wf_protectdw`, `w_adjwindow.wf_returnadjinvoice`, `w_adjwindow.wf_validatefullcode`, `w_adjwindow.wf_validateitem`, `w_adjwindow.wf_validaterow`, `w_adjwindow.wf_releaselock`, `w_adjwindow.wf_retrievelist`, `w_adjwindow.wf_retrievelistall`, `w_adjwindow.wf_findfullcode`, `w_adjwindow.wf_allowadjustmentmodification`, `w_adjwindow.wf_populatefiltereditems`, `w_adjwindow.wf_checkitemstock`, `w_adjwindow.wf_itemstockinfo`, `w_adjwindow.wf_setiteminfo`, `w_adjwindow.wf_setiteminfobatch`, `w_adjwindow.wf_validatelooseqty`, `w_adjwindow.wf_fetchserverdate`, `w_adjwindow.wf_show_item_adjustment_history`

Source: `recovered/scripts/adjustment/w_adjwindow.pbs`
