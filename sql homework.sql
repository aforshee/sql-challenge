--create tables

Create table employees (
	emp_no int primary key,
	birth_date date,
	first_name varchar,
	last_name varchar,
	gender varchar,
	hire_date date
);
Select * from employees;

Create table departments (
	dept_no varchar primary key,
	dept_name varchar
);
Select * from departments

Create table dept_employees (
	emp_no int,
	dept_no varchar,
	from_date date,
	to_date date,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
Select * from dept_employees

Create table dept_manager (
	dept_no varchar,
	emp_no int,
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
Select * from dept_manager

Create table salaries (
	emp_no int,
	salary int,
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
Select * from salaries

Create table titles (
	emp_no int,
	title varchar,
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
)
Select * from titles

--load data from csv
Copy employees From 'C:\temp-data\09-SQL_homework_assignment_data_employees.csv' DELIMITER ',' CSV HEADER;
Copy departments From 'C:\temp-data\09-SQL_homework_assignment_data_departments.csv' DELIMITER ',' CSV HEADER;
Copy dept_employees From 'C:\temp-data\09-SQL_homework_assignment_data_dept_emp.csv' DELIMITER ',' CSV HEADER;
Copy dept_manager From 'C:\temp-data\09-SQL_homework_assignment_data_dept_manager.csv' DELIMITER ',' CSV HEADER;
Copy salaries From 'C:\temp-data\09-SQL_homework_assignment_data_salaries.csv' DELIMITER ',' CSV HEADER;
Copy titles From 'C:\temp-data\09-SQL_homework_assignment_data_titles.csv' DELIMITER ',' CSV HEADER;

Select * from employees
Select * from departments
Select * from dept_employees
Select * from dept_manager
Select * from salaries
Select * from titles


--1. List the following details of each employee: employee number, last name, first name, gender, and salary.
Select e.emp_no,
		e.last_name,
		e.first_name,
		e.gender,
		s.salary
from employees as e
join salaries as s
on e.emp_no = s.emp_no

--2. List employees who were hired in 1986.
Select *
from employees
where hire_date > '1985-12-31' and hire_date < '1987-01-01';

--3. List the manager of each department with the following information: 
--       department number, department name, the manager's employee number, last name, first name, 
--       and start and end employment dates.
Select dm.dept_no,
		d.dept_name,
		dm.emp_no,
		e.last_name,
		e.first_name,
		e.hire_date as emp_start_date,
		end_date_table.end_date as emp_end_date,
		dm.from_date as manager_start_date,
		dm.to_date as manager_end_date
from dept_manager as dm
join departments as d
on dm.dept_no = d.dept_no
join employees as e
on dm.emp_no = e.emp_no
join 
	(Select emp_no,
		max(to_date) as end_date
	from titles
	group by emp_no) as end_date_table
on dm.emp_no = end_date_table.emp_no

--4. List the department of each employee with the following information:
--       employee number, last name, first name, and department name.


--5. List all employees whose first name is "Hercules" and last names begin with "B."
Select *
from employees
Where first_name = 'Hercules' and last_name like 'B%'

--6. List all employees in the Sales department, including their employee number, 
--       last name, first name, and department name.
Select de.emp_no,
		last_name,
		first_name,
		dept_name		
from dept_employees as de
join departments as d
on de.dept_no = d.dept_no
left join employees as e
on e.emp_no = de.emp_no
Where d.dept_name = 'Sales' and de.to_date = '9999-01-01'

--7. List all employees in the Sales and Development departments, 
--        including their employee number, last name, first name, and department name.
Select de.emp_no,
		last_name,
		first_name,
		dept_name		
from dept_employees as de
join departments as d
on de.dept_no = d.dept_no
left join employees as e
on e.emp_no = de.emp_no
Where d.dept_name IN ('Sales', 'Development') and de.to_date = '9999-01-01'

--8.  In descending order, list the frequency count of employee last names, 
--        i.e., how many employees share each last name.

Select last_name,
		count(last_name) as Count_of_Name
from employees
group by last_name
order by Count_of_Name desc
