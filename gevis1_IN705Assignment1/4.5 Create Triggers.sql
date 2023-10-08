USE gevis1_IN705Assignment1;
GO

CREATE OR ALTER TRIGGER trigSupplierDelete
ON Supplier
INSTEAD OF DELETE
AS
	-- Check that only one supplier is deleted
	IF (@@ROWCOUNT) > 1
		THROW 51000, 'Can not delete multiple suppliers at a time.', 1;

	-- Capture Supplier info from deleted table joined with contact table
	DECLARE @DeletedSupplierID INTEGER;
	DECLARE @DeletedSupplierName NVARCHAR(50);
	SELECT DISTINCT TOP(1)
		@DeletedSupplierID = s.SupplierID,
		@DeletedSupplierName = c.ContactName
		FROM deleted AS s
		JOIN Contact AS c ON s.SupplierID = c.ContactID;

	-- Capture how many components the supplier supplies
	DECLARE @nComponents INTEGER;
	SELECT @nComponents = COUNT(*)
	FROM Component WHERE SupplierID =  @DeletedSupplierID;

	IF 0 < @nComponents BEGIN
		-- With the hardcoded text plus the VARCHARS it's 109 characters long. Plus the integer.. assuming a million components would be an ambitious maximum. So 118.. round to 120. 
		DECLARE @ErrorMessage VARCHAR(120);
		SET @ErrorMessage = CONCAT('You can not delete this supplier. ', @DeletedSupplierName, ' has ', @nComponents, ' related components.');
		THROW 51000, @ErrorMessage, 1;
		END
	ELSE
		DELETE FROM Supplier
			WHERE SupplierID = @DeletedSupplierID;
		-- This is where deleting the contact entry would be considered if there is no customer attached to it
GO
