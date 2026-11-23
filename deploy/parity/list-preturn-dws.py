import json, os
p = r'C:\Projects\Abuzar\recovered\objects\prcomponents\window\w_purchasereturn.json'
j = json.load(open(p, encoding='utf-8-sig'))
print('ancestor', j.get('ancestor'))
def walk(o, d=0):
    for c in o.get('controls') or []:
        do = None
        for f in c.get('fields') or []:
            if f.get('name') == 'dataobject': do = f.get('value')
        if do or (c.get('name') or '').startswith('id_'):
            print('  ' * d + f"{c.get('name')} anc={c.get('ancestor')} do={do}")
        walk(c, d + 1)
walk(j)
print('--- vars ---')
for f in j.get('fields') or []:
    n = f.get('name') or ''
    if n.startswith('id_') or n in ('menuname', 'ib_itemvalidated'): print(n, '=', f.get('value'))
