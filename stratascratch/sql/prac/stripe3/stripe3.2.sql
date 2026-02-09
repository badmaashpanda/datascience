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


-- For each month of inquiry creation, calculate:
-- total number of inquiries
-- number of inquiries that escalated
-- escalation rate
-- average number of days from inquiry creation to escalation creation

-- only include inquiries that actually escalated
-- fractional days are fine

-- Return:
-- inquiry_month,
-- total_inquiries,
-- escalated_inquiries,
-- escalation_rate,
-- avg_days_to_escalation

-- Order by inquiry_month.

-- Notes (read these, they matter):
-- An inquiry can have at most one escalation
-- Some inquiries never escalate
-- Use inquiry.created as the starting point
-- Use escalation.created as the ending point

with facts as (
select 
date_trunc('month', i.created) as inquiry_month,
inquiry_id,
case when e.escalation_id is not null then 1 else 0 end as had_escalalation,
case when e.escalation_id is not null then (e.created::date - i.created::date) end as days_to_escalation
from inquiry i left join escalation e on i.inquiry_id = e.inquiry_id
)

, agg as (
    select inquiry_month,
    count(distinct inquiry_id) as total_inquiries,
    sum(had_escalalation) as escalated_inquiries,
    avg(days_to_escalation) as avg_days_to_escalation
    from facts 
    group by 1
)

select inquiry_month,
total_inquiries,
escalated_inquiries,
escalated_inquiries::float / nullif(total_inquiries,0) as escalation_rate,
avg_days_to_escalation
from agg
order by 1




