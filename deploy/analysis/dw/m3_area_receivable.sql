SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT Area=Area.Name, AreaCode=Area.AreaCode, Sum(Debit - Credit) AS balance FROM VirtualGL V, Accounts A, SubAccounts S, Customer C, Area WHERE V.AccCode = A.AccCode AND A.SubCode = S.SubAccCode AND S.SubAccCode = 3 AND A.AccCode = C.CustCode AND C.AreaCode = Area.AreaCode GROUP BY Area.Name, Area.AreaCode ORDER BY Area.Name, Area.AreaCode;
