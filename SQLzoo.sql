/*
SQLZOO Helpdesk Answers
Questions available at http://sqlzoo.net/wiki/Help_Desk
*/

/*
#1. There are three issues that include the words "index" and "Oracle". Find the call_date for each of them
*/

SELECT call_date, call_ref 
FROM Issue 
WHERE detail LIKE  '%index%' 
AND detail LIKE '%Oracle%' ;

/*
#2. Samantha Hall made three calls on 2017-08-14. Show the date and time for each
*/

SELECT call_date, first_name, last_name
FROM Caller
JOIN Issue
using (Caller_id)
WHERE First_name = 'Samantha' AND Last_name='Hall' AND date(call_date) = '2017-08-14'

/*
3.
There are 500 calls in the system (roughly). Write a query that shows the number that have each status.
*/

SELECT Status,
count(*) AS Volume
FROM Issue
GROUP BY 1

/*
 4.
Calls are not normally assigned to a manager but it does happen. How many calls have been assigned to staff who are at Manager Level?
*/

SELECT COUNT(*) AS mlcc
FROM Issue AS i
JOIN Staff AS s
ON i.assigned_to = s.Staff_code
JOIN Level AS l
USING (Level_code)
WHERE Manager = 'Y'

/*
5. Show the manager for each shift. Your output should include the shift date and type; also the first and last name of the manager.
*/

SELECT Shift_date, shift_type, first_name, last_name 
FROM Shift
JOIN Staff
ON (Shift.Manager = Staff.staff_code)
ORDER BY 1

/*
6. List the Company name and the number of calls for those companies with more than 18 calls.
*/

SELECT Company_name, COUNT(Call_ref) AS cc
FROM Issue
JOIN Caller
USING (Caller_id)
JOIN
Customer
USING (Company_ref)
GROUP BY 1
HAVING cc > 18;

/*
7.
Find the callers who have never made a call. Show first name and last name
*/

SELECT first_name, last_name
FROM Caller
WHERE Caller_id 
NOT IN (SELECT DISTINCT Caller_id FROM Issue);

/*
8.
For each customer show: Company name, contact name, number of calls where the number of calls is fewer than 5
*/

SELECT Company_name, first_name, last_name, nc
FROM
(SELECT Company_name, Contact_id, COUNT(Call_ref) AS nc
FROM Issue
JOIN Caller
USING (Caller_id)
JOIN
Customer
USING (Company_ref)
GROUP BY 1, 2
HAVING nc < 5) AS j
JOIN Caller
ON Caller_id = j.Contact_id;

/*
9.
For each shift show the number of staff assigned. Beware that some roles may be NULL and that the same person might have been assigned to multiple roles (The roles are 'Manager', 'Operator', 'Engineer1', 'Engineer2').
*/

SELECT Shift_date, Shift_type, COUNT(DISTINCT role) as cw
FROM
(SELECT Shift_date, Shift_type, Manager AS role FROM Shift
UNION ALL 
SELECT Shift_date, Shift_type, Operator AS role FROM Shift
UNION ALL 
SELECT Shift_date, Shift_type, Engineer1 AS role FROM Shift
UNION ALL 
SELECT Shift_date, Shift_type, Engineer2 AS role FROM Shift) AS u
GROUP BY 1, 2
ORDER BY 1, 2

/*
10. Caller 'Harry' claims that the operator who took his most recent call was abusive and insulting. Find out who took the call (full name) and when.
*/

SELECT First_name, last_name, Call_date
FROM Staff
JOIN
(SELECT Call_date, taken_by
FROM Caller
JOIN Issue 
USING (Caller_id)
WHERE First_name = 'Harry' 
ORDER BY Call_date DESC LIMIT 1) AS j
ON (j.Taken_by = Staff.Staff_code)


-------------------------------------------------------------------
-----------Guest House problem--------------
------------------------------------------

/*1.
Guest 1183. Give the booking_date and the number of nights for guest 1183.*/

SELECT booking_date, nights
FROM booking 
WHERE guest_id = 1183

/*2. When do they get here? List the arrival time and the first and last names for all guests due to arrive on 2016-11-05, order the output by time of arrival.*/

SELECT arrival_time, first_name, last_name
FROM booking 
INNER JOIN guest
ON booking.guest_id = guest.id
WHERE booking_date = '2016-11-05'
ORDER BY 1

/*3. Look up daily rates. Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295. Include booking id, room type, number of occupants and the amount.*/

SELECT booking_id, room_type_requested, occupants, amount
FROM booking
JOIN rate 
ON (room_type_requested = room_type AND occupants = occupancy)
WHERE booking_id IN (5152, 5165, 5154, 5295)

/*
4.
Who’s in 101? Find who is staying in room 101 on 2016-12-03, include first name, last name and address.
*/

SELECT first_name, last_name, address
FROM booking
JOIN guest
ON guest_id = id
WHERE room_no = 101 AND booking_date='2016-12-03'

/*
5. How many bookings, how many nights? For guests 1185 and 1270 show the number of bookings made and the total number nights. Your output should include the guest id and the total number of bookings and the total number of nights.*/

SELECT guest_id, COUNT(booking_id), sum(nights)
FROM booking
WHERE guest_id = 1185 OR guest_id = 1270
GROUP BY 1

/*
6.
Ruth Cadbury. Show the total amount payable by guest Ruth Cadbury for her room bookings. You should JOIN to the rate table using room_type_requested and occupants.*/

SELECT sum(nights * amount)
FROM booking
JOIN rate 
ON (room_type_requested = room_type AND occupants = occupancy)
WHERE guest_id = (SELECT id FROM guest WHERE first_name='Ruth' AND last_name='Cadbury')

SELECT sum(nights * amount)
FROM booking
JOIN rate 
ON (room_type_requested = room_type AND occupants = occupancy AND guest_id = (SELECT id FROM guest WHERE first_name='Ruth' AND last_name='Cadbury'))

/*7.Including Extras. Calculate the total bill for booking 5128 including extra.

Note that the answer shown is inaccurate. 
*/

SELECT amount + extra_amount AS total_amount
FROM
(SELECT booking_id, sum(nights * amount) AS amount
FROM booking
JOIN rate
ON (room_type_requested = room_type AND occupants = occupancy)
WHERE booking_id = 5128
GROUP BY 1) AS a
JOIN (SELECT booking_id, sum(amount) AS extra_amount
FROM extra 
WHERE booking_id=5128
GROUP BY 1) AS b
using (booking_id)

/*
8. Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked. Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. Order by last name then first name.*/

SELECT last_name, first_name, address, IFNULL(sum(nights), 0) AS nights
FROM guest 
LEFT JOIN booking 
ON booking.guest_id = guest.id
WHERE address LIKE '%Edinburgh%'
GROUP BY 1, 2, 3 
ORDER BY 1, 2

SELECT last_name, first_name, address, COALESCE(sum(nights), 0) AS nights
FROM guest 
LEFT JOIN booking 
ON booking.guest_id = guest.id
WHERE address LIKE '%Edinburgh%'
GROUP BY 1, 2, 3 
ORDER BY 1, 2

SELECT last_name, first_name, address, 
CASE WHEN sum(nights) IS NULL THEN 0
ELSE sum(nights) END AS nights
FROM guest 
LEFT JOIN booking 
ON booking.guest_id = guest.id
WHERE address LIKE '%Edinburgh%'
GROUP BY 1, 2, 3 
ORDER BY 1, 2

/*
9.
Show the number of people arriving. For each day of the week beginning 2016-11-25 show the number of people who are arriving that day.*/

SELECT booking_date, COUNT(booking_id)
FROM booking
WHERE booking_date BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY 1

/*The above query gives the answer on the website, but I believe it only gives the number of people who made booking for the given day. 
To get the total number of people arriving, we can use the occupants as a proxy*/

SELECT booking_date, sum(occupants)
FROM booking
WHERE booking_date BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY 1

/*10.
How many guests? Show the number of guests in the hotel on the night of 2016-11-21. Include all those who checked in that day or before but not those who have check out on that day or before.*/

SELECT sum(occupants)
FROM booking
WHERE booking_id IN
(SELECT DISTINCT booking_id
FROM booking
WHERE booking_date <= '2016-11-21' AND DATE_ADD(booking_date, INTERVAL 1*nights DAY) > '2016-11-21')

SELECT sum(occupants)
FROM booking
WHERE booking_id IN
(SELECT DISTINCT booking_id
FROM booking
WHERE booking_date <= '2016-11-21' AND DATEDIFF('2016-11-21', booking_date) < nights) 

/*
The following query works as well because booking_id is the primary key*/

SELECT
	sum(occupants)
FROM
	booking
WHERE
	booking_date <= '2016-11-21'
	AND DATE_ADD(booking_date, INTERVAL nights DAY) > '2016-11-21'

/*By the same logic we can drop distinct in the previous queries*/

SELECT sum(occupants)
FROM booking
WHERE booking_id IN
(SELECT booking_id
FROM booking
WHERE booking_date <= '2016-11-21' AND DATEDIFF('2016-11-21', booking_date) < nights) 

/*
11. Coincidence. Have two guests with the same surname ever stayed in the hotel on the evening? Show the last name and both first names. Do not include duplicates.
*/

SELECT DISTINCT a.last_name, a.first_name, b.first_name 
FROM
(SELECT * 
FROM booking 
JOIN guest
ON guest.id = booking.guest_id) AS a
JOIN (SELECT * 
FROM booking 
JOIN guest
ON guest.id = booking.guest_id) AS b
ON (a.last_name = b.last_name AND a.first_name > b.first_name)
WHERE a.booking_date <= b.booking_date 
AND DATEDIFF(b.booking_date, a.booking_date) < a.nights
ORDER BY 1

/*using a.first_name > b.first_name instead of just a.first_name <> b.first_name makes sure we exclude the duplicates*/

/*
12. Check out per floor. The first digit of the room number indicates the floor – e.g. room 201 is on the 2nd floor. For each day of the week beginning 2016-11-14 show how many guests are checking out that day by floor number. Columns should be day (Monday, Tuesday ...), floor 1, floor 2, floor 3.
*/

SELECT DATE_ADD(booking_date, INTERVAL nights DAY) AS i, 
SUM(CASE WHEN room_no LIKE '1%' THEN 1 ELSE 0 END) AS '1st',
SUM(CASE WHEN room_no LIKE '2%' THEN 1 ELSE 0 END) AS '2nd',
SUM(CASE WHEN room_no LIKE '3%' THEN 1 ELSE 0 END) AS '3rd'
FROM booking 
WHERE DATE_ADD(booking_date, INTERVAL nights DAY) BETWEEN '2016-11-14' AND '2016-11-20'
GROUP BY 1


/*-------------------------------------------------
---------------USING SELECT WITHIN SELECT----------
------------------------------------------------*/

/*Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.*/

SELECT name 
FROM world 
WHERE continent = 'Europe' 
AND gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')

/*List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
*/

SELECT name, continent 
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY 1;

/*
Which country has a population that is more than Canada but less than Poland? Show the name and the population.
*/

SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada') 
AND population < (SELECT population FROM world WHERE name = 'Poland');

/*5.
Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.

Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.*/ 

SELECT name, CONCAT(ROUND(population * 100 / (SELECT population FROM world WHERE name = 'Germany'),0), '%') 
FROM world
WHERE continent = 'Europe';

/*
6.
Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)*/

SELECT name 
FROM world 
WHERE gdp > ALL(SELECT IFNULL(gdp,0) FROM world WHERE continent = 'Europe');

/*7.
Find the largest country (by area) in each continent, show the continent, the name and the area:*/

SELECT continent, name, area
FROM world AS w1
WHERE area >= ALL (SELECT area FROM world AS w2 
WHERE w1.continent = w2.continent);

/*
The above example is known as a correlated or synchronized sub-query.

Using correlated subqueries
A correlated subquery works like a nested loop: the subquery only has access to rows related to a single record at a time in the outer query. The technique relies on table aliases to identify two different uses of the same table, one in the outer query and the other in the subquery.

One way to interpret the line in the WHERE clause that references the two table is “… where the correlated values are the same”.

In the example provided, you would say “select the country details from world where the population is greater than or equal to the population of all countries where the continent is the same”.
*/

/*
8.
List each continent and the name of the country that comes first alphabetically
*/

SELECT continent, min(name)
FROM world 
GROUP BY 1;

SELECT continent, name
FROM world AS w1
WHERE name <= ALL (SELECT name FROM world AS w2 WHERE w1.continent = w2.continent);

/*
9.
Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.*/

SELECT name, continent, population 
FROM world
WHERE continent IN 
(SELECT continent FROM world 
GROUP BY continent HAVING max(population) <= 25000000);

SELECT name, continent, population 
FROM world AS w1
WHERE 25000000 > ALL (SELECT population FROM world w2 WHERE w1.continent = w2.continent);

/*10.
Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.*/   

SELECT name, continent 
FROM world w1
WHERE population >  ALL (SELECT 3.0 * population FROM world w2 
WHERE w1.continent = w2.continent AND w1.name <> w2.name);
