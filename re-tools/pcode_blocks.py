"""Parse the memory snapshot of one routine (``mem`` / ``mem_addr`` / ``code_off`` / ``ext`` / ``names_order`` from pcode_export.py).

A routine is a doubly linked list of heap chunks:  [next u32][prev u32][tag u16][flags u16][heap u32] + data; the tag is only
the size class. Its descriptor chunks point (at +2 or +8) to the tables they describe, which may sit outside the window
(exported as ``ext``). Tables are recognised by content:
  * name table      : 16 bytes of UTF-16 spaces, then packed NUL-terminated UTF-16 strings; the *reference table* additionally
                      holds, between the names, 8-byte records addressed by the instruction operands (see Routine.ref)
  * local records   : 0x14-byte records  [u32 0][u16 0xffff,u16 0][u32 name offset][u32 slot][u32 type word]
  * line table      : [u32 count] then (line u16, byte offset u16) pairs
Every routine owns, in this order, a locals-name table (possibly empty) and a reference table.
"""
import base64, struct

NUL2 = bytes(2)
SPACES = b' ' + bytes(1)
SPACES = (b' ' + bytes(1)) * 7 + NUL2


class Tab:
    def __init__(self, data):
        self.m = data

    def cstr(self, o):
        m, e = self.m, o
        while e + 2 <= len(m) and m[e:e + 2] != NUL2:
            e += 2
        return m[o:e].decode('utf-16-le', 'replace')

    def u32(self, o):
        return struct.unpack_from('<I', self.m, o)[0]

    def starts(self):
        """offsets of the packed strings (relative to the table start)"""
        out, o = set(), 16
        while o + 2 <= len(self.m):
            if self.m[o:o + 2] == NUL2:
                o += 2
                continue
            out.add(o)
            o += 2 * len(self.cstr(o)) + 2
        return out


class Routine:
    def __init__(self, r):
        self.r = r
        self.m = base64.b64decode(r['mem']) if r.get('mem') else b''
        self.base = r.get('mem_addr', 0)
        self.code_off = r.get('code_off', 0x40)
        self.chunks = []                       # (hdr_off, data_off, end_off) - only when a window was exported
        if self.m:
            self._walk()
        blobs = {self.base + d: self.m[d:e] for _, d, e in self.chunks}
        for x in r.get('ext', []):
            blobs[x['addr']] = base64.b64decode(x['b64'])
        order = r.get('names_order') or [a for a, b in sorted(blobs.items()) if b[:16] == SPACES]
        self.tabs = [Tab(blobs[a]) for a in order if a in blobs]
        self.blobs = blobs
        self.line = base64.b64decode(r['line']) if r.get('line') else b''
        self._find_locals()

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

    def _find_locals(self):
        self.locals = []                        # dicts: name, slot, type
        self.lt = self.tabs[0] if self.tabs else None
        self.rt = self.tabs[1] if len(self.tabs) > 1 else None
        if self.lt is None:
            return
        starts = self.lt.starts()
        if not starts:
            if len(self.tabs) == 1 and len(self.lt.m) > 16:      # a lone table with content: the reference table
                self.rt, self.lt = self.lt, None
            return
        for addr, b in sorted(self.blobs.items()):
            if b[:16] == SPACES or len(b) < 0x14:
                continue
            n = 0
            u = lambda o: struct.unpack_from('<I', b, o)[0]
            while 0x14 * (n + 1) <= len(b) and u(0x14 * n) < 0x100 and u(0x14 * n + 8) in starts \
                    and (u(0x14 * n + 4) == 0xffff or 16 <= u(0x14 * n + 4) < len(self.lt.m)):
                n += 1
            if n:
                for i in range(n):
                    o = 0x14 * i
                    dims = None
                    if u(o + 4) != 0xffff:                          # array: offset of the bounds descriptor in the name table
                        # descriptor: number of dimensions (u8), flags (u8), type (u16), then (lower, upper) per dimension
                        nd = self.lt.m[u(o + 4)] if u(o + 4) < len(self.lt.m) else 1
                        dims = self.lt.m[u(o + 4):u(o + 4) + max(16, 4 + 8 * nd)].hex()
                    self.locals.append({'name': self.lt.cstr(u(o + 8)), 'slot': u(o + 12), 'type': u(o + 16), 'dims': dims})
                return
        if len(self.tabs) == 1:                                   # no locals: the lone table is the reference table
            self.rt, self.lt = self.lt, None

    # --- reference table
    def ref(self, off):
        """record at operand offset: ('field', name, idx, type) | ('func', name, id) | None"""
        t = self.rt
        if t is None or off + 8 > len(t.m):
            return None
        a, b = t.u32(off), t.u32(off + 4)
        if a & 0x80000000 and 16 <= b < 0x10000:                            # function (0xC...) / event (0x8...) record
            return ('func', t.cstr(b), a & 0x3fffffff)
        if 16 <= a < 0x10000:
            return ('field', t.cstr(a), b & 0xffff, b >> 16)
        return None

    def string(self, off):
        return self.rt.cstr(off) if self.rt else None

    @property
    def refs(self):                             # kept for callers that test "has a reference table"
        return 0 if self.rt else None

    def raw(self, off, n):
        return self.rt.m[off:off + n] if self.rt else b''
