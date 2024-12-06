/*
SQL Project Name: Employee Payroll Management System (EPMS)
Name: MD. Mehbub Ali Milon
ID: 1285648
Batch: CS/PNTL-A/62/01

Table of Contents: DML
			=> SECTION 01: INSERT DATA USING INSERT INTO KEYWORD
			=> SECTION 02: INSERT DATA THROUGH STORED PROCEDURE
				SUB SECTION => 2.1 : INSERT DATA THROUGH STORED PROCEDURE WITH AN OUTPUT PARAMETER 
				SUB SECTION => 2.2 : INSERT DATA USING SEQUENCE VALUE
			=> SECTION 03: UPDATE DELETE DATA THROUGH STORED PROCEDURE
				SUB SECTION => 3.1 : UPDATE DATA THROUGH STORED PROCEDURE
				SUB SECTION => 3.2 : DELETE DATA THROUGH STORED PROCEDURE
				SUB SECTION => 3.3 : STORED PROCEDURE WITH TRY CATCH AND RAISE ERROR
			=> SECTION 04: INSERT UPDATE DELETE DATA THROUGH VIEW
				SUB SECTION => 4.1 : INSERT DATA through view
				SUB SECTION => 4.2 : UPDATE DATA through view
				SUB SECTION => 4.3 : DELETE DATA through view
			=> SECTION 05: RETREIVE DATA USING FUNCTION(SCALAR, SIMPLE TABLE VALUED, MULTISTATEMENT TABLE VALUED)
			=> SECTION 06: TEST TRIGGER (FOR/AFTER TRIGGER ON TABLE, INSTEAD OF TRIGGER ON TABLE & VIEW)
			=> SECTION 07: QUERY
				SUB SECTION => 7.01 : SELECT FROM TABLE
				SUB SECTION => 7.02 : SELECT FROM VIEW
				SUB SECTION => 7.03 : SELECT INTO
				SUB SECTION => 7.04 : IMPLICIT JOIN WITH WHERE BY CLAUSE, ORDER BY CLAUSE
				SUB SECTION => 7.05 : INNER JOIN WITH GROUP BY CLAUSE
				SUB SECTION => 7.06 : OUTER JOIN
				SUB SECTION => 7.07 : CROSS JOIN
				SUB SECTION => 7.08 : TOP CLAUSE WITH TIES
				SUB SECTION => 7.09 : DISTINCT
				SUB SECTION => 7.10 : COMPARISON, LOGICAL(AND OR NOT) & BETWEEN OPERATOR
				SUB SECTION => 7.11 : LIKE, IN, NOT IN, OPERATOR & IS NULL CLAUSE
				SUB SECTION => 7.12 : OFFSET FETCH
				SUB SECTION => 7.13 : UNION
				SUB SECTION => 7.14 : EXCEPT INTERSECT
				SUB SECTION => 7.15 : AGGREGATE FUNCTIONS
				SUB SECTION => 7.16 : GROUP BY & HAVING CLAUSE
				SUB SECTION => 7.17 : ROLLUP & CUBE OPERATOR
				SUB SECTION => 7.18 : GROUPING SETS
				SUB SECTION => 7.19 : SUB-QUERIES (INNER, CORRELATED)
				SUB SECTION => 7.20 : EXISTS
				SUB SECTION => 7.21 : CTE
				SUB SECTION => 7.22 : MERGE
				SUB SECTION => 7.23 : BUILT IN FUNCTION
				SUB SECTION => 7.24 : CASE
				SUB SECTION => 7.25 : IIF
				SUB SECTION => 7.26 : COALESCE & ISNULL
				SUB SECTION => 7.27 : WHILE
				SUB SECTION => 7.28 : GROPING FUNCTION
				SUB SECTION => 7.29 : RANKING FUNCTION
				SUB SECTION => 7.30 : IF ELSE & PRINT
				SUB SECTION => 7.31 : TRY CATCH
				SUB SECTION => 7.32 : GOTO
				SUB SECTION => 7.33 : WAITFOR
				SUB SECTION => 7.34 : sp_helptext
				SUB SECTION => 7.35 : TRANSACTION WITH SAVE POINT



*/

USE EmployeePayrollSystem;
GO

/*============================== SECTION 01 ==============================
                        INSERT DATA INTO TABLES
==========================================================================*/

INSERT INTO Department (department_id, department_name, location, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(101, 'Human Resources', 'Dhaka', 'Admin', GETDATE(), NULL, NULL),
(102, 'IT', 'Chittagong', 'Admin', GETDATE(), NULL, NULL),
(103, 'Finance', 'Sylhet', 'Admin', GETDATE(), NULL, NULL);
GO


INSERT INTO Employee (employee_id, first_name, last_name, email, phone, hire_date, job_title, department_id, manager_id, status, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(1001, 'Md', 'Milon', 'milon@bdexample.com', '01711112222', '2020-01-15', 'Manager', 101, NULL, 'Active', 'Admin', GETDATE(), NULL, NULL),
(1002, 'Hasan', 'Ahmed', 'hasan@bdexample.com', '01722334455', '2021-02-20', 'Software Engineer', 102, 1001, 'Active', 'Admin', GETDATE(), NULL, NULL),
(1003, 'Abdur', 'Rakib', 'rakib@bdexample.com', '01733445566', '2022-03-10', 'Accountant', 103, 1001, 'Active', 'Admin', GETDATE(), NULL, NULL);
GO


-- Create a custom payroll_id by concatenating year and employee_id
-- Make sure payroll_id is provided with a valid value
INSERT INTO Payroll (payroll_id, employee_id, pay_period_start, pay_period_end, base_salary, overtime_hours, overtime_pay, bonus, deductions, net_pay, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(2024001, 1001, '2024-01-01', '2024-01-31', 50000.00, 10.00, 1500.00, 3000.00, 500.00, 54500.00, 'Admin', GETDATE(), NULL, NULL),
(2024002, 1002, '2024-01-01', '2024-01-31', 40000.00, 5.00, 750.00, 2000.00, 400.00, 42250.00, 'Admin', GETDATE(), NULL, NULL),
(2024003, 1003, '2024-01-01', '2024-01-31', 35000.00, 8.00, 1200.00, 1500.00, 350.00, 37750.00, 'Admin', GETDATE(), NULL, NULL);



INSERT INTO Attendance (attendance_id, employee_id, work_date, clock_in, clock_out, hours_worked, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(3001, 1001, '2024-01-10', '09:00', '17:00', 8.00, 'Admin', GETDATE(), NULL, NULL),
(3002, 1002, '2024-01-10', '09:15', '17:15', 8.00, 'Admin', GETDATE(), NULL, NULL),
(3003, 1003, '2024-01-10', '09:30', '17:30', 8.00, 'Admin', GETDATE(), NULL, NULL);
GO


INSERT INTO Leave (leave_id, employee_id, leave_type, start_date, end_date, status, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(4001, 1001, 'Sick Leave', '2024-01-12', '2024-01-14', 'Approved', 'Admin', GETDATE(), NULL, NULL),
(4002, 1002, 'Vacation', '2024-02-05', '2024-02-10', 'Pending', 'Admin', GETDATE(), NULL, NULL),
(4003, 1003, 'Maternity Leave', '2024-03-01', '2024-03-15', 'Approved', 'Admin', GETDATE(), NULL, NULL);
GO

INSERT INTO TaxAndDeduction (tax_deduction_id, employee_id, deduction_type, deduction_amount, effective_date, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(5001, 1001, 'Income Tax', 5000.00, '2024-01-01', 'Admin', GETDATE(), NULL, NULL),
(5002, 1002, 'Provident Fund', 4000.00, '2024-01-01', 'Admin', GETDATE(), NULL, NULL),
(5003, 1003, 'Health Insurance', 3000.00, '2024-01-01', 'Admin', GETDATE(), NULL, NULL);
GO

INSERT INTO PaymentMethod (payment_method_id, employee_id, method, bank_account, bank_name, createdBy, createdOn, updatedBy, updatedOn)
VALUES 
(6001, 1001, 'Direct Deposit', '1234567890123456', 'DBBL', 'Admin', GETDATE(), NULL, NULL),
(6002, 1002, 'Check', '9876543219876543', 'BRAC Bank', 'Admin', GETDATE(), NULL, NULL),
(6003, 1003, 'Cash', NULL, NULL, 'Admin', GETDATE(), NULL, NULL);
GO



/*============================== SECTION 02 ==============================
                  INSERT DATA THROUGH STORED PROCEDURE
==========================================================================*/

EXEC spInsertEmployee 
    @employee_id = 1004, 
    @first_name = 'Mehbub', 
    @last_name = 'Milon', 
    @email = 'john.doe@example.com', 
    @phone = '01835222229', 
    @hire_date = '2024-11-15', 
    @job_title = 'Software Engineer', 
    @department_id = 102, 
    @manager_id = 1001, 
    @status = 'Active', 
    @createdBy = 'Admin';

EXEC spInsertPayroll 
    @payroll_id = 2024004, 
    @employee_id = 1001, 
    @pay_period_start = '2024-11-01', 
    @pay_period_end = '2024-11-15', 
    @base_salary = 5000.00, 
    @overtime_hours = 10.5, 
    @overtime_pay = 525.00, 
    @bonus = 200.00, 
    @deductions = 100.00, 
    @net_pay = 5625.00, 
    @createdBy = 'Admin';




--============== INSERT DATA THROUGH STORED PROCEDURE WITH AN OUTPUT PARAMETER ============--


DECLARE @payroll_id INT = 2024005;  

EXEC spInsertPayroll 
    @payroll_id = @payroll_id,  
    @employee_id = 1001, 
    @pay_period_start = '2024-11-01', 
    @pay_period_end = '2024-11-15', 
    @base_salary = 5000.00, 
    @overtime_hours = 10.5, 
    @overtime_pay = 525.00, 
    @bonus = 200.00, 
    @deductions = 100.00, 
    @net_pay = 5625.00, 
    @createdBy = 'Admin';

-- After execution, you can check the value of @payroll_id
SELECT @payroll_id AS NewPayrollID;





/*============================== SECTION 03 ==============================
            UPDATE  DATA THROUGH STORED PROCEDURE
==========================================================================*/

EXEC spUpdateEmployeeStatus 
    @employee_id = 1001, 
    @status = 'Active', 
    @updatedBy = 'Admin';



/*============================== SECTION 04 ==============================
                  MANIPULATE DATA THROUGH VIEWS
==========================================================================*/

--============== INSERT DATA through view ============--
INSERT INTO VW_EmployeePayrollInfo 
    (employee_id, first_name, last_name, department_id, department_name, pay_period_start, pay_period_end, base_salary, overtime_hours, overtime_pay, bonus, deductions, net_pay)
VALUES
    (1001, 'Habib', 'Khan', 1, 'Sales', '2024-10-01', '2024-10-31', 3000.00, 10, 200.00, 500.00, 100.00, 3600.00);


--============== UPDATE DATA through view ============--
UPDATE VW_EmployeePayrollInfo
SET 
    base_salary = 3500.00,
    overtime_pay = 300.00
WHERE employee_id = 1001;


/*============================== SECTION 05 ==============================
                RETRIEVE DATA USING FUNCTIONS
==========================================================================*/
-- Retrieve the total payroll expense for the current year
SELECT dbo.fnCurrentYearPayrollExpense() AS TotalPayrollExpense;

-- Retrieve monthly payroll details for a specific year and month (e.g., 2024, October)
SELECT * 
FROM dbo.fnMonthlyPayrollDetails(2024, 10);

-- Retrieve detailed payroll transaction information for October 2024
SELECT * 
FROM dbo.fnMonthlyPayrollTransactionDetails(2024, 10);  -- Example for October 2024


-- Retrieve monthly payroll summary for October 2024
SELECT * 
FROM dbo.fnMonthlyPayrollSummary(2024, 10);


/*============================== SECTION 06 ==============================
                                TRIGGERS
==========================================================================*/



/*============================== SECTION 07 ==============================
                                QUERIES
==========================================================================*/

-- 7.01: SELECT FROM TABLE 
-- Select all columns from the Employee table
SELECT * 
FROM Employee;

--7.02: SELECT FROM VIEW
-- Select all columns from a view
SELECT * 
FROM VW_EmployeePayrollInfo;

--7.03: SELECT INTO
-- Create a new table and copy data from Employee table into it
SELECT * 
INTO EmployeeBackup
FROM Employee;


--7.05: INNER JOIN WITH GROUP BY CLAUSE
-- Join Employee and Department tables implicitly (without explicit JOIN)
-- Inner join Employee and Department tables, and group by department name
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM Employee e
INNER JOIN Department d ON e.department_id = d.department_id
GROUP BY d.department_name;


--7.06: OUTER JOIN
---- Left outer join Employee and Department tables
SELECT e.first_name, e.last_name, d.department_name
FROM Employee e
LEFT OUTER JOIN Department d ON e.department_id = d.department_id;

--7.07: CROSS JOIN
-- Cross join between Employee and Department tables
SELECT e.first_name, d.department_name
FROM Employee e
CROSS JOIN Department d;

--7.08: TOP CLAUSE WITH TIES
-- Get the top 3 highest-paid employees (based on base salary)
SELECT TOP 3 WITH TIES e.first_name, e.last_name, p.base_salary
FROM Employee e
INNER JOIN Payroll p ON e.employee_id = p.employee_id
ORDER BY p.base_salary DESC;

--7.09: DISTINCT
---- Get distinct department names from Employee table
SELECT DISTINCT department_id
FROM Employee;


--7.10: COMPARISON, LOGICAL(AND OR NOT) & BETWEEN OPERATOR
-- Employees who are 'Active' and have a salary between 50000 and 100000
SELECT e.first_name, e.last_name, p.base_salary
FROM Employee e
INNER JOIN Payroll p ON e.employee_id = p.employee_id
WHERE e.status = 'Active' AND p.base_salary BETWEEN 50000 AND 100000;

--7.11: LIKE, IN, NOT IN, OPERATOR & IS NULL CLAUSE
-- Employees whose first name starts with 'J' and have a status of 'Active'
SELECT * 
FROM Employee 
WHERE first_name LIKE 'J%' AND status = 'Active';

-- Employees who are in a specific set of departments
SELECT * 
FROM Employee
WHERE department_id IN (1, 2, 3);

-- Employees whose email is NULL
SELECT * 
FROM Employee
WHERE email IS NULL;

--7.12: OFFSET FETCH
-- Skip the first 5 employees and fetch the next 10
SELECT * 
FROM Employee
ORDER BY employee_id
OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;

--7.13: UNION
---- Union of two different SELECT queries (example: employees from department 1 and 2)
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 1
UNION
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 2;

--7.14: EXCEPT INTERSECT
-- Get employees from department 1 but not in department 2
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 1
EXCEPT
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 2;

-- Get employees common to both department 1 and department 2
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 1
INTERSECT
SELECT first_name, last_name 
FROM Employee 
WHERE department_id = 2;

--7.15: AGGREGATE FUNCTIONS
-- Total number of employees and average salary by department
SELECT department_id, COUNT(e.employee_id) AS total_employees, AVG(base_salary) AS avg_salary
FROM Employee e
INNER JOIN Payroll p ON e.employee_id = p.employee_id
GROUP BY department_id;


--7.16: GROUP BY & HAVING CLAUSE
-- Count employees by department but only show departments with more than 5 employees
SELECT department_id, COUNT(employee_id) AS total_employees
FROM Employee
GROUP BY department_id
HAVING COUNT(employee_id) > 5;

--7.17: ROLLUP & CUBE OPERATOR
-- Using ROLLUP to get total employees by department and overall total
SELECT department_id, COUNT(employee_id) AS total_employees
FROM Employee
GROUP BY department_id
WITH ROLLUP;

-- Using CUBE to get total employees in each department and total for all
SELECT department_id, COUNT(employee_id) AS total_employees
FROM Employee
GROUP BY department_id
WITH CUBE;


--7.18: GROUPING SETS
-- Get total employees by department and overall total using GROUPING SETS
SELECT department_id, COUNT(employee_id) AS total_employees
FROM Employee
GROUP BY GROUPING SETS (department_id, ());

--7.19: SUB-QUERIES (INNER, CORRELATED)
-- Sub-query to get employees who earn more than the average salary in their department
SELECT first_name, last_name, base_salary
FROM Employee e
INNER JOIN Payroll p ON e.employee_id = p.employee_id
WHERE p.base_salary > (
    SELECT AVG(base_salary) 
    FROM Payroll 
    WHERE department_id = e.department_id
);

-- Correlated sub-query to get employees who are their department's highest-paid
SELECT first_name, last_name, base_salary
FROM Employee e
INNER JOIN Payroll p ON e.employee_id = p.employee_id
WHERE p.base_salary = (
    SELECT MAX(base_salary) 
    FROM Payroll 
    WHERE department_id = e.department_id
);

-- 7.20 : EXISTS
-- Checking if a row exists in the Employee table where the employee status is 'Active'
SELECT employee_id, first_name, last_name
FROM Employee
WHERE EXISTS (
    SELECT 1
    FROM Department
    WHERE department_id = Employee.department_id
    AND department_name = 'IT'
);
GO

-- 7.21 : CTE (Common Table Expression)
-- Retrieving employee information along with their department name using CTE
WITH EmployeeCTE AS (
    SELECT e.employee_id, e.first_name, e.last_name, d.department_name
    FROM Employee e
    JOIN Department d ON e.department_id = d.department_id
)
SELECT * FROM EmployeeCTE;
GO

-- 7.22 : MERGE
-- Merging data between the Payroll and PayrollHistory tables
MERGE INTO PayrollHistory ph
USING Payroll p
ON ph.payroll_id = p.payroll_id
WHEN MATCHED THEN
    UPDATE SET ph.payment_date = GETDATE()
-- Only insert if the payroll_id is not already in PayrollHistory
WHEN NOT MATCHED AND NOT EXISTS (SELECT 1 FROM PayrollHistory ph2 WHERE ph2.payroll_id = p.payroll_id) THEN
    INSERT (payroll_id, payment_date) 
    VALUES (p.payroll_id, GETDATE());
GO



-- 7.23 : BUILT IN FUNCTION
-- Using the GETDATE() built-in function to get current date and time
SELECT employee_id, first_name, last_name, GETDATE() AS [current_date]
FROM Employee;
GO

-- 7.24 : CASE
-- Using CASE expression to categorize employees based on their job title
SELECT employee_id, first_name, last_name, job_title,
    CASE 
        WHEN job_title = 'Manager' THEN 'Management'
        WHEN job_title = 'Developer' THEN 'Technical'
        ELSE 'Other'
    END AS job_category
FROM Employee;
GO

-- 7.25 : IIF
-- Using IIF function to check employee's status and return a value
SELECT employee_id, first_name, last_name, 
    IIF(status = 'Active', 'Currently Working', 'Not Working') AS work_status
FROM Employee;
GO

-- 7.26 : COALESCE & ISNULL
-- Using COALESCE to return first non-null value and ISNULL for handling null values
SELECT employee_id, first_name, last_name, 
    COALESCE(phone, 'No Phone') AS phone_number,
    ISNULL(email, 'No Email') AS email_address
FROM Employee;
GO

-- 7.27 : WHILE
-- Using WHILE loop to iterate through employee IDs
DECLARE @counter INT = 1;
DECLARE @maxId INT;
SELECT @maxId = MAX(employee_id) FROM Employee;

WHILE @counter <= @maxId
BEGIN
    PRINT 'Employee ID: ' + CAST(@counter AS VARCHAR);
    SET @counter = @counter + 1;
END
GO

-- 7.28 : GROUPING FUNCTION
-- Using GROUPING function to detect which columns are grouped in a GROUP BY query
SELECT department_id, status, COUNT(*) AS total_employees,
    GROUPING(department_id) AS department_grouped,
    GROUPING(status) AS status_grouped
FROM Employee
GROUP BY department_id, status WITH ROLLUP;
GO

-- 7.29 : RANKING FUNCTION
-- Using RANK to rank employees based on their base salary
SELECT employee_id, base_salary,
    RANK() OVER (ORDER BY base_salary DESC) AS salary_rank
FROM Payroll;
GO

-- 7.30 : IF ELSE & PRINT
-- Using IF ELSE to check if an employee is active and print status
DECLARE @employee_status VARCHAR(20);
SELECT @employee_status = status FROM Employee WHERE employee_id = 1;

IF @employee_status = 'Active'
    PRINT 'Employee is active.'
ELSE
    PRINT 'Employee is not active.';
GO

-- 7.31 : TRY CATCH
-- Using TRY CATCH to handle errors when updating payroll
BEGIN TRY
    UPDATE Payroll
    SET base_salary = base_salary + 500
    WHERE employee_id = 99999; -- Assume this employee_id does not exist
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 7.32 : GOTO
-- Using GOTO to control flow and jump to a label
DECLARE @x INT = 1;

IF @x = 1
    GOTO JumpLabel;

SELECT 'This will not execute';

JumpLabel:
SELECT 'This will execute because of GOTO';
GO

-- 7.33 : WAITFOR
-- Using WAITFOR to delay the execution of a statement for a certain period
WAITFOR DELAY '00:00:05'; -- Delays execution for 5 seconds
SELECT 'This was delayed by 5 seconds';
GO

-- 7.34 : sp_helptext
-- Using sp_helptext to view the text of a stored procedure (if exists)
-- EXEC sp_helptext 'YourStoredProcedureName';
GO

-- 7.35 : TRANSACTION WITH SAVE POINT
-- Using a transaction with save points to control rollbacks
BEGIN TRANSACTION;

SAVE TRANSACTION SavePoint1;









