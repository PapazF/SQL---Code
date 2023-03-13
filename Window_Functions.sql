-- Assign a number to each year in which Summer Olympic games were held. Using subquery!
SELECT
  Year,
  ROW_NUMBER () OVER() AS Row_N
FROM (
  SELECT DISTINCT(year)
  FROM Summer_Medals
  ORDER BY Year 
) AS Years
ORDER BY Year;

-- Rank each athlete by the number of medals they've earned. Using 'CTE'!
WITH Athlete_Medals AS (
  SELECT 
	Athlete,
	COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)
  
SELECT Athlete,
ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-- Get the previous year's champion for each year.Using 'CTE'!
WITH Weightlifting_Gold AS (
  SELECT 
	Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')
    
SELECT
  Year, Champion,
  LAG (Champion) OVER
    (order by year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

-- Return the previous champions of each year's(starting year 2000), for event 'Javelin Throw' by gender.
SELECT
  DISTINCT gender, year,
  country AS champion,
  LAG(country) OVER (PARTITION BY Gender
            ORDER BY year ASC) AS Last_Champion
FROM summer_medals
WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold'
ORDER BY Gender ASC, Year ASC;

/*For each year, fetch the current gold medalist and the gold medalist 3 competitions ahead of the current row. 
Starting from 2000 and Evet 'Discus Throw') */
SELECT 
  DISTINCT year,
  athlete,
  LEAD(athlete,3) OVER (ORDER BY year) AS future_champion
FROM summer_medals
WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000
ORDER BY Year;

-- Return all golden male athletes and the first athlete ordered by alphabetical order.
SELECT 
  DISTINCT athlete,
  FIRST_VALUE(athlete) OVER (ORDER BY athlete) AS first_athlete
FROM summer_medals
WHERE Medal = 'Gold'
    AND Gender = 'Men'
ORDER BY athlete;

/* Return the year and the city in which each Olympic games were held.
Fetch the last city in which the Olympic games were held. */

SELECT DISTINCT year, city,
      LAST_VALUE(city) OVER (ORDER BY year 
      RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING) AS last_city
FROM summer_medals 
ORDER BY year;

-- Rank each athlete by the number of medals they've earned. Using 'RANK'.
SELECT athlete, COUNT(*) AS medals,
      RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_n
FROM summer_medals
GROUP BY athlete 
ORDER BY medals DESC;

-- Rank each country's(USA and Canada) athletes by the count of medals they've earned. Using 'DENSE_RANK'
SELECT 
  country,
  athlete,
  DENSE_RANK() OVER (PARTITION BY Country ORDER BY COUNT(*) DESC) AS Rank_N 
FROM summer_medals 
WHERE Country IN ('USA', 'CAN')
      AND Year >= 2000
GROUP BY country, Athlete
HAVING COUNT(*) > 1
ORDER BY Country ASC, RANK_N ASC;

-- Split the distinct events into exactly 111 groups.
SELECT DISTINCT event,  
      NTILE(111) OVER (ORDER BY event) AS page
FROM summer_medals 
ORDER BY event;

/* Split the athletes into top, middle, and bottom thirds based on their count of medals.
Return the average of each third. */
WITH thirds AS (SELECT athlete, COUNT(*) AS medals,
      NTILE(3) OVER(ORDER BY COUNT(*) desc) AS third
FROM summer_medals 
GROUP BY athlete
HAVING COUNT(*) > 1
ORDER BY medals DESC, athlete)

SELECT third, ROUND(AVG(medals),2) AS avg_medals
FROM thirds
GROUP BY third
ORDER BY third;

-- Calculate the number of medals each athlete earned, and the medals running total.

SELECT athlete, 
      COUNT(medal) AS medals,
      SUM(COUNT(medal)) OVER (ORDER BY athlete) AS max_medals 
FROM summer_medals 
WHERE Country = 'CAN' AND Medal = 'Gold'
      AND Year >= 2000
GROUP BY athlete
ORDER BY athlete;

-- Calculate the maximum medals earned so far for each country (USA,Canada, Mexico).
SELECT year,
      country,
      COUNT(medal) AS medals,
      MAX(COUNT(medal)) OVER ( PARTITION BY country ORDER BY year) AS max_medals 
FROM summer_medals 
WHERE country IN ('USA', 'CAN', 'MEX')
    AND medal = 'Gold' AND Year >= 2000
GROUP BY country, year
ORDER BY country, year;

-- Calculate the minimum medals earned so far.
SELECT year, 
      COUNT(medal) AS medals,
      MIN(COUNT(medal)) OVER (PARTITION BY country ORDER BY year) AS min_medals 
FROM summer_medals 
WHERE country = 'CAN'
    AND medal = 'Gold' AND year >= 2000
GROUP BY country, year 
ORDER BY year;

-- Calculate the 3-year moving average of medals earned.
SELECT year,
      COUNT(medal) AS medals,
      AVG(COUNT(medal)) OVER 
      (ORDER BY year 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS medals_ma
FROM summer_medals
WHERE country = 'CAN'
    AND medal = 'Gold'
    AND year >= 1980
GROUP BY year 
ORDER BY year;

/* Calculate the gold medals awarded per country and gender.
Generate Country-level gold award counts */
SELECT country, 
      gender,
      COUNT(medal) AS gold_awards 
FROM summer_medals 
WHERE Year = 2004
      AND medal = 'Gold'
      AND country IN ('CAN', 'USA', 'MEX')
GROUP BY country, ROLLUP(gender)
ORDER BY country;