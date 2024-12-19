import duckdb

# Criação das tabelas que estarão no modelo entidade relacionamento
csv_path = "./data_lake/gold/gold.csv"


duckdb.execute("""
    CREATE TABLE diamond AS            
    SELECT * FROM read_csv_auto(?)""", [csv_path])


duckdb.execute("""
    CREATE TABLE years AS SELECT DISTINCT(year) FROM diamond
""")

duckdb.execute("""
    CREATE TABLE months AS SELECT DISTINCT(month) FROM diamond
""")

duckdb.execute("""
    CREATE TABLE days AS SELECT DISTINCT(day) FROM diamond
""")

duckdb.execute("""
    CREATE TABLE currencys AS SELECT DISTINCT(currency) FROM diamond
""")

duckdb.execute("""
    CREATE TABLE exchanges AS SELECT DISTINCT(Index) FROM diamond
""")

# exportação dessas tabelas como csv

duckdb.execute("""
    COPY years TO './data_lake/diamond/years.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY months TO './data_lake/diamond/months.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY days TO './data_lake/diamond/days.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY currencys TO './data_lake/diamond/currencys.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY exchanges TO './data_lake/diamond/exchanges.csv' (HEADER, DELIMITER ',')
""")