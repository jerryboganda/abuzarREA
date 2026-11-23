"""Apply the runtime class fixes that compensate for lost decompiler details.

Idempotent: safe to run after any class rebuild.  Writes both the served
`web/public/data/classes` and the built `web/dist/data/classes` copies.
"""
import json
from pathlib import Path

ROOT = Path(r"C:\Projects\Abuzar\rebuild\web")
PUB = ROOT / "public" / "data" / "classes"
DIST = ROOT / "dist" / "data" / "classes"


def load(name):
    return json.loads((PUB / name).read_text(encoding="utf-8"))


def save(name, data):
    text = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
    (PUB / name).write_text(text, encoding="utf-8")
    (DIST / name).write_text(text, encoding="utf-8")


def sid(n):
    return {"k": "id", "n": n}


def mem(o, n):
    return {"k": "mem", "o": o, "n": n}


def sv(v):
    return {"k": "str", "v": v}


def num(v):
    return {"k": "num", "v": v, "dec": False}


def call(o, n, a):
    return {"k": "call", "o": o, "n": n, "a": a}


def expr(e):
    return {"k": "expr", "e": e}


# ---------------------------------------------------------------- w_multi_entry
wm = load("w_multi_entry.json")
body = wm["routines"]["dw_itemslist"]["clicked"][0]["body"]
if not any(n.get("k") == "expr" and "ll_rowmain" in json.dumps(n) and '"stock"' in json.dumps(n) for n in body):
    parent3 = mem(mem(mem(sid("parent"), "parent"), "parent"), "id_detail")
    list3 = mem(mem(mem(sid("parent"), "parent"), "parent"), "id_itemslist")
    node = expr(call(parent3, "setitem", [
        sid("ll_rowmain"), sv("stock"),
        call(list3, "getitemnumber", [sid("row"), sv("stock")])]))
    at = next((i for i, n in enumerate(body) if n.get("k") == "return"), len(body))
    body.insert(at, node)
    print("w_multi_entry: stock transfer inserted")
else:
    print("w_multi_entry: stock transfer already present")
save("w_multi_entry.json", wm)

# ---------------------------------------------------------------------- w_sale
ws = load("w_sale.json")
body = ws["routines"]["w_sale"]["wf_inititeminfo"][0]["body"]

# retflag initializer must come after the declaration (a lost decompiler initializer)
body = [n for n in body
        if not (n.get("k") == "assign" and n.get("l", {}).get("n") == "retflag" and n.get("r", {}).get("n") == "true")]
at = 0
while at < len(body) and body[at].get("k") == "decl":
    at += 1
body.insert(at, {"k": "assign", "l": sid("retflag"), "op": "=", "r": sid("true")})
print("w_sale: retflag initializer after", at, "declarations")

# stock fallback from the detail stock already set by the item list
def detail_stock():
    return call(mem(sid("this"), "id_detail"), "getitemnumber", [sid("al_row"), sv("stock")])


# drop an older fallback if present, then insert after the getitemstocktotal status check
body = [n for n in body
        if not (n.get("k") == "if" and "ld_godownstock" in json.dumps(n) and "id_itemslist" in json.dumps(n))]
if not any(n.get("k") == "if" and "ld_godownstock" in json.dumps(n) and "id_detail" in json.dumps(n) for n in body):
    idx = next((i for i, n in enumerate(body) if n.get("k") == "expr" and "getitemstocktotal" in json.dumps(n)), None)
    if idx is None:
        raise SystemExit("no getitemstocktotal node")
    pos = idx + 1
    if pos < len(body) and body[pos].get("k") == "if" and "sqlcode" in json.dumps(body[pos].get("c", {})):
        pos += 1
    body.insert(pos, {"k": "if", "c": {"k": "bin", "op": ">", "l": detail_stock(), "r": num(0)},
                       "t": [{"k": "assign", "l": sid("ld_godownstock"), "op": "=", "r": detail_stock()}], "ei": []})
    print("w_sale: stock fallback inserted", pos)
else:
    print("w_sale: stock fallback already present")


def status_col(c):
    """column name of getitemstatus(row, col, buffer) inside a condition"""
    try:
        if c.get("k") == "call" and c.get("n") == "getitemstatus":
            a = c.get("a") or []
            if len(a) > 1 and a[1].get("k") == "str":
                return a[1].get("v")
        if c.get("k") == "bin":
            return status_col(c.get("l", {}))
    except Exception:
        pass
    return None


def normalize_status_or(o):
    """Collapse (status=notmodified OR status=new) repeated by re-runs."""
    if isinstance(o, dict):
        if o.get("k") == "bin" and o.get("op") == "or":
            lcol = status_col(o.get("l", {}))
            rcol = status_col(o.get("r", {}))
            s = json.dumps(o)
            if lcol and lcol == rcol and "notmodified!" in s and "new!" in s:
                # find the getitemstatus call in the left subtree
                def find_call(x):
                    if isinstance(x, dict):
                        if x.get("k") == "call" and x.get("n") == "getitemstatus" and x.get("a") and x["a"][1].get("v") == lcol:
                            return x
                        for v in x.values():
                            r = find_call(v)
                            if r:
                                return r
                    elif isinstance(x, list):
                        for v in x:
                            r = find_call(v)
                            if r:
                                return r
                    return None
                call = find_call(o.get("l"))
                if call:
                    c1 = json.loads(json.dumps(call))
                    c2 = json.loads(json.dumps(call))
                    return {"k": "bin", "op": "or",
                            "l": {"k": "bin", "op": "=", "l": c1, "r": {"k": "enum", "v": "notmodified!"}},
                            "r": {"k": "bin", "op": "=", "l": c2, "r": {"k": "enum", "v": "new!"}}}
        return {k: normalize_status_or(v) for k, v in o.items()}
    if isinstance(o, list):
        return [normalize_status_or(v) for v in o]
    return o
def widen(status_cols):
    changed = 0

    def walk(o):
        nonlocal changed
        if isinstance(o, dict):
            if o.get("k") == "bin" and o.get("op") == "=" and o.get("r", {}).get("v") == "notmodified!":
                col = status_col(o.get("l", {}))
                if col in status_cols:
                    changed += 1
                    left = o["l"]
                    return {"k": "bin", "op": "or",
                            "l": {"k": "bin", "op": "=", "l": left, "r": {"k": "enum", "v": "notmodified!"}},
                            "r": {"k": "bin", "op": "=", "l": json.loads(json.dumps(left)), "r": {"k": "enum", "v": "new!"}}}
            return {k: walk(v) for k, v in o.items()}
        if isinstance(o, list):
            return [walk(v) for v in o]
        return o

    return walk(body), changed


body, changed = widen({"saleprice", "discperc"})
body = normalize_status_or(body)
print("w_sale: default gates widened", changed, "nodes (normalized)")

ws["routines"]["w_sale"]["wf_inititeminfo"][0]["body"] = body

# Enter in the sale detail refreshes the footer (original: itemfocuschanged)
ev = ws["routines"].get("dw_itemsdetail", {}).get("ue_enterkey")
if ev:
    eb = ev[0]["body"]
    if not any("wf_grandtotal" in json.dumps(n) for n in eb):
        at = 0
        while at < len(eb) and eb[at].get("k") == "decl":
            at += 1
        eb.insert(at, expr(call(None, "wf_grandtotal", [])))
        print("w_sale: ue_enterkey refreshes total")
    else:
        print("w_sale: ue_enterkey already refreshes total")
save("w_sale.json", ws)

# ---------------------------------------------------------------- f_validatedw
fv = load("f_validatedw.json")
fb = fv["routines"]["f_validatedw"]["f_validatedw"][0]["body"]
find_call = next((n["c"]["l"] for n in fb
                  if n.get("k") == "if" and "findrequired" in json.dumps(n.get("c", {}))), None)
third = next((n for n in fb
              if n.get("k") == "if" and "ll_row" in json.dumps(n.get("c", {}))
              and "findrequired" not in json.dumps(n.get("c", {}))), None)
if find_call and third:
    third["c"] = {"k": "bin", "op": "=", "l": json.loads(json.dumps(find_call)), "r": num(1)}
    print("f_validatedw: message gated on FindRequired=1")
else:
    print("f_validatedw: pattern not found")
save("f_validatedw.json", fv)

# ---------------------------------------------------------------- verify markers
print("verification:")
for name in ("w_sale.json", "w_multi_entry.json", "f_validatedw.json"):
    d = json.loads((PUB / name).read_text(encoding="utf-8"))
    if name == "w_sale.json":
        b = d["routines"]["w_sale"]["wf_inititeminfo"][0]["body"]
        print(" retflag:", sum(1 for n in b if n.get("k") == "assign" and n.get("l", {}).get("n") == "retflag"))
        print(" gates:", json.dumps(b,separators=(",",":")).count('"v":"new!"'))
    if name == "w_multi_entry.json":
        print(" stock transfer:", "ll_rowmain" in json.dumps(d["routines"]["dw_itemslist"]["clicked"]) and '"stock"' in json.dumps(d["routines"]["dw_itemslist"]["clicked"]))
    if name == "f_validatedw.json":
        print(" gated:", json.dumps(d["routines"]["f_validatedw"]["f_validatedw"][0]["body"][8]["c"]).count("findrequired"))
