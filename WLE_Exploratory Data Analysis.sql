# World Life Expectancy (Exploratory Data Analysis)

SELECT * FROM world_life_expectancy;

-- Identifying the average life expectancy from all countires 
SELECT ROUND(AVG(`Life expectancy`),2) AS global_avg_life_expectancy
FROM world_life_expectancy
WHERE `Life expectancy` != 0;

-- What is the increase in life expectancy over the last 15 years for each country
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS life_increase_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) != 0 
AND MAX(`Life expectancy`) != 0 
ORDER BY life_increase_15_years DESC;

-- Viewing average life expectancy from 2007-2022. Is the increase drastic?
SELECT Year , 
ROUND(AVG(`Life expectancy`),2) AS avg_life_expectancy
FROM world_life_expectancy
WHERE `Life expectancy` != 0 
AND `Life expectancy` != 0 
GROUP BY Year
ORDER BY Year DESC;

-- Finding correlations between Life Expectancy and high or low GDP in each country
SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp != 0
AND GDP != 0
ORDER BY GDP DESC;

-- Finding the average GDP globally
SELECT ROUND(AVG(gdp),0) AS avg_GDP
FROM world_life_expectancy
WHERE gdp != 0;

-- Average life expectancies of high and low GDP countries
SELECT 
SUM(CASE WHEN GDP >= 7483 THEN 1 ELSE 0 END) High_GDP_Count, 
ROUND(AVG(CASE WHEN GDP >= 7483 THEN `Life expectancy` ELSE NULL END),2) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 7483 THEN 1 ELSE 0 END) Low_GDP_Count, 
ROUND(AVG(CASE WHEN GDP <= 7483 THEN `Life expectancy` ELSE NULL END),2) Low_GDP_Life_expectancy
FROM world_life_expectancy;

-- Finding average life expectancy by Status (Developed vs Developing)
SELECT Status, COUNT(DISTINCT Country) AS count, ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy
FROM world_life_expectancy
GROUP BY Status;

-- Average life expectancies of high and low BMI countries
SELECT country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Exp,
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI DESC;


-- Calculating the Rolling Total of 'Adult Mortality' over the United States based on year
SELECT Country, 
Year, 
`Life expectancy`,
`Adult Mortality`,
Sum(`Adult Mortality`) OVER(PARTITION BY country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE country LIKE 'United States%';
