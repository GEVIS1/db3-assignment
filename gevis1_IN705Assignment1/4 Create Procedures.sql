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
