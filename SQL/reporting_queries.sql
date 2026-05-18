-- Average wait time by department
SELECT
    d.department_name,
    ROUND(AVG(f.wait_minutes), 2) AS avg_wait_minutes
FROM fact_visits f
JOIN dim_department d 
    ON f.department_key = d.department_key
GROUP BY d.department_name
ORDER BY avg_wait_minutes DESC;

-- Provider workload report
SELECT
    pr.provider_name,
    COUNT(f.visit_id) AS total_visits
FROM fact_visits f
JOIN dim_provider pr 
    ON f.provider_key = pr.provider_key
GROUP BY pr.provider_name
ORDER BY total_visits DESC;

-- Daily patient visit trend
SELECT
    dt.visit_date,
    COUNT(f.visit_id) AS total_visits
FROM fact_visits f
JOIN dim_date dt 
    ON f.date_key = dt.date_key
GROUP BY dt.visit_date
ORDER BY dt.visit_date;

-- Department revenue report
SELECT
    d.department_name,
    SUM(f.total_cost) AS total_revenue,
    ROUND(AVG(f.total_cost), 2) AS average_visit_cost
FROM fact_visits f
JOIN dim_department d 
    ON f.department_key = d.department_key
GROUP BY d.department_name
ORDER BY total_revenue DESC;

-- CTE: visits with long wait times
WITH wait_time_report AS (
    SELECT
        f.visit_id,
        p.patient_name,
        d.department_name,
        pr.provider_name,
        f.wait_minutes
    FROM fact_visits f
    JOIN dim_patient p 
        ON f.patient_key = p.patient_key
    JOIN dim_department d 
        ON f.department_key = d.department_key
    JOIN dim_provider pr 
        ON f.provider_key = pr.provider_key
)
SELECT *
FROM wait_time_report
WHERE wait_minutes > 30
ORDER BY wait_minutes DESC;
