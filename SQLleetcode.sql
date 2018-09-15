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

----------------------------------------

/*
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
For example, return the following Ids for the above Weather table:

+----+
| Id |
+----+
|  2 |
|  4 |
+----+

*/

SELECT w1.Id as Id
FROM Weather AS w1
LEFT JOIN Weather as w2
ON (w1.RecordDate = DATE_Add(w2.RecordDate, INTERVAL 1 DAY))
WHERE w1.Temperature > w2.Temperature;

-- We can use the DATEDIFF function as well. Seems to be faster than DATE_ADD

SELECT w1.Id as Id
FROM Weather AS w1
LEFT JOIN Weather as w2
ON (DATEDIFF(w1.RecordDate, w2.RecordDate) = 1)
WHERE w1.Temperature > w2.Temperature;

/*
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Note:

Your output is the whole Person table after executing your sql. Use delete statement.
*/

DELETE p1 FROM 
Person p1
LEFT JOIN Person p2
ON (p1.Email = p2.Email)
WHERE p1.Id > p2.Id;

DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id


/*
Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.
For example:
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
After running your query, the above salary table should have the following rows:
| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |

*/

UPDATE salary
SET sex = CASE WHEN sex = 'f' then 'm'
               WHEN sex = 'm' then 'f'
          END

UPDATE salary
SET sex = CASE WHEN sex = 'f' then 'm'
               ELSE 'f'
          END 

---------------------------
/*
There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:

+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
Should output:

+---------+
| class   |
+---------+
| Math    |
+---------+
Note:
The students should not be counted duplicate in each course.
*/

SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5;

-------------------------------

/*
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
*/

SELECT Score, DENSE_RANK() OVER (ORDER BY Score DESC) AS Rank
FROM Scores; -- T-SQL query. Window functions not present in MySQL 

/*
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
*/

SELECT DISTINCT l1.Num as ConsecutiveNums 
FROM Logs AS l1, 
Logs AS l2, 
Logs AS l3
WHERE l2.id = l1.id + 1 AND l3.id = l2.id + 1
AND l1.Num = l2.Num and l1.Num = l3.Num;

SELECT DISTINCT l3.Num AS ConsecutiveNums  
FROM
(SELECT l2.id as l12_id, l2.Num as l12_Num
FROM Logs AS l1
INNER JOIN Logs AS l2
ON (l2.id = l1.id + 1 AND l1.Num = l2.Num)) AS l12
INNER JOIN Logs AS l3
ON (l3.id = l12_id + 1 AND l3.Num = l12_Num)

--- moving the number equality condition from ON to where clause works as well

SELECT DISTINCT l3.Num AS ConsecutiveNums
FROM
(SELECT l2.id AS l12_id, l2.Num AS l12_Num
FROM Logs l1
INNER JOIN Logs l2
ON (l2.id = l1.id + 1)
WHERE l2.Num = l1.Num) AS l12
INNER JOIN Logs l3
ON (l3.id = l12_id + 1)
WHERE l3.Num = l12_Num

/*
The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
*/

SELECT Department, Employee, Salary
FROM
(SELECT Department, Employee, Salary, 
RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
FROM
(SELECT d.Name AS Department, 
e.Name AS Employee, Salary
FROM Employee AS e
INNER JOIN Department AS d
ON (e.DepartmentId = d.Id)) AS j) AS k
WHERE Rank = 1;

SELECT Department, Employee, Salary
FROM
(SELECT d.Name AS Department, 
e.Name AS Employee, Salary, 
RANK() OVER (PARTITION BY d.Name ORDER BY Salary DESC) AS Rank
FROM Employee AS e
INNER JOIN Department AS d
ON (e.DepartmentId = d.Id)) AS j
WHERE Rank = 1;

/*The following solution works in MySQL, but not in MS-SQL*/

SELECT d.Name AS Department, e.Name AS Employee, Salary
FROM Employee AS e
INNER JOIN Department AS d
ON (e.DepartmentId = d.Id)
WHERE 
(d.Id, Salary) IN 
(SELECT DepartmentId, MAX(Salary) AS Salary
FROM Employee
GROUP BY DepartmentId);

SELECT
Department, Employee.Name AS Employee, Salary
FROM
(SELECT d.Name AS Department, d.Id AS d_id, max(Salary) AS max_salary
FROM Employee AS e
LEFT JOIN Department AS d
ON (e.DepartmentId = d.Id)
GROUP BY Department) AS Joined
INNER JOIN Employee
ON (Joined.d_id = Employee.DepartmentId AND Joined.max_salary = Employee.Salary)

---------------------------------------
/*
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
*/

-- T-SQL solution

CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN

DECLARE @M INT;
SET @M = @N-1;
    RETURN (
        /* Write your T-SQL query statement below. */
        SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC 
        OFFSET @M ROWS FETCH NEXT 1 ROWS ONLY
    );
END

-- MySQL solution

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE M INT;
    SET M = N-1;
    RETURN (
        /* Write your T-SQL query statement below. */
        SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT 1 OFFSET M
    );
END

-----------------------------------------------------------------

/*
Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.
Mary wants to change seats for the adjacent students.
Can you write a SQL query to output the result for Mary?
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:
If the number of students is odd, there is no need to change the last one's seat.
*/

SELECT 
CASE WHEN mod(id, 2) <> 0 and id <> counts THEN id+1
     WHEN mod(id, 2) <> 0 and id = counts THEN id
     ELSE id - 1
     END AS id, student
FROM seat,
    (SELECT COUNT(*) AS counts 
    FROM seat) AS seat_counts
ORDER BY id

/*
When we xor a number with 1, we change it from odd to even and around. 
0 -> 1
1 -> 0
2 -> 3
3 -> 2
4 -> 5
5 -> 4
In order to match the order we do the +1, -1 gymnastics. 
The COALESCE() fn in mySQL returns the first non-null expression in the list.
SELECT COALESCE(NULL, NULL, 1, 2, NULL) gives NULL
*/

SELECT s1.id AS id, COALESCE(s2.student, s1.student) AS student
FROM seat AS s1
LEFT JOIN seat AS s2
ON ((s1.id+1)^1 - 1 = s2.id)
ORDER BY s1.id


----------------------------------------------------------------------------

/*
Human trafic of stadium

X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:
+------+------------+-----------+
| id   | date       | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
For the sample data above, the output is:

+------+------------+-----------+
| id   | date       | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
Note:
Each day only have one row record, and the dates are increasing with id increasing.
*/

SELECT DISTINCT s1.*
FROM stadium AS s1, stadium AS s2, stadium AS s3
WHERE s1.people >= 100 AND s2.people >= 100 AND s3.people >= 100
AND ((s1.id = s2.id-1 AND s1.id = s3.id-2) 
    OR (s1.id = s2.id+1 AND s1.id = s3.id-1)
    OR (s1.id = s2.id+1 AND s1.id = s3.id+2))
ORDER BY s1.id

----------------------------------------------------------------------

/*
Department top three salaries:

The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
*/

SELECT Department, Employee, Salary
FROM
(SELECT d.Name AS Department, e.Name AS Employee, Salary, 
DENSE_RANK() OVER (PARTITION BY d.Id ORDER BY Salary DESC) AS Rank
FROM Employee AS e
INNER JOIN Department AS d
ON e.DepartmentId = d.Id) AS Joined
WHERE RANK <= 3
