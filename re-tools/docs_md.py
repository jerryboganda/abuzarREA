"""Markdown documents generated from docs/data (run docs_build.py first).
Outputs: docs/NAVIGATION.md, docs/catalog/<module>.md, docs/journeys/<window>.md, docs/DATA-ACCESS.md, docs/EXTERNAL-COMPONENTS.md
usage: python -I docs_md.py"""
import os, re, json, glob, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..'))
DOCS = os.path.join(ROOT, 'docs')
DATA = os.path.join(DOCS, 'data')
REC = os.path.join(ROOT, 'recovered')


def jl(name):
    return json.load(open(os.path.join(DATA, name), encoding='utf-8'))


def slug(s):
    return re.sub(r'[^a-z0-9]+', '-', s.lower()).strip('-')


def clean(t):
    return (t or '').replace('&', '').replace('~t', '  [').rstrip() + (']' if t and '~t' in t else '')


# ----------------------------------------------------------------------------------------------- rights seed
def load_rights():
    rows = {}
    seed = os.path.join(ROOT, 'db', 'seed', 'seed_ledger.sql')
    pat = re.compile(r"insert\s+into\s+rights\s+(?:\([^)]*\)\s*)?values\s*\(\s*(\d+)\s*,\s*'((?:[^']|'')*)'\s*,\s*'((?:[^']|'')*)'\s*,\s*(\d+)\s*,\s*'([\d,]*)'\s*,\s*'(\w*)'", re.I)
    if os.path.exists(seed):
        for line in open(seed, encoding='utf-8', errors='replace'):
            for m in pat.finditer(line):
                rows[int(m.group(1))] = {'code': int(m.group(1)), 'name': m.group(2).replace("''", "'"), 'menu': m.group(3),
                                         'level': int(m.group(4)), 'indices': m.group(5), 'object': m.group(6)}
    return rows


# ----------------------------------------------------------------------------------------------- menus
def resolve_targets(lib_scripts, owner_obj, item_name):
    """window(s) a menu item opens: from its clicked script (declared local window types, string class names, open() calls)"""
    return None


def main():
    menus = jl('menus.json')
    cat = jl('objects_catalog.json')
    dws = jl('datawindows.json')
    tu = jl('table_usage.json')
    ext = jl('external_libs.json')
    rights = load_rights()
    by_name = {e['name']: e for e in cat}
    os.makedirs(os.path.join(DOCS, 'catalog'), exist_ok=True)
    os.makedirs(os.path.join(DOCS, 'journeys'), exist_ok=True)

    # script text per menu item click (to find window targets declared as local variable types)
    click_text = {}
    for f in glob.glob(os.path.join(REC, 'scripts', '*', 'm_*.pbs')):
        t = open(f, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'^// (\w+)\.clicked\(.*?\n(.*?)(?=\n// |\Z)', t, re.S | re.M):
            click_text[(os.path.basename(f)[:-4], m.group(1))] = m.group(2)

    def targets(menu_obj, item):
        body = click_text.get((menu_obj, item['name'])) or ''
        found = []
        for m in re.finditer(r'^\s*(w_[a-z0-9_]+)\s+lw_\w+', body, re.M):
            found.append('sheet:' + m.group(1))
        for m in re.finditer(r'\bopen(?:sheet)?(?:withparm)?\(\s*(w_[a-z0-9_]+)', body):
            found.append('open:' + m.group(1))
        for m in re.finditer(r'"(w_[a-z0-9_]+)"', body):
            found.append('open:' + m.group(1))
        for m in re.finditer(r'\b(mf_\w+|wf_\w+)\(([^)]*)\)', body):
            found.append('call:%s(%s)' % (m.group(1), m.group(2)[:60]))
        return list(dict.fromkeys(found))

    # ---------- NAVIGATION.md : the application menu (m_mainmenu, inherited by m_entry) with rights
    path_rights = {r['indices']: r for r in rights.values() if r['object'] == 'A'}
    lines = ['# Navigation: the application menu', '',
             'The MDI frame `w_main` uses menu `m_entry`, which inherits `m_mainmenu` (718 items). Visibility/enabled state of every item comes from '
             'the `d_security` DataWindow (rows of `levelindex`, `indicesstring` = index path of the item, `status`) filtered by the logged-in user; '
             'right codes below are from the migration seed (`rights` table, object `A`). Items marked `sheet:` open an MDI sheet, `open:` a modal window, '
             '`call:` run a helper (`mf_openvoucher` ... ).', '']

    def walk(items, obj, depth, path):
        for i, it in enumerate(items, 1):
            p = path + [i]
            t = clean(it['props'].get('text')) or ('-' * 3 if it['name'].startswith('m_-') or it['name'].startswith('m__') else it['name'])
            if t.strip('-') == '' and it['name'].startswith(('m_-', 'm__')):
                continue
            tg = targets(obj, it)
            r = path_rights.get(','.join(map(str, p)) + ',')
            extra = []
            if it['props'].get('shortcut'):
                extra.append('shortcut ' + it['props']['shortcut'])
            if r:
                extra.append('right %d' % r['code'])
            lines.append('%s- **%s** (`%s`)%s%s' % ('  ' * depth, t.strip(), it['name'],
                                                 ' - ' + ', '.join('`%s`' % x for x in tg) if tg else '',
                                                 ' _(%s)_' % '; '.join(extra) if extra else ''))
            walk(it.get('items', []), obj, depth + 1, p)

    mm = menus.get('m_mainmenu')
    if mm:
        walk(mm['items'], 'm_mainmenu', 0, [])
    lines += ['', '## Other menus (per-window sheet menus and legacy `m_main`)', '']
    inh = jl('inheritance.json')
    for name, m in sorted(menus.items()):
        if name == 'm_mainmenu':
            continue
        n = sum(1 for _ in m['items'])
        used = [e['name'] for e in cat if e.get('menu') == name]
        lines.append('- `%s` (%s): %d own top-level items; ancestor `%s`; used by %d windows' % (name, m['library'], n, inh.get(name), len(used)))
    open(os.path.join(DOCS, 'NAVIGATION.md'), 'w', encoding='utf-8').write('\n'.join(lines) + '\n')

    # ---------- catalog per module
    mods = collections.defaultdict(list)
    for e in cat:
        mods[e['module']].append(e)
    idx = ['# Object catalog', '', 'Every window, user object, menu and global function by module; machine-readable data in `docs/data/objects_catalog.json`.', '']
    for mod, es in sorted(mods.items()):
        fn = 'catalog/%s.md' % slug(mod)
        idx.append('- [%s](%s) - %d objects (%d windows)' % (mod, fn, len(es), sum(1 for e in es if e['kind'] == 'window')))
        out = ['# ' + mod, '', '| object | kind | library | title | size (w x h) | ancestor | DataWindows | tables | procedures | opens |', '|---|---|---|---|---|---|---|---|---|---|']
        for e in es:
            out.append('| `%s` | %s | %s | %s | %s | %s | %s | %s | %s | %s |' % (
                e['name'], e['kind'], e['library'], (e['title'] or '').replace('|', '/'),
                ('%s x %s' % (e['width'], e['height'])) if e['width'] else '', e['ancestor'] or '',
                ', '.join(e['datawindows'][:6]) + (' ...' if len(e['datawindows']) > 6 else ''),
                ', '.join(e['tables'][:8]) + (' ...' if len(e['tables']) > 8 else ''),
                ', '.join(e['procs'][:5]), ', '.join(e['opens'][:5])))
        open(os.path.join(DOCS, fn), 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    open(os.path.join(DOCS, 'CATALOG.md'), 'w', encoding='utf-8').write('\n'.join(idx) + '\n')

    # ---------- data access
    top = sorted(tu.items(), key=lambda kv: -(len(kv[1]['windows']) + len(kv[1]['functions']) + len(kv[1]['datawindows'])))[:80]
    da = ['# Data access map', '', 'Tables most used by windows / functions / DataWindows (from embedded SQL and DataWindow SQL). Full data: `docs/data/table_usage.json`.', '',
          '| table | windows | functions | DataWindows |', '|---|---|---|---|']
    for t, u in top:
        da.append('| `%s` | %d | %d | %d |' % (t, len(u['windows']), len(u['functions']), len(u['datawindows'])))
    open(os.path.join(DOCS, 'DATA-ACCESS.md'), 'w', encoding='utf-8').write('\n'.join(da) + '\n')

    # ---------- external components
    ex = ['# External components referenced by the compiled code', '', '| library / program | objects |', '|---|---|']
    for dll, objs in ext.items():
        ex.append('| `%s` | %s |' % (dll, ', '.join('`%s`' % o for o in list(objs)[:8]) + (' ...' if len(objs) > 8 else '')))
    open(os.path.join(DOCS, 'EXTERNAL-COMPONENTS.md'), 'w', encoding='utf-8').write('\n'.join(ex) + '\n')

    # ---------- journey cards for the largest windows
    # menu path(s) leading to each window
    reach = collections.defaultdict(list)
    if mm:
        def w2(items, path):
            for it in items:
                t = clean(it['props'].get('text')).strip()
                tg = targets('m_mainmenu', it)
                for x in tg:
                    reach[x.split(':', 1)[1]].append(' > '.join(path + [t]))
                w2(it.get('items', []), path + [t])
        w2(mm['items'], [])
    big = sorted((e for e in cat if e['kind'] == 'window'), key=lambda e: -e['lines'])[:60]
    for e in big:
        out = ['# %s' % e['name'], '', '- title: %s' % (e['title'] or '(set at run time)'), '- library: %s (%s)' % (e['library'], e['module']),
               '- ancestor: `%s`' % e['ancestor'], '- size: %s x %s PBU' % (e['width'], e['height']),
               '- reached from: %s' % ('; '.join(reach.get(e['name'], [])[:6]) or '(opened from code / other windows)'),
               '- script size: %d lines; %d events, %d functions' % (e['lines'], len(e['events']), len(e['functions'])), '',
               '## Controls (%d)' % len(e['controls']), '']
        for c in e['controls'][:80]:
            out.append('- `%s` (%s)%s%s' % (c['name'], c['class'] or '?', ' text "%s"' % c['text'] if c['text'] else '',
                                          ' dataobject `%s`' % c['dataobject'] if c['dataobject'] else ''))
        out += ['', '## Data', '', '- DataWindows: ' + (', '.join('`%s`' % d for d in e['datawindows']) or '-'),
                '- tables touched by embedded SQL: ' + (', '.join(e['tables']) or '-'), '- stored procedures: ' + (', '.join(e['procs']) or '-'),
                '- global functions: ' + (', '.join(e['globals']) or '-'), '- windows opened: ' + (', '.join(e['opens']) or '-'), '',
                '## Events and functions', '', ', '.join('`%s`' % x for x in e['events'] + e['functions'])[:6000], '',
                'Source: `recovered/scripts/%s/%s.pbs`' % (e['library'], e['name'])]
        open(os.path.join(DOCS, 'journeys', e['name'] + '.md'), 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    print('menus', len(menus), 'rights seed rows', len(rights), 'journey cards', len(big))


if __name__ == '__main__':
    main()
