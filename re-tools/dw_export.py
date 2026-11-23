"""Export DataWindow source syntax (.srd text) from compiled PBDs using the real DataWindow engine (pbdwe125.dll).

Must run under a 32-bit Python (the PowerBuilder runtime DLLs are 32-bit):
    C:\\Tools\\py32\\python.exe -I dw_export.py <pbd path> <out dir> [start_index]

DLL folder: C:\\Tools\\dwhost\\bin (copy of Application\\*.dll + the ATL71.DLL stand-in from make_atl71_stub.py).
Each exported DataWindow is written to <out dir>/<name>.srd; progress is appended to <out dir>/_progress.log
so a driver can restart after a native crash (see dw_export_all.py).
"""
import sys, os, ctypes, struct

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pbd_lib import entries

APP = r'C:\Tools\dwhost\bin'
os.add_dll_directory(APP)
os.chdir(APP)
k32 = ctypes.WinDLL('kernel32', use_last_error=True)
u32 = ctypes.WinDLL('user32', use_last_error=True)
k32.LoadLibraryExW.restype = ctypes.c_void_p
k32.LoadLibraryExW.argtypes = [ctypes.c_wchar_p, ctypes.c_void_p, ctypes.c_uint32]
k32.GetProcAddress.restype = ctypes.c_void_p
k32.GetProcAddress.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
for dll in ('pbshr125.dll', 'PBVM125.dll', 'pbdwe125.dll'):
    h = k32.LoadLibraryExW(os.path.join(APP, dll), None, 8)
    if dll == 'pbdwe125.dll':
        dwe = h
V = ctypes.c_void_p


def fn(name, restype, *argtypes):
    return ctypes.WINFUNCTYPE(restype, *argtypes)(k32.GetProcAddress(dwe, name.encode()))


dwLoadLibrary = fn('dwLoadLibrary', V, V, ctypes.c_int, ctypes.c_wchar_p, ctypes.c_int)
dwCreateWindow = fn('dwCreateWindow', V, V, ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int,
                    ctypes.c_int, V, V, V, V)
dwDescribe = fn('dwDescribe', V, V, ctypes.c_wchar_p)
ctypes.CFUNCTYPE(ctypes.c_int)(0x11501150)()          # register the engine's window classes

u32.CreateWindowExW.restype = V
u32.CreateWindowExW.argtypes = [ctypes.c_uint32, ctypes.c_wchar_p, ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_int,
                                ctypes.c_int, ctypes.c_int, ctypes.c_int, V, V, V, V]
u32.DestroyWindow.argtypes = [V]
parent = u32.CreateWindowExW(0, 'STATIC', 'host', 0x00C00000, 0, 0, 800, 600, None, None, None, None)


def export_one(pbd, name):
    path = ctypes.create_unicode_buffer(pbd)
    arr = (ctypes.c_void_p * 2)(ctypes.addressof(path), 0)
    dw = dwLoadLibrary(ctypes.addressof(arr), 1, name, 0)
    if not dw:
        return None, 'load failed'
    hw = dwCreateWindow(0, '', 0x40000000, 0, 0, 700, 500, parent, 1, 0, dw)
    if not hw:
        return None, 'create window failed'
    try:
        r = dwDescribe(hw, 'datawindow.syntax')
        return (ctypes.wstring_at(r) if r else None), ('' if r else 'describe returned null')
    finally:
        u32.DestroyWindow(hw)


def main(pbd, out, start=0):
    os.makedirs(out, exist_ok=True)
    data = open(pbd, 'rb').read()
    names = sorted({e['name'][:-4] for e in entries(data) if e['name'].lower().endswith('.dwo')})
    log = open(os.path.join(out, '_progress.log'), 'a', encoding='utf-8')
    for i, name in enumerate(names):
        if i < start:
            continue
        log.write('START\t%d\t%s\n' % (i, name))
        log.flush()
        try:
            text, err = export_one(pbd, name)
        except OSError as e:
            text, err = None, 'OSError %s' % e
        if text:
            with open(os.path.join(out, name + '.srd'), 'w', encoding='utf-8', newline='\n') as f:
                f.write(text)
            log.write('OK\t%d\t%s\t%d\n' % (i, name, len(text)))
        else:
            log.write('FAIL\t%d\t%s\t%s\n' % (i, name, err))
        log.flush()
    log.write('DONE\t%d\n' % len(names))
    log.close()


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 0)
