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

CREATE TABLE silver(
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

CREATE TABLE gold(
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

-- MIGRANDO DA CAMADA SILVER PARA A GOLD

INSERT INTO exchanges(exchange)
SELECT DISTINCT(exchange)
FROM silver;

INSERT INTO currencys(currency)
SELECT DISTINCT(currency)
FROM silver;

INSERT INTO years(year)
SELECT DISTINCT(year)
FROM silver;

INSERT INTO months(month)
SELECT DISTINCT(month)
FROM silver
WHERE year IN (SELECT year FROM years);

INSERT INTO days(day)
SELECT DISTINCT day
FROM silver
WHERE year IN (SELECT year FROM years) 
	AND month IN (SELECT month FROM months);

INSERT INTO gold (exchange, open, close, adj_close, high, low, volume, currency, year, month, day)
SELECT 
	(SELECT id FROM exchanges WHERE silver.exchange = exchanges.exchange),
	open, close, adj_close, high, low, volume, 
	(SELECT id FROM currencys WHERE silver.currency = currencys.currency),
	(SELECT id FROM years WHERE silver.year = years.year), 
	(SELECT id FROM months WHERE silver.month = months.month), 
	(SELECT id FROM days WHERE silver.day = days.day)	
FROM silver;