-- The marketing team is evaluating the performance of their previously ran promotions.


-- They are particularly interested in comparing the number of transactions on the first and last day of each promotion.


-- Segment the results by promotion and calculate the percentage of total transactions that occurred on these days.


-- Your output should include the promotion ID, the percentage of transactions on the first day, and the percentage of transactions on the last day.

with cte as (
select a.promotion_id, b.start_date, b.end_date, a.date_sold,
case when date_sold = start_date then 1 else 0 end as start_txn,
case when date_sold = end_date then 1 else 0 end as end_txn
from
online_orders a 
left join online_sales_promotions b on a.promotion_id=b.promotion_id)

select promotion_id, 
sum(start_txn), 
sum(end_txn),
count(*)
from cte
group by 1