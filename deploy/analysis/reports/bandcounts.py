import re, os
files={
 'd_dailysalesdetail':r'C:\Projects\Abuzar\recovered\datawindows\salereportsdet\d_dailysalesdetail.srd',
 'd_dailysalessummery':r'C:\Projects\Abuzar\recovered\datawindows\salereportssumm\d_dailysalessummery.srd',
 'd_stockinhand':r'C:\Projects\Abuzar\recovered\datawindows\stockreports\d_stockinhand.srd',
 'd_stockinbackdate':r'C:\Projects\Abuzar\recovered\datawindows\stockreports\d_stockinbackdate.srd',
 'd_customerledger_itemwise':r'C:\Projects\Abuzar\recovered\datawindows\accountreports\d_customerledger_itemwise.srd',
 'd_cashflow':r'C:\Projects\Abuzar\recovered\datawindows\accountreports\d_cashflow.srd',
 'd_amintraders_saleinvreport':r'C:\Projects\Abuzar\recovered\datawindows\sprntatod\d_amintraders_saleinvreport.srd',
 'd_glaxydist_saleinvreport':r'C:\Projects\Abuzar\recovered\datawindows\sprntetok\d_glaxydist_saleinvreport.srd',
}
for n,p in files.items():
    t=open(p,encoding='utf-8',errors='replace').read()
    # count dwo blocks with band=detail
    controls=re.findall(r'(?m)^\s*(column|compute|text|picture|line|rect|bitmap|graph|report)\(([^\n]*)',t)
    det=[c for c in controls if 'band=detail' in c[1]]
    detc=[c for c in det if c[0] in ('column','compute')]
    hdr=[c for c in controls if 'band=header' in c[1]]
    sumb=[c for c in controls if 'band=summary' in c[1]]
    print(f"{n:32} total={len(controls):3} detail={len(det):3} detailcols={len(detc):3} header={len(hdr):3} summary={len(sumb):3}")
