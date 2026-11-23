# Reports, printing & utilities

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `m_barcodelabelmenu` | menu | barcodecomponents |  |  | m_multi_entry |  |  | create, destroy |  |
| `m_purlabelmenu` | menu | barcodecomponents |  |  | m_multi_entry |  |  |  |  |
| `w_barcode` | window | barcodecomponents | Bar Code Labels Printing | 2921 x 1920 | window | d_barcode, d_barcodelabelheader, d_barcodelabels |  |  |  |
| `w_barcodelabels` | window | barcodecomponents | BarCode Label Printing | 2966 x 1843 | w_multi_entry | d_barcodelabels_bambinostore, d_barcodelabels_bambinostore2, d_barcodelabels_clinix, d_barcodelabels_clinix2, d_barcodelabels_clinix3, d_barcodelabels_clinix4 ... | accounts, godowndetail, instruction, item, itemcategory, itemdesign, itempacking, itemsgroupcategory ... | getitemavgprice, getitemstockall, getitemstockbatch, getitemstocktotal, updateitemavgprice | w_arg_item_populate3, w_arg_receipt, w_arg_sinvcode_linvcode, w_arg_spurinv_lpurinv, w_arg_transfer |
| `w_barcodelabels_popup` | window | barcodecomponents |  | 2966 x 1900 | w_barcodelabels |  |  |  |  |
| `w_mainqrcode` | window | barcodecomponents | PowerBuilder QRCode API Generator | 1998 x 1496 | window |  |  |  |  |
| `w_purlabel` | window | barcodecomponents | Label Printing | 2966 x 2102 | w_multi_entry | d_normalpurchasedetail, d_normalpurchaseheader, d_populateditems_active, d_populateditems_active_and, d_purchaseorderdetail, d_purinvno ... | accounts, godowndetail, item, itemcategory, itemsgroupcategory, manufacturer, purledger, purorderheader ... | getglobalcode, getitemavgprice, getitemstockall, getitemstockbatch, getitemstocktotal | w_arg_item_populate3, w_arg_sinvcode_linvcode, w_salesmanpassword |
| `f_findtreeitem` | function | packingmodule |  |  |  |  |  |  |  |
| `m_packingoption` | menu | packingmodule |  |  | menu |  |  | create, destroy |  |
| `m_packjob` | menu | packingmodule |  |  | m_multi_entry |  |  |  |  |
| `w_packcasecapacity` | window | packingmodule | Packing Case Capacity Form | 3040 x 2264 | w_multi_entry | ddd_itempacking, ddd_packinglist_for_a_category | itemcategory |  |  |
| `w_packingjob` | window | packingmodule | Packing Job Form | 3095 x 1920 | w_multi_entry | d_packingjob_itemppoulation, d_packingjob_printout, d_packingjob_printout2 | item, itemcategory, packingjobdetail, packingjobpending, packingjobsource, saleledger | getmaxlimitforpackcase | w_preview_invoices, w_salesmanpassword, w_select_case, w_selectformat_1_2 |
| `w_select_case` | window | packingmodule | Select Packing Case | 1897 x 836 | window | d_arg_packlayout |  |  |  |
| `nv_datastore` | userobject | pbdwr125 |  |  | datastore |  |  |  |  |
| `nv_remote_datawindow` | userobject | pbdwr125 |  |  | nonvisualobject |  |  |  |  |
| `nv_retreival_arg` | userobject | pbdwr125 |  |  | nonvisualobject |  |  |  |  |
| `remote_datawindow_appl` | application | pbdwr125 |  |  | application |  |  |  |  |
| `soapconnection` | ? | pbsoapclient125 |  |  |  |  |  |  |  |
| `soapexception` | ? | pbsoapclient125 |  |  |  |  |  |  |  |
| `soapconnection` | userobject | pbwsclient125 |  |  | nonvisualobject |  |  |  |  |
| `soapexception` | userobject | pbwsclient125 |  |  | runtimeerror |  |  |  |  |
| `soappbcookie` | userobject | pbwsclient125 |  |  | nonvisualobject |  |  |  |  |
| `m_psrviewer` | menu | psrviewer |  |  | m_entry |  |  |  |  |
| `w_psrviewer` | window | psrviewer | Powersoft Report Viewer | 3429 x 10500 | window |  |  |  | w_printer, w_save_reportfilter, w_select, w_view_reportfilter |
| `w_filter_for_itemlist_rep` | window | reportformat | Select Format | 2121 x 1382 | window |  |  |  |  |
| `w_select_activate_deactivate` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_select_area_customer` | window | reportformat | Select Format | 745 x 716 | window |  |  |  |  |
| `w_select_area_manfcategory` | window | reportformat | Select Format | 951 x 643 | window |  |  |  |  |
| `w_select_area_salesman` | window | reportformat | Select Format | 951 x 643 | window |  |  |  |  |
| `w_select_area_subarea_customer` | window | reportformat | Select Format | 736 x 644 | window |  |  |  |  |
| `w_select_argument_window` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_select_balancesheet` | window | reportformat | Select Format | 951 x 644 | window |  |  |  |  |
| `w_select_batchwisestockmovement` | window | reportformat | Select Format | 590 x 704 | window |  |  |  |  |
| `w_select_cashierjob_voucher` | window | reportformat | Select Voucher Category | 2318 x 1640 | w_arguements | d_arg_cashierjob_voucher |  |  |  |
| `w_select_categorycriteria` | window | reportformat | Selection Criteria | 1298 x 784 | window |  |  |  |  |
| `w_select_changediscmethod` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_crs_normal` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_select_cust_custcat` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_cust_custgroup` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_cust_header` | window | reportformat | Select Format | 978 x 624 | window |  |  |  |  |
| `w_select_cust_patient` | window | reportformat | Select Format | 987 x 716 | window |  |  |  |  |
| `w_select_custbalance_format2` | window | reportformat | Select Format | 1115 x 774 | window |  |  |  |  |
| `w_select_custbalance_sman_area` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_custwisesalesummary` | window | reportformat | Select Format | 1179 x 1484 | window |  |  |  |  |
| `w_select_deselect_all` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_doctor_servicetemplate_setting` | window | reportformat | Select Format | 1253 x 644 | window |  |  |  |  |
| `w_select_emp_payrolltype` | window | reportformat | Select Format | 987 x 624 | window |  |  |  |  |
| `w_select_format_installmentanalysis` | window | reportformat | Select Format | 837 x 644 | window |  |  |  |  |
| `w_select_format_monthsale_manf` | window | reportformat | Select Format | 590 x 644 | window |  |  |  |  |
| `w_select_general_crs` | window | reportformat | Select Scope | 978 x 644 | window |  |  |  |  |
| `w_select_general_custcat` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_general_monthlysummary` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_general_suppcat` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_group_properties` | window | reportformat | Select Report Group Properties | 1015 x 644 | window |  |  |  |  |
| `w_select_initialization_type` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_invoicepopulation_voucher` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_invoicerange_period` | window | reportformat | Select Criteria | 978 x 644 | window |  |  |  |  |
| `w_select_invprofitmargin` | window | reportformat | Select Format | 1024 x 928 | window |  |  |  |  |
| `w_select_itemregrequest_deletion_option` | window | reportformat | Select Format | 1152 x 680 | window |  |  |  |  |
| `w_select_itemsalesumm_area_subarea_cust` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_ledgertype` | window | reportformat | Select Ledger Type | 1847 x 1144 | window |  |  |  |  |
| `w_select_manf_cat_class_pack_saleorder` | window | reportformat | Select Column Criteria | 1061 x 976 | window |  |  |  |  |
| `w_select_manf_cat_class_packing_combined` | window | reportformat | Select Column Criteria | 1061 x 844 | window |  |  |  |  |
| `w_select_orientation` | window | reportformat | Select Orientation | 1847 x 1144 | window |  |  |  |  |
| `w_select_page` | window | reportformat | Select Page Size | 1847 x 1144 | window |  |  |  |  |
| `w_select_pagesize` | window | reportformat | Select Page Size | 722 x 820 | window |  |  |  |  |
| `w_select_patient_salesumm` | window | reportformat | Select Format | 987 x 621 | window |  |  |  |  |
| `w_select_payments` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_select_populate_customer` | window | reportformat | Customer Selection Criteria | 882 x 924 | window |  |  |  |  |
| `w_select_population_mode` | window | reportformat | Select Mode | 786 x 644 | window |  |  |  |  |
| `w_select_postedissuecategory` | window | reportformat | Select Receipt Category | 2326 x 1594 | w_arguements | d_arg_postedissuecategory |  |  |  |
| `w_select_postedreceiptcategory` | window | reportformat | Select Receipt Category | 2326 x 1594 | w_arguements | d_arg_posted_receiptcategory |  |  |  |
| `w_select_postedsaleordercategory` | window | reportformat | Select Voucher Category | 2327 x 1592 | w_arguements | d_arg_postedsaleordercategory |  |  |  |
| `w_select_postedvouchercategory` | window | reportformat | Select Voucher Category | 2318 x 1640 | w_arguements | d_arg_postedvouchercategory |  |  |  |
| `w_select_quarterpage_ledger` | window | reportformat | Select Format | 1824 x 840 | window |  |  |  |  |
| `w_select_receipts` | window | reportformat | Select Format | 1847 x 643 | window |  |  |  |  |
| `w_select_repairdb_option` | window | reportformat | Repair Options | 1051 x 768 | window |  |  |  |  |
| `w_select_sales_advsales` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_sales_salereturn` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_school_branch_class_defaulter` | window | reportformat | Select Criteria | 1074 x 780 | window |  |  |  |  |
| `w_select_stockbatchpriority` | window | reportformat | Select Format | 976 x 739 | window |  |  |  |  |
| `w_select_supp_manf` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_select_user_areawise_billsummary` | window | reportformat | Select Format | 1202 x 644 | window |  |  |  |  |
| `w_select_users_class` | window | reportformat | Select Format | 745 x 716 | window |  |  |  |  |
| `w_select_weighingscale` | window | reportformat | Select Format | 976 x 701 | window |  |  |  |  |
| `w_select_weighingscale_price` | window | reportformat | Select Format | 978 x 608 | window |  |  |  |  |
| `w_selectaccountsfromvoucher` | window | reportformat | Select Voucher Type and its Vouchers | 2734 x 1740 | window | d_arg_svouchcode_lvouchcode, d_selectaccountsfromvoucher |  |  |  |
| `w_selectformat` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_1_11` | window | reportformat | Select Format | 1166 x 1428 | window |  |  |  |  |
| `w_selectformat_1_12` | window | reportformat | Select Format | 1166 x 1528 | window |  |  |  |  |
| `w_selectformat_1_13` | window | reportformat | Select Format | 1166 x 1628 | window |  |  |  |  |
| `w_selectformat_1_14` | window | reportformat | Select Format | 1166 x 1628 | window |  |  |  |  |
| `w_selectformat_1_15` | window | reportformat | Select Format | 1166 x 1628 | window |  |  |  |  |
| `w_selectformat_1_16` | window | reportformat | Select Format | 1166 x 1672 | window |  |  |  |  |
| `w_selectformat_1_2` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_1_3` | window | reportformat | Select Format | 1458 x 644 | window |  |  |  |  |
| `w_selectformat_1_4` | window | reportformat | Select Format | 1723 x 644 | window |  |  |  |  |
| `w_selectformat_1_5` | window | reportformat | Select Format | 2185 x 644 | window |  |  |  |  |
| `w_selectformat_1_6` | window | reportformat | Select Format | 2633 x 644 | window |  |  |  |  |
| `w_selectformat_1_7` | window | reportformat | Select Format | 3013 x 644 | window |  |  |  |  |
| `w_selectformat_1_8` | window | reportformat | Select Format | 3575 x 644 | window |  |  |  |  |
| `w_selectformat_1_9` | window | reportformat | Select Format | 1166 x 1300 | window |  |  |  |  |
| `w_selectformat_accledger` | window | reportformat | Select Format | 1637 x 644 | window |  |  |  |  |
| `w_selectformat_accountbalance` | window | reportformat | Select Format | 1728 x 668 | window |  |  |  |  |
| `w_selectformat_advancetax` | window | reportformat | Select Format | 1459 x 784 | window |  |  |  |  |
| `w_selectformat_advancetaxonsale` | window | reportformat | Select Format | 1452 x 1024 | window |  |  |  |  |
| `w_selectformat_agingcriteria` | window | reportformat | Select Aging Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_agingdetailcriteria` | window | reportformat | Select Aging Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_agingsummary` | window | reportformat | Select Format | 1339 x 644 | window |  |  |  |  |
| `w_selectformat_areawisesale` | window | reportformat | Select Format | 1367 x 644 | window |  |  |  |  |
| `w_selectformat_areawisestoresummary` | window | reportformat | Select Format | 1143 x 644 | window |  |  |  |  |
| `w_selectformat_balancereminder` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_cashflow` | window | reportformat | Select Format | 1986 x 1267 | window |  |  |  |  |
| `w_selectformat_cat_1_or_n` | window | reportformat | Select Format | 978 x 584 | window |  |  |  |  |
| `w_selectformat_cat_purchase` | window | reportformat | Select Report Type | 1307 x 680 | window |  |  |  |  |
| `w_selectformat_catwise_grossprofit` | window | reportformat | Select Format | 1353 x 644 | window |  |  |  |  |
| `w_selectformat_claimable` | window | reportformat | Select Format | 969 x 644 | window |  |  |  |  |
| `w_selectformat_classwisesales` | window | reportformat | Select Format | 1637 x 644 | window |  |  |  |  |
| `w_selectformat_collectionreceipt` | window | reportformat | Select Format | 933 x 644 | window |  |  |  |  |
| `w_selectformat_comprehensivebillsumm` | window | reportformat | Select Format | 2181 x 900 | window |  |  |  |  |
| `w_selectformat_creditreceiptvoucher` | window | reportformat |  | 1167 x 1318 | window |  |  |  |  |
| `w_selectformat_crosstab_godownstock` | window | reportformat | Select Format | 590 x 764 | window |  |  |  |  |
| `w_selectformat_crs_consolidated` | window | reportformat | Select Report Type | 1075 x 589 | window |  |  |  |  |
| `w_selectformat_crs_ledgertype` | window | reportformat | Select Report Type | 1075 x 589 | window |  |  |  |  |
| `w_selectformat_crs_stockposition` | window | reportformat | Select Format | 1459 x 733 | window |  |  |  |  |
| `w_selectformat_crs_supplierledger` | window | reportformat | Select Report Type | 1075 x 662 | window |  |  |  |  |
| `w_selectformat_cstatus_type` | window | reportformat | Select Aging Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_cust_item_monthlysales` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_cust_manf_netsales` | window | reportformat | Select Format | 1193 x 832 | window |  |  |  |  |
| `w_selectformat_cust_manf_sales` | window | reportformat | Select Format | 2117 x 1210 | window |  |  |  |  |
| `w_selectformat_cust_patient_summ3` | window | reportformat | Select Format | 1198 x 1492 | window |  |  |  |  |
| `w_selectformat_cust_sale_summ_2` | window | reportformat | Select Format | 1458 x 804 | window |  |  |  |  |
| `w_selectformat_cust_sale_tajmedicos` | window | reportformat | Select Format | 1801 x 1172 | window |  |  |  |  |
| `w_selectformat_custcatwise_aging` | window | reportformat | Select Report Type | 677 x 682 | window |  |  |  |  |
| `w_selectformat_custcatwise_sales` | window | reportformat | Select Format | 1367 x 840 | window |  |  |  |  |
| `w_selectformat_custlist` | window | reportformat | Select Format | 962 x 995 | window |  |  |  |  |
| `w_selectformat_customer_manf_sales` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_customerbalance` | window | reportformat | Select Format | 1225 x 1382 | window |  |  |  |  |
| `w_selectformat_customersaledetail` | window | reportformat | Select Format | 2441 x 1156 | window |  |  |  |  |
| `w_selectformat_custsaleformat4` | window | reportformat | Select Format | 1394 x 672 | window |  |  |  |  |
| `w_selectformat_custwise_invdetail` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_dailyrefusedsale` | window | reportformat | Select Format | 1216 x 776 | window |  |  |  |  |
| `w_selectformat_dailysaledetail` | window | reportformat | Select Format | 1595 x 1322 | window |  |  |  |  |
| `w_selectformat_dailysaledetail_dc` | window | reportformat | Select Report Format | 773 x 680 | window |  |  |  |  |
| `w_selectformat_dailysaledetail_pricediff` | window | reportformat | Select Format | 1408 x 644 | window |  |  |  |  |
| `w_selectformat_dailysaledetailheaderwise` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_dailysaledetailinvrange` | window | reportformat | Select Format | 1637 x 644 | window |  |  |  |  |
| `w_selectformat_dailysalessummary` | window | reportformat | Select Format | 1888 x 1912 | window |  |  |  |  |
| `w_selectformat_dailyservicedetail` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_dailyservicesummary` | window | reportformat | Select Format | 1170 x 708 | window |  |  |  |  |
| `w_selectformat_datewise_invwise` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_dayssalessummary` | window | reportformat | Select Format | 976 x 797 | window |  |  |  |  |
| `w_selectformat_dayssummary` | window | reportformat | Select Format | 1458 x 744 | window |  |  |  |  |
| `w_selectformat_dayssummary_salmod` | window | reportformat | Select Format | 1459 x 746 | window |  |  |  |  |
| `w_selectformat_dc_taxinv_invoice` | window | reportformat | Select Format | 1358 x 724 | window |  |  |  |  |
| `w_selectformat_deliverychallan` | window | reportformat | Select Format | 1938 x 2140 | window |  |  |  |  |
| `w_selectformat_do_reprint` | window | reportformat | Select Format | 978 x 692 | window |  |  |  |  |
| `w_selectformat_doctorservices` | window | reportformat | Select Report Type | 1193 x 792 | window |  |  |  |  |
| `w_selectformat_emp_cat_dept` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_emp_cat_dept_desig` | window | reportformat | Select Format | 978 x 728 | window |  |  |  |  |
| `w_selectformat_expiryreport` | window | reportformat | Select Aging Criteria | 1509 x 1060 | window |  |  |  |  |
| `w_selectformat_front_back` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_gen_manf_cat_class_pack` | window | reportformat | Select Format | 1902 x 608 | window |  |  |  |  |
| `w_selectformat_general_storekeepersumm` | window | reportformat | Select Format | 1856 x 1016 | window |  |  |  |  |
| `w_selectformat_godown` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_godown_packing_stock` | window | reportformat | Select Format | 933 x 732 | window |  |  |  |  |
| `w_selectformat_godown_stockinhand` | window | reportformat | Select Format | 658 x 744 | window |  |  |  |  |
| `w_selectformat_godowndetailreport` | window | reportformat | Select Format | 1394 x 736 | window |  |  |  |  |
| `w_selectformat_godowngroup_stockinhand` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_godownstockandsale` | window | reportformat | Select Format | 1609 x 778 | window |  |  |  |  |
| `w_selectformat_headergeneral` | window | reportformat | Select Format | 786 x 644 | window |  |  |  |  |
| `w_selectformat_headerwisesummary` | window | reportformat | Select Format | 1467 x 728 | window |  |  |  |  |
| `w_selectformat_headerwisesummary2` | window | reportformat | Select Format | 1467 x 640 | window |  |  |  |  |
| `w_selectformat_headerwisetranssumm` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_icatwisenetsale` | window | reportformat | Select Report Type | 773 x 680 | window |  |  |  |  |
| `w_selectformat_inpatient_outpatient` | window | reportformat | Select Patient Category | 976 x 643 | window |  |  |  |  |
| `w_selectformat_inpatientbill` | window | reportformat | Select Format | 1147 x 1200 | window |  |  |  |  |
| `w_selectformat_inputax` | window | reportformat | Select Format | 1679 x 838 | window |  |  |  |  |
| `w_selectformat_installmentstatus` | window | reportformat | Select Format | 1367 x 644 | window |  |  |  |  |
| `w_selectformat_inventoryforecast` | window | reportformat | Select Format | 1819 x 1176 | window |  |  |  |  |
| `w_selectformat_issue_sale` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_issuedetail` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_item_netsales` | window | reportformat | Select Format | 1774 x 716 | window |  |  |  |  |
| `w_selectformat_itemactivity` | window | reportformat | Select Format | 1079 x 732 | window |  |  |  |  |
| `w_selectformat_itembasicdatachanges` | window | reportformat | Select Format | 846 x 644 | window |  |  |  |  |
| `w_selectformat_itemcat_netsalevolume` | window | reportformat | Select Format | 1701 x 740 | window |  |  |  |  |
| `w_selectformat_itemconversiondetail` | window | reportformat | Select Aging Criteria | 1207 x 644 | window |  |  |  |  |
| `w_selectformat_itemlabels` | window | reportformat | Select Aging Criteria | 1715 x 1981 | window |  |  |  |  |
| `w_selectformat_itemlist` | window | reportformat | Select Format | 1134 x 644 | window |  |  |  |  |
| `w_selectformat_itemlist_format` | window | reportformat | Select Format | 1551 x 883 | window |  |  |  |  |
| `w_selectformat_itempurchases` | window | reportformat | Select Report Type | 1321 x 872 | window |  |  |  |  |
| `w_selectformat_itemrefreshtype` | window | reportformat | Select Format | 1536 x 964 | window | d_arg_refreshtype |  |  |  |
| `w_selectformat_itemsaleanddiscount` | window | reportformat | Select Report Type | 1088 x 776 | window |  |  |  |  |
| `w_selectformat_itemsaleretactivity` | window | reportformat | Select Report Type | 1271 x 912 | window |  |  |  |  |
| `w_selectformat_itemsalereturn` | window | reportformat | Select Format | 1275 x 956 | window |  |  |  |  |
| `w_selectformat_label` | window | reportformat | Select Format | 1239 x 644 | window |  |  |  |  |
| `w_selectformat_lasttrans_selection` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_ledgertype` | window | reportformat | Select Report Type | 1558 x 2022 | window |  |  |  |  |
| `w_selectformat_machine_catwisesale` | window | reportformat | Select Format | 969 x 764 | window |  |  |  |  |
| `w_selectformat_machinesummary_advsale` | window | reportformat | Select Report Type | 1435 x 680 | window |  |  |  |  |
| `w_selectformat_machinewisesales` | window | reportformat | Select Format | 1239 x 808 | window |  |  |  |  |
| `w_selectformat_manf_cat_class_paking` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_manf_cat_class_paking2` | window | reportformat | Select Format | 882 x 776 | window |  |  |  |  |
| `w_selectformat_manf_cat_class_paking3` | window | reportformat | Select Format | 882 x 776 | window |  |  |  |  |
| `w_selectformat_manfwise_claimablereport` | window | reportformat | Select Format | 905 x 644 | window |  |  |  |  |
| `w_selectformat_minlevelreport` | window | reportformat | Select Format | 1211 x 644 | window |  |  |  |  |
| `w_selectformat_monthly_stockmovement` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_monthlyexpensesummary` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_monthlysales` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_monthlysalesreport` | window | reportformat | Select Format | 1312 x 820 | window |  |  |  |  |
| `w_selectformat_netpursummary` | window | reportformat | Select Format | 1902 x 803 | window |  |  |  |  |
| `w_selectformat_netsalesummary` | window | reportformat | Select Report Type | 1649 x 970 | window |  |  |  |  |
| `w_selectformat_norcoticsregister` | window | reportformat | Select Report Type | 677 x 680 | window |  |  |  |  |
| `w_selectformat_oneuser_alluser` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_opdpatientbill` | window | reportformat | Select Format | 1102 x 896 | window |  |  |  |  |
| `w_selectformat_outputsalestax` | window | reportformat | Select Report Type | 903 x 682 | window |  |  |  |  |
| `w_selectformat_patient_saledetail` | window | reportformat | Select Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_patientbalance` | window | reportformat | Select Format | 978 x 736 | window |  |  |  |  |
| `w_selectformat_patientcontact` | window | reportformat | Select Format | 1723 x 788 | window |  |  |  |  |
| `w_selectformat_patientledger` | window | reportformat | Select Format | 976 x 736 | window |  |  |  |  |
| `w_selectformat_patientlocation_ward` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_patientsaleretsum` | window | reportformat | Select Format | 1459 x 739 | window |  |  |  |  |
| `w_selectformat_patientsalesummary` | window | reportformat | Select Format | 1529 x 1126 | window |  |  |  |  |
| `w_selectformat_period_invrange` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_periodicpurchases` | window | reportformat | Select Mode | 891 x 812 | window |  |  |  |  |
| `w_selectformat_populateinvoices` | window | reportformat | Invoice Population Method | 978 x 644 | window |  |  |  |  |
| `w_selectformat_populateinvoices_criteria` | window | reportformat | Invoice Population Method | 1239 x 856 | window |  |  |  |  |
| `w_selectformat_portrait_landscape` | window | reportformat | Select Orientation | 677 x 644 | window |  |  |  |  |
| `w_selectformat_product_stockinhand` | window | reportformat | Select Format | 1445 x 614 | window |  |  |  |  |
| `w_selectformat_proformainvoice` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_purchase_receipt` | window | reportformat | Select Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_purnetratecomp` | window | reportformat | Select Format | 933 x 644 | window |  |  |  |  |
| `w_selectformat_pursumm` | window | reportformat | Select Format | 1664 x 1059 | window |  |  |  |  |
| `w_selectformat_qty_value_both` | window | reportformat | Select Format | 731 x 701 | window |  |  |  |  |
| `w_selectformat_refno_period` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_sale_or_all` | window | reportformat | Select Format | 1175 x 644 | window |  |  |  |  |
| `w_selectformat_sale_receipt` | window | reportformat |  | 978 x 644 | window |  |  |  |  |
| `w_selectformat_saleinvstatus` | window | reportformat | Select Format | 1562 x 982 | window |  |  |  |  |
| `w_selectformat_saleinvtypewisereport` | window | reportformat | Select Criteria | 969 x 644 | window |  |  |  |  |
| `w_selectformat_saleinvversion` | window | reportformat | Select Format | 1376 x 796 | window |  |  |  |  |
| `w_selectformat_saleorderstatus` | window | reportformat | Select Format | 2126 x 776 | window |  |  |  |  |
| `w_selectformat_saleordersumm_sectionwise` | window | reportformat | Select Aging Criteria | 969 x 576 | window |  |  |  |  |
| `w_selectformat_salesandcollection` | window | reportformat | Select Criteria | 1138 x 644 | window |  |  |  |  |
| `w_selectformat_salesman_itemsum_crosstab` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_salesman_netsales` | window | reportformat | Select Format | 1070 x 740 | window |  |  |  |  |
| `w_selectformat_salesmancustlist` | window | reportformat | Select Format | 1211 x 643 | window |  |  |  |  |
| `w_selectformat_salesmanreceipts` | window | reportformat | Select Report Type | 709 x 740 | window |  |  |  |  |
| `w_selectformat_salesperson_salesumm` | window | reportformat | Select Format | 976 x 774 | window |  |  |  |  |
| `w_selectformat_salestax_on_receipt` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_saletype` | window | reportformat | Select Sales Criteria | 969 x 672 | window |  |  |  |  |
| `w_selectformat_school_branch_service` | window | reportformat | Select Criteria | 1074 x 668 | window |  |  |  |  |
| `w_selectformat_serviceinvtype_gp` | window | reportformat | Select Format | 1458 x 840 | window |  |  |  |  |
| `w_selectformat_servicewiseprofit` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_single_range` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_single_range_period` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_slowfastmoving` | window | reportformat | Select Format | 1426 x 980 | window |  |  |  |  |
| `w_selectformat_sman_monthlysales` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_sman_netservices` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_spersonbased_saleformat` | window | reportformat | Select Format | 1638 x 643 | window |  |  |  |  |
| `w_selectformat_spersonincentive` | window | reportformat | Select Format | 1459 x 771 | window |  |  |  |  |
| `w_selectformat_sstatus_type` | window | reportformat | Select Aging Criteria | 677 x 644 | window |  |  |  |  |
| `w_selectformat_stock_classwise_godown` | window | reportformat | Select Format | 1221 x 1052 | window |  |  |  |  |
| `w_selectformat_stockinhand_categorywise` | window | reportformat | Select Format | 1728 x 1044 | window |  |  |  |  |
| `w_selectformat_stockinhand_genitemwise` | window | reportformat | Select Format | 1417 x 820 | window |  |  |  |  |
| `w_selectformat_stockinhand_manf` | window | reportformat | Select Format | 2139 x 1693 | window |  |  |  |  |
| `w_selectformat_stockinhand_margin` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_stockinhandmodelwise` | window | reportformat | Select Format | 1339 x 644 | window |  |  |  |  |
| `w_selectformat_stockitem_allitem` | window | reportformat |  | 855 x 644 | window |  |  |  |  |
| `w_selectformat_stockmovement_catwise` | window | reportformat | Select Format | 965 x 824 | window |  |  |  |  |
| `w_selectformat_stocksale_godown` | window | reportformat | Select Format | 987 x 596 | window |  |  |  |  |
| `w_selectformat_storekeepersummary` | window | reportformat | Select Format | 1275 x 644 | window |  |  |  |  |
| `w_selectformat_studentattendancesheet` | window | reportformat | Select Format | 1229 x 643 | window |  |  |  |  |
| `w_selectformat_studentbalance` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_studentdefaulterlist` | window | reportformat | Select Aging Criteria | 1723 x 672 | window |  |  |  |  |
| `w_selectformat_studentledger` | window | reportformat | Select Format | 976 x 643 | window |  |  |  |  |
| `w_selectformat_studentlist` | window | reportformat | Select Format | 1551 x 947 | window |  |  |  |  |
| `w_selectformat_subarea_netsalevolume` | window | reportformat | Select Report Type | 571 x 680 | window |  |  |  |  |
| `w_selectformat_subareamanfsalevol` | window | reportformat | Select Report Type | 677 x 680 | window |  |  |  |  |
| `w_selectformat_summ_acc_ledger_type` | window | reportformat | Select Report Type | 1595 x 824 | window |  |  |  |  |
| `w_selectformat_summaccbalance` | window | reportformat | Select Format | 590 x 644 | window |  |  |  |  |
| `w_selectformat_summary_detail` | window | reportformat | Select Report Type | 677 x 680 | window |  |  |  |  |
| `w_selectformat_summary_detail2` | window | reportformat | Select Report Type | 928 x 1044 | window |  |  |  |  |
| `w_selectformat_summary_detail_adj` | window | reportformat | Select Report Type | 677 x 680 | window |  |  |  |  |
| `w_selectformat_summary_issuereceipt` | window | reportformat | Select Report Type | 1001 x 680 | window |  |  |  |  |
| `w_selectformat_supp_servicecat_profit` | window | reportformat | Select Report Type | 677 x 682 | window |  |  |  |  |
| `w_selectformat_supp_suppcat_purtype` | window | reportformat | Select Format | 1367 x 644 | window |  |  |  |  |
| `w_selectformat_suppitems_default` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_suppliercategorywisenetpu` | window | reportformat | Select Report Type | 1413 x 564 | window |  |  |  |  |
| `w_selectformat_supplierledger_portrait` | window | reportformat | Select Report Type | 1236 x 765 | window |  |  |  |  |
| `w_selectformat_supplist` | window | reportformat | Select Format | 978 x 692 | window |  |  |  |  |
| `w_selectformat_supportbillsum` | window | reportformat | Select Format | 969 x 644 | window |  |  |  |  |
| `w_selectformat_suppwisepurdetail` | window | reportformat | Select Mode | 1243 x 986 | window |  |  |  |  |
| `w_selectformat_topncustomers` | window | reportformat | Select Format | 1381 x 848 | window |  |  |  |  |
| `w_selectformat_unpaid_due_purchases` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_userattendance` | window | reportformat | Select Report Type | 677 x 680 | window |  |  |  |  |
| `w_selectformat_userwise_categorysummary` | window | reportformat | Select Format | 1207 x 643 | window |  |  |  |  |
| `w_selectformat_userwisesales` | window | reportformat | Select Format | 1659 x 644 | window |  |  |  |  |
| `w_selectformat_vehicle_vehicletype` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_selectformat_voucherprinting` | window | reportformat | Select Format | 978 x 676 | window |  |  |  |  |
| `w_selection_area_region_zone` | window | reportformat | Selection Criteria | 1061 x 868 | window |  |  |  |  |
| `w_selection_manf_cat_class` | window | reportformat | Selection Criteria | 1061 x 816 | window |  |  |  |  |
| `w_selection_manf_cat_class_pack_etc` | window | reportformat | Select Column Criteria | 1061 x 1370 | window |  |  |  |  |
| `w_selection_manf_cat_class_packing` | window | reportformat | Select Column Criteria | 1061 x 800 | window |  |  |  |  |
| `w_selection_manf_cat_class_packing2` | window | reportformat | Select Column Criteria | 1070 x 812 | window |  |  |  |  |
| `w_selection_manf_cat_class_packing_mdisc` | window | reportformat | Select Column Criteria | 1061 x 928 | window |  |  |  |  |
| `w_selection_region_custcat` | window | reportformat | Selection Criteria | 1061 x 644 | window |  |  |  |  |
| `w_selection_reprioritize_item_stock` | window | reportformat | Selection Criteria | 1262 x 660 | window |  |  |  |  |
| `w_selection_transfer_1tomany` | window | reportformat | Select Transfer Report | 1847 x 1128 | window |  |  |  |  |
| `w_selectstockreport_inbackdate` | window | reportformat | Select Stock Report Type | 1061 x 868 | window |  |  |  |  |
| `w_stockandsale_orientation` | window | reportformat | Select Format For Stock and Sales Report | 2798 x 1693 | window |  |  |  |  |
| `w_voucherreceipt_printbalance` | window | reportformat | Select Format | 978 x 644 | window |  |  |  |  |
| `w_arg_acadamiclass_date` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_academicclass` | window | reports | Specify Retrieval Arguements | 2414 x 1875 | w_listarguments | d_arg_active_academicclasses |  |  |  |
| `w_arg_academicclass_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_active_academicclasses |  |  |  |
| `w_arg_academicclass_month_year` | window | reports | Specify Retrieval Arguements | 2414 x 1860 | w_listarguments | d_arg_active_academicclasses |  |  |  |
| `w_arg_academicclass_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_active_academicclasses |  |  |  |
| `w_arg_academicclass_servicetemplate` | window | reports | Specify Retrieval Arguements | 2414 x 1780 | w_listarguments | d_arg_active_academicclasses, d_arg_servicetemplate2 |  |  |  |
| `w_arg_academicclass_sinvcode_linvcode` | window | reports | Specify Retrieval Arguements | 2414 x 1875 | w_listarguments | d_arg_active_academicclasses |  |  |  |
| `w_arg_academicclass_svctemp2` | window | reports | Specify Retrieval Arguements | 2414 x 1846 | w_listarguments | d_arg_active_academicclasses, d_arg_servicetemplate_remarks2, d_service_price_selection |  |  |  |
| `w_arg_academicclass_svctemp_remarks` | window | reports | Specify Retrieval Arguements | 2414 x 1779 | w_listarguments | d_arg_active_academicclasses, d_arg_servicetemplate_remarks |  |  |  |
| `w_arg_acc_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_acc |  |  |  |
| `w_arg_account_godown` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arg_manf | d_arg_account_godown |  |  |  |
| `w_arg_account_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_account_godown |  |  |  |
| `w_arg_account_sinv_linv` | window | reports | Specify Retrieval Arguements | 2185 x 1436 | w_arguements | d_arg_account, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_accounts` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allaccounts |  |  |  |
| `w_arg_accounts_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allaccounts |  |  |  |
| `w_arg_activeclass_single` | window | reports | Specify Retrieval Arguements | 2368 x 963 | w_arguements | d_arg_activeclass_single |  |  |  |
| `w_arg_aging` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_aging_customerwise` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_aging_salesman` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_aging_subarea` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subarea2 |  |  |  |
| `w_arg_agingbased_epi` | window | reports | Specify Retrieval Arguements | 2377 x 1824 | w_listarguments | d_arg_area, d_arg_scode_lcode, d_arg_vouchcategory |  |  | w_calendar |
| `w_arg_agingdetail` | window | reports | Specify Retrieval Arguements | 2423 x 1188 | w_listarguments | d_arg_cust, d_arg_supp |  |  |  |
| `w_arg_agingdetail_saleperson` | window | reports | Specify Retrieval Arguements | 2423 x 1188 | w_listarguments | d_arg_salesman2 |  |  |  |
| `w_arg_allcust_manfs_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust, d_manufacturers |  |  |  |
| `w_arg_allowedgodowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allowedgodown |  |  |  |
| `w_arg_amount` | window | reports |  | 1211 x 432 | window |  |  |  |  |
| `w_arg_antinortixitem_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_antinortixitem |  |  |  |
| `w_arg_ason` | window | reports | Specify Retrieval Arguements | 1650 x 744 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_balancesheet` | window | reports | Specify Retrieval Arguments | 1554 x 964 | window |  |  |  |  |
| `w_arg_batch_selection` | window | reports | Selection List | 2898 x 1340 | w_popup_forselection_walias | d_popup_batchselection, ddd_godownlist_itempriority |  |  |  |
| `w_arg_batchno` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_billsummary_pop_invbased_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_billsummary_population` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_billsummary_population_invbased` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_billsummary_population_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_billsummaryreport` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_billsummaryreport_areawise` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_cat` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements |  |  |  |  |
| `w_arg_cat_area_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_area, d_arg_cat |  |  |  |
| `w_arg_cat_class_manufacturers` | window | reports | Specify Retrieval Arguements | 2359 x 1660 | w_arguements | d_arg_class, d_categories, d_manufacturers |  |  |  |
| `w_arg_cat_class_sdate_ldate_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_categories, ddd_tradeactualprice |  |  |  |
| `w_arg_cat_class_stockandsale` | window | reports | Specify Retrieval Arguements | 2423 x 1828 | w_listarguments | d_arg_class, d_categories, ddd_tradeactualprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_cat_godown` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat_godown |  |  |  |
| `w_arg_cat_manf` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat_manf, d_arg_godown |  |  |  |
| `w_arg_cat_manufacturers` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cat, d_manufacturers |  |  |  |
| `w_arg_cat_manufacturers_markup` | window | reports | Specify Retrieval Arguements | 2423 x 2308 | w_listarguments | d_arg_cat, d_arg_pricetype, d_manufacturers |  |  |  |
| `w_arg_cat_pack` | window | reports | Specify Retrieval Arguements | 1897 x 965 | w_arguements | d_arg_cat_pack |  |  |  |
| `w_arg_cat_pack_manf` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat_pack_manf |  |  |  |
| `w_arg_cat_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2688 x 1480 | w_arguements | d_arg_cat2 |  |  |  |
| `w_arg_cat_sdate_ldate1` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat |  |  |  |
| `w_arg_cat_sdate_ldate_projection` | window | reports | Specify Retrieval Arguements | 1947 x 992 | w_arguements | d_arg_manf |  |  |  |
| `w_arg_cat_single_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat |  |  |  |
| `w_arg_catacc_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_expense_categoryaccounts, d_arg_functionalarea |  |  |  |
| `w_arg_catacc_period_functionalarea` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_expense_categoryaccounts, d_arg_functionalarea |  |  |  |
| `w_arg_categories` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_models` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cat, d_arg_models |  |  |  |
| `w_arg_categories_models_backdate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cat, d_arg_models, d_arg_stockdate |  |  |  |
| `w_arg_categories_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_period_price_bonus_ret` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_tradeactualprice |  |  |  |
| `w_arg_categories_projection` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_projection_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_tradeactualprice |  |  |  |
| `w_arg_categories_sale_saledisc` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_saledisc, ddd_saleprice |  |  |  |
| `w_arg_categories_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_sdate_ldate_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_sdate_ldate_salecat` | window | reports | Specify Retrieval Arguements | 2423 x 1840 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_slow` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_stock` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_stock_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_stockandsale` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_actualtradeprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_categories_transfer` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_v1` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_categories_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_category_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_category_smonth` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_month, ddd_tradeactualprice, ddd_year |  |  |  |
| `w_arg_category_smonth_returnsoption` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_month, ddd_tradeactualprice, ddd_year |  |  |  |
| `w_arg_category_stockandsale` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_actualtradeprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_class` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_class |  |  |  |
| `w_arg_class_cat` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat_class |  |  |  |
| `w_arg_class_cat2` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat_class2 |  |  |  |
| `w_arg_class_day` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_class_pack` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_class_pack |  |  |  |
| `w_arg_class_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_class |  |  |  |
| `w_arg_class_sdate_ldate_all` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_class_sdate_ldate_all2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_class_sdate_ldate_all_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_class_sdate_ldate_invtype` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_class |  |  |  |
| `w_arg_class_sdate_ldate_v3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, ddd_salediscno, ddd_salepriceno |  |  |  |
| `w_arg_class_user_sdate_ldate_all` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_users |  |  |  |
| `w_arg_class_user_sdate_ldate_all2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_users |  |  |  |
| `w_arg_classes_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_classwise_studentselection_forsms` | window | reports | Populate Phone No. of SMS Recipient | 2962 x 1780 | window | d_studentlist_for_an_activeclass |  |  |  |
| `w_arg_clientinstance` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_crs_clientinstance |  |  |  |
| `w_arg_code` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_sale |  |  |  |
| `w_arg_code_caption` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_code_caption |  |  |  |
| `w_arg_contactselection` | window | reports | Populate Sale Invoice(s) | 2862 x 1788 | window | d_contactselection_detail, d_contactselection_header |  |  |  |
| `w_arg_contactselection_smscenter` | window | reports | Populate Sale Invoice(s) | 2862 x 1788 | window | d_contactselection_header, d_smscenter_contactselection_detail |  |  |  |
| `w_arg_containerno` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_custgroup` | window | reports | Specify Retrieval Arguements | 2661 x 963 | w_arguements | d_arg_custrgroup |  |  |  |
| `w_arg_custgroup_itemgroup` | window | reports | Specify Retrieval Arguements | 2661 x 963 | w_arguements | d_arg_custrgroup_itemgroup |  |  |  |
| `w_arg_custgroup_salesman` | window | reports | Specify Retrieval Arguements | 2661 x 963 | w_arguements | d_arg_custrgroup_salesman |  |  |  |
| `w_arg_customer_active_yesno` | window | reports |  | 1211 x 432 | window | d_arg_yesno_both |  |  |  |
| `w_arg_customerservicetemplate` | window | reports | Specify Retrieval Arguements | 2203 x 980 | w_arguements | d_arg_customerservicetemplate |  |  |  |
| `w_arg_customerservicetemplate_posted` | window | reports | Specify Retrieval Arguements | 2203 x 980 | w_arguements | d_arg_customerservicetemplate_posted |  |  |  |
| `w_arg_date` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_date_class` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_date_cust_discinput_dateoption_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1932 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_cust_discinput_dateoption_v3` | window | reports | Specify Retrieval Arguements | 2423 x 1932 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_cust_discinput_less_amt` | window | reports | Specify Retrieval Arguements | 2423 x 2044 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_dateoption` | window | reports | Specify Retrieval Arguements | 2423 x 2045 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_disc_gst_dateoption` | window | reports | Specify Retrieval Arguements | 2423 x 2045 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_disc_inputstring` | window | reports | Specify Retrieval Arguements | 2432 x 2004 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_discinput` | window | reports | Specify Retrieval Arguements | 2423 x 1932 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_discinput_dateoption` | window | reports | Specify Retrieval Arguements | 2423 x 2044 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_inputstring` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customer_inputstring3` | window | reports | Specify Retrieval Arguements | 2423 x 2045 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customerv2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customerv3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customerv4` | window | reports | Specify Retrieval Arguements | 2423 x 1884 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_customerv5` | window | reports | Specify Retrieval Arguements | 2423 x 1884 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_date_doctors` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_doctor |  |  |  |
| `w_arg_date_doctors_disc` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_doctor |  |  |  |
| `w_arg_date_manufacturer` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manfacturer |  |  |  |
| `w_arg_date_purchasetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_purchasetype |  |  |  |
| `w_arg_date_wards` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_ward |  |  |  |
| `w_arg_date_wards_cust` | window | reports | Specify Retrieval Arguements | 2423 x 1972 | w_listarguments | d_arg_cust, d_arg_ward |  |  |  |
| `w_arg_day` | window | reports | Specify Retrieval Arguements | 1897 x 965 | w_arguements | d_arg_days |  |  |  |
| `w_arg_decimal_val` | window | reports |  | 1712 x 432 | window |  |  |  |  |
| `w_arg_deliveredby_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_deliveredby_sinv_linv` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_department_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_department |  |  |  |
| `w_arg_discperc` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_discperc |  |  |  |
| `w_arg_disease_diseasetype` | window | reports | Specify Retrieval Arguements | 2235 x 973 | w_arguements | d_arg_disease_diseasetype |  |  |  |
| `w_arg_diseases` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_disease |  |  |  |
| `w_arg_diseases_diseasetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_disease_diseasetype |  |  |  |
| `w_arg_diseases_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_disease |  |  |  |
| `w_arg_diseasetreatmenttemplate` | window | reports | Specify Retrieval Arguements | 2523 x 972 | w_arguements | d_arg_diseasetreatrmenttemplate |  |  |  |
| `w_arg_diseasetreatmenttemplate_disease` | window | reports | Specify Retrieval Arguements | 2319 x 973 | w_arguements | d_arg_diseasetreatrmenttemplate_disease |  |  |  |
| `w_arg_diseasetype` | window | reports | Specify Retrieval Arguements | 2235 x 972 | w_arguements | d_arg_diseasetype |  |  |  |
| `w_arg_doct_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_doctor |  |  |  |
| `w_arg_doct_svccat_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_doctor, d_arg_servicecategory |  |  |  |
| `w_arg_doctors` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_doctor2 |  |  |  |
| `w_arg_doctors_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_doctor2 |  |  |  |
| `w_arg_emp_category` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_category, d_arg_emp_department |  |  |  |
| `w_arg_emp_category_dept_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_emp_category, d_arg_emp_department |  |  |  |
| `w_arg_emp_category_period` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_category, d_arg_emp_department |  |  |  |
| `w_arg_emp_department` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_department |  |  |  |
| `w_arg_emp_department_period` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_department |  |  |  |
| `w_arg_emp_designation` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_department, d_arg_emp_designation |  |  |  |
| `w_arg_emp_designation_period` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_emp_department, d_arg_emp_designation |  |  |  |
| `w_arg_employeeselection_forsms` | window | reports | Populate Phone No. of SMS Recipient | 2962 x 1780 | window | d_employeeselection_forsms |  |  |  |
| `w_arg_expense_catacc_sdate_ldate_type` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_expense_categoryaccounts, d_arg_functionalarea |  |  |  |
| `w_arg_genericitems_only` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_genericitem |  |  |  |
| `w_arg_genericitems_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_genericitem |  |  |  |
| `w_arg_genericitemtype_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_genericitemtype |  |  |  |
| `w_arg_godown` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arg_manf | d_arg_godown |  |  |  |
| `w_arg_godown_categories_dates_price` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown, d_categories, ddd_purpriceavgprice |  |  |  |
| `w_arg_godown_categories_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown, d_categories |  |  |  |
| `w_arg_godown_item` | window | reports | Selection List | 2882 x 1412 | w_popup_forselection_walias | d_arg_godown, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_godown_item_sdate_ldate` | window | reports | Selection List | 2882 x 1412 | w_popup_forselection_walias | d_arg_godown, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_godown_item_stockregister` | window | reports | Selection List | 2882 x 1412 | w_popup_forselection_walias | d_arg_godown, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_godown_manuf_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown, d_manufacturers |  |  |  |
| `w_arg_godown_manufacturers_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown, d_manufacturers |  |  |  |
| `w_arg_godown_price` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arg_manf | d_arg_godown |  |  |  |
| `w_arg_godown_saleman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_godown2, d_arg_salesman |  |  |  |
| `w_arg_godown_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_godown |  |  |  |
| `w_arg_godown_sdate_ldate_v1` | window | reports | Specify Parameters To Generate Sale | 2039 x 996 | w_arguements | d_arg_godown |  |  |  |
| `w_arg_godown_sinv_linv` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_godown, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_godown_sinv_linv_sale_sret` | window | reports | Specify Retrieval Arguements | 2423 x 1780 | w_listarguments | d_arg_header, d_arg_sinvcode_linvcode, d_arg_transfergodown |  |  |  |
| `w_arg_godown_sinvcode_linvcode` | window | reports | Specify Retrieval Arguements | 2423 x 1812 | w_listarguments | d_arg_transfergodown |  |  |  |
| `w_arg_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown2 |  |  |  |
| `w_arg_godowns_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown2 |  |  |  |
| `w_arg_godowns_sdate_ldate_rpp_avg` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown2, ddd_avgpricerpp |  |  |  |
| `w_arg_godowns_sdate_ldate_rpp_avg_comm` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_godown2, ddd_avgpricerpp |  |  |  |
| `w_arg_group` | window | reports | Specify Retrieval Arguements | 1902 x 964 | w_arg_manf | d_arg_group |  |  |  |
| `w_arg_group_allowedgodowns_zqty` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allowedgodown, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_group_allowedgodowns_zqty_ptype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allowedgodown, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_groupaccounts_expense_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subaccounts_expense |  |  |  |
| `w_arg_groupaccounts_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subaccounts |  |  |  |
| `w_arg_grouping` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_area_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_area_period_top` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_ccat_area` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_class, d_arg_customercat, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_dates` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_cashcredit` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_cashcredit_batch` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_ref, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_price` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_dates_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_pricetype2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_dates_pricetype3` | window | reports | Specify Retrieval Arguements | 2423 x 1923 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_dates_pricetype4` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_typepofprice2 |  |  |  |
| `w_arg_grouping_dates_pricetype_batch` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_ref, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_dates_pricetype_old` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_pricetype_zone` | window | reports | Specify Retrieval Arguements | 2423 x 1700 | w_listarguments | d_arg_class, d_arg_packing, d_arg_zone, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_grouping_dates_zoneothers_price` | window | reports | Specify Retrieval Arguements | 2423 x 1868 | w_listarguments | d_arg_class, d_arg_packing, d_arg_zone, d_itemcategories, d_manufacturers, ddd_tradeactualprice | _utn, zoneareas |  |  |
| `w_arg_grouping_godowngroup` | window | reports |  | 2423 x 1684 | w_listarguments | d_arg_class, d_arg_packing, d_categories, d_godowngroup, d_itemcategories, d_manufacturers ... |  |  |  |
| `w_arg_grouping_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_godowns_allowed` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown_allowed, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_godowns_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_godowns_zeroqty_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_price` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_price_batch` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_batchno, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_typeofprice_v2 |  |  |  |
| `w_arg_grouping_pricetype2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_region_include_bns_ret` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_categories, d_itemcategories, d_manufacturers, d_region ... |  |  |  |
| `w_arg_grouping_sperson_period_top` | window | reports | Specify Retrieval Arguements | 2450 x 1988 | w_listarguments | d_arg_class, d_arg_packing, d_arg_salesman, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_grouping_stockandsale` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_tradeactualprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_grouping_zeroqty_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_groups` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_group |  |  |  |
| `w_arg_groupsummacc` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_groupsummaryaccount |  |  |  |
| `w_arg_groupsummacc_expaccounts_period` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_account_expensesummary, d_arg_groupsummaryaccount |  |  |  |
| `w_arg_groupsummacc_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_groupsummaryaccount |  |  |  |
| `w_arg_groupsummacc_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_groupsummaryaccount |  |  |  |
| `w_arg_gstperc` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_gstperc |  |  |  |
| `w_arg_guest_guestcheckin` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_guestcheckin, d_popup_guestselected, d_popup_guestselection |  |  |  |
| `w_arg_guest_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_guestselected_1, d_popup_guestselection |  |  |  |
| `w_arg_guest_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_guestselected_1, d_popup_guestselection_1 |  |  |  |
| `w_arg_guests_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_guestselected, d_popup_guestselection |  |  |  |
| `w_arg_guests_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_guestselected, d_popup_guestselection |  |  |  |
| `w_arg_header` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_header |  |  |  |
| `w_arg_header_detailsummary` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_header |  |  |  |
| `w_arg_header_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_header |  |  |  |
| `w_arg_headerno_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_header |  |  |  |
| `w_arg_incomestatement` | window | reports | Specify Retrieval Arguments | 1554 x 963 | window |  |  |  |  |
| `w_arg_integer_val` | window | reports |  | 1887 x 432 | window |  |  |  |  |
| `w_arg_inv_header` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_header, d_arg_sinvcode |  |  |  |
| `w_arg_invcode_caption` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_sale |  |  |  |
| `w_arg_invcode_percent` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_sale |  |  |  |
| `w_arg_invcode_print_date_expiry_batch` | window | reports | Specify Retrieval Arguements | 1897 x 1040 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_invcode_printdate_printexpiry` | window | reports | Specify Retrieval Arguements | 1897 x 972 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_issue` | window | reports | Specify Retrieval Arguements | 2464 x 963 | w_arguements | d_arg_issue |  |  |  |
| `w_arg_issue_receipt_ggroup_period` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_godowngroup |  |  |  |
| `w_arg_issuetype_ref` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_issuetype_ref |  |  |  |
| `w_arg_item` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_area_sdate_ldate` | window | reports | Selection List | 2882 x 1412 | w_popup_forselection_walias | d_arg_area, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_area_sdate_ldate_pricetype` | window | reports | Selection List | 2882 x 1412 | w_popup_forselection_walias | d_arg_area, d_popup_itemselected, d_popup_itemselection, ddd_tradeactualprice |  |  |  |
| `w_arg_item_batch_generation_purchase` | window | reports | Auto Batch Generation | 2889 x 1708 | w_popup_forselection_walias | d_generatebatches_purchase, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_batch_generation_receipt` | window | reports | Selection List | 2889 x 1708 | w_popup_forselection_walias | d_generatebatches, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_batch_salereturn_issuebased` | window | reports | Selection List | 2889 x 1336 | w_popup_forselection_walias | d_issuebased_batch_salereturn, d_popup_itemselected, d_popup_itemselection | issuedetail, srdetail | batchwisesalereturn_issuebased |  |
| `w_arg_item_find_and_replace_salinvgroup` | window | reports | Selection List | 2783 x 1488 | w_popup_forselection_walias2 | d_arg_saleprice, d_arg_saleprice_disabled, d_popup_itemselected, d_popup_itemselection | item |  |  |
| `w_arg_item_item2` | window | reports | Selection List | 2783 x 1488 | w_popup_forselection_walias2 | d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_itemcols_sdate_ldate` | window | reports | Selection List | 2882 x 1596 | w_popup_forselection_walias | d_itembasicdatachanges, d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_item_populate` | window | reports | Specify Retrieval Arguements | 2368 x 1792 | w_arguements | d_arg_class, d_arg_godownpriority, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_item_populate2` | window | reports | Specify Retrieval Arguements | 2368 x 1792 | w_arguements | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_item_populate3` | window | reports | Specify Retrieval Arguements | 2368 x 1792 | w_arguements | d_arg_class, d_arg_godownpriority, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_item_populate4` | window | reports | Specify Retrieval Arguements | 2368 x 1792 | w_arguements | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_item_populate_all_withoutgodown` | window | reports | Specify Retrieval Arguements | 2405 x 2112 | w_arguements | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_item_price` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection, ddd_typepofprice |  |  |  |
| `w_arg_item_recipe_qty_sdate_ldate` | window | reports | Selection List | 2907 x 1652 | w_popup_forselection_walias | d_arg_item_recipe, d_popup_itemselected, d_popup_itemselection, d_qty |  |  |  |
| `w_arg_item_saleprice_discperc` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_saleprice_discperc, d_popup_itemselected, d_popup_itemselection | item |  |  |
| `w_arg_item_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_sdate_ldate_newstockregister` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_sdate_ldate_old` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_item |  |  |  |
| `w_arg_item_sdate_ldate_pricetype` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection, ddd_typepofprice |  |  |  |
| `w_arg_item_sdate_ldate_stockregister` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection, d_stockregisterformats |  |  |  |
| `w_arg_item_smans_sdate_ldate` | window | reports | Selection List | 2882 x 1968 | w_popup_forselection_walias | d_arg_salesman, d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_item_smonth_lmonth` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_item, ddd_month, ddd_year |  |  |  |
| `w_arg_itemalert_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_itemalert |  |  |  |
| `w_arg_itemalert_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_itemalert |  |  |  |
| `w_arg_itemalert_sdate_ldate_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_itemalert |  |  |  |
| `w_arg_itemcat_itemcols_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, d_itembasicdatachanges |  |  |  |
| `w_arg_itemcat_period_disc1range_disc2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, ddd_saleprice |  |  |  |
| `w_arg_itemcategories` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories |  |  |  |
| `w_arg_itemgroup` | window | reports | Specify Retrieval Arguements | 2007 x 964 | w_arg_manf | d_arg_itemgroup |  |  |  |
| `w_arg_itemgroups` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_itemgroup |  |  |  |
| `w_arg_itemregrequest` | window | reports | Specify Retrieval Arguements | 2473 x 963 | w_arguements | d_arg_itemregrequest |  |  |  |
| `w_arg_items` | window | reports | Selection List | 3186 x 1420 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_area_sdate_ldate_pricetype` | window | reports | Selection List | 2882 x 1384 | w_popup_forselection_walias | d_arg_area, d_popup_itemselected_arglist, d_popup_itemselection, ddd_tradeactualprice |  |  |  |
| `w_arg_items_discperc` | window | reports | Selection List | 3185 x 1536 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection, ddd_itemdiscpercs |  |  |  |
| `w_arg_items_documentfiltered` | window | reports | Selection List | 3185 x 1421 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection_documentfiltered |  |  |  |
| `w_arg_items_filtered` | window | reports | Selection List | 3186 x 1420 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection | manufacturer |  |  |
| `w_arg_items_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_sdate_ldate_antinorcotix` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection_antinorcotix |  |  |  |
| `w_arg_items_sdate_ldate_notallitem` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_sdate_ldate_pick10items` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_sdate_ldate_purcategory` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_sdate_ldate_stockregister` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection, d_stockregisterformats |  |  | w_arg_masterpart |
| `w_arg_items_sdate_ldate_stockregisternew` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_itemselected_arglist, d_popup_itemselection |  |  | w_arg_masterpart |
| `w_arg_items_sdate_ldate_topn` | window | reports | Selection List | 2889 x 1254 | w_popup_forselection_walias | d_arg_top_n_customers, d_popup_itemselected_arglist, d_popup_itemselection |  |  |  |
| `w_arg_items_sman_sdate_ldate` | window | reports | Selection List | 2882 x 1386 | w_popup_forselection_walias | d_arg_salesman, d_popup_itemselected_arglist, d_popup_itemselection, ddd_tradeactualprice |  |  |  |
| `w_arg_ldate_purchasetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_purchasetype |  |  |  |
| `w_arg_letter_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2770 x 1448 | w_arguements | d_arg_letter |  |  |  |
| `w_arg_linestyle` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_class |  |  |  |
| `w_arg_machine_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1915 x 1124 | w_arguements | d_arg_machinename |  |  |  |
| `w_arg_machine_sinv_linv` | window | reports | Specify Retrieval Arguements | 1898 x 1411 | w_arguements | d_arg_machinename_sinv_linv, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_manf` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arguements | d_arg_manf |  |  |  |
| `w_arg_manf_area_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_area, d_arg_manf |  |  |  |
| `w_arg_manf_cat_class` | window | reports | Specify Retrieval Arguements | 2377 x 1976 | w_arguements | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manf_cat_class_pack` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat, d_arg_class, d_arg_manf, d_arg_packing |  |  |  |
| `w_arg_manf_cat_class_pack_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat, d_arg_class, d_arg_manf, d_arg_packing |  |  |  |
| `w_arg_manf_cat_class_pack_single` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manf_cat_class_packing` | window | reports | Specify Retrieval Arguements | 2368 x 1904 | w_arguements | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manf_category_class_pack_oneorall` | window | reports | Specify Retrieval Arguements | 2075 x 996 | w_arguements | d_manf_cat_class_packing_onle_all |  |  |  |
| `w_arg_manf_cust_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_select_cust, d_manufacturers |  |  |  |
| `w_arg_manf_custcat_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2071 x 976 | w_arguements | d_arg_customercat, d_arg_manf |  |  |  |
| `w_arg_manf_day` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manf_godown` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arguements | d_arg_manf_godown |  |  |  |
| `w_arg_manf_just` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manf_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manf_manf_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1911 x 976 | w_arguements | d_arg_manf_manf |  |  |  |
| `w_arg_manf_month_year` | window | reports | Specify Retrieval Arguements | 1897 x 1012 | w_arguements | d_arg_manf, ddd_month, ddd_year |  |  |  |
| `w_arg_manf_sale_saledisc` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_saledisc, ddd_saleprice |  |  |  |
| `w_arg_manf_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_manf |  |  |  |
| `w_arg_manf_sdate_ldate_abbott` | window | reports | Specify Retrieval Arguements | 1897 x 1464 | w_arguements | d_arg_distcode, d_arg_manf, d_custdata_abbott, d_invdata_abbott, d_stockdata_abbott |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_amarantpharma` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manfcategory, d_custdata_dsr_amarantpharma, d_invdata_dsr_amarantpharma, d_stockdata_dsr_amarantpharma |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_amarantpharmaold` | window | reports | Specify Retrieval Arguements | 1934 x 1396 | w_arguements | d_areadata_amarantpharma, d_arg_distcode, d_arg_manf, d_custdata_amarantpharma, d_invdata_amarantpharma, d_proddata_amarantpharma |  |  |  |
| `w_arg_manf_sdate_ldate_amsonpharma` | window | reports | Specify Retrieval Arguements | 1898 x 1594 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_amsonpharma, d_invdata_dsr_amsonpharma, d_proddata_dsr_amsonpharma, d_stockdata_dsr_amsonpharma ... |  |  |  |
| `w_arg_manf_sdate_ldate_atco` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_atco, d_custdata_atco_excel, d_invdata_atco, d_invdata_atco_excel |  |  |  |
| `w_arg_manf_sdate_ldate_biolabpharma` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode, d_arg_manf, d_custdata_biolabpharma, d_invdata_biolabpharma, d_proddata_biolabpharma |  |  |  |
| `w_arg_manf_sdate_ldate_bmbiotech` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode, d_arg_manf, d_brickdata_bmbiotech, d_custdata_bmbiotech, d_invdata_bmbiotech, d_proddata_bmbiotech |  |  |  |
| `w_arg_manf_sdate_ldate_bosch` | window | reports | Specify Retrieval Arguements | 1920 x 1296 | w_arguements | d_arg_manf, d_bosch_batchstock, d_bosch_sales_and_return_data, d_bosch_sales_and_return_data_approval |  |  |  |
| `w_arg_manf_sdate_ldate_brooks` | window | reports | Specify Retrieval Arguements | 1934 x 1360 | w_arguements | d_areadata_brooks, d_arg_manf, d_custdata_brooks, d_invdata_brooks, d_proddata_brooks |  |  |  |
| `w_arg_manf_sdate_ldate_dist` | window | reports | Specify Retrieval Arguements | 2267 x 1024 | w_arguements | d_arg_manf |  |  |  |
| `w_arg_manf_sdate_ldate_efroze_stocknsale` | window | reports | Specify Retrieval Arguements | 1934 x 1392 | w_arguements | d_arg_manf, d_efroze_stocknsale_ssr |  |  |  |
| `w_arg_manf_sdate_ldate_ferozsons` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_ferozsons, d_invdata_dsr_ferozsons, d_proddata_dsr_ferozsons, d_stockdata_dsr_ferozsons ... |  |  |  |
| `w_arg_manf_sdate_ldate_getz` | window | reports | Specify Retrieval Arguements | 1897 x 1448 | w_arguements | d_arg_distcode, d_arg_manf, d_invdata_getz, d_proddata_getz, d_stockdata_getz, d_towndata_getz |  |  |  |
| `w_arg_manf_sdate_ldate_globalpharma` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_globalpharma, d_invdata_dsr_globalpharma, d_proddata_dsr_globalpharma, d_stockdata_dsr_globalpharma ... |  |  |  |
| `w_arg_manf_sdate_ldate_highqpharma` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_highq, d_arg_manf, d_custdata_dsr_highqpharma, d_invdata_dsr_highqpharma, d_proddata_dsr_highqpharma, d_stockdata_dsr_highqpharma ... |  |  |  |
| `w_arg_manf_sdate_ldate_hilton` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem, d_arg_manf, d_custdata_dsr_hilton, d_custdata_hilton, d_invdata_dsr_hilton, d_invdata_hilton ... |  |  |  |
| `w_arg_manf_sdate_ldate_libra` | window | reports | Specify Retrieval Arguements | 1898 x 1594 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_brickdata_dsr_libra, d_custdata_dsr_libra, d_invdata_dsr_libra, d_proddata_dsr_libra ... |  |  |  |
| `w_arg_manf_sdate_ldate_macter` | window | reports | Specify Retrieval Arguements | 1897 x 1464 | w_arguements | d_arg_distcode, d_arg_manf, d_custdata_dsr_macter, d_invdata_dsr_macter, d_proddata_dsr_macter, d_stockdata_dsr_macter |  |  |  |
| `w_arg_manf_sdate_ldate_mandp` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_mandp, d_invdata_dsr_mandp, d_proddata_dsr_mandp, d_stockdata_dsr_mandp |  |  |  |
| `w_arg_manf_sdate_ldate_markermerck` | window | reports | Specify Retrieval Arguements | 1915 x 1600 | w_arguements | d_arg_zone_details, d_custdata_merckmarker, d_invdata_merckmarker, d_proddata_merckmarker | zone |  |  |
| `w_arg_manf_sdate_ldate_martindow` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_martindow, d_invdata_martindow, d_proddata_martindow, d_stockdata_martindow ... |  |  |  |
| `w_arg_manf_sdate_ldate_masspharma` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_masspharma, d_arg_manf, d_custdata_dsr_masspharma, d_invdata_dsr_masspharma, d_proddata_dsr_masspharma, d_stockdata_dsr_masspharma |  |  |  |
| `w_arg_manf_sdate_ldate_matrix` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_matrix, d_invdata_matrix |  |  |  |
| `w_arg_manf_sdate_ldate_mds` | window | reports | Specify Retrieval Arguements | 1915 x 1608 | w_arguements | d_arg_distcode, d_arg_manf, d_custdata_mds, d_invdata_mds, d_stockdata_mds |  |  |  |
| `w_arg_manf_sdate_ldate_merck` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_merck, d_invdata_merck, d_smandata_merck |  |  |  |
| `w_arg_manf_sdate_ldate_merck2` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_merck2 |  |  | w_arg_custcategories |
| `w_arg_manf_sdate_ldate_merck_stock` | window | reports | Specify Retrieval Arguements | 1898 x 1498 | w_arguements | d_arg_manf, d_stockdata_merckmarker |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_meteir` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_meteir, d_invdata_meteir, d_stockdata_meteir, d_transdata_meteir |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_neutro` | window | reports | Specify Retrieval Arguements | 1898 x 1594 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_neutropharma, d_invdata_dsr_neutropharma, d_proddata_dsr_neutropharma, d_stockdata_dsr_neutropharma |  |  |  |
| `w_arg_manf_sdate_ldate_nextpharma` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_nextpharma, d_invdata_nextpharma, d_stockdata_nextpharma |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_obs` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_obs, d_invdata_obs, d_stockdata_obs |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_otsuka` | window | reports | Specify Retrieval Arguements | 1898 x 1498 | w_arguements | d_arg_manf, d_custdata_otsuka, d_invdata_otsuka, d_stockdata_otsuka |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_pacific` | window | reports | Specify Retrieval Arguements | 1906 x 1624 | w_arguements | d_arg_distcode_city, d_arg_manf, d_pacificpharma_brick, d_pacificpharma_chemist, d_pacificpharma_item, d_pacificpharma_territory ... |  |  |  |
| `w_arg_manf_sdate_ldate_pacific2` | window | reports | Specify Retrieval Arguements | 1905 x 1626 | w_arguements | d_arg_distcode_city2, d_arg_manf, d_pacificpharma2_brick, d_pacificpharma2_chemist, d_pacificpharma2_item, d_pacificpharma2_stock ... |  |  |  |
| `w_arg_manf_sdate_ldate_pharmahealth` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_pharmahealth, d_invdata_dsr_pharmahealth, d_proddata_dsr_pharmahealth, d_stockdata_dsr_pharmahealth |  |  |  |
| `w_arg_manf_sdate_ldate_pharmalink` | window | reports | Specify Retrieval Arguements | 1897 x 1352 | w_arguements | d_arg_manf, d_invdata_pharmalink, d_invdata_pharmalink_detail |  |  |  |
| `w_arg_manf_sdate_ldate_premieragency` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_premieragency, d_invdata_dsr_premieragency, d_proddata_dsr_premieragency |  |  |  |
| `w_arg_manf_sdate_ldate_racket` | window | reports | Specify Retrieval Arguements | 1898 x 1594 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_branddata_dsr_racket, d_custdata_dsr_racket, d_invdata_dsr_racket, d_smandata_dsr_racket ... |  |  |  |
| `w_arg_manf_sdate_ldate_remington` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_remington, d_invdata_remington, d_stockdata_remington |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_sami` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_sami, d_invdata_dsr_sami, d_proddata_dsr_sami, d_stockdata_dsr_sami |  |  |  |
| `w_arg_manf_sdate_ldate_sanofi` | window | reports | Specify Retrieval Arguements | 1920 x 1496 | w_arguements | d_arg_manf, d_custdata_sanofi, d_invdata_sanofi, d_stockdata_sanofi, d_summdata_sanofi |  |  |  |
| `w_arg_manf_sdate_ldate_schazoozaka` | window | reports | Specify Retrieval Arguements | 2007 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_batchdata_dsr_schazoozaka, d_custdata_dsr_schazoozaka, d_invdata_dsr_schazoozaka, d_proddata_dsr_schazoozaka ... |  |  |  |
| `w_arg_manf_sdate_ldate_scilife` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata2_scilife, d_custdata_scilife, d_invdata_scilife, d_stockdata_scilife |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_shaigan` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_brickdata_dsr_shaigan, d_custdata_dsr_shaigan, d_invdata_dsr_shaigan, d_proddata_dsr_shaigan ... |  |  |  |
| `w_arg_manf_sdate_ldate_siza` | window | reports | Specify Retrieval Arguements | 1925 x 1320 | w_arguements | d_arg_manf, d_siza_excel_data, d_siza_textreport |  |  |  |
| `w_arg_manf_sdate_ldate_sjg_fazulelahi` | window | reports | Specify Retrieval Arguements | 1898 x 1347 | w_arguements | d_arg_manf, d_custdata_sjg, d_invdata_sjg, d_stockdata_sjg |  |  | w_arg_manufacturers_only, w_select_general_crs |
| `w_arg_manf_sdate_ldate_standpharm` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_standpharm, d_invdata_standpharm, d_stockdata_standpharm |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_surge` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_surge, d_invdata_surge |  |  |  |
| `w_arg_manf_sdate_ldate_vikor` | window | reports | Specify Retrieval Arguements | 1897 x 1592 | w_arguements | d_arg_distcode_targetsystem_vikor, d_arg_manf, d_custdata_dsr_vikor, d_invdata_dsr_vikor, d_proddata_dsr_vikor, d_stockdata_dsr_vikor |  |  |  |
| `w_arg_manf_sdate_ldate_wilsons` | window | reports | Specify Retrieval Arguements | 1897 x 1496 | w_arguements | d_arg_manf, d_custdata_wilsons, d_invdata_wilsons, d_stockdata_wilsons |  |  | w_select_general_crs |
| `w_arg_manf_sdate_ldate_wwoodwards` | window | reports | Specify Retrieval Arguements | 1897 x 1464 | w_arguements | d_arg_distcode, d_arg_manf, d_custdata_dsr_wwoodwards, d_invdata_dsr_wwoodwards, d_proddata_dsr_wwoodwards, d_stockdata_dsr_wwoodwards |  |  |  |
| `w_arg_manf_zone_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_manf, d_arg_zone |  |  |  |
| `w_arg_manfcategory_sman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manfcategory2, d_arg_salesman |  |  |  |
| `w_arg_manfs_cats_classes_packs` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_area` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_ccat_area` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_class, d_arg_customercat, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_custcats` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_customercat, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_dates` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_dates_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_dates_v3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_days` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_godowns2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_itemgroup` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_itemgroup, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_manfs` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_manf, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_price` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_typeofprice_v2 |  |  |  |
| `w_arg_manfs_cats_classes_packs_price_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_typeofprice_v2, ddd_typeofprice_v3 |  |  |  |
| `w_arg_manfs_cats_classes_packs_region` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_categories, d_itemcategories, d_manufacturers, d_region ... |  |  |  |
| `w_arg_manfs_cats_classes_packs_region2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_categories, d_itemcategories, d_manufacturers, d_region ... |  |  |  |
| `w_arg_manfs_cats_classes_packs_region3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_categories, d_itemcategories, d_manufacturers, d_region ... |  |  |  |
| `w_arg_manfs_cats_classes_packs_regions` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, d_region |  |  |  |
| `w_arg_manfs_cats_classes_packs_subarea` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_subarea, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_cats_classes_packs_subarea2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_subarea, d_itemcategories, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_manfs_cats_classes_packs_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1856 | w_listarguments | d_arg_class, d_arg_packing, d_itemcategories, d_manufacturers, ddd_salediscno, ddd_salepriceno |  |  |  |
| `w_arg_manfs_cats_classes_packs_zones` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_zone, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_classes` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_manufacturers, ddd_tradeactualprice |  |  |  |
| `w_arg_manfs_custgroup_godowns_period` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_class, d_arg_custgroup, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_custs_date` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_cust, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_custs_disc_perc_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_cust, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_custs_godowns_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_cust, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_custs_godowns_sdate_ldate2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_cust, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_custs_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_cust, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_godowns` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_godowns2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_invs_discperc` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manfs_salesman_godowns_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_packing, d_arg_salesman, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_salesman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_class, d_arg_packing, d_arg_salesman, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfs_supps_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_class, d_arg_packing, d_arg_supp, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_manfwise_sdate_ldate_pricetype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manfwise_stockandsales` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_tradeactualprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_manfwise_stockandsales2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_postingstatus, d_manufacturers, ddd_tradeactualprice, ddd_tradeactualprice_avgprice |  |  |  |
| `w_arg_manufacturercategory` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manufacturercategory |  |  |  |
| `w_arg_manufacturercategory_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manufacturercategory |  |  |  |
| `w_arg_manufacturers` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_agp` | window | reports | Specify Retrieval Arguements | 2418 x 1908 | w_listarguments | d_customerdata_agp, d_manufacturers, d_productdata_agp, d_stockdata_agp, d_tran_agp |  |  |  |
| `w_arg_manufacturers_bosch_linz` | window | reports | Specify Retrieval Arguements | 2418 x 1908 | w_listarguments | d_manufacturers, d_purchasedata_bosch_linz, d_salesdata_bosch_linz, d_salesreturndata_bosch_linz, d_stockdata_bosch_linz |  |  |  |
| `w_arg_manufacturers_flax` | window | reports | Specify Retrieval Arguements | 2418 x 1908 | w_listarguments | d_customerdata_flax, d_manufacturers, d_productdata_flax, d_stock_flax, d_summ_flax, d_tran_flax |  |  |  |
| `w_arg_manufacturers_gsk` | window | reports | Specify Retrieval Arguements | 2455 x 1940 | w_listarguments | d_gsk_salesdata, d_manufacturers |  |  |  |
| `w_arg_manufacturers_gsk_cognos` | window | reports | Specify Retrieval Arguements | 2417 x 1907 | w_listarguments | d_gsk_cognos_customermaster_data, d_gsk_cognos_productmaster_data, d_gsk_cognos_sales_data, d_gsk_cognos_stock_data, d_manufacturers |  |  |  |
| `w_arg_manufacturers_ims` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_loosepack, d_customerdata_ims, d_manufacturers, d_productdata_ims, d_salesdistinctdates_ims, d_salestran_ims ... |  |  | w_select_general_crs |
| `w_arg_manufacturers_manfcatfilter` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_only` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_pharmalink` | window | reports | Specify Retrieval Arguements | 2455 x 1796 | w_listarguments | d_invdata_pharmalink, d_invdata_pharmalink_detail, d_manufacturers |  |  |  |
| `w_arg_manufacturers_returnoptions` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_manufacturers_v3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_typeofprice_v2 |  |  |  |
| `w_arg_manufacturers_v4` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_saleprice |  |  |  |
| `w_arg_manufacturers_v5` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_saleprice |  |  |  |
| `w_arg_manufacturers_vikor_gsk` | window | reports | Specify Retrieval Arguements | 2482 x 1760 | w_listarguments | d_manufacturers, d_vikor_gsk_areas_data, d_vikor_gsk_customers_data, d_vikor_gsk_items_data, d_vikor_gsk_medicalrep_data, d_vikor_gsk_principal_data ... |  |  |  |
| `w_arg_manufacturertype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manufacturertype2 |  |  |  |
| `w_arg_manufs_period_disc1range_disc2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_saleprice |  |  |  |
| `w_arg_masterpart` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_models` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_models |  |  |  |
| `w_arg_modelvisit` | window | reports | Specify Retrieval Arguements | 2377 x 963 | w_arguements | d_arg_modelvisits |  |  |  |
| `w_arg_monthly_netsales_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2217 x 963 | w_arguements | d_arg_reportcriteria |  |  |  |
| `w_arg_noofsiblings` | window | reports | No. of Siblings | 1211 x 496 | window |  |  |  |  |
| `w_arg_oneval_class_manf_pack_cat` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat, d_arg_class, d_arg_manf, d_arg_packing |  |  |  |
| `w_arg_oneval_class_manf_pack_cat_stax` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat, d_arg_class, d_arg_manf, d_arg_packing, d_arg_salestaxschedule |  |  |  |
| `w_arg_oneval_class_mnf_pack_cat_stax_etc` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cat, d_arg_class, d_arg_manf, d_arg_packing, d_arg_pctcode, d_arg_salestaxschedule |  |  |  |
| `w_arg_only_decimal_input` | window | reports |  | 1307 x 476 | window |  |  |  |  |
| `w_arg_packing` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arguements | d_arg_packing |  |  |  |
| `w_arg_packings` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_packing |  |  |  |
| `w_arg_patient` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_2, ddd_pagesize |  |  |  |
| `w_arg_patient_admission` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_patientadmissions, d_popup_patientselected, d_popup_patientselection |  |  |  |
| `w_arg_patient_saletype_sdate_ldate` | window | reports | Selection List | 2882 x 1267 | w_popup_forselection_walias | d_arg_saletype, d_popup_patientselected_1, d_popup_patientselection_3 |  |  |  |
| `w_arg_patient_saletype_sdate_ldate_disc` | window | reports | Selection List | 2882 x 1268 | w_popup_forselection_walias | d_arg_saletype, d_popup_patientselected_1, d_popup_patientselection_3 |  |  |  |
| `w_arg_patient_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sdate_ldate_cashcredit` | window | reports | Selection List | 2882 x 1588 | w_popup_forselection_walias | d_arg_cust, d_arg_header, d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sdate_ldate_disc` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sdate_ldate_inactive` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_2, ddd_pagesize |  |  |  |
| `w_arg_patient_sdate_ldate_old` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_patient |  |  |  |
| `w_arg_patient_sdate_ldate_otbill` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_otbill, d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sdate_ldate_v2` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sdate_ldate_v3` | window | reports | Selection List | 2898 x 1340 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_sinvcode_linvcode` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patient_v2` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_2, ddd_pagesize |  |  |  |
| `w_arg_patientadmission_sinv_linv` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_patientadmission, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_patientcategory` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientcategory |  |  |  |
| `w_arg_patientcategory_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientcategory |  |  |  |
| `w_arg_patientcategory_only` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientcategory |  |  |  |
| `w_arg_patientcategory_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientcategory |  |  |  |
| `w_arg_patientcategory_single` | window | reports | Specify Retrieval Arguements | 2487 x 963 | w_arguements | d_arg_patientcategory |  |  |  |
| `w_arg_patientlocation` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientlocation |  |  |  |
| `w_arg_patientonly` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_1 |  |  |  |
| `w_arg_patients` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_sdate_ldate2` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_sdate_ldate_disc` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_sdate_ldate_disc_v3` | window | reports | Selection List | 2882 x 1389 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection |  |  |  |
| `w_arg_patients_sdate_ldate_saletype` | window | reports | Selection List | 2958 x 1484 | w_popup_forselection_walias | d_arg_saletype, d_popup_patientselected_1, d_popup_patientselection, ddd_saletype |  |  |  |
| `w_arg_patientselection_smscenter` | window | reports | Populate Sale Invoice(s) | 2864 x 1789 | window | d_smscenter_patientselection_detail |  |  |  |
| `w_arg_pctcodes` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_pctcode |  |  |  |
| `w_arg_percentage_reduce_raise` | window | reports | Specify Retrieval Arguements | 1554 x 804 | w_arguements | d_arg_percentage_reduce_raise |  |  |  |
| `w_arg_phoneno` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_po_generate_from_quot` | window | reports | Specify Retrieval Arguements | 2089 x 920 | w_arguements | d_arg_purordercategory_filter, d_arg_supp, d_date_weekday |  |  |  |
| `w_arg_po_generate_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1649 x 864 | w_arguements | d_arg_cust, d_date_weekday |  |  |  |
| `w_arg_presaleinvcode` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_arg_presaleinvcode | presaleheader |  |  |
| `w_arg_pricetype_markup` | window | reports | Price Type Based Mar-Up Facility | 1897 x 963 | w_arguements | d_arg_pricetype_markupperc |  |  |  |
| `w_arg_printers` | window | reports | Specify Retrieval Arguements | 1897 x 960 | w_arg_manf | d_arg_printer |  |  |  |
| `w_arg_proforma_saleinvcode` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_arg_proforma_saleinvcode | saleledger |  |  |
| `w_arg_pur_return` | window | reports | Specify Retrieval Arguements | 2075 x 768 | w_arguements | d_arg_cust, d_arg_pur_return | prledger |  |  |
| `w_arg_purchase_item_populate` | window | reports | Specify Retrieval Arguements | 2811 x 1660 | w_arguements | d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_purchasetype_peiord` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | ddd_purchasetype |  |  |  |
| `w_arg_purinvcode` | window | reports | Specify Retrieval Arguements | 2075 x 768 | w_arguements | d_arg_cust, d_arg_purinvcode | purledger |  |  |
| `w_arg_purorder` | window | reports | Specify Retrieval Arguements | 2213 x 963 | w_arguements | d_arg_purorder |  |  |  |
| `w_arg_purorder_sdate_ldate_onesupp` | window | reports | Specify Retrieval Arguements | 2670 x 1944 | w_arg_sinvcode_linvcode | d_arg_supp, d_purorder_invwise_suppwise_lookup |  |  |  |
| `w_arg_quotation` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_quotation |  |  |  |
| `w_arg_quotation_customer_remarks` | window | reports | Select Quotation | 2432 x 1098 | window | d_arg_quotation_customer_remarks |  |  |  |
| `w_arg_receipt` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_receipt |  |  |  |
| `w_arg_recipe` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_recipeselected, d_popup_recipeselection |  |  |  |
| `w_arg_recipient` | window | reports | Select Recipient | 1271 x 560 | window | d_arg_recipient |  |  |  |
| `w_arg_ref` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_region` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_region |  |  |  |
| `w_arg_region_categories_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_categories, d_region |  |  |  |
| `w_arg_region_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_region |  |  |  |
| `w_arg_regions` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_region |  |  |  |
| `w_arg_regions_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_region |  |  |  |
| `w_arg_sale` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_sale |  |  |  |
| `w_arg_sale_allowedcat_date_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_allowed_cat |  |  |  |
| `w_arg_sale_outstanding_a_customer` | window | reports | Specify Retrieval Arguements | 1554 x 963 | w_arguements | d_arg_sale_outstanding_a_customer |  |  |  |
| `w_arg_sale_return_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sale_salesman_withlist_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_sale_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sale_sdate_ldate_avgprice_rpp` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust, ddd_avgpricerpp |  |  |  |
| `w_arg_sale_sdate_ldate_vochercategory` | window | reports | Specify Retrieval Arguements | 1947 x 963 | w_arguements | d_arg_vouchcategory |  |  |  |
| `w_arg_sale_users_withlist_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_saleinvcode` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_arg_saleinvcode | saleledger |  |  |
| `w_arg_saleinvcode_all` | window | reports | Specify Retrieval Arguements | 2222 x 768 | w_arguements | d_arg_cust, d_arg_saleinvcode_all | saleledger |  |  |
| `w_arg_saleinvcode_iteminquiry` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_arg_saleinvcode |  |  |  |
| `w_arg_saleinvcode_page` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_arg_saleinvcode, ddd_pagesize | saleledger |  |  |
| `w_arg_saleorder` | window | reports | Specify Retrieval Arguements | 2464 x 963 | w_arguements | d_arg_saleorder |  |  |  |
| `w_arg_salesman` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_salesman_active_inactive` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_salesman_grouping_sdate_ldate_rate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_salesman, d_categories, d_itemcategories, d_manufacturers ... |  |  |  |
| `w_arg_salesman_manf_active_inactive` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manf, d_arg_salesman |  |  |  |
| `w_arg_salesman_manf_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manf2, d_arg_salesman |  |  |  |
| `w_arg_salesman_month_year` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman, ddd_month, ddd_year |  |  |  |
| `w_arg_salesman_overdue` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_days, d_arg_salesman |  |  |  |
| `w_arg_salesman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman |  |  |  |
| `w_arg_salesman_sdate_ldate_incentive` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_salesman, ddd_typepofprice_incentiveprice |  |  |  |
| `w_arg_saletemplate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_saletemplate |  |  |  |
| `w_arg_saletemplate_single` | window | reports | Specify Retrieval Arguements | 2176 x 960 | w_arg_manf | d_saletemplates |  |  |  |
| `w_arg_saletype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_saletype |  |  |  |
| `w_arg_saletype_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_saletype |  |  |  |
| `w_arg_schollbranch` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_schoolbranch |  |  |  |
| `w_arg_schollbranch_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_schoolbranch |  |  |  |
| `w_arg_schollbranch_sdate_ldate_age_total` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_schoolbranch |  |  |  |
| `w_arg_school` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_school |  |  |  |
| `w_arg_school_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_school |  |  |  |
| `w_arg_scode_lcode` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_scode_lcode |  |  |  |
| `w_arg_scode_lcode2` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_scode_lcode |  |  |  |
| `w_arg_sdate` | window | reports | Specify Retrieval Arguements | 1650 x 744 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_cashflow_crosstab` | window | reports | Specify Retrieval Arguements | 1467 x 988 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1651 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_adj` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_admit_discharge` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust, d_arg_dischargestatus |  |  |  |
| `w_arg_sdate_ldate_agedays` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_agedays_printtotal` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_avg_rpp` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust, ddd_avgpricerpp |  |  |  |
| `w_arg_sdate_ldate_cashcreditboth` | window | reports | Specify Retrieval Arguements | 1649 x 963 | w_arguements | d_arg_cashcreditboth, d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_clinix` | window | reports | Specify Retrieval Arguements | 1898 x 1034 | w_arguements | d_arg_manf, d_clinix_dataexportutility |  |  |  |
| `w_arg_sdate_ldate_cust` | window | reports | Specify Retrieval Arguements | 2057 x 992 | w_arguements | d_cust_code, ddd_customer, ddd_pagesize |  |  |  |
| `w_arg_sdate_ldate_custcat` | window | reports | Specify Retrieval Arguements | 2144 x 1432 | w_arguements | d_custcat_code, ddd_customer, ddd_pagesize |  |  |  |
| `w_arg_sdate_ldate_dump_clearance` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust | grouprights | deleteinvoicesfrompurdump, deleteinvoicesfromsaledump | w_salesmanpassword |
| `w_arg_sdate_ldate_margin` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_margin_markup_range` | window | reports | Specify Retrieval Arguements | 1705 x 1056 | w_arguements | d_arg_margin_markup_range |  |  |  |
| `w_arg_sdate_ldate_onecust_netamt` | window | reports | Specify Retrieval Arguements | 2670 x 1944 | w_arg_sinvcode_linvcode | d_cust_code, d_saleinvlist_inv_custwise_lookup |  |  |  |
| `w_arg_sdate_ldate_outstanding_inv` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_patientlocation` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_patientlocation |  |  |  |
| `w_arg_sdate_ldate_perc` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_postunpost` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_postunpost_dateoption` | window | reports | Specify Retrieval Arguements | 1349 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_projdays` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_purtype` | window | reports | Specify Retrieval Arguements | 1550 x 1024 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_remarks_option` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_saleorderstatus` | window | reports | Specify Retrieval Arguements | 1650 x 963 | w_arguements | d_arg_cust, d_arg_saleorderstatus |  |  |  |
| `w_arg_sdate_ldate_saletype` | window | reports | Specify Retrieval Arguements | 1551 x 1024 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_stax_disc_reduceqty` | window | reports | Specify Retrieval Arguements | 1696 x 984 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_transaction` | window | reports | Specify Retrieval Arguements | 2066 x 1172 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_ldate_transactionwindow` | window | reports | Specify Retrieval Arguements | 2094 x 1064 | w_arguements | d_arg_transactioncode |  |  |  |
| `w_arg_sdate_ldate_transtype` | window | reports | Specify Retrieval Arguements | 1838 x 1300 | w_arguements | d_arg_vouchcategory |  |  |  |
| `w_arg_sdate_ldate_ward` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_ward |  |  |  |
| `w_arg_sdate_notime` | window | reports | Specify Retrieval Arguements | 1650 x 744 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_sdate_purinvcode` | window | reports | Specify Retrieval Arguements | 1678 x 768 | w_arguements | d_arg_cust, d_purchaseinvcode | purledger |  |  |
| `w_arg_search_item` | window | reports | Selection List | 2889 x 1876 | w_popup_forselection_walias | d_popup_itemselected, d_popup_itemselection |  |  |  |
| `w_arg_section_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | ddd_section |  |  |  |
| `w_arg_servicecat_salesman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2432 x 1820 | w_listarguments | d_arg_salesman, d_arg_servicecategory |  |  |  |
| `w_arg_servicecategory` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_servicecategory |  |  |  |
| `w_arg_servicecategory_only` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_servicecategory |  |  |  |
| `w_arg_serviceinvoice_services` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_servicerowid |  |  |  |
| `w_arg_serviceinvtype_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_serviceinvtype |  |  |  |
| `w_arg_serviceresult_deliverydate` | window | reports | Specify Retrieval Arguements | 1650 x 744 | w_arguements | d_arg_serviceresult_deliverydate |  |  |  |
| `w_arg_serviceresultstyle` | window | reports | Specify Retrieval Arguements | 2213 x 963 | w_arguements | d_arg_serviceresultstyle |  |  |  |
| `w_arg_services` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_service |  |  |  |
| `w_arg_services_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_service |  |  |  |
| `w_arg_servicestudenttemplate` | window | reports | Specify Retrieval Arguements | 2213 x 963 | w_arguements | d_arg_servicestudenttemplate |  |  |  |
| `w_arg_servicestudenttemplate_posted` | window | reports | Specify Retrieval Arguements | 2213 x 963 | w_arguements | d_arg_servicestudenttemplate_posted |  |  |  |
| `w_arg_single_servicetemplate` | window | reports | Specify Retrieval Arguements | 2213 x 963 | w_arguements | d_arg_servicetemplate |  |  |  |
| `w_arg_single_suppcategory_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2222 x 963 | w_arguements | d_arg_suppliercategory |  |  |  |
| `w_arg_singleregion` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_region |  |  |  |
| `w_arg_singlezone` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_zone |  |  |  |
| `w_arg_sinv_linv_header_srtype` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinv_linv_lc_header` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_header, d_arg_invcode_lc |  |  |  |
| `w_arg_sinv_linv_manf_cat_class_pack` | window | reports | Specify Retrieval Arguements | 1568 x 1152 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinv_linv_salesum_headerwise` | window | reports | Specify Retrieval Arguements | 2213 x 1424 | w_arguements | d_arg_header, d_arg_salesman, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinv_linv_saleswithsum_smanwise` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_salesman, d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_sinv_linv_saletype_header` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_header` | window | reports | Specify Retrieval Arguements | 1897 x 972 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_sinvcode_linvcode` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_adjtype` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_caption` | window | reports | Specify Retrieval Arguements | 1952 x 1404 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_cust` | window | reports | Specify Retrieval Arguements | 2057 x 992 | w_arguements | d_arg_sinvcode_linvcode_sales, d_cust_code, ddd_customer, ddd_pagesize |  |  |  |
| `w_arg_sinvcode_linvcode_cust_cust2` | window | reports | Selection List | 2882 x 1192 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_sinvcode_linvcode_cust_header` | window | reports | Specify Retrieval Arguements | 1897 x 972 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_sinvcode_linvcode_cust_v2` | window | reports | Specify Retrieval Arguements | 2057 x 1384 | w_arguements | d_arg_sinvcode_linvcode_salemodified, d_cust_code, ddd_customer, ddd_pagesize |  |  |  |
| `w_arg_sinvcode_linvcode_cust_v3` | window | reports | Specify Retrieval Arguements | 2075 x 1152 | w_arguements | d_arg_sinvcode_linvcode_sales, d_cust_code_required_yes, ddd_customer |  |  |  |
| `w_arg_sinvcode_linvcode_cust_v4` | window | reports | Specify Retrieval Arguements | 2075 x 1284 | w_arguements | d_arg_header, d_arg_pricetype, d_arg_sinvcode_linvcode_salemodified_all, d_cust_code, d_groupallowedmoduleheader, ddd_customer ... |  |  |  |
| `w_arg_sinvcode_linvcode_disc_salemod` | window | reports | Specify Retrieval Arguements | 2075 x 1152 | w_arguements | d_arg_sinvcode_linvcode_salemodified_all, d_cust_code_required_yes |  |  |  |
| `w_arg_sinvcode_linvcode_gstperc_date` | window | reports | Specify Retrieval Arguements | 2075 x 1152 | w_arguements | d_arg_sinvcode_linvcode_sales, d_cust_code_required_yes |  |  |  |
| `w_arg_sinvcode_linvcode_header` | window | reports | Specify Retrieval Arguements | 1897 x 972 | w_arguements | d_arg_header, d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_sinvcode_linvcode_invselection` | window | reports | Specify Retrieval Arguements | 2670 x 1944 | w_arg_sinvcode_linvcode | d_saleinvlist_unposted_invwise_lookup |  |  |  |
| `w_arg_sinvcode_linvcode_onecust` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode, d_cust_code, ddd_customer |  |  |  |
| `w_arg_sinvcode_linvcode_onecust_netamt` | window | reports | Specify Retrieval Arguements | 2670 x 1944 | w_arg_sinvcode_linvcode | d_cust_code, d_saleinvlist_invwise_custwise_lookup |  |  |  |
| `w_arg_sinvcode_linvcode_onedoctor` | window | reports | Specify Retrieval Arguements | 2007 x 1044 | w_arguements | d_arg_doctor_user, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_print_date` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_saleandreturn` | window | reports | Specify Retrieval Arguements | 1897 x 1128 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_saleandreturn2` | window | reports | Specify Retrieval Arguements | 1897 x 1128 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_sales` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_sinvcode_linvcode_sales |  |  |  |
| `w_arg_sinvcode_linvcode_saleswithsummary` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_sinvcode_linvcode_sales_asce |  |  |  |
| `w_arg_sinvcode_linvcode_saletype` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_saletype_spres_h` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_serviceandreturn` | window | reports | Specify Retrieval Arguements | 1897 x 1128 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sinvcode_linvcode_srtype` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_sman_item_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_item, d_arg_salesman |  |  |  |
| `w_arg_sman_ldate_weekday_overdue` | window | reports | Specify Retrieval Arguements | 1906 x 1044 | w_arguements | d_arg_days, d_arg_salesman |  |  |  |
| `w_arg_sman_month_year` | window | reports | Specify Retrieval Arguements | 1897 x 1012 | w_arguements | d_arg_salesman, ddd_month, ddd_year |  |  |  |
| `w_arg_sman_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_salesman |  |  |  |
| `w_arg_smans_areas_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_area, d_arg_salesman |  |  |  |
| `w_arg_smans_areas_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_area, d_arg_salesman |  |  |  |
| `w_arg_smans_areas_sdate_ldate2` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_area, d_arg_salesman |  |  |  |
| `w_arg_smans_subareas` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_salesman, d_arg_subarea |  |  |  |
| `w_arg_smscenter` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_ref |  |  |  |
| `w_arg_spocode_lpocode` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_sporder_lporder |  |  |  |
| `w_arg_spoteam` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_spoteam |  |  |  |
| `w_arg_spoteam_distcode` | window | reports | Specify Retrieval Arguements | 2432 x 1788 | w_listarguments | d_sposhare_merck, ddd_spoteam |  |  |  |
| `w_arg_spoteam_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | ddd_spoteam |  |  |  |
| `w_arg_spurinv_lpurinv` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_spurinv_lpurinv |  |  |  |
| `w_arg_squotcode_lquotcode` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_squotcode_lquotcode |  |  |  |
| `w_arg_stcode_ltcode_price` | window | reports | Specify Retrieval Arguements | 2213 x 1136 | w_arguements | d_arg_sinvcode_linvcode_transfer |  |  |  |
| `w_arg_stock_author` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_author |  |  |  |
| `w_arg_stock_classes` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class |  |  |  |
| `w_arg_stock_classes_cat_single_godown` | window | reports | Specify Retrieval Arguements | 2423 x 1864 | w_listarguments | d_arg_cat, d_arg_class, d_arg_godown3 |  |  |  |
| `w_arg_stock_classes_single_godown` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown3 |  |  |  |
| `w_arg_stock_genericitems` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_genericitem |  |  |  |
| `w_arg_stock_manufacturers` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_stock_manufacturers_new` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers, ddd_typepofprice_new |  |  |  |
| `w_arg_stock_manufacturers_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_manufacturers |  |  |  |
| `w_arg_stockinbackdate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_godown, d_arg_stockdate, d_itemcategories, d_manufacturers |  |  |  |
| `w_arg_storekeepersummary` | window | reports | Specify Retrieval Arguements | 2423 x 1708 | w_listarguments | d_arg_sinvcode_linvcode_sales, d_arg_users, ddd_grouping |  |  |  |
| `w_arg_storekeepersummary_v2` | window | reports | Specify Retrieval Arguements | 2423 x 1708 | w_listarguments | d_arg_salesman, d_arg_sinvcode_linvcode_sales, ddd_grouping |  |  |  |
| `w_arg_student_grade_branch` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_student_grade_branch |  |  |  |
| `w_arg_students` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_studentselected, d_popup_studentselection |  |  |  |
| `w_arg_students_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_studentselected, d_popup_studentselection |  |  |  |
| `w_arg_students_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_studentselected, d_popup_studentselection |  |  |  |
| `w_arg_subacc_period` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_functionalarea, d_arg_subaccounts |  |  |  |
| `w_arg_subacc_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_subacc |  |  |  |
| `w_arg_subarea_overdue` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_days, d_arg_subarea |  |  |  |
| `w_arg_subsidiaryaccounts_all` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subaccounts |  |  |  |
| `w_arg_summacc_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_summaccselected_arglist, d_popup_summaccselection |  |  |  |
| `w_arg_supp_cust` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_cust, d_arg_supp |  |  |  |
| `w_arg_supp_cust_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust, d_arg_supp |  |  |  |
| `w_arg_supp_label` | window | reports | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_supp |  |  |  |
| `w_arg_supp_period_outstanding_inv` | window | reports | Selection List | 2889 x 2020 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection, d_supp_outstanding_purchases |  |  |  |
| `w_arg_supp_period_outstanding_serviceinv` | window | reports | Selection List | 2889 x 2020 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection, d_supp_outstanding_services |  |  |  |
| `w_arg_supp_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection |  |  |  |
| `w_arg_supp_sdate_ldate_old` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_supp |  |  |  |
| `w_arg_supp_sdate_ldate_pricetype` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection, ddd_typepofprice |  |  |  |
| `w_arg_supp_sinv_linv` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_sinvcode_linvcode, d_arg_supp |  |  |  |
| `w_arg_supp_stock` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection, ddd_typepofprice |  |  |  |
| `w_arg_suppcategory` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | d_arg_suppcategory |  |  |  |
| `w_arg_suppcategory_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | d_arg_suppcategory |  |  |  |
| `w_arg_suppcategory_peiord` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | d_arg_suppcategory |  |  |  |
| `w_arg_suppcategory_period` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | d_arg_suppcategory |  |  |  |
| `w_arg_suppcategory_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1800 | w_listarguments | d_arg_suppcategory |  |  |  |
| `w_arg_supplier` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_supp |  |  |  |
| `w_arg_supplier_all` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_supp |  |  |  |
| `w_arg_suppliers` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_supp |  |  |  |
| `w_arg_suppliers_catfilter_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many |  |  |  |
| `w_arg_suppliers_catfilter_sdate_ldate2` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many |  |  |  |
| `w_arg_suppliers_label` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many |  |  |  |
| `w_arg_suppliers_period_loose_open_pur` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many |  |  |  |
| `w_arg_suppliers_sdate_ldate` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many |  |  |  |
| `w_arg_suppliers_stock` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_supp |  |  |  |
| `w_arg_supps_sdate_ldate_pricetype` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected_many, d_popup_supplierselection_many, ddd_typepofprice |  |  |  |
| `w_arg_supps_stock` | window | reports | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_supplierselected, d_popup_supplierselection, ddd_typepofprice |  |  |  |
| `w_arg_taxcategory` | window | reports | Specify Retrieval Arguements | 2423 x 1802 | w_listarguments | d_arg_taxcategory |  |  |  |
| `w_arg_transactionwindow` | window | reports | Specify Retrieval Arguements | 2094 x 1064 | w_arguements | d_arg_transactioncode |  |  |  |
| `w_arg_transactionwindow_post` | window | reports | Specify Retrieval Arguements | 2094 x 1064 | w_arguements | d_arg_transactioncode_post |  |  |  |
| `w_arg_transfer` | window | reports | Specify Retrieval Arguements | 1943 x 768 | w_arguements | d_arg_cust, d_arg_transferinvcode | theader |  |  |
| `w_arg_transfer_1tomany` | window | reports | Specify Retrieval Arguements | 2423 x 1792 | w_listarguments | d_arg_transfergodown |  |  |  |
| `w_arg_transfer_manyto1` | window | reports | Specify Retrieval Arguements | 2423 x 1812 | w_listarguments | d_arg_transfergodown |  |  |  |
| `w_arg_trialbalance` | window | reports | Trial Balance | 2030 x 1658 | w_arguements |  |  |  |  |
| `w_arg_user_manf_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manf2, d_arg_users |  |  |  |
| `w_arg_user_manf_sdate_ldate_incentive` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_manf2, d_arg_users |  |  |  |
| `w_arg_user_sdate_ldate` | window | reports | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_user |  |  |  |
| `w_arg_users` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_users_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_users_sdate_ldate_2` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_users_sdate_ldate_3` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_users_vouchcat_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1808 | w_listarguments | d_arg_users, d_arg_vouchcategory |  |  |  |
| `w_arg_users_withlist_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_users_withlist_sdate_ldate_purcat` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_vehicle` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_vehicle |  |  |  |
| `w_arg_vehicle_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_vehicle |  |  |  |
| `w_arg_vehicletype` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_vehicletype |  |  |  |
| `w_arg_vehicletype_sdate_ldate` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_vehicletype |  |  |  |
| `w_arg_vochcat_sdate_ldate_scode_lcode` | window | reports | Specify Retrieval Arguements | 2368 x 1880 | w_listarguments | d_arg_scode_lcode, d_arg_vouchcategory |  |  |  |
| `w_arg_voucherdetails` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_users |  |  |  |
| `w_arg_ward` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_ward |  |  |  |
| `w_arg_yesno` | window | reports |  | 1211 x 432 | window | d_arg_yesno |  |  |  |
| `w_arguements` | window | reports | Specify Retrieval Arguements | 1554 x 963 | window | ddd_typepofprice |  |  | w_calendar |
| `w_cashierdeclaration` | window | reports | Cashier Declaration Report | 1970 x 1392 | window | d_cashierdecalration |  |  |  |
| `w_choose_customercategory` | window | reports | Item Category | 2432 x 1768 | window | d_choose_customercategory |  |  |  |
| `w_choose_itemcategory` | window | reports | Item Category | 2432 x 1768 | window | d_choose_itemcategory_for_itemlist |  |  |  |
| `w_choose_servicecategory` | window | reports | Item Category | 2432 x 1768 | window | d_choose_servicecategory_for_itemlist |  |  |  |
| `w_choose_suppliercategory` | window | reports | Item Category | 2432 x 1768 | window | d_choose_suppliercategory |  |  |  |
| `w_expintimation_range_selection` | window | reports | Populate Expiry Intimation(s) | 2864 x 1789 | window | d_expintimation_range_selection, d_expiryintimation_range_list |  |  |  |
| `w_generate_services_academicclass` | window | reports | Generate Class Wise Fee For Students | 2864 x 1754 | window | d_generate_services_class_reamrks, d_generate_studentlist_class_service |  | generate_svc_for_studentfee |  |
| `w_generate_services_academicclass2` | window | reports | Generate Class Wise Fee For Students | 2864 x 1754 | window | d_generate_services_class_reamrks2, d_generate_studentlist_class_svc |  | generate_svc_for_studentfee_template |  |
| `w_generate_services_academicclass3` | window | reports | Generate Class Wise Fee For Students | 2864 x 1754 | window | d_generate_services_class_reamrks, d_generate_studentlist_class_service3 |  | generate_svc_for_studentfee |  |
| `w_generate_visitpresctiption_labels` | window | reports | Generate Visit Prescription Labels | 2871 x 1812 | window | d_arg_visitcode_prescription_labels, d_visit_prescription_labelprinting, d_visitprescription_label_rashidnursing |  |  | w_preview_invoices |
| `w_items_select_documentfiltered` | window | reports | Select Item(s) | 2864 x 1789 | window | d_arg_item_select_documentfiltered |  |  |  |
| `w_listarguments` | window | reports | Specify Retrieval Arguements | 2423 x 1748 | window | d_arg_sinvcode_linvcode, ddd_typepofprice |  |  | w_calendar |
| `w_po_supp_sdate_ldate` | window | reports | Populate Purchase Invoice(s) | 2862 x 1788 | window | d_po_supp_sdate_ldate, d_purorders_supplier_sdate_ldate |  |  |  |
| `w_populateinvoices_cust_sdate_ldate` | window | reports | Populate Sale Invoice(s) | 2862 x 1788 | window | d_customer_sdate_ldate, d_salesinvoices_cust_sdate_ldate |  |  |  |
| `w_purinvoices_posted_supp_sdate_ldate` | window | reports | Populate Purchase Invoice(s) | 2862 x 1788 | window | d_purinvoices_posted_supp_sdate_ldate, d_purorders_supplier_sdate_ldate |  |  |  |
| `w_purinvoices_supp_sdate_ldate` | window | reports | Populate Purchase Invoice(s) | 2862 x 1788 | window | d_purinvoices_supp_sdate_ldate, d_purorders_supplier_sdate_ldate |  |  |  |
| `w_purorder_supp_sdate_ldate` | window | reports | Populate Purchase Order(s) | 2862 x 1788 | window | d_purorders_supp_sdate_ldate, d_purorders_supplier_sdate_ldate |  |  |  |
| `w_quotation_cust_sdate_ldate` | window | reports | Populate Quotation(s) | 2864 x 1789 | window | d_quotation_cust_sdate_ldate, d_quotation_customer_sdate_ldate |  |  |  |
| `w_quotation_range_selection` | window | reports | Populate Quotation(s) | 2864 x 1789 | window | d_quotation_cust_startingno_endingno, d_quotation_customer_startno_endno |  |  |  |
| `w_arg_allowedcustomers` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_allowedcustomerselection, d_popup_customerselected_arglist |  |  |  |
| `w_arg_area_custcategory` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_customercat |  |  |  |
| `w_arg_area_custcategory_date` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_customercat |  |  |  |
| `w_arg_area_custcategory_date_limits` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_customercat |  |  |  |
| `w_arg_area_custcategory_labels` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_customercat |  |  |  |
| `w_arg_area_customers_labels` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_area_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_area |  |  |  |
| `w_arg_area_sdate_ldate_posted_unposted` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_area |  |  |  |
| `w_arg_area_singleselection` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_area |  |  |  |
| `w_arg_area_singleselection_posting` | window | reports_cust | Specify Retrieval Arguements | 1897 x 1040 | w_arguements | d_arg_area, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_area_subarea_customers` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_cust, d_arg_subarea, d_manufacturers |  |  |  |
| `w_arg_area_subarea_customers_period` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_cust, d_arg_subarea, d_manufacturers |  |  |  |
| `w_arg_areas` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_areas_cat_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_cat |  |  |  |
| `w_arg_areas_cat_sdate_ldate_pricetype` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_cat, ddd_tradeactualprice |  |  |  |
| `w_arg_areas_for_a_zone_region` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_areas_for_a_region_zone |  |  |  |
| `w_arg_areas_manf_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_manf |  |  |  |
| `w_arg_areas_manf_sdate_ldate_bonus` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_manf |  |  |  |
| `w_arg_areas_sale_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_areas_saletype_range_post_grouping` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1708 | w_listarguments | d_area, d_arg_saletype, d_arg_sinvcode_linvcode_sales, ddd_grouping |  |  |  |
| `w_arg_areas_sdate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_areas_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_areas_sdate_ldate_salecriteria` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area, d_arg_salecriteria |  |  |  |
| `w_arg_areas_sinv_linv_salecriteria` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area, d_arg_salecriteria |  |  |  |
| `w_arg_areas_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_areas_sman_period_invstatus` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_postingstatus, d_arg_salesman |  |  |  |
| `w_arg_areas_sman_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_area, d_arg_salesman |  |  |  |
| `w_arg_areas_zerobalance` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_area |  |  |  |
| `w_arg_citycounty` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_county |  |  |  |
| `w_arg_cust` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_dates_caption_disc_terms` | window | reports_cust | Selection List | 2898 x 1852 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_discperc_cust_discperc_dates` | window | reports_cust | Specify Retrieval Arguements | 1897 x 1244 | w_arguements | d_arg_cust_discperc_cust_discperc_tax | customer |  |  |
| `w_arg_cust_item_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_item, d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_cust_item_sdate_ldate_old` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1772 | w_listarguments | d_arg_cust, d_arg_item |  |  |  |
| `w_arg_cust_label` | window | reports_cust | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_cust_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_ldate_withalloption` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_manf_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust_manf |  |  |  |
| `w_arg_cust_manfs_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1964 | w_listarguments | d_arg_cust, d_arg_godown, d_manufacturers |  |  |  |
| `w_arg_cust_or_allcust` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_patient_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1644 | w_popup_forselection_walias | d_arg_patient2, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_period_outstanding_inv` | window | reports_cust | Selection List | 2882 x 1948 | w_popup_forselection_walias | d_cust_outstanding_sales, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_period_outstanding_serviceinv` | window | reports_cust | Selection List | 2882 x 1948 | w_popup_forselection_walias | d_cust_outstanding_services, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_pur_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_cust, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_cust_ref_caption_disc_terms` | window | reports_cust | Selection List | 2882 x 1528 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection | customer |  |  |
| `w_arg_cust_sdate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_balancereminder` | window | reports_cust | Selection List | 2882 x 1532 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_balancereminder2` | window | reports_cust | Selection List | 2882 x 1532 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_cash_credit` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_dateoption` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_discperc` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_discperc_line_1_2` | window | reports_cust | Selection List | 2882 x 1288 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_discperc_v2` | window | reports_cust | Selection List | 2882 x 1290 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_old` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_cust_sdate_ldate_saletype` | window | reports_cust | Selection List | 2889 x 1508 | w_popup_forselection_walias | d_arg_saletype, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_saletype2` | window | reports_cust | Selection List | 2882 x 1556 | w_popup_forselection_walias | d_arg_saletype, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_tax` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust |  |  |  |
| `w_arg_cust_sdate_ldate_v10` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v11` | window | reports_cust | Selection List | 2882 x 1328 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v12` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v13` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v15` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias |  |  |  |  |
| `w_arg_cust_sdate_ldate_v16` | window | reports_cust | Selection List | 2882 x 1480 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v17` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v18` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v19` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v2` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v20` | window | reports_cust | Selection List | 2882 x 1328 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v3` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v3_header` | window | reports_cust | Selection List | 2882 x 1288 | w_popup_forselection_walias | d_arg_header, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v4` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v5` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v6` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v7` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v8` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_v9` | window | reports_cust | Selection List | 2882 x 1720 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_withalloption` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sdate_ldate_withalloption2` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinv_linv` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_cust_sinv_linv_itemcat_terms` | window | reports_cust | Selection List | 2882 x 1880 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_itemcategory_discperc, d_popup_customerselected, d_popup_customerselection |  | itemcategorydiscperclist |  |
| `w_arg_cust_sinv_linv_term_batch_exp_disc` | window | reports_cust | Selection List | 2882 x 1436 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinv_linv_terms` | window | reports_cust | Selection List | 2882 x 1308 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinv_linv_terms2` | window | reports_cust | Selection List | 2882 x 1616 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinv_linv_terms_formatwise` | window | reports_cust | Selection List | 2882 x 1428 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinv_linv_type` | window | reports_cust | Selection List | 2889 x 1380 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_cust_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_cust_sinvcode_linvcode2` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_cust, d_arg_sinvcode_linvcode |  |  |  |
| `w_arg_cust_student_servicetemplate` | window | reports_cust | Specify Retrieval Arguements | 2203 x 980 | w_arguements | d_arg_custo_student_servicetemp |  |  |  |
| `w_arg_cust_student_servicetemplate_post` | window | reports_cust | Specify Retrieval Arguements | 2203 x 980 | w_arguements | d_arg_custo_student_servicetemp_posted |  |  |  |
| `w_arg_cust_v14` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_custcat_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_customercat |  |  |  |
| `w_arg_custcat_sdate_ldate_comment` | window | reports_cust | Specify Retrieval Arguements | 2592 x 1284 | w_arguements | d_arg_customercat |  |  |  |
| `w_arg_custcat_sdate_ldate_discperc` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_customercat |  |  |  |
| `w_arg_custcategories` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_customercat |  |  |  |
| `w_arg_custcategories_aginginterval` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_aginginterval, d_arg_customercat |  |  |  |
| `w_arg_custcategories_aginginterval_limit` | window | reports_cust | Specify Retrieval Arguements | 2441 x 1760 | w_listarguments | d_arg_aginginterval, d_arg_customercat, d_arg_sinvcode_linvcode_singlerow |  |  |  |
| `w_arg_custcategories_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_customercat |  |  |  |
| `w_arg_custcategories_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_customercat |  |  |  |
| `w_arg_custcategories_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_customercat |  |  |  |
| `w_arg_customer_godown` | window | reports_cust | Specify Retrieval Arguements | 2226 x 960 | w_arg_manf | d_arg_customergodown | accountgodown |  |  |
| `w_arg_customer_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust |  |  |  |
| `w_arg_customers` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_labels` | window | reports_cust | Selection List | 2889 x 1376 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_oneorall_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_reminderletter` | window | reports_cust | Selection List | 2882 x 1400 | w_popup_forselection_walias | d_areawise_customers_selection, d_arg_salesman, d_popup_customerselected_arglist, d_popup_customerselection |  |  | w_arg_areas |
| `w_arg_customers_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_comments` | window | reports_cust | Selection List | 2882 x 1443 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_comments2` | window | reports_cust | Selection List | 2882 x 1672 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_outstandinginv` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_salecriteria` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_salecriteria, d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_unposted` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v2` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v3` | window | reports_cust | Selection List | 2882 x 1444 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v4` | window | reports_cust | Selection List | 2882 x 1564 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v5` | window | reports_cust | Selection List | 2882 x 1444 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v6` | window | reports_cust | Selection List | 2882 x 1443 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sdate_ldate_v7` | window | reports_cust | Selection List | 2882 x 1443 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sinv_linv_salecriteria` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust, d_arg_salecriteria, d_arg_sinvcode_linvcode_sales |  |  |  |
| `w_arg_customers_sinvcode_linvcode` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_cust, d_arg_sinvcode_linvcode_sales |  |  |  |
| `w_arg_customers_sinvcode_linvcode_v2` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_sinvcode_linvcode, d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_customers_sman_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_salesman, d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_customers_sman_sdate_ldate2` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_arg_salesman, d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_custs_sdate_ldate` | window | reports_cust | Selection List | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected_arglist, d_popup_customerselection |  |  |  |
| `w_arg_purchasefromcustomer` | window | reports_cust | Purchase From Customer | 2882 x 1197 | w_popup_forselection_walias | d_popup_customerselected, d_popup_customerselection |  |  |  |
| `w_arg_sdate_ldate_v1` | window | reports_cust | Selection List | 2882 x 1392 | w_popup_forselection_walias | d_popup_customerselected2, d_popup_customerselection |  |  |  |
| `w_arg_subareas` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subarea |  |  |  |
| `w_arg_subareas_areabased` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subarea_areabased |  |  |  |
| `w_arg_subareas_areabased_sdate_edate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_item, d_arg_subarea_areabased |  |  |  |
| `w_arg_subareas_range_areabased` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1592 | w_listarguments | d_arg_subarea_areabased, ddd_grouping |  |  |  |
| `w_arg_subareas_saletype_areabased` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1708 | w_listarguments | d_arg_saletype, d_arg_sinvcode_linvcode_sales, d_arg_subarea_areabased, ddd_grouping |  |  |  |
| `w_arg_subareas_saletype_range_areabased` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1708 | w_listarguments | d_arg_saletype, d_arg_sinvcode_linvcode_sales, d_arg_subarea_areabased, ddd_grouping |  |  |  |
| `w_arg_subareas_sdate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subarea |  |  |  |
| `w_arg_subareas_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_subarea |  |  |  |
| `w_arg_zone` | window | reports_cust | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_zone |  |  |  |
| `w_arg_zone_cat_arealist_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_zone, d_categories |  |  |  |
| `w_arg_zone_categories_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_zone, d_categories |  |  |  |
| `w_arg_zone_categories_sdate_ldate_rate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_zone, d_categories, ddd_tradeactualprice |  |  |  |
| `w_arg_zone_grouping_sdate_ldate_rate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_zone, d_categories, d_itemcategories, d_manufacturers ... |  |  |  |
| `w_arg_zone_grouping_sdate_ldate_rate_v2` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_class, d_arg_packing, d_arg_zone, d_categories, d_itemcategories, d_manufacturers ... |  |  |  |
| `w_arg_zone_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_zone |  |  |  |
| `w_arg_zone_sdate_ldate_top_n_customer` | window | reports_cust | Specify Retrieval Arguements | 1898 x 963 | w_arguements | d_arg_top_n_customers, d_arg_zone |  |  |  |
| `w_arg_zones_sdate_ldate` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_zone2 |  |  |  |
| `w_arg_zones_sdate_ldate_zonalsale` | window | reports_cust | Specify Retrieval Arguements | 2423 x 1748 | w_listarguments | d_arg_zonaldailsale, d_arg_zone2 |  |  |  |
| `w_userattendance_form` | window | useratten | Time-In | 1125 x 820 | window | d_usertime | userattendance, users | check_userattendance, mark_userattendance | w_userauthentication_form |
| `w_userauthentication_form` | window | useratten | User Authentication Window | 1253 x 604 | window | d_authenticationkey | grouprights, users |  | w_salesmanpassword |
