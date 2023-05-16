-- Median Price Of Wines

-- Find the median price for each wine variety across both datasets. Output distinct varieties along with the corresponding median price.

with base as (select variety, price from winemag_p1 union all select variety, price from winemag_p2)

select variety, 
percentile_cont(0.5) within group (order by price)
from base
group by 1