-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Find inquiries that have more than one resolution record. 
-- Return inquiry_id and resolution_count, sorted by resolution_count desc.

with inq as (
select 
i.inquiry_id,
count(r.resolution_id) as resolution_count
from inquiry i 
join resolution r on i.inquiry_id = r.inquiry_id
group by i.inquiry_id
having count(r.resolution_id) > 1
)

select inquiry_id, resolution_count
from inq 
order by resolution_count desc


-- 
select
  inquiry_id,
  count(*) as resolution_count
from resolution
group by inquiry_id
having count(*) > 1
order by resolution_count desc;