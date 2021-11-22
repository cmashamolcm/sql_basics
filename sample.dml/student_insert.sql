-- helps to insert data in any column in any order.
insert into STUDENT (rollno, sname, age, division, marks)
values(1, "meena", 10, 'A', 98);
insert into STUDENT (rollno, sname, age, division, marks)
values(2, "seena", 11, 'B', 90);
insert into STUDENT (rollno, sname, age, division, marks)
values(3, "jeena", 12, 'B', 67);
insert into STUDENT (rollno, sname, age, division, marks)
values(4, "teena", 13, 'A', 79);
insert into STUDENT (rollno, sname, age, division, marks)
values(5, "teena", 14, NULL, 79);

-- order will be same as that of create query.
insert into STUDENT values(2, "Jeena", 11, "B", 89);

-- insert only specific column values. Other columns will get NULL
insert into STUDENT (rollno, sname, division)
values(3, "Meera", 'B');

insert into STUDENT values(2, "ra_dha", 13, 89, "B"):
insert into STUDENT values(4, "ra_dha%KRISHNAN", 14, 89, "A");