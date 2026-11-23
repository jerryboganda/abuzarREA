# w_adjincrease

- title: Adjustment Increase
- library: adjustment (Purchase & stock)
- ancestor: `w_multi_entry`
- size: 3039 x 3216 PBU
- reached from: Maintenance > Adjustment > Increase
- script size: 1533 lines; 17 events, 32 functions

## Controls (2)

- `tab_retrieve` (tab_retrieve)
- `dw_adjreport` (u_dwstandard) dataobject `d_adjustmentreport`

## Data

- DataWindows: `d_adjheader`, `d_adjincreasedetail`, `d_adjinvno`, `d_adjustmentreport`, `d_groupallowedmoduleheader`, `d_populateditems_active`, `d_populateditems_active_and`
- tables touched by embedded SQL: adjdetail, adjheader, godown, groupallowedgodown, item, itemcategory, itemsgroupcategory, usergroups
- stored procedures: create, getitemavgprice, getitemstockall, getitemstockbatch, getitemstockinallowedgodown, getitemstocktotal, getmaxutn, updateactivitymonitor, updateitemavgprice, updateitemstockbatch
- global functions: f_datepreferences, f_generateheaderinvcode, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_newtableid, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_arg_item_populate3, w_arg_sinvcode_linvcode, w_itemadjustmenthistory, w_populate_stockaudit_from_datacarrydb, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_adjincrease.ue_populate_shelfstock_from_datacarry`, `w_adjincrease.ue_populate_stockaudit_from_datacarry`, `w_adjincrease.create`, `w_adjincrease.destroy`, `w_adjincrease.ue_save`, `w_adjincrease.ue_newform`, `w_adjincrease.ue_detail`, `w_adjincrease.ue_newitem`, `w_adjincrease.ue_deleteitem`, `w_adjincrease.close`, `w_adjincrease.ue_new`, `w_adjincrease.ue_list`, `w_adjincrease.ue_print`, `w_adjincrease.ue_postopen`, `w_adjincrease.open`, `dw_footer.itemchanged`, `dw_itemsdetail.itemchanged`, `w_adjincrease.wf_validateitem`, `w_adjincrease.wf_assigndatawindowobjects`, `w_adjincrease.wf_genfullcode`, `w_adjincrease.wf_grandtotal`, `w_adjincrease.wf_initmodify`, `w_adjincrease.wf_iteminfo`, `w_adjincrease.wf_lockadjinvoice`, `w_adjincrease.wf_lockadjinvoices`, `w_adjincrease.wf_protectdw`, `w_adjincrease.wf_selectprintreport`, `w_adjincrease.wf_setgodownoption`, `w_adjincrease.wf_validatefullcode`, `w_adjincrease.wf_post`, `w_adjincrease.wf_retrievelist`, `w_adjincrease.wf_retrievelistall`, `w_adjincrease.wf_inititeminfo`, `w_adjincrease.wf_findfullcode`, `w_adjincrease.wf_allowadjustmentmodification`, `w_adjincrease.wf_populatefiltereditems`, `w_adjincrease.wf_setiteminfo`, `w_adjincrease.wf_fetchserverdate`, `w_adjincrease.wf_show_item_adjustment_history`, `dw_footer.losefocus`, `dw_footer.itemfocuschanged`, `dw_footer.itemerror`, `dw_detail.itemerror`, `dw_itemsdetail.itemfocuschanged`, `dw_itemsdetail.rowfocuschanged`, `dw_itemsdetail.losefocus`, `dw_itemsdetail.editchanged`, `dw_itemsdetail.itemerror`, `dw_itemsdetail.getfocus`

Source: `recovered/scripts/adjustment/w_adjincrease.pbs`
