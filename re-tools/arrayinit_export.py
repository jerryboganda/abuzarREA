"""Recover the design-time values of array properties (`item[]` of list boxes and drop-down lists, picture name lists)
from the compiled objects.

    python -I re-tools/arrayinit_export.py Application recovered/pcode_names/array_inits.json

The class tables that obj_export reads hold only a pointer for an array property, so these values were missing
(a drop-down list of printers, of COM ports, AM/PM ...).  In the compiled object every array instance is a record

    u16 marker (0xffff = array of a system class, anything else = declared by this object)
    u16 element type (6 = string, 1 = integer)   u32 array descriptor (01 00 00 0d ...)   u32 element count
    08 00 01 00   u32   u32 address (compile-time, identifies the instance)   ... (40 bytes in all)

It appears twice: first directly after the element strings (NUL-terminated UTF-16, in order), then in front of a table
of 8-byte entries (string offset | 0x80000000, type word).  Two arrays with the same values share the strings: the
second one is decoded through its offset table.  The strings of an object stand in control order, so the readable
strings in front of an array (`context`) tell which control it belongs to; the source generator does that matching.

Output: {object: [{"type", "count", "values", "offset", "decoded", "context"}, ...]} in file order.
"""
import glob
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pbd_lib as P

REC = re.compile(rb'(..)(..)\x01\x00\x00.(....)\x08\x00\x01\x00.{4}(....)', re.S)
NUL = bytes(2)
# a readable UTF-16 string of three or more characters with its terminator
TEXT = re.compile(rb'(?:[\x20-\x7e]\x00){3,}\x00\x00')


def _string_back(b, k):
    """the NUL-terminated UTF-16 string that ends at offset k (k points behind its terminator): (text, start) or None"""
    if b[k - 2:k] != NUL:
        return None
    k -= 2
    s = k
    while s >= 2 and b[s - 2:s] != NUL:
        s -= 2
    try:
        return b[s:k].decode('utf-16le'), s
    except UnicodeDecodeError:
        return None


def _skip_padding(b, k):
    return k - 2 if b[k - 2:k] == NUL and b[k - 4:k - 2] == NUL else k


def strings_before(b, end, count):
    """`count` strings that end right before offset `end`"""
    k, out = _skip_padding(b, end), []
    for _ in range(count):
        r = _string_back(b, k)
        if r is None:
            return None
        out.append(r[0])
        k = r[1]
    return out[::-1]


def context_before(b, end, count, want=4):
    """the readable strings in front of an array's own strings: values of the same or of the preceding control"""
    k, out, steps = _skip_padding(b, end), [], 0
    while steps < count + 40 and len(out) < want and k >= 4:
        r = _string_back(b, k)
        if r is None:
            break
        text, k = r
        steps += 1
        if steps <= count:
            continue
        text = ''.join(ch for ch in text if ch.isprintable() and ord(ch) < 0x3000)
        if len(text) >= 2:
            out.append(text)
    return out[::-1]


def arrays_of(b):
    """array instances the object declares, in file order"""
    first, twin, order = {}, {}, []
    for m in REC.finditer(b):
        marker, dt = struct.unpack('<HH', m.group(1) + m.group(2))
        count = struct.unpack('<I', m.group(3))[0]
        if marker == 0xffff or dt not in (6, 1) or count > 100000:
            continue
        key = (dt, m.group(4))
        if key not in first:
            first[key] = (m.start(), count)
            order.append(key)
        elif key not in twin:
            twin[key] = m.start()
    # the offset table of an array names its strings by their offset in the object's string pool (identical strings are
    # stored once, so an array's strings need not stand in front of it).  The pool's position in the file is found from
    # the arrays whose strings do stand in front of them: file offset of the first string - its pool offset.
    tables, votes = {}, {}
    for key in order:
        start, count = first[key]
        if key in twin and count:
            base = twin[key] + 40
            tables[key] = [struct.unpack_from('<I', b, base + 8 * i)[0] for i in range(count) if base + 8 * i + 4 <= len(b)]
        if key[0] == 6 and count and len(tables.get(key, [])) == count:
            k = _skip_padding(b, start)
            pos = []
            for _ in range(count):
                r = _string_back(b, k)
                if r is None:
                    pos = None
                    break
                pos.append(r[1])
                k = r[1]
            if pos:
                first_string = pos[-1]
                delta = first_string - (tables[key][0] & 0x7fffffff)
                votes[delta] = votes.get(delta, 0) + 1
    pool = max(votes, key=votes.get) if votes else None
    # check the vote against every offset of every table; if it does not explain them, try each string start of the
    # object as the position of one reference offset and keep the base under which the most offsets hit a string start
    sample = sorted({o & 0x7fffffff for k, t in tables.items() if k[0] == 6 for o in t if o & 0x80000000})

    def score(base):
        good = 0
        for o in sample[:400]:
            s = base + o
            if 2 <= s < len(b) - 2 and b[s - 2:s] == NUL and b[s:s + 2] != NUL:
                good += 1
        return good

    if sample and (pool is None or score(pool) < min(len(sample), 400)):
        ref = sample[0]
        best, best_score = pool, score(pool) if pool is not None else -1
        for s in range(2, len(b) - 2, 2):
            if b[s - 2:s] == NUL and b[s:s + 2] != NUL:
                sc = score(s - ref)
                if sc > best_score:
                    best, best_score = s - ref, sc
        pool = best

    def pool_string(off):
        if pool is None or not off & 0x80000000:
            return None
        s = pool + (off & 0x7fffffff)
        e = s
        while e + 2 <= len(b) and b[e:e + 2] != NUL:
            e += 2
        try:
            text = b[s:e].decode('utf-16le')
        except UnicodeDecodeError:
            return None
        return text if all(ch.isprintable() or ch in '\t\r\n' for ch in text) else None

    out = []
    for key in order:
        dt = key[0]
        start, count = first[key]
        offsets = tables.get(key, [])
        values = None
        if not count:
            values = []
        elif dt == 6 and len(offsets) == count:
            got = [pool_string(o) for o in offsets]
            values = got if all(v is not None for v in got) else None
        elif dt == 1 and len(offsets) == count:
            values = [struct.unpack('<i', struct.pack('<I', o))[0] for o in offsets]
        end = (twin[key] + 40 + 8 * count) if key in twin else start + 40
        out.append({'type': dt, 'count': count, 'values': values if values is not None else [], 'offset': start,
                    'decoded': values is not None,
                    # readable strings of the object in front of / behind this array (texts of the controls around it)
                    'context': [m.group(0)[:-2].decode('utf-16le') for m in TEXT.finditer(b, max(0, start - 8000), start)][-16:],
                    'after': [m.group(0)[:-2].decode('utf-16le') for m in TEXT.finditer(b, end, min(len(b), end + 8000))][:16]})
    return out


def main(app, out):
    res, total, bad = {}, 0, 0
    for f in sorted(glob.glob(os.path.join(app, '*.pbd'))):
        d = open(f, 'rb').read()
        for e in P.entries(d):
            name, _, ext = e['name'].rpartition('.')
            if ext not in ('win', 'udo'):
                continue
            arr = arrays_of(P.read_obj(d, e))
            if arr:
                res[name.lower()] = arr
                total += sum(1 for a in arr if a['type'] == 6 and a['count'])
                bad += sum(1 for a in arr if not a['decoded'])
    json.dump(res, open(out, 'w', encoding='utf-8'), indent=0, ensure_ascii=False)
    print('objects', len(res), '| string arrays with values', total, '| not decoded', bad)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
