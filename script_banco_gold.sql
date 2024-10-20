-- APLICANDO O MODELO RELACIONAL

CREATE TABLE symbols(
	id_symbol VARCHAR(20) PRIMARY KEY
);

INSERT INTO symbols(id_symbol)
SELECT DISTINCT(crypto_symbol)
FROM cryptos_silver;

SELECT *
FROM symbols 
LIMIT 10;

CREATE TABLE years(
	year INT PRIMARY KEY
);

INSERT INTO years(year)
SELECT DISTINCT(year)
FROM cryptos_silver;

SELECT * 
FROM years;

CREATE TABLE months(
	month INT PRIMARY KEY
);

INSERT INTO months(month)
SELECT DISTINCT month
FROM cryptos_silver
WHERE year IN (SELECT year FROM years);

CREATE TABLE days(
	day INT PRIMARY KEY
);

INSERT INTO days(day)
SELECT DISTINCT day
FROM cryptos_silver
WHERE year IN (SELECT year FROM years) 
	AND month IN (SELECT month FROM months);

CREATE TABLE days_of_week (
 		day_of_week VARCHAR(10) PRIMARY KEY
);

INSERT INTO days_of_week(day_of_week)
SELECT DISTINCT day_of_week
FROM cryptos_silver;

CREATE TABLE hours(
	hour INT PRIMARY KEY
);

INSERT INTO hours(hour)
SELECT DISTINCT hour
FROM cryptos_silver;

CREATE TABLE crypto_gold(
	id BIGSERIAL PRIMARY KEY,
	time_hours TIME NOT NULL,
	hour INT NOT NULL REFERENCES hours(hour),	
	day_of_week VARCHAR(10) NOT NULL REFERENCES days_of_week(day_of_week),
	day INT NOT NULL REFERENCES days(day),
	month INT NOT NULL REFERENCES months(month),
	year INT NOT NULL REFERENCES years(year),
	open NUMERIC(30, 14) NOT NULL,
	close NUMERIC(30, 14) NOT NULL,
	high NUMERIC(30, 14) NOT NULL,
	low NUMERIC(30, 14) NOT NULL,
	volume NUMERIC(30, 14) NOT NULL,
	crypto_symbol VARCHAR(20) NOT NULL REFERENCES symbols(id_symbol)
);

-- MIGRANDO DA CAMADA SILVER PARA A GOLD

INSERT INTO crypto_gold (time_hours, hour, day_of_week, day, month, year, open, close, high, low, volume, crypto_symbol)
SELECT TO_CHAR(time, 'HH24:MI:SS')::TIME, hour, day_of_week, day, month, year, open, close, high, low, volume, crypto_symbol
FROM cryptos_silver
WHERE hour IN (SELECT hour FROM hours) AND
	day_of_week IN (SELECT day_of_week FROM days_of_week) AND
	day IN (SELECT day FROM days) AND
	month IN (SELECT month FROM months) AND
	year IN (SELECT year FROM years) AND
	crypto_symbol IN (SELECT id_symbol FROM symbols);