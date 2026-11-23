# Employees / HR

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `cvuo_attendance` | userobject | employee |  | 2939 x 1476 | userobject | d_emp_attendance_info |  |  |  |
| `m_employeecard` | menu | employee |  |  | m_multi_entry |  |  |  |  |
| `m_payroll_menu` | menu | employee |  |  | m_multi_entry |  |  |  |  |
| `w_arg_emp_record_pointer` | window | employee | Specify Retrieval Arguements | 1897 x 963 | w_arguements | d_arg_emp_recordpointer, d_emp_recordpointer |  |  |  |
| `w_emp_advance` | window | employee | Employee Advances | 3163 x 2736 | w_multi_entry | d_emp_advance_print | emp_employee | createvoucher | w_preview_invoices, w_printer_copies, w_salesmanpassword |
| `w_emp_allowances` | window | employee | Employee Allowances Form | 2999 x 1920 | w_single_entry |  | emp_allowance |  |  |
| `w_emp_attendance` | window | employee |  | 3003 x 1712 | window | d_emp_employee_id, d_emp_fingerprint_features | emp_employee, into | markattendance |  |
| `w_emp_attendance_old` | window | employee | Employee Attendance System | 2985 x 1368 | window | d_emp_attendance_info, d_emp_fingerprint_features | emp_employee, into | markattendance |  |
| `w_emp_attendanceregister` | window | employee | Employee Attendance Register | 3076 x 2301 | w_multi_entry |  | emp_department, emp_pay |  |  |
| `w_emp_attendancestatus` | window | employee | Employee Attendance Status | 2999 x 1920 | w_single_entry |  | emp_attendancestatus |  |  |
| `w_emp_biometricmachine_mgmt` | window | employee | Biometric Device Management | 2565 x 2088 | window | d_biometricmachine_sync | emp_employee, into | markattendance |  |
| `w_emp_category` | window | employee | Employee Category Form | 2999 x 1920 | w_single_entry |  | emp_category |  |  |
| `w_emp_certification` | window | employee | Employee Certification Form | 2999 x 1920 | w_single_entry |  | emp_certification |  |  |
| `w_emp_deduction` | window | employee | Employee Deduction Form | 2977 x 1920 | w_single_entry |  | accounts, categoryaccounts, gldetail, prledger, purledger, saleledger, srledger, subaccounts | virtualgl | w_account_ledger |
| `w_emp_dept` | window | employee | Employee Department Form | 3076 x 2301 | w_multi_entry |  | emp_department |  |  |
| `w_emp_designation` | window | employee | Employee Designation Form | 2999 x 1920 | w_single_entry |  | emp_designation |  |  |
| `w_emp_education` | window | employee | Employee Education Form | 2999 x 1920 | w_single_entry |  | emp_education |  |  |
| `w_emp_employee_fingerprint_enrollment` | window | employee | Employee Fingerprint Enrollment  | 2693 x 1964 | window | d_emp_employee_info | emp_fingerprint, into |  |  |
| `w_emp_employee_fingerprint_enrollment_old` | window | employee | Employee Fingerprint Enrollment  | 2693 x 1964 | window | d_emp_employee_info | emp_fingerprint, into |  |  |
| `w_emp_form` | window | employee | Employee Form | 3087 x 2093 | window | d_account_detail, d_emp_allowances_list, d_emp_deduction_list, d_emp_payallowances_notused, d_emp_paydeduction_notused, d_emp_recordpointer ... | _tabmaxkey, accounts, emp_employee, emp_image, into, transportroute |  | w_arg_emp_record_pointer, w_employeegallary, w_employeeimage |
| `w_emp_holiday` | window | employee | Holiday Calendar | 3186 x 2952 | w_multi_entry |  | emp_department |  |  |
| `w_emp_payroll_payment` | window | employee | Employee Payroll Payment | 3024 x 1459 | window | d_emp_paid_payrolllist | patient, serverdate | getdatetime | w_salesmanpassword |
| `w_emp_skill` | window | employee | Employee Skill Form | 2999 x 1920 | w_single_entry |  | emp_skill |  |  |
| `w_employee_list` | window | employee | Employee List | 3122 x 1936 | w_listview_form | d_emp_employee |  |  | w_emp_employee_fingerprint_enrollment, w_emp_form |
| `w_employeecard` | window | employee | Employee Card Printing Form | 2970 x 2307 | w_multi_entry | d_studentenrolment_detail, d_studentenrolment_print | emp_employee, softwarepreferences |  | w_arg_activeclass_single, w_preview_invoices, w_selectformat_1_2, w_selectformat_front_back |
| `w_employeegallary` | window | employee | Patient Image Gallery | 2839 x 2240 | window | d_employeegallery | emp_image |  |  |
| `w_employeeimage` | window | employee | Employee Image(s) | 2569 x 1380 | window | d_employeeimage |  |  | w_employeeimage_rowid |
| `w_employeeimage_rowid` | window | employee | Employee Image | 2912 x 1952 | window | d_employeeimage_rowid, d_patientimage_rowid |  |  |  |
| `w_payroll` | window | employee | Payroll | 3679 x 2099 | w_multi_entry | d_emp_attendance_record, d_emp_payallowances, d_emp_paydeduction, d_payslip_print, d_purdetail_changeprice_foritemlog, ddd_employees | emp_advance, emp_employee, emp_payroll, virtualgl | generatepayroll, postpayroll | w_arg_emp_category_dept_period, w_arg_sinvcode_linvcode, w_emp_payroll_payment, w_preview_invoices, w_salesmanpassword |
