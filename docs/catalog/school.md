# School

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `m_custstudentservicetemp` | menu | studentcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_schoolleavingmenu` | menu | studentcomponents |  |  | m_single_entry |  |  |  |  |
| `m_studentcardmenu` | menu | studentcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_studentfeesheet_menu` | menu | studentcomponents |  |  | m_entry |  |  | create, destroy |  |
| `m_studentmenu` | menu | studentcomponents |  |  | m_single_entry |  |  |  |  |
| `m_studentservicetemp` | menu | studentcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_studenttransfermenu` | menu | studentcomponents |  |  | m_single_entry |  |  |  |  |
| `w_academicclass_form` | window | studentcomponents | Academic Class Form | 2970 x 1898 | w_single_entry |  | class, studentclass |  |  |
| `w_classgraduation` | window | studentcomponents | Class Graduation Form | 2976 x 1948 | w_multi_entry | d_classstudentlist_for_graduation, d_studentenrolment_detail, d_studentenrolment_print | student, studentclass | graduateclass | w_preview_invoices |
| `w_classmedium_form` | window | studentcomponents | Academic Class Medium Form | 2971 x 1896 | w_single_entry |  | classmedium |  |  |
| `w_classpromotion` | window | studentcomponents | Class Promotion Form | 2967 x 1800 | w_multi_entry | d_classstudentlist_for_promotion, d_studentenrolment_detail, d_studentenrolment_print | student, studentclass | promoteclass | w_preview_invoices, w_select_classpromotionoptions |
| `w_classtype_form` | window | studentcomponents | Academic Class Type Form | 2971 x 1896 | w_single_entry |  | classtype |  |  |
| `w_customerstudentservicetemplate` | window | studentcomponents | Customer/Student Service Template Form | 2953 x 1976 | w_multi_entry | d_servicestudenttemplatedetail, d_studentenrolment_print | class, customerstudentservicetemplate, student |  | w_arg_cust_student_servicetemplate, w_preview_invoices, w_salesmanpassword, w_set_student_columnvalue |
| `w_generate_studentfeesheet` | window | studentcomponents | Generate Class Wise Fee For Students | 2864 x 1754 | window | d_generate_services_class_reamrks2, d_generate_studentlist_class_service2, d_studentfeesheet_detail, d_studentfeesheet_header | _tabmaxkey |  |  |
| `w_grade_form` | window | studentcomponents | Grade Form | 2971 x 1896 | w_single_entry |  | grade |  |  |
| `w_school_form` | window | studentcomponents | School/Faculty Form | 2971 x 1896 | w_single_entry |  | school |  |  |
| `w_schoolbranch_form` | window | studentcomponents | School Branch Form | 2971 x 1896 | w_single_entry |  | schoolbranch |  |  |
| `w_schoolleaving_form` | window | studentcomponents | School Leaving Form | 3035 x 2020 | w_single_entry |  | serviceheader, servicerheader, student | performschoolleaving | w_popup_partialsearch_selection, w_salesmanpassword, w_studentsearch, w_studentsearchresult |
| `w_set_student_columnvalue` | window | studentcomponents | Copy Sale Price | 2121 x 692 | window | d_set_student_columnvalue |  |  |  |
| `w_student_fee_sheet_list` | window | studentcomponents | Student Fee Sheet | 3010 x 2122 | w_listview_form | d_serviceoinvreport, d_studentfeesheet_print |  | poststudentfeesheet | w_arg_academicclass_svctemp2, w_generate_studentfeesheet, w_preview_invoices, w_salesmanpassword, w_studentfeesheet_form |
| `w_student_fine_sdate_ldate` | window | studentcomponents | Student Fine Module | 2917 x 1796 | window | d_student_fine_sdate_ldate, d_student_fine_sdate_ldate_detail |  | apply_studentfine_on_unpaidinvoices |  |
| `w_student_fine_waiver` | window | studentcomponents | Student Fine Waiver | 2587 x 1160 | window | d_student_fine_waiver | virtualgl |  |  |
| `w_student_form` | window | studentcomponents | Student Registration Form | 2992 x 1754 | w_single_entry | d_studentimage, d_studentregisteration_print | into, student, studentimage | admit_student, gettabmaxkey, virtualgl | w_arg_activeclass_single, w_popup_comprehensicesearch_selection, w_popup_partialsearch_selection, w_preview_invoices, w_salesmanpassword |
| `w_student_form2` | window | studentcomponents | Quick Student Registration Form | 2970 x 2189 | w_single_entry | d_studentimage, d_studentregisteration_print | into, student, studentimage | admit_student, gettabmaxkey, virtualgl | w_arg_activeclass_single, w_popup_comprehensicesearch_selection, w_popup_partialsearch_selection, w_preview_invoices, w_student_ledger |
| `w_student_siblings_discount` | window | studentcomponents | Student Siblings Discount | 2766 x 1660 | window | d_student_siblings_discount |  |  | w_arg_noofsiblings, w_preview_invoices |
| `w_studentcard` | window | studentcomponents | Student Card Printing Form | 2944 x 1828 | w_multi_entry | d_studentenrolment_detail, d_studentenrolment_print | softwarepreferences, student, studentimage |  | w_arg_activeclass_single, w_preview_invoices, w_selectformat_1_2, w_selectformat_front_back |
| `w_studentclasstransfer_form` | window | studentcomponents | Student Class Transfer Form | 2999 x 1848 | w_single_entry |  | student, studentclass | admit_student | w_popup_partialsearch_selection, w_salesmanpassword, w_studentsearch, w_studentsearchresult, w_studenttransferhistory |
| `w_studentenrolment` | window | studentcomponents | Student Enrollment Form | 2951 x 1978 | w_multi_entry | d_studentenrolment_detail, d_studentenrolment_print | student, studentclass |  | w_preview_invoices |
| `w_studentfeesheet_form` | window | studentcomponents | Student Fee Sheet | 3368 x 2064 | window | d_mr_recordpointer | _tabmaxkey, _utn, accounts, customer, item, itemcategory, itemsgroupcategory, patient ... | checkunpostedpurinvintransactions, getdatetime, getpurinvbalance, getservice_aliasname, lockpurinvoice | w_arg_mr_record_pointer, w_patientgallary |
| `w_studentgallary` | window | studentcomponents | Student Image Gallery | 2793 x 1880 | window | d_studentgallary | studentimage |  |  |
| `w_studentimage` | window | studentcomponents | Student Image(s) | 2569 x 1380 | window | d_patientimage |  |  | w_studentimage_rowid |
| `w_studentimage_rowid` | window | studentcomponents | Student Image | 2894 x 1888 | window | d_Studentimage_rowid, d_patientimage_rowid |  |  |  |
| `w_studentregisteration` | window | studentcomponents | Quick Student Registration | 2971 x 1968 | window | d_student_detail2 | serverdate, student | admit_student, getdatetime, gettabmaxkey |  |
| `w_studentsearch` | window | studentcomponents | Student Search . . . | 2834 x 1219 | window | d_studentsearch |  |  |  |
| `w_studentsearchresult` | window | studentcomponents | Student Search Result(s) | 2853 x 1652 | window | d_studentsearch_result |  |  |  |
| `w_studentsearchresult_classwise` | window | studentcomponents | Student Search Result(s) | 2853 x 1652 | window | d_studentsearch_result_classwise |  |  |  |
| `w_studentservicetemplate` | window | studentcomponents | Student Service Template Form | 2944 x 1828 | w_multi_entry | d_servicestudenttemplatedetail, d_studentenrolment_print | student, studentservicetemplate, transportroute, vehicle |  | w_arg_servicestudenttemplate, w_preview_invoices, w_salesmanpassword, w_set_student_columnvalue |
| `w_studenttransferhistory` | window | studentcomponents | Student Class Transfer History | 3145 x 1572 | window | d_studenttransferhistory |  |  |  |
| `w_transportroute_form` | window | studentcomponents | Transport Route Form | 2971 x 1896 | w_single_entry |  | transportroute |  |  |
