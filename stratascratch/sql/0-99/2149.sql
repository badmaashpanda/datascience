-- Following a recent advertising campaign, you have been asked to compare the sales of consumable products across all brands.


-- Do the comparison of the brands by finding the percentage of unique customers (among all customers in the dataset) who purchased consumable products of some brand and then do the calculation for each brand.


-- Your output should contain the brand_name and percentage_of_customers rounded to the nearest whole number and ordered in descending order.


with cte as (
select a.*,
b.product_id, b.brand_name, b.product_family
from online_orders a 
left join online_products b on a.product_id=b.product_id)

select brand_name, 
count(distinct customer_id) filter (where product_family = 'CONSUMABLE') as con1,
(select count(distinct customer_id) from online_orders) as tot
from cte 
group by 1