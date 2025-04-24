
-- The marketing department is assessing the success of their promotional campaigns.


-- You have been asked to find which products sold the most units for each promotion.


-- Your output should contain the promotion ID, product ID, and corresponding total sales for the most successful product ID. In the case of a tie, output all results.

with base as (select promotion_id,product_id,
sum(units_sold) as  total_sold,
rank() over (partition by promotion_id order by sum(units_sold) desc) as rnk
from 
online_orders
group by 1,2
order by 1,2)

select promotion_id,product_id, total_sold 
from base 
where rnk=1
