-- The marketing department wants to launch a new promotion for the most successful product classes.


-- If multiple product classes have the same number of sales and qualify for the top 3, include all of them in the output.

with base as (select product_class,
rank() over (order by count(*) desc) as rnk
from online_orders a 
join online_products b on a.product_id=b.product_id
group by 1
)

select product_class from base where rnk<=3