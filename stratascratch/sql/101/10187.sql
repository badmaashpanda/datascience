-- Find the total number of available beds per hosts' nationality
-- Find the total number of available beds per hosts' nationality.
-- Output the nationality along with the corresponding total number of available beds.
-- Sort records by the total available beds in descending order.

select b.nationality, sum(a.n_beds)
from airbnb_apartments a 
join airbnb_hosts b on a.host_id=b.host_id
group by 1
order by 2 desc