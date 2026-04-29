-- Q1)Find employees who are NOT assigned to any department 
-- OR belong to a department that does not exist in Departments table

select e.emp_id,e.name
from employees e 
left join departments d on
e.dept_id = d.dept_id
where e.dept_id is null or d.dept_name is null

--Q2)Find departments that have NO employees

select d.dept_id,d.dept_name
from departments d
left join employees e
on d.dept_id = e.dept_id
where e.emp_id is null

--Q)3Find employees who belong to a valid department 
--AND employees whose department is missing
--(in one query, labeled result)”

select e.emp_id,e.name,
case
    when e.dept_id is not null then 'VALID'
    else 'INVALID'
end as status
from employees e
left join departments d on e.dept_id = d.dept_id

--Q4)Find employees:whose department name starts with 'F'
--OR who have no department

select e.emp_id,e.name
from employees e
left join departments d 
on e.dept_id = d.dept_id
where d.dept_name like 'F%'
or d.dept_id is null

--Q5)Find number of employees in each department
--Include departments with 0 employees

select d.dept_name,count(e.emp_id) as employee_count
from departments d 
left join employees e 
on d.dept_id = e.dept_id
group by d.dept_name

--Q)6Find departments with more than 1 employee

select d.dept_name,count(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_name
having count(e.emp_id) > 1

--Q7)Find the employee(s) who earn the highest salary in each department

select emp_id,name,dept_id,salary
from(
    select emp_id,name,dept_id,salary,
    rank() over(partition by dept_id order by salary desc) as rnk
    from employees
)t
where rnk = 1

--Q)8Find top 2 highest paid employees in each department

select emp_id,name,dept_id,salary
from(
    select emp_id,name,dept_id,salary,
    rank() over(partition by dept_id order by salary desc) as rnk
)t
where rnk <=2

--Q9)Find departments where the average salary is higher than the overall company average salary

select dept_id,avg(salary) as avg_salary
from employees e
group by dept_id
having avg(salary) >
(
    select avg(salary)
    from employees
)

--Q10)Find departments where the total salary is greater than the average salary of the entire company

select dept_id,sum(salary)
from employees
group by dept_id
having sum(salary) >
(
    select avg(salary) from employees
)