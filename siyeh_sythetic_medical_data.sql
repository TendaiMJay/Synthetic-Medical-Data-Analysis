use medical_db;
-- Cleaning Dataset
/* Changing data type to datatime */

UPDATE observations
SET value = 0
WHERE patient = 'efaf74f9-3de3-45dd-a5d5-26d08e8a3190'
    AND description = 'Quality adjusted life years';


SELECT 
    COLUMN_NAME, data_type
FROM
    information_schema.columns
WHERE
    TABLE_SCHEMA = 'medical_db'
        AND TABLE_NAME = 'patients'
        AND COLUMN_NAME = 'deathdate';

UPDATE patients
SET deathdate = STR_TO_DATE(deathdate, '%Y-%m-%d')
WHERE deathdate IS NOT NULL AND deathdate != '';

UPDATE patients
SET deathdate = NULL
WHERE deathdate = '';

ALTER TABLE patients
MODIFY COLUMN deathdate DATE;

/* Checking for OUTLIERS, missing or wrong information*/
SELECT * FROM procedures;
UPDATE procedures
SET reasoncode = NULLIF(reasoncode, ''),
    reasondescription = NULLIF(reasondescription, '')
WHERE reasoncode = '' OR reasondescription = '';

SELECT * FROM `medical_db`.`all_prevalences`;
ALTER TABLE `medical_db`.`all_prevalences`
RENAME COLUMN`PREVALENCE PERCENTAGE` to PREVALENCE_PERCENTAGE;

SELECT PATIENT, start FROM allergies; 
UPDATE allegies
SET start = '2023-01-12'
WHERE patient = 'f12b31fa-02ff-4c7e-b49b-597b9a4a7d6b';

-- 1 Cleaning observations
SELECT * FROM observations; 
SELECT observations.patient,
       observations.description,
       CAST(observations.value AS DECIMAL) AS New_Value,
       observations.units
  FROM observations
 WHERE observations.description = "Body Mass Index"
 OR observations.description = "Body Weight"
 OR observations.description = "Body Height";
 SELECT * FROM observations_cleaned;
 
-- 2 Check when patients' medical conditions started and ended
SELECT conditions.start,
       conditions.stop,
       conditions.description AS conditions
  FROM conditions;
  
  -- 3 How many allergies do we have recorded by patients
  SELECT DISTINCT allergies.description
  FROM allergies;
  
  -- 4 Retrieve the first 100 patients from the immunizations table.
 SELECT 
    *
FROM
    immunizations
LIMIT 100;

 -- 5 Retrieve all information on patients with an allergy to mould
 SELECT *
  FROM allergies
 WHERE allergies.description = "Allergy to mould";
 
 -- 6 Show all prevalent disorders/diseases that have an occurance of over 10% or 100 in the population that do not have the word Mg in the middle or the end
 SELECT DISTINCT item
  FROM all_prevalences
 WHERE all_prevalences.occurrences > 200
 AND item NOT LIKE '% Mg%';
 
 -- 7 Retrieve all appointments where patients's body weights where observed from smalled to largest (by ascending) 'Body Weight'
 SELECT *
  FROM observations
 WHERE observations.description = "Body Weight"
 ORDER BY observations.value;
 
 -- 8 Retrieve all appointments where patients's body Height where observed from tallest to shortest
 SELECT observations.date,
       observations.patient,
       observations.description,
       observations.value,
       observations.units
  FROM observations
 WHERE observations.description = "Body Height"
 ORDER BY observations.value DESC;
 
 -- 9 Retrieve all patients that suffered a stroke and where given Clopidogrel 75 MG Oral Tablet
 SELECT medications.patient,
       medications.description,
       medications.reasondescription
  FROM medications
 WHERE medications.reasondescription = "Stroke"
       AND medications.description = "Clopidogrel 75 MG Oral Tablet"
 ORDER BY medications.patient;
 
 -- 10 Retrieve all patients with Diabetes or Prediabetes
 SELECT *
  FROM conditions
 WHERE conditions.description = "Diabetes"
 OR conditions.description = "Prediabetes";
 
 -- 11 How many procedures where done to patients with normal pregnancies excluding the'Standard pregnancy test' 
 SELECT DISTINCT procedures.description
  FROM procedures
 WHERE procedures.reasondescription = "Normal pregnancy"
       AND NOT procedures.description = "Standard pregnancy test";
       
-- 12  Retrieve patient's weight values converted to pounds for all observations where the description is "Body Weight".
SELECT observations.patient,
       observations.description,
       observations.value * 2.2 AS `Weight in lbs`
  FROM observations
 WHERE observations.description = "Body Weight";
 
 -- 13 Retrieve patient observations for body height (in inches) that exceed the 65 inches.
 SELECT observations.patient,
       observations.description,
       observations.value/2.5 AS `Height in Inches`
  FROM observations
 WHERE observations.description = "Body Height"
       AND observations.value/2.5 > 65;
       
-- 14 Retrieve details of medications where a reason for administration (reasondescription) is documented (NOT NULL) 
SELECT medications.patient,
       medications.description,
       medications.reasondescription
  FROM medications
 WHERE medications.reasondescription IS NOT NULL;
 
 -- 15 Retrieve all patients who received Acetaminophen and the reason description
 SELECT medications.patient,
       medications.description,
       medications.reasondescription
  FROM medications
 WHERE medications.description LIKE "Acetaminophen%";
 
 -- 16
 SELECT medications.patient,
       medications.description,
       medications.reasondescription
  FROM medications
 WHERE medications.description LIKE "Acetaminophen%"
       AND medications.description NOT LIKE "%codone%"
 ORDER BY medications.description DESC;
 
 -- 17 Retrieve the patient IDs, descriptions, and corresponding values of observations categorized as "Quality adjusted life years" where the recorded values fall within a range of 1 to 5.
 /* FRAME A PREDICTIVE MODEL FOR QUALITY OF LIFE BASED ON  OBSERVATIONS
 A healthcare organization is conducting a study to assess the quality of life among patients based on specific health observations recorded in a database. 
 QALY is a measure that combines life expectancy with quality of life considerations. It's used in health economics to assess the overall impact of health interventions 
 or conditions on an individual's well-being and life span. Economic assessment of a medical intervantion. QALY=Life Expectancy (in years) × Health-related Quality of Life (QoL)
 The EQ-5D index score can be calculated using country-specific value sets or weights assigned to different health states. For instance, the UK value set assigns values (utilities)
 to each health state ranging from 0 (equivalent to death) to 1 (perfect health).*/
 
SELECT 
    *
FROM
    observations
WHERE
  description = 'Quality adjusted life years';
  
 SELECT observations.patient,
       observations.description,
       observations.value
  FROM observations
 WHERE observations.description = "Quality adjusted life years"
       AND observations.value BETWEEN 1 AND 5;
       
-- 18 Fetches the next set of immunization records to display on the second page, starting from the 101st record in the immunizations table.
SELECT *
  FROM immunizations
 LIMIT 100
OFFSET 100;

-- 19 Link patients to their medications and diagnosis reasons.
SELECT patients.patient,
       patients.marital,
       patients.race,
       patients.ethnicity,
       patients.gender,
       medications.description AS medication,
       medications.reasondescription AS diagnosis
  FROM patients, medications
 WHERE patients.patient = medications.patient;
  -- 20 Alternative Join Method when joining column has same name
 SELECT patients.patient,
       patients.marital,
       patients.race,
       patients.ethnicity,
       patients.gender,
       medications.description AS medication,
       medications.reasondescription AS diagnosis
  FROM patients
       JOIN medications
       USING (patient);
  -- 21 Mainstrean join method
  SELECT patients.patient,
       patients.marital,
       patients.race,
       patients.ethnicity,
       patients.gender,
       medications.description AS medication,
       medications.reasondescription AS diagnosis
  FROM patients
       JOIN medications
       ON medications.patient = patients.patient;
       
       
-- 22 Retrieve patient information along with associated procedure details for Asian female patients only.
SELECT patients.patient,
       patients.race,
       patients.ethnicity,
       patients.gender,
       procedures.description AS procedures,
       procedures.reasondescription AS diagnosis
  FROM patients
       LEFT OUTER JOIN procedures
       ON patients.patient = procedures.patient
 WHERE patients.race = "asian"
       AND patients.gender = "F";
       
-- 23 Converts the value of the patient's height to a decimal data type.
SELECT observations.patient,
       observations.description,
       CAST(observations.value AS DECIMAL),
       observations.units
  FROM observations
 WHERE observations.description = "Body Height";
 
 -- 24 How many patients are allergic to fish
 SELECT allergies.description,
       COUNT(*)
  FROM allergies
 WHERE allergies.description = "Allergy to fish";
 
 -- 25 What is the average body weight of patients observed over time recorded
 SELECT observations_cleaned.patient,
       AVG(observations_cleaned.value),
       observations_cleaned.units
  FROM observations_cleaned
 WHERE observations_cleaned.description = "Body Weight"
 GROUP BY
    observations_cleaned.patient, observations_cleaned.units
    ORDER BY patient;
 
 -- 26 What is the average body height of patients observed over time
 SELECT observations_cleaned.description,
       MAX(observations_cleaned.value) AS Maximum_Height,
       observations_cleaned.units
  FROM observations_cleaned
 WHERE observations_cleaned.description = "Body Height"
 GROUP BY
    observations_cleaned.description, observations_cleaned.value, observations_cleaned.units;
-- check how many times the patients were observed 
    SELECT patient, COUNT(patient)
    FROM observations_cleaned
    GROUP BY patient
    HAVING COUNT(patient) > 1;
    
     -- 27 How many allergies does it patient recorded have
 SELECT allergies.patient,
       COUNT(allergies.description)
  FROM allergies
 GROUP BY allergies.patient
 ORDER BY COUNT(allergies.description) DESC;
 
 -- 28 Calculate average BMI, number of (BMI) readings per patient, and the maximum BMI recorded that exceeds a threshold indicating obesity (BMI > 30).
SELECT 
    observations_cleaned.patient,
    AVG(CASE
        WHEN observations_cleaned.description = 'Body Mass Index' THEN observations_cleaned.value
    END) AS `Avg BMI`,
    COUNT(CASE
        WHEN observations_cleaned.description = 'Body Mass Index' THEN observations_cleaned.value
    END) AS `Number of Readings`,
    MAX(CASE
        WHEN
            observations_cleaned.description = 'Body Mass Index'
                AND observations_cleaned.value > 30
        THEN
            observations_cleaned.value
    END) AS `Max Obese BMI`
FROM
    observations_cleaned
WHERE
    observations_cleaned.description = 'Body Mass Index'
GROUP BY observations_cleaned.patient;
 
  -- 29 Now order Max Obese BMI by DESC
 
 SELECT
    observations_cleaned.patient,
    AVG(CASE WHEN observations_cleaned.description = 'Body Mass Index' THEN observations_cleaned.value END) AS `Avg BMI`,
    COUNT(CASE WHEN observations_cleaned.description = 'Body Mass Index' THEN observations_cleaned.value END) AS `Number of Readings`,
    MAX(CASE WHEN observations_cleaned.description = 'Body Mass Index' AND observations_cleaned.value > 30 THEN observations_cleaned.value END) AS `Max Obese BMI`
FROM
    observations_cleaned
WHERE
    observations_cleaned.description = 'Body Mass Index'
GROUP BY
    observations_cleaned.patient
HAVING
    `Avg BMI` > 30
ORDER BY
    `Max Obese BMI` DESC;
 
 -- 30 Calculate the average BMI and categorize BMI values into different categories ('Underweight', 'Healthy', 'Overweight', 'Obese') for patients based on their BMI observations
 SELECT 
    observations_cleaned.patient,
    AVG(observations_cleaned.value) AS `Avg BMI`,
    CASE
        WHEN observations_cleaned.value < 18.5 THEN 'Underweight'
        WHEN
            observations_cleaned.value >= 18.5
                AND observations_cleaned.value < 25
        THEN
            'Healthy'
        WHEN
            observations_cleaned.value >= 25
                AND observations_cleaned.value < 30
        THEN
            'Overweight'
        WHEN observations_cleaned.value >= 30 THEN 'Obese'
    END AS `BMI category`
FROM
    observations_cleaned
WHERE
    observations_cleaned.description = 'Body Mass Index'
GROUP BY observations_cleaned.patient , `BMI category`;

 -- 31 Patients with Allergie sto moudl, grass pollen, tree and house dust mite
 SELECT allergies.patient,
       allergies.description
  FROM allergies
 WHERE allergies.description IN ("Allergy to mould", "Allergy to grass pollen", "Allergy to tree pollen", "House dust mite allergy");
 
 -- 32 Calculate the age at death for patients who have a recorded death date
SELECT 
    patients.patient,
    patients.birthdate,
    patients.deathdate,
    TIMESTAMPDIFF(YEAR, patients.birthdate, patients.deathdate) AS `age at death`
FROM 
    patients
WHERE 
    patients.deathdate IS NOT NULL
ORDER BY 
    `age at death` DESC;
    
--  Retrieve dead patient information along with corresponding quality of life observations for each patient.
SELECT 
    patients.patient,
    patients.birthdate,
    patients.deathdate,
    observations.date,
    TIMESTAMPDIFF(YEAR, patients.birthdate, patients.deathdate) AS `age at death`,
    observations.value AS `quality_of_life_value`
FROM 
    patients
LEFT JOIN 
    observations ON patients.patient = observations.patient
WHERE 
    patients.deathdate IS NOT NULL
    AND observations.description = 'Quality adjusted life years'  -- Filter quality of life observations
ORDER BY 
    `age at death` DESC;
    
 -- Verify the existence of matching records between the patients and observations tables
SELECT 
    p.patient AS patient,
    p.birthdate AS patient_birthdate,
    p.deathdate AS patient_deathdate,
    o.patient AS observation,
    o.description AS observation_description,
    o.value AS observation_value,
    o.units AS observation_units
FROM 
    patients p
INNER JOIN 
    observations o ON p.patient = o.patient
WHERE 
    p.deathdate IS NOT NULL
    AND o.description = 'Quality adjusted life years';

-- check how many times the patients were observed for 'Quality adjusted life years'
    SELECT o.date, p.deathdate, o.value AS observation_value, o.patient, COUNT(o.patient) AS observation_count, p.patient
    FROM observations o
    JOIN 
    patients p ON o.patient = p.patient
    WHERE description = 'Quality adjusted life years'
    GROUP BY p.patient, o.date, p.deathdate, o.value;
    
    -- data inconsitstency w.r.t QALY anyone who dies before 2017-10-31 should have a QALY value of 0 
UPDATE observations
JOIN patients ON observations.patient = patients.patient
SET observations.value = 0
WHERE observations.description = 'Quality adjusted life years'
    AND patients.deathdate <= observations.date
    AND observations.value <> 0;  -- Add an additional condition to avoid unnecessary updates

SET GLOBAL wait_timeout = 600;  -- Increase wait_timeout to 10 minutes
SET GLOBAL interactive_timeout = 600;  -- Increase interactive_timeout to 10 minutes

-- Standard SQL to list all tables in the database
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'medical_db';

SELECT table_name, column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'medical_db'
    AND table_name = 'all_prevalences';



    