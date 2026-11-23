"""Probe: how the runtime stores the initial value of an array property (item[] of a list box, tabstop[] of an edit mask).
32-bit Python:  C:\\Tools\\py32\\python.exe -I re-tools/arrayprop_probe.py <object> <kind hex> <field name> [control]"""
import ctypes
import struct
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *


def walk(ref, gid, path, want, only, depth=0):
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    for i in range(n.value):
        b = mem(rec + 0x4a * i, 0x4a)
        name = wstr(struct.unpack_from('<I', b, 2)[0])
        dt, ptr, flags, attr = struct.unpack_from('<H', b, 8)[0], struct.unpack_from('<I', b, 10)[0], struct.unpack_from('<H', b, 14)[0], b[0x22]
        if attr in (0x8c, 0x9c) and (dt & 0x8000) and depth < 8:
            walk(((dt << 16) | gid) & 0xffffffff, gid, path + '/' + str(name), want, only, depth + 1)
        elif name == want and (not only or path.endswith('/' + only)):
            print(path, name, 'dt=%x flags=%x attr=%x ptr=%x rec=%s' % (dt, flags, attr, ptr, b.hex()))
            for k in range(0x10, 0x4a - 3):
                q = struct.unpack_from('<I', b, k)[0]
                if 0x10000 < q < 0x7fffffff:
                    try:
                        m3 = mem(q, 48)
                        print('   rec+%02x -> %x: %s' % (k, q, m3.hex()))
                    except OSError:
                        pass
            if ptr > 0x10000:
                try:
                    d = mem(ptr, 96)
                    print('   @ptr', d.hex())
                    for k in range(0, 96, 4):
                        q = struct.unpack_from('<I', d, k)[0]
                        if q > 0x10000:
                            try:
                                m2 = mem(q, 64)
                                s = None
                                try:
                                    s = wstr(q, 40)
                                except OSError:
                                    pass
                                print('     +%02x -> %x: %s | %s' % (k, q, m2[:32].hex(), ascii(s)))
                            except OSError:
                                pass
                except OSError as e:
                    print('   unreadable', e)


def main(name, kind, want, only=None):
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    ref = O.cref(O.mgr, g, name)
    walk(ref, g, name, want, only)


if __name__ == '__main__':
    main(sys.argv[1], int(sys.argv[2], 16), sys.argv[3], sys.argv[4] if len(sys.argv) > 4 else None)
