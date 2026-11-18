# Databricks notebook source
%md
# Ingest circuits.csv file
1. Read the file using spark dataframe reader API
2. Add Metadata Columns 
    - Source File
    - Ingestion Timestamp
3. Write to bronze delta table    

# COMMAND ----------

 %run ../00-common/01.environment-config

# COMMAND ----------

 %run ../00-common/02.bronze-helpers

# COMMAND ----------

source_file = f"{landing_folder_path}/circuits.csv"
table_name = f"{catalog_name}.{bronze_schema}.circuits"

# COMMAND ----------

 %md
 #### Step 1 - Read the CSV file using the dataframe reader API

# COMMAND ----------

from pyspark.sql.types import StructType, StructField, StringType, DoubleType

circuits_schema = StructType([
    StructField('circuitId',   StringType()),
    StructField("url",         StringType()),
    StructField("circuitName", StringType()),
    StructField("lat",         DoubleType()),
    StructField("long",        DoubleType()),
    StructField("locality",    StringType()),
    StructField("country",     StringType())
])

# COMMAND ----------

circuits_df = (
    spark.read
         .format('csv')
         .option('header', 'true')
#         .option('inferSchema', 'true')
         .option('mode', 'FAILFAST')
         .schema(circuits_schema)
         .load(source_file)
)

# COMMAND ----------

display(circuits_df)

# COMMAND ----------

 %md
 #### Step 2 - Add Metadata Columns
 - Source File
 - Ingestion Timestamp

# COMMAND ----------

circuits_final_df = add_ingestion_metadata(circuits_df)

# COMMAND ----------

display(circuits_final_df)

# COMMAND ----------

 %md
 #### Step 3 - Write to bronze delta table

# COMMAND ----------

(
    circuits_final_df
        .write
        .format('delta')
        .mode('overwrite')
        .saveAsTable(table_name)
)

# COMMAND ----------

display(spark.table(table_name))

# COMMAND ----------

display(spark.table('formula1.bronze.circuits'))