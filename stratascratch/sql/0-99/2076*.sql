-- Trips in Consecutive Months
-- Find the IDs of the drivers who completed at least one trip a month for at least two months in a row.

---Good Solution
SELECT distinct a.driver_id
FROM uber_trips a JOIN uber_trips b ON a.driver_id = b.driver_id AND to_char(a.trip_date + interval '1 month', 'YYYY-MM') = to_char(b.trip_date, 'YYYY-MM')
WHERE a.is_completed = True AND b.is_completed = True

-- My solution

with base as (select driver_id,
to_char(trip_date,'yyyy-mm') as trip_mon,
to_char(trip_date - interval '1 month','yyyy-mm') as trip_mon_minus_1,
count(trip_id) as total_trips
from uber_trips
where is_completed = 'TRUE'
group by 1,2,3
order by 1,2)

,base2 as (
select *,
case when lag(trip_mon,1) over (partition by driver_id order by trip_mon)  = trip_mon_minus_1 then 1 else 0 end as consective_mon
from base)

select distinct driver_id
from base2
where consective_mon=1

