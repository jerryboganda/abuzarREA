SET NOCOUNT ON;
SELECT o.name, LEN(m.definition) AS chars,
       SUBSTRING(REPLACE(REPLACE(m.definition, CHAR(13), ' '), CHAR(10), ' '), 1, 900) AS head
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE o.name IN ('SP_SyncBasicData_On_Remote','SP_SyncTransactionData_OnRemote','SP_CRS_ClientDataTransfer','SP_Fetch_ChildServerSales','SP_TransferSaleInvoices')
ORDER BY o.name;

SELECT o.name, LEN(m.definition) AS chars
FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
WHERE m.definition LIKE '%DISTRIBUTED TRANSACTION%'
ORDER BY LEN(m.definition) DESC;
