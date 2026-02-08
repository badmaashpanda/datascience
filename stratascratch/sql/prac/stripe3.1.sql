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

-- For each month of charge creation, compute:

-- total number of charges
-- number of charges that received an inquiry
-- inquiry rate = inquiries / charges
-- average charge amount for charges that received an inquiry

-- Return: charge_month, total_charges, charges_with_inquiry, inquiry_rate, avg_amount_inquired
-- Order by charge_month.

with facts as (
    select 
    date_trunc('month', c.created)::date charge_month,
    charge_id,
    amount,
    case when i.inquiry_id is not null then 1 else 0 end as has_inquiry,
    case when i.inquiry_id is not null then c.amount end as inquired_amount
    from charge c left join inquiry i on c.charge_id = i.charge_id
)

, agg as (
    select 
    charge_month,
    count(distinct charge_id) as total_charges,
    sum(has_inquiry) as charges_with_inquiry,
    avg(inquired_amount) as avg_amount_inquired
    from facts
    group by 1 
)

 select 
    charge_month,
    total_charges,
    charges_with_inquiry,
    charges_with_inquiry::float / nullif(total_charges,0) as inquiry_rate,
    avg_amount_inquired
    from agg
    order by 1


-- better solution
select 
date_trunc('month', c.created)::date charge_month,
count(distinct c.charge_id) as total_charges,
count(distinct case when i.inquiry_id is not null then c.charge_id end) as charges_with_inquiry,
avg(case when i.inquiry_id is not null then c.amount end) as avg_amount_inquired,
count(distinct case when i.inquiry_id is not null then c.charge_id end)::float / nullif(count(distinct c.charge_id),0) as inquiry_rate
from charge c left join inquiry i on c.charge_id = i.charge_id  
group by 1
order by 1
