-- schema
-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Q1: For each day, return the number of charges created that day and the total charge amount for that day.

select 
created as charge_day,
count(*) as total_charges,
sum(amount) as total_amount
from charge
group by 1
order by 1

-- Q2: For each charge_id, return whether it ever reached escalation (has a row in escalation via inquiry) 
-- and whether it ever had evidence submitted (has a row in evidence via inquiry). 
-- Output: charge_id, has_escalation, has_evidence as booleans (or 0/1).

select 
c.charge_id,
max(case when es.escalation_id is not null then 1 else 0 end) as has_escalation,
max(case when ev.evidence_id is not null then 1 else 0 end) as has_evidence
from charge c 
left join inquiry i on i.charge_id = c.charge_id
left join escalation es on i.inquiry_id = es.inquiry_id
left join evidence ev on i.inquiry_id = ev.inquiry_id
group by 1


-- Q3: 
-- Compute daily funnel counts based on charge.created:
-- charges_created
-- inquiries_created (inquiries whose created is that day)
-- escalations_created
-- evidence_created
-- resolutions_created

-- Return one row per day with those five counts. Include days where some stages are zero. Sort ascending by day.

