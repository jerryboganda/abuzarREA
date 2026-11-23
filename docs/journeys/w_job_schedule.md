# w_job_schedule

- title: Job Schedules
- library: preferences (Application shell & settings)
- ancestor: `window`
- size: 3131 x 2384 PBU
- reached from: (opened from code / other windows)
- script size: 3882 lines; 69 events, 38 functions

## Controls (4)

- `dw_hidden` (u_dwstandard) dataobject `d_softwarepreferences_hidden`
- `cb_cancel` (commandbutton) text "&Cancel"
- `cb_ok` (commandbutton) text "&Save"
- `tab_preferences` (tab)

## Data

- DataWindows: `d_backupschedule_2012`, `d_softwarepreferences_hidden`
- tables touched by embedded SQL: sysjobs
- stored procedures: activatejob, adjustjobschedule, dbms_version
- global functions: f_getglobalcode, f_numberpreferences, f_rightexists, f_set_preference_local
- windows opened: -

## Events and functions

`w_job_schedule.create`, `w_job_schedule.destroy`, `w_job_schedule.open`, `cb_cancel.ue_enterkey`, `cb_cancel.clicked`, `cb_ok.ue_enterkey`, `cb_ok.clicked`, `tab_preferences.create`, `tab_preferences.destroy`, `tabpage_backup.create`, `tabpage_backup.destroy`, `rb_backupevery.clicked`, `rb_backuponce.clicked`, `cbx_activateautobackup.clicked`, `tabpage_stock.create`, `tabpage_stock.destroy`, `rb_oncestkver.clicked`, `rb_everystkver.clicked`, `cbx_activatestkver.clicked`, `rb_everystockreport.clicked`, `rb_everystockledger.clicked`, `cbx_activatestockledger.clicked`, `cbx_activatestockreport.clicked`, `rb_oncestockledger.clicked`, `rb_oncestockreport.clicked`, `tabpage_sales.create`, `tabpage_sales.destroy`, `rb_autoduesatisfy_every.clicked`, `rb_autoduesatisfy_once.clicked`, `cbx_autoduesatisfy.clicked`, `cbx_activateautocreditsaleposting.clicked`, `cbx_activateautocashsaleposting.clicked`, `tabpage_patient.create`, `tabpage_patient.destroy`, `cbx_activateautopostvisit.clicked`, `cbx_activateautopostvisitappointment.clicked`, `rb_patient_svc_every.clicked`, `rb_patient_svc_once.clicked`, `cbx_patientrecurringservices.clicked`, `rb_inpatient_svc_every.clicked`, `rb_inpatient_svc_once.clicked`, `cbx_inpatientrecurringservices.clicked`, `tabpage_guest.create`, `tabpage_guest.destroy`, `dw_guestcheckinservice.itemchanged`, `cbx_activateguestcheckinservice.clicked`, `tabpage_datamigration.create`, `tabpage_datamigration.destroy`, `rb_autodatamigration_every.clicked`, `rb_autodatamigration_once.clicked`, `cbx_activateautodatamigration.clicked`, `rb_autopurgesalesevery.clicked`, `rb_autopurgesalesonce.clicked`, `cbx_activateautopurgesales.clicked`, `tabpage_sms.create`, `tabpage_sms.destroy`, `rb_everysms.clicked`, `cbx_activatesms.clicked`, `rb_oncesms.clicked`, `tabpage_employee.create`, `tabpage_employee.destroy`, `rb_everyemp.clicked`, `rb_onceemp.clicked`, `cbx_activateemp.clicked`, `tabpage_doctor.create`, `tabpage_doctor.destroy`, `cbx_activatedocttoken.clicked`, `rb_oncedocttoken.clicked`, `rb_everydocttoken.clicked`, `w_job_schedule.wf_assigndatawindowchild`, `w_job_schedule.wf_insertandscrollto`, `w_job_schedule.wf_showerrmessage`, `w_job_schedule.wf_assigndatawindow`, `w_job_schedule.wf_set_interface_adjustments`, `w_job_schedule.wf_set_tab_visibility`, `w_job_schedule.wf_autodoctortokenreset`, `w_job_schedule.wf_autodatamigration`, `w_job_schedule.wf_autopurgepostedsales`, `w_job_schedule.wf_autocreditsalepostingjob`, `w_job_schedule.wf_autocashsalepostingjob`, `w_job_schedule.wf_autocheckedinguestservicesjob`, `w_job_schedule.wf_autoinpatientservicesjob`, `w_job_schedule.wf_autosatisfyduejob`, `w_job_schedule.wf_autoclientbackupjob`, `w_job_schedule.wf_stockledgerjob`, `w_job_schedule.wf_stockreportjob`, `w_job_schedule.wf_stockverificationjob`, `w_job_schedule.wf_autocreatesmsjob`, `w_job_schedule.wf_autoemployeetimeout`, `w_job_schedule.wf_open_autopurgesalesjob`, `w_job_schedule.wf_open_autodatamigrationjob`, `w_job_schedule.wf_open_autobackupclientjob`, `w_job_schedule.wf_open_autocashsalepostingjob`, `w_job_schedule.wf_open_autocreditsalepostingjob`, `w_job_schedule.wf_open_autodoctortokenresetjob`, `w_job_schedule.wf_open_stockjobs`, `w_job_schedule.wf_open_autoemployeetimeoutjob`, `w_job_schedule.wf_open_autocreatesmsjob`, `w_job_schedule.wf_open_autoguestcheckedinjob`, `w_job_schedule.wf_open_autoduesatisfyjob`, `w_job_schedule.wf_open_autopatientrecservericejob`, `w_job_schedule.wf_autopatientrecservicesjob`, `w_job_schedule.wf_open_inpatientrecservicesjob`, `w_job_schedule.wf_autopostvisitappointment`, `w_job_schedule.wf_open_autopostvisitappointmentjob`, `w_job_schedule.wf_open_autopostvisitjob`, `w_job_schedule.wf_autopostvisit`

Source: `recovered/scripts/preferences/w_job_schedule.pbs`
