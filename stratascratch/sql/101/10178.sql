-- Businesses Open On Sunday
-- Find the number of businesses that are open on Sundays. Output the slot of operating hours along with the corresponding number of businesses open during those time slots. Order records by total number of businesses opened during those hours in descending order.

select a.sunday,
count(distinct b.name) 
from yelp_business_hours a
inner join yelp_business b on a.business_id=b.business_id
where a.sunday is not null
and is_open=1
group by 1
order by 2 desc