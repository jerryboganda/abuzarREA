#!/usr/bin/env python3
"""Read-only PowerScript hotspot scanner for recovered .pbs files.

Outputs JSON + CSV under deploy/analysis/scripts/out/.
No source files are modified.
"""
import os, re, json, csv, sys, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
SCRIPTS = os.path.join(ROOT, 'recovered', 'scripts')
OUT = os.path.join(os.path.dirname(__file__), 'out')
os.makedirs(OUT, exist_ok=True)

HDR = re.compile(r'^//\s+([A-Za-z0-9_]+)\.([A-Za-z0-9_]+)\((.*?)\)\s+returns\s+(.*)$')

LOOP_START = re.compile(r'^(\s*)(for\s+[A-Za-z_]\w*\s*=|do\s*$|do\s+while\b|do\s+until\b)', re.I)
LOOP_END = re.compile(r'^\s*(next|loop)\b', re.I)

# token -> (regex, weight)
TOKENS = [
    ('SQL',        re.compile(r'^\s*SQL\s+', re.I), 60),
    ('Retrieve',   re.compile(r'\.retrieve\s*\(', re.I), 100),
    ('GetItem',    re.compile(r'\bgetitem(?:string|number|date|datetime|time|decimal)\s*\(', re.I), 3),
    ('SetItem',    re.compile(r'\bsetitem\s*\(', re.I), 3),
    ('Describe',   re.compile(r'\.describe\s*\(', re.I), 12),
    ('Modify',     re.compile(r'\.modify\s*\(', re.I), 10),
    ('Find',       re.compile(r'\.find\s*\(', re.I), 5),
    ('Filter',     re.compile(r'\.filter\s*\(', re.I), 20),
    ('SetFilter',  re.compile(r'\.setfilter\s*\(', re.I), 20),
    ('SetSort',    re.compile(r'\.setsort\s*\(', re.I), 15),
    ('RowCount',   re.compile(r'\.rowcount\s*\(', re.I), 2),
    ('InsertRow',  re.compile(r'\.insertrow\s*\(', re.I), 6),
    ('DeleteRow',  re.compile(r'\.deleterow\s*\(', re.I), 6),
    ('MessageBox', re.compile(r'\bmessagebox\s*\(', re.I), 30),
    ('Create',     re.compile(r'^\s*create\s+\w', re.I), 35),
    ('Destroy',    re.compile(r'^\s*destroy\s+\w', re.I), 20),
    ('Open',       re.compile(r'(?<![\w.])open\s*\(', re.I), 60),
    ('OpenSheet',  re.compile(r'\bopensheet\s*\(', re.I), 60),
    ('TriggerEvent', re.compile(r'\btriggerevent\s*\(', re.I), 15),
    ('PostEvent',  re.compile(r'\bpostevent\s*\(', re.I), 8),
    ('SetTransObject', re.compile(r'\.settransobject\s*\(', re.I), 15),
    ('SetRedraw',  re.compile(r'\.setredraw\s*\(', re.I), 5),
    ('Sleep',      re.compile(r'\bsleep\s*\(', re.I), 40),
    ('Concat',     re.compile(r'^\s*\w+\s*=\s*\w+\s*\+', re.I), 1),
    ('Mid',        re.compile(r'\bmid\s*\(', re.I), 1),
    ('Pos',        re.compile(r'\bpos\s*\(', re.I), 1),
    ('StringFn',   re.compile(r'\bstring\s*\(', re.I), 1),
    ('Trim',       re.compile(r'\btrim\s*\(', re.I), 1),
    ('FileIO',     re.compile(r'\b(?:fileopen|fileread|filewrite|fileclose|filedelete|filecopy)\s*\(', re.I), 20),
    ('Registry',   re.compile(r'\bregistry(?:get|set|delete)\w*\s*\(', re.I), 30),
    ('Run',        re.compile(r'\brun\s*\(', re.I), 50),
]

SQL_RE = re.compile(r'^\s*SQL\s+(.*)$', re.I)
SQL_START = re.compile(r'^(select|insert|update|delete|commit|rollback|declare|fetch|close|open|exec|execute|set|if|begin|create|drop|alter|truncate|with)\b', re.I)

def indent_of(s):
    n = 0
    for ch in s:
        if ch == '\t': n += 4
        elif ch == ' ': n += 1
        else: break
    return n

def read_lines(path):
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        return f.read().splitlines()

def norm_sql(sql):
    s = sql.strip().rstrip(';')
    s = re.sub(r"'(?:[^']|'')*'", "'?'", s)       # string literals
    s = re.sub(r'\b\d+(?:\.\d+)?\b', '?', s)      # numbers
    s = re.sub(r':[A-Za-z_]\w*', ':?', s)          # bind vars
    s = re.sub(r'\s+', ' ', s)
    return s.strip().lower()

def tables_of(sql):
    t = []
    for m in re.finditer(r'\b(?:from|join)\s+([A-Za-z_][\w\.#]*)', sql, re.I):
        t.append(m.group(1).lower())
    return t

files = []
for dirpath, _, names in os.walk(SCRIPTS):
    for n in names:
        if n.lower().endswith('.pbs'):
            files.append(os.path.join(dirpath, n))
files.sort()

all_loops = []
all_sql = []
hot_lines = []
blocks = []
file_stats = []
func_defs = []
ident_uses = collections.Counter()

for path in files:
    rel = os.path.relpath(path, ROOT).replace('\\', '/')
    lib = os.path.basename(os.path.dirname(path))
    lines = read_lines(path)
    nlines = len(lines)

    # blocks
    hdrs = []
    for i, l in enumerate(lines):
        m = HDR.match(l)
        if m:
            hdrs.append((i, m.group(1), m.group(2), m.group(3), m.group(4)))
    for k, (i, obj, fn, args, ret) in enumerate(hdrs):
        end = hdrs[k+1][0] if k+1 < len(hdrs) else nlines
        blocks.append({'file': rel, 'lib': lib, 'object': obj, 'routine': fn,
                       'start': i+1, 'end': end, 'lines': end - i,
                       'ret': ret, 'args': args})
        func_defs.append((obj, fn, rel, i+1, end - i))

    # indentation loops
    stack = []
    loops = []
    for i, l in enumerate(lines):
        s = l.strip()
        if not s or s.startswith('//'):
            continue
        ind = indent_of(l)
        if LOOP_END.match(l):
            # close nearest loop with indent >= current
            while stack and stack[-1]['indent'] >= ind:
                L = stack.pop()
                L['end'] = i + 1
                loops.append(L)
            continue
        m = LOOP_START.match(l)
        if m:
            stack.append({'start': i+1, 'indent': ind, 'header': s, 'end': None})
    while stack:
        L = stack.pop(); L['end'] = nlines; loops.append(L)

    loops = [L for L in loops if L['end'] and L['end'] > L['start']]
    loops.sort(key=lambda x: (x['start'], -x['end']))
    # innermost determination by smallest span
    for L in loops:
        span = L['end'] - L['start']
        body = lines[L['start']-1:L['end']]
        counts = collections.Counter()
        for ln in body:
            for name, rx, w in TOKENS:
                if rx.search(ln):
                    counts[name] += 1
        score = sum(counts[n] * w for n, _, w in TOKENS)
        L.update({'file': rel, 'lib': lib, 'span': span, 'counts': dict(counts), 'score': score})
        L['sql_in_loop'] = counts.get('SQL', 0)
        L['rowcount_in_header'] = bool(re.search(r'rowcount\s*\(', L['header'], re.I))
        all_loops.append(L)

    # sql
    for i, l in enumerate(lines):
        m = SQL_RE.match(l)
        if not m: continue
        body = m.group(1).strip()
        low = body.lower()
        kind = 'other'
        for k in ('select', 'insert', 'update', 'delete', 'commit', 'rollback', 'exec', 'execute', 'declare', 'fetch'):
            if re.match(r'^' + k + r'\b', low):
                kind = k; break
        tabs = tables_of(body)
        rec = {
            'file': rel, 'lib': lib, 'line': i+1, 'kind': kind,
            'sql': body, 'norm': norm_sql(body), 'tables': tabs,
            'select_star': bool(re.search(r'\bselect\s+(?:distinct\s+)?\*', low)),
            'has_where': bool(re.search(r'\bwhere\b', low)),
            'has_join': bool(re.search(r'\bjoin\b', low)),
            'has_into': bool(re.search(r'\binto\b', low)),
            'has_commit': bool(re.search(r'\bcommit\b', low)),
            'has_getdate': bool(re.search(r'\bgetdate\s*\(', low)),
        }
        all_sql.append(rec)

    # per-line tokens outside loops too (for global counts)
    for i, l in enumerate(lines):
        for name, rx, w in TOKENS:
            if rx.search(l):
                ident_uses[name] += 1

    file_stats.append({'file': rel, 'lib': lib, 'lines': nlines, 'bytes': os.path.getsize(path),
                       'loops': len(loops), 'sql': sum(1 for r in all_sql if r['file'] == rel)})

# ---- assign innermost loop to each sql + hot line ----
loop_by_file = collections.defaultdict(list)
for L in all_loops:
    loop_by_file[L['file']].append(L)

def innermost(f, line):
    best = None
    for L in loop_by_file.get(f, ()):
        if L['start'] < line <= L['end']:
            if best is None or L['span'] < best['span']:
                best = L
    return best

for r in all_sql:
    L = innermost(r['file'], r['line'])
    r['in_loop'] = bool(L)
    r['loop_start'] = L['start'] if L else None

# hot lines: SQL / retrieve / create / destroy / messagebox / sleep etc inside loops
HOT_LINE_RX = {
    'SQL': re.compile(r'^\s*SQL\s+', re.I),
    'Retrieve': re.compile(r'\.retrieve\s*\(', re.I),
    'GetItem': re.compile(r'\bgetitem(?:string|number|date|datetime|time|decimal)\s*\(', re.I),
    'SetItem': re.compile(r'\bsetitem\s*\(', re.I),
    'Describe': re.compile(r'\.describe\s*\(', re.I),
    'Modify': re.compile(r'\.modify\s*\(', re.I),
    'Filter': re.compile(r'\.(?:setfilter|filter)\s*\(', re.I),
    'SetSort': re.compile(r'\.setsort\s*\(', re.I),
    'InsertRow': re.compile(r'\.insertrow\s*\(', re.I),
    'DeleteRow': re.compile(r'\.deleterow\s*\(', re.I),
    'MessageBox': re.compile(r'\bmessagebox\s*\(', re.I),
    'Create': re.compile(r'^\s*create\s+\w', re.I),
    'Destroy': re.compile(r'^\s*destroy\s+\w', re.I),
    'Open': re.compile(r'(?<![\w.])(?:opensheet|open)\s*\(', re.I),
    'TriggerEvent': re.compile(r'\btriggerevent\s*\(', re.I),
    'SetTransObject': re.compile(r'\.settransobject\s*\(', re.I),
    'Sleep': re.compile(r'\bsleep\s*\(', re.I),
    'Concat': re.compile(r'^\s*\w+\s*=\s*\w+\s*\+', re.I),
}
for path in files:
    rel = os.path.relpath(path, ROOT).replace('\\', '/')
    if rel not in loop_by_file: continue
    lines = read_lines(path)
    for i, l in enumerate(lines):
        for name, rx in HOT_LINE_RX.items():
            if rx.search(l):
                L = innermost(rel, i+1)
                if L and L['span'] > 1:
                    hot_lines.append({'file': rel, 'line': i+1, 'token': name,
                                      'text': l.strip()[:300],
                                      'loop_start': L['start'], 'loop_span': L['span'],
                                      'loop_score': L['score']})
                break

# ---- loop ranking (dedupe overlaps: keep high score times sqrt(span)) ----
for L in all_loops:
    L['rank_score'] = L['score'] * (1 + min(L['span'], 200) / 200.0)
loops_sorted = sorted(all_loops, key=lambda x: -x['rank_score'])

# ---- outputs ----
json.dump({'files': len(files), 'lines': sum(f['lines'] for f in file_stats),
           'sql': all_sql, 'loops': all_loops, 'hot_lines': hot_lines,
           'file_stats': file_stats},
          open(os.path.join(OUT, 'scan.json'), 'w', encoding='utf-8'), indent=1)

with open(os.path.join(OUT, 'loops.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(['rank','file','loop_start','loop_end','span','score','sql','retrieve','getitem','setitem','describe','modify','filter','rowcount','insertrow','deleterow','messagebox','create','destroy','open','trigger','header'])
    for k, L in enumerate(loops_sorted[:2000], 1):
        c = L['counts']
        w.writerow([k, L['file'], L['start'], L['end'], L['span'], L['score'], c.get('SQL',0),
                    c.get('Retrieve',0), c.get('GetItem',0), c.get('SetItem',0), c.get('Describe',0),
                    c.get('Modify',0), c.get('Filter',0), c.get('RowCount',0), c.get('InsertRow',0),
                    c.get('DeleteRow',0), c.get('MessageBox',0), c.get('Create',0), c.get('Destroy',0),
                    c.get('Open',0), c.get('TriggerEvent',0), L['header'][:200]])

with open(os.path.join(OUT, 'sql.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(['file','line','kind','in_loop','select_star','has_where','tables','sql'])
    for r in all_sql:
        w.writerow([r['file'], r['line'], r['kind'], r['in_loop'], r['select_star'],
                    r['has_where'], ';'.join(r['tables']), r['sql'][:500]])

# repeated SQL
rep = collections.Counter(r['norm'] for r in all_sql)
reps = []
for norm, cnt in rep.most_common(200):
    if cnt < 3: continue
    locs = [(r['file'], r['line']) for r in all_sql if r['norm'] == norm]
    reps.append({'count': cnt, 'norm': norm, 'locs': locs[:40]})
json.dump(reps, open(os.path.join(OUT, 'repeated_sql.json'), 'w', encoding='utf-8'), indent=1)

# top statements/loops summary to stdout
print('files', len(files), 'lines', sum(f['lines'] for f in file_stats), 'sql', len(all_sql),
      'in-loop sql', sum(1 for r in all_sql if r['in_loop']), 'loops', len(all_loops),
      'hot lines', len(hot_lines))
print('\n== TOP LOOPS ==')
for k, L in enumerate(loops_sorted[:40], 1):
    print(f"{k:2d}. {L['file']}:{L['start']}-{L['end']} span={L['span']} score={L['score']} "
          f"sql={L['counts'].get('SQL',0)} get={L['counts'].get('GetItem',0)} "
          f"msg={L['counts'].get('MessageBox',0)} | {L['header'][:110]}")
print('\n== TOP REPEATED SQL (exact normalized) ==')
for r in reps[:15]:
    print(r['count'], '|', r['norm'][:160])
    print('    ', r['locs'][:5])
