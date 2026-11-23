# SMS

| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |
|---|---|---|---|---|---|---|---|---|---|
| `m_smscentermenu` | menu | smscomponents |  |  | menu |  |  |  |  |
| `m_smstemplatemenu` | menu | smscomponents |  |  | m_multi_entry |  |  |  |  |
| `w_arg_contactgroup` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_contactgroup |  |  |  |
| `w_arg_objectcolumnlist` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_objectcolumnlist |  |  |  |
| `w_arg_smsdatadefinition` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_smsdatadefinition |  |  |  |
| `w_arg_smsdatadefinition_enabled` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_smsdatadefinition_enabled |  |  |  |
| `w_arg_smstemplate_data_enabled` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_smstemplate_data_enabled |  |  |  |
| `w_arg_smstemplate_enabled` | window | smscomponents | Specify Retrieval Arguements | 2798 x 963 | w_arguements | d_arg_smstemplate_enabled |  |  |  |
| `w_sendsms` | window | smscomponents | Test Message (SMS) | 2894 x 1948 | window | d_port, d_portdetail, d_sms_message |  |  |  |
| `w_sms_center` | window | smscomponents | SMS Center | 2864 x 2045 | window | d_khyber_thermal_saleinvrep, d_smscenter_contactgroup_selection, d_smscenter_contactselection, d_smscenter_patientselection_detail | saleledger, sms_center, sms_template, srledger, sysjobs | activatejob, adjustjobschedule, createdatasms, createsms | w_arg_academicclass, w_arg_classwise_studentselection_forsms, w_arg_contactselection_smscenter, w_arg_emp_category, w_arg_emp_department |
| `w_sms_finalizedsaleorder` | window | smscomponents | SMS Finalized Sale Order(s) | 2871 x 1796 | window | d_sms_customer_sdate_ldate, d_sms_finalizedsaleorders |  |  |  |
| `w_sms_postedsales` | window | smscomponents | SMS Finalized Sale Order(s) | 2871 x 1796 | window | d_sms_customer_sdate_ldate, d_sms_postedsales |  |  |  |
| `w_smscenter_preview` | window | smscomponents | SMS Preview Window | 2811 x 1840 | window | d_smscenter_preview |  |  |  |
| `w_smsdatacontent_enable_disable` | window | smscomponents | Enable/Disable SMS Data Contents | 2811 x 1840 | window | d_sms_datadefinitions, d_sms_templates |  |  |  |
| `w_smstemplate_form` | window | smscomponents | SMS Template Form | 3040 x 2264 | w_multi_entry |  | contactgroup, sms_datadefinition |  | w_arg_objectcolumnlist, w_rightsmodification_key, w_smsdatacontent_enable_disable |
| `bulksmsresquest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `campaignsresponse` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `campaignsresquest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `counterrequest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `counterresponse` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `dynamiclist` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `dynamicsmsrequest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `inboxrequest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `inboxresponse` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `numberslist` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `quicksmsresquest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `reportrequest` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
| `reportresponse` | userobject | smswebservices |  |  | nonvisualobject |  |  |  |  |
