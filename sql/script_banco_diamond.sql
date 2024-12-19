-- APLICANDO O MODELO RELACIONAL

CREATE TABLE currencys(
	id SERIAL PRIMARY KEY,
	currency VARCHAR(5) NOT NULL
);

CREATE TABLE years(
	id SERIAL PRIMARY KEY,
	year INT NOT NULL
);

CREATE TABLE months(
	id SERIAL PRIMARY KEY,
	month INT NOT NULL
);

CREATE TABLE days(
	id SERIAL PRIMARY KEY,
	day INT NOT NULL
);

CREATE TABLE exchanges (
	id SERIAL PRIMARY KEY,
	exchange VARCHAR(10) NOT NULL
);

CREATE TABLE gold(
	id SERIAL PRIMARY KEY,
	exchange VARCHAR(10) NOT NULL,
	date DATE NOT NULL,
	open NUMERIC(14,9) NOT NULL,
	high NUMERIC(14,9) NOT NULL,
	low NUMERIC(14,9) NOT NULL,
	close NUMERIC(14,9) NOT NULL,
	adj_close NUMERIC(14,9) NOT NULL,
	volume NUMERIC(14,2) NOT NULL,
	currency VARCHAR(5) NOT NULL,
	year INT NOT NULL,
	month INT NOT NULL,
	day INT NOT NULL
);

CREATE TABLE diamond(
	id SERIAL PRIMARY KEY,
	exchange INT REFERENCES exchanges(id),
	open NUMERIC(14,9) NOT NULL,
	high NUMERIC(14,9) NOT NULL,
	low NUMERIC(14,9) NOT NULL,
	close NUMERIC(14,9) NOT NULL,
	adj_close NUMERIC(14,9) NOT NULL,
	volume NUMERIC(14,2) NOT NULL,
	currency INT REFERENCES currencys(id),
	year INT REFERENCES years(id),
	month INT REFERENCES months(id),
	day INT REFERENCES days(id)
);

-- MIGRANDO DA CAMADA GOLD PARA A DIAMOND

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
FROM silver;