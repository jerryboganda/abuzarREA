CREATE TRIGGER dbo.Trig_ItemPart_AfterUpdate_ReflectItemPartChanges_TO_Item
ON dbo.ItemPart
AFTER UPDATE
AS 
/*
Author: Muhammad Azhar Inayat
Created On: 01st April, 2006
*/
BEGIN
	IF UPDATE(description) OR UPDATE(application) OR UPDATE(remarks) OR UPDATE(icatcode) OR UPDATE(iccode)
	BEGIN
		IF (SELECT MasterIPartCode FROM Inserted) IS NULL
		BEGIN
			UPDATE Item
			SET 
				remarks     = ISNULL((SELECT Inserted.description FROM Inserted), ''),
				packingdesc = ISNULL((SELECT Inserted.application FROM Inserted), ''),
				remarks1    = ISNULL((SELECT Inserted.remarks FROM Inserted), ''),
				icatcode    = (SELECT Inserted.icatcode FROM Inserted),
				iccode      = (SELECT Inserted.iccode FROM Inserted)
			FROM Item, ItemPart
			WHERE
				Item.IPartCode IN
					(SELECT IP.IPartCode FROM ItemPart IP
					WHERE IP.MasterIPartCode IN (SELECT I.IPartCode FROM Inserted I)
					UNION
					SELECT Inserted.IPartCode FROM Inserted) AND
				ItemPart.IPartCode=Item.IPartCode

			UPDATE ItemPart 
			SET 
				description = I.description,
				application = I.application,
				remarks     = I.remarks,
				icatcode    = I.icatcode,
				iccode      = I.iccode
			FROM Inserted I, ItemPart
			WHERE ItemPart.MasterIPartCode = I.IPartCode
		END
	END
END
