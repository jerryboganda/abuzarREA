import re, struct
def entries(d):
    out=[]
    for m in re.finditer(rb'ENT\*0\x006\x000\x000\x00', d):
        o=m.start()
        try:
            ptr,size,ts=struct.unpack('<III', d[o+12:o+24])
            clen,nlen=struct.unpack('<HH', d[o+24:o+28])
            name=d[o+28+clen:o+28+clen+nlen] if False else d[o+28:o+28+nlen]
            name=name.decode('utf-16le','ignore').rstrip('\x00')
            if not name or ptr>len(d): continue
            out.append(dict(name=name,ptr=ptr,size=size,ts=ts,clen=clen))
        except Exception: pass
    return out
def read_obj(d, e):
    """follow DAT* chain: DAT* | next(4) | len(2) | data"""
    buf=b''; p=e['ptr']; guard=0
    while p and p+10<=len(d) and guard<100000:
        if d[p:p+4]!=b'DAT*': break
        nxt,ln=struct.unpack('<IH', d[p+4:p+10])
        buf+=d[p+10:p+10+ln]; p=nxt; guard+=1
    return buf
