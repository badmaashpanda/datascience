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

-- For each month of inquiry creation, compute the median time to resolution (in days), separately for:

-- inquiries with evidence
-- inquiries without evidence
-- Only include inquiries that actually have a resolution.

-- Return:
-- inquiry_month, has_evidence, median_days_to_resolution

with facts as (
    select 
    date_trunc('month', i.created) as inquiry_month,
    inquiry_id,
    i.created as inquiry_created,
    r.created as resolution_created,
    max(case when e.evidence_id is not null then 1 else 0 end) as has_evidence,
    max(case when r.resolution_id is not null then 1 else 0 end) as has_resolution
    from 
    inquiry i 
    left join evidence e on i.inquiry_id = e.inquiry_id
    left join resolution r on i.inquiry_id = r.inquiry_id
    group by 1,2,3,4
)

, agg as (
    select 
    inquiry_month,
    has_evidence,
    case when has_resolution = 1 then (resolution_created - inquiry_created) else null end as inquiries_with_resolution
    from facts
)

select 
inquiry_month,
has_evidence,
percentile_cont(0.5) within group (order by inquiries_with_resolution) as median_days_to_resolution
from agg
group by 1,2
order by 1,2



