"""Read the system tables of a SQL Server 2000-format .mdf (internal version 539) without SQL Server.

SQL Server 2022/2025 cannot attach these files, so the catalog (sysobjects, syscolumns, syscomments,
sysindexes, sysreferences, systypes) is parsed straight from the 8 KB data pages.

usage as a module:  from mdf2000 import load_catalog
"""
import struct, collections

PAGE = 8192


def fix_torn(pg):
    """Undo torn-page-detection bits. The header word at 0x3C holds the pattern in bits 0-1 and the original
    low 2 bits of sectors 1..15 in bits 2..31; those sectors' last bytes carry the pattern instead."""
    torn = struct.unpack_from('<I', pg, 0x3c)[0]
    pattern = torn & 3
    if pattern == 0 or any((pg[s * 512 + 511] & 3) != pattern for s in range(1, 16)):
        return pg
    b = bytearray(pg)
    for s in range(1, 16):
        i = s * 512 + 511
        b[i] = (b[i] & ~3) | ((torn >> (2 * s)) & 3)
    return bytes(b)


def scan_system_pages(path, max_obj=100):
    """Return {object_id: [page bytes]} for level-0 data pages of system tables."""
    out = collections.defaultdict(list)
    with open(path, 'rb') as f:
        while True:
            blk = f.read(PAGE * 256)
            if not blk:
                break
            for i in range(0, len(blk) - PAGE + 1, PAGE):
                pg = blk[i:i + PAGE]
                if pg[1] != 1:
                    continue
                obj = struct.unpack_from('<I', pg, 0x18)[0]
                if obj <= max_obj and pg[3] == 0:
                    out[obj].append(fix_torn(pg))
    return out


def iter_rows(pg):
    n = struct.unpack_from('<H', pg, 0x16)[0]
    for i in range(n):
        off = struct.unpack_from('<H', pg, 8190 - 2 * i)[0]
        if 96 <= off < PAGE - 8:
            yield off


def parse_row(pg, off):
    """-> (fixed bytes, var field list) or None for ghost/forwarded/invalid records."""
    try:
        st = pg[off]
        if st & 0x0f:
            return None
        pmin = struct.unpack_from('<H', pg, off + 2)[0]
        fixed = pg[off + 4:off + pmin]
        ncols = struct.unpack_from('<H', pg, off + pmin)[0]
        p = off + pmin + 2 + (ncols + 7) // 8
        var = []
        if st & 0x20:
            nv = struct.unpack_from('<H', pg, p)[0]
            p += 2
            ends = [struct.unpack_from('<H', pg, p + 2 * k)[0] for k in range(nv)]
            p += 2 * nv
            pos = p
            for e in ends:
                e &= 0x7fff
                var.append(pg[pos:off + e])
                pos = off + e
        return fixed, var
    except Exception:
        return None


def table_rows(pages):
    for pg in pages:
        for off in iter_rows(pg):
            r = parse_row(pg, off)
            if r:
                yield r


def u16(b):
    return b.decode('utf-16le', 'replace')


XTYPES = {34: 'image', 35: 'text', 36: 'uniqueidentifier', 48: 'tinyint', 52: 'smallint', 56: 'int',
          58: 'smalldatetime', 59: 'real', 60: 'money', 61: 'datetime', 62: 'float', 98: 'sql_variant',
          99: 'ntext', 104: 'bit', 106: 'decimal', 108: 'numeric', 122: 'smallmoney', 127: 'bigint',
          165: 'varbinary', 167: 'varchar', 173: 'binary', 175: 'char', 189: 'timestamp',
          231: 'nvarchar', 239: 'nchar'}


def load_catalog(path):
    sp = scan_system_pages(path)
    cat = {}
    # sysobjects
    objs = {}
    for fixed, var in table_rows(sp[1]):
        if len(fixed) < 38 or not var:
            continue
        oid = struct.unpack_from('<I', fixed, 0)[0]
        objs[oid] = dict(id=oid, type=fixed[4:6].decode('latin1').strip(), uid=struct.unpack_from('<h', fixed, 6)[0],
                         status=struct.unpack_from('<i', fixed, 10)[0],
                         parent=struct.unpack_from('<I', fixed, 24)[0], name=u16(var[0]), fixed=fixed)
    cat['objects'] = objs
    # syscolumns
    cols = collections.defaultdict(list)
    for fixed, var in table_rows(sp[3]):
        if len(fixed) < 42 or not var:
            continue
        oid, xtype, typestat, xusertype, length, xprec, xscale, colid = struct.unpack_from('<IBBHhBBH', fixed, 0)
        colstat, cdefault = struct.unpack_from('<hI', fixed, 18)[0], struct.unpack_from('<I', fixed, 20)[0]
        cols[oid].append(dict(id=oid, name=u16(var[0]), xtype=xtype, xusertype=xusertype, length=length,
                              prec=xprec, scale=xscale, colid=colid, colstat=colstat, cdefault=cdefault,
                              fixed=fixed, var=var))
    for k in cols:
        cols[k].sort(key=lambda c: c['colid'])
    cat['columns'] = cols
    # systypes (user types)
    ut = {}
    for fixed, var in table_rows(sp[4]):
        if var and len(fixed) >= 6:
            ut[struct.unpack_from('<H', fixed, 4)[0]] = u16(var[0])
    cat['usertypes'] = ut
    # syscomments: concatenate chunks
    chunks = collections.defaultdict(list)
    for fixed, var in table_rows(sp[6]):
        if len(fixed) >= 10 and var:
            oid, number, colid, status = struct.unpack_from('<IHHH', fixed, 0)
            # status bit 2: text is stored single-byte (ANSI); otherwise UTF-16
            txt = var[-1].decode('cp1252', 'replace') if status & 2 else u16(var[-1])
            chunks[(oid, number)].append((colid, txt))
    cat['comments'] = {k: ''.join(t for _, t in sorted(v)) for k, v in chunks.items()}
    cat['sysindexes_rows'] = list(table_rows(sp[2]))
    cat['sysreferences_rows'] = list(table_rows(sp[14]))
    return cat
