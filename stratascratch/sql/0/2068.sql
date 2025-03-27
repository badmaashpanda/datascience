-- The sales department wants to identify lower-priced products that still sell well.


-- Find product IDs that meet both of the following criteria:


-- ⦁    The product has been sold at least twice (i.e., appeared in at least two different purchases).
-- ⦁    The average sale price (cost_in_dollars) for that product is at least $3.


-- Return a list containing product IDs along with their corresponding brand name.


with base as (select product_id, count(*) from online_orders
group by 1
having count(*) > 1 and AVG(cost_in_dollars) >= 3)

select a.product_id, b.brand_name
from base a left join online_products b on a.product_id=b.product_id