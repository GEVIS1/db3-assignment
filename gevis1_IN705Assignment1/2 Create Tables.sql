-- =========================================
-- Create Tables
-- =========================================
USE gevis1_IN705Assignment1;
GO

IF OBJECT_ID('Contact', 'U') IS NOT NULL
  DROP TABLE Contact
GO

CREATE TABLE Contact
(
	ContactID INTEGER IDENTITY PRIMARY KEY,
	ContactName NVARCHAR(50) NOT NULL,
	ContactPhone NVARCHAR(30) NOT NULL,
	ContactFax NVARCHAR(30) NULL,
	ContactMobilePhone NVARCHAR(30) NULL,
	ContactEmail NVARCHAR(50) NULL,
	ContactWWW NVARCHAR(50) NULL,
	ContactPostalAddress NVARCHAR(100) NOT NULL,
)
GO

IF OBJECT_ID('Customer', 'U') IS NOT NULL
  DROP TABLE Customer
GO

CREATE TABLE Customer
(
	CustomerID INTEGER NOT NULL PRIMARY KEY,

	CONSTRAINT FK_Customer_Contact
		FOREIGN KEY (CustomerID)
		REFERENCES Contact(ContactID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
GO

IF OBJECT_ID('Quote', 'U') IS NOT NULL
  DROP TABLE Quote
GO

CREATE TABLE Quote
(
	QuoteID INTEGER IDENTITY PRIMARY KEY,
	QuoteDescription NVARCHAR(100) NOT NULL,
	QuoteDate DATE NOT NULL,
	QuotePrice MONEY NULL,
	QuoteCompiler VARCHAR(50) NOT NULL,
	CustomerID INTEGER NOT NULL,

	CONSTRAINT FK_Quote_Customer
		FOREIGN KEY (CustomerID)
		REFERENCES Customer(CustomerID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,

	CONSTRAINT Valid_Quote_QuotePrice
		CHECK (0 <= QuotePrice)
)
GO

IF OBJECT_ID('Supplier', 'U') IS NOT NULL
  DROP TABLE Supplier
GO

CREATE TABLE Supplier
(
	SupplierID INTEGER NOT NULL PRIMARY KEY,
	SupplierGST DECIMAL(5,2) NOT NULL, -- DECIMAL(5,2) covers -999.99 to 999.99 which fits 0.00 to 100.00

	CONSTRAINT FK_Supplier_Contact
		FOREIGN KEY (SupplierID)
		REFERENCES Contact(ContactID),

	CONSTRAINT Valid_Supplier_SupplierGST
		CHECK (0.0 <= SupplierGST AND SupplierGST <= 100.0)
)
GO

IF OBJECT_ID('Category', 'U') IS NOT NULL
  DROP TABLE Category
GO

CREATE TABLE Category
(
	CategoryID INTEGER IDENTITY PRIMARY KEY,
	CategoryName NVARCHAR(20) NOT NULL,
)
GO

IF OBJECT_ID('Component', 'U') IS NOT NULL
  DROP TABLE Component
GO

CREATE TABLE Component
(
	ComponentID INTEGER NOT NULL PRIMARY KEY,

	ComponentName VARCHAR(50) NOT NULL,
	ComponentDescription VARCHAR(100) NOT NULL,
	TradePrice MONEY NOT NULL,
	ListPrice MONEY NOT NULL,
	TimeToFit DECIMAL DEFAULT 0,
	CategoryID INTEGER NOT NULL,
	SupplierID INTEGER NOT NULL,
	
	CONSTRAINT FK_Component_Category
		FOREIGN KEY (CategoryID)
		REFERENCES Category(CategoryID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	CONSTRAINT FK_Component_Supplier
		FOREIGN KEY (SupplierID)
		REFERENCES Supplier(SupplierID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,

	CONSTRAINT Valid_Component_TradePrice
		CHECK (0 <= TradePrice),

	CONSTRAINT Valid_Component_ListPrice
		CHECK (0 <= ListPrice),

	CONSTRAINT Valid_Component_TimeToFit
		CHECK (0 <= TimeToFit),
)
GO

-- Sequence for ComponentID
CREATE SEQUENCE [dbo].ComponentID
AS INTEGER
START WITH 31000
INCREMENT BY 1;

IF OBJECT_ID('QuoteComponent', 'U') IS NOT NULL
  DROP TABLE QuoteComponent
GO

CREATE TABLE QuoteComponent
(
	ComponentID INTEGER NOT NULL,
	QuoteID INTEGER NOT NULL,

	-- DECIMAL(19,9) gives a 9 byte size with a max number of 9999999999.999999999 which is sufficient
	Quantity DECIMAL(19,9) DEFAULT 1,
	TradePrice MONEY NOT NULL,
	ListPrice MONEY NOT NULL,
	TimeToFit DECIMAL DEFAULT 0,
	
	CONSTRAINT FK_QuoteComponent_Component
		FOREIGN KEY (ComponentID)
		REFERENCES Component(ComponentID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION, -- Will be handled by trigger

	CONSTRAINT FK_QuoteComponent_Quote
		FOREIGN KEY (QuoteID)
		REFERENCES Quote(QuoteID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

	CONSTRAINT PK_QuoteComponent
		PRIMARY KEY (ComponentID, QuoteID),

	CONSTRAINT Valid_QuoteComponent_Quantity
		CHECK (0 <= Quantity),

	CONSTRAINT Valid_QuoteComponent_TradePrice
		CHECK (0 <= TradePrice),

	CONSTRAINT Valid_QuoteComponent_ListPrice
		CHECK (0 <= ListPrice),

	CONSTRAINT Valid_QuoteComponent_TimeToFit
		CHECK (0 <= TimeToFit),
)
GO

IF OBJECT_ID('AssemblySubComponent', 'U') IS NOT NULL
  DROP TABLE AssemblySubComponent
GO

CREATE TABLE AssemblySubComponent
(
	AssemblyID INTEGER NOT NULL,
	SubcomponentID INTEGER NOT NULL,

	Quantity DECIMAL(19,9) DEFAULT 1,

	CONSTRAINT FK_Subcomponent_Component
		FOREIGN KEY (SubcomponentID)
		REFERENCES Component(ComponentID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION, -- Will be handled by trigger

	CONSTRAINT FK_Assembly_Component
		FOREIGN KEY (AssemblyID)
		REFERENCES Component(ComponentID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION, -- Will be handled by trigger

	CONSTRAINT PK_AssemblySubcomponent
		PRIMARY KEY (AssemblyID, SubcomponentID),

	CONSTRAINT Valid_AssemblySubComponent_Quantity
		CHECK (0 <= Quantity),
)
GO
