CREATE PROCEDURE DBO.SP_CleanUp_Bad_Session @DBName VARCHAR(100)
AS
DELETE Tempdb.dbo.sysisolaation 
WHERE ID IN 
	(SELECT ID
	FROM
		(SELECT ID=S.ID, DatabaseName=S.sys, ComputerName=S.CN, Connection=S.CC, 
			Program=(SELECT MIN(P.Program_Name) FROM master.dbo.sysprocesses P, master.dbo.sysdatabases D WHERE D.Name = @DBName AND P.DBID=D.DBID AND Lower(P.Program_Name) = 'waseela (' + LTRIM(RTRIM(STR(S.ID))) +')'), 
			StartedOn=(SELECT MIN(P.Login_Time) FROM master.dbo.sysprocesses P, master.dbo.sysdatabases D WHERE D.Name = @DBName AND P.DBID=D.DBID AND Lower(P.Program_Name) = 'waseela (' + LTRIM(RTRIM(STR(S.ID))) +')'), 
			DomainName=(SELECT MIN(P.NT_Domain) FROM master.dbo.sysprocesses P, master.dbo.sysdatabases D WHERE D.Name = @DBName AND P.DBID=D.DBID AND Lower(P.Program_Name) = 'waseela (' + LTRIM(RTRIM(STR(S.ID))) +')'), 
			OSUserName=(SELECT MIN(P.NT_UserName) FROM master.dbo.sysprocesses P, master.dbo.sysdatabases D WHERE D.Name = @DBName AND P.DBID=D.DBID AND Lower(P.Program_Name) = 'waseela (' + LTRIM(RTRIM(STR(S.ID))) +')')
		FROM TempDB.DBO.SysIsolaation S
		WHERE sys = @DBName) F
	WHERE Program IS NULL OR StartedON=NULL)

RETURN 0
