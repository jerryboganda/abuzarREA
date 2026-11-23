import csv, statistics
p=r'C:\Projects\Abuzar\deploy\analysis\reports\srd_metrics.csv'
rows=[r for r in csv.DictReader(open(p,encoding='utf-8'))]
for r in rows:
    for k in ['bytes','sql_bytes','ctrl_total','col_ctrl','text_ctrl','compute_ctrl','bitmap_ctrl','report_ctrl','group_levels','summary_h','detail_h','tbl_cols','compute_syntax']:
        try: r[k]=int(r[k] or 0)
        except: r[k]=0
names={'d_dailysalesdetail','d_dailysalessummery','d_stockinhand','d_stockinbackdate','d_customerledger_itemwise','d_itemwisesalesdetail','d_saledetail_crosstab','d_itemstockregister','d_dailysalesdetail_invwise','d_comp_dailysummery_invwise','d_stockandsale','d_cashflow','d_itemwisesales','d_salesummary'}
seen=set()
for r in rows:
    if r['name'] in names and r['name'] not in seen:
        seen.add(r['name'])
        print(r['lib'],r['name'],'bytes',r['bytes'],'sql',r['sql_bytes'],'ctrl',r['ctrl_total'],'col',r['col_ctrl'],'txt',r['text_ctrl'],'comp',r['compute_ctrl'],'bmp',r['bitmap_ctrl'],'nest',r['report_ctrl'],'grp',r['group_levels'],'sumh',r['summary_h'],'sort',r['sort_clause'],'tbl',r['tbl_cols'])
r=[x for x in rows if x['sql_bytes']>0]
print('median controls',statistics.median(x['ctrl_total'] for x in r),'mean',round(statistics.mean(x['ctrl_total'] for x in r)))
print('p90 controls',sorted(x['ctrl_total'] for x in r)[int(.9*len(r))], 'max',max(x['ctrl_total'] for x in r))
print('dws >100 controls',sum(1 for x in r if x['ctrl_total']>100),' >200',sum(1 for x in r if x['ctrl_total']>200))
print('bitmap dws',sum(1 for x in r if x['bitmap_ctrl']>0),'nested dws',sum(1 for x in r if x['report_ctrl']>0))
print('detail band median',statistics.median(x['detail_h'] for x in r if x['detail_h']>0))
print('with sort',sum(1 for x in r if x['sort_clause']>0),'with filter',sum(1 for x in r if x['filter_clause']>0))
