import duckdb

def create_gold():
    # Enriquecimento de dados
    csv_path = "./data_lake/silver/silver.csv"


    duckdb.execute("""
        CREATE TABLE gold AS            
        SELECT * FROM read_csv_auto(?)""", [csv_path])

    duckdb.execute("""
        ALTER TABLE gold
        ADD COLUMN year INT
    """)

    duckdb.execute("""
        ALTER TABLE gold
        ADD COLUMN month INT
    """)

    duckdb.execute("""
        ALTER TABLE gold
        ADD COLUMN day INT
    """)

    duckdb.execute("""
        UPDATE gold
            SET year = EXTRACT(YEAR FROM CAST("Date" AS DATE)),
                month = EXTRACT(MONTH FROM CAST("Date" AS DATE)),
                day = EXTRACT(DAY FROM CAST("Date" AS DATE))
    """)

    duckdb.execute("""
        COPY gold TO './data_lake/gold/gold.csv' (HEADER, DELIMITER ',')
    """)
