-- Q1:
-- Get customer names who have placed more than 1 order.
-- Trap: Don’t accidentally count NULL or duplicate logic incorrectly.

SELECT c.customer_id,c.name,count(o.order_id) from customers
join orders o
on c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) > 1

-- Q2:
-- Get customer name and total order amount, but:
-- Ignore orders where amount is NULL
-- Only include customers whose total > 800

select c.customer_id,c.name,sum(o.amount) as total_amount
from customers c
join orders o 
on c.customer_id = o.customer_id
where o.amount is not null
group by c.customer_id,c.name
having sum(o.amount) > 800

-- Q3:
-- Get:Name of customer(s) who have the highest single order amount
-- Rules:
-- Ignore NULL amounts
-- Return ALL if tie
-- No LIMIT

select c.customer_id,c.name
from customers c 
join orders o
on c.customer_id = o.customer_id
where o.amount =
(select max(o.amount) from orders where amount is not null) 
