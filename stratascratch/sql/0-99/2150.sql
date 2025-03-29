--Customers Who Purchased the Same Product
-- In order to improve customer segmentation efforts for users interested in purchasing furniture, you have been asked to find customers who have purchased the same items of furniture.
-- Output the product_id, brand_name, unique customer ID's who purchased that product, and the count of unique customer ID's who purchased that product. Arrange the output in descending order with the highest count at the top.


with cte as (
select a.product_id	, a.customer_id,
b.brand_name, b.product_class
from 
online_orders a 
inner join online_products b on a.product_id=b.product_id and product_class = 'FURNITURE')

select product_id,
brand_name, 
customer_id,
count(customer_id) over (partition by product_id)
from cte
group by 1,2,3
order by 4 desc