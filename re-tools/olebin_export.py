"""Export the binary component (OLE / ActiveX control data) of every object that has one, as the text PowerBuilder writes
at the end of an exported object ("Start of PowerBuilder Binary Data Section ...").

32-bit Python only, absolute paths:
    C:\\Tools\\py32\\python.exe -I re-tools/olebin_export.py C:/Projects/Abuzar/Application C:/Projects/Abuzar/recovered/olebin

The compiled libraries keep this data as `<object>.bin` entries.  PowerBuilder's build API (ORCA, PBORC.DLL of the free
PowerBuilder Utilities) exports such an entry from the original .pbd in the exact source syntax, checksums included, so
nothing has to be re-encoded here.  Output: <out>/<object>.txt.
"""
import ctypes
import glob
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import orca_build as B
import pbd_lib as P


def main(app, out):
    os.makedirs(out, exist_ok=True)
    os.environ['PATH'] = B.UTIL + ';' + B.RUNTIME + ';' + os.environ['PATH']
    for d in (B.UTIL, B.RUNTIME):
        os.add_dll_directory(d)
    dll = ctypes.WinDLL(os.path.join(B.UTIL, 'PBORC.DLL'))
    dll.PBORCA_SessionOpen.restype = ctypes.c_void_p
    h = ctypes.c_void_p(dll.PBORCA_SessionOpen())
    c = B.CONFIG(1, 1, True, True, False, None, 1, False, None, None, None)
    dll.PBORCA_ConfigureSession(h, ctypes.byref(c))
    done, failed = 0, []
    for lib in sorted(glob.glob(os.path.join(app, '*.pbd'))):
        for e in P.entries(open(lib, 'rb').read()):
            if not e['name'].lower().endswith('.bin'):
                continue
            name = e['name'][:-4]
            buf = ctypes.create_string_buffer(8000000)
            got = ctypes.c_long(0)
            rc = dll.PBORCA_LibraryEntryExportEx(h, ctypes.c_wchar_p(os.path.abspath(lib)), ctypes.c_wchar_p(name), 11, buf,
                                                 8000000, ctypes.byref(got))
            if rc:
                failed.append([os.path.basename(lib), name, rc])
                continue
            text = buf.raw[:got.value].decode('utf-8', 'replace')
            with open(os.path.join(out, name.lower() + '.txt'), 'w', encoding='utf-8', newline='') as f:
                f.write(text)
            done += 1
    dll.PBORCA_SessionClose(h)
    print('binary sections exported', done, 'failed', failed)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
