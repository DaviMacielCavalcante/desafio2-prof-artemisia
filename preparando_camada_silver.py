import pandas as pd
import duckdb

csv_path = "./data_lake/raw/raw.csv"

# Criação da camada silver

duckdb.execute("""
    CREATE TABLE raw AS            
    SELECT * FROM read_csv_auto(?)""", [csv_path])

duckdb.execute("ALTER TABLE raw ADD COLUMN currency VARCHAR(5)")

exchanges_to_currency = {
    "NYA": "USD",
    "IXIC": "USD",
    "HSI": "HKD",
    "000001.SS": "CNY",
    "N225": "JPY",
    "N100": "EUR",
    "399001.SZ": "CNY",
    "GSPTSE": "CAD",
    "NSEI": "INR",
    "GDAXI": "EUR",
    "KS11": "KRW",
    "SSMI": "CHF",
    "TWII": "TWD",
    "J203.JO": "ZAR"
}

for exchange, currency in exchanges_to_currency.items():
    duckdb.execute("""
    UPDATE raw 
        SET currency = ?
        WHERE "Index" = ? 
    """, [currency, exchange])


## Procurando valores duplicados ou nulos

duckdb.execute("""
    CREATE TABLE silver AS 
    SELECT * FROM raw 
    WHERE "Index" IS NOT NULL AND TRIM("Index") NOT IN ('', ' ', 'null') AND
          "Date" IS NOT NULL AND
          "Open" IS NOT NULL AND TRIM("Open") NOT IN ('', ' ', 'null') AND
          "High" IS NOT NULL AND TRIM("High") NOT IN ('', ' ', 'null') AND
          "Low" IS NOT NULL AND TRIM("Low") NOT IN ('', ' ', 'null') AND
          "Close" IS NOT NULL AND TRIM("Close") NOT IN ('', ' ', 'null') AND
          "Adj Close" IS NOT NULL AND TRIM("Adj Close") NOT IN ('', ' ', 'null') AND
          "Volume" IS NOT NULL AND TRIM("Volume") NOT IN ('', ' ', 'null') AND
          "currency" IS NOT NULL AND TRIM("currency") NOT IN ('', ' ', 'null');
""")



# Como o arquivo não é grande, exportei como csv

duckdb.execute("""
    COPY silver TO './data_lake/silver/silver.csv' (HEADER, DELIMITER ',')
""")
