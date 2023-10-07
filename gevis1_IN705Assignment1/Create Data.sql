/*  START  */

-- This is the edited version of PopulateQuoteCompilationWithComponents.sql
USE gevis1_IN705Assignment1;
GO

/*
Create data on QuoteCompilation database to support
ID705 Databases 3 assignment.

****************************WARNING******************************************************
Object names used in this script require that
you must have implemented the database as specified on the assignment ERD


*/

--support functions, views and sp
--create function dbo.getCategoryID
--create function dbo.getAssemblySupplierID()
--create proc addSubComponent
-- Using variables : @ABC int, @XYZ int, @CDBD int, @BITManf int- capture the ContactID

--create categories
insert Category (CategoryName) values ('Black Steel')
insert Category (CategoryName) values ('Assembly')
insert Category (CategoryName) values ('Fixings')
insert Category (CategoryName) values ('Paint')
insert Category (CategoryName) values ('Labour')


--create contacts
--Using variables : @ABC int, @XYZ int, @CDBD int, @BITManf int- capture the ContactID
-- This will mean you don't have to hard code these later.

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('ABC Ltd.', '17 George Street, Dunedin', 'www.abc.co.nz', 'info@abc.co.nz', '	471 2345', null)

DECLARE @ABC INTEGER = @@IDENTITY

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('XYZ Ltd.', '23 Princes Street, Dunedin', null, 'xyz@paradise.net.nz', '4798765', '4798760')

DECLARE @XYZ INTEGER = @@IDENTITY

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('CDBD Pty Ltd.',	'Lot 27, Kangaroo Estate, Bondi, NSW, Australia 2026', '	www.cdbd.com.au', 'support@cdbd.com.au', '+61 (2) 9130 1234', null)

DECLARE @CDBD INTEGER = @@IDENTITY

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('BIT Manufacturing Ltd.', 'Forth Street, Dunedin', 'bitmanf.tekotago.ac.nz', 'bitmanf@tekotago.ac.nz', '0800 SMARTMOVE', null)

DECLARE @BITManf INTEGER = @@IDENTITY

-- create suppliers
INSERT INTO Supplier (SupplierID, SupplierGST)
(
	SELECT ContactID AS SupplierID, 22.9 AS SupplierGST FROM Contact
);
-- create components
-- Note this script relies on you having captured the ContactID to insert into SupplierID

SET IDENTITY_INSERT Component ON

insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30901, 'BMS10', '10mm M6 ms bolt', @ABC, 0.20, 0.17, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30902, 'BMS12', '12mm M6 ms bolt', @ABC, 0.25, 0.2125,	0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30903, 'BMS15', '15mm M6 ms bolt', @ABC, 0.32, 0.2720, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30904, 'NMS10', '10mm M6 ms nut', @ABC, 0.05, 0.04, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30905, 'NMS12', '12mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30906, 'NMS15', '15mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30911, 'BMS.3.12', '3mm x 12mm flat ms bar', @XYZ, 1.20, 1.15, 	0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30912, 'BMS.5.15', '5mm x 15mm flat ms bar', @XYZ, 2.50, 2.45, 	0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30913, 'BMS.10.25', '10mm x 25mm flat ms bar', @XYZ, 8.33, 8.27, 0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30914, 'BMS.15.40', '15mm x 40mm flat ms bar', @XYZ, 20.00, 19.85, 0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30931, '27', 'Anti-rust paint, silver', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30932, '43', 'Anti-rust paint, red', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30933, '154', 'Anti-rust paint, blue', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30921, 'ARTLAB', 'Artisan labour', @BITManf, 42.00, 42.00, 0	, dbo.getCategoryID('Labour'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30922, 'DESLAB', 'Designer labour', @BITManf, 54.00, 54.00, 0, dbo.getCategoryID('Labour'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30923, 'APPLAB', 'Apprentice labour', @BITManf, 23.50, 23.50, 0, dbo.getCategoryID('Labour'))

SET IDENTITY_INSERT Component OFF

--create assemblies
exec createAssembly  'SmallCorner.15', '15mm small corner'
exec dbo.addSubComponent 'SmallCorner.15', 'BMS.5.15', 0.120
exec dbo.addSubComponent 'SmallCorner.15', 'APPLAB', 0.33333
exec dbo.addSubComponent 'SmallCorner.15', '43', 0.0833333

exec dbo.createAssembly 'SquareStrap.1000.15', '1000mm x 15mm square strap'
exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS.5.15', 4
exec dbo.addSubComponent 'SquareStrap.1000.15', 'SmallCorner.15', 4
exec dbo.addSubComponent 'SquareStrap.1000.15', 'APPLAB', 25
exec dbo.addSubComponent 'SquareStrap.1000.15', 'ARTLAB', 10
exec dbo.addSubComponent 'SquareStrap.1000.15', '43', 0.185
exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS10', 8

exec dbo.createAssembly 'CornerBrace.15', '15mm corner brace'
exec dbo.addSubComponent 'CornerBrace.15', 'BMS.5.15', 0.090
exec dbo.addSubComponent 'CornerBrace.15', 'BMS10', 2

--create customers
EXEC dbo.createCustomer 'Meridith Francino', '200-339-2140', '913 Union Point', 'mfrancino0@facebook.com', 'https://zdnet.com/nibh/quisque/id/justo/sit/amet.jpg', '846-829-1339', '681-262-1188';
EXEC dbo.createCustomer 'Therese Jacketts', '547-597-6504', '61 Waxwing Drive', 'tjacketts1@xinhuanet.com', 'http://reuters.com/praesent/lectus/vestibulum/quam.js', '413-403-0697', '956-835-6296';
EXEC dbo.createCustomer 'Elysee Yewen', '835-521-0499', '06361 Commercial Center', 'eyewen2@prnewswire.com', 'https://thetimes.co.uk/tortor/risus.js', '215-553-6723', '378-889-4915';
EXEC dbo.createCustomer 'Cornela Folley', '494-923-3173', '9705 Stang Crossing', 'cfolley3@creativecommons.org', 'http://webnode.com/vulputate/nonummy/maecenas.js', '854-702-3879', '362-819-1265';
EXEC dbo.createCustomer 'Jameson Wickwarth', '993-643-1190', '24909 Russell Parkway', 'jwickwarth4@wired.com', 'http://discuz.net/consequat/morbi/a/ipsum/integer/a/nibh.js', '504-709-7430', '129-557-9800';
EXEC dbo.createCustomer 'Abbey Shimman', '645-447-0409', '84222 Bunting Hill', 'ashimman5@hao123.com', 'http://independent.co.uk/elementum/in/hac/habitasse/platea.html', '637-824-4908', '954-269-9920';
EXEC dbo.createCustomer 'Marje Kliemann', '888-841-1540', '451 Grasskamp Hill', 'mkliemann6@issuu.com', 'https://wordpress.com/sapien/cum/sociis.xml', '733-885-2167';
EXEC dbo.createCustomer 'Kahaleel Sibley', '467-788-0976', '72 American Ash Parkway', 'ksibley7@oracle.com', 'https://bbc.co.uk/amet.js';
EXEC dbo.createCustomer 'Ram Luckie', '862-829-8939', '4 Thierer Road', 'rluckie8@timesonline.co.uk';
EXEC dbo.createCustomer 'Bronny Zorzi', '425-834-1825', '7 Logan Drive';

--create quotes
DECLARE @Now DATE;
SET @Now = CAST(GETDATE() AS DATE);
DECLARE @NewQuoteID INTEGER;
EXEC dbo.createQuote 'Some Description', @Now, 'That Guy', 14, @NewQuoteID
SELECT * FROM Quote

/*
drop functions, views and sp
drop proc createAssembly
drop proc addSubComponent
drop function dbo.getCategoryID
drop function dbo.getAssemblySupplierID

END  */
