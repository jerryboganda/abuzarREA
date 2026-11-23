"""Replay the Script.mdb migration chain (7,968 scripts) into a final, data-free schema.

usage: python -I db_rebuild.py <script_rows.jsonl> <out_dir>

Input is the `Script` table exported from Script.mdb as JSON lines
({"sequenceid", "date", "query"}). Output is written under <out_dir>:
schema/*.sql, seed/seed_ledger.sql, schema.json, unhandled.log.
Static replay only - nothing is executed against a database.
"""
import json, os, re, sys, collections

ID = r'(?:\[[^\]]+\]|"[^"]+"|\w+)'
QN = r'(?:%s\s*\.\s*)*%s' % (ID, ID)


def norm(name):
    name = name.strip().split('.')[-1].strip()
    return name.strip('[]"').strip()


def key(name):
    return norm(name).lower()


def strip_comments(s):
    s = re.sub(r'/\*.*?\*/', ' ', s, flags=re.S)
    return re.sub(r'--[^\n]*', ' ', s)


def squash(s):
    return re.sub(r'\s+', ' ', s).strip()


def balanced(s, i):
    """s[i] == '(' -> index just past the matching ')' (quote aware)."""
    depth, q = 0, None
    n = len(s)
    while i < n:
        c = s[i]
        if q:
            if c == q:
                q = None
        elif c in "'\"":
            q = c
        elif c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return n


def split_top(s, sep=','):
    out, depth, q, cur = [], 0, None, []
    for c in s:
        if q:
            cur.append(c)
            if c == q:
                q = None
            continue
        if c in "'\"":
            q = c
        elif c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
        if c == sep and depth == 0:
            out.append(''.join(cur))
            cur = []
        else:
            cur.append(c)
    if ''.join(cur).strip():
        out.append(''.join(cur))
    return out


OBJ_RX = re.compile(r'^(create|alter)\s+(proc(?:edure)?|function|view|trigger)\s+(%s)' % QN, re.I)
BOUNDARY = re.compile(
    r'\b(INSERT\s+(?:INTO\s+)?\w|EXEC(?:UTE)?\s|DROP\s+(?:TABLE|PROC|PROCEDURE|VIEW|INDEX|FUNCTION|TRIGGER)\b|'
    r'CREATE\s+(?:TABLE|PROC|PROCEDURE|VIEW|INDEX|UNIQUE|CLUSTERED|NONCLUSTERED|FUNCTION|TRIGGER)\b|'
    r'ALTER\s+(?:TABLE|PROC|PROCEDURE|VIEW|FUNCTION|TRIGGER)\b|UPDATE\s+\S+\s+SET\b|DELETE\s+(?:FROM\s+)?\w|'
    r'TRUNCATE\s|DECLARE\s+@|IF\s+(?:NOT\s+)?EXISTS\b|IF\s+@|SET\s+(?:ANSI|NOCOUNT|QUOTED|IDENTITY|ARITH|CONCAT|NUMERIC)|'
    r'PRINT\s|BEGIN\b|SELECT\s)', re.I)


def split_statements(q):
    """Split a multi-statement script at top-level statement keywords. Stops at the first object (proc/func/view/trigger)."""
    stmts, depth, qt, start, i, n = [], 0, None, 0, 0, len(q)
    prev = ''
    while i < n:
        c = q[i]
        if qt:
            if c == qt:
                qt = None
        elif c in "'\"":
            qt = c
        elif c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
        elif depth == 0 and (i == 0 or not (q[i - 1].isalnum() or q[i - 1] in '_@#')) and c.isalpha():
            m = BOUNDARY.match(q, i)
            if m and i > start:
                pw = re.search(r'(\w+)\s*$', q[start:i])
                prev = pw.group(1).upper() if pw else ''
                if not (prev == 'ON' and m.group(1).upper().startswith(('UPDATE', 'DELETE'))) and \
                        not (prev == 'EXISTS' or prev in ('IF', 'NOT', 'AS', 'AND', 'OR')) and \
                        not (m.group(1).upper().startswith('SELECT') and prev in ('INSERT', 'INTO')):
                    seg = q[start:i].strip()
                    if seg:
                        stmts.append(seg)
                    start = i
                    if OBJ_RX.match(q[i:i + 200]):
                        break
        i += 1
    tail = q[start:].strip()
    if tail:
        stmts.append(tail)
    return stmts


GUARD_RX = re.compile(r'^if\s+(not\s+)?exists\s*\(', re.I)


def strip_guard(stmt):
    m = GUARD_RX.match(stmt)
    if not m:
        return None, stmt
    end = balanced(stmt, m.end() - 1)
    return ('not exists' if m.group(1) else 'exists'), stmt[end:].strip()


# ---------------------------------------------------------------- column / constraint parsing
KW = r'(?:NOT\s+NULL|NULL|IDENTITY|COLLATE|CONSTRAINT|DEFAULT|PRIMARY|UNIQUE|REFERENCES|FOREIGN|CHECK|ROWGUIDCOL)'


def read_expr(s, i):
    n = len(s)
    while i < n and s[i].isspace():
        i += 1
    if i >= n:
        return '', i
    j = i
    if s[i] == '(':
        j = balanced(s, i)
    elif s[i] in "'\"":
        q = s[i]
        j = i + 1
        while j < n and s[j] != q:
            j += 1
        j += 1
    else:
        m = re.match(r"[-+]?[\w.@#]+(?:\s*\([^)]*\))?", s[i:])
        j = i + (m.end() if m else 1)
    return s[i:j], j


def parse_constraint_clauses(rest, table, col=None):
    """Pull inline constraints out of a column/ALTER fragment. Returns (remaining, constraints list, default)."""
    cons, default = [], None
    work = rest
    # DEFAULT
    m = re.search(r'(?:\bCONSTRAINT\s+(%s)\s+)?\bDEFAULT\b' % ID, work, re.I)
    if m:
        expr, end = read_expr(work, m.end())
        default = {'name': norm(m.group(1)) if m.group(1) else None, 'expr': expr.strip()}
        work = work[:m.start()] + ' ' + work[end:]
    # CHECK
    m = re.search(r'(?:\bCONSTRAINT\s+(%s)\s+)?\bCHECK\s*(?:NOT\s+FOR\s+REPLICATION\s*)?\(' % ID, work, re.I)
    if m:
        end = balanced(work, m.end() - 1)
        cons.append({'kind': 'CHECK', 'name': norm(m.group(1)) if m.group(1) else None,
                     'text': 'CHECK ' + squash(work[m.end() - 1:end])})
        work = work[:m.start()] + ' ' + work[end:]
    # PRIMARY KEY / UNIQUE
    for kind, rx in (('PRIMARY KEY', r'PRIMARY\s+KEY'), ('UNIQUE', r'UNIQUE')):
        m = re.search(r'(?:\bCONSTRAINT\s+(%s)\s+)?\b%s(\s+(?:NON)?CLUSTERED)?(\s*\()?' % (ID, rx), work, re.I)
        if m:
            end = m.end()
            cols = [col] if col else []
            if m.group(3):
                e2 = balanced(work, m.end() - 1)
                cols = [norm(c.split()[0]) for c in split_top(work[m.end():e2 - 1])]
                end = e2
            work2 = work[end:]
            mo = re.match(r'\s*WITH\s*\([^)]*\)', work2, re.I)
            if mo:
                end += mo.end()
            cl = (m.group(2) or '').strip().upper()
            cons.append({'kind': kind, 'name': norm(m.group(1)) if m.group(1) else None,
                         'cols': cols, 'clustered': cl, 'text': None})
            work = work[:m.start()] + ' ' + work[end:]
    # FOREIGN KEY / REFERENCES
    m = re.search(r'(?:\bCONSTRAINT\s+(%s)\s+)?(?:\bFOREIGN\s+KEY\s*(\([^)]*\))?\s*)?\bREFERENCES\s+(%s)\s*(\([^)]*\))?' % (ID, QN), work, re.I)
    if m:
        end = m.end()
        tail = re.match(r'(?:\s+ON\s+(?:DELETE|UPDATE)\s+(?:CASCADE|NO\s+ACTION|SET\s+NULL|SET\s+DEFAULT))*(?:\s+NOT\s+FOR\s+REPLICATION)?', work[end:], re.I)
        actions = squash(tail.group(0)) if tail else ''
        end += tail.end() if tail else 0
        cols = [norm(c) for c in split_top(m.group(2)[1:-1])] if m.group(2) else ([col] if col else [])
        rcols = [norm(c) for c in split_top(m.group(4)[1:-1])] if m.group(4) else []
        cons.append({'kind': 'FOREIGN KEY', 'name': norm(m.group(1)) if m.group(1) else None, 'cols': cols,
                     'ref': norm(m.group(3)), 'refcols': rcols, 'actions': actions})
        work = work[:m.start()] + ' ' + work[end:]
    # leftover bare "CONSTRAINT name" (e.g. PK on separate clause) is ignored
    return work, cons, default


def parse_coldef(text, table):
    text = text.strip()
    text = re.sub(r'^COLUMN\s+', '', text, flags=re.I)
    m = re.match(r'(%s)\s*(.*)$' % ID, text, re.S)
    if not m:
        return None, []
    name, rest = norm(m.group(1)), m.group(2)
    work, cons, default = parse_constraint_clauses(rest, table, name)
    ident = None
    mi = re.search(r'\bIDENTITY\s*(\([^)]*\))?(\s+NOT\s+FOR\s+REPLICATION)?', work, re.I)
    if mi:
        ident = 'IDENTITY' + (squash(mi.group(1)) if mi.group(1) else '(1,1)')
        work = work[:mi.start()] + ' ' + work[mi.end():]
    collate = None
    mc = re.search(r'\bCOLLATE\s+(\w+)', work, re.I)
    if mc:
        collate = mc.group(1)
        work = work[:mc.start()] + ' ' + work[mc.end():]
    work = re.sub(r'\bROWGUIDCOL\b', ' ', work, flags=re.I)
    notnull = None
    if re.search(r'\bNOT\s+NULL\b', work, re.I):
        notnull = True
        work = re.sub(r'\bNOT\s+NULL\b', ' ', work, flags=re.I)
    elif re.search(r'\bNULL\b', work, re.I):
        notnull = False
        work = re.sub(r'\bNULL\b', ' ', work, flags=re.I)
    work = re.sub(r'\b(?:NON)?CLUSTERED\b|\bON\s+\[?PRIMARY\]?', ' ', work, flags=re.I)
    typ = squash(work)
    typ = re.sub(r'\s*\(\s*', '(', typ)
    typ = re.sub(r'\s*,\s*', ',', typ)
    typ = re.sub(r'\)\s*', ')', typ).strip()
    col = {'name': name, 'type': typ.lower(), 'collate': collate, 'identity': ident, 'notnull': notnull, 'default': default}
    return col, cons


class Db:
    def __init__(self):
        self.tables = collections.OrderedDict()   # key -> table
        self.objects = {k: collections.OrderedDict() for k in ('procedure', 'function', 'view', 'trigger')}
        self.seed = []          # (seq, text)
        self.unhandled = []     # (seq, reason, snippet)
        self.dropped_tables = set()
        self.protect_tables = set()   # tables present in the catalog base: older scripts must not touch them
        self.protect_objs = set()     # (kind, key) of programmable objects present in the catalog base
        self.protect_until = 0        # scripts below this sequence number are subject to protection

    # ---- tables
    def table(self, name, create=False):
        k = key(name)
        if k.startswith('#'):
            return None
        t = self.tables.get(k)
        if t is None and create:
            t = {'name': norm(name), 'cols': collections.OrderedDict(), 'cons': collections.OrderedDict(),
                 'indexes': collections.OrderedDict(), 'created': None, 'altered': 0}
            self.tables[k] = t
        return t

    def add_cons(self, t, c, col_default_for=None):
        if c['name'] is None:
            base = {'PRIMARY KEY': 'PK', 'UNIQUE': 'UQ', 'FOREIGN KEY': 'FK', 'CHECK': 'CK'}[c['kind']]
            suffix = '_'.join(c.get('cols') or []) or str(len(t['cons']) + 1)
            c['name'] = '%s_%s_%s' % (base, t['name'], suffix)
            c['auto'] = True
        t['cons'][c['name'].lower()] = c

    def add_column(self, t, text, seq):
        col, cons = parse_coldef(text, t['name'])
        if not col:
            self.unhandled.append((seq, 'column def', squash(text)[:200]))
            return
        ck = col['name'].lower()
        if ck in t['cols']:
            return  # idempotent: scripts are re-run guards
        t['cols'][ck] = col
        for c in cons:
            self.add_cons(t, c)

    def table_constraint(self, t, text, seq):
        text = text.strip()
        m = re.match(r'(?:CONSTRAINT\s+(%s)\s+)?DEFAULT\b' % ID, text, re.I)
        if m:
            expr, end = read_expr(text, m.end())
            mf = re.match(r'\s*FOR\s+(%s)' % ID, text[end:], re.I)
            if mf and key(mf.group(1)) in t['cols']:
                t['cols'][key(mf.group(1))]['default'] = {'name': norm(m.group(1)) if m.group(1) else None, 'expr': expr.strip()}
                return
        work, cons, default = parse_constraint_clauses(text, t['name'])
        if not cons:
            self.unhandled.append((seq, 'table constraint', squash(text)[:200]))
        for c in cons:
            self.add_cons(t, c)

    def alter_table(self, stmt, seq):
        m = re.match(r'alter\s+table\s+(%s)\s*(?:with\s+(?:no)?check\s+)?(.*)$' % QN, stmt, re.I | re.S)
        if not m:
            self.unhandled.append((seq, 'alter table parse', squash(stmt)[:200]))
            return
        t = self.table(m.group(1))
        rest = m.group(2).strip()
        if t is None:
            if not key(m.group(1)).startswith('#'):
                self.unhandled.append((seq, 'alter on unknown table', squash(stmt)[:160]))
            return
        t['altered'] += 1
        mm = re.match(r'(add|drop|alter\s+column|(?:no)?check|enable|disable)\b\s*(.*)$', rest, re.I | re.S)
        if not mm:
            self.unhandled.append((seq, 'alter table action', squash(stmt)[:200]))
            return
        action, body = mm.group(1).lower(), mm.group(2)
        if action == 'add':
            for item in split_top(body):
                it = item.strip()
                if re.match(r'(constraint|primary\s+key|unique|foreign\s+key|check|default)\b', it, re.I):
                    self.table_constraint(t, it, seq)
                elif it:
                    self.add_column(t, it, seq)
        elif action == 'alter column':
            col, cons = parse_coldef(body, t['name'])
            if not col or col['name'].lower() not in t['cols']:
                self.unhandled.append((seq, 'alter column unknown', squash(stmt)[:200]))
                return
            old = t['cols'][col['name'].lower()]
            old['type'] = col['type']
            old['notnull'] = col['notnull'] if col['notnull'] is not None else False
            if col['collate']:
                old['collate'] = col['collate']
        elif action == 'drop':
            md = re.match(r'(constraint|column)\s+(.*)$', body, re.I | re.S)
            if not md:
                self.unhandled.append((seq, 'drop what', squash(stmt)[:200]))
                return
            names = [norm(x.strip().split()[0]) for x in split_top(md.group(2)) if x.strip()]
            if md.group(1).lower() == 'constraint':
                for nme in names:
                    t['cons'].pop(nme.lower(), None)
                    for c in t['cols'].values():
                        if c['default'] and c['default']['name'] and c['default']['name'].lower() == nme.lower():
                            c['default'] = None
            else:
                for nme in names:
                    t['cols'].pop(nme.lower(), None)
                    for ck_, c in list(t['cons'].items()):
                        if nme in (c.get('cols') or []) and c['kind'] != 'FOREIGN KEY' or (c['kind'] == 'FOREIGN KEY' and nme in (c.get('cols') or [])):
                            t['cons'].pop(ck_, None)
        # check/nocheck/enable/disable: no schema effect

    def create_table(self, stmt, seq):
        m = re.match(r'create\s+table\s+(%s)\s*\(' % QN, stmt, re.I)
        if not m:
            self.unhandled.append((seq, 'create table parse', squash(stmt)[:200]))
            return
        t = self.table(m.group(1), create=True)
        if t is None:
            return
        end = balanced(stmt, m.end() - 1)
        t['cols'].clear()
        t['cons'].clear()
        t['created'] = seq
        for item in split_top(stmt[m.end():end - 1]):
            it = item.strip()
            if re.match(r'(constraint|primary\s+key|unique|foreign\s+key|check)\b', it, re.I):
                self.table_constraint(t, it, seq)
            elif it:
                self.add_column(t, it, seq)

    def drop_table(self, stmt, seq):
        for nm in re.findall(r'drop\s+table\s+(%s)' % QN, stmt, re.I):
            k = key(nm)
            if k in self.tables:
                del self.tables[k]
                for t in self.tables.values():
                    for ck_, c in list(t['cons'].items()):
                        if c['kind'] == 'FOREIGN KEY' and c['ref'].lower() == k:
                            del t['cons'][ck_]

    def create_index(self, stmt, seq):
        m = re.match(r'create\s+(unique\s+)?((?:non)?clustered\s+)?index\s+(%s)\s+on\s+(%s)\s*\(' % (ID, QN), stmt, re.I)
        if not m:
            self.unhandled.append((seq, 'create index parse', squash(stmt)[:200]))
            return
        t = self.table(m.group(4))
        if t is None:
            return
        end = balanced(stmt, m.end() - 1)
        cols = squash(stmt[m.end():end - 1])
        t['indexes'][norm(m.group(3)).lower()] = {'name': norm(m.group(3)), 'unique': bool(m.group(1)),
                                                  'clustered': (m.group(2) or '').strip().upper(), 'cols': cols}

    def drop_index(self, stmt, seq):
        body = re.match(r'drop\s+index\s+(.*)$', stmt, re.I | re.S).group(1)
        body = re.split(r'\b(?:IF|INSERT|UPDATE|DELETE)\b', body, flags=re.I)[0]
        mo = re.match(r'(%s)\s+on\s+(%s)' % (ID, QN), body, re.I)
        if mo:
            t = self.table(mo.group(2))
            if t:
                t['indexes'].pop(norm(mo.group(1)).lower(), None)
            return
        for part in split_top(body):
            part = part.strip()
            if '.' in part:
                tn, inn = part.rsplit('.', 1)
                t = self.table(tn)
                if t:
                    t['indexes'].pop(norm(inn).lower(), None)

    # ---- programmable objects
    def set_object(self, kind_word, name, text, seq):
        kind = {'proc': 'procedure', 'procedure': 'procedure'}.get(kind_word.lower(), kind_word.lower())
        body = re.sub(r'^\s*alter\b', 'CREATE', text.strip(), count=1, flags=re.I)
        body = re.sub(r'^\s*create\b', 'CREATE', body, count=1, flags=re.I)
        self.objects[kind][key(name)] = {'name': norm(name), 'seq': seq, 'body': body}

    def drop_object(self, stmt, seq):
        m = re.match(r'drop\s+(proc(?:edure)?|view|function|trigger)\s+(%s)' % QN, stmt, re.I)
        if m:
            kind = 'procedure' if m.group(1).lower().startswith('proc') else m.group(1).lower()
            self.objects[kind].pop(key(m.group(2)), None)

    # ---- driver
    def _protected(self, head):
        m = re.match(r'(?:create|alter|drop)\s+table\s+(%s)' % QN, head, re.I) or             re.match(r'create\s+(?:unique\s+|clustered\s+|nonclustered\s+)*index\s+%s\s+on\s+(%s)' % (ID, QN), head, re.I)
        if m:
            return key(m.group(1)) in self.protect_tables
        m = re.match(r'drop\s+index\s+(%s)\.' % QN, head, re.I) or re.match(r'drop\s+index\s+%s\s+on\s+(%s)' % (ID, QN), head, re.I)
        if m:
            return key(m.group(1)) in self.protect_tables
        m = OBJ_RX.match(head)
        if m:
            kind = 'procedure' if m.group(2).lower().startswith('proc') else m.group(2).lower()
            return (kind, key(m.group(3))) in self.protect_objs
        m = re.match(r'drop\s+(proc(?:edure)?|view|function|trigger)\s+(%s)' % QN, head, re.I)
        if m:
            kind = 'procedure' if m.group(1).lower().startswith('proc') else m.group(1).lower()
            return (kind, key(m.group(2))) in self.protect_objs
        return False

    def run(self, seq, q):
        q0 = q.strip()
        head = strip_comments(q0).lstrip()
        if OBJ_RX.match(head):
            if seq < self.protect_until and self._protected(head):
                return
            m = OBJ_RX.match(head)
            self.set_object(m.group(2), m.group(3), q0[q0.lower().find(m.group(1).lower()):], seq)
            return
        if re.match(r'(begin|declare|set\b(?!\s+(?:ansi|quoted|nocount))|if\s+@|print)', head, re.I) and not GUARD_RX.match(head):
            self.seed.append((seq, q0))
            return
        stmts = split_statements(q0)
        for st in stmts:
            clean = strip_comments(st).strip()
            guard, body = strip_guard(clean)
            if guard and re.match(r'begin\b', body, re.I):
                self.seed.append((seq, st))
                continue
            head = body
            if seq < self.protect_until and self._protected(head):
                continue
            if OBJ_RX.match(head):
                m = OBJ_RX.match(head)
                raw = st
                pos = re.search(r'\b(create|alter)\s+(proc|procedure|function|view|trigger)\b', raw, re.I)
                self.set_object(m.group(2), m.group(3), raw[pos.start():], seq)
            elif re.match(r'create\s+table\b', head, re.I):
                self.create_table(head, seq)
            elif re.match(r'alter\s+table\b', head, re.I):
                self.alter_table(head, seq)
            elif re.match(r'drop\s+table\b', head, re.I):
                self.drop_table(head, seq)
            elif re.match(r'create\s+(unique\s+|clustered\s+|nonclustered\s+)*index\b', head, re.I):
                self.create_index(head, seq)
            elif re.match(r'drop\s+index\b', head, re.I):
                self.drop_index(head, seq)
            elif re.match(r'drop\s+(proc|procedure|view|function|trigger)\b', head, re.I):
                self.drop_object(head, seq)
            elif re.match(r'(insert|update|delete|truncate|exec|execute|select|set|declare|print|if|begin)\b', head, re.I):
                if re.match(r'set\s+(ansi|quoted|nocount|arith|concat|numeric)', head, re.I):
                    continue
                self.seed.append((seq, st))
            else:
                self.unhandled.append((seq, 'unclassified', squash(head)[:200]))


# ---------------------------------------------------------------- rendering
def render_col(c):
    s = '[%s] %s' % (c['name'], c['type'])
    if c['collate']:
        s += ' COLLATE ' + c['collate']
    if c['identity']:
        s += ' ' + c['identity']
    s += ' NOT NULL' if c['notnull'] else ' NULL'
    if c['default']:
        d = c['default']
        s += (' CONSTRAINT [%s]' % d['name'] if d['name'] else '') + ' DEFAULT ' + d['expr']
    return s


def render_cons(c):
    if c['kind'] in ('PRIMARY KEY', 'UNIQUE'):
        cl = (' ' + c['clustered']) if c.get('clustered') else ''
        return 'CONSTRAINT [%s] %s%s (%s)' % (c['name'], c['kind'], cl, ', '.join('[%s]' % x for x in c['cols']))
    if c['kind'] == 'CHECK':
        return 'CONSTRAINT [%s] %s' % (c['name'], c['text'])
    return ('CONSTRAINT [%s] FOREIGN KEY (%s) REFERENCES [dbo].[%s]%s%s' % (
        c['name'], ', '.join('[%s]' % x for x in c['cols']), c['ref'],
        (' (%s)' % ', '.join('[%s]' % x for x in c['refcols'])) if c['refcols'] else '',
        (' ' + c['actions']) if c.get('actions') else ''))


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)


def seed_from_catalog(db, v2):
    """Load a catalog-derived schema.json (see mdf_to_schema.py) into the replay model as the starting state."""
    for name, t in v2['tables'].items():
        tb = db.table(name, create=True)
        for c in t['columns']:
            tb['cols'][c['name'].lower()] = {
                'name': c['name'], 'type': c['type'].lower(), 'collate': None,
                'identity': 'IDENTITY(1,1)' if c['identity'] else None, 'notnull': c['notnull'],
                'default': ({'name': c['default']['name'], 'expr': c['default']['expr']} if c['default'] else None)}
        if t['pk']:
            db.add_cons(tb, {'kind': 'PRIMARY KEY', 'name': t['pk']['name'], 'cols': t['pk']['columns'],
                             'clustered': 'CLUSTERED' if t['pk']['clustered'] else 'NONCLUSTERED', 'text': None})
        for u in t['unique']:
            db.add_cons(tb, {'kind': 'UNIQUE', 'name': u['name'], 'cols': u['columns'], 'clustered': '', 'text': None})
        for f in t['fks']:
            db.add_cons(tb, {'kind': 'FOREIGN KEY', 'name': f['name'] or None, 'cols': f['columns'],
                             'ref': f['ref_table'], 'refcols': f['ref_columns'], 'actions': ''})
        for ck in t['checks']:
            db.add_cons(tb, {'kind': 'CHECK', 'name': ck['name'], 'text': 'CHECK ' + ck['expr']})
        for ix in t['indexes']:
            tb['indexes'][ix['name'].lower()] = {'name': ix['name'], 'unique': ix.get('unique', False), 'clustered': '',
                                                 'cols': ', '.join(ix['columns'])}
    for kind, d in v2['objects'].items():
        pass
    return db


def emit(db, out):
    T = sorted(db.tables.values(), key=lambda t: t['name'].lower())
    tables_sql, fk_sql, idx_sql = [], [], []
    for t in T:
        lines = [render_col(c) for c in t['cols'].values()]
        inline = [c for c in t['cons'].values() if c['kind'] != 'FOREIGN KEY']
        lines += [render_cons(c) for c in inline]
        tables_sql.append('CREATE TABLE [dbo].[%s] (\n    %s\n);\nGO\n' % (t['name'], ',\n    '.join(lines)))
        for c in t['cons'].values():
            if c['kind'] == 'FOREIGN KEY':
                fk_sql.append('ALTER TABLE [dbo].[%s] ADD %s;' % (t['name'], render_cons(c)))
        for ix in t['indexes'].values():
            idx_sql.append('CREATE %s%sINDEX [%s] ON [dbo].[%s] (%s);' % (
                'UNIQUE ' if ix['unique'] else '', (ix['clustered'] + ' ') if ix['clustered'] else '', ix['name'], t['name'], ix['cols']))
    hdr = '-- Reconstructed by re-tools/db_rebuild.py (static; not validated on SQL Server)\n\n'
    write(os.path.join(out, 'schema', '01_tables.sql'), hdr + '\n'.join(tables_sql))
    write(os.path.join(out, 'schema', '02_foreign_keys.sql'), hdr + '\nGO\n'.join(fk_sql) + '\nGO\n')
    write(os.path.join(out, 'schema', '03_indexes.sql'), hdr + '\nGO\n'.join(idx_sql) + '\nGO\n')
    for kind, fn in (('function', '04_functions.sql'), ('view', '05_views.sql'),
                     ('procedure', '06_procedures.sql'), ('trigger', '07_triggers.sql')):
        objs = sorted(db.objects[kind].values(), key=lambda o: o['name'].lower())
        write(os.path.join(out, 'schema', fn), hdr + '\n'.join(
            '-- %s (last defined by script %s)\n%s\nGO\n' % (o['name'], o['seq'], o['body'].rstrip()) for o in objs))
    write(os.path.join(out, 'seed', 'seed_ledger.sql'),
          '-- Data statements from the migration chain, in order (rights, preferences, dropdowns, report metadata ...).\n'
          '-- Not applied/validated. Row data of the customer database is NOT included.\n\n' +
          '\n'.join('-- script %d\n%s\nGO\n' % (s, t.rstrip()) for s, t in db.seed))
    write(os.path.join(out, 'unhandled.log'), '\n'.join('%s\t%s\t%s' % u for u in db.unhandled))
    schema = {
        'tables': {t['name']: {'columns': [dict(c) for c in t['cols'].values()],
                               'constraints': [dict(c) for c in t['cons'].values()],
                               'indexes': list(t['indexes'].values())} for t in T},
        'objects': {k: sorted(o['name'] for o in d.values()) for k, d in db.objects.items()},
    }
    write(os.path.join(out, 'schema.json'), json.dumps(schema, indent=1))
    n_fk = sum(1 for t in T for c in t['cons'].values() if c['kind'] == 'FOREIGN KEY')
    print('tables', len(T), 'columns', sum(len(t['cols']) for t in T), 'fks', n_fk,
          'indexes', sum(len(t['indexes']) for t in T),
          {k: len(v) for k, v in db.objects.items()}, 'seed stmts', len(db.seed), 'unhandled', len(db.unhandled))


def main(rows_path, out, base_json=None, from_seq=0):
    rows = sorted((json.loads(l) for l in open(rows_path, encoding='utf-8')), key=lambda r: r['sequenceid'])
    db = Db()
    if base_json:
        v2 = json.load(open(base_json, encoding='utf-8'))
        seed_from_catalog(db, v2)
        # programmable objects from the catalog (bodies as stored, CREATE form)
        for kind, d in v2.get('bodies', {}).items():
            for name, p in d.items():
                db.objects[kind][name.lower()] = {'name': name, 'seq': 'catalog', 'body': p['body']}
                db.protect_objs.add((kind, name.lower()))
        db.protect_tables = set(db.tables)
        db.protect_until = from_seq
    for r in rows:
        try:
            db.run(r['sequenceid'], r['query'] or '')
        except Exception as e:  # keep going; record
            db.unhandled.append((r['sequenceid'], 'exception %s' % e, squash(r['query'] or '')[:160]))
    emit(db, out)


if __name__ == '__main__':
    # usage: db_rebuild.py rows.jsonl out_dir [base_schema.json from_seq]
    # with a base: scripts below from_seq only touch objects the base does not contain (gap-fill); later ones apply fully
    if len(sys.argv) > 4:
        main(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
    else:
        main(sys.argv[1], sys.argv[2])
