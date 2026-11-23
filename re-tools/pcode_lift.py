"""Lift the p-code of one routine to a flat list of statements (expression trees) with jump markers.

The stack machine, as observed:
  * every PUSH_* pushes one entry; calls leave their receiver and arguments where they are and push the result on top,
    POP_N_TIMES n then removes the n entries *below* the top; FREE_* are memory bookkeeping only
  * ASSIGN_* pop value + lvalue, LVALUE_EXPR / POP_FREE / FREE_POP / POP_POP / FREE_FREE pop a discarded result
  * JUMP operands are byte offsets from the start of the code (instruction word index * 2)
Expression nodes are tuples (see render()).
"""
import re, struct, base64, json, collections
import pcode_blocks as PB

# constants have no slot in an object: member numbers skip them.  0xc9 = constant the class declares, 0xd9 = constant it
# inherits (found 2026-11-23 on n_smtp: with 0xd9 counted, every variable after the inherited constants got the name of
# an earlier member; 10 classes)
CONSTANT_ATTRS = (0xc9, 0xd9)

PRIM = {1: 'integer', 2: 'long', 3: 'real', 4: 'double', 5: 'decimal', 6: 'string', 7: 'boolean', 8: 'any',
        9: 'unsignedinteger', 10: 'unsignedlong', 11: 'blob', 12: 'date', 13: 'time', 14: 'datetime', 16: 'procedure', 18: 'char',
        20: 'longlong'}

# vtable of system classes seen in linked calls (from the runtime): 16503 = powerobject
SYSCLS_FUNCS = {16503: {0: 'create', 1: 'destroy', 2: 'classname', 3: 'postevent', 4: 'postevent', 5: 'postevent',
                        6: 'postevent', 7: 'postevent', 8: 'postevent', 9: 'triggerevent', 10: 'triggerevent',
                        11: 'triggerevent', 12: 'triggerevent', 13: 'triggerevent', 14: 'triggerevent', 15: 'typeof',
                        16: 'getparent', 17: 'getcontextservice', 18: 'getclassdefinition'}}

BINOP = {'ADD': '+', 'SUB': '-', 'MULT': '*', 'DIV': '/', 'MOD': 'mod', 'POWER': '^', 'EQ': '=', 'NE': '<>', 'LT': '<',
         'GT': '>', 'LE': '<=', 'GE': '>='}
FUNC1 = {'UPPER': 'upper', 'LOWER': 'lower', 'LEN_STRING': 'len', 'LEN_BINARY': 'len', 'INT': 'int', 'LOG': 'log',
         'LOGTEN': 'logten', 'ISNULL': 'isnull', 'ISVALID': 'isvalid', 'ISNUMBER': 'isnumber', 'ISDATE': 'isdate',
         'ISTIME': 'istime', 'RAND_LONG': 'rand', 'CEILING': 'ceiling', 'CEILING_ANY': 'ceiling'}
FUNC2 = {'MIN_LONG': 'min', 'MAX_LONG': 'max'}
MEMMGMT = {'TRANSFORM_BOUNDED_TO_BOUNDED', 'FREE_REF_PAK_N', 'FREE_NODE_N', 'CALC_UNBOUNDED_ARRAY_BOUND', 'CALC_SIMPLE_ARRAY_BOUND', 'ENTER_EMBEDDED',
           'EXIT_EMBEDDED', 'FREE_INV_METH_ARGS', 'TRANSFORM_UNBOUNDED_TO_UNBOUNDED', 'ARRAY_BOUND_INFO'}
DISCARD = {'POP_FREE', 'FREE_POP', 'POP_POP', 'FREE_FREE'}
CALLS = {'DOTFUNCCALL', 'DOTFUNCCALL_ANY', 'DOTFUNCCALL_DOUBLE', 'DOTFUNCCALL_DEC'}
CLASSCALLS = {'CLASS_CALL', 'CLASS_CALL_DEC', 'CLASS_CALL_DOUBLE', 'CLASS_CALL_ANY'}


def s16(v):
    return v - 0x10000 if v >= 0x8000 else v


def s32(lo, hi):
    v = lo | (hi << 16)
    return v - (1 << 32) if v >= (1 << 31) else v


def dec_text(raw):
    """PowerBuilder decimal constant: 12-byte little-endian mantissa, then [pad, pad, sign, scale]"""
    if len(raw) < 16:
        return '0'
    mant = int.from_bytes(raw[:12], 'little')
    sign, scale = raw[14], raw[15]
    txt = str(mant).rjust(scale + 1, '0')
    txt = (txt[:-scale] + '.' + txt[-scale:]) if scale else txt
    return ('-' if sign else '') + txt


def pbstr(s):
    return '"' + s.replace('~', '~~').replace('"', '~"').replace('\r', '~r').replace('\n', '~n').replace('\t', '~t') + '"'


class Unbalanced(Exception):
    pass


def call_modifiers(flags):
    """call-mode operand of DOTFUNCCALL*: bit0 = post, bit1 = dynamic, bit2 = event (evidence: ue_postopen/ue_close are 5 = post event
    when called from open events, 4 = direct event call from clicked; mf_initsecurityapp on a generic menu is 2 = dynamic)"""
    words = []
    if flags & 2:
        words.append('dynamic')
    if flags & 1:
        words.append('post')
    if flags & 4:
        words.append('event')
    return ' '.join(words) + ' ' if words else ''


class Lifter:
    def __init__(self, obj, ctx, routine, owner_class):
        self.obj, self.ctx, self.rt = obj, ctx, routine
        self.R = PB.Routine(routine) if (routine.get('mem') or routine.get('ext')) else None
        self.owner = owner_class
        self.stack = []
        self.items = []                       # ('s', byte, stmt) | ('j', byte, kind, target, cond) | ('ret', byte)
        self.problems = []
        self.cur = 0

    # ---------------------------------------------------------------- symbols
    def local(self, i):
        L = self.R.locals if self.R else []
        if 0 <= i < len(L):
            return L[i]['name']
        self.problems.append('local %d' % i)
        return 'local_%d' % i

    def shared_name(self, n):
        """shared / global variable n of this object's group: entry 0 is the object's own global instance variable"""
        tab = (getattr(self.ctx, 'shared', None) or {}).get(self.obj.get('name'))
        if tab and 0 <= n < len(tab) and tab[n][0]:
            return tab[n][0]
        if n == 0:
            return self.obj.get('name') or 'shared_0'
        self.problems.append('shared %d' % n)
        return 'shared_%d' % n

    def glob(self, slot):
        for l in (self.R.locals if self.R else []):
            if l['slot'] == slot and (l['type'] & 0xc0) == 0x40:
                return l['name'].lstrip(':') if l['name'].startswith('::') and False else l['name']
        self.problems.append('globref %d' % slot)
        return 'glob_%d' % slot

    def class_of_type(self, t):
        if t < 0x8000:                                   # system class / enumeration ids
            return (getattr(self.ctx, 'systypes', None) or {}).get(str(t))
        c = self.obj.get('classes', {}).get(str(t))
        return c['name'] if c else None

    def local_class(self, name):
        for l in (self.R.locals if self.R else []):
            if l['name'] == name:
                t = l['type'] >> 16
                if t >= 0x8000:
                    return self.class_of_type(t)
        return None

    def memref(self, off):
        rec = self.R.ref(off) if self.R else None
        if rec is None:
            self.problems.append('ref %d' % off)
            return ('mref', 'ref_%d' % off, -1, 0)
        if rec[0] == 'field':
            return ('mref', rec[1], rec[2], rec[3])
        return ('mref', rec[1], rec[2], -2)

    def field_by_type(self, idx, typ):
        """member of an object whose class is unknown: the (index, declared type) pair is usually unique among system classes"""
        rev = getattr(self.ctx, '_rev_fields', None)
        if rev is None:
            rev = self.ctx._rev_fields = {}
            for cname, tab in (getattr(self.ctx, 'classfields', None) or {}).items():
                for i, f in enumerate([f for f in tab[1:] if f[2] not in CONSTANT_ATTRS]):
                    rev.setdefault((i, f[1]), collections.Counter())[f[0]] += 1
        c = rev.get((idx, typ))
        if c:
            top = c.most_common(2)
            if len(top) == 1 or top[0][1] > 2 * top[1][1]:
                return top[0][0]
        return None

    def field_name(self, cls, idx):
        """member of a system / foreign class by index: usable fields = table[1:] without constants"""
        tab = self.ctx.classfields.get(cls) if cls else None
        if not tab:
            return None
        usable = [f for f in tab[1:] if f[2] not in CONSTANT_ATTRS]
        return usable[idx][0] if 0 <= idx < len(usable) else None

    # ---------------------------------------------------------------- stack
    def push(self, e):
        self.stack.append(e)

    def pop(self):
        if not self.stack:
            self.problems.append('underflow@%d' % self.cur)
            return ('const', '<?>')
        return self.stack.pop()

    def emit(self, stmt):
        self.items.append(('s', self.cur, stmt))
        if self.stack:
            self.problems.append('leak@%d:%d' % (self.cur, len(self.stack)))
            del self.stack[:]

    def static_class(self, e):
        k = e[0]
        if k == 'this':
            return self.owner
        if k == 'var':
            return self.local_class(e[1]) or (getattr(self.ctx, 'gtypes', None) or {}).get(e[1])
        if k == 'mem':
            return e[3] if len(e) > 3 else None
        if k == 'idx':                                   # element of an array of objects: same class as the array member
            return self.static_class(e[1])
        if k == 'cast':
            return self.static_class(e[2])
        return None

    # ---------------------------------------------------------------- main
    def run(self):
        ins = self.rt['instrs']
        if self.R is None:
            self.problems.append('nomem')
        for pos, (w, op, a) in enumerate(ins):
            self.cur = w * 2
            self.step(ins, pos, op, a)
        return self.items

    def step(self, ins, pos, op, a):
        P = self.push
        if op == 'PUSH_THIS':
            P(('this',))
        elif op == 'PUSH_PARENT':
            P(('parent', 1))
        elif op == 'PUSH_NTH_PARENT':
            P(('parent', a[0]))
        elif op == 'PUSH_CONST_REF':
            P(self.memref(a[0]))
        elif op in ('DOT', 'DOT_LV', 'DOT_DOUBLE', 'DOT_DEC', 'DOT_ANY'):
            m, o = self.pop(), self.pop()
            name, cls = m[1], None
            if m[0] != 'mref':
                self.problems.append('dot-noref@%d' % self.cur)
                name = '?'
            else:
                cls = self.static_class(o)
                if not name:
                    name = self.field_name(cls, m[2]) or self.field_by_type(m[2], m[3]) or 'field%d' % m[2]
                cls = self.class_of_type(m[3]) if m[3] and m[3] >= 0x4000 else None
            P(('mem', o, name, cls))
        elif op == 'PUSH_CONST_LONG' or op == 'PUSH_CONST_ULONG':
            P(('const', str(s32(a[0], a[1]) if op == 'PUSH_CONST_LONG' else a[0] | a[1] << 16)))
        elif op == 'PUSH_CONST_INT':
            P(('const', str(s16(a[0]))))
        elif op == 'PUSH_CONST_UINT':
            P(('const', str(a[0])))
        elif op == 'PUSH_CONST_BOOL':
            P(('const', 'true' if a[0] else 'false'))
        elif op == 'PUSH_CONST_STRING':
            txt = self.R.string(a[0]) if self.R else None
            if txt is None:
                self.problems.append('string %d' % a[0])
            P(('const', pbstr(txt if txt is not None else '?')))
        elif op == 'PUSH_CONST_FLOAT':
            P(('const', repr(struct.unpack('<f', struct.pack('<I', a[0] | a[1] << 16))[0])))
        elif op == 'PUSH_CONST_DOUBLE':
            raw = self.R.raw(a[0], 8) if self.R else b''
            P(('const', repr(struct.unpack('<d', raw)[0]) if len(raw) == 8 else '0.0'))
        elif op == 'PUSH_CONST_DEC':
            P(('const', dec_text(self.R.raw(a[0], 16) if self.R else b'')))
        elif op == 'PUSH_CONST_DATE':
            raw = self.R.raw(a[0], 8) if self.R else b''
            if len(raw) == 8:
                # {u32 time part, i16 year-1900, u8 month-1, u8 day}: 00000000ffff0b1e = 1899-12-30, 000000000000011c = 1900-02-28
                P(('const', 'date("%04d-%02d-%02d")' % (1900 + struct.unpack_from('<h', raw, 4)[0], raw[6] + 1, raw[7])))
            else:
                P(('const', 'date(%s)' % raw.hex()))
        elif op == 'PUSH_CONST_ENUM':
            tab = self.obj.get('enums', {}).get(str(a[1])) or {}
            nm = tab.get(str(a[0]))
            P(('const', (nm + '!') if nm else 'enum_%d_%d' % (a[1], a[0])))
        elif op.startswith('PUSH_LOCAL_VAR') or op in ('PUSH_LOCAL_ARGREF', 'PUSH_LOCAL_ARGREF_LV', 'PUSH_LOCAL_ARGREF_DOUBLE'):
            P(('var', self.local(a[0])))
        elif op.startswith('PUSH_LOCAL_GLOBREF'):
            P(('var', self.glob(a[0])))
        elif op.startswith('PUSH_SHARED_VAR') or op.startswith('PUSH_SHARED_GLOBREF'):
            P(('var', self.shared_name(a[0])))
        elif op == 'PUSH_RESULT':
            if self.pending_result is not None:
                P(self.pending_result)
                self.pending_result = None
            else:
                self.problems.append('result@%d' % self.cur)
                P(('const', '<result>'))
        elif op in CALLS:
            self.do_dotcall(op, a)
        elif op == 'PUSH_FUNC_CLASS':
            P(('desc', a[0], a[1]))
        elif op in CLASSCALLS:
            self.do_classcall(op, a)
        elif op == 'EVENTCALL':
            self.do_eventcall(a)
        elif op == 'POP_N_TIMES':
            n = a[0]
            if len(self.stack) < n:
                self.problems.append('popn-underflow@%d' % self.cur)
                del self.stack[:]
            elif n:
                del self.stack[len(self.stack) - n:]
            if self.pending_result is not None:
                P(self.pending_result)
                self.pending_result = None
        elif op in MEMMGMT or op.startswith('COPY_') or op.startswith('CONV_'):
            pass
        elif op.startswith('CNV_'):
            m = re.match(r'CNV_([A-Z]+)_TO_([A-Z]+)$', op)
            e = self.pop()
            P(('cast', m.group(2).lower(), e) if m else e)
        elif op in DISCARD:
            e = self.pop()
            if e[0] != 'dead':
                self.emit(('expr', e))
        elif op == 'LVALUE_EXPR':
            self.emit(('expr', self.pop()))
        elif op.startswith('ASSIGN_'):
            v, lv = self.pop(), self.pop()
            self.emit(('assign', lv, v))
        elif op.startswith('ADDASSIGN_') or op.startswith('SUBASSIGN_'):
            v, lv = self.pop(), self.pop()
            self.emit(('assign', lv, ('bin', '+' if op.startswith('ADD') else '-', lv, v)))
        elif op.startswith('INCR_') or op.startswith('DECR_'):
            lv = self.pop()
            self.emit(('assign', lv, ('bin', '+' if op.startswith('INCR') else '-', lv, ('const', '1'))))
        elif op == 'STORE_RETURN_VAL':
            self.emit(('return', self.pop() if a[0] else None))
        elif op == 'RETURN':
            self.items.append(('ret', self.cur))
        elif op in ('JUMP', 'JUMPFALSE', 'JUMPTRUE'):
            cond = self.pop() if op != 'JUMP' else None
            self.items.append(('j', self.cur, op, a[0], cond))
            if self.stack:
                self.problems.append('leak-jump@%d:%d' % (self.cur, len(self.stack)))
                del self.stack[:]
        elif op == 'CREATE' or op == 'CREATE_EXT_OBJ':
            rec = self.R.ref(a[0]) if self.R else None
            cname = self.class_of_type(rec[2]) if rec and rec[0] == 'field' else None
            P(('create', cname or (rec[1] if rec else '?')))
        elif op == 'CREATE_USING':
            P(('createusing', self.pop()))
        elif op == 'DESTROY':
            self.emit(('destroy', self.pop()))
        elif op == 'AND' or op == 'OR':
            b, x = self.pop(), self.pop()
            P(('bin', op.lower(), x, b))
        elif op == 'NOT':
            P(('un', 'not', self.pop()))
        elif op.startswith('NEGATE_'):
            P(('un', '-', self.pop()))
        elif op in ('CAT_STRING', 'CAT_BINARY'):
            # appends the top operand to the one below it *in place*; the consumed operand is popped by a later POP_*
            if len(self.stack) >= 2:
                self.stack[-2] = ('bin', '+', self.stack[-2], self.stack[-1])
                self.stack[-1] = ('dead',)
            else:
                self.problems.append('cat-underflow@%d' % self.cur)
        elif op == 'BLOB':                                 # blob(text [, encoding]): operand 1 = argument count
            n = max(1, min(a[1], len(self.stack)))
            P(('fn', 'blob', [self.pop() for _ in range(n)][::-1]))
        elif op in FUNC1:
            P(('fn', FUNC1[op], [self.pop()]))
        elif op in FUNC2:
            b, x = self.pop(), self.pop()
            P(('fn', FUNC2[op], [x, b]))
        elif op.startswith('ABS_'):
            P(('fn', 'abs', [self.pop()]))
        elif op == 'CALC_COMPLEX_ARRAY_BOUND':
            ub, lb, ix = self.pop(), self.pop(), self.pop()
            prev = self.pop() if a[2] else None
            P(('dims', (prev[1] if prev and prev[0] == 'dims' else []) + [ix]))
        elif op == 'DOT_FLD_UPDATE_INDEX_RP':
            ix, m, o = self.pop(), self.pop(), self.pop()
            P(('idx', ('mem', o, m[1] if m[0] == 'mref' else '?', None), ix))
        elif op in ('INDEX', 'INDEX_LV', 'INDEX_RP', 'INDEX_ERR_CHK', 'INDEX_ERR_CHK_ANY', 'INDEX_ERR_CHK_DBL', 'INDEX_ERR_CHK_DEC',
                    'INDEX_DEC', 'INDEX_DOUBLE'):
            i, arr = self.pop(), self.pop()
            P(('idx', arr, i))
        elif op == 'UPPERBOUND':
            P(('fn', 'upperbound', [self.pop()]))
        elif op in ('BUILD_UNBOUNDED_ARRAYLIST', 'BUILD_BOUNDED_ARRAYLIST'):
            n = a[2]                                    # element count (bounded: [type, flags, n, n, 0])
            els = [self.pop() for _ in range(min(n, len(self.stack)))][::-1]
            P(('arr', els))
        elif op.startswith('DB'):
            self.do_db(op, a)
        elif op == 'DUP_STACKED_LVALUE':
            k = a[0]
            if len(self.stack) >= k:
                P(self.stack[-k])
        elif op in ('PUSH_TRY', 'POP_TRY', 'CATCH_EXCEPTION', 'GOSUB', 'RETURN_SUB', 'HALT'):
            self.items.append(('misc', self.cur, op, list(a)))
        elif op.startswith('EQ_') or op.startswith('NE_') or re.match(r'^(ADD|SUB|MULT|DIV|MOD|POWER|LT|GT|LE|GE)_', op):
            b, x = self.pop(), self.pop()
            P(('bin', BINOP[op.split('_')[0]], x, b))
        else:
            self.problems.append('op:' + op)
            self.items.append(('misc', self.cur, op, list(a)))

    pending_result = None

    # ---------------------------------------------------------------- calls
    def do_dotcall(self, op, a):
        rec = self.R.ref(a[0]) if self.R else None
        name = rec[1] if rec and rec[0] == 'func' else 'func_%d' % a[0]
        if rec is None:
            self.problems.append('callref %d' % a[0])
        argc = a[2]
        if len(self.stack) < argc + 1:
            self.problems.append('call-underflow@%d' % self.cur)
            self.pending_result = ('call', None, name, [])
            return
        args = self.stack[len(self.stack) - argc:] if argc else []
        recv = self.stack[len(self.stack) - argc - 1]
        self.pending_result = ('call', recv, call_modifiers(a[3] if len(a) > 3 else 0) + name, list(args))

    def proto_name(self, cn, fid):
        """name of prototype `fid` of class `cn` (looking through the ancestors)"""
        protos = getattr(self.ctx, 'protos', None) or {}
        anc = getattr(self.ctx, 'ancestor', None) or {}
        seen = 0
        while cn and seen < 12:
            e = protos.get(cn, {}).get(str(fid))
            if e:
                return e[0]
            cn, seen = anc.get(cn), seen + 1
        return None

    def do_classcall(self, op, a):
        d = self.pop()
        if d[0] != 'desc':
            self.problems.append('classcall-nodesc@%d' % self.cur)
            self.push(('call', None, 'cc_%d' % a[0], []))
            return
        fid, cls = d[1], d[2]
        argc = a[1]
        args = self.stack[len(self.stack) - argc:] if argc and len(self.stack) >= argc else []
        if cls == 16592:
            rec = self.ctx.sysf.get(str(fid))
            name = rec[0] if rec else 'sysfunc_%d' % fid
            self.pending_result = ('fn', name, list(args))
        else:
            cn = self.class_of_type(cls)
            # global-function / ancestor-function reference: the id is an index into a link table that is not kept in memory
            nm = SYSCLS_FUNCS.get(cls, {}).get(fid) or (self.rt.get('_fnrefs') or {}).get(str(fid))
            self.pending_result = ('call', None, ('post ' if len(a) > 2 and a[2] & 1 else '') + (nm or 'gfunc_%d' % fid), list(args), cn)

    def do_eventcall(self, a):
        """[event id, argc, ancestor class, 16, 0]: the compiler's `call super::<this event>(args)`"""
        argc = a[1]
        args = self.stack[len(self.stack) - argc:] if argc and len(self.stack) >= argc else []
        self.pending_result = ('call', ('var', 'super'), self.rt.get('name') or 'event_%d' % a[0], list(args))

    # ---------------------------------------------------------------- database
    SQLKW = re.compile(r'\s*(select|insert|update|delete|execute|exec|declare|call|open|fetch|close|with|create|drop|alter|truncate|set|if|begin|\{)', re.I)

    def _raw_text(self, pool, off):
        """SQL text of the statement record at pool offset `off`: direct block (text pointer at +0x18) or an op record whose
        +8 points at the block (text pointer at block+0x1c); None when neither yields SQL"""
        def utf16(ptr):
            ptr &= 0x7fffffff
            e = ptr
            while e + 2 <= len(pool) and pool[e:e + 2] != bytes(2):
                e += 2
            return pool[ptr:e].decode('utf-16-le', 'replace') if 0 < ptr < len(pool) else ''
        for fn in (lambda: utf16(struct.unpack_from('<I', pool, off + 0x18)[0]),
                   lambda: utf16(struct.unpack_from('<I', pool, (struct.unpack_from('<I', pool, off + 8)[0] & 0x7fffffff) - 4 + 0x1c)[0])):
            try:
                t = fn()
            except (struct.error, ValueError):
                continue
            if self.SQLKW.match(t) and len(t) > 8:
                return t
        return None

    def _bases(self):
        """statements of an ancestor-typed operand (DBSELECT [off, 0x8000 + k, ...], k != 0) sit in a second section of the same
        pool: find, per type word, the base that makes every such offset a valid statement record"""
        if hasattr(self, '_basecache'):
            return self._basecache
        cache = getattr(self.ctx, '_bases_by_obj', None)
        if cache is None:
            cache = self.ctx._bases_by_obj = {}
        key = self.obj.get('name')
        if key in cache:
            self._basecache = cache[key]
            return cache[key]
        pool = self._pool(0x8000)
        offs = {}

        def walk(n):
            for r in n['routines']:
                for w, op, a in r['instrs']:
                    if op in ('DBSELECT', 'DBUPDATE', 'DBINSERT', 'DBDELETE', 'DBFETCH', 'DBSELECTBLOB', 'DBUPDATEBLOB') and a[1] != 0x8000:
                        offs.setdefault(a[1], set()).add(a[0])
            for c in n['controls']:
                walk(c)
        walk(self.obj)
        bases = {}
        if pool and offs:
            # every position that looks like a statement block start (text pointer at +0x18)
            starts = []
            for m in range(0, len(pool) - 0x20, 4):
                v = struct.unpack_from('<I', pool, m)[0]
                if v & 0x80000000 and (v & 0x7fffffff) < len(pool) - 8 and self._raw_text(pool, m - 0x18):
                    starts.append(m - 0x18)
            for q in range(4, len(pool) - 0x10, 4):          # op records: +4 holds a pointer to (record - 4)
                v = struct.unpack_from('<I', pool, q + 4)[0]
                if v & 0x80000000 and (v & 0x7fffffff) == q - 4 and self._raw_text(pool, q):
                    starts.append(q)
            starts = sorted(set(starts))
            for typ, os_ in offs.items():
                best, best_n = None, 0
                for lo in sorted(os_)[:3]:                       # anchor on one of the first offsets
                    for st in starts:
                        base = st - lo
                        if base < 0:
                            continue
                        n = sum(1 for o in os_ if self._raw_text(pool, base + o) is not None)
                        if n > best_n:
                            best, best_n = base, n
                            if n == len(os_):
                                break
                    if best_n == len(os_):
                        break
                if best is not None and best_n * 10 >= len(os_) * 8:
                    bases[typ] = best
        cache[key] = bases
        self._basecache = bases
        return bases

    def sql_text(self, off, typ=0x8000):
        pool = self._pool(0x8000)
        if not pool:
            return None
        if typ != 0x8000:
            base = self._bases().get(typ)
            if base is not None:
                off += base
        return self._raw_text(pool, off) or None

    def _pool(self, typ=0x8000):
        if not hasattr(self, '_poolb'):
            sp = self.obj.get('sqlpool')
            self._poolb = base64.b64decode(sp['b64']) if sp else b''
        return self._poolb

    def do_db(self, op, a):
        """embedded-SQL ops.  Stack (bottom -> top): [INTO variables] [cursor / statement variable] [binds] transaction;
        for cursor and dynamic ops ENTER_EMBEDDED / EXIT_EMBEDDED merely bracket the transaction operand."""
        kind = op[2:].lower()
        if op in ('DBSELECT', 'DBSELECTBLOB', 'DBSELECTCLOB'):
            nbind, ninto = a[2], a[3]
            tr = self.pop()
            binds = [self.pop() for _ in range(nbind)][::-1]
            intos = [self.pop() for _ in range(ninto)][::-1]
            self.emit(('sql', 'select', self.sql_text(a[0], a[1]), intos, binds, tr))
        elif op in ('DBUPDATE', 'DBINSERT', 'DBDELETE', 'DBUPDATEWITHCURS', 'DBDELETEWITHCURS'):
            tr = self.pop()
            binds = [self.pop() for _ in range(a[2])][::-1]
            self.emit(('sql', kind, self.sql_text(a[0], a[1]), [], binds, tr))
        elif op in ('DBUPDATEBLOB', 'DBUPDATECLOB'):
            tr = self.pop()
            binds = [self.pop() for _ in range(a[2] + 1)][::-1]            # n where-binds and the blob itself
            self.emit(('sql', kind, self.sql_text(a[0], a[1]), [], binds, tr))
        elif op == 'DBFETCH':
            tr, name = self.pop(), self.pop()
            intos = [self.pop() for _ in range(a[2])][::-1]
            self.emit(('sql', 'fetch', self.sql_text(a[0], a[1]), intos, [], tr, name))
        elif op == 'DBOPEN':
            args = [self.pop() for _ in range(a[0])][::-1]
            tr, name = self.pop(), self.pop()
            self.emit(('sql', 'open', None, [], args, tr, name))
        elif op == 'DBCLOSE':
            tr, name = self.pop(), self.pop()
            self.emit(('sql', 'close', None, [], [], tr, name))
        elif op == 'DBEXECUTE':
            args = [self.pop() for _ in range(a[0])][::-1]
            tr, name = self.pop(), self.pop()
            self.emit(('sql', 'execute', None, [], args, tr, name))
        elif op == 'DBEXECUTEIMMED':
            tr, text = self.pop(), self.pop()
            self.emit(('sql', 'execute immediate', None, [], [text], tr))
        elif op in ('DBCOMMIT', 'DBROLLBACK', 'DBSTART', 'DBSTOP'):
            self.emit(('sql', kind, None, [], [], self.pop()))
        else:
            self.problems.append('db:' + op)
            self.items.append(('misc', self.cur, op, list(a)))


# ------------------------------------------------------------------- rendering
# PB_POWERSCRIPT=1: write text the PowerBuilder compiler accepts (used for the regenerated source in recovered/scripts_pb);
# without it the output stays as the rebuild's interpreter reads it
POWERSCRIPT = bool(__import__('os').environ.get('PB_POWERSCRIPT'))
PREC = {'or': 1, 'and': 2, 'not': 3, '=': 4, '<>': 4, '<': 4, '>': 4, '<=': 4, '>=': 4, '+': 5, '-': 5, '*': 6, '/': 6,
        'mod': 6, '^': 7}


def render(e, prec=0):
    k = e[0]
    if k == 'const':
        return e[1]
    if k == 'var':
        return e[1]
    if k == 'this':
        return 'this'
    if k == 'parent':
        return '.'.join(['parent'] * e[1])
    if k == 'mref':
        return e[1]
    if k == 'mem':
        o = e[1]
        if POWERSCRIPT and o[0] == 'parent' and o[1] >= 2:
            # a member of the window (or menu) reached from a nested control: the source names it without a qualifier and
            # the compiler finds it through the enclosing object; `parent.parent` is not PowerScript
            return e[2]
        if POWERSCRIPT and o[0] == 'mem' and (o[2] == 'borderstyle' or (o[2] == 'name' and not render(o[1], 9).endswith('object'))):
            # `<datawindow>.object.<column>`: when the class of the variable is not known, the member index of `object`
            # is printed with the name another class has at that index (borderstyle, name)
            return '%s.object.%s' % (render(o[1], 9), e[2])
        base = render(o, 9)
        return '%s.%s' % (base, e[2])
    if k == 'call' and e[1] is not None:
        n_, a_ = e[2], e[3]
        if n_ == '__get_attribute_item' and len(a_) >= 3 and a_[0][0] == 'const':
            rows = a_[2][1] if a_[2][0] == 'arr' else [a_[2]]
            return '%s.%s[%s]' % (render(e[1], 9), a_[0][1].strip('"'), ', '.join(render(x) for x in rows))
        if POWERSCRIPT and n_ == '__invoke_method' and len(a_) >= 3 and a_[0][0] == 'const':
            # OLE automation call: `<object>.<method>(<arguments>)`
            items = a_[2][1] if a_[2][0] == 'arr' else [a_[2]]
            return '%s.%s(%s)' % (render(e[1], 9), a_[0][1].strip('"'), ', '.join(render(x) for x in items))
        if n_ == '__get_attribute' and a_ and a_[0][0] == 'const':
            return '%s.%s' % (render(e[1], 9), a_[0][1].strip('"'))
    if k == 'call':
        args = ', '.join(render(x) for x in e[3])
        if e[1] is None or e[1] == ('this',):
            return '%s(%s)' % (e[2], args)
        if POWERSCRIPT and e[1][0] == 'parent' and e[1][1] >= 2:
            return '%s(%s)' % (e[2], args)             # function of the enclosing window / menu, called without a qualifier
        if e[1] == ('var', 'super'):
            return 'super::%s(%s)' % (e[2], args)
        return '%s.%s(%s)' % (render(e[1], 9), e[2], args)
    if k == 'fn':
        return '%s(%s)' % (e[1], ', '.join(render(x) for x in e[2]))
    if k == 'bin':
        if e[1] == 'mod' and POWERSCRIPT:
            # PowerScript has no infix modulo: the compiled MOD comes from the function Mod(x, y)
            return 'mod(%s, %s)' % (render(e[2]), render(e[3]))
        p = PREC.get(e[1], 5)
        s = '%s %s %s' % (render(e[2], p), e[1], render(e[3], p + 1))
        return '(' + s + ')' if p < prec else s
    if k == 'un':
        s = '%s %s' % (e[1], render(e[2], 8)) if e[1] == 'not' else '-%s' % render(e[2], 8)
        return '(' + s + ')' if prec > 3 else s
    if k == 'cast':
        return render(e[2], prec)
    if k == 'dims':
        return ', '.join(render(x) for x in e[1])
    if k == 'idx':
        return '%s[%s]' % (render(e[1], 9), render(e[2]))
    if k == 'arr':
        return '{' + ', '.join(render(x) for x in e[1]) + '}'
    if k == 'create':
        return 'create ' + e[1]
    if k == 'createusing':
        return 'create using ' + render(e[1])
    if k == 'desc':
        return '<desc %s/%s>' % (e[1], e[2])
    return '<%s>' % k
