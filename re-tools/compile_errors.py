"""Summarise the compiler messages of an ORCA rebuild / import (orca_build.py output, .json or .jsonl).

    python -I re-tools/compile_errors.py pbsrc/rebuild-1.json [summary.json] [--show C0031 20]

Groups the messages by object and by error code so that a class of errors can be fixed at its source (the decompiler or
the source generator) instead of object by object.
"""
import collections
import json
import re
import sys


def load(path):
    if path.endswith('l'):
        return [json.loads(x) for x in open(path, encoding='utf-8') if x.strip()]
    return json.load(open(path, encoding='utf-8')).get('messages', [])


def parse(messages):
    """[(library, object, section, line, kind, code, text)]"""
    lib = obj = sec = None
    out = []
    for m in messages:
        t = m.get('text') or ''
        a = re.match(r'\s*Library: (.*)', t)
        if a:
            lib = a.group(1).replace('\\', '/').rsplit('/', 1)[-1]
            continue
        a = re.match(r'\s*Object: (\S+)', t)
        if a:
            obj, sec = a.group(1), None
            continue
        a = re.search(r'\((\d+)\): (Error|Warning|Information)\s+(C\d+): (.*)', t)
        if a:
            out.append((lib, obj, sec, int(a.group(1)), a.group(2), a.group(3), a.group(4).strip()))
        elif t.strip():
            sec = t.strip()
    return out


def main(argv):
    rows = parse(load(argv[0]))
    errors = [r for r in rows if r[4] == 'Error']
    objects = {(r[0], r[1]) for r in errors}
    by_code = collections.Counter((r[5], re.sub(r':.*', '', r[6])) for r in errors)
    print(f'messages {len(rows)} | errors {len(errors)} in {len(objects)} objects | warnings {sum(r[4] == "Warning" for r in rows)}')
    for (code, text), n in by_code.most_common(40):
        objs = len({(r[0], r[1]) for r in errors if r[5] == code})
        print(f'{n:7d}  {code}  {text[:70]}   ({objs} objects)')
    if '--show' in argv:
        i = argv.index('--show')
        code, limit = argv[i + 1], int(argv[i + 2]) if len(argv) > i + 2 else 15
        seen = collections.Counter()
        for r in errors:
            if r[5] == code and seen[r[6]] < 2 and sum(seen.values()) < limit:
                seen[r[6]] += 1
                print(f'   {r[1]} [{r[2]}] line {r[3]}: {r[6][:140]}')
    if len(argv) > 1 and not argv[1].startswith('--'):
        json.dump({'errors': len(errors), 'objects_with_errors': len(objects),
                   'by_code': [[c, t, n] for (c, t), n in by_code.most_common()],
                   'by_object': {f'{l}/{o}': n for (l, o), n in collections.Counter((r[0], r[1]) for r in errors).most_common()}},
                  open(argv[1], 'w', encoding='utf-8'), indent=1)


if __name__ == '__main__':
    main(sys.argv[1:])
