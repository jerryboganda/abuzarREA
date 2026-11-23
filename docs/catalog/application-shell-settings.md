# Application shell & settings

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `m_main` | menu | abuzarapp |  |  | menu |  |  | create, destroy | w_purchase, w_sale |
| `traderappv1` | application | abuzarapp |  |  | application | d_CompReportHeaderInfo, d_backupinfo, d_columnpreferences, d_general1, d_groupcatcode, d_reportheaderinfo ... | configsetting, script, syscatelog, sysobjects, usergroups | cmdshell, getdatetime, getmostrecenttransdate | w_activation, w_dashboards, w_dbbackup1, w_login1, w_logo |
| `w_about` | window | abuzarapp | About | 2441 x 1876 | window |  | sequence, systextcatalog | dbms_version | w_activation, w_dbmsinfo |
| `w_access` | window | abuzarapp | Untitled | 1979 x 784 | window | d_access_saledetail, d_access_saledetail_copy, d_access_saleledger |  |  |  |
| `w_activation` | window | abuzarapp | License Window | 1723 x 748 | window |  | into, saleledger, sequence, systextcatalog | getdatetime | w_administrator_key |
| `w_administrator_key` | window | abuzarapp | Administrator Key | 1696 x 612 | window |  | sequence |  |  |
| `w_autopricingsettings` | window | abuzarapp | Auto Pricing Settings | 1851 x 1036 | window | d_general1 |  |  |  |
| `w_autorecovery` | window | abuzarapp | Auto Restore/Recovery | 2765 x 1514 | window | d_backupinfo |  | insert_eventlog | w_administrator_key, w_disclaimerwindow |
| `w_backupinfo` | window | abuzarapp |  | 2747 x 848 | window |  |  |  |  |
| `w_backupinfo_for_verificatioin` | window | abuzarapp | Backup file Selection | 2747 x 848 | window | d_backupinfo_for_verification |  |  |  |
| `w_bkg` | window | abuzarapp |  | 2578 x 1640 | window |  |  |  |  |
| `w_checkdb` | window | abuzarapp | Database Integrity Monitor | 2843 x 1748 | window |  |  | alterdb, checkdbintegrity, checktable, dbreindex, repairdb | w_administrator_key, w_disclaimerwindow, w_select_repairdb_option |
| `w_dbbackup1` | window | abuzarapp | Backup Database | 2000 x 698 | window |  |  | dbms_version | w_backupinfo, w_backupinfo_for_verificatioin |
| `w_dbmsinfo` | window | abuzarapp | Server Information | 2066 x 1088 | window |  |  |  |  |
| `w_disclaimerwindow` | window | abuzarapp |  | 2258 x 1080 | window |  |  |  |  |
| `w_godownsettings` | window | abuzarapp | Godown Settings | 1737 x 968 | window | d_general1, d_general2 |  |  |  |
| `w_login` | window | abuzarapp | Login | 1582 x 784 | window | d_login | users |  | w_main |
| `w_login1` | window | abuzarapp | Login | 1582 x 1016 | window | d_login, d_remotelogin, d_reportserver_databasename_company | users |  | w_checkdb, w_connectionmonitor |
| `w_logo` | window | abuzarapp |  | 1824 x 752 | window |  | softwarepreferences |  |  |
| `w_main` | window | abuzarapp | Abuzar Consultancy | 2999 x 2272 | window | d_groups, d_security | users |  | w_login |
| `w_module_password` | window | abuzarapp | Password | 1254 x 499 | window |  |  |  |  |
| `w_newpreferences` | window | abuzarapp | Preferences | 2779 x 1860 | window |  | rights, sysjobs | activatejob, adjustjobschedule |  |
| `w_pointofsalepreferences` | window | abuzarapp | Point of Sale Preferences | 1861 x 1184 | window | d_general1 |  |  |  |
| `w_pointofsalesettings` | window | abuzarapp | Point of Sale Settings | 2071 x 1692 | window | d_general1 |  |  |  |
| `w_special_rights_password` | window | abuzarapp | Password | 1262 x 508 | window |  |  |  |  |
| `w_startup` | window | abuzarapp | Startup Task(s) List | 2789 x 1684 | window | d_backupinfo, d_groupallowedstartupright |  |  | w_backupinfo |
| `w_startuprightsmodification` | window | abuzarapp | Rights | 2894 x 1948 | window | d_startupright |  |  |  |
| `w_startuprightsmodification_key` | window | abuzarapp |  | 1696 x 908 | window |  | sequence |  |  |
| `w_dashboard` | window | dashboard | Dashboard | 3745 x 2605 | window | d_dashboard_categoryinventorybeakup, d_dashboard_custcat_salesanalysis, d_dashboard_suppcat_puranalysis, d_top10sellingitemsgraph |  |  | w_dashboard_drilldown, w_dashboard_zoomed |
| `w_dashboard_drilldown` | window | dashboard | Dashboard | 1730 x 1005 | window | d_dashboard_accounts_drilldown, d_dashboard_adj2_drilldown, d_dashboard_adj_drilldown, d_dashboard_crs_sales_drilldown, d_dashboard_crs_sales_drilldown2, d_dashboard_crs_stockposition_drilldown ... |  |  |  |
| `w_dashboard_zoomed` | window | dashboard | Dashboard | 1726 x 1005 | window | d_dailysalesgraph |  |  | w_dashboard_drilldown |
| `w_dashboards` | window | dashboard | Dashboard | 3068 x 2090 | window | d_mr_recordpointer | serverdate | getdatetime | w_arg_mr_record_pointer, w_dashboard_zoomed |
| `m_crs_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  | w_crs_clientwise_searchinvoice |
| `m_dataimport_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_employee_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_guest_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_installment_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_loyalty_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_passport_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_popupmenu` | menu | popupmenus |  |  | menu | d_security_filtered |  |  |  |
| `m_product_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_production_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `m_student_reports` | menu | popupmenus |  |  | m_popupmenu |  |  |  |  |
| `w_job_schedule` | window | preferences | Job Schedules | 3131 x 2384 | window | d_backupschedule_2012, d_softwarepreferences_hidden | sysjobs | activatejob, adjustjobschedule, dbms_version |  |
| `w_pref_get_date` | window | preferences |  | 1152 x 548 | w_pref_get_text | d_pref_getdate |  |  |  |
| `w_pref_get_datetime` | window | preferences |  | 1152 x 548 | w_pref_get_text | d_pref_getdatetime |  |  |  |
| `w_pref_get_decimal` | window | preferences |  | 2363 x 548 | w_pref_get_text | d_pref_getdecimal |  |  |  |
| `w_pref_get_dropdown` | window | preferences |  | 2523 x 1120 | window | d_pref_dropdown |  |  |  |
| `w_pref_get_long` | window | preferences |  | 2363 x 548 | w_pref_get_text | d_pref_getlong |  |  |  |
| `w_pref_get_password` | window | preferences |  | 2761 x 548 | window | d_pref_getpassword |  |  |  |
| `w_pref_get_text` | window | preferences |  | 2761 x 548 | window | d_pref_gettext |  |  |  |
| `w_pref_get_text2` | window | preferences |  | 2761 x 548 | window | d_pref_gettext2 |  |  |  |
| `w_preferences` | window | preferences | Preferences | 2984 x 1843 | window | d_backupschedule_2012, d_softwarepreferences, d_softwarepreferences_hidden | sysjobs | activatejob, adjustjobschedule, dbms_version, godowndetail_repairforzerodecimal, initialize_tabmaxkey | w_module_password, w_pref_get_date, w_pref_get_datetime, w_pref_get_decimal, w_pref_get_dropdown |
| `w_printer` | window | printer | Print | 1957 x 1168 | window |  |  |  |  |
| `m_groupgodownsetting` | menu | templates |  |  | m_single_entry |  |  |  |  |
| `m_groupheadersetting` | menu | templates |  |  | m_single_entry |  |  |  |  |
| `m_saletemplatemenu` | menu | templates |  |  | m_multi_entry |  |  | create, destroy |  |
| `u_stockledger` | userobject | templates |  | 2710 x 714 | userobject | d_current_datetime, d_end_datetime, d_generateable_stockledger_items, d_start_datetime, d_stockleder_inputs |  | insert_eventlog, stockledger, updateitemstockledger |  |
| `w_alternate_saleinvno_setting` | window | templates | Alternate Sale Inv. Number Generation | 1979 x 1036 | window | d_general1 | _tabmaxkey |  |  |
| `w_attendenceslip` | window | templates | Attendance Slip | 2341 x 1464 | window | d_attendanceslip |  | getdatetime |  |
| `w_copyissueinvoicefrom` | window | templates | Copy Invoice From .... | 2880 x 1112 | window | d_arg_receipt, d_issuerequest, d_purinvtemplates | issuereqheader, purledger, receiptheader |  |  |
| `w_copyprescription` | window | templates | Prescription Selection | 1979 x 1064 | window | d_prescription |  |  |  |
| `w_copyprescription_all` | window | templates | Prescription Selection | 1979 x 1064 | window | d_prescription_all |  |  |  |
| `w_copyprfrom` | window | templates | Copy Invoice From .... | 2176 x 868 | window | d_prinvtemplates |  |  |  |
| `w_copypurfrom` | window | templates | Copy Invoice From .... | 2871 x 944 | window | d_purinvtemplates | purledger |  |  |
| `w_copypurinvoicefrom` | window | templates | Copy Invoice From .... | 2862 x 872 | window | d_purordertemplates |  |  |  |
| `w_copypurreturninvoicefrom` | window | templates | Copy Invoice From .... | 2864 x 1674 | window | d_arg_expiryinitimcation_purbased, d_arg_transfer, d_purinvtemplates, d_salereturninvtemplates | expiryintimation, purledger, srledger |  |  |
| `w_copysaleinvformodifiedsale` | window | templates | Copy Invoice From .... | 2862 x 1520 | window | d_saleinvformodifiedsale |  |  |  |
| `w_copysaleinvoicefrom` | window | templates | Copy Invoice From .... | 2862 x 1796 | window | d_arg_transfer, d_issuerequest, d_purinvtemplates, d_saleinvtemplates, d_salereturninvtemplates, d_saletemplates | issuereqheader, purledger, saleledger, srledger, theader |  |  |
| `w_copysaleinvoicefrom2` | window | templates | Copy Invoice From .... | 2245 x 1549 | window | d_arg_copysalefrom, d_arg_purorder, d_arg_receipt, d_arg_transfer, d_issuerequest, d_purinvtemplates ... | issuereqheader, purledger, purorderheader, receiptheader, saleledger, srledger, theader |  |  |
| `w_copysaleinvoicefrom3` | window | templates | Copy Invoice From .... | 2245 x 1548 | window | d_arg_copysalefrom3, d_saleinvtemplates, d_salereturninvtemplates | saleledger, srledger |  |  |
| `w_dbbackup` | window | templates |  | 1979 x 396 | window |  |  | backupdb |  |
| `w_for_generating_headerinvno` | window | templates | Untitled | 2405 x 1436 | window | d_saleinvlist_withheader1 |  |  |  |
| `w_for_removing_hyphen` | window | templates | Untitled | 2405 x 1436 | window | d_items_hyphen_list |  |  |  |
| `w_groupwise_allowedgroups_setting` | window | templates | Group Wise Allowed Groups Setting | 3058 x 1956 | window | d_groupallowedgroups, d_groupallowedgroupsdetail, d_groupinfo, d_groups_all |  |  |  |
| `w_groupwisegodownsetting` | window | templates | Group Wise Godown Setting | 2976 x 3316 | window | d_groupallowedgodown, d_groupallowedgodowndetail, d_groupinfo, ddd_adjustmentgodownstrategy, ddd_issuegodownstrategy, ddd_purchasegodownstrategy ... |  |  |  |
| `w_groupwiseheadersetting` | window | templates | Group Wise Header Setting | 2900 x 4915 | window | d_groupallowedheader, d_groupallowedheaderdetail, d_groupinfo |  |  |  |
| `w_initialization_key` | window | templates |  | 1687 x 828 | window |  | sequence |  |  |
| `w_inplace_initialization` | window | templates | Inplace Initialization | 1993 x 915 | window |  | _utn, loyaltycard | init_after_opening_voch, init_customers_balances, init_delete_table, init_loyaltypoints, init_opening_pur |  |
| `w_modify_reporttitles` | window | templates | Modify Report Titles | 2977 x 1920 | w_single_entry |  | region |  |  |
| `w_normal_initialization` | window | templates | Normal Initialization | 1993 x 1200 | window | d_drive_letters | _utn, into, loyaltycard, patientadmission, reportdata, softwarepreferences | init_after_opening_voch, init_customers_balances, init_delete_table, init_fetch_lastpurchasehistory, init_loyaltypoints |  |
| `w_popup_bookingdetail` | window | templates | Booking Details | 2898 x 1196 | window | d_booking_detail, d_booking_detail_allservices | accounts |  |  |
| `w_popup_customer` | window | templates | New Customer | 2757 x 772 | window | d_customer_popupdetail | accounts |  |  |
| `w_reipe_population_rejected` | window | templates | Rejected Item List | 2656 x 1624 | window | d_quotation_salepopulation_rejected |  |  |  |
| `w_reprioritize_stock` | window | templates | Re-Prioritize Item Stock | 1641 x 1212 | window |  |  | groupwise_reprioritizestockbatches, reprioritizestockbatches | w_arg_grouping, w_selection_manf_cat_class_packing, w_selection_reprioritize_item_stock |
| `w_rightsmodification` | window | templates | Rights Allocation Module | 2885 x 1776 | window | d_grouprights_modification, d_rights_modification, d_rightscategory, d_rightsclone, d_userrights_modification |  |  |  |
| `w_rightsmodification_key` | window | templates |  | 1687 x 828 | window |  | sequence |  |  |
| `w_sale_primarykeyfixer` | window | templates | Problem Fixer in Pur | 1979 x 451 | window |  |  | init_update_tabmaxkey |  |
| `w_saletemplate` | window | templates | Sale Template | 3077 x 1880 | w_multi_entry | d_adjust_saletemplate_wrt_stock, d_groupallowedmoduleheader, d_populateditems_active_stockitems, d_populateditems_and_active_stockitems, d_saletemplate_report, d_saletemplate_report_alhaqcorp ... | godowndetail, grouprights, item, itemcategory, itemsgroupcategory, saletemplatedetail, saletemplateheader, usergroups | generateautosale, generatemarkedsalefromtemplate, getitemstockall, getitemstocktotal, importsales | w_arg_godown_sdate_ldate_v1, w_arg_grouping, w_arg_item_populate2, w_arg_only_decimal_input, w_arg_percentage_reduce_raise |
| `w_saletemplate_saleestimates` | window | templates | Sales Estimates | 3488 x 2064 | window | d_saletemplate_additionalsale, d_saletemplate_detail_saleestimates, d_saletemplate_saleestimates | saletemplatedetail |  | w_selectformat_sale_or_all |
| `w_savesaleastemplate` | window | templates | Save As Template | 2222 x 1140 | window |  |  |  |  |
| `w_select_classpromotionoptions` | window | templates | Class Promotion Options | 1138 x 852 | window |  |  |  |  |
| `w_select_templateanalyzer` | window | templates | Template Analyzer | 1376 x 1196 | window |  |  |  |  |
| `w_select_templatemanipulator` | window | templates | Template Manipulator | 2711 x 1260 | window |  |  |  |  |
| `w_set_lasttransdate` | window | templates | Last Transaction Date Modification | 1979 x 452 | window |  | serverdate |  |  |
| `w_setgstperc` | window | templates | Specify Quantity | 1422 x 692 | window |  |  |  |  |
| `w_stockledger_repair` | window | templates | Update Item Stock Ledgers | 2736 x 848 | window |  |  | insert_eventlog, stockledger, updateitemstockledger |  |
| `w_templatemanipulater_cust_sdate_ldate` | window | templates | Populate Sale Invoice(s) | 2853 x 1776 | window | d_customer_sdate_ldate, d_saletemplate_detail, d_templatemanipulator_cust_sdate_ldate |  |  |  |
| `w_virtualgl_repair` | window | templates | Upgrade Accounting Repository | 2074 x 1008 | window |  |  | insert_eventlog, virtualgl |  |
| `m_transfer` | menu | transfer |  |  | m_multi_entry |  |  |  |  |
| `m_transferrequisition` | menu | transfer |  |  | m_multi_entry |  |  |  |  |
| `w_itemtransferhistory` | window | transfer | Item Transfer History | 3077 x 1848 | window | d_itemtransferhistory |  |  |  |
| `w_sourcebasedtransfer_stockperc` | window | transfer | Select Transfer Critreria | 992 x 644 | window |  |  |  |  |
| `w_transfer` | window | transfer | Transfer | 2971 x 1996 | w_multi_entry | d_IssueReqdetail_temp, d_OpenWholeSaleReturnDetail, d_WholeSaleDetail, d_batchtransfer_detail, d_godownwise_consumption, d_godownwise_itemreorder ... | accountgodown, customer, godown, godowndetail, godownitemsetting, groupallowedgodown, groups, into ... | deleteitemstockbatch, getitemavgprice, getitemreqqtyfortransfer, getitemstockbatch, getitemstocktotal | w_arg_account_godown, w_arg_categories_transfer, w_arg_cust, w_arg_customer_godown, w_arg_item_populate2 |
| `w_transfer_itemlist` | window | transfer | Items List | 3031 x 1212 | window | d_item_transferqty |  |  |  |
| `w_transfer_old` | window | transfer | Transfer | 2966 x 1789 | w_multi_entry | d_IssueReqdetail_temp, d_OpenWholeSaleReturnDetail, d_WholeSaleDetail, d_alharmainlights_transferinvreport_full, d_alkausar_transferinvreport, d_alnaseeb_transferinvreport_full ... | accountgodown, customer, godown, godowndetail, godownitemsetting, groupallowedgodown, groups, into ... | deleteitemstockbatch, getitemavgprice, getitemreqqtyfortransfer, getitemstockbatch, getitemstocktotal | w_arg_account_godown, w_arg_categories_transfer, w_arg_cust, w_arg_customer_godown, w_arg_item_populate2 |
| `w_transferrequisition` | window | transfer | Inter Godown Transfer Requisition | 3046 x 3469 | w_multi_entry | d_IssueReqdetail_temp, d_OpenWholeSaleReturnDetail, d_WholeSaleDetail, d_alnaseeb_transferrequisition_print, d_godownwise_consumption, d_godownwise_itemreorder ... | customer, godown, godowndetail, godownitemsetting, groupallowedgodown, into, item, itemcategory ... | getitemreqqtyfortransfer, getitemstocktotal, locksaleinvoice | w_arg_categories_transfer, w_arg_item_populate2, w_arg_item_populate_all_withoutgodown, w_arg_sinvcode_linvcode, w_copysaleinvoicefrom |
| `w_transferrequisition_posted_form` | window | transfer | Populate/Edit Posted Sale Order From .... | 1106 x 920 | window | d_saleorder_posted |  |  |  |
