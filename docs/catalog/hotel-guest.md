# Hotel / guest

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `m_guestcheckinmenu` | menu | guestcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_guesttransfermenu` | menu | guestcomponents |  |  | m_entry |  |  | create, destroy |  |
| `w_guest_form` | window | guestcomponents | Guest Form | 2962 x 1952 | w_single_entry | d_guest_print | guest | gettabmaxkey | w_popup_comprehensicesearch_selection, w_popup_partialsearch_selection, w_preview_invoices |
| `w_guestcheckin` | window | guestcomponents | Guest Check In Form | 3081 x 2044 | w_multi_entry | d_group_servicetemplate, d_guestcheckin_print, d_guestcheckinservice, d_guestroomservice, d_mastercashierwindow_detail, d_sawarhotel_guestcheckin_print ... | guest, guestcheckin, guestcheckinservice, guestroom, mastercashwin, saleledger, service, servicetemplateheader |  | w_arg_sdate, w_arg_sinvcode_linvcode, w_guestregistration, w_mastercashierwindow, w_preview_invoices |
| `w_guestcheckin_form` | window | guestcomponents | Issue License Form | 3013 x 2099 | window |  | _tabmaxkey, guestcheckin, guestroom |  |  |
| `w_guestcheckin_list` | window | guestcomponents | Guest Check IN | 3598 x 5264 | w_listview_form |  |  |  | w_guestcheckin_form |
| `w_guestcheckout_form` | window | guestcomponents | Guest Check Out Form | 3255 x 3124 | w_single_entry | d_guestcheckin_bill | guest, guestcheckin, guestroom, patient, patientadmission, patientlocation, patienttransfer | guestcheckinbalance | w_patienttransferhistory, w_preview_invoices |
| `w_guestregistration` | window | guestcomponents | Guest Registration | 2889 x 1648 | window | d_guest_detail | guest, serverdate | getdatetime, gettabmaxkey |  |
| `w_guestroom_form` | window | guestcomponents | Guest Room Form | 3057 x 2003 | w_multi_entry | d_group_servicetemplate, d_guestroom_detail, d_guestroomservice | guestroom, guestroomservice, saleledger, service |  | w_arg_sinvcode_linvcode, w_preview_invoices, w_salesmanpassword |
| `w_guestroomfloor_form` | window | guestcomponents | Guest Room Floor Form | 2971 x 1896 | w_single_entry |  | guestroomfloor |  |  |
| `w_guestroomstatus_form` | window | guestcomponents | Guest Room Status Form | 2971 x 1896 | w_single_entry |  | guestroomstatus |  |  |
| `w_guestroomtype_form` | window | guestcomponents | Guest Room Type Form | 2971 x 1896 | w_single_entry |  | guestroomtype |  |  |
| `w_guesttransfer_form` | window | guestcomponents | Guest Transfer Form | 3218 x 2952 | w_single_entry | d_guesttransfer_print, d_guesttransferdetail | guestcheckin, guestroom |  | w_guesttransferhistory, w_salesmanpassword |
| `w_guesttransferhistory` | window | guestcomponents | Guest Transfer History | 2898 x 1736 | window | d_guesttransferhistory |  |  |  |
