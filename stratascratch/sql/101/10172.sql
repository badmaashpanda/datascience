-- Best Selling Item
-- Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid. The best selling item is calculated using the formula (unitprice * quantity). Output the description of the item along with the amount paid.

with base as (select date_part('month',invoicedate) as month,
description, 
sum(quantity*unitprice) as total_sales
from online_retail
group by 1,2)

select month, description, total_sales from  (
select month,
description,
total_sales,
rank() over (partition by month order by total_sales desc) as rnk
from base) a
where rnk=1
