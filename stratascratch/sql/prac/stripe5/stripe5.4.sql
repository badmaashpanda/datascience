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

-- For each charge, return:
-- charge_id
-- latest_inquiry_id (most recent inquiry.created)
-- latest_inquiry_created
-- has_escalation (boolean: true if ANY escalation exists for the charge across all inquiries)

-- Rules:
-- Include charges with no inquiries
-- If a charge has inquiries but none escalated → false
-- Avoid fan-out joins
-- One row per charge

with latest as (
    select * from (
    select 
    inquiry_id,
    created,
    charge_id,
    row_number() over (partition by charge_id order by created desc) as rn
    from from inquiry
    ) a where a.rn = 1
    
)

, agg as (
    select 
    c.charge_id, 
    l.inquiry_id as latest_inquiry_id,
    l.created as latest_inquiry_created,
    max(case when e.escalation_id is not null then 1 else 0 end) as has_escalation
    from charge c 
    left join latest l on c.charge_id = l.charge_id
    left join escalation e on l.inquiry_id = e.inquiry_id
    group by 1,2,3
)

select 
charge_id,
latest_inquiry_id,
latest_inquiry_created,
case when has_escalation = 1 then true else false end as has_escalation
from agg

