-- Most Profitable Companies
-- Find the 3 most profitable companies in the entire world.
-- Output the result along with the corresponding company name.
-- Sort the result based on profits in descending order.

-- Solution 1
-- select company, profits
-- from forbes_global_2010_2014
-- order by profits desc
-- limit 3

-- Solution 2
with base as (
select company,
profits,
rank() over (order by profits desc) as rnk,
dense_rank() over (order by profits desc) as rnk1,
row_number() over (order by profits desc) as rnk2
from forbes_global_2010_2014)

select company,profits from base where rnk<=3
