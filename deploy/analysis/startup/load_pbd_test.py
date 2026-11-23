import sys, ctypes, os, time, glob
sys.path.insert(0,'C:/Projects/Abuzar/re-tools')
from pbvm_host import *
begin = export('pbshr125.dll','pbstg_begin_nofast',V,I)
pool = begin(0x2000)
err = ctypes.create_string_buffer(512)
mgr = export('PBVM125.dll','ob_mgr_init_ex',V,V,V,ctypes.c_wchar_p)(ctypes.addressof(err), pool, 'pbvm125.dll')
print('mgr',hex(mgr or 0), flush=True)
lst = export('PBVM125.dll','ob_get_objnames_of_class_in_lib',V,V,I,V,ctypes.c_wchar_p)
libs = sorted(glob.glob(r'C:\Projects\Abuzar\deploy\Application\*.pbd'))
kinds=(0x4085,0x4080,0x40be,0x4081,0x4082,0x4083,0x4084,0x4086,0x4087)
t0=time.time(); total=0
for lib in libs[:20]:
    n=0
    for kind in kinds:
        cnt=ctypes.c_int(0); r=lst(mgr,kind,ctypes.addressof(cnt),lib)
        if r and cnt.value: n+=cnt.value
    total+=n
    print(os.path.basename(lib), n, round(time.time()-t0,2), flush=True)
print('TOTAL objs',total,'secs',round(time.time()-t0,2), flush=True)
