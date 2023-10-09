USE gevis1_IN705Assignment1;
GO

CREATE OR ALTER PROCEDURE dbo.createAssembly
    @ComponentName VARCHAR(50),
    @ComponentDescription VARCHAR(100)  
AS
BEGIN
	INSERT INTO Component (ComponentID, ComponentName, ComponentDescription, TradePrice, ListPrice, TimeToFit, CategoryID, SupplierID)
	SELECT NEXT VALUE FOR [dbo].ComponentID, @ComponentName, @ComponentDescription, 0, 0, 0, dbo.getCategoryID('Assembly'), dbo.getAssemblySupplierID()
	RETURN 0 
END
GO

CREATE OR ALTER PROCEDURE dbo.addSubComponent
    @AssemblyName VARCHAR(50),
    @SubComponentName VARCHAR(50),
	@Quantity DECIMAL(19,9)
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

CREATE OR ALTER PROCEDURE dbo.createQuote
	@QuoteDescription NVARCHAR(100),
	@QuoteDate DATE = NULL,
	@QuoteCompiler VARCHAR(50),
	@CustomerID INTEGER,
	@QuoteID INTEGER OUTPUT
AS
BEGIN
	-- Set date if NULL
	IF @QuoteDate IS NULL
		SET @QuoteDate = CAST(GETDATE() AS DATE);


	INSERT INTO Quote (
		QuoteDescription,
		QuoteDate,
		QuoteCompiler,
		CustomerID
	)
	VALUES (
		@QuoteDescription,
		@QuoteDate,
		@QuoteCompiler,
		@CustomerID
	);

	SET @QuoteID = @@IDENTITY;

	RETURN 0;
END
GO

CREATE OR ALTER PROCEDURE dbo.addQuoteComponent
	@QuoteID INTEGER,
	@ComponentID INTEGER,
	@Quantity DECIMAL(19,9)
AS
BEGIN
	-- Get prices and TimeToFit
	DECLARE @CurrentTradePrice MONEY;
	DECLARE @CurrentListPrice MONEY;
	DECLARE @CurrentTimeToFit DECIMAL;

	SELECT
		@CurrentTradePrice = TradePrice,
		@CurrentListPrice  = ListPrice,
		@CurrentTimeToFit  = TimeToFit
	FROM Component WHERE ComponentID = @ComponentID
	INSERT INTO QuoteComponent (
		ComponentID,
		QuoteID,
		Quantity,
		TradePrice,
		ListPrice,
		TimeToFit
	)
	VALUES (
		@ComponentID,
		@QuoteID,
		@Quantity,
		@CurrentTradePrice,
		@CurrentListPrice,
		@CurrentTimeToFit
	);

	/*
	DISABLED DUE TO OUT OF SCOPE

	Update quote cost and TTF
	Consider making this a trigger on the QuoteComponent table?
	This will fail if QuotePrice is NULL, so make it 0
	This should be optimized into a single UPDATE statement but it is out of the scope of this assignment
	so it is left as is..
	It also doesn't recursively tally up prices of assemblies since they are 0 cost, so there
	needs to be a check if it is an assembly then a tally of all the subcomponents of that assembly
	should be added.. either way this is huge feature creep for the assignment.
	
	IF (SELECT DISTINCT TOP(1) QuotePrice FROM Quote WHERE QuoteID = @QuoteID) IS NULL
		UPDATE Quote SET QuotePrice = 0 WHERE QuoteID = @QuoteID;

	UPDATE Quote
	SET
		QuotePrice += @Quantity * @CurrentTradePrice
	WHERE QuoteID = @QuoteID;
	*/
	RETURN 0;
END
GO

CREATE OR ALTER PROCEDURE updateAssemblyPrices
AS
BEGIN
	-- Tally up total TradePrice and Listprice for all assemblies in common table expression
	WITH [Assemblies] (AssemblyID, TradePrice, Listprice) AS
	(
		SELECT
			co1.ComponentID,
			SUM([asc].Quantity * co2.TradePrice) AS TradePrice,
			SUM([asc].Quantity * co2.ListPrice) AS ListPrice
		FROM Component AS co1
		JOIN Category AS ca ON co1.CategoryID = ca.CategoryID
		JOIN AssemblySubComponent AS [asc] ON co1.ComponentID = [asc].AssemblyID
		JOIN Component AS co2 ON [asc].SubcomponentID = co2.ComponentID
		WHERE ca.CategoryName = 'Assembly'
		GROUP BY co1.ComponentID
	)
	UPDATE Component
	SET
		TradePrice = a.TradePrice,
		ListPrice = a.ListPrice
	FROM Component AS c
	JOIN [Assemblies] AS a ON c.ComponentID = a.AssemblyID
	WHERE ComponentID = a.AssemblyID
	RETURN 0;
END;
GO
