import re
def get(path):
    t=open(path,encoding='utf-8',errors='replace').read()
    return re.search(r'retrieve="(.*?)"\s*\r?\n',t,re.S).group(1)
# stock in hand
s=get(r'C:\Projects\Abuzar\recovered\datawindows\stockreports\d_stockinhand.srd')
s=s.replace(':manfcode','SELECT ManfCode FROM Manufacturer').replace(':ai_pricetype','1')
open(r'C:\Projects\Abuzar\deploy\analysis\reports\bench_stockinhand.sql','w',encoding='utf-8').write("SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;\nGO\n"+s+"\n")
# stock backdate: params ad_date, as_allgodown, ai_gcode, as_reporttype, ai_code, ai_pricetype
b=get(r'C:\Projects\Abuzar\recovered\datawindows\stockreports\d_stockinbackdate.srd')
b=b.replace(':ad_date',"'2024-12-31'").replace(':as_allgodown',"'Y'").replace(':ai_GCode','1').replace(':as_ReportType',"'M'").replace(':ai_pricetype','1')
b=b.replace(':ai_code','SELECT ManfCode FROM Manufacturer')
open(r'C:\Projects\Abuzar\deploy\analysis\reports\bench_stockbackdate.sql','w',encoding='utf-8').write("SET NOCOUNT ON; SET STATISTICS IO ON; SET STATISTICS TIME ON;\nGO\n"+b+"\n")
print('ok',len(s),len(b))
