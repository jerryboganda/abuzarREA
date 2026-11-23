"""Prototype tables of the *unlinked* class images stored in the .pbd files.

Calls to global functions are linked as `PUSH_FUNC_CLASS [id, type]`; `id` is the index of the call's prototype record
in the calling class's prototype table, and the original table (still in the .pbd) names it. In the runtime image the
global-function records are gone, in the file they are not.

A prototype table = a name table (16 bytes of UTF-16 spaces, then packed NUL-terminated names; events start with '+')
followed by 0x14-byte records [u32 flags][u32 0xffff][u32 name offset][u32 arg info][u32 type word, high half 0xC0xx].
"""
import re, struct, sys, os, glob, json

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pbd_lib as P

SP = (b' \x00' * 7) + bytes(2)


def name_starts(raw, t, limit=120000):
    """packed names after the space header at t -> {offset relative to t: name}, end offset"""
    out, o, end = {}, t + 16, min(len(raw), t + limit)
    while o + 2 <= end:
        if raw[o:o + 2] == bytes(2):
            o += 2
            if raw[o:o + 2] == bytes(2) and o > t + 16:         # two NULs in a row: names are over
                break
            continue
        e = o
        while e + 2 <= end and raw[e:e + 2] != bytes(2):
            c = raw[e] | raw[e + 1] << 8
            if not (32 <= c < 0x250):
                return out, o
            e += 2
        out[o - t] = raw[o:e].decode('utf-16le')
        o = e + 2
    return out, o


def prototype_tables(raw):
    """-> list of tables, each a list of record names in record order (None where the name offset is unknown)"""
    tables = []
    for m in re.finditer(re.escape(SP), raw):
        t = m.start()
        names, end = name_starts(raw, t)
        if not names:
            continue
        # records follow within a short distance, at any 2-byte alignment
        for a in range(max(t + 16, end - 24), min(len(raw) - 20, end + 40), 2):
            n = 0
            while a + 20 * (n + 1) <= len(raw):
                w = struct.unpack_from('<5I', raw, a + 20 * n)
                if w[1] == 0xffff and w[2] in names and (w[4] >> 16) & 0xff00 == 0xc000 or \
                        (w[1] == 0xffff and w[2] in names and w[4] >> 24 == 0xc0):
                    n += 1
                else:
                    break
            if n:
                recs = [names[struct.unpack_from('<I', raw, a + 20 * i + 8)[0]] for i in range(n)]
                tables.append(recs)
                break
    return tables


def pbd_tables(pbd):
    d = open(pbd, 'rb').read()
    out = {}
    for e in P.entries(d):
        out[e['name']] = prototype_tables(P.read_obj(d, e))
    return out


if __name__ == '__main__':
    r = pbd_tables(sys.argv[1])
    for k, v in r.items():
        if len(sys.argv) < 3 or sys.argv[2].lower() in k.lower():
            print(k)
            for t in v:
                print('   ', t)
