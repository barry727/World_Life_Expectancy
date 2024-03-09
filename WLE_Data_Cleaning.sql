# World Life Expectency (Data Cleaning) #

# Finding Duplicates

-- Finding duplicates by using the 'CONCAT()' function on the 'country' and 'year' columns to create a unique column (duplicates)
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year)) AS duplicates 
FROM world_life_expectancy
GROUP BY Country, Year
HAVING duplicates > 1;

-- Create row numbers for data grouped by 'Country' and 'Year' 
-- Filters out rows with a row number greater than 1
 SELECT *
 FROM ( 
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) 
    ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
     ) AS Row_table
WHERE Row_Num > 1;

-- Delete duplicate records 
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
		SELECT Row_ID
		FROM (
			SELECT Row_ID, 
			CONCAT(Country, Year),
			ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) 
            ORDER BY CONCAT(Country, Year)) as Row_Num
			FROM world_life_expectancy
     ) AS Row_table
WHERE Row_Num > 1);

# Standardizing Status Column

-- Identifying blank values in Status column 
SELECT DISTINCT Status
FROM world_life_expectancy
WHERE status != '';

SELECT DISTINCT Country 
FROM world_life_expectancy
WHERE status = '';

-- Standardizing blank values with 'Developing' status from 'Countries' column
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	USING(Country)
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developing';

-- Standardizing blank values with 'Developed' status from 'Countries' column
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	USING(Country)
SET t1.Status = 'Developed'
WHERE t1.sStatus = ''
AND t2.Status != ''
AND t2.Status = 'Developed';

# Standardizing Status Column

-- Finding blank values in 'Life expectancy' column
SELECT * FROM world_life_expectancy
WHERE `Life expectancy` = '';

-- Calculating the expected average of the blank values from 'Life expectancy' between the previous and next years using self joins
SELECT 
t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`, 
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2. Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

-- Updating blank values in 'Life expectancy' with the average between the previous and years
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2. Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3. Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
WHERE t1.`Life expectancy` = '';




 