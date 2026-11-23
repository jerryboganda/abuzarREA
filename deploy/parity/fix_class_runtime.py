import json, shutil
from pathlib import Path

ROOT=Path(r"C:\Projects\Abuzar\rebuild\web")
PUB=ROOT/"public"/"data"/"classes"
DIST=ROOT/"dist"/"data"/"classes"

def load(name): return json.loads((PUB/name).read_text(encoding="utf-8"))
def save(name,d):
    (PUB/name).write_text(json.dumps(d,ensure_ascii=False,separators=(",",":")),encoding="utf-8")
    (DIST/name).write_text(json.dumps(d,ensure_ascii=False,separators=(",",":")),encoding="utf-8")

# ---------- w_multi_entry: list click transfers stock to the detail row ----------
wm=load("w_multi_entry.json")
body=wm["routines"]["dw_itemslist"]["clicked"][0]["body"]
def list_stock_node():
    detail=lambda: {"k":"mem","o":{"k":"mem","o":{"k":"mem","o":{"k":"id","n":"parent"},"n":"parent"},"n":"parent"},"n":"id_detail"}
    lst={"k":"mem","o":{"k":"mem","o":{"k":"mem","o":{"k":"id","n":"parent"},"n":"parent"},"n":"parent"},"n":"id_itemslist"}
    return {"k":"expr","e":{"k":"call","o":detail(),"n":"setitem","a":[
        {"k":"id","n":"ll_rowmain"},{"k":"str","v":"stock"},
        {"k":"call","o":lst,"n":"getitemnumber","a":[{"k":"id","n":"row"},{"k":"str","v":"stock"}]}]}}
if not any(n.get("k")=="expr" and '"v":"stock"' in json.dumps(n) and "ll_rowmain" in json.dumps(n) for n in body):
    at=len(body)
    for i,n in enumerate(body):
        if n.get("k")=="return": at=i; break
    body.insert(at,list_stock_node())
    print("w_multi_entry: inserted stock transfer")
else: print("w_multi_entry: stock transfer already present")
save("w_multi_entry.json",wm)

# ---------- w_sale helpers ----------
ws=load("w_sale.json")
body=ws["routines"]["w_sale"]["wf_inititeminfo"][0]["body"]

# retflag must be initialised after its declaration, never before it
for n in list(body):
    if n.get("k")=="assign" and n.get("l",{}).get("n")=="retflag" and n.get("r",{}).get("n")=="true":
        body.remove(n)
at=0
while at<len(body) and body[at].get("k")=="decl": at+=1
body.insert(at,{"k":"assign","l":{"k":"id","n":"retflag"},"op":"=","r":{"k":"id","n":"true"}})
print("w_sale: retflag initialised after",at,"declarations")

# stock fallback from the detail value already transferred by the list
detail_stock={"k":"call","o":{"k":"mem","o":{"k":"id","n":"this"},"n":"id_detail"},"n":"getitemnumber","a":[{"k":"id","n":"al_row"},{"k":"str","v":"stock"}]}
fallback={"k":"if","c":{"k":"bin","op":">","l":detail_stock,"r":{"k":"num","v":0,"dec":False}},
          "t":[{"k":"assign","l":{"k":"id","n":"ld_godownstock"},"op":"=","r":json.loads(json.dumps(detail_stock))}],"ei":[]}
# remove prior fallbacks and insert after the getitemstocktotal sqlcode check
newbody=[]
inserted=False
for i,n in enumerate(body):
    s=json.dumps(n)
    if n.get("k")=="if" and "ld_godownstock" in s and ("id_itemslist" in s or "getrow" in s):
        continue
    newbody.append(n)
    if n.get("k")=="if" and "ld_godownstock" in s and "id_itemslist" not in s:
        pass
# locate getitemstocktotal and the following sqlcode if
idx=None
for i,n in enumerate(newbody):
    if n.get("k")=="expr" and "getitemstocktotal" in json.dumps(n): idx=i; break
if idx is None: raise SystemExit("no getitemstocktotal node")
pos=idx+1
if pos<len(newbody) and newbody[pos].get("k")=="if" and "sqlcode" in json.dumps(newbody[pos].get("c",{})):
    pos+=1
newbody.insert(pos,fallback)
body=newbody
print("w_sale: stock fallback inserted at",pos)

# getitemstatus default checks: accept both NotModified! and New!
def widen_status(node,col):
    changed=0
    def walk(o):
        nonlocal changed
        if isinstance(o,dict):
            if o.get("k")=="bin" and o.get("op")=="=" and o.get("r",{}).get("v")=="notmodified!":
                s=json.dumps(o.get("l",{}))
                if "getitemstatus" in s and f'"v":"{col}"' in s:
                    left=o["l"]
                    o.clear(); o.update({"k":"bin","op":"or",
                        "l":{"k":"bin","op":"=","l":left,"r":{"k":"enum","v":"notmodified!"}},
                        "r":{"k":"bin","op":"=","l":left,"r":{"k":"enum","v":"new!"}}})
                    changed+=1
            for v in o.values(): walk(v)
        elif isinstance(o,list):
            for v in o: walk(v)
    walk(node)
    return changed
print("w_sale: saleprice gate widened",widen_status(body[108] if False else body,"saleprice"))
print("w_sale: discperc gate widened",widen_status(body,"discperc"))

# Enter in the sale detail must refresh the footer (the original does it in itemfocuschanged)
evs=ws["routines"].get("dw_itemsdetail",{}).get("ue_enterkey")
if evs:
    eb=evs[0]["body"]
    if not any("wf_grandtotal" in json.dumps(n) for n in eb):
        at=0
        while at<len(eb) and eb[at].get("k")=="decl": at+=1
        eb.insert(at,{"k":"expr","e":{"k":"call","o":None,"n":"wf_grandtotal","a":[]}})
        print("w_sale: ue_enterkey calls wf_grandtotal at",at)
    else: print("w_sale: ue_enterkey already refreshes total")
save("w_sale.json",ws)

# ---------- f_validatedw: only report a missing required value when one exists ----------
fv=load("f_validatedw.json")
fb=fv["routines"]["f_validatedw"]["f_validatedw"][0]["body"]
# second findrequired condition (the unconditional ll_row<>0 message)
find_call=None; third=None
for n in fb:
    if n.get("k")=="if" and "findrequired" in json.dumps(n.get("c",{})):
        find_call=n["c"]["l"]; break
for n in fb:
    if n.get("k")=="if" and "ll_row" in json.dumps(n.get("c",{})) and "findrequired" not in json.dumps(n.get("c",{})):
        third=n; break
if find_call and third:
    third["c"]={"k":"bin","op":"=","l":json.loads(json.dumps(find_call)),"r":{"k":"num","v":1,"dec":False}}
    print("f_validatedw: gated the message on FindRequired=1")
else: print("f_validatedw: pattern not found")
save("f_validatedw.json",fv)

print("done")
