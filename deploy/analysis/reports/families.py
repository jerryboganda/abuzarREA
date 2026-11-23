import json, collections, re
calls=json.load(open(r"C:\Projects\Abuzar\deploy\analysis\reports\report_calls.json",encoding='utf-8'))
fam=collections.Counter(); byfam=collections.defaultdict(set)
for lib,fn,line,title,dw in calls:
    t=title.split()[0] if title.split() else 'Other'
    t=re.sub(r'[^A-Za-z]','',t).title()
    fam[t]+=1; byfam[t].add(dw)
print('total',len(calls))
for k,v in fam.most_common(30): print(f"{k:14} {v:4}  unique {len(byfam[k])}")
print('\nTop-level families:', ', '.join(f"{k}({v})" for k,v in fam.most_common(15)))
# count DW name prefixes
pref=collections.Counter()
for c in calls:
    dw=c[4]
    m=re.match(r'd_([a-z0-9]+)', dw)
    if m: pref[m.group(1)[:12]]+=1
print('\nDW prefixes:')
for k,v in pref.most_common(20): print(k,v)
