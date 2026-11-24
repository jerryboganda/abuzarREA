"""Regenerate PowerBuilder export source (.sr*) from the recovered application, in the `ws_objects` layout that
Appeon's free PBAutoBuild merges into PBLs and compiles (ws_objects/<library>.pbl.src/<object>.sr?).

    python -I re-tools/pbsrc_export.py . pbsrc          (first argument: the project folder that holds recovered/)

Inputs:  recovered/scripts (decompiled PowerScript), recovered/objects (properties, controls, instance variables),
         recovered/pcode (prototype records: which events a class declares itself and their message ids),
         recovered/pcode_names (enums_all.json, pbm_ids.json, shared_vars.json, global_types.json),
         recovered/datawindows (already export source).
Outputs: pbsrc/ws_objects/**, pbsrc/abuzar.pbt, pbsrc/export-report.json.

Nothing written here has been compiled yet.  export-report.json counts what was written and lists every place where
the generator had to leave something out or guess; it is not a build result.
"""
import glob
import json
import os
import re
import struct
import sys

HDR = re.compile(r'^// (\S+?)\.([^()]*)\((.*)\) returns (.+?)(?: \[(\w+)\])?\s*$')
FIRST = re.compile(r'^// (\w+) (\S+) \((\w+)\)\s+ancestor: (\S+)')
BOM = '﻿'
EXT = {'window': 'srw', 'userobject': 'sru', 'menu': 'srm', 'structure': 'srs', 'application': 'sra', 'function': 'srf'}

# obj_export.py labels the primitive type ids 8..14 and 18 wrongly (the decompiler's table in pcode_lift.py is the right
# one: 8 any, 9 unsignedinteger, 10 unsignedlong, 11 blob, 12 date, 13 time, 14 datetime, 18 char); corrected here
PRIMFIX = {'date': 'any', 'time': 'unsignedinteger', 'handle': 'unsignedlong', 'datetime': 'date', 'byte': 'time',
           'longlong': 'datetime', 'type_18': 'char'}
PRIMNUM = {1: 'integer', 2: 'long', 3: 'real', 4: 'double', 5: 'decimal', 6: 'string', 7: 'boolean', 8: 'any',
           9: 'unsignedinteger', 10: 'unsignedlong', 11: 'blob', 12: 'date', 13: 'time', 14: 'datetime', 18: 'char',
           20: 'longlong', 21: 'byte'}
NUMERIC = {'integer', 'long', 'real', 'double', 'unsignedinteger', 'unsignedlong', 'longlong', 'byte'}

# events the system classes define themselves: a script for one of these needs no declaration in the object
COMMON = {'constructor', 'destructor', 'dragdrop', 'dragenter', 'dragleave', 'dragwithin', 'getfocus', 'losefocus', 'help',
          'other', 'rbuttondown'}
STD = {
    'window': {'activate', 'clicked', 'close', 'closequery', 'deactivate', 'doubleclicked', 'dragdrop', 'dragenter', 'dragleave',
               'dragwithin', 'help', 'hide', 'hotlinkalarm', 'key', 'mousedown', 'mousemove', 'mouseup', 'open', 'other',
               'rbuttondown', 'remoteexec', 'remotehotlinkstart', 'remotehotlinkstop', 'remoterequest', 'remotesend', 'resize',
               'show', 'systemkey', 'timer', 'toolbarmoved'},
    'application': {'close', 'connectionbegin', 'connectionend', 'idle', 'open', 'systemerror'},
    'menu': {'clicked', 'selected', 'help'},
    'datawindow': COMMON | {'buttonclicked', 'buttonclicking', 'clicked', 'collapsed', 'collapsing', 'dberror', 'doubleclicked',
                            'editchanged', 'error', 'expanded', 'expanding', 'graphcreate', 'itemchanged',
                            'itemerror', 'itemfocuschanged', 'printend', 'printmarginchange', 'printpage', 'printstart',
                            'processenter', 'resize', 'retrieveend', 'retrieverow', 'retrievestart', 'rowfocuschanged',
                            'rowfocuschanging', 'scrollhorizontal', 'scrollvertical', 'sqlpreview', 'tabdownout', 'tabout',
                            'tabupout', 'updateend', 'updatestart', 'wserror'},
    'datastore': {'constructor', 'destructor', 'dberror', 'error', 'itemchanged', 'itemerror', 'printend',
                  'printpage', 'printstart', 'retrieveend', 'retrieverow', 'retrievestart', 'sqlpreview', 'updateend',
                  'updatestart', 'wserror'},
    'tab': COMMON | {'clicked', 'doubleclicked', 'key', 'rightclicked', 'rightdoubleclicked', 'selectionchanged',
                     'selectionchanging'},
    # activate / deactivate / canbepooled of a non-visual object are not predefined: the class that scripts them declares
    # them itself (`event activate pbm_component_activate`)
    'nonvisualobject': {'constructor', 'destructor'},
    'transaction': {'constructor', 'destructor', 'dbnotification', 'error'},
    'timing': {'constructor', 'destructor', 'timer'},
    'inet': {'constructor', 'destructor'},
}
for _c in ('commandbutton', 'picturebutton', 'checkbox', 'radiobutton', 'statichyperlink'):
    STD[_c] = COMMON | {'clicked'}
for _c in ('statictext', 'picture', 'picturehyperlink'):
    STD[_c] = COMMON | {'clicked', 'doubleclicked'}
for _c in ('singlelineedit', 'multilineedit', 'editmask'):
    STD[_c] = COMMON | {'modified'}
for _c in ('dropdownlistbox', 'dropdownpicturelistbox'):
    STD[_c] = COMMON | {'doubleclicked', 'modified', 'selectionchanged'}
for _c in ('listbox', 'picturelistbox'):
    STD[_c] = COMMON | {'doubleclicked', 'selectionchanged'}
STD['listview'] = COMMON | {'beginlabeledit', 'begindrag', 'beginrightdrag', 'clicked', 'columnclick', 'deleteallitems',
                            'deleteitem', 'doubleclicked', 'endlabeledit', 'insertitem', 'itemactivate', 'itemchanged',
                            'itemchanging', 'key', 'rightclicked', 'rightdoubleclicked', 'sort'}
STD['treeview'] = COMMON | {'beginlabeledit', 'begindrag', 'beginrightdrag', 'clicked', 'deleteitem', 'doubleclicked',
                            'endlabeledit', 'itemcollapsed', 'itemcollapsing', 'itemexpanded', 'itemexpanding', 'itempopulate',
                            'key', 'rightclicked', 'rightdoubleclicked', 'selectionchanged', 'selectionchanging', 'sort'}
STD['userobject'] = COMMON
STD['graph'] = COMMON | {'clicked', 'doubleclicked'}
STD['monthcalendar'] = COMMON | {'clicked', 'doubleclicked', 'datechanged', 'dateselected', 'rightclicked', 'rightdoubleclicked',
                                 'key', 'valuechanged'}
STD['datepicker'] = COMMON | {'clicked', 'doubleclicked', 'closeup', 'dropdown', 'userstring', 'valuechanged', 'key'}
STD['richtextedit'] = COMMON | {'doubleclicked', 'fileexists', 'inputfieldselected', 'key', 'modified', 'mousedown', 'mousemove',
                                'mouseup', 'pictureselected', 'printfooter', 'printheader', 'rbuttonup'}
STD['olecustomcontrol'] = COMMON | {'clicked', 'doubleclicked', 'error', 'externalexception', 'propertychanged',
                                    'propertyrequestedit'}
STD['olecontrol'] = COMMON | {'clicked', 'doubleclicked', 'close', 'datachange', 'error', 'externalexception', 'propertychanged',
                              'propertyrequestedit', 'rename', 'save', 'viewchange'}
for _c in ('hscrollbar', 'vscrollbar', 'hprogressbar', 'vprogressbar', 'htrackbar', 'vtrackbar'):
    STD[_c] = COMMON | {'lineup', 'linedown', 'lineleft', 'lineright', 'moved', 'pageup', 'pagedown', 'pageleft', 'pageright'}
# system event behind a message id, for the ids no script of the application names
PBM_EVENT = {'pbm_sbnlinedown': 'linedown', 'pbm_sbnlineup': 'lineup', 'pbm_sbnpagedown': 'pagedown', 'pbm_sbnpageup': 'pageup',
             'pbm_sbnthumbtrack': 'moved', 'pbm_sbnmoved': 'moved', 'pbm_sbnthumbposition': 'moved', 'pbm_enmodified': 'modified',
             'pbm_ensetfocus': 'getfocus', 'pbm_enkillfocus': 'losefocus', 'pbm_bnclicked': 'clicked',
             'pbm_bnsetfocus': 'getfocus', 'pbm_bnkillfocus': 'losefocus'}
# an ActiveX control brings its events with it: they are never declared in the source
OLE = {'olecustomcontrol', 'olecontrol'}


def kind_of(project, name):
    d = project.objs.get(name) or {}
    return d.get('kind') or (project.scripts.get(name) or {}).get('kind') or 'window'


def pbstring(s):
    out = s.replace('~', '~~').replace('"', '~"').replace('\r', '~r').replace('\n', '~n').replace('\t', '~t')
    return '"' + out + '"'


# the decompiler writes an array as `long[] al_arr`; PowerScript wants `long al_arr[]`
ARRAY_ARG = re.compile(r'(\w+)(\[[^\]]*\])\s+(\w+)')
ARRAY_DECL = re.compile(r'^(\s*)(\w+)(\[[^\]]*\])\s+(\w+)(\s*=.*)?$')


def body_line(line):
    """decompiler dialect -> PowerScript: embedded SQL carries an `SQL ` marker, CONNECT / DISCONNECT are `start` / `stop`"""
    text = line[1:] if line.startswith('\t') else line
    indent = text[:len(text) - len(text.lstrip('\t'))]
    s = text[len(indent):]
    if s.startswith('SQL '):
        rest = s[4:]
        low = rest.lower()
        if low.startswith('start '):
            rest = 'CONNECT ' + rest[6:]
        elif low.startswith('stop '):
            rest = 'DISCONNECT ' + rest[5:]
        return indent + rest
    m = ARRAY_DECL.match(text)
    if m:
        return f'{m.group(1)}{m.group(2)} {m.group(4)}{m.group(3)}{m.group(5) or ""}'
    return text


class Routine:
    __slots__ = ('cls', 'name', 'args', 'ret', 'event', 'body', 'old_name')

    def __init__(self, cls, name, args, ret, event):
        self.cls, self.name, self.args, self.ret, self.event, self.body = cls, name, args, ret, event, []
        self.old_name = None     # the unreadable name the export had, where the event was named from its message id


def parse_script(path):
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    m = FIRST.match(lines[0])
    if not m:
        return None
    out, cur = [], None
    for line in lines[1:]:
        h = HDR.match(line)
        if h:
            cur = Routine(h.group(1), h.group(2), ARRAY_ARG.sub(r'\1 \3\2', h.group(3).strip()), h.group(4).strip(),
                          h.group(5) == 'event')
            out.append(cur)
        elif cur is not None:
            cur.body.append(line)
    for r in out:
        while r.body and not r.body[-1].strip():
            r.body.pop()
    return {'kind': m.group(1), 'name': m.group(2), 'lib': m.group(3), 'ancestor': m.group(4), 'routines': out}


class Node:
    """one class of an object: the object itself or one of its (nested) controls / menu items"""

    def __init__(self, name, path):
        self.name, self.path = name, path
        self.unnamed = False     # the export had no name for it; named from the parent's create script
        self.ancestor, self.inherited = None, False
        self.fields, self.children = [], []
        self.precs = {}          # event / function name -> prototype record (bytes), scripted or only declared
        self.declared_only = []  # names declared here without a script
        self.pnames = []         # routine names in the compiled order
        self.plist = []          # (name, prototype record) of the routines in the compiled order
        self.routines = []       # Routine objects assigned from the decompiled text


class Project:
    def __init__(self, root):
        self.root = root
        names = os.path.join(root, 'recovered', 'pcode_names')
        self.enums = json.load(open(os.path.join(names, 'enums_all.json'), encoding='utf-8'))
        self.pbm = json.load(open(os.path.join(names, 'pbm_ids.json'), encoding='utf-8'))
        self.shared = json.load(open(os.path.join(names, 'shared_vars.json'), encoding='utf-8'))
        self.gtypes = json.load(open(os.path.join(names, 'global_types.json'), encoding='utf-8'))
        self.systypes = json.load(open(os.path.join(names, 'system_types.json'), encoding='utf-8'))

        def optional(name):
            p = os.path.join(names, name)
            return {k.lower(): v for k, v in json.load(open(p, encoding='utf-8'))['objects'].items()} if os.path.exists(p) else {}

        # external / RPC declarations (extdecl_export.py) and array bounds + object-level structures (arrays_export.py)
        self.extdecls = optional('ext_decls_full.json')
        self.arrays = optional('array_bounds.json')
        # design-time values of array properties (arrayinit_export.py)
        p = os.path.join(names, 'array_inits.json')
        self.inits = json.load(open(p, encoding='utf-8')) if os.path.exists(p) else {}
        p = os.path.join(names, 'global_array_bounds.json')
        self.global_bounds = json.load(open(p, encoding='utf-8')) if os.path.exists(p) else {}
        p = os.path.join(names, 'global_inits.json')
        self.global_inits = {k: v['values'] for k, v in json.load(open(p, encoding='utf-8')).items()} if os.path.exists(p) else {}
        self._auto = None
        self._array_values = {}
        self.objs, self.pcode, self.scripts, self.all_scripts = {}, {}, {}, []
        for f in glob.glob(os.path.join(root, 'recovered', 'objects', '*', '*', '*.json')):
            if os.path.basename(f).startswith('_'):
                continue
            d = json.load(open(f, encoding='utf-8'))
            self.objs[d['name'].lower()] = d
        for f in glob.glob(os.path.join(root, 'recovered', 'pcode', '*', '*', '*.json')):
            if os.path.basename(f).startswith('_'):
                continue
            d = json.load(open(f, encoding='utf-8'))
            self.pcode[d['name'].lower()] = d
        # recovered/scripts_pb = the decompile in PowerScript mode (PB_POWERSCRIPT=1 decomp_all.py); recovered/scripts is the
        # dialect the rebuild's interpreter reads
        scripts_root = os.path.join(root, 'recovered', 'scripts_pb')
        if not os.path.isdir(scripts_root):
            scripts_root = os.path.join(root, 'recovered', 'scripts')
        for d, _, files in os.walk(scripts_root):
            for f in sorted(files):
                if f.endswith('.pbs'):
                    s = parse_script(os.path.join(d, f))
                    if s:
                        self.scripts[s['name'].lower()] = s
                        self.all_scripts.append(s)
        self.trees = {}
        self.report = {'written': {}, 'functions': 0, 'datawindows': 0, 'skipped': [], 'extra_routines': [],
                       'cursor_statements': 0, 'unassigned_routines': [], 'run_mismatches': [], 'events_declared': 0,
                       'events_mapped': 0, 'events_without_signature': [], 'external_functions_missing': 0,
                       'external_functions': 0, 'local_structures': 0, 'bounded_arrays': 0, 'catch_types': 0, 'binary_sections': 0,
                       'inherited_flag_dropped': 0, 'event_names_resolved': [], 'local_types_inferred': [], 'functions_without_value': [],
                       'uo_instance_controls': 0, 'uo_instance_scripts_left_out': 0, 'global_initial_values': 0, 'message_guards': 0,
                       'array_values_placed': [], 'array_values_by_order': [],
                       'array_values_unplaced': [], 'array_values_undecoded': [],
                       'structures_without_member_order': [], 'cursor_declares': 0,
                       'cursor_declares_missing': 0,
                       'external_function_objects': {}, 'ole_controls': [], 'properties_skipped': {},
                       'globals_without_type': [], 'ancestor_calls_rewritten': 0, 'ancestor_calls_inline': 0,
                       'functions_on_controls': []}
        # signature of every scripted event by name, for events that are declared in a class without a script
        self.event_sigs = {}
        for s in self.scripts.values():
            for r in s['routines']:
                if r.event:
                    self.event_sigs.setdefault(r.name, (r.args, r.ret))
        # type of a local variable by its name, for the few declarations whose class id the export could not resolve
        votes = {}
        for s in self.all_scripts:
            for r in s['routines']:
                for line in r.body:
                    m = re.match(r'^\s*([a-z_]\w*) ([a-z_]\w*)\s*$', line)
                    if m and not m.group(1).startswith('type_') and m.group(1) not in ('return', 'destroy', 'goto', 'call', 'halt'):
                        votes.setdefault(m.group(2), {}).setdefault(m.group(1), 0)
                        votes[m.group(2)][m.group(1)] += 1
        self.local_types = {name: max(v, key=v.get) for name, v in votes.items()}
        # events a class declares without a script: argument lists read from the runtime (extdecl_export.py --events),
        # keyed `object/class/event`
        self.exact_sigs, self.need_sigs = {}, []
        extra = os.path.join(names, 'event_sigs_extra.json')
        if os.path.exists(extra):
            for key, sig in json.load(open(extra, encoding='utf-8')).items():
                text = (', '.join(f"{a['type']} {a['name']}" for a in sig['args']), sig['ret'] or '0')
                if '/' in key:
                    self.exact_sigs[key] = text
                else:
                    self.event_sigs.setdefault(key, text)

    # ------------------------------------------------------------------ tree
    def tree(self, name):
        """{path tuple: Node} of one object: its recovered properties merged with the compiled class tree"""
        key = name.lower()
        if key in self.trees:
            return self.trees[key]
        nodes = {}

        def get(path, label):
            if path not in nodes:
                nodes[path] = Node(label, path)
                if len(path) > 1 and path[:-1] in nodes:
                    nodes[path[:-1]].children.append(nodes[path])
            return nodes[path]

        script = self.scripts.get(key)

        def created_by(parent):
            """the names a class creates in its create script, in order"""
            for r in (script['routines'] if script else []):
                if r.event and r.name == 'create' and r.cls.lower() == parent:
                    found = [a.lower() for a, b in re.findall(r'this\.(\w+) = create (\w+)', '\n'.join(r.body)) if a.lower() == b.lower()]
                    if found:
                        return found
            return []

        def children(d, path):
            """[(child, label, was_unnamed)]: an item the export left without a name (a menu item added below an inherited
            one) takes the name its parent's create script gives it"""
            kids = d.get('controls', [])
            named = {(c.get('field') or c.get('name') or '').lower() for c in kids}
            spare = [x for x in created_by(path[-1]) if x not in named]
            out = []
            for c in kids:
                label = c.get('field') or c.get('name')
                if label:
                    # a class without a `name` is the one the decompiled text calls `None`
                    out.append((c, label.lower(), not c.get('name')))
                elif spare:
                    out.append((c, spare.pop(0), True))
            return out

        def walk_obj(d, path):
            n = get(path, path[-1])
            n.ancestor = d.get('ancestor') or n.ancestor
            n.inherited = n.inherited or bool(d.get('inherited'))
            n.fields = d.get('fields', [])
            for c, label, unnamed in children(d, path):
                walk_obj(c, path + (label,))
                nodes[path + (label,)].unnamed = unnamed

        def walk_pcode(d, path):
            n = get(path, path[-1])
            n.ancestor = n.ancestor or d.get('ancestor')
            n.inherited = n.inherited or bool(d.get('inherited'))
            for r in d.get('routines', []):
                n.pnames.append(r['name'])
                n.plist.append((r['name'], bytes.fromhex(r['prec']) if r.get('prec') else None))
                if r.get('prec'):
                    n.precs[(r['name'], bool(r['event']))] = bytes.fromhex(r['prec'])
            for r in d.get('declared_only', []):
                if r.get('prec') and (r['name'], bool(r['event'])) not in n.precs:
                    n.precs[(r['name'], bool(r['event']))] = bytes.fromhex(r['prec'])
                    n.declared_only.append((r['name'], bool(r['event'])))
            for c, label, unnamed in children(d, path):
                walk_pcode(c, path + (label,))
                nodes[path + (label,)].unnamed = unnamed

        if key in self.objs:
            walk_obj(self.objs[key], (key,))
        if key in self.pcode:
            walk_pcode(self.pcode[key], (key,))
        self.trees[key] = nodes
        # a control counts as inherited only if an ancestor object really has it at the same place; the export also flags
        # some controls the object declares itself
        for path in sorted(nodes, key=len):          # parents first: a child's origin may lie in its parent's class
            n = nodes[path]
            if len(path) == 1:
                continue
            found = self.origin(key, path) is not None
            if n.inherited and not found:
                n.inherited = False
                self.report['inherited_flag_dropped'] += 1
            elif found and not n.inherited:
                n.inherited = True               # a control of the user object class its container is an instance of
        self.assign_routines(key, nodes)
        return nodes

    def origin(self, top, path):
        """(object, path) where a control is first defined, or None for a control the object declares itself: the same
        control of an ancestor window, or the control inside the user object class that a containing control is an
        instance of (`type cb_ok from u_stockledger`cb_ok within uo_1`)"""
        top = top.lower()
        a, seen = self.ancestor_of(top), 0
        while a and self.is_user_class(a) and seen < 30:
            p = (a.lower(),) + path[1:]
            if p in self.tree(a):
                return a.lower(), p
            a, seen = self.ancestor_of(a), seen + 1
        nodes = self.trees.get(top) or {}
        for k in range(len(path) - 1, 0, -1):
            if path[:k] not in nodes:
                continue
            cls, seen = self.class_of(top, path[:k]), 0
            while cls and self.is_user_class(cls) and seen < 30:
                p = (cls.lower(),) + path[k:]
                if p in self.tree(cls):
                    return cls.lower(), p
                cls, seen = self.ancestor_of(cls), seen + 1
        return None

    def autoinstantiated(self):
        """non-visual user object classes that are auto-instantiated.  The flag itself was not found in the compiled
        class; it shows in the use: variables of the class exist, their members are used, and no `create <class>` exists
        anywhere for the class or a descendant (`n_winsock my_socket` ... `my_socket.of_startup()`).  A descendant of
        such a class is one as well."""
        if self._auto is not None:
            return self._auto
        users = {k for k, d in self.objs.items() if d.get('kind') == 'userobject'}
        created, proof = set(), {}
        decl = re.compile(r'^\s*(\w+)(?:\[[^\]]*\])?\s+(\w+)(?:\[[^\]]*\])?\s*$')
        make = re.compile(r'\bcreate\s+(?:using\s+)?(\w+)', re.I)
        for s in self.scripts.values():
            for r in s['routines']:
                text = '\n'.join(r.body)
                for m in make.finditer(text):
                    created.add(m.group(1).lower())
                for line in r.body:
                    m = decl.match(line)
                    if not m or m.group(1).lower() not in users:
                        continue
                    v = re.escape(m.group(2))
                    # a local of the class whose members are used, and that is never given a value
                    if re.search(r'\b%s(?:\[[^\]]*\])?\.\w' % v, text) and not re.search(r'(?m)^\s*%s(?:\[[^\]]*\])?\s*=' % v, text):
                        proof.setdefault(m.group(1).lower(), f"{s['name'].lower()}.{r.name}: {m.group(2)}")

        def chain(k):
            out, seen = [], 0
            a = self.ancestor_of(k)
            while a and a.lower() in users and seen < 30:
                out.append(a.lower())
                a, seen = self.ancestor_of(a), seen + 1
            return out
        non_visual = {k for k in users if self.system_base(k) == 'nonvisualobject'}
        # a class that is created somewhere, itself or through a descendant, is an ordinary one: its unassigned local
        # got its value another way (a reference argument)
        made = {a for k in created if k in users for a in [k] + chain(k)}
        base = {k for k in proof if k in non_visual and k not in made}
        self._auto = base | {k for k in non_visual if any(a in base for a in chain(k)) and k not in made}
        self.report['autoinstantiate'] = {k: proof.get(k, 'descendant of ' + next((a for a in chain(k) if a in base), '?'))
                                          for k in sorted(self._auto)}
        self.report['autoinstantiate_but_created'] = sorted(k for k in self._auto if k in created)
        return self._auto

    def in_uo_instance(self, top, path):
        """a control that belongs to a user object placed on the object (or on a control of it): it is defined, with its
        properties and scripts, in the user object class and cannot be changed from outside"""
        nodes = self.trees.get(top.lower()) or {}
        for k in range(len(path) - 1, 1, -1):
            if path[:k] not in nodes:
                continue
            cls, seen = self.class_of(top, path[:k]), 0
            while cls and self.is_user_class(cls) and seen < 30:
                if (cls.lower(),) + path[k:] in self.tree(cls):
                    return True
                cls, seen = self.ancestor_of(cls), seen + 1
        return False

    def class_of(self, top, path):
        """class a control is an instance of; an inherited control takes it from where it is defined"""
        node = (self.trees.get(top.lower()) or {}).get(path)
        if node is None:
            return None
        if len(path) == 1:
            return node.ancestor
        o = self.origin(top, path) if node.inherited or node.ancestor == node.name else None
        if o is not None and o != (top.lower(), path):
            return self.class_of(o[0], o[1]) or node.ancestor
        return node.ancestor

    def assign_routines(self, key, nodes):
        """the decompiled text names a routine by its class only: give each run of routines to the tree node of that name
        whose compiled routine list matches"""
        s = self.scripts.get(key)
        if not s:
            return
        runs = []
        for r in s['routines']:
            if runs and runs[-1][0] == r.cls.lower():
                runs[-1][1].append(r)
            else:
                runs.append((r.cls.lower(), [r]))
        order = list(nodes.values())
        used = set()
        split = []
        for cls, rs in runs:
            # consecutive classes without a name appear as one run: cut it into the routine lists of the unnamed nodes
            rest = list(rs)
            if cls == 'none':
                for n in [x for x in order if x.unnamed]:
                    k = len(n.pnames)
                    if k and [r.name for r in rest[:k]] == n.pnames:
                        split.append((cls, rest[:k]))
                        rest = rest[k:]
            if rest:
                split.append((cls, rest))
        for cls, rs in split:
            if cls == 'none':        # the decompiler printed no name for these: the items named from the create script
                cands = [n for n in order if n.unnamed and id(n) not in used]
            else:
                cands = [n for n in order if n.name == cls and id(n) not in used]
            names = sorted(r.name for r in rs)
            pick = next((n for n in cands if sorted(n.pnames) == names), None)
            if pick is None and cands:
                pick = next((n for n in cands if n.pnames), cands[0])
                self.report['run_mismatches'].append({'object': key, 'class': cls})
            if pick is None:
                self.report['unassigned_routines'].append({'object': key, 'class': cls, 'routines': len(rs)})
                continue
            used.add(id(pick))
            pick.routines = rs
            aligned = [x[0] for x in pick.plist] == [r.name for r in rs]      # same routines in the same order
            for i, r in enumerate(rs):
                rec = pick.plist[i][1] if aligned else (pick.precs.get((r.name, True)) or pick.precs.get((r.name, False)))
                token = struct.unpack_from('<H', rec, 0x20)[0] if rec and len(rec) >= 0x22 else 0xffff
                if token != 0xffff and (not r.name.isidentifier() or not r.event):
                    # a script for an event of a control inside a user object: the export could not read its name and
                    # lists it as a function; the message id names the system event
                    name = self.token_names().get(token) or PBM_EVENT.get(self.pbm.get(str(token)))
                    self.report['event_names_resolved'].append({'object': key, 'class': cls, 'event': name,
                                                                'message': self.pbm.get(str(token))})
                    if name:
                        r.old_name = r.name          # its own text still calls the ancestor event by the unreadable name
                        r.name, r.event, r.args = name, True, r.args.replace('+', '')

    def datastore_members(self, key):
        """instance variables of an object (and of its ancestors) that are DataStores"""
        out, seen = set(), 0
        while key and self.is_user_class(key) and seen < 30:
            top = self.tree(key).get((key.lower(),))
            for f in (top.fields if top else []):
                if f['attr'] in ('0xcc', '0xdc') and f['type'] in ('datastore', 'u_ds_standard', 'nv_datastore'):
                    out.add(f['name'])
            key, seen = self.ancestor_of(key), seen + 1
        return out

    def token_names(self):
        """message id -> name of the system event that carries it (taken from the events the application scripts)"""
        if not hasattr(self, '_token_names'):
            votes = {}
            for d in self.pcode.values():
                stack = [d]
                while stack:
                    n = stack.pop()
                    stack.extend(n.get('controls', []))
                    for r in n.get('routines', []):
                        if r.get('event') and r.get('prec') and str(r['name']).isidentifier():
                            rec = bytes.fromhex(r['prec'])
                            token = struct.unpack_from('<H', rec, 0x20)[0]
                            if token != 0xffff and rec[0x1f] & 0x80:
                                votes.setdefault(token, {}).setdefault(r['name'], 0)
                                votes[token][r['name']] += 1
            self._token_names = {t: max(v, key=v.get) for t, v in votes.items()}
        return self._token_names

    # ------------------------------------------------------------- inheritance
    def ancestor_of(self, name):
        key = (name or '').lower()
        d = self.objs.get(key) or self.pcode.get(key)
        return d.get('ancestor') if d else None

    def is_user_class(self, name):
        key = (name or '').lower()
        return key in self.objs or key in self.pcode

    def system_base(self, cls):
        seen = 0
        while self.is_user_class(cls) and seen < 30:
            cls, seen = self.ancestor_of(cls), seen + 1
        return (cls or '').lower()

    def real_class(self, top, node):
        """class a node is an instance of"""
        if len(node.path) == 1:
            return node.ancestor
        self.tree(top)
        return self.class_of(top, node.path) or node.ancestor

    def inherited_events(self, top, node):
        """event names that an ancestor already has: the class chain of the control, and the same control where it is
        defined (an ancestor window, or the user object class of its container)"""
        out = set()
        cls, seen = self.real_class(top, node), 0
        while cls and self.is_user_class(cls) and seen < 30:
            top_node = self.tree(cls).get((cls.lower(),))
            if top_node is not None:
                out.update(n for (n, ev) in top_node.precs if ev)
            cls, seen = self.ancestor_of(cls), seen + 1
        where, seen = (top.lower(), node.path), 0
        while len(node.path) > 1 and seen < 30:
            where = self.origin(where[0], where[1])
            if where is None:
                break
            other = self.tree(where[0]).get(where[1])
            if other is not None:
                out.update(n for (n, ev) in other.precs if ev)
            seen += 1
        return out

    # ------------------------------------------------------------------ events
    def new_events(self, top, node):
        """[(name, declaration line, is_mapped)] of the events this class declares itself"""
        cls = self.real_class(top, node) if len(node.path) > 1 else node.ancestor
        base = self.system_base(cls)
        std = STD.get(base, COMMON)
        have = self.inherited_events(top, node)
        own = {r.name: r for r in node.routines if r.event}
        out = []
        for (name, is_event), rec in node.precs.items():
            if not is_event or name in ('create', 'destroy') or len(rec) < 0x22 or not name.isidentifier():
                continue
            token = struct.unpack_from('<H', rec, 0x20)[0]
            mapped = token != 0xffff and str(token) in self.pbm
            # the flag marks an event that an ancestor or the system class defines; a few events mapped to a message id
            # carry it although only this class has them (`event close pbm_dwnitemchange` on a DataWindow control)
            if name in std or name in have or (rec[0x1f] & 0x80 and not (mapped and base in STD)):
                continue
            token = struct.unpack_from('<H', rec, 0x20)[0]
            if token != 0xffff and str(token) in self.pbm:
                out.append((name, f'event {name} {self.pbm[str(token)]}', True))
                self.report['events_mapped'] += 1
            else:
                if name in own:
                    sig = (own[name].args, own[name].ret)
                else:
                    # declared here without a script: the signature is the one the runtime holds for this class
                    # (extdecl_export.py --events); an event of another class with the same name proves nothing
                    sig = self.exact_sigs.get(f'{top}/{node.name}/{name}')
                    argc, rcode = rec[0x1e], struct.unpack_from('<H', rec, 0x1c)[0]
                    if sig is None and argc == 0 and rcode < 0x4000:
                        sig = ('', PRIMNUM.get(rcode, '0') if rcode else '0')
                    if sig is None:
                        ids = [None] if len(node.path) == 1 else \
                            [int(c) for c, v in ((self.pcode.get(top) or {}).get('classes') or {}).items()
                             if (v.get('name') or '').lower() == node.name]
                        self.need_sigs.append({'object': top, 'kind': kind_of(self, top), 'label': node.name, 'class_ids': ids,
                                               'events': [name]})
                        self.report['events_without_signature'].append({'object': top, 'class': node.name, 'event': name,
                                                                        'arguments': argc})
                        sig = self.event_sigs.get(name) or ('', '0')
                args, ret = sig
                out.append((name, (f'event type {ret} {name} ( {args} )' if ret != '0' else f'event {name} ( {args} )'), False))
            self.report['events_declared'] += 1
        return out

    # -------------------------------------------------------------- properties
    # ----------------------------------------------------------- array properties
    @staticmethod
    def is_array_property(f):
        """a property that is an array: the export holds only a pointer for it (a few garbage characters / a huge number)"""
        t, name, v = f['type'], f['name'], f['value']
        if name == 'item':
            return True
        if t == 'string':
            return isinstance(v, str) and any(not ch.isprintable() and ch not in '\t\r\n' for ch in v)
        return name in ('tabstop', 'itempictureindex') and t == 'integer'

    def array_values(self, key):
        """{node path: {property: [values]}}: the design-time values of string array properties (list items, picture
        names, initialised instance arrays), recovered by arrayinit_export.py and matched to their controls here.
        The arrays of an object stand in control order; the readable strings in front of an array are values of the
        control itself or of the control before it, which fixes its place when not every list has values."""
        if key in self._array_values:
            return self._array_values[key]
        res = {}
        arrays = [a for a in self.inits.get(key, []) if a['type'] == 6 and a['count']]
        nodes = list(self.tree(key).values())
        slots = []                                   # (node index, node, property)
        for i, n in enumerate(nodes):
            for f in n.fields:
                if PRIMFIX.get(f['type'], f['type']) != 'string':
                    continue
                if (f['attr'] in ('0xbc', '0xbe') and self.is_array_property(f)) or (f['attr'] == '0xcc' and f.get('array')):
                    slots.append((i, n, f['name']))
        # a text that only one control has places that control in the file: an array between the texts of controls p and
        # q belongs to a control from p to q
        owner = {}
        for i, n in enumerate(nodes):
            for f in n.fields:
                v = f['value']
                if f['type'] == 'string' and isinstance(v, str) and len(v) >= 3 and v.isprintable() and not self.is_array_property(f):
                    owner.setdefault(v, set()).add(i)
        unique = {v: next(iter(s)) for v, s in owner.items() if len(s) == 1}
        lo, hi = [], []
        for a in arrays:
            before = [unique[c] for c in a.get('context', []) if c in unique]
            after = [unique[c] for c in a.get('after', []) if c in unique]
            lo.append(before[-1] if before else 0)
            hi.append(after[0] if after else len(nodes))
        n = len(arrays)
        early, late = [None] * n, [None] * n
        k = 0
        for i in range(n):                           # earliest slot each array can take, keeping the order
            while k < len(slots) and slots[k][0] < lo[i]:
                k += 1
            early[i] = k if k < len(slots) else None
            k += 1
        k = len(slots) - 1
        for i in range(n - 1, -1, -1):               # latest slot each array can take
            while k >= 0 and slots[k][0] > hi[i]:
                k -= 1
            late[i] = k if k >= 0 else None
            k -= 1
        def keywords(values):
            """when several neighbouring lists fit, the shape of the values points at the control by its name
            (a tie-breaker inside the window the file positions leave, never a placement on its own)"""
            v = set(values)
            if v == {'AM', 'PM'}:
                return ('ampm', 'time')
            if len(values) == 60 and v >= {'01', '59'}:
                return ('sec', 'min')
            if len(values) == 12 and v >= {'1', '12'}:
                return ('hr', 'hour')
            if v and v <= {'=', '<', '>', '<=', '>=', '<>', 'like', 'Like'}:
                return ('_op',)
            return ()

        last = -1
        for i, a in enumerate(arrays):
            if not a['decoded']:
                self.report['array_values_undecoded'].append({'object': key, 'count': a['count']})
                continue
            pick = early[i]
            if pick is None or late[i] is None or late[i] < pick:
                self.report['array_values_unplaced'].append({'object': key, 'values': a['values'][:3]})
                continue
            pick = max(pick, last + 1)
            if late[i] > pick:
                words = keywords(a['values'])
                named = next((q for q in range(pick, late[i] + 1) if any(w in slots[q][1].name for w in words)), None)
                if named is not None:
                    pick = named
            if pick > late[i]:
                self.report['array_values_unplaced'].append({'object': key, 'values': a['values'][:3]})
                continue
            last = pick
            _, node, prop = slots[pick]
            res.setdefault(node.path, {})[prop] = a['values']
            entry = {'object': key, 'control': node.name, 'property': prop, 'count': a['count'], 'first': a['values'][:2]}
            self.report['array_values_placed'].append(entry)
            if late[i] != pick:                      # more than one control fits: the first one was taken
                self.report['array_values_by_order'].append(dict(entry, candidates=[slots[q][1].name for q in range(pick, late[i] + 1)]))
        self._array_values[key] = res
        return res

    def property_lines(self, node):
        out = []
        placed = self.array_values(node.path[0]).get(node.path, {})
        for f in node.fields:
            if f['attr'] not in ('0xbc', '0xbe') or f.get('array'):
                continue
            t, name, v = PRIMFIX.get(f['type'], f['type']), f['name'], f['value']
            if self.is_array_property(f):
                if name in placed:
                    out.append(f'string {name}[] = {{' + ','.join(pbstring(x) for x in placed[name]) + '}')
                continue
            if t == 'string':
                if isinstance(v, str):
                    out.append(f'string {name} = {pbstring(v)}')
            elif t == 'boolean':
                out.append(f'boolean {name} = {"true" if v else "false"}')
            elif t in NUMERIC:
                if isinstance(v, (int, float)) and not isinstance(v, bool):
                    out.append(f'{t} {name} = {v}')
            elif t in self.enums:
                label = self.enums[t].get(str(v))
                if label:
                    out.append(f'{t} {name} = {label}!')
                else:
                    self.report['properties_skipped'][t] = self.report['properties_skipped'].get(t, 0) + 1
            else:
                # object references (the control array, menu items ...) are built by the create script
                self.report['properties_skipped'][t] = self.report['properties_skipped'].get(t, 0) + 1
        return out

    def array_suffix(self, key, scope, name, flagged):
        """`[n]` for an array with fixed bounds, `[]` for an unbounded one, nothing for a scalar"""
        a = self.arrays.get(key, {}).get(scope, {}).get(name.lower())
        if a is None:
            return '[]' if flagged else ''
        # descriptor: u8 dimensions, u8 flags (0x40 / 0x80 = fixed bounds), u16 type, then (lower, upper) per dimension
        d = bytes.fromhex(a['raw'])
        nd, flags = d[0], d[1]
        if not flags & 0xc0 or nd < 1 or len(d) < 4 + 8 * nd:
            return '[]'
        parts = []
        for k in range(nd):
            lo, hi = struct.unpack_from('<ii', d, 4 + 8 * k)
            parts.append(str(hi) if lo == 1 else f'{lo} to {hi}')
        self.report['bounded_arrays'] += 1
        return '[' + ', '.join(parts) + ']'

    def local_structures(self, key):
        """[(name, member lines)] of the structures an object declares for itself (not global objects)"""
        classes = (self.pcode.get(key) or {}).get('classes') or {}
        out = []
        for sname, members in (self.arrays.get(key, {}).get('#members') or {}).items():
            if not sname:
                continue                 # '' = the object's own member list (used for global structures)
            lines = []
            for name, dt, flags, attr in members:
                if attr != 0x8c:
                    continue
                if dt < 0x4000:
                    t = PRIMNUM.get(dt, f'type_{dt}')
                elif dt < 0x8000:
                    t = self.systypes.get(str(dt), f'type_{dt:x}')
                else:
                    t = (classes.get(str(dt)) or {}).get('name') or f'type_{dt:x}'
                lines.append(f'\t{t}\t\t{name}{self.array_suffix(key, sname, name, bool(flags & 0x2000))}')
            out.append((sname, lines))
        return out

    @staticmethod
    def external_line(d):
        """declaration of a DLL or RPC (stored procedure) function"""
        args = []
        for a in d['args']:
            flags = a['raw'][1]
            # 0x2 = by reference; 0x4 together with it is taken as `readonly` (an assumption, 12 arguments)
            mod = 'readonly ' if flags & 0x4 else ('ref ' if flags & 0x2 else '')
            args.append(f"{mod}{a['type']} {a['name']}" + ('[]' if a['raw'][0] != 0xffff else ''))
        joined = ', '.join(args)
        head = f"function {d['ret']} {d['name']} ({joined})" if d['ret'] else f"subroutine {d['name']} ({joined})"
        alias = f' alias for "{d["alias"]}"' if d['alias'] else ''
        if d['kind'] == 'rpc':
            return head + ' RPCFUNC' + alias
        return head + f' library "{d["library"]}"' + alias

    def variable_lines(self, node, key):
        out = []
        for f in node.fields:
            if f['attr'] not in ('0xcc', '0xc9'):
                continue
            t, name, v = PRIMFIX.get(f['type'], f['type']), f['name'], f['value']
            const = f['attr'] == '0xc9'
            if f.get('array'):
                out.append(f'{t} {name}{self.array_suffix(key, "", name, True)}')
                continue
            init = None
            if t == 'string' and isinstance(v, str) and (v or const) and not re.search(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', v):
                init = pbstring(v)
            elif t == 'boolean' and (v or const):
                init = 'true' if v else 'false'
            elif t in NUMERIC:
                if isinstance(v, str):
                    try:
                        v = int(v, 16)
                    except ValueError:
                        v = 0
                if isinstance(v, (int, float)) and not isinstance(v, bool) and (v or const):
                    init = str(v)
            line = f'{t} {name}' + (f' = {init}' if init is not None else '')
            out.append(('constant ' if const and init is not None else '') + line)
        return out

    # ------------------------------------------------------------------ scripts
    DECL = re.compile(r'^\s*[a-z_]\w*(\{\d+\})?\s+[a-z_]\w*(\[[^\]]*\])?(\s*=.*)?$', re.I)
    NOT_DECL = {'return', 'destroy', 'call', 'goto', 'halt', 'if', 'do', 'for', 'choose', 'loop', 'next', 'end', 'else',
                'elseif', 'case', 'try', 'catch', 'finally', 'throw', 'exit', 'continue', 'create', 'connect', 'disconnect',
                'commit', 'rollback', 'select', 'update', 'insert', 'delete', 'execute', 'fetch', 'open', 'close'}

    def script_body(self, r):
        lines = [body_line(b) for b in r.body]
        # two properties of PowerObject / ClassDefinition that the decompiler prints as getter calls
        lines = [re.sub(r'\.getlibraryname\(\)', '.libraryname', re.sub(r'\bgetclassdefinition\(\)', 'this.classdefinition', x))
                 for x in lines]
        # `<datawindow>.object.<column>[row]`: with the class of the variable unknown, `object` was printed as `borderstyle`
        lines = [re.sub(r'\.(?:borderstyle|name)\.(\w+)(\[|\.)', r'.object.\1\2', x) for x in lines]
        # a literal statement of EXECUTE IMMEDIATE carries no host-variable colon; the application's name property was
        # printed with the name another class has at that index
        lines = [x.replace('EXECUTE IMMEDIATE :"', 'EXECUTE IMMEDIATE "').replace('getapplication().microhelp', 'getapplication().appname')
                 for x in lines]
        # member names printed from the wrong class (the index is right, the class of the variable was not known):
        # message.returnvalue, three RichTextEdit properties written as setter calls, a local of unresolved type
        lines = [re.sub(r'\.set_(displayonly|popmenu|toolbar)\((.*)\)\s*$', r'.\1 = \2', x.replace('::message.field6', '::message.returnvalue').replace('::message.fillcolor', '::message.returnvalue'))
                 for x in lines]
        for i, x in enumerate(lines):
            m = re.match(r'^(\s*)type_[0-9a-f]+ (\w+)\s*$', x)
            if m and m.group(2) in self.local_types:
                lines[i] = f'{m.group(1)}{self.local_types[m.group(2)]} {m.group(2)}'
                self.report['local_types_inferred'].append({'object': getattr(self, 'current', ''), 'variable': m.group(2),
                                                            'type': self.local_types[m.group(2)]})
        # `dataobject` of a DataStore was printed as `tag` / `recipienttype`
        stores = {m.group(2) for x in lines for m in [re.match(r'^\s*(datastore|u_ds_standard|nv_datastore) (\w+)\s*$', x)] if m}
        stores |= self.datastore_members(getattr(self, 'current', None))
        if stores or any('.ds' in x for x in lines):
            names = '|'.join(sorted(map(re.escape, stores))) or 'NO_NAME'
            pat = re.compile(r'\b((?:%s)|ds\d?)\.(tag|recipienttype)\b' % names)
            lines = [pat.sub(r'\1.dataobject', x) for x in lines]
        if r.event and r.ret == '0':
            # an event without return value cannot return the message's return value (the decompiler's default epilogue)
            lines = [x for x in lines if x.strip() != 'return ::message.returnvalue']
        # an event that extends its ancestor is compiled as `long ancestorreturnvalue` + an assignment from the ancestor
        # event as its first statement; in source that is `call super::<event>` (the variable then exists by itself)
        in_decls, drop = True, None
        for i, text in enumerate(lines):
            if not text.strip():
                continue
            if r.body[i].lstrip().startswith('SQL ') and re.match(r'\s*(FETCH|OPEN|CLOSE)\b', text, re.I):
                self.report['cursor_statements'] += 1
            m = re.match(r'^(\s*)ancestorreturnvalue = super::(\w+)\((.*)\)\s*$', text)
            if not m and r.event:
                # an event without return value that extends its ancestor: `super::<this event>(<its arguments>)`
                m = re.match(r'^(\s*)super::(%s)\((.*)\)\s*$' % re.escape(r.name), text)
            if m:
                if m.group(2) == getattr(r, 'old_name', None):
                    m = re.match(r'^(\s*)(?:ancestorreturnvalue = )?super::(\w+)\((.*)\)\s*$',
                                 text.replace('super::' + r.old_name + '(', 'super::' + r.name + '('))
                if in_decls and r.event:
                    lines[i] = f'{m.group(1)}call super::{m.group(2)}'
                    drop = next((j for j in range(i) if re.match(r'^\s*\w+\s+ancestorreturnvalue\s*$', lines[j])), None)
                    self.report['ancestor_calls_rewritten'] += 1
                else:
                    lines[i] = f'{m.group(1)}ancestorreturnvalue = super::event {m.group(2)}({m.group(3)})'
                    self.report['ancestor_calls_inline'] += 1
                in_decls = False
                continue
            if in_decls and not (self.DECL.match(text) and text.split()[0].lower() not in self.NOT_DECL):
                in_decls = False
        if drop is not None:
            del lines[drop]
        lines = self.cursor_fix(r, lines)
        # `catch (throwable ex)`: the decompiler names every handler `throwable`; the real type is the one of the local
        # variable the compiler made for it, and the catch clause declares that variable itself
        for i, text in enumerate(lines):
            m = re.match(r'^(\s*)catch \(throwable (\w+)\)\s*$', text) if text is not None else None
            if not m:
                continue
            decl = next((j for j, d in enumerate(lines)
                         if d is not None and re.match(r'^\s*\w+\s+%s\s*$' % re.escape(m.group(2)), d)), None)
            if decl is not None:
                lines[i] = f'{m.group(1)}catch ({lines[decl].split()[0]} {m.group(2)})'
                lines[decl] = None
                self.report['catch_types'] += 1
        lines = [x for x in lines if x is not None]
        if r.event and r.ret != '0':
            # the compiler's event epilogue is `if not isvalid(::message) then return 0` + `return ::message.returnvalue`;
            # the decompiler shortens it to the second line.  The guard matters before the application's message object
            # exists (constructor of an auto-instantiated variable declared in the application: n_smtp)
            res = []
            for x in lines:
                if x.strip() == 'return ::message.returnvalue' and not (len(res) >= 3 and res[-1].strip() == 'end if'
                                                                         and res[-3].strip() == 'if not isvalid(::message) then'):
                    ind = x[:len(x) - len(x.lstrip())]
                    res += [f'{ind}if not isvalid(::message) then', f'{ind}\treturn 0', f'{ind}end if']
                    self.report['message_guards'] += 1
                res.append(x)
            lines = res
        return '\r\n'.join(lines)

    CURSOR_OP = re.compile(r'^(\s*)(EXECUTE|OPEN|FETCH|CLOSE)\s+(\w+)(.*?)(?:\s+USING\s+([\w.]+))?\s*;\s*(?:/\*\s*args:\s*(.*?)\s*\*/)?\s*$',
                           re.I)

    def pool_sql(self, key):
        """SQL texts of the object's statement pool (the text of cursors and declared procedures lives only there)"""
        import base64
        out = []

        def walk(n):
            sp = n.get('sqlpool')
            if sp and sp.get('b64'):
                text = base64.b64decode(sp['b64']).decode('utf-16le', 'replace')
                for s in re.split('\x00+', text):
                    m = re.search(r'(?i)\b(execute|select)\b.*', s, re.S)
                    if m and len(m.group(0)) > 12:
                        out.append(m.group(0).strip())
            for c in n.get('controls', []):
                walk(c)

        if key in self.pcode:
            walk(self.pcode[key])
        return out

    def cursor_fix(self, r, lines):
        """a cursor or declared procedure is used through OPEN / EXECUTE, FETCH, CLOSE; its DECLARE is not an executable
        statement, so the decompiled text lacks it.  Rebuild it from the statement pool and move USING onto it."""
        key, declared, out = getattr(self, 'current', None), {}, []
        for text in lines:
            m = self.CURSOR_OP.match(text)
            if not m or m.group(3).upper() == 'IMMEDIATE' or m.group(3).startswith(':'):
                out.append(text)
                continue
            indent, op, name, rest, using, args = m.groups()
            op = op.upper()
            if name.lower() not in declared and op in ('EXECUTE', 'OPEN'):
                pool = self.pool_sql(key) if key else []
                trans = f' USING {using}' if using else ''
                if op == 'EXECUTE':
                    sql = next((s for s in pool if s.lower().startswith('execute')), None)
                    if sql:
                        call = re.sub(r'(?i)^execute\s+', '', sql)
                        for a in [x.strip() for x in (args or '').split(',') if x.strip()]:
                            call = call.replace("' '", ':' + a, 1)
                        out.append(f'{indent}DECLARE {name} PROCEDURE FOR {call.strip()}{trans};')
                else:
                    body = '\n'.join(lines).lower()
                    sql = next((s for s in pool if s.lower().startswith('select') and s.lower()[:40] not in body), None)
                    if sql:
                        out.append(f'{indent}DECLARE {name} CURSOR FOR {sql.strip()}{trans};')
                declared[name.lower()] = bool(sql)
                self.report['cursor_declares' if sql else 'cursor_declares_missing'] += 1
            out.append(f'{indent}{op} {name}{rest};')
        return out

    def class_text(self, top, node, new_unmapped):
        """create / destroy, functions and events of one class"""
        out = []
        funcs = [r for r in node.routines if not r.event]
        if funcs and len(node.path) > 1:
            self.report['functions_on_controls'].append({'object': top, 'class': node.name, 'functions': len(funcs)})
        for r in node.routines:
            if r.event and r.name in ('create', 'destroy'):
                out.append(f'on {node.name}.{r.name}\r\n{self.script_body(r)}\r\nend on\r\n')
        for r in node.routines:
            if not r.event or r.name in ('create', 'destroy'):
                continue
            if r.name in new_unmapped and (r.args or r.ret != '0'):
                head = f'event type {r.ret} {r.name}({r.args});' if r.ret != '0' else f'event {r.name}({r.args});'
            else:
                head = f'event {r.name};'
            out.append(f'{head}{self.script_body(r)}\r\nend event\r\n')
        return out

    def function_body(self, r):
        """PowerBuilder 12.5 accepted a function with a return type that ends, or says `return`, without a value; the
        2022 compiler does not (C0094).  Such a path returns the default value of the type here (0, "", false, an unset
        variable); assumption: that is what the old runtime handed back, as it does for a variable never assigned"""
        body = self.script_body(r)
        if r.ret == '0':
            return body
        lines = body.split('\r\n')
        t = r.ret.lower()
        simple = '0' if t in NUMERIC or t.startswith('decimal') else '""' if t == 'string' else 'false' if t == 'boolean' else None
        value = simple or 'noresult_value'
        changed = False
        for i, x in enumerate(lines):
            if x.strip().lower() == 'return':
                lines[i] = x.rstrip() + ' ' + value
                changed = True
        last = next((x.strip().lower() for x in reversed(lines) if x.strip()), '')
        if not re.match(r'^(return|throw)\b', last):
            lines.append('return ' + value)
            changed = True
        if changed:
            self.report['functions_without_value'].append({'object': getattr(self, 'current', ''), 'function': r.name,
                                                           'type': r.ret})
            if simple is None:
                lines.insert(0, f'{r.ret} noresult_value')
        return '\r\n'.join(lines)

    @staticmethod
    def proto(r):
        return f'public subroutine {r.name} ({r.args})' if r.ret == '0' else f'public function {r.ret} {r.name} ({r.args})'

    # ------------------------------------------------------------------ objects
    def type_line(self, top, node):
        parent = node.path[-2]
        if node.inherited:
            o = self.origin(top, node.path)
            return f'type {node.name} from {o[0] if o else self.ancestor_of(top)}`{node.name} within {parent}'
        return f'type {node.name} from {node.ancestor} within {parent}'

    def object_source(self, key, kind):
        self.current = key
        nodes = self.tree(key)
        top = nodes[(key,)]
        controls = [n for p, n in nodes.items() if len(p) > 1]
        ancestor = top.ancestor or {'window': 'window', 'menu': 'menu', 'userobject': 'nonvisualobject',
                                    'application': 'application'}[kind]
        out = [f'$PBExportHeader${key}.{EXT[kind]}', 'forward', f'global type {key} from {ancestor}', 'end type']
        for n in controls:
            out += [self.type_line(key, n), 'end type']
        structs = self.local_structures(key)
        for sname, _ in structs:
            out += [f'type {sname} from structure within {key}', 'end type']
        if kind == 'application':
            out += [f'global {self.gtypes.get(g, t)} {g}' for g, t in (('sqlca', 'transaction'), ('sqlda', 'dynamicdescriptionarea'),
                                                                      ('sqlsa', 'dynamicstagingarea'), ('error', 'error'),
                                                                      ('message', 'message'))]
        out += ['end forward', '']
        for sname, lines in structs:
            out += [f'type {sname} from structure'] + lines + ['end type', '']
            self.report['local_structures'] += 1
        if key in self.shared and kind != 'application':
            out += ['shared variables'] + self.global_lines(key) + ['end variables', '']
        if kind == 'application':
            out += ['global variables'] + self.global_lines(key) + ['end variables', '']

        def type_block(n, head, is_top):
            new = self.new_events(key, n)
            block = [head]
            if kind != 'menu':
                props = self.property_lines(n)
                if is_top and kind == 'window' and not any(p.startswith('string menuname') for p in props):
                    for r in n.routines:
                        if r.event and r.name == 'create':
                            m = re.search(r'this\.menuname = "(\w+)"', '\n'.join(r.body))
                            if m:
                                props.append(f'string menuname = "{m.group(1)}"')
                block += props
            block += [d for _, d, _ in new]
            block += [f'{c.name} {c.name}' for c in n.children if not c.inherited]
            block.append('end type')
            return block, {name for name, _, mapped in new if not mapped}

        auto = kind == 'userobject' and key in self.autoinstantiated()
        block, new_unmapped = type_block(top, f'global type {key} from {ancestor}' + (' autoinstantiate' if auto else ''), True)
        # an auto-instantiated class has no global variable of its own name
        out += block + ([''] if auto else [f'global {key} {key}', ''])
        ext = [(n, e) for (n, e) in top.declared_only if not e]
        decls = self.extdecls.get(key, [])
        if decls:
            out += ['type prototypes'] + [self.external_line(d) for d in decls] + ['end prototypes', '']
            self.report['external_functions'] += len(decls)
        if ext:
            # objects with external / RPC functions: the list extdecl_export.py works from
            self.report['external_function_objects'][key] = len(ext)
            if len(ext) > len(decls):
                self.report['external_functions_missing'] += len(ext) - len(decls)
        variables = self.variable_lines(top, key)
        if variables:
            out += ['type variables'] + variables + ['end variables', '']
        funcs = [r for r in top.routines if not r.event]
        if funcs:
            out += ['forward prototypes'] + [self.proto(r) for r in funcs] + ['end prototypes', '']
            for r in funcs:
                end = 'end subroutine' if r.ret == '0' else 'end function'
                out.append(f'{self.proto(r)};{self.function_body(r)}\r\n{end}\r\n')
        out += self.class_text(key, top, new_unmapped)
        for n in controls:
            if self.system_base(self.real_class(key, n)) in OLE:
                self.report['ole_controls'].append({'object': key, 'control': n.name})
            if self.in_uo_instance(key, n.path):
                # a control of a user object placed here: its properties and scripts are the user object's.  The compiled
                # object repeats them (with unreadable names); written out again they would be a second script that runs
                # after the user object's own, and property values read through the wrong class
                out += [self.type_line(key, n), 'end type', '']
                self.report['uo_instance_controls'] += 1
                if n.routines:
                    self.report['uo_instance_scripts_left_out'] += len(n.routines)
                continue
            block, unmapped = type_block(n, self.type_line(key, n), False)
            out += block + ['']
            out += self.class_text(key, n, unmapped)
        return BOM + '\r\n'.join(out) + '\r\n'

    def global_lines(self, key):
        out = []
        for name, word in self.shared.get(key, []):
            if not name or name in ('sqlca', 'sqlda', 'sqlsa', 'error', 'message') or name == key:
                continue
            hi, lo = word >> 16, word & 0xffff
            if hi & 0x8000:
                t = self.gtypes.get(name)
            else:
                t = PRIMNUM.get(hi)
            if not t:
                self.report['globals_without_type'].append({'object': key, 'variable': name, 'type_word': hex(word)})
                continue
            # bounds of a global array: read from a routine that refers to it (recovered/pcode_names/global_array_bounds.json)
            line = f'{t} {name}' + (self.global_bounds.get(name, '[]') if lo & 0x2000 else '')
            # the initial value the declaration gives it (globals_export.py): the application's version number, the names
            # of its SQL Agent jobs, the temporary folder ...
            init = self.global_inits.get(key, {}).get(name)
            if init is not None and not lo & 0x2000:
                kind, value = init
                if kind in ('string', 'char'):
                    line += ' = ' + pbstring(value)
                elif kind == 'boolean':
                    line += ' = ' + ('true' if value else 'false')
                else:
                    line += f' = {value}'
                self.report['global_initial_values'] += 1
            out.append(line)
        return out

    def structure_source(self, key):
        d = self.objs[key]
        out = [f'$PBExportHeader${key}.srs', f'global type {key} from structure']
        # the export keeps a member of an object type (datawindow dw, transaction t ...) as a child node, not as a field
        types = {f['name'].lower(): PRIMFIX.get(f['type'], f['type']) for f in d.get('fields', []) if f['attr'] == '0x8c'}
        for c in d.get('controls', []):
            if c.get('field') and c.get('name'):
                types[c['field'].lower()] = c['name']
        order = [m[0].lower() for m in (self.arrays.get(key, {}).get('#members') or {}).get('', []) if m[3] == 0x8c]
        if set(order) != set(types):         # no runtime member list: fields first, object members after
            order = list(types)
            self.report['structures_without_member_order'].append(key)
        flagged = {f['name'].lower() for f in d.get('fields', []) if f.get('array')}
        for name in order:
            out.append(f'\t{types[name]}\t\t{name}{self.array_suffix(key, "", name, name in flagged)}')
        out += ['end type', '']
        return BOM + '\r\n'.join(out)

    def function_source(self, s):
        name = s['name'].lower()
        self.current = name
        own = [r for r in s['routines'] if r.name in (name, '')]
        for r in s['routines']:
            if r.name not in (name, ''):
                self.report['extra_routines'].append({'object': name, 'routine': r.name})
        if len(own) != 1:
            self.report['skipped'].append({'object': name, 'why': f'{len(own)} routines named like the function object'})
            return None
        r = own[0]
        sub = r.ret == '0'
        proto = f'global subroutine {name} ({r.args})' if sub else f'global function {r.ret} {name} ({r.args})'
        parts = [f'$PBExportHeader${name}.srf', f'global type {name} from function_object', 'end type', '', 'forward prototypes',
                 proto, 'end prototypes', '', proto + ';' + self.function_body(r), 'end subroutine' if sub else 'end function', '']
        return BOM + '\r\n'.join(parts)

    # -------------------------------------------------------------------- write
    def run(self, out, improve=None):
        """improve: folder of changes on top of the faithful regeneration (the improved application):
            objects/<library>.pbl.src/<name>.sr?   a whole object, replacing the regenerated one or adding a new one
            patches.py                             PATCHES = [(object, extension, description, regex, replacement, count)]:
                                                   applied to the regenerated text; `count` matches are required, so a
                                                   regeneration can never lose a fix without it being noticed.  With
                                                   regex None the replacement is a function(text) -> (text, changes)
            properties.json                        {"overrides": [{object, control, property, type, value}]}: a design-time
                                                   property value; an inherited control the object did not change so far
                                                   gets its own (inherited) entry"""
        libs = {}
        patches, overlay_done = {}, set()
        self.report['property_overrides'] = {'applied': 0, 'nodes_added': 0, 'failed': []}
        if improve and os.path.exists(os.path.join(improve, 'properties.json')):
            for o in json.load(open(os.path.join(improve, 'properties.json'), encoding='utf-8'))['overrides']:
                d = self.objs.get(o['object'].lower())
                if d is None or self.trees:
                    self.report['property_overrides']['failed'].append(o)
                    continue
                ctl = next((c for c in d.setdefault('controls', [])
                            if (c.get('field') or c.get('name') or '').lower() == o['control'].lower()), None)
                if ctl is None:
                    ctl = {'name': o['control'], 'field': o['control'], 'ancestor': None, 'inherited': True, 'fields': [],
                           'controls': []}
                    d['controls'].append(ctl)
                    self.report['property_overrides']['nodes_added'] += 1
                f = next((f for f in ctl['fields'] if f['name'] == o['property']), None)
                if f is None:
                    ctl['fields'].append({'name': o['property'], 'type': o['type'], 'attr': '0xbc', 'value': o['value']})
                else:
                    f['value'] = o['value']
                self.report['property_overrides']['applied'] += 1
        if improve and os.path.exists(os.path.join(improve, 'patches.py')):
            scope = {}
            exec(compile(open(os.path.join(improve, 'patches.py'), encoding='utf-8').read(), 'patches.py', 'exec'), scope)
            for obj, ext, what, pattern, repl, count in scope.get('PATCHES', []):
                patches.setdefault((obj.lower(), ext), []).append((what, pattern, repl, count))
        self.report['improvements'] = {'objects_replaced': [], 'objects_added': [], 'patches_applied': [], 'patches_failed': []}

        # remove.txt: `library/name.ext` per line (text after # is a comment): objects the improved application drops
        removed = set()
        if improve and os.path.exists(os.path.join(improve, 'remove.txt')):
            for line in open(os.path.join(improve, 'remove.txt'), encoding='utf-8'):
                line = line.split('#')[0].strip().lower()
                if line:
                    removed.add(line)
        self.report['improvements']['objects_removed'] = []

        def write(lib, name, ext, text):
            if f'{lib}/{name}.{ext}' in removed:
                stale = os.path.join(out, 'ws_objects', lib + '.pbl.src', f'{name}.{ext}')
                if os.path.exists(stale):
                    os.remove(stale)
                self.report['improvements']['objects_removed'].append(f'{lib}/{name}.{ext}')
                return
            if improve:
                over = os.path.join(improve, 'objects', lib + '.pbl.src', f'{name}.{ext}')
                if os.path.exists(over):
                    text = open(over, encoding='utf-8-sig', newline='').read()
                    text = BOM + '\r\n'.join(text.splitlines()) + '\r\n'
                    overlay_done.add(os.path.normcase(over))
                    self.report['improvements']['objects_replaced'].append(f'{lib}/{name}.{ext}')
                for what, pattern, repl, count in patches.get((name, ext), []):
                    # no pattern: `repl` is a function(text) -> (new text, number of changes made)
                    text, n = re.subn(pattern, repl, text) if pattern is not None else repl(text)
                    key = 'patches_applied' if n == count else 'patches_failed'
                    self.report['improvements'][key].append({'object': name, 'patch': what, 'matches': n, 'expected': count})
            # binary component (OLE / ActiveX control data), exported from the original library by olebin_export.py
            binary = os.path.join(self.root, 'recovered', 'olebin', name + '.txt')
            if ext in ('srw', 'sru', 'srd') and os.path.exists(binary):
                text = text.rstrip('\r\n') + '\r\n' + open(binary, encoding='utf-8', newline='').read().lstrip('\r\n')
                self.report['binary_sections'] += 1
            target = os.path.join(out, 'ws_objects', lib + '.pbl.src')
            os.makedirs(target, exist_ok=True)
            with open(os.path.join(target, f'{name}.{ext}'), 'w', encoding='utf-8', newline='') as h:
                h.write(text)
            libs[lib] = libs.get(lib, 0) + 1
            self.report['written'][ext] = self.report['written'].get(ext, 0) + 1

        for s in sorted(self.all_scripts, key=lambda x: (x['name'].lower(), x['lib'])):
            key, kind, lib = s['name'].lower(), s['kind'], s['lib']
            try:
                if kind == 'function':
                    text = self.function_source(s)
                    if text:
                        self.report['functions'] += 1
                elif kind in ('window', 'userobject', 'menu', 'application'):
                    text = self.object_source(key, kind)
                else:
                    text = None
            except Exception as e:          # one object must not stop the export; it is listed instead
                self.report['skipped'].append({'object': key, 'why': f'{type(e).__name__}: {e}'})
                text = None
            if text:
                write(lib, key, EXT[kind], text)
        for key, d in sorted(self.objs.items()):
            lib = (d.get('library') or '').lower().replace('.pbd', '')
            if d.get('kind') == 'structure' and lib:
                write(lib, key, 'srs', self.structure_source(key))
            elif d.get('kind') in ('window', 'userobject', 'menu') and key not in self.scripts and lib:
                # an object without any script still exists (properties and controls only)
                try:
                    write(lib, key, EXT[d['kind']], self.object_source(key, d['kind']))
                except Exception as e:
                    self.report['skipped'].append({'object': key, 'why': f'{type(e).__name__}: {e}'})
        # DataWindows are export source already: recovered/datawindows/<library>/<name>.srd
        for f in glob.glob(os.path.join(self.root, 'recovered', 'datawindows', '*', '*.srd')):
            lib = os.path.basename(os.path.dirname(f)).lower().replace('.pbd', '')
            name = os.path.basename(f)[:-4].lower()
            # improve/datawindows/<library>/<name>.srd: a corrected DataWindow in the same form (engine export)
            better = os.path.join(improve, 'datawindows', os.path.basename(os.path.dirname(f)), os.path.basename(f)) if improve else None
            if better and os.path.exists(better):
                f = better
                self.report['improvements'].setdefault('datawindows_replaced', []).append(f'{lib}/{name}')
            raw = open(f, 'rb').read()
            for enc in ('utf-8-sig', 'utf-16', 'cp1252'):
                try:
                    text = raw.decode(enc)
                    break
                except UnicodeError:
                    continue
            if not text.startswith('$PBExportHeader$'):
                text = f'$PBExportHeader${name}.srd\r\n' + text
            write(lib, name, 'srd', BOM + text)
            self.report['datawindows'] += 1
        # objects that exist only in the improvement folder
        if improve:
            for f in sorted(glob.glob(os.path.join(improve, 'objects', '*.pbl.src', '*.sr?'))):
                if os.path.normcase(f) in overlay_done:
                    continue
                lib = os.path.basename(os.path.dirname(f))[:-len('.pbl.src')]
                name, ext = os.path.basename(f).rsplit('.', 1)
                text = open(f, encoding='utf-8-sig', newline='').read()
                write(lib, name, ext, text)
                tag = f'{lib}/{name}.{ext}'
                if tag in self.report['improvements']['objects_replaced']:
                    self.report['improvements']['objects_replaced'].remove(tag)       # nothing was regenerated for it
                self.report['improvements']['objects_added'].append(tag)
        # pipelines and queries are kept as source text inside the compiled libraries
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import pbd_lib
        for f in sorted(glob.glob(os.path.join(self.root, 'Application', '*.pbd'))):
            data = open(f, 'rb').read()
            for e in pbd_lib.entries(data):
                name, _, ext = e['name'].rpartition('.')
                if ext in ('srp', 'srq'):
                    text = pbd_lib.read_obj(data, e).decode('utf-16le', 'replace').rstrip('\x00')
                    write(os.path.basename(f)[:-4].lower(), name.lower(), ext, BOM + f'$PBExportHeader${name.lower()}.{ext}\r\n' + text)
        order = sorted(libs, key=lambda x: (x != 'abuzarapp', x))
        pbt = ['Save Format v3.0(19990112)', '@begin Projects', '@end;', 'appname "traderappv1";', 'applib "abuzarapp.pbl";',
               'LibList "' + ';'.join(x + '.pbl' for x in order) + '";', 'type "pb";', '']
        with open(os.path.join(out, 'abuzar.pbt'), 'w', encoding='utf-8', newline='') as h:
            h.write('\r\n'.join(pbt))
        # build file for PBAutoBuild (PowerBuilder 2022; schema from Appeon's documentation, not run yet): the Merging step
        # creates the PBLs, imports the .sr* files and compiles them
        build = {'MetaInfo': {'IDEVersion': '220', 'RuntimeVersion': '22.0.0.1878'},
                 'BuildPlan': {'SourceControl': {'PreCommand': '', 'ClearSrcBeforeDownload': False, 'SVN': [], 'Git': [], 'VSS': [],
                                                 'Merging': [{'Target': '.\\abuzar.pbt', 'LocalProjectPath': '.', 'RefreshPbl': True}],
                                                 'PostCommand': ''},
                               'BuildJob': {'PreCommand': '', 'Projects': [], 'PostCommand': ''}}}
        with open(os.path.join(out, 'build.json'), 'w', encoding='utf-8') as h:
            json.dump(build, h, indent=1)
        with open(os.path.join(out, 'event-objects.json'), 'w', encoding='utf-8') as h:
            json.dump(self.need_sigs, h, indent=0)      # input of `extdecl_export.py --events`
        self.report['libraries'] = libs
        with open(os.path.join(out, 'export-report.json'), 'w', encoding='utf-8') as h:
            json.dump(self.report, h, indent=1)
        r = self.report
        print('written', r['written'], '| libraries', len(libs))
        print('skipped', len(r['skipped']), '| unassigned routine runs', len(r['unassigned_routines']), '| run mismatches',
              len(r['run_mismatches']), '| functions on controls', len(r['functions_on_controls']))
        print('events declared', r['events_declared'], '(mapped to a message id:', r['events_mapped'], ') | without signature',
              len(r['events_without_signature']))
        print('external / RPC declarations written', r['external_functions'], '| object-level structures', r['local_structures'],
              '| arrays with fixed bounds', r['bounded_arrays'])
        print('external / RPC functions without declaration', r['external_functions_missing'], '| OLE controls', len(r['ole_controls']),
              '| cursor declarations rebuilt', r['cursor_declares'], 'missing', r['cursor_declares_missing'], '| globals without type', len(r['globals_without_type']))


if __name__ == '__main__':
    Project(sys.argv[1]).run(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
