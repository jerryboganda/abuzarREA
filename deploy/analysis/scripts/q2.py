import json, collections, re

d = json.load(open('deploy/analysis/scripts/out/scan.json', encoding='utf-8'))

def block_summary(fname):
    bs = [b for b in d.get('blocks', []) if b['file'].endswith(fname)] if 'blocks' in d else []
    return bs

# blocks were not dumped; reparse headers from file
import os
HDR = re.compile(r'^//\s+([A-Za-z0-9_]+)\.([A-Za-z0-9_]+)\((.*?)\)\s+returns\s+(.*)$')
for f in ['abuzarapp/w_newpreferences.pbs', 'abuzarapp/w_main.pbs', 'abuzarapp/w_login1.pbs',
          'components/m_mainmenu.pbs', 'salewin/w_sale.pbs', 'purchasecomponents/w_purchase.pbs']:
    path = 'recovered/scripts/' + f
    lines = open(path, encoding='utf-8', errors='replace').read().splitlines()
    hdrs = [(i, m.group(2), m.group(1), m.group(4)) for i, l in enumerate(lines) for m in [HDR.match(l)] if m]
    print('=====', f, len(lines), 'lines', len(hdrs), 'routines')
    out = []
    for k, (i, fn, obj, ret) in enumerate(hdrs):
        end = hdrs[k+1][0] if k+1 < len(hdrs) else len(lines)
        body = lines[i:end]
        sql = sum(1 for l in body if re.match(r'^\s*SQL\s', l, re.I))
        loops = sum(1 for l in body if re.match(r'^\s*(for\s+\w+\s*=|do\s+while|do\s+until)', l, re.I))
        msgs = sum(1 for l in body if re.search(r'\bmessagebox\s*\(', l, re.I))
        concat = sum(1 for l in body if re.match(r'^\s*\w+\s*=\s*\w+\s*\+', l, re.I))
        if end-i > 40 or sql or loops or msgs:
            out.append((end-i, sql, loops, msgs, concat, i+1, fn))
    for row in sorted(out, reverse=True)[:30]:
        print('  lines=%4d sql=%3d loops=%2d msg=%2d concat=%3d @%5d %s' % row)
