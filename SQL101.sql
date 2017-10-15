/*Reference: Intro to SQL for Data Science course on DataCamp*/

/* Selecting one and more fields from a table */

SELECT title FROM films;

SELECT title, release_year FROM films;

SELECT title, release_year, country FROM films;

SELECT * FROM films;

/* DISTINCT */

SELECT DISTINCT country FROM films; /*say want to know which countries are 
represented in the films table*/

SELECT DISTINCT role FROM roles;

/* COUNT -- allows to count number of rows */

SELECT COUNT(*) FROM reviews /*Getting number of records in the reviews table*/

SELECT COUNT(*) FROM people; /*number of rows in the people table*/

SELECT COUNT(birthdate) FROM people; /*number of non-missing birth dates in the 
people table*/

/*Number of unique birthdate*/
SELECT COUNT(DISTINCT birthdate) FROM people; 

/*Count the number of unique languages in the films table*/
SELECT COUNT(DISTINCT language) FROM films;


/***********  Filtering results  ***************************/

/*Get all details of films released in 2016*/
SELECT * FROM films WHERE release_year = 2016;
/*Note: it is not '==' but '='*/

/*Number of films released before 2000*/
SELECT COUNT(*) FROM films WHERE release_year < 2000;

/*Get the title and release year of films released after 2000*/
SELECT title, release_year FROM films WHERE release_year > 2000;

/*Note: where always comes immediately after the table name*/

/*Get all details for all French language films*/
SELECT * FROM films WHERE language = 'French'

/*The name and birth date of the person born on November 11th, 1974*/
SELECT name, birthdate FROM people WHERE birthdate = '1974-11-11';

/*Number of Hindi language films*/
SELECT COUNT(*) FROM films WHERE language = 'Hindi';

/*all details for all films with an R certification*/
SELECT * FROM films WHERE certification = 'R';

/* Using multiple conditions */

/* title and release year for all Spanish language films released before 2000*/
SELECT title, release_year
FROM films
WHERE language = 'Spanish' 
AND release_year < 2000;

/*Note that the column name needs to be specified for every condition*/

/*all details for Spanish language films released after 2000, but before 2010*/
SELECT *
FROM films
WHERE language = 'Spanish' 
AND release_year > 2000 
AND release_year < 2010;

/*get the title and release year of films released in the 90s which were in 
French or Spanish and which took in more than $2M gross.*/

SELECT title, release_year 
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND gross > 2000000;

/*Build queries one step at a time*/

/* BETWEEN -- remember its inclusive, meaning the beginning and end values are 
included in the results */

/*get the title and release year of all Spanish language films released between 
1990 and 2000 (inclusive) with budgets over $100 million*/
SELECT title, release_year 
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND (language = 'Spanish' OR language = 'French')

/*IN operator*/

/*Get the title and release year of all films released in 1990 or released 
in 2000 that were longer than two hours*/

SELECT title, release_year
FROM films
WHERE release_year IN (1990, 2000)
AND duration > 120

/*Get the title and language of all films which were in English, 
Spanish, or French*/
SELECT title, language
FROM films
WHERE language IN ('English', 'Spanish', 'French');

/*NULL and IS NULL*/

/*Get the names of people who are still alive, i.e. whose death date is missing*/
SELECT name 
FROM people
WHERE deathdate IS NULL;

/*Get the number of films which don't have a language associated with them*/
SELECT COUNT(*)
FROM films
WHERE language IS NULL;

/*LIKE and NOT LIKE*/

/*Get the names of all people whose names begin with 'B'*/
SELECT name 
FROM people
WHERE name LIKE 'B%';

/*Get the names of people whose names have 'r' as the second letter*/
SELECT name 
FROM people
WHERE name LIKE '_r%';

/*Get the names of people whose names don't start with A*/
SELECT name 
FROM people
WHERE name NOT LIKE 'A%'

/******* Aggregate functions *************/

/* Use the SUM function to get the total duration of all films */
SELECT SUM(duration) 
FROM films;

/* Get the average duration of all films */
SELECT AVG(duration)
FROM films;

/* Get the duration of the shortest film */
SELECT MIN(duration)
FROM films;

/* get the total amount grossed by all films made in the year 2000 or later */
SELECT SUM(gross)
FROM films
WHERE release_year >= 2000;

/* Get the average amount grossed by all films whose titles start with the 
letter 'A' */
SELECT AVG(gross)
FROM films
WHERE title LIKE 'A%';

/* Get the amount grossed by the worst performing film in 1994 */
SELECT MIN(gross)
FROM films
WHERE release_year = 1994;

/* Get the amount grossed by the best performing film between 2000 and 2012, 
inclusive */
SELECT MAX(gross)
FROM films
WHERE release_year BETWEEN 2000 AND 2012;

/* AS aliasing */

/* Get the title and net profit (the amount a film grossed, minus its budget) 
for all films. Alias the net profit as net_profit */
SELECT title, gross - budget AS net_profit
FROM films;

/* Get the title and duration in hours for all films */
SELECT title, duration / 60.0 AS duration_hours
FROM films;

/* Get the percentage of people who are no longer alive. 
Alias the result as percentage_dead */

SELECT (COUNT(deathdate) * 100.0 / COUNT(*))   AS percentage_dead
FROM people;

/* Looks like COUNT counts only the non-null values */

/* Get the number of decades the films table covers. 
Alias the result as number_of_decades */

SELECT (MAX(release_year) - MIN(release_year)) / 10.0 AS number_of_decades
FROM films;

/******** Sorting, grouping, and joins *************/ 

/* Get the names of people from the people table, sorted alphabetically */
SELECT name 
FROM people
ORDER BY name

/* Get the birth date and name for every person, in order of when they were born */
SELECT birthdate, name
FROM people
ORDER BY birthdate;

/* Get the title of films released in 2000 or 2012, in the order they were released */
SELECT title 
FROM films
WHERE release_year IN (2000, 2012)
ORDER BY release_year

/* Get all details for all films except those released in 2015 and order them 
by duration */
SELECT * 
FROM films
WHERE release_year NOT IN (2015) /*the parantheses here are required*/
ORDER BY duration;

/* Get the title and gross earnings for movies which begin with the letter 'M' 
and order the results alphabetically */
SELECT title, gross
FROM films
WHERE title LIKE 'M%';

/* Get the IMDB score and film ID for every film from the reviews table, 
sorted from highest to lowest score */
SELECT imdb_score, film_id
FROM reviews 
ORDER BY imdb_score DESC;

/* Get the title for every film, in reverse order */
SELECT title 
FROM films
ORDER BY films DESC;

/* Get the title and duration for every film, in order of longest duration 
to shortest */
SELECT title, duration
FROM films
ORDER BY duration DESC;

/* Sorting over two columns -- sorts by the first column specified, 
then sort by the next, then the next, and so on. The order of columns is important */

/* Get the birth date and name of people in the people table, 
in order of when they were born and alphabetically by name */
SELECT birthdate, name 
FROM people
ORDER BY birthdate, name;

/* Get the release year, duration, and title of films ordered by their 
release year and duration */
SELECT release_year, duration, title
FROM films
ORDER BY release_year, duration;


/******** GROUP BY *****************/

/* SQL will return an error if you try to SELECT a field that is not in your 
GROUP BY clause without using it (the field that is not in GROUP BY) to 
calculate some kind of value about the 
entire group -- see the second example below. */

/* GROUP BY always goes after the FROM clause, but not necessary immediately 
after. The WHERE clause takes the precedence.  GROUP BY can be combined with 
ORDER BY. ORDER BY always goes after GROUP BY */

/* Get the release year and count of films released in each year */
SELECT release_year, COUNT(*)
FROM films
GROUP BY release_year;

/* Get the release year and average duration of all films, grouped by release 
year */
SELECT release_year, AVG(duration)
FROM films
GROUP BY release_year;

/* Get the IMDB score and count of film reviews grouped by IMDB score in the 
reviews table */
SELECT imdb_score, COUNT(*)
FROM reviews
GROUP BY imdb_score

/* Get the language and total gross amount films in each language made */
SELECT language, SUM(gross)
FROM films
GROUP BY language;

/* Get the release year, country, and highest budget spent making a film for 
each year, for each country. Sort your results by release year and country */
SELECT release_year, country, MAX(budget)
FROM films
GROUP BY release_year, country
ORDER BY release_year, country;
























