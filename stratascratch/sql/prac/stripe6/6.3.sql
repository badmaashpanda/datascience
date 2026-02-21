-- Question 3 (Harder: window functions + rolling metrics + joins)

-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For the last 60 days (based on charge.created), produce a daily time series with:

-- charge_day
-- total_charges (distinct charges that day)
-- charges_with_inquiry (distinct charges that have an inquiry at any time)
-- inquiry_rate = charges_with_inquiry / total_charges
-- inquiry_rate_7d = 7-day rolling average of inquiry_rate (including the current day)

-- Requirements
-- Use charge.created to define the day.
-- Use LEFT JOIN so charges without inquiries are included.
-- Rolling average must be a window function over days:
-- avg(inquiry_rate) over (order by charge_day rows between 6 preceding and current row)
-- Avoid integer division (cast so you don’t get 0s).
-- Order by charge_day.

with base as (
  select 
  date_trunc('day', c.created) as charge_day,
  count(distinct c.charge_id) as total_charges,
  count(distinct case when i.inquiry_id is not null then c.charge_id else null end) as charges_with_inquiry
  from charge c
  left join inquiry i on c.charge_id = i.charge_id
  where c.created > now() - interval '60 days'
  group by 1
)

select  
charge_day,
total_charges,
charges_with_inquiry,
charges_with_inquiry::float / nullif(total_charges,0) as inquiry_rate,
avg(charges_with_inquiry::float / nullif(total_charges,0)) over (order by charge_day rows between 6 preceding and current row) as inquiry_rate_7d
from base
order by 1