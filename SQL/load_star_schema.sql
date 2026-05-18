INSERT INTO dim_patient (
    patient_id,
    patient_name,
    age,
    gender
)
SELECT DISTINCT
    patient_id,
    patient_name,
    age,
    gender
FROM staging_patient_visits_clean
ON CONFLICT (patient_id) DO NOTHING;

INSERT INTO dim_department (
    department_name
)
SELECT DISTINCT
    department
FROM staging_patient_visits_clean
ON CONFLICT (department_name) DO NOTHING;

INSERT INTO dim_provider (
    provider_name
)
SELECT DISTINCT
    provider_name
FROM staging_patient_visits_clean
ON CONFLICT (provider_name) DO NOTHING;

INSERT INTO dim_date (
    visit_date,
    year,
    month,
    day
)
SELECT DISTINCT
    visit_date,
    EXTRACT(YEAR FROM visit_date)::INT,
    EXTRACT(MONTH FROM visit_date)::INT,
    EXTRACT(DAY FROM visit_date)::INT
FROM staging_patient_visits_clean
ON CONFLICT (visit_date) DO NOTHING;

INSERT INTO fact_visits (
    visit_id,
    patient_key,
    department_key,
    provider_key,
    date_key,
    diagnosis,
    wait_minutes,
    length_of_stay_minutes,
    total_cost
)
SELECT
    s.visit_id,
    p.patient_key,
    d.department_key,
    pr.provider_key,
    dt.date_key,
    s.diagnosis,
    EXTRACT(EPOCH FROM (s.seen_time - s.arrival_time)) / 60 AS wait_minutes,
    EXTRACT(EPOCH FROM (s.discharge_time - s.arrival_time)) / 60 AS length_of_stay_minutes,
    s.total_cost
FROM staging_patient_visits_clean s
JOIN dim_patient p 
    ON s.patient_id = p.patient_id
JOIN dim_department d 
    ON s.department = d.department_name
JOIN dim_provider pr 
    ON s.provider_name = pr.provider_name
JOIN dim_date dt 
    ON s.visit_date = dt.visit_date
ON CONFLICT (visit_id) DO NOTHING;
