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
	DECLARE @AssemblyID INTEGER = (
		SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = @AssemblyName
	);

	DECLARE @SubComponentID INTEGER = (
		SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = @SubComponentName
	);

	INSERT INTO AssemblySubComponent (AssemblyID, SubcomponentID, Quantity)
		VALUES (@AssemblyID, @SubComponentID, @Quantity)
	RETURN 0
END
GO