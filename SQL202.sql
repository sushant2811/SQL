/*Reference: Joining Data in PostgreSQL*/

/*
Basic syntax for an INNER JOIN, here including 
all columns in both tables:

SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
*/

SELECT cities.name AS city, countries.name AS country, countries.region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

/*
Select

country code,
name of the country,
year, and
inflation rate
as the fields from an inner join of countries on the left with economies on the right. 
(What field do you need to use in ON to match the two tables?)

Alias countries AS c and economies AS e.

Alias c.code AS country_code. Don't alias the other fields.
*/
SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
FROM countries AS c
INNER JOIN economies AS e
ON c.code = e.code;

/* Now, for each country, you want to get the country name, its region, and 
the fertility rate and unemployment rate for both 2010 and 2015 (those are the only 
years included in the economics and population table) */
SELECT c.code, c.name, c.region, p.year, p.fertility_rate, e.unemployment_rate, e.year
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code AND p.year = e.year

/*
SELECT c.name AS country, l.name AS language
FROM countries AS c
INNER JOIN languages AS l;

gives an error because INNER JOIN requires a specification of the key field 
(or fields) in each table.
*/

/****** USING **************/

/*
When joining tables with a common field name (e.g. countries.code = cities.code), 
you can use USING as a shortcut. Here, you could just do USING (code)

Paranthesis are important
*/

/*
Inner join countries on the left and languages on the right USING code. Select the fields corresponding to

country name AS country,
continent name,
language name AS language, and
whether or not the language is official.
*/

SELECT c.name AS country, c.continent, l.name AS language, l.official
FROM countries AS c
INNER JOIN languages AS l
USING (code);

/**** Self-join ***/

/*
In this exercise, you'll use the populations table to perform a self-join to 
calculate the percentage increase in population from 2010 to 2015 for each 
country code!
*/

/*step 1*/

SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code

/*This produces a result that for each country_code has four entries 
laying out all combinations of 2010 and 2015*/

/*step 2*/
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code AND p1.year = p2.year - 5

/*The last AND condition removes the three combinations we are not interested 
in*/
/*Finally to get the percentage do the following*/

/* step 3*/
SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015, 
       (p2.size - p1.size) / p1.size * 100.0 AS growth_perc 
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code AND p1.year = p2.year - 5

/* CASE WHEN and THEN */

SELECT name, continent, code, surface_area,
  CASE WHEN surface_area > 2000000 THEN 'large'
       WHEN surface_area > 350000 THEN 'medium'
       ELSE 'small' END
       AS geosize_group
FROM countries

/*
Using the populations table focused only on 2015, create a new field 
AS popsize_group to organize population size into

'large' (> 50 million),
'medium' (> 1 million), and
'small' groups.
Select only the country code, population size, and this new popsize_group as 
fields
*/

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
         WHEN size > 1000000 THEN 'medium'
         ELSE 'small' END
         AS popsize_group
FROM populations  
WHERE year = 2015

/*
Use INTO to save the result of the previous query as pop_plus. 
You can see an example of this in the countries_plus code in the assignment text. 
Make sure to include a ; at the end of your WHERE clause!

Then, include another query below your first query to display all the records 
in pop_plus using SELECT * FROM pop_plus; so that you generate results and this 
will display pop_plus in query result.
*/

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
         WHEN size > 1000000 THEN 'medium'
         ELSE 'small' END
         AS popsize_group
INTO pop_plus         
FROM populations  
WHERE year = 2015;

SELECT * FROM pop_plus;

/*
Keep the first query intact that creates pop_plus using INTO.
Remove the SELECT * FROM pop_plus; code and instead write a second query to join 
countries_plus AS c on the left with pop_plus AS p on the right matching on the 
country code fields.
Select country name, continent, the surface area grouping (NOT surface_area), 
and the population grouping fields. (Four fields total.)
Sort the data based on geosize_group, in ascending order so that large appears on top
*/

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
         WHEN size > 1000000 THEN 'medium'
         ELSE 'small' END
         AS popsize_group
INTO pop_plus         
FROM populations  
WHERE year = 2015;

SELECT c.name, c.continent, c.geosize_group, p.popsize_group
FROM countries_plus AS c
INNER JOIN pop_plus AS p
ON c.code = p.country_code
ORDER BY c.geosize_group DESC

/* LEFT JOIN.  Keep entries in the left table which have no matching partner in 
the left table as well*/

SELECT c1.name AS city, 
       code, 
       c2.name AS country,
       c2.region, c1.city_proper_pop
FROM cities AS c1
LEFT JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC

/* When it is unambiguous, can use the field name w/o specifying the table name. 
For instance in the code above we can just use 'code' in SELECT because it 
appears in only one table*/

SELECT c.name AS country, 
       local_name, 
       l.name AS language,
       percent
FROM countries AS c
LEFT JOIN languages AS l
ON c.code = l.code
ORDER BY country DESC

/*
Use the AVG() function in combination with left join to 
determine the average gross domestic product (GDP) per capita by region in 2010.
Arrange from highest to lowest average GDP per capita
*/
SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
ON c.code = e.code
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp DESC

/** RIGHT JOIN **/

/*
Right joins aren't as common as left joins. One reason why is that you can 
always write a right join as a left join.
*/

/*
The left join code is commented out here. Your task is to write a new query 
using rights joins that produces the same result as what the query using left 
joins produces. Keep this left joins code commented as you write your own query 
just below it using right joins to solve the problem.

Note the order of the joins matters in your conversion to using right joins!
*/

-- convert this code to use RIGHT JOINs instead of LEFT JOINs
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
LEFT JOIN countries
ON cities.country_code = countries.code
LEFT JOIN languages
ON countries.code = languages.code
ORDER BY city, language;
*/

SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
ON languages.code = countries.code
RIGHT JOIN cities
ON countries.code = cities.country_code
ORDER BY city, language;

/**  FULL JOIN **/

SELECT name AS country, code, region, basic_unit
FROM currencies
FULL JOIN countries
USING (code)
WHERE region = 'North America' OR region IS NULL
ORDER BY region;


SELECT name AS country, code, region, basic_unit
FROM countries
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' OR region IS NULL
ORDER BY region;


SELECT countries.name, code, languages.name AS language
FROM languages
FULL / LEFT/ INNER JOIN countries
/*Look at these three different joins consecutively to understand the differemce*/
USING (code)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;


SELECT c1.name AS country,
       region, l.name,
       basic_unit, frac_unit
FROM countries AS c1
FULL JOIN languages AS l
USING (code)
FULL JOIN currencies AS c2
USING (code)
WHERE region LIKE 'M%esia'

/* CROSS JOIN */
/*
CROSS JOIN is a result of all combinations in the left and right table. 
Note that CROSS JOIN does not use ON or USING (as other joins)
*/
SELECT c.name AS city, l.name AS language
FROM cities AS c
CROSS JOIN languages AS l
WHERE c.name LIKE 'Hyder%'

SELECT c.name AS city, l.name AS language
FROM cities AS c
INNER JOIN languages AS l
ON c.country_code = l.code
WHERE c.name LIKE 'Hyder%'


SELECT c.name AS city, l.name AS language
FROM cities AS c
CROSS JOIN languages AS l
WHERE c.name LIKE 'Hyder%'

/*
In terms of life expectancy for 2010, determine the names of the lowest 
five countries and their regions.
*/

SELECT c.name AS country,
       region, 
       life_expectancy AS life_exp
FROM countries AS c
LEFT JOIN populations AS p
ON c.code = p.country_code
WHERE year = 2010
ORDER BY life_exp
LIMIT 5
