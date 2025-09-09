--Step 1: Create Database
CREATE DATABASE employee_mgmt;

--Step 2: Use Database
USE employee_mgmt;

--Step 3: Create Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL
);


--Step 4: Create employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2),
    manager_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

--Step 5: Create leave Table
CREATE TABLE leaves (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_date DATE,
    leave_type VARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

--Step 6: Insert Into departments Table
INSERT INTO departments (dept_name) VALUES
('HR'), ('IT'), ('Finance'), ('Sales');

--Step 7: Insert Into employees Table
INSERT INTO employees (name, dept_id, salary, manager_id, hire_date) VALUES
('Aarti', 1, 50000, NULL, '2019-05-10'),
('Rahul', 1, 60000, 1, '2020-06-15'),
('Priya', 2, 70000, 1, '2021-01-20'),
('Aman', 2, 80000, 3, '2018-03-12'),
('Sneha', 3, 55000, 1, '2019-07-25'),
('Rohan', 4, 65000, 4, '2022-09-30');

--Step 8: Show all employees
SELECT * FROM employees;

--Step 9: Show employees with department name (JOIN)
SELECT e.name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

--Step 10: Find employees earning more than average salary
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--Step 11: Start Transaction
START TRANSACTION;

UPDATE employees SET salary = salary + 5000 WHERE dept_id = 2;

-- If something goes wrong
ROLLBACK;

-- If update is correct
COMMIT;

--Step 12: Create View 
CREATE VIEW high_salary_employees AS
SELECT name, salary
FROM employees
WHERE salary > 60000;

--Step 13: Create Trigger
DELIMITER //

CREATE TRIGGER check_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
   IF NEW.salary < 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Salary cannot be negative';
   END IF;
END;
//

DELIMITER ;

--Step 14: Create Procedure
DELIMITER //

CREATE PROCEDURE get_employee_details(IN empName VARCHAR(50))
BEGIN
   SELECT e.name, d.dept_name, e.salary
   FROM employees e
   JOIN departments d ON e.dept_id = d.dept_id
   WHERE e.name = empName;
END;
//

DELIMITER ;


-- Call procedure
CALL get_employee_details('Priya');

-- Ranking employees by salary
SELECT name, dept_id, salary,
       RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
FROM employees;


--Step 15: Recursive CTE (Hierarchy)

WITH RECURSIVE emp_hierarchy AS (
   SELECT emp_id, name, manager_id, 1 AS level
   FROM employees
   WHERE manager_id IS NULL
   UNION ALL
   SELECT e.emp_id, e.name, e.manager_id, eh.level + 1
   FROM employees e
   INNER JOIN emp_hierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM emp_hierarchy;

