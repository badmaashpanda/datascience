-- Sales Evaluation on Media Formats

-- The marketing department is evaluating the most effective promotional strategies for each product family.


-- You have been asked to find the total sales by media type for each category as a percentage of the overall sales for that family. For example the product family ELECTRONICS could be sold 57% through INTERNET and 43% through BROADCAST.


-- Your output should include the product family listed alphabetically, the media type, and the calculated percentage of sales rounded to the nearest whole number ordered from highest to lowest.

with cte as (select a.*,
b.media_type,
c.product_family
from online_orders a
join online_sales_promotions b on a.promotion_id=b.promotion_id
join online_products c on a.product_id=c.product_id)
, cte1 as (
select product_family,
media_type, 
sum(cost_in_dollars * units_sold) as total_sales
from cte
group by 1,2
order by 1,2
)

select product_family,media_type,
round(100*total_sales/sum(total_sales) over (partition by product_family)) as pc_sales
from cte1
order by 1,3 desc