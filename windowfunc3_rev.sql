--JOINS

select c.customer_id,c.name,o.order_id,o.amount,o.order_date
from customers c 
left join orders o on 
c.customer_id = o.customer_id

select c.customer_id,c.name,o.order_id,o.amount,o.order_date
from customers c 
left join orders o on 
c.customer_id = o.customer_id
where o.order_id is null

select c.customer_id,c.name,COALESCE(sum(o.amount),0) as total_amount
from customers c left join order o on c.customer_id = o.customer_id
group by c.customer_id,c.name

--agg and filter

select c.customer_id,c.name,sum(o.amount) as total_amount from
customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
having sum(o.amount) > 800

select c.customer_id,c.name,count(o.order_id) as total_orders
from customers c left join orders o on 
c.customer_id = o.customer_id
group by c.customer_id,c.name
having count(o.order_id) >= 2

--subquery

--Get customers whose total order amount > average total order amount of all customers
--select customer where total_amount > avg_amount

select customer_id from
(select customer_id,sum(amount) as total_amount
from orders
group by customer_id
)t
where total_amount > 
(select avg(total_amount)
from(select customer_id,sum(amount) as total_amount
from orders
group by customer_id
)a
)

select customer_id, amount from
orders where amount =
(select max(amount) from orders)

--cte

with customer_total as(
    select customer_id,sum(amount) as total_amount
    from orders
    group by customer_id
)
select customer_id from customer_total 
where total_amount > 800

-- windowfuncs

with cte as(
    select customer_id,sum(amount) as total_spent
    from orders
    group by customer_id
)
select customer_id,total_spent,
rank() over(order by total_spent desc) as rnk
from cte


with cte as(
    select c.customer_id,c.name,c.city,sum(o.amount) as total_spent
    from customers c 
    left join orders o on c.customer_id = o.customer_id
    group by c.customer_id,c.name,c.city
)
select * from
(
    select *,
    row_number over (partition by city order by total_spent desc) as rn
    from cte
)t
where rn = 1

select * from 
(select c.customer_id,c.name,c.city,sum(o.amount) as total_spent,
row_number() over (partition by c.city order by sum(o.amount) desc) as rn
from customers c 
left join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name,c.city
)t
where rn =1