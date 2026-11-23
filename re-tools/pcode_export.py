"""Export the compiled routines (events / functions) of every class as symbolic p-code disassembly.

32-bit Python only:  C:\\Tools\\py32\\python.exe -I pcode_export.py <library.pbd> <out dir> [start_index]
Uses obj_export.py (manager setup) and opcodes.json (instruction names + operand counts read from PBVM125.dll:
the table at 0x10DDAC94, 12 bytes per opcode, plus the name table behind rt_pcode_name_index).
p-code layout: a routine is a run of 16-bit words; word 0 of an instruction is the opcode, followed by N operand words.
Output per object: <out>/<kind>/<name>.json  {name, routines:[{name, event, instrs:[[wordindex, opcode, [args]]]}], controls:[...]}.
"""
import sys, os, json, struct, base64

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *

OP = json.load(open(os.path.join(O.HERE, 'opcodes.json')))
NARGS = OP['nargs']
NAMES = OP['names']
centry = export(O.PB, 'ob_get_class_entry', V, V, V, ctypes.c_uint32)
_gd_cache = {}


def group_data(gid):
    if gid not in _gd_cache:
        tbl = u32(O.mgr + 0x9a)
        gp = u32(tbl + gid * 0x50 + 4)
        _gd_cache[gid] = u32(gp + 0xe)
    return _gd_cache[gid]


def disassemble(addr, nbytes):
    out, p, end = [], addr, addr + nbytes
    while p < end:
        op = u16(p)
        if op >= len(NARGS):
            out.append([(p - addr) // 2, 'BAD_%d' % op, []])
            return out, False
        n = NARGS[op]
        out.append([(p - addr) // 2, NAMES[str(op)][3:], [u16(p + 2 + 2 * i) for i in range(n)]])
        p += 2 + 2 * n
    return out, p == end


def safe_mem(a, n):
    """read up to n bytes at a, stopping at the first unreadable page"""
    out = b''
    while len(out) < n:
        step = min(n - len(out), 0x1000 - ((a + len(out)) & 0xfff))
        try:
            out += mem(a + len(out), step)
        except OSError:
            break
    if not out:
        raise OSError('unreadable at %x' % a)
    return out


# operands that carry a class/type reference (hi bits: 0x8000+ = class of this object's type table, 0x4000.. = system type)
TYPE_OPERANDS = {'PUSH_FUNC_CLASS': 1, 'EVENTCALL': 2, 'CNV_ANY_TO_OBJECT': 1, 'ENTER_EMBEDDED': 0, 'PUSH_CONST_ENUM': 1,
                 'BUILD_UNBOUNDED_ARRAYLIST': 0, 'BUILD_BOUNDED_ARRAYLIST': 1}
USED_TYPES = set()
_enum_cache = {}


def note_types(instrs):
    for _, op, args in instrs:
        k = TYPE_OPERANDS.get(op)
        if k is not None and k < len(args) and args[k] >= 0x4000:
            USED_TYPES.add(args[k])


def enum_table(t):
    """system enumeration type -> {value: name}  (names as stored: lower case without the '!')"""
    if t not in _enum_cache:
        try:
            sg = u32(O.mgr + 0xca)
            gdv = ctypes.c_uint32(sg)
            cr = centry(O.mgr, ctypes.addressof(gdv), t)
            epool = u32(u32(u32(sg + 0x2a) + 0x20) + 8)
            E, n = u32(cr + 0x86), u16(u32(cr + 8) + 4)
            _enum_cache[t] = {struct.unpack('<h', mem(E + 8 * i + 4, 2))[0]: wstr(epool + (u32(E + 8 * i) & 0x7fffffff), 64)
                              for i in range(min(n, 500))}
        except OSError:
            _enum_cache[t] = None
    return _enum_cache[t]


def class_protos(ref, gid):
    """prototype table of a class: index (as used by PUSH_FUNC_CLASS / EVENTCALL) -> name, routine id, raw record"""
    gdv = ctypes.c_uint32(group_data(gid))
    cr = centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
    if not cr:
        return {}
    P, T = u32(cr + 0x28), u32(cr + 0x40)
    if not P:
        return {}
    cnt = u32(T + 0x1e) if T else 1500
    pool = u32(u32(u32(group_data(gid) + 0x2a) + 0x28) + 8)
    out = {}
    for i in range(min(cnt, 3000)):
        try:
            pp = u32(P + i * 8)
            if pp < 0x10000:
                continue
            out[i] = {'name': wstr(pool + (u32(pp) & 0x7fffffff), 128), 'rid': u16(pp + 0x18),
                      'rec': mem(pp, 0x24).hex()}
        except OSError:
            break
    return out


SKIPPED = []
DECLARED = []


def class_routines(ref, gid):
    gdv = ctypes.c_uint32(group_data(gid))
    cr = centry(O.mgr, ctypes.addressof(gdv), ref >> 16)
    if not cr:
        return []
    T = u32(cr + 0x40)
    if not T:
        return []
    cnt, arr = u32(T + 0x1e), u32(T + 2)
    P = u32(cr + 0x28)
    pool = u32(u32(u32(group_data(gid) + 0x2a) + 0x28) + 8)
    routines = []
    skipped = []
    done = set()

    def entry(i, strict):
        """prototype entry i -> routine dict, or None; strict = beyond the routine count, accept only well-formed entries"""
        pp = u32(P + i * 8) if P else 0
        if strict and not pp:
            raise StopIteration
        name, rid = None, i
        if pp:
            try:
                name = wstr(pool + (u32(pp) & 0x7fffffff))
            except OSError:
                name = None
            rid = u16(pp + 0x18) & 0x7fff
            raw_rid = u16(pp + 0x18)
            if strict and (not name or not name.strip() or not name.isprintable()
                           or (raw_rid != 0xffff and rid >= cnt)):
                raise StopIteration
            if rid == 0x7fff:                       # prototype / event declared without a script (inherited or empty)
                DECLARED.append(((name or '').lstrip('+'), bool(name and name.startswith('+')), i, mem(pp, 0x24).hex()))
                return None
        if rid in done:
            return None
        d0 = arr + rid * 0x28
        B = u32(d0 + 0xc)
        if not B:
            return None
        ln, pc = u16(B), u32(B + 6)
        instrs, exact = disassemble(pc, ln)
        note_types(instrs)
        done.add(rid)
        return {'name': (name or '').lstrip('+'), 'event': bool(name and name.startswith('+')), 'routine': rid,
                'proto': i, 'prec': mem(pp, 0x24).hex() if pp else None,
                'bytes': ln, 'header': [u16(B + 2), u16(B + 4)], 'exact': exact, 'instrs': instrs,
                '_B': B, '_pc': pc, '_anch': [u32(d0 + k) for k in (0x18, 0x1c, 0x20, 0x24)]}

    for i in range(cnt):
        try:
            r = entry(i, False)
            if r:
                routines.append(r)
        except OSError:
            skipped.append(i)
    # classes with external-function declarations keep further prototype entries (the ones with bodies) after the first
    # `cnt`: walk on while the entries are well-formed
    for i in range(cnt, cnt + 600):
        if len(done) >= cnt and i > cnt + 64:
            break
        try:
            r = entry(i, True)
            if r:
                routines.append(r)
        except (StopIteration, OSError):
            break
    SKIPPED.extend(skipped)
    # tables of each routine: the entry's descriptors point at the name tables / local records (the code itself is
    # disassembled above; its heap chunks are not necessarily contiguous with the tables)
    for r in routines:
        try:
            heap = mem(r['_pc'] - 4, 4)
            r['ext'], r['names_order'] = [], []
            anchor_tables(r['_anch'], heap, r['ext'], r['names_order'])
        except OSError:
            r['ext'], r['names_order'] = [], []
        r['line'] = None
        try:
            lb = u32(r['_B'] + 0xa)                          # line-number table: (line u16, byte offset u16) pairs
            h = safe_mem(lb - 16, 16)
            r['line'] = base64.b64encode(safe_mem(lb, size_class(struct.unpack_from('<H', h, 8)[0] >> 8))).decode()
        except (OSError, ValueError, struct.error):
            pass
        del r['_B'], r['_pc'], r['_anch']
    return routines


SIZE_CLASS = {1: 8, 2: 16, 3: 24, 4: 32}


def size_class(tag):
    """heap size class (the chunk tag byte) -> data bytes: 8,16,24,32,48,64,96,128,192,256,384 ..."""
    if tag in SIZE_CLASS:
        return SIZE_CLASS[tag]
    if tag < 5 or tag > 40:
        raise ValueError('tag %d' % tag)
    k = tag - 5                       # tag 5 -> 48, 6 -> 64, 7 -> 96 ...
    return (48 << (k // 2)) if k % 2 == 0 else (64 << (k // 2))


def trim_chunks(buf, base, code_off):
    """cut a memory window after the last heap chunk that belongs to the routine"""
    off, seen = code_off - 0x10, set()
    while 0 <= off < len(buf) - 16 and off not in seen:
        seen.add(off)
        nxt = struct.unpack_from('<I', buf, off)[0]
        if base <= nxt < base + len(buf) and nxt - base > off:
            off = nxt - base
            continue
        tag = struct.unpack_from('<H', buf, off + 8)[0] >> 8
        return buf[:min(len(buf), off + 16 + size_class(tag))]
    return buf


SPACES16 = b' \x00' * 7 + bytes(2)


def chunk_list(buf, base, code_off):
    """(header offset, data offset, end offset) of the routine's chunks inside the window, in list order"""
    out, off, seen = [], code_off - 0x10, set()
    while 0 <= off < len(buf) - 16 and off not in seen:
        seen.add(off)
        nxt = struct.unpack_from('<I', buf, off)[0]
        end = (nxt - base) if base <= nxt < base + len(buf) and nxt - base > off else len(buf)
        out.append((off, off + 16, end))
        if end >= len(buf):
            break
        off = end
    return out


def ext_chunks(buf, base, code_off):
    """Tables that live outside the window: every descriptor chunk holds a pointer (at +2 or +8) to the data it describes.
    Returns (ext chunks [{addr, b64}], name-table addresses in descriptor order)."""
    heap = buf[code_off - 4:code_off] if code_off >= 4 else b''
    ext, order, seen = [], [], set()
    for hdr, data, end in chunk_list(buf, base, code_off)[1:]:
        for k in (2, 8):
            if data + k + 4 > len(buf):
                continue
            p = struct.unpack_from('<I', buf, data + k)[0]
            if p in seen or p % 2 or not (0x01000000 <= p < 0x7f000000):
                continue
            if base <= p < base + len(buf):
                if buf[p - base:p - base + 16] == SPACES16:
                    seen.add(p)
                    order.append(p)
                continue
            try:
                h = safe_mem(p - 16, 16)
            except OSError:
                continue
            if h[12:16] != heap:
                continue
            tag = struct.unpack_from('<H', h, 8)[0] >> 8
            try:
                body = safe_mem(p, size_class(tag))
            except OSError:
                continue
            seen.add(p)
            ext.append({'addr': p, 'b64': base64.b64encode(body).decode()})
            if body[:16] == SPACES16:
                order.append(p)
    return ext, order


def anchor_tables(anch, heap, ext, order):
    """follow the routine entry's descriptor pointers to the tables they describe (appends to ext / order)"""
    have = {x['addr'] for x in ext}
    for a in anch:
        if not (0x01000000 <= a < 0x7f000000) or a % 2:
            continue
        try:
            desc = safe_mem(a, 0x30)
        except OSError:
            continue
        for k in (8, 2):
            if k + 4 > len(desc):
                continue
            p = struct.unpack_from('<I', desc, k)[0]
            if p % 2 or not (0x01000000 <= p < 0x7f000000):
                continue
            try:
                h = safe_mem(p - 16, 16)
                if h[12:16] != heap:
                    if p & 0xfff != 8:
                        continue
                    raise ValueError('large allocation')
                body = safe_mem(p, size_class(struct.unpack_from('<H', h, 8)[0] >> 8))
                used = struct.unpack_from('<I', desc, 0)[0] if k == 8 else 0
                if used > len(body) and used < 0x80000:           # the descriptor knows the real length
                    body = safe_mem(p, used + 64)
            except (OSError, ValueError):
                # large tables sit in their own allocation (data at page offset 8, no chunk header): the descriptor
                # carries the used size (u32 at +0 for name tables, u16 at +0 for local records)
                if p & 0xfff != 8:
                    continue
                used = struct.unpack_from('<I', desc, 0)[0] if k == 8 else struct.unpack_from('<H', desc, 0)[0]
                try:
                    body = safe_mem(p, min(max(used, 16) + 64, 0x40000))
                except OSError:
                    continue
            if p not in have:
                have.add(p)
                ext.append({'addr': p, 'b64': base64.b64encode(body).decode()})
            if body[:16] == SPACES16 and p not in order:
                order.append(p)


CLASSFIELDS = {}


def class_fields(ref, name):
    """property / variable table of a class (shared by name; system classes recur in every object)"""
    if name in CLASSFIELDS:
        return
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    rows = []
    if rec:
        for i in range(n.value):
            b = mem(rec + 0x4a * i, 0x4a)
            rows.append([wstr(struct.unpack_from('<I', b, 2)[0], 128), struct.unpack_from('<H', b, 8)[0], b[0x22]])
    CLASSFIELDS[name] = rows


def object_extras(ref, gid):
    """tables that give meaning to the operands of every routine of this object (one group = one object)"""
    out = {'group': gid}
    gd = group_data(gid)
    try:
        S = u32(gd + 0x26)                                  # embedded-SQL statement pool
        B0 = u32(S + 8)
        used = u32(S)
        nxt = u32(B0 - 16)
        size = max(used, nxt - B0 if B0 < nxt < B0 + 0x100000 else 0)
        out['sqlpool'] = {'addr': B0, 'b64': base64.b64encode(safe_mem(B0, size)).decode()}
    except OSError:
        out['sqlpool'] = None
    classes, enums = {}, {}
    try:
        ntypes = u32(u32(u32(gd + 0x2a) + 8) + 0x12)
    except OSError:
        ntypes = 0
    all_types = set(USED_TYPES) | {0x8000 + i for i in range(1, min(ntypes, 20000) + 1)}
    for t in sorted(all_types):
        if t >= 0x8000:
            cref_ = ((t << 16) | gid) & 0xffffffff
            nm = O.class_name(cref_)
            if not nm:
                continue
            ent = {'name': nm, 'ancestor': O.parent_name(cref_)}
            try:
                class_fields(cref_, nm)
            except OSError:
                pass
            try:
                ent['protos'] = class_protos(cref_, gid) if nm else {}
            except OSError:
                ent['protos'] = {}
            classes[str(t)] = ent
        else:
            enums[str(t)] = enum_table(t)
    out['classes'], out['enums'] = classes, enums
    return out


def export_class(ref, gid, depth=0):
    base = O.export_class.__wrapped__(ref, gid, depth) if hasattr(O.export_class, '__wrapped__') else None
    return base


def defined_events(ref, gid):
    """events / functions this class (an item or control of a descendant) defines itself, beyond the compiler's create / destroy"""
    for e in class_protos(ref, gid).values():
        if e['rid'] != 0xffff and e['name'].lstrip('+').lower() not in ('create', 'destroy'):
            return True
    return False


def has_own(ref, gid, depth=0):
    """does an inherited control / menu item carry anything the descendant added: own sub-items or own scripts"""
    if depth > 12:
        return False
    if defined_events(ref, gid):
        return True
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    for i in range(n.value if rec else 0):
        b = mem(rec + 0x4a * i, 0x4a)
        dt = struct.unpack_from('<H', b, 8)[0]
        if dt & 0x8000 and b[0x22] in (0x8c, 0x9c):
            if b[0x22] == 0x8c or has_own(((dt << 16) | gid) & 0xffffffff, gid, depth + 1):
                return True
    return False


def walk(ref, gid, depth=0):
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    del SKIPPED[:]
    del DECLARED[:]
    try:
        routines = class_routines(ref, gid)
        err = None
    except OSError as e:          # native access violation inside one class: keep the rest of the object
        routines, err = [], str(e)
    node = {'name': O.class_name(ref), 'ancestor': O.parent_name(ref), 'routines': routines, 'controls': []}
    if SKIPPED:
        node['routines_skipped'] = list(SKIPPED)
        del SKIPPED[:]
    if DECLARED:
        node['declared_only'] = [{'name': n_, 'event': e_, 'proto': i_, 'prec': p_} for n_, e_, i_, p_ in DECLARED]
        del DECLARED[:]
    if err:
        node['routines_error'] = err
    if rec and depth < 8:
        for i in range(n.value):
            b = mem(rec + 0x4a * i, 0x4a)
            dt = struct.unpack_from('<H', b, 8)[0]
            attr = b[0x22]
            if attr in (0x8c, 0x9c) and (dt & 0x8000):
                cref_ = ((dt << 16) | gid) & 0xffffffff
                if attr == 0x9c and not has_own(cref_, gid):
                    continue                      # inherited and untouched: the ancestor's export covers it
                child = walk(cref_, gid, depth + 1)
                child['field'] = wstr(struct.unpack_from('<I', b, 2)[0])
                if attr == 0x9c:
                    child['inherited'] = True     # overridden / extended by this descendant
                node['controls'].append(child)
    return node


def main(lib, out, start=0):
    os.makedirs(out, exist_ok=True)
    log = open(os.path.join(out, '_progress.log'), 'a', encoding='utf-8')
    items = []
    for kind, kname in O.KINDS.items():
        if kname == 'structure':
            continue
        cnt = ctypes.c_int(0)
        r = O.list_objs(O.mgr, kind, ctypes.addressof(cnt), lib)
        for i in range(cnt.value):
            items.append((kind, kname, wstr(u32(r + 4 * i))))
    items.sort(key=lambda t: (t[1], t[2].lower()))
    for idx, (kind, kname, name) in enumerate(items):
        if idx < start:
            continue
        log.write('START\t%d\t%s\t%s\n' % (idx, kname, name))
        log.flush()
        try:
            g = O.gref(O.mgr, 0, name, kind) & 0xffff
            if g == 0xffff:
                raise RuntimeError('group not found')
            ref = O.cref(O.mgr, g, name)
            USED_TYPES.clear()
            data = walk(ref, g)
            data.update(object_extras(ref, g))
            data['kind'] = kname
            data['library'] = os.path.basename(lib)
            os.makedirs(os.path.join(out, kname), exist_ok=True)
            with open(os.path.join(out, kname, name + '.json'), 'w', encoding='utf-8', errors='replace') as f:
                json.dump(data, f, ensure_ascii=False)
            log.write('OK\t%d\t%s\t%s\n' % (idx, kname, name))
        except Exception as e:
            log.write('FAIL\t%d\t%s\t%s\t%s\n' % (idx, kname, name, e))
        log.flush()
    cf = os.path.join(out, '_classfields.json')
    old = json.load(open(cf, encoding='utf-8')) if os.path.exists(cf) else {}
    old.update(CLASSFIELDS)
    with open(cf, 'w', encoding='utf-8', errors='replace') as f:
        json.dump(old, f, ensure_ascii=False)
    log.write('DONE\t%d\n' % len(items))
    log.close()


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 0)
