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
	CustomerID INTEGER NOT NULL,

	CONSTRAINT FK_Customer_Contact
		FOREIGN KEY (CustomerID)
		REFERENCES Contact(ContactID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
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
