"""Assemble a folder from which the rebuilt application can be started, apart from the vendor's working copy.

usage: python -I pb_runfolder.py <build folder (abuzar.exe + *.pbd from orca_build.py exe)> <vendor Application folder>
                                 <run folder> [--db <database name>]

Copies: the new abuzar.exe and its PBDs; the vendor's own files that are not PowerBuilder 12.5 runtime or compiled
libraries (third-party DLLs, pictures, sounds, Reports\\, Script.mdb, the settings file mgmtcomp.pbd); the 32-bit
PowerBuilder 2022 runtime DLLs.  The licence / settings file is taken as it is; `--db` rewrites its database-name line only
(line 17; the file is UTF-8 text, one setting per line, every character shifted by 128), so a test run works on a copy of
the database.
Nothing of the settings file is printed.
"""
import sys, os, shutil, glob, re

RUNTIME = r'C:\Program Files (x86)\Appeon\Common\PowerBuilder\Runtime 22.0.0.1878'
SKIP_DIRS = {'_pbd_before_patch_20261123', 'tmpwebservice'}


def main(build, vendor, run, db=None):
    os.makedirs(run, exist_ok=True)
    n = {'built': 0, 'vendor': 0, 'runtime': 0}
    built = {os.path.basename(f).lower() for f in glob.glob(os.path.join(build, '*.pbd'))} | {'abuzar.exe'}
    for f in glob.glob(os.path.join(build, '*.pbd')) + [os.path.join(build, 'abuzar.exe')]:
        shutil.copy2(f, os.path.join(run, os.path.basename(f)))
        n['built'] += 1
    for root, dirs, files in os.walk(vendor):
        dirs[:] = [d for d in dirs if d.lower() not in SKIP_DIRS]
        rel = os.path.relpath(root, vendor)
        for f in files:
            low = f.lower()
            if low in built or low.endswith(('.pbd', '.pbx', '.legacy-fix-backup', '.bak')) and low != 'mgmtcomp.pbd':
                continue
            if re.match(r'^pb\w*125\.(dll|ini|jar)$', low) or low in ('pbvm125.dll', 'abuzar.exe', 'waseelalauncher.exe'):
                continue                       # the 12.5 runtime and the old executables
            if low.startswith('sybase.powerbuilder.') or low in ('easysoap125.dll', 'expat125.dll', 'service1.dll'):
                continue                       # 12.5 web service pieces, replaced by HTTPClient
            os.makedirs(os.path.join(run, rel), exist_ok=True)
            target = os.path.join(run, rel, f)
            if os.path.exists(target):
                try:
                    os.chmod(target, 0o666)                # a read-only copy from the last run
                    shutil.copy2(os.path.join(root, f), target)
                except PermissionError:
                    n['kept'] = n.get('kept', 0) + 1       # in use by a running test: the copy already there stays
                    continue
            else:
                shutil.copy2(os.path.join(root, f), target)
            n['vendor'] += 1
    for f in os.listdir(RUNTIME):
        p = os.path.join(RUNTIME, f)
        if os.path.isfile(p) and f.lower().endswith(('.dll', '.ini', '.pbx', '.pbd', '.json')):
            shutil.copy2(p, os.path.join(run, f))
            n['runtime'] += 1
    if db:
        p = os.path.join(run, 'mgmtcomp.pbd')
        raw = open(p, 'rb').read()
        bom = raw.startswith(b'\xef\xbb\xbf')                 # the file is UTF-8 text with a byte order mark
        text = raw.decode('utf-8-sig')
        nl = '\r\n' if '\r\n' in text else '\n'
        lines = text.split(nl)
        if len(lines) < 17:
            raise SystemExit('settings file has fewer than 17 lines')
        lines[16] = ''.join(chr(ord(c) + 128) for c in db)
        open(p, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + nl.join(lines).encode('utf-8'))
    print('copied', n, '| database line', 'rewritten' if db else 'unchanged', '| run folder', run)


if __name__ == '__main__':
    a = sys.argv[1:]
    db = None
    if '--db' in a:
        db = a[a.index('--db') + 1]
        del a[a.index('--db'):a.index('--db') + 2]
    main(a[0], a[1], a[2], db)
