-- Question 3 — Intermediate (Rolling-window velocity)
-- Prompt

-- Identify cards with 10 or more captured charges within any rolling 1-hour window in the last 7 days.

-- Return (one row per card per “flag event” is fine):
-- card_id
-- charge_id (the charge that triggered the threshold)
-- created_at
-- captured_count_last_hour
-- captured_amount_last_hour

-- Tables
-- charges(charge_id, card_id, created_at, amount, status)

-- Notes
-- This is a classic fraud signal (“burst velocity”).
-- A fixed date_trunc('hour') bucket is not sufficient; we want a rolling window.
-- Write the SQL and briefly explain your approach.

with cte as (
select 
card_id,
charge_id,
created_at,
count(charge_id) over (partition by card_id order by created_at range between INTERVAL '1 hour' preceding and current row) as captured_count_last_hour,
sum(amount) over (partition by card_id order by created_at range between INTERVAL '1 hour' preceding and current row) as captured_amount_last_hour
from charges
where created_at >= now() - INTERVAL '7 days' 
and status = 'captured'
)

, agg as (
select 
*,
case when captured_count_last_hour >= 10 then 1 else 0 end as flag
from cte)

select 
card_id,
charge_id,
created_at,
captured_count_last_hour,
captured_amount_last_hour
from agg where flag = 1


--- Using corelated sub query
select 
a.card_id,
a.charge_id,
a.created_at,
(select count(*) from charges b on a.card_id=b.a.card_id and b.status = 'captured' and b.created_at between a.created_at - interval '1 hour' and a.created_at) as captured_count_last_hour,
(select sum(amount) from charges b on a.card_id=b.a.card_id and b.status = 'captured' and b.created_at between a.created_at - interval '1 hour' and a.created_at) as captured_count_last_hour
from 
charges a
