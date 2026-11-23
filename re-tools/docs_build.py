"""Build the navigation / catalog / usage indexes of the application from the recovered artifacts.

Inputs : recovered/objects (definitions), recovered/scripts (*.pbs), recovered/datawindows_json, recovered/pcode_names/protos.json,
         db/schema.json
Outputs: docs/data/*.json  (machine-readable, consumed by the rebuild) and docs/*.md summaries.
usage: python -I docs_build.py
"""
import os, re, json, glob, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..'))
REC = os.path.join(ROOT, 'recovered')
DOCS = os.path.join(ROOT, 'docs')
DATA = os.path.join(DOCS, 'data')
os.makedirs(DATA, exist_ok=True)

HDR = re.compile(r'^// ([A-Za-z0-9_]+)\.([A-Za-z0-9_]+)\((.*?)\)(?: returns (.*))?$')

MODULES = [  # library-name pattern -> module
    (r'^(abuzarapp|dashboard|preferences|dropdowns|lists|labels|templates|popupmenus|printer|transfer|summary)$', 'Application shell & settings'),
    (r'^(components|multientry|multientrygroups|multientryitem|multientryitemrespwin|multientrypolicy|singleentry|singleentryitem|mgmtcomp|functions|barcodefunctions|dw2xls|graphcomponents|notescomponents|custcomponents|contactmanagement)$', 'Shared framework & master data'),
    (r'^accounts|^financialreports|^receipt|^cashierjob|^duecomponents|^agingreports', 'Accounts & cash'),
    (r'^purchase|^prcomponents|^proformapurchase|^advancedpurchase|^purchase&return|^pocomponents|^adjustment|^changeitemprice|^expiryintimation|^incentivesheet', 'Purchase & stock'),
    (r'^sale|^poscomponents|^advancedsale|^proformasales|^quotation|^billsummary|^ipsale|^ipservices|^salerespwin|^saleprintouts|^salemod|^reportviewer|^specialreports|^sprnt|^stockreports|^godownreports|^itemreports|^issue|^managementreports', 'Sales, POS & reports'),
    (r'^service', 'Services'),
    (r'^patient|^eprescription|^ipservices', 'Hospital / clinic'),
    (r'^student', 'School'),
    (r'^guest', 'Hotel / guest'),
    (r'^employee', 'Employees / HR'),
    (r'^sms', 'SMS'),
    (r'^crs|^datatransfer', 'Remote sync (CRS / data transfer)'),
    (r'^report|^packingmodule|^barcode|^psrviewer|^useratten|^pb', 'Reports, printing & utilities'),
]


def module_of(lib):
    for pat, name in MODULES:
        if re.search(pat, lib):
            return name
    return 'Other'


# ----------------------------------------------------------------------------------------------- scripts
def parse_scripts():
    out = {}
    for f in glob.glob(os.path.join(REC, 'scripts', '*', '*.pbs')):
        lib = os.path.basename(os.path.dirname(f))
        obj = os.path.splitext(os.path.basename(f))[0]
        rts, cur = {}, None
        for line in open(f, encoding='utf-8', errors='replace'):
            line = line.rstrip('\n')
            m = HDR.match(line)
            if m:
                cur = (m.group(1), m.group(2))
                rts[cur] = {'sig': line[3:], 'body': []}
            elif cur is not None:
                rts[cur]['body'].append(line)
        out[(lib, obj)] = rts
    return out


def load_objects():
    objs = {}
    for f in glob.glob(os.path.join(REC, 'objects', '*', '*', '*.json')):
        d = json.load(open(f, encoding='utf-8'))
        parts = f.replace('\\', '/').split('/')
        objs[(parts[-3], d['name'])] = d
    return objs


SQL_TABLE = re.compile(r'\b(?:from|join|update|into|delete\s+from|delete|insert)\s+(?:dbo\.)?([A-Za-z_][A-Za-z0-9_]*)', re.I)
SQL_KW = {'select', 'set', 'values', 'where', 'inserted', 'deleted', 'dbo', 'using', 'the', 'a', 'table', 'tempdb'}
OPEN_RE = re.compile(r'\b(open|opensheet|openwithparm|opensheetwithparm|openuserobject|openuserobjectwithparm)\(\s*([A-Za-z_][A-Za-z0-9_]*)')
DWO_RE = re.compile(r'dataobject\s*=\s*"([A-Za-z0-9_]+)"', re.I)
GF_RE = re.compile(r'\b(f_[a-z0-9_]+|uf_[a-z0-9_]+|gf_[a-z0-9_]+)\(', re.I)
PROP_RE = re.compile(r'^\s*this\.(text|microhelp|shortcut|toolbaritemname|toolbaritemtext|toolbaritemvisible|menuimage|toolbaritemspace|'
                     r'checked|visible|enabled|tag|toolbaritembarindex|toolbaritemorder|title) = (.*)$')


def sql_tables(text):
    return {m.group(1).lower() for m in SQL_TABLE.finditer(text)} - SQL_KW


def routine_text(r):
    return '\n'.join(r['body'])


def main():
    scripts = parse_scripts()
    objects = load_objects()
    schema = json.load(open(os.path.join(ROOT, 'db', 'schema.json'), encoding='utf-8'))
    tabs = schema['tables']
    table_names = {(t['name'] if isinstance(t, dict) else t).lower().split('.')[-1] for t in (tabs if isinstance(tabs, list) else tabs.values())} \
        if not isinstance(tabs, dict) else {k.lower().split('.')[-1] for k in tabs}

    # stored procedures exposed through the transaction object (RPC declarations)
    procs = set()
    for (lib, name), o in objects.items():
        pass
    protos = json.load(open(os.path.join(REC, 'pcode_names', 'protos.json'), encoding='utf-8'))['protos']
    rpc = {e[0].lower() for e in protos.get('u_transaction', {}).values()}

    # ---------------------------------------------------------------- windows / userobjects / functions
    catalog = {}
    usage_tables = collections.defaultdict(lambda: {'windows': set(), 'functions': set(), 'datawindows': set()})
    for (lib, obj), rts in scripts.items():
        o = objects.get((lib, obj)) or {}
        kind = o.get('kind') or ('function' if obj.startswith('f_') else '?')
        fields = {f['name']: f['value'] for f in o.get('fields', [])} if o else {}
        entry = {'name': obj, 'library': lib, 'module': module_of(lib), 'kind': kind, 'ancestor': o.get('ancestor'),
                 'title': fields.get('title'), 'width': fields.get('width'), 'height': fields.get('height'),
                 'x': fields.get('x'), 'y': fields.get('y'), 'menu': fields.get('menuname'), 'windowtype': fields.get('windowtype'),
                 'controls': [], 'opens': set(), 'datawindows': set(), 'tables': set(), 'procs': set(), 'globals': set(),
                 'events': [], 'functions': [], 'lines': 0}
        for c in o.get('controls', []):
            cf = {f['name']: f['value'] for f in c.get('fields', [])}
            entry['controls'].append({'name': c['name'], 'class': c.get('ancestor'), 'text': cf.get('text'), 'dataobject': cf.get('dataobject'),
                                      'x': cf.get('x'), 'y': cf.get('y'), 'width': cf.get('width'), 'height': cf.get('height')})
            if cf.get('dataobject'):
                entry['datawindows'].add(cf['dataobject'])
        for (owner, rname), r in rts.items():
            text = routine_text(r)
            entry['lines'] += len(r['body'])
            (entry['events'] if owner and rname in ('clicked', 'open', 'create', 'destroy', 'close', 'closequery', 'key', 'itemchanged') or
             rname.startswith('ue_') else entry['functions']).append('%s.%s' % (owner, rname))
            entry['opens'].update(m.group(2) for m in OPEN_RE.finditer(text) if m.group(2).startswith('w_'))
            entry['datawindows'].update(m.group(1) for m in DWO_RE.finditer(text))
            entry['globals'].update(m.group(1).lower() for m in GF_RE.finditer(text))
            for line in r['body']:
                s = line.strip()
                if s.startswith('SQL '):
                    entry['tables'].update(sql_tables(s))
            entry['procs'].update(n for n in rpc if re.search(r'\.%s\(' % re.escape(n), text))
            if not entry['title']:
                m = re.search(r'this\.title = "([^"]*)"', text)
                if m and owner == obj:
                    entry['title'] = m.group(1)
        catalog[(lib, obj)] = entry
        for t in entry['tables']:
            usage_tables[t][('functions' if kind == 'function' else 'windows')].add(obj)

    # ---------------------------------------------------------------- menus
    menus = {}
    for (lib, name), o in objects.items():
        if o.get('kind') != 'menu':
            continue
        rts = scripts.get((lib, name), {})

        def item(node):
            props = {}
            create = rts.get((node['name'], 'create'))
            if create:
                for line in create['body']:
                    m = PROP_RE.match(line)
                    if m:
                        props[m.group(1)] = m.group(2).strip().strip('"')
            click = rts.get((node['name'], 'clicked'))
            action = None
            if click:
                body = routine_text(click)
                action = {'opens': sorted({m.group(2) for m in OPEN_RE.finditer(body)}),
                          'calls': sorted(set(m.group(1).lower() for m in GF_RE.finditer(body))),
                          'lines': len(click['body'])}
            d = {'name': node['name'], 'props': props, 'action': action}
            kids = [item(c) for c in node.get('controls', [])]
            if kids:
                d['items'] = kids
            return d
        menus[name] = {'library': lib, 'items': [item(c) for c in o.get('controls', [])]}
    json.dump(menus, open(os.path.join(DATA, 'menus.json'), 'w', encoding='utf-8'), indent=1, ensure_ascii=False)

    # ---------------------------------------------------------------- datawindows
    dws = {}
    for f in glob.glob(os.path.join(REC, 'datawindows_json', '*', '*.json')):
        d = json.load(open(f, encoding='utf-8'))
        name = os.path.splitext(os.path.basename(f))[0]
        t = d.get('table') or {}
        sqltxt = t.get('retrieve') or ''
        dws[name] = {'library': os.path.basename(os.path.dirname(f)), 'tables': sorted(sql_tables(sqltxt)),
                     'columns': len(t.get('columns', [])), 'update': t.get('update'), 'usedby': []}
    for (lib, obj), e in catalog.items():
        for dw in e['datawindows']:
            if dw in dws:
                dws[dw]['usedby'].append(obj)
                for t in dws[dw]['tables']:
                    usage_tables[t]['datawindows'].add(dw)
    json.dump(dws, open(os.path.join(DATA, 'datawindows.json'), 'w', encoding='utf-8'), indent=0, ensure_ascii=False)

    # ---------------------------------------------------------------- serialise
    def ser(e):
        return {k: (sorted(v) if isinstance(v, set) else v) for k, v in e.items()}
    cat = [ser(e) for e in sorted(catalog.values(), key=lambda e: (e['module'], e['library'], e['name']))]
    json.dump(cat, open(os.path.join(DATA, 'objects_catalog.json'), 'w', encoding='utf-8'), indent=0, ensure_ascii=False)
    tu = {t: {k: sorted(v) for k, v in u.items()} for t, u in sorted(usage_tables.items())}
    json.dump(tu, open(os.path.join(DATA, 'table_usage.json'), 'w', encoding='utf-8'), indent=0, ensure_ascii=False)
    libs = collections.defaultdict(lambda: collections.Counter())
    for e in cat:
        libs[e['library']][e['kind']] += 1
    json.dump({l: {'module': module_of(l), **dict(c)} for l, c in sorted(libs.items())},
              open(os.path.join(DATA, 'libraries.json'), 'w', encoding='utf-8'), indent=1)
    # inheritance
    inh = {e['name']: e['ancestor'] for e in cat if e['ancestor']}
    json.dump(inh, open(os.path.join(DATA, 'inheritance.json'), 'w', encoding='utf-8'), indent=0)
    print('objects', len(cat), 'menus', len(menus), 'datawindows', len(dws), 'tables used', len(tu),
          'unknown tables', sorted(t for t in tu if t not in table_names)[:10])


if __name__ == '__main__':
    main()
