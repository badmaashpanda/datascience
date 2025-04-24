-- The VP of Sales feels that some product categories don't sell and can be completely removed from the inventory.


-- As a first pass analysis, they want you to find what percentage of product categories have never been sold.

with allc as (
select distinct category_id from online_product_categories) ,

sold as (
select distinct product_category from online_orders a join online_products b on a.product_id=b.product_id
)

select 
100*((select count(*) from allc) - (select count(*) from sold))  / (select count(*) from allc) 


--also

with base as (select 
c.category_id,
coalesce(sum(a.units_sold),0) as total_sales
from online_orders a
join online_products b on a.product_id=b.product_id
right join online_product_categories c on b.product_category=c.category_id
group by 1)

select 
100*count(*) filter (where total_sales=0)/count(*)::float as percentage_of_unsold_categories
from 
base
