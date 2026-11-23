"""Driver: export every DataWindow from every PBD, restarting the 32-bit worker after native crashes.

usage (64-bit Python):  python -I dw_export_all.py <Application dir> <out root>
Output: <out root>/<pbd name>/<datawindow>.srd, <out root>/summary.json
"""
import sys, os, subprocess, json, glob, re

PY32 = r'C:\Tools\py32\python.exe'
HERE = os.path.dirname(os.path.abspath(__file__))


def progress(out):
    p = os.path.join(out, '_progress.log')
    last, done = -1, False
    if os.path.exists(p):
        for line in open(p, encoding='utf-8'):
            f = line.rstrip('\n').split('\t')
            if f[0] == 'START':
                last = int(f[1])
            elif f[0] == 'DONE':
                done = True
    return last, done


def run(pbd, out):
    crashes = []
    start = 0
    while True:
        r = subprocess.run([PY32, '-I', os.path.join(HERE, 'dw_export.py'), pbd, out, str(start)],
                           capture_output=True, text=True, timeout=3600)
        last, done = progress(out)
        if done:
            return crashes
        # native crash: the item that was STARTed but never finished is the culprit; skip it
        crashes.append(last)
        start = last + 1


def main(app, root):
    summary = {}
    for pbd in sorted(glob.glob(os.path.join(app, '*.pbd'))):
        name = os.path.basename(pbd)[:-4]
        out = os.path.join(root, name)
        if os.path.exists(os.path.join(out, '_progress.log')) and progress(out)[1]:
            continue
        crashes = run(pbd, out)
        ok = fail = 0
        for line in open(os.path.join(out, '_progress.log'), encoding='utf-8'):
            ok += line.startswith('OK\t')
            fail += line.startswith('FAIL\t')
        summary[name] = {'ok': ok, 'fail': fail, 'crash_indexes': crashes}
        print(name, summary[name], flush=True)
    json.dump(summary, open(os.path.join(root, 'summary.json'), 'w'), indent=1)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
