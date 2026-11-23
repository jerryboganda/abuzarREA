import re, sys, os

ROOT = r"C:\Projects\Abuzar\recovered\scripts"
DB = re.compile(r'\bSQL\s+(SELECT|INSERT|UPDATE|DELETE|COMMIT|ROLLBACK|EXECUTE|EXEC)\b|\.\s*retrieve\s*\(|\.\s*update\s*\(|\.\s*insertrow\s*\(|\.\s*deleterow\s*\(', re.I)
FOR = re.compile(r'^\s*(for\s+.+\bto\b|do\b(?!uble))', re.I)
END = re.compile(r'^\s*(next|loop)\b', re.I)

def scan(rel):
    path = os.path.join(ROOT, rel)
    lines = open(path, encoding='utf-8', errors='replace').read().splitlines()
    stack = []
    out = []
    for i, ln in enumerate(lines):
        isdb = bool(DB.search(ln))
        for fr in stack:
            if isdb:
                fr['db'] += 1
                fr['last'] = i
        if FOR.match(ln):
            stack.append({'start': i, 'db': 0, 'last': i})
        elif END.match(ln) and stack:
            fr = stack.pop()
            if fr['db'] >= 4:
                out.append(fr)
    return lines, out

for rel in sys.argv[1:]:
    lines, out = scan(rel)
    print(f"===== {rel}: {len(out)} loops with >=4 DB ops =====")
    for fr in sorted(out, key=lambda x: -x['db'])[:5]:
        print(f"--- lines {fr['start']+1}-{fr['last']+1}, {fr['db']} db ops ---")
        for j in range(fr['start'], min(fr['start']+10, len(lines))):
            print(f"{j+1}: {lines[j][:170]}")
        print("...")
