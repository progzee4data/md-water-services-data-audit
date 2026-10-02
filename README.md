# Md-water-services-data-audit
# Summary
This repository contains the complete SQL data auditing, cleanup, and quality assurance for the Maji Ndogo water services database (md_water_services). The primary objective of this project is to audit qualitative survey records, resolve human data entry errors, align descriptive logs with tested biological metrics, and correct misclassified public water sources to support reliable public health reporting
# Technical Workflow & Project Tasks
## Task 1: Initial database inspection, table discovery, and data preview
Objective: Verify database connectivity, validate table structures, and establish baseline counts across md_water_services
### SQL Query:
```
SHOW TABLES;
SELECT *
FROM data_dictionary LIMIT 5;
SELECT *
FROM employee LIMIT 5;
SELECT *
FROM global_water_access LIMIT 5;
SELECT *
FROM location LIMIT 5;
SELECT *
FROM visits LIMIT 5;
SELECT *
FROM water_quality LIMIT 5;
SELECT *
FROM water_source LIMIT 5;
SELECT *
FROM well_pollution LIMIT 5;
```
## Tasks 2 – 6: Exploratory Data Analysis & Schema Audit
Objective: Evaluate queue times, water source distributions, and cross examine qualitative field survey labels against quantitative contamination measurements.
### SQL Query:
```
-- Find all unique water source types
SELECT DISTINCT 
    type_of_water_source 
FROM 
    water_source;

-- Task 3: Identify Severe Queue Times (> 500 minutes / ~8.3 hours)
SELECT 
    * 
FROM 
    visits
WHERE 
	time_in_queue > 500;

-- Task 4: Look up Water Source Types for High Queue Time Sources
SELECT
	*
FROM
	water_source
WHERE 
	source_id IN ('AkKi00881224', 'SoRu37635224', 'SoRu36096224', 'AkRu05234224', 'HaZa21742224');

-- Task 5: Audit Water Quality for Second Visits
SELECT
	*
FROM 
	water_quality
WHERE
	subjective_quality_score = 10 
    AND visit_count =2;

-- Task 6: Inspect Well Pollution Laboratory Records
SELECT
	*
FROM 
	well_pollution LIMIT 5;
```
## Task 7: Detecting Contamination Anomalies
Objective: Identify water sources mislabeled as 'Clean' in survey results despite exceeding the $0.01\text{ CFU/mL}$ biological contamination threshold.
### SQL Query:
```
SELECT *
FROM well_pollution
WHERE results = 'Clean' 
  AND biological > 0.01;
```
## Task 8: Identifying Incorrect Descriptions with Trailing Text
Objective: Isolate records where field surveyors erroneously prepended "Clean " to descriptive notes detailing active biological contaminants.
### SQL Query:
```
SELECT 
	*
FROM 
	well_pollution
WHERE 
	description LIKE 'Clean %'
	AND biological > 0;
```
## Task 9: Cleaning Description Strings and Updating Contaminated Survey Results
Objective: Perform safe batch updates of mislabeled records.
### SQL Query:
```
-- Disable safe updates for this session
SET SQL_SAFE_UPDATES = 0;
-- Fix E. coli descriptions
UPDATE well_pollution
SET 
	description = 'Bacteria: E. coli'
WHERE 
	description = 'clean Bacteria: E. coli';

-- Fix Giardia Lamblia descriptions
UPDATE well_pollution
SET 
	description = 'Bacteria: Giardia Lamblia'
WHERE 
	description = 'clean Bacteria: Giardia Lamblia';

-- Update the survey results status for all wells with biological contamination exceeding the $0.01$ safety threshold
UPDATE 
	well_pollution
SET 
	results = 'Contaminated: Biological'
WHERE 
	results = 'Clean'
	AND biological > 0.01;
```
