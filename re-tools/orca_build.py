"""Drive PowerBuilder's build API (ORCA, PBORC.DLL of the free PowerBuilder Utilities) and keep every compiler message.

32-bit Python only (PBORC.DLL is 32-bit), absolute paths:
    C:\\Tools\\py32\\python.exe -I re-tools/orca_build.py rebuild  C:/Projects/Abuzar/pbsrc/abuzar.pbt  out.json [full|incremental|3pass]
    C:\\Tools\\py32\\python.exe -I re-tools/orca_build.py import   <target.pbt> out.json <library.pbl> <file.sr?> [...]
    C:\\Tools\\py32\\python.exe -I re-tools/orca_build.py export   <target.pbt> out.json <library.pbl> <entry> <type>
    C:\\Tools\\py32\\python.exe -I re-tools/orca_build.py exe      <target.pbt> out.json <exe path>

OrcaScript runs the same API but prints no compiler messages; here the error callback records them:
    {"rc": n, "error": "...", "messages": [{"level", "number", "text", "line", "column"}, ...]}
"""
import ctypes
import json
import os
import re
import sys
from ctypes import wintypes

UTIL = r'C:\Program Files (x86)\Appeon\PowerBuilderUtilities 22.0'
RUNTIME = r'C:\Program Files (x86)\Appeon\Common\PowerBuilder\Runtime 22.0.0.1878'
TYPES = {'sra': 0, 'srd': 1, 'srf': 2, 'srm': 3, 'srq': 4, 'srs': 5, 'sru': 6, 'srw': 7, 'srp': 8, 'srj': 9, 'srx': 10, 'bin': 11}
REBUILD = {'full': 0, 'incremental': 1, 'migrate': 2, '3pass': 3}


class COMPERR(ctypes.Structure):
    _fields_ = [('iLevel', ctypes.c_int), ('lpszMessageNumber', ctypes.c_wchar_p), ('lpszMessageText', ctypes.c_wchar_p),
                ('iColumnNumber', ctypes.c_uint), ('iLineNumber', ctypes.c_uint)]


class LINKERR(ctypes.Structure):
    _fields_ = [('lpszMessageText', ctypes.c_wchar_p)]


class CONFIG(ctypes.Structure):
    _fields_ = [('eClobber', ctypes.c_int), ('eExportEncoding', ctypes.c_int), ('bExportHeaders', wintypes.BOOL),
                ('bExportIncludeBinary', wintypes.BOOL), ('bExportCreateFile', wintypes.BOOL),
                ('pExportDirectory', ctypes.c_wchar_p), ('eImportEncoding', ctypes.c_int), ('bDebug', wintypes.BOOL),
                ('filler2', ctypes.c_void_p), ('filler3', ctypes.c_void_p), ('filler4', ctypes.c_void_p)]


ERRPROC = ctypes.WINFUNCTYPE(None, ctypes.POINTER(COMPERR), ctypes.c_void_p)
LNKPROC = ctypes.WINFUNCTYPE(None, ctypes.POINTER(LINKERR), ctypes.c_void_p)


class Orca:
    def __init__(self, target):
        os.environ['PATH'] = UTIL + ';' + RUNTIME + ';' + os.environ['PATH']
        for d in (UTIL, RUNTIME):
            if hasattr(os, 'add_dll_directory'):
                os.add_dll_directory(d)
        self.dll = ctypes.WinDLL(os.path.join(UTIL, 'PBORC.DLL'))
        self.dll.PBORCA_SessionOpen.restype = ctypes.c_void_p
        self.h = ctypes.c_void_p(self.dll.PBORCA_SessionOpen())
        self.messages = []
        self.errproc = ERRPROC(self._on_error)
        self.lnkproc = LNKPROC(self._on_link)
        text = open(target, encoding='utf-8-sig').read()
        folder = os.path.dirname(os.path.abspath(target))
        self.appname = re.search(r'appname "([^"]+)"', text).group(1)
        self.applib = os.path.join(folder, re.search(r'applib "([^"]+)"', text).group(1))
        self.libs = [os.path.join(folder, x) for x in re.search(r'(?i)liblist "([^"]+)"', text).group(1).split(';') if x]
        arr = (ctypes.c_wchar_p * len(self.libs))(*self.libs)
        self.check(self.dll.PBORCA_SessionSetLibraryList(self.h, arr, len(self.libs)), 'set library list')
        self.check(self.dll.PBORCA_SessionSetCurrentAppl(self.h, ctypes.c_wchar_p(self.applib), ctypes.c_wchar_p(self.appname)),
                   'set application')

    def _on_error(self, p, _):
        e = p.contents
        self.messages.append({'level': e.iLevel, 'number': e.lpszMessageNumber, 'text': e.lpszMessageText,
                              'line': e.iLineNumber, 'column': e.iColumnNumber})
        if STREAM:
            # a long rebuild may be stopped from outside: every message is on disk as soon as it arrives
            STREAM.write(json.dumps(self.messages[-1], ensure_ascii=False) + '\n')
            STREAM.flush()

    def _on_link(self, p, _):
        self.messages.append({'level': -1, 'text': p.contents.lpszMessageText})

    def error(self):
        buf = ctypes.create_unicode_buffer(2048)
        self.dll.PBORCA_SessionGetError(self.h, buf, 2048)
        return buf.value

    def check(self, rc, what):
        if rc:
            raise RuntimeError('%s: rc %d %s' % (what, rc, self.error()))

    def configure(self, include_binary=True, encoding=1):
        # export as UTF-8 text; import buffers are UTF-16 (PBORCA_UNICODE = 0), which is what import_file / import_list pass
        c = CONFIG(1, encoding, True, include_binary, False, None, 0, False, None, None, None)
        return self.dll.PBORCA_ConfigureSession(self.h, ctypes.byref(c))

    def rebuild(self, kind):
        return self.dll.PBORCA_ApplicationRebuild(self.h, REBUILD[kind], self.errproc, None)

    def import_file(self, library, path):
        name, ext = os.path.splitext(os.path.basename(path))
        raw = open(path, 'rb').read()
        text = raw.decode('utf-8-sig')
        buf = ctypes.create_unicode_buffer(text)
        return self.dll.PBORCA_CompileEntryImport(self.h, ctypes.c_wchar_p(library), ctypes.c_wchar_p(name), TYPES[ext[1:].lower()],
                                                  ctypes.c_wchar_p(''), buf, ctypes.sizeof(buf) - 2, self.errproc, None)

    def import_list(self, files):
        """[(library path, source file)]: one call, so objects that need each other are compiled together"""
        n = len(files)
        libs = (ctypes.c_wchar_p * n)()
        names = (ctypes.c_wchar_p * n)()
        kinds = (ctypes.c_int * n)()
        comments = (ctypes.c_wchar_p * n)()
        sources = (ctypes.c_wchar_p * n)()
        sizes = (ctypes.c_long * n)()
        keep = []
        self.binaries = []
        for i, (lib, path) in enumerate(files):
            name, ext = os.path.splitext(os.path.basename(path))
            text = open(path, 'rb').read().decode('utf-8-sig')
            # the binary component (OLE control data) is a separate entry for this API: import it after the source
            cut = text.find('Start of PowerBuilder Binary Data Section')
            if cut >= 0:
                self.binaries.append((lib, name, text[cut:]))
                text = text[:cut].rstrip('\r\n') + '\r\n'
            buf = ctypes.create_unicode_buffer(text)
            keep.append(buf)
            libs[i], names[i], kinds[i], comments[i] = lib, name, TYPES[ext[1:].lower()], ''
            sources[i] = ctypes.cast(buf, ctypes.c_wchar_p)
            sizes[i] = ctypes.sizeof(buf) - 2
        return self.dll.PBORCA_CompileEntryImportList(self.h, libs, names, kinds, comments, sources, sizes, n, self.errproc, None)

    def export(self, library, entry, kind, size=8000000):
        buf = ctypes.create_string_buffer(size)
        got = ctypes.c_long(0)
        rc = self.dll.PBORCA_LibraryEntryExportEx(self.h, ctypes.c_wchar_p(library), ctypes.c_wchar_p(entry), int(kind), buf, size,
                                                  ctypes.byref(got))
        return rc, buf.raw[:max(got.value, 0)]

    def executable(self, exe):
        # every library becomes a PBD, the application library too (the vendor's layout: abuzar.exe + abuzarapp.pbd).
        # Linked into the EXE, a picture the build machine does not have (`yourlogo.bmp` of w_bkg, a file a shop may add)
        # stops the link; in a PBD it is only left to be loaded from the folder at run time
        flags = (ctypes.c_int * len(self.libs))(*([1] * len(self.libs)))
        # both calls take a last argument `pbcPara` since PowerBuilder 2019 (deployment options, none here); without it
        # the call reads past its arguments (access violation)
        for lib in self.libs:
            rc = self.dll.PBORCA_DynamicLibraryCreate(self.h, ctypes.c_wchar_p(lib), ctypes.c_wchar_p(''), ctypes.c_long(0),
                                                      ctypes.c_void_p(None))
            if rc:
                self.messages.append({'level': -2, 'text': 'PBD %s: rc %d %s' % (os.path.basename(lib), rc, self.error())})
        if os.path.exists(exe):
            os.remove(exe)                             # an existing file makes the link fail ("Create of executable file failed")
        return self.dll.PBORCA_ExecutableCreate(self.h, ctypes.c_wchar_p(exe), ctypes.c_wchar_p(''), ctypes.c_wchar_p(''),
                                                self.lnkproc, None, flags, len(self.libs), ctypes.c_long(0),
                                                ctypes.c_void_p(None))

    def close(self):
        self.dll.PBORCA_SessionClose(self.h)


STREAM = None


def main(argv):
    global STREAM
    mode, target, out = argv[0], argv[1], argv[2]
    res = {'mode': mode}
    STREAM = open(out + 'l', 'w', encoding='utf-8')          # <out>.jsonl: the messages as they arrive
    try:
        o = Orca(target)
        if mode == 'rebuild':
            res['rc'] = o.rebuild(argv[3] if len(argv) > 3 else 'full')
        elif mode == 'import':
            o.configure(True, 1)
            res['files'] = []
            for path in argv[4:]:
                before = len(o.messages)
                rc = o.import_file(argv[3], path)
                res['files'].append({'file': os.path.basename(path), 'rc': rc, 'messages': o.messages[before:],
                                     'error': o.error() if rc else ''})
            res['rc'] = max([f['rc'] for f in res['files']] or [0], key=abs)
        elif mode == 'importeach':
            # importeach <target> out.json <ws_objects folder>: one import per object whose source changed since the last
            # run (manifest imported.json next to the target).  A failing import still stores the source; the rebuild that
            # follows gives the authoritative error list.
            import hashlib
            o.configure(True, 1)
            folder = os.path.dirname(os.path.abspath(target))
            manifest_path = os.path.join(folder, 'imported.json')
            manifest = json.load(open(manifest_path, encoding='utf-8')) if os.path.exists(manifest_path) else {}
            order = ['srs', 'sra', 'sru', 'srf', 'srm', 'srw', 'srq', 'srp', 'srd']
            todo = []
            for src in sorted(os.listdir(argv[3])):
                for f in sorted(os.listdir(os.path.join(argv[3], src))):
                    path = os.path.join(argv[3], src, f)
                    digest = hashlib.sha1(open(path, 'rb').read()).hexdigest()
                    key = src + '/' + f
                    if manifest.get(key) != digest and (f.rsplit('.', 1)[-1] != 'srd' or key in manifest or len(argv) > 4):
                        todo.append((order.index(f.rsplit('.', 1)[-1]), os.path.join(folder, src[:-len('.src')]), path, key, digest))
            todo.sort()
            # an object whose source is gone (removed from the product) leaves the library as well
            res['deleted'] = []
            for key in sorted(manifest):
                src, f = key.split('/', 1)
                if not os.path.exists(os.path.join(argv[3], src, f)):
                    name, ext = os.path.splitext(f)
                    rc = o.dll.PBORCA_LibraryEntryDelete(o.h, ctypes.c_wchar_p(os.path.join(folder, src[:-len('.src')])),
                                                         ctypes.c_wchar_p(name), TYPES[ext[1:].lower()])
                    res['deleted'].append([key, rc])
                    del manifest[key]
            res['count'], res['failed'], res['binaries'] = len(todo), 0, []
            for _, lib, path, key, digest in todo:
                name, ext = os.path.splitext(os.path.basename(path))
                text = open(path, 'rb').read().decode('utf-8-sig')
                cut = text.find('Start of PowerBuilder Binary Data Section')
                binary = text[cut:] if cut >= 0 else None
                if cut >= 0:
                    text = text[:cut].rstrip('\r\n') + '\r\n'
                buf = ctypes.create_unicode_buffer(text)
                rc = o.dll.PBORCA_CompileEntryImport(o.h, ctypes.c_wchar_p(lib), ctypes.c_wchar_p(name), TYPES[ext[1:].lower()],
                                                     ctypes.c_wchar_p(''), buf, ctypes.sizeof(buf) - 2, o.errproc, None)
                res['failed'] += bool(rc)
                if binary:
                    b = ctypes.create_unicode_buffer(binary)
                    brc = o.dll.PBORCA_CompileEntryImport(o.h, ctypes.c_wchar_p(lib), ctypes.c_wchar_p(name), 11, ctypes.c_wchar_p(''),
                                                          b, ctypes.sizeof(b) - 2, o.errproc, None)
                    res['binaries'].append([name, brc])
                manifest[key] = digest
            json.dump(manifest, open(manifest_path, 'w', encoding='utf-8'))
            res['rc'] = 0
        elif mode == 'importlist':
            # importlist <target> out.json <ws_objects folder> [extensions, default every type but srd]
            o.configure(True, 1)
            folder = os.path.dirname(os.path.abspath(target))
            exts = set(argv[4].split(',')) if len(argv) > 4 else {'sra', 'srs', 'srf', 'sru', 'srm', 'srw'}
            order = ['srs', 'sra', 'sru', 'srf', 'srm', 'srw', 'srq', 'srp', 'srd']
            files = []
            for src in sorted(os.listdir(argv[3])):
                lib = os.path.join(folder, src[:-len('.src')])
                for f in sorted(os.listdir(os.path.join(argv[3], src))):
                    if f.rsplit('.', 1)[-1] in exts:
                        files.append((lib, os.path.join(argv[3], src, f)))
            files.sort(key=lambda x: order.index(x[1].rsplit('.', 1)[-1]))
            res['count'] = len(files)
            res['rc'] = o.import_list(files)
            res['binaries'] = []
            for lib, name, text in o.binaries:
                buf = ctypes.create_unicode_buffer(text)
                rc = o.dll.PBORCA_CompileEntryImport(o.h, ctypes.c_wchar_p(lib), ctypes.c_wchar_p(name), 11, ctypes.c_wchar_p(''),
                                                     buf, ctypes.sizeof(buf) - 2, o.errproc, None)
                res['binaries'].append([name, rc, o.error() if rc else ''])
        elif mode == 'export':
            o.configure(True, 1)
            rc, data = o.export(argv[3], argv[4], argv[5])
            res['rc'] = rc
            res['text'] = data.decode('utf-8', 'replace')
        elif mode == 'exe':
            res['rc'] = o.executable(argv[3])
        res['error'] = o.error() if res.get('rc') else ''
        res['messages'] = o.messages
        o.close()
    except Exception as e:
        res['exception'] = '%s: %s' % (type(e).__name__, e)
    json.dump(res, open(out, 'w', encoding='utf-8'), indent=1)
    print(mode, 'rc', res.get('rc'), res.get('exception', ''), 'messages', len(res.get('messages', [])))


if __name__ == '__main__':
    main(sys.argv[1:])
