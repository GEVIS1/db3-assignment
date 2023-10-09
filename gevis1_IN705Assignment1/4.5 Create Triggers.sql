USE gevis1_IN705Assignment1;
GO

CREATE OR ALTER TRIGGER trigFK_Assembly_Component
ON Component
AFTER UPDATE
AS
	--Only run if a ComponentID changed
	IF UPDATE(ComponentID)
	BEGIN
		DECLARE @UpdatedAssemblies TABLE (
			OldAssemblyComponentID INTEGER,
			NewAssemblyComponentID INTEGER
		);
		INSERT INTO @UpdatedAssemblies
			SELECT
				d.ComponentID AS OldAssemblyComponentID,
				i.ComponentID AS NewAssemblyComponentID
			FROM deleted AS d
			CROSS JOIN inserted AS i
			-- We can confirm that it is an assembly by asserting that its CategoryName is 'Assembly'
			-- NB: This could get funky if the assembly Component's category got changed from 'Assembly' to something else,
			--     but this is unintended behaviour.
			JOIN Category AS ca ON d.CategoryID = ca.CategoryID
			WHERE ca.CategoryName = 'Assembly';

		UPDATE AssemblySubcomponent
		SET
			AssemblyID = ua.NewAssemblyComponentID
		FROM AssemblySubcomponent AS asu
		JOIN @UpdatedAssemblies AS ua ON asu.AssemblyID = ua.OldAssemblyComponentID
		WHERE asu.AssemblyID = ua.OldAssemblyComponentID;
	END
;
GO

-- This trigger should/could be merged with trigFK_Assembly_Component
CREATE OR ALTER TRIGGER trigFK_Subcomponent_Component
ON Component
AFTER UPDATE
AS
--Only run if a ComponentID changed
	IF UPDATE(ComponentID)
	BEGIN
		DECLARE @UpdatedSubcomponents TABLE (
			OldSubcomponentID INTEGER,
			NewSubComponentID INTEGER
		);
		INSERT INTO @UpdatedSubcomponents
			SELECT
				d.ComponentID AS OldSubcomponentID,
				i.ComponentID AS NewSubcomponentID
			FROM deleted AS d
			CROSS JOIN inserted AS i
			-- We can confirm that it is a subcomponent by asserting that its ComponentID is also a SubcomponentID
			JOIN AssemblySubcomponent AS asu ON d.ComponentID = asu.SubcomponentID;

		UPDATE AssemblySubcomponent
		SET
			SubcomponentID = usu.NewSubComponentID
		FROM AssemblySubcomponent AS asu
		JOIN @UpdatedSubcomponents AS usu ON asu.SubcomponentID = usu.OldSubcomponentID
		WHERE asu.SubcomponentID = usu.OldSubcomponentID;
	END
;
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
