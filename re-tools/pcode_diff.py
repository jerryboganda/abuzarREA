"""Instruction-level differences between two p-code exports of the same object, with context.

usage: python -I pcode_diff.py <a/object.json> <b/object.json> [context=4]
"""
import sys, json

sys.stdout.reconfigure(encoding='utf-8')


def routines(obj):
    out = {}

    def walk(node, path):
        for i, r in enumerate(node.get('routines', [])):
            out[(path, i, r.get('name'))] = r
        for c in node.get('controls', []):
            walk(c, path + '/' + str(c.get('name')))
    walk(obj, obj.get('name', ''))
    return out


def main(a, b, ctx=4):
    A, B = routines(json.load(open(a, encoding='utf-8'))), routines(json.load(open(b, encoding='utf-8')))
    for key in A:
        ia, ib = A[key].get('instrs') or [], (B.get(key) or {}).get('instrs') or []
        if ia == ib:
            continue
        print('==', key, len(ia), len(ib))
        if len(ia) != len(ib):
            print('   different instruction counts')
        for n, (x, y) in enumerate(zip(ia, ib)):
            if x != y:
                for j in range(max(0, n - ctx), min(len(ia), n + ctx + 1)):
                    mark = '>>' if ia[j] != ib[j] else '  '
                    print(mark, ia[j], '' if ia[j] == ib[j] else '  ->  %s' % (ib[j],))
                print()


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 4)
