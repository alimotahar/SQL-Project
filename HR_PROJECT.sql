CREATE DATABASE HR_Project

USE HR_Project

SELECT * FROM HR

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HR'

--DATA CLEANING AND PREPROCESSING

UPDATE HR
SET termdate = CAST(SUBSTRING(termdate, 1, 10) AS date)
WHERE termdate IS NOT NULL;

ALTER TABLE HR
ALTER COLUMN termdate date

--Create  Age Column

ALTER TABLE HR
ADD age INT;

UPDATE HR
SET age = DATEDIFF(YEAR,birthdate,GETDATE())


SELECT MIN(age) MIN, MAX(age)MAX
FROM HR

--1. What is the gender breakdown  of employee in the company
SELECT gender, count(*) AS Count
FROM HR
GROUP BY gender

--2. What is the race breakdown  of employee in the company 
SELECT race, count(*) AS Count
FROM HR
WHERE termdate IS NULL
GROUP BY race

--3. What is the age distribution of employee in the compsny
SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group,
	COUNT(*) AS count
FROM HR
WHERE termdate IS NULL
GROUP BY
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END
ORDER BY age_group;

--4. How many employees work at HQ VS remoot
SELECT location,COUNT(*) AS count
FROM HR
WHERE termdate Is NULL
GROUP BY location

--5. What is the AVG. length of employement who have been terminated
SELECT ROUND(AVG(YEAR(termdate) - YEAR(hire_date)),0) AS length_of_emp
From HR
WHERE termdate IS NOT NULL AND termdate <= GETDATE()

--6. How does the gender disterbution vary across dept. and jobtitles.
SELECT department,jobtitle,gender, COUNT(*) AS count
FROM HR
WHERE termdate IS NOT NULL
GROUP BY department,jobtitle,gender
ORDER BY department,jobtitle,gender


SELECT department,gender, COUNT(*) AS count
FROM HR
WHERE termdate IS NOT NULL
GROUP BY department,gender
ORDER BY department,gender

--7. What is the distribution of job title across the company
SELECT jobtitle,COUNT(*) AS count
FROM HR
WHERE termdate IS NULL
GROUP BY jobtitle

SELECT department, COUNT(*) AS count
FROM HR
WHERE termdate IS NULL
GROUP BY department


--8. Which dep. has the higher ternover/termination rate
SELECT department,
       COUNT(*) AS total_count,
       COUNT(CASE
                 WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
                 END) AS terminate_count,
       ROUND((COUNT(CASE
                     WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
                     END) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100, 2) AS termination_rate
FROM HR
GROUP BY department
ORDER BY termination_rate DESC;

--9. What is disttribution of employees across location_state
SELECT location_state, COUNT(*) AS count
FROM HR
WHERE termdate IS NULL
GROUP BY location_state

SELECT location_city, COUNT(*) AS count
FROM HR
WHERE termdate IS NULL
GROUP BY location_city

--10. How has the companies employee count change over time based on hire and termination date.
SELECT * FROM HR

SELECT year,
       SUM(hires) AS hires,
       SUM(terminations) AS terminations,
       SUM(hires) - SUM(terminations) AS net_change,
       (SUM(terminations) * 1.0 / SUM(hires)) AS change_percent
FROM (
    SELECT YEAR(hire_date) AS year,
           COUNT(*) AS hires,
           SUM(CASE
               WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
               ELSE 0
           END) AS terminations
    FROM HR
    GROUP BY YEAR(hire_date)
) AS subquery
GROUP BY year
ORDER BY year;

--11. What is the tenure destribution for each dept.
SELECT department, ROUND(AVG(DATEDIFF(YEAR, hire_date, termdate)), 0) AS avg_tenure
FROM HR
WHERE termdate IS NOT NULL AND termdate <= GETDATE()
GROUP BY department;

--12. termination and hire breakdown gender wise
SELECT
    gender,
    total_hires,
    total_terminations,
    ROUND((total_terminations * 100.0 / total_hires), 2) AS termination_rate
FROM (
    SELECT gender,
        COUNT(*) AS total_hires,
        COUNT(CASE
            WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
            END) AS total_terminations
    FROM HR
    GROUP BY gender
) AS subquery

--13. termination and hire breakdown age wise
SELECT
    age,
    total_hires,
    total_terminations,
    ROUND((total_terminations * 100.0 / total_hires), 2) AS termination_rate
FROM (
    SELECT age,
        COUNT(*) AS total_hires,
        COUNT(CASE
            WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
            END) AS total_terminations
    FROM HR
    GROUP BY age
) AS subquery
ORDER BY age

--14. termination and hire breakdown department wise
SELECT
    department,
    total_hires,
    total_terminations,
    ROUND((total_terminations * 100.0 / total_hires), 2) AS termination_rate
FROM (
    SELECT department,
        COUNT(*) AS total_hires,
        COUNT(CASE
            WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
            END) AS total_terminations
    FROM HR
    GROUP BY department
) AS subquery

--15. termination and hire breakdown age wise
SELECT
    race,
    total_hires,
    total_terminations,
    ROUND((total_terminations * 100.0 / total_hires), 2) AS termination_rate
FROM (
    SELECT race,
        COUNT(*) AS total_hires,
        COUNT(CASE
            WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1
            END) AS total_terminations
    FROM HR
    GROUP BY race
) AS subquery


