"""Dump the raw 0x4a-byte field records of the instance variables of a class (to find where array dimensions are stored).
32-bit Python:  py32 -I field_dump.py <library.pbd> <window name>"""
import sys, os, struct, ctypes
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *

name = sys.argv[2]
g = O.gref(O.mgr, 0, name, 0x4085) & 0xffff
ref = O.cref(O.mgr, g, name)
n = ctypes.c_int(0)
rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
for i in range(n.value):
    b = mem(rec + 0x4a * i, 0x4a)
    if b[0x22] == 0xcc:
        print('%-20s type=%04x v=%s b14=%s b16..=%s' % (wstr(struct.unpack_from('<I', b, 2)[0]), struct.unpack_from('<H', b, 8)[0], b[10:14].hex(), b[14:18].hex(), b[18:34].hex()))
