import sys
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbvm_host import *
begin = export('pbshr125.dll','pbstg_begin_nofast',V,I)
pool = begin(0x2000)
err = ctypes.create_string_buffer(512)
mgr = export('PBVM125.dll','ob_mgr_init_ex',V,V,V,ctypes.c_wchar_p)(ctypes.addressof(err), pool, 'pbvm125.dll')
print('mgr',hex(mgr or 0), flush=True)
lst = export('PBVM125.dll','ob_get_objnames_of_class_in_lib',V,V,I,V,ctypes.c_wchar_p)
lib = r'C:\Projects\Abuzar\Application\useratten.pbd'
for kind in (0x4085, 0x4080, 0x40be, 0x4081, 0x4082, 0x4083, 0x4084, 0x4086, 0x4087):
    cnt = ctypes.c_int(0)
    r = lst(mgr, kind, ctypes.addressof(cnt), lib)
    names = []
    if r and cnt.value:
        for i in range(cnt.value):
            names.append(wstr(u32(r + 4*i)))
    print(hex(kind), 'count', cnt.value, names[:8], flush=True)
