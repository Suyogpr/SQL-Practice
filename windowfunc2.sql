-- Q1 — LAG (very common)
-- Get:customer_id
-- order_date
-- amount
-- previous order amount for each customer

SELECT 
    customer_id,
    order_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS prev_amount
FROM orders;

-- Q2 — Running Total
-- Get:customer_id
-- order_date
-- amount
-- running total of amount per customer (by date)

SELECT 
    customer_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total
FROM orders;

-- Q3 — Change Detection (INTERVIEW FAVORITE)
-- Get:customer_id
-- order_date
-- amount
-- difference between current and previous order

SELECT 
    customer_id,
    order_date,
    amount,
    LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount,
    amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff
FROM orders;

-- Q4 — Top N per group (advanced combo)
-- Get:top 2 highest orders per customer

select * from 
(
    select
    customer_id,
    order_id,
    amount,
    row_number() over(partition by customer_id order by amount desc) as rn
    from orders
)
where rn <=2

-- Q5 — Real Analyst Question (HARD)
-- Get:customers whose latest order amount is greater than their average order amount

with latest_order as (
        select 
        customer_id,order_id,amount,
        row_number() over(
        partition by customer_id order by order_date desc)as rn
        from orders
        ),
        avg_order as(
            select
            customer_id,avg(amount) as avg_amount 
            from orders
            group by customer_id
        )
        select l.customer_id
        from latest_order l
        join avg_order a
        on l.customer_id = a.customer_id
        where l.rn = 1
        and l.amount > a.avg_amount