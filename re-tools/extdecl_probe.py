"""Probe: where does the runtime keep the argument list and the library name of an external function prototype?
32-bit Python:  C:\\Tools\\py32\\python.exe -I re-tools/extdecl_probe.py <object> <kind hex, e.g. 4081>"""
import ctypes
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_export as P
from pbvm_host import *

O = P.O


def main(name, kind):
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    ref = O.cref(O.mgr, g, name)
    gd = P.group_data(g)
    gdv = ctypes.c_uint32(gd)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
    tab, info = u32(cr + 0x28), u32(cr + 0x40)
    cnt = u32(info + 0x1e) if info else 0
    base = u32(gd + 0x2a)
    print('class entry %x protos %x cnt %d base %x' % (cr, tab, cnt, base))
    pools = {}
    for k in range(0x10, 0x48, 4):
        try:
            p = u32(base + k)
            q = u32(p + 8) if p > 0x10000 else 0
            pools[k] = q
            print('  base+%02x -> %x -> +8 %x' % (k, p, q))
        except OSError:
            pass
    pool = pools.get(0x28, 0)
    shown = 0
    for i in range(cnt + 80):
        try:
            pp = u32(tab + i * 8)
            if pp < 0x10000:
                continue
            rec = mem(pp, 0x24)
        except OSError:
            break
        nm = wstr(pool + (struct.unpack_from('<I', rec, 0)[0] & 0x7fffffff), 80)
        rid = struct.unpack_from('<H', rec, 0x18)[0]
        a4, a8, ac = struct.unpack_from('<III', rec, 4)
        if nm.startswith('+') or a8 == 0xffff and ac == 0xffff:
            continue
        print('#%d %s rid=%x rec=%s second=%x' % (i, nm, rid, rec.hex(), u32(tab + i * 8 + 4)))
        if ac != 0xffff:
            print('    name pool @0c:', repr(wstr(pool + ac, 120)))
        for k, q in pools.items():
            if not q or a8 == 0xffff:
                continue
            try:
                raw = mem(q + a8, max(12, a4 - a8) + 8)
            except OSError:
                continue
            print('    pool+%02x @08: %s' % (k, raw.hex()))
        shown += 1
        if shown >= 6:
            break


if __name__ == '__main__':
    main(sys.argv[1], int(sys.argv[2], 16))
