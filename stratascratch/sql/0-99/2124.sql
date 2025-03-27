-- You have been tasked with finding the top two single-channel media types (ranked in decreasing order) that correspond to the most money the grocery chain had spent on its promotional campaigns.


-- Your output should contain the media type and the total amount spent on the advertising campaign. In the event of a tie, output all results and do not skip ranks.

with cte as (select media_type,sum(cost) as total_cost
from online_sales_promotions group by 1)

,r as (
select media_type, total_cost,
dense_rank() over (order by total_cost desc) as rnk
from cte)

select media_type,total_cost from r where rnk<=2


-- Method 2
with cte as (
select media_type,sum(cost) as total_cost,
dense_rank() over (order by sum(cost) desc) as rnk
from online_sales_promotions 
group by 1)

select media_type, total_cost from cte where rnk < 3
