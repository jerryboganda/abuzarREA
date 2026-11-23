"""Reduce the inherited controls of an object export to what the descendant changed.

usage: python -I diff_inherited.py <objects2 root (obj_export with inherited nodes)> <out root>

obj_export lists, besides the controls an object declares itself, every inherited control with the property values the
descendant's class table holds for it.  The table repeats all inherited values, so a descendant that merely inherits a
control would repeat it unchanged.  Here each inherited node is compared with the same control of the direct ancestor
object: only the fields whose value differs are kept; nodes without any difference (and without changed children) are dropped.
The result is directly usable: a runtime that builds a window from the ancestor chain applies these overrides on top.
"""
import sys, os, json, glob, copy


def load_all(root):
    objs = {}
    for f in glob.glob(os.path.join(root, '*', '*', '*.json')):
        try:
            d = json.load(open(f, encoding='utf-8'))
        except Exception:
            continue
        if 'name' in d:
            objs[d['name'].lower()] = (f, d)
    return objs


def find(tree, name):
    for c in tree.get('controls', []):
        if (c.get('field') or c['name']).lower() == name:
            return c
    return None


def field_map(node):
    return {f['name']: f for f in node.get('fields', [])}


# properties that are handles of the running object, not settings (`object` of a DataWindow control is the proxy of its expressions)
JUNK = {'object'}


def reduce_node(node, anc):
    """returns the reduced copy of `node`, or None when nothing is left"""
    out = {k: v for k, v in node.items() if k not in ('fields', 'controls')}
    am = field_map(anc) if anc else {}
    if node.get('inherited') and anc is not None:
        # a property the ancestor's node does not list has its zero default there: an explicit zero / false of the descendant is a change only against a listed, different value
        # (the export keeps the zeros of inherited nodes since 2026-11-03: `visible = false` of the date fields of w_arg_group)
        # (a zero position or size is not an override: the detail grids of w_sale hold x = 0 while the original draws them at the x of the ancestor; only the booleans `visible` / `enabled` / `border`
        # of an inherited node are real when zero - w_arg_group hides its date fields that way)
        zero = lambda f: f['value'] in (0, False, None, '', 0.0) and f.get('attr') in ('0xbc', '0xba', '0xbe') and f['name'] not in ('visible', 'enabled', 'border')
        out['fields'] = [f for f in node['fields'] if not zero(f) and ((f['name'] in am and am[f['name']]['value'] != f['value']) or f['name'] not in am)]
    elif node.get('inherited'):
        # no ancestor node to compare with (the controls of a user object placed in a window): zero defaults stay out, but the properties whose default is true keep their zero
        out['fields'] = [f for f in node['fields'] if f.get('attr') not in ('0xbc', '0xba', '0xbe') or f['value'] not in (0, False, None, '', 0.0) or f['name'] in ('visible', 'enabled', 'border')]
    else:
        out['fields'] = node.get('fields', [])
    out['controls'] = []
    for c in node.get('controls', []):
        key = (c.get('field') or c['name']).lower()
        r = reduce_node(c, find(anc, key) if anc else None)
        if r is not None:
            out['controls'].append(r)
    out['fields'] = [f for f in out['fields'] if f['name'] not in JUNK]
    if node.get('inherited'):
        if not out['fields'] and not out['controls']:
            return None
        out['inherited'] = True
    return out


def main(src, dst):
    objs = load_all(src)
    n_in = n_kept = 0
    for name, (f, d) in objs.items():
        anc_name = (d.get('ancestor') or '').lower()
        anc = objs.get(anc_name, (None, None))[1]
        res = {k: v for k, v in d.items() if k != 'controls'}
        # the class table of the object itself repeats every property: zero defaults stay out (the export keeps them since 2026-11-03), except the ones whose default is true
        # (instance variables - attribute 0xcc - are declarations: they stay whatever their value, a structure or object variable has none)
        res['fields'] = [f for f in d.get('fields', []) if f.get('attr') not in ('0xbc', '0xba', '0xbe') or f['value'] not in (0, False, None, '', 0.0) or f['name'] in ('visible', 'enabled', 'border')]
        res['fields'] = [f for f in res['fields'] if f['name'] not in JUNK]
        res['controls'] = []
        for c in d.get('controls', []):
            n_in += 1
            key = (c.get('field') or c['name']).lower()
            r = reduce_node(c, find(anc, key) if anc else None)
            if r is not None:
                res['controls'].append(r)
                n_kept += 1
        rel = os.path.relpath(f, src)
        out = os.path.join(dst, rel)
        os.makedirs(os.path.dirname(out), exist_ok=True)
        json.dump(res, open(out, 'w', encoding='utf-8', newline='\n'), separators=(',', ':'), ensure_ascii=False)
    print('objects', len(objs), 'top-level controls in', n_in, 'kept', n_kept)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
