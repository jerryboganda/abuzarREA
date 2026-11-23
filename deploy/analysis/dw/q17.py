import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
r=[x for x in rows if x["name"]=="d_cashflow"][0]
s=r["sql"]["sql"]
parts=[];buf=[];d=0;i=0
while i<len(s):
    c=s[i]
    if c=="(": d+=1
    elif c==")": d=max(0,d-1)
    if d==0:
        m=re.match(r"\bUNION\b(\s+ALL\b)?",s[i:],re.I)
        if m: parts.append("".join(buf));buf=[];i+=m.end();continue
    buf.append(c);i+=1
parts.append("".join(buf))
for j,p in enumerate(parts):
    label=re.search(r"remarks\s*=\s*'([^']{0,40})",p)
    print(j,len(p),(label.group(1) if label else p[:60]).replace("\n"," "))
