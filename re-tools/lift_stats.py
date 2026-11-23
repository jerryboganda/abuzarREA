"""Run the lifter over a pcode export directory and report problems (stack imbalance, unknown ops, unresolved refs)."""
import sys, os, json, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pcode_lift as L


class Ctx:
    def __init__(self, root):
        self.sysf = json.load(open(os.path.join(root, '..', 'pcode_names', 'sysfuncs.json'), encoding='utf-8'))
        self.classfields = {}
        self._pools = {}
        yp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'system_types.json')
        self.systypes = json.load(open(yp, encoding='utf-8')) if os.path.exists(yp) else {}
        gp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'global_types.json')
        self.gtypes = json.load(open(gp, encoding='utf-8')) if os.path.exists(gp) else {}
        sp = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'shared_vars.json')
        self.shared = json.load(open(sp, encoding='utf-8')) if os.path.exists(sp) else {}
        self.root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode')
        ip = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'objindex.json')
        self.objindex = json.load(open(ip, encoding='utf-8')) if os.path.exists(ip) else {}
        self.protos, self.ancestor = {}, {}
        pf = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'recovered', 'pcode_names', 'protos.json')
        if os.path.exists(pf):
            pj = json.load(open(pf, encoding='utf-8'))
            self.protos, self.ancestor = pj['protos'], pj['ancestor']
        for f in glob.glob(os.path.join(root, '*', '_classfields.json')):
            self.classfields.update(json.load(open(f, encoding='utf-8')))

    def pool_of(self, name):
        """statement pool (bytes) of the object called `name` - used for statements stored in an ancestor"""
        if name not in self._pools:
            rel = self.objindex.get(name)
            pool = b''
            if rel:
                import base64
                sp = json.load(open(os.path.join(self.root, rel), encoding='utf-8')).get('sqlpool')
                pool = base64.b64decode(sp['b64']) if sp else b''
            self._pools[name] = pool
        return self._pools[name]


def routines_of(node, owner):
    for r in node['routines']:
        r['_fnrefs'] = node.get('fnrefs')
        yield owner, r
    for c in node['controls']:
        yield from routines_of(c, c['name'])


def main(root, limit=None):
    ctx = Ctx(root)
    probs = collections.Counter()
    nrout = nclean = 0
    examples = {}
    files = glob.glob(os.path.join(root, '*', '*', '*.json'))
    for fi, f in enumerate(files):
        if limit and fi >= limit:
            break
        obj = json.load(open(f, encoding='utf-8'))
        for owner, r in routines_of(obj, obj['name']):
            nrout += 1
            lf = L.Lifter(obj, ctx, r, owner)
            try:
                lf.run()
            except Exception as e:
                lf.problems.append('EXC:%s' % type(e).__name__)
                examples.setdefault('EXC:%s' % type(e).__name__, (f, owner, r['name'], repr(e)))
            if not lf.problems:
                nclean += 1
            for p in set(__import__('re').sub(r'[ @]-?\d+.*','',x) for x in lf.problems):
                probs[p] += 1
                examples.setdefault(p, (os.path.basename(f), owner, r['name']))
    print('routines', nrout, 'clean', nclean)
    for p, c in probs.most_common(60):
        print('%6d  %-28s e.g. %s' % (c, p, examples[p]))


if __name__ == '__main__':
    main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else None)
