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
order by total_registrations desc;

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

--BONUS QUESTIONS
--Bonus #1 Find the longest name contained in this dataset. What do you notice about the long names?
SELECT name, CHAR_LENGTH(name)
FROM names
WHERE CHAR_LENGTH(name) >= 15
GROUP BY name
ORDER BY CHAR_LENGTH(name) DESC;
--36 names have 15 characters, most of them appear to actually be multiple names run together
--FROM JOSH'S NOTES...
SELECT DISTINCT name, gender, LENGTH(name) AS name_length
FROM names
ORDER BY name_length DESC;

--Bonus #2 How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
SELECT name, REVERSE(name)
FROM names
WHERE name ILIKE REVERSE(name)
GROUP BY name;

SELECT COUNT(DISTINCT name)
FROM names
WHERE name ILIKE REVERSE(name);
--137 names are palindromes

/*Bonus #3 Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). 
(Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html)*/
SELECT DISTINCT(name)
FROM names
WHERE name NOT ILIKE '%a%'
	AND name NOT ILIKE '%e%'
	AND name NOT ILIKE '%i%'
	AND name NOT ILIKE '%o%'
	AND name NOT ILIKE '%u%'
	AND name NOT ILIKE '%y%'
GROUP BY name;

--FROM JOSH'S NOTES...
SELECT DISTINCT name
FROM names
WHERE LOWER(name) NOT SIMILAR TO '%(a|e|i|o|u|y)%';

-- Bryan
select distinct names_examined.name
from (select name, regexp_replace(lower(name), E'[aeiouy]', '', 'g') as modified_name from usa_names) as names_examined
where length(names_examined.name) = length(names_examined.modified_name);


/*Bonus #4How many double-letter names show up in the dataset? Double-letter means the same letter repeated 
back-to-back, like Matthew or Aaron. Are there any triple-letter names?*/
--FROM JOSH'S NOTES...
SELECT COUNT(DISTINCT name) AS double_letter_names
FROM names
WHERE name ~* '(.)\1{1}';

SELECT COUNT(DISTINCT name) AS triple_letter_names
FROM names
WHERE name ~* '(.)\1{2}';
/* Answer B4
22,537 double-letter
12 triple-letter
*/

/*Bonus #5 On question 17 of the first part of the exercise, 
you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but 
were used both before and after the 1950s. We'll answer this question in two steps.
		a. First, write a query that returns all names that appeared during the 1950s.
		b. Now, make use of this query along with the IN keyword in order the find all names that did not 
		appear in the 1950s but which were used both before and after the 1950s.*/
SELECT DISTINCT name, MIN(year), MAX(year)
FROM names
WHERE name NOT IN
	(SELECT DISTINCT name
	FROM names
	WHERE year BETWEEN 1950 AND 1959)
GROUP BY name
	HAVING MIN(year) < 1950
	AND MAX(year) > 1959;
	
SELECT COUNT(DISTINCT name)
FROM names
WHERE name NOT IN
	(SELECT DISTINCT name
	FROM names
	WHERE year BETWEEN 1950 AND 1959)
	AND name IN
	(SELECT DISTINCT name
	FROM names
	GROUP BY name
	HAVING MIN(year) < 1950
	AND MAX(year) > 1959);
--2525 names from the list that did not appear in the 1950's but did appear before and after

/*They did it a little off in that they were excluding ONLY the names which only appeared in the 50's, a bit redundant
given the question asked*/
SELECT name, MIN(year) AS min_year, MAX(year) max_year
FROM names
WHERE name NOT IN
	(SELECT name
	FROM names
	GROUP BY name
	HAVING (MIN(year) BETWEEN 1950 AND 1959)
	AND (MAX(year) BETWEEN 1950 AND 1959))
GROUP BY name
HAVING MIN(year) < 1950 AND MAX(year) > 1959
ORDER BY min_year DESC;
-- Chris
SELECT COUNT(DISTINCT name)
FROM names
WHERE name NOT IN 
	(SELECT name
	 FROM names
	 GROUP BY name
	 HAVING MIN(year) >= 1950
	 AND MAX(year) <= 1959)
AND name IN
	(SELECT name
	 FROM names
	 GROUP BY name
	 HAVING MIN(year) < 1950
	 AND MAX(year) > 1959);
/* Answer B5
14,548 names 
*/
SELECT COUNT(DISTINCT name)
FROM names
WHERE name IN
	(SELECT name
	 FROM names
	 GROUP BY name
	 HAVING MIN(year) < 1950
	 AND MAX(year) > 1959);

/*Bonus #6 In question 16, you found how many names appeared in only one year. Which year had 
the highest number of names that only appeared once?*/
SELECT year, COUNT(year) AS number_of_names
FROM names
WHERE name IN
	(SELECT name
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 1)
GROUP BY year
ORDER BY number_of_names DESC
LIMIT 10;
--2018 had 1,050 names that only appear in the list once
--FROM JOSH's NOTES...
SELECT year, COUNT(DISTINCT name) AS one_offs
FROM names
WHERE name IN 
	(SELECT name AS years_appeared
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 1)
GROUP BY year 
ORDER BY one_offs DESC;

--Bonus #7 Which year had the most new names (names that hadn't appeared in any years before that year)?
SELECT first_occ, COUNT(first_occ) AS new_name_count
FROM(SELECT name, MIN(year) AS first_occ
	  FROM names
	  GROUP BY name) AS first_year
GROUP BY first_occ
ORDER BY new_name_count DESC;
--2007 had the most new names with 2027
--FROM JOSH'S NOTES...
--We discovered this doesn't work because having the year in the GROUP BY statement results in creating a "group"
--for each year, so the (MIN) in the HAVING statement doesn't really do anything because each row is its own minimum
SELECT year, COUNT(*) AS new_names
FROM (SELECT name, year
	 FROM names
	 GROUP BY name, year
	 HAVING MIN(year) = year
	 ORDER BY name) AS s
 GROUP BY year
 ORDER BY new_names DESC;
 --The below confirms the same total for 2008 as the above
 SELECT COUNT(DISTINCT name)
 FROM names
 WHERE year = 2008;

/*Bonus #8 Is there more variety (more distinct names) for females or for males? Is this true for all years or are 
their any years where this is reversed? Hint: you may need to make use of multiple subqueries and JOIN them in order 
to answer this question.*/
SELECT gender, COUNT(DISTINCT name) AS total_names
FROM names
GROUP BY gender;
--Playing with CASE statements
SELECT
	COUNT(DISTINCT CASE WHEN gender = 'M' THEN name END) AS total_male_names,
	COUNT(DISTINCT CASE WHEN gender = 'F' THEN name END) AS total_female_names
FROM names;
--Females have a good bit more variety with 67,698 distinct names and males have 41,475 distinct names
--(these totals include the 10,773 unisex names)
--Looking for exceptions by year
--Using subqueries joined together
SELECT year, total_male_names, total_female_names
FROM (SELECT year, COUNT(DISTINCT name) AS total_female_names
	  FROM names
	  WHERE gender = 'F'
	  GROUP BY year) AS f
	  INNER JOIN
	  (SELECT year, COUNT(DISTINCT name) AS total_male_names
	  FROM names
	  WHERE gender = 'M'
	  GROUP BY year) AS m
	  USING (year)
WHERE total_male_names > total_female_names;

--Playing with CTEs
WITH female_names AS (SELECT year, COUNT(DISTINCT name) AS total_female_names
					  FROM names
					  WHERE gender = 'F'
					  GROUP BY year),
	male_names AS (SELECT year, COUNT(DISTINCT name) AS total_male_names
				   	FROM names
				   	WHERE gender = 'M'
				    GROUP BY year)
SELECT year, total_male_names, total_female_names
FROM female_names AS fn INNER JOIN male_names as mn USING(year)
WHERE total_male_names > total_female_names;
--Playing with CASE statements				  
SELECT *
FROM(SELECT year,
		COUNT(DISTINCT CASE WHEN gender = 'M' THEN name END) AS total_male_names,
		COUNT(DISTINCT CASE WHEN gender = 'F' THEN name END) AS total_female_names
	FROM names
	GROUP BY year) AS comparison
WHERE total_male_names > total_female_names
ORDER BY year;
--Pulling out unisex names
SELECT year, total_male_names, total_female_names
FROM (SELECT year, COUNT(DISTINCT name) AS total_female_names
	  FROM names
	  WHERE gender = 'F'
	  AND name NOT IN (SELECT name
					   FROM names
					   WHERE gender = 'F'
					   INTERSECT
					   SELECT name
					   FROM names
					   WHERE gender = 'M')
	  GROUP BY year) AS f
	  INNER JOIN
	  (SELECT year, COUNT(DISTINCT name) AS total_male_names
	  FROM names
	  WHERE gender = 'M'
	  AND name NOT IN (SELECT name
					   FROM names
					   WHERE gender = 'F'
					   INTERSECT
					   SELECT name
					   FROM names
					   WHERE gender = 'M')
	  GROUP BY year) AS m
	  USING (year)
WHERE total_male_names > total_female_names
ORDER BY year;
--There are no years with more distinct male names if you pull out the unisex names
--FROM JOSH'S NOTES, VERY SIMILAR TO MY CASE STATEMENT, BUT AN INTERESTING FEATURE I HADN'T SEEN
SELECT year,
	SUM(CASE WHEN gender = 'F' THEN 1 END) AS distinct_female,
	SUM(CASE WHEN gender = 'M' THEN 1 END) AS distinct_male
FROM names
GROUP BY year
HAVING SUM(CASE WHEN gender = 'M' THEN 1 END) > SUM(CASE WHEN gender = 'F' THEN 1 END);

/*Bonus #9 Which names are closest to being evenly split between male and female usage? For this question, consider only names 
that have been used at least 10000 times in total.*/
SELECT *, ABS(f_registered - m_registered) AS count_dif
FROM (SELECT name, SUM(num_registered) AS total_registered,
		SUM(CASE WHEN gender = 'F' THEN num_registered END) AS F_registered,
		SUM(CASE WHEN gender = 'M' THEN num_registered END) AS M_registered
	  FROM names
	  GROUP BY name) AS counts
WHERE f_registered > 0
AND m_registered> 0
AND total_registered >= 10000
ORDER BY count_dif;
--Santana only has a difference of 93 registrations, Elisha (167), Baby(216), Mckinley(240)
--After looking at Josh's solution, agree that percent difference makes more sense
SELECT *, ABS(f_registered - m_registered) AS count_dif, ROUND(ABS(f_registered - m_registered)*100/(total_registered)::decimal, 3) AS pct_dif
FROM (SELECT name, SUM(num_registered) AS total_registered,
		SUM(CASE WHEN gender = 'F' THEN num_registered END) AS F_registered,
		SUM(CASE WHEN gender = 'M' THEN num_registered END) AS M_registered
	  FROM names
	  GROUP BY name) AS counts
WHERE f_registered > 0
AND m_registered> 0
AND total_registered >= 10000
ORDER BY pct_dif;
---Elisha, Quin, Santana all have less than 1% difference in usage
--FROM JOSH'S NOTES...
WITH females AS (
	SELECT name,
		SUM(num_registered) AS females_registered
	FROM names
	WHERE gender = 'F'
	GROUP BY name),
males AS (
	SELECT name,
		SUM(num_registered) AS males_registered
	FROM names
	WHERE gender = 'M'
	GROUP BY name)
SELECT name, 
	females_registered,
	males_registered,
	ABS(females_registered - males_registered) AS difference,
	ABS(females_registered - males_registered)*100.0/(females_registered + males_registered) AS pct_difference
FROM females
INNER JOIN males
USING (name)
WHERE females_registered + males_registered > 10000
ORDER BY pct_difference;

/*Bonus #10 Which names have been among the top 25 most popular names for their gender in every single year 
contained in the names table?  Hint: you may have to combine a window function and a subquery to answer this question.*/
SELECT name, COUNT(name)
FROM (SELECT name,
		   gender,
		   year,
		   num_registered,
		   RANK () OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS rank_by_year
	 FROM names) AS ranks
WHERE rank_by_year <= 25
GROUP BY name
HAVING COUNT(name) = 139;
--Joseph, William, James

--FROM JOSH'S NOTES...
WITH ranks AS (
	SELECT *,
		RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC)
	FROM names
)
SELECT name, gender
FROM ranks
WHERE rank <= 25
GROUP BY name, gender
HAVING COUNT(*) = (SELECT MAX(year) - MIN(year) + 1
							 FROM names);

/*Bonus #11 Find the name that had the biggest gap between years that it was used.*/
SELECT name,
	   year,
	   year - LAG(year,1) OVER(PARTITION BY name ORDER BY year) AS years_since_last_used
FROM names
ORDER BY years_since_last_used DESC NULLS LAST
LIMIT 1;
--Franc was not used for 115 years when it was used in 2001

/*Bonus #12 Have there been any names that were not used in the first year of the dataset (1880) 
but which made it to be the most-used name for its gender in some year? Difficult follow-up: 
What is the shortest amount of time that a name has gone from not being used at all to being the 
number one used name for its gender in a year?*/
--Full list of names that fit above critera with years that they were the top name
WITH name_ranks AS	(SELECT name,
		   					year,
				 			num_registered,
				 			RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS name_rank
	  				 FROM names)
SELECT *
FROM name_ranks
WHERE name_rank = 1
AND name NOT IN
				(SELECT name
				 FROM names
				 WHERE year = 1880);
--List of distinct names only
WITH name_ranks AS	(SELECT name,
		   					year,
				 			num_registered,
				 			RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS name_rank
	  				 FROM names)
SELECT DISTINCT name
FROM name_ranks
WHERE name_rank = 1
AND name NOT IN
				(SELECT name
				 FROM names
				 WHERE year = 1880);
--Jennifer, Liam, Lisa
--Difficult follow up
WITH name_ranks AS	(SELECT name,
		   					year,
				 			num_registered,
				 			RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS name_rank,
					 		year - MIN(year) OVER(PARTITION BY gender, name) AS years_since_first_used
	  				 FROM names)
SELECT *
FROM name_ranks
WHERE name_rank = 1
AND name NOT IN
				(SELECT name
				 FROM names
				 WHERE year = 1880)
ORDER BY years_since_first_used;
--Jennifer, 55 years from no use to #1

--FROM JOSH'S NOTES...
--He actually set up a table to get the latest UNUSED year where I found the first used year and added one in my final answer
WITH gaps_ranks AS (
	SELECT *,
		year - lag(year) OVER(PARTITION BY name ORDER BY year) AS gap,
		RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS rank
	FROM names
),
max_null_years AS (
	SELECT name, MAX(year)-1 AS latest_unused 
	FROM gaps_ranks
	WHERE gap IS NULL
	GROUP BY name
),
min_top_years AS (
	SELECT name, MIN(year) AS earliest_top
	FROM gaps_ranks
	WHERE rank = 1
	GROUP BY name
)
SELECT *, earliest_top - latest_unused AS zero_to_hero
FROM max_null_years
INNER JOIN min_top_years
USING (name)
WHERE latest_unused > 1879
ORDER BY zero_to_hero;
