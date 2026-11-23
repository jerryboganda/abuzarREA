"""Extract the raw .mdf pages from a SQL Server 2000-format .BAK (internal DB version 539).

The backup is an MTF container: a fixed header, then the database pages in file order
(unallocated pages are zero-filled), then MTF trailer blocks ("MQDA"/"MSTL").  Every real
page carries its page id at offset 0x20, so pages are placed at their own offset; that
also repairs any pages the writer omitted.

usage: python -I bak2000.py <file.bak> <out.mdf> [file_pages]
"""
import os, struct, sys

PAGE = 8192


def find_data_start(b):
    """First page-0 header: version 1, type 15 (file header), page id 0, file id 1."""
    for off in range(0, min(len(b), 1 << 20)):
        if b[off] == 1 and b[off + 1] == 15 and struct.unpack_from('<I', b, off + 0x20)[0] == 0 \
                and struct.unpack_from('<I', b, off + 0x24)[0] == 1:
            return off
    raise SystemExit('page 0 header not found')


def extract(bak, out, file_pages=None):
    size = os.path.getsize(bak)
    with open(bak, 'rb') as f:
        head = f.read(1 << 20)
        base = find_data_start(head)
        f.seek(base)
        pages = {}
        seen = 0
        while True:
            pg = f.read(PAGE)
            if len(pg) < PAGE:
                break
            if pg[:4] in (b'MQDA', b'MSTL', b'EOF1', b'EOF2'):
                break
            seen += 1
            pid = struct.unpack_from('<I', pg, 0x20)[0]
            fid = struct.unpack_from('<I', pg, 0x24)[0]
            if pg[0] == 0 and pid == 0:
                continue                      # unallocated placeholder
            if fid != 1:
                continue                      # log or other file
            if pid in pages:
                print('duplicate page id', pid, 'at stream page', seen - 1)
                continue
            pages[pid] = pg
    if file_pages is None:
        file_pages = max(pages) + 1
    with open(out, 'wb') as f:
        f.truncate(file_pages * PAGE)
        for pid, pg in pages.items():
            if pid >= file_pages:
                print('page id out of range', pid)
                continue
            f.seek(pid * PAGE)
            f.write(pg)
    print('data start %#x, stream pages %d, real pages %d, file pages %d, bytes %d'
          % (base, seen, len(pages), file_pages, file_pages * PAGE))
    return base, pages


if __name__ == '__main__':
    extract(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else None)
