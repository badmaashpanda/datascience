-- The marketing department is aiming its next promotion at customers who have purchased products from two particular brands: Fort West and Golden.


-- You have been asked to prepare a list of customers who purchased products from both brands.

with base as (select a.customer_id,
b.brand_name
from online_orders a
join online_products b on a.product_id=b.product_id)

select distinct a.customer_id
from base a 
join base b on a.customer_id=b.customer_id and a.brand_name='Fort West'
and b.brand_name = 'Golden'