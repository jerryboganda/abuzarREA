# w_prodnote_form

- title: Production Note
- library: issuereq (Sales, POS & reports)
- ancestor: `window`
- size: 3087 x 2250 PBU
- reached from: (opened from code / other windows)
- script size: 2060 lines; 27 events, 47 functions

## Controls (7)

- `cb_print` (commandbutton) text "&Print"
- `cb_cancel` (commandbutton) text "&Cancel"
- `cb_ok` (commandbutton) text "&Save"
- `tab_main` (tab)
- `dw_image` (u_dwstandard) dataobject `d_patientimage`
- `dw_print` (datawindow) dataobject `d_prodnote_print_full`
- `dw_dischargeslip` (u_dwstandard) dataobject `d_pic2014_dischargeslip`

## Data

- DataWindows: `d_alnaseeb_prodnote_print_full`, `d_groupitemreceiptexptemplate_detail`, `d_patientimage`, `d_pic2014_dischargeslip`, `d_prodnote_print_full`
- tables touched by embedded SQL: _tabmaxkey, item, serverdate
- stored procedures: getaliasname_withqtyprice, getdatetime, getitemstockinallowedgodown, getitemstocktotal, getitemtotalpiecesinhand
- global functions: f_datepreferences, f_getgroupcode, f_groupallowedgodowncount, f_groupgodownstrategy, f_numberpreferences, f_setcolumnstyle, f_stringpreferences, f_validatedw
- windows opened: w_patientgallary, w_preview_invoices, w_salesmanpassword

## Events and functions

`w_prodnote_form.ue_close`, `w_prodnote_form.create`, `w_prodnote_form.destroy`, `w_prodnote_form.open`, `cb_print.clicked`, `cb_cancel.clicked`, `cb_ok.ue_enterkry`, `cb_ok.clicked`, `tab_main.create`, `tab_main.destroy`, `tabpage_header.create`, `tabpage_header.destroy`, `dw_header.ue_enterkey`, `tabpage_issue.create`, `tabpage_issue.destroy`, `dw_selectionlist.ue_setfocus`, `dw_selectionlist.clicked`, `dw_issue.ue_dwnkey`, `dw_issue.ue_enterkey`, `dw_issue.itemchanged`, `tabpage_receipt.create`, `tabpage_receipt.destroy`, `dw_selectionlistpod.ue_setfocus`, `dw_selectionlistpod.clicked`, `dw_receipt.itemchanged`, `dw_receipt.ue_dwnkey`, `dw_receipt.ue_enterkey`, `w_prodnote_form.wf_set_interface_adjustments`, `w_prodnote_form.wf_set_tab_visibility`, `w_prodnote_form.wf_connect`, `w_prodnote_form.wf_tabnewid`, `w_prodnote_form.wf_retrieve_tabs`, `w_prodnote_form.wf_insert_row`, `w_prodnote_form.wf_delete_row`, `w_prodnote_form.wf_protectdw`, `w_prodnote_form.wf_apply_protect_setting`, `w_prodnote_form.wf_save`, `w_prodnote_form.wf_print`, `w_prodnote_form.wf_select_first_tab`, `w_prodnote_form.wf_itemlist_initialization`, `w_prodnote_form.wf_validateitem`, `w_prodnote_form.wf_show_patient_gallery`, `w_prodnote_form.wf_validateserverdatetime`, `w_prodnote_form.wf_validate_receipt`, `w_prodnote_form.wf_validateitem_receipt`, `w_prodnote_form.wf_itemlist_initialization_receipt`, `w_prodnote_form.wf_validate_issue`, `w_prodnote_form.wf_findfullcode`, `w_prodnote_form.wf_getassociatedgodown`, `w_prodnote_form.wf_validategodown`, `w_prodnote_form.wf_inititeminfo`, `w_prodnote_form.wf_inititeminfo_receipt`, `w_prodnote_form.wf_print_note`, `w_prodnote_form.wf_setitemprice`, `w_prodnote_form.wf_setreceiptprice`, `w_prodnote_form.wf_set_itemexpense_interface`, `tab_main.selectionchanged`, `dw_header.getfocus`, `dw_header.itemfocuschanged`, `dw_selectionlist.doubleclicked`, `dw_issue.getfocus`, `dw_issue.itemfocuschanged`, `dw_issue.editchanged`, `dw_issue.itemerror`, `dw_issue.losefocus`, `dw_issue.rowfocuschanging`, `dw_issue.rowfocuschanged`, `dw_selectionlistpod.doubleclicked`, `dw_receipt.editchanged`, `dw_receipt.getfocus`, `dw_receipt.itemerror`, `dw_receipt.itemfocuschanged`, `dw_receipt.losefocus`, `dw_receipt.rowfocuschanging`

Source: `recovered/scripts/issuereq/w_prodnote_form.pbs`
