import pandas as pd
import duckdb

# Criação da camada silver

df = pd.read_csv("./datasets/indexData.csv")

duckdb.execute("CREATE TABLE raw AS SELECT * FROM df")

duckdb.execute("ALTER TABLE raw ADD COLUMN currency VARCHAR(5)")

duckdb.execute("""
    UPDATE raw 
        SET currency = CASE
        WHEN "Index" = 'NYA' THEN 'USD'
        WHEN "Index" = 'IXIC' THEN 'USD'
        WHEN "Index" = 'HSI' THEN 'HKD'
        WHEN "Index" = '000001.SS' THEN 'CNY'
        WHEN "Index" = 'N225' THEN 'JPY'
        WHEN "Index" = 'N100' THEN 'EUR'
        WHEN "Index" = '399001.SZ' THEN 'CNY'
        WHEN "Index" = 'GSPTSE' THEN 'CAD'
        WHEN "Index" = 'NSEI' THEN 'INR'
        WHEN "Index" = 'GDAXI' THEN 'EUR'
        WHEN "Index" = 'KS11' THEN 'KRW'
        WHEN "Index" = 'SSMI' THEN 'CHF'
        WHEN "Index" = 'TWII' THEN 'TWD'
        WHEN "Index" = 'J203.JO' THEN 'ZAR'
        ELSE '-'
        END """)

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

# Enriquecendo os dados da camada silver

duckdb.execute("""
    ALTER TABLE silver
    ADD COLUMN year INT
""")

duckdb.execute("""
    ALTER TABLE silver
    ADD COLUMN month INT
""")

duckdb.execute("""
    ALTER TABLE silver
    ADD COLUMN day INT
""")

duckdb.execute("""
    UPDATE silver
        SET year = EXTRACT(YEAR FROM CAST("Date" AS DATE)),
            month = EXTRACT(MONTH FROM CAST("Date" AS DATE)),
            day = EXTRACT(DAY FROM CAST("Date" AS DATE))
""")

# Como o arquivo não é grande, exportei como csv

duckdb.execute("""
    COPY silver TO './data_lake/silver/silver.csv' (HEADER, DELIMITER ',')
""")
