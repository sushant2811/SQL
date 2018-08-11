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
