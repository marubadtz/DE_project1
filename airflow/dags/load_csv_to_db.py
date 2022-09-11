# import the libraries
import os
import logging
from datetime import timedelta

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG
# Operators; we need this to write tasks!
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
# This makes scheduling easy
from airflow.utils.dates import days_ago

import pyarrow.csv as pv
import pyarrow.parquet as pq
import pandas as pd
from sqlalchemy import create_engine

from dotenv import load_dotenv

load_dotenv(find_dotenv())

DATABASE_URL = os.getenv('DATABASE_URL')


dataset_url = "https://ct-deep-gis-open-data-website-ctdeep.hub.arcgis.com/datasets/CTDEEP::eelgrass-beds-2006-polygon.csv"
dataset_file = "extracted_{{ execution_date.strftime(\'%Y_%m\') }}.csv"
parquet_file = dataset_file.replace('.csv', '.parquet')
path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
clear_file = path_to_local_home +'/fire_incidents_*'

def format_to_parquet(src_file):
    if not src_file.endswith('.csv'):
        logging.error("Can only accept source files in CSV format, for the moment")
        return
    table = pv.read_csv(src_file)
    pq.write_table(table, src_file.replace('.csv', '.parquet'))

def upload_to_postgres(src_file, DATABASE_URL):
    src_file = src_file.replace('.csv', '.parquet')

    df = pd.read_parquet(src_file)

    DATABASE_URL = DATABASE_URL.replace('postgres:', 'postgresql:') # sqlalchemy doesnt work otherwise
    engine=create_engine(DATABASE_URL)

    df.to_sql(name='extracted_data', con=engine, if_exists='append')

    engine.dispose()

#defining DAG arguments
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'marubadtz',
    'start_date': days_ago(0),
    'email': ['maru@badtz.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

# defining the DAG

# define the DAG
dag = DAG(
    'load_csv_to_db',
    default_args=default_args,
    description='My simple DAG',
    schedule_interval=timedelta(days=1),
)

# define the tasks

# define the first task

extract = BashOperator(
    task_id='extract',
    bash_command=f'curl {dataset_url} --output /opt/airflow/data/{dataset_file}',
    dag=dag,
)

'''
# define the second task
transform_and_load = BashOperator(
    task_id='transform',
    bash_command=f'tr ":" "," < /opt/airflow/data/{dataset_file} > /opt/airflow/data/transformed-data.csv',
    dag=dag,
)
'''

# convert to parquet
format_to_parquet_task = PythonOperator(
    task_id="format_to_parquet",
    python_callable=format_to_parquet,
    op_kwargs={
        "src_file": f"{path_to_local_home}/data/{dataset_file}",
    },
    dag=dag,
)

# upload to postgres
upload_to_postgres_task = PythonOperator(
    task_id="upload_to_postgres",
    python_callable=upload_to_postgres,
    op_kwargs={
        "src_file": f"{path_to_local_home}/data/{dataset_file}",
        "DATABASE_URL": f"{DATABASE_URL}",
    },
    dag=dag,
)

# task pipeline
extract >> format_to_parquet_task >> upload_to_postgres_task