-- Sales Percentage Week's Beginning and End
-- The sales department has given you the sales figures for the first two months of 2023.


-- You've been tasked with determining the percentage of weekly sales on the first and last day of every week. Consider Sunday as last day of week and Monday as first day of week.


-- In your output, include the week number, percentage sales for the first day of the week, and percentage sales for the last day of the week. Both proportions should be rounded to the nearest whole number.

with cte as (select invoicedate,
quantity,
unitprice,
extract(week from invoicedate) as week_,
date_part('dow', invoicedate) as day_
from early_sales)

select 
week_,
ROUND(sum(100*case when day_ = 1 then quantity*unitprice else 0 end) / sum(quantity*unitprice)) as day1_pc,
ROUND(sum(100*case when day_ = 0 then quantity*unitprice else 0 end) / sum(quantity*unitprice)) as day0_pc
from cte
group by 1
order by 1

