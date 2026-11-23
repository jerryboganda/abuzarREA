"""Initial values of global variables (application objects) and shared variables (other objects).

32-bit python:  C:\\Tools\\py32\\python.exe -I globals_export.py <Application dir> <ABSOLUTE out json> <library>:<object> ...
e.g.            ... C:\\Projects\\Abuzar\\Application C:\\Projects\\Abuzar\\recovered\\pcode_names\\global_inits.json
                    abuzarapp:traderappv1 dw2xls:n_dwr_psr dw2xls:n_dwr_dw_storage pbdwr125:remote_datawindow_appl

A record of the variable table is five 32-bit words: [?, ?, name offset, value, type word].  For a number, boolean or
character the fourth word is the value itself; for a string it points to the text.  Arrays and the pointer types (date,
time, datetime, decimal, real, double, blob, any) are listed under `not_decoded` when the word is not zero.
Output: {object: {values: {name: [type, value]}, not_decoded: {name: type}}}  (only variables that differ from the default).
"""
import sys, os, json, struct, ctypes
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *
import pcode_export as P

TYPES = {1: 'integer', 2: 'long', 3: 'real', 4: 'double', 5: 'decimal', 6: 'string', 7: 'boolean', 8: 'any', 9: 'unsignedinteger',
         10: 'unsignedlong', 11: 'blob', 12: 'date', 13: 'time', 14: 'datetime', 18: 'char', 20: 'longlong', 21: 'byte'}
SYSTEM = {'sqlca', 'sqlda', 'sqlsa', 'error', 'message'}


def table(name):
    for kind in O.KINDS:
        g = O.gref(O.mgr, 0, name, kind) & 0xffff
        if g == 0xffff:
            continue
        try:
            O.cref(O.mgr, g, name)
            gd = P.group_data(g)
            slot = u16(gd + 0x10)
            iv = u32(slot * 0x50 + 0x2c + u32(O.mgr + 0x9a))
            tab = u32(iv + 8)
            recs, n = u32(tab + 2), u32(tab + 0x12)
            names = u32(u32(iv + 0xc) + 8)
        except OSError:
            continue
        for i in range(n):
            w = struct.unpack('<5I', mem(recs + 0x14 * i, 0x14))
            try:
                nm = wstr(names + (w[2] & 0x7fffffff), 60)
            except OSError:
                nm = None
            yield nm, w
        return


def main(app, out, items):
    res = {}
    for item in items:
        lib, name = item.split(':')
        values, missing = {}, {}
        for nm, w in table(name):
            if not nm or nm.lower() in SYSTEM or nm.lower() == name.lower():
                continue
            hi, lo, v = w[4] >> 16, w[4] & 0xffff, w[3]
            if hi & 0x8000 or not v:
                continue                                   # an object reference, or the default value
            t = TYPES.get(hi, hex(hi))
            if lo & 0x2000:
                missing[nm] = t + '[]'
            elif t in ('integer',):
                values[nm] = [t, struct.unpack('<h', struct.pack('<H', v & 0xffff))[0]]
            elif t in ('long',):
                values[nm] = [t, struct.unpack('<i', struct.pack('<I', v))[0]]
            elif t in ('unsignedinteger', 'byte'):
                values[nm] = [t, v & 0xffff]
            elif t == 'unsignedlong':
                values[nm] = [t, v]
            elif t == 'boolean':
                values[nm] = [t, bool(v & 0xffff)]
            elif t == 'char':
                values[nm] = [t, chr(v & 0xffff)]
            elif t == 'string':
                try:
                    s = wstr(v, 2000)
                except OSError:
                    s = None
                if s is None:
                    try:
                        s = ctypes.wstring_at(v)
                    except Exception:
                        s = None
                if s is None:
                    missing[nm] = t
                elif s != '':
                    values[nm] = [t, s]
            else:
                missing[nm] = t
        res[name.lower()] = {'library': lib, 'values': values, 'not_decoded': missing}
        print(name, 'values', len(values), 'not decoded', missing, flush=True)
    json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], sys.argv[3:])
