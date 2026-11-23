import re, os
src=r"C:\Projects\Abuzar\recovered\datawindows\salereportsdet\d_dailysalesdetail.srd"
t=open(src,encoding='utf-8',errors='replace').read()
m=re.search(r'retrieve="(.*?)"\s*\r?\n', t, re.S)
sql=m.group(1)
sql=sql.replace(':ad_StartDate',"'2023-03-13'").replace(':ad_EndDate',"'2023-03-14'").replace(':ai_saletype','3')
sql=re.sub(r'dbo\.saleledger\.custcode IN \(SELECT C\.CustCode FROM Customer C WHERE C\.AreaCode IN \(:ai_areacode\)\)','1=1',sql)
out=r"C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales.sql"
open(out,'w',encoding='utf-8').write("SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\nGO\n"+sql+"\n")
# variant no udf
v2=sql.replace('dbo.fn_getSaleInvTotal(dbo.saleledger.saleinvcode)','0')
open(r"C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales_noudf.sql",'w',encoding='utf-8').write("SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\nGO\n"+v2+"\n")
# variant no correlated tax subquery (both branches): replace from "totalsalestax = (SELECT" to the matching "\n\t)" before FROM
v3=re.sub(r'totalsalestax = \(SELECT.*?\n\t\)', 'totalsalestax = 0', sql, flags=re.S)
open(r"C:\Projects\Abuzar\deploy\analysis\reports\bench_dailysales_notaxsub.sql",'w',encoding='utf-8').write("SET NOCOUNT ON;\nSET STATISTICS IO ON;\nSET STATISTICS TIME ON;\nGO\n"+v3+"\n")
print(len(sql), 'taxsub replaced', v3!=sql, 'noudf', v2!=sql)
