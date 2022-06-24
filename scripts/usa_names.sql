/* Problem 1
How many rows are in the names table?
*/

SELECT COUNT(*)
FROM names;

/* Answer 1
1,957,046 rows
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 2
How many total registered people appear in the dataset?
*/

SELECT SUM(num_registered)
FROM names;

/* Answer 2
351,653,025 registered people
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 3
Which name had the most appearances in a single year in the dataset?
*/

SELECT name, num_registered
FROM names
ORDER BY num_registered DESC
LIMIT 1;

/* Answer 3
Linda (99,689 appearances)
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 4
What range of years are included?
*/

SELECT MIN(year), MAX(year)
FROM names;

/* Answer 4
1880 - 2018
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 5
What year has the largest number of registrations?
*/

SELECT year, SUM(num_registered) AS total_registered
FROM names
GROUP BY year
ORDER BY total_registered DESC
LIMIT 1;

/* Answer 5
1957 (4,200,022 registrations)
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 6
How many different (distinct) names are contained in the dataset?
*/

SELECT COUNT(DISTINCT name)
FROM names;

/* Answer 6
98,400 distinct names
*/
----------------------------------------------------------------------------------------------------------------
/* Problem 7
Are there more males or more females registered?
*/

SELECT gender, SUM(num_registered)
FROM names
GROUP BY gender;

/* Answer 7
There are about 3,500,000 more males registered.
*/

-- Bryan's concise one
select (case when males > females then 'true' else 'false' end) as are_more_males_than_females_registered
from (select count(gender) from names where gender = 'M') males,
     (select count(gender) from names where gender = 'F') females;


----------------------------------------------------------------------------------------------------------------
/* Problem 8
What are the most popular male and female names overall (i.e., the most total registrations)?
*/

SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'F'
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1;

SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'M'
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1;

/* Answer 8
Mary (4,125,675)
James (5,164,280)
*/

-- Bryan's approach

select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from names
order by total_registrations desc

-- Chris
SELECT name, gender, SUM(num_registered) AS sum_registered
FROM names
GROUP BY name, gender
ORDER BY sum_registered DESC;


----------------------------------------------------------------------------------------------------------------
/* Problem 9
What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
*/

SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'F'
	AND year BETWEEN 2000 AND 2009
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1;

SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'M'
	AND year BETWEEN 2000 AND 2009
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1;

/* Answer 9
Emily (223,690)
Jacob (273,844)
*/

-- Bryan
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from names
where year between 2000 and 2009
order by total_registrations desc


----------------------------------------------------------------------------------------------------------------
/* Problem 10
Which year had the most variety in names (i.e. had the most distinct names)?
*/

SELECT year, COUNT(DISTINCT name) AS distinct_names
FROM names
GROUP BY year
ORDER BY distinct_names DESC
LIMIT 1;

/*
2008 (32,518 distinct names)
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 11
What is the most popular name for a girl that starts with the letter X?
*/

SELECT name, SUM(num_registered) AS total_registered
FROM names
WHERE gender = 'F'
	AND name LIKE 'X%'
GROUP BY name
ORDER BY total_registered
LIMIT 1;

/* Answer 11
Xailey (5) -- It's like Hailey if Hailey became a mutant hero.
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 12
How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
*/

SELECT COUNT(DISTINCT name)
FROM names
WHERE name LIKE 'Q%'
	AND name NOT LIKE '_u%';
	
/* Answer 12
46 distinct Q names that don't have u as a second letter
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 13
Which is the more popular spelling between "Stephen" and "Steven"? 
Use a single query to answer this question.
*/

SELECT name, SUM(num_registered)
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name;

/* Answer 13
Steven is more popular (by about 50%)
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 14
What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?
*/

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

/* Answer 14
10,733 names are unisex out of 98,400 (Problem 6), or 10.9%. 
*/

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


----------------------------------------------------------------------------------------------------------------
/* Problem 15
How many names have made an appearance in every single year since 1880?
*/

-- Corrected

SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;

/* Answer 15
136 names appeared every year between 1880 and 2018
*/

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


----------------------------------------------------------------------------------------------------------------
/* Problem 16
How many names have only appeared in one year?
*/

SELECT name, COUNT(DISTINCT year) AS years_appeared
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 1;

/* Answer 16
21,123 names appeared in only one year
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 17
How many names only appeared in the 1950s?
*/

SELECT name
FROM names
GROUP BY name
HAVING MIN(year) >= 1950 AND MAX(year) <= 1959;

/* Answer 17
661 names only appeared in the 1950s
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 18
How many names made their first appearance in the 2010s?
*/

SELECT name
FROM names
GROUP BY name
HAVING MIN(year) >= 2010;

/* Answer 18
11,270 names only appeared in the 1950s
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 19
Find the names that have not be used in the longest.
*/

SELECT name, 2018 - MAX(year) AS years_since_named
FROM names
GROUP BY name
ORDER BY years_since_named DESC;

/* Answer 19
Zilpah and Roll haven't been used in 137 years.
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 20
Come up with a question that you would like to answer using this dataset. 
Then write a query to answer this question.

- What were the most common male and female names between 1985 and 1994? What were the most common names in 1999 and 2000, respectively?
- Were there years with female Hugos?

*/

-- Common names between 1985 and 1994

SELECT name, gender, SUM(num_registered) AS total_registered
FROM names
WHERE year BETWEEN 1985 AND 1994
AND gender = 'M'
GROUP BY name, gender
ORDER BY total_registered DESC;

SELECT name, gender, SUM(num_registered) AS total_registered
FROM names
WHERE year BETWEEN 1985 AND 1994
AND gender = 'F'
GROUP BY name, gender
ORDER BY total_registered DESC;

-- Female Hugos

SELECT *
FROM names
WHERE name = 'Hugo' AND gender = 'F'
ORDER BY year;

----------------------------------------------------------------------------------------------------------------
/* Bonus 1
Find the longest name contained in this dataset. What do you notice about the long names?
*/

SELECT DISTINCT name, gender, LENGTH(name) AS name_length
FROM names
ORDER BY name_length DESC;

/* Answer B1
The longest names are predominantly male names, but they're all combinations of first names, maybe typos
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 2
How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
*/

SELECT COUNT(DISTINCT name)
FROM names
WHERE name ILIKE REVERSE(name);

/* Answer B2
137 palindrome names
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 3
Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). 
(Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html
)*/

SELECT DISTINCT name
FROM names
WHERE LOWER(name) NOT SIMILAR TO '%(a|e|i|o|u|y)%'

/* Answer B3
43 vowelless names
*/

-- Bryan

select distinct names_examined.name
from (select name, regexp_replace(lower(name), E'[aeiouy]', '', 'g') as modified_name from usa_names) as names_examined
where length(names_examined.name) = length(names_examined.modified_name);


----------------------------------------------------------------------------------------------------------------
/* Bonus 4
How many double-letter names show up in the dataset?
Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. 
Are there any triple-letter names?
*/

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

----------------------------------------------------------------------------------------------------------------
/* Bonus 5
On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. 
Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. 
We'll answer this question in two steps.

a. First, write a query that returns all names that appeared during the 1950s.

b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s. 
See the example "A subquery with the IN operator." on this page: https://www.dofactory.com/sql/subquery.
*/

-- a

SELECT name, MIN(year), MAX(year)
FROM names
GROUP BY name
HAVING (MIN(year) BETWEEN 1950 AND 1959)
AND (MAX(year) BETWEEN 1950 AND 1959)

-- b

SELECT name, MIN(year) AS min_year, MAX(year) max_year
FROM names
WHERE name NOT IN
	(
	SELECT name
	FROM names
	GROUP BY name
	HAVING (MIN(year) BETWEEN 1950 AND 1959)
	AND (MAX(year) BETWEEN 1950 AND 1959)
	)
GROUP BY name
HAVING MIN(year) < 1950 AND MAX(year) > 1959
ORDER BY min_year DESC;

-- Chris
SELECT COUNT(DISTINCT name)
FROM names
WHERE name NOT IN 
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MIN(year) >= 1950
		AND MAX(year) <= 1959
	)
AND name IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MIN(year) < 1950
		AND MAX(year) > 1959
	);


/* Answer B5
14,548 names 
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 6
In question 16, you found how many names appeared in only one year. 
Which year had the highest number of names that only appeared once?
*/

SELECT year, COUNT(DISTINCT name) AS one_offs
FROM names
WHERE name IN 
	(SELECT name AS years_appeared
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 1)
GROUP BY year 
ORDER BY one_offs DESC;

/* Answer B6
2018 had the most unique names
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 7
Which year had the most new names (names that hadn't appeared in any years before that year)? 
For this question, you might find it useful to write a subquery and then select from this subquery. 
See this page about using subqueries in the from clause: https://www.geeksforgeeks.org/sql-sub-queries-clause/
*/

SELECT year, COUNT(*) AS new_names
FROM (SELECT name, year
	 FROM names
	 GROUP BY name, year
	 HAVING MIN(year) = year
	 ORDER BY year) AS s
 GROUP BY year
 ORDER BY new_names DESC;

/* Answer B7
2008 had the most new names (32,518)
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 8
Is there more variety (more distinct names) for females or for males? 
Is this true for all years or are their any years where this is reversed? 
Hint: you may need to make use of multiple subqueries and JOIN them in order to answer this question.
*/

-- overall
SELECT gender, COUNT(DISTINCT name) AS distinct_names
FROM names
GROUP BY gender
ORDER BY distinct_names DESC;

WITH gaps_ranks AS (
	SELECT *,
		year - lag(year) OVER(PARTITION BY name ORDER BY year) AS gap,
		RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC) AS rank
	FROM names
)
SELECT *
FROM gaps_ranks
WHERE name IN (
	SELECT DISTINCT name
	FROM gaps_ranks
	WHERE rank = 1
	)
AND (rank = 1 OR gap IS NULL);

-- by year, wide, CASE WHEN, no subquery

SELECT year,
	SUM(CASE WHEN gender = 'F' THEN 1 END) AS distinct_female,
	SUM(CASE WHEN gender = 'M' THEN 1 END) AS distinct_male
FROM names
GROUP BY year
HAVING SUM(CASE WHEN gender = 'M' THEN 1 END) > SUM(CASE WHEN gender = 'F' THEN 1 END);


/* Answer B8
Females have more distinct names overall (67,698 vs 41,475)
Only the first three years of the data set (1880-1882) have more variety among male names than female names
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 9
Which names are closest to being evenly split between male and female usage? 
For this question, consider only names that have been used at least 10000 times in total.
*/

WITH females AS (
	SELECT name,
		SUM(num_registered) AS females_registered
	FROM names
	WHERE gender = 'F'
	GROUP BY name
),
males AS (
	SELECT name,
		SUM(num_registered) AS males_registered
	FROM names
	WHERE gender = 'M'
	GROUP BY name
)
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

/* Answer B9
Unknown (if that's a name) with a difference of 91, i.e., 0.48%
Otherwise it's Elisha with a difference of 167, i.e., 0.61% (pronunciation difference?)
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 10
Which names have been among the top 25 most popular names for their gender in every single year contained in the names table? 
Hint: you may have to combine a window function and a subquery to answer this question.
*/

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
							 FROM names)

/* Answer B10
James, William, and Joseph have been in the top 25 of the males for every year in the data set
Notably, no female names have been in the top 25 every year
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 11
Find the name that had the biggest gap between years that it was used.
*/

WITH gaps AS (
	SELECT name, 
		year,
		year - lag(year) OVER(PARTITION BY name ORDER BY year) as gap
	FROM names
)
SELECT name, MAX(gap) AS max_gap
FROM gaps
WHERE gap IS NOT NULL
GROUP BY name
ORDER BY max_gap DESC

/* Answer B11
Franc is the name with the biggest gap between uses (118 years)
*/

----------------------------------------------------------------------------------------------------------------
/* Bonus 12
Have there been any names that were not used in the first year of the dataset (1880) 
but which made it to be the most-used name for its gender in some year? 

Difficult follow-up:
What is the shortest amount of time that a name has gone from not being used at all
to being the number one used name for its gender in a year?
*/

-- a

WITH ranks AS (
	SELECT *,
		RANK() OVER(PARTITION BY gender, year ORDER BY num_registered DESC)
	FROM names
)
SELECT name, gender, COUNT(*) AS times_at_top
FROM ranks
WHERE rank = 1
AND name NOT IN (
	SELECT name
	FROM names
	WHERE year = 1880
)
GROUP BY name, gender

-- b

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

/* Answer B12
Jennifer, Liam, and Lisa were not used in 1880 but became the most used name for their gender in other years
Jennifer went from unused to top name in the fewest number of years (55)
*/