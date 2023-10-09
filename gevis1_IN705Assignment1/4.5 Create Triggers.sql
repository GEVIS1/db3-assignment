USE gevis1_IN705Assignment1;
GO


--CREATE OR ALTER TRIGGER trigFK_Assembly_Component
--ON Component
--AFTER UPDATE
--AS
	-- Only run if a ComponentID changed
--	IF UPDATE(ComponentID)
--	BEGIN
--		DECLARE @UpdatedAssemblies TABLE (
--			OldAssemblyComponentID INTEGER,
--			NewAssemblyComponentID INTEGER
--		);

--		INSERT INTO @UpdatedAssemblies
--			SELECT
--				d.ComponentID AS OldAssemblyComponentID
--			FROM deleted AS d
--			UNION
--			SELECT
--				i.ComponentID AS NewAssemblyComponentID
--			FROM inserted AS i;

--		--SELECT * FROM @UpdatedAssemblies;
--	END
--;
--GO

---- Test trigFK_Assembly_Component
--BEGIN TRANSACTION

--ALTER TABLE Component
--	NOCHECK CONSTRAINT FK_Assembly_Component;

--UPDATE Component
--SET
--	ComponentID = 30999
--WHERE ComponentID = 30950;

--ALTER TABLE Component
--	CHECK CONSTRAINT FK_Assembly_Component;

--ROLLBACK TRANSACTION
--GO

--CREATE OR ALTER TRIGGER trigFK_Subcomponent_Component
--ON AssemblySubComponent
--AFTER UPDATE
--AS
--;
--GO

---- Test trigFK_Assembly_Component
--BEGIN TRANSACTION

--ALTER TABLE Component
--	NOCHECK CONSTRAINT FK_Subcomponent_Component;

--UPDATE Component
--SET
--	ComponentID = 40000
--WHERE ComponentID = <subcomponent id>;

--ALTER TABLE Component
--	CHECK CONSTRAINT FK_Subcomponent_Component;

--ROLLBACK TRANSACTION
--GO

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
