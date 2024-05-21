use medical_db;
SELECT
    patient_id,
    gender,
    marital_status,
    age,
    bmi_value,
    qaly_value,
    coronary_heart_disease,
    diabetes,
    CASE
        WHEN age <> 0 THEN qaly_value / age
        ELSE NULL  -- Handle division by zero if age is zero
    END AS HRQL
FROM
    (
        SELECT
            p.patient AS patient_id,
            p.gender AS gender,
            p.marital AS marital_status,
            TIMESTAMPDIFF(YEAR, p.birthdate, LEAST('2017-12-31', COALESCE(p.deathdate, '2017-12-31'))) AS age,
            COALESCE(o1.value, 0) AS bmi_value,
            COALESCE(o2.value, 0) AS qaly_value,
            CASE WHEN c1.description = 'Coronary Heart Disease' THEN 1 ELSE 0 END AS coronary_heart_disease,
            CASE WHEN c2.description = 'Diabetes' THEN 1 ELSE 0 END AS diabetes
        FROM
            patients p
        LEFT JOIN
            observations o1 ON p.patient = o1.patient
            AND o1.description = 'Body Mass Index'
        LEFT JOIN
            observations o2 ON p.patient = o2.patient
            AND o2.description = 'Quality adjusted life years'
        LEFT JOIN
            conditions c1 ON p.patient = c1.patient
            AND c1.description = 'Coronary Heart Disease'
        LEFT JOIN
            conditions c2 ON p.patient = c2.patient
            AND c2.description = 'Diabetes'
        WHERE
            o1.description IS NOT NULL OR o2.description IS NOT NULL
            OR c1.description IS NOT NULL OR c2.description IS NOT NULL
    ) AS summary_table;
