"""Structure the flat statement list produced by pcode_lift.Lifter (if / else / while / loops / return / exit / goto)
and print PowerScript-like source.

The compiler emitted structured code, so the jump patterns are regular:
    if c then A end if          cond; JUMPFALSE L;  A;                     L:
    if c then A else B          cond; JUMPFALSE L1; A; JUMP L2;  L1: B;    L2:
    do while c  B  loop         L0: cond; JUMPFALSE L1; B; JUMP L0;        L1:
    do  B  loop while c         L0: B; cond; JUMPTRUE L0
"""
import bisect, os
from pcode_lift import render, PRIM, POWERSCRIPT

# PB_LEGACY_STRUCT=1: the if-structuring as it was before the 2026-11-23 corrections (to measure what they change)
LEGACY_STRUCT = os.environ.get('PB_LEGACY_STRUCT') == '1'


NEG = {'=': '<>', '<>': '=', '<': '>=', '>=': '<', '>': '<=', '<=': '>'}


def neg(c):
    if c[0] == 'un' and c[1] == 'not':
        return c[2]
    if c[0] == 'bin' and c[1] in NEG:
        return ('bin', NEG[c[1]], c[2], c[3])
    return ('un', 'not', c)


class Structurer:
    def __init__(self, items, final_ret_pos=None):
        self.I = [x for x in items]
        self.pos = [x[1] for x in self.I]
        # position of the closing RETURN (the target of every `return`)
        self.end_pos = None
        for x in self.I:
            if x[0] == 'ret':
                self.end_pos = x[1]
        self.loops = []
        self.back_tail, self.done_tails = {}, set()
        for q, it in enumerate(self.I):                # conditional jumps that go backwards
            if it[0] == 'j' and it[2] in ('JUMPTRUE', 'JUMPFALSE') and bisect.bisect_left(self.pos, it[3]) <= q:
                self.back_tail.setdefault(bisect.bisect_left(self.pos, it[3]), q)
        self.gotos = set()
        self.labels = set()
        self.label_at = set()        # positions that get a `Lnnn:` label (PowerScript mode, second pass)
        self.issues = []
        self._args = (items, final_ret_pos)

    def tgt(self, T):
        return bisect.bisect_left(self.pos, T)

    def run(self):
        body = self._run()
        if POWERSCRIPT:
            # a jump that fits no structured statement is written as `goto Lnnn`; the compiler needs the label too:
            # structure once more with a label placed at every position such a goto names
            targets = goto_targets(body)
            if targets:
                again = Structurer(*self._args)
                again.label_at = targets
                body = again._run()
                self.issues = again.issues + ['goto without label L%d' % t for t in sorted(goto_targets(body) - again.labels)]
            body = trim_unreachable(body)
        return body

    def _run(self):
        n = len(self.I)
        # drop the trailing RETURN
        if n and self.I[-1][0] == 'ret':
            n -= 1
        stmts = self.block(0, n)
        for T in self.label_at:                  # a target at the very end of the routine
            if T not in self.labels and self.tgt(T) >= n:
                self.labels.add(T)
                stmts.append(('label', T))
        body = inline_casevars(fold_choose(stmts))
        return trim_returns(collapse_epilogue(body))

    # -------------------------------------------------------------------- helpers
    def is_jump(self, i, kind=None):
        x = self.I[i]
        return x[0] == 'j' and (kind is None or x[2] == kind)

    def block(self, i0, i1):
        out = []
        i = i0
        while i < i1:
            x = self.I[i]
            k = x[0]
            if self.label_at:
                # a jump target may lie between two statements: the label goes before the first statement at or after it
                for T in self.label_at:
                    if T not in self.labels and self.tgt(T) == i:
                        self.labels.add(T)
                        out.append(('label', T))
            tail = self.back_tail.get(i)
            if tail is not None and tail < i1 and tail not in self.done_tails:
                # `do ... loop while c`: a conditional jump back to this item closes the loop
                self.done_tails.add(tail)
                kind, cond = self.I[tail][2], self.I[tail][4]
                self.loops.append((i, tail + 1))
                body = self.block(i, tail)
                self.loops.pop()
                out.append(('dowhile', body, cond if kind == 'JUMPTRUE' else neg(cond)))
                i = tail + 1
                continue
            if k == 's':
                st = x[2]
                # `return expr` is STORE_RETURN_VAL followed by a JUMP to the final RETURN: keep one statement
                if st[0] == 'return' and i + 1 < len(self.I) and self.is_jump(i + 1, 'JUMP') \
                        and self.I[i + 1][3] == self.end_pos:
                    out.append(st)
                    i += 2
                    continue
                out.append(st)
                i += 1
            elif k == 'ret':
                out.append(('return', None))
                i += 1
            elif k == 'misc' and x[2] == 'PUSH_TRY':
                i = self.try_block(i, out)
            elif k == 'misc' and x[2] == 'POP_TRY':
                i += 1
            elif k == 'misc' and x[2] == 'HALT':
                out.append(('halt', x[3][0]))
                i += 1
            elif k == 'misc':
                out.append(('misc', x[2], x[3]))
                i += 1
            else:
                i = self.jump(i, i1, out)
        # a trailing jump to the instruction right after this region is a fall-through
        while out and out[-1][0] == 'goto' and self.tgt(out[-1][1]) == i1:
            out.pop()
        # an unconditional jump right after return/exit/continue/goto can never run
        res = []
        for st in out:
            if res and res[-1][0] in ('return', 'exit', 'continue', 'goto') and st[0] != 'label':
                continue                      # unreachable (a label makes what follows reachable again)
            res.append(st)
        return res

    def jump(self, i, i1, out):
        _, pos, kind, T, cond = self.I[i]
        t = self.tgt(T)
        if kind == 'JUMP':
            f = self.for_loop(i, t, out)
            if f is not None:
                return f
            out.append(self.jump_stmt(T))
            return i + 1
        if kind == 'JUMPTRUE' and t > i:                 # `if not c then A [else B]`: same shape as JUMPFALSE
            kind, cond = 'JUMPFALSE', neg(cond)
        if kind == 'JUMPFALSE' and t > i:
            # `if A then if B then X`: consecutive guards with the same exit were written as one `A and B`.
            # PowerScript evaluates BOTH sides of `and` (no short circuit), so that is not the same program: B (a function
            # call, a member of an object that A has just tested) would run although A is false.  A compiled `and` is one
            # AND instruction, never two jumps, so two jumps are always two nested ifs: kept as such in PowerScript mode
            # (found 2026-11-23: `Null object reference` in w_sale.tab_retrieve.selectionchanging of the rebuilt program)
            while (LEGACY_STRUCT or not POWERSCRIPT) and i + 1 < len(self.I) and self.I[i + 1][0] == 'j' \
                    and self.I[i + 1][2] == 'JUMPFALSE' and self.tgt(self.I[i + 1][3]) == t:
                cond = ('bin', 'and', cond, self.I[i + 1][4])
                i += 1
            if t > i1:                                   # leaves the enclosing region: guard + jump
                # JUMPFALSE jumps when the condition is FALSE.  Until 2026-11-23 the guard was written with the condition
                # as it stands (`if c then <jump>`), i.e. inverted
                if os.environ.get('PB_GUARD_TRACE'):
                    out.append(('misc', 'GUARDJUMP', [pos, T]))
                if LEGACY_STRUCT:
                    out.append(('if', cond, [self.jump_stmt(T)], None))
                else:
                    out.append(('if', neg(cond), [self.jump_stmt(T)], None))
                return i + 1
            last = self.I[t - 1] if t - 1 > i else None
            if last is not None and last[0] == 'j' and last[2] == 'JUMP':
                U = last[3]
                u = self.tgt(U)
                if LEGACY_STRUCT and U == self.end_pos:  # then-part ends with a return; the rest is the continuation
                    pair = t - 2 > i and self.I[t - 2][0] == 's' and self.I[t - 2][2][0] == 'return'
                    then = self.block(i + 1, t if pair else t - 1)       # `return x` = STORE_RETURN_VAL + that JUMP
                    # with `pair` the JUMP belongs to a `return x` inside the block (possibly inside a nested if), so there
                    # is no further return here: adding one made the routine leave where the original falls through
                    # (e.g. on to the next round of the enclosing loop)
                    if not pair and not (then and then[-1][0] == 'return'):
                        then.append(('return', None))
                    out.append(('if', cond, then, None))
                    return t
                if LEGACY_STRUCT and u > t:
                    then = self.block(i + 1, t - 1)
                    if u <= i1:                          # if / else
                        els = self.block(t, u)
                        out.append(('if', cond, then, els))
                        return u
                    if not (then and then[-1][0] in ('return', 'exit', 'continue', 'goto')):
                        then.append(self.jump_stmt(U))   # the jump leaves the enclosing region (exit / continue / goto)
                    out.append(('if', cond, then, None))
                    return t
                if not LEGACY_STRUCT and U != self.end_pos and t < u <= i1:           # if / else
                    then = self.block(i + 1, t - 1)
                    els = self.block(t, u)
                    out.append(('if', cond, then, els))
                    return u
                # a then-part that ends with a jump out (return / exit / continue / goto) keeps that jump INSIDE its block:
                # a nested `if` whose end is the same place (`if A then ... if B then ... exit end if end if`) is then an
                # ordinary nested if.  Cut one instruction short, as before, the nested if "left the region" and was
                # written as an (inverted) guard + goto
                if u <= i:                               # loop: the closing jump goes back to (or before) the condition
                    self.loops.append((u, t))
                    body = self.block(i + 1, t - 1)
                    self.loops.pop()
                    out.append(('while', cond, body))
                    return t
            then = self.block(i + 1, t)
            out.append(('if', cond, then, None))
            return t
        if kind == 'JUMPTRUE' and t <= i:                # do ... loop while cond
            # the loop body is everything already emitted back to index t: re-structure by rewinding
            out.append(('dowhile_tail', cond, T))
            return i + 1
        if kind == 'JUMPFALSE' and t <= i:               # do ... loop until cond
            out.append(('dountil_tail', cond, T))
            return i + 1
        if kind == 'JUMPTRUE' and t > i:                 # if not cond then ... (rare) : jump over when true
            then = self.block(i + 1, min(t, i1))
            out.append(('if', ('un', 'not', cond), then, None))
            return min(t, i1)
        self.issues.append('jump %s %s' % (kind, T))
        out.append(('misc', kind, [T]))
        return i + 1

    def try_block(self, i, out):
        """PUSH_TRY [catch, end]; body; JUMP end; catch: (CATCH_EXCEPTION; JUMPFALSE next; handler; JUMP end)...; end: POP_TRY"""
        I = self.I
        c, e = I[i][3][0], I[i][3][1]
        tc, te = self.tgt(c), self.tgt(e)
        if not (i < tc <= te < len(I) + 1):
            out.append(('misc', 'PUSH_TRY', I[i][3]))
            return i + 1
        end_body = tc - 1 if tc - 1 > i and I[tc - 1][0] == 'j' and I[tc - 1][2] == 'JUMP' else tc
        body = self.block(i + 1, end_body)
        clauses, j = [], tc
        while j < te:
            if I[j][0] == 'misc' and I[j][2] == 'CATCH_EXCEPTION' and j + 1 < te and I[j + 1][0] == 'j' and I[j + 1][2] == 'JUMPFALSE':
                var = I[j + 1][4]
                nxt = self.tgt(I[j + 1][3])
                stop = nxt - 1 if nxt - 1 > j + 1 and I[nxt - 1][0] == 'j' and I[nxt - 1][2] == 'JUMP' else nxt
                handler = self.block(j + 2, min(stop, te))
                # the handler's own jump to the end of the try statement is its normal end, not a goto
                if POWERSCRIPT and handler and handler[-1][0] == 'goto' and self.tgt(handler[-1][1]) >= te:
                    handler.pop()
                clauses.append((var, handler))
                j = max(nxt, j + 2)
            else:
                break
        fin = []
        if j < te:
            # finally subroutine: POP_TRY; <statements>; JUMP end; RETURN_SUB  (entered through the GOSUB at `end`)
            k2 = j
            if I[k2][0] == 'misc' and I[k2][2] == 'POP_TRY':
                k2 += 1
            stop = te
            for q in range(k2, te):
                if I[q][0] == 'misc' and I[q][2] == 'RETURN_SUB':
                    stop = q
                    break
            fin = self.block(k2, stop)
            fin = [x for x in fin if x[0] not in ('return', 'goto') or (x[0] == 'return' and x[1] is not None)]
        out.append(('try', body, clauses, fin))
        nxt = te
        while nxt < len(I) and I[nxt][0] == 'misc' and I[nxt][2] in ('GOSUB', 'POP_TRY'):
            nxt += 1
        return nxt

    def jump_stmt(self, T):
        t = self.tgt(T)
        if T == self.end_pos:
            return ('return', None)
        # a jump to a lone `return x` (shared epilogue) is that return
        if t < len(self.I) and self.I[t][0] == 's' and self.I[t][2][0] == 'return' and t + 1 < len(self.I)                 and self.I[t + 1][0] == 'j' and self.I[t + 1][2] == 'JUMP' and self.I[t + 1][3] == self.end_pos:
            return self.I[t][2]
        if self.loops and t == self.loops[-1][1]:
            return ('exit',)
        if self.loops and t == self.loops[-1][0]:
            return ('continue',)
        # a jump to the loop's own closing jump goes round the loop as well
        if POWERSCRIPT and self.loops and t == self.loops[-1][1] - 1 and t < len(self.I) and self.I[t][0] == 'j' \
                and self.I[t][2] == 'JUMP':
            return ('continue',)
        # a jump that lands on another unconditional jump goes where that one goes (jump threading)
        if POWERSCRIPT and t < len(self.I) and self.I[t][0] == 'j' and self.I[t][2] == 'JUMP' and self.I[t][3] != T \
                and getattr(self, '_thread', 0) < 6:
            self._thread = getattr(self, '_thread', 0) + 1
            try:
                return self.jump_stmt(self.I[t][3])
            finally:
                self._thread -= 1
        self.gotos.add(T)
        return ('goto', T)

    def for_loop(self, i, c, out):
        """init; JUMP Lcond; Lincr: v = v +/- s; Lcond: if limit >= v ...; body; JUMP Lincr  ==>  for v = init to limit step s"""
        I = self.I
        if not (i + 1 < c < len(I) - 1 and c - 1 > i):
            return None
        inc, cond = I[c - 1], I[c]
        if not (inc[0] == 's' and inc[2][0] == 'assign' and cond[0] == 'j' and cond[2] == 'JUMPFALSE'):
            return None
        var, val = inc[2][1], inc[2][2]
        if not (val[0] == 'bin' and val[1] in '+-' and val[2] == var and val[3][0] == 'const'):
            return None
        t = self.tgt(cond[3])
        back = I[t - 1] if t - 1 > c else None
        if not (back and back[0] == 'j' and back[2] == 'JUMP' and self.tgt(back[3]) == c - 1):
            return None
        if not (out and out[-1][0] == 'assign' and out[-1][1] == var):
            return None
        init = out.pop()[2]
        c2 = cond[4]
        if c2[0] != 'bin' or c2[1] not in ('>=', '<=', '>', '<'):
            out.append(('assign', var, init))
            return None
        # the compared copy of the loop variable is often widened (CNV_INT_TO_LONG ...): compare without the casts, or the limit is read as the variable itself
        def bare(e):
            while isinstance(e, tuple) and e and e[0] == 'cast':
                e = e[2]
            return e
        limit = c2[2] if bare(c2[3]) == var else c2[3]
        step = val[3][1] if val[1] == '+' else '-' + val[3][1]
        self.loops.append((c - 1, t))
        body = self.block(c + 1, t - 1)
        self.loops.pop()
        # a jump from an inner loop to this loop's increment (`continue` of the outer loop) has no statement of its own:
        # its label stands at the end of the body, right before `next`
        for T in self.label_at:
            if T not in self.labels and self.tgt(T) in (c - 1, t - 1):
                self.labels.add(T)
                body.append(('label', T))
        out.append(('for', var, init, limit, step, body))
        return t

    def else_has_code(self, t, i1):
        return any(self.I[k][0] != 'ret' for k in range(t, min(i1, len(self.I))))



import re as _re2
_CASEVAR = _re2.compile(r'^?case\d+$')


def _is_casevar(e):
    return e[0] == 'var' and _CASEVAR.match(e[1]) is not None


def uncast(e):
    while e[0] == 'cast':
        e = e[2]
    return e


def uncast_cond(c):
    """drop implicit conversions inside a comparison tree"""
    if c[0] == 'bin':
        return ('bin', c[1], uncast_cond(c[2]), uncast_cond(c[3]))
    return uncast(c)


def _mentions(e, var):
    if e == var:
        return True
    if isinstance(e, (tuple, list)):
        return any(_mentions(x, var) for x in e)
    return False


def _subst(e, var, val):
    if e == var:
        return val
    if isinstance(e, tuple):
        return tuple(_subst(x, var, val) for x in e)
    if isinstance(e, list):
        return [_subst(x, var, val) for x in e]
    return e


def inline_casevars(stmts):
    """compiler temporaries of `choose case` that survived (condition mixed with other tests): put the selector expression back"""
    out = list(stmts)
    i = 0
    while i < len(out):
        st = out[i]
        if st[0] == 'assign' and _is_casevar(st[1]):
            var, val = st[1], st[2]
            rest = [_subst(x, var, val) for x in out[i + 1:]]
            out = out[:i] + rest
            continue
        i += 1
    res = []
    for st in out:
        if isinstance(st, tuple):
            st = tuple(inline_casevars(x) if isinstance(x, list) and x and all(isinstance(y, tuple) and y and isinstance(y[0], str) for y in x) else x for x in st)
        res.append(st)
    return res


def _fused(ifst, var):
    """`if <selector = label> and <other test> then ... end if` (no else): one `case label` whose body is `if <other test>`"""
    c = ifst[1]
    return ifst[3] is None and c[0] == 'bin' and c[1] == 'and' and case_labels(c[2], var) is not None and not _mentions(c[3], var)


def case_labels(c, var):
    """condition of one `case` arm on the selector variable -> list of label texts, or None"""
    c = uncast_cond(c)
    if c[0] == 'bin' and c[1] == '=':
        if c[3] == var and not _mentions(c[2], var):
            return [render(c[2])]
        if c[2] == var and not _mentions(c[3], var):
            return [render(c[3])]
    if c[0] == 'bin' and c[1] == 'or':
        a, b = case_labels(c[2], var), case_labels(c[3], var)
        return a + b if a is not None and b is not None else None
    if c[0] == 'bin' and c[1] == 'and':
        lo = hi = None
        for x in (c[2], c[3]):
            if x[0] == 'bin' and x[2] == var and x[1] == '>=':
                lo = render(x[3])
            elif x[0] == 'bin' and x[3] == var and x[1] == '<=':
                lo = render(x[2])
            elif x[0] == 'bin' and x[2] == var and x[1] == '<=':
                hi = render(x[3])
            elif x[0] == 'bin' and x[3] == var and x[1] == '>=':
                hi = render(x[2])
        if lo is not None and hi is not None:
            return ['%s to %s' % (lo, hi)]
    if c[0] == 'bin' and c[1] in ('<', '<=', '>', '>='):
        if c[2] == var:
            return ['is %s %s' % (c[1], render(c[3]))]
        if c[3] == var:
            flip = {'<': '>', '<=': '>=', '>': '<', '>=': '<='}[c[1]]
            return ['is %s %s' % (flip, render(c[2]))]
    return None


def fold_choose(stmts):
    """`casenn = expr; if casenn = 1 ... elseif casenn = 2 ...`  ->  choose case expr"""
    out = []
    i = 0
    while i < len(stmts):
        st = stmts[i]
        if st[0] == 'assign' and _is_casevar(st[1]) and i + 1 < len(stmts) and stmts[i + 1][0] == 'if':
            var, arms, els, cur, ok = st[1], [], None, stmts[i + 1], True
            while cur is not None:
                lab = case_labels(cur[1], var)
                if lab is None and cur[3] is None and cur[1][0] == 'bin' and cur[1][1] == 'and':
                    lab1 = case_labels(cur[1][2], var)
                    if lab1 is not None and not _mentions(cur[1][3], var):
                        arms.append((lab1, [('if', cur[1][3], fold_choose(cur[2]), None)]))
                        cur = None
                        break
                if lab is None:
                    ok = False
                    break
                arms.append((lab, fold_choose(cur[2])))
                e = cur[3]
                if e is None:
                    cur = None
                elif len(e) == 1 and e[0][0] == 'if' and (case_labels(e[0][1], var) is not None or _fused(e[0], var)):
                    cur = e[0]
                else:
                    els, cur = fold_choose(e), None
            if ok and arms:
                j = i + 2
                # arms that end in `return` split the compiler's if-chain into separate ifs: they are further arms of the same choose
                while els is None and j < len(stmts) and stmts[j][0] == 'if' and stmts[j][3] is None and always_returns(arms[-1][1]):
                    lab = case_labels(stmts[j][1], var)
                    if lab is not None:
                        arms.append((lab, fold_choose(stmts[j][2])))
                    elif _fused(stmts[j], var):
                        arms.append((case_labels(stmts[j][1][2], var), [('if', stmts[j][1][3], fold_choose(stmts[j][2]), None)]))
                    else:
                        break
                    j += 1
                arms = [(l, _subst(b, var, st[2])) for l, b in arms]
                els = _subst(els, var, st[2]) if els is not None else None
                out.append(('choose', st[2], arms, els))
                i = j
                continue
        out.append(fold_inner(st))
        i += 1
    return out


MSG_RET = ('mem', ('var', '::message'), 'returnvalue', None)


def collapse_epilogue(stmts):
    """`if not isvalid(::message) then return 0 end if; return ::message.returnvalue` is the compiler's event epilogue"""
    out = []
    for st in stmts:
        if st[0] == 'if':
            st = ('if', st[1], collapse_epilogue(st[2]), collapse_epilogue(st[3]) if st[3] is not None else None)
        elif st[0] == 'while':
            st = ('while', st[1], collapse_epilogue(st[2]))
        elif st[0] == 'for':
            st = st[:5] + (collapse_epilogue(st[5]),)
        elif st[0] == 'choose':
            st = ('choose', st[1], [(l, collapse_epilogue(b)) for l, b in st[2]], collapse_epilogue(st[3]) if st[3] is not None else None)
        out.append(st)
    res = []
    for st in out:
        if st[0] == 'return' and st[1] == MSG_RET and res and res[-1][0] == 'if' and res[-1][3] is None                 and res[-1][1] == ('un', 'not', ('fn', 'isvalid', [('var', '::message')]))                 and res[-1][2] == [('return', ('const', '0'))]:
            res.pop()
            res.append(('return', ('const', '::message.returnvalue')))
            continue
        res.append(st)
    return res


def always_returns(stmts):
    if not stmts:
        return False
    st = stmts[-1]
    if st[0] == 'return':
        return True
    if st[0] == 'if' and st[3] is not None:
        return always_returns(st[2]) and always_returns(st[3])
    return False


def _walk(stmts):
    """every statement of a structured body, nested ones included"""
    for st in stmts or []:
        yield st
        k = st[0]
        if k == 'if':
            yield from _walk(st[2])
            yield from _walk(st[3])
        elif k == 'while':
            yield from _walk(st[2])
        elif k == 'dowhile':
            yield from _walk(st[1])
        elif k == 'for':
            yield from _walk(st[5])
        elif k == 'try':
            yield from _walk(st[1])
            for _, b in st[2]:
                yield from _walk(b)
            yield from _walk(st[3] if len(st) > 3 else [])
        elif k == 'choose':
            for _, b in st[2]:
                yield from _walk(b)
            yield from _walk(st[3])


def goto_targets(stmts):
    return {st[1] for st in _walk(stmts) if st[0] == 'goto'}


def trim_unreachable(stmts):
    """PowerScript mode: a valueless `return` right after statements that always return can never run, and the compiler
    rejects it in a function that returns a value; drop it at every nesting level"""
    if stmts is None:
        return None
    out = []
    for st in stmts:
        if st[0] == 'return' and st[1] is None and out and always_returns(out):
            continue
        k = st[0]
        if k == 'if':
            st = ('if', st[1], trim_unreachable(st[2]), trim_unreachable(st[3]))
        elif k == 'while':
            st = ('while', st[1], trim_unreachable(st[2]))
        elif k == 'dowhile':
            st = ('dowhile', trim_unreachable(st[1]), st[2])
        elif k == 'for':
            st = st[:5] + (trim_unreachable(st[5]),)
        elif k == 'try':
            st = ('try', trim_unreachable(st[1]), [(v, trim_unreachable(b)) for v, b in st[2]],
                  trim_unreachable(st[3]) if len(st) > 3 else [])
        elif k == 'choose':
            st = ('choose', st[1], [(l, trim_unreachable(b)) for l, b in st[2]], trim_unreachable(st[3]))
        out.append(st)
    return out


def trim_returns(stmts):
    """drop a valueless `return` that can never run (after an exhaustive if/else) or that ends the routine"""
    out = []
    for st in stmts:
        if st[0] == 'return' and st[1] is None and out and always_returns(out):
            continue
        out.append(st)
    if out and out[-1][0] == 'return' and out[-1][1] is None:
        out.pop()
    return out


def fold_inner(st):
    k = st[0]
    if k == 'if':
        then, els = fold_choose(st[2]), fold_choose(st[3]) if st[3] is not None else None
        if not then and els:                           # `if c then (nothing) else B`  ->  `if not c then B`
            return ('if', neg(st[1]), els, None)
        return ('if', st[1], then, els)
    if k == 'while':
        return ('while', st[1], fold_choose(st[2]))
    if k == 'dowhile':
        return ('dowhile', fold_choose(st[1]), st[2])
    if k == 'for':
        return st[:5] + (fold_choose(st[5]),)
    if k == 'try':
        return ('try', fold_choose(st[1]), [(v, fold_choose(b)) for v, b in st[2]], fold_choose(st[3]) if len(st) > 3 else [])
    return st


# ------------------------------------------------------------------------- printing
def pstmt(st, ind, out, ctx=None):
    p = '\t' * ind
    k = st[0]
    if k == 'assign':
        out.append('%s%s = %s' % (p, render(st[1]), render(st[2])))
    elif k == 'expr':
        e = st[1]
        if e[0] == 'call' and e[1] is not None and e[2] == '__set_attribute_item' and len(e[3]) >= 4 and e[3][0][0] == 'const':
            rows = e[3][2][1] if e[3][2][0] == 'arr' else [e[3][2]]
            out.append('%s%s.%s[%s] = %s' % (p, render(e[1], 9), e[3][0][1].strip('"'), ', '.join(render(x) for x in rows),
                                             render(e[3][3])))
        elif e[0] == 'call' and e[1] is not None and e[2] == '__set_attribute' and len(e[3]) >= 2 and e[3][0][0] == 'const':
            out.append('%s%s.%s = %s' % (p, render(e[1], 9), e[3][0][1].strip('"'), render(e[3][1])))
        elif e[0] == 'call' and e[1] == ('var', 'super') and not e[3]:
            out.append('%scall super::%s' % (p, e[2]))
        else:
            out.append('%s%s' % (p, render(e)))
    elif k == 'return':
        out.append(p + ('return ' + render(st[1]) if st[1] is not None else 'return'))
    elif k == 'destroy':
        out.append('%sdestroy %s' % (p, render(st[1])))
    elif k == 'halt':
        out.append(p + ('halt close' if st[1] else 'halt'))
    elif k == 'exit':
        out.append(p + 'exit')
    elif k == 'continue':
        out.append(p + 'continue')
    elif k == 'goto':
        out.append('%sgoto L%d' % (p, st[1]))
    elif k == 'label':
        out.append('%sL%d:' % (p, st[1]))
    elif k == 'if':
        out.append('%sif %s then' % (p, render(st[1])))
        for s in st[2]:
            pstmt(s, ind + 1, out)
        els = st[3]
        while els is not None:
            if len(els) == 1 and els[0][0] == 'if':
                e = els[0]
                out.append('%selseif %s then' % (p, render(e[1])))
                for s in e[2]:
                    pstmt(s, ind + 1, out)
                els = e[3]
            else:
                out.append(p + 'else')
                for s in els:
                    pstmt(s, ind + 1, out)
                els = None
        out.append(p + 'end if')
    elif k == 'try':
        out.append(p + 'try')
        for x in st[1]:
            pstmt(x, ind + 1, out)
        for var, body in st[2]:
            out.append('%scatch (throwable %s)' % (p, render(var) if var is not None else '?'))
            for x in body:
                pstmt(x, ind + 1, out)
        if len(st) > 3 and st[3]:
            out.append(p + 'finally')
            for x in st[3]:
                pstmt(x, ind + 1, out)
        out.append(p + 'end try')
    elif k == 'choose':
        out.append('%schoose case %s' % (p, render(st[1])))
        for labels, body in st[2]:
            out.append('%scase %s' % (p, ', '.join(labels)))
            for x in body:
                pstmt(x, ind + 1, out)
        if st[3] is not None:
            out.append(p + 'case else')
            for x in st[3]:
                pstmt(x, ind + 1, out)
        out.append(p + 'end choose')
    elif k == 'dowhile':
        out.append(p + 'do')
        for x in st[1]:
            pstmt(x, ind + 1, out)
        out.append('%sloop while %s' % (p, render(st[2])))
    elif k == 'for':
        out.append('%sfor %s = %s to %s%s' % (p, render(st[1]), render(st[2]), render(st[3]),
                                              '' if st[4] == '1' else ' step ' + st[4]))
        for x in st[5]:
            pstmt(x, ind + 1, out)
        out.append(p + 'next')
    elif k == 'while':
        out.append('%sdo while %s' % (p, render(st[1])))
        for s in st[2]:
            pstmt(s, ind + 1, out)
        out.append(p + 'loop')
    elif k == 'sql':
        kind, text, intos, binds, tr = st[1], st[2], st[3], st[4], st[5]
        name = st[6] if len(st) > 6 else None
        out.append('%sSQL %s' % (p, sql_statement(kind, text, intos, binds, tr, name)))
    elif k == 'misc':
        out.append('%s// %s %s' % (p, st[1], st[2]))
    elif k in ('dowhile_tail', 'dountil_tail'):
        out.append('%s// %s %s -> %d' % (p, k, render(st[1]), st[2]))
    else:
        out.append('%s// ?%s' % (p, k))


import re as _re
# dummy literals the compiler leaves where a host variable was: 0 (numbers), ' ' (strings), {ts '...'} (dates/datetimes)
_PLACE = _re.compile(r"\{(?:ts|d|t) '[^']*'\}|(?<![\w.'])0(?![\w.'])|' '")


def _real_zero_score(text, m):
    """how likely a `0` token is a genuine literal rather than a bind (higher = more likely real)"""
    before, after = text[max(0, m.start() - 14):m.start()], text[m.end():m.end() + 8]
    if _re.search(r'(When|Then|Else)\s*$', before, _re.I) or _re.match(r'\s*(Then|Else|End)\b', after, _re.I):
        return 5                                                            # CASE branches / conditions
    if _re.search(r',\s*$', before) and _re.match(r'\s*\)', after):          # ISNULL(x, 0) / COALESCE(x, 0)
        return 5
    if _re.search(r'(<>|!=|>=|<=|>|<)\s*$', before):
        return 2
    if _re.search(r'(Top|Count\s*\()\s*$', before, _re.I):
        return 4
    return 0


def depth0_from(text):
    """index of the FROM that belongs to the outermost SELECT (not inside parentheses / sub-selects)"""
    depth = 0
    for m in _re.finditer(r"[()]|\bFROM\b", text, _re.I):
        g = m.group().upper()
        if g == '(':
            depth += 1
        elif g == ')':
            depth -= 1
        elif depth == 0:
            return m.start()
    return -1


def sql_statement(kind, text, intos, binds, tr, name=None):
    """SQL text with the host variables put back where the compiler left its dummy literals, in order of appearance.
    The compiled image does not record the positions; when the text has more dummy-looking tokens than binds the surplus
    are genuine zeros, picked by syntax (ISNULL fallbacks, CASE branches, comparisons with 0) and flagged `inferred`."""
    using = ' USING ' + render(tr) if tr is not None else ''
    if kind in ('open', 'close', 'execute') and name is not None:
        args = ' /* args: %s */' % ', '.join(render(b) for b in binds) if binds else ''
        return '%s %s%s;%s' % (kind.upper(), render(name), using, args)
    if kind == 'fetch':
        return 'FETCH %s INTO %s%s;' % (render(name), ', '.join(':' + render(x) for x in intos), using)
    if kind == 'execute immediate':
        return 'EXECUTE IMMEDIATE %s%s;' % (':' + render(binds[0]) if binds else '', using)
    if text is None:
        return '%s%s;' % (kind, using)
    names = [render(b) for b in binds]
    cands = list(_PLACE.finditer(text))
    note = ''
    if len(cands) > len(names):
        is_str = [_re.search(r'(^|[.])[lagri]?s_', n) is not None for n in names]
        strs = [c for c in cands if c.group() == "' '"]
        rest = [c for c in cands if c.group() != "' '"]
        gone, uncertain = set(), False

        def pick(group, want, score):
            nonlocal uncertain
            drop = len(group) - want
            if drop <= 0:
                return
            ranked = sorted(group, key=lambda c: (-score(c), -c.start()))
            for c in ranked[:drop]:
                gone.add(id(c))
            top = [score(c) for c in ranked[:drop]]
            nxt = score(ranked[drop]) if drop < len(ranked) else -1
            if min(top) == 0 or min(top) == nxt:
                uncertain = True

        def space_score(c):                               # `x + ' '` / `' ' + x`: a literal space
            b4, af = text[max(0, c.start() - 3):c.start()], text[c.end():c.end() + 3]
            return 3 if _re.search(r'\+\s*$', b4) and _re.match(r'\s*[,)+]', af) else 0

        pick(strs, sum(is_str), space_score)
        pick(rest, len(names) - sum(is_str), lambda c: _real_zero_score(text, c) if c.group() == '0' else 0)
        cands = [c for c in cands if id(c) not in gone]
        if uncertain:
            note = '   /* bind positions inferred */'
    if len(cands) == len(names):
        parts, last = [], 0
        for m, nm in zip(cands, names):
            parts.append(text[last:m.start()])
            parts.append(':' + nm)
            last = m.end()
        parts.append(text[last:])
        text = ''.join(parts)
    elif names:
        note = '   /* binds in order of appearance: %s */' % ', '.join(names)
    text = _re.sub(r'\s+', ' ', text).strip()
    if intos:
        f = depth0_from(text)
        into = ' INTO ' + ', '.join(':' + render(x) for x in intos)
        text = (text[:f].rstrip() + into + ' ' + text[f:]) if f >= 0 else text + into
    return '%s%s;%s' % (text, using, note)


def print_body(body, ind=0):
    out = []
    for st in body:
        pstmt(st, ind, out)
    return out


def local_type(l, classes):
    t = l['type'] >> 16
    if t >= 0x8000:
        c = classes.get(str(t))
        name = c['name'] if c else 'type_%x' % t
    else:
        name = PRIM.get(t & 0xff, 'type_%d' % (t & 0xff))
    if POWERSCRIPT and l.get('dims'):
        return name + array_bounds(bytes.fromhex(l['dims']))
    return name + ('[]' if (l['type'] >> 8) & 0x20 else '')


def array_bounds(d):
    """bounds descriptor -> `[]`, `[n]`, `[lo to hi]`, `[a, b]`: u8 dimensions, u8 flags (0x40 / 0x80 = fixed bounds),
    u16 type, then a (lower, upper) pair of u32 per dimension"""
    import struct
    nd, flags = d[0], d[1]
    if not flags & 0xc0 or nd < 1 or len(d) < 4 + 8 * nd:
        return '[]'
    parts = []
    for k in range(nd):
        lo, hi = struct.unpack_from('<ii', d, 4 + 8 * k)
        parts.append(str(hi) if lo == 1 else '%d to %d' % (lo, hi))
    return '[' + ', '.join(parts) + ']'
