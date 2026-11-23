"""Parse the memory snapshot of one routine (``mem`` / ``mem_addr`` / ``code_off`` from pcode_export.py).

A routine is a doubly linked list of heap chunks:  [next u32][prev u32][tag u16][flags u16][heap u32] + data; the tag is only
the size class. Chunks are recognised by content:
  * name table      : 16 bytes of UTF-16 spaces, then packed NUL-terminated UTF-16 strings; the *reference table* additionally
                      holds, between the names, 8-byte records addressed by the instruction operands (see Routine.ref)
  * local records   : 0x14-byte records  [u32 0][u16 0xffff,u16 0][u32 name offset][u32 slot][u32 type word]
  * line table      : [u32 count] then (line u16, byte offset u16) pairs
  * fix-up list     : (offset u32, kind u16, 1 u16) - the offsets of all records of the reference table
Every routine owns, in this order, a locals-name table (possibly empty) and a reference table.
"""
import base64, struct

NUL2 = bytes(2)
SPACES = b' \x00' * 7 + NUL2


class Routine:
    def __init__(self, r):
        self.r = r
        self.m = base64.b64decode(r['mem'])
        self.base = r['mem_addr']
        self.code_off = r['code_off']
        self.chunks = []                       # (hdr_off, data_off, end_off)
        self._walk()
        self.name_chunks = [c for c in self.chunks if self.m[c[1]:c[1] + 16] == SPACES]
        self._find_locals()

    # --- raw access
    def u16(self, o):
        return struct.unpack_from('<H', self.m, o)[0]

    def u32(self, o):
        return struct.unpack_from('<I', self.m, o)[0]

    def _walk(self):
        m, b = self.m, self.base
        off = self.code_off - 0x10                          # header of the code chunk
        seen = set()
        while 0 <= off < len(m) - 16 and off not in seen:
            seen.add(off)
            nxt = self.u32(off)
            end = (nxt - b) if b <= nxt < b + len(m) and nxt - b > off else len(m)
            self.chunks.append((off, off + 16, end))
            if end >= len(m):
                break
            off = end

    def cstr(self, o):
        """NUL-terminated UTF-16 string at memory offset o"""
        m = self.m
        e = o
        while e + 2 <= len(m) and m[e:e + 2] != NUL2:
            e += 2
        return m[o:e].decode('utf-16-le', 'replace')

    # --- local variables
    def _starts(self, nd, end):
        """offsets (relative to the data start) of the packed strings of a name table"""
        out, o = set(), nd + 16
        while o + 2 <= end:
            if self.m[o:o + 2] == NUL2:
                o += 2
                continue
            out.add(o - nd)
            o += 2 * len(self.cstr(o)) + 2
        return out

    def _find_locals(self):
        self.locals = []                        # dicts: name, slot, type
        nc = self.name_chunks
        self.locals_names = nc[0][1] if nc else None
        self.refs = nc[1][1] if len(nc) > 1 else None
        if self.locals_names is None:
            return
        starts = self._starts(self.locals_names, nc[0][2])
        if not starts:
            return
        for hdr, data, end in self.chunks:
            if self.m[data:data + 16] == SPACES or end - data < 0x14:
                continue
            n = 0
            while data + 0x14 * (n + 1) <= end and self.u32(data + 0x14 * n) == 0 and self.u16(data + 0x14 * n + 4) == 0xffff \
                    and self.u16(data + 0x14 * n + 6) == 0 and self.u32(data + 0x14 * n + 8) in starts:
                n += 1
            if n:
                for i in range(n):
                    o = data + 0x14 * i
                    self.locals.append({'name': self.cstr(self.locals_names + self.u32(o + 8)), 'slot': self.u32(o + 12),
                                        'type': self.u32(o + 16)})
                return

    # --- reference table
    def ref(self, off):
        """record at operand offset: ('field', name, idx, type) | ('func', name, id) | None"""
        if self.refs is None or self.refs + off + 8 > len(self.m):
            return None
        a, b = self.u32(self.refs + off), self.u32(self.refs + off + 4)
        if a & 0xc0000000 == 0xc0000000 and b < 0x10000:                    # function / event record
            return ('func', self.cstr(self.refs + b), a & 0x3fffffff)
        if a < 0x10000 and a >= 16:
            return ('field', self.cstr(self.refs + a), b & 0xffff, b >> 16)
        return None

    def string(self, off):
        if self.refs is None:
            return None
        return self.cstr(self.refs + off)


def describe(r):
    R = Routine(r)
    print(r['name'], 'hdr', r['header'], 'code_off', r['code_off'], 'len', len(R.m),
          'locals', [(l['name'], hex(l['type']), l['slot']) for l in R.locals])
    return R
