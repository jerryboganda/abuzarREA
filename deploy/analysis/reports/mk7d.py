import re
for src,dst,nd in [
 (r'C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales.sql', r'C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales_7d.sql','2023-03-13'),
 (r'C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales_noudf.sql', r'C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales_7d_noudf.sql','2023-03-13')]:
    t=open(src,encoding='utf-8').read()
    t=t.replace("'2023-03-14'","'2023-03-20'")
    open(dst,'w',encoding='utf-8').write(t)
print('ok')
