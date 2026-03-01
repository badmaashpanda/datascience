-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Find the top 5 charges by total evidence submissions across all their inquiries. 
-- Return charge_id and evidence_count.

with evid as (
select 
charge_id,
count(distinct e.evidence_id) as evidence_count
from inquiry i 
join evidence e on i.inquiry_id = e.inquiry_id
group by charge_id
)

select charge_id,
evidence_count
from evid
order by evidence_count desc
limit 5
