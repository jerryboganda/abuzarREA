CREATE TRIGGER dbo.Trig_ItemPartInModel_AfterInsertUpdate_ReflectItemPartInModelChanges_TO_ItemInModel
ON dbo.ItemPartInModel
AFTER INSERT, UPDATE
AS
/*
Author: Muhammad Azhar Inayat
Created On: 01st April, 2006
*/
 
IF (SELECT MAX(MasterIPartCode) FROM ItemPart 
	WHERE IPartCode IN 
		(SELECT DISTINCT Inserted.IPartCode FROM Inserted)) IS NULL
BEGIN
	DELETE ItemInModel
	WHERE ICode IN
		(SELECT Item.ICode FROM Item
		WHERE Item.IPartCode IN
			(SELECT IP.IPartCode FROM ItemPart IP
			WHERE IP.MasterIPartCode IN (SELECT DISTINCT I.IPartCode FROM Inserted I)
			UNION 
			SELECT DISTINCT Inserted.IPartCode FROM Inserted))

	INSERT INTO ItemInModel (ICode, ModelCode)
	SELECT I.ICode, M.ModelCode
	FROM
		(SELECT Item.ICode FROM Item
		WHERE Item.IPartCode IN
			(SELECT IP.IPartCode FROM ItemPart IP
			WHERE IP.MasterIPartCode IN (SELECT DISTINCT I.IPartCode FROM Inserted I)
			UNION SELECT DISTINCT Inserted.IPartCode FROM Inserted)) I,
		(SELECT DISTINCT ModelCode FROM ItemPartInModel 
		WHERE IPartCode IN (SELECT DISTINCT Inserted.IPartCode FROM Inserted)) M

	DELETE ItemPartInModel
	WHERE IPartCode IN
		(SELECT IP.IPartCode FROM ItemPart IP
		WHERE IP.MasterIPartCode IN (SELECT DISTINCT I.IPartCode FROM Inserted I))

	INSERT INTO ItemPartInModel (IPartCode, ModelCode)
	SELECT IP.IPartCode, M.ModelCode
	FROM
		(SELECT IP.IPartCode FROM ItemPart IP
		WHERE IP.MasterIPartCode IN (SELECT DISTINCT I.IPartCode FROM Inserted I)) IP,
		(SELECT ModelCode
		FROM ItemPartInModel
		WHERE IPartCode IN (SELECT DISTINCT Inserted.IPartCode FROM Inserted)) M
END
