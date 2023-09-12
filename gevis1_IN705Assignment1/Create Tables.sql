-- =========================================
-- Create Tables
-- =========================================
USE gevis1_IN705Assignment1;
GO

-- Drop table if it doesn't exist
IF OBJECT_ID('Customer.Contact', 'U') IS NOT NULL
  DROP TABLE Customer.Contact
GO

CREATE TABLE Customer.Contact
(
	<columns_in_primary_key, , c1> <column1_datatype, , int> <column1_nullability,, NOT NULL>, 
	<column2_name, sysname, c2> <column2_datatype, , char(10)> <column2_nullability,, NULL>, 
	<column3_name, sysname, c3> <column3_datatype, , datetime> <column3_nullability,, NULL>, 
    CONSTRAINT <contraint_name, sysname, PK_sample_table> PRIMARY KEY (<columns_in_primary_key, , c1>)
)
GO

