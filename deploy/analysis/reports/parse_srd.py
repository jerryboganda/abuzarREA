import os, re, json, csv, sys

ROOT = r"C:\Projects\Abuzar\recovered\datawindows"
OUT = r"C:\Projects\Abuzar\deploy\analysis\reports"

REPORT_LIBS = {
 'sprntatod','sprntotos','sprntetok','sprntlton','sprntttoz',
 'salereportscust','accountreports','salereports','stockreports','purchaseprintouts',
 'purchase&returnreports','salereportssumm','salereturnprintouts','specialreports',
 'itemreports','patientreports','salereportsdet','salemodreports','crsreports',
 'godownreports','issuereports','financialreports','agingreports','receiptreports',
 'saleprintouts','servicesaleprintouts','reports_cust','billsummary','reportdwarg',
 'managementreports','servicereports','salereportscomp','reportformat'
}

def extract_retrieve(t):
    i = t.find('retrieve="')
    if i < 0:
        return ''
    i += len('retrieve="')
    n = len(t)
    j = i
    while j < n:
        c = t[j]
        if c == '~':
            j += 2
            continue
        if c == '"':
            # closing if rest of line is whitespace
            k = j + 1
            while k < n and t[k] in ' \t':
                k += 1
            if k >= n or t[k] in '\r\n':
                return t[i:j]
        j += 1
    return t[i:i+200000]

def norm(s):
    return re.sub(r'\s+', ' ', s)

def count_controls(t):
    # layout controls appear near end; count patterns like "text(" / "column(" at token boundary
    return {
      'text_ctrl': len(re.findall(r'(?m)^\s*text\(', t)),
      'col_ctrl': len(re.findall(r'(?m)^\s*column\(', t)),
      'compute_ctrl': len(re.findall(r'(?m)^\s*compute\(', t)),
      'picture_ctrl': len(re.findall(r'(?m)^\s*picture\(', t)),
      'report_ctrl': len(re.findall(r'(?m)^\s*report\(', t)),
      'graph_ctrl': len(re.findall(r'(?m)^\s*graph\(', t)),
      'group_band': len(re.findall(r'(?m)^\s*group\(', t)),
      'line_ctrl': len(re.findall(r'(?m)^\s*line\(', t)),
      'rect_ctrl': len(re.findall(r'(?m)^\s*rect\(', t)),
    }

def band_heights(t):
    out = {}
    for b in ['header','summary','footer','detail','background','foreground']:
        m = re.search(r'(?m)^'+b+r'\(height=(\d+)', t)
        out[b] = int(m.group(1)) if m else None
    # group bands have header/trailer sub-bands: count group levels
    out['group_levels'] = len(re.findall(r'(?m)^\s*group\(level=', t)) or len(re.findall(r'group\(level=', t))
    return out

def parse_file(path, lib):
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        t = f.read()
    sql = extract_retrieve(t)
    s = norm(sql)
    su = s.upper()
    # table section columns (column=(type=... name=...)
    tbl_cols = len(re.findall(r'(?m)^column=\(type=', t))
    lays = count_controls(t)
    bands = band_heights(t)
    m = re.search(r'(?m)^table\((.*?)^\)', t, re.S)
    table_block = m.group(1) if m else ''
    tables = sorted(set(re.findall(r'dbname="([A-Za-z0-9_]+)\.', t)))
    out = {
      'lib': lib,
      'name': os.path.basename(path)[:-4],
      'bytes': os.path.getsize(path),
      'sql_bytes': len(sql),
      'tbl_cols': tbl_cols,
      'sql_cols': s.count(',') + 1 if s else 0,
      'tables_ref': len(tables),
      'tables': '|'.join(tables)[:200],
      'select_star': bool(re.search(r'\bSELECT\s+(TOP\s+\d+\s+)?\*', su)),
      'distinct': 'DISTINCT' in su,
      'group_by': 'GROUP BY' in su,
      'having': 'HAVING' in su,
      'union': 'UNION' in su,
      'joins': len(re.findall(r'\bJOIN\b', su)),
      'subqueries': len(re.findall(r'\(\s*SELECT\b', su)),
      'case_exprs': len(re.findall(r'\bCASE\b', su)),
      'sum_exprs': len(re.findall(r'\bSUM\s*\(', su)),
      'convert_calls': len(re.findall(r'\bCONVERT\s*\(', su)),
      'date_pred': bool(re.search(r'(SDATE|EDATE|DATE|BETWEEN\s+:|\bBETWEEN\b)', su)),
      'order_by': 'ORDER BY' in su,
      'top_n': bool(re.search(r'\bSELECT\s+TOP\b', su)),
      'sql_len': len(s),
      'sort_clause': len(re.findall(r'(?m)^\s*sort=', t)),
      'filter_clause': len(re.findall(r'(?m)^\s*filter=', t)),
      'args': len(re.findall(r'(?m)^\s*arguments=', t)),
      'compute_syntax': len(re.findall(r'compute\(name=', t)),
      'bitmap_ctrl': len(re.findall(r'bitmap\(', t)),
      'crosstab': ('crosstab(' in t.lower()) or ('crosstab_reportdata' in t.lower()),
      'nested_report': len(re.findall(r'report\(name=', t)),
      'in_subquery': len(re.findall(r'\bIN\s*\(\s*SELECT\b', su)),
      'temp_table': bool(re.search(r'#\w+', s)),
      'nolock': 'NOLOCK' in su,
      'top_n': bool(re.search(r'\bSELECT\s+TOP\b', su)),
      'summary_h': bands['summary'],
      'detail_h': bands['detail'],
      'header_h': bands['header'],
      'group_levels': bands['group_levels'],
      'retrieve_as_needed': 'Retrieve.As.Needed' in t or 'retrieve.as.needed' in t.lower(),
      'rows_setting': (re.search(r'rows=(\d+)', t).group(1) if re.search(r'(?m)^\s*rows=', t) else ''),
    }
    out.update(lays)
    out['ctrl_total'] = sum(lays[k] for k in ('text_ctrl','col_ctrl','compute_ctrl','picture_ctrl','line_ctrl','rect_ctrl','report_ctrl','graph_ctrl'))
    return out

rows=[]
for lib in sorted(os.listdir(ROOT)):
    d=os.path.join(ROOT,lib)
    if not os.path.isdir(d): continue
    for fn in os.listdir(d):
        if fn.lower().endswith('.srd'):
            try:
                rows.append(parse_file(os.path.join(d,fn), lib))
            except Exception as e:
                print('ERR',lib,fn,e, file=sys.stderr)

with open(os.path.join(OUT,'srd_metrics.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

print('files',len(rows))
print('report-lib files',sum(1 for r in rows if r['lib'] in REPORT_LIBS))
print('with SQL',sum(1 for r in rows if r['sql_len']>0))
print('SELECT *',sum(1 for r in rows if r['select_star']))
print('DISTINCT',sum(1 for r in rows if r['distinct']))
print('GROUP BY',sum(1 for r in rows if r['group_by']))
print('UNION',sum(1 for r in rows if r['union']))
print('subqueries>0',sum(1 for r in rows if r['subqueries']>0))
print('nested report ctrl',sum(1 for r in rows if r['report_ctrl']>0))
print('images',sum(1 for r in rows if r['picture_ctrl']>0))
print('sort on client',sum(1 for r in rows if r['sort_clause']>0))
print('filter on client',sum(1 for r in rows if r['filter_clause']>0))
print('compute ctrl>0',sum(1 for r in rows if r['compute_ctrl']>0))
print('summary band>0',sum(1 for r in rows if (r['summary_h'] or 0)>0))
print('group levels>0',sum(1 for r in rows if r['group_levels']>0))
