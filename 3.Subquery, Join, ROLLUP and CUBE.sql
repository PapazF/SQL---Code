/* We want to know person's salary comparing to his/her department average salary */
SELECT id, last_name,
	   department,
       salary,
       (SELECT AVG(salary) 
		FROM staff AS ss
        WHERE ss.department = s.department) AS average_salary
FROM staff AS s
ORDER BY 3;

/* How many people are earning above/below the average salary of his/her department? */
SELECT departmenT,
	   COUNT(*)
FROM staff AS s
WHERE salary < 
(
SELECT AVG(salary)
FROM staff AS ss
WHERE s.department = ss.department
)
GROUP BY 1;

/* Assume that employees who earn at latest 100,000 salaries are Executive.
We want to know the average salary for executives for each department. */
SELECT department,
	   ROUND(AVG(salary),2) AS average_salary
FROM staff 
WHERE salary > 100000
GROUP BY 1 
ORDER BY 2 DESC; -- We can see that Sports department has highest average salary for Executives where Movies department has the lowest

/* Who earn the most in the company? 
It seems like Stanley Grocery earns the most.
*/
SELECT id, last_name,
	   job_title,
       department,
	   salary
FROM staff
ORDER BY 5 DESC
LIMIT 1; -- Looks like Stanley earns the most, works in Grocery departmnet as Director of Sales.

/* Who earns the most in his/her own department */
SELECT s.department, 
       s.last_name, 
	   s.salary
FROM staff s
WHERE s.salary = (
	SELECT MAX(s2.salary)
	FROM staff s2
	WHERE s2.department = s.department
)
ORDER BY 1;

/* Full details info of employees with company division */
SELECT last_name,
	   s.department,
       company_division
FROM staff AS s
INNER JOIN company_divisions as c
ON s.department = c.department; -- Based on the results, we see that there are only 953 rows returns. We know that there are 1000 staffs!

/* Using left join all 1000 staffs are returned, but 47 people have missing company_division. */
SELECT last_name,
	   s.department,
       company_division
FROM staff AS s
LEFT JOIN company_divisions as c
ON s.department = c.department;

/* Who are those people with missing company division? */
SELECT last_name,
	   s.department,
       company_division
FROM staff AS s
LEFT JOIN company_divisions as c
ON s.department = c.department
WHERE company_division IS NULL;    /* It seems like all staffs from "books" department have missing company division!
                                   We may want to inform our IT team to add Books department in corresponding company division. */


/* How many staffs are in each company regions, also compute grad total */
SELECT company_regions,
	   COUNT(*) AS number_of_staff
FROM company_regions as c 
INNER JOIN staff AS s
ON c.region_id = s.region_id
GROUP BY 1 WITH ROLLUP;

/* Number of employees per regions & country, Then sub totals per Country, Then toal for whole table*/
SELECT country,
       company_regions,
       COUNT(*) AS number_of_employees
FROM company_regions AS c
INNER JOIN staff AS s
ON c.region_id = s.region_id
GROUP BY country, company_regions WITH ROLLUP;

/* With CUBE we will generate subtotals for country and also for company_regions */
SELECT country,
       company_regions,
       COUNT(*) AS number_of_employees
FROM company_regions AS c
INNER JOIN staff AS s
ON c.region_id = s.region_id
GROUP BY CUBE (country, company_regions);
