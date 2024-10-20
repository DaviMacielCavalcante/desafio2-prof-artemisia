-- APLICANDO O STAR SCHEMA

-- CREATE TABLE symbols(
-- 	id_symbol SERIAL PRIMARY KEY,
-- 	symbol VARCHAR(20) UNIQUE NOT NULL
-- );

-- CREATE TABLE years(
-- 	id_year SERIAL PRIMARY KEY,
-- 	year INT UNIQUE NOT NULL 
-- );

-- CREATE TABLE months(
-- 	id_month SERIAL PRIMARY KEY,
-- 	month INT UNIQUE NOT NULL
-- );

-- CREATE TABLE days(
-- 	id_day SERIAL PRIMARY KEY,
-- 	day INT UNIQUE NOT NULL
-- );

-- CREATE TABLE days_of_week (
--  	id_day_of_week SERIAL PRIMARY KEY,
-- 	day_of_week VARCHAR(10) UNIQUE NOT NULL
-- );

-- CREATE TABLE hours(
-- 	id_hour SERIAL PRIMARY KEY,
-- 	hour INT UNIQUE NOT NULL
-- );

-- INSERT INTO symbols(symbol)
-- SELECT DISTINCT(crypto_symbol)
-- FROM cryptos_silver;

-- INSERT INTO years(year)
-- SELECT DISTINCT(year)
-- FROM cryptos_silver;

-- INSERT INTO months(month)
-- SELECT DISTINCT month
-- FROM cryptos_silver
-- WHERE year IN (SELECT year FROM years);

-- INSERT INTO days(day)
-- SELECT DISTINCT day
-- FROM cryptos_silver
-- WHERE year IN (SELECT year FROM years) 
-- 	AND month IN (SELECT month FROM months);

-- INSERT INTO days_of_week(day_of_week)
-- SELECT DISTINCT day_of_week
-- FROM cryptos_silver;

-- INSERT INTO hours(hour)
-- SELECT DISTINCT hour
-- FROM cryptos_silver;

-- CREATE TABLE crypto_diamond(
-- 	id BIGSERIAL PRIMARY KEY,
-- 	time_hours TIME NOT NULL,
-- 	hour INT NOT NULL REFERENCES hours(id_hour),	
-- 	day_of_week INT NOT NULL REFERENCES days_of_week(id_day_of_week),
-- 	day INT NOT NULL REFERENCES days(id_day),
-- 	month INT NOT NULL REFERENCES months(id_month),
-- 	year INT NOT NULL REFERENCES years(id_year),
-- 	open NUMERIC(30, 14) NOT NULL,
-- 	close NUMERIC(30, 14) NOT NULL,
-- 	high NUMERIC(30, 14) NOT NULL,
-- 	low NUMERIC(30, 14) NOT NULL,
-- 	volume NUMERIC(30, 14) NOT NULL,
-- 	crypto_symbol INT NOT NULL REFERENCES symbols(id_symbol)
-- );

-- MIGRANDO DA CAMADA SILVER PARA A DIAMOND

-- INSERT INTO crypto_diamond (time_hours, hour, day_of_week, day, month, year, open, close, high, low, volume, crypto_symbol)
-- SELECT TO_CHAR(time, 'HH24:MI:SS')::TIME, 
-- 	(SELECT id_hour FROM hours WHERE cryptos_silver.hour = hours.hour), 
-- 	(SELECT id_day_of_week FROM days_of_week WHERE cryptos_silver.day_of_week = days_of_week.day_of_week), 
-- 	(SELECT id_day FROM days WHERE cryptos_silver.day = days.day), 
-- 	(SELECT id_month FROM months WHERE cryptos_silver.month = months.month), 
-- 	(SELECT id_year FROM years WHERE cryptos_silver.year = years.year), 
-- 	open, close, high, low, volume, 
-- 	(SELECT id_symbol FROM symbols WHERE cryptos_silver.crypto_symbol = symbols.symbol)
-- FROM cryptos_silver;