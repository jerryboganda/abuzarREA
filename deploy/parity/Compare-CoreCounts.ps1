param(
    [string]$Mssql = '.\SQLEXPRESS2022',
    [string]$Pg = '127.0.0.1',
    [string]$PgDb = 'trader',
    [string]$PgUser = 'postgres',
    [string]$PgPassword = 'postgres'
)
$ErrorActionPreference = 'Stop'
$env:PGPASSWORD = $PgPassword
$ms = @"
SET NOCOUNT ON;
SELECT 'users' AS t, COUNT(*) AS n FROM dbo.Users
UNION ALL SELECT 'groups', COUNT(*) FROM dbo.Groups
UNION ALL SELECT 'rights', COUNT(*) FROM dbo.Rights
UNION ALL SELECT 'grouprights', COUNT(*) FROM dbo.GroupRights
UNION ALL SELECT 'item', COUNT(*) FROM dbo.Item
UNION ALL SELECT 'customer', COUNT(*) FROM dbo.Customer
UNION ALL SELECT 'saledger', COUNT(*) FROM dbo.SaleLedger
UNION ALL SELECT 'saledetail', COUNT(*) FROM dbo.SaleDetail
UNION ALL SELECT 'virtualgl', COUNT(*) FROM dbo.VirtualGl
UNION ALL SELECT 'stockreport', COUNT(*) FROM dbo.StockReport
UNION ALL SELECT 'stockledger', COUNT(*) FROM dbo.StockLedger;
SELECT 'saledger_total' AS t, SUM(InvTotal) AS n FROM dbo.SaleLedger;
SELECT 'saledetail_qty' AS t, SUM(LooseQty) AS n FROM dbo.SaleDetail;
SELECT 'virtualgl_debit' AS t, SUM(Debit) AS n FROM dbo.VirtualGl;
SELECT 'virtualgl_credit' AS t, SUM(Credit) AS n FROM dbo.VirtualGl;
SELECT 'stockreport_stock' AS t, SUM(Stock) AS n FROM dbo.StockReport;
SELECT 'stockledger_qty' AS t, SUM(Qty) AS n FROM dbo.StockLedger;
"@
$pgSql = @"
SET search_path TO dbo, public;
SELECT 'users' AS t, COUNT(*) AS n FROM dbo.users
UNION ALL SELECT 'groups', COUNT(*) FROM dbo.groups
UNION ALL SELECT 'rights', COUNT(*) FROM dbo.rights
UNION ALL SELECT 'grouprights', COUNT(*) FROM dbo.grouprights
UNION ALL SELECT 'item', COUNT(*) FROM dbo.item
UNION ALL SELECT 'customer', COUNT(*) FROM dbo.customer
UNION ALL SELECT 'saledger', COUNT(*) FROM dbo.saleledger
UNION ALL SELECT 'saledetail', COUNT(*) FROM dbo.saledetail
UNION ALL SELECT 'virtualgl', COUNT(*) FROM dbo.virtualgl
UNION ALL SELECT 'stockreport', COUNT(*) FROM dbo.stockreport
UNION ALL SELECT 'stockledger', COUNT(*) FROM dbo.stockledger;
SELECT 'saledger_total' AS t, SUM(invtotal) AS n FROM dbo.saleledger;
SELECT 'saledetail_qty' AS t, SUM(looseqty) AS n FROM dbo.saledetail;
SELECT 'virtualgl_debit' AS t, SUM(debit) AS n FROM dbo.virtualgl;
SELECT 'virtualgl_credit' AS t, SUM(credit) AS n FROM dbo.virtualgl;
SELECT 'stockreport_stock' AS t, SUM(stock) AS n FROM dbo.stockreport;
SELECT 'stockledger_qty' AS t, SUM(qty) AS n FROM dbo.stockledger;
"@
Write-Output '=== SQL Server ==='
$ms | sqlcmd -S $Mssql -E -C -d FazalDinPP19DataBaseV2 -W -s '|' -w 200
Write-Output '=== PostgreSQL ==='
$pgSql | & 'C:\PostgreSQL\17\bin\psql.exe' -h $Pg -U $PgUser -d $PgDb -At -F '|'

