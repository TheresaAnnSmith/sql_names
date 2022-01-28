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

SELECT 100*10733.0/98400;

/* Answer 14
10,733 names are unisex out of 98,400 (Problem 6), or 10.9%. 
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 15
How many names have made an appearance in every single year since 1880?
*/

SELECT name, COUNT(name) AS years_appeared
FROM names
GROUP BY name
HAVING COUNT(name) = 139;

/* Answer 15
136 names appeared every year between 1880 and 2018
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 16
How many names have only appeared in one year?
*/

SELECT name, COUNT(name) AS years_appeared
FROM names
GROUP BY name
HAVING COUNT(name) = 1;

/* Answer 15
21,100 names appeared in only one year
*/

----------------------------------------------------------------------------------------------------------------
/* Problem 17
How many names only appeared in the 1950s?
*/

SELECT name)
FROM names
GROUP BY name
HAVING MIN(year) > 1950 AND MAX(year) < 1959;

/* Answer 17
507 names only appeared in the 1950s
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
*/
