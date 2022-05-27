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
ORDER BY num_registered DESC;
--Linda, 99,689 in 1947

/*4. What range of years are included?*/
SELECT MAX(year), MIN(year)
FROM names;
--1880 to 2018

/*5. What year has the largest number of registrations?*/
SELECT SUM(num_registered) AS total_registered, year
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC;
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

/*8. What are the most popular male and female names overall (i.e., the most total registrations)?*/
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC;
-- Most popular overall female name is Mary (4,125,675 registered)
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY SUM(num_registered) DESC;
--Most popular overall male name is James (5,164,280)

/*9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?*/
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'F'
AND year BETWEEN 2000 AND 2009
GROUP BY name
ORDER BY SUM(num_registered) DESC;
--Most popular female name of this decade is Emily (223,690)
SELECT name, SUM(num_registered)
FROM names
WHERE gender = 'M'
AND year BETWEEN 2000 AND 2009
GROUP BY name
ORDER BY SUM(num_registered) DESC;
--Most popular male name of this decade is Jacob (273,844)

/*10. Which year had the most variety in names (i.e. had the most distinct names)?*/
SELECT year, COUNT(DISTINCT name) AS num_names
FROM names
GROUP BY year
ORDER BY num_names DESC;
--2008 with 32,518 distinct names

/*11. What is the most popular name for a girl that starts with the letter X?*/
SELECT name, SUM(num_registered)
FROM names
WHERE name LIKE 'X%'
AND gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC;
--Ximena with 26,145 registrations
/*The below works for the number, but can't add the name column in to the first line, is there a better
or different way to get the name too?*/
SELECT MAX(total_registered)
FROM (SELECT name, SUM(num_registered) AS total_registered
	FROM names
	WHERE name LIKE 'X%'
	AND gender = 'F'
	GROUP BY name) AS a;
	
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
/*SELECT name
FROM names
WHERE gender = 'F'
AND gender = 'M'*/

/*15. How many names have made an appearance in every single year since 1880?*/
SELECT COUNT(*)
FROM(SELECT name, COUNT(name)
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 139) AS a;
--136

/*16. How many names have only appeared in one year?*/
SELECT COUNT(*)
FROM(SELECT name, COUNT(name)
	FROM names
	GROUP BY name
	HAVING COUNT(name) = 1) AS a;
--21,100

/*17. How many names only appeared in the 1950s?*/


/*18. How many names made their first appearance in the 2010s?*/


/*19. Find the names that have not be used in the longest.*/

