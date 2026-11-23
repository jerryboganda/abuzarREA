import glob
import json

paths = glob.glob(r'C:\Projects\Abuzar\recovered\objects\**\w_salepromotion_form.json', recursive=True)
print(paths)
if paths:
    p = paths[0]
    j = json.load(open(p, encoding='utf-8-sig'))
    print('ancestor', j.get('ancestor'))

    def walk(o, d=0):
        for c in o.get('controls') or []:
            do = None
            for f in c.get('fields') or []:
                if f.get('name') == 'dataobject':
                    do = f.get('value')
            if do or (c.get('name') or '').startswith('id_'):
                print('  ' * d + "%s do=%s" % (c.get('name'), do))
            walk(c, d + 1)

    walk(j)
    for f in j.get('fields') or []:
        n = f.get('name') or ''
        if n.startswith('id_'):
            print(n, '=', f.get('value'))
