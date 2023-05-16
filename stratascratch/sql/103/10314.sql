-- Revenue Over Time
-- Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase amount, and date purchased. Do not include returns which are represented by negative purchase values. Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month.

-- A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the current month and previous two months. The first two months will not be a true 3-month rolling average since we are not given data from last year. Assume each month has at least one purchase.

-- select to_char(created_at,'YYYY-MM') as month,
-- (sum(purchase_amt) + lag(sum(purchase_amt),1) over () + lag(sum(purchase_amt),2) over ())/3 
-- from amazon_purchases
-- where purchase_amt>=0
-- group by 1
-- order by 1

-- best solution
-- select to_char(created_at,'YYYY-MM') as month,
-- avg(sum(purchase_amt)) over (order by to_char(created_at,'YYYY-MM') rows between 2 preceding and current row)
-- from amazon_purchases
-- where purchase_amt>=0
-- group by 1


with base as (
select to_char(created_at,'YYYY-MM') as month,
sum(purchase_amt) as month_revenue
from amazon_purchases
where purchase_amt>=0
group by 1
order by 1)

select month,
avg(month_revenue) over (order by month rows between 2 preceding and current row)
from base

