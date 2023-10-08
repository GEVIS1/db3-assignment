USE gevis1_IN705Assignment1;

DECLARE @Bimble INTEGER;
DECLARE @Hyperfont INTEGER;

--create customers
EXEC @Bimble = dbo.createCustomer 'Bimble & Hat', '444 5555', '123 Digit Street, Dunedin', 'guy.little@bh.biz.nz';
EXEC @Hyperfont = dbo.createCustomer 'Hyperfont Modulator (International) Ltd.', '(4) 213 4359', '3 Lambton Quay, Wellington', 'sue@nz.hfm.com';

--create quotes
DECLARE @BimbleQuoteIDFrame INTEGER;
EXEC dbo.createQuote 'Craypot frame', NULL, 'Hiro Protagonist', @Bimble, @QuoteID = @BimbleQuoteIDFrame OUTPUT;

IF @BimbleQuoteIDFrame IS NULL
	THROW 51000, 'NULL @BimbleQuoteIDFrame', 1;

EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30951, 3
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30912, 8
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30901, 24
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30904, 24
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30933, 200
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30921, 150
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30923, 120
EXEC dbo.addQuoteComponent @BimbleQuoteIDFrame, 30922, 45


DECLARE @BimbleQuoteIDStand INTEGER;
EXEC dbo.createQuote 'Craypot stand', NULL, 'Hiro Protagonist', @Bimble, @QuoteID = @BimbleQuoteIDStand OUTPUT;

IF @BimbleQuoteIDStand IS NULL
	THROW 51000, 'NULL @BimbleQuoteIDStand', 1;

EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30914, 2
EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30903, 4
EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30906, 4
EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30933, 100
EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30923, 90
EXEC dbo.addQuoteComponent @BimbleQuoteIDStand, 30922, 15


DECLARE @HyperfontQuoteID INTEGER;

EXEC dbo.createQuote 'Phasing restitution fulcrum', NULL, 'Y.T.', @Hyperfont, @QuoteID = @HyperfontQuoteID OUTPUT;

IF @HyperfontQuoteID IS NULL
	THROW 51000, 'NULL @HyperfontQuoteID', 1;

EXEC dbo.addQuoteComponent @HyperFontQuoteID, 30952, 3
EXEC dbo.addQuoteComponent @HyperFontQuoteID, 30950, 1
EXEC dbo.addQuoteComponent @HyperFontQuoteID, 30921, 320
EXEC dbo.addQuoteComponent @HyperFontQuoteID, 30922, 105
EXEC dbo.addQuoteComponent @HyperFontQuoteID, 30932, 0.5
