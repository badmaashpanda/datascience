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

-- Return the daily escalation rate for the last 30 days:
-- charge_created_day
-- charges_with_inquiry (count of charges created that day that have at least one inquiry)
-- charges_with_escalation (count of charges created that day that have at least one escalation across any inquiry)
-- escalation_rate = charges_with_escalation / charges_with_inquiry (as decimal, 0 if denominator is 0)

-- One row per day. No fan-out mistakes.

with base as (
    select 
    date_trunc('day',c.created) as charge_day,
    count(distinct case when i.inquiry_id is not null then c.charge_id else null end) as charges_with_inquiry,
    count(distinct case when e.escalation_id is not null then c.charge_id else null end) as charges_with_escalation
    from charge c 
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    where c.created >= now() - interval '30 days'
    group by 1
)

select charge_day,
charges_with_inquiry,
charges_with_escalation,
charges_with_escalation::float / nullif(charges_with_inquiry,0) as escalation_rate
from base
order by 1