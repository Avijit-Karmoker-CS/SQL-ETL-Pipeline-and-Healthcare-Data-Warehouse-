
import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("SUPABASE_DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("SUPABASE_DATABASE_URL is missing. Add it to your .env file.")

engine = create_engine(DATABASE_URL)

queries = {
    "average_wait_by_department": """
        SELECT
            d.department_name,
            ROUND(AVG(f.wait_minutes), 2) AS avg_wait_minutes
        FROM fact_visits f
        JOIN dim_department d 
            ON f.department_key = d.department_key
        GROUP BY d.department_name
        ORDER BY avg_wait_minutes DESC;
    """,

    "provider_workload": """
        SELECT
            pr.provider_name,
            COUNT(f.visit_id) AS total_visits
        FROM fact_visits f
        JOIN dim_provider pr 
            ON f.provider_key = pr.provider_key
        GROUP BY pr.provider_name
        ORDER BY total_visits DESC;
    """,

    "daily_visit_trend": """
        SELECT
            dt.visit_date,
            COUNT(f.visit_id) AS total_visits
        FROM fact_visits f
        JOIN dim_date dt 
            ON f.date_key = dt.date_key
        GROUP BY dt.visit_date
        ORDER BY dt.visit_date;
    """,

    "department_revenue": """
        SELECT
            d.department_name,
            SUM(f.total_cost) AS total_revenue,
            ROUND(AVG(f.total_cost), 2) AS average_visit_cost
        FROM fact_visits f
        JOIN dim_department d 
            ON f.department_key = d.department_key
        GROUP BY d.department_name
        ORDER BY total_revenue DESC;
    """
}

def run_reports():
    os.makedirs("outputs", exist_ok=True)

    for report_name, query in queries.items():
        df = pd.read_sql(query, engine)

        print(f"\n--- {report_name} ---")
        print(df)

        output_path = f"outputs/{report_name}.csv"
        df.to_csv(output_path, index=False)

        print(f"Saved report to {output_path}")

if __name__ == "__main__":
    run_reports()
