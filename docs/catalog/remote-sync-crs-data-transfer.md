# Remote sync (CRS / data transfer)

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `w_crs_client_controlpanel` | window | crscomponents | CRS Client Control Panel | 2437 x 1752 | window | d_backupschedule, d_crs_client_controlpanel, d_sequence | sysjobs | activatejob, adjustjobschedule, crs_clientdatatransfer, crs_getlastcrsdatasendinfo | w_salesmanpassword |
| `w_crs_client_datatransfer_config` | window | crscomponents | CRS Client Form | 2977 x 1920 | w_single_entry |  | crs_clientlist |  |  |
| `w_crs_clientinstance` | window | crscomponents | CRS Client Instance Form | 2977 x 1920 | w_single_entry |  | crs_clientinstance |  |  |
| `w_crs_clientlist` | window | crscomponents | CRS Client Form | 2977 x 1920 | w_single_entry |  | crs_clientlist |  |  |
| `w_crs_clientwise_searchinvoice` | window | crscomponents | Search CRS Invoice(s) | 2871 x 1795 | window | d_crs_clientwise_search_criteria, d_crs_clientwise_searchinvoice |  |  | w_crs_invoicedetail |
| `w_crs_invoicedetail` | window | crscomponents | Purchase Invoice Detail | 2864 x 1789 | window |  |  |  |  |
| `w_crs_searchinvoice` | window | crscomponents | Search CRS Sale/Return Invoice(s) | 2871 x 1796 | window | d_crs_searchinvoice, d_crs_searchtext | into, reportdata |  | w_crs_invoicedetail |
| `m_transferablemarking` | menu | datatransferapp |  |  | m_multi_entry |  |  |  |  |
| `w_datatransfer` | window | datatransferapp | Data Transfer Window | 2363 x 1836 | window | d_sequence |  | droptemporarytables, transferaccountingvoucher, transferbasicdata, transferintergodowntransfers, transferpurchaseinvoices2 | w_logdetail |
| `w_invoicedetail` | window | datatransferapp | Purchase Invoice Detail | 2864 x 1789 | window |  |  |  |  |
| `w_logdetail` | window | datatransferapp | Data Transfer Report | 2862 x 1788 | window | d_transferlogdetail, d_transferlogheader |  |  |  |
| `w_transferablemarking` | window | datatransferapp | Invoice Marking | 2958 x 1960 | w_multi_entry | d_glvoch_fortransferable, d_purinvoices_fortransferable1, d_purinvoices_fortransferable1_purtype, d_purinvoices_fortransferable1_suppcat, d_purtransferablemarking_hidden, d_saleinvoices_fortransferable ... | glheader, godown, prledger, purledger, saleledger, srledger, theader | lockprinvoice, lockpurinvoice, locksaleinvoice, locksrinvoice | w_arg_cust_sinv_linv, w_arg_godown_sinv_linv, w_arg_headerno_sdate_ldate, w_arg_purchasetype_peiord, w_arg_sinvcode_linvcode |
| `w_advsales_transmit_cust_sdate_ldate` | window | datatransfercomponents | Child/Stand By Server Sales Selection | 2862 x 1788 | window | d_advsale_transmit_cust_sdate_ldate, d_advsales_transmit_customer_sdate_ldate |  |  |  |
| `w_childerserver_controlpanel` | window | datatransfercomponents | Child/Stand By Server Control Panel | 2922 x 1667 | window | d_backupschedule, d_backupschedule_2012, d_childserver_controlpanel, d_sequence | sysjobs | activatejob, adjustjobschedule, dbms_version, dropimporttables, importdata | w_advsales_transmit_cust_sdate_ldate, w_sales_transmit_cust_sdate_ldate, w_select_sales_advsales, w_select_sales_salereturn, w_sreturn_transmit_cust_sdate_ldate |
| `w_dataaquisition` | window | datatransfercomponents | Data Aquisition Wizard | 3200 x 1444 | window | d_sequence | grouprights | aquirepostedtransactions, checkpacketcounters, getversioninfo, readdatamigrationpacket, transferbasicdata | w_dataaquisition_alert, w_salesmanpassword |
| `w_dataaquisition_alert` | window | datatransfercomponents | Dislaimer | 2176 x 1248 | window |  |  |  |  |
| `w_datamigration` | window | datatransfercomponents | Data Migration Wizard | 3195 x 1564 | window |  | _tabmaxkey, grouprights | checkunpostedtransactions, copyinvoicestopurledgermod, copyinvoicestosaledump, copysbuffertosales, deletepostedtransactions | w_datamigration_alert, w_salesmanpassword |
| `w_datamigration_alert` | window | datatransfercomponents | Dislaimer | 2176 x 1248 | window |  |  |  |  |
| `w_datasync` | window | datatransfercomponents | Data Synchronization Wizard | 2725 x 1325 | window | d_sequence |  | deletesyncedtransactions, getversioninfo, syncbasicdata_on_remote, synctransactiondata_onremote | w_salesmanpassword |
| `w_export_datacarrysetting` | window | datatransfercomponents | Export Data To DataCarryDB | 2414 x 2248 | window | d_export_datacarrysetting | issueheader, saleledger |  | w_arg_issue, w_arg_pur_return, w_arg_purorder, w_arg_saleinvcode_all, w_arg_saleorder |
| `w_fetch_linkservers` | window | datatransfercomponents | Specify Retrieval Arguements | 1935 x 1091 | w_arguements | d_arg_linkedserver, d_linkedservers |  |  |  |
| `w_import_datacarrysetting` | window | datatransfercomponents | Import Data From DataCarryDB | 1586 x 1128 | window | d_import_datacarrysetting |  |  |  |
| `w_import_parentserver_transaction` | window | datatransfercomponents | Parent Server Transaction(s) | 2322 x 972 | window | d_import_parentserver_transation |  | import_quot_so_po_fromparentserver |  |
| `w_import_previoussalehistory` | window | datatransfercomponents | Specify Retrieval Arguements | 1934 x 1092 | w_arguements | d_arg_database |  | get_previoussalehistory |  |
| `w_incorporate_childserver_sales` | window | datatransfercomponents | Child Server Sales Selection | 2862 x 1788 | window | d_incorporate_childserver_sales_detail, d_incorporate_childserver_sales_header |  |  |  |
| `w_incorporate_childserver_salesinv` | window | datatransfercomponents | Child Server Sales Selection | 2862 x 1788 | window | d_incorporate_childserver_sales_header, d_incorporate_childserver_salesin_detail |  |  |  |
| `w_incorporate_childserver_sr` | window | datatransfercomponents | Child Server Sales Selection | 2862 x 1788 | window | d_incorporate_childserver_sales_header, d_incorporate_childserver_salesin_detail |  |  |  |
| `w_otp_verfication` | window | datatransfercomponents | OTP Verification | 2732 x 986 | window | d_otp |  |  |  |
| `w_parentserver_controlpanel` | window | datatransfercomponents | Parent Server Control Panel | 2736 x 1430 | window | d_backupschedule, d_backupschedule_2012, d_parentserver_controlpanel | sysjobs | activatejob, adjustjobschedule, childserver_sale_translation, dbms_version, fetch_childserversales | w_fetch_linkservers, w_incorporate_childserver_sales, w_incorporate_childserver_salesinv, w_incorporate_childserver_sr, w_select_sales_advsales |
| `w_populate_expintimation_from_datacarry` | window | datatransfercomponents | Import Purchase Invoices From Data Carry DB | 1979 x 899 | window | d_import_expintimation_from_datacarry |  |  |  |
| `w_populate_po_from_datacarrydb` | window | datatransfercomponents |  | 1559 x 660 | window | d_accesspurorderheader |  |  |  |
| `w_populate_purchase_from_datacarrydb` | window | datatransfercomponents | Import Purchase Invoices From Data Carry DB | 1979 x 899 | window | d_import_purinvoices_from_datacarry |  |  |  |
| `w_populate_purreturn_from_datacarrydb` | window | datatransfercomponents |  | 1559 x 544 | window | d_accessprledger |  |  |  |
| `w_populate_quotation_from_datacarrydb` | window | datatransfercomponents | Import Quotation From Data Carry DB | 1979 x 899 | window | d_import_quotation_from_datacarry |  |  |  |
| `w_populate_sale_from_datacarrydb` | window | datatransfercomponents | Sales Invoices From Data Carry DB | 1979 x 691 | window | d_accesssaleledger |  |  |  |
| `w_populate_services_from_datacarrydb` | window | datatransfercomponents | Service Sales Invoices From Data Carry DB | 1979 x 900 | window | d_access_serviceheader |  |  |  |
| `w_populate_so_from_datacarrydb` | window | datatransfercomponents |  | 1559 x 544 | window | d_accesssaleorderheader |  |  |  |
| `w_populate_stockaudit_from_datacarrydb` | window | datatransfercomponents |  | 1989 x 764 | window | d_access_stockauditjob |  |  |  |
| `w_pull_expintimation_from_dropbox` | window | datatransfercomponents | Pull Expiry Intimation From Drop Box | 1979 x 899 | window | d_drobox_expintimation |  |  |  |
| `w_pull_issue_from_dropbox` | window | datatransfercomponents | Pull Issue Documents From Drop Box | 1979 x 691 | window | d_dropbox_issueheader |  |  |  |
| `w_pull_po_from_dropbox` | window | datatransfercomponents | Pull P/O From Drop Box | 1558 x 659 | window | d_dropbox_purorderheader |  |  |  |
| `w_pull_purreturn_from_dropbox` | window | datatransfercomponents | Pull P/R From Drop Box | 1558 x 544 | window | d_dropbox_prledger |  |  |  |
| `w_pull_sale_from_dropbox` | window | datatransfercomponents | Pull Sales Invoices From Drop Box | 1979 x 691 | window | d_dropbox_saleledger |  |  |  |
| `w_pump_purorder_purreturn_datacarrydb` | window | datatransfercomponents | Select Purchase Orders For Pumping To DataCarryDB | 1989 x 1548 | window | d_datacarry_arg_sporder_lporder, d_datacarry_arg_sprcode_lprcode, d_datacarry_arg_ssorder_lsorder |  |  |  |
| `w_pump_sale_datacarrydb` | window | datatransfercomponents | Select Invoices For Pumping To DataCarryDB | 1979 x 692 | window | d_datacarry_arg_sinvcode_linvcode |  |  |  |
| `w_sales_transmit_cust_sdate_ldate` | window | datatransfercomponents | Child/Stand By Server Sales Selection | 2862 x 1788 | window | d_advsales_transmit_customer_sdate_ldate, d_sale_transmit_cust_sdate_ldate |  |  |  |
| `w_site_update` | window | datatransfercomponents | Site/Branch Update | 3467 x 2086 | window | d_site_update |  |  |  |
| `w_sreturn_transmit_cust_sdate_ldate` | window | datatransfercomponents | Child/Stand By Server Sales Selection | 2862 x 1788 | window | d_advsales_transmit_customer_sdate_ldate, d_sreturn_transmit_cust_sdate_ldate |  |  |  |
| `w_transferabledata` | window | datatransfercomponents | Transferable Data Settings | 3467 x 2086 | window | d_transferabledata |  |  |  |
| `w_transferabledata_export_restrictedcol` | window | datatransfercomponents | Restricted Columns List for Data Export | 3076 x 1965 | w_multi_entry |  |  |  |  |
| `w_transferabledata_restrictedcolumn` | window | datatransfercomponents | Zone Form | 3077 x 1964 | w_multi_entry |  |  |  |  |
| `w_update_saleandreturncost` | window | datatransfercomponents | Historical Cost Updation | 1943 x 856 | w_arguements | d_arg_database |  | update_itemhistoricalcost_in_sale_and_return |  |
