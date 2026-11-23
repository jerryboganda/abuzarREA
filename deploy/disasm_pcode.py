import json, sys, base64
sys.path.insert(0, r'C:\Projects\Abuzar\deploy')
from pcode_blocks_local import Routine

def load(path):
    return json.load(open(path, encoding='utf-8'))

def disasm(path, out):
    d = load(path)
    lines = []
    lines.append('OBJECT: %s  ancestor=%s  kind=%s  lib=%s  group=%s' % (
        d.get('name'), d.get('ancestor'), d.get('kind'), d.get('library'), d.get('group')))
    classes = d.get('classes') or {}
    enums = d.get('enums') or {}
    sqlpool = d.get('sqlpool')
    sqlbytes = base64.b64decode(sqlpool['b64']) if sqlpool else b''
    def sqlstr(off):
        e = off
        while e + 1 < len(sqlbytes) and not (sqlbytes[e] == 0 and sqlbytes[e+1] == 0):
            e += 2
        return sqlbytes[off:e].decode('utf-16-le', 'replace')

    def dump_node(node, indent=0):
        pre = '  ' * indent
        lines.append('')
        lines.append(pre + '#' * 90)
        lines.append(pre + 'NODE %s  ancestor=%s  routines=%d controls=%d' % (
            node.get('name'), node.get('ancestor'), len(node.get('routines', [])), len(node.get('controls', []))))
        for r in node.get('routines', []):
            R = Routine(r)
            locals_by_idx = R.locals
            globals_by_slot = {l['slot']: l['name'] for l in R.locals if l['slot'] != 0}
            lines.append(pre + '-' * 90)
            lines.append(pre + 'ROUTINE %s  event=%s  routine=%s  bytes=%s  exact=%s  code_off=%s' % (
                r.get('name'), r.get('event'), r.get('routine'), r.get('bytes'), r.get('exact'), r.get('code_off')))
            lines.append(pre + 'LOCALS: ' + ', '.join('%d:%s' % (i, l['name']) for i, l in enumerate(R.locals)))
            for ins in r.get('instrs', []):
                idx, op, args = ins
                ann = []
                if op in ('PUSH_LOCAL_VAR', 'PUSH_LOCAL_VAR_LV', 'PUSH_LOCAL_VAR_RP'):
                    n = args[0]
                    ann.append(locals_by_idx[n]['name'] if n < len(locals_by_idx) else '?local%d' % n)
                elif op in ('PUSH_LOCAL_GLOBREF', 'PUSH_LOCAL_GLOBREF_LV', 'PUSH_LOCAL_GLOBREF_RP'):
                    n = args[0]
                    ann.append(globals_by_slot.get(n, '?global%d' % n))
                elif op == 'PUSH_CONST_REF':
                    off = args[0]
                    ref = R.ref(off)
                    s = R.string(off)
                    if ref:
                        ann.append('ref=%r' % (ref,))
                    elif s is not None:
                        ann.append('str=%r' % s)
                    else:
                        ann.append('off=%d' % off)
                elif op == 'PUSH_CONST_STRING':
                    off = args[0]
                    s = R.string(off)
                    ann.append('str=%r' % s if s is not None else 'off=%d' % off)
                elif op == 'PUSH_CONST_LONG':
                    ann.append(str(args[0] | (args[1] << 16)))
                elif op == 'PUSH_CONST_DEC':
                    ann.append('raw=%r' % (args,))
                elif op == 'PUSH_CONST_ENUM':
                    t = args[1] if len(args) > 1 else None
                    v = args[0]
                    em = enums.get(str(t)) or {}
                    ann.append('enum[%s]=%s' % (t, em.get(str(v)) or em.get(v) or v))
                elif op == 'PUSH_FUNC_CLASS':
                    proto, cref = args[0], args[1]
                    c = classes.get(str(cref))
                    if c:
                        p = (c.get('protos') or {}).get(str(proto)) or {}
                        ann.append('%s.%s' % (c.get('name'), p.get('name') or ('proto%d' % proto)))
                    else:
                        ann.append('class=%s proto=%s' % (cref, proto))
                elif op == 'EVENTCALL':
                    ev = args[0]
                    cref = args[2] if len(args) > 2 else None
                    c = classes.get(str(cref))
                    if c:
                        p = (c.get('protos') or {}).get(str(ev)) or {}
                        ann.append('%s.%s' % (c.get('name'), p.get('name') or ('event%d' % ev)))
                    else:
                        ann.append('event=%s class=%s' % (ev, cref))
                elif op in ('DBSELECT', 'DBUPDATE', 'DBDELETE', 'DBINSERT'):
                    off = args[0]
                    ann.append('SQL@%d: %s' % (off, sqlstr(off)[:220].replace('\r',' ').replace('\n',' ')))
                lines.append(pre + '%5d  %-32s %-30s %s' % (idx, op, str(args), ' ; '.join(ann)))
        for c in node.get('controls', []):
            dump_node(c, indent + 1)

    dump_node(d)
    txt = '\n'.join(lines)
    open(out, 'w', encoding='utf-8').write(txt)
    print('wrote', out, len(txt), 'bytes')

if __name__ == '__main__':
    disasm(sys.argv[1], sys.argv[2])
