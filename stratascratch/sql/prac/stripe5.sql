-- Question 5 — Data correctness & fraud nuance (Deduping disputes)
-- Context
-- In the production dataset, a single charge can have multiple dispute rows over time (status updates, appeals, reopens). You must avoid overcounting such charges when computing how many charges ever had a dispute.

-- Prompt
-- For the last 180 days, produce per merchant:
-- merchant_id
-- captured_charges — number of charges with status = 'captured' created in the last 180 days
-- charges_with_disputes — number of distinct charges (from those captured charges) that have ever had at least one dispute row (regardless of dispute status or dispute created_at)
-- Return every merchant who had at least one captured charge in the period.

-- Tables
-- charges(charge_id, merchant_id, created_at, status)
-- disputes(dispute_id, charge_id, created_at, status)

-- Requirements / evaluation points
-- Correctly dedupe dispute rows so a charge with multiple dispute rows counts once.
-- Ensure the dispute is linked to the charge (only count disputes for charges in the captured set).
-- Use clear, readable SQL and state any assumptions you make.
-- Prefer robust patterns (e.g., count(distinct ...) or dedupe in a subquery/CTE) and explain tradeoffs briefly.

with captured as (
  select *
  from charges
  where status = 'captured'
    and created_at >= current_timestamp - interval '180 days'
),
disputed_charges as (
  select distinct charge_id
  from disputes
)
select
  c.merchant_id,
  count(*) as captured_charges,
  count(d.charge_id) as charges_with_disputes
from captured c
left join disputed_charges d
  on d.charge_id = c.charge_id
group by c.merchant_id
order by captured_charges desc;