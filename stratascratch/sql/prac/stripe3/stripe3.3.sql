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

-- total inquiries
-- inquiries that submitted evidence
-- inquiries that received a resolution
-- % resolved among inquiries with evidence
-- % overturned among resolved inquiries (resolution.overturned = true)

-- Return exactly:
-- inquiry_month,
-- total_inquiries,
-- inquiries_with_evidence,
-- resolved_inquiries,
-- pct_resolved_with_evidence,
-- pct_overturned

-- Rules (do not ignore these)
-- An inquiry can have multiple evidence records
-- An inquiry can have at most one resolution
-- Evidence and resolution can happen after the inquiry month
-- Percentages should be NULL when the denominator is zero

with facts as (
    select 
    date_trunc('month', i.created) as inquiry_month,
    inquiry_id,
    max(case when e.evidence_id is not null then 1 else 0 end) as has_evidence,
    max(case when r.resolution_id is not null then 1 else 0 end) as has_resolution,
    max(case when r.resolution_id is not null and r.overturned = true then 1 else 0 end) as has_resolution_overturned
    from inquiry i 
    left join evidence e on i.inquiry_id = e.inquiry_id
    left join resolution r on i.inquiry_id = r.inquiry_id
    group by 1,2
)

, agg as 
(
    select 
    inquiry_month,
    count(*) as total_inquiries,
    sum(has_evidence) as inquiries_with_evidence,
    sum(has_resolution) as resolved_inquiries,
    sum(has_resolution_overturned) as overturned_inquiries,
    sum(case when has_evidence = 1 and has_resolution = 1 then 1 else 0 end) as resolved_with_evidence
    from facts
    group by 1
)

select 
inquiry_month,
total_inquiries,
inquiries_with_evidence,
resolved_inquiries,
resolved_with_evidence::float / nullif(inquiries_with_evidence,0) as pct_resolved_with_evidence,
overturned_inquiries::float / nullif(resolved_inquiries,0) as pct_overturned
from agg
order by 1
