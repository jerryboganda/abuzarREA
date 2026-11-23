import re
p=r'C:\Projects\Abuzar\recovered\datawindows\accountreports\d_customerledger_itemwise.srd'
t=open(p,encoding='utf-8',errors='replace').read()
s=re.search(r'retrieve="(.*?)"\s*\r?\n',t,re.S).group(1)
for pat in ['VirtualGL','UNION ALL','\\(\\s*SELECT','dbo\\.fn_','SaleDetail','SaleLedger','CashierWindow','Item ']:
    print(pat, len(re.findall(pat,s,re.I)))
print('len',len(s))
print('selects',len(re.findall(r'\bSELECT\b',s,re.I)))
