/* Employee salary vs average salary of his/her department */
SELECT id, 
       last_name,
       department,
       salary,
       AVG(salary) OVER (PARTITION BY department)
FROM staff
ORDER BY 3;

/* Employee salary vs max salary of his/her department */
SELECT id, 
       last_name,
       department,
       salary,
       MAX(salary) OVER (PARTITION BY department)
FROM staff
ORDER BY 3;

/* Employee salary vs min salary of his/her Company Region */
SELECT id, 
       last_name,
       company_regions,
       salary,
       MIN(salary) OVER (PARTITION BY department)
FROM staff AS s
INNER JOIN company_regions AS c ON s.region_id = c.region_id
ORDER BY 3;

/* FIRST_VALUE returns first value of the partition conditions, in this case decending order of salary group by department */
SELECT department,
       salary,
       FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;

/* Compare with the salary of person whose last_name is the first in ascenidng in that department */
SELECT id,
       last_name,
       department,
       salary,
       FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY last_name ASC)
FROM staff;

/* Give the rank by salary decending oder withint the specific department group.
The ranking 1, 2, 3 will restart when it reaches to another unique group.
Works same as Row_Number Function */
SELECT id,
       last_name,
       department,
       salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;

/* LAG() function allows us to compare current row value with the values of previous rows.
Also we can specify the number of rows from current row, by defining 'n', example LAG(column,n) */
-- We want to know person's salary and next lower salary in that department
SELECT id,
       last_name,
       department,
       salary,
       LAG(salary) OVER (PARTITION BY department ORDER BY salary ASC)
FROM staff;

/* LEAD() function opposite of LAG() allows us to compare current row value with the values after the current row */
-- We want to know person's salary and secound next higer salary in that department
SELECT id,
       last_name,
       department,
       salary,
       LEAD(salary,2) OVER (PARTITION BY department ORDER BY salary ASC)
FROM staff;


--------------------- NTILE(bins number) function ---------------------------
-- allows to create bins/ bucket

/* There are bins (1-10) Assigned each employees based on the decending salary of specific department, create bins in range (1-10) */
SELECT id,
       last_name,
       department,
       salary,
       NTILE(10) OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;

