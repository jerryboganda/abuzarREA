"""Export the external (DLL) and RPC (stored procedure) function declarations of the objects that have any.

32-bit Python only, absolute paths (the host changes the working directory):
    C:\\Tools\\py32\\python.exe -I re-tools/extdecl_export.py C:/Projects/Abuzar/pbsrc/export-report.json C:/Projects/Abuzar/recovered

Reads the object list from the generator's report (`external_function_objects`) and writes
recovered/pcode_names/ext_decls_full.json:
    {object: [{name, ret, args: [{name, type, ref, raw: [x, flags]}], kind: 'dll' | 'rpc', library, alias, flags}]}

Layout found by re-tools/extdecl_probe.py.  A prototype record is 0x24 bytes:
    +00 name offset (name pool)          +04 offset of the signature string (argument pool)
    +08 offset of the argument records   +0c offset of the alias string (name pool), 0xffff = none
    +10 offset of the library name (name pool) for a DLL function
    +18 routine id (0xffff = no script)  +1c return type   +1e argument count   +1f kind bits (0x08 RPC, 0x04 DLL)
An argument record is 12 bytes: name offset, a second word (0xffff for a scalar), type (u16), flags (u16, 0x2 = by reference).
The name pool is group_data+0x2a -> +0x28 -> +8, the argument pool the same with +0x30.
"""
import ctypes
import json
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_export as P
from pbvm_host import *

O = P.O
KIND = {'application': 0x4081, 'window': 0x4085, 'userobject': 0x4080, 'menu': 0x40af}
PRIM = {0: None, 1: 'integer', 2: 'long', 3: 'real', 4: 'double', 5: 'decimal', 6: 'string', 7: 'boolean', 8: 'any',
        9: 'unsignedinteger', 10: 'unsignedlong', 11: 'blob', 12: 'date', 13: 'time', 14: 'datetime', 18: 'char',
        20: 'longlong', 21: 'byte'}


def type_name(dt, g, systypes):
    if dt < 0x4000:
        return PRIM.get(dt, 'type_%d' % dt)
    if dt < 0x8000:
        return systypes.get(str(dt), 'type_%x' % dt)
    return O.class_name(((dt << 16) | g) & 0xffffffff) or ('type_%x' % dt)


def export_object(name, kind, systypes):
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    if g == 0xffff:
        raise RuntimeError('group not found')
    ref = O.cref(O.mgr, g, name)
    gd = P.group_data(g)
    gdv = ctypes.c_uint32(gd)
    cr = P.centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
    tab, info = u32(cr + 0x28), u32(cr + 0x40)
    cnt = u32(info + 0x1e) if info else 0
    base = u32(gd + 0x2a)
    names = u32(u32(base + 0x28) + 8)
    argpool = u32(u32(base + 0x30) + 8) if u32(base + 0x30) else 0
    out, bad = [], 0
    for i in range(cnt + 1200):
        try:
            pp = u32(tab + i * 8)
            if pp < 0x10000:
                bad += 1
                if i >= cnt and bad > 3:
                    break
                continue
            rec = mem(pp, 0x24)
            nm = wstr(names + (struct.unpack_from('<I', rec, 0)[0] & 0x7fffffff), 128)
        except OSError:
            break
        if not nm or not nm.strip() or not nm.isprintable():
            if i >= cnt:
                break
            continue
        bad = 0
        a4, a8, ac, lib_off = struct.unpack_from('<IIII', rec, 4)
        rid, ret, argc, bits = struct.unpack_from('<H', rec, 0x18)[0], struct.unpack_from('<H', rec, 0x1c)[0], rec[0x1e], rec[0x1f]
        if nm.startswith('+') or rid != 0xffff or not bits & 0x0c:
            continue
        d = {'name': nm, 'ret': type_name(ret, g, systypes), 'args': [], 'kind': 'rpc' if bits & 0x08 else 'dll',
             'library': None, 'alias': None, 'flags': bits}
        try:
            if ac != 0xffff:
                d['alias'] = wstr(names + ac, 256)
            if d['kind'] == 'dll':
                d['library'] = wstr(names + lib_off, 256)
            for k in range(argc):
                off, x, dt, fl = struct.unpack('<IIHH', mem(argpool + a8 + 12 * k, 12))
                d['args'].append({'name': wstr(names + (off & 0x7fffffff), 128), 'type': type_name(dt, g, systypes),
                                  'ref': bool(fl & 0x2), 'raw': [x, fl]})
        except OSError as e:
            d['error'] = str(e)
        out.append(d)
    return out


def main(report, recovered):
    objects = json.load(open(report, encoding='utf-8'))['external_function_objects']
    systypes = json.load(open(os.path.join(recovered, 'pcode_names', 'system_types.json'), encoding='utf-8'))
    index = json.load(open(os.path.join(recovered, 'pcode_names', 'objindex.json'), encoding='utf-8'))
    res, failed = {}, []
    for name in sorted(objects):
        kind = (index.get(name) or '').split('/')[1] if name in index else None
        if kind not in KIND:
            failed.append([name, 'kind %s' % kind])
            continue
        try:
            res[name] = export_object(name, KIND[kind], systypes)
        except Exception as e:
            failed.append([name, '%s: %s' % (type(e).__name__, e)])
    out = os.path.join(recovered, 'pcode_names', 'ext_decls_full.json')
    json.dump({'objects': res, 'failed': failed}, open(out, 'w', encoding='utf-8'), indent=1)
    print('objects', len(res), 'declarations', sum(len(v) for v in res.values()), 'expected', sum(objects.values()), 'failed', failed)


def event_signatures(name, kind, class_ids, wanted, systypes):
    """argument lists of events that a class (the object or one of its controls, by class id) declares without a script"""
    g = O.gref(O.mgr, 0, name, kind) & 0xffff
    ref = O.cref(O.mgr, g, name)
    gd = P.group_data(g)
    base = u32(gd + 0x2a)
    names = u32(u32(base + 0x28) + 8)
    argpool = u32(u32(base + 0x30) + 8) if u32(base + 0x30) else 0
    out = {}
    for cid in class_ids or [ref >> 16]:
        gdv = ctypes.c_uint32(gd)
        cr = P.centry(O.mgr, ctypes.addressof(gdv), int(cid))
        if not cr:
            continue
        tab, info = u32(cr + 0x28), u32(cr + 0x40)
        cnt = u32(info + 0x1e) if info else 0
        for i in range(cnt + 200):
            try:
                pp = u32(tab + i * 8)
                if pp < 0x10000:
                    continue
                rec = mem(pp, 0x24)
                nm = wstr(names + (struct.unpack_from('<I', rec, 0)[0] & 0x7fffffff), 128)
            except OSError:
                break
            if not nm or nm.lstrip('+') not in wanted:
                continue
            a8 = struct.unpack_from('<I', rec, 8)[0]
            args = []
            for k in range(rec[0x1e]):
                off, x, dt, fl = struct.unpack('<IIHH', mem(argpool + a8 + 12 * k, 12))
                args.append({'name': wstr(names + (off & 0x7fffffff), 128), 'type': type_name(dt, g, systypes), 'raw': [x, fl]})
            out[nm.lstrip('+')] = {'ret': type_name(struct.unpack_from('<H', rec, 0x1c)[0], g, systypes), 'args': args}
    return out


def main_events(listing, recovered):
    """listing: [{object, kind, class_ids: [...], events: [...]}] -> recovered/pcode_names/event_sigs_extra.json {event: {ret, args}}"""
    systypes = json.load(open(os.path.join(recovered, 'pcode_names', 'system_types.json'), encoding='utf-8'))
    out = os.path.join(recovered, 'pcode_names', 'event_sigs_extra.json')
    res = json.load(open(out, encoding='utf-8')) if os.path.exists(out) else {}
    failed = 0
    for item in json.load(open(listing, encoding='utf-8')):
        try:
            ids = [c for c in (item.get('class_ids') or []) if c]
            got = event_signatures(item['object'], KIND[item['kind']], ids, set(item['events']), systypes)
        except Exception:
            failed += 1
            continue
        for event, sig in got.items():
            # keyed by object / class / event: the same event name has different signatures in different classes
            res['%s/%s/%s' % (item['object'], item.get('label') or item['object'], event)] = sig
    json.dump(res, open(out, 'w', encoding='utf-8'), indent=1)
    print('event signatures', len(res), 'objects failed', failed)


if __name__ == '__main__':
    if sys.argv[1] == '--events':
        main_events(sys.argv[2], sys.argv[3])
    else:
        main(sys.argv[1], sys.argv[2])
