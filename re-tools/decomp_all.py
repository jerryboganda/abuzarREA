"""Decompile a whole export tree (or one library) to text files: <out>/<library>/<object>.pbs
usage: python -I decomp_all.py <pcode export root> <out root> [library ...]"""
import sys, os, json, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import decomp_obj as D


def main(root, out, libs):
    stats = collections.Counter()
    for libdir in sorted(glob.glob(os.path.join(root, '*'))):
        lib = os.path.basename(libdir)
        if not os.path.isdir(libdir) or (libs and lib not in libs):
            continue
        ctx = D.Ctx(glob.glob(os.path.join(root, '*', '_classfields.json')))
        os.makedirs(os.path.join(out, lib), exist_ok=True)
        for f in sorted(glob.glob(os.path.join(libdir, '*', '*.json'))):
            obj = json.load(open(f, encoding='utf-8'))
            lines = ['// %s %s (%s)  ancestor: %s' % (obj.get('kind'), obj['name'], lib, obj.get('ancestor')), '']
            for owner, r in D.routines_of(obj, obj['name']):
                try:
                    body = D.decompile_routine(obj, ctx, owner, r)
                except Exception as e:
                    body = ['// %s.%s: DECOMPILE ERROR %r' % (owner, r['name'], e)]
                    stats['error'] += 1
                lines += body + ['']
                stats['routines'] += 1
                if any(l.startswith('// PROBLEMS') for l in body):
                    stats['problems'] += 1
            with open(os.path.join(out, lib, obj['name'] + '.pbs'), 'w', encoding='utf-8', errors='replace') as fh:
                fh.write('\n'.join(lines))
    print(dict(stats))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], set(sys.argv[3:]))
