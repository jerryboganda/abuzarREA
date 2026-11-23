"""Shared / global variable tables of an object's group (PUSH_SHARED_VAR [n] indexes them).
32-bit python:  C:\Tools\py32\python.exe -I shared_export.py <library.pbd> <out json>   (merges into the json)"""
import sys, os, json, struct, ctypes
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *
import pcode_export as P


def table(g):
    gd = P.group_data(g)
    slot = u16(gd + 0x10)
    iv = u32(slot * 0x50 + 0x2c + u32(O.mgr + 0x9a))
    tab = u32(iv + 8)
    recs, n = u32(tab + 2), u32(tab + 0x12)
    names = u32(u32(iv + 0xc) + 8)
    out = []
    for i in range(n):
        w = struct.unpack('<5I', mem(recs + 0x14 * i, 0x14))
        try:
            nm = wstr(names + (w[2] & 0x7fffffff), 60)
        except OSError:
            nm = None
        out.append([nm, w[4]])
    return out


def main(lib, out):
    res = json.load(open(out, encoding='utf-8')) if os.path.exists(out) else {}
    for kind, kname in O.KINDS.items():
        if kname == 'structure':
            continue
        cnt = ctypes.c_int(0)
        r = O.list_objs(O.mgr, kind, ctypes.addressof(cnt), lib)
        for i in range(cnt.value):
            name = wstr(u32(r + 4 * i))
            try:
                g = O.gref(O.mgr, 0, name, kind) & 0xffff
                if g == 0xffff:
                    continue
                O.cref(O.mgr, g, name)
                t = table(g)
                if len(t) > 1:
                    res[name] = t
            except OSError:
                pass
    json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False)
    print(len(res), 'objects with shared variables')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
