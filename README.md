## ETL pipeline with Airflow
This project was created to practice using data tools.

**Examine data before creating a piplein and create a table:**
- Download file in CSV format from source
- Examine data in Jupyter using Pandas and define datatypes
- Connect ot remote PostgreSQL database and create table

**Create ETL pipline in Airflow with the following tasks:**
- Download file in CSV format from source
- Convert CSV format to parquet
- Upload data from parquet file to remote PostgreSQL database

PostgreSQL on Heroku is used as a database
Airflow is set up to run the pipeline onece daily

**Suggestions and further steps:**
- Use cloud storage for raw data and database
- Use dbt to further transform, test and prepare data for analysis
- Analyse and visualize data