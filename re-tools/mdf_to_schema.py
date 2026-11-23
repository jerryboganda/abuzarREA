"""Turn the catalog parsed by mdf2000.py into schema files (SQL Server dialect + JSON). Schema only, no row data.

usage: python -I mdf_to_schema.py <file.mdf> <out_dir>
"""
import os, sys, json, struct, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mdf2000 import load_catalog, XTYPES

SKIP_TABLES = {'dtproperties'}


def type_string(c, ut):
    xt = c['xtype']
    name = XTYPES.get(xt, 'xtype_%d' % xt)
    if c['xusertype'] > 256 and c['xusertype'] in ut:
        return ut[c['xusertype']]
    ln = c['length']
    if name in ('varchar', 'char', 'binary', 'varbinary'):
        return '%s(%s)' % (name, 'max' if ln in (-1, 0) else ln)
    if name in ('nvarchar', 'nchar'):
        return '%s(%s)' % (name, 'max' if ln in (-1, 0) else ln // 2)
    if name in ('decimal', 'numeric'):
        return '%s(%d,%d)' % (name, c['prec'], c['scale'])
    return name


def keys_of(var0, keycnt):
    """sysindexes.keys: 32-byte blocks, key column id at +16."""
    out = []
    for i in range(0, len(var0) - 31, 32):
        out.append(struct.unpack_from('<H', var0, i + 16)[0])
    return out[:keycnt] if keycnt else out


def build(mdf):
    cat = load_catalog(mdf)
    objs, cols, comments, ut = cat['objects'], cat['columns'], cat['comments'], cat['usertypes']
    byparent = collections.defaultdict(list)
    for o in objs.values():
        byparent[o['parent']].append(o)

    def text_of(oid):
        parts = [(k[1], v) for k, v in comments.items() if k[0] == oid]
        return ''.join(v for _, v in sorted(parts)) if parts else None

    comment_by_id = collections.defaultdict(list)
    for (oid, num), v in comments.items():
        comment_by_id[oid].append((num, v))

    def text(oid):
        parts = comment_by_id.get(oid)
        return ''.join(v for _, v in sorted(parts)) if parts else None

    tables = {}
    for o in sorted((o for o in objs.values() if o['type'] == 'U'), key=lambda o: o['name'].lower()):
        if o['name'].lower() in SKIP_TABLES or o['id'] not in cols:
            continue
        cl = []
        for c in cols[o['id']]:
            d = objs.get(c['cdefault']) if c['cdefault'] else None
            cl.append({'name': c['name'], 'type': type_string(c, ut), 'notnull': bool(c['fixed'][5] & 1),
                       'identity': bool(c['colstat'] & 1),
                       'default': ({'name': d['name'], 'expr': (text(d['id']) or '').strip()} if d and d['type'] == 'D' else None)})
        tables[o['name']] = {'id': o['id'], 'columns': cl, 'pk': None, 'unique': [], 'indexes': [], 'fks': [], 'checks': []}
    id2name = {v['id']: k for k, v in tables.items()}
    colname = {tid: {c['colid']: c['name'] for c in cols[tid]} for tid in id2name}

    # indexes / PK / UNIQUE
    clustered_keys = {}
    rows = []
    for fixed, var in cat['sysindexes_rows']:
        if len(fixed) < 26 or len(var) < 2:
            continue
        tid, status = struct.unpack_from('<Ii', fixed, 0)
        indid, = struct.unpack_from('<H', fixed, 14)
        keycnt, = struct.unpack_from('<H', fixed, 24)
        if tid not in id2name or indid == 0 or indid >= 255 or status & 0x20:
            continue
        name = var[1].decode('utf-16le', 'replace')
        rows.append((tid, status, indid, keycnt, keys_of(var[0], 0), name))
        if indid == 1:
            clustered_keys[tid] = keycnt
    for tid, status, indid, keycnt, ks, name in rows:
        n = keycnt
        if indid > 1 and tid in clustered_keys:
            # SQL Server 2000 appends the clustering key (and uniquifier) to every nonclustered index
            n = max(1, keycnt - clustered_keys[tid])
        cn = []
        for k in ks[:n]:
            if k == 0:   # hidden uniquifier column
                continue
            nm = colname[tid].get(k, '?%d' % k)
            if nm not in cn:
                cn.append(nm)
        t = tables[id2name[tid]]
        ent = {'name': name, 'columns': cn, 'clustered': bool(status & 16) if indid == 1 else False}
        if status & 0x800:
            t['pk'] = ent
        elif status & 0x1000:
            t['unique'].append(ent)
        else:
            ent['unique'] = bool(status & 2)
            t['indexes'].append(ent)

    # foreign keys
    for fixed, var in cat['sysreferences_rows']:
        if len(fixed) < 16 or len(var) < 2:
            continue
        cid, fid, rid = struct.unpack_from('<III', fixed, 0)
        if fid not in id2name or rid not in id2name:
            continue
        if len(var[0]) > 32 or len(var[0]) % 2 or len(var[1]) != len(var[0]):
            continue
        fk =[struct.unpack_from('<H', var[0], i)[0] for i in range(0, len(var[0]), 2)]
        rk = [struct.unpack_from('<H', var[1], i)[0] for i in range(0, len(var[1]), 2)]
        co = objs.get(cid, {})
        tables[id2name[fid]]['fks'].append({
            'name': co.get('name') or '', 'columns': [colname[fid].get(k, '?') for k in fk],
            'ref_table': id2name[rid], 'ref_columns': [colname[rid].get(k, '?') for k in rk],
            'status': co.get('status', 0)})
    # check constraints
    for o in objs.values():
        if o['type'] == 'C' and o['parent'] in id2name:
            tables[id2name[o['parent']]]['checks'].append({'name': o['name'], 'expr': (text(o['id']) or '').strip()})

    progs = {'procedure': {}, 'function': {}, 'view': {}, 'trigger': {}}
    kind = {'P': 'procedure', 'FN': 'function', 'TF': 'function', 'IF': 'function', 'V': 'view', 'TR': 'trigger'}
    for o in objs.values():
        if o['type'] in kind and not o['name'].startswith('dt_'):
            t = text(o['id'])
            if t:
                progs[kind[o['type']]][o['name']] = {'id': o['id'], 'parent': id2name.get(o['parent']), 'body': t}
    return tables, progs


def render_sql(tables, progs, out):
    os.makedirs(os.path.join(out, 'schema'), exist_ok=True)
    tsql, fksql, idxsql = [], [], []
    for name, t in tables.items():
        lines = []
        for c in t['columns']:
            s = '[%s] %s%s %s' % (c['name'], c['type'], ' IDENTITY(1,1)' if c['identity'] else '', 'NOT NULL' if c['notnull'] else 'NULL')
            if c['default']:
                s += ' CONSTRAINT [%s] DEFAULT %s' % (c['default']['name'], c['default']['expr'])
            lines.append(s)
        if t['pk']:
            lines.append('CONSTRAINT [%s] PRIMARY KEY %s(%s)' % (t['pk']['name'], 'CLUSTERED ' if t['pk']['clustered'] else 'NONCLUSTERED ',
                                                                 ', '.join('[%s]' % x for x in t['pk']['columns'])))
        for u in t['unique']:
            lines.append('CONSTRAINT [%s] UNIQUE (%s)' % (u['name'], ', '.join('[%s]' % x for x in u['columns'])))
        for ck in t['checks']:
            lines.append('CONSTRAINT [%s] CHECK %s' % (ck['name'], ck['expr']))
        tsql.append('CREATE TABLE [dbo].[%s] (\n    %s\n);\nGO\n' % (name, ',\n    '.join(lines)))
        for fk in t['fks']:
            nm = fk['name'] or 'FK_%s_%s_%s' % (name, fk['ref_table'], '_'.join(fk['columns']))
            fksql.append('ALTER TABLE [dbo].[%s] ADD CONSTRAINT [%s] FOREIGN KEY (%s) REFERENCES [dbo].[%s] (%s);' % (
                name, nm, ', '.join('[%s]' % x for x in fk['columns']), fk['ref_table'], ', '.join('[%s]' % x for x in fk['ref_columns'])))
        for ix in t['indexes']:
            idxsql.append('CREATE %sINDEX [%s] ON [dbo].[%s] (%s);' % ('UNIQUE ' if ix['unique'] else '', ix['name'], name,
                                                                          ', '.join('[%s]' % x for x in ix['columns'])))
    hdr = '-- Reconstructed from the SQL Server 2000-format V2 database file (catalog pages), schema only\n\n'
    w = lambda fn, s: open(os.path.join(out, 'schema', fn), 'w', encoding='utf-8', newline='\n').write(hdr + s)
    w('01_tables.sql', '\n'.join(tsql))
    w('02_foreign_keys.sql', '\nGO\n'.join(fksql) + '\nGO\n')
    w('03_indexes.sql', '\nGO\n'.join(idxsql) + '\nGO\n')
    for fn, k in (('04_functions.sql', 'function'), ('05_views.sql', 'view'), ('06_procedures.sql', 'procedure'), ('07_triggers.sql', 'trigger')):
        w(fn, '\n'.join('-- %s\n%s\nGO\n' % (n, p['body'].rstrip()) for n, p in sorted(progs[k].items(), key=lambda kv: kv[0].lower())))


if __name__ == '__main__':
    mdf, out = sys.argv[1], sys.argv[2]
    tables, progs = build(mdf)
    render_sql(tables, progs, out)
    with open(os.path.join(out, 'schema.json'), 'w', encoding='utf-8') as f:
        json.dump({'tables': tables, 'objects': {k: sorted(v) for k, v in progs.items()}, 'bodies': progs}, f, indent=1)
    print('tables', len(tables), 'columns', sum(len(t['columns']) for t in tables.values()),
          'pk', sum(1 for t in tables.values() if t['pk']), 'unique', sum(len(t['unique']) for t in tables.values()),
          'indexes', sum(len(t['indexes']) for t in tables.values()), 'fks', sum(len(t['fks']) for t in tables.values()),
          'checks', sum(len(t['checks']) for t in tables.values()), {k: len(v) for k, v in progs.items()})
