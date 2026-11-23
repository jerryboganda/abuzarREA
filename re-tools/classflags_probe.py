"""Raw class entry of user objects, to find the auto-instantiate flag.

32-bit python:  C:\\Tools\\py32\\python.exe -I classflags_probe.py <ABSOLUTE out json> <object> ...
Output: {object: hex of the first 0x80 bytes of its class entry}
"""
import sys, os, json, struct, ctypes
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *
import pcode_export as P


def main(out, names):
    res = {}
    for name in names:
        for kind in O.KINDS:
            g = O.gref(O.mgr, 0, name, kind) & 0xffff
            if g == 0xffff:
                continue
            try:
                ref = O.cref(O.mgr, g, name)
                gdv = ctypes.c_void_p(P.group_data(g))
                cr = P.centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
                res[name] = mem(cr, 0x80).hex() if cr else None
            except OSError as e:
                res[name] = 'error %s' % e
            break
    json.dump(res, open(out, 'w'), indent=1)
    print(len(res))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2:])
