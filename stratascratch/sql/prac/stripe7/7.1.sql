-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For each charge_id, return whether it ever had an inquiry, and if so the first inquiry date.

with first_inq as (
    select charge_id,
    min(created) as first_inq
    from inquiry
    group by 1
)

select c.charge_id,
case when i.charge_id is not null then 1 else 0 end as has_inquiry,
i.first_inq_date
from charge c
left join first_inq i on c.charge_id = i.charge_id