--1. Classic American names (Names that have appeared in all 101 years)
SELECT
	first_name,
	SUM(num) AS sum
FROM usa_baby_names
GROUP BY first_name
HAVING COUNT(first_name) = 101
ORDER BY sum DESC;

--2. Timeless or trendy? (Categorize names as 'Classic', 'Semi-classic', 'Semi-trendy', or 'Trendy' based on recurrence)
SELECT
	first_name,
	SUM(num) AS sum,
	CASE
		WHEN COUNT(first_name) > 80 THEN 'Classic'
		WHEN COUNT(first_name) > 50 THEN 'Semi-classic'
		WHEN COUNT(first_name) > 20 THEN 'Semi-trendy'
		WHEN COUNT(first_name) > 0 THEN 'Trendy'
		ELSE NULL
	END AS popularity_type
FROM usa_baby_names
GROUP BY first_name
ORDER BY first_name;

--3. Top 10 ranked female names since 1920
SELECT TOP 10
	RANK() OVER(ORDER BY SUM(num) DESC) as name_rank,
	first_name,
	SUM(num) AS sum
FROM usa_baby_names
WHERE sex = 'F'
GROUP BY first_name
ORDER BY sum DESC;

--4. The most popular girl's name since 2015 that ends with an 'a'
SELECT
	first_name,
	SUM(num) AS sum
FROM usa_baby_names
WHERE sex = 'F'
	AND	year > 2015
	AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY sum DESC;

--5. When did the name 'Olivia' start becoming popular?
SELECT
	year,
	first_name,
	num,
	SUM(num) OVER(ORDER BY year) AS cumulative_olivias
FROM usa_baby_names
WHERE first_name = 'Olivia';

--6. The most popular male name by year
SELECT
	subquery.year,
	first_name,
	num
FROM (
SELECT
	year,
	MAX(num) AS max_num
FROM usa_baby_names
WHERE sex = 'M'
GROUP BY year) AS subquery
LEFT JOIN usa_baby_names AS ubn
ON subquery.max_num = ubn.num
ORDER BY year DESC;

--7. The male name with most years at number one
WITH CTE AS(
SELECT
	subquery.year,
	first_name,
	num
FROM (
SELECT
	year,
	MAX(num) AS max_num
FROM usa_baby_names
WHERE sex = 'M'
GROUP BY year) AS subquery
LEFT JOIN usa_baby_names AS ubn
ON subquery.max_num = ubn.num)

SELECT 
	first_name,
	COUNT(first_name) AS top_name_count
FROM CTE
GROUP BY first_name
ORDER BY top_name_count DESC;