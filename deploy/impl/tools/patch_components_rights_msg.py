import sys,struct,shutil
sys.path.insert(0,r"C:\Projects\Abuzar\re-tools")
import pbd_lib
src=r"C:\Projects\Abuzar\Application\components.pbd"
out=sys.argv[1]
d=bytearray(open(src,"rb").read())
e=[x for x in pbd_lib.entries(d) if x["name"]=="w_multi_entry.win"][0]
chunks=[]; p=e["ptr"]; pos=0; buf=bytearray()
while p and d[p:p+4]==b"DAT*":
    nxt,ln=struct.unpack("<IH",d[p+4:p+10]); chunks.append((pos,p+10,ln)); buf+=d[p+10:p+10+ln]; pos+=ln; p=nxt
print("object bytes",len(buf),"chunks",len(chunks),"entry size",e["size"])
pat=struct.pack("<8H",30,3,52,0,0,200,3,188)
hits=[i for i in range(len(buf)-len(pat)) if buf[i:i+len(pat)]==pat]
print("pattern hits",hits)
assert len(hits)==1
i=hits[0]; start=i-30   # PUSH_LOCAL_VAR at word 15 of the routine
w=lambda wordidx: struct.unpack_from("<H",buf,start+2*wordidx)[0]
assert w(0)==285 and w(2)==30, (w(0),w(2))          # PUSH_LOCAL_VAR_LV, PUSH_LOCAL_VAR
assert w(53)==59, w(53)                              # PUSH_CONST_STRING: start of the messagebox block
assert (w(94),w(95),w(96))==(52,65534,65535), (w(94),w(95),w(96))  # return -2
assert w(22)==188 and w(21)==3
print("routine start byte",start,"; word22=188 -> will become 106 (word 53)")
# map the operand (buf offset start+44) to file offsets and patch byte by byte
new=struct.pack("<H",106); old=struct.pack("<H",188)
off=start+44
for k in range(2):
    b=off+k
    for (cpos,fpos,ln) in chunks:
        if cpos<=b<cpos+ln:
            fo=fpos+(b-cpos); assert d[fo]==old[k],(fo,d[fo],old[k]); d[fo]=new[k]; print("file offset",fo,hex(old[k]),"->",hex(new[k])); break
    else: raise SystemExit("unmapped")
open(out,"wb").write(d)
print("wrote",out,len(d))
