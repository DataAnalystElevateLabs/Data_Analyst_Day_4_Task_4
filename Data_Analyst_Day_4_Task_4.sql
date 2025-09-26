
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id)
);


alter table return_status alter column return_book_isbn drop not null
select*from books

select*from branch

select * from employees

select * from members

select*from issued_status

select*from return_status

--Retrieve All Books in a Specific Category:
select
*
from books
where category='Classic'

-- Find Total Rental Income by Category:

select
category,
sum(rental_price) as total_rents_from_books
from books
group by category

--List Members Who Registered in the Last 180 Days:
select
member_id,
member_name
from members
where reg_date<=current_date-interval '180 day'


--List Employees with Their Branch Manager's Name and their branch details:

select
b.branch_id,
e.emp_id,
e1.emp_name as manger_name,
e1.emp_id as manger_id
from branch as b
join
employees as e
on
b.branch_id=e.branch_id
join
employees as e1
on
e1.emp_id=b.manager_id

--Create a Table of Books with Rental Price Above a Certain Threshold

select
*
from books
where rental_price>7

--Retrieve the List of Books Not Yet Returned
select*from books
select*from issued_status
select*from return_status

--books returned
select
count(*) as list_of_books_issued
from
(select
b.*,
i.*,
r.*
from books as b
join
issued_status as i
on
b.isbn=i.issued_book_isbn
join
return_status as r
on
i.issued_id=r.issued_id
--where r.return_id is null 
--and
--i.issued_emp_id <> null
) as t1

--books not returned
select
i.*,
r.*
from issued_status as i
left join
return_status as r
on
i.issued_id=r.issued_id
where r.return_id is null

--Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period).
-- Display the member's_id, member's name, book title, issue date, and days overdue.
select*from books
select*from members
select*from issued_status
select*from return_status

select
m.member_id,
m.member_name,
i.issued_book_name,
i.issued_date,
--r.return_date,
(r.return_date-i.issued_date) as over_due_days
from issued_status as i
left join
return_status as r
on
i.issued_id=r.issued_id
join
members as m
on
m.member_id=i.issued_member_id
where (r.return_date-i.issued_date)>30
or
r.return_date is null


--Branch Performance Report
--Create a query that generates a performance report for each branch, 
--showing the number of books issued, the number of books returned, 
--and the total revenue generated from book rentals.
 select*from books
 select*from branch
 select*from employees
 select*from issued_status
 select*from return_status

 select
 b.branch_id,
 count(i.issued_id) as toatl_books_issued,
 count(r.return_id) as total_returns,
 sum(rental_price) as total_rental_income_book_sale
 from branch as b
 left join
 employees as e
 on
 b.branch_id=e.branch_id
 left join
 issued_status as i
 on
 e.emp_id=i.issued_emp_id
 left join
 books as bo
 on
 bo.isbn=i.issued_book_isbn
 left join
 return_status as r
 on
 i.issued_id=r.issued_id
 group by b.branch_id
 order by b.branch_id asc
 

--CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members
-- who have issued at least one book in the last 2 months.

   with active_memebers
   as
   (select
   m.member_id,
   m.member_name,
   count(i.issued_id) as total_books_issued
   from members as m
   left join
   issued_status as i
   on
   m.member_id=i.issued_member_id
   where  issued_date<= current_date-interval '2 months'
   group by 1
   having count(i.issued_id)>=1
   ) 
   select*from active_memebers
   order by member_id asc

--Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee name, number of books processed, and their branch.

select*from employees
select*from issued_status

select
e.emp_name,
e.branch_id,
count(*) as total_books_processed
from employees as e
left join
issued_status as i
on
e.emp_id=i.issued_emp_id
group by 1,2
order by total_books_processed desc
limit 3

--or alternate way
--top 3 employees from each branch who has processed more books
select
*
from
(select
e.emp_name,
e.branch_id,
count(*) as total_books_processed,
dense_rank() over(partition by e.branch_id order by count(*)desc) as rank_proc
from employees as e
left join
issued_status as i
on
e.emp_id=i.issued_emp_id
group by 1,2
) as t1
where rank_proc<=3

-- Index on issued_status join column
create index idx_issued_emp_id on issued_status(issued_emp_id);

-- Index on employees branch_id for grouping/filtering
create index idx_employees_branch on employees(branch_id, emp_id);

-- Optional: if emp_name is often grouped/filtered
create index idx_employees_name on employees(emp_name);


--Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
--Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days.
-- The table should include: The number of overdue books.
-- The total fines, with each day's fine calculated at $0.50. The number of books issued by each member.
-- The resulting table should show: Member ID Number of overdue books Total fines

create view over_due_books_summary
as
(with over_due_books
as
(select
m.member_id,
m.member_name,
(r.return_date-i.issued_date) as days_returned_after
from members as m
left join
issued_status as i
on
m.member_id=i.issued_member_id
left join
return_status as r
on
i.issued_id=r.issued_id
where r.return_date is null
or
(r.return_date-i.issued_date)>=30
)
select
member_id,
member_name,
count(*) number_of_over_due_books,
concat('$',coalesce(sum((days_returned_after)*0.5),0)) as total_penalty_from_over_due_books
from over_due_books
group by member_id,member_name
)

select*from over_due_books_summary
order by member_id asc

--END--
