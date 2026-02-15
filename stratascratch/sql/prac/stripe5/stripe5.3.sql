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

-- For each charge, find the first inquiry (earliest inquiry.created) if it exists, and return:

-- charge_id
-- charge_created
-- amount
-- first_inquiry_id
-- first_inquiry_created

-- Include charges with no inquiries (nulls for inquiry fields).


with first_inq as (
    select 
    i.charge_id,
    i.inquiry_id,
    i.created,
    row_number() over (partition by i.charge_id order by i.created ASC) as rn 
    from inquiry i
)

select 
c.charge_id,
c.created as charge_created,
c.amount,
f.inquiry_id as first_inquiry_id,
f.created as first_inquiry_created
from charge c 
left join first_inq f on c.charge_id = f.charge_id and f.rn = 1