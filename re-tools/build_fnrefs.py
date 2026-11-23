"""Attach `fnrefs` (prototype-record index -> name) to every class node of the p-code export, from the unlinked tables in
the .pbd files (see raw_protos.py).  Checks the runtime's own routines against the table (same name at the same index).
usage: python -I build_fnrefs.py <Application dir> <pcode root>"""
import sys, os, glob, json, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import raw_protos as R


def nodes(node):
    yield node
    for c in node['controls']:
        yield from nodes(c)


def global_signatures(root):
    sig = {}
    for f in glob.glob(os.path.join(root, '*', 'function', '*.json')):
        d = json.load(open(f, encoding='utf-8'))
        for r in d['routines']:
            if r.get('prec'):
                sig.setdefault(d['name'].lower(), set()).add(bytes.fromhex(r['prec'])[0x1e])
    return sig


def call_sites(n):
    """(id, argc) of every linked non-system function call in the class's routines"""
    out = []
    for r in n['routines']:
        ins = r['instrs']
        for k, (w, op, a) in enumerate(ins):
            if op == 'PUSH_FUNC_CLASS' and a[1] != 16592 and k + 1 < len(ins) and ins[k + 1][1] == 'CLASS_CALL':
                out.append((a[0], ins[k + 1][2][1]))
    return out


def fits(table, sites, sig):
    for i, argc in sites:
        if i >= len(table) or table[i].startswith('+'):
            return False
        s = sig.get(table[i].lower())
        if s and argc not in s:
            return False
    return True


def main(app, root):
    sig = global_signatures(root)
    stat = collections.Counter()
    bad = []
    for pbd in sorted(glob.glob(os.path.join(app, '*.pbd'))):
        lib = os.path.basename(pbd)[:-4]
        raw = R.pbd_tables(pbd)
        byname = collections.defaultdict(list)
        PREF = ('win', 'men', 'udo', 'fun', 'apl', 'app', 'str')                 # compiled class images first, '.bin' blobs last
        for k, v in sorted(raw.items(), key=lambda kv: PREF.index(kv[0].rsplit('.', 1)[-1].lower()) if kv[0].rsplit('.', 1)[-1].lower() in PREF else 9):
            if k.rsplit('.', 1)[-1].lower() in PREF:
                byname[k.rsplit('.', 1)[0].lower()].append(v)
        for f in glob.glob(os.path.join(root, lib, '*', '*.json')):
            obj = json.load(open(f, encoding='utf-8'))
            cands = byname.get(obj['name'].lower())
            if not cands:
                stat['object without raw image'] += 1
                continue
            tabs = cands[0]
            ns = list(nodes(obj))
            ti = 0
            changed = False
            for n in ns:
                want = [r['name'].lower() for r in sorted(n['routines'] + [dict(x, name=x['name']) for x in n.get('declared_only', [])],
                                                          key=lambda r: r['proto'])]
                if not want:
                    stat['class without routines'] += 1
                    continue
                # the next table whose entries contain the runtime routines in order, and no event the runtime lacks
                sites = call_sites(n)
                found = None
                for j in range(ti, min(ti + 12, len(tabs))):
                    t = [x.lstrip('+').lower() for x in tabs[j]]
                    if set(want) <= set(t) and fits(tabs[j], sites, sig):
                        found = j
                        break
                if found is None and all(w == '' for w in want) and ti < len(tabs) and len(tabs[ti]) >= len(want):
                    found = ti                                      # routines exported without names: take the next table
                if found is None:                                   # menu items: `clicked` is the base event, not in their table
                    w2 = set(want) - {'clicked'}
                    for j in range(ti, min(ti + 12, len(tabs))):
                        if set(x.lstrip('+').lower() for x in tabs[j]) >= w2 and len(tabs[j]) <= len(w2) + 1:
                            found = j
                            break
                if found is None and sites:
                    # its table was taken by an earlier class with the same events and no calls of its own (found on
                    # w_item_form.dw_find): any table of the object that holds the routines and fits every call site
                    # will do, if all such tables name the called functions alike
                    cands = [t for t in tabs if set(want) <= set(x.lstrip('+').lower() for x in t) and fits(t, sites, sig)]
                    names = {tuple(t[i] for i, _ in sites) for t in cands}
                    if len(names) == 1:
                        n['fnrefs'] = {str(i): nm.lstrip('+') for i, nm in enumerate(cands[0])}
                        stat['class matched late'] += 1
                        changed = True
                        continue
                if found is None:
                    stat['class unmatched'] += 1
                    bad.append((lib, obj['name'], n['name']))
                    continue
                ti = found + 1
                n['fnrefs'] = {str(i): nm.lstrip('+') for i, nm in enumerate(tabs[found])}
                stat['class matched'] += 1
                changed = True
            if changed:
                with open(f, 'w', encoding='utf-8', errors='replace') as fh:
                    json.dump(obj, fh, ensure_ascii=False)
    print(dict(stat))
    print(bad[:20])
    json.dump(bad, open(os.path.join(root, '_fnrefs_unmatched.json'), 'w'))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
