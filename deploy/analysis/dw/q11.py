import json,re
rows=json.load(open("dw_metrics.json",encoding="utf-8"))
for n in ["d_customerledger_itemwise","d_cashflow","d_summacc_accountledger_itemwise","d_itemstockregister_standard"]:
    r=[x for x in rows if x["name"]==n][0]; s=r["sql"]["sql"]
    print("="*110); print(n)
    # parameter contexts
    for m in re.finditer(r".{80}[:@][A-Za-z_]\w*.{60}",s):
        print("  ...",m.group(0).replace("\n"," "))
        break
    print("PARAMS:",sorted(set(re.findall(r"[:@][A-Za-z_]\w*",s))))
    print("TAIL:",s[-1500:])
