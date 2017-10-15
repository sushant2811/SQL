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

/*Number of films released before 2000*/
SELECT COUNT(*) FROM films WHERE release_year < 2000;

/*Get the title and release year of films released after 2000*/
SELECT title, release_year FROM films WHERE release_year > 2000;

/*Note: where always comes immediately after the table name*/




