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

/*
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
