"""Measure a compile run: for every PBL in a folder, which source objects have a compiled object next to them.

    python -I re-tools/pbl_compiled.py pbsrc [pbsrc/compile-result.json]

A PBL holds one entry per source object (`name.sr?`) and, once the object compiled, one entry for its compiled form
(`name.win`, `.udo`, `.fun`, `.men`, `.str`, `.apl`, `.dwo` ...).  An object with source but no compiled entry did not
compile.  This counts results of a real PowerBuilder compile; it does not compile anything itself.
"""
import glob
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pbd_lib as P


def main(folder, out=None):
    total_src = total_bin = 0
    by_kind, failed, libs = {}, {}, {}
    for f in sorted(glob.glob(os.path.join(folder, '*.pbl'))):
        names = [e['name'] for e in P.entries(open(f, 'rb').read())]
        src = [n for n in names if n.rsplit('.', 1)[-1].startswith('sr')]
        have = {n.rsplit('.', 1)[0] for n in names if not n.rsplit('.', 1)[-1].startswith('sr')}
        bad = sorted(n for n in src if n.rsplit('.', 1)[0] not in have)
        for n in src:
            k = n.rsplit('.', 1)[-1]
            c = by_kind.setdefault(k, [0, 0])
            c[0] += 1
            c[1] += n.rsplit('.', 1)[0] in have
        lib = os.path.basename(f)
        libs[lib] = [len(src), len(src) - len(bad)]
        if bad:
            failed[lib] = bad
        total_src += len(src)
        total_bin += len(src) - len(bad)
    print(f'libraries {len(libs)} | source objects {total_src} | compiled {total_bin} | not compiled {total_src - total_bin}')
    for k, (n, ok) in sorted(by_kind.items()):
        print(f'  .{k}: {ok} of {n} compiled')
    if out:
        json.dump({'libraries': libs, 'by_kind': by_kind, 'not_compiled': failed}, open(out, 'w', encoding='utf-8'), indent=1)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
