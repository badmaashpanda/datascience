-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For each charge_id, return the number of inquiries and the date of the most recent inquiry.

select 
c.charge_id,
count(i.inquiry_id) as total_inquiries,
max(i.created) as most_recent_inquiry
from charge c 
left join inquiry i on c.charge_id = i.charge_id
group by charge_id

-- another approacj

with base as (
    select charge_id, 
    count(distinct inquiry_id) as total_inquiries, 
    max(created) as most_recent_inquiry
    from inquiry
    group by 1
)

select 
c.charge_id,
coalesce(b.total_inquiries,0) as total_inquiries,
b.most_recent_inquiry
from charge c 
left join base b on c.charge_id = b.charge_id
