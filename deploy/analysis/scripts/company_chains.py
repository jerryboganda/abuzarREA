import os, re

rows = []
total = 0
for dp, _, ns in os.walk('recovered/scripts'):
    for n in ns:
        if not n.endswith('.pbs'):
            continue
        p = os.path.join(dp, n)
        lines = open(p, encoding='utf-8', errors='replace').read().splitlines()
        rel = os.path.relpath(p, 'recovered/scripts').replace('\\', '/')
        run = 0
        start = 0
        best = (0, 0)
        for i, l in enumerate(lines):
            c = len(re.findall(r'\bgs_company\s*=', l, re.I)) + len(re.findall(r'\bleft\s*\(\s*gs_company', l, re.I))
            total += c
            if c:
                if run == 0:
                    start = i + 1
                run += c
                if run > best[0]:
                    best = (run, start)
            else:
                run = 0
        if best[0] >= 8:
            rows.append((best[0], rel, best[1]))
rows.sort(reverse=True)
print('total gs_company comparisons:', total)
print('files with a single chain >=8:', len(rows))
for r in rows[:25]:
    print(r)
