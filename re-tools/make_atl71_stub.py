"""Write a minimal 32-bit ATL71.DLL stub that only exports the five ordinals PBVM125/pbdwe125 import.

ATL71.DLL (Microsoft ATL 7.1 runtime) is not part of the repository. The PowerBuilder runtime DLLs only
need it to *load*; the functions behind these ordinals are used for ActiveX hosting, which we never call.
usage: python -I make_atl71_stub.py <out.dll>
"""
import struct, sys

ORDINALS = [40, 42, 48, 65, 66]
BASE = min(ORDINALS)
NFUNCS = max(ORDINALS) - BASE + 1
IMAGE_BASE = 0x6B000000
SECT_VA, SECT_RAW, FILE_ALIGN = 0x1000, 0x200, 0x200

code = bytearray(0x200)
code[0:8] = bytes.fromhex('B801000000C20C00')          # DllMain: mov eax,1 ; ret 0Ch
code[0x10:0x13] = bytes.fromhex('31C0C3')              # stub:    xor eax,eax ; ret
EXP_OFF = 0x100
STUB_RVA = SECT_VA + 0x10
name = b'ATL71.DLL\0'
name_rva = SECT_VA + EXP_OFF + 40 + NFUNCS * 4
exp = struct.pack('<IIHHIIIIIII', 0, 0, 0, 0, name_rva, BASE, NFUNCS, 0, SECT_VA + EXP_OFF + 40, 0, 0)
table = b''.join(struct.pack('<I', STUB_RVA if (BASE + i) in ORDINALS else 0) for i in range(NFUNCS))
blob = exp + table + name
code[EXP_OFF:EXP_OFF + len(blob)] = blob
exp_size = len(blob)

dos = bytearray(0x80)
dos[0:2] = b'MZ'
struct.pack_into('<I', dos, 0x3c, 0x80)
coff = struct.pack('<HHIIIHH', 0x14c, 1, 0, 0, 0, 224, 0x2103)   # i386, 1 section, DLL | stripped relocs
opt = bytearray(224)
struct.pack_into('<HBBIIIIIIIIIHHHHHHIIIIHHIIIIII', opt, 0,
                 0x10b, 7, 10, 0x200, 0, 0, SECT_VA, SECT_VA, SECT_VA + 0x1000, IMAGE_BASE, 0x1000, FILE_ALIGN,
                 4, 0, 0, 0, 4, 0, 0, 0x2000, 0x200, 0, 2, 0, 0x100000, 0x1000, 0x100000, 0x1000, 0, 16)
struct.pack_into('<II', opt, 96, SECT_VA + EXP_OFF, exp_size)       # export directory
sect = struct.pack('<8sIIIIIIHHI', b'.text', 0x1000, SECT_VA, 0x200, SECT_RAW, 0, 0, 0, 0, 0x60000060)
hdr = bytes(dos) + b'PE\0\0' + coff + bytes(opt) + sect
hdr = hdr.ljust(SECT_RAW, b'\0')
open(sys.argv[1], 'wb').write(hdr + bytes(code))
print('wrote', sys.argv[1], len(hdr + bytes(code)), 'bytes')
