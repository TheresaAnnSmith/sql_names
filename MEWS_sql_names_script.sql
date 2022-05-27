/*1. How many rows are in the names table?*/
SELECT COUNT(*)
FROM names;
--1,957,046

/*2. How many total registered people appear in the dataset?*/
SELECT SUM(num_registered)
FROM names;
--351653025

/*3. Which name had the most appearances in a single year in the dataset?*/
SELECT name, num_registered, year
FROM names
ORDER BY num_registered DESC
LIMIT 1;
--Linda, 99,689 in 1947

/*4. What range of years are included?*/
SELECT MAX(year), MIN(year)
FROM names;
--1880 to 2018

/*5. What year has the largest number of registrations?*/
SELECT SUM(num_registered) AS total_registered, year
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC
LIMIT 1;
--1957 with 4,200,022 registrations

/*6. How many different (distinct) names are contained in the dataset?*/
SELECT COUNT(DISTINCT name)
FROM names;
--98,400

/*7. Are there more males or more females registered?*/
SELECT gender, SUM(num_registered)
FROM names
GROUP BY gender;
-- more males (177,573,793) than females(174,079,232)

-- FROM JOSH'S script....
--Bryan's concise one
select (case when males > females then 'true' else 'false' end) as are_more_males_than_females_registered
from (select count(gender) from names where gender = 'M') males,
     (select count(gender) from names where gender = 'F') females;

/*8. What are the most popular male and female names overall (i.e., the most total registrations)?*/
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
-- Most popular overall female name is Mary (4,125,675 registered)
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
--Most popular overall male name is James (5,164,280)

--FROM JOSH'S NOTES...
-- Bryan's approach
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from names
order by total_registrations desc;

-- Chris
SELECT name, gender, SUM(num_registered) AS sum_registered
FROM names
GROUP BY name, gender
ORDER BY sum_registered DESC;

/*9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?*/
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'F'
	AND year BETWEEN 2000 AND 2009
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
--Most popular female name of this decade is Emily (223,690)
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'M'
	AND year BETWEEN 2000 AND 2009
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
--Most popular male name of this decade is Jacob (273,844)
--FROM JOSH'S NOTES...
-- Bryan
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from names
where year between 2000 and 2009
order by total_registrations desc


/*10. Which year had the most variety in names (i.e. had the most distinct names)?*/
SELECT year, COUNT(DISTINCT name) AS num_names
FROM names
GROUP BY year
ORDER BY num_names DESC
LIMIT 1;
--2008 with 32,518 distinct names

/*11. What is the most popular name for a girl that starts with the letter X?*/
SELECT name, SUM(num_registered)
FROM names
WHERE name LIKE 'X%'
	AND gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
--Ximena with 26,145 registrations

/*12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?*/
SELECT COUNT(DISTINCT name)
FROM names
WHERE name LIKE 'Q%' 
AND name NOT LIKE '_u%';
--46

/*13. Which is the more popular spelling between "Stephen" and "Steven"? 
Use a single query to answer this question.*/
SELECT name, SUM(num_registered)
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name;
--Steven is more popular (1,286,951) than Stephen (860,972)

/*14. What percentage of names are "unisex" - that is what 
percentage of names have been used both for boys and for girls?*/
SELECT COUNT(name)
FROM(SELECT name,
		COUNT(CASE WHEN gender = 'F' THEN 'f_count' END) AS F_count,
		COUNT(CASE WHEN gender = 'M' THEN 'm_count' END) AS M_count
	FROM names
	GROUP BY name
	ORDER BY F_count DESC) AS counts
WHERE F_count > 0
AND M_count> 0;
--10,773/98,400= 10.95%
--Thought of another way to do this with intersect
SELECT COUNT(*)
FROM(SELECT name
	FROM names
	WHERE gender = 'F'
	INTERSECT
	SELECT name
	FROM names
	WHERE gender = 'M') AS unisex;

--FROM JOSH'S NOTES...
-- SELECT SUM((MIN(gender) = 'F' AND MAX(gender) = 'M'))/SUM(name = name)
-- FROM names
-- GROUP BY name;
-- Option A
SELECT name
FROM names
GROUP BY name
HAVING MIN(gender) = 'F' AND MAX(gender) = 'M';

--Option B
SELECT name,
	COUNT(DISTINCT gender) AS gender_count
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2;

SELECT 100*10733.0/COUNT(DISTINCT name)
FROM names;

-- Jacob
SELECT name, COUNT(DISTINCT gender)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2;

SELECT (10773.0/COUNT(DISTINCT name))*100
FROM names;

-- Chris
SELECT CAST(MIN(unisex_count) AS FLOAT) / CAST(MAX(unisex_count) AS FLOAT) * 100
FROM
	(SELECT 
	COUNT(*) AS unisex_count
	FROM 
		(SELECT name
		FROM names
		GROUP BY name
		HAVING COUNT(DISTINCT gender) > 1) AS ut
UNION
SELECT 
COUNT(DISTINCT name) AS total_count
FROM names AS n) AS union_table;

-- Bryan
select count(distinct name)*1.00 / (select count(distinct name) from names) as percent_unisex
from names
where name in
      (select name from names where gender = 'M')
  and name in
      (select name from names where gender = 'F');

/*15. How many names have made an appearance in every single year since 1880?*/
SELECT COUNT(*)
FROM(SELECT name, COUNT(name)
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 139) AS a;
--136
--FROM JOSH'S NOTES...
SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;
-- Chris
SELECT 
COUNT(*)
FROM
	(SELECT name 
	FROM names
	GROUP BY name
	HAVING COUNT(DISTINCT year) = (SELECT MAX(year) - MIN(year) + 1 FROM names)) AS yearly_names;

-- Jacob
SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;

-- Bryan
select name, count(name) as years_appeared
from names
group by name
having count(name) = (select max(year) from names) - (select min(year) from names) + 1;


/*16. How many names have only appeared in one year?*/
SELECT COUNT(*)
FROM(SELECT name, COUNT(name)
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 1) AS a;
--21,100
--FROM JOSH'S NOTES...
SELECT name, COUNT(DISTINCT year) AS years_appeared
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 1;

/*17. How many names only appeared in the 1950s?*/
SELECT COUNT(name)
FROM(SELECT name
	FROM names
	WHERE year BETWEEN 1950 AND 1959
	EXCEPT
	SELECT name
	FROM names
	WHERE year < 1950 OR year >1959) AS fifties_names;
--661
--FROM JOSH'S NOTES...
SELECT name
FROM names
GROUP BY name
HAVING MIN(year) >= 1950 AND MAX(year) <= 1959;

/*18. How many names made their first appearance in the 2010s?*/
SELECT COUNT(name)
FROM(SELECT name
	FROM names
	WHERE year >=2010
	EXCEPT
	SELECT name
	FROM names
	WHERE year < 2010) AS new_names;
--11,270
--FROM JOSH'S NOTES...
SELECT name
FROM names
GROUP BY name
HAVING MIN(year) >= 2010;

/*19. Find the names that have not be used in the longest.*/
SELECT name, MAX(year)
FROM names
GROUP BY name
ORDER BY MAX(year)
LIMIT 50;
--Roll and Zilpah haven't been used since 1881
--FROM JOSH'S NOTES...
SELECT name, 2018 - MAX(year) AS years_since_named
FROM names
GROUP BY name
ORDER BY years_since_named DESC;