import pandas as pd
import duckdb

# Criação das tabelas que estarão no modelo entidade relacionamento

df = pd.read_csv("./data_lake/silver/silver.csv")

duckdb.execute("CREATE TABLE silver AS SELECT * FROM df")

duckdb.execute("""
    CREATE TABLE years AS SELECT DISTINCT(year) FROM silver
""")

duckdb.execute("""
    CREATE TABLE months AS SELECT DISTINCT(month) FROM silver
""")

duckdb.execute("""
    CREATE TABLE days AS SELECT DISTINCT(day) FROM silver
""")

duckdb.execute("""
    CREATE TABLE currencys AS SELECT DISTINCT(currency) FROM silver
""")

duckdb.execute("""
    CREATE TABLE exchanges AS SELECT DISTINCT(Index) FROM silver
""")

years = duckdb.execute("SELECT * FROM years").fetchdf()

months = duckdb.execute("SELECT * FROM months").fetchdf()

days = duckdb.execute("SELECT * FROM days").fetchdf()

currencys = duckdb.execute("SELECT * FROM currencys").fetchdf()

exchanges = duckdb.execute("SELECT * FROM exchanges").fetchdf()

print(years.value_counts())
print(months.value_counts())
print(days.value_counts())
print(currencys.value_counts())
print(exchanges.value_counts())

# exportação dessas tabelas como csv

duckdb.execute("""
    COPY years TO './data_lake/gold/years.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY months TO './data_lake/gold/months.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY days TO './data_lake/gold/days.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY currencys TO './data_lake/gold/currencys.csv' (HEADER, DELIMITER ',')
""")

duckdb.execute("""
    COPY exchanges TO './data_lake/gold/exchanges.csv' (HEADER, DELIMITER ',')
""")

""" 
Dado que o duckdb é orientado a colunas,
optou-se por fazer o resto da criação da
camada gold usando postgreSQL
"""