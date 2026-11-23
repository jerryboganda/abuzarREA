for enc in ["utf-16", "utf-8-sig", "latin-1"]:
    s = open("out_m7.txt", encoding=enc, errors="replace").read()
    lines = s.splitlines()
    n = 0
    for l in lines:
        if l.startswith("Table '"):
            break
        n += 1
    print(enc, "lines", len(lines), "beforeTable", n)
print(repr(open("out_m7.txt", "rb").read(8)))
