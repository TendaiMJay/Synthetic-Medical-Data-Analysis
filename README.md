# Synthetic Medical Data Analysis

## About

This project aims to explore the data generated using Synthea, a synthetic patient generator that models the medical history of synthetic patients. Exploring healthcare data by deriving insights from exploratory data analysis and predictive modeling for health-related quality of life for enhanced patient care.



## Project Purpose

The major aim of the project is to gain understanding of the healthcare landscape within the dataset and identify factors influencing patient quality of life and provide actionable insights for enhanced patient care.
.
## About Database

This data was generated using Synthea, a synthetic patient generator that models the medical history of synthetic patients. Their mission is to output high-quality synthetic, realistic but not real, patient data and associated health records covering every aspect of healthcare. The resulting data is free from cost, privacy, and security restrictions, enabling research with Health IT data that is otherwise legally or practically unavailable. The database contains 11 tables found here (https://data.world/siyeh/synthetic-medical-data)


| Table                   | Description                             | Column Data Types     |
| :---------------------- | :-------------------------------------- | :---------------------|
| all_prevalence          | All prevalent diseases and disorders    | VARCHAR(), DATE, INT  |
| allergies               | Allergies that patients have recorded   | VARCHAR(), DATE, INT  |
| careplans               | Plan of care for patient condition      | VARCHAR(), DATE, INT  |
| claims                  | Number of claims to patient over time   | VARCHAR(), DATE, INT  |
| conditions              | Medical conditions diagnosed in patients| VARCHAR(), DATE, INT  |
| encounters              | Hospital visits over time               | VARCHAR(), DATE, INT  |
| immunizations           | Patient immunizations received          | VARCHAR(), DATE, INT  |
| medications             | Lists medications prescribed to patients| VARCHAR(), DATE, INT  |            
| observations            | Captures different health observations  | VARCHAR(), DATE, INT  |
| patients                | Contains demographic information        | VARCHAR(), DATE       |
| procedures              | Medical procedures performed on patients| VARCHAR(), DATE, INT  |


## Analysis List

### Exploratory and Descriptive  Analytics


1. Disease Prevalence Analysis (Including identifying Top 5 Conditions and Procedures)

> Identify the most prevalent medical conditions and  within the patient population to prioritize resource allocation and targeted interventions.

2. Patient Risk Profiling

> Develop profiles of patients at higher risk based on their demographic information and medical history to enable proactive care management.

3. Health Trends Analysis

> Analyze trends in key health metrics such as BMI, Blood Pressure and Cholesterol to monitor population health and identify areas of concern

4. Medication Effectiveness Analysis

> Evaluate the effectiveness of medications in managing specific health conditions and their impact on patient outcomes.

5. Mortality Rate Analysis

> Understanding mortality rates at this hospital and conditions associated with the highest mortality rates.


### Prescriptive and Predictive Analytics


1. Clinical Decision Support: 

> Provide actionable insights to healthcare providers to support clinical decision-making and enhance personalized care delivery.

2. Quality of Life Assessment

> Build predictive models to estimate Quality Adjusted Life Years (QALY) based on factors influencing health-related quality of life (HRQL).

3. Optimizing Healthcare Resource Allocation

> Inform resource allocation strategies based on prevalent conditions, patient demographics, and healthcare utilization patterns.



## Approach Used

### SQL Analysis

1. **Data Wrangling:** The inspection of data to make sure **NULL** values and missing values are detected and data replacement methods are used to replace, missing or **NULL** values.

> 1. Build a database - create a new schema
> 2. Import table data from csv(s) downloaded.
> 3. Set **NOT NULL** for each field so null values are filtered out.
> 4. Update date formats 
> 5. Normalize column names

2. **Feature Engineering:** This will help use generate some new columns from existing ones and drop some columns that will not be used for the analysis and edit some records.

> 1. Calculate BMI from height and weight observations.

> 2. Identify patients with specific medical conditions.

> 3. Correct data inconsistency w.r.t QALY, anyone who dies before 2017-12-31 change dates to <= 2017 and change QALY value to 0 

3 **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.


### Questions To Answer

#### Generic Questions

1. Show all prevalent disorders/diseases that have an occurrence of over 10% or 100 in the population that do not have the word Mg in the middle or the end
2. Retrieve all patients that suffered a stroke and where given Clopidogrel 75 MG Oral Tablet?
3. Retrieve all patients with Diabetes or Prediabetes?
4. How many procedures where done to patients with normal pregnancies excluding the 'Standard pregnancy test'?
5. Retrieve all patients who received Acetaminophen and the reason description?
6. Link patients to their medications and diagnosis reasons?
7. Retrieve patient information along with associated procedure details for Asian female patients only?
8. How many patients are allergic to mould, grass pollen, tree and house dust mite?
9. Calculate average BMI, number of (BMI) readings per patient, and the maximum BMI recorded that exceeds a threshold indicating obesity (BMI > 30)?
10.Categorize BMI values into different categories ('Underweight', 'Healthy', 'Overweight', 'Obese') for patients based on their BMI observations?
11.Calculate the age at death for patients who have a recorded death date?

### Quality of life prediction 

#### Calculation of Quality adjusted life years (QALYs)

QALYs = Age(Life Years) * HRQL(Utility assigned to the measurement of health-related quality of life)  

1. Calculate HRQL?
2. Retrieve the patient IDs, descriptions, and corresponding values of observations categorized as "Quality adjusted life years" where the recorded values fall within a range of 1 to 5?
3. Retrieve dead patient information along with corresponding quality of life observations for each patient?
4. Check how many times the patients were observed for 'Quality adjusted life years'
5. Create a table with all data related to the model for predicting QALYs

### Power BI Analysis

1. **Data Modeling:** 
> 1. Connect to SQL database (import query)
> 2. Deactivate auto-relationship detect, drop/hide tables and columns that will not be used in the analysis.
> 2. Set up primary relationships while checking relationship cardinality and cross-filter direction.

2. **Visualisations:** 
> 1.Build a summarisation dashboard
> 2 Build a patient profile interface with patient information
> 3 Add a new patient form using Power Apps to have direct live data updates
> 4 Connect machine learning plot from Python and visuals for quality of life assessments 

3. **DAX Calculations:** 
> 1. Create own Date Table.
> 2. Calculate column categorization of heath metrics such as BMI, Blood Pressure, etc. Measures such as mortality rate, age, 
> 3. Dynamic titles and labels

Interact with dynamic report here: https://mavenanalytics.io/project/14802

### Python Analysis

1. **Data Preparation:** 
> 1. Load QALY_data.csv exported from SQL 
> 2. Handle missing values, convert categorical values to numeric representation

1. **Model Selection and Training:** 
> 1. Identify HRQL as the target variable based on relevant health observations.
> 2. Divide the dataset into training and testing sets 
> 2. Use Ordinary Least Squares regression models for HRQL prediction and evaluate performance of model


## Conclusion

### MS PowerPoint Reporting

Report results are summarized for executive  for stakeholders to easily digest all the results and recommendations that came from the report. https://github.com/TendaiMJay/Synthetic-Medical-Data-Analysis/blob/main/Medical%20Data%20Anlaysis.pdf


### Code

For the rest of the code, check the queries 
> https://github.com/TendaiMJay/Synthetic-Medical-Data-Analysis/blob/main/siyeh_sythetic_medical_data.sql, 
> https://github.com/TendaiMJay/Synthetic-Medical-Data-Analysis/blob/main/QALY_Dataset.sql, 
> https://github.com/TendaiMJay/Synthetic-Medical-Data-Analysis/blob/main/QALY_OLS_reg.ipynb,
> https://github.com/TendaiMJay/Synthetic-Medical-Data-Analysis/blob/main/medicinal_data%20analysis.pbix

