-- Question 1 — Foundational (Warm-up)
-- Context

-- You’re analyzing merchant-level fraud performance.

-- Prompt
-- For the last 90 days, calculate per merchant:
-- Number of captured charges
-- Number of disputed charges
-- Dispute rate

-- Requirements
-- Use captured charges as the denominator.
-- Include merchants with zero disputes.
-- Avoid double-counting charges.
-- Handle division by zero safely.

-- Tables
-- charges(charge_id, merchant_id, created_at, status)
-- disputes(dispute_id, charge_id, created_at)

with cte as (
select 
a.merchant_id,
count(a.charge_id) as total_charges,
count(b.dispute_id) as total_disputes
from charges a
left join disputes b on a.charge_id=b.charge_id
where a.created_at >= current_date - interval '90 days'
and a.status = 'captured'
group by 1 
)

select 
merchant_id,
total_charges,
total_disputes,
case when total_charges = 0 then null else total_disputes/total_charges end as dispute_rate
from cte


