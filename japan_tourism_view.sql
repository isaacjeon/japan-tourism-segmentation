/*
Create a view of Japan tourism-related tables that categorizes data
by location, geographic_level (Prefecture or Region), category (e.g.
Nationality), label (e.g. South Korea), and percentage.
*/
CREATE OR REPLACE VIEW japan_tourism_stats AS
-- Combine tables using generalized 'category' and 'label columns'
WITH all_categories AS (
	SELECT `Area of Visit`,
		'Accommodation Type' AS category,
		`Accommodation Type` AS label,
		Percentage
	FROM `accommodation type`
    UNION ALL
    	SELECT `Area of Visit`,
		'Length of Stay (in days)' AS category,
		`Length of Stay (in days)` AS label,
		Percentage
	FROM `length of stay`
    UNION ALL
	SELECT `Area of Visit`,
		'Means of Transportation' AS category,
		`Means of Transportation` AS label,
		Percentage
	FROM `means of transportation`
    UNION ALL
	SELECT `Area of Visit`,
		'Nationality' AS category,
		`Nationality` AS label,
		Percentage
	FROM nationality
    UNION ALL
	SELECT `Area of Visit`,
		'Places to Shop' AS category,
		`Places to Shop` AS label,
		Percentage
	FROM `places to shop`
    UNION ALL
	SELECT `Area of Visit`,
		'Port of Departure' AS category,
		`Port of Departure` AS label,
		Percentage
	FROM `port of departure`
    UNION ALL
	SELECT `Area of Visit`,
		'Port of Entry' AS category,
		`port of Entry` AS label,
		Percentage
	FROM `port of entry`
    UNION ALL
	SELECT `Area of Visit`,
		'Sex/Age' AS category,
		`Sex/Age` AS label,
		Percentage
	FROM sex_age
    UNION ALL
    -- Split 'Sex' and 'Age' into separate categories
    SELECT `Area of Visit`,
		'Sex' AS category,
		SUBSTRING_INDEX(`Sex/Age`, '/', 1) AS label,
		SUM(Percentage) AS Percentage
	FROM sex_age
	GROUP BY `Area of Visit`, label
	UNION ALL
    SELECT `Area of Visit`,
		'Age' AS category,
		SUBSTRING_INDEX(`Sex/Age`, '/', -1) AS label,
		SUM(Percentage) as Percentage
	FROM sex_age
	GROUP BY `Area of Visit`, label
	UNION ALL
	SELECT `Area of Visit`,
		'Times Visited Japan' AS category,
		`Times Visited Japan` AS label,
		Percentage
	FROM `times visited japan`
    UNION ALL
	SELECT `Area of Visit`,
		'Travel Arrangement' AS category,
		`Travel Arrangement` AS label,
		Percentage
	FROM `travel arrangement`
    UNION ALL
	SELECT `Area of Visit`,
		'Travel Companions' AS category,
		`Travel Companions` AS label,
		Percentage
	FROM `travel companions`
)
-- Distinguish `Area of Visit` between prefectural and regional level
-- Convert `Percentage` to decimal and round to 4 places
SELECT
	(CASE
		WHEN `Area of Visit` NOT LIKE '%Region' THEN `Area of Visit`
		ELSE LEFT(`Area of Visit`, LENGTH(`Area of Visit`) - 7)
    END) AS location,
	(CASE
		WHEN `Area of Visit` NOT LIKE '%Region' THEN 'Prefecture'
		ELSE 'Region'
    END) AS geographic_level,  
    category,
    label,
    ROUND(percentage / 100, 4) as percentage
FROM all_categories;
