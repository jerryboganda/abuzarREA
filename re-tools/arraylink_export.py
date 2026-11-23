"""Link the design-time array values found by arrayinit_export.py to the control and property they belong to.

32-bit Python only, absolute paths:
    C:\\Tools\\py32\\python.exe -I re-tools/arraylink_export.py C:/Projects/Abuzar/recovered

Reads recovered/pcode_names/array_inits.json (objects that declare arrays) and writes
recovered/pcode_names/array_links.json: {object: {control path: {"table": hex of the class's value table,
"fields": [[index, name, type id, flags], ...]}}}.

Each class entry holds, at +0x54, a table of the initial values that are not plain scalars; the entry of an array
property carries the offset of that array's record inside the compiled object (the same record arrayinit_export.py
finds in the file).  The matching itself is done offline by the source generator.
"""
import ctypes
import json
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_export as P
from pbvm_host import *

O = P.O
KIND = {'window': 0x4085, 'userobject': 0x4080}


def walk(ref, gid, gd, path, out, depth=0):
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    fields, children = [], []
    for i in range(n.value):
        b = mem(rec + 0x4a * i, 0x4a)
        name = wstr(struct.unpack_from('<I', b, 2)[0])
        dt, flags, attr = struct.unpack_from('<H', b, 8)[0], struct.unpack_from('<H', b, 14)[0], b[0x22]
        if attr in (0x8c, 0x9c) and (dt & 0x8000) and depth < 8:
            children.append((name, dt))
        elif flags & 0x2000:
            fields.append([struct.unpack_from('<H', b, 0)[0], name, dt, flags])
    gdv = ctypes.c_uint32(gd)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
    table = b''
    if cr:
        try:
            t = u32(cr + 0x54)
            if t > 0x10000:
                for size in (0x600, 0x200, 0x80):
                    try:
                        table = mem(t, size)
                        break
                    except OSError:
                        continue
        except OSError:
            pass
    out[path] = {'table': table.hex(), 'fields': fields}
    for name, dt in children:
        walk(((dt << 16) | gid) & 0xffffffff, gid, gd, path + '/' + str(name), out, depth + 1)


def main(recovered):
    inits = json.load(open(os.path.join(recovered, 'pcode_names', 'array_inits.json'), encoding='utf-8'))
    index = json.load(open(os.path.join(recovered, 'pcode_names', 'objindex.json'), encoding='utf-8'))
    lower = {k.lower(): (k, v) for k, v in index.items()}
    res, failed = {}, []
    for name in sorted(inits):
        if name not in lower:
            failed.append([name, 'not in index'])
            continue
        real, rel = lower[name]
        kind = rel.split('/')[1]
        try:
            g = O.gref(O.mgr, 0, real, KIND[kind]) & 0xffff
            ref = O.cref(O.mgr, g, real)
            out = {}
            walk(ref, g, P.group_data(g), name, out)
            res[name] = out
        except Exception as e:
            failed.append([name, '%s: %s' % (type(e).__name__, e)])
    json.dump(res, open(os.path.join(recovered, 'pcode_names', 'array_links.json'), 'w', encoding='utf-8'))
    print('objects', len(res), 'classes', sum(len(v) for v in res.values()), 'failed', failed)


if __name__ == '__main__':
    main(sys.argv[1])
