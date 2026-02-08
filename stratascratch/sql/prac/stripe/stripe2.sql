-- Question 2 — Slightly Harder (Time bucketing + trending)
-- Compute weekly dispute trends for the last 8 weeks, by merchant.
-- Return:
-- merchant_id
-- week (week bucket)
-- captured_charges (count of captured charges created that week)
-- disputed_charges (count of charges created that week that eventually had a dispute, regardless of when the dispute occurred)
-- dispute_rate = disputed_charges / captured_charges

-- Tables
-- charges(charge_id, merchant_id, created_at, status)
-- disputes(dispute_id, charge_id, created_at)

-- Key nuance (intentional)
-- The week is based on charge created_at, not dispute created_at. This is a common Stripe-style metric definition question.
-- Write the SQL and state any assumptions.


with cte as (
select 
a.merchant_id,
date_trunc('week',a.created_at) as created_week,
count(*) as captured_charges,
count(distinct b.charge_id) as disputed_charges
from charges a
left join disputes b on a.charge_id=b.charge_id
where a.created_at >= date_trunc('week',current_date) - interval '8 weeks'
and a.status = 'captured'
group by 1,2
)

select 
merchant_id,
created_week,
disputed_charges,
disputed_charges,
case when captured_charges = 0 then 0 else disputed_charges/captured_charges::float end as dispute_rate
from cte

