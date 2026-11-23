"""Host the PowerBuilder runtime (PBVM125.dll + pbshr125.dll) in a 32-bit Python process.

Run with C:\\Tools\\py32\\python.exe. DLLs are loaded from C:\\Tools\\dwhost\\bin (copy of Application\\*.dll plus the
ATL71.DLL stand-in). Provides: dll handles, typed export lookup, and a vectored exception handler that prints where an
access violation happened (helps when calling undocumented functions).
"""
import sys, os, ctypes, struct

APP = r'C:\Tools\dwhost\bin'
os.add_dll_directory(APP)
os.chdir(APP)

# Run on a private, invisible desktop: any window or message box the PowerBuilder runtime creates (e.g. R0007 link
# errors) stays off the user's screen. Must happen before any DLL creates a window.
_u32 = ctypes.WinDLL('user32', use_last_error=True)
_u32.CreateDesktopW.restype = ctypes.c_void_p
_u32.CreateDesktopW.argtypes = [ctypes.c_wchar_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint32, ctypes.c_void_p]
_u32.SetThreadDesktop.argtypes = [ctypes.c_void_p]
HDESK = None
if os.environ.get('PBHOST_VISIBLE') != '1':
    HDESK = _u32.CreateDesktopW('pbhost_%d' % os.getpid(), None, None, 0, 0x10000000, None)
    if HDESK and not _u32.SetThreadDesktop(HDESK):
        HDESK = None
k32 = ctypes.WinDLL('kernel32', use_last_error=True)
k32.LoadLibraryExW.restype = ctypes.c_void_p
k32.LoadLibraryExW.argtypes = [ctypes.c_wchar_p, ctypes.c_void_p, ctypes.c_uint32]
k32.GetProcAddress.restype = ctypes.c_void_p
k32.GetProcAddress.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
k32.AddVectoredExceptionHandler.restype = ctypes.c_void_p

H = {}
for dll in ('pbshr125.dll', 'PBVM125.dll', 'pbdwe125.dll'):
    H[dll.lower()] = k32.LoadLibraryExW(os.path.join(APP, dll), None, 8)

V = ctypes.c_void_p
I = ctypes.c_int


def export(dll, name, restype, *argtypes, cc='stdcall'):
    a = k32.GetProcAddress(H[dll.lower()], name.encode())
    if not a:
        raise KeyError(name)
    proto = ctypes.WINFUNCTYPE if cc == 'stdcall' else ctypes.CFUNCTYPE
    return proto(restype, *argtypes)(a)


def at(addr, restype, *argtypes, cc='cdecl'):
    proto = ctypes.WINFUNCTYPE if cc == 'stdcall' else ctypes.CFUNCTYPE
    return proto(restype, *argtypes)(addr)


class _Rec(ctypes.Structure):
    _fields_ = [('code', ctypes.c_uint32), ('flags', ctypes.c_uint32), ('rec', V), ('addr', V), ('n', ctypes.c_uint32),
                ('info', ctypes.c_uint32 * 15)]


class _Ptrs(ctypes.Structure):
    _fields_ = [('rec', ctypes.POINTER(_Rec)), ('ctx', V)]


def _veh(p):
    ep = ctypes.cast(p, ctypes.POINTER(_Ptrs)).contents
    r = ep.rec.contents
    if r.code == 0xC0000005:
        c = ep.ctx
        g = lambda off: ctypes.c_uint32.from_address(c + off).value
        regs = {n: hex(g(o)) for n, o in (('eax', 0xb0), ('ebx', 0xa4), ('ecx', 0xac), ('edx', 0xa8), ('esi', 0xa0),
                                          ('edi', 0x9c), ('ebp', 0xb4), ('esp', 0xc4))}
        print('AV eip=%s rw=%d target=%s %s' % (hex(g(0xb8)), r.info[0], hex(r.info[1]), regs), flush=True)
        try:
            st = [ctypes.c_uint32.from_address(g(0xc4) + 4 * i).value for i in range(40)]
            print('  return-address candidates:', [hex(x) for x in st if 0x10b00000 <= x < 0x11000000 or 0x11500000 <= x < 0x11900000], flush=True)
        except Exception:
            pass
    return 0


_VEH = ctypes.WINFUNCTYPE(ctypes.c_long, V)(_veh)
k32.AddVectoredExceptionHandler(1, _VEH)


def mem(a, n):
    return ctypes.string_at(a, n)


def u32(a):
    return struct.unpack('<I', mem(a, 4))[0]


def u16(a):
    return struct.unpack('<H', mem(a, 2))[0]


def wstr(a, maxc=256):
    if not a:
        return None
    try:
        return ctypes.wstring_at(a, maxc).split('\0')[0]
    except Exception:
        # a fixed-length read that runs past the end of a mapped page fails although the string is short: read up to its terminator
        try:
            return ctypes.wstring_at(a)
        except Exception:
            return None
