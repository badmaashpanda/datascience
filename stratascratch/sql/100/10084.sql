-- Cum Sum Energy Consumption

-- Calculate the running total (i.e., cumulative sum) energy consumption of the Meta/Facebook data centers in all 3 continents by the date. Output the date, running total energy consumption, and running total percentage rounded to the nearest whole number.

with base as (select * from fb_eu_energy 
union all
select * from fb_na_energy
union all
select * from fb_asia_energy)

,total as (
select date,
sum(consumption) as consumption 
from base
group by 1 order by 1)

select date,
sum(consumption) over (order by date) as cum_consumption,
round(100*(sum(consumption) over (order by date)) / (select sum(consumption) from total)::float) as perc
from total


-- The main difference between UNION and UNION ALL is that: UNION: only keeps unique records. UNION ALL: keeps all records, including duplicates.
-- Cum Sum