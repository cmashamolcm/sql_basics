
------------------------------------------------------HAVING---------------------------------------
-- used with aggregate functions and group by. This can be used as "HAVING count(*)" whereas "WHERE count(*)" cannot be used.
-- WHERE before GROUP BY and HAVING after GROUP BY in terms of syntactical order order. In same way, WHERE applies on entire table. But HAVING applies on result of group by.
-- Having applies on each group.
-- get total number of employees
select count(*) from EMPLOYEE;
-- count(*)
--  6
-- get number of employees per department
select department, count(*) from EMPLOYEE group by department;
-- department	count(*)
--                  1               -- (blank) dept for ceo
--  10	            2
--  11	            3
-- get number of employees with salary > 50000 in each dept
select department, count(*) from EMPLOYEE where salary>50000 group by department;
--department	count(*)
--                  1
--      10	        2
-- get departments having at least or min 2 employees with salary 50000
-- Here, if we use WHERE clause, it gets applied on entire table. Not on result of aggregate function
-- There comes HAVING
-- HAVING can be applied on aggregate functions, mostly useful when some extra condition needs to be applied on result of
-- group by where we cannot apply WHERE clause
select department, count(*) from EMPLOYEE where salary>50000 group by department having count(*) >2;
-- can use alias name with HAVING. Since this is applied on top of result of from->where->select->group by and then -> having
select department, count(*) empCount from EMPLOYEE where salary>50000 group by department having empCount >2;
-- department	empCount
--  10	            2
-- get no: of employees from dept 11 per designation/ job
select designation, count(*) from EMPLOYEE where department =11 group by designation;
-- get each job or designation with > 1 employee working in it
select designation, count(*) from EMPLOYEE group by designation having count(*) >= 1;
-- get job which has more than 1 employee of dept no: 11
select designation, count(*) from EMPLOYEE where department = 11 group by designation having count(*) >= 1;

-- we can use
select * from EMPLOYEE where department = 10;
-- as well as
select * from EMPLOYEE having department = 10;
-- both gives same result.
-- But WHERE applies on each row and gets subset based on condition. (from -> where -> select)
-- Whereas HAVING is applied on top of entire data fetched by select. (from-> select -> having)
-- Unnecessarily data fetch happens in having. Even though the purpose of each of them are different,
-- one to filter from entire table and the other one to filter in each group (aggregation), if uses for same purpose,
-- WHERE is high performer in terms of memory and speed.

--------------------------------------------------SUBQUERY-------------------------------------------
-- inner and outer queries will be there. Inner query is used in outer query. Outer query result is given to external world.
-- one query inside another one (mostly useful when there are 2 tables where data is to be fetched from table 1 based on some value in table 2)
-- get the list of employees working in location "USA"
select * from EMPLOYEE where deptartment = (select deptno from DEPARTMENT where location = "USA");
-- get no: of employees in "GERMANY"
select count(*) from EMPLOYEE where deptartment = (select deptno from DEPARTMENT where location = "USA");
-- get the dept name in which employee "Ramu" works
select dname from DEPARTMENT where deptno = (select department from EMPLOYEE where name = "Ramu");
-- get avg salary of employees in marketing department
select avg(salary) from EMPLOYEE where department = (select deptno from DEPARTMENT where dname = "marketing");
-- this can go wrong, if the inner query has more than one raw returned.
-- So, better to use IN instead of = in all the above cases.
select avg(salary) from EMPLOYEE where department in (select deptno from DEPARTMENT where dname = "sales");
-- Make sure not to return select * from or multiple columns from inner query. Else error comes

-- subquery with group by and having
-- get number of employees in each job or designation in location Germany
select designation, count(*) from EMPLOYEE where department in (select deptno from DEPARTMENT where location = "Germany") group by designation;
-- per job, how many employees in marketing earns salary more than 40000
select designation, count(*) from EMPLOYEE group by designation; -- groups by job
select designation, count(*) from EMPLOYEE where salary > 40000 group by designation; -- >40000 per group
select designation, count(*) from EMPLOYEE where salary > 40000 and department in (select deptno from DEPARTMENT where dname = "marketing") group by designation;
-- list jobs in descending order of the number of employees
select designation, count(*) from EMPLOYEE group by designation order by count(*) desc;
-- list of jobs in descending order of number of employees. Ensure that minimum 2 from Germany.
select designation, count(*) from EMPLOYEE where department in (select deptno from DEPARTMENT where location = "Germany") group by designation having count(*) > 1 order by 2 DESC;
-- designation	count(*)
--  lead	        2
-- Index can be used with ORDER BY, not with group by or where or having.

-- with aggregate functions
-- get max salary
select max(salary) from EMPLOYEE;
-- get name of employee getting max salary
select name from EMPLOYEE where salary = (select max(salary) from EMPLOYEE);
-- we cannot say, where salary = max(salary). It gives error. But have to make it a sub query.
-- how may employees earn more than emp 6
select count(*) from EMPLOYEE where salary > (select salary from EMPLOYEE where id = 6);
-- which employees do same job as emp 6 (including 6)
select * from EMPLOYEE where designation = (select designation from EMPLOYEE where id = 6);
-- excluding 6
select * from EMPLOYEE where designation = (select designation from EMPLOYEE where id = 6) and id != 6;
-- which emp from Germany does the same job as emp id 6 excluding 6 if it is present
select * from EMPLOYEE where department IN (select deptno from DEPARTMENT where location = "Germany") and designation = (select designation from EMPLOYEE where id = 6) and id != 6;

-- advanced
-- get the name of lead who gets the highest salary
select name from EMPLOYEE where designation = "lead" and salary = (select max(salary) from EMPLOYEE where designation = "lead");
-- this can be written in another way
select name from EMPLOYEE where (designation, salary) in (select designation, max(salary) from EMPLOYEE where designation  = "lead");
-- above query works fine.
-- But it is recommended to use group by with sub-queries if such aggregations are used.
select name from EMPLOYEE where (designation, salary) in (select designation, max(salary) from EMPLOYEE where designation  = "lead" group by designation); -- to avoid any error due to multiple rows
-- get details of manager earning 50000
select * from EMPLOYEE where salary = 50000 and designation = "manager";
-- is same as
select * from EMPLOYEE where (salary, designation) in (50000, "manager");
-- when we try to put multiple columns in where and in, then, right hand side of IN is expected to be a sub-query always.

