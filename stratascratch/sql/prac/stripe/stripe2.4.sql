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

-- For each charge_month, compute:
-- median_days_to_first_inquiry (days from charge.created to the first inquiry.created for that charge, only for charges that have an inquiry)
-- p90_days_to_first_inquiry

-- Postgres functions allowed (percentile_cont), count each charge once.

with first_inq as (
    select charge_id,
    min(created) as first_inq
    from
    inquiry
    group by 1
)

, base as (
select 
date_trunc('month', c.created)::date as charge_month,
(i.first_inq::date - c.created::date) AS days_to_inquiry
from charge c join first_inq i on c.charge_id=i.charge_id
)

select 
charge_month,
percentile_cont(0.5) within group (order by days_to_inquiry) as median_days_to_first_inquiry,
percentile_cont(0.9) within group (order by days_to_inquiry) as p90_days_to_first_inquiry
from base
group by 1
order by 1

