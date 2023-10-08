USE gevis1_IN705Assignment1;
GO


--CREATE OR ALTER TRIGGER trigFK_Assembly_Component
--ON Component
--AFTER UPDATE
--AS
--	-- Is there a better way to do this?
--	/*
--	-- Store the assembly components' old IDs before updating Component
--	DECLARE @Assemblies TABLE (AssemblyID INTEGER, CategoryID INTEGER);

--	INSERT INTO @Assemblies
--		SELECT i.ComponentID, i.CategoryID 
--		FROM inserted AS i
--		JOIN Category AS c ON i.CategoryID = c.CategoryID
--		WHERE c.CategoryName = 'Assembly';

--	-- Run the actual update statement
--	UPDATE Component
--	SET 
--		ComponentID = CASE 
--			WHEN i.ComponentID <> c.ComponentID THEN i.ComponentID
--			ELSE c.ComponentID END,
--		ComponentName = CASE
--			WHEN i.ComponentName <> c.ComponentName THEN i.ComponentName
--			ELSE c.ComponentName END,
--		ComponentDescription = CASE
--			WHEN i.ComponentDescription <> c.ComponentDescription THEN i.ComponentDescription
--			ELSE c.ComponentDescription END,
--		TradePrice = CASE
--			WHEN i.TradePrice <> c.TradePrice THEN i.TradePrice
--			ELSE c.TradePrice END,
--		ListPrice = CASE
--			WHEN i.ListPrice <> c.ListPrice THEN i.ListPrice
--			ELSE c.ListPrice END,
--		TimeToFit = CASE
--			WHEN i.TimeToFit <> c.TimeToFit THEN i.TimeToFit
--			ELSE c.TimeToFit END,
--		CategoryID = CASE
--			WHEN i.CategoryID <> c.CategoryID THEN i.CategoryID
--			ELSE c.CategoryID END,
--		SupplierID = CASE
--			WHEN i.SupplierID <> c.SupplierID THEN i.SupplierID
--			ELSE c.SupplierID END
--	FROM inserted AS i
--	JOIN Component AS c ON i.ComponentID = c.ComponentID
--	WHERE c.ComponentID = i.ComponentID;

--	-- Update the sub components
--	UPDATE AssemblySubComponent
--	SET
--		AssemblyID = inserted.ComponentID
--	FROM AssemblySubComponent AS ac
--	JOIN @Assemblies AS a ON ac.AssemblyID = a.AssemblyID
--	WHERE a.AssemblyID = ac.AssemblyID

--	*/

--	-- Yes.. The old IDS are in Deleted and the new in Inserted.
--	DECLARE @UpdatedAssemblies TABLE (
--		OldAssemblyComponentID INTEGER,
--		NewAssemblyComponentID INTEGER
--	);

--	--INSERT INTO @UpdatedAssemblies
--	SELECT
--		d.ComponentID AS OldAssemblyComponentID
--	FROM deleted AS d
--	UNION 
--	SELECT
--		i.ComponentID AS NewAssemblyComponentID
--	FROM inserted AS i;

--	--SELECT * FROM @UpdatedAssemblies;
--;
--GO

--BEGIN TRANSACTION
--SET IDENTITY_INSERT Component ON
--UPDATE Component
--SET
--	ComponentID = 30959
--WHERE ComponentID = 30950;
--SET IDENTITY_INSERT Component OFF
--ROLLBACK TRANSACTION
--GO

--CREATE OR ALTER TRIGGER trigFK_Subcomponent_Component
--ON AssemblySubComponent
--AFTER UPDATE
--AS
--;
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
