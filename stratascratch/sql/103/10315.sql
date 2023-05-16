-- Cities With The Most Expensive Homes
-- Write a query that identifies cities with higher than average home prices when compared to the national average. Output the city names.
select city
from zillow_transactions
group by 1
having avg(mkt_price)>= (select avg(mkt_price) from zillow_transactions)
