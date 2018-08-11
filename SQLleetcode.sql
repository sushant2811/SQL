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
