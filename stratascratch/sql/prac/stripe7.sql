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


-- Now calculate three rates by charge created month:

-- inquiry_rate = charges with ≥1 inquiry / total charges
-- escalation_rate = charges with ≥1 escalation / total charges
-- loss_rate = charges that are resolved NOT overturned / total charges

-- Rules/definitions:
-- Escalation is tied to inquiry_id via escalation.inquiry_id.
-- Resolution is tied to inquiry_id via resolution.inquiry_id.
-- A charge can have multiple inquiries; inquiries can have escalation/resolution. Count each charge once per metric.
-- For loss_rate: a charge is a “loss” if it has at least one resolution row where overturned = false.

-- Output columns:

-- charge_month
-- total_charges
-- inquiry_charges
-- escalation_charges
-- loss_charges
-- inquiry_rate
-- escalation_rate
-- loss_rate


with base as (
select 
date_trunc('month', created) as charge_month,
exists (select 1 from inquiry i where i.charge_id = c.charge_id) as has_inquiry,
exists (select 1 from inquiry i join escalation e on i.inquiry_id = e.inquiry_id where i.charge_id = c.charge_id) as has_escalation,
exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where i.charge_id = c.charge_id AND r.overturned = false) as has_loss
from charge c
)

, agg as (
    select 
    charge_month,
    count(*) as total_charges,
    sum(has_inquiry) as inquiry_charges,
    sum(has_escalation) as escalation_charges,
    sum(has_loss) as loss_charges
    from base 
    group by 1
)

select 
charge_month,
total_charges,
inquiry_charges,
escalation_charges,
loss_charges,
inquiry_charges::float / nullif(total_charges,0) as inquiry_rate,
escalation_charges::float / nullif(total_charges,0) as escalation_rate,
loss_charges::float / nullif(total_charges,0) as loss_rate
from agg
order by 1


-- another method


with charges as (
select 
date_trunc('month',created) as charge_month,
count(*) as total_charges
from charge c
group by 1
)

, inq as (
    select charge_id,
    count(inquiry_id) as num_inquires
    from inquiry
    group by 1
)

, esc as (
    select c.charge_id, 
           count(e.escalation_id) as num_escalations
    from charge c left join inquiry i on c.charge_id=i.charge_id
    join escalation e on i.inquiry_id = e.inquiry_id
    group by 1
)

, res as (
    select c.charge_id, 
           count(r.resolution_id) as loss_charges
    from charge c left join inquiry i on c.charge_id=i.charge_id
    join resolution r on i.inquiry_id = r.inquiry_id and overturned = false
    group by 1
)

, base as (
    select 
    c.charge_month,
    c.total_charges,
    i.num_inquires,
    e.num_escalations,
    r.loss_charges
    from 
    charges c
    left join inq i on c.charge_id = i.charge_id
    left join esc e on c.charge_id = e.charge_id
    left join res r on c.charge_id = r.charge_id
)
