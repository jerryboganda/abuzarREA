import os, re, collections, json
ROOT=r"C:\Projects\Abuzar\recovered\scripts"
OUT=r"C:\Projects\Abuzar\deploy\analysis\reports"
pat=re.compile(r'mf_displayreport\(\s*("(?:[^"~]|~.)*"|[^,]+)\s*,\s*("(?:[^"~]|~.)*"|[^\)]+)\s*\)')
calls=[]
for dp,dn,fn in os.walk(ROOT):
    for f in fn:
        if not f.endswith('.pbs'): continue
        p=os.path.join(dp,f)
        t=open(p,encoding='utf-8',errors='replace').read()
        for m in pat.finditer(t):
            title=m.group(1).strip().strip('"')
            dw=m.group(2).strip().strip('"')
            line=t[:m.start()].count('\n')+1
            calls.append((os.path.basename(dp),f,line,title,dw))
print('total calls',len(calls),'unique dw',len(set(c[4] for c in calls)))
cnt=collections.Counter(c[4] for c in calls)
print('most referenced:')
for k,v in cnt.most_common(25): print(v,k)
json.dump(calls,open(os.path.join(OUT,'report_calls.json'),'w',encoding='utf-8'),indent=0)
# also dataobject assignments in reportviewer
spat=re.compile(r'dataobject\s*=\s*"([^"]+)"')
dwset=set()
for dp,dn,fn in os.walk(os.path.join(ROOT,'reportviewer')):
    for f in fn:
        t=open(os.path.join(dp,f),encoding='utf-8',errors='replace').read()
        dwset.update(spat.findall(t))
print('DW assigned in reportviewer:',len(dwset))
json.dump(sorted(dwset),open(os.path.join(OUT,'reportviewer_dws.json'),'w'),indent=0)
