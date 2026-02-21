-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Question 4 (Hard: self-join + time windows)

-- For each charge_day in the last 30 days, compute:
-- total_charges
-- charges_with_inquiry_within_24h (distinct charges whose first inquiry happened within 24 hours of charge creation
-- rate_within_24h = charges_with_inquiry_within_24h / total_charges

-- Constraints:
-- If a charge has multiple inquiries, only consider the first inquiry timestamp for that charge.
-- Use a CTE to compute the first inquiry per charge, then join back to charges.
-- Group by charge day

with first_inquiry as (
  select
  charge_id,
  created, 
  row_number() over (partition by charge_id order by created asc) as rno
  from inquiry 
)

, base as (
  select
  date_trunc('day',c.created) as charge_day,
  c.charge_id,
  case when fi.created >= c.created - interval '24 hours' then c.charge_id else null end as charge_with_inq_24h
  from charge c
  left join first_inquiry fi on c.charge_id = fi.charge_id and fi.rno=1
  where c.created >= now() - interval '30 days'
)

select 
charge_day,
count(distinct charge_id) as total_charges,
count(charge_with_inq_24h) as charges_with_inquiry_within_24h,
count(charge_with_inq_24h)::float / nullif(count(distinct charge_id),0) as rate_within_24h
from base 
group by 1 
order by 1
