"""Build a small, self-contained compile test from the regenerated source: a minimal application object plus the
generated global functions that depend on nothing else in the application.  It answers one question as early as
possible: does Appeon PBAutoBuild accept and compile what pbsrc_export.py writes?

    python -I re-tools/pbsrc_compiletest.py pbsrc pbsrc/compiletest
    PBAutoBuild220.exe /f pbsrc\\compiletest\\build.json /l build.log /le error.log

The build file uses only the documented `Merging` step (create the PBL, import the .sr* files, compile).  Its exact
schema is taken from Appeon's documentation and has not been run yet.
"""
import glob
import json
import os
import re
import shutil
import sys

BOM = '﻿'
APP = 'compiletest'
SRA = f'''$PBExportHeader${APP}.sra
forward
global type {APP} from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type {APP} from application
string appname = "{APP}"
end type
global {APP} {APP}

on {APP}.create
appname="{APP}"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on {APP}.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;messagebox("compile test", "built from regenerated source")
end event
'''


def independent(text, name, user_types):
    """no call to another application function, no application global, no application type"""
    body = text.lower()
    if re.search(r'\b(gs|gl|gi|gb|gd|gds|ga|gdt|gdc)_\w+', body):
        return False
    for other in re.findall(r'\b((?:f|af|wf|of|uf)_\w+)\s*\(', body):
        if other != name:
            return False
    return not any(re.search(r'\b' + re.escape(t) + r'\b', body) for t in user_types)


def main(src, out):
    files = sorted(glob.glob(os.path.join(src, 'ws_objects', '*.pbl.src', '*.srf')))
    # names of application classes a function may mention (windows, user objects, structures, menus)
    user_types = set()
    for d, _, fs in os.walk(os.path.join(os.path.dirname(os.path.abspath(src)), 'recovered', 'objects')):
        if os.path.basename(d) in ('window', 'userobject', 'structure', 'menu'):
            user_types.update(f[:-5].lower() for f in fs if f.endswith('.json'))
    target = os.path.join(out, 'ws_objects', APP + '.pbl.src')
    if os.path.isdir(out):
        shutil.rmtree(out)
    os.makedirs(target)
    picked = []
    for f in files:
        name = os.path.basename(f)[:-4]
        text = open(f, encoding='utf-8-sig').read()
        if independent(text, name, user_types):
            shutil.copy(f, target)
            picked.append(name)
    with open(os.path.join(target, APP + '.sra'), 'w', encoding='utf-8', newline='') as h:
        h.write(BOM + SRA.replace('\n', '\r\n'))
    with open(os.path.join(out, APP + '.pbt'), 'w', encoding='utf-8', newline='') as h:
        h.write('\r\n'.join(['Save Format v3.0(19990112)', '@begin Projects', '@end;', f'appname "{APP}";',
                             f'applib "{APP}.pbl";', f'LibList "{APP}.pbl";', 'type "pb";', '']))
    # PowerBuilder 2022 (owner's choice, 2026-11-23): PBAutoBuild220.exe; use '250' with PBAutoBuild250.exe
    build = {'MetaInfo': {'IDEVersion': '220', 'RuntimeVersion': ''},
             'BuildPlan': {'SourceControl': {'PreCommand': '', 'ClearSrcBeforeDownload': False, 'SVN': [], 'Git': [], 'VSS': [],
                                             'Merging': [{'Target': f'.\\{APP}.pbt', 'LocalProjectPath': '.', 'RefreshPbl': True}],
                                             'PostCommand': ''},
                           'BuildJob': {'PreCommand': '', 'Projects': [], 'PostCommand': ''}}}
    with open(os.path.join(out, 'build.json'), 'w', encoding='utf-8') as h:
        json.dump(build, h, indent=1)
    print(f'{len(picked)} of {len(files)} functions are self-contained and were copied to {out}')
    print(', '.join(picked[:12]) + (' ...' if len(picked) > 12 else ''))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
