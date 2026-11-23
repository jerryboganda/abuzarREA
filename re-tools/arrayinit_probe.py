"""Probe: where a class entry keeps the initial values of its array properties (item[] of a list box ...).
32-bit Python:  C:\\Tools\\py32\\python.exe -I re-tools/arrayinit_probe.py <object> <kind hex> <control>"""
import ctypes
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_export as P
from pbvm_host import *

O = P.O
SIG = bytes.fromhex('01 00 00 0d'.replace(' ', ''))


def find_class(ref, gid, want, depth=0):
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    for i in range(n.value):
        b = mem(rec + 0x4a * i, 0x4a)
        name = wstr(struct.unpack_from('<I', b, 2)[0])
        dt, attr = struct.unpack_from('<H', b, 8)[0], b[0x22]
        if attr in (0x8c, 0x9c) and (dt & 0x8000) and depth < 8:
            child = ((dt << 16) | gid) & 0xffffffff
            if name == want:
                return child, dt
            r = find_class(child, gid, want, depth + 1)
            if r:
                return r
    return None


def main(name, kind, want):
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    ref = O.cref(O.mgr, g, name)
    child, dt = find_class(ref, g, want)
    gd = P.group_data(g)
    gdv = ctypes.c_uint32(gd)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), dt)
    print('class %s id %x entry %x' % (want, dt, cr))
    head = mem(cr, 0xa0)
    print(head.hex())
    for k in range(0, 0xa0 - 3, 2):
        q = struct.unpack_from('<I', head, k)[0]
        if 0x10000 < q < 0x7fffffff:
            try:
                m = mem(q, 0x400)
            except OSError:
                try:
                    m = mem(q, 0x40)
                except OSError:
                    continue
            hit = m.find(SIG)
            print('  +%02x -> %x  %s%s' % (k, q, m[:24].hex(), '   SIG at +%x: %s' % (hit - 4, m[max(hit - 4, 0):hit + 28].hex()) if hit >= 0 else ''))


if __name__ == '__main__':
    main(sys.argv[1], int(sys.argv[2], 16), sys.argv[3])


def scan(name, kind, want, count):
    """find the array record with `count` elements in the loaded image and print what points at it"""
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    ref = O.cref(O.mgr, g, name)
    child, dt = find_class(ref, g, want)
    gd = P.group_data(g)
    gdv = ctypes.c_uint32(gd)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), dt)
    sig = bytes.fromhex('06000100000d') + struct.pack('<I', count) + bytes.fromhex('08000100')
    lo = (min(cr, gd) & 0xfff00000) - 0x400000
    hits = []
    for base in range(lo, lo + 0x1800000, 0x1000):
        try:
            m = mem(base, 0x1000)
        except OSError:
            continue
        k = m.find(sig)
        while k >= 0:
            hits.append(base + k - 2)
            k = m.find(sig, k + 1)
    print('class entry %x, records with %d elements at' % (cr, count), [hex(h) for h in hits])
    for h in hits:
        r = mem(h - 0x30, 0x70)
        print('  %x: %s' % (h, r.hex()))
        # who points at the record (or near it)?
        for base in range(lo, lo + 0x1800000, 0x1000):
            try:
                m = mem(base, 0x1000)
            except OSError:
                continue
            for delta in range(-0x40, 8, 2):
                p = struct.pack('<I', h + delta)
                k = m.find(p)
                if k >= 0:
                    print('      pointer to record%+d at %x (class entry %+d)' % (delta, base + k, base + k - cr))


if __name__ == '__main__' and len(sys.argv) > 4:
    scan(sys.argv[1], int(sys.argv[2], 16), sys.argv[3], int(sys.argv[4]))
