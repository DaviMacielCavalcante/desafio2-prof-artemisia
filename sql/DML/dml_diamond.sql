INSERT INTO exchanges(exchange)
SELECT DISTINCT(exchange)
FROM gold;

INSERT INTO currencys(currency)
SELECT DISTINCT(currency)
FROM gold;

INSERT INTO years(year)
SELECT DISTINCT(year)
FROM gold;

INSERT INTO months(month)
SELECT DISTINCT(month)
FROM gold
WHERE year IN (SELECT year FROM years);

INSERT INTO days(day)
SELECT DISTINCT day
FROM gold
WHERE year IN (SELECT year FROM years) 
	AND month IN (SELECT month FROM months);

INSERT INTO diamond (exchange, open, close, adj_close, high, low, volume, currency, year, month, day)
SELECT 
	(SELECT id FROM exchanges WHERE gold.exchange = exchanges.exchange),
	open, close, adj_close, high, low, volume, 
	(SELECT id FROM currencys WHERE gold.currency = currencys.currency),
	(SELECT id FROM years WHERE gold.year = years.year), 
	(SELECT id FROM months WHERE gold.month = months.month), 
	(SELECT id FROM days WHERE gold.day = days.day)	
FROM gold;