-- Tables

-- charges
-- charge_id (pk)
-- created_at (timestamp)
-- amount (int, cents)
-- currency (text)
-- status (text: authorized, captured, failed, refunded)
-- merchant_id (text)
-- customer_id (text)
-- card_id (text)
-- ip (inet/text)
-- device_id (text)

-- disputes
-- dispute_id (pk)
-- charge_id (fk -> charges)
-- created_at (timestamp)
-- reason (text)
-- status (text)
-- amount (int, cents)

-- Assume one dispute per charge max unless you explicitly handle otherwise.

-- Question 1 (Warm-up: join + aggregation)
-- Goal: For each merchant_id, compute dispute rate over the last 90 days:
-- captured_charges
-- disputed_captured_charges
-- dispute_rate = disputed_captured_charges / captured_charges (as decimal)

-- Rules:
-- Only include charges with status = 'captured'.
-- A charge is “disputed” if it has a matching row in disputes (any status).
-- Merchants with 0 captured charges in window should not appear (no divide-by-zero gymnastics).
-- Sort by dispute_rate desc, then captured_charges desc.


with base as (
select 
c.merchant_id,
c.charge_id,
case when dispute_id is not null then 1 else 0 end as is_disputed
from 
charges c left join disputes d on c.charge_id = d.charge_id
where c.created_at >= now() - interval '90 days'
and c.status = 'captured'
)

, agg as (
select merchant_id,
count(*) as captured_charges,
sum(is_disputed) as disputed_captured_charges
from base 
group by 1
)

select 
merchant_id,
captured_charges,
disputed_captured_charges,
disputed_captured_charges::float / nullif(captured_charges,0) as dispute_rate
from agg
order by dispute_rate, captured_charges desc

