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

CREATE OR ALTER PROCEDURE dbo.createCustomer
	@Name NVARCHAR(50),
	@Phone NVARCHAR(30),
	@PostalAddress NVARCHAR(100),
	@Email NVARCHAR(50) = NULL,
	@WWW NVARCHAR(50) = NULL,
	@Fax NVARCHAR(30) = NULL,
	@MobilePhone NVARCHAR(30) = NULL
AS
BEGIN
	INSERT INTO Contact (
		ContactName,
		ContactPhone,
		ContactPostalAddress,
		ContactEmail,
		ContactWWW,
		ContactFax,
		ContactMobilePhone
	)
	VALUES (
		@Name,
		@Phone,
		@PostalAddress,
		@Email,
		@WWW,
		@Fax,
		@MobilePhone
	)

	DECLARE @NewCustomerID INTEGER = @@IDENTITY;

	INSERT INTO Customer (CustomerID)
		VALUES (@NewCustomerID);

	RETURN @NewCustomerID
END
GO
