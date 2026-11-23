"""Export the structures that an object declares for itself (they are not global objects, so obj_export_all skips them).

32-bit Python only, absolute paths:
    C:\\Tools\\py32\\python.exe -I re-tools/localstruct_export.py C:/Projects/Abuzar/pbsrc/local-structs.json C:/Projects/Abuzar/recovered

Input: {object: {class id: structure name}} (built from the `classes` table of recovered/pcode).
Output: recovered/pcode_names/local_structs.json  {object: {structure name: [field records as obj_export writes them]}}
"""
import json
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *

KIND = {'application': 0x4081, 'window': 0x4085, 'userobject': 0x4080, 'menu': 0x40af}


def array_bounds(rec):
    """raw field record (hex) of an array member, kept for later decoding"""
    return rec


def main(listing, recovered):
    todo = json.load(open(listing, encoding='utf-8'))
    index = json.load(open(os.path.join(recovered, 'pcode_names', 'objindex.json'), encoding='utf-8'))
    out, failed = {}, []
    for name, classes in sorted(todo.items()):
        kind = (index.get(name) or '/').split('/')[1]
        try:
            g = O.gref(O.mgr, 0, name, KIND[kind]) & 0xffff
            O.cref(O.mgr, g, name)
            out[name] = {}
            for cid, sname in classes.items():
                ref = ((int(cid) << 16) | g) & 0xffffffff
                d = O.export_class(ref, g)
                # raw field records too: the array bounds of a member are not in the decoded value
                n = ctypes.c_int(0)
                rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
                raw = []
                for i in range(n.value):
                    b = mem(rec + i * 0x4a, 0x4a)
                    ptr = struct.unpack_from('<I', b, 10)[0]
                    deref = None
                    if struct.unpack_from('<H', b, 14)[0] & 0x2000 and ptr > 0x10000:
                        try:
                            deref = mem(ptr - 16, 80).hex()
                        except OSError:
                            deref = None
                    raw.append({'name': wstr(struct.unpack_from('<I', b, 2)[0]), 'rec': b.hex(), 'array': deref})
                out[name][sname] = {'fields': d.get('fields', []), 'raw': raw}
        except Exception as e:
            failed.append([name, '%s: %s' % (type(e).__name__, e)])
    json.dump({'objects': out, 'failed': failed}, open(os.path.join(recovered, 'pcode_names', 'local_structs.json'), 'w',
                                                        encoding='utf-8'), indent=1)
    print('objects', len(out), 'structures', sum(len(v) for v in out.values()), 'failed', failed)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
