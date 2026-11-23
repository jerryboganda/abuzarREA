import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for n in ["d_stockandsale_zone_and_others","d_supplierledger_itemwise","d_customerledger_quarter_summary"]:
    r=[x for x in rows if x["name"]==n][0]; s=r["sql"]["sql"]
    print("="*100); print(n,"len",len(s))
    for p in sorted(set(re.findall(r":([A-Za-z_]\w*)",s))):
        i=s.lower().find(":"+p.lower())
        print(f'  {p}: ...{s[max(0,i-120):i+80]}...'.replace("\n"," "))
