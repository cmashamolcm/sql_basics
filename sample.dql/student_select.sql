-- get all students
select * from STUDENT;

-- rollno	    sname	age	marks	division
--  1	        meena	10	    98	    A
--  1	        Jeena	11	    89	    B
--  3	        Meera	null	null	B
--  2	        ra_dha	13	    89	    B
--  4	        ra_dha%KRISHNAN	14	89	A

-- get students not written exam (assume that marks = NULL means not written exam.)
-- Note: use keyword "IS" with NULL instead of =
select * from STUDENT where marks is null;

-- get students written exam (assume that marks = NULL means not written exam.)
-- Note: use keyword "IS NOT" with NULL instead of !=
select * from STUDENT where marks is not null;

-------------------------------------------------------LIKE------------------------------------------------------------
-- get all students having name starting with 'm'.
-- Use LIKE <expression>
-- % means 0 or more
-- _ means exactly one char
-- __ means exactly 2 char
-- %r_ means, any sname starts with anything and having r as the second last letter. Exactly one letter should be there after r
select * from STUDENT where sname like 'm%';
select * from STUDENT where sname like '%r_'; -- Meera, Siri. But not Serial as it has more letters after r.

-- get all student having name contains a anywhere in it.
select * from STUDENT where sname like "%a%";

-- get all student having name contains e as second char in it.
select * from STUDENT where sname like "_e%";

-- But what of we want to get values having _ or % in it and have to use like.
-- When we specify $ before this special symbols and specifies 'escape "$"', it will treat anything after $ as actual symbol.
-- Not special one.
-- Anything can be used to escape. Not mandatory to have $ everytime. If our data has $, better to use something else as escape char.
select * from STUDENT where sname like "%$_%" escape "$";
select * from STUDENT where sname like "%\_%" escape "\";

-- Get student having _ as letter followed by exactly 3 char and then % as next char and ending with anything. Eg: ra_dha%KRISHNAN
select * from STUDENT where sname like "%$____$%%" escape '$';
select * from STUDENT where sname like "%\____\%%" escape '\';

-------------------------------------------------------DISTINCT------------------------------------------------------------
-- get all divisions
select division from STUDENT;
-- get distinct divisions - no duplicates will come.
select distinct division from STUDENT;

-------------------------------------------------------ORDER BY------------------------------------------------------------
-- get details ordered by marks asc
select * from STUDENT order by marks asc;
--same as
select * from STUDENT order by marks;
-- descending (big to small)
select * from STUDENT order by marks desc;
-- order by multiple columns
select * from STUDENT order by marks desc, age asc; -- first sorts by marks(big to small) and then by age(small to big)

-------------------------------------------------------WHERE & ORDER BY------------------------------------------------------------
-- get students with mark below 90 in descending order of name
-- order by is always given after where clause. That helps in applying sorting in minimum subset rather than entire table which adds
-- to better performance
select * from STUDENT where marks<90 order by sname;

-- where works only with column name. Not with alias or column index in select.
-- from -> where -> select
select sname, marks*1000 percentage from STUDENT where percentage>90000; --not works
select sname, marks*1000 percentage from STUDENT where marks*1000>90000; -- works fine

-- order by works with column, expression, alias name or index of column in select.
-- from -> where -> select -> order by
select sname, marks*1000 percentage from STUDENT where marks*1000>90000 order by percentage desc; -- works fine
select sname, marks*1000 percentage from STUDENT where marks*1000>90000 order by marks*1000 desc; -- works fine
select sname, marks*1000 percentage from STUDENT where marks*1000>90000 order by 1 desc; -- works fine by sorting with sname if it is 1. by percentage if it is 2

-------------------------------------------------------APPLY CALCULATIONS in QUERY---(also, usage of alias)---------------------------------------------------------
-- get % of marks each student has
select sname, marks*1000 from STUDENT;
--  sname	marks*1000
--  meena	98000

-- with alias name
select sname, marks*1000 percentage from STUDENT;
--  sname	percentage
--  meena	98000

-- with column name having more than one world in it. Add ""
select sname, marks*1000 "percentage in thousand" from STUDENT;
--  sname	percentage in thousand
--  meena	98000

-- get all students scored more than 90000
select * from STUDENT where marks*1000>90000;
-- rollno	sname	age	    marks	division
-- 1	    meena	10	    98	        A

-- below get gives error as percentage is unknown column. Reason is,
-- from statement gets executed first. Then, on top of that,where gets executed. Finally, select gets executed. So,
-- at the time of where clause, we are directly dealing with table. Not with result of select. If it was like,
-- select then where, this alias makes sense. Else, there is no meaning for it.
-- SELECT is working after WHERE clause as if it was in reverse, entire table has to fetch first and then will have to apply filtering.
-- That needs more memory and resource. So, we cannot use alias with WHERE. But we can use a column name or expression with WHERE.
-- from -> where -> select
select sname, marks*1000 percentage from STUDENT where percentage>90000; --not works
select sname, marks*1000 percentage from STUDENT where marks*1000>90000; -- works fine

-- but will alias name works with ORDER BY
-- order by executes last. Even after the select. Because, it actually does the sorting of fetched data. So, it works.
-- from -> where -> select -> order by
select sname, marks*1000 percentage from STUDENT where marks*1000>90000 order by percentage desc; -- works fine

-- get student name, percentage in the order of % high to low for students who scored more than 90000 as percentage.
select sname, marks*1000 percentage from STUDENT where marks*1000>90000 order by marks*1000 desc;

------------------------------------------------------5-AGGREGATE FUNCTIONS-------(max, min, avg, sum, count)--------------------------------------------------
-- all returns a single value as output
-- get max of marks
select max(marks) from STUDENT;
-- with alias name
select max(marks) topper from STUDENT;
-- get avg of all ages
select avg(age) from STUDENT where division = "A"; -- gives decimals also
-- get count of rows in a table
select count(*) from STUDENT; --Eg: gives 5
select count(marks) from STUDENT; -- will also give 5 only if all entries in column marks are NOT NULL.
-- get average of marks
select avg(marks) from STUDENT; -- this gives average of non-null marks.
-- if one mark is null
select avg(marks) from STUDENT; -- will give (sum of all non-null marks)/no: of non-null marks
-- BUT
select sum(marks)/count(*) from STUDENT; -- will give (sum of all non-null marks)/no: of rows irrespective of null mark or not
-- BUT
select sum(marks)/count(marks) from STUDENT; -- will be same as avg().
-- get sum of marks for students of division A
select sum(marks)from STUDENT where division="A";
-- get total number of different divisions
select count(distinct division) from STUDENT;
-- what will be the result of aggregate functions, if we apply it on varchar column?
-- It just returns 0 as result
-- order of execution
-- from -> select -> count. Count applies on result of select
------------------------------------------------------BETWEEN--------------------------------------------------
-- get number of students got mark between 70 and 95
select count(*) from STUDENT where marks >=70 && marks <= 90;
-- this is same as
select count(*) from STUDENT where marks between 70 and 90; -- 70, 90 included

------------------------------------------------------GROUP BY-----------(like map of list of similar items)---------------------------------------
-- Without group by, applies operations on entire table.
-- But when group by is there, first, divides the table into groups and then applies operations.
-- To group the queried result
select division from STUDENT group by division;
-- this results in printing
-- division
-- A
-- B
-- Similar to
select distinct division from STUDENT;
-- It become more useful when applied along with aggregate functions.
-- get number of students in each division
-- if any of the division has NULL values, that will be treated as a separate group with division as NULL
select count(*) from STUDENT group by division;
-- get each individual division and it's count
-- Actually, this is to get the number of repetitions each distinct division is present in table.
select division, count(*) from STUDENT group by division;
-- The column not used with GROUP BY cannot be used in SELECT.
-- Eg: select * from STUDENT GROUP BY division;
-- will give error as there are other columns which is not used in group by
-- Reason is; when we does group by division, division A can have 2 students in it.
-- If we want to show the full details based on group,there will be confusion on which student name to be displayed against
-- division A or should I concatenate all and show it to occupy in single row.
-- It will be always better to avoid such confusions in SQL as a language. So, in SQL and from MySQL5.7.5, error comes if we try to query a column
-- that is not used in in GROUP BY.
-- Refer: https://medium.com/@riccardoodone/the-love-hate-relationship-between-select-and-group-by-in-sql-4957b2a70229
-- get number of students in same division and same age
select division, marks, count(*) from student group by division, marks;
-- or
select division, marks, count(*) from student group by marks, division;
-- If A has 2 students with 50 and 3 students with 48, it forms two distinct groups. B with 50 forms another group
-- division marks count(*)
-- A        50      2
-- A        48      3
-- B        50      5
-- B        37      1
-- NULL     70      1
-- B        NULL    1
-- select -> group by -> count
-- get count of students with each distinct mark
select marks, count(*) from STUDENT group by marks;
-- marks	count(*)
--  98	        1
--  90	        1
--  67	        1
--  79	        2
-- get number of students with same mark in same divisions
select marks, division, count(*) from STUDENT group by marks, division;
-- marks	division	count(*)
--  98	    A	        1
--  90	    B	        2
--  67	    B	        1
--  79	    A	        1
--  79		            1
-- get highest mark in each division
select division, max(marks) from STUDENT group by division;
-- division	max(marks)
--  A	    98
--  B	    90
--  79
-- get number of students with marks > 90 in each division
select division, count(*) from STUDENT where marks>90 group by division;
-- If there is 0 as count for any division, that will not be displayed.
-- from -> where -> group by -> count
-- WHERE should come before GROUP BY. Else, syntax error comes.
-- WHERE clause gets priority because, it helps to reduce the amount of data to process. Once we fetch everything based on where clause,
-- then applies GROUP BY.
-- If count(*) etc comes for a group, that will be excluded from final result

