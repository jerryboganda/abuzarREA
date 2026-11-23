import csv, collections, statistics, json, os
OUT=r"C:\Projects\Abuzar\deploy\analysis\reports"
rows=list(csv.DictReader(open(os.path.join(OUT,'srd_metrics.csv'),encoding='utf-8')))
for r in rows:
    for k in ['sql_len','bytes','sql_bytes','tbl_cols','sql_cols','tables_ref','joins','subqueries','case_exprs','sum_exprs','compute_syntax','ctrl_total','text_ctrl','col_ctrl','compute_ctrl','group_levels','summary_h','filter_clause','sort_clause','in_subquery','bitmap_ctrl','nested_report']:
        r[k]=int(r[k]) if r[k] not in ('','None') else 0
    for k in ['select_star','distinct','group_by','having','union','crosstab','temp_table','nolock','top_n']:
        r[k]=(r[k]=='True')

REPORT_LIBS={'sprntatod','sprntotos','sprntetok','sprntlton','sprntttoz','salereportscust','accountreports','salereports','stockreports','purchaseprintouts','purchase&returnreports','salereportssumm','salereturnprintouts','specialreports','itemreports','patientreports','salereportsdet','salemodreports','crsreports','godownreports','issuereports','financialreports','agingreports','receiptreports','saleprintouts','servicesaleprintouts','reports_cust','billsummary','reportdwarg','managementreports','servicereports','salereportscomp','reportformat'}
rep=[r for r in rows if r['lib'] in REPORT_LIBS]
print('report DWs',len(rep))
print('report DWs w groupby',sum(1 for r in rep if r['group_by']), 'union',sum(1 for r in rep if r['union']),'distinct',sum(1 for r in rep if r['distinct']))
print('crosstab',sum(1 for r in rep if r['crosstab']),'sort client',sum(1 for r in rep if r['sort_clause']>0),'compute',sum(1 for r in rep if r['compute_syntax']>0))
print('nested',sum(1 for r in rep if r['nested_report']>0),'bitmap',sum(1 for r in rep if r['bitmap_ctrl']>0))
print('avg sql bytes',int(statistics.mean([r['sql_bytes'] for r in rep if r['sql_bytes']>0])))
print('median sql bytes',int(statistics.median([r['sql_bytes'] for r in rep if r['sql_bytes']>0])))
print('p90 sql bytes',int(sorted([r['sql_bytes'] for r in rep if r['sql_bytes']>0])[int(.9*len([r for r in rep if r['sql_bytes']>0]))]))

# lib summary
by=collections.defaultdict(lambda: [0,0,0,0,0])
for r in rep:
    a=by[r['lib']]; a[0]+=1; a[1]+=r['sql_bytes']; a[2]+=1 if r['group_by'] else 0; a[3]+=1 if r['crosstab'] else 0; a[4]+=1 if r['union'] else 0
print('\nLIB count avgsql groupby crosstab union')
for k,v in sorted(by.items(), key=lambda kv:-kv[1][0])[:20]:
    print(f"{k:24} {v[0]:5} {v[1]//max(1,v[0]):8} {v[2]:6} {v[3]:6} {v[4]:5}")

def score(r):
    return (r['sql_len']//10 + r['joins']*80 + r['subqueries']*50 + r['in_subquery']*80 + r['group_by']*150 + r['union']*200 + r['distinct']*100 + r['case_exprs']*20 + r['sum_exprs']*25 + r['tbl_cols']*2 + r['compute_syntax']*10 + r['crosstab']*300)
print('\nTOP 40 complexity (report libs)')
for r in sorted(rep,key=score,reverse=True)[:40]:
    print(f"{score(r):6} {r['lib']:18} {r['name'][:46]:46} bytes={r['bytes']:7} sql={r['sql_bytes']:6} j={r['joins']:2} sub={r['subqueries']:1} gb={int(r['group_by'])} u={int(r['union'])} ct={int(r['crosstab'])} cols={r['tbl_cols']:3} comp={r['compute_syntax']:3} sort={int(r['sort_clause']>0)}")

print('\nTOP 25 biggest SQL in report libs')
for r in sorted(rep,key=lambda r:r['sql_bytes'],reverse=True)[:25]:
    print(f"{r['sql_bytes']:7} {r['lib']:18} {r['name'][:50]:50} j={r['joins']} tbl={r['tbl_cols']} gb={int(r['group_by'])} u={int(r['union'])} star={int(r['select_star'])}")

print('\nNo date predicate among report libs with SQL > 2KB:', sum(1 for r in rep if r['sql_bytes']>2000 and not r['date_pred']))
print('report DWs using temp tables:',sum(1 for r in rep if r['temp_table']),'with NOLOCK:',sum(1 for r in rep if r['nolock']),'TOP:',sum(1 for r in rep if r['top_n']))
