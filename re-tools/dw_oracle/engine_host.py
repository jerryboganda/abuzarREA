import sys, os, ctypes
APP = r'C:\Tools\dwhost\bin'
os.add_dll_directory(APP); os.chdir(APP)
k32 = ctypes.WinDLL('kernel32', use_last_error=True); u32 = ctypes.WinDLL('user32', use_last_error=True)
k32.LoadLibraryExW.restype = ctypes.c_void_p; k32.LoadLibraryExW.argtypes = [ctypes.c_wchar_p, ctypes.c_void_p, ctypes.c_uint32]
k32.GetProcAddress.restype = ctypes.c_void_p; k32.GetProcAddress.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
for dll in ('pbshr125.dll', 'PBVM125.dll', 'pbdwe125.dll'):
    h = k32.LoadLibraryExW(os.path.join(APP, dll), None, 8)
    if dll == 'pbdwe125.dll': dwe = h
V = ctypes.c_void_p
def fn(name, restype, *argtypes):
    a = k32.GetProcAddress(dwe, name.encode()); return ctypes.WINFUNCTYPE(restype, *argtypes)(a) if a else None
dwLoadLibrary = fn('dwLoadLibrary', V, V, ctypes.c_int, ctypes.c_wchar_p, ctypes.c_int)
dwCreateWindow = fn('dwCreateWindow', V, V, ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, V, V, V, V)
dwDescribe = fn('dwDescribe', V, V, ctypes.c_wchar_p)
ctypes.CFUNCTYPE(ctypes.c_int)(0x11501150)()
u32.CreateWindowExW.restype = V
u32.CreateWindowExW.argtypes = [ctypes.c_uint32, ctypes.c_wchar_p, ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, V, V, V, V]
parent = u32.CreateWindowExW(0, 'STATIC', 'host', 0x00C00000, 0, 0, 800, 600, None, None, None, None)
pbd = sys.argv[1]; name = sys.argv[2]
path = ctypes.create_unicode_buffer(pbd); arr = (ctypes.c_void_p * 2)(ctypes.addressof(path), 0)
dw = dwLoadLibrary(ctypes.addressof(arr), 1, name, 0)
hw = dwCreateWindow(0, '', 0x40000000, 0, 0, 1500, 500, parent, 1, 0, dw)
def d(p):
    r = dwDescribe(hw, p); return ctypes.wstring_at(r) if r else None
import json
exprs = json.load(open(sys.argv[3]))
out = open(sys.argv[4], 'a', encoding='utf-8')
start = int(sys.argv[5])
NL = chr(10)
for i in range(start, len(exprs)):
    out.write(json.dumps({'i': i, 'r': '<PENDING>'}) + NL); out.flush()
    r = d(exprs[i])
    out.write(json.dumps({'i': i, 'r': r}) + NL); out.flush()
