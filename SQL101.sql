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












