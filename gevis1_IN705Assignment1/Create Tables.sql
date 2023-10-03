-- =========================================
-- Create Tables
-- =========================================
USE gevis1_IN705Assignment1;
GO

-- Drop table if it exists
IF OBJECT_ID('Contact', 'U') IS NOT NULL
  DROP TABLE Contact
GO

CREATE TABLE Contact
(
	ContactID INTEGER PRIMARY KEY NOT NULL,
	ContactName NVARCHAR(50) NOT NULL,
	ContactPhone NVARCHAR(30) NOT NULL,
	ContactFax NVARCHAR(30) NULL,
	ContactMobilePhone NVARCHAR(30) NULL,
	ContactEmail NVARCHAR(50) NULL,
	ContactWWW NVARCHAR(50) NULL,
	ContactPostalAddress NVARCHAR(100) NOT NULL,
)
GO

