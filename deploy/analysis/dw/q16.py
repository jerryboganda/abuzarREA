import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
r=[x for x in rows if x["name"]=="d_customerledger_itemwise"][0]
s=r["sql"]["sql"]
parts=re.split(r"\bUNION ALL\b",s,flags=re.I)
print(parts[0])
