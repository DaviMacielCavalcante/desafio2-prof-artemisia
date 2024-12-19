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

duplicates = duckdb.execute("""
    SELECT *, COUNT(*)
    FROM raw
    GROUP BY "Index", "Date", "Open", "High", "Low", "Close", "Adj Close", "Volume", "currency"
    HAVING COUNT(*) > 1
""").fetchdf()

null_rows = duckdb.execute("""
    SELECT COUNT(*)
    FROM raw
    WHERE "Index" IS NULL OR
        "Date" IS NULL OR 
        "Open" IS NULL OR
        "High" IS NULL OR
        "Low" IS NULL OR
        "Close" IS NULL OR
        "Adj Close" IS NULL OR
        "Volume" IS NULL OR 
        "currency" IS NULL
""").fetchdf()

duckdb.execute("""
        CREATE TABLE silver AS 
        SELECT * FROM raw WHERE "Index" NOT NULL AND
        "Date" NOT NULL AND 
        "Open" NOT NULL AND
        "High" NOT NULL AND
        "Low" NOT NULL AND
        "Close" NOT NULL AND
        "Adj Close" NOT NULL AND
        "Volume" NOT NULL AND 
        "currency" NOT NULL
""")

null_rows_silver = duckdb.execute("""
    SELECT COUNT(*)
    FROM silver
    WHERE "Index" IS NULL OR
        "Date" IS NULL OR 
        "Open" IS NULL OR
        "High" IS NULL OR
        "Low" IS NULL OR
        "Close" IS NULL OR
        "Adj Close" IS NULL OR
        "Volume" IS NULL OR 
        "currency" IS NULL
""").fetchdf()

count_rows_silver = duckdb.execute("""
    SELECT COUNT(*)
    FROM silver
""").fetch_df()

# Como o arquivo não é grande, exportei como csv

duckdb.execute("""
    COPY silver TO './data_lake/silver/silver.csv' (HEADER, DELIMITER ',')
""")
