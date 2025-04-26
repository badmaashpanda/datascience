-- The sales department wants to identify lower-priced products that still sell well.


-- Find product IDs that meet both of the following criteria:


-- ⦁    The product has been sold at least twice (i.e., appeared in at least two different purchases).
-- ⦁    The average sale price (cost_in_dollars) for that product is at least $3.


-- Return a list containing product IDs along with their corresponding brand name.


with base as (
select 
product_id,
count(*) as number_purchases,
avg(cost_in_dollars) as avg_price
from online_orders
group by 1)

select a.product_id, b.brand_name
from base a
join online_products b on a.product_id=b.product_id
where a.number_purchases>=2 and avg_price>=3


-- Method 2
with select a.product_id, brand_name,
count(*) as num_purchases,
avg(cost_in_dollars) as avg_cost
from online_orders a
join online_products b on a.product_id=b.product_id
group by 1,2
having count(*)>=2 and avg(cost_in_dollars)>=3
order by 1