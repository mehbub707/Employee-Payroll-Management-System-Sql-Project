/*
								SQL Project Name : Employee Payroll Management System
								Name: MD. Mehbub Ali Milon
								ID: 1285648
								Batch: CS/PNTL-A/62/01

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Table of Contents: DDL
    => SECTION 01: CREATE A DATABASE [EmployeePayrollSystem]
    => SECTION 02: CREATE APPROPRIATE TABLES WITH COLUMN DEFINITIONS RELATED TO THE PROJECT
    => SECTION 03: ALTER, DROP, AND MODIFY TABLES & COLUMNS
    => SECTION 04: CREATE CLUSTERED AND NONCLUSTERED INDEXES
    => SECTION 05: CREATE SEQUENCE & ALTER SEQUENCE
    => SECTION 06: CREATE A VIEW & ALTER VIEW
    => SECTION 07: CREATE STORED PROCEDURES & ALTER STORED PROCEDURES
    => SECTION 08: CREATE FUNCTIONS (SCALAR, SIMPLE TABLE-VALUED, MULTI-STATEMENT TABLE-VALUED)
    => SECTION 09: CREATE TRIGGERS (FOR/AFTER TRIGGERS)
    => SECTION 10: CREATE TRIGGERS (INSTEAD OF TRIGGERS)
*/

/*
==============================  SECTION 01  ==============================
					CREATE DATABASE WITH ATTRIBUTES
==========================================================================



*/

CREATE DATABASE EmployeePayrollSystem
ON
(
	name='HMS_Data',
	filename='E:\TempData\EPS_Data.mdf',
	size=2mb,
	maxSize=200mb,
	filegrowth=2%
)
LOG ON
(
	name='HMS_Log',
	filename='E:\TempData\EPS_Data.ldf',
	size=3mb,
	maxSize=200mb,
	filegrowth=2mb
)


USE EmployeePayrollSystem
/*
==============================  SECTION 02  ==============================
		          CREATE TABLES WITH COLUMN DEFINITION 
==========================================================================
*/

-- 1. Department Table
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME
);
GO


-- 2. Employee Table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY, -- No IDENTITY, manual insertion required
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    hire_date DATE NOT NULL,
    job_title VARCHAR(50),
    department_id INT,
    manager_id INT NULL, -- Allow manager_id to be NULL for top-level managers
    status VARCHAR(20) CHECK (status IN ('Active', 'Terminated')),
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) ON DELETE NO ACTION -- Prevent cascading delete
);
GO

-- 3. Payroll Table
CREATE TABLE Payroll (
    payroll_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    base_salary DECIMAL(18,2) NOT NULL,
    overtime_hours DECIMAL(5,2) DEFAULT 0,
    overtime_pay DECIMAL(18,2) DEFAULT 0,
	additional_allowance DECIMAL(18,2) NULL,
    bonus DECIMAL(18,2) DEFAULT 0,
    deductions DECIMAL(18,2) DEFAULT 0,
    net_pay DECIMAL(18,2) NOT NULL,
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

-- 4. Attendance Table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    work_date DATE NOT NULL,
    clock_in TIME,
    clock_out TIME,
    hours_worked DECIMAL(5,2) NOT NULL,
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

-- 5. Leave Table
CREATE TABLE Leave (
    leave_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Approved', 'Pending', 'Rejected')),
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

-- 6. Tax and Deduction Table
CREATE TABLE TaxAndDeduction (
    tax_deduction_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    deduction_type VARCHAR(50) NOT NULL,
    deduction_amount DECIMAL(18,2) NOT NULL,
    effective_date DATE NOT NULL,
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

-- 7. Payment Method Table
CREATE TABLE PaymentMethod (
    payment_method_id INT PRIMARY KEY,
    employee_id INT NOT NULL,
    method VARCHAR(50) CHECK (method IN ('Direct Deposit', 'Check', 'Cash')) NOT NULL,
    bank_account VARCHAR(20),
    bank_name VARCHAR(100),
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

-- 8. Payroll History Table
CREATE TABLE PayrollHistory (
    history_id INT PRIMARY KEY,
    payroll_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50),
    createdBy VARCHAR(50),
    createdOn DATETIME DEFAULT GETDATE(),
    updatedBy VARCHAR(50),
    updatedOn DATETIME,
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id)
);
GO

--========================== SECTION 03 ==========================
--   ALTER, DROP, AND MODIFY TABLES & COLUMNS FOR PAYROLL SYSTEM
--================================================================

--============== ALTER TABLE SCHEMA AND TRANSFER TO [DBO] ============--

-- Transfer `Employee` table to dbo schema (if not already in dbo)
ALTER SCHEMA dbo TRANSFER Employee
GO

-- Transfer `Payroll` table to dbo schema (if not already in dbo)
ALTER SCHEMA dbo TRANSFER Payroll
GO

--============== Update column definitions ============--

-- Update column length for `method` in PaymentMethod
ALTER TABLE PaymentMethod
ALTER COLUMN method VARCHAR(30) NOT NULL
GO

-- Update column type for `net_pay` in Payroll to handle higher amounts
ALTER TABLE Payroll
ALTER COLUMN net_pay DECIMAL(18, 2) NOT NULL
GO

--============== ADD columns with DEFAULT CONSTRAINT ============--

-- Add column `salary_increment` to Payroll table with a default of 0
ALTER TABLE Payroll
ADD salary_increment DECIMAL(18, 2) DEFAULT 0
GO

--============== ADD CHECK CONSTRAINTS ============--

-- Add check constraint to validate `phone` format in Employee table
ALTER TABLE Employee
ADD CONSTRAINT CK_phoneValidate CHECK(phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

-- Add check constraint for `bank_account` in PaymentMethod (if applicable)
ALTER TABLE PaymentMethod
ADD CONSTRAINT CK_bankAccountValidate CHECK(bank_account LIKE '[0-9]%')
GO

--============== DROP COLUMNS ============--

-- Remove `overtime_pay` column from Payroll table if it's not required
					ALTER TABLE Payroll
					DROP COLUMN additional_allowance 
					GO

--============== DROP TABLES ============--

-- Drop `PayrollHistory` table if no longer needed
IF OBJECT_ID('PayrollHistory') IS NOT NULL
DROP TABLE PayrollHistory
GO

--============== DROP SCHEMAS ============--
CREATE SCHEMA HR;
GO
-- Drop unused schema `HR` if it exists
					DROP SCHEMA HR
					GO



/*
==============================  SECTION 04  ==============================
		          CREATE CLUSTERED AND NONCLUSTERED INDEXES
==========================================================================
*/

-- Clustered Index on Employee Table
-- Check if a clustered index on `employee_id` already exists before creating one
IF NOT EXISTS (
    SELECT * 
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('Employee') 
    AND type = 1 -- 1 = Clustered Index
)
BEGIN
    CREATE CLUSTERED INDEX IX_Employee_EmployeeID
    ON Employee (employee_id);
    PRINT 'Clustered index IX_Employee_EmployeeID created.';
END
ELSE
BEGIN
    PRINT 'Clustered index IX_Employee_EmployeeID already exists.';
END
GO

-- Clustered Index on Department Table
-- Check if a clustered index on `department_id` already exists before creating one
IF NOT EXISTS (
    SELECT * 
    FROM sys.indexes 
    WHERE object_id = OBJECT_ID('Department') 
    AND type = 1 -- 1 = Clustered Index
)
BEGIN
    CREATE CLUSTERED INDEX IX_Department_DepartmentID
    ON Department (department_id);
    PRINT 'Clustered index IX_Department_DepartmentID created.';
END
ELSE
BEGIN
    PRINT 'Clustered index IX_Department_DepartmentID already exists.';
END
GO


-- Nonclustered Index on Payroll Table
-- Creating a non-clustered index on `employee_id` and `pay_period_start` for faster payroll record retrievals
CREATE NONCLUSTERED INDEX IX_Payroll_EmployeeID_PayPeriodStart
ON Payroll (employee_id, pay_period_start)
GO

-- Nonclustered Index on Attendance Table
-- Creating a non-clustered index on `employee_id` and `work_date` for efficient attendance tracking by date
CREATE NONCLUSTERED INDEX IX_Attendance_EmployeeID_WorkDate
ON Attendance (employee_id, work_date)
GO

-- Nonclustered Index on Employee Table
-- Creating a unique non-clustered index on `email` in the Employee table to enforce unique emails and improve search speed
CREATE UNIQUE NONCLUSTERED INDEX IX_Employee_Email
ON Employee (email)
GO

-- Nonclustered Index on Leave Table
-- Creating a non-clustered index on `employee_id` and `start_date` to speed up leave records retrieval by employee and date
CREATE NONCLUSTERED INDEX IX_Leave_EmployeeID_StartDate
ON Leave (employee_id, start_date)
GO


/*
==============================  SECTION 05  ==============================
		                         CREATE SEQUENCE
==========================================================================
*/

-- Creating a sequence for generating unique employee codes
CREATE SEQUENCE seqEmployeeCode
	AS INT
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10000
	CYCLE
	CACHE 20
GO

-- Creating a sequence for generating unique payroll IDs
CREATE SEQUENCE seqPayrollID
	AS INT
	START WITH 1000
	INCREMENT BY 1
	MINVALUE 1000
	MAXVALUE 9999
	NO CYCLE
	CACHE 10
GO

--============== ALTER SEQUENCE ============--

-- Alter `seqEmployeeCode` to adjust maximum value and cycle setting
ALTER SEQUENCE seqEmployeeCode
	MAXVALUE 20000
	CYCLE
	CACHE 15
GO

-- Alter `seqPayrollID` to adjust cache size
ALTER SEQUENCE seqPayrollID
	CACHE 5
GO


/*
==============================  SECTION 06  ==============================
		                          CREATE A VIEW
==========================================================================
*/

-- Basic View to retrieve Employee Payroll Information
CREATE VIEW VW_EmployeePayrollInfo
AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    p.pay_period_start,
    p.pay_period_end,
    p.base_salary,
    p.overtime_hours,
    p.overtime_pay,
    p.bonus,
    p.deductions,
    p.net_pay
FROM 
    Employee e
JOIN 
    Payroll p ON e.employee_id = p.employee_id
GO

-- VIEW WITH ENCRYPTION, SCHEMABINDING & WITH CHECK OPTION
-- A view to get today's employee attendance information

CREATE VIEW VW_TodayAttendance
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT 
    a.attendance_id,
    a.employee_id,
    e.first_name,
    e.last_name,
    a.work_date,
    a.clock_in,
    a.clock_out,
    a.hours_worked
FROM 
    dbo.Attendance a
JOIN 
    dbo.Employee e ON a.employee_id = e.employee_id
WHERE 
    CONVERT(DATE, a.work_date) = CONVERT(DATE, GETDATE())
WITH CHECK OPTION
GO

--============== ALTER VIEW ============--

ALTER VIEW VW_EmployeePayrollInfo
AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name,
    p.pay_period_start,
    p.pay_period_end,
    p.base_salary,
    p.overtime_hours,
    p.overtime_pay,
    p.bonus,
    p.deductions,
    p.net_pay
FROM 
    Employee e
JOIN 
    Payroll p ON e.employee_id = p.employee_id
LEFT JOIN 
    Department d ON e.department_id = d.department_id
GO




/*
==============================  SECTION 07  ==============================
                             STORED PROCEDURE
==========================================================================
*/

--============== STORED PROCEDURE for inserting Employee data ============--

CREATE PROCEDURE spInsertEmployee 
    @employee_id INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @email VARCHAR(100),
    @phone VARCHAR(15),
    @hire_date DATE,
    @job_title VARCHAR(50),
    @department_id INT,
    @manager_id INT,
    @status VARCHAR(20),
    @createdBy VARCHAR(50)
AS
BEGIN
    INSERT INTO Employee (employee_id, first_name, last_name, email, phone, hire_date, job_title, department_id, manager_id, status, createdBy)
    VALUES (@employee_id, @first_name, @last_name, @email, @phone, @hire_date, @job_title, @department_id, @manager_id, @status, @createdBy)
END
GO

--============== STORED PROCEDURE for inserting Payroll data with OUTPUT parameter ============--

CREATE PROCEDURE spInsertPayroll 
    @payroll_id INT,  
    @employee_id INT,
    @pay_period_start DATE,
    @pay_period_end DATE,
    @base_salary DECIMAL(18,2),
    @overtime_hours DECIMAL(5,2),
    @overtime_pay DECIMAL(18,2),
    @bonus DECIMAL(18,2),
    @deductions DECIMAL(18,2),
    @net_pay DECIMAL(18,2),
    @createdBy VARCHAR(50)
AS
BEGIN
    -- Insert data into Payroll table
    INSERT INTO Payroll (payroll_id, employee_id, pay_period_start, pay_period_end, base_salary, overtime_hours, overtime_pay, bonus, deductions, net_pay, createdBy)
    VALUES (@payroll_id, @employee_id, @pay_period_start, @pay_period_end, @base_salary, @overtime_hours, @overtime_pay, @bonus, @deductions, @net_pay, @createdBy);

    -- Return the payroll_id (same value passed as input)
    SELECT @payroll_id AS NewPayrollID;  -- OUTPUT the same payroll_id
END
GO



--============== STORED PROCEDURE for updating Employee status ============--

CREATE PROCEDURE spUpdateEmployeeStatus 
    @employee_id INT,
    @status VARCHAR(20),
    @updatedBy VARCHAR(50)
AS
BEGIN
    UPDATE Employee
    SET status = @status,
        updatedOn = GETDATE(),
        updatedBy = @updatedBy
    WHERE employee_id = @employee_id
END
GO


--============== STORED PROCEDURE for deleting Payroll data ============--

CREATE PROCEDURE spDeletePayroll 
    @payroll_id INT
AS
BEGIN
    DELETE FROM Payroll
    WHERE payroll_id = @payroll_id
END
GO


--============== TRY CATCH IN A STORED PROCEDURE & RAISERROR ============--

CREATE PROCEDURE spDeleteDepartmentWithErrorHandling
    @department_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Start transaction
        
        DELETE FROM Department
        WHERE department_id = @department_id;

        COMMIT TRANSACTION; -- Commit transaction if successful
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Rollback if an error occurs

        -- Capture and re-throw the error with THROW
        THROW;
    END CATCH
END
GO

--============== Create STORED PROCEDURE to  Payroll deductions ============--

CREATE PROCEDURE spUpdatePayrollDeductions
    @payroll_id INT,
    @deductions DECIMAL(18,2),
    @updatedBy VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Start transaction
     
        -- Check if payroll_id exists
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @payroll_id)
        BEGIN
            THROW 50001, 'Payroll ID not found.', 1; -- Custom error
        END

        UPDATE Payroll
        SET deductions = @deductions,
            updatedOn = GETDATE(),
            updatedBy = @updatedBy
        WHERE payroll_id = @payroll_id;

        COMMIT TRANSACTION; -- Commit if successful
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Rollback in case of an error
     
        -- Capture and re-throw the error
        THROW;
    END CATCH
END
GO


--============== ALTER STORED PROCEDURE to update Payroll deductions ============--

					ALTER PROCEDURE spUpdatePayrollDeductions
						@payroll_id INT,
						@deductions DECIMAL(18,2),
						@updatedBy VARCHAR(50)
					AS
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION; -- Start transaction
        
							-- Check if payroll_id exists
							IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @payroll_id)
							BEGIN
								THROW 50001, 'Payroll ID not found.', 1; -- Custom error
							END

							UPDATE Payroll
							SET deductions = @deductions,
								updatedOn = GETDATE(),
								updatedBy = @updatedBy
							WHERE payroll_id = @payroll_id;

							COMMIT TRANSACTION; -- Commit if successful
						END TRY
						BEGIN CATCH
							ROLLBACK TRANSACTION; -- Rollback in case of an error
        
							-- Capture and re-throw the error
							THROW;
						END CATCH
					END
					GO


/*
==============================  SECTION 08  ==============================
                                 FUNCTION
==========================================================================
*/

--============== A SCALAR FUNCTION ============--
-- A Scalar Function to get Current Year Total Payroll Expense

CREATE FUNCTION fnCurrentYearPayrollExpense()
RETURNS MONEY
AS
BEGIN
    DECLARE @totalPayrollExpense MONEY

    SELECT @totalPayrollExpense = SUM(net_pay)
    FROM Payroll
    WHERE YEAR(Payroll.pay_period_end) = YEAR(GETDATE())

    RETURN @totalPayrollExpense
END
GO

--============== A SIMPLE TABLE VALUED FUNCTION ============--
-- An Inline Table-Valued Function to get monthly total base salary, overtime pay, and net pay using two parameters @year & @month

CREATE FUNCTION fnMonthlyPayrollDetails(@year INT, @month INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        SUM(base_salary) AS 'Total Base Salary',
        SUM(overtime_pay) AS 'Total Overtime Pay',
        SUM(net_pay) AS 'Total Net Pay'
    FROM Payroll
    WHERE YEAR(Payroll.pay_period_end) = @year AND MONTH(Payroll.pay_period_end) = @month
)
GO


--============== A MULTISTATEMENT TABLE VALUED FUNCTION ============--
-- Function to get detailed payroll transactions for a specified month and year

CREATE FUNCTION fnMonthlyPayrollTransactionDetails(@year INT, @month INT)
RETURNS @payrollDetails TABLE
(
    [Employee Id] INT,
    [Employee Name] VARCHAR(50),
    [Pay Date] DATETIME,
    [Base Salary] MONEY,
    [Overtime Pay] MONEY,
    [Net Pay] MONEY
)
AS
BEGIN    
    INSERT INTO @payrollDetails
    SELECT
        e.employeeId,
        e.name,
        p.pay_period_end,
        p.base_salary,
        p.overtime_pay,
        p.net_pay
    FROM Payroll p
    INNER JOIN Employees e ON e.employeeId = p.employeeId
    WHERE YEAR(p.pay_period_end) = @year AND MONTH(p.pay_period_end) = @month

    RETURN
END
GO

CREATE FUNCTION fnMonthlyPayrollSummary(@year INT, @month INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        SUM(base_salary) AS 'Total Base Salary',
        SUM(overtime_pay) AS 'Total Overtime Pay',
        SUM(net_pay) AS 'Total Net Payroll'
    FROM Payroll
    WHERE YEAR(Payroll.pay_period_end) = @year AND MONTH(Payroll.pay_period_end) = @month
);
GO


--============== ALTER FUNCTION ============--

						ALTER FUNCTION fnMonthlyPayrollSummary(@year INT, @month INT)
						RETURNS TABLE
						AS
						RETURN
						(
							SELECT 
								SUM(base_salary) AS 'Total Base Salary',
								SUM(overtime_pay) AS 'Total Overtime Pay',
								SUM(net_pay) AS 'Total Net Payroll'
							FROM Payroll
							WHERE YEAR(Payroll.pay_period_end) = @year AND MONTH(Payroll.pay_period_end) = @month
						)
						GO

/*
==============================  SECTION 09  ==============================
                            FOR/AFTER TRIGGER
==========================================================================
*/

--============== A TRIGGER FOR INSERT ============--
-- Create trigger on Payroll table to update the total payroll expense in a summary table after a new payroll entry

CREATE TRIGGER trAfterPayrollInsert
ON Payroll
FOR INSERT
AS
BEGIN
    DECLARE @newPayrollExpense MONEY
    DECLARE @payrollYear INT
    DECLARE @payrollMonth INT

    -- Calculate the total net pay for the new payroll entry
    SELECT @newPayrollExpense = SUM(net_pay)
    FROM inserted

    -- Extract the year and month from the inserted payroll record's pay period
    SELECT @payrollYear = YEAR(pay_period_start), 
           @payrollMonth = MONTH(pay_period_start)
    FROM inserted

    -- Optionally, update a custom table or field that tracks total payroll expenses.
    -- If you're using a different table to track total expenses for the year/month,
    -- you can update it here. Example:
    -- Example: UPDATE PayrollSummary SET total_expense = total_expense + @newPayrollExpense
    -- WHERE year = @payrollYear AND month = @payrollMonth;

    PRINT 'Payroll summary updated for the period ' + CAST(@payrollMonth AS VARCHAR) + '/' + CAST(@payrollYear AS VARCHAR)
END
GO


--============== AN AFTER TRIGGER FOR INSERT, UPDATE, DELETE ============--
-- Trigger to manage payroll summary for insert, update, and delete operations on Payroll table

CREATE TRIGGER trPayrollSummaryManage
ON Payroll
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @netPayInserted MONEY
    DECLARE @netPayUpdatedOld MONEY
    DECLARE @netPayUpdatedNew MONEY
    DECLARE @netPayDeleted MONEY

    -- Check if the trigger is for an UPDATE operation
    IF (EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED))
    BEGIN
        -- Calculate the net pay for the updated records (old and new values)
        SELECT @netPayUpdatedOld = SUM(net_pay) FROM deleted
        SELECT @netPayUpdatedNew = SUM(net_pay) FROM inserted

        -- Adjust total payroll expense based on updated records
        PRINT 'Payroll entry updated: Old Total Pay - ' + CAST(@netPayUpdatedOld AS VARCHAR) 
               + ', New Total Pay - ' + CAST(@netPayUpdatedNew AS VARCHAR)

        -- Optionally, you can log or display the old and new values for auditing purposes
    END

    -- Check if the trigger is for an INSERT operation only
    ELSE IF (EXISTS(SELECT * FROM INSERTED) AND NOT EXISTS(SELECT * FROM DELETED))
    BEGIN
        SELECT @netPayInserted = SUM(net_pay) FROM inserted

        -- Print the net pay for the new records inserted
        PRINT 'New payroll entry inserted with net pay total of: ' + CAST(@netPayInserted AS VARCHAR)
    END

    -- Check if the trigger is for a DELETE operation only
    ELSE IF (EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED))
    BEGIN
        SELECT @netPayDeleted = SUM(net_pay) FROM deleted

        -- Print the net pay for the deleted records
        PRINT 'Payroll entry deleted with net pay total of: ' + CAST(@netPayDeleted AS VARCHAR)
    END
    ELSE 
    BEGIN
        PRINT 'Trigger fired without matching conditions, transaction rolled back.'
        ROLLBACK TRANSACTION
    END
END
GO

/*
==============================  SECTION 10  ==============================
                            INSTEAD OF TRIGGER
==========================================================================
*/

--============== INSTEAD OF TRIGGER FOR INSERT ============--
-- Trigger to insert payroll data, calculating the net pay based on base salary and overtime pay from another table

CREATE TRIGGER trPayrollInsert
ON Payroll
INSTEAD OF INSERT
AS
BEGIN
    IF ((SELECT COUNT(*) FROM inserted) > 0)
    BEGIN
        -- Insert payroll record with calculated net pay based on base salary and overtime pay from inserted data
        INSERT INTO Payroll(payroll_id, employee_id, pay_period_start, pay_period_end, base_salary, overtime_pay, net_pay)
        SELECT 
			i.payroll_id,
            i.employee_id, 
            i.pay_period_start,
            i.pay_period_end,
            i.base_salary,  
            i.overtime_pay,
            i.base_salary + i.overtime_pay AS net_pay  -- Calculate net pay
        FROM inserted i
    END
    ELSE
    BEGIN
        PRINT 'Error occurred while inserting data into Payroll table!'
    END
END
GO



--============== INSTEAD OF TRIGGER ON VIEW ============--
-- Trigger on VW_EmployeePayrollInfo to handle insert operations, directing them to the Payroll table

CREATE TRIGGER trViewEmployeePayrollInsert
ON VW_EmployeePayrollInfo
INSTEAD OF INSERT
AS
BEGIN
    -- Declare a variable to hold the new payroll_id
    DECLARE @new_payroll_id INT;

    -- Get the maximum payroll_id from the Payroll table and increment it by 1
    SELECT @new_payroll_id = ISNULL(MAX(payroll_id), 0) + 1 FROM Payroll;

    -- Insert into Payroll table using data from the view
    INSERT INTO Payroll(payroll_id, employee_id, pay_period_start, pay_period_end, base_salary, overtime_hours, overtime_pay, bonus, deductions, net_pay)
    SELECT 
        @new_payroll_id,  
        i.employee_id, 
        i.pay_period_start, 
        i.pay_period_end, 
        i.base_salary, 
        i.overtime_hours, 
        i.overtime_pay, 
        i.bonus, 
        i.deductions, 
        i.net_pay
    FROM inserted i;
END
GO



--============== ALTER TRIGGER ============--


ALTER TRIGGER trViewEmployeePayrollInsert
ON VW_EmployeePayrollInfo
INSTEAD OF INSERT
AS
BEGIN
    -- Insert into Payroll table using data from the view, including overtime pay and calculating net pay
    INSERT INTO Payroll(employee_id, pay_period_start, pay_period_end, base_salary, overtime_hours, overtime_pay, bonus, deductions, net_pay)
    SELECT 
        i.employee_id, 
        i.pay_period_start, 
        i.pay_period_end, 
        i.base_salary, 
        i.overtime_hours, 
        i.overtime_pay, 
        i.bonus, 
        i.deductions, 
        -- Calculate net pay as base_salary + overtime_pay + bonus - deductions
        i.base_salary + i.overtime_pay + i.bonus - i.deductions AS net_pay
    FROM inserted i;
END
GO



