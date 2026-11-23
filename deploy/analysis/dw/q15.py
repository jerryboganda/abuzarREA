import glob,re,os
for fn in sorted(glob.glob("out_*.txt")):
    try:
        lines=open(fn,encoding="utf-8-sig",errors="replace").read().splitlines()
    except: continue
    # rows before first Table ' line
    n=0
    for l in lines:
        if l.startswith("Table '"): break
        n+=1
    data=max(0,n-2) if n>=2 else 0
    cpu=re.findall(r"CPU time = (\d+) ms",open(fn,encoding="utf-8-sig",errors="replace").read())
    el=re.findall(r"elapsed time = (\d+) ms",open(fn,encoding="utf-8-sig",errors="replace").read())
    print(f'{fn:38s} result_lines={data:6d} cpu={cpu[-1] if cpu else "?":>6s} elapsed={el[-1] if el else "?":>6s}')
