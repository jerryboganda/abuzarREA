import os, re, glob, collections, json

ROOT = r"C:\Projects\Abuzar\recovered\datawindows"
stat = collections.Counter()
rows = []

def count(pat, s, flags=0):
    return len(re.findall(pat, s, flags))

for path in glob.glob(os.path.join(ROOT, "**", "*.srd"), recursive=True):
    try:
        txt = open(path, encoding="utf-8", errors="replace").read()
    except Exception:
        continue
    low = txt.lower()
    lib = os.path.basename(os.path.dirname(path))
    name = os.path.basename(path)[:-4]
    pres = "unknown"
    m = re.search(r"presentation\s*\(([^)]*)\)", low)
    if m:
        sm = re.search(r"style\s*=\s*(\w+)", m.group(1))
        if sm: pres = sm.group(1)
    rec = {
        "lib": lib, "name": name, "pres": pres, "bytes": len(txt),
        "cols": count(r"\n\s*column\s*\(", low),
        "compute": count(r"\n\s*compute\s*\(", low),
        "nested": count(r"\n\s*report\s*\(", low),
        "graph": count(r"\n\s*graph\s*\(", low),
        "bitmap": count(r"\n\s*bitmap\s*\(", low),
        "richtext": count(r"\n\s*richtext\s*\(", low),
        "html": count(r"\n\s*html\s*\(", low),
        "dddw": count(r"dddw\s*\(", low),
        "editmask": count(r"editmask\s*\(", low),
        "sum": count(r"sum\s*\(", low),
        "avg": count(r"avg\s*\(", low),
        "count_": count(r"count\s*\(", low),
        "gradient": count(r"gradient\.color\s*=\s*\"?(\d+)\"?", low),
        "group": count(r"\n\s*group\s*\(", low),
        "crosstab": count(r"crosstab", low),
        "retrieve": count(r"\bretrieve\s*=", low),
        "filter": count(r"\bfilter\s*=", low),
        "sort": count(r"\bsort\s*=", low),
        "arguments": count(r"\n\s*arguments\s*=\s*\(", low),
        "tabseq": count(r"tabsequence", low),
        "hidden_cols": count(r"column\([^)]*visible\s*=\s*\"0\"", low),
        "picture_bg": count(r"background\.mode\s*=\s*\"?[2-9]", low),
        "transparency": count(r"transparency\s*=\s*\"?[1-9]", low),
        "sql_join": count(r"\bjoin\b", low),
        "union": count(r"\bunion\b", low),
        "subquery": count(r"\(\s*select\b", low),
    }
    rows.append(rec)
    stat["total"] += 1
    stat["pres:" + pres] += 1
    if rec["nested"]: stat["has_nested"] += 1
    if rec["graph"]: stat["has_graph"] += 1
    if rec["bitmap"]: stat["has_bitmap"] += 1
    if rec["richtext"]: stat["has_richtext"] += 1
    if rec["html"]: stat["has_html"] += 1
    if rec["dddw"]: stat["has_dddw"] += 1
    if rec["compute"]: stat["has_compute"] += 1
    if rec["group"]: stat["has_group"] += 1
    if rec["filter"]: stat["has_filter"] += 1
    if rec["sort"]: stat["has_sort"] += 1
    if rec["union"]: stat["has_union"] += 1

print(dict(sorted(stat.items(), key=lambda kv: -kv[1])))
print("\nPres counts:", {k: v for k, v in stat.items() if k.startswith("pres:")})
print("\nTop 25 by columns:")
for r in sorted(rows, key=lambda x: -x["cols"])[:25]:
    print(f"{r['name'][:38]:38} {r['pres']:10} cols={r['cols']:>4} comp={r['compute']:>3} nest={r['nested']:>2} grp={r['group']:>2} bmp={r['bitmap']:>2} dd={r['dddw']:>2} fld={r['filter']} sort={r['sort']} bytes={r['bytes']}")
print("\nTop 20 by computed fields:")
for r in sorted(rows, key=lambda x: -x["compute"])[:20]:
    print(f"{r['name'][:38]:38} {r['pres']:10} cols={r['cols']:>4} comp={r['compute']:>3} sum={r['sum']:>3} nest={r['nested']:>2} grp={r['group']}")
json.dump(rows, open(r"C:\Projects\Abuzar\deploy\analysis\ui-hotspots\dw.json", "w"))
