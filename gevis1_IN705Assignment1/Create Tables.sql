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

	CONSTRAINT Valid_QuotePrice
		CHECK (0 <= QuotePrice)
)
GO

IF OBJECT_ID('QuoteComponent', 'U') IS NOT NULL
  DROP TABLE QuoteComponent
GO

CREATE TABLE QuoteComponent
(
	ComponentID INTEGER NOT NULL,
	QuoteID INTEGER NOT NULL,

	-- DECIMAL(9,2) gives a 5 byte size with a max number of 9999999.99 which is sufficient
	Quantity DECIMAL(9,2) DEFAULT 1,
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

	CONSTRAINT Valid_Quantity
		CHECK (0 <= Quantity),

	CONSTRAINT Valid_TradePrice
		CHECK (0 <= TradePrice),

	CONSTRAINT Valid_ListPrice
		CHECK (0 <= ListPrice),

	CONSTRAINT Valid_TimeToFit
		CHECK (0 <= TimeToFit),
)
GO

---- Drop table if it exists
--IF OBJECT_ID('<TableName>', 'U') IS NOT NULL
--  DROP TABLE <TableName>
--GO

--CREATE TABLE <TableName>
--(
--	PrimaryKey INTEGER PRIMARY KEY NOT NULL,
--	Field1 NVARCHAR(50) NULL,
--)
--GO
