-- =============================================================================
-- Project: MD Water Services Analysis
-- Task 2:  02_water_source_analysis.sql
-- Description: Retrieve all unique types of water sources from the dataset.
-- =============================================================================

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

-- -----------------------------------------------------------------------------
-- -- Task 5: Audit Water Quality for Second Visits
-- Insight: Returned 218 rows with score = 10 on visit_count = 2, indicating 
--          potential surveyor data entry errors or duplicate visit logging.
-- -----------------------------------------------------------------------------
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

-- Task 7: Detecting Contamination Anomalies
SELECT
	*
FROM
	well_pollution
WHERE 
	results = 'clean' 
    AND biological > 0.01;

-- Task 8: Identifying Incorrect Descriptions with Trailing Text
SELECT 
	*
FROM 
	well_pollution
WHERE 
	description LIKE 'Clean %'
	AND biological > 0;

-- Task 9: Cleaning Description Strings and Updating Contaminated Survey Results

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