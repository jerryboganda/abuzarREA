SET NOCOUNT ON; SET STATISTICS TIME ON;
DECLARE @i int=1,@v varchar(100);
WHILE @i<=10000 BEGIN SET @v=dbo.fn_GetPreference('roundsaleinvon'); SET @i+=1; END
SELECT @v;
