USE gevis1_IN705Assignment1;
GO

CREATE OR ALTER FUNCTION dbo.getCategoryID
(
    @CategoryName VARCHAR(20) -- Same size as CategoryName field
)
RETURNS INTEGER
AS
BEGIN
    RETURN (SELECT DISTINCT TOP(1)
		CategoryID
	FROM Category
	WHERE CategoryName = @CategoryName)
END
GO

CREATE OR ALTER FUNCTION dbo.getAssemblySupplierID()
RETURNS INTEGER
AS
BEGIN
    RETURN (SELECT DISTINCT TOP(1)
		CategoryID
	FROM Category
	WHERE CategoryName = 'BIT Manufacturing Ltd.')
END
GO