# SQL ETL Pipeline and Healthcare Data Warehouse

## Overview
This project demonstrates a cloud-based healthcare ETL pipeline using Supabase PostgreSQL, SQL, Python, and star-schema data warehouse design.

Raw patient visit data was uploaded as a CSV file into Supabase. The data was cleaned, transformed into staging tables, loaded into dimension and fact tables, and queried for healthcare operational reporting.

## Tools Used
- Supabase PostgreSQL
- SQL
- Python
- Pandas
- SQLAlchemy
- GitHub
- CSV data ingestion

## ETL Workflow
1. Uploaded raw patient visit CSV into Supabase.
2. Created a clean staging table from the raw CSV table.
3. Designed a star-schema warehouse.
4. Loaded data into dimension tables and fact table.
5. Created SQL reports for wait time, provider workload, visit trends, and department revenue.
6. Used Python to connect to Supabase and export reports as CSV files.

## Star Schema Tables
- dim_patient
- dim_department
- dim_provider
- dim_date
- fact_visits

## Reports
- Average wait time by department
- Provider workload
- Daily patient visit trend
- Department revenue
- Long wait-time visits using CTE

## How to Run
Run the SQL files in Supabase SQL Editor in this order:

1. sql/01_create_clean_staging.sql
2. sql/02_create_star_schema.sql
3. sql/03_load_star_schema.sql
4. sql/04_reporting_queries.sql

To run Python reports:

```bash
pip install -r requirements.txt
python python/run_supabase_reports.py
