USE gevis1_IN705Assignment1;

-- Test trigFK_Assembly_Component
BEGIN TRANSACTION
-- Disable checks
ALTER TABLE QuoteComponent
	NOCHECK CONSTRAINT FK_QuoteComponent_Component;
ALTER TABLE AssemblySubcomponent
	NOCHECK CONSTRAINT FK_Subcomponent_Component;
ALTER TABLE AssemblySubcomponent
	NOCHECK CONSTRAINT FK_Assembly_Component;


SELECT 'Assembly', * FROM Component WHERE ComponentID = 31000;
SELECT 'Subcomponent', * FROM AssemblySubcomponent AS asu
JOIN Component AS co ON asu.SubcomponentID = co.ComponentID
WHERE asu.AssemblyID = 31000;


UPDATE Component
SET
	ComponentID = 30950
WHERE ComponentID = 31000;


SELECT 'Assembly', * FROM Component WHERE ComponentID = 30950;
SELECT 'Subcomponent', * FROM AssemblySubcomponent AS asu
JOIN Component AS co ON asu.SubcomponentID = co.ComponentID
WHERE asu.AssemblyID = 30950;

-- Enable checks
ALTER TABLE QuoteComponent
	CHECK CONSTRAINT FK_QuoteComponent_Component;
ALTER TABLE AssemblySubcomponent
	CHECK CONSTRAINT FK_Assembly_Component;
ROLLBACK TRANSACTION
GO

-- Test trigFK_Subcomponent_Component
BEGIN TRANSACTION
-- Disable checks
ALTER TABLE QuoteComponent
	NOCHECK CONSTRAINT FK_QuoteComponent_Component;
ALTER TABLE AssemblySubcomponent
	NOCHECK CONSTRAINT FK_Subcomponent_Component;
ALTER TABLE AssemblySubcomponent
	NOCHECK CONSTRAINT FK_Assembly_Component;


SELECT 'Assembly', * FROM Component WHERE ComponentID = 31000;
SELECT 'Subcomponent', * FROM AssemblySubcomponent AS asu
JOIN Component AS co ON asu.SubcomponentID = co.ComponentID
WHERE asu.AssemblyID = 31000;


UPDATE Component
SET
	ComponentID = 31010
WHERE ComponentID = 30912;


SELECT 'Assembly', * FROM Component WHERE ComponentID = 31000;
SELECT 'Subcomponent', * FROM AssemblySubcomponent AS asu
JOIN Component AS co ON asu.SubcomponentID = co.ComponentID
WHERE asu.AssemblyID = 31000;

-- Enable checks
ALTER TABLE QuoteComponent
	CHECK CONSTRAINT FK_QuoteComponent_Component;
ALTER TABLE AssemblySubcomponent
	CHECK CONSTRAINT FK_Assembly_Component;
ROLLBACK TRANSACTION
GO

-- Test trigSupplierDelete
-- Multiple supplier delete
BEGIN TRANSACTION
DELETE FROM Supplier
WHERE SupplierID IN (SELECT TOP (2) SupplierID FROM Supplier);
ROLLBACK TRANSACTION
-- Delete supplier with components
BEGIN TRANSACTION
DELETE FROM Supplier
WHERE SupplierID IN (SELECT TOP (1) SupplierID FROM Supplier);
ROLLBACK TRANSACTION
-- Successfully delete supplier 
BEGIN TRANSACTION
ALTER TABLE AssemblySubcomponent
	NOCHECK CONSTRAINT FK_Subcomponent_Component;
ALTER TABLE QuoteComponent
	NOCHECK CONSTRAINT FK_QuoteComponent_Component;
DELETE FROM Component
WHERE SupplierID IN (SELECT SupplierID FROM Supplier AS s JOIN Contact AS c ON s.SupplierID = c.ContactID WHERE c.ContactName = 'ABC Ltd.')
DELETE FROM Supplier
WHERE SupplierID IN (SELECT SupplierID FROM Supplier AS s JOIN Contact AS c ON s.SupplierID = c.ContactID WHERE c.ContactName = 'ABC Ltd.');
ROLLBACK TRANSACTION


-- Test updateAssemblyPrices
BEGIN TRANSACTION

SELECT *
		FROM Component AS co1
		JOIN Category AS ca ON co1.CategoryID = ca.CategoryID
		WHERE ca.CategoryName = 'Assembly'

EXEC updateAssemblyPrices

SELECT *
		FROM Component AS co1
		JOIN Category AS ca ON co1.CategoryID = ca.CategoryID
		WHERE ca.CategoryName = 'Assembly'

ROLLBACK TRANSACTION