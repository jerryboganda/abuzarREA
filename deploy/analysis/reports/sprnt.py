import csv, statistics, collections
p=r'C:\Projects\Abuzar\deploy\analysis\reports\srd_metrics.csv'
rows=[r for r in csv.DictReader(open(p,encoding='utf-8'))]
sprnt={'sprntatod','sprntotos','sprntetok','sprntlton','sprntttoz'}
def I(x):
    try:return int(x or 0)
    except:return 0
s=[r for r in rows if r['lib'] in sprnt]
for r in s:
    for k in ['bytes','ctrl_total','col_ctrl','text_ctrl','compute_ctrl','bitmap_ctrl','report_ctrl','sql_bytes','group_levels']:
        r[k]=I(r[k])
print('sprnt layouts',len(s),'total MB',round(sum(r['bytes'] for r in s)/1048576,1))
print('median ctrl',statistics.median(r['ctrl_total'] for r in s),'p90',sorted(r['ctrl_total'] for r in s)[int(.9*len(s))],'max',max(r['ctrl_total'] for r in s))
print('with bitmap',sum(1 for r in s if r['bitmap_ctrl']>0),'median bmp',statistics.median(r['bitmap_ctrl'] for r in s if r['bitmap_ctrl']>0))
print('nested',sum(1 for r in s if r['report_ctrl']>0))
print('median sql bytes',statistics.median(r['sql_bytes'] for r in s if r['sql_bytes']>0))
print('avg controls per layout',round(sum(r['ctrl_total'] for r in s)/len(s),1))
# Top layouts by controls
print('\nTop 15 by controls:')
for r in sorted(s,key=lambda x:x['ctrl_total'],reverse=True)[:15]:
    print(r['lib'],r['name'],r['ctrl_total'],'bmp',r['bitmap_ctrl'],'kb',r['bytes']//1024)
