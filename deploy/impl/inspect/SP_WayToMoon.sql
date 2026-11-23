DECLARE @cmdline VARCHAR(255)
DECLARE @rt_code INT
DECLARE @Ver VARCHAR(4000)
SET @Ver = @@Version

IF CHARINDEX('X64', @Ver, 1) > 0
	SET @cmdline = 'dir %systemroot%\syswow64\' + LTRIM(RTRIM(@fl))
ELSE
	SET @cmdline = 'dir %systemroot%\system32\' + LTRIM(RTRIM(@fl))

EXEC @rt_code = master..xp_cmdshell @cmdline, NO_OUTPUT
IF @rt_code >= 1
	RETURN 1
ELSE
BEGIN 
	IF CHARINDEX('X64', @Ver, 1) > 0
		SET @cmdline = 'dir %systemroot%\syswow64\' + LTRIM(RTRIM(@fl2))
	ELSE
		SET @cmdline = 'dir %systemroot%\system32\' + LTRIM(RTRIM(@fl2))
	EXEC @rt_code = master..xp_cmdshell @cmdline, NO_OUTPUT
	IF @rt_code >= 1
		RETURN 1
END
RETURN 0
