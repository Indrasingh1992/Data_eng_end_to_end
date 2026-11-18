-- Databricks notebook source
%md
# Set-up the project environment for Formula1 Project


1. Create External Location databricks-course-ext-dl1-formula1
1. Create Catalog formula1
1. Create Schemas landing, bronze, silver and gold
1. Create Volume Files in the landing schema

-- COMMAND ----------

%md
### Access Cloud Storage

-- COMMAND ----------

%fs ls 'abfss://formula1@stgadbext.dfs.core.windows.net/landing'

-- COMMAND ----------

%md
### Create External Location

-- COMMAND ----------

CREATE EXTERNAL LOCATION IF NOT EXISTS databricks_course_ext_dl1_formula1
URL 'abfss://formula1@stgadbext.dfs.core.windows.net/'
WITH (STORAGE CREDENTIAL `acc_conn`)
COMMENT 'External location for the formula1 container';

-- COMMAND ----------

%md
### Create Catalog formula1

-- COMMAND ----------

SHOW CATALOGS;

-- COMMAND ----------

CREATE CATALOG IF NOT EXISTS formula1
   MANAGED LOCATION 'abfss://formula1@stgadbext.dfs.core.windows.net/' 
   COMMENT 'This is the main catalog for the formula1 project' ;

-- COMMAND ----------

%md
### Create Schemas landing, bronze, silver, gold

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS formula1.landing;
CREATE SCHEMA IF NOT EXISTS formula1.bronze
    MANAGED LOCATION 'abfss://formula1@stgadbext.dfs.core.windows.net/bronze';
CREATE SCHEMA IF NOT EXISTS formula1.silver
    MANAGED LOCATION 'abfss://formula1@stgadbext.dfs.core.windows.net/silver';
CREATE SCHEMA IF NOT EXISTS formula1.gold
    MANAGED LOCATION 'abfss://formula1@stgadbext.dfs.core.windows.net/gold';         

-- COMMAND ----------

SELECT current_catalog();

-- COMMAND ----------

USE CATALOG formula1;

-- COMMAND ----------

SHOW SCHEMAS;

-- COMMAND ----------

%md
### Create Volume Files

-- COMMAND ----------

CREATE EXTERNAL VOLUME formula1.landing.files
LOCATION 'abfss://formula1@stgadbext.dfs.core.windows.net/landing';

-- COMMAND ----------

%fs ls /Volumes/formula1/landing/files