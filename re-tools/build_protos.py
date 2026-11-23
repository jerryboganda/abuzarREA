"""Collect the prototype tables (index -> name, argc, return type, event flag) and the ancestor of every exported class.
Used to name calls like `w_multi_entry.func_11(...)`.   usage: python -I build_protos.py <pcode export root> <out json>"""
import sys, os, json, glob, struct


def rec_info(prec):
    if not prec:
        return None, None
    b = bytes.fromhex(prec)
    return b[0x1e], struct.unpack_from('<H', b, 0x1c)[0]


def main(root, out):
    protos, anc = {}, {}

    def walk(node, lib):
        name = node['name']
        anc[name] = node.get('ancestor')
        t = protos.setdefault(name, {})
        for r in node['routines']:
            argc, ret = rec_info(r.get('prec'))
            t[str(r['proto'])] = [r['name'], r['event'], argc, ret, lib]
        for d in node.get('declared_only', []):
            argc, ret = rec_info(d.get('prec'))
            t.setdefault(str(d['proto']), [d['name'], d['event'], argc, ret, lib])
        for c in node['controls']:
            walk(c, lib)

    for f in glob.glob(os.path.join(root, '*', '*', '*.json')):
        lib = os.path.normpath(f).split(os.sep)[-3]
        walk(json.load(open(f, encoding='utf-8')), lib)
    json.dump({'protos': protos, 'ancestor': anc}, open(out, 'w', encoding='utf-8'), ensure_ascii=False)
    idx = {}
    for f in glob.glob(os.path.join(root, '*', '*', '*.json')):
        idx.setdefault(os.path.splitext(os.path.basename(f))[0], os.path.relpath(f, root).replace(os.sep, '/'))
    json.dump(idx, open(os.path.join(os.path.dirname(out), 'objindex.json'), 'w'))
    print(len(protos), 'classes')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
