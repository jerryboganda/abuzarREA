SET NOCOUNT ON;
SELECT 'rows_returned' k, COUNT(*) v FROM (SELECT A.AccCode FROM VirtualGl V, Accounts A, SubAccounts S WHERE V.AccCode=A.AccCode AND A.SubCode=S.SubAccCode AND S.SubAccCode=3 GROUP BY A.AccCode,A.Name) x;
