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

-- For each charge_month, return the top 3 merchants by total charge amount in that month.

-- Output columns:
-- charge_month
-- merchant_id
-- total_amount
-- rank_in_month (1 = highest total)

-- Rules:
-- Use a window function for ranking (dense_rank or row_number, your call).
-- If there’s a tie at rank 3, I’m fine with either including all ties (dense_rank) or arbitrarily picking 3 (row_number), but be consistent.

with base as (
select 
date_trunc('month', created) as charge_month,
merchant_id,
sum(amount) as total_amount
from charge
group by 1,2
)

, rn as (
    select charge_month,
    merchant_id,
    total_amount,
    row_number() over (partition by charge_month order by total_amount desc) as rank_in_month 
    from base 
)

select charge_month, merchant_id, total_amount, rank_in_month
from rn where rank_in_month <=3
order by charge_month, rank_in_month;

