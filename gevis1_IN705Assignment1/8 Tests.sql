USE gevis1_IN705Assignment1;
GO

-- Test trigFK_Assembly_Component #########################################################################################################
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
--#########################################################################################################################################

-- Test trigFK_Subcomponent_Component #####################################################################################################
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
--#########################################################################################################################################

-- Test trigSupplierDelete ################################################################################################################
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
GO
--#########################################################################################################################################

-- Test updateAssemblyPrices ##############################################################################################################
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
GO
--#########################################################################################################################################

-- Test isCyclicAssembly ##################################################################################################################
-- Not a component
BEGIN TRANSACTION
EXEC testCyclicAssembly 1
ROLLBACK TRANSACTION

-- Not an assembly
BEGIN TRANSACTION
EXEC testCyclicAssembly 30901
ROLLBACK TRANSACTION

-- Not cyclic
BEGIN TRANSACTION
DECLARE @NotCyclic INTEGER;
EXEC @NotCyclic = testCyclicAssembly 31000 -- Assembly SmallCorner.15
SELECT @NotCyclic AS NotCyclic
ROLLBACK TRANSACTION

-- Cyclic subcomponent
BEGIN TRANSACTION
exec createAssembly 'Assembly A', 'An excellent assembly!'
DECLARE @AssemblyAID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly A');
-- Insert cyclic assembly
exec dbo.addSubComponent 'Assembly A', 'Assembly A', 1
DECLARE @CyclicSub INTEGER;
EXEC @CyclicSub = testCyclicAssembly @AssemblyAID
SELECT @CyclicSub AS CyclicSub
ROLLBACK TRANSACTION

-- Non-Cyclic sub-sub-component
BEGIN TRANSACTION
exec createAssembly 'Assembly 1', 'The 1st assembly'
DECLARE @Assembly1ID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly 1');
exec createAssembly 'Assembly 2', 'The 2nd assembly'
DECLARE @Assembly2ID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly 2');
exec createAssembly 'Assembly 3', 'The 3rd assembly'
DECLARE @Assembly3ID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly 3');
-- Insert assemblies into eachother
exec dbo.addSubComponent 'Assembly 2', 'Assembly 3', 1
exec dbo.addSubComponent 'Assembly 1', 'Assembly 2', 1
DECLARE @NotCyclicSubSub INTEGER;
EXEC @NotCyclicSubSub = testCyclicAssembly @Assembly1ID
SELECT @NotCyclicSubSub AS CyclicSubSub
ROLLBACK TRANSACTION

-- Cyclic sub-sub-component
BEGIN TRANSACTION
exec createAssembly 'Assembly B', 'A non-repudiable assembly!'
DECLARE @AssemblyBID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly B');
exec createAssembly 'Assembly C', 'An incredulous assembly!'
DECLARE @AssemblyCID INTEGER = (SELECT DISTINCT TOP(1) ComponentID FROM Component WHERE ComponentName = 'Assembly C');
-- Insert cyclic assembly
exec dbo.addSubComponent 'Assembly B', 'Assembly C', 1;
exec dbo.addSubComponent 'Assembly C', 'Assembly B', 1;
DECLARE @CyclicSubSub INTEGER;
EXEC @CyclicSubSub = testCyclicAssembly @AssemblyBID
SELECT @CyclicSubSub AS CyclicSubSub;
ROLLBACK TRANSACTION
--##################################################################################################################################
