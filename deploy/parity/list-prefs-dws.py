import json, os
p = r'C:\Projects\Abuzar\recovered\objects\preferences\window\w_preferences.json'
j = json.load(open(p, encoding='utf-8-sig'))

def walk(o, d=0):
    for c in o.get('controls') or []:
        do = None
        for f in c.get('fields') or []:
            if f.get('name') == 'dataobject': do = f.get('value')
        if do or (c.get('name') or '').startswith('id_'):
            print('  ' * d + f"{c.get('name')} anc={c.get('ancestor')} do={do}")
        walk(c, d + 1)
walk(j)
print('--- instance vars ---')
for f in j.get('fields') or []:
    n = f.get('name') or ''
    if n.startswith('id_') or n == 'menuname': print(n, '=', f.get('value'))
