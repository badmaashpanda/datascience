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

-- For charges created in the last 30 days, compute by charge_created_day:
-- charge_day
-- escalated_charges (number of charges that have at least one escalation)
-- p50_days_to_escalation (median days from charge.created to the first escalation for that charge)
-- p90_days_to_escalation (90th percentile of the same)

-- Definitions:
-- For a given charge, first escalation = the earliest escalation.created across all inquiries for that charge.
-- days_to_escalation = first_escalation_created - charge.created in days.
-- Exclude non-escalated charges from percentile calculations (but still report escalated_charges).

with first_escalation as (
    select 
    escalation_id,
    inquiry_id,
    min(created) as first_escalation_date
    from escalation
    group by 1,2
)

, facts as (
    select 
    date_trunc('day',c.created) as charge_day,
    c.created as charge_created,
    i.inquiry_id,
    count(distinct case when e.escalation_id is not null then c.charge_id end) as escalated_charges
    from charge c
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    where c.created >= now() - interval '30 days'
    group by 1,2,3,4
)

select charge_day,
escalated_charges,
percentile_cont(0.5) within group (order by (e.first_escalation_date - f.charge_created)) as p50_days_to_escalation,
percentile_cont(0.9) within group (order by (e.first_escalation_date - f.charge_created)) as p90_days_to_escalation
from facts f left join first_escalation e on f.inquiry_id=e.inquiry_id
order by 1