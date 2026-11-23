# Hospital / clinic

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `w_diagnosticitem_form` | window | eprescriptionbasics | Diagnostic Item Form | 2994 x 2232 | w_single_entry |  | diagnosticitem |  |  |
| `w_diagnosticitemtype_form` | window | eprescriptionbasics | Diagnostic Item Type Form | 2994 x 2232 | w_single_entry |  | diagnosticitemtype |  |  |
| `w_diagnosticunit_form` | window | eprescriptionbasics | Diagnostic Unit Form | 2994 x 2232 | w_single_entry |  | diagnosticunit |  |  |
| `w_dosageunit_form` | window | eprescriptionbasics | Diagnostic Unit Form | 2995 x 2234 | w_single_entry |  | dosageunit |  |  |
| `w_edit_visitprescription` | window | eprescriptionbasics | Populate/Edit Patient Visit Prescription From .... | 2417 x 1453 | window | d_arg_visitcode_prescription |  |  |  |
| `w_organ_form` | window | eprescriptionbasics | Organ Form | 2994 x 2232 | w_single_entry |  | organ |  |  |
| `w_physicalexam_form` | window | eprescriptionbasics | Physical Examination Form | 2994 x 2232 | w_single_entry |  | physicalexam |  |  |
| `w_severitylevel_form` | window | eprescriptionbasics | Severity Level Form | 2999 x 1920 | w_single_entry |  | severitylevel |  |  |
| `w_symptom_form` | window | eprescriptionbasics | Sysmtom Form | 2994 x 2232 | w_single_entry |  | symptom |  |  |
| `w_symptomtype_form` | window | eprescriptionbasics | Symptom Type Form | 2999 x 1920 | w_single_entry |  | symptomtype |  |  |
| `w_visitstatus_form` | window | eprescriptionbasics | Visit Status Form | 2994 x 2232 | w_single_entry |  | symptom |  |  |
| `w_visittype_form` | window | eprescriptionbasics | Visit Type Form | 2994 x 2232 | w_single_entry |  | symptom |  |  |
| `f_set_patientprintout` | function | patientcomponents |  |  |  |  |  |  |  |
| `m_admissionmenu` | menu | patientcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_discchargepatient` | menu | patientcomponents |  |  | m_entry |  |  | create, destroy |  |
| `m_patientcard` | menu | patientcomponents |  |  | m_multi_entry |  |  |  |  |
| `m_patientmenu` | menu | patientcomponents |  |  | m_single_entry |  |  |  |  |
| `m_prescriptionmenu` | menu | patientcomponents |  |  | m_multi_entry |  |  | create, destroy |  |
| `m_transfermenu` | menu | patientcomponents |  |  | m_single_entry |  |  |  |  |
| `w_arg_mr_record_pointer` | window | patientcomponents | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_mr_recordpointer, d_mr_recordpointer |  |  |  |
| `w_associatedpatient` | window | patientcomponents | Associated Patient(s) | 2898 x 1656 | window | d_associated_patients_list |  |  |  |
| `w_birthcertificate` | window | patientcomponents | Birth Certificate | 3057 x 3475 | w_multi_entry | d_birthcertificate_detail_print, d_mubarakmc_birthcertificate_print | patient, patientadmission, visit |  | w_patientsearch, w_patientsearchresult, w_preview_invoices |
| `w_choose_precaution` | window | patientcomponents | Item Category | 2633 x 1684 | window | d_select_precaution |  |  |  |
| `w_customersite_form` | window | patientcomponents | Customer Site Form | 2985 x 2832 | w_multi_entry | d_group_servicetemplate, d_interfacesettingcols, d_mastercashierwindow_detail, d_patient_recurringservices, d_patientadmission_print, d_salecatinfo | mastercashwin, patient, patientadmission, patientlocation, patientrecservices, patienttransfer, saleledger, service ... |  | w_arg_sdate, w_arg_sinvcode_linvcode, w_mastercashierwindow, w_patientregistration, w_salesmanpassword |
| `w_deathcertificate` | window | patientcomponents | Death Certificate | 3057 x 1846 | w_multi_entry | d_deathcertificate_print, d_mubarakmc_deathcertificate_print | doctors, patient, patientadmission, visit |  | w_patientsearch, w_patientsearchresult, w_preview_invoices |
| `w_dischargereason_form` | window | patientcomponents | Patient Discharge Reason Form | 2999 x 1920 | w_single_entry |  | dischargereason |  |  |
| `w_dischargerefferal_form` | window | patientcomponents | Patient  Discharge Refferal Form | 2999 x 1920 | w_single_entry |  | dischargerefferal |  |  |
| `w_dosage_form` | window | patientcomponents | Dosage Form | 2999 x 1920 | w_single_entry |  | dosage |  |  |
| `w_eyevision_form` | window | patientcomponents | Eye Vision Form | 2999 x 1920 | w_single_entry |  | eyevision |  |  |
| `w_gestation_form` | window | patientcomponents | Patient Gestation Form | 2999 x 1920 | w_single_entry |  | gestation |  |  |
| `w_instruction_form` | window | patientcomponents | Medicine Instruction Form | 2999 x 1920 | w_single_entry |  | instruction |  |  |
| `w_iolpower_form` | window | patientcomponents | IOL Power Form | 2999 x 1920 | w_single_entry |  | iolpower |  |  |
| `w_mr_form` | window | patientcomponents | Patient Medical Record | 3072 x 2083 | window | d_mr_recordpointer, d_patientimage, d_pic2014_dischargeslip, d_pic2014_lab_print | _tabmaxkey, dosage, into, item, patient, patientadmission, patientimage, serverdate | getdatetime, getpatientdischargeability | w_arg_mr_record_pointer, w_patientgallary, w_patientimage, w_preview_invoices |
| `w_mr_list` | window | patientcomponents | Patient Medical Record (List View) | 2976 x 1964 | w_listview_form | d_mr_print_summarized | into, patientadmission, patientimage |  | w_mr_form, w_patient_first_contact, w_patientimage_rowid, w_patientregistration |
| `w_mr_patient_prescription_view` | window | patientcomponents | Patient Prescription View | 2898 x 1656 | window | d_mr_treatmentgiven |  |  |  |
| `w_patient_first_contact` | window | patientcomponents | Patient First Contact | 2839 x 1304 | window | d_patient_first_contact, d_patient_first_contact_print | patient, patientadmission, patientfirstcontact | admit_patient_emergency | w_patientfirstcontacthistory, w_preview_invoices |
| `w_patient_form1` | window | patientcomponents |  | 2995 x 1971 | w_single_entry | d_interfacesettingcols, d_mastercashierwindow_detail, d_mr_print_summarized, d_patientimage, d_patientregisteration_print | into, itemclass, mastercashwin, patient, patientadmission, patientimage, patienttransfer | autogeneratepatientregno, createautotriggersms, gettabmaxkey, virtualgl | w_associatedpatient, w_mastercashierwindow, w_patient_ledger, w_patientimage, w_popup_comprehensicesearch_selection |
| `w_patient_profile` | window | patientcomponents | Patient Profile | 2743 x 1594 | window | d_patient_profile_detail | patient, serverdate | autogeneratepatientregno, createautotriggersms, getdatetime, gettabmaxkey | w_salesmanpassword |
| `w_patient_profile_form` | window | patientcomponents | Patient Profile | 2977 x 1920 | w_single_entry | d_patientregisteration_print | itemclass, patient, patientadmission, patienttransfer | autogeneratepatientregno, createautotriggersms, gettabmaxkey | w_preview_invoices, w_salesmanpassword |
| `w_patientadmission_form` | window | patientcomponents | Patient Admission Form | 2940 x 1981 | w_multi_entry | d_admitedpatient_recurringservices2, d_amanchildcare_patientadmission_p, d_group_servicetemplate, d_mastercashierwindow_detail, d_patientadmission_fatimapharmacy, d_patientadmission_meharhsp_print ... | admittedpatientrecurringservices, mastercashwin, patient, patientadmission, patientlocation, patienttransfer, saleledger, serverdate ... | createautotriggersms, virtualgl | w_arg_disease_diseasetype, w_arg_diseasetype, w_arg_sdate, w_arg_single_servicetemplate, w_arg_sinvcode_linvcode |
| `w_patientadmission_form_popup` | window | patientcomponents | Patient Admission Form | 2940 x 1932 | w_patientadmission_form |  |  |  |  |
| `w_patientcard` | window | patientcomponents | Patient Card Printing Form | 2944 x 1827 | w_multi_entry | d_patientcard_detail, d_patientcard_print, d_studentenrolment_detail | patient |  | w_arg_activeclass_single, w_preview_invoices |
| `w_patientcategory` | window | patientcomponents | Patient Category Window | 3049 x 3324 | w_multi_entry |  | patientcatallowedmodule, patientcategory |  |  |
| `w_patientdischarge_form` | window | patientcomponents | Patient Discharge Form | 2999 x 1920 | w_single_entry | d_amanchildcare_patientdischarge_p, d_meharhsp_patientdischarge_print, d_nazeerhsp_patientdischarge_print, d_patientdischarge_print, d_pic2014_dischargeslip, d_realdoctorpvt_patientdischarge_prnt | patient, patientadmission, patientlocation, patienttransfer | createautotriggersms, getpatientdischargeability, inpatientbalance, virtualgl | w_inpatient_bill, w_mr_form, w_patienttransferhistory, w_preview_invoices |
| `w_patientfirstcontacthistory` | window | patientcomponents | Item Sale History | 2926 x 1700 | window | d_arg_patientfirstcontact_history, d_patient_first_contact_print |  |  |  |
| `w_patientgallary` | window | patientcomponents | Patient Image Gallery | 2793 x 1884 | window | d_patientgallary | patientimage |  |  |
| `w_patientimage` | window | patientcomponents | Patient Documents | 2569 x 1380 | window | d_patientimage |  |  | w_patientimage_rowid |
| `w_patientimage_admission` | window | patientcomponents | Patient Image(s) | 2569 x 1380 | window | d_patientimage_admission |  |  | w_patientimage_rowid |
| `w_patientimage_rowid` | window | patientcomponents | Patient Documents | 2985 x 1912 | window |  |  |  |  |
| `w_patientimage_rowid_old` | window | patientcomponents | Patient Image | 2967 x 1928 | window |  |  |  |  |
| `w_patientimage_visit` | window | patientcomponents | Patient Documents | 2569 x 1380 | window | d_patientimage_visit |  |  | w_patientimage_rowid |
| `w_patientinfo` | window | patientcomponents | Patient Information | 2944 x 1444 | window | d_interfacesettingcols, d_patient_detail |  |  |  |
| `w_patientlocation_form` | window | patientcomponents | Patient Location Form | 2999 x 1920 | w_single_entry |  | patientlocation, ward |  |  |
| `w_patientphonesearchresult` | window | patientcomponents | Patient Phone Search Result(s) | 2853 x 1652 | window | ddd_patientbyphoneno |  |  |  |
| `w_patientrecordview` | window | patientcomponents | View Patient Record | 2882 x 1197 | w_popup_forselection_walias | d_popup_patientselected_1, d_popup_patientselection_2 |  |  | w_popup_comprehensicesearch_selection |
| `w_patientregistration` | window | patientcomponents |  | 2970 x 1395 | window | d_interfacesettingcols, d_mastercashierwindow_detail, d_patient_detail, d_patientregisteration_print | mastercashwin, patient, serverdate | autogeneratepatientregno, createautotriggersms, getdatetime, gettabmaxkey | w_mastercashierwindow, w_salesmanpassword |
| `w_patientsearch` | window | patientcomponents | Patient Search . . . | 2834 x 1443 | window | d_patientsearch |  |  |  |
| `w_patientsearchresult` | window | patientcomponents | Patient Search Result(s) | 2853 x 1651 | window | d_patientsearch_result |  |  |  |
| `w_patienttransfer_form` | window | patientcomponents | Patient Admission Form | 2999 x 1920 | w_single_entry | d_patienttransferdetail | patient, patientadmission, patientlocation |  | w_patienttransferhistory, w_salesmanpassword |
| `w_patienttransferhistory` | window | patientcomponents | Patient Transfer History | 2930 x 1180 | window | d_patienttransferhistory |  |  |  |
| `w_precaution_form` | window | patientcomponents | Precautions Form | 2999 x 1920 | w_single_entry |  | precaution |  |  |
| `w_prescription_form` | window | patientcomponents | Patient Prescription Form | 2940 x 2301 | w_multi_entry | d_deliveryorder_half, d_itemstockinfo, d_prescriptiondeletedetail, d_retailsaleinvreport, d_view_prescription_discontinueditems, d_view_prescription_profile | dosage, item, itemcategory, itemsgroupcategory, patient, patientadmission, patientcatallowedmodule, prescriptionheader ... | postpresheader | w_arg_sinvcode_linvcode, w_preview_invoices, w_previnvinfo, w_salesmanpassword |
| `w_rank_form` | window | patientcomponents | Rank Form | 2999 x 1920 | w_single_entry |  | timeslot |  |  |
| `w_relation_form` | window | patientcomponents | Relation Form | 2999 x 1920 | w_single_entry |  | timeslot |  |  |
| `w_route_form` | window | patientcomponents | Medicine Route Form | 2999 x 1920 | w_single_entry |  | route |  |  |
| `w_simple_patientregistration` | window | patientcomponents |  | 2971 x 748 | window | d_mastercashierwindow_detail, d_patientregisteration_print, d_simple_patient_detail | mastercashwin, patient, serverdate | autogeneratepatientregno, getdatetime, gettabmaxkey | w_mastercashierwindow, w_salesmanpassword |
| `w_surgery_form` | window | patientcomponents | Surgery Form | 2999 x 1920 | w_single_entry |  | surgery |  |  |
| `w_surgeryprocedure_form` | window | patientcomponents | Surgery Procedure Form | 2999 x 1920 | w_single_entry |  | surgeryprocedure |  |  |
| `w_testmachine_form` | window | patientcomponents | Test Machine Form | 2999 x 1920 | w_single_entry |  | gestation |  |  |
| `w_unit_form` | window | patientcomponents | Unit Form | 2999 x 1920 | w_single_entry |  | timeslot |  |  |
| `w_ward_form` | window | patientcomponents | Ward Form | 2999 x 1920 | w_single_entry |  | ward |  |  |
| `m_vaccinefollowupmenu` | menu | patientvaccinecomp |  |  | menu |  |  | create, destroy |  |
| `m_vaccineshedulemenu` | menu | patientvaccinecomp |  |  | m_multi_entry |  |  | create, destroy |  |
| `w_vaccine_followup` | window | patientvaccinecomp | Treatment / Vaccine Follow-Up Form | 2894 x 1952 | window | d_patientvaccinefollowup_print, d_patientvaccineschedule_print, d_vaccineschedule_details | patient, saleledger, srledger |  | w_arg_patientonly, w_arg_sdate_ldate, w_preview_invoices |
| `w_vaccineschedule_form` | window | patientvaccinecomp | Treatment / Vaccine Schedule Form | 2948 x 2240 | w_multi_entry | d_deliveryorder_half, d_patientvaccineschedule_print, d_saletemplate_detail_bulk, d_vaccineschedule_details | item, itemcategory, itemsgroupcategory, patient, patientadmission, patientcatallowedmodule, prescriptionheader, saledetail ... | postpresheader | w_arg_saletemplate, w_arg_sinvcode_linvcode, w_preview_invoices, w_salesmanpassword |
| `w_vaccineschedule_info` | window | patientvaccinecomp | Vaccine Schedule Information | 3397 x 1656 | window | d_patientvaccineschedule_print |  |  |  |
| `m_patientvisitmenu` | menu | patientvisitcomp |  |  | m_single_entry |  |  |  |  |
| `m_visit_appointment` | menu | patientvisitcomp |  |  | m_single_entry |  |  |  |  |
| `m_visitmenu` | menu | patientvisitcomp |  |  | m_multi_entry |  |  |  |  |
| `w_appointments_for_a_period` | window | patientvisitcomp | Patient Appointments | 3255 x 1645 | window | d_appointments_for_a_doctor, d_appointments_for_a_doctor_print |  |  |  |
| `w_appointtments_for_a_period` | window | patientvisitcomp | Patient Visit Appointments | 3255 x 1642 | window | d_visitappointment_for_a_period, d_visitprescription_print |  |  |  |
| `w_diseasetreatmenttemplate` | window | patientvisitcomp | Disease Treatment Template | 3077 x 1880 | w_multi_entry | d_diseasetreatmenttempalte_printout, d_groupallowedmoduleheader, d_populateditems_active_stockitems, d_populateditems_and_active_stockitems | diseasetreatmenttemp, dosage, grouprights, item, itemcategory, itemsgroupcategory, usergroups |  | w_arg_item_populate2, w_preview_invoices |
| `w_patientvisit_form` | window | patientvisitcomp | Patient Visit | 3149 x 2304 | window | d_diseasetreatmenttemplate_detail, d_mr_recordpointer, d_patientimage, d_populate_visit_prescription, d_visit_detail, d_visit_prescription ... | _tabmaxkey, diseasetreatmenttemp, doctors, dosage, into, item, patient, patientcatallowedmodule ... | getdatetime | w_arg_disease_diseasetype, w_arg_diseasetreatmenttemplate, w_arg_diseasetreatmenttemplate_disease, w_arg_diseasetype, w_arg_mr_record_pointer |
| `w_patientvisit_list` | window | patientvisitcomp | Patient Visit | 3013 x 2141 | w_listview_form | d_visitprescription_print | into, patientimage, visit | postvisit | w_appointtments_for_a_period, w_arg_sdate_ldate, w_arg_sinvcode_linvcode_onedoctor, w_patientimage_rowid, w_patientregistration |
| `w_visit_appointment_form` | window | patientvisitcomp | Patient Visit Appointment Form | 3013 x 2157 | w_single_entry | d_surgicalcentre_visitappointment_print, d_visitappointment_print, d_visitappointment_print_drwajidali, d_visitappointment_print_familycarehsp, d_visitappointment_print_mubarakmc | doctors, itemclass, patient, patientadmission, patientcatallowedmodule, patienttransfer, serviceheader, visitappointment | createautotriggersms, gettabmaxkey, postvisitappointment | w_appointments_for_a_period, w_arg_sinvcode_linvcode_onedoctor, w_patientregistration, w_preview_invoices, w_salesmanpassword |
| `w_visit_form` | window | patientvisitcomp | Patient Visit Form | 3067 x 2004 | w_multi_entry | d_patientimage, d_visit_detail, d_visit_precaution, d_visit_prescription, d_visitdiagnostics, d_visitphysicalexam ... | doctors, into, patient, patientcatallowedmodule, patientimage, visit | lockvisit, postvisit | w_arg_sinvcode_linvcode_onedoctor, w_choose_precaution, w_patientimage, w_patientregistration, w_patientsearch |
| `w_visit_prescription_assistant` | window | patientvisitcomp | Patient Visit Prescription Assistant | 3255 x 1642 | window | d_populate_visit_prescription |  |  |  |
| `w_visit_prescription_history` | window | patientvisitcomp | Patient Visit Prescription History | 3255 x 1642 | window | d_visit_prescription_visithistory, d_visitprescription_print |  |  |  |
| `w_visitdiagnostics` | window | patientvisitcomp | Patient Diagnostics | 3131 x 1820 | window | d_visitdiagnostics, d_visitsymptoms_header, ddd_diagnosticitem |  |  |  |
| `w_visithistory` | window | patientvisitcomp | Patient Visit History | 2853 x 1652 | window | d_visithistory, d_visitprescription_print |  |  | w_preview_invoices |
| `w_visitphysicalexam` | window | patientvisitcomp | Patient Physical Exam | 3131 x 1820 | window | d_visitphysicalexam, d_visitsymptoms_header, ddd_physicalexam |  |  |  |
| `w_visitprescription` | window | patientvisitcomp | Rx (Patient Prescription) | 3141 x 1840 | window | d_visit_prescription, d_visit_prescription_detail, d_visitsymptoms_header, ddd_itemmanfnames_visitprescript_popup | dosage |  | w_arg_modelvisit, w_visitprescription_details |
| `w_visitprescription_details` | window | patientvisitcomp | Rx/Prescription Detail | 2866 x 1756 | window | d_visit_prescription_detail | dosage, serverdate | getdatetime |  |
| `w_visits_for_a_period` | window | patientvisitcomp | Patient Visit | 3255 x 1642 | window | d_visit_for_a_period, d_visitprescription_print |  |  |  |
| `w_visitsymptoms` | window | patientvisitcomp | Patient Diagnosis/Symptoms | 3150 x 1840 | window | d_visitsymptoms, d_visitsymptoms_header, ddd_symptom |  |  |  |
| `w_visitsymptoms1` | window | patientvisitcomp | Patient Diagnosis/Symptoms | 3122 x 1824 | window | d_visitsymptoms, d_visitsymptoms_header, ddd_symptom |  |  |  |
| `w_visitvitals` | window | patientvisitcomp | Patient Vital Signs | 2587 x 1780 | window | d_visitvitals | patient, serverdate | getdatetime |  |
