import os, collections
root = r"C:\Projects\Abuzar\recovered"
# assign each library to exactly one bucket, first match wins
order = [
 ("reports", ["reports","reportformat","reports_cust","reportdwarg","reportviewer","salereports","salereportscomp","salereportscust","salereportsdet","salereportssumm","salemodreports","stockreports","itemreports","issuereports","purchase&returnreports","salereturnreports","servicereports","patientreports","accountreports","financialreports","agingreports","managementreports","specialreports","godownreports","saleprintouts","purchaseprintouts","salereturnprintouts","servicesaleprintouts","sprntatod","sprntetok","sprntlton","sprntotos","sprntttoz","receiptreports"]),
 ("pharmacy/hospital", ["patientcomponents","patientvisitcomp","patientvaccinecomp","ipservices","ipsale","eprescriptionbasics","servicemodules","servicecomponents","serviceresult","servicesalescomp","servicesalesreturn","servicepurcomponents","serviceheads","servicesalesatoh","servicesalesitop","servicesalesqtoz"]),
 ("core-sales", ["sale","salewin","salerespwin","salereturncomponents","saleorder","quotation","proformasales","proformapurchase","advancedsale","salemodified","poscomponents","cashierjob","billsummary","duecomponents","receiptcomponents"]),
 ("core-purchase", ["purchasecomponents","purchaseresponsewin","advancedpurchase","pocomponents","prcomponents","issuecomponents","issuereq","transfer","adjustment","packingmodule"]),
 ("master-data", ["custcomponents","multientry","multientrygroups","multientryitem","multientryitemrespwin","multientrypolicy","changeitemprice","components","preferences","contactmanagement","notescomponents","singleentry","singleentryitem","lists","dropdowns","expiryintimation"]),
 ("accounts", ["accounts","accountsext","accountsrespwin","accountstemplate"]),
 ("school", ["studentcomponents"]),
 ("hotel", ["guestcomponents"]),
 ("hr", ["employee","useratten","incentivesheet"]),
 ("sms/crs/sync", ["smscomponents","smswebservices","crscomponents","crsreports","datatransferapp","datatransfercomponents"]),
 ("framework", ["templates","functions","barcodefunctions","barcodecomponents","labels","graphcomponents","dashboard","printer","psrviewer","dw2xls","abuzarapp","popupmenus","mgmtcomp","pbdwr125","pbsoapclient125","pbwsclient125"]),
]
wins=collections.Counter(); dws=collections.Counter(); lines=collections.Counter()
libw={};libdw={};libln={}
for lib in os.listdir(os.path.join(root,"objects")):
    p=os.path.join(root,"objects",lib,"window")
    if os.path.isdir(p): libw[lib]=len([f for f in os.listdir(p) if f.endswith(".json")])
for lib in os.listdir(os.path.join(root,"datawindows")):
    p=os.path.join(root,"datawindows",lib)
    if os.path.isdir(p): libdw[lib]=len([f for f in os.listdir(p) if f.endswith(".srd")])
for lib in os.listdir(os.path.join(root,"scripts")):
    p=os.path.join(root,"scripts",lib)
    if not os.path.isdir(p): continue
    n=0
    for dp,_,fs in os.walk(p):
        for f in fs:
            if f.endswith(".pbs"): n+=open(os.path.join(dp,f),encoding="utf-8",errors="ignore").read().count("\n")+1
    libln[lib]=n
assigned=set()
for g,libs in order:
    for l in libs:
        if l in assigned: continue
        assigned.add(l)
        wins[g]+=libw.get(l,0);dws[g]+=libdw.get(l,0);lines[g]+=libln.get(l,0)
print(f"{'bucket':20}{'windows':>8}{'dws':>7}{'lines':>9}")
for g,_ in order: print(f"{g:20}{wins[g]:8}{dws[g]:7}{lines[g]:9}")
print("TOTAL",sum(wins.values()),sum(dws.values()),sum(lines.values()))
print("unassigned",sorted((set(libw)|set(libdw)|set(libln))-assigned))
