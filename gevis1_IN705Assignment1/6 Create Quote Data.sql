USE gevis1_IN705Assignment1;

DECLARE @Bimble INTEGER;
DECLARE @Hyperfont INTEGER;

--create customers
EXEC @Bimble = dbo.createCustomer 'Bimble & Hat', '444 5555', '123 Digit Street, Dunedin', 'guy.little@bh.biz.nz';
EXEC @Hyperfont = dbo.createCustomer 'Hyperfont Modulator (International) Ltd.', '(4) 213 4359', '3 Lambton Quay, Wellington', 'sue@nz.hfm.com';

--create quotes
DECLARE @NewQuoteID INTEGER;
EXEC dbo.createQuote 'Some Description', NULL, 'That Guy', 14, @QuoteID = @NewQuoteID OUTPUT
--SELECT *, @NewQuoteID AS NewQuoteID FROM Quote

EXEC dbo.addQuoteComponent QuoteID, ComponentID, Quantity
