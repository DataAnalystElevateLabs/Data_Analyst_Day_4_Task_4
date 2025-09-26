# Data_Analyst_Day_4_Task_4
Fourth Task of Data Analyst Internship @ Elevate Labs


Steps in SQL :

1.Created Tables

branch → Stores branch details.

employees → Stores employee details with branch reference.

members → Stores library members.

books → Stores book details like title, author, price, etc.

issued_status → Tracks books issued (linked to members, employees, books).

return_status → Tracks returned books (linked to issued books).

2.Modified Columns

Altered return_status.return_book_isbn to drop NOT NULL constraint.

Inserted & Viewed Data

Verified table structures using SELECT * from each table.

3.Basic Queries

Retrieved books in a specific category (Classic).

Calculated total rental income by category (SUM).

Listed members who registered in the last 180 days.

Retrieved employees with their branch manager details (self-join on employees).

Retrieved books with rental price above a threshold.

4.Issued & Return Queries

Checked total issued and returned books.

Found books not yet returned (LEFT JOIN return_status).

5.Overdue Book Analysis

Identified members with overdue books (30-day return period).

Displayed member details, book issued, and days overdue.

Branch Performance Report

Counted issued books, returns, and total rental revenue per branch.

5.CTAS (Create Table As Select)

Created a table of active members (issued books in last 2 months).

Employee Performance Queries

Found top 3 employees overall by books processed.

Found top 3 employees per branch using DENSE_RANK().

6.Indexing for Optimization

Indexed issued_status(issued_emp_id) for join performance.

Indexed employees(branch_id, emp_id) for grouping.

Indexed employees(emp_name) for filtering/grouping.

7.Views (Reusable Query)

Created a view over_due_books_summary that calculates:

Number of overdue books per member.

Total penalties ($0.50/day).

Queried from the view for simplified reporting.
