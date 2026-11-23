"""Show compiler errors of one code together with the source lines they point at.

    python -I re-tools/compile_show.py pbsrc2/rebuild-1.jsonl pbsrc2/ws_objects C0015 [max examples] [text filter]

The line number of a message counts from the first line of the routine's script; the routine is found in the generated
source file of the object (function body, `event x;` or `on x.create` block of the named class).
"""
import glob
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import compile_errors as C


def routine_lines(path, section, obj):
    """lines of the routine a message section names, or None"""
    text = open(path, encoding='utf-8-sig').read().replace('\r\n', '\n').split('\n')
    m = re.match(r'(Function|Event): (\S+?)::(\S+)', section or '')
    if section and section.startswith('Function Source'):
        start = next((i for i, l in enumerate(text) if re.match(r'global (function|subroutine) ', l) and l.rstrip().endswith(';') is False
                      and ';' in l), None)
        if start is None:
            start = next((i for i, l in enumerate(text) if re.match(r'global (function|subroutine) .*\);', l)), None)
    elif m:
        kind, cls, name = m.group(1), m.group(2).lower(), m.group(3).lower()
        start, current = None, obj.lower()
        for i, l in enumerate(text):
            t = re.match(r'type (\w+) from .* within ', l)
            if t:
                current = t.group(1).lower()
            if re.match(r'global type ', l):
                current = obj.lower()
            if kind == 'Function' and re.match(r'(public|private|protected) (function|subroutine) .*\b%s \(.*\);' % re.escape(name), l):
                start = i
                break
            if kind == 'Event' and current == cls and (re.match(r'event (type \S+ )?%s\b.*;' % re.escape(name), l)
                                                       or re.match(r'on %s\.%s\b' % (re.escape(cls), re.escape(name)), l)):
                start = i
                break
    else:
        return None
    if start is None:
        return None
    first = text[start]
    first = first[first.index(';') + 1:] if ';' in first else ''
    return [first] + text[start + 1:start + 4000]


def main(argv):
    rows = [r for r in C.parse(C.load(argv[0])) if r[4] == 'Error' and r[5] == argv[2]]
    limit = int(argv[3]) if len(argv) > 3 else 12
    flt = argv[4].lower() if len(argv) > 4 else None
    files = {}
    for f in glob.glob(os.path.join(argv[1], '*', '*.sr?')):
        files.setdefault(os.path.basename(f).rsplit('.', 1)[0].lower(), f)
    shown, seen = 0, set()
    for lib, obj, sec, line, kind, code, text in rows:
        if flt and flt not in text.lower():
            continue
        key = re.sub(r'\w+$', '', text) if len(seen) > 40 else text
        if (text, sec) in seen:
            continue
        seen.add((text, sec))
        src = None
        f = files.get((obj or '').lower())
        if f:
            lines = routine_lines(f, sec, obj)
            if lines and 0 < line <= len(lines):
                src = lines[line - 1].strip()
        print(f'{obj} [{sec}] line {line}: {text[:110]}')
        print(f'      > {src[:170] if src else "(source line not found)"}')
        shown += 1
        if shown >= limit:
            break
    print(f'-- {len(rows)} errors with code {argv[2]}')


if __name__ == '__main__':
    main(sys.argv[1:])
