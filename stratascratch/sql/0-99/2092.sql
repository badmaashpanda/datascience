-- Daily Top Merchants
-- You have been asked to find the top 3 merchants for each day with the highest number of orders on that day.


-- In the event of a tie, multiple merchants may share the same spot, but each day at least one merchant must be in first, second, and third place.


-- Your output should include the date in the format YYYY-MM-DD, the name of the merchant, and their place in the daily ranking.



with base as (select
order_timestamp::date as order_date,
merchant_id,
count(n_items) as total_orders,
dense_rank() over (partition by order_timestamp::date order by count(n_items) desc) as enjk
from order_details
group by 1,2
order by 1)

select order_date, name,enjk
from base a
join merchant_details b on a.merchant_id=b.id
where enjk<=3
order by order_date, enjk