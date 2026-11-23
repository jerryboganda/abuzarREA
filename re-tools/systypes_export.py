"""Dump the system enumerations (value -> name) and the event / function names of the system classes from PBVM125.dll.

32-bit Python only:  C:\\Tools\\py32\\python.exe -I re-tools/systypes_export.py recovered/pcode_names
Writes enums_all.json {enum type: {value: name}} and system_class_protos.json {class: {index: [name, is_event, record hex]}}.
The source generator (pbsrc_export.py) needs both: enumerated property values are written by name, and an event that a
system class already defines must not be declared again.
"""
import ctypes
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_export as P
from pbvm_host import *

O = P.O


def system_protos(t):
    sg = u32(O.mgr + 0xca)
    gdv = ctypes.c_uint32(sg)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), t)
    if not cr:
        return {}
    tab, info = u32(cr + 0x28), u32(cr + 0x40)
    if not tab:
        return {}
    cnt = u32(info + 0x1e) if info else 0
    pool = u32(u32(u32(sg + 0x2a) + 0x28) + 8)
    out = {}
    for i in range(min(cnt, 3000)):
        pp = tab + i * 0x24
        name = wstr(pool + (u32(pp) & 0x7fffffff), 128)
        out[i] = [name.lstrip('+'), name.startswith('+'), mem(pp, 0x24).hex()]
    return out


def main(out):
    types = json.load(open(os.path.join(out, 'system_types.json'), encoding='utf-8'))
    enums, protos, failed = {}, {}, []
    for tid, name in sorted(types.items(), key=lambda x: int(x[0])):
        t = int(tid)
        try:
            e = P.enum_table(t)
        except Exception:
            e = None
        if e:
            enums[name] = {str(k): v for k, v in e.items()}
        try:
            p = system_protos(t)
        except Exception as ex:
            failed.append([name, str(ex)])
            p = {}
        if p:
            protos[name] = p
    json.dump(enums, open(os.path.join(out, 'enums_all.json'), 'w', encoding='utf-8'), indent=0)
    json.dump(protos, open(os.path.join(out, 'system_class_protos.json'), 'w', encoding='utf-8'))
    print('enum types', len(enums), 'classes with prototypes', len(protos), 'failed', len(failed))


if __name__ == '__main__':
    main(sys.argv[1])
