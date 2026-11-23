"""Export the bounds of array members (instance variables, structure members) that obj_export does not decode.

32-bit Python only, absolute paths:
    C:\\Tools\\py32\\python.exe -I re-tools/arrays_export.py C:/Projects/Abuzar/pbsrc/array-objects.json C:/Projects/Abuzar/recovered

Input:  {object: {"kind": "window" | "userobject" | "structure" | ..., "local": {class id: structure name}}}
Output: recovered/pcode_names/array_bounds.json
        {object: {"": {field: {bounded, dims, raw}}, <local structure>: {...}}, ...}   ("" = the object's own class)
        and for local structures also their member list: {object: {"#members": {structure: [[name, type id, flags], ...]}}}

A field record is 0x4a bytes: +2 name pointer, +8 type id, +10 value / pointer, +14 flags (0x2000 = array), +0x22 attribute.
The array descriptor the value points at: u16 flags (0x4000 = fixed bounds), u16 type, u32 number of dimensions, then one
u32 element count per dimension.
"""
import ctypes
import json
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *

KIND = {'application': 0x4081, 'window': 0x4085, 'userobject': 0x4080, 'menu': 0x40af, 'structure': 0x4079}


def class_arrays(ref):
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    arrays, members = {}, []
    for i in range(n.value):
        b = mem(rec + i * 0x4a, 0x4a)
        name = wstr(struct.unpack_from('<I', b, 2)[0])
        dt, ptr, flags = struct.unpack_from('<H', b, 8)[0], struct.unpack_from('<I', b, 10)[0], struct.unpack_from('<H', b, 14)[0]
        members.append([name, dt, flags, b[0x22]])
        if flags & 0x2000 and ptr > 0x10000:
            try:
                d = mem(ptr, 48)
            except OSError:
                continue
            head, ndims = struct.unpack_from('<H', d, 0)[0], struct.unpack_from('<I', d, 4)[0]
            dims = [struct.unpack_from('<I', d, 8 + 4 * k)[0] for k in range(min(ndims, 4))]
            arrays[name] = {'bounded': bool(head & 0x4000), 'dims': dims, 'raw': d.hex()}
    return arrays, members


def main(listing, recovered):
    todo = json.load(open(listing, encoding='utf-8'))
    out, failed = {}, []
    for name, info in sorted(todo.items()):
        try:
            g = O.gref(O.mgr, 0, name, KIND[info['kind']]) & 0xffff
            if g == 0xffff:
                raise RuntimeError('group not found')
            ref = O.cref(O.mgr, g, name)
            arrays, members = class_arrays(ref)
            out[name] = {'': arrays, '#members': {'': members}}          # '' = the object's own class, in declared order
            for cid, sname in (info.get('local') or {}).items():
                a, members = class_arrays(((int(cid) << 16) | g) & 0xffffffff)
                out[name][sname] = a
                out[name]['#members'][sname] = members
        except Exception as e:
            failed.append([name, '%s: %s' % (type(e).__name__, e)])
    json.dump({'objects': out, 'failed': failed}, open(os.path.join(recovered, 'pcode_names', 'array_bounds.json'), 'w',
                                                        encoding='utf-8'), indent=1)
    print('objects', len(out), 'array members', sum(len(a) for o in out.values() for k, a in o.items() if k != '#members'),
          'failed', failed)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
