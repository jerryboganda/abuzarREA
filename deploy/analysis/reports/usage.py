import os,re,collections
ROOT=r"C:\Projects\Abuzar\recovered\scripts"
names=['d_itemlog_azhar','d_item_detail','d_item_garments_wizard','d_item_update','d_normalpurchasedetail','d_customer_detail','d_saledetail','d_amintraders_saleinvreport','d_glaxydist_saleinvreport','d_ahmadmedicine2_saleinvprint_full','d_dailysalesdetail','d_stockinhand','d_customerledger_itemwise']
for n in names:
    hits=[]
    for dp,dn,fn in os.walk(ROOT):
        for f in fn:
            if not f.endswith('.pbs'): continue
            t=open(os.path.join(dp,f),encoding='utf-8',errors='replace').read()
            c=t.count(n)
            if c: hits.append((os.path.basename(dp),f,c))
    print(n,'refs',sum(h[2] for h in hits),'files',len(hits), hits[:5])
