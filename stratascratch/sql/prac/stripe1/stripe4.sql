-- uestion 4 — Intermediate+ (Deduplicate to first threshold crossing per card)
-- Prompt

-- Using the same velocity definition from Question 3 (≥ 10 captured charges within any rolling 1-hour window, considering the last 7 days), return only the first time each card crosses the threshold in that period.

-- Return exactly one row per card_id with:
-- card_id
-- first_flagged_at (earliest created_at where the rolling count is ≥ 10)
-- trigger_charge_id (the charge_id at first_flagged_at)
-- captured_count_last_hour
-- captured_amount_last_hour

-- Table
-- charges(charge_id, card_id, created_at, amount, status)

-- Requirements / evaluation points
-- Rolling window must be correct (trailing 1 hour).
-- Dedup must be correct (first crossing, not max).
-- Avoid integer division / type issues (if any).
-- Clean, explainable SQL.


with cte as (
    select 
    card_id,
    created_at,
    charge_id,
    count(*) over (partition by card_id order by created_at range between INTERVAL '1 hour' preceding and current row) as captured_count_last_hour,
    sum(amount) over (partition by card_id order by created_at range between INTERVAL '1 hour' preceding and current row) as captured_amount_last_hour
    from charges 
    where created_at >= current_timestamp - INTERVAL '7 days'
    and status = 'captured'
)

, agg as (
    select card_id,
    created_at,
    captured_count_last_hour,
    captured_amount_last_hour,
    row_number() over (partition by card_id order by created_at, charge_id ) as rn
    from cte
    where captured_count_last_hour >= 10
)

select 
card_id,
created_at,
captured_count_last_hour,
captured_amount_last_hour
from agg where rn = 1
