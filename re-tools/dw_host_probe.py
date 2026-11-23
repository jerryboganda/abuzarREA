import sys, os, ctypes, struct, faulthandler
faulthandler.enable()
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # needs pbd_lib.py next to it
from pbd_lib import entries, read_obj
APP = r'C:\Tools\dwhost\bin'
os.add_dll_directory(APP); os.chdir(APP)
k32 = ctypes.WinDLL('kernel32', use_last_error=True)
k32.LoadLibraryExW.restype = ctypes.c_void_p
k32.LoadLibraryExW.argtypes = [ctypes.c_wchar_p, ctypes.c_void_p, ctypes.c_uint32]
k32.GetProcAddress.restype = ctypes.c_void_p
k32.GetProcAddress.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
for dll in ('pbshr125.dll', 'PBVM125.dll', 'pbdwe125.dll'):
    h = k32.LoadLibraryExW(os.path.join(APP, dll), None, 8)
    if dll == 'pbdwe125.dll':
        dwe = h
def fn(name, restype, *argtypes):
    return ctypes.WINFUNCTYPE(restype, *argtypes)(k32.GetProcAddress(dwe, name.encode()))
V = ctypes.c_void_p
dwLoadMemory = fn('dwLoadMemory', V, V)
dwInfoBegin = fn('dwInfoBegin', None, V, V)
dwInfoEnd = fn('dwInfoEnd', None, V)
dwInfoGetFirstObject = fn('dwInfoGetFirstObject', V, V)
dwInfoGetNextObject = fn('dwInfoGetNextObject', V, V)
dwInfoGetObjectType = fn('dwInfoGetObjectType', ctypes.c_int, V, V)

def load(blob):
    buf = ctypes.create_string_buffer(blob, len(blob))
    return dwLoadMemory(ctypes.addressof(buf)), buf

d = open(r'C:\Projects\Abuzar\Application\useratten.pbd', 'rb').read()
e = [x for x in entries(d) if x['name'] == 'd_authenticationkey.dwo'][0]
dw, keep = load(read_obj(d, e))
print('dw', hex(dw or 0), flush=True)
info = ctypes.create_string_buffer(512)
dwInfoBegin(dw, ctypes.addressof(info))
print('info begun', flush=True)
o = dwInfoGetFirstObject(ctypes.addressof(info))
n = 0
while o and n < 100:
    t = dwInfoGetObjectType(ctypes.addressof(info), o)
    print('object', hex(o), 'type', t, flush=True)
    o = dwInfoGetNextObject(ctypes.addressof(info))
    n += 1
print('info words', [hex(x) for x in struct.unpack('<8I', info.raw[:32])], flush=True)
rd = lambda a, n=64: ctypes.string_at(a, n)
lst = struct.unpack('<8I', info.raw[:32])[4]
print('list4 head bytes', rd(lst, 32).hex(' ') if lst else None, flush=True)
