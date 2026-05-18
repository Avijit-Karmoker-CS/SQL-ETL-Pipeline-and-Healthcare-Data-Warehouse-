CREATE TABLE IF NOT EXISTS staging_patient_visits_clean AS
SELECT
    CAST(visit_id AS INT) AS visit_id,
    CAST(patient_id AS INT) AS patient_id,
    TRIM(patient_name) AS patient_name,
    CAST(age AS INT) AS age,
    TRIM(gender) AS gender,
    TRIM(department) AS department,
    TRIM(provider_name) AS provider_name,
    CAST(visit_date AS DATE) AS visit_date,
    CAST(arrival_time AS TIME) AS arrival_time,
    CAST(seen_time AS TIME) AS seen_time,
    CAST(discharge_time AS TIME) AS discharge_time,
    TRIM(diagnosis) AS diagnosis,
    CAST(total_cost AS NUMERIC(10,2)) AS total_cost
FROM raw_patient_visits
WHERE visit_id IS NOT NULL
  AND patient_id IS NOT NULL
  AND visit_date IS NOT NULL;

ALTER TABLE staging_patient_visits_clean ENABLE ROW LEVEL SECURITY;
