import os, re, glob

bad = []
for path in glob.glob(r"C:\Projects\Abuzar\recovered\scripts\**\*.pbs", recursive=True):
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    hdr = None
    blocks = []
    cur = None
    for i, l in enumerate(lines):
        if l.startswith("// ") and re.match(r"^//\s+\S+\.\w+\(", l):
            if cur:
                blocks.append(cur)
            cur = {"hdr": l, "s": i + 1, "lines": []}
        elif cur is not None:
            cur["lines"].append(l)
    if cur:
        blocks.append(cur)
    for b in blocks:
        depth = 0
        off = False
        setline = None
        for j, l in enumerate(b["lines"]):
            low = l.strip().lower()
            if "setredraw(false)" in low or "setredraw( false" in low:
                if not off:
                    off = True
                    depth = 0
                    setline = j
            if off:
                depth += len(re.findall(r"^\s*(for|do|choose|if)\b", l))
                depth -= len(re.findall(r"^\s*(next|loop|end choose|end if)\b", l))
                if "setredraw(true)" in low:
                    off = False
                elif re.match(r"^\s*return\b", l):
                    # return while redraw is off
                    bad.append((b["hdr"], path, setline))
                    off = False
print("blocks with SetRedraw(false) then return before SetRedraw(true):", len(bad))
for h, p, sl in bad[:40]:
    print(h, "|", os.path.basename(p), "| setredraw at block line", sl)
