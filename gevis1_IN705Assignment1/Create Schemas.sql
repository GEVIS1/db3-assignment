-- ==========================================================================================================================
-- Create Schemas
-- ==========================================================================================================================
USE gevis1_IN705Assignment1;
GO

CREATE SCHEMA Customer;
GO

CREATE SCHEMA Billing;
GO

CREATE SCHEMA Component;
GO

CREATE SYNONYM Billing.QuoteComponent FOR Component.QuoteComponent;
GO