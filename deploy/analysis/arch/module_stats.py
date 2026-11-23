import os, collections, json
root = r"C:\Projects\Abuzar\recovered"
groups = {
 "core-sales": ["sale","salewin","salerespwin","salereturncomponents","saleorder","quotation","proformasales","proformapurchase","advancedsale","salemodified","poscomponents","cashierjob","billsummary","duecomponents","receiptcomponents"],
 "core-purchase": ["purchasecomponents","purchaseresponsewin","advancedpurchase","pocomponents","prcomponents","proformapurchase","issuecomponents","issuereq","transfer","adjustment","godownreports","packingmodule"],
 "master-data": ["custcomponents","multientry","multientrygroups","multientryitem","multientryitemrespwin","multientrypolicy","changeitemprice","components","preferences","contactmanagement","notescomponents"],
 "accounts": ["accounts","accountsext","accountsrespwin","accountstemplate","accountreports","financialreports","agingreports","managementreports","specialreports"],
 "reports": ["reports","reportformat","reports_cust","salereports","salereportscomp","salereportscust","salereportsdet","salereportssumm","salemodreports","stockreports","itemreports","issuereports","purchasereports","purchase&returnreports","salereturnreports","servicereports","patientreports","accountreports","financialreports","agingreports","managementreports","specialreports","godownreports","reportdwarg","reportviewer","saleprintouts","purchaseprintouts","salereturnprintouts","servicesaleprintouts"],
 "pharmacy/hospital": ["patientcomponents","patientvisitcomp","patientvaccinecomp","patientreports","ipservices","ipsale","eprescriptionbasics","servicemodules","servicecomponents","serviceresult","servicesalescomp","servicesalesreturn","servicepurcomponents","serviceheads"],
 "school": ["studentcomponents"],
 "hotel": ["guestcomponents"],
 "hr": ["employee","useratten","incentivesheet"],
 "sms/crs/sync": ["smscomponents","smswebservices","crscomponents","crsreports","datatransferapp","datatransfercomponents"],
 "framework": ["templates","functions","dropdowns","barcodefunctions","barcodecomponents","labels","graphcomponents","dashboard","printer","psrviewer","reportviewer","dw2xls"],
}
wins = collections.Counter(); dws = collections.Counter(); lines = collections.Counter()
libw = {}; libdw = {}; libln = {}
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
            if f.endswith(".pbs"):
                n += open(os.path.join(dp,f),encoding="utf-8",errors="ignore").read().count("\n")+1
    libln[lib]=n
for g,libs in groups.items():
    seen=set()
    for l in libs:
        if l in seen: continue
        seen.add(l)
        wins[g]+=libw.get(l,0); dws[g]+=libdw.get(l,0); lines[g]+=libln.get(l,0)
print(f"{'group':20} {'windows':>8} {'dws':>8} {'lines':>9}")
for g in groups: print(f"{g:20} {wins[g]:8} {dws[g]:8} {lines[g]:9}")
print("unassigned libs:")
assigned=set(l for ls in groups.values() for l in ls)
for l in sorted(set(libw)|set(libdw)|set(libln)):
    if l not in assigned: print(f"  {l:28} win={libw.get(l,0):4} dw={libdw.get(l,0):4} lines={libln.get(l,0):7}")
