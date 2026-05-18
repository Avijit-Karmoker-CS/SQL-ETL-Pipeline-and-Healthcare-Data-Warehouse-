CREATE TABLE IF NOT EXISTS dim_patient (
    patient_key BIGSERIAL PRIMARY KEY,
    patient_id INT UNIQUE,
    patient_name TEXT,
    age INT,
    gender TEXT
);

ALTER TABLE dim_patient ENABLE ROW LEVEL SECURITY;


CREATE TABLE IF NOT EXISTS dim_department (
    department_key BIGSERIAL PRIMARY KEY,
    department_name TEXT UNIQUE
);

ALTER TABLE dim_department ENABLE ROW LEVEL SECURITY;


CREATE TABLE IF NOT EXISTS dim_provider (
    provider_key BIGSERIAL PRIMARY KEY,
    provider_name TEXT UNIQUE
);

ALTER TABLE dim_provider ENABLE ROW LEVEL SECURITY;


CREATE TABLE IF NOT EXISTS dim_date (
    date_key BIGSERIAL PRIMARY KEY,
    visit_date DATE UNIQUE,
    year INT,
    month INT,
    day INT
);

ALTER TABLE dim_date ENABLE ROW LEVEL SECURITY;


CREATE TABLE IF NOT EXISTS fact_visits (
    visit_key BIGSERIAL PRIMARY KEY,
    visit_id INT UNIQUE,
    patient_key BIGINT REFERENCES dim_patient(patient_key),
    department_key BIGINT REFERENCES dim_department(department_key),
    provider_key BIGINT REFERENCES dim_provider(provider_key),
    date_key BIGINT REFERENCES dim_date(date_key),
    diagnosis TEXT,
    wait_minutes INT,
    length_of_stay_minutes INT,
    total_cost NUMERIC(10,2)
);

ALTER TABLE fact_visits ENABLE ROW LEVEL SECURITY;
