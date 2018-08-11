/*Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+ 

For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+


*/


SELECT DISTINCT Salary AS SecondHighestSalary
FROM Employee
ORDER BY Salary
LIMIT 1
OFFSET 1;

/*However we want the answer to be null if the second highest salary is not present. 
Following are the two ways of acheiving that
*/

SELECT IFNULL(
(SELECT DISTINCT Salary 
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 
    OFFSET 1)
, NULL) AS SecondHighestSalary;

SELECT 
(SELECT DISTINCT Salary
FROM Employee
Order By Salary DESC
LIMIT 1 OFFSET 1) 
AS SecondHighestSalary

-------------------------------
/*
Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
*/

SELECT Name AS Customers
FROM Customers as c
LEFT JOIN Orders as O
ON c.Id = O.CustomerId
WHERE O.CustomerId is NULL;

SELECT Name AS Customers
FROM Customers
WHERE Id NOT IN (SELECT CustomerId FROM Orders);

----------------------------------------------

/*Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
*/

SELECT Email 
FROM (SELECT Email, count(*) as dupCount
FROM Person 
GROUP BY Email) AS grouped
WHERE grouped.dupCount > 1;


SELECT Email
FROM Person
GROUP BY Email
HAVING count(Email) > 1;

SELECT Email
FROM Person
GROUP BY Email
HAVING count(*) > 1;

-----------------------------------------------

/*
Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.
Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table.
 

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

FirstName, LastName, City, State

*/

SELECT FirstName, LastName, City, State
FROM Person AS p
LEFT JOIN Address as a
ON (p.PersonId = a.Personid);

-----------------------------------
/*
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+
*/

SELECT e1.Name as Employee
FROM Employee as e1
LEFT JOIN Employee as e2
ON (e1.ManagerId = e2.Id)
WHERE e1.Salary > e2.Salary;
