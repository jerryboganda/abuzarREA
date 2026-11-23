import os,re,csv,json
ROOT=r"C:\Projects\Abuzar\recovered\datawindows"
OUT=r"C:\Projects\Abuzar\deploy\analysis\reports"
REPORT_LIBS={'sprntatod','sprntotos','sprntetok','sprntlton','sprntttoz','salereportscust','accountreports','salereports','stockreports','purchaseprintouts','purchase&returnreports','salereportssumm','salereturnprintouts','specialreports','itemreports','patientreports','salereportsdet','salemodreports','crsreports','godownreports','issuereports','financialreports','agingreports','receiptreports','saleprintouts','servicesaleprintouts','reports_cust','billsummary','reportdwarg','managementreports','servicereports','salereportscomp','reportformat'}
out=[]
for lib in os.listdir(ROOT):
    if lib not in REPORT_LIBS: continue
    d=os.path.join(ROOT,lib)
    for filename in os.listdir(d):
        if not filename.endswith('.srd'): continue
        t=open(os.path.join(d,filename),encoding='utf-8',errors='replace').read()
        m=re.search(r'retrieve="(.*?)"\s*\r?\n',t,re.S)
        if not m: continue
        s=m.group(1)
        u=len(re.findall(r'\bUNION\b',s,re.I)); sel=len(re.findall(r'\bSELECT\b',s,re.I))
        vgl=len(re.findall(r'\bVirtualGL\b',s,re.I)); fnref=len(re.findall(r'\bdbo\.fn_',s,re.I))
        sd=len(re.findall(r'\bSaleDetail\b',s,re.I)); cw=len(re.findall(r'\bCashierWindow\b',s,re.I))
        sub=len(re.findall(r'\(\s*SELECT',s,re.I))
        out.append(dict(lib=lib,name=filename[:-4],sql=len(s),union=u,selects=sel,vgl=vgl,fnref=fnref,sd=sd,cw=cw,sub=sub))
out.sort(key=lambda r:-(r['union']*300+r['sub']*20+r['vgl']*200+r['fnref']*100+r['sql']//20))
json.dump(out,open(os.path.join(OUT,'sqlcost.json'),'w'),indent=0)
print('TOP 45 by SQL fan-out')
for r in out[:45]:
    print(f"{r['lib']:18} {r['name'][:44]:44} sql={r['sql']:5} union={r['union']:3} sel={r['selects']:3} vgl={r['vgl']:3} fn={r['fnref']:2} sub={r['sub']:3}")
print('\ncounts: union>10',sum(1 for r in out if r['union']>10),'sub>50',sum(1 for r in out if r['sub']>50),'vgl>10',sum(1 for r in out if r['vgl']>10),'fn>0',sum(1 for r in out if r['fnref']>0))
