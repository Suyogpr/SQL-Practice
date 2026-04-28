select p.patient_id,p.name,v.visit_id
from patients p 
left join visits v on 
p.patient_id = v.patient_id
where v.visit_id is null

select p.patient_id,p.name,sum(v.visit_id) as total_visit

select avg(sum(v.cost))

-- Get patients whose total visit cost is greater 
--than the average total cost of all patients

with cte as 
(
    select p.patient_id,p.name,sum(v.cost) as total_cost
    from patients p 
    left join visits v on p.patient_id = v.patient_id
    group by p.patient_id,p.name
)

select * from cte
where total_cost > 
(select avg(total_cost)
from cte
)

--Get patients whose latest visit cost > their average visit cost

select * from(
select 
p.patient_id,p.name,v.cost,
avg(cost) over(partition by v.patient_id) as avg_cost,
row_number() over(partition by v.patient_id order by visit_id desc) as rn
from patients p
left join visits v on p.patient_id = v.patient_id
)t
where rn = 1 and cost > avg_cost

--Find customers who have placed at least 2 orders

select c.customer_id,c.name,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
having count(o.order_id) >= 2