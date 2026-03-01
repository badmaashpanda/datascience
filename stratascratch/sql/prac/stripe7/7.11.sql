-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For each inquiry, flag whether it has evidence and whether it escalated.
-- Return inquiry_id, has_evidence (0/1), has_escalation (0/1).

with evid as (
  select inquiry_id,
  min(created) as first_evid_date
  from evidence 
  group by 1
)

, esc as (
  select inquiry_id,
  min(created) as first_esc_date
  from escalation 
  group by 1
)

  select i.inquiry_id,
  case when ev.inquiry_id is not null then 1 else 0 end as has_evidence,
  case when es.inquiry_id is not null then 1 else 0 end as has_escalation
  from inquiry i 
  left join evid ev on i.inquiry_id = ev.inquiry_id
  left join esc es on i.inquiry_id = es.inquiry_id