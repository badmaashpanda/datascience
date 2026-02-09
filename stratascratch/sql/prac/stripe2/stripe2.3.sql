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

-- For each charge_month (based on charge.created), compute:
-- inquiry_30d_rate: % of charges with an inquiry created within 30 days of the charge
-- escalation_30d_rate: % of charges with an escalation created within 30 days of the charge
-- loss_60d_rate: % of charges with a loss resolution (overturned=false) created within 60 days of the charge

-- Rules
-- Use event timestamps: inquiry.created, escalation.created, resolution.created
-- The window is relative to the individual charge’s created
-- Count each charge once per metric (even if multiple events qualify)

-- Output:
-- charge_month
-- total_charges 
-- inquiry_30d_charges 
-- escalation_30d_charges 
-- loss_60d_charges 
-- the three rates

with agg as (
    select 
    date_trunc('month', c.created)::date as charge_month,
    count( distinct c.charge_id) as total_charges,
    count(distinct case when i.created > c.created and i.created < c.created + interval '30 days' and i.inquiry_id is not null then c.charge_id end) as inquiry_30d_charges,
    count(distinct case when e.created > c.created and e.created < c.created + interval '30 days' and e.escalation_id is not null then c.charge_id end) as escalation_30d_charges
    from charge c 
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    group by 1
)

select charge_month,total_charges,inquiry_30d_charges, escalation_30d_charges,
inquiry_30d_charges::float /nullif(total_charges,0) as inquiry_30d_rate,
escalation_30d_charges::float /nullif(total_charges,0) as escalation_30d_rate
from agg






