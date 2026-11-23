import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
r=[x for x in rows if x["name"]=="d_customerledger_itemwise"][0]
s=r["sql"]["sql"]
parts=re.split(r"\bUNION ALL\b",s,flags=re.I)
print("legs",len(parts))
for i,p in enumerate(parts[:6]):
    # show FROM..WHERE area
    print("-"*90); print("LEG",i,"len",len(p)); print(p[:200].replace("\n"," ")); print("...")
    m=re.search(r"\bFROM\b(.{0,400})",p,re.I|re.S)
    print("FROM:",m.group(1).replace("\n"," ") if m else "none")
print("refs to C.",len(re.findall(r"\bC\.",s)))
