--Top Three Classes
--The marketing department wants to identify the top-performing product classes based on the number of orders placed for each class.
-- If multiple product classes have the same number of sales and qualify for the top 3, include all of them in the output.

with base as (select product_class,
rank() over (order by count(*) desc) as rnk
from online_orders a 
join online_products b on a.product_id=b.product_id
group by 1
)

select product_class from base where rnk<=3

-- Method 2: 
select product_class from (
select product_class,
count(units_sold) as total_sold,
dense_rank() over (order by count(units_sold) desc) as rnk
from online_orders a
join online_products b on a.product_id=b.product_id
group by 1
order by 2 desc) a 
where a.rnk <= 3