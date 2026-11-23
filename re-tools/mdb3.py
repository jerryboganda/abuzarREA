import re,sys,collections
d=open(sys.argv[1],'rb').read()
# decode only runs of printable utf16 (allow CR/LF/TAB), keep long ones
runs=[m.group().decode('utf-16le','ignore') for m in re.finditer(rb'(?:[\x09\x0a\x0d\x20-\x7e\xa0-\xff]\x00){30,}', d)]
print('runs',len(runs), sum(len(r) for r in runs))
text='\n@@RUN@@\n'.join(runs)
open('script_mdb_all.txt','w',encoding='utf-8').write(text)
ct=re.findall(r'create\s+table\s+\[?(?:dbo\]?\.\[?)?([A-Za-z_#][\w]*)', text, re.I)
c=collections.Counter(x.lower() for x in ct)
print('create table stmts',len(ct),'distinct',len(c))
print(', '.join(sorted(c)[:400]))
pr=re.findall(r'create\s+proc(?:edure)?\s+\[?(?:dbo\]?\.\[?)?([A-Za-z_][\w]*)', text, re.I)
print('procs distinct',len(set(x.lower() for x in pr)))
print(', '.join(sorted(set(x.lower() for x in pr)))[:3000])
