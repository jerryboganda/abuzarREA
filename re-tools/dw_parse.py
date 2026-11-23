"""Parse DataWindow source syntax (.srd, as exported by dw_export.py) into JSON.

usage: python -I dw_parse.py <srd dir or file> <out dir>
Result per DataWindow: {release, datawindow:{...}, bands:{header|summary|footer|detail|group:{...}},
table:{columns:[...], retrieve, update, arguments, ...}, objects:[{type, band, name, x, y, width, height, ...}],
extras:[{type, props}]}.  Attribute values are kept as strings exactly as written (quotes/escapes resolved).
"""
import sys, os, re, json, glob

BAND_TYPES = ('header', 'summary', 'footer', 'detail', 'group')
OBJECT_TYPES = ('text', 'column', 'compute', 'line', 'rectangle', 'ellipse', 'roundrectangle', 'bitmap', 'button',
                'groupbox', 'report', 'graph', 'ole', 'inkpic', 'tableblob', 'richtext', 'picture')
ESC = {'n': '\n', 'r': '\r', 't': '\t', '"': '"', "'": "'", '~': '~'}


class Parser:
    def __init__(self, s):
        self.s, self.i, self.n = s, 0, len(s)

    def ws(self):
        while self.i < self.n and self.s[self.i] in ' \t\r\n':
            self.i += 1

    def ident(self):
        m = re.compile(r'[A-Za-z_][\w.]*(?:\[\d+\])?').match(self.s, self.i)
        if not m:
            return None
        self.i = m.end()
        return m.group()

    def string(self):
        assert self.s[self.i] == '"'
        self.i += 1
        out = []
        while self.i < self.n:
            c = self.s[self.i]
            if c == '~' and self.i + 1 < self.n:
                nx = self.s[self.i + 1]
                out.append(ESC.get(nx, '~' + nx))
                self.i += 2
                continue
            if c == '"':
                self.i += 1
                return ''.join(out)
            out.append(c)
            self.i += 1
        raise ValueError('unterminated string')

    def value(self):
        self.ws()
        c = self.s[self.i]
        if c == '"':
            return self.string()
        if c == '(':
            return self.group()
        m = re.compile(r"[^\s()\"=]+").match(self.s, self.i)
        if not m:
            raise ValueError('bad value at %d: %r' % (self.i, self.s[self.i:self.i + 30]))
        self.i = m.end()
        tok = m.group()
        if self.i < self.n and self.s[self.i] == '(':      # e.g. type=char(20), decimal(2)
            j = self.s.index(')', self.i)
            tok += self.s[self.i:j + 1]
            self.i = j + 1
        return tok

    def group(self):
        """( key=value key=value ... ) -> dict; repeated keys / bare items kept in order."""
        assert self.s[self.i] == '('
        self.i += 1
        props, items = {}, []
        while True:
            self.ws()
            if self.i >= self.n:
                raise ValueError('unterminated group')
            if self.s[self.i] == ')':
                self.i += 1
                break
            if self.s[self.i] == '"':
                items.append(self.string())
                continue
            if self.s[self.i] == '(':          # nested list, e.g. arguments=(("a", number), ("b", date))
                items.append(self.group())
                continue
            if self.s[self.i] in ',':
                self.i += 1
                continue
            k = self.ident()
            if k is None:
                raise ValueError('bad key at %d: %r' % (self.i, self.s[self.i:self.i + 40]))
            self.ws()
            if self.i < self.n and self.s[self.i] == '=':
                self.i += 1
                v = self.value()
                props[k] = v
            elif self.i < self.n and self.s[self.i] == '(':
                props[k] = self.group()
            else:
                items.append(k)
        if items:
            props['_items'] = items
        return props


def parse(text):
    p = Parser(text)
    out = {'release': None, 'datawindow': {}, 'bands': {}, 'table': {}, 'objects': [], 'extras': []}
    m = re.match(r'\s*release\s+([\d.]+)\s*;', text)
    if m:
        out['release'] = m.group(1)
        p.i = m.end()
    cols = []
    while True:
        p.ws()
        if p.i >= p.n:
            break
        kind = p.ident()
        if kind is None:
            raise ValueError('unexpected %r at %d' % (text[p.i:p.i + 40], p.i))
        p.ws()
        if p.i >= p.n or p.s[p.i] != '(':
            raise ValueError('expected ( after %s' % kind)
        if kind == 'table':
            p.i += 1
            t = {'columns': []}
            while True:
                p.ws()
                if p.s[p.i] == ')':
                    p.i += 1
                    break
                k = p.ident()
                p.ws()
                if p.s[p.i] != '=':
                    raise ValueError('table: expected = after %s' % k)
                p.i += 1
                p.ws()
                v = p.group() if p.s[p.i] == '(' else p.value()
                if k == 'column':
                    t['columns'].append(v)
                else:
                    t[k] = v
            out['table'] = t
            continue
        g = p.group()
        if kind == 'datawindow':
            out['datawindow'] = g
        elif kind.split('[')[0] in BAND_TYPES:
            if kind == 'group':
                out['bands'].setdefault('group', []).append(g)
            else:
                out['bands'][kind] = g
        elif kind in OBJECT_TYPES:
            g['type'] = kind
            out['objects'].append(g)
        else:
            out['extras'].append({'type': kind, 'props': g})
    return out


def main(src, out):
    files = [src] if os.path.isfile(src) else sorted(glob.glob(os.path.join(src, '**', '*.srd'), recursive=True))
    os.makedirs(out, exist_ok=True)
    bad = []
    for f in files:
        try:
            doc = parse(open(f, encoding='utf-8').read())
            name = os.path.splitext(os.path.basename(f))[0]
            sub = os.path.basename(os.path.dirname(f))
            os.makedirs(os.path.join(out, sub), exist_ok=True)
            with open(os.path.join(out, sub, name + '.json'), 'w', encoding='utf-8') as fh:
                json.dump(doc, fh, ensure_ascii=False, indent=1)
        except Exception as e:
            bad.append((f, str(e)))
    print('parsed', len(files) - len(bad), 'failed', len(bad))
    for f, e in bad[:15]:
        print(' ', f, e)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
