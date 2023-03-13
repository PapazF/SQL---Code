SELECT *
FROM company_divisions
LIMIT 5;

SELECT *
FROM company_regions
LIMIT 5;

SELECT *
FROM staff
LIMIT 5;

/* How many total employees in this company */
SELECT COUNT(*) 
FROM staff;

/* What about gender distribution? */
SELECT gender, COUNT(*) AS total_employees
FROM staff
GROUP BY gender;

/* How many employees in each department */
SELECT department, COUNT(*) AS total_employee
FROM staff
GROUP BY department
ORDER BY department;

/* How many distinct departments ? */
SELECT DISTINCT(department)
FROM staff
ORDER BY department;

/* What is the highest and lowest salary of employees? */
SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM staff;

/* What about salary distribution by gender group? */
SELECT gender,
	   MIN(salary) As Min_Salary, 
       MAX(salary) AS Max_Salary, 
       AVG(salary) AS Average_Salary
FROM staff
GROUP BY gender;
-- It seems like the average between male and female group is pretty close, with slighly higher average salary for Female group!

/* Want to know distribution of min, max average salary by department */
SELECT
	department, 
	MIN(salary) As min_salary, 
	MAX(salary) AS max_salary, 
	AVG(salary) AS average_salary, 
	COUNT(*) AS total_employees
FROM staff
GROUP BY department
ORDER BY 4 DESC;
-- It seems like Outdoors deparment has the highest average salary paid  and Jewelery department with lowest!

/* How spread out those salary around the average salary in each department ? */
SELECT 
	department, 
	MIN(salary) As Min_Salary, 
	MAX(salary) AS Max_Salary, 
	AVG(salary) AS Average_Salary,
	VAR_POP(salary) AS Variance_Salary,
	STDDEV_POP(salary) AS StandardDev_Salary,
	COUNT(*) AS total_employees
FROM staff
GROUP BY department
ORDER BY 6 DESC;
-- Although average salary for Outdoors is highest among deparment, it seems like data points are pretty close to average salary compared to other departments!
-- Health department has the highest deviation and outdoors department has smallest!

/* Let's see Health department salary */
SELECT department, salary
FROM staff
WHERE department LIKE 'Health'
ORDER BY 2 ASC;

/* We will make 3 buckets to see the salary earning status for Health Department */
SELECT CASE 
			WHEN salary >=100000 THEN 'high earner'
			WHEN salary >=50000 AND salary <100000 THEN 'middle earner'
            ELSE 'low earner' END AS earning_status,
            COUNT(*)
FROM staff
WHERE department LIKE 'Health'
GROUP BY 1 
ORDER BY 2 DESC; -- We can see that there are 24 high earners, 14 middle earners and 8 low earners!

/* Let's find out about Outdoors department salary */
SELECT CASE
			WHEN salary >= 100000 THEN 'high earner'
			WHEN salary >= 50000 AND salary < 100000 THEN 'middle earner'
			ELSE 'low earner'
			END AS earning_status,
            COUNT(*)
FROM staff
WHERE department LIKE 'Outdoors'
GROUP BY 1
ORDER BY 2 DESC; -- We can see that there are 34 high earners, 12 middle earners and 2 low earners!





