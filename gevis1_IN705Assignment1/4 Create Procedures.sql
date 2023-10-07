USE gevis1_IN705Assignment1;
GO

CREATE OR ALTER PROCEDURE dbo.createAssembly
    @ComponentName VARCHAR(50),
    @ComponentDescription VARCHAR(100)  
AS
BEGIN
	INSERT INTO Component (ComponentName, ComponentDescription, TradePrice, ListPrice, TimeToFit, CategoryID, SupplierID)
		VALUES (@ComponentName,	@ComponentDescription, 0, 0, 0, dbo.getCategoryID('Assembly'), dbo.getAssemblySupplierID())
	RETURN 0 
END
GO

CREATE OR ALTER PROCEDURE dbo.addSubComponent
    @AssemblyName VARCHAR(50),
    @SubComponentName VARCHAR(50),
	@Quantity INTEGER
AS
BEGIN
	INSERT INTO AssemblySubComponent (AssemblyID, SubcomponentID, Quantity)
		SELECT 
			c1.ComponentID AS AssemblyID,
			c2.ComponentID AS SubcomponentID,
			@Quantity AS Quantity 
		FROM Component AS c1
		JOIN Component AS c2 ON c2.ComponentName = @SubComponentName
		WHERE c1.ComponentName = @AssemblyName
	RETURN 0
END
GO
