-- Q1
-- Get: employee name
-- total sales amount
-- rank of employee based on total sales (highest = rank 1)

select s.emp_id,e.name,sum(s.amount) as total_sales,
rank() over(order by sum(s.amount) desc)
from sales s join employees e on s.emp_id = e.emp_id
group by s.emp_id,e.name

-- Q2:
-- Same question—but use DENSE_RANK()

select s.emp_id,e.name,sum(s.amount) as total_sales,
dense_rank() over(order by sum(s.amount) desc)
from sales s join employees e on s.emp_id = e.emp_id
group by s.emp_id,e.name


-- rank()                          dense_rank()                row_num()
-- skips rank on ties:             no skips or gaps:           
-- 1                               1                           1
-- 2                               2                           2
-- 2                               2                           3
-- 4                               3                           4


-- | Function       | Behavior                     |
-- | -------------- | ---------------------------- |
-- | `ROW_NUMBER()` | Always unique (1,2,3,4…)     |
-- | `RANK()`       | Ties share rank, gaps appear |
-- | `DENSE_RANK()` | Ties share rank, no gaps     |



-- Q3
-- Get:employee name
-- individual sale amount
-- rank of each sale within their department (highest first)

select s.emp_id,e.name,s.amount,
rank() over(partition by e.dept order by s.amount desc)
from sales s 
join employee e 
    on s.emp_id = e.emp_id


-- Q (very common interview question)
-- Get:employee name
-- sale amount
-- latest sale per employee (based on highest sale_id)
-- 👉Return only 1 row per employee


select * from
(
    select s.emp_id,e.name,s.amount,
row_number() over(partition by s.emp_id order by s.sale_id desc) as rn
from sales s
join employees e
    on s.emp_id = e.emp_id
)
where rn = 1
