"""External (DLL / OLE / web-service) declarations found in the compiled libraries.
usage: python -I ext_decls.py <Application dir> <out json>"""
import sys, os, re, json, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pbd_lib as P

DLL = re.compile(rb'(?:[A-Za-z0-9_\-\.:]\x00){2,}?\.\x00(?:[Dd]\x00[Ll]\x00[Ll]\x00|[Oo]\x00[Cc]\x00[Xx]\x00|[Ee]\x00[Xx]\x00[Ee]\x00|[Dd]\x00[Rr]\x00[Vv]\x00)')
STR = re.compile(rb'(?:[\x20-\x7e]\x00){3,}')


def main(app, out):
    res = collections.defaultdict(lambda: collections.defaultdict(set))
    for pbd in sorted(glob.glob(os.path.join(app, '*.pbd'))):
        lib = os.path.basename(pbd)[:-4]
        d = open(pbd, 'rb').read()
        for e in P.entries(d):
            if not e['name'].lower().endswith(('.win', '.udo', '.app', '.men', '.fun')):
                continue
            raw = P.read_obj(d, e)
            strs = [(m.start(), m.group().decode('utf-16le')) for m in STR.finditer(raw)]
            for i, (o, s) in enumerate(strs):
                if re.search(r'\.(dll|ocx|exe|drv)$', s, re.I):
                    # the declaration lists the function names just before the library name in the same table
                    near = [t for oo, t in strs[max(0, i - 6):i] if re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', t)]
                    res[s.lower()][e['name'].rsplit('.', 1)[0]].update(near)
    out_d = {dll: {obj: sorted(fn) for obj, fn in objs.items()} for dll, objs in sorted(res.items())}
    json.dump(out_d, open(out, 'w', encoding='utf-8'), indent=1)
    print(len(out_d), 'libraries referenced')
    for k, v in list(out_d.items())[:40]:
        print(k, '->', len(v), 'objects', list(v)[:3])


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
