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



























