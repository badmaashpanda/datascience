-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Identify charges where the inquiry was opened more than 30 days after the charge was created. 
-- Return charge_id, charge_created, and the earliest inquiry_created for that charge.

with first_inq as (
  select charge_id,
  min(created) as first_inq_date
  from inquiry 
  group by 1
 )

 select 
 c.charge_id,
 c.created as charge_created,
fi.first_inq_date as earliest_inquiry_created 
 from charge c 
 join first_inq fi on c.charge_id = fi.charge_id
 where fi.first_inq_date > c.created + interval '30 day'