-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- 

with base as (
	select i.inquiry_id,
	i.charge_id,
	i.created as inquiry_created,
	max(es.created) as escalation_created,
	max(ev.created) as evidence_created,
	max(re.created) as resolution_created
	from inquiry i
	left join escalation es on i.inquiry_id = es.inquiry_id
	left join evidence ev  on i.inquiry_id = ev.inquiry_id
	left join resolution re on i.inquiry_id = re.inquiry_id
	group by 1,2,3
)

, latest as (
	select *,
	greatest(inquiry_created,
		coalesce(escalation_created,inquiry_created),
		coalesce(evidence_created,inquiry_created),
		coalesce(resolution_created,inquiry_created)
		) as latest_stage_date
	from base
)

select 
inquiry_id,
charge_id,
inquiry_created,
case 
	when resolution_created  = latest_stage_date THEN 'resolution'
	when evidence_created = latest_stage_date then 'evidence'
	when escalation_created = latest_stage_date then 'escalation'
	when inquiry_created = latest_stage_date then 'inquiry'
else 'NA' end as latest_stage,
latest_stage_date
from latest;