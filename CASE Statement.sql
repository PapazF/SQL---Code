/* Create a list of matches in the 2011/2012 season where Barcelona was the home team,
and create a new group 'wins, losses, and ties' */
SELECT 
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
         WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :(' 
         ELSE 'Tie' END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
WHERE m.hometeam_id = 8634; -- Filter for Barcelona as the home team

/* Create a list of matches in the 2011/2012 season where Barcelona was the away team,
and create a new group 'wins, losses, and ties' */
SELECT
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.home_goal < m.away_goal THEN 'Barcelona win!'
         WHEN m.home_goal > m.away_goal THEN 'Barcelona loss :('
         ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;

-- Query a list of matches played between Barcelona and Real Madrid to see their head to head matches.
	SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	Case When home_goal > away_goal and hometeam_id = 8634 Then 'Barcelona win!'
        WHEN home_goal > away_goal and hometeam_id = 8633 Then 'Real Madrid win!'
        WHEN home_goal < away_goal and awayteam_id = 8634 then 'Barcelona win!'
        WHEN home_goal < away_goal and awayteam_id = 8633 then 'Real Madrid win!'
        else 'Tie!' end as outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

-- Count the number of matches played in each country during the 2012/2013, 2013/2014, and 2014/2015 match seasons.
SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(case when m.season = '2012/2013'then m.id end) AS matches_2012_2013,
	COUNT(case when m.season = '2013/2014' then m.id end) AS matches_2013_2014,
	COUNT(case when m.season = '2014/2015' then m.id end) AS matches_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

/* Determine the total number of matches won by the home team in each country 
during the 2012/2013, 2013/2014, and 2014/2015 seasons */
SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(Case When m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 End) AS matches_2012_2013,
 	SUM(Case When m.season = '2013/2014' AND m.home_goal > m.away_goal 
        THEN 1 Else 0 End) AS matches_2013_2014,
	SUM(Case When m.season = '2014/2015' and m.home_goal > m.away_goal 
        Then 1 Else 0 End) AS matches_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;





















