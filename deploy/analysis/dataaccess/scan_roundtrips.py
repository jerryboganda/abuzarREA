import os, re, json, csv, sys

ROOT = r"C:\Projects\Abuzar\recovered\scripts"
OUT = r"C:\Projects\Abuzar\deploy\analysis\dataaccess"

sql_re = re.compile(r'\bSQL\s+(SELECT|INSERT|UPDATE|DELETE|COMMIT|ROLLBACK|EXECUTE|EXEC|START|STOP)\b', re.I)
ret_re = re.compile(r'\.\s*retrieve\s*\(', re.I)
sto_re = re.compile(r'\.\s*settransobject\s*\(', re.I)
st_re = re.compile(r'\.\s*settrans\s*\(', re.I)
desc_re = re.compile(r'\.\s*describe\s*\(', re.I)
mod_re = re.compile(r'\.\s*modify\s*\(', re.I)
upd_re = re.compile(r'\.\s*update\s*\(', re.I)
ins_re = re.compile(r'\.\s*insertrow\s*\(', re.I)
del_re = re.compile(r'\.\s*deleterow\s*\(', re.I)
start_re = re.compile(r'\bSQL\s+START\s+USING\b', re.I)
stop_re = re.compile(r'\bSQL\s+STOP\s+USING\b', re.I)
commit_re = re.compile(r'\bSQL\s+COMMIT\b', re.I)
rollback_re = re.compile(r'\bSQL\s+ROLLBACK\b', re.I)
for_re = re.compile(r'^\s*for\s+.+\bto\b', re.I)
do_re = re.compile(r'^\s*do\b', re.I)
loop_re = re.compile(r'^\s*loop\b', re.I)
next_re = re.compile(r'^\s*next\b', re.I)
if_re = re.compile(r'^\s*if\b.*\bthen\s*$', re.I)
end_if_re = re.compile(r'^\s*end\s+if\b', re.I)

files = []
for dp, dn, fn in os.walk(ROOT):
    for f in fn:
        if f.lower().endswith('.pbs'):
            files.append(os.path.join(dp, f))

rows = []
for path in files:
    try:
        text = open(path, encoding='utf-8', errors='replace').read()
    except Exception:
        continue
    lines = text.splitlines()
    stats = {
        'file': os.path.relpath(path, ROOT).replace('\\', '/'),
        'lib': os.path.basename(os.path.dirname(path)),
        'name': os.path.splitext(os.path.basename(path))[0],
        'sql_select': 0, 'sql_insert': 0, 'sql_update': 0, 'sql_delete': 0,
        'sql_exec': 0, 'commit': 0, 'rollback': 0, 'start': 0, 'stop': 0,
        'retrieve': 0, 'settransobject': 0, 'settrans': 0,
        'describe': 0, 'modify': 0, 'dwupdate': 0, 'insertrow': 0, 'deleterow': 0,
        'loops': 0, 'loops_with_db': 0, 'max_loop_db': 0, 'lines': len(lines),
    }
    stack = []  # each entry: dict(type, db_calls)
    for ln in lines:
        m = sql_re.search(ln)
        if m:
            kw = m.group(1).upper()
            key = {'SELECT': 'sql_select', 'INSERT': 'sql_insert', 'UPDATE': 'sql_update',
                   'DELETE': 'sql_delete', 'EXECUTE': 'sql_exec', 'EXEC': 'sql_exec',
                   'COMMIT': 'commit', 'ROLLBACK': 'rollback',
                   'START': 'start', 'STOP': 'stop'}.get(kw)
            if key:
                stats[key] += 1
        r = ret_re.search(ln)
        if r: stats['retrieve'] += 1
        if sto_re.search(ln): stats['settransobject'] += 1
        if st_re.search(ln): stats['settrans'] += 1
        if desc_re.search(ln): stats['describe'] += 1
        if mod_re.search(ln): stats['modify'] += 1
        if upd_re.search(ln): stats['dwupdate'] += 1
        if ins_re.search(ln): stats['insertrow'] += 1
        if del_re.search(ln): stats['deleterow'] += 1

        is_db = bool(m or r or upd_re.search(ln) or ins_re.search(ln) or del_re.search(ln))
        if is_db:
            for fr in stack:
                fr['db'] += 1
        if for_re.match(ln) or (do_re.match(ln) and not ln.strip().lower().startswith('double')):
            stack.append({'type': 'loop', 'db': 0})
        elif next_re.match(ln) or loop_re.match(ln):
            if stack:
                fr = stack.pop()
                stats['loops'] += 1
                if fr['db'] > 0:
                    stats['loops_with_db'] += 1
                    stats['max_loop_db'] = max(stats['max_loop_db'], fr['db'])
    # score: DB statements dominate, but count retrieve.
    stats['db_calls'] = (stats['sql_select'] + stats['sql_insert'] + stats['sql_update'] +
                         stats['sql_delete'] + stats['sql_exec'] + stats['commit'] +
                         stats['rollback'] + stats['retrieve'] + stats['dwupdate'])
    stats['conn_cycles'] = min(stats['start'], stats['stop'])
    rows.append(stats)

rows.sort(key=lambda r: (r['db_calls'] + 2*r['loops_with_db'] + 5*r['conn_cycles']), reverse=True)
with open(os.path.join(OUT, 'roundtrip_scan.csv'), 'w', newline='', encoding='utf-8') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

print(f"{len(rows)} pbs files")
print(f"total SQL DML/exec: {sum(r['sql_select']+r['sql_insert']+r['sql_update']+r['sql_delete']+r['sql_exec'] for r in rows)}")
print(f"total retrieve: {sum(r['retrieve'] for r in rows)}  settransobject: {sum(r['settransobject'] for r in rows)}")
print(f"total start/stop: {sum(r['start'] for r in rows)}/{sum(r['stop'] for r in rows)}")
print(f"files with both start+stop: {sum(1 for r in rows if r['start']>0 and r['stop']>0)}")
print(f"files with loops containing DB calls: {sum(1 for r in rows if r['loops_with_db']>0)}")
print()
print("TOP 40 by score (db_calls + 2*loops_with_db + 5*conn_cycles):")
hdr = f"{'window':42} {'sel':>4}{'ins':>4}{'upd':>4}{'del':>4}{'exec':>4}{'com':>4}{'rtr':>5}{'sto':>5}{'start':>5}{'loopDB':>6}{'maxLoop':>7}"
print(hdr)
for r in rows[:40]:
    print(f"{r['file'][:42]:42} {r['sql_select']:4}{r['sql_insert']:4}{r['sql_update']:4}{r['sql_delete']:4}{r['sql_exec']:4}{r['commit']:4}{r['retrieve']:5}{r['settransobject']:5}{r['start']:5}{r['loops_with_db']:6}{r['max_loop_db']:7}")
