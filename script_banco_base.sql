-- Criação da tabela para representar a camada raw do data lake
CREATE TABLE cryptos_raw(
	id BIGSERIAL PRIMARY KEY,
	time BIGINT NOT NULL,
	open DOUBLE PRECISION NOT NULL,
	close DOUBLE PRECISION NOT NULL,
	high DOUBLE PRECISION NOT NULL,
	low DOUBLE PRECISION NOT NULL,
	volume DOUBLE PRECISION NOT NULL,
	crypto_name VARCHAR(30) NOT NULL
);

-- Criação da tabela para representar a camada silver do data lake
CREATE TABLE cryptos_silver(
	id BIGSERIAL PRIMARY KEY,
	time BIGINT NOT NULL,
	open DOUBLE PRECISION NOT NULL,
	close DOUBLE PRECISION NOT NULL,
	high DOUBLE PRECISION NOT NULL,
	low DOUBLE PRECISION NOT NULL,
	volume DOUBLE PRECISION NOT NULL,
	crypto_name VARCHAR(30) NOT NULL	
);

-- Copiando os dados para que possam ser tratados na camada silver, sem perder os originais

INSERT INTO cryptos_silver (time, open, close, high, low, volume, crypto_name)
SELECT time, open, close, high, low, volume, crypto_name 
FROM cryptos_raw;

