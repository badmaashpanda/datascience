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

-- Question 5 (final boss-ish, but fair)

-- For each month of charge creation, compute:
-- total charges
-- charges that had an inquiry
-- charges that had an inquiry and later had a resolution overturned = true
-- overturn rate among inquired charges

-- Return:
-- charge_month, total_charges, inquired_charges, overturned_inquired_charges, overturn_rate

with facts as (
    select 
    date_trunc('month', c.created) as charge_month,
    c.charge_id,
    max(case when i.inquiry_id is not null then 1 else 0 end) as has_inquiry,
    max(case when r.resolution_id is not null and overturned = true then 1 else 0 end) as has_resolution_true
    from charge c 
    left join inquiry i on c.charge_id = i.charge_id
    left join resolution r on i.inquiry_id = r.inquiry_id
    group by 1,2
)

, agg as (
    select 
    charge_month,
    count(charge_id) as total_charges,
    sum(has_inquiry) as inquired_charges,
    sum(has_resolution_true) as overturned_inquired_charges
    from facts
    group by 1
)

select charge_month,
total_charges,
inquired_charges,
overturned_inquired_charges,
overturned_inquired_charges::float / nullif(inquired_charges,0) as overturn_rate
from agg
order by 1

