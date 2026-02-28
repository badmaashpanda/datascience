-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Return the top 5 charge_ids by total charge amount where the charge had at 
-- least one inquiry and the associated inquiry was resolved with overturned = false. 
-- Output charge_id and total_amount (sum of charge.amount).

with resolved_inq as (
    select distinct i.charge_id
    from inquiry i 
    join resolution r on i.inquiry_id = r.inquiry_id and r.overturned = false
)

select c.charge_id,
sum(amount) as total_amount
from charge c 
join resolved_inq r on c.charge_id=r.charge_id
group by 1
limit 5

