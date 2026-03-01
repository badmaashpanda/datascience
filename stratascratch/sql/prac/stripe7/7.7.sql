-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Find inquiry_ids where evidence.created is earlier than the inquiry’s created date. 
-- Return inquiry_id, inquiry_created, and the earliest evidence_created.

with first_evi as (
    select inquiry_id,
    min(created) as first_evidence
    from evidence
    group by 1
)

select 
i.inquiry_id,
i.created as inquiry_created,
e.first_evidence as evidence_created
from inquiry i
left join first_evi e on i.inquiry_id = e.inquiry_id
where e.first_evidence < i.created


--

with first_evi as (
    select inquiry_id,
    min(created) as first_evidence
    from evidence
    group by 1
)

select 
i.inquiry_id,
i.created as inquiry_created,
e.first_evidence as evidence_created
from inquiry i
left join first_evi e on i.inquiry_id = e.inquiry_id
where e.first_evidence < i.created