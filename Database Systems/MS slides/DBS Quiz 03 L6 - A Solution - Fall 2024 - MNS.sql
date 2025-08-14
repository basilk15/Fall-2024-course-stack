-- Q1) Write a single SQL query to add a new table to the given schema called ‘Dependents’ with the 
--	   following attributes:
--		•	DependentID of type varchar containing up to 20 characters
--		•	WorkerID of type integer
--		•	DependentName of the same type as that of FIRST_NAME of the Worker table given in the script file 
--				– this field can never be empty
--		•	DOB of type Date – this field can never be empty
-- The other relevant information to create the ‘Family’ table is as follows:
--		•	DependentID and WorkerID form a composite primary key
--		•	WorkerID is a foreign key linked to the Worker table with an alias fk_dependent_worker

create table Dependents (
	DependentID varchar(20),
	WorkerID int,
	DependentName varchar(50) NOT NULL, 
	DOB DATE NOT NULL,
	PRIMARY KEY(DependentID, WorkerID),
	CONSTRAINT fk_dependent_worker
	FOREIGN KEY(WorkerID) REFERENCES Worker(Worker_ID)
);

select * from Dependents;

-- Q2) Write a single SQL query to find all records of designations whose titles 
--	   have at least 6 characters and end with letter ‘r’

select * from Designation where title like '______%r';

-- Q3) Write a single SQL query to get unique worker IDs of workers who have either been 
--	   assigned a designation or have received a bonus, or both. 
--		DO NOT USE JOINs AND/OR CARTESIAN PRODUCTS FOR THIS QUERY.

select WORKER_REF_ID As 'Worker ID' from Title 
UNION 
select WORKER_REF_ID As 'Worker ID' from Bonus;

-- Q4) Write a single SQL query to find complete names of workers who do not have a last name 
--	   in the records and have not been assigned any departments either.

select concat(FIRST_NAME, ' ', LAST_NAME) as CompleteName from Worker 
where last_name is null and DEPT_ID is null;

-- Q5) Write a single SQL query to calculate the average salary of workers in each department, 
--	   for all the average salaries greater than 150,000

select dept_id as 'Department ID', avg(salary) as 'Average Salary' 
from worker 
where dept_id is not null 
group by dept_id 
having avg(salary) > 150000;


-- Q6) Write a single SQL query that retrieves worker’s full name, their department name, 
--	  salary package and promotion status, in the decreasing order of their joining date.
--	  For salary package, the following conditions apply:
--		•	If salary is in the range of 0 to 10000 (both inclusive), 
--			then the salary package will be ‘Low Package’
--		•	If salary is above 10000 up to 60000, then the salary package will be ‘Regular Package’
--		•	If salary is above 60000 up to 125000, then the salary status will be ‘High Package'
--		•	Salaries above 125000 are considered as ‘Executive Package’
--
--	  For promotion status, read the following conditions apply:
--		•	If it’s been more than 5 years, then the promotion status would be: ‘Eligible for Promotion’
--		•	Otherwise, they will be considered as ‘Recently Promoted’

select concat(first_name, ' ', last_name) as 'Full Name', 
dept_name as 'Department', 
case 
	when salary between 0 and 10000 then 'Low Package'
	when salary > 10000 and salary <= 60000 then 'Regular Package'
	when salary > 60000 and salary <= 125000 then 'High Package'
	else 'Executive Package'
end as 'Salary Package',
case
	when datediff(year, convert(date, affected_from), getdate()) > 5 then 'Eligible for Promotion'
	else 'Recently Promoted'
end as 'Promotion Status'
from Department join Worker on Department.ID =  Worker.DEPT_ID
join Title on worker.WORKER_ID = Title.WORKER_REF_ID
order by JOINING_DATE asc;

