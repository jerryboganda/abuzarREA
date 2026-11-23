import ctypes, ctypes.wintypes as w

user32 = ctypes.WinDLL("user32", use_last_error=True)
PID = 8796

EnumWindows = user32.EnumWindows
EnumWindowsProc = ctypes.WINFUNCTYPE(ctypes.c_bool, w.HWND, w.LPARAM)
GetWindowThreadProcessId = user32.GetWindowThreadProcessId
GetWindowRect = user32.GetWindowRect
GetClassNameW = user32.GetClassNameW
GetWindowTextW = user32.GetWindowTextW
IsWindowVisible = user32.IsWindowVisible
GetWindowLongW = user32.GetWindowLongW

rows = []
def cb(hwnd, lparam):
    pid = w.DWORD()
    GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
    if pid.value != PID:
        return True
    r = w.RECT()
    GetWindowRect(hwnd, ctypes.byref(r))
    cls = ctypes.create_unicode_buffer(256)
    GetClassNameW(hwnd, cls, 256)
    txt = ctypes.create_unicode_buffer(512)
    GetWindowTextW(hwnd, txt, 512)
    ex = GetWindowLongW(hwnd, -20)
    rows.append((hwnd, cls.value, txt.value, r.left, r.top, r.right - r.left, r.bottom - r.top,
                 bool(IsWindowVisible(hwnd)), hex(ex & 0xFFFFFFFF)))
    return True

EnumWindows(EnumWindowsProc(cb), 0)
print("hwnd       class                vis  x    y     w     h    exstyle    title")
for h, cls, txt, x, y, ww, hh, vis, ex in sorted(rows, key=lambda r: -r[5]):
    print(f"{h:10} {cls[:20]:20} {int(vis)} {x:5} {y:5} {ww:5} {hh:5} {ex:10} {txt[:60]}")
