-- =============================================================================
-- Project: MD Water Services Analysis
-- Script:  01_database_exploration.sql
-- Description: Initial database inspection, table discovery, and data preview.
-- =============================================================================

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
	