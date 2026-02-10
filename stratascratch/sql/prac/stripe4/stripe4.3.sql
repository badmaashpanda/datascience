-- Charge - - -> Dispute inquiry - - -> Dispute escalation - - -> Evidence submission - - -> Resolution

-- charge                                escalation
-- +---------------+---------+           +---------------+---------+
-- | charge_id     | varchar |<--+       | escalation_id | varchar |
-- | created       | date    |   |       | created       | date    |
-- | amount        | int     |   |   +-->| inquiry_id    | varchar |
-- +---------------+---------+   |   |   +---------------+---------+
--                               |   |
-- inquiry                       |   |   evidence
-- +---------------+---------+   |   |   +---------------+---------+
-- | inquiry_id    | varchar |<--|---+   | evidence_id   | varchar |
-- | created       | date    |   |   |   | created       | date    |
-- | charge_id     | varchar |<--+   +-->| inquiry_id    | varchar |
-- +---------------+---------+       |   +---------------+---------+
--                                   |
-- resolution                        |
-- +---------------+---------+       | 
-- | resolution_id | varchar |       |
-- | created       | date    |       |
-- | inquiry_id    | varchar |<------+
-- | overturned    | bool    |
-- +---------------+---------+
-- */

-- For each charge_month (based on charge.created), compute:

-- p50_days_to_inquiry: median number of days from charge.created to the first inquiry for that charge
-- p90_days_to_inquiry: 90th percentile of the same metric

-- Rules / grading traps
-- Only include charges that have an inquiry (no null first-inquiry dates).
-- If a charge has multiple inquiries, use the earliest inquiry.created.
-- Use Postgres percentile functions: percentile_cont (Stripe-y answer).
-- “Days to inquiry” should be a numeric value (integer or decimal is fine, but be consistent).

with first_inq as (
    select 
    c.charge_id,
    min(i.created) as first_inq
    from charge c join inquiry i on c.charge_id = i.charge_id
    group by 1
)

, facts as (
    select
    date_trunc('month',c.created) as charge_month,
    date_part('day', fi.first_inq - c.created) as days_first_inq
    from charge c join first_inq fi on c.charge_id = fi.charge_id
)

select 
charge_month,
percentile_cont(0.5) within group (order by days_first_inq) as p50_days_to_inquiry,
percentile_cont(0.9) within group (order by days_first_inq) as p90_days_to_inquiry
from facts
group by 1
order by 1