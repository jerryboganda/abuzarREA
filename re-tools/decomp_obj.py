"""Decompile every routine of one exported object to PowerScript-like text.
usage: python -I decomp_obj.py <object.json> [routine-name]   (needs ../recovered/pcode_names/sysfuncs.json)"""
import sys, os, json, glob, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_lift as L
import pcode_struct as S

HERE = os.path.dirname(os.path.abspath(__file__))


class Ctx:
    def __init__(self, classfield_files):
        self.sysf = json.load(open(os.path.join(HERE, '..', 'recovered', 'pcode_names', 'sysfuncs.json'), encoding='utf-8'))
        self.classfields = {}
        self._pools = {}
        yp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'system_types.json')
        self.systypes = json.load(open(yp, encoding='utf-8')) if os.path.exists(yp) else {}
        gp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'global_types.json')
        self.gtypes = json.load(open(gp, encoding='utf-8')) if os.path.exists(gp) else {}
        sp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'shared_vars.json')
        self.shared = json.load(open(sp, encoding='utf-8')) if os.path.exists(sp) else {}
        self.root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode')
        ip = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'objindex.json')
        self.objindex = json.load(open(ip, encoding='utf-8')) if os.path.exists(ip) else {}
        self.protos, self.ancestor = {}, {}
        pf = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'protos.json')
        if os.path.exists(pf):
            pj = json.load(open(pf, encoding='utf-8'))
            self.protos, self.ancestor = pj['protos'], pj['ancestor']
        for f in classfield_files:
            self.classfields.update(json.load(open(f, encoding='utf-8')))

    def pool_of(self, name):
        """statement pool (bytes) of the object called `name` - used for statements stored in an ancestor"""
        if name not in self._pools:
            rel = self.objindex.get(name)
            pool = b''
            if rel:
                import base64
                sp = json.load(open(os.path.join(self.root, rel), encoding='utf-8')).get('sqlpool')
                pool = base64.b64decode(sp['b64']) if sp else b''
            self._pools[name] = pool
        return self._pools[name]


def local_init(l, R=None):
    """initial value of a local declared with one (`boolean lb_ok = true`): the 4-byte field after the name offset of the local record, inline for the
    integral types, the boolean (low byte) and the char (low byte = character code); strings, doubles and decimals keep a pointer there and are not decoded"""
    import struct
    ty = l['type']
    if (ty & 0xc0) == 0x40 or l.get('dims') is not None or (ty >> 8) & 0x20:
        return None                                  # global-object references, arrays
    prim, sl = (ty >> 16) & 0xff, l.get('slot', 0)
    if not sl:
        return None
    if prim == 7:
        return 'true' if sl & 0xff else None
    if prim == 18:
        c = sl & 0xff
        return '"%s"' % chr(c) if 32 <= c < 127 and c != 34 else None
    if prim in (1, 2, 20):
        v = struct.unpack('<i', struct.pack('<I', sl & 0xffffffff))[0]
        return str(v) if v else None
    if prim in (9, 10):
        return str(sl & 0xffffffff)
    if prim == 4 and R is not None and R.rt is not None and sl + 8 <= len(R.rt.m):
        # a double keeps the offset of its 8 bytes in the reference table
        v = struct.unpack_from('<d', R.rt.m, sl)[0]
        return repr(v) if v and v == v and abs(v) < 1e15 else None
    if prim == 6 and R is not None and R.rt is not None and not re.search(r'pw|pass|pwd|key|secret|token|cred|login', l['name'], re.I):
        # a string keeps the offset of its constant in the reference table
        try:
            t = R.rt.cstr(sl)
        except Exception:
            return None
        if t and t.strip() and all(32 <= ord(c) < 127 for c in t):
            return '"' + t.replace('~', '~~').replace('"', '~"') + '"'
    return None


def array_init(l, R):
    """initial elements of a local array (`integer li_weight[] = {1, 3, 1, 3 ...}`): the local record points into the reference table at a list
    ffff0100 .. count .. (header 0x24 bytes), the count again, then count x (value, type word)"""
    import struct
    ty, sl = l["type"], l.get("slot", 0)
    prim = (ty >> 16) & 0xff
    if l.get("dims") is None or not sl or (ty & 0xc0) == 0x40 or prim not in (1, 2, 7, 9, 10, 18, 20) or R is None or R.rt is None:
        return []
    m = R.rt.m
    if sl + 0x28 > len(m) or struct.unpack_from("<I", m, sl)[0] != (0xffff | (prim << 16)):
        return []
    n = struct.unpack_from("<I", m, sl + 8)[0]
    if not 0 < n <= 2000 or sl + 0x28 + 8 * n > len(m):
        return []
    out = []
    for i in range(n):
        v = struct.unpack_from("<I", m, sl + 0x28 + 8 * i)[0]
        if prim == 18:
            lit = chr(34) + chr(v & 0xff) + chr(34) if 32 <= (v & 0xff) < 127 and (v & 0xff) != 34 else None
        elif prim == 7:
            lit = "true" if v & 0xff else "false"
        elif prim in (1, 2, 20):
            lit = str(struct.unpack("<i", struct.pack("<I", v))[0])
        else:
            lit = str(v)
        if lit is None:
            return []
        out.append("%s[%d] = %s" % (l["name"], i + 1, lit))
    return out


def decompile_routine(obj, ctx, owner, r):
    if r['bytes'] == 0 or (not (r.get('ext') or r.get('mem')) and not r['exact']):
        return ['// %s.%s: external function / prototype without script' % (owner, r['name'])]
    lf = L.Lifter(obj, ctx, r, owner)
    items = lf.run()
    st = S.Structurer(items)
    body = st.run()
    lines = []
    R = lf.R
    import struct
    prec = bytes.fromhex(r['prec']) if r.get('prec') else b''
    argc = prec[0x1e] if len(prec) > 0x1f else 0
    ret = struct.unpack_from('<H', prec, 0x1c)[0] if len(prec) > 0x1d else 0
    sig = '%s.%s' % (owner, r['name'])
    args, locs = [], []
    for i, l in enumerate(R.locals if R else []):
        if (l['type'] & 0xc0) == 0x40:
            continue                                 # references to global objects (sqlca, message ...)
        if chr(1) in l['name']:
            continue                                 # compiler temporaries of choose case
        init = None if i < argc else local_init(l, R)
        # an argument whose type word carries 0x80 is passed by reference (`ref string as_appname`): the callers rely on the value coming back
        byref = i < argc and (l['type'] & 0x80) != 0
        # 0x80 = passed by reference; with 0x40 as well the argument is `readonly` (a literal may be passed for it)
        how = ('readonly ' if S.POWERSCRIPT and (l['type'] & 0x40) else 'ref ') if byref else ''
        (args if i < argc else locs).append('%s%s %s%s' % (how, S.local_type(l, obj.get('classes', {})), l['name'], ' = ' + init if init else ''))
    lines.append('// %s(%s) returns %s%s' % (sig, ', '.join(args), L.PRIM.get(ret, ret) if ret < 0x8000 else obj.get('classes', {}).get(str(ret), {}).get('name', ret), ' [event]' if r.get('event') else ''))
    for d in locs:
        lines.append('\t' + d)
    for l in (R.locals if R else []):
        if (l['type'] & 0xc0) != 0x40 and chr(1) not in l['name']:
            lines += ['\t' + x for x in array_init(l, R)]
    lines += [l.replace(chr(1), '') if l.lstrip().startswith('SQL ') else l for l in S.print_body(body, 1)]
    probs = lf.problems + st.issues
    if probs:
        lines.append('// PROBLEMS: ' + ', '.join(sorted(set(probs))[:12]))
    return lines


def routines_of(node, owner):
    for r in node['routines']:
        r['_fnrefs'] = node.get('fnrefs')
        yield owner, r
    for c in node['controls']:
        yield from routines_of(c, c['name'])


if __name__ == '__main__':
    path = sys.argv[1]
    only = sys.argv[2] if len(sys.argv) > 2 else None
    obj = json.load(open(path, encoding='utf-8'))
    cf = glob.glob(os.path.join(os.path.dirname(path), '..', '_classfields.json')) or glob.glob('C:/Tools/pctest4/_classfields.json')
    ctx = Ctx(cf)
    for owner, r in routines_of(obj, obj['name']):
        if only and r['name'] != only:
            continue
        print('\n'.join(decompile_routine(obj, ctx, owner, r)))
        print()
