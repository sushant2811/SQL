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
