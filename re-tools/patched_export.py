"""Export objects + p-code of chosen libraries from another copy of the application (e.g. the patched deploy\\Application).

usage (64-bit Python): python -I patched_export.py <Application dir> <out root> <library> [library ...]
Writes <out root>/liblist.txt, <out root>/objects/<library>/..., <out root>/pcode/<library>/...
The decompiler then runs on <out root>/pcode like on recovered/pcode.
"""
import sys, os, glob, subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
PY32 = r'C:\Tools\py32\python.exe'
sys.path.insert(0, HERE)
import pcode_export_all as P


def run(script, pbd, out):
    crashes, start = [], 0
    while True:
        subprocess.run([PY32, '-I', os.path.join(HERE, script), pbd, out, str(start)], capture_output=True, text=True,
                       timeout=3600)
        last, done = P.progress(out)
        if done:
            return crashes
        if last < start - 1:
            raise SystemExit(f'{script} made no progress on {pbd} (see {out})')
        crashes.append(last)
        start = last + 1


def main(app, root, libs):
    app, root = os.path.abspath(app), os.path.abspath(root)
    os.makedirs(root, exist_ok=True)
    liblist = os.path.join(root, 'liblist.txt')
    with open(liblist, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sorted(glob.glob(os.path.join(app, '*.pbd')))))
    os.environ['PB_LIBLIST'] = liblist
    for lib in libs:
        pbd = os.path.join(app, lib + '.pbd')
        for script, kind in (('obj_export.py', 'objects'), ('pcode_export.py', 'pcode')):
            out = os.path.join(root, kind, lib)
            if os.path.exists(os.path.join(out, '_progress.log')) and P.progress(out)[1]:
                continue
            crashes = run(script, pbd, out)
            log = open(os.path.join(out, '_progress.log'), encoding='utf-8').read().split('\n')
            print(lib, kind, 'ok', sum(x.startswith('OK\t') for x in log), 'fail', sum(x.startswith('FAIL\t') for x in log),
                  'crashes', crashes, flush=True)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], sys.argv[3:])
