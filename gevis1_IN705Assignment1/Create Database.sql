-- =============================================
-- Create Database
-- =============================================
-- Drop the database if it already exists
IF EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'gevis1_IN705Assignment1'
)
DROP DATABASE gevis1_IN705Assignment1;
GO

CREATE DATABASE gevis1_IN705Assignment1;
GO