SET NOCOUNT ON;
IF OBJECT_ID('tempdb..#w') IS NOT NULL DROP TABLE #w;
CREATE TABLE #w (tbl sysname, col sysname, typ sysname, maxlen int, avg_len decimal(12,1), max_actual int, null_pct decimal(6,2), sample_rows int);

DECLARE @tbl sysname, @sum nvarchar(max), @cmd nvarchar(max);
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
  SELECT name FROM sys.tables WHERE is_ms_shipped=0
    AND name IN ('Item','SaleLedger','Saledetail','VirtualGl','StockReport','ItemLog','Purdetail','PurOrderDetail');
OPEN c; FETCH NEXT FROM c INTO @tbl;
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @sum = STUFF((SELECT '+ISNULL(DATALENGTH('+QUOTENAME(name)+'),0)' FROM sys.columns
                       WHERE object_id=OBJECT_ID(@tbl) FOR XML PATH('')),1,1,'');
  SET @cmd = 'INSERT #w(tbl,col,typ,maxlen,avg_len,max_actual,null_pct,sample_rows) SELECT '''+@tbl+''',''<ROW TOTAL>'','''','+CAST((SELECT SUM(max_length) FROM sys.columns WHERE object_id=OBJECT_ID(@tbl)) AS varchar(10))
    + ',AVG(CAST('+@sum+' AS decimal(12,1))),MAX('+@sum+'),0,COUNT(*) FROM (SELECT TOP 3000 * FROM '+QUOTENAME(@tbl)+') s;';
  EXEC sp_executesql @cmd;

  SELECT @cmd = '';
  SELECT @cmd = @cmd + 'INSERT #w(tbl,col,typ,maxlen,avg_len,max_actual,null_pct,sample_rows) SELECT '''
    + @tbl + ''',''' + c.name + ''',''' + ty.name + ''',' + CAST(c.max_length AS varchar(10))
    + ',AVG(CAST(DATALENGTH(' + QUOTENAME(c.name) + ') AS decimal(12,1))),MAX(DATALENGTH(' + QUOTENAME(c.name) + ')),'
    + '100.0*SUM(CASE WHEN ' + QUOTENAME(c.name) + ' IS NULL THEN 1 ELSE 0 END)/COUNT(*),COUNT(*)'
    + ' FROM (SELECT TOP 3000 ' + QUOTENAME(c.name) + ' FROM ' + QUOTENAME(@tbl) + ') s;'
  FROM sys.columns c JOIN sys.types ty ON ty.user_type_id=c.user_type_id
  WHERE c.object_id=OBJECT_ID(@tbl) AND (c.max_length>=20 OR ty.name IN ('text','ntext','image'));
  EXEC sp_executesql @cmd;
  FETCH NEXT FROM c INTO @tbl;
END
CLOSE c; DEALLOCATE c;

SELECT 'ROW_TOTALS' AS k;
SELECT tbl, avg_len AS avg_actual_row_bytes, max_actual AS max_row_bytes, sample_rows
FROM #w WHERE col='<ROW TOTAL>' ORDER BY avg_len DESC;

SELECT 'WIDE_COLS' AS k;
SELECT tbl, col, typ, maxlen, avg_len, max_actual, null_pct
FROM #w WHERE col<>'<ROW TOTAL>' AND avg_len>0
ORDER BY avg_len DESC;

SELECT 'DECLARED_VS_ACTUAL' AS k;
SELECT tbl, MAX(maxlen) AS declared_row_bytes, MAX(CASE WHEN col='<ROW TOTAL>' THEN avg_len END) AS avg_actual_row_bytes,
       CAST(MAX(CASE WHEN col='<ROW TOTAL>' THEN avg_len END)*100.0/NULLIF(MAX(maxlen),0) AS DECIMAL(5,1)) AS pct_used
FROM #w GROUP BY tbl;
