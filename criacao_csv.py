import os
import pandas as pd
from pyspark.sql import SparkSession

diretorio = './datasets'

for arch in os.listdir(diretorio):
    if arch.endswith('.csv'):
        arch_path = os.path.join(diretorio, arch)
        df = pd.read_csv(arch_path)
        df['crypto_name'] = os.path.splitext(arch)[0]

        if "Unnamed: 0" in df.columns:
            df.drop(columns="Unnamed: 0", inplace=True)
        df.to_csv(f"./teste/{arch}", index=False)

spark = SparkSession.builder.appName("Combine csv").master("local[*]").getOrCreate()

csvs_path = "./teste/*.csv"

df = spark.read.csv(csvs_path, header=True, inferSchema=True)

df.repartition(1).write.csv("./combinado", header=True, mode="overwrite")

df.printSchema()

df.show(5)

spark.stop()




