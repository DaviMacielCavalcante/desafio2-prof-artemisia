import duckdb
import os
from sqlalchemy import create_engine

# Criação das tabelas que estarão no modelo entidade relacionamento
csv_path = "./data_lake/gold/gold.csv"

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)
script_ddl_path = "./sql/DDL/ddl_diamond.sql"
script_dml_path = "./sql/DML/dml_diamond.sql"

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

with open(script_ddl_path, "r") as f:
    script_ddl = f.read()
    
with engine.connect() as conn:
    conn.begin()
    for statement in script_ddl.split(";"):  # Dividindo os comandos SQL
        statement = statement.strip()
        if statement:  # Ignorar comandos vazios
            print(f"Executing: {statement}")
            conn.exec_driver_sql(statement)
    conn.commit()

conn = engine.raw_connection()  # Obtém a conexão bruta
try:
    cursor = conn.cursor()
    with open(csv_path, 'r') as f:  # Abre o arquivo CSV
        cursor.copy_expert(f"COPY gold(exchange, date, open, high, low, close, adj_close, volume, currency, year, month, day) FROM STDIN WITH CSV HEADER", f)  # Executa o comando COPY
    conn.commit()  # Confirma a transação
finally:
    conn.close()  # Fecha a conexão bruta

with open(script_dml_path, "r") as f:
    script_dml = f.read()

with engine.connect() as conn:
    conn.begin()
    for statement in script_dml.split(";"):  # Dividindo os comandos SQL
        statement = statement.strip()
        if statement:  # Ignorar comandos vazios
            print(f"Executing: {statement}")
            conn.exec_driver_sql(statement)
    conn.commit()