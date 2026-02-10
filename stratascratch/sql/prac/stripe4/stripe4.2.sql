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

-- Now compute this per charge_month:
-- inquired_charges (≥ 1 inquiry)
-- escalated_inquired_charges (among inquired charges, at least one escalation)
-- escalation_rate = escalated_inquired_charges / inquired_charges

-- Schema reminders
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- charge(charge_id, created, amount)

-- Grading traps
-- Multiple escalations per inquiry and multiple inquiries per charge = double-count city unless you dedupe correctly.
-- Escalation rate denominator is inquired_charges, not total charges.
-- Use charge month from charge.created.

with facts as (
    select 
    charge_id,
    date_trunc('month',c.created) as charge_month,
    max(case when i.inquiry_id is not null then 1 else 0 end) as has_inquiry,
    max(case when e.inquiry_id is not null then 1 else 0 end) as has_escalation
    from charge c
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    group by 1,2
)

, agg as (
    select 
    charge_month,
    sum(has_inquiry) as inquired_charges,
    sum(case when has_inquiry=1 and has_escalation=1 then 1 else 0 end) as escalated_inquired_charges
    from facts
    group by 1
)

select charge_month, 
inquired_charges,
escalated_inquired_charges,
escalated_inquired_charges::float / nullif(inquired_charges,0) as escalation_rate
from agg
order by 1
