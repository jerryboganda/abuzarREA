"""Export the complete item tree of every menu: inherited items AND the items a descendant menu adds to inherited submenus.

32-bit Python only:  C:\\Tools\\py32\\python.exe -I menu_export.py <library.pbd> <out dir>
The normal object export (obj_export / pcode_export) only follows fields with attribute 0x8c (items declared by the menu itself), so
`m_single_entry.m_file.m_save` (declared in the inherited submenu m_file and added by the descendant) was missing.
Fields of a menu / item class that have a class type are items: 0x8c = declared here, 0x9c = inherited (the class is overridden when
the descendant adds items below it).  Output: <out>/<menu>.json  {name, ancestor, items:[{name, own, items:[...]}]}
"""
import sys, os, json, struct, ctypes

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import obj_export as O
from pbvm_host import *


def items(ref, gid, depth=0):
    """children of a menu / menu-item class, in table order"""
    if depth > 12:
        return []
    n = ctypes.c_int(0)
    rec = O.finfo(O.mgr, ref, ctypes.addressof(n))
    out = []
    if not rec:
        return out
    for i in range(n.value):
        b = mem(rec + 0x4a * i, 0x4a)
        dt = struct.unpack_from('<H', b, 8)[0]
        attr = b[0x22]
        if (dt & 0x8000) and attr in (0x8c, 0x9c):
            cref = ((dt << 16) | gid) & 0xffffffff
            out.append({'name': wstr(struct.unpack_from('<I', b, 2)[0], 128), 'own': attr == 0x8c, 'class': O.class_name(cref),
                        'ancestor': O.parent_name(cref), 'items': items(cref, gid, depth + 1)})
    return out


def main(lib, out):
    os.makedirs(out, exist_ok=True)
    cnt = ctypes.c_int(0)
    r = O.list_objs(O.mgr, 0x40af, ctypes.addressof(cnt), lib)
    n = 0
    for i in range(cnt.value):
        name = wstr(u32(r + 4 * i))
        try:
            g = O.gref(O.mgr, 0, name, 0x40af) & 0xffff
            ref = O.cref(O.mgr, g, name)
            tree = {'name': name, 'ancestor': O.parent_name(ref), 'library': os.path.basename(lib), 'items': items(ref, g)}
            json.dump(tree, open(os.path.join(out, name + '.json'), 'w', encoding='utf-8', errors='replace'), ensure_ascii=False)
            n += 1
        except Exception as e:  # keep going: one broken menu must not stop the export
            open(os.path.join(out, '_errors.log'), 'a', encoding='utf-8').write('%s\t%s\n' % (name, e))
    print(os.path.basename(lib), n, 'menus')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
