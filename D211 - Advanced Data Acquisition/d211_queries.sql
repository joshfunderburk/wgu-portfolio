-- Create WGU medical dataset view
CREATE VIEW wgu_medical_data AS 
SELECT
	patient.patient_id,
	location.city AS patient_city,
	location.state AS patient_state,
	location.county AS patient_county,
	lpad(location.zip::text, 5, '0') AS patient_zip_code,
	patient.lat AS patient_lattitude,
	patient.lng AS patient_longitude,
	patient.population census_population_near_patient_location,
	job.job_title,
	patient.children AS no_of_children,
	patient.age,
	patient.income,
	patient.marital,
	patient.gender,
	CASE
		WHEN patient.readmis = 'Yes' THEN TRUE
		WHEN patient.readmis = 'No' THEN FALSE
	END AS is_readmitted,
	patient.vitd_levels,
	patient.doc_visits,
	patient.full_meals,
	patient.vitd_supp,
	CASE
		WHEN patient.soft_drink = 'Yes' THEN TRUE
		WHEN patient.soft_drink = 'No' THEN FALSE
	END AS soft_drink,
	admission.initial_admission,
	CASE
		WHEN patient.hignblood = 'Yes' THEN TRUE
		WHEN patient.hignblood = 'No' THEN FALSE
	END AS has_high_blood_pressure,
	CASE
		WHEN patient.stroke = 'Yes' THEN TRUE
		WHEN patient.stroke = 'No' THEN FALSE
	END AS has_stroke_history,
	complication.complication_risk,
	CASE
		WHEN servicesaddon.overweight = 'Yes' THEN TRUE
		WHEN servicesaddon.overweight = 'No' THEN FALSE
	END AS is_overweight,
	CASE
		WHEN servicesaddon.arthritis = 'Yes' THEN TRUE
		WHEN servicesaddon.arthritis = 'No' THEN FALSE
	END AS has_arthritis,
	CASE
		WHEN servicesaddon.diabetes = 'Yes' THEN TRUE
		WHEN servicesaddon.diabetes = 'No' THEN FALSE
	END AS has_diabetes,
	CASE
		WHEN servicesaddon.hyperlipidemia = 'Yes' THEN TRUE
		WHEN servicesaddon.hyperlipidemia = 'No' THEN FALSE
	END AS has_hyperlipidemia,
	CASE
		WHEN servicesaddon.backpain = 'Yes' THEN TRUE
		WHEN servicesaddon.backpain = 'No' THEN FALSE
	END AS has_back_pain,
	CASE
		WHEN servicesaddon.anxiety = 'Yes' THEN TRUE
		WHEN servicesaddon.anxiety = 'No' THEN FALSE
	END AS has_anxiety,
	CASE
		WHEN servicesaddon.allergic_rhinitis = 'Yes' THEN TRUE
		WHEN servicesaddon.allergic_rhinitis = 'No' THEN FALSE
	END AS has_allergic_rhinitis,
	CASE
		WHEN servicesaddon.reflux_esophagitis = 'Yes' THEN TRUE
		WHEN servicesaddon.reflux_esophagitis = 'No' THEN FALSE
	END AS has_reflux_esophagitis,
	CASE
		WHEN servicesaddon.asthma = 'Yes' THEN TRUE
		WHEN servicesaddon.asthma = 'No' THEN FALSE
	END AS has_asthma,
	servicesaddon.services,
	patient.initial_days,
	patient.totalcharge AS total_charge,
	patient.additional_charges,
	survey_responses_addon.item1 AS survey_timely_admission,
	survey_responses_addon.item2 AS survey_timely_treatment,
	survey_responses_addon.item3 AS survey_timely_visit,
	survey_responses_addon.item4 AS survey_reliability,
	survey_responses_addon.item5 AS survey_options,
	survey_responses_addon.item6 AS survey_hours_of_treatment,
	survey_responses_addon.item7 AS survey_courteous_staff,
	survey_responses_addon.item8 AS survey_doctor_active_listening
FROM
	patient
	JOIN admission ON admission.admins_id = patient.admis_id
	JOIN complication ON complication.complication_id = patient.compl_id
	JOIN job ON job.job_id = patient.job_id
	JOIN "location" ON location.location_id = patient.location_id
	JOIN servicesaddon ON servicesaddon.patient_id = patient.patient_id
	JOIN survey_responses_addon ON survey_responses_addon.patient_id = patient.patient_id;
	

-- Create table for kff data
CREATE TABLE kff_inpatient_expenses (
    state_location VARCHAR(100) NOT NULL,
    expenses_per_day NUMERIC(10, 2) NOT NULL, 
    state_abbrev CHAR(2) NOT NULL,
    
    CONSTRAINT kff_inpatient_expenses_pk PRIMARY KEY (state_abbrev)
)

TABLESPACE pg_default;

ALTER TABLE public.kff_inpatient_expenses
    OWNER to postgres;

-- Import kff data
COPY kff_inpatient_expenses
FROM 'C:\Users\Public\Downloads\d211\d211_kff.csv'
DELIMITER ','
CSV HEADER;

-- Referential Integrity
ALTER TABLE servicesaddon ADD FOREIGN KEY (patient_id) REFERENCES patient(patient_id);
ALTER TABLE survey_responses_addon ADD FOREIGN KEY (patient_id) REFERENCES patient(patient_id);
