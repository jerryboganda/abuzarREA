"""Property overrides for the "All ticked by default" fix of 2026-11-23 (deploy/FIX-LOG-2026-11-23.md), in source form.

usage: python -I improve_all_ticked.py <raw object export of the vendor libraries (recovered/objects6_raw)>
                                       <raw object export of the patched libraries (recovered/patched/objects)>
                                       <reduced object export the generator reads (recovered/objects)>
                                       <out: improve/properties.json>

The patch set `checked` of the `cbx_all` check box in the compiled property table of every window it covers.  Source works
by inheritance: a window says `checked = ...` only where it differs from the window it inherits the box from.  So the wanted
end state (patched windows ticked, every other window as the vendor built it) is turned into the explicit values that give
exactly that state: a window gets one where its wanted value differs from what it would inherit, or where it already has one.
"""
import sys, os, json, glob

sys.stdout.reconfigure(encoding='utf-8')


def box(d):
    """(value of cbx_all.checked, inherited flag) of a window export, or None if the window has no such box"""
    for c in d.get('controls', []) or []:
        if (c.get('name') or c.get('field') or '').lower() == 'cbx_all':
            v = next((f.get('value') for f in c.get('fields', []) if f.get('name') == 'checked'), None)
            return bool(v), bool(c.get('inherited')), any(f.get('name') == 'checked' for f in c.get('fields', []))
    return None


def load(root):
    out = {}
    for f in glob.glob(os.path.join(root, '*', 'window', '*.json')):
        text = open(f, encoding='utf-8').read()
        if 'cbx_all' not in text:
            d = json.loads(text)
            out[d['name'].lower()] = (d.get('ancestor') or '').lower(), None
            continue
        d = json.loads(text)
        out[d['name'].lower()] = (d.get('ancestor') or '').lower(), box(d)
    return out


def main(raw, patched, reduced, out):
    vendor = load(raw)
    fixed = load(patched)
    explicit = {k: v[1][2] for k, v in load(reduced).items() if v[1]}          # windows whose source already says `checked`
    wanted = {}
    for name, (anc, b) in vendor.items():
        if b is None:
            continue
        wanted[name] = b[0]
        if name in fixed and fixed[name][1] is not None:
            wanted[name] = fixed[name][1][0]
    ticked = sorted(n for n in wanted if wanted[n] and not vendor[n][1][0])
    res = []
    for name in sorted(wanted):
        anc, b = vendor[name]
        inherits = anc in wanted          # two controls of one name cannot exist in a window and its ancestor
        default = wanted[anc] if inherits else False
        if wanted[name] != default or explicit.get(name):
            res.append({'object': name, 'control': 'cbx_all', 'property': 'checked', 'type': 'boolean', 'value': wanted[name],
                        'inherited': inherits})
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
    json.dump({'why': 'All ticked by default in the report argument windows (owner request, 2026-11-23)',
               'windows_ticked': ticked, 'overrides': res}, open(out, 'w', encoding='utf-8'), indent=1)
    print('windows with the box', len(wanted), '| ticked by the fix', len(ticked), '| explicit values written', len(res),
          '| of them true', sum(r['value'] for r in res), 'false', sum(not r['value'] for r in res))


if __name__ == '__main__':
    main(*sys.argv[1:5])
