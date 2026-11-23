import json
p = r'C:\Projects\Abuzar\recovered\objects\multientrygroups\window\w_users.json'
j = json.load(open(p, encoding='utf-8-sig'))
print('ancestor', j.get('ancestor'))

def walk(o, d=0):
    for c in o.get('controls') or []:
        do = None
        for f in c.get('fields') or []:
            if f.get('name') == 'dataobject':
                do = f.get('value')
        if do or (c.get('name') or '').startswith('id_'):
            print('  ' * d + "%s anc=%s do=%s" % (c.get('name'), c.get('ancestor'), do))
        walk(c, d + 1)

walk(j)
print('--- vars ---')
for f in j.get('fields') or []:
    n = f.get('name') or ''
    if n.startswith('id_') or n == 'menuname':
        print(n, '=', f.get('value'))
